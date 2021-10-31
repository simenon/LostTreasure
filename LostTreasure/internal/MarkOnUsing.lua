local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("markOnUsing")

local markOnUsing =
{
	list =
	{
		[LOST_TREASURE_PIN_TYPE_TREASURE] = { },
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = { },
	}
}
internal.markOnUsing = markOnUsing


local function ClearList(list)
	for key, value in pairs(list) do
		if type(value) == "table" then
			ClearList(value)
		else
			list[key] = nil
		end
	end
end

function markOnUsing:Remove(pinType, itemId)
	local value = self.list[pinType][itemId]
	self.list[pinType][itemId] = nil
	if value then
		logger:Debug("%d has been removed from %s", itemId, pinType)
	else
		logger:Debug("%d has not been found in %s", itemId, pinType)
	end
end

function markOnUsing:DoesExist(pinType, itemId)
	return self.list[pinType][itemId] == true
end

function markOnUsing:Add(pinType, itemId)
	self.list[pinType][itemId] = true
	logger:Debug("%d has been added to %s", itemId, pinType)
end

function markOnUsing:Clear()
	ClearList(self.list)
	logger:Debug("list has been cleared")
end