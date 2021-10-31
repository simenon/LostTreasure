local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local LogManager = internal.LogManager
local logger = LogManager:New("debug")

local debug = { }
internal.debug = debug


local ACTIVE = true
local NOT_ACTIVE = false

function debug:Initialize()
	self:SetState(NOT_ACTIVE)

	logger:Debug("initialized")
end

function debug:Enable()
	LogManager:SetMinLogLevelToAllTags(LogManager.LOG_LEVEL_DEBUG)
	self:SetState(ACTIVE)
	logger:Info("Debug has been enabled")
end

function debug:Disable()
	LogManager:SetMinLogLevelToAllTags(LogManager.LOG_LEVEL_INFO)
	self:SetState(NOT_ACTIVE)
	logger:Info("Debug has been disabled")
end

function debug:SetState(bool)
	self.active = bool or false
end

function debug:GetState()
	return self.active
end