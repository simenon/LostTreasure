-- Spanish Localization by Inval1d (https://www.esoui.com/forums/member.php?userid=33630)

local function SafeStrings(strings)
	for stringId, stringValue in pairs(strings) do
		SafeAddString(_G[stringId], stringValue, 0)
	end
	ZO_ClearTable(strings)
end

local strings = {
	SI_LOST_TREASURE_BUGREPORT_PICKUP_MESSAGE = table.concat(message, "\n"),
	SI_LOST_TREASURE_BUGREPORT_PICKUP_TITLE = "New map found v%d id%d %s",
	SI_LOST_TREASURE_BUGREPORT_PICKUP_NO_MAP = "no map opened",

	SI_LOST_TREASURE_TREASURE_MAPS = "Mapas del tesoro",
	SI_LOST_TREASURE_SURVEY_REPORTS = "Informes de prospección",

	SI_LOST_TREASURE_COMPARE_TREASURE = "mapa del tesoro",
	SI_LOST_TREASURE_COMPARE_SURVEY = "prospección:",

	SI_LOST_TREASURE_SHOW_ON_MAP = "Mostrar en mapa",
	SI_LOST_TREASURE_SHOW_ON_MAP_TT = "Muestra los marcadores en el mapa del jugador.",
	SI_LOST_TREASURE_SHOW_ON_COMPASS = "Mostrar en brújula",
	SI_LOST_TREASURE_SHOW_ON_COMPASS_TT = "Muestra los marcadores en la brújula.",
	SI_LOST_TREASURE_PIN_ICON = "Icono",
	SI_LOST_TREASURE_PIN_ICON_TT = "Define los iconos de los marcadores.",
	SI_LOST_TREASURE_PIN_SIZE = "Tamaño",
	SI_LOST_TREASURE_PIN_SIZE_TT = "Define el tamaño de los iconos en el mapa del jugador.",
	SI_LOST_TREASURE_MARK_OPTION = "Aparición del marcador",
	SI_LOST_TREASURE_MARK_OPTION_TT = "Define cuando un marcador debería ser visible en el mapa del jugador y en la brújula.",
	SI_LOST_TREASURE_MARK_OPTION1_TT = "Muestra un marcador sólo tras abrir un mapa del tesoro o informe de prospección.",
	SI_LOST_TREASURE_MARK_OPTION2_TT = "Muestra los marcadores de los mapas del tesoro e informes de prospección en tu inventario.",
	SI_LOST_TREASURE_MARK_OPTION3_TT = "Muestra todos los marcadores sin importar si tienes lo mapas del tesoro o informes de prospección en tu inventario.",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1 = "al usar",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2 = "en inventario",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3 = "todos",
	SI_LOST_TREASURE_PIN_LEVEL = "Nivel del marcador",
	SI_LOST_TREASURE_PIN_LEVEL_TT = "Un nivel más alto mostrará el marcador sobre otros marcadores con niveles más bajos. Incrementa este valor si los marcadores son obstruidos por otros.",
	SI_LOST_TREASURE_MARKER_DELAY = "Tiempo de desaparición",

	SI_LOST_TREASURE_SHOW_MINIMAP_HEADER = "Minimapa",
	SI_LOST_TREASURE_SHOW_MINIMAP = "Mostrar minimapa",
	SI_LOST_TREASURE_SHOW_MINIMAP_TT = "Muestra un minimapa tras leer un mapa del tesoro o informe de prospección.",
	SI_LOST_TREASURE_SHOW_MINIMAP_SIZE = "Tamaño de minimapa",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY = "Tiempo de desaparición",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT = "Tiempo (en segundos) en el que se ocultará un minimapa una vez hayas recogido el tesoro o prospección.",

	SI_LOST_TREASURE_NOTIFICATION_MESSAGE = "Has hallado nueva información.",
	SI_LOST_TREASURE_NOTIFICATION_NOTE = "Por favor, comparte tus mapas del tesoro o prospecciones desonocidas aceptando esta notificación. Necesitarás una cuenta de ESOUI.com para informar este error.",
}

SafeStrings(strings)

-- we have to generate this later, because the options have to be defined first
strings = {
	SI_LOST_TREASURE_MARKER_DELAY_TT = zo_strformat("Añade un tiempo de retraso antes de eliminar una ubicación marcada en el mapa. Esto sólo funciona en conjunto con <<1>> o <<2>>. No funcionará si tienes la opción <<3>> o si abres los mapas, pues esto volverá a mostrar los marcadores.", ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3))),
}

SafeStrings(strings)