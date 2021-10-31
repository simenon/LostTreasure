local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = LostTreasure.logger:Create("debug")

local debug = { }
internal.debug = debug


local ACTIVE = true
local NOT_ACTIVE = false


function debug:Initialize()

	self:SetState(NOT_ACTIVE)
	self:SetIgnoreSaving()

	self.mainLogger = LibDebugLogger
	local mainLogger = self.mainLogger
	self.mainLogLevel = mainLogger:GetMinLogLevel()

	-- We want to know if this function was triggered from LostTreasure or from outside. We only want to track the changes from outside.
	local LOG_LEVELS = self.mainLogger.LOG_LEVEL_TO_STRING
	ZO_PostHook(mainLogger, "SetMinLogLevel", function(_, level)
		if self.ignoreSaving then
			self.mainLogLevel = level
			logger:Info("mainLogLevel has been changed to: %s (%s)", LOG_LEVELS[level], level)
		else
			logger:Info("Addon SetMinLogLevel has been changed to: %s (%s)", LOG_LEVELS[level], level)
		end
	end)

	-- We do not want to save the SetMinLogLevel from LostTreasure, so we will reset to the start-up mainLogLevel before Logout
	ZO_PreHook("Logout", function()
		self:Disable()
	end)

	logger:Debug("initialized")
end

function debug:SetIgnoreSaving(bool)
	self.ignoreSaving = bool
end

function debug:GetIgnoreSaving()
	return self.ignoreSaving
end

function debug:SetState(bool)
	self.active = bool or false
end

function debug:GetState()
	return self.active
end

function debug:Enable()
	self:SetState(ACTIVE)

	local mainLogger = self.mainLogger
	self:SetIgnoreSaving(false)
	mainLogger:SetMinLogLevel(mainLogger.LOG_LEVEL_DEBUG)
	self:SetIgnoreSaving(true)
	logger:Info("Debug has been enabled")
end

function debug:Disable()
	self:SetState(NOT_ACTIVE)
	self.mainLogger:SetMinLogLevel(self.mainLogLevel)
	logger:Info("Debug has been disabled")
end
