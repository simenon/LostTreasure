local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("itemCache")
local mining = internal.mining

local itemCache = { }
internal.itemCache = itemCache


local utilities = internal.utilities
local settings = internal.settings
local markOnUsing = internal.markOnUsing

local Id64ToString, ZO_ClearTable = Id64ToString, ZO_ClearTable
local GetItemId, GetItemUniqueId, GetItemLink = GetItemId, GetItemUniqueId, GetItemLink


local function IsTreasureOrSurveyItem(bagId, slotIndex)
	local specializedItemType = select(2, GetItemType(bagId, slotIndex))
	return utilities:IsTreasureOrSurveyItemType(specializedItemType)
end

function itemCache:Initialize()
	self.uniqueIdList = { }
	self.itemIdList = { }
	self:BuildMasterLists()

	SHARED_INVENTORY:RegisterCallback("SlotAdded", function(...) self:SlotAdded(...) end)
	SHARED_INVENTORY:RegisterCallback("SlotRemoved", function(...) self:SlotRemoved(...) end)

	logger:Debug("initialized")
end

function itemCache:BuildMasterLists()
	ZO_ClearTable(self.uniqueIdList)
	ZO_ClearTable(self.itemIdList)

	local itemList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(BAG_BACKPACK, IsTreasureOrSurveyItem)
	for _, slotData in pairs(itemList) do
		local itemId = GetItemId(slotData.bag, slotData.index)
		local uniqueId = GetItemUniqueId(slotData.bag, slotData.index)
		local itemLink = GetItemLink(slotData.bag, slotData.index)
		self:Add(itemId, uniqueId, itemLink)
	end

	logger:Debug("masterList updated")
end

function itemCache:IsItemInBagCache(itemId)
	return self.itemIdList[itemId]
end

function itemCache:GetItemIdFromUniqueId(uniqueId)
	local uniqueId64String = Id64ToString(uniqueId)
	local uniqueEntry = self.uniqueIdList[uniqueId64String]
	if uniqueEntry then
		logger:Debug("itemId %d has been found from uniqueId64String %s", itemId, uniqueId64String)
		return uniqueEntry.itemId
	end
	logger:Debug("Can't return itemId, because uniqueId64String %s has not been found", uniqueId64String)
	return
end

do
	function itemCache:Add(itemId, uniqueId, itemLink)
		if not self.itemIdList[itemId] then
			self.itemIdList[itemId] = true
		end

		local uniqueId64String = Id64ToString(uniqueId)
		if not self.uniqueIdList[uniqueId64String] then
			local data =
			{
				uniqueIdString = uniqueId64String,
				itemId = itemId,
				itemLink = itemLink,
			}
			self.uniqueIdList[uniqueId64String] = data
		end

		logger:Verbose("%d (%s) has been added", itemId, GetItemLinkName(itemLink))
	end

	function itemCache:SlotAdded(bagId, slotIndex, newSlotData)
		if bagId ~= BAG_BACKPACK then
			return
		end

		local specializedItemType = newSlotData.specializedItemType
		if utilities:IsTreasureOrSurveyItemType(specializedItemType) then

			local itemId = GetItemId(bagId, slotIndex)
			local uniqueId = GetItemUniqueId(bagId, slotIndex)
			local itemLink = GetItemLink(bagId, slotIndex)
			self:Add(itemId, uniqueId, itemLink)

			for pinType, pinData in pairs(LOST_TREASURE_PIN_TYPE_DATA) do
				if pinData.specializedItemType == specializedItemType then
					local markOption = settings:GetSettingsFromPinType(pinType, "markOption")
					if markOption == LOST_TREASURE_MARK_OPTIONS_INVENTORY then
						self:RefreshAllPinsFromPinType(pinType)
					end
					break
				end
			end

			logger:Debug("%s added to your backpack cache. itemLink: %s", newSlotData.name, itemLink)
		else
			logger:Verbose("%s added to your backpack", newSlotData.name)
		end
	end
end

do
	local MINIMAP_FADE_DURATION = ZO_ONE_SECOND_IN_MILLISECONDS
	local HIDE_MINI_MAP = true

	local function RequestHidingMiniMap(itemId, interactionType)
		local lastOpenedItemId = LOST_TREASURE:IsLastOpenedItemId(itemId)
		logger:Debug("isLastOpenedTreasureMap: %s", tostring(lastOpenedItemId))
		if lastOpenedItemId then

			LOST_TREASURE:ProzessQueue(nil, function() LOST_TREASURE:UpdateVisibility(HIDE_MINI_MAP, MINIMAP_FADE_DURATION) end, interactionType)
		end
	end

	local function RequestHidingPins(specializedItemType, itemId, interactionType, oldSlotData)
		for pinType, pinData in pairs(LOST_TREASURE_PIN_TYPE_DATA) do
			if pinData.specializedItemType == specializedItemType then
				if markOnUsing:DoesExist(pinType, itemId) then
					markOnUsing:Remove(pinType, itemId)
				end

				local itemData = self:Remove(oldSlotData.uniqueId)
				if itemData and itemData.itemLink then
					LOST_TREASURE:ProzessQueue(pinType, function() LOST_TREASURE:RefreshPinTypePins(pinType) end, interactionType)

					if mining:IsActive() then
						local sceneName = SCENE_MANAGER:GetCurrentSceneName()
						logger:Debug("%s removed from backpack. interactionType %d, sceneName: %s, specializedItemType: %d, itemId: %d", oldSlotData.name, interactionType, sceneName, specializedItemType, itemId)

						LOST_TREASURE:RequestReport(pinType, interactionType, itemData.itemId, oldSlotData.name, itemData.itemLink, sceneName)
					else
						logger:Debug("mining is not active, no report will be requested")
					end
				end
			end
		end
	end

	function itemCache:Remove(uniqueId)
		local uniqueId64String = Id64ToString(uniqueId)
		local uniqueEntry = self.uniqueIdList[uniqueId64String]
		if uniqueEntry then
			local itemId = uniqueEntry.itemId
			self.itemIdList[itemId] = nil
			logger:Debug("%d has been deleted from itemIdList", itemId)

			self.uniqueIdList[uniqueId64String] = nil
			logger:Debug("%d (%s) has been removed from cache", uniqueEntry.itemId, GetItemLinkName(uniqueEntry.itemLink))
			return uniqueEntry
		else
			logger:Error("uniqueId has not been found")
		end
	end

	-- Important Note:
	-- Make sure to use LOST_TREASURE instead of LostTreasure in this function, because this file is loaded before.
	-- Otherwise you will have issues by calling all those functions on LostTreasure.lua
	function itemCache:SlotRemoved(bagId, slotIndex, oldSlotData)
		if bagId ~= BAG_BACKPACK then
			return
		end

		local specializedItemType = oldSlotData.specializedItemType
		if utilities:IsTreasureOrSurveyItemType(specializedItemType) then
			local itemId = self:GetItemIdFromUniqueId(oldSlotData.uniqueId)
			if itemId then
				local interactionType = GetInteractionType()
				RequestHidingMiniMap(itemId, interactionType)
				RequestHidingPins(specializedItemType, itemId, interactionType, oldSlotData)
			end
		end
	end
end