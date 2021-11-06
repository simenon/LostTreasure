local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local utilities = internal.utilities
local data = internal.data

----------------------------------------------
-- Please feel free to ask for more functions,
-- if it helps to improve your addon/plugin.
----------------------------------------------

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


-- to make sure the AddOn is finally initialized including the API, we will set a flag:
LostTreasure.isInitialized = true
