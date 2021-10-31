local LostTreasure = LOST_TREASURE

if LostTreasure == nil then
	zo_callLater(function() d("Global is nil") end, 2000)
end

local internal = LostTreasure.internal


local LogManager = { }
internal.LogManager = LogManager

local str_cant_send_message = "Logger can't send a message. "
local str_no_instance = "No tag instance has been found. "

local function RaiseError(self, customMsg)
	local logger = self.tags[namespace]
	if logger.Error then
		logger:Error(str_cant_send_message)
	elseif customMsg then
		self.mainLogger:Error(str_no_instance .. customMsg)
	else
		self.mainLogger:Error(str_no_instance .. str_cant_send_message)
	end
end

function LogManager:Initialize()
	self.tags = { }
	
	local LibDebugLogger = LibDebugLogger
	self.mainLogger = LibDebugLogger(LostTreasure.addOnName)
	self.LOG_LEVEL_DEBUG = LibDebugLogger.LOG_LEVEL_DEBUG
	self.LOG_LEVEL_INFO = LibDebugLogger.LOG_LEVEL_INFO

	self:SetMinLogLevelToAllTags(LibDebugLogger:GetMinLogLevel())
end

function LogManager:GetTags()
	return self.tags
end

function LogManager:SetTagMinLogLevel(namespace, level)
	local tags = self.tags
	local logger = tags[namespace]
	if logger then
		logger:SetMinLevelOverride(level)
	else
		RaiseError(self, "SetTagMinLogLevel has not been applied.")
	end
end

function LogManager:SetMinLogLevelToAllTags(level)
	level = level or self.LOG_LEVEL_INFO
	self.mainLogger:SetMinLevelOverride(level)

	local tags = self:GetTags()
	for namespace, _ in pairs(tags) do
		self:SetTagMinLogLevel(namespace, level)
	end
end

function LogManager:New(namespace)
	local tags = self.tags
	if not tags[namespace] then
		tags[namespace] = self.mainLogger:Create(namespace)
		return tags[namespace]
	else
		self.mainLogger:Error("failed creating a new logger for: %s", namespace or "nil")
	end
end

function LogManager:Verbose(...)
	self.mainLogger:Verbose(...)
end

function LogManager:Debug(...)
	self.mainLogger:Debug(...)
end

function LogManager:Info(...)
	self.mainLogger:Info(...)
end


LogManager:Initialize()