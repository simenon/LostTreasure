-- Russian Localization by KL1SK

local function SafeStrings(strings)
	for stringId, stringValue in pairs(strings) do
		SafeAddString(_G[stringId], stringValue, 0)
	end
	ZO_ClearTable(strings)
end

local strings = {
	SI_LOST_TREASURE_TREASURE_MAPS = "Карты Cокровищ",
	SI_LOST_TREASURE_SURVEY_REPORTS = "Отчеты об исследованиях",

	SI_LOST_TREASURE_COMPARE_TREASURE = "Карта сокровищ",
	SI_LOST_TREASURE_COMPARE_SURVEY = "Исследование",

	SI_LOST_TREASURE_SHOW_ON_MAP = "Показать на карте",
	SI_LOST_TREASURE_SHOW_ON_MAP_TT = "Показать метки на карте.",
	SI_LOST_TREASURE_SHOW_ON_COMPASS = "Показать на компасе",
	SI_LOST_TREASURE_SHOW_ON_COMPASS_TT = "Показать метки на компасе.",
	SI_LOST_TREASURE_PIN_ICON = "Иконка",
	SI_LOST_TREASURE_PIN_ICON_TT = "Выберите нужный символ.",
	SI_LOST_TREASURE_PIN_SIZE = "Размер",
	SI_LOST_TREASURE_PIN_SIZE_TT = "Выберите размер метки на карте.",
	SI_LOST_TREASURE_MARK_OPTION = "Параметры метки",
	SI_LOST_TREASURE_MARK_OPTION_TT = "Определяет, когда метка должен быть видна на карте и на компасе.",
	SI_LOST_TREASURE_MARK_OPTION1_TT = "Отображает метку только после открытия карты сокровищ или отчета об исследовании.",
	SI_LOST_TREASURE_MARK_OPTION2_TT = "Показать метки карт сокровищ и отчетов об исследованиях, которые находятся в вашем инвентаре.",
	SI_LOST_TREASURE_MARK_OPTION3_TT = "Показать все метки независимо от того, есть ли они в вашем инвентаре.",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1 = "на использование",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2 = "все в инвентаре",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3 = "все локации",
	SI_LOST_TREASURE_PIN_LEVEL = "Уровень на карте",
	SI_LOST_TREASURE_PIN_LEVEL_TT = "Увеличение уровеня отображения метки. Увеличьте это значение, если метка скрыта другими метками.",
	SI_LOST_TREASURE_MARKER_DELAY = "Задержка",

	SI_LOST_TREASURE_SHOW_MINIMAP_HEADER = "Мини-карта",
	SI_LOST_TREASURE_SHOW_MINIMAP = "Показать мини-карту",
	SI_LOST_TREASURE_SHOW_MINIMAP_TT = "Покажите мини-карту после использования карты сокровищ или отчета об исследовании.",
	SI_LOST_TREASURE_SHOW_MINIMAP_SIZE = "Размер мини-карты",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY = "Задержка",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT = "Задержка (в секундах) перед тем, как спрятать мини-карту после того, как вы собрали сокровище или исследование.",

	-- SI_LOST_TREASURE_NOTIFICATION_MESSAGE = "Новые неизвестные данные были найдены.", -- not supported
	-- SI_LOST_TREASURE_NOTIFICATION_NOTE = "", -- not supported
}

SafeStrings(strings)

-- we have to generate this later, because the options have to be defined first
strings = {
	SI_LOST_TREASURE_MARKER_DELAY_TT = zo_strformat("Добавляет задержку перед удалением метки на карте. Работает только в сочетании с <<1>> или <<2>>. Это не будет работать, если вы выбрали опцию <<3>> или откроете карту, поскольку она обновит все метки.", ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2))),
}

SafeStrings(strings)