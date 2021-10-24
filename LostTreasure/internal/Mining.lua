local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = LostTreasure.logger:Create("mining")

local mining = { }
internal.mining = mining

local notifications = internal.notifications
local savedVars = internal.savedVars

local MINING_ACTIVE_TIME = ZO_ONE_DAY_IN_SECONDS * 7

local function HasBlankSavedVars(miningTimeStamp, miningAPIVersion)
	local BLANK_SAVED_VARS = LOST_TREASURE_BLANK_SAVED_VARS
	return miningTimeStamp == BLANK_SAVED_VARS or miningAPIVersion == BLANK_SAVED_VARS
end

local function IsWithinMiningActiveTime(now, miningTimeStamp)
	return GetDiffBetweenTimeStamps(now, miningTimeStamp) < MINING_ACTIVE_TIME
end

-- DO NOT initialize before the db are created!
function mining:Initialize()
	--[[
		only for testing:
		
		1.
		/script LostTreasure_Account["EU Megaserver"]["@LoadingScreen"]["$AccountWide"]["mining"]["APITimeStamp"] = GetCurrentTimeStamp()
		=> Result: ACTIVE

		2.
		/script LostTreasure_Account["EU Megaserver"]["@LoadingScreen"]["$AccountWide"]["mining"]["APITimeStamp"] = 1
		=> Result: NOT active
		
		3.
		/script LostTreasure_Account["EU Megaserver"]["@LoadingScreen"]["$AccountWide"]["mining"]["APIVersion"] = GetAPIVersion() - 1
		=> Result: ACTIVE
	]]
	self.isActive = false

	local db = savedVars.db
	local miningData = db.mining
	local currentAPIVersion = LostTreasure.APIVersion

	local miningTimeStamp = miningData.APITimeStamp
	local miningAPIVersion = miningData.APIVersion

	local hasNewAPIVersion = currentAPIVersion > miningAPIVersion
	local now = GetTimeStamp()

	local additionalText = ": AN ISSUE HAS BEEN ENCOUNTERED"
	if HasBlankSavedVars(miningTimeStamp, miningAPIVersion) or hasNewAPIVersion then
		db.mining.APIVersion = currentAPIVersion
		db.mining.APITimeStamp = now
		if hasNewAPIVersion then
			ZO_ClearTable(db.mining.data)
			additionalText = "due to a new game API Version."
		else
			additionalText = "due to blank SavedVars."
		end
		self.isActive = true
	elseif IsWithinMiningActiveTime(now, miningTimeStamp) then
		additionalText = "within active mining time."
		self.isActive = true
	end

	if self.isActive then
		logger:Info("initialized: Mining is ACTIVE " .. additionalText)
	else
		notifications:DeleteAllNotifications()
		logger:Info("initialized: Mining is NOT active")
	end
end

local function IsStored(pinData)
	local db = savedVars.db
	local mapIdData = db.mining.data[pinData.mapId]
	if mapIdData then
		for _, pinLayoutData in ipairs(mapIdData) do
			if pinLayoutData.itemId == pinData.itemId then
				logger:Debug("%d has been found", pinData.itemId)
				return true
			end
		end
	end
	logger:Debug("%d has not been found", pinData.itemId)
	return false
end

function mining:IsActive()
	return self.isActive
end

function mining:Store(pinData)
	-- Only report new pins when the treasure map has been opened.
	if pinData.lastOpenedTreasureMap == LOST_TREASURE_MAP_NOT_OPENED then
		logger:Debug("no treasure map has been opened before")
		return
	end

	-- Store in db
	local db = savedVars.db
	local currentMapIdData = db.mining.data[pinData.mapId]
	currentMapIdData[#currentMapIdData + 1] = pinData

	logger:Debug("new item %d %s has been stored", pinData.itemId, pinData.itemName)

	-- send a new notification
	notifications:Add(pinData)
end

function mining:Add(pinData)
	if not self:IsActive() then
		logger:Info("Mining not active! Tried to add %s", pinData.itemId)
		return
	end

	if not IsStored(pinData) then
		self:Store(pinData)
	end
end
