local LostTreasure = LostTreasure

local function IsValidInteractionType(pinType, specializedItemType, interactionType, sceneName)
	if sceneName == "hud" then
		local pinTypeInteractionType = LOST_TREASURE_PIN_TYPE_DATA[pinType].interactionType
		if pinTypeInteractionType == interactionType then
			return true
		end
	end
	return false
end

local function RequestRefreshMap()
	if SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
end

local function IsInteractionDelayed(interactionType, delayInSeconds)
	return interactionType == INTERACTION_BANK or delayInSeconds == 0
end

local function SecondsToMilliseconds(second)
	return second * ZO_ONE_SECOND_IN_MILLISECONDS
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
local SLOT_UPDATED_DELAY = ZO_ONE_SECOND_IN_MILLISECONDS / 5

LostTreasure.listMarkOnUse =
{
	[LOST_TREASURE_PIN_TYPE_TREASURE] = { },
	[LOST_TREASURE_PIN_TYPE_SURVEYS] = { },
}

function LostTreasure:Initialize(control)
	self.control = control
	self.mapControl = control:GetNamedChild("Map")
	self.closeControl = control:GetNamedChild("Close")

	local function OnAddOnLoaded(_, addOnName)
		if addOnName == self.addOnName then
			self.control:UnregisterForEvent(EVENT_ADD_ON_LOADED)

			self.savedVars = LibSavedVars
				:NewAccountWide("LostTreasure_Account", self.DEFAULTS)
				:AddCharacterSettingsToggle("LostTreasure_Character")

			self.bagCache = LostTreasure_BagCache:New(self.logger)
			self.notifications = LostTreasure_Notification:New(self.addOnName, self.addOnDisplayName, self.savedVars, self.logger, self.feedback)

			self.lastOpenedTreasureMapItemId = 0
			self:ResetCurrentTreasureMapTextureName()

			self:InitializePins()

			self:RegisterEvents()

			self:SetMiniMapAnchor()
			self:UpdateVisibility(HIDE_MINI_MAP)

			self:InitializeSettingsMenu()
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

	SHARED_INVENTORY:RegisterCallback("SlotAdded", function(...) self:SlotAdded(...) end)
	SHARED_INVENTORY:RegisterCallback("SlotRemoved", function(...) self:SlotRemoved(...) end)
end

function LostTreasure:OnEventShowTreasureMap(treasureMapIndex)
	local name, texturePath = GetTreasureMapInfo(treasureMapIndex)
	local mapTextureName = self:GetTreasureMapTexturePathName(texturePath)
	self.currentTreasureMapTextureName = mapTextureName

	self.logger:Info("Treasure map opened. name: %s, texturePath: %s, mapTextureName: %s, treasureMapIndex: %d", name, texturePath, mapTextureName, treasureMapIndex)

	self.mapControl:SetTexture(texturePath)
	self:UpdateVisibility(not self.savedVars.miniMap.enabled)

	local pinType = self:GetPinTypeFromString(name)
	if pinType then
		local data = LostTreasure:GetAllData()
		for zone, zonePinType in pairs(data) do
			local zonePins = zonePinType[pinType]
			if zonePins then
				for index, pinData in ipairs(zonePins) do
					if pinData[LOST_TREASURE_DATA_INDEX_TEXTURE] == mapTextureName then
						local itemId = pinData[LOST_TREASURE_DATA_INDEX_ITEMID]
						self.lastOpenedTreasureMapItemId = itemId
						local markOption = self:GetPinTypeSettings(pinType, "markOption")
						if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
							if not self:IsItemInMarkedOnUse(pinType, itemId) then
								table.insert(self.listMarkOnUse[pinType], itemId)
								LostTreasure:RefreshAllPinsFromPinType(pinType)
							end
						end
						break
					end
				end
			end

			-- Create pins from mined data
			local minedZoneData = self.savedVars.mining.data[zone]
			if minedZoneData then
				local minedZonePins = minedZoneData[pinType]
				if minedZonePins then
					for index, pinData in ipairs(minedZonePins) do
						if pinData[LOST_TREASURE_DATA_INDEX_TEXTURE] == mapTextureName then
							local itemId = pinData[LOST_TREASURE_DATA_INDEX_ITEMID]
							self.lastOpenedTreasureMapItemId = itemId
							local markOption = self:GetPinTypeSettings(pinType, "markOption")
							if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
								if not self:IsItemInMarkedOnUse(pinType, itemId) then
									table.insert(self.listMarkOnUse[pinType], itemId)
									LostTreasure:RefreshAllPinsFromPinType(pinType)
								end
							end
							break
						end
					end
				end
			end
		end
	end
end

function LostTreasure:OnEventShowBook(title, body, medium, showTitle, bookId)
	local itemId = LostTreasure:GetBookItemId(bookId)
	if itemId then
		local pinType = self:GetPinTypeFromString(title)
		local markOption = self:GetPinTypeSettings(pinType, "markOption")
		if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
			table.insert(self.listMarkOnUse[pinType], itemId)
			LostTreasure:RefreshAllPinsFromPinType(pinType)
		end
	end
	self.logger:Info("Book opened. bookId: %s, title: %s, isCollected: %s", bookId, title, tostring(itemId ~= nil))
end

function LostTreasure:IsItemInMarkedOnUse(pinType, itemId)
	return ZO_IsElementInNumericallyIndexedTable(self.listMarkOnUse[pinType], itemId) == true
end

function LostTreasure:ResetCurrentTreasureMapTextureName()
	self.currentTreasureMapTextureName = GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_NO_MAP)
end

function LostTreasure:SlotAdded(bagId, slotIndex, newSlotData)
	local specializedItemType = newSlotData.specializedItemType
	if bagId == BAG_BACKPACK and self.bagCache:IsTreasureOrSurveyItemType(specializedItemType) then

		local uniqueId = GetItemUniqueId(bagId, slotIndex)
		local itemId = GetItemId(bagId, slotIndex)
		local itemLink = GetItemLink(bagId, slotIndex)
		self.bagCache:AddItemToBagCache(uniqueId, itemId, itemLink)

		for pinType, pinData in ipairs(LOST_TREASURE_PIN_TYPE_DATA) do
			if pinData.specializedItemType == specializedItemType then
				local markOption = self:GetPinTypeSettings(pinType, "markOption")
				if markOption == LOST_TREASURE_MARK_OPTIONS_INVENTORY then
					self:RefreshAllPinsFromPinType(pinType)
				end
				break
			end
		end

		self.logger:Info("%s added to your backpack. itemLink: %s", newSlotData.name, itemLink)
	end
end

function LostTreasure:SlotRemoved(bagId, slotIndex, oldSlotData)
	local specializedItemType = oldSlotData.specializedItemType
	if bagId == BAG_BACKPACK and self.bagCache:IsTreasureOrSurveyItemType(specializedItemType) then
		local interactionType = GetInteractionType()

		local itemId = self.bagCache:GetItemIdFromUniqueId(oldSlotData.uniqueId)
		if itemId then

			-- Mini Map
			if self.lastOpenedTreasureMapItemId == itemId then
				local fadeDuration = ZO_ONE_SECOND_IN_MILLISECONDS
				self:ProzessQueue(nil, function() self:UpdateVisibility(HIDE_MINI_MAP, fadeDuration) end, interactionType)
			end

			-- PinTypes
			for pinType, pinData in ipairs(LOST_TREASURE_PIN_TYPE_DATA) do
				if pinData.specializedItemType == specializedItemType then
					local index = ZO_IndexOfElementInNumericallyIndexedTable(self.listMarkOnUse[pinType], itemId)
					if index then
						table.remove(self.listMarkOnUse[pinType], index)
					end

					self:ProzessQueue(pinType, function() self:RefreshAllPinsFromPinType(pinType) end, interactionType)

					local itemData = self.bagCache:DeleteItemFromBagCache(oldSlotData.uniqueId)
					if itemData and itemData.itemLink then
						local sceneName = SCENE_MANAGER:GetCurrentSceneName()
						self.logger:Info("%s removed from backpack. interactionType %d, sceneName: %s, itemId: %d", oldSlotData.name, interactionType, sceneName, itemId)
						self:RequestReport(pinType, interactionType, specializedItemType, itemData.itemId, oldSlotData.name, itemData.itemLink, sceneName)
					end
				end
			end
		end
	end
end

-- /script LOST_TREASURE:RequestReport(1, INTERACTION_NONE, SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP, 57764, "itemName", "itemLink", "hud")
function LostTreasure:RequestReport(pinType, interactionType, specializedItemType, itemId, itemName, itemLink, sceneName)
	if IsValidInteractionType(pinType, specializedItemType, interactionType, sceneName) then
		-- Check for exisiting items in LostTreasure_Data.
		local itemIds = self:GetPinTypeItemIds(pinType)
		if itemIds and itemIds[itemId] then
			self.logger:Info("Item %d has been found in database.", itemId)
			return -- item has been found, no need to continue
		end

		-- If no item has been found, we have to send a notification.
		RequestRefreshMap() -- to properly take the map data, refresh the map first

		local x, y, zone, subZone, mapId = self:GetPlayerPositionInfo()
		local zoneName = zo_strformat(SI_ITEM_FORMAT_STR_TEXT1_TEXT2, zone, subZone)

		self.logger:Info("new pin location at %.4f x %.4f, zone: %s, mapId: %d, itemId: %d, itemName: %s, treasureMapTexture: %s, interactionType: %d, sceneName: %s, itemLink: %s", x, y, zoneName, mapId, itemId, itemName, self.currentTreasureMapTextureName, interactionType, sceneName, itemLink)

		-- Pop up a new notification.
		local notificationData =
		{
			icon = self:GetPinTypeSettings(pinType, "texture"),
			x = x,
			y = y,
			zone = zoneName,
			mapId = mapId,
			itemId = itemId,
			itemName = itemName,
			lastOpenedTreasureMap = self.currentTreasureMapTextureName,
			addOnVersion = self.version,
			pinType = pinType,
		}
		self.notifications:NewNotification(notificationData)
	else
		self.logger:Info("Invalid interaction. pinType %d, specializedItemType %d, interactionType %d, sceneName %s", pinType, specializedItemType, interactionType, sceneName)
	end
end

function LostTreasure:GetPinTypeFromString(itemName)
	itemName = zo_strlower(itemName)
	for pinType, pinData in ipairs(LOST_TREASURE_PIN_TYPE_DATA) do
		if zo_strfind(itemName, pinData.compareString) then
			return pinType
		end
	end
	self.logger:Error("no pinType found for itemName: %s", itemName)
	return
end

function LostTreasure:GetItemLinkFromItemId(itemId)
	return string.format("|H0:item:%s:4:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", itemId)
end

function LostTreasure:GetTreasureMapTexturePathName(texturePath)
	return zo_strmatch(texturePath, ".+/(.+)%.dds")
end

function LostTreasure:GetPinTypeSettings(pinType, key)
	return self.savedVars.pinTypes[pinType][key]
end

function LostTreasure:GetDeletionDelay(pinType)
	return pinType and self.savedVars.pinTypes[pinType].deletionDelay or self.savedVars.miniMap.deletionDelay
end

function LostTreasure:UpdateVisibility(hidden, fadeTime)
	LOST_TREASURE_FRAGMENT:SetHiddenForReason("hasMapOpened", hidden, fadeTime, fadeTime)
end

function LostTreasure:CheckZoneData(pinType, key)
	-- We don't use RequestRefreshMap here, because you can't zoom out the map anymore.
	-- The refresh happens while opening the map manually anyways.
	local mapId = GetCurrentMapId()

	local data = LostTreasure:GetMapIdData(mapId)
	if data then
		local zonePins = data[pinType]
		if zonePins then
			for _, pinData in ipairs(zonePins) do
				local markOption = self:GetPinTypeSettings(pinType, "markOption")
				if markOption ~= LOST_TREASURE_MARK_OPTIONS_ALL then
					local itemId = pinData[LOST_TREASURE_DATA_INDEX_ITEMID]
					if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
						if self:IsItemInMarkedOnUse(pinType, itemId) then
							self:CreateNewPin(pinType, pinData, key)
						end
					else
						if self.bagCache:IsItemInBagCache(itemId) then
							self:CreateNewPin(pinType, pinData, key)
						end
					end
				else
					self:CreateNewPin(pinType, pinData, key)
				end
			end
		end
	end
end

function LostTreasure:CheckMinedData(pinType, key)
	-- We don't use RequestRefreshMap here, because you can't zoom out the map anymore.
	-- The refresh happens while opening the map manually anyways.
	local mapId = GetCurrentMapId()

	local data = self.savedVars.mining.data[mapId]
	if data then
		local zonePins = data[pinType]
		if zonePins then
			for _, pinData in ipairs(zonePins) do
				local markOption = self:GetPinTypeSettings(pinType, "markOption")
				if markOption ~= LOST_TREASURE_MARK_OPTIONS_ALL then
					local itemId = pinData[LOST_TREASURE_DATA_INDEX_ITEMID]
					if markOption == LOST_TREASURE_MARK_OPTIONS_USING then
						if self:IsItemInMarkedOnUse(pinType, itemId) then
							self:CreateNewPin(pinType, pinData, key)
						end
					else
						if self.bagCache:IsItemInBagCache(itemId) then
							self:CreateNewPin(pinType, pinData, key)
						end
					end
				else
					self:CreateNewPin(pinType, pinData, key)
				end
			end
		end
	end
end

function LostTreasure:RunCallbackAsync(callback, delay)
	zo_callLater(callback, delay)
end

function LostTreasure:ProzessQueue(pinType, callback, interactionType)
	local delayInSeconds = self:GetDeletionDelay(pinType)
	self:RunCallbackAsync(callback, IsInteractionDelayed(interactionType, delayInSeconds) and SLOT_UPDATED_DELAY or SecondsToMilliseconds(delayInSeconds))
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

function LostTreasure_Hide()
	LOST_TREASURE:UpdateVisibility(HIDE_MINI_MAP)
end

function LostTreasure_SetMiniMapAnchor()
	LOST_TREASURE:SetMiniMapAnchor()
end

function LostTreasure_ClearListMarkOnUse()
	ClearTable(LOST_TREASURE.listMarkOnUse)
end

function LostTreasure_OnMoveStop(control)
	LOST_TREASURE:OnMoveStop()
end

function LostTreasure_OnInitialized(self)
	LOST_TREASURE = LostTreasure:New(self)
end