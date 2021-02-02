local LostTreasure = LostTreasure

local LibMapPins = LibMapPins
local COMPASS_PINS = COMPASS_PINS

local ShouldMapShowQuestsInList = ZO_WorldMapQuestsData_Singleton.ShouldMapShowQuestsInList

local function IsValidMapType()
	return ShouldMapShowQuestsInList()
end

local function RefreshMapPins(pinName)
	LibMapPins:RefreshPins(pinName)
end

local function RefreshCompassPins(pinName)
	COMPASS_PINS:RefreshPins(pinName)
end

-- globals
function LostTreasure:GetPinNameFromPinType(pinType)
	return LOST_TREASURE_PIN_TYPE_DATA[pinType].pinName
end

function LostTreasure:GetPlayerPositionInfo()
	local x, y = GetMapPlayerPosition("player")
	local zone, subZone = LibMapPins:GetZoneAndSubzone()
	return x, y, zone, subZone, GetCurrentMapId()
end

function LostTreasure:IsMapPinEnabled(pinName)
	return LibMapPins:IsEnabled(pinName)
end

function LostTreasure:SetLayoutKey(pinType, key, data)
	local pinName = self:GetPinNameFromPinType(pinType)
	LibMapPins:SetLayoutKey(pinName, key, data)
end

function LostTreasure:SetMapPinState(pinType, state)
	local pinName = self:GetPinNameFromPinType(pinType)
	LibMapPins:SetEnabled(pinName, state)
end

function LostTreasure:CreateMapPin(pinName, pinData, x, y)
	LibMapPins:CreatePin(pinName, pinData, x, y)
end

function LostTreasure:CreateCompassPin(pinName, pinData, x, y, itemName)
	COMPASS_PINS.pinManager:CreatePin(pinName, pinData, x, y, itemName)
end

function LostTreasure:RefreshAllPinsFromPinType(pinTypeOrPinName, dontUpdateCompass)
	if type(pinTypeOrPinName) == "number" then
		pinTypeOrPinName = self:GetPinNameFromPinType(pinTypeOrPinName)
	end

	RefreshMapPins(pinTypeOrPinName)
	if not dontUpdateCompass then
		RefreshCompassPins(pinTypeOrPinName)
	end
end

function LostTreasure:RefreshCompassPinsFromPinType(pinType)
	local pinName = self:GetPinNameFromPinType(pinType)
	RefreshCompassPins(pinName)
end

function LostTreasure:SetCompassPinTypeTexture(pinType, texturePath)
	local pinName = self:GetPinNameFromPinType(pinType)
	COMPASS_PINS.pinLayouts[pinName].texture = texturePath
end

function LostTreasure:AddNewPins(pinName, pinType, mapCallback, mapLayout, pinTooltip, mapFilter, compassCallback, compassLayout, settings, settingsKey)
	LibMapPins:AddPinType(pinName, mapCallback, nil, mapLayout, pinTooltip)
	LibMapPins:AddPinFilter(pinName, mapFilter, nil, settings, settingsKey)

	COMPASS_PINS:AddCustomPin(pinName, compassCallback, compassLayout)

	-- call the refresh a bit later, otherwise they wouldn't appear after EVENT_PLAYER_ACTIVATED
	self:RunCallbackAsync(function() RefreshCompassPins(pinName) end, 100)
end

function LostTreasure:CreateNewPin(pinType, pinData, key)
	local pinName = self:GetPinNameFromPinType(pinType)
	if key == LOST_TREASURE_PIN_KEY_MAP then
		self:CreateMapPin(pinName, pinData, pinData[LOST_TREASURE_DATA_INDEX_X], pinData[LOST_TREASURE_DATA_INDEX_Y])
	elseif key == LOST_TREASURE_PIN_KEY_COMPASS then
		local itemLink = LOST_TREASURE:GetItemLinkFromItemId(pinData[LOST_TREASURE_DATA_INDEX_ITEMID])
		local itemName = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))
		self:CreateCompassPin(pinName, pinData, pinData[LOST_TREASURE_DATA_INDEX_X], pinData[LOST_TREASURE_DATA_INDEX_Y], itemName)
	end
end

function LostTreasure:AddTooltip(text, itemName, color, itemStackCount, iconPath)
	if IsInGamepadPreferredMode() then
		local InformationTooltip = ZO_MapLocationTooltip_Gamepad
		local baseSection = InformationTooltip.tooltip
		InformationTooltip:LayoutIconStringLine(baseSection, nil, itemName, { widthPercent = 100, fontFace = "$(GAMEPAD_BOLD_FONT)", fontSize = "$(GP_34)", uppercase = true, fontColor = color })
		InformationTooltip:LayoutIconStringLine(baseSection, iconPath, text, { fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_3 })
		if itemStackCount > 1 then
			InformationTooltip:LayoutStringLine(baseSection, string.format("%s: %d", GetString(SI_CRAFTING_QUANTITY_HEADER), itemStackCount))
		end
	else
		InformationTooltip:AddLine(itemName, "", color:UnpackRGB())
		-- don't use zo_iconTextFormat, because it will turns points into commas
		InformationTooltip:AddLine(string.format("%s %s", zo_iconFormat(iconPath, 32, 32), text), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		if itemStackCount > 1 then
			InformationTooltip:AddLine(string.format("%s: %d", GetString(SI_CRAFTING_QUANTITY_HEADER), itemStackCount), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		end
	end
end

function LostTreasure:InitializePins()
	-- handle pin names in compass frame
	local TIME_BETWEEN_LABEL_UPDATES_MS = 250
	local nextLabelUpdateTime = 0

	local function IsAboveUpdateThreshold()
		return GetFrameTimeMilliseconds() > nextLabelUpdateTime + TIME_BETWEEN_LABEL_UPDATES_MS
	end

	ZO_PreHook(COMPASS, "OnUpdate", function()
		if IsAboveUpdateThreshold() then
			return false -- use orig callback when we haven't got an update from LibMapPins lately
		else
			return true
		end
	end)

	local overPinLabel = COMPASS.centerOverPinLabel
	local overPinAnimation = COMPASS.centerOverPinLabelAnimation
	local overrideAnimation = COMPASS.areaOverrideAnimation

	local function UpdatePinName(pin, _, normalizedAngle, normalizedDistance)
		local now = GetFrameTimeMilliseconds()
		if now < nextLabelUpdateTime then
			return
		end

		if pin.pinName then
			if zo_abs(normalizedAngle) < 0.1 and zo_abs(normalizedDistance) < 0.95 then
				if overrideAnimation:IsPlaying() then
					overPinAnimation:PlayBackward()
				elseif not overPinAnimation:IsPlaying() or not overPinAnimation:IsPlayingBackward() then
					overPinLabel:SetText(pin.pinName)
					overPinAnimation:PlayForward()
				end
				nextLabelUpdateTime = now + TIME_BETWEEN_LABEL_UPDATES_MS
			end
		end
	end

	-- create new pins
	local function PinTypeAddCallback(pinType, pinName)
		if IsValidMapType() and LostTreasure:IsMapPinEnabled(pinName) then
			self:CheckZoneData(pinType, LOST_TREASURE_PIN_KEY_MAP)
			self:CheckMinedData(pinType, LOST_TREASURE_PIN_KEY_MAP)
		end
	end

	local function PinCallback(pinType)
		if IsValidMapType() and self:GetPinTypeSettings(pinType, "showOnCompass") then
			self:CheckZoneData(pinType, LOST_TREASURE_PIN_KEY_COMPASS)
			self:CheckMinedData(pinType, LOST_TREASURE_PIN_KEY_COMPASS)
		end
	end

	local pinTooltipCreator =
	{
		creator = function(pin)
			local pinTag = select(2, pin:GetPinTypeAndTag())
			local x, y = pinTag[LOST_TREASURE_DATA_INDEX_X], pinTag[LOST_TREASURE_DATA_INDEX_Y]
			local text = string.format("%.2f x %.2f", x * 100, y * 100)

			local itemId = pinTag[LOST_TREASURE_DATA_INDEX_ITEMID]
			local itemLink = LOST_TREASURE:GetItemLinkFromItemId(itemId)
			local itemName = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))
			local stackCount = GetItemLinkStacks(itemLink)
			local color = GetItemQualityColor(GetItemLinkDisplayQuality(itemLink))

			LostTreasure:AddTooltip(text, itemName, color, stackCount, "LostTreasure/Icons/map_white.dds")
		end,
	}

	for pinType, settings in ipairs(self.savedVars.pinTypes) do

		local mapPinLayout =
		{
			level = settings.pinLevel,
			size = settings.size,
			texture = settings.texture,
		}

		local compassPinLayout =
		{
			maxDistance = 0.05,
			texture = settings.texture,
			additionalLayout =
			{
				[1] = UpdatePinName, -- update pin
				[2] = function() end, -- disable pin
			},
		}

		local pinName = self:GetPinNameFromPinType(pinType)
		local pinCheckboxText = zo_strformat("<<C:1>> (<<C:2>>)", LOST_TREASURE_PIN_TYPE_DATA[pinType].name, self.addOnDisplayName)
		LostTreasure:AddNewPins(pinName, pinType, function() PinTypeAddCallback(pinType, pinName) end, mapPinLayout, pinTooltipCreator, pinCheckboxText, function() PinCallback(pinType) end, compassPinLayout, settings, "showOnMap")
	end
end