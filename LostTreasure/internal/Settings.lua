local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("settings")

local settings = { }
internal.settings = settings


local debug = internal.debug

local ADDON_NAME = LostTreasure.addOnName
local ADDON_WEBSITE = "http://www.esoui.com/downloads/info561-LostTreasure.html"

local MARK_OPTIONS =
{
	-- make sure all key have the same value count
	labels =
	{
		GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1),
		GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2),
		GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3),
	},
	values = {
		LOST_TREASURE_MARK_OPTIONS_USING,
		LOST_TREASURE_MARK_OPTIONS_INVENTORY,
		LOST_TREASURE_MARK_OPTIONS_ALL,
	},
	tooltips =
	{
		GetString(SI_LOST_TREASURE_MARK_OPTION1_TT),
		GetString(SI_LOST_TREASURE_MARK_OPTION2_TT),
		GetString(SI_LOST_TREASURE_MARK_OPTION3_TT),
	},
}

local MINIMAP_SIZES =
{
	-- make sure all key have the same value count
	labels =
	{
		GetString(SI_GUILDSIZEATTRIBUTEVALUE1),
		GetString(SI_GUILDSIZEATTRIBUTEVALUE2),
		GetString(SI_GUILDSIZEATTRIBUTEVALUE3),
		GetString(SI_GUILDSIZEATTRIBUTEVALUE4),
	},
	values =
	{
		200,
		300,
		400,
		500,
	},
}

function settings:Initialize()
	local savedVars = internal.savedVars
	local db = savedVars:GetSavedVars()
	local defaults = savedVars:GetDefaults()

	local pins = internal.pins
	local markOnUsing = internal.markOnUsing

	local icons = LibTreasure_GetIcons()

	local panelData = {
		type = "panel",
		name = ADDON_NAME,
		displayName = LostTreasure.addOnDisplayName,
		author = LostTreasure.author,
		version = tostring(LostTreasure.version),
		website = ADDON_WEBSITE,
		registerForRefresh = true,
		registerForDefaults = true,
	}

	local menu = { }

	local function AddSetting(data)
		table.insert(menu, data)
	end

	AddSetting(db:GetLibAddonMenuAccountCheckbox())

	AddSetting {
		type = "checkbox",
		name = SI_LOST_TREASURE_DEBUG,
		tooltip = SI_LOST_TREASURE_DEBUG_TT,
		getFunc = function()
			return debug:GetState()
		end,
		setFunc = function(value)
			if value then
				debug:Enable()
			else
				debug:Disable()
			end
		end,
		default = false,
	}

	for pinType, settings in pairs(db.pinTypes) do
		AddSetting {
			type = "header",
			name = LOST_TREASURE_PIN_TYPE_DATA[pinType].name,
		}
		AddSetting {
			type = "checkbox",
			name = SI_LOST_TREASURE_SHOW_ON_MAP,
			tooltip = SI_LOST_TREASURE_SHOW_ON_MAP_TT,
			getFunc = function()
				return db.pinTypes[pinType].showOnMap
			end,
			setFunc = function(value)
				db.pinTypes[pinType].showOnMap = value
				pins:SetMapPinState(pinType, value)
			end,
			default = defaults.pinTypes[pinType].showOnMap,
		}
		AddSetting {
			type = "checkbox",
			name = SI_LOST_TREASURE_SHOW_ON_COMPASS,
			tooltip = SI_LOST_TREASURE_SHOW_ON_COMPASS_TT,
			getFunc = function()
				return db.pinTypes[pinType].showOnCompass
			end,
			setFunc = function(value)
				db.pinTypes[pinType].showOnCompass = value
				pins:RefreshCompassPinsFromPinType(pinType)
			end,
			default = defaults.pinTypes[pinType].showOnCompass,
		}
		AddSetting {
			type = "iconpicker",
			name = SI_LOST_TREASURE_PIN_ICON,
			tooltip = SI_LOST_TREASURE_PIN_ICON_TT,
			choices = icons,
			getFunc = function() return db.pinTypes[pinType].texture end,
			setFunc = function(value)
				db.pinTypes[pinType].texture = value
				pins:SetLayoutKey(pinType, "texture", value)
				pins:SetCompassPinTypeTexture(pinType, value)
				pins:RefreshAllPinsFromPinType(pinType)
			end,
			disabled = function() return not db.pinTypes[pinType].showOnMap and not db.pinTypes[pinType].showOnCompass end,
			default = defaults.pinTypes[pinType].texture,
		}
		AddSetting {
			type = "slider",
			name = SI_LOST_TREASURE_PIN_SIZE,
			tooltip = SI_LOST_TREASURE_PIN_SIZE_TT,
			min = 12,
			max = 48,
			step = 2,
			decimals = 0,
			clampInput = true,
			readOnly = true,
			getFunc = function() return db.pinTypes[pinType].size end,
			setFunc = function(value)
				db.pinTypes[pinType].size = value
				pins:SetLayoutKey(pinType, "size", value)
				pins:RefreshAllPinsFromPinType(pinType)
			end,
			disabled = function() return not db.pinTypes[pinType].showOnMap end,
			default = defaults.pinTypes[pinType].size,
		}
		AddSetting {
			type = "dropdown",
			name = SI_LOST_TREASURE_MARK_OPTION,
			tooltip = SI_LOST_TREASURE_MARK_OPTION_TT,
			choices = MARK_OPTIONS.labels,
			choicesValues = MARK_OPTIONS.values,
			choicesTooltips = MARK_OPTIONS.tooltips,
			getFunc = function() return db.pinTypes[pinType].markOption end,
			setFunc = function(value)
				db.pinTypes[pinType].markOption = value
				markOnUsing:Clear()
				pins:RefreshAllPinsFromPinType(pinType)
			end,
			disabled = function() return not db.pinTypes[pinType].showOnMap and not db.pinTypes[pinType].showOnCompass end,
			default = defaults.pinTypes[pinType].markOption,
		}
		AddSetting {
			type = "slider",
			name = SI_LOST_TREASURE_PIN_LEVEL,
			tooltip = SI_LOST_TREASURE_PIN_LEVEL_TT,
			min = 0,
			max = 250,
			step = 1,
			decimals = 0,
			readOnly = true,
			getFunc = function() return db.pinTypes[pinType].pinLevel end,
			setFunc = function(value)
				db.pinTypes[pinType].pinLevel = value
				pins:SetLayoutKey(pinType, "level", value)
				pins:RefreshAllPinsFromPinType(pinType)
			end,
			disabled = function() return not db.pinTypes[pinType].showOnMap end,
			default = defaults.pinTypes[pinType].pinLevel,
		}
		AddSetting {
			type = "slider",
			name = SI_LOST_TREASURE_MARKER_DELAY,
			tooltip = SI_LOST_TREASURE_MARKER_DELAY_TT,
			min = 0,
			max = 60,
			step = 1,
			decimals = 0,
			readOnly = true,
			getFunc = function() return db.pinTypes[pinType].deletionDelay end,
			setFunc = function(value)
				db.pinTypes[pinType].deletionDelay = value
			end,
			disabled = function() return not db.pinTypes[pinType].showOnMap and not db.pinTypes[pinType].showOnCompass end,
			default = defaults.pinTypes[pinType].deletionDelay,
		}
	end

	AddSetting {
		type = "header",
		name = SI_LOST_TREASURE_SHOW_MINIMAP_HEADER,
	}
	AddSetting {
		type = "checkbox",
		name = SI_LOST_TREASURE_SHOW_MINIMAP,
		tooltip = SI_LOST_TREASURE_SHOW_MINIMAP_TT,
		getFunc = function() return db.miniMap.enabled end,
		setFunc = function(value) db.miniMap.enabled = value end,
		default = defaults.miniMap.enabled,
	}
	AddSetting {
		type = "dropdown",
		name = SI_LOST_TREASURE_SHOW_MINIMAP_SIZE,
		choices = MINIMAP_SIZES.labels,
		choicesValues = MINIMAP_SIZES.values,
		getFunc = function() return db.miniMap.size end,
		setFunc = function(value)
			db.miniMap.size = value
			LostTreasure_SetMiniMapAnchor()
		end,
		disabled = function() return not db.miniMap.enabled end,
		default = defaults.miniMap.size,
	}
	AddSetting {
		type = "slider",
		name = SI_LOST_TREASURE_SHOW_MINIMAP_DELAY,
		tooltip = SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT,
		min = 0,
		max = 60,
		step = 1,
		decimals = 0,
		readOnly = true,
		getFunc = function() return db.miniMap.deletionDelay end,
		setFunc = function(value)
			db.miniMap.deletionDelay = value
		end,
		default = defaults.miniMap.deletionDelay,
	}

	local globalPanelName = ADDON_NAME .. "LAMSettings"
	local LibAddonMenu = LibAddonMenu2
	LibAddonMenu:RegisterAddonPanel(globalPanelName, panelData)
	LibAddonMenu:RegisterOptionControls(globalPanelName, menu)

	logger:Debug("initialized")
end

function settings:GetSettingsFromPinType(pinType, key)
	local savedVars = internal.savedVars
	local db = savedVars:GetSavedVars()
	return db.pinTypes[pinType][key]
end

function settings:GetSettingDeletionDelay(pinType)
	local savedVars = internal.savedVars
	local db = savedVars:GetSavedVars()
	local deletionDelay

	local isMinimap = pinType == nil
	if isMinimap then
		deletionDelay = db.miniMap.deletionDelay
	else
		deletionDelay = db.pinTypes[pinType].deletionDelay
	end

	logger:Debug("Deletion delay pinType: %s, deletionDelay: %d", isMinimap and "minimap" or pinType, deletionDelay)
	return deletionDelay
end
