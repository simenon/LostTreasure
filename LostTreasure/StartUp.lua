-- Constants
LOST_TREASURE_DATA_INDEX_X = 1
LOST_TREASURE_DATA_INDEX_Y = 2
LOST_TREASURE_DATA_INDEX_TEXTURE = 3
LOST_TREASURE_DATA_INDEX_ITEMID = 4

LOST_TREASURE_MARK_OPTIONS_USING = 1
LOST_TREASURE_MARK_OPTIONS_INVENTORY = 2
LOST_TREASURE_MARK_OPTIONS_ALL = 3

LOST_TREASURE_PIN_KEY_MAP = 1
LOST_TREASURE_PIN_KEY_COMPASS = 2

LOST_TREASURE_PIN_TYPE_TREASURE = 1
LOST_TREASURE_PIN_TYPE_SURVEYS = 2

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


-- Lost Treasure
LostTreasure = ZO_InitializingObject:Subclass()

LostTreasure.addOnName = "LostTreasure"
LostTreasure.addOnDisplayName = "Lost Treasure"

LostTreasure.website = "http://www.esoui.com/downloads/info561-LostTreasure.html"
LostTreasure.feedback = "https://www.esoui.com/portal.php?id=121&a=bugreport&addonid=561"

LostTreasure.DEFAULTS =
{
	pinTypes =
	{
		[LOST_TREASURE_PIN_TYPE_TREASURE] =
		{
			showOnMap = true,
			showOnCompass = true,
			texture = "LostTreasure/Icons/x_red.dds",
			size = 32,
			markOption = LOST_TREASURE_MARK_OPTIONS_INVENTORY,
			pinLevel = 45,
			deletionDelay = 10,
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] =
		{
			showOnMap = true,
			showOnCompass = true,
			texture = "LostTreasure/Icons/x_red.dds",
			size = 32,
			markOption = LOST_TREASURE_MARK_OPTIONS_INVENTORY,
			pinLevel = 45,
			deletionDelay = 10,
		},
	},
	miniMap =
	{
		enabled = true,
		anchor = ZO_Anchor:New(TOPLEFT, nil, TOPLEFT, 100, 100),
		size = 400,
		deletionDelay = 4,
	},
	notifications = { },
	mining =
	{
		APIVersion = 0,
		APITimeStamp = 0,
		AddOnVersion = nil,
		data = { },
	},
}

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

LostTreasure.logger = LibDebugLogger(LostTreasure.addOnName)