local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("itemCache")

local itemCache = { }
internal.itemCache = itemCache


local utilities = internal.utilities
local settings = internal.settings
local markOnUsing = internal.markOnUsing
local mining = internal.mining

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

function itemCache:GetUniqueEntry(uniqueId)
	local uniqueId64String = Id64ToString(uniqueId)
	local uniqueEntry = self.uniqueIdList[uniqueId64String]
	if uniqueEntry then
		logger:Debug("uniqueId64String %s has been found", uniqueId64String)
		return uniqueEntry, uniqueId64String
	end
	logger:Debug("uniqueId64String %s has not been found", uniqueId64String)
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
						-- internal.pins is loaded after ItemCache. That's why we have
						-- to call that again here instead of the beginning of this file.
						local pins = internal.pins
						pins:RefreshAllPinsFromPinType(pinType)
					end
					break
					-- this break is not really needed. it does only break the second
					-- pinType, if the specialized item was called in the first key.
					-- It's still helps not to iterate further.
				end
			end

			logger:Debug("%s added to your backpack cache. itemLink: %s", newSlotData.name, itemLink)
		else
			logger:Verbose("%s added to your backpack", newSlotData.name)
		end
	end
end

do
	-- Important Note:
	-- Make sure to use LOST_TREASURE instead of LostTreasure in this function, because this file is loaded before.
	-- Otherwise you will have issues by calling all those functions on LostTreasure.lua

	local MINIMAP_FADE_DURATION = ZO_ONE_SECOND_IN_MILLISECONDS
	local HIDE_MINI_MAP = true

	local function RequestHidingMiniMap(itemId, interactionType)
		local LostTreasure = LOST_TREASURE
		local lastOpenedItemId = LostTreasure:IsLastOpenedItemId(itemId)
		logger:Debug("isLastOpenedTreasureMap: %s", tostring(lastOpenedItemId))
		if lastOpenedItemId then
			LostTreasure:ProzessQueue(nil, function() LostTreasure:UpdateVisibility(HIDE_MINI_MAP, MINIMAP_FADE_DURATION) end, interactionType)
		end
	end

	local function RequestHidingPins(self, specializedItemType, itemId, interactionType, oldSlotData)
		for pinType, pinData in pairs(LOST_TREASURE_PIN_TYPE_DATA) do
			if pinData.specializedItemType == specializedItemType then
				if markOnUsing:DoesExist(pinType, itemId) then
					markOnUsing:Remove(pinType, itemId)
				end

				local itemData = self:Remove(oldSlotData.uniqueId)
				if itemData and itemData.itemLink then
					local LostTreasure = LOST_TREASURE
					LostTreasure:ProzessQueue(pinType, function() LostTreasure:RefreshPinTypePins(pinType) end, interactionType)

					if mining:IsActive() then
						local sceneName = SCENE_MANAGER:GetCurrentSceneName()
						logger:Debug("%s removed from backpack. interactionType %d, sceneName: %s, specializedItemType: %d, itemId: %d", oldSlotData.name, interactionType, sceneName, specializedItemType, itemId)

						LostTreasure:RequestReport(pinType, interactionType, itemData.itemId, oldSlotData.name, itemData.itemLink, sceneName)
					else
						logger:Debug("mining is not active, no report will be requested")
					end
				end
			end
		end
	end

	function itemCache:Remove(uniqueId)
		local uniqueEntry, uniqueId64String = self:GetUniqueEntry(uniqueId)
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

	function itemCache:SlotRemoved(bagId, slotIndex, oldSlotData)
		if bagId ~= BAG_BACKPACK then
			return
		end

		local specializedItemType = oldSlotData.specializedItemType
		if utilities:IsTreasureOrSurveyItemType(specializedItemType) then
			local uniqueEntry = self:GetUniqueEntry(oldSlotData.uniqueId)
			if uniqueEntry then
				local itemId = uniqueEntry.itemId
				local interactionType = GetInteractionType()
				RequestHidingMiniMap(itemId, interactionType)
				RequestHidingPins(self, specializedItemType, itemId, interactionType, oldSlotData)
			end
		end
	end
end