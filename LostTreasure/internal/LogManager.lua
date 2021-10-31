local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal


local LogManager = { }
internal.LogManager = LogManager

local LibDebugLogger = LibDebugLogger
local logger = LibDebugLogger(LostTreasure.addOnName)

function LogManager:Initialize()
	self.tags = { }

	self.mainLogger = logger
	self.LOG_LEVEL_DEBUG = LibDebugLogger.LOG_LEVEL_DEBUG
	self.LOG_LEVEL_INFO = LibDebugLogger.LOG_LEVEL_INFO

	self:SetMinLogLevelToAllTags(LibDebugLogger:GetMinLogLevel())

	self:Debug("initialized")
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
		logger:Error("failed SetTagMinLogLevel: %s", namespace or "nil")
	end
end

function LogManager:SetMinLogLevelToAllTags(level)
	level = level or self.LOG_LEVEL_INFO
	logger:SetMinLevelOverride(level)

	local tags = self:GetTags()
	for namespace, _ in pairs(tags) do
		self:SetTagMinLogLevel(namespace, level)
	end
end

function LogManager:New(namespace)
	local tags = self.tags
	if not tags[namespace] then
		tags[namespace] = logger:Create(namespace)
		return tags[namespace]
	else
		self:Error("failed creating a new logger for: %s", namespace or "nil")
	end
end

function LogManager:Verbose(...)
	logger:Verbose(...)
end

function LogManager:Debug(...)
	logger:Debug(...)
end

function LogManager:Info(...)
	logger:Info(...)
end

function LogManager:Error(...)
	logger:Error(...)
end


LogManager:Initialize()