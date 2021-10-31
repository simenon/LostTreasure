-- Japanese Localization by Calamath

local function SafeStrings(strings)
	for stringId, stringValue in pairs(strings) do
		SafeAddString(_G[stringId], stringValue, 0)
	end
	ZO_ClearTable(strings)
end

local strings = {
	SI_LOST_TREASURE_TREASURE_MAPS = "宝の地図",
	SI_LOST_TREASURE_SURVEY_REPORTS = "調査報告",

	SI_LOST_TREASURE_COMPARE_TREASURE = "宝の地図",
	SI_LOST_TREASURE_COMPARE_SURVEY = "調査報告:",

	SI_LOST_TREASURE_SHOW_ON_MAP = "マップに表示",
	SI_LOST_TREASURE_SHOW_ON_MAP_TT = "プレイヤーマップにピンを表示する",
	SI_LOST_TREASURE_SHOW_ON_COMPASS = "コンパスに表示",
	SI_LOST_TREASURE_SHOW_ON_COMPASS_TT = "コンパスにピンを表示する",
	SI_LOST_TREASURE_PIN_ICON = "アイコンの選択",
	SI_LOST_TREASURE_PIN_ICON_TT = "ピンのアイコンを選択する",
	SI_LOST_TREASURE_PIN_SIZE = "サイズ",
	SI_LOST_TREASURE_PIN_SIZE_TT = "プレイヤーマップ上のピンのサイズを選択する",
	SI_LOST_TREASURE_MARK_OPTION = "表示オプション",
	SI_LOST_TREASURE_MARK_OPTION_TT = "プレーヤーマップとコンパスにピンをいつ表示するか選択する",
	SI_LOST_TREASURE_MARK_OPTION1_TT = "宝の地図や調査報告を開いた後のみ、ピンを表示する",
	SI_LOST_TREASURE_MARK_OPTION2_TT = "インベントリにある宝の地図や調査報告のピンを全て表示する",
	SI_LOST_TREASURE_MARK_OPTION3_TT = "インベントリにあるかどうかに関わらず、全てのピンを表示する",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1 = "使用中のみ",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2 = "インベントリ内の全て",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3 = "すべての場所",
	SI_LOST_TREASURE_PIN_LEVEL = "マップピンのレベル（レイヤー）",
	SI_LOST_TREASURE_PIN_LEVEL_TT = "高いレベルのピンほど、低いレベルのピンより上層に描画されます。ピンが他のピンによって隠れている場合は、この値を増やします",
	SI_LOST_TREASURE_MARKER_DELAY = "非表示までの待機時間",

	SI_LOST_TREASURE_SHOW_MINIMAP_HEADER = "ミニ宝地図",
	SI_LOST_TREASURE_SHOW_MINIMAP = "ミニ宝地図を表示",
	SI_LOST_TREASURE_SHOW_MINIMAP_TT = "宝の地図または調査報告を使用した際に、ミニ宝地図（宝の地図の絵）のウィンドウを表示する",
	SI_LOST_TREASURE_SHOW_MINIMAP_SIZE = "ミニ宝地図のサイズ",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY = "非表示までの待機時間",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT = "宝の地図や調査報告でアイテムを獲得した後、ミニ宝地図を非表示にするまでの待機時間［秒］",

	-- SI_LOST_TREASURE_NOTIFICATION_MESSAGE = "新しい未知のデータが見つかりました。", -- not supported
	-- SI_LOST_TREASURE_NOTIFICATION_NOTE = "", -- not supported
}

SafeStrings(strings)

-- we have to generate this later, because the options have to be defined first
strings = {
	SI_LOST_TREASURE_MARKER_DELAY_TT = zo_strformat("マップ上に表示されたピンを非表示にするまでの待機時間を設定します。この項目は表示オプションで「<<1>>」か「<<2>>」を選択したときのみ有功です。表示オプションで「<<3>>」を選択したときや、マップを開いたときには全てのピンが再表示されるため無効です。", ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3))),
}

SafeStrings(strings)