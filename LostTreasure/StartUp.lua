local LostTreasure = ZO_InitializingObject:Subclass()

LOST_TREASURE_BLANK_SAVED_VARS = 0

LOST_TREASURE_MARK_OPTIONS_USING = "using"
LOST_TREASURE_MARK_OPTIONS_INVENTORY = "inventory"
LOST_TREASURE_MARK_OPTIONS_ALL = "all"

LOST_TREASURE_PIN_KEY_MAP = "worldmap"
LOST_TREASURE_PIN_KEY_COMPASS = "compass"

LOST_TREASURE_PIN_TYPE_TREASURE = "treasure"
LOST_TREASURE_PIN_TYPE_SURVEYS = "survey"

LOST_TREASURE_MAP_NOT_OPENED = GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_NO_MAP)
LOST_TREASURE_BOOK_NOT_OPENED = 0

LOST_TREASURE_NO_PIN_TYPE = "nil"

LOST_TREASURE_PIN_TYPE_DATA =
{
	[LOST_TREASURE_PIN_TYPE_TREASURE] =
	{
		pinName = "LostTreasure_TreasureMapPin",
		specializedItemType = SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP,
		compareString = zo_strlower(GetString(SI_LOST_TREASURE_COMPARE_TREASURE)),
		name = GetString(SI_LOST_TREASURE_TREASURE_MAPS),
		interactionType = INTERACTION_NONE,
	},
	[LOST_TREASURE_PIN_TYPE_SURVEYS] =
	{
		pinName = "LostTreasure_SurveyReportPin",
		specializedItemType = SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT,
		compareString = zo_strlower(GetString(SI_LOST_TREASURE_COMPARE_SURVEY)),
		name = GetString(SI_LOST_TREASURE_SURVEY_REPORTS),
		interactionType = INTERACTION_HARVEST,
	},
}

LostTreasure.addOnName = "LostTreasure"
LostTreasure.addOnDisplayName = "Lost Treasure"
LostTreasure.APIVersion = GetAPIVersion()
LostTreasure.internal = { }

local function GetAddOnInfos()
	local addOnManager = GetAddOnManager()
	local name, author
	for i = 1, addOnManager:GetNumAddOns() do
		name, _, author = addOnManager:GetAddOnInfo(i)
		if name == LostTreasure.addOnName then
			return author, addOnManager:GetAddOnVersion(i)
		end
	end
end
LostTreasure.author, LostTreasure.version = GetAddOnInfos()

-- The flag will only be changed after API.lua is loaded
LostTreasure.isInitialized = false

-- GLOBAL
LOST_TREASURE = LostTreasure