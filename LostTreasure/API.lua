local LostTreasure = LOST_TREASURE

----------------------------------------------
-- Please feel free to ask for more functions,
-- if it helps to improve your addon/plugin.
----------------------------------------------

-- Get the data from all saved maps
-- @return *table:nilable* allData
function LostTreasure_GetAllData()
	return LostTreasure:GetAllData()
end

-- Get the data from a specific mapId
-- @param *number* mapId
-- @return *table:nilable* mapIdData
function LostTreasure_GetMapIdData(mapId)
	return LostTreasure:GetMapIdData(mapId)
end

-- Get all itemIds from a pinType
-- @param *number* pinType (LOST_TREASURE_PIN_TYPE_TREASURE, LOST_TREASURE_PIN_TYPE_SURVEYS)
-- @return *table:nilable* pinTypeItemIds
function LostTreasure_GetPinTypeItemIds(pinType)
	return LostTreasure:GetPinTypeItemIds(pinType)
end

-- Get the player position data
-- @return *number* x, *number* y, *string* zone, *string* subZone
function LostTreasure_GetPlayerPositionInfo()
	return LostTreasure:GetPlayerPositionInfo()
end

-- Get an itemLink string from a item number
-- @param *number* itemId
-- @return *string* itemLink
function LostTreasure_GetItemLinkFromItemId(itemId)
	return LostTreasure:GetItemLinkFromItemId(itemId)
end

-- Add more icons to the icon picker setting windows
-- @param *string* path
function LostTreasure_AddIcon(path)
	table.insert(LostTreasure.OPTIONS_TEXTURE_PATHS, path)
end