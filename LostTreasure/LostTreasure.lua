local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager

local utilities = internal.utilities
local savedVars = internal.savedVars
local itemCache = internal.itemCache
local pins = internal.pins
local notifications = internal.notifications
local mining = internal.mining
local markOnUsing = internal.markOnUsing
local data = internal.data
local debug = internal.debug
local settings = internal.settings


local HIDE_MINI_MAP = true

function LostTreasure:Initialize(control)
	self.control = control
	self.mapControl = control:GetNamedChild("Map")

	self.lastOpenedTreasureMap = LOST_TREASURE_MAP_NOT_OPENED
	self.lastOpenedBookId = LOST_TREASURE_BOOK_NOT_OPENED
	self:SetLastOpenedItemId(0)

	local function OnAddOnLoaded(_, addOnName)
		if addOnName == self.addOnName then
			self.control:UnregisterForEvent(EVENT_ADD_ON_LOADED)

			savedVars:Initialize()
			itemCache:Initialize()
			notifications:Initialize()
			mining:Initialize()
			pins:Initialize()
			debug:Initialize()
			settings:Initialize()

			self:RegisterEvents()

			self:SetMiniMapAnchor()
			self:UpdateVisibility(HIDE_MINI_MAP)
		end
	end

	LOST_TREASURE_FRAGMENT = ZO_HUDFadeSceneFragment:New(control)
	HUD_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	HUD_UI_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	TREASURE_MAP_INVENTORY_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	GAMEPAD_TREASURE_MAP_INVENTORY_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	WORLD_MAP_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	GAMEPAD_WORLD_MAP_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)

	self.control:RegisterForEvent(EVENT_ADD_ON_LOADED, OnAddOnLoaded)
end

function LostTreasure:RegisterEvents()
	self.control:RegisterForEvent(EVENT_SHOW_TREASURE_MAP, function(_, ...) self:OnEventShowTreasureMap(...) end)
	self.control:RegisterForEvent(EVENT_SHOW_BOOK, function(_, ...) self:OnEventShowBook(...) end)

	-- We have to refresh the compass pins, otherwise they are not always visible from the beginning
	self.control:RegisterForEvent(EVENT_PLAYER_ACTIVATED , function()
		self:OnPlayerActivated()
	end)
end


function LostTreasure:OnEventShowTreasureMap(treasureMapIndex)
	local name, texturePath = GetTreasureMapInfo(treasureMapIndex)
	local mapTextureName = utilities:GetTreasureMapTexturePathName(texturePath)
	self.lastOpenedTreasureMap = mapTextureName

	logger:Info("Treasure map opened. name: %s, texturePath: %s, mapTextureName: %s, treasureMapIndex: %d", name, texturePath, mapTextureName, treasureMapIndex)

	self.mapControl:SetTexture(texturePath)

	local isMinimapEnabled = savedVars.db.miniMap.enabled
	self:UpdateVisibility(not isMinimapEnabled)

	local pin = LibTreasure_GetTextureData(mapTextureName)
	logger:Debug("GetTextureData itemId: %d", pin and pin.itemId or "no - pin has not been found")
	if pin then
		self:SetLastOpenedItemId(pin.itemId)
		local pinType = utilities:GetPinTypeFromString(name)
		if pinType ~= LOST_TREASURE_NO_PIN_TYPE then
			local markOption = settings:GetSettingsFromPinType(pinType, "markOption")
			if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
				self:AddMarkOnUsingPin(pinType, pin.itemId)
			end
		end
	end
end

function LostTreasure:OnEventShowBook(title, body, medium, showTitle, bookId)
	self.lastOpenedBookId = bookId

	local itemId = LibTreasure_GetBookIdItemId(bookId)
	if itemId then
		local pinType = utilities:GetPinTypeFromString(title)
		if pinType ~= LOST_TREASURE_NO_PIN_TYPE then
			local markOption = settings:GetSettingsFromPinType(pinType, "markOption")
			if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
				self:AddMarkOnUsingPin(pinType, itemId)
			end
		end
	end
	logger:Info("Book opened. bookId: %s, title: %s, isCollected: %s", bookId, title, tostring(itemId ~= nil))
end

function LostTreasure:OnPlayerActivated()
	local db = savedVars:GetSavedVars()
	for pinType, _ in pairs(db.pinTypes) do
		pins:RefreshCompassPinsFromPinType(pinType)
	end
end

function LostTreasure:UpdateVisibility(hidden, fadeTime)
	local isHidden = tostring(LOST_TREASURE_FRAGMENT:IsHidden())
	logger:Debug("set hidden: %s, isHidden: %s, fadeTime: %s", tostring(hidden), isHidden, fadeTime or "nil")
	LOST_TREASURE_FRAGMENT:SetHiddenForReason("hasMapOpened", hidden, fadeTime, fadeTime)
end

function LostTreasure:AddMarkOnUsingPin(pinType, itemId)
	if not markOnUsing:DoesExist(pinType, itemId) then
		markOnUsing:Add(pinType, itemId)
		self:RefreshPinTypePins(pinType)
	end
end

function LostTreasure:RefreshPinTypePins(pinType)
	pins:RefreshAllPinsFromPinType(pinType)
end

do
	local function IsValidInteractionType(pinType, interactionType, sceneName)
		if sceneName == "hud" then
			local pinTypeInteractionType = LOST_TREASURE_PIN_TYPE_DATA[pinType].interactionType
			if pinTypeInteractionType == interactionType then
				return true
			end
		end
		return false
	end

	--[[

	This has to pass without action:
	/script LOST_TREASURE:RequestReport("treasure", INTERACTION_NONE, 57764, "itemName", "itemLink", "hud", true)
	
	This has to pop a request:
	/script LOST_TREASURE:RequestReport("treasure", INTERACTION_NONE, 99999, "itemName", "itemLink", "hud", true)

	]]
	function LostTreasure:RequestReport(pinType, interactionType, itemId, itemName, itemLink, sceneName, overwriteMiningState)
		if IsValidInteractionType(pinType, interactionType, sceneName) then
			-- Check for exisiting items in LostTreasure_Data.
			if LibTreasure_GetItemIdData(itemId) then
				logger:Info("Item %d has been found in database.", itemId)
				return -- item has been found, no need to continue
			end

			-- If no item has been found, we have to send a notification.
			utilities:RequestRefreshMap() -- to properly take the map data, refresh the map first

			local x, y, zone, subZone, mapId = utilities:GetPlayerPositionInfo()
			local zoneName = zo_strformat(SI_ITEM_FORMAT_STR_TEXT1_TEXT2, zone, subZone)
			local texture = settings:GetSettingsFromPinType(pinType, "texture")

			logger:Info("new pin location at %.4f x %.4f, zone: %s, mapId: %d, itemId: %d, itemName: %s, treasureMapTexture: %s, interactionType: %d, sceneName: %s, itemLink: %s, bookId: %d, texture: %s", x, y, zoneName, mapId, itemId, itemName, self.lastOpenedTreasureMap, interactionType, sceneName, itemLink, self.lastOpenedBookId, texture)

			-- Pop up a new notification by handing over pinData.
			local pinData =
			{
				itemId = itemId,
				mapId = mapId,
				pinType = pinType,
				x = x,
				y = y,
				texture = texture,
				zone = zoneName,
				itemName = itemName,
				lastOpenedTreasureMap = self.lastOpenedTreasureMap,
				lastOpenedBookId = self.lastOpenedBookId,
			}
			mining:Add(pinData, overwriteMiningState)
		else
			logger:Info("Invalid interaction. pinType %s, interactionType %d, sceneName %s", pinType, interactionType, sceneName)
		end
	end
end

function LostTreasure:IsLastOpenedItemId(itemId)
	logger:Debug("lastOpenedItemId: %s, itemId: %s", tostring(self.lastOpenedItemId) or "nil", itemId)
	return self.lastOpenedItemId == itemId
end

function LostTreasure:SetLastOpenedItemId(itemId)
	self.lastOpenedItemId = itemId
	logger:Debug("set lastOpenedItemId: %s, itemId: %s", tostring(self.lastOpenedItemId) or "nil", itemId)
end

do
	local SLOT_UPDATED_DELAY = ZO_ONE_SECOND_IN_MILLISECONDS / 5

	local function IsInteractionDelayed(interactionType, delayInSeconds)
		return interactionType == INTERACTION_BANK or delayInSeconds == 0
	end

	local function GetDelayInMilliseconds(delayInSeconds)
		return IsInteractionDelayed(interactionType, delayInSeconds) and SLOT_UPDATED_DELAY or utilities:SecondsToMilliseconds(delayInSeconds)
	end

	function LostTreasure:ProzessQueue(pinType, callback, interactionType)
		local delayInSeconds = settings:GetSettingDeletionDelay(pinType)
		local delayInMilliseconds = GetDelayInMilliseconds(delayInSeconds)
		logger:Debug("ProzessQueue - delayInSeconds: %s, delayInMilliseconds: %s, interactionType: %d", delayInSeconds, delayInMilliseconds, interactionType)
		utilities:RunCallbackAsync(callback, delayInMilliseconds)
	end
end

-- XML / Globals
do
	local anchor = ZO_Anchor:New()

	function LostTreasure:SetMiniMapAnchor()
		local db = savedVars:GetSavedVars()
		self.control:SetDimensions(db.miniMap.size, db.miniMap.size)
		anchor:ResetToAnchor(db.miniMap.anchor)
		anchor:Set(self.control)
	end

	function LostTreasure:OnMoveStop()
		anchor:SetFromControlAnchor(self.control)
		local db = savedVars:GetSavedVars()
		db.miniMap.anchor = anchor
	end
end

function LostTreasure_Hide()
	LOST_TREASURE:UpdateVisibility(HIDE_MINI_MAP)
end

function LostTreasure_SetMiniMapAnchor()
	LOST_TREASURE:SetMiniMapAnchor()
end

function LostTreasure_OnMoveStop(control)
	LOST_TREASURE:OnMoveStop()
end

function LostTreasure_OnInitialized(self)
	LOST_TREASURE = LostTreasure:New(self)
end