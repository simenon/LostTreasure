local LostTreasure = LOST_TREASURE

local internal = LostTreasure.internal
local logger = internal.LogManager:New("bugReport")

local bugReport = { }
internal.bugReport = bugReport


local BUG_REPORT_URL = "https://www.esoui.com/portal.php?id=121&a=bugreport&addonid=561&title=%s&message=%s"

local sformat = string.format
local addOnVersion = LostTreasure.version

local function GetTitleString(data)
	local itemId = data.itemId
	local itemName = data.itemName
	logger:Debug("addOnVersion: %d, itemId: %d, itemName: %s", addOnVersion, itemId, itemName)
	return sformat(GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_TITLE), addOnVersion, itemId, itemName)
end

local function GetMessageString(data)
	return sformat(GetString(SI_LOST_TREASURE_BUGREPORT_PICKUP_MESSAGE), addOnVersion, data.zone, data.mapId, data.x, data.y, data.lastOpenedTreasureMap, data.itemId, data.itemName)
end

local function ReplaceSpecialCharacters(str)
	-- 1. replace "\n" with "%%0A" (%0A is a new line)
	-- 2. replace " " with "%%20" (%20 is a space)
	-- 3. replace " " with "%%20" (" " this is a special character. if we don't replace it, the bug report doesn't work properly)
	return str:gsub("\n", "%%0A"):gsub(" ", "%%20"):gsub(" ", "%%20")
end

local function GetReportURL(data)
	local title = GetTitleString(data)
	local message = GetMessageString(data)
	return ReplaceSpecialCharacters(sformat(BUG_REPORT_URL, title, message))
end

function bugReport:RequestOpenURL(data)
	RequestOpenUnsafeURL(GetReportURL(data))
end
