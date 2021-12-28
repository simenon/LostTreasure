local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("savedVars")

local savedVars = { }
internal.savedVars = savedVars

local BLANK_SAVED_VARS = LOST_TREASURE_BLANK_SAVED_VARS

local function HasUpdatedPath(path)
	local pathLower = path:lower()
	return path:find("EsoUI") ~= nil or path:find("LibTreasure") ~= nil
end

local function GetTexturePath(index)
	local textures = LibTreasure_GetIcons()
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

	-- update icons
	for pinType, settings in pairs(self.db.pinTypes) do
		local texture = self:GetNewTexturePath(settings.texture, pinType)
		self.db.pinTypes[pinType].texture = texture
	end

	-- debug
	logger:Debug("initialized")
end

function savedVars:GetSavedVars()
	return self.db
end

function savedVars:GetDefaults()
	return self.DEFAULTS
end

function savedVars:GetNewTexturePath(path, pinType)
	if path then -- check if path is existing in our savedVars
		if HasUpdatedPath(path) then -- check if the path refers to LibTreasure already
			logger:Debug("Use existing iconPath, path: %s", path)
			return path
		else -- if the path still refers to LostTreasure, update to the new path
			logger:Debug("Saved path does not exist. Try to catch the new one.")
			local textures = LibTreasure_GetIcons()
			local utilities = internal.utilities
			local fileName = utilities:GetFileNameFromPath(path)
			for i, value in ipairs(textures) do
				if utilities:DoesPathContainsFileName(value, fileName) then
					local iconPath = textures[i]
					logger:Debug("Use new iconPath, path: %s", iconPath)
					-- save the icon into savedVars
					local db = self:GetSavedVars()
					db.pinTypes[pinType].texture = iconPath
					return iconPath
				end
			end
		end
	end
	-- return default value
	local defaults = self:GetDefaults()
	local iconPath = defaults.pinTypes[pinType].texture
	logger:Debug("Use default iconPath, path: %s", iconPath)
	return iconPath
end
