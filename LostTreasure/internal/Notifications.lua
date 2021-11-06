local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("notifications")

local notifications = { }
internal.notifications = notifications


local savedVars = internal.savedVars
local bugReport = internal.bugReport

local ADDON_NAME = LostTreasure.addOnDisplayName
local SUPPORTED_LANGUAGES = ZO_CreateSetFromArguments("en", "de", "fr")

local tinsert, tremove, tconcat = table.insert, table.remove, table.concat
local language = GetCVar("language.2")

local function IsLanguageSupported()
	return SUPPORTED_LANGUAGES[language] == true
end

local function Accept(self, data)
	self:RemoveNotification(data)
	bugReport:RequestOpenURL(data.data)
end

local function Decline(self, data)
	self:RemoveNotification(data)
end

-- DO NOT initalize before the db are created!
function notifications:Initialize()
	self.provider = LibNotifications:CreateProvider()

	self:RestoreAllNotifications()

	local function OnPlayerDeactivated()
		self:SaveAllNotifications()
	end
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_DEACTIVATED, OnPlayerDeactivated)

	logger:Debug("initialized")
end

function notifications:SaveAllNotifications()
	local db = savedVars.db
	local provider = self.provider
	ZO_ClearTable(db.notifications)
	for _, layoutData in ipairs(provider.notifications) do
		tinsert(db.notifications, layoutData.data)
	end
	self:DeleteAllNotificationsInDatabase()
end

function notifications:RestoreAllNotifications()
	local db = savedVars.db
	for _, layoutData in ipairs(db.notifications) do
		self:Add(layoutData)
	end
	self:DeleteAllNotificationsInDatabase()
end

function notifications:DeleteAllNotificationsInDatabase()
	local db = savedVars.db
	if db and db.notifications and next(db.notifications) then
		ZO_ClearTable(db.notifications)
		logger:Debug("All notifications have been removed")
	end
end

function notifications:RemoveNotification(data)
	local provider = self.provider
	tremove(provider.notifications, data.notificationId)
	provider:UpdateNotifications()
end

function notifications:AddNotification(notification)
	local provider = self.provider
	local providerNotifications = provider.notifications

	local addNotification = true
	local itemId = notification.data.itemId
	if next(providerNotifications) then
		for index, layoutData in ipairs(providerNotifications) do
			if layoutData.data.itemId == itemId then
				addNotification = false
				break
			end
		end
	end

	if addNotification then
		tinsert(providerNotifications, notification)
		provider:UpdateNotifications()
		logger:Debug("New notification has been added for itemId %d", itemId)
	else
		logger:Debug("Notification itemId already exist")
	end
end

function notifications:Add(pinData)
	if not IsLanguageSupported() then
		logger:Debug("Tried to add pin, but the language \"%s\" is not supported", language)
		return
	end

	local notification =
	{
		data = pinData,
		dataType = NOTIFICATIONS_REQUEST_DATA,
		secsSinceRequest = ZO_NormalizeSecondsSince(0),
		note = GetString(SI_LOST_TREASURE_NOTIFICATION_NOTE),
		message = GetString(SI_LOST_TREASURE_NOTIFICATION_MESSAGE),
		heading = ADDON_NAME,
		texture = pinData.texture,
		shortDisplayText = ADDON_NAME,
		controlsOwnSounds = false,
		keyboardAcceptCallback = function(data) Accept(self, data) end,
		keyboardDeclineCallback = function(data) Decline(self, data) end,
		gamepadAcceptCallback = function(data) Accept(self, data) end,
		gamepadDeclineCallback = function(data) Decline(self, data) end,
	}
	self:AddNotification(notification)
end