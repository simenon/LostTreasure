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