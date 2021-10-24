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
function mining:Initialize()
	self.isActive = false

	local db = savedVars.db
	local miningData = db.mining

	local now = GetTimeStamp()
	local miningTimeStamp = miningData.APITimeStamp
	local diffInSeconds = GetDiffBetweenTimeStamps(now, miningTimeStamp)
	if diffInSeconds > MINING_ACTIVE_TIME and miningTimeStamp ~= 0 then
		logger:Info("The time for mining has expired. Mining not active")
		notifications:DeleteAllNotifications()
		return
	end

	local currentAPIVersion = LostTreasure.APIVersion
	local savedAddOnVersion = miningData.AddOnVersion
	local addOnVersion = LostTreasure.version
	if miningData.APIVersion ~= BLANK_SAVED_VARS and (currentAPIVersion <= miningData.APIVersion or addOnVersion <= savedAddOnVersion) then
		logger:Info("No version change since last login. Mining not active")
		notifications:DeleteAllNotifications()
		return
	end

	-- Let's activate mining
	db.mining.APIVersion = currentAPIVersion
	db.mining.APITimeStamp = now
	db.mining.AddOnVersion = addOnVersion
	ZO_ClearTable(db.mining.data)
	self.isActive = true

	logger:Debug("initialized and activated")
end

local function IsStored(newPin)
	local db = savedVars.db
	local mapIdData = db.mining.data[newPin.mapId]
	if mapIdData then
		for _, pinData in ipairs(mapIdData) do
			if pinData.itemId == newPin.itemId then
				logger:Debug("%d has been found", newPin.itemId)
				return true
			end
		end
	end
	logger:Debug("%d has not been found", newPin.itemId)
	return false
end

function mining:IsActive()
	return self.isActive
end

function mining:Store(newPin)
	-- Only report new pins when the treasure map has been opened.
	if newPin.lastOpenedTreasureMap == LOST_TREASURE_MAP_NOT_OPENED then
		logger:Debug("no treasure map has been opened before")
		return
	end

	-- Store in db
	local db = savedVars.db
	local currentMapIdData = db.mining.data[newPin.mapId]
	currentMapIdData[#currentMapIdData + 1] = newPin

	logger:Debug("new item %d %s has been stored", newPin.itemId, newPin.itemName)
end

function mining:Add(newPin)
	if not self:IsActive() then
		logger:Info("Mining not active! Tried to add %s", newPin.itemId)
		return
	end

	if not IsStored() then
		self:Store(newPin)
	end
end
