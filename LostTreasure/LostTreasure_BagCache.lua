LostTreasure_BagCache = ZO_InitializingObject:Subclass()

local TRACKED_SPECIALIZED_ITEM_TYPES =
{
	[SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP] = true,
	[SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT] = true,
}

local function IsTreasureOrSurveyItem(bagId, slotIndex)
	local specializedItemType = select(2, GetItemType(bagId, slotIndex))
	return TRACKED_SPECIALIZED_ITEM_TYPES[specializedItemType] == true
end

function LostTreasure_BagCache:Initialize(logger)
	self.logger = logger:Create("Cache")
	self.bagCache = { }
	self:BuildMasterList()
end

function LostTreasure_BagCache:BuildMasterList()
	ZO_ClearTable(self.bagCache)

	local itemList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(BAG_BACKPACK, IsTreasureOrSurveyItem)
	for _, slotData in pairs(itemList) do
		local uniqueId = GetItemUniqueId(slotData.bag, slotData.index)
		local itemId = GetItemId(slotData.bag, slotData.index)
		local itemLink = GetItemLink(slotData.bag, slotData.index)
		self:AddItemToBagCache(uniqueId, itemId, itemLink)
	end

	self.logger:Debug("BuildMasterList done")
end

function LostTreasure_BagCache:AddItemToBagCache(uniqueId, itemId, itemLink)
	local data =
	{
		uniqueId = uniqueId,
		itemId = itemId,
		itemLink = itemLink,
	}
	table.insert(self.bagCache, data)
	self.logger:Debug("ItemId %d has been added to cache. ItemLink %s", itemId, itemLink)
end

function LostTreasure_BagCache:DeleteItemFromBagCache(uniqueId)
	local index, itemData = self:GetIndexFromUniqueId(uniqueId)
	if index then
		self.logger:Info("ItemId %d has been removed from cache. ItemLink %s", itemData.itemId, itemData.itemLink)
		return table.remove(self.bagCache, index)
	end
	self.logger:Error("uniqueId not found - %d", Id64ToString(uniqueId))
	return
end

function LostTreasure_BagCache:IsTreasureOrSurveyItemType(specializedItemType)
	return TRACKED_SPECIALIZED_ITEM_TYPES[specializedItemType] == true
end

function LostTreasure_BagCache:IsItemInBagCache(itemId)
	for _, itemData in pairs(self.bagCache) do
		if itemId == itemData.itemId then
			return true
		end
	end
	return false
end

function LostTreasure_BagCache:GetItemIdFromUniqueId(uniqueId)
	for index, itemData in ipairs(self.bagCache) do
		if itemData.uniqueId == uniqueId then
			return itemData.itemId
		end
	end
	return
end

function LostTreasure_BagCache:GetIndexFromUniqueId(uniqueId)
	for index, itemData in ipairs(self.bagCache) do
		if itemData.uniqueId == uniqueId then
			return index, itemData
		end
	end
	return
end