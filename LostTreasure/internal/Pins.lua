local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("pins")

local pins = { }
internal.pins = pins


local TIME_BETWEEN_LABEL_UPDATES_MS = 250
local DEFAULT_GAMEPAD_TOOLTIP_TEXTURE = LibTreasure_GetIcons()[4]

local LibMapPins = LibMapPins
local LibCompassPins = COMPASS_PINS

local utilities = internal.utilities
local settings = internal.settings
local itemCache = internal.itemCache
local savedVars = internal.savedVars
local markOnUsing = internal.markOnUsing

local function GetMapFilterCheckboxName(pinType)
	local addOnDisplayName = LostTreasure.addOnDisplayName
	local nameLocalized = LOST_TREASURE_PIN_TYPE_DATA[pinType].name
	return zo_strformat(SI_LOST_TREASURE_MAP_FILTER_CHECKBOX_NAME, nameLocalized, addOnDisplayName)
end

local function GetPinNameFromPinType(pinType)
	return LOST_TREASURE_PIN_TYPE_DATA[pinType].pinName
end

local function RefreshMapPins(pinName)
	LibMapPins:RefreshPins(pinName)
end

local function RefreshCompassPins(pinName)
	LibCompassPins:RefreshPins(pinName)
end

function pins:SetLayoutKey(pinType, key, data)
	local pinName = GetPinNameFromPinType(pinType)
	LibMapPins:SetLayoutKey(pinName, key, data)
end

function pins:IsEnabled(pinName)
	return LibMapPins:IsEnabled(pinName)
end

function pins:SetMapPinState(pinType, state)
	local pinName = GetPinNameFromPinType(pinType)
	LibMapPins:SetEnabled(pinName, state)
end

function pins:RefreshAllPinsFromPinType(pinType)
	local pinName = GetPinNameFromPinType(pinType)
	RefreshMapPins(pinName)
	RefreshCompassPins(pinName)
end

function pins:RefreshCompassPinsFromPinType(pinType)
	local pinName = GetPinNameFromPinType(pinType)
	RefreshCompassPins(pinName)
end

function pins:SetCompassPinTypeTexture(pinType, texturePath)
	local pinName = GetPinNameFromPinType(pinType)
	LibCompassPins.pinLayouts[pinName].texture = texturePath
end

function pins:RefreshAllPins()
	local savedVars = internal.savedVars
	local db = savedVars:GetSavedVars()
	for pinType, _ in pairs(db.pinTypes) do
		pins:RefreshAllPinsFromPinType(pinType)
	end
end

function pins:AddNewPins(pinName, pinType, mapCallback, mapLayout, pinTooltip, mapFilter, compassCallback, compassLayout, settingsLayout, settingsKey)
	LibMapPins:AddPinType(pinName, mapCallback, nil, mapLayout, pinTooltip)
	LibMapPins:AddPinFilter(pinName, mapFilter, nil, settingsLayout, settingsKey)

	LibCompassPins:AddCustomPin(pinName, compassCallback, compassLayout)

	RefreshCompassPins(pinName)
end

function pins:CreateNewPin(pinType, pinData, key)
	local pinName = GetPinNameFromPinType(pinType)
	if key == LOST_TREASURE_PIN_KEY_MAP then
		LibMapPins:CreatePin(pinName, pinData, pinData.x, pinData.y)
	elseif key == LOST_TREASURE_PIN_KEY_COMPASS then
		local itemLink = utilities:GetItemLinkFromItemId(pinData.itemId)
		local itemName = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))
		LibCompassPins.pinManager:CreatePin(pinName, pinData, pinData.x, pinData.y, itemName)
	end
	logger:Verbose("Add pin to map - pinType: %s, pinName: %s, itemId: %s", pinType, pinName, pinData.itemId)
end

function pins:CreateMarkOptionMapPin(pinType, key, pinData, markOption)
	if markOption ~= LOST_TREASURE_MARK_OPTIONS_ALL then
		local itemId = pinData.itemId
		if markOption == LOST_TREASURE_MARK_OPTIONS_USING then -- mark on using
			if markOnUsing:DoesExist(pinType, itemId) then
				self:CreateNewPin(pinType, pinData, key)
			end
		else
			if itemCache:IsItemInBagCache(itemId) then -- only inventory items
				self:CreateNewPin(pinType, pinData, key)
			end
		end
	else
		self:CreateNewPin(pinType, pinData, key) -- all items
	end
end

-- /script LOST_TREASURE.internal.pins:GetAndCreateMapPins("treasure", LOST_TREASURE_PIN_KEY_MAP)
-- /script LOST_TREASURE.internal.pins:GetAndCreateMapPins("surveys", LOST_TREASURE_PIN_KEY_MAP)
function pins:GetAndCreateMapPins(pinType, key)
	-- We don't use RequestRefreshMap here, because you can't zoom out the map anymore.
	-- The refresh happens while opening the map manually anyways.
	local mapId = GetCurrentMapId()
	local mapIdData = LibTreasure_GetMapIdData(mapId)
	if mapIdData then
		local markOption = settings:GetSettingsFromPinType(pinType, "markOption")
		for _, pinData in ipairs(mapIdData) do
			if pinData.pinType == pinType then
				self:CreateMarkOptionMapPin(pinType, key, pinData, markOption)
			end
		end
	end
end

function pins:GetAndCreateMinedMapPins(pinType, key)
	local savedVars = internal.savedVars
	local db = savedVars.db
	local mapId = GetCurrentMapId()
	local currentMapIdData = db.mining.data[mapId]
	if currentMapIdData then
		local markOption = settings:GetSettingsFromPinType(pinType, "markOption")
		for _, pinData in ipairs(currentMapIdData) do
			if pinData.pinType == pinType then
				self:CreateMarkOptionMapPin(pinType, key, pinData, markOption)
			end
		end
	end
end

function pins:UpdatePinName(pin, _, normalizedAngle, normalizedDistance)
	local now = GetFrameTimeMilliseconds()
	if now < self.nextLabelUpdateTime then
		return
	end

	if pin.pinName then
		if zo_abs(normalizedAngle) < 0.1 and zo_abs(normalizedDistance) < 0.95 then
			if self.overrideAnimation:IsPlaying() then
				self.overPinAnimation:PlayBackward()
			elseif not self.overPinAnimation:IsPlaying() or not self.overPinAnimation:IsPlayingBackward() then
				self.overPinLabel:SetText(pin.pinName)
				self.overPinAnimation:PlayForward()
			end
			self.nextLabelUpdateTime = now + TIME_BETWEEN_LABEL_UPDATES_MS
		end
	end
end

function pins:InitializeUpdatePinName()
	-- handle pin names in compass frame
	self.nextLabelUpdateTime = -1

	local function IsAboveUpdateThreshold()
		return GetFrameTimeMilliseconds() > self.nextLabelUpdateTime + TIME_BETWEEN_LABEL_UPDATES_MS
	end

	ZO_PreHook(COMPASS, "OnUpdate", function()
		return not IsAboveUpdateThreshold()
	end)

	self.overPinLabel = COMPASS.centerOverPinLabel
	self.overPinAnimation = COMPASS.centerOverPinLabelAnimation
	self.overrideAnimation = COMPASS.areaOverrideAnimation
end

function pins:Initialize()
	pins:InitializeUpdatePinName()

	-- create new pins
	local function PinTypeAddCallback(pinType, pinName)
		if utilities:IsValidMapType() and self:IsEnabled(pinName) then
			self:GetAndCreateMapPins(pinType, LOST_TREASURE_PIN_KEY_MAP)
			self:GetAndCreateMinedMapPins(pinType, LOST_TREASURE_PIN_KEY_MAP)
		end
	end

	local function PinCallback(pinType)
		if utilities:IsValidMapType() and settings:GetSettingsFromPinType(pinType, "showOnCompass") then
			self:GetAndCreateMapPins(pinType, LOST_TREASURE_PIN_KEY_COMPASS)
			self:GetAndCreateMinedMapPins(pinType, LOST_TREASURE_PIN_KEY_COMPASS)
		end
	end

	local pinTooltipCreator =
	{
		creator = function(pin)
			local pinTag = select(2, pin:GetPinTypeAndTag())
			local x, y = pinTag.x, pinTag.y
			local text = string.format("%.2f x %.2f", x * 100, y * 100)

			local itemId = pinTag.itemId
			local itemLink = utilities:GetItemLinkFromItemId(itemId)
			local itemName = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))
			local stackCount = GetItemLinkStacks(itemLink)
			local color = GetItemQualityColor(GetItemLinkDisplayQuality(itemLink))

			utilities:AddTooltip(text, itemName, color, stackCount, DEFAULT_GAMEPAD_TOOLTIP_TEXTURE)
		end,
	}

	local savedVars = internal.savedVars
	local db = savedVars:GetSavedVars()
	for pinType, settingsLayout in pairs(db.pinTypes) do

		local mapPinLayout =
		{
			level = settingsLayout.pinLevel,
			size = settingsLayout.size,
			texture = settingsLayout.texture,
		}

		local compassPinLayout =
		{
			maxDistance = 0.05,
			texture = settingsLayout.texture,
			additionalLayout =
			{
				[1] = function(...) self:UpdatePinName(...) end, -- update pin
				[2] = function() end, -- reset pin
			},
		}

		local pinName = GetPinNameFromPinType(pinType)

		self:AddNewPins(
			pinName,
			pinType,
			function() PinTypeAddCallback(pinType, pinName) end,
			mapPinLayout,
			pinTooltipCreator,
			GetMapFilterCheckboxName(pinType),
			function() PinCallback(pinType) end,
			compassPinLayout,
			settingsLayout,
			"showOnMap")
	end

	logger:Debug("initialized")
end