local IDENTIFIER = "Notifications"

-- Mining
------------
local Mining = ZO_InitializingObject:Subclass()

function Mining:Initialize(savedVars, logger)
	self.logger = logger:Create("Mining")

	local miningAPIVersion = savedVars.mining.APIVersion
	local miningTimeStamp = savedVars.mining.APITimeStamp
	local currentVersion = GetAPIVersion()
	local currentTimeStamp = GetTimeStamp()
	local differenceTimeStamp = GetDiffBetweenTimeStamps(currentTimeStamp, miningTimeStamp)
	local isLessThanHalfAMonth = differenceTimeStamp < ZO_ONE_MONTH_IN_SECONDS / 2

	self.isActive = false
	if currentVersion > miningAPIVersion then
		savedVars.mining.APIVersion = currentVersion
		savedVars.mining.APITimeStamp = currentTimeStamp
		self.isActive = true
	elseif currentVersion == miningAPIVersion and isLessThanHalfAMonth then
		self.isActive = true
	end

	self.logger:Info("Active: %s, isLessThanHalfAMonth: %s, differenceTimeStamp: %d, ", tostring(self.isActive), tostring(isLessThanHalfAMonth), differenceTimeStamp)
end

function Mining:IsActive()
	return self.isActive
end


-- BugReport
------------
local URL_PATTERN_TITLE = 1
local URL_PATTERN_MESSAGE = 2

local URL_PATTERN =
{
	[URL_PATTERN_TITLE] = "&title=",
	[URL_PATTERN_MESSAGE] = "&message="
}

local BugReport = ZO_Object:Subclass()

function BugReport:New(bugReportURL, logger)
	local object = ZO_Object.New(self)
	object.logger = logger:Create("BugReport")
	object.url = bugReportURL
	object.pattern = URL_PATTERN
	object:ResetOutput()
	return object
end

function BugReport:ResetOutput()
	self.output = ""
end

function BugReport:ReplaceSpecialCharacters(str)
	-- 1. replace "\n" with "%%0A" (%0A is a new line)
	-- 2. replace " " with "%%20" (%20 is a space)
	-- 3. replace " " with "%%20" (" " this is a special character. if we don't replace it, the bug report doesn't work properly)
	return str:gsub("\n", "%%0A"):gsub(" ", "%%20"):gsub(" ", "%%20")
end

function BugReport:GenerateURL(data)
	local itemId = data.itemId
	local itemName = data.itemName
	local version = data.addOnVersion

	-- bugReport stringIds are defined in "en" file only
	local output = { }
	table.insert(output, self.url)
	table.insert(output, self.pattern[URL_PATTERN_TITLE])
	table.insert(output, string.format(GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_TITLE), version, itemId, itemName))
	table.insert(output, self.pattern[URL_PATTERN_MESSAGE])
	table.insert(output, string.format(GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_MESSAGE), version, version, data.zone, data.mapId, data.x, data.y, data.lastOpenedTreasureMap, itemId, itemName))
	self.output = self:ReplaceSpecialCharacters(table.concat(output))
end

function BugReport:RequestOpenURL()
	local output = self.output
	if output and output ~= "" then
		self.logger:Debug(output)
		RequestOpenUnsafeURL(output)
		self:ResetOutput()
	end
end


-- LostTreasure_Notification
----------------------------
LostTreasure_Notification = ZO_InitializingObject:Subclass()

function LostTreasure_Notification:Initialize(addOnName, addOnDisplayName, savedVars, logger, bugReportURL)
	self.logger = logger:Create(IDENTIFIER)

	self.addOnDisplayName = addOnDisplayName
	self.savedVars = savedVars
	self.provider = LibNotifications:CreateProvider()
	self.bugReport = BugReport:New(bugReportURL, self.logger)
	self.mining = Mining:New(savedVars, self.logger)

	local function OnPlayerActivated()
		self:RestoreAllNotifications()
	end
	EVENT_MANAGER:RegisterForEvent(addOnName .. IDENTIFIER, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)

	local function OnPlayerDeactivated()
		self:SaveAllNotifications()
	end
	EVENT_MANAGER:RegisterForEvent(addOnName .. IDENTIFIER, EVENT_PLAYER_DEACTIVATED, OnPlayerDeactivated)
end

function LostTreasure_Notification:SaveAllNotifications()
	local savedVars = self.savedVars
	local provider = self.provider
	ZO_ClearTable(savedVars.notifications)
	for _, layoutData in ipairs(provider.notifications) do
		table.insert(savedVars.notifications, layoutData.data)
	end
	ZO_ClearTable(provider.notifications)
end

function LostTreasure_Notification:RestoreAllNotifications()
	local savedVars = self.savedVars
	for _, layoutData in ipairs(savedVars.notifications) do
		self:NewNotification(layoutData)
	end
	ZO_ClearTable(savedVars.notifications)
end

function LostTreasure_Notification:RemoveNotification(message)
	local provider = self.provider
	table.remove(provider.notifications, message.notificationId)
	provider:UpdateNotifications()
end

function LostTreasure_Notification:AddNotification(message)
	local provider = self.provider
	local providerNotifications = provider.notifications

	local addNotification = true
	if next(providerNotifications) then
		for index, layoutData in ipairs(providerNotifications) do
			if layoutData.data[NOTIFICATION_ITEM_ID] == message.data[NOTIFICATION_ITEM_ID] then
				addNotification = false
				break
			end
		end
		self.logger:Debug("Notification itemId already exist.")
	end

	if addNotification then
		table.insert(providerNotifications, message)
		provider:UpdateNotifications()
		self.logger:Debug("Added new notification: %s", table.concat(message.data, ", "))
	end
end

function LostTreasure_Notification:Accept(message)
	self:RemoveNotification(message)
	self.bugReport:GenerateURL(message.data)
	self.bugReport:RequestOpenURL()
end

function LostTreasure_Notification:Decline(data)
	self:RemoveNotification(data)
end

function LostTreasure_Notification:NewNotification(notificationData)
	if self.mining:IsActive() then
		local message =
		{
			dataType = NOTIFICATIONS_REQUEST_DATA,
			secsSinceRequest = ZO_NormalizeSecondsSince(0),
			note = GetString(SI_LOST_TREASURE_NOTIFICATION_NOTE),
			message = GetString(SI_LOST_TREASURE_NOTIFICATION_MESSAGE),
			heading = self.addOnDisplayName,
			texture = notificationData.icon,
			shortDisplayText = self.addOnDisplayName,
			controlsOwnSounds = false,
			keyboardAcceptCallback = function(data) self:Accept(data) end,
			keyboardDeclineCallback = function(data) self:Decline(data) end,
			gamepadAcceptCallback = function(data) self:Accept(data) end,
			gamepadDeclineCallback = function(data) self:Decline(data) end,
			data = notificationData
		}
		self:AddNotification(message)
	end
end