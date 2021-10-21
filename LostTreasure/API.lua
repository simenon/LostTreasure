local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local utilities = internal.utilities
local data = internal.data

----------------------------------------------
-- Please feel free to ask for more functions,
-- if it helps to improve your addon/plugin.
----------------------------------------------

-- Get the data from all saved items data
-- @return *table* itemsData
function LostTreasure_GetAllItemsData()
	return data.ITEMS_DATA
end

-- Get the data of an item in the database
-- @param *number* itemId
-- @return *table:nilable* itemData
function LostTreasure_GetItemIdData(itemId)
	return data.ITEMS_DATA[itemId]
end

-- Get the data from a specific mapId
-- @param *number* mapId
-- @return *table:nilable* mapIdData
function LostTreasure_GetMapIdData(mapId)
	return data.MAP_ID_DATA[mapId]
end

-- Get the player position data
-- @return *number* x, *number* y, *string* zone, *string* subZone
function LostTreasure_GetPlayerPositionInfo()
	return utilities:GetPlayerPositionInfo()
end

-- Get an itemLink string from a item number
-- @param *number* itemId
-- @return *string* itemLink
function LostTreasure_GetItemLinkFromItemId(itemId)
	return utilities:GetItemLinkFromItemId(itemId)
end

-- Add more icons to the icon picker setting windows
-- @param *string* path
function LostTreasure_AddIcon(path)
	table.insert(utilities.OPTIONS_TEXTURE_PATHS, path)
end


-- to make sure the AddOn is finally initialized including the API, we will set a flag:
LostTreasure.isInitialized = true
