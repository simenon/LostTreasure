-- Chinese Localization by Calamath

local function SafeStrings(strings)
	for stringId, stringValue in pairs(strings) do
		SafeAddString(_G[stringId], stringValue, 0)
	end
	ZO_ClearTable(strings)
end

local strings = {
	SI_LOST_TREASURE_BUGREPORT_PICKUP_TITLE = "发现新地图 v%d id%d %s",
	SI_LOST_TREASURE_BUGREPORT_PICKUP_NO_MAP = "无地图打开",

	SI_LOST_TREASURE_TREASURE_MAPS = "藏宝图",
	SI_LOST_TREASURE_SURVEY_REPORTS = "调查报告",

	SI_LOST_TREASURE_COMPARE_TREASURE = "藏宝图",
	SI_LOST_TREASURE_COMPARE_SURVEY = "调查:",

	SI_LOST_TREASURE_SHOW_ON_MAP = "在地图上显示",
	SI_LOST_TREASURE_SHOW_ON_MAP_TT = "在玩家地图上显示标志.",
	SI_LOST_TREASURE_SHOW_ON_COMPASS = "在罗盘上显示",
	SI_LOST_TREASURE_SHOW_ON_COMPASS_TT = "在罗盘上显示标志.",
	SI_LOST_TREASURE_PIN_ICON = "图标",
	SI_LOST_TREASURE_PIN_ICON_TT = "选择您想要的标志图标.",
	SI_LOST_TREASURE_PIN_SIZE = "尺寸",
	SI_LOST_TREASURE_PIN_SIZE_TT = "选择玩家地图上的标志尺寸.",
	SI_LOST_TREASURE_MARK_OPTION = "标记选项",
	SI_LOST_TREASURE_MARK_OPTION_TT = "定义一个标记应在何时出现在玩家地图和罗盘上。",
	SI_LOST_TREASURE_MARK_OPTION1_TT = "仅当打开一个藏宝图或调查报告之后显示标志。",
	SI_LOST_TREASURE_MARK_OPTION2_TT = "显示您物品栏中的藏宝图或调查报告的标志。",
	SI_LOST_TREASURE_MARK_OPTION3_TT = "展示所有的标记，无论你物品栏中是否有它们",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1 = "在使用",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2 = "物品栏中所有",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3 = "所有地点",
	SI_LOST_TREASURE_PIN_LEVEL = "地图等级",
	SI_LOST_TREASURE_PIN_LEVEL_TT = "更高等级的叠加在更低等级的标志上面。如果标志被其他标志覆盖，则增加此值。",
	SI_LOST_TREASURE_MARKER_DELAY = "隐藏延迟",

	SI_LOST_TREASURE_SHOW_MINIMAP_HEADER = "小地图",
	SI_LOST_TREASURE_SHOW_MINIMAP = "显示小地图",
	SI_LOST_TREASURE_SHOW_MINIMAP_TT = "使用藏宝图或调查报告后，显示小地图.",
	SI_LOST_TREASURE_SHOW_MINIMAP_SIZE = "小地图尺寸",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY = "隐藏延迟",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT = "你获得藏宝图或调查报告后，隐藏小地图之前的延迟 (以秒计) ",

	SI_LOST_TREASURE_NOTIFICATION_MESSAGE = "发现新的未知数据.",
	SI_LOST_TREASURE_NOTIFICATION_NOTE = "请确认此通知以分享你的新未知藏宝图/调查报告数据。你需要一个ESOUI.com账户来发送此BUG报告.",
}

SafeStrings(strings)

-- we have to generate this later, because the options have to be defined first
strings = {
	SI_LOST_TREASURE_MARKER_DELAY_TT = zo_strformat("在删除地图上标记的位置之前加入一个延迟。仅和 <<1>> or <<2>> 同时生效。当你选择选项<<3>>或打开地图刷新所有标记时，这将不会起效。", ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3))),
}

SafeStrings(strings)