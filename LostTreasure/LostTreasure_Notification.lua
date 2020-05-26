local IDENTIFIER = "Notifications"

local NOTIFICATION_ICON_PATH = 1
local NOTIFICATION_X = 2
local NOTIFICATION_Y = 3
local NOTIFICATION_ZONE = 4
local NOTIFICATION_MAP_ID = 5
local NOTIFICATION_ITEM_ID = 6
local NOTIFICATION_TREASURE_MAP = 7
local NOTIFICATION_MAX_VALUE = NOTIFICATION_TREASURE_MAP

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

function BugReport:New(bugReportURL)
	local object = ZO_Object.New(self)
	object.url = bugReportURL
	object.pattern = URL_PATTERN
	object:ResetOutput()
	return object
end

function BugReport:ResetOutput()
	self.output = ""
end

function BugReport:ReplaceSpecialCharacters(str)
	str = str:gsub(" ", "%%20") -- %20 is a space
	str = str:gsub("\n", "%%0A") -- %0A is a new line
	return str
end

function BugReport:GenerateURL(data)
-- Check first, if we have the correct amount of data parameters.
-- This is just a little safety, if we forgot to change the input parameters after we added/removed some.
	if #data == NOTIFICATION_MAX_VALUE then
		local output = { }
		table.insert(output, self.url)
		table.insert(output, self.pattern[URL_PATTERN_TITLE])
		table.insert(output, GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_TITLE))
		table.insert(output, self.pattern[URL_PATTERN_MESSAGE])
		table.insert(output, string.format(GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_MESSAGE), select(2, unpack(data)))) -- we have to cut out the iconTexture
		self.output = self:ReplaceSpecialCharacters(table.concat(output))
	end
end

function BugReport:RequestOpenURL()
	local output = self.output
	if output and output ~= "" then
		RequestOpenUnsafeURL(output)
		self:ResetOutput()
	end
end


-- LostTreasure_Notification
----------------------------
LostTreasure_Notification = ZO_Object:Subclass()

function LostTreasure_Notification:New(...)
	local object = ZO_Object.New(self)
	object:Initialize(...)
	return object
end

function LostTreasure_Notification:Initialize(addOnName, addOnDisplayName, savedVars, debugLogger, bugReportURL)
	-- self.control = control
	self.addOnDisplayName = addOnDisplayName
	self.savedVars = savedVars
	self.provider = LibNotifications:CreateProvider()
	self.bugReport = BugReport:New(bugReportURL)

	self.debugLogger = debugLogger:Create(IDENTIFIER)

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
		table.insert(savedVars.notifications, layoutData)
	end
	ZO_ClearTable(provider.notifications)
end

function LostTreasure_Notification:RestoreAllNotifications()
	local savedVars = self.savedVars
	for _, layoutData in ipairs(savedVars.notifications) do
		self:NewNotification(unpack(layoutData.data))
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
		self.debugLogger:Debug("Notification itemId already exist.")
	end

	if addNotification then
		table.insert(providerNotifications, message)
		provider:UpdateNotifications()
		self.debugLogger:Debug("Added new notification: %s", table.concat(message.data, ", "))
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

function LostTreasure_Notification:NewNotification(notificationIconPath, x, y, zone, itemId, mapId, lastOpenedTreasureMap)
	local message =
	{
		dataType = NOTIFICATIONS_REQUEST_DATA,
		secsSinceRequest = ZO_NormalizeSecondsSince(0),
		note = GetString(SI_LOST_TREASURE_NOTIFICATION_NOTE),
		message = GetString(SI_LOST_TREASURE_NOTIFICATION_MESSAGE),
		heading = self.addOnDisplayName,
		texture = notificationIconPath,
		shortDisplayText = self.addOnDisplayName,
		controlsOwnSounds = false,
		keyboardAcceptCallback = function(data) self:Accept(data) end,
		keyboardDeclineCallback = function(data) self:Decline(data) end,
		gamepadAcceptCallback = function(data) self:Accept(data) end,
		gamepadDeclineCallback = function(data) self:Decline(data) end,
		data =
		{
			[NOTIFICATION_ICON_PATH] = notificationIconPath,
			[NOTIFICATION_X] = x,
			[NOTIFICATION_Y] = y,
			[NOTIFICATION_ZONE] = zone,
			[NOTIFICATION_MAP_ID] = mapId,
			[NOTIFICATION_ITEM_ID] = itemId,
			[NOTIFICATION_TREASURE_MAP] = lastOpenedTreasureMap or GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_NO_MAP),
		}
	}
	self:AddNotification(message)
end