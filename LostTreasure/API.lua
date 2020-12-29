local LostTreasure = LostTreasure

-- API
------
function LostTreasure_GetAllData()
	return LostTreasure:GetAllData()
end

function LostTreasure_GetItemIdsByPinType(pinType)
	return LostTreasure:GetItemIdsByPinType(pinType)
end

function LostTreasure_GetZoneData(mapId)
	return LostTreasure:GetZoneData(mapId or GetCurrentMapId())
end

function LostTreasure_GetItemLinkFromItemId(itemId)
	return LostTreasure:GetItemLinkFromItemId(itemId)
end

function LostTreasure_AddIcon(path)
	table.insert(LostTreasure.OPTIONS_TEXTURE_PATHS, path)
end