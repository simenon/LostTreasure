local function SafeStrings(strings)
	for stringId, stringValue in pairs(strings) do
		SafeAddString(_G[stringId], stringValue, 0)
	end
	ZO_ClearTable(strings)
end

local strings = {
	SI_LOST_TREASURE_TREASURE_MAPS = "Schatzkarten",
	SI_LOST_TREASURE_SURVEY_REPORTS = "Fundberichte",

	SI_LOST_TREASURE_COMPARE_TREASURE = "schatzkarte:",
	SI_LOST_TREASURE_COMPARE_SURVEY = "fundbericht:",

	SI_LOST_TREASURE_SHOW_ON_MAP = "Auf Karte anzeigen",
	SI_LOST_TREASURE_SHOW_ON_MAP_TT = "Zeigt die Symbole auf der Karte an.",
	SI_LOST_TREASURE_SHOW_ON_COMPASS = "Im Kompass anzeigen",
	SI_LOST_TREASURE_SHOW_ON_COMPASS_TT = "Zeigt die Symbole im Kompass an.",
	SI_LOST_TREASURE_PIN_ICON = "Symbol",
	SI_LOST_TREASURE_PIN_ICON_TT = "Wählt Euer gewünschtes Symbol aus.",
	SI_LOST_TREASURE_PIN_SIZE = "Symbolgrösse",
	SI_LOST_TREASURE_PIN_SIZE_TT = "Wählt die Symbolgrösse aus, welche auf der Karte angezeigt werden.",
	SI_LOST_TREASURE_MARK_OPTION = "Markierungsoptionen",
	SI_LOST_TREASURE_MARK_OPTION_TT = "Legt fest, wann ein Symbol auf der Karte und dem Kompass sichtbar sein soll.",
	SI_LOST_TREASURE_MARK_OPTION1_TT = "Zeigt ein Symbol erst nach dem Öffnen einer Schatzkarte oder einem Fundbericht an.",
	SI_LOST_TREASURE_MARK_OPTION2_TT = "Zeigt nur Symbole von Schatzkarten oder Fundberichte an, welche sich in Eurem Inventar befinden.",
	SI_LOST_TREASURE_MARK_OPTION3_TT = "Zeigt alle Symbole an, unabhängig davon, ob sich diese in Eurem Inventar befinden.",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1 = "beim Benutzen",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2 = "alle im Inventar",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3 = "alle Standorte",
	SI_LOST_TREASURE_PIN_LEVEL = "Kartenebene",
	SI_LOST_TREASURE_PIN_LEVEL_TT = "Je grösser die Zahl, desto höher die Ebene. Je höher eine Ebene ist, desto mehr andere Kartensymbole werden überdeckt.",
	SI_LOST_TREASURE_MARKER_DELAY = "Verbergen verzögern",

	SI_LOST_TREASURE_SHOW_MINIMAP_HEADER = "Kleine Karte",
	SI_LOST_TREASURE_SHOW_MINIMAP = "Kleine Karte anzeigen",
	SI_LOST_TREASURE_SHOW_MINIMAP_TT = "Zeigt Euch eine kleine Karte an, nachdem Ihr eine Schatzkarte oder einen Fundbericht geöffnet habt.",
	SI_LOST_TREASURE_SHOW_MINIMAP_SIZE = "Kartengrösse",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY = "Verbergen verzögern",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT = "Verzögerung (in Sekunden) vor dem Ausblenden der kleinen Karte, nachdem Ihr den Schatz oder Fund aufgenommen habt.",

	SI_LOST_TREASURE_NOTIFICATION_MESSAGE = "Es wurden neue unbekannte Daten gefunden.",
	SI_LOST_TREASURE_NOTIFICATION_NOTE = "Teilt Eure Daten mit uns. Um einen Bericht einzureichen benötigt Ihr ein ESOUI.com-Konto. Ihr müsst Euch zuerst einloggen, bevor Ihr auf Akzeptieren klickt!",

	SI_LOST_TREASURE_DEBUG = "Debug aktivieren",
	SI_LOST_TREASURE_DEBUG_TT = "Aktiviert die Debug-Funktion, um potenzielle Probleme von dieser Erweiterung zu finden. Diese Einstellung wird nach dem Ausloggen zurückgesetzt.",
}

SafeStrings(strings)

-- we have to generate this later, because the options have to be defined first
strings = {
	SI_LOST_TREASURE_MARKER_DELAY_TT = zo_strformat("Wenn die Markierungsoption <<1>> oder <<2>> ausgewählt ist, könnt Ihr hier die Verzögerung (in Sekunden) einstellen, bevor das Karten-/Kompasssymbol verschwindet. Dies funktioniert jedoch nicht mit Markierungsoption <<3>> oder wenn ihr die Weltkarte öffnet, da dann alle Kartensymbole sofort aktualisiert werden.", ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3))),
}

SafeStrings(strings)