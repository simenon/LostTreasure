local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = LostTreasure.logger:Create("mining")

local mining = { }
internal.mining = mining

local notifications = internal.notifications
local savedVars = internal.savedVars


local MINING_ACTIVE_TIME = ZO_ONE_DAY_IN_SECONDS * 7
local BLANK_SAVED_VARS = 0

-- DO NOT initalize before the db are created!
--[[
/script LostTreasure_Account["EU Megaserver"]["@LoadingScreen"]["$AccountWide"]["mining"]["APITimeStamp"] = 1
]]
function mining:Initialize()
	self.isActive = false

	local db = savedVars.db
	local miningData = db.mining
	local currentAPIVersion = LostTreasure.APIVersion

	local miningTimeStamp = miningData.APITimeStamp
	local miningAPIVersion = miningData.APIVersion
	local miningAddOnVersion = miningData.AddOnVersion

	local now = GetTimeStamp()

	local hasBlankSavedVars = miningTimeStamp ~= BLANK_SAVED_VARS or miningAPIVersion ~= BLANK_SAVED_VARS
	local hasNewAPIVersion = currentAPIVersion > miningAPIVersion

	if hasBlankSavedVars or hasNewAPIVersion then
		db.mining.APIVersion = currentAPIVersion
		db.mining.APITimeStamp = now
		db.mining.AddOnVersion = LostTreasure.version
		if hasNewAPIVersion then
			ZO_ClearTable(db.mining.data)
		end
		self.isActive = true
	elseif GetDiffBetweenTimeStamps(now, miningTimeStamp) < MINING_ACTIVE_TIME then
		self.isActive = true
	end

	if self.isActive then
		logger:Info("initialized: Mining is ACTIVE")
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
