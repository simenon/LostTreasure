local function SafeStrings(strings)
	for stringId, stringValue in pairs(strings) do
		SafeAddString(_G[stringId], stringValue, 0)
	end
	ZO_ClearTable(strings)
end

local strings = {
	SI_LOST_TREASURE_TREASURE_MAPS = "Cartes au trésor",
	SI_LOST_TREASURE_SURVEY_REPORTS = "Repérages",

	SI_LOST_TREASURE_COMPARE_TREASURE = "carte au trésor",
	SI_LOST_TREASURE_COMPARE_SURVEY = "repérages",

	SI_LOST_TREASURE_SHOW_ON_MAP = "Affichage de la carte",
	SI_LOST_TREASURE_SHOW_ON_MAP_TT = "Afficher les marqueurs sur la carte.",
	SI_LOST_TREASURE_SHOW_ON_COMPASS = "Affichage de la boussole",
	SI_LOST_TREASURE_SHOW_ON_COMPASS_TT = "Afficher les marqueurs sur la boussole.",
	SI_LOST_TREASURE_PIN_ICON = "Symbole",
	SI_LOST_TREASURE_PIN_ICON_TT = "Choisissez le symbole à utiliser pour les marqueurs.",
	SI_LOST_TREASURE_PIN_SIZE = "Taille",
	SI_LOST_TREASURE_PIN_SIZE_TT = "Choisissez la taille de marqueur sur la carte.",
	SI_LOST_TREASURE_MARK_OPTION = "Options des marqueurs",
	SI_LOST_TREASURE_MARK_OPTION_TT = "Déterminer quand afficher les marqueurs sur la carte et la boussole.",
	SI_LOST_TREASURE_MARK_OPTION1_TT = "Afficher les marqueurs uniquement après avoir ouvert une carte au trésor ou un repérage.",
	SI_LOST_TREASURE_MARK_OPTION2_TT = "Afficher les marqueurs des cartes au trésor et des repérages qui se trouvent dans votre inventaire.",
	SI_LOST_TREASURE_MARK_OPTION3_TT = "Afficher tout les marqueurs sans tenir compte de votre inventaire.",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1 = "à l'utilisation",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2 = "Carte dans l'inventaire",
	SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3 = "Tous",
	SI_LOST_TREASURE_PIN_LEVEL = "Niveau des marqueurs",
	SI_LOST_TREASURE_PIN_LEVEL_TT = "Un niveau supérieur positionne le marqueur au-dessus des autres. Augmenter cette valeur si le marqueur est caché par un autre.",
	SI_LOST_TREASURE_MARKER_DELAY = "Délai de masquage",

	SI_LOST_TREASURE_SHOW_MINIMAP_HEADER = "Mini-Carte",
	SI_LOST_TREASURE_SHOW_MINIMAP = "Afficher la mini-carte",
	SI_LOST_TREASURE_SHOW_MINIMAP_TT = "Affiche une mini-carte lorsque une carte est utilisée depuis l'inventaire.",
	SI_LOST_TREASURE_SHOW_MINIMAP_SIZE = "Taille de la carte",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY = "Délai de masquage",
	SI_LOST_TREASURE_SHOW_MINIMAP_DELAY_TT = "Délai (en secondes) après lequel masquer la mini-Carte une fois le trésor ou le repérage récupéré.",

	SI_LOST_TREASURE_NOTIFICATION_MESSAGE = "De nouvelles données ont été trouvées.",
	SI_LOST_TREASURE_NOTIFICATION_NOTE = "SVP partagez les nouvelles données de repérages et cartes aux trésor en acceptant cette notification. Vous devez avoir un compte ESOUI pour remplir ce rapport de bug.",
}

SafeStrings(strings)

-- we have to generate this later, because the options have to be defined first
strings = {
	SI_LOST_TREASURE_MARKER_DELAY_TT = zo_strformat("Ajoute un délai avant d'effacer un emplacement marqué sur la carte. Marche seulement avec <<1>> ou <<2>>. Cette option ne fonctionne pas si vous avez sélectionné l'option <<3>> ou ouvert la carte.", ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION1)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION2)), ZO_SELECTED_TEXT:Colorize(GetString(SI_LOST_TREASURE_MARK_MAP_MENU_OPTION3))),
}

SafeStrings(strings)