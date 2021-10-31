local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("utilities")

local utilities = { }
internal.utilities = utilities


local TRACKED_SPECIALIZED_ITEM_TYPES = ZO_CreateSetFromArguments(SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP, SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT)
local ZO_ONE_SECOND_IN_MILLISECONDS = ZO_ONE_SECOND_IN_MILLISECONDS

local zo_strlower, zo_strfind, zo_strmatch = zo_strlower, zo_strfind, zo_strmatch
local sformat = string.format
local task = LostTreasure.task

local GetMapPlayerPosition, GetCurrentMapId = GetMapPlayerPosition, GetCurrentMapId
local ShouldMapShowQuestsInList = ZO_WorldMapQuestsData_Singleton.ShouldMapShowQuestsInList


utilities.OPTIONS_TEXTURE_PATHS = {
	"LostTreasure/Icons/x_red.dds",
	"LostTreasure/Icons/x_black.dds",
	"LostTreasure/Icons/map_black.dds",
	"LostTreasure/Icons/map_white.dds",
	"LostTreasure/Icons/hammerstrike.dds",
	"EsoUI/Art/Icons/justice_stolen_map_001.dds",
	"EsoUI/Art/Icons/quest_scroll_001.dds",
	"EsoUI/Art/Icons/scroll_001.dds",
	"EsoUI/Art/Icons/justice_stolen_unique_dwemer_puzzle_cube.dds",
	"EsoUI/Art/Icons/delivery_box_001.dds",
	"EsoUI/Art/Icons/justice_stolen_unique_jurgen_windcaller_plait.dds",
	"EsoUI/Art/Icons/justice_stolen_unique_shehai_essence_box.dds",
	"EsoUI/Art/Icons/crafting_accessory_sp_names_002.dds",
	"EsoUI/Art/Icons/crafting_accessory_sp_names_001.dds",
	"EsoUI/Art/Icons/collectable_memento_dawnshard.dds",
}

function utilities:IsTreasureOrSurveyItemType(specializedItemType)
	return TRACKED_SPECIALIZED_ITEM_TYPES[specializedItemType] == true
end

function utilities:SecondsToMilliseconds(second)
	return second * ZO_ONE_SECOND_IN_MILLISECONDS
end

function utilities:GetItemLinkFromItemId(itemId)
	return sformat("|H0:item:%s:4:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", itemId)
end

function utilities:GetTreasureMapTexturePathName(texturePath)
	return zo_strmatch(texturePath, ".+/(.+)%.dds")
end

function utilities:RunCallbackAsync(callback, delay)
	task:Delay(delay, callback)
end

-- Tooltips
function utilities:AddTooltip(text, itemName, itemQualityColor, itemStackCount, iconPath)
	if IsInGamepadPreferredMode() then
		local InformationTooltip = ZO_MapLocationTooltip_Gamepad
		local baseSection = InformationTooltip.tooltip
		local fontLayout =
		{
			widthPercent = 100,
			fontFace = "$(GAMEPAD_BOLD_FONT)",
			fontSize = "$(GP_34)",
			uppercase = true,
			fontColor = itemQualityColor
		}
		InformationTooltip:LayoutIconStringLine(baseSection, nil, itemName, fontLayout)

		local iconLayout =
		{
			fontSize = 27,
			fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_3
		}
		InformationTooltip:LayoutIconStringLine(baseSection, iconPath, text, iconLayout)
		if itemStackCount > 1 then
			InformationTooltip:LayoutStringLine(baseSection, sformat("%s: %d", GetString(SI_CRAFTING_QUANTITY_HEADER), itemStackCount))
		end
	else
		InformationTooltip:AddLine(itemName, "", itemQualityColor:UnpackRGB())
		-- don't use zo_iconTextFormat, because it will turns points into commas
		InformationTooltip:AddLine(sformat("%s %s", zo_iconFormat(iconPath, 32, 32), text), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		if itemStackCount > 1 then
			InformationTooltip:AddLine(sformat("%s: %d", GetString(SI_CRAFTING_QUANTITY_HEADER), itemStackCount), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		end
	end
end

-- Map / Pins
local NO_PIN_TYPE = "nil"
local GetZoneAndSubzone = LibMapPins.GetZoneAndSubzone
local itemNameCache = { }

local function LoggerMessage(itemName)
	logger:Error("no pinType has been found for itemName: %s", itemName)
end

function utilities:GetPlayerPositionInfo()
	local x, y = GetMapPlayerPosition("player")
	local zone, subZone = GetZoneAndSubzone()
	return x, y, zone, subZone, GetCurrentMapId()
end

function utilities:IsValidMapType()
	return ShouldMapShowQuestsInList()
end

function utilities:RequestRefreshMap()
	if SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
end

function utilities:GetPinTypeFromString(itemName)
	itemName = zo_strlower(itemName)

	-- Check if we have the itemName cached
	local itemNameCached = itemNameCache[itemName]
	if itemNameCached then
		if itemNameCached == NO_PIN_TYPE then
			LoggerMessage(itemName)
			return
		end
		return itemNameCached
	end

	-- Let's check if the itemName is a Treasure Map or a Crafting Survey
	for pinType, pinData in pairs(LOST_TREASURE_PIN_TYPE_DATA) do
		if zo_strfind(itemName, pinData.compareString) then
			itemNameCached = pinType
			itemNameCache[itemName] = itemNameCached
			logger:Verbose("new item has been added to itemNameCache: %s", itemName)
			return itemNameCached
		end
	end

	-- If we didn't find any matching pinType, let's store the value as "nil" (NO_PIN_TYPE)
	itemNameCache[itemName] = NO_PIN_TYPE
	LoggerMessage(itemName)
	return
end
