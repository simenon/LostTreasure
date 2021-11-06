local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("itemCache")
local mining = internal.mining

local itemCache = { }
internal.itemCache = itemCache


local utilities = internal.utilities
local settings = internal.settings
local pins = internal.pins

local function IsTreasureOrSurveyItem(bagId, slotIndex)
	local specializedItemType = select(2, GetItemType(bagId, slotIndex))
	return utilities:IsTreasureOrSurveyItemType(specializedItemType)
end

function itemCache:Initialize()
	self.masterList = { }
	self:BuildMasterList()

	SHARED_INVENTORY:RegisterCallback("SlotAdded", function(...) self:SlotAdded(...) end)
	SHARED_INVENTORY:RegisterCallback("SlotRemoved", function(...) self:SlotRemoved(...) end)

	logger:Debug("initialized")
end

function itemCache:BuildMasterList()
	ZO_ClearTable(self.masterList)

	local itemList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(BAG_BACKPACK, IsTreasureOrSurveyItem)
	for _, slotData in pairs(itemList) do
		local uniqueId = GetItemUniqueId(slotData.bag, slotData.index)
		local itemId = GetItemId(slotData.bag, slotData.index)
		local itemLink = GetItemLink(slotData.bag, slotData.index)
		self:Add(uniqueId, itemId, itemLink)
	end

	logger:Debug("masterList updated")
end

function itemCache:IsItemInBagCache(itemId)
	for _, itemData in pairs(self.masterList) do
		if itemId == itemData.itemId then
			return true
		end
	end
	return false
end

function itemCache:GetIndexFromUniqueId(uniqueId)
	local uniqueIdString = Id64ToString(uniqueId)
	for index, itemData in ipairs(self.masterList) do
		if itemData.uniqueIdString == uniqueIdString then
			logger:Debug("index %d has been found from uniqueIdString %s", index, uniqueIdString)
			return index, itemData, uniqueIdString
		end
	end
	logger:Debug("index has not been found: uniqueIdString %s", uniqueIdString)
	return
end

function itemCache:GetItemIdFromUniqueId(uniqueId)
	local uniqueIdString = Id64ToString(uniqueId)
	for index, itemData in ipairs(self.masterList) do
		if itemData.uniqueIdString == uniqueIdString then
			local itemId = itemData.itemId
			logger:Debug("itemId %d has been found from uniqueIdString %s", itemId, uniqueIdString)
			return itemId
		end
	end
	logger:Debug("uniqueId has not been found: uniqueIdString %s", uniqueIdString)
	return
end

function itemCache:Add(uniqueId, itemId, itemLink)
	local data =
	{
		uniqueIdString = Id64ToString(uniqueId),
		itemId = itemId,
		itemLink = itemLink,
	}
	table.insert(self.masterList, data)
	logger:Verbose("%d (%s) has been added", itemId, GetItemLinkName(itemLink))
end

function itemCache:SlotAdded(bagId, slotIndex, newSlotData)
	if bagId ~= BAG_BACKPACK then
		return
	end

	local specializedItemType = newSlotData.specializedItemType
	if utilities:IsTreasureOrSurveyItemType(specializedItemType) then

		local uniqueId = GetItemUniqueId(bagId, slotIndex)
		local itemId = GetItemId(bagId, slotIndex)
		local itemLink = GetItemLink(bagId, slotIndex)
		self:Add(uniqueId, itemId, itemLink)

		for pinType, pinData in ipairs(LOST_TREASURE_PIN_TYPE_DATA) do
			if pinData.specializedItemType == specializedItemType then
				local markOption = settings:GetSettingsFromPinType(pinType, "markOption")
				if markOption == LOST_TREASURE_MARK_OPTIONS_INVENTORY then
					self:RefreshAllPinsFromPinType(pinType)
				end
				break
			end
		end

		logger:Info("%s added to your backpack cache. itemLink: %s", newSlotData.name, itemLink)
	else
		logger:Verbose("%s added to your backpack", newSlotData.name)
	end
end

function itemCache:Remove(uniqueId)
	local index, itemData, uniqueIdString = self:GetIndexFromUniqueId(uniqueId)
	if index then
		logger:Info("%d (%s) has been removed from cache", itemData.itemId, GetItemLinkName(itemData.itemLink))
		return table.remove(self.masterList, index)
	end
	logger:Error("uniqueId has not been found")
	return
end

function itemCache:SlotRemoved(bagId, slotIndex, oldSlotData)
	if bagId ~= BAG_BACKPACK then
		logger:Debug("this bagId is not tracked")
		return
	end

	local specializedItemType = oldSlotData.specializedItemType
	if utilities:IsTreasureOrSurveyItemType(specializedItemType) then
		local interactionType = GetInteractionType()

		local itemId = self:GetItemIdFromUniqueId(oldSlotData.uniqueId)
		if itemId then
			-- Mini Map
			if LostTreasure:IsLastOpenedTreasureMapItemId(itemId) then
				local fadeDuration = ZO_ONE_SECOND_IN_MILLISECONDS
				logger:Debug("update Mini Map - fadeDuration %d", fadeDuration)
				LostTreasure:ProzessQueue(nil, function() LostTreasure:UpdateVisibility(HIDE_MINI_MAP, fadeDuration) end, interactionType)
			end

			-- PinTypes
			for pinType, pinData in pairs(LOST_TREASURE_PIN_TYPE_DATA) do
				if pinData.specializedItemType == specializedItemType then
					local index = ZO_IndexOfElementInNumericallyIndexedTable(self.listMarkOnUse[pinType], itemId)
					if index then
						table.remove(self.listMarkOnUse[pinType], index)
					end

					local itemData = self:Remove(oldSlotData.uniqueId)
					if itemData and itemData.itemLink then
						logger:Debug("update PinTypes - index %d, itemLink %s", index, itemLink)
						LostTreasure:ProzessQueue(pinType, function() pins:RefreshAllPinsFromPinType(pinType) end, interactionType)

						if mining:IsActive() then
							local sceneName = SCENE_MANAGER:GetCurrentSceneName()
							logger:Info("%s removed from backpack. interactionType %d, sceneName: %s, specializedItemType: %d, itemId: %d", oldSlotData.name, interactionType, sceneName, specializedItemType, itemId)

							LostTreasure:RequestReport(pinType, interactionType, itemData.itemId, oldSlotData.name, itemData.itemLink, sceneName)
						else
							logger:Debug("mining is not active, no report will be requested")
						end
					end
				end
			end
		end
	end
end
