local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("savedVars")

local savedVars = { }
internal.savedVars = savedVars

local BLANK_SAVED_VARS = LOST_TREASURE_BLANK_SAVED_VARS

local function GetTexturePath(index)
	local utilities = internal.utilities
	local textures = utilities.OPTIONS_TEXTURE_PATHS
	local numTextures = #textures
	if index == nil or index < 1 or index > numTextures then
		index = 1
	end
	local texture = textures[index]
	logger:Debug("numTextures: %d, index: %d, texture: \"%s\"", numTextures, index, texture)
	return texture
end


savedVars.DEFAULTS =
{
	pinTypes =
	{
		[LOST_TREASURE_PIN_TYPE_TREASURE] =
		{
			showOnMap = true,
			showOnCompass = true,
			texture = GetTexturePath(),
			size = 32,
			markOption = LOST_TREASURE_MARK_OPTIONS_INVENTORY,
			pinLevel = 45,
			deletionDelay = 10,
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] =
		{
			showOnMap = true,
			showOnCompass = true,
			texture = GetTexturePath(5),
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
		APIVersion = BLANK_SAVED_VARS,
		APITimeStamp = BLANK_SAVED_VARS,
		data = { },
	},
}

function savedVars:Initialize()
	self.db = LibSavedVars
		:NewAccountWide("LostTreasure_Account", self.DEFAULTS)
		:AddCharacterSettingsToggle("LostTreasure_Character")
		:Version(20, function(savedVarsTable)
			ZO_ClearTable(savedVarsTable)
		end)
		-- :RemoveSettings(10, "*")

	logger:Debug("initialized")
end

function savedVars:GetSavedVars()
	return self.db
end

function savedVars:GetDefaults()
	return self.DEFAULTS
end