local LibAddonMenu = LibAddonMenu2

local MARK_OPTIONS_VALUE = {
	LOST_TREASURE_MARK_OPTIONS_USING,
	LOST_TREASURE_MARK_OPTIONS_INVENTORY,
	LOST_TREASURE_MARK_OPTIONS_ALL,
}

local OPTIONS_TEXTURE_PATHS = {
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

local function UpdateMarkOptions(pinType, data)
	for pinTypeShowSetting, _ in ipairs(MARK_OPTIONS_VALUE) do
		if pinTypeShowSetting == data then
			LostTreasure_RefreshAllPinsFromPinType(pinType)
			break
		end
	end
end



LostTreasure_Settings = ZO_Object:Subclass()

local ONLY_MAP_PINS = true

function LostTreasure_Settings:New(...)
	local object = ZO_Object.New(self)
	object:Initialize(...)
	return object
end

function LostTreasure_Settings:Initialize(name, displayName, version, author, website, feedback)
	self.name = name
	self.displayName = displayName
	self.version = version
	self.author = author
	self.website = website
	self.feedback = feedback

	self.settings = { }
	self:AddSettingsMenu()
end


function LostTreasure_Settings:AddSetting(data)
	table.insert(self.settings, data)
end

function LostTreasure_Settings:AddSettingsMenu()

	local savedVars = LostTreasure_GetSavedVarsSettings()
	local defaults = LostTreasure_GetDefaultSettings()

	local panelData = {
		type = "panel",
		name = self.name,
		displayName = self.displayName,
		author = self.author,
		version = tostring(self.version),
		website = self.website,
		feedback = self.feedback,
		registerForRefresh = true,
		registerForDefaults = true,
	}

	self:AddSetting(savedVars:GetLibAddonMenuAccountCheckbox())

	for pinType, settings in ipairs(savedVars.pinTypes) do
		self:AddSetting {
			type = "header",
			name = LOST_TREASURE_PIN_TYPE_DATA[pinType].name,
		}
		self:AddSetting {
			type = "checkbox",
			name = SI_LOST_TREASURE_SHOW_ON_MAP,
			tooltip = SI_LOST_TREASURE_SHOW_ON_MAP_TT,
			getFunc = function()
				return savedVars.pinTypes[pinType].showOnMap
			end,
			setFunc = function(value)
				savedVars.pinTypes[pinType].showOnMap = value
				LostTreasure_SetMapPinState(pinType, value)
			end,
			default = defaults.pinTypes[pinType].showOnMap,
		}
		self:AddSetting {
			type = "checkbox",
			name = SI_LOST_TREASURE_SHOW_ON_COMPASS,
			tooltip = SI_LOST_TREASURE_SHOW_ON_COMPASS_TT,
			getFunc = function()
				return savedVars.pinTypes[pinType].showOnCompass
			end,
			setFunc = function(value)
				savedVars.pinTypes[pinType].showOnCompass = value
				LostTreasure_RefreshCompassPinsFromPinType(pinType)
			end,
			default = defaults.pinTypes[pinType].showOnCompass,
		}
		self:AddSetting {
			type = "iconpicker",
			name = SI_LOST_TREASURE_PIN_ICON,
			tooltip = SI_LOST_TREASURE_PIN_ICON_TT,
			choices = OPTIONS_TEXTURE_PATHS,
			getFunc = function() return savedVars.pinTypes[pinType].texture end,
			setFunc = function(value)
				savedVars.pinTypes[pinType].texture = value
				LostTreasure_SetLayoutKey(pinType, "texture", value)
				LostTreasure_SetCompassPinTypeTexture(pinType, value)
				LostTreasure_RefreshAllPinsFromPinType(pinType)
			end,
			disabled = function() return not savedVars.pinTypes[pinType].showOnMap and not savedVars.pinTypes[pinType].showOnCompass end,
			default = defaults.pinTypes[pinType].texture,
		}
		self:AddSetting {
			type = "slider",
			name = SI_LOST_TREASURE_PIN_SIZE,
			tooltip = SI_LOST_TREASURE_PIN_SIZE_TT,
			min = 12,
			max = 48,
			step = 2,
			decimals = 0,
			clampInput = true,
			readOnly = true,
			getFunc = function() return savedVars.pinTypes[pinType].size end,
			setFunc = function(value)
				savedVars.pinTypes[pinType].size = value
				LostTreasure_SetLayoutKey(pinType, "size", value)
				LostTreasure_RefreshAllPinsFromPinType(pinType)
			end,
			disabled = function() return not savedVars.pinTypes[pinType].showOnMap end,
			default = defaults.pinTypes[pinType].size,
		}
		self:AddSetting {
			type = "dropdown",
			name = SI_LOST_TREASURE_MARK_OPTION,
			tooltip = SI_LOST_TREASURE_MARK_OPTION_TT,
			choices = { GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1), GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2), GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3) },
			choicesValues = MARK_OPTIONS_VALUE,
			choicesTooltips = { GetString(SI_LOST_TREASURE_MARK_OPTION1_TT), GetString(SI_LOST_TREASURE_MARK_OPTION2_TT), GetString(SI_LOST_TREASURE_MARK_OPTION3_TT) },
			getFunc = function() return savedVars.pinTypes[pinType].markOption end,
			setFunc = function(value)
				savedVars.pinTypes[pinType].markOption = value
				if value ~= LOST_TREASURE_MARK_OPTIONS_USING then
					LostTreasure_ClearListMarkOnUse()
				end
				UpdateMarkOptions(pinType, value)
			end,
			disabled = function() return not savedVars.pinTypes[pinType].showOnMap and not savedVars.pinTypes[pinType].showOnCompass end,
			default = defaults.pinTypes[pinType].markOption,
		}
		self:AddSetting {
			type = "slider",
			name = SI_LOST_TREASURE_PIN_LEVEL,
			tooltip = SI_LOST_TREASURE_PIN_LEVEL_TT,
			min = 0,
			max = 250,
			step = 1,
			decimals = 0,
			readOnly = true,
			getFunc = function() return savedVars.pinTypes[pinType].pinLevel end,
			setFunc = function(value)
				savedVars.pinTypes[pinType].pinLevel = value
				LostTreasure_SetLayoutKey(pinType, "level", value)
				LostTreasure_RefreshAllPinsFromPinType(pinType, ONLY_MAP_PINS)
			end,
			disabled = function() return not savedVars.pinTypes[pinType].showOnMap end,
			default = defaults.pinTypes[pinType].pinLevel,
		}
		self:AddSetting {
			type = "slider",
			name = SI_LOST_TREASURE_MARKER_DELAY,
			tooltip = SI_LOST_TREASURE_MARKER_DELAY_TT,
			min = 0,
			max = 60,
			step = 1,
			decimals = 0,
			readOnly = true,
			getFunc = function() return savedVars.pinTypes[pinType].deletionDelay end,
			setFunc = function(value)
				savedVars.pinTypes[pinType].deletionDelay = value
			end,
			disabled = function() return not savedVars.pinTypes[pinType].showOnMap and not savedVars.pinTypes[pinType].showOnCompass end,
			default = defaults.pinTypes[pinType].deletionDelay,
		}
	end

	self:AddSetting {
		type = "header",
		name = SI_LOST_TREASURE_SHOW_MINIMAP_HEADER,
	}
	self:AddSetting {
		type = "checkbox",
		name = SI_LOST_TREASURE_SHOW_MINIMAP,
		tooltip = SI_LOST_TREASURE_SHOW_MINIMAP_TT,
		getFunc = function() return savedVars.miniMap.enabled end,
		setFunc = function(value) savedVars.miniMap.enabled = value end,
		default = defaults.miniMap.enabled,
	}
	self:AddSetting {
		type = "dropdown",
		name = SI_LOST_TREASURE_SHOW_MINIMAP_SIZE,
		choices = { GetString(SI_GUILDSIZEATTRIBUTEVALUE1), GetString(SI_GUILDSIZEATTRIBUTEVALUE2), GetString(SI_GUILDSIZEATTRIBUTEVALUE3), GetString(SI_GUILDSIZEATTRIBUTEVALUE4) },
		choicesValues = { 200, 300, 400, 500 },
		getFunc = function() return savedVars.miniMap.size end,
		setFunc = function(value)
			savedVars.miniMap.size = value
			LostTreasure_SetMiniMapAnchor()
		end,
		disabled = function() return not savedVars.miniMap.enabled end,
		default = defaults.miniMap.size,
	}
	self:AddSetting {
		type = "slider",
		name = SI_LOST_TREASURE_SHOW_MINIMAP_DELAY,
		tooltip = SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT,
		min = 0,
		max = 60,
		step = 1,
		decimals = 0,
		readOnly = true,
		getFunc = function() return savedVars.miniMap.deletionDelay end,
		setFunc = function(value)
			savedVars.miniMap.deletionDelay = value
		end,
		default = defaults.miniMap.deletionDelay,
	}

	local globalPanelName = self.name .. "LAMSettings"
	LibAddonMenu:RegisterAddonPanel(globalPanelName, panelData)
	LibAddonMenu:RegisterOptionControls(globalPanelName, self.settings)
end