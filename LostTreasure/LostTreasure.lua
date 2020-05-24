local ADDON_NAME = "LostTreasure"
local ADDON_DISPLAY_NAME = "Lost Treasure"
local ADDON_WEBSITE = "http://www.esoui.com/downloads/info561-LostTreasure.html"
local ADDON_FEEDBACK = "https://www.esoui.com/portal.php?id=121&a=bugreport&addonid=561"

local LibMapPins = LibMapPins
local COMPASS_PINS = COMPASS_PINS

local DEFAULTS =
{
	pinTypes =
	{
		[LOST_TREASURE_PIN_TYPE_TREASURE] =
		{
			showOnMap = true,
			showOnCompass = true,
			texture = "LostTreasure/Icons/x_red.dds",
			size = 32,
			markOption = LOST_TREASURE_MARK_OPTIONS_INVENTORY,
			pinLevel = 45,
			deletionDelay = 10,
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] =
		{
			showOnMap = true,
			showOnCompass = true,
			texture = "LostTreasure/Icons/x_red.dds",
			size = 32,
			markOption = LOST_TREASURE_MARK_OPTIONS_INVENTORY,
			pinLevel = 45,
			deletionDelay = 10,
		},
	},
	miniMap =
	{
		enabled = true,
		anchor = ZO_Anchor:New(TOPLEFT, nil, TOPLEFT, 100, 100),
		size = 400,
		deletionDelay = 10,
	},
	notifications = { },
}


-- LOCAL PIN DATA
-----------------
local PIN_DATA_INDEX_X = 1
local PIN_DATA_INDEX_Y = 2
local PIN_DATA_INDEX_TEXTURE = 3
local PIN_DATA_INDEX_ITEMID = 4

local TRACKED_SPECIALIZED_ITEM_TYPES =
{
	[SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP] = true,
	[SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT] = true,
}


-- LOCAL FUNCTIONS
------------------
local function GetAddOnInfos()
	local addOnManager = GetAddOnManager()
	for i = 1, addOnManager:GetNumAddOns() do
		local name, _, author = addOnManager:GetAddOnInfo(i)
		if name == ADDON_NAME then
			return author, addOnManager:GetAddOnVersion(i)
		end
	end
end

local function IsTrackedSpecializedItem(bagId, slotIndex)
	local specializedItemType = select(2, GetItemType(bagId, slotIndex))
	return TRACKED_SPECIALIZED_ITEM_TYPES[specializedItemType] == true
end

local function IsTreasureOrSurveyItemType(specializedItemType)
	return TRACKED_SPECIALIZED_ITEM_TYPES[specializedItemType] == true
end

local function GetPinNameFromPinType(pinType)
	return LOST_TREASURE_PIN_TYPE_DATA[pinType].pinName
end

local function RefreshAllPinsFromPinType(pinName, refreshMapPinsOnly)
	if type(pinName) == "number" then
		pinName = GetPinNameFromPinType(pinName)
	end
	LibMapPins:RefreshPins(pinName)
	if not refreshMapPinsOnly then
		COMPASS_PINS:RefreshPins(pinName)
	end
end

local function GetPinTypeFromString(itemName)
	itemName = zo_strlower(itemName)
	for pinType, pinData in ipairs(LOST_TREASURE_PIN_TYPE_DATA) do
		if zo_strfind(itemName, pinData.compareString) then
			return pinType
		end
	end
	self.logger:Debug("no pinType found for itemName: %s", itemName)
	return
end

local function CreateNewPin(pinType, pinData, key)
	local pinName = GetPinNameFromPinType(pinType)
	if key == LOST_TREASURE_PIN_KEY_MAP then
		LibMapPins:CreatePin(pinName, pinData, pinData[PIN_DATA_INDEX_X], pinData[PIN_DATA_INDEX_Y])
	elseif key == LOST_TREASURE_PIN_KEY_COMPASS then
		local itemLink = LOST_TREASURE:GetItemLinkFromItemId(pinData[PIN_DATA_INDEX_ITEMID])
		local itemName = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))
		COMPASS_PINS.pinManager:CreatePin(pinName, pinData, pinData[PIN_DATA_INDEX_X], pinData[PIN_DATA_INDEX_Y], itemName)
	end
end

local function AddTooltip(coordFormat, itemName, color, itemStackCount, iconPath)
	if IsInGamepadPreferredMode() then
		local baseSection = ZO_MapLocationTooltip_Gamepad.tooltip
		ZO_MapLocationTooltip_Gamepad:LayoutIconStringLine(baseSection, nil, itemName, { widthPercent = 100, fontFace = "$(GAMEPAD_BOLD_FONT)", fontSize = "$(GP_34)", uppercase = true, fontColor = color })
		ZO_MapLocationTooltip_Gamepad:LayoutIconStringLine(baseSection, iconPath, coordFormat, { fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_3 })
		if itemStackCount > 1 then
			ZO_MapLocationTooltip_Gamepad:LayoutStringLine(baseSection, string.format("%s: %d", GetString(SI_CRAFTING_QUANTITY_HEADER), itemStackCount))
		end
	else
		InformationTooltip:AddLine(itemName, "", color:UnpackRGB())
		-- don't use zo_iconTextFormat, because it will turns points into commas
		InformationTooltip:AddLine(string.format("%s %s", zo_iconFormat(iconPath, 32, 32), coordFormat), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		if itemStackCount > 1 then
			InformationTooltip:AddLine(string.format("%s: %d", GetString(SI_CRAFTING_QUANTITY_HEADER), itemStackCount), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		end
	end
end

local function IsValidMapType()
	return GetMapType() <= MAPTYPE_ZONE
end

local function ClearTable(clearableTable)
	for key, value in pairs(clearableTable) do
		if type(value) == "table" then
			ClearTable(value)
		else
			clearableTable[key] = nil
		end
	end
end


-- LOST TREASURE
------------------
local HIDE_MINI_MAP = true
local HOOK_COMPASS_PIN_NAME = true


local LostTreasure = ZO_Object:Subclass()

LostTreasure.bagCache = { }
LostTreasure.isInitial = true

LostTreasure.listMarkOnUse =
{
	[LOST_TREASURE_PIN_TYPE_TREASURE] = { },
	[LOST_TREASURE_PIN_TYPE_SURVEYS] = { },
}

function LostTreasure:New(...)
	local container = ZO_Object.New(self)
	container:Initialize(...)
	return container
end

function LostTreasure:Initialize(control)
	self.control = control
	self.mapControl = control:GetNamedChild("Map")
	self.closeControl = control:GetNamedChild("Close")

	local function OnAddOnLoaded(_, addOnName)
		if addOnName == ADDON_NAME then
			self.control:UnregisterForEvent(EVENT_ADD_ON_LOADED)

			self.savedVars = LibSavedVars
				:NewAccountWide("LostTreasure_Account", DEFAULTS)
				:AddCharacterSettingsToggle("LostTreasure_Character")

			self.author, self.version = GetAddOnInfos()
			self.logger = LibDebugLogger(ADDON_NAME)
			self.notifications = LostTreasure_Notification:New(ADDON_NAME, ADDON_DISPLAY_NAME, self.savedVars, self.logger, ADDON_FEEDBACK)

			self:InitializeBagCache()
			self:InitializePins()

			self:RegisterEvents()

			self:SetMiniMapAnchor()
			self:UpdateVisibility(HIDE_MINI_MAP)

			self.settings = LostTreasure_Settings:New(ADDON_NAME, ADDON_DISPLAY_NAME, self.version, self.author, ADDON_WEBSITE, ADDON_FEEDBACK, self.savedVars, DEFAULTS)
		end
	end

	LOST_TREASURE_FRAGMENT = ZO_HUDFadeSceneFragment:New(control)
	HUD_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	HUD_UI_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	TREASURE_MAP_INVENTORY_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)
	GAMEPAD_TREASURE_MAP_INVENTORY_SCENE:AddFragment(LOST_TREASURE_FRAGMENT)

	self.control:RegisterForEvent(EVENT_ADD_ON_LOADED, OnAddOnLoaded)
end

function LostTreasure:RegisterEvents()
	self.control:RegisterForEvent(EVENT_SHOW_TREASURE_MAP, function(_, ...) self:OnEventShowTreasureMap(...) end)
	self.control:RegisterForEvent(EVENT_SHOW_BOOK, function(_, ...) self:OnEventShowBook(...) end)

	SHARED_INVENTORY:RegisterCallback("SlotAdded", function(...) self:SlotAdded(...) end)
	SHARED_INVENTORY:RegisterCallback("SlotRemoved", function(...) self:SlotRemoved(...) end)
end

function LostTreasure:OnEventShowTreasureMap(treasureMapIndex)
	local name, texturePath = GetTreasureMapInfo(treasureMapIndex)
	local mapTextureName = self:GetTreasureMapTexturePathName(texturePath)
	self.currentTreasureMapTextureName = mapTextureName

	self.logger:Info("Treasure map opened. name: %s, texturePath: %s, mapTextureName: %s", name, texturePath, mapTextureName)

	self.mapControl:SetTexture(texturePath)
	self:UpdateVisibility(not self.savedVars.miniMap.enabled)

	local pinType = GetPinTypeFromString(name)
	local data = LostTreasure_GetAllData()
	for zone, zonePinType in pairs(data) do
		local zonePins = zonePinType[pinType]
		if zonePins then
			for index, pinData in ipairs(zonePins) do
				if pinData[PIN_DATA_INDEX_TEXTURE] == mapTextureName then
					local itemId = pinData[PIN_DATA_INDEX_ITEMID]
					self.lastOpenedTreasureMapItemId = itemId
					local markOption = self:GetPinTypeSettings(pinType, "markOption")
					if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
						table.insert(self.listMarkOnUse[pinType], itemId)
						RefreshAllPinsFromPinType(pinType)
					end
					return
				end
			end
		end
	end
end

function LostTreasure:OnEventShowBook(title, body, medium, showTitle, bookId)
	local itemId = LostTreasure_GetBookItemId(bookId)
	local pinType = GetPinTypeFromString(title)
	local markOption = self:GetPinTypeSettings(pinType, "markOption")
	if itemId and markOption == LOST_TREASURE_MARK_OPTIONS_USING then
		table.insert(self.listMarkOnUse[pinType], itemId)
		RefreshAllPinsFromPinType(pinType)
	end

	self.logger:Info("Book opened. bookId: %s, title: %s, isCollected: %s", bookId, title, tostring(itemId ~= nil))
end

function LostTreasure:InitializeBagCache()
	ClearTable(self.bagCache)
	local itemId
	local itemList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(BAG_BACKPACK, IsTrackedSpecializedItem)
	for _, itemInfo in pairs(itemList) do
		itemId = GetItemId(itemInfo.bag, itemInfo.index)
		self.bagCache[itemId] = true
	end
end

function LostTreasure:InitializePins()
	local function PinTypeAddCallback(pinType, pinName)
		if IsValidMapType() and LibMapPins:IsEnabled(pinName) then
			self:CheckZoneData(pinType, LOST_TREASURE_PIN_KEY_MAP)
		end
	end

	local function PinCallback(pinType)
		if IsValidMapType() and self:GetPinTypeSettings(pinType, "showOnCompass") then
			self:CheckZoneData(pinType, LOST_TREASURE_PIN_KEY_COMPASS)
		end
	end

	local pinTooltipCreator = {
		creator = function(pin)
			local pinTag = select(2, pin:GetPinTypeAndTag())
			local x, y = pinTag[PIN_DATA_INDEX_X], pinTag[PIN_DATA_INDEX_Y]
			local coordFormat = string.format("%.2f x %.2f", x * 100, y * 100)

			local itemId = pinTag[PIN_DATA_INDEX_ITEMID]
			local itemLink = LOST_TREASURE:GetItemLinkFromItemId(itemId)
			local itemName = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))
			local color = GetItemQualityColor(GetItemLinkQuality(itemLink))

			AddTooltip(coordFormat, itemName, color, GetItemLinkStacks(itemLink), "LostTreasure/Icons/map_white.dds")
		end,
	}

	for pinType, settings in ipairs(self.savedVars.pinTypes) do
		local pinName = GetPinNameFromPinType(pinType)
		local pinCheckboxText = zo_strformat("<<C:1>> (<<C:2>>)", LOST_TREASURE_PIN_TYPE_DATA[pinType].name, ADDON_DISPLAY_NAME)

		local mapPinLayout = {
			level = settings.pinLevel,
			size = settings.size,
			texture = settings.texture,
		}
		LibMapPins:AddPinType(pinName, function() PinTypeAddCallback(pinType, pinName) end, nil, mapPinLayout, pinTooltipCreator)
		LibMapPins:AddPinFilter(pinName, pinCheckboxText, nil, settings, "showOnMap")

		local compassPinLayout = {
			maxDistance = 0.05,
			texture = settings.texture,
		}
		COMPASS_PINS:AddCustomPin(pinName, function() PinCallback(pinType) end, compassPinLayout)
		COMPASS_PINS:RefreshPins(pinName)
	end

	-- compass pin names
	self:SetCompassPinNameState(not HOOK_COMPASS_PIN_NAME) -- turn off by default until it's used

	if COMPASS_PINS.version > 30 then
		local TIME_BETWEEN_LABEL_UPDATES_MS = 250
		local nextLabelUpdateTime = 0
		local now = 0

		ZO_PreHook(COMPASS, "OnUpdate", function()
			if not self:GetCompassPinNameState() and nextLabelUpdateTime < nextLabelUpdateTime + 2 * TIME_BETWEEN_LABEL_UPDATES_MS then
				return false
			else
				return true
			end
		end)

		local overPinLabel = COMPASS.centerOverPinLabel
		local overPinAnimation = COMPASS.centerOverPinLabelAnimation
		local overrideAnimation = COMPASS.areaOverrideAnimation

		CALLBACK_MANAGER:RegisterCallback("CustomCompassPins_SizeCallback", function(pin, _, normalizedAngle, normalizedDistance)
			local now = GetFrameTimeMilliseconds()
			if now < nextLabelUpdateTime then
				return
			end
			nextLabelUpdateTime = now + TIME_BETWEEN_LABEL_UPDATES_MS

			if pin.pinName then
				if zo_abs(normalizedAngle) < 0.1 and zo_abs(normalizedDistance) < 0.95 then
					self:SetCompassPinNameState(HOOK_COMPASS_PIN_NAME)
					if overrideAnimation:IsPlaying() then
						overPinAnimation:PlayBackward()
					elseif not overPinAnimation:IsPlaying() or not overPinAnimation:IsPlayingBackward() then
						overPinLabel:SetText(pin.pinName)
						overPinAnimation:PlayForward()
					end
				else
					self:SetCompassPinNameState(not HOOK_COMPASS_PIN_NAME)
				end
			end
		end)
	end
end

function LostTreasure:SlotAdded(bagId, slotIndex, newSlotData)
	local specializedItemType = newSlotData.specializedItemType
	if bagId == BAG_BACKPACK and IsTreasureOrSurveyItemType(specializedItemType) then
		for pinType, pinData in ipairs(LOST_TREASURE_PIN_TYPE_DATA) do
			if pinData.specializedItemType == specializedItemType then
				local markOption = self:GetPinTypeSettings(pinType, "markOption")
				if markOption == LOST_TREASURE_MARK_OPTIONS_INVENTORY then
					RefreshAllPinsFromPinType(pinType)
				end
				break
			end
		end

		local itemId = GetItemId(bagId, slotIndex)
		self.bagCache[itemId] = true

		self.logger:Debug("Item %d added to your backpack. itemLink: %s", itemId, GetItemLink(bagId, slotIndex))
	end
end

function LostTreasure:SlotRemoved(bagId, slotIndex, oldSlotData)
	local specializedItemType = oldSlotData.specializedItemType
	if bagId == BAG_BACKPACK and IsTreasureOrSurveyItemType(specializedItemType) then
		local interactionType = GetInteractionType()

		-- Mini Map
		local lastOpenedTreasureMapItemId = self.lastOpenedTreasureMapItemId
		if lastOpenedTreasureMapItemId and lastOpenedTreasureMapItemId == oldSlotData.itemId then
			self:ProzessQueue(nil, function() self:UpdateVisibility(HIDE_MINI_MAP, ZO_ONE_SECOND_IN_MILLISECONDS) end, interactionType)
		end

		-- PinTypes
		for pinType, pinData in ipairs(LOST_TREASURE_PIN_TYPE_DATA) do
			if pinData.specializedItemType == specializedItemType then
				local markOption = self:GetPinTypeSettings(pinType, "markOption")
				if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
					local index = ZO_IndexOfElementInNumericallyIndexedTable(self.listMarkOnUse[pinType], oldSlotData.itemId)
					if index then
						table.remove(self.listMarkOnUse[pinType], index)
					end
				end

				self:ProzessQueue(pinType, function() RefreshAllPinsFromPinType(pinType) end, interactionType)
				self.bagCache[oldSlotData.itemId] = nil

				self.logger:Debug("Item %d removed from backpack. interactionType %d, itemLink: %s", oldSlotData.itemId, interactionType, oldSlotData.itemLink)

				return self:RequestReport(pinType, interactionType, oldSlotData.itemId, oldSlotData.itemLink)
			end
		end
	end
end

function LostTreasure:RequestReport(pinType, interactionType, itemId, itemLink)
	-- INTERACTION_HARVEST for treasure maps and INTERACTION_NONE for survey report
	if interactionType == INTERACTION_HARVEST or interactionType == INTERACTION_NONE then
		local zone = self:GetZoneName()
		local pinTypeData = LostTreasure_GetZonePinTypeData(pinType, zone)
		if pinTypeData then
			for _, layoutData in ipairs(pinTypeData) do
				if itemId == layoutData[PIN_DATA_INDEX_ITEMID] then
					return -- item was found, no need to continue
				end
			end
		end

		local NO_CHAT_OUTPUT = true
		local x, y = LibMapPins:MyPosition(NO_CHAT_OUTPUT)

		self.logger:Info("new pin location at %.4f x %.4f, zone: %s, interactionType: %d, itemId: %d, itemLink: %s", x, y, zone, interactionType, itemId, itemLink)

		self.notifications:NewNotification(self:GetPinTypeSettings(pinType, "texture"), x, y, zone, itemId, self.currentTreasureMapTextureName)
	end
end

function LostTreasure:GetItemLinkFromItemId(itemId)
	return string.format("|H0:item:%s:4:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", itemId)
end

function LostTreasure:GetZoneName()
	local mapTileTexture = GetMapTileTexture()
	return zo_strmatch(mapTileTexture, "%w+/%w+/%w+/(%w+)_%w+_%d.dds")
end

function LostTreasure:GetTreasureMapTexturePathName(texturePath)
	return zo_strmatch(texturePath, ".+/(.+)%.dds")
end

function LostTreasure:GetPinTypeSettings(pinType, key)
	return self.savedVars.pinTypes[pinType][key]
end

function LostTreasure:GetCompassPinNameState()
	return self.disableCompassAnimation
end

function LostTreasure:SetCompassPinNameState(state)
	self.disableCompassAnimation = state
end

function LostTreasure:UpdateVisibility(hidden, fadeTime)
	LOST_TREASURE_FRAGMENT:SetHiddenForReason("hasMapOpened", hidden, fadeTime, fadeTime)
end

function LostTreasure:ProzessQueue(pinType, callback, interactionType)
	local delay
	if pinType then
		delay = self.savedVars.pinTypes[pinType].deletionDelay
	else
		delay = self.savedVars.miniMap.deletionDelay
	end

	if interactionType == INTERACTION_BANK or delay == 0 then
		callback()
	else
		zo_callLater(callback, delay * 1000)
	end
end

function LostTreasure:CheckZoneData(pinType, key)
	local markOption = self:GetPinTypeSettings(pinType, "markOption")
	local zone = self:GetZoneName()
	local data = LostTreasure_GetZoneData(zone)
	if data then
		local zonePins = data[pinType]
		if zonePins then
			for _, pinData in ipairs(zonePins) do
				if markOption ~= LOST_TREASURE_MARK_OPTIONS_ALL then
					local itemId = pinData[PIN_DATA_INDEX_ITEMID]
					if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
						if ZO_IsElementInNumericallyIndexedTable(self.listMarkOnUse[pinType], itemId) then
							CreateNewPin(pinType, pinData, key)
						end
					else
						if self.bagCache[itemId] then
							CreateNewPin(pinType, pinData, key)
						end
					end
				else
					CreateNewPin(pinType, pinData, key)
				end
			end
		end
	end
end


-- XML / Globals
do
	local anchor = ZO_Anchor:New()

	function LostTreasure:SetMiniMapAnchor()
		local savedVars = self.savedVars
		self.control:SetDimensions(savedVars.miniMap.size, savedVars.miniMap.size)
		anchor:ResetToAnchor(savedVars.miniMap.anchor)
		anchor:Set(self.control)
	end

	function LostTreasure:OnMoveStop()
		anchor:SetFromControlAnchor(self.control)
		local savedVars = self.savedVars
		savedVars.miniMap.anchor = anchor
	end
end

function LostTreasure_GetDefaultSettings()
	return DEFAULTS
end

function LostTreasure_GetSavedVarsSettings()
	return LOST_TREASURE.savedVars
end

function LostTreasure_SetCompassPinNameState(state)
	LOST_TREASURE:SetCompassPinNameState(state)
end

function LostTreasure_GetPinNameFromPinType(pinType)
	return GetPinNameFromPinType(pinType)
end

function LostTreasure_RefreshAllPinsFromPinType(pinName, onlyMapPins)
	RefreshAllPinsFromPinType(pinName, onlyMapPins)
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