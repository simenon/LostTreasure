local LostTreasure = LostTreasure

--[[
How to get subZone pins:

Replace *X* and *Y* with the coordinates of the data below from zone.
/script PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_TYPE_LOCATION_CENTERED, *X*, *Y*)

Then swap to subZone and use this command
/script d(string.format("mapId %d, mapName %s, X %.4f, Y %.4f", GetCurrentMapId(), GetMapName(), GetMapPlayerWaypoint()))
]]

LostTreasure.LOST_TREASURE_DATA = {
-- Khenarthi's Roost
	[258] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.6119, 0.7579, "treasuremap_khenarthi_01", 43695 }, -- Khenarthi's Roost Treasure Map I
			{ 0.2254, 0.3140, "treasuremap_khenarthi_02", 43696 }, -- Khenarthi's Roost Treasure Map II
			{ 0.4102, 0.5848, "treasuremap_khenarthi_03", 43697 }, -- Khenarthi's Roost Treasure Map III
			{ 0.7739, 0.3376, "treasuremap_khenarthi_04", 43698 }, -- Khenarthi's Roost Treasure Map IV
			{ 0.6168, 0.8328, "treasuremap_ce_aldmeri_khenarthi_01a", 44939 }, -- Khenarthi's Roost CE Treasure Map I
			{ 0.3990, 0.3665, "treasuremap_ce_aldmeri_khenarthi_01b", 45010 }, -- Khenarthi's Roost CE Treasure Map II
		},
	},
-- Auridon
	[143] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4931, 0.8888, "treasuremap_auridon_01", 43625 }, -- Auridon Treasure Map I
			{ 0.4822, 0.6403, "treasuremap_auridon_02", 43626 }, -- Auridon Treasure Map II
			{ 0.4392, 0.5035, "treasuremap_auridon_03", 43627 }, -- Auridon Treasure Map III
			{ 0.6641, 0.4114, "treasuremap_auridon_04", 43628 }, -- Auridon Treasure Map IV
			{ 0.5002, 0.2530, "treasuremap_auridon_05", 43629 }, -- Auridon Treasure Map V
			{ 0.3360, 0.1280, "treasuremap_auridon_06", 43630 }, -- Auridon Treasure Map VI
			{ 0.6881, 0.9678, "treasuremap_ce_aldmeri_auridon_02", 44927 }, -- Auridon CE Treasure Map
			{ 0.2003, 0.2180, "glenmoral_weapon_auridon_map", 153640 }, -- Glenmoril Wyrd Treasure Map: Auridon
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.4085, 0.7007, "auridon_survey_clothier", 57738 }, -- Clothier Survey: Auridon
			{ 0.5451, 0.3001, "auridon_survey_alchemist", 57744 }, -- Alchemist Survey: Auridon
			{ 0.4449, 0.2856, "auridon_survey_enchanter", 57733 }, -- Enchanter Survey: Auridon
			{ 0.5455, 0.4624, "auridon_survey_woodworker", 57741 }, -- Woodworker Survey: Auridon
			{ 0.6359, 0.6950, "auridon_survey_blacksmith", 57687 }, -- Blacksmith Survey: Auridon
			{ 0.3992, 0.6107, nil, 139422 }, -- Jewelry Crafting Survey: Auridon
		},
	},
	-- SubPin: Firsthold
	[540] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.8025, 0.1482, "treasuremap_auridon_06", 43630 }, -- Auridon Treasure Map VI
		},
	},
	-- SubPin: Vulkhel Guard
	[243] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.8160, 0.729, "treasuremap_ce_aldmeri_auridon_02", 44927 }, -- Auridon CE Treasure Map
		},
	},
-- Grahtwood
	[9] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.3951, 0.6749, "treasuremap_grahtwood_01", 43631 }, -- Grahtwood Treasure Map I
			{ 0.6496, 0.4778, "treasuremap_grahtwood_02", 43632 }, -- Grahtwood Treasure Map II
			{ 0.6292, 0.3811, "treasuremap_grahtwood_03", 43633 }, -- Grahtwood Treasure Map III
			{ 0.4734, 0.3406, "treasuremap_grahtwood_04", 43634 }, -- Grahtwood Treasure Map IV
			{ 0.3550, 0.3562, "treasuremap_grahtwood_05", 43635 }, -- Grahtwood Treasure Map V
			{ 0.4699, 0.4724, "treasuremap_grahtwood_06", 43636 }, -- Grahtwood Treasure Map VI
			{ 0.3128, 0.6006, "treasuremap_ce_aldmeri_grahtwood_03", 44937 }, -- Grahtwood CE Treasure Map
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.7674, 0.4693, "grahtwood_survey_blacksmith", 57747 }, -- Blacksmith Survey: Grahtwood
			{ 0.3140, 0.5828, "grahtwood_survey_enchanter", 57750 }, -- Enchanter Survey: Grahtwood
			{ 0.4578, 0.7874, "grahtwood_survey_clothier", 57754 }, -- Clothier Survey: Grahtwood
			{ 0.6120, 0.3808, "grahtwood_survey_alchemist", 57771 }, -- Alchemist Survey: Grahtwood
			{ 0.4258, 0.2649, "grahtwood_survey_woodworker", 57816 }, -- Woodworker Survey: Grahtwood
			{ 0.3903, 0.3928, nil, 139425 }, -- Jewelry Crafting Survey: Grahtwood
		},
	},
	-- SubPin: Eldenroot
	[445] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.8862, 0.4054, "treasuremap_grahtwood_02", 43632 }, -- Grahtwood Treasure Map II
		},
	},
-- Greenshade
	[300] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.6543, 0.8344, "treasuremap_greenshade_01", 43637 }, -- Greenshade Treasure Map I
			{ 0.7222, 0.7418, "treasuremap_greenshade_02", 43638 }, -- Greenshade Treasure Map II
			{ 0.3636, 0.5055, "treasuremap_greenshade_03", 43639 }, -- Greenshade Treasure Map III
			{ 0.3405, 0.3237, "treasuremap_greenshade_04", 43640 }, -- Greenshade Treasure Map IV
			{ 0.2502, 0.1494, "treasuremap_greenshade_05", 43641 }, -- Greenshade Treasure Map V
			{ 0.5970, 0.3832, "treasuremap_greenshade_06", 43642 }, -- Greenshade Treasure Map VI
			{ 0.5931, 0.8112, "treasuremap_ce_aldmeri_greenshade_04", 44938 }, -- Greenshade CE Treasure Map
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.5563, 0.3957, "greenshade_survey_clothier", 57757 }, -- Clothier Survey: Greenshade
			{ 0.7642, 0.8266, "greenshade_survey_alchemist", 57774 }, -- Alchemist Survey: Greenshade
			{ 0.5990, 0.6273, "greenshade_survey_blacksmith", 57788 }, -- Blacksmith Survey: Greenshade
			{ 0.4980, 0.2903, "greenshade_survey_enchanter", 57802 }, -- Enchanter Survey: Greenshade
			{ 0.2991, 0.8134, "greenshade_survey_woodworker", 57819 }, -- Woodworker Survey: Greenshade
			{ 0.2309, 0.4013, "greenshade_survey_jewelry", 139427}-- Jewelry Crafting Survey: Greenshade
		},
	},
-- Malabal Tor
	[22] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2029, 0.4994, "treasuremap_malabaltor_01", 43643 }, -- Malabal Tor Treasure Map I
			{ 0.0537, 0.4782, "treasuremap_malabaltor_02", 43644 }, -- Malabal Tor Treasure Map II
			{ 0.5015, 0.6817, "treasuremap_malabaltor_03", 43645 }, -- Malabal Tor Treasure Map III
			{ 0.6534, 0.7034, "treasuremap_malabaltor_04", 43646 }, -- Malabal Tor Treasure Map IV
			{ 0.7995, 0.2861, "treasuremap_malabaltor_05", 43647 }, -- Malabal Tor Treasure Map V
			{ 0.6623, 0.2307, "treasuremap_malabaltor_06", 43648 }, -- Malabal Tor Treasure Map VI
			{ 0.1238, 0.5252, "treasuremap_ce_aldmeri_malbator_05", 44940 }, -- Malabal Tor CE Treasure Map
			{ 0.8250, 0.4460, "glenmoral_weapon_malabaltor_map", 153644 }, --Glenmoril Wyrd Treasure Map: Malabal Tor
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.8025, 0.1670, "malabaltor_survey_alchemist", 57777 }, -- Alchemist Survey: Malabal Tor
			{ 0.2774, 0.6270, "malabaltor_survey_clothier", 57760 }, -- Clothier Survey: Malabal Tor
			{ 0.8326, 0.4942, "malabaltor_survey_blacksmith", 57791 }, -- Blacksmith Survey: Malabal Tor
			{ 0.5845, 0.7977, "malabaltor_survey_enchanter", 57805 }, -- Enchanter Survey: Malabal Tor
			{ 0.5850, 0.5865, "malabaltor_survey_woodworker", 57822 }, -- Woodworker Survey: Malabal Tor
			{ 0.4135, 0.6588, "malabaltor_survey_jewelry", 139430}-- Jewelry Crafting Survey: Malabal Tor
		},
	},
	-- SubPin: Velynharbor
	[275] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2078, 0.3602, "treasuremap_malabaltor_02", 43644 }, -- Malabal Tor Treasure Map II
			{ 0.5132, 0.5649, "treasuremap_ce_aldmeri_malbator_05", 44940 }, -- Malabal Tor CE Treasure Map
		},
	},
-- Reaper’s March
	[256] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.3786, 0.4317, "treasuremap_reapersmarch_01", 43649 }, -- Reaper's March Treasure Map I
			{ 0.3343, 0.1275, "treasuremap_reapersmarch_02", 43650 }, -- Reaper's March Treasure Map II
			{ 0.2705, 0.6514, "treasuremap_reapersmarch_03", 43651 }, -- Reaper's March Treasure Map III
			{ 0.4413, 0.6922, "treasuremap_reapersmarch_04", 43652 }, -- Reaper's March Treasure Map IV
			{ 0.5507, 0.4163, "treasuremap_reapersmarch_05", 43653 }, -- Reaper's March Treasure Map V
			{ 0.6686, 0.2402, "treasuremap_reapersmarch_06", 43654 }, -- Reaper's March Treasure Map VI
			{ 0.4087, 0.5434, "treasuremap_ce_aldmeri_reapersmarch_06", 44941 }, -- Reaper's March CE Treasure Map
			{ 0.2980, 0.1540, "glenmoral_weapon_reapersmarch_map", 153645 }, -- Glenmoril Wyrd Treasure Map: Reaper's March
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.3314, 0.7321, "reapersmarch_survey_enchanter", 57808 }, -- Enchanter Survey: Reaper's March
			{ 0.5924, 0.5187, "reapersmarch_survey_clothier", 57763 }, -- Clothier Survey: Reaper's March
			{ 0.3000, 0.3616, "reapersmarch_survey_alchemist", 57780 }, -- Alchemist Survey: Reaper's March
			{ 0.6450, 0.2200, "reapersmarch_survey_blacksmith", 57793 }, -- Blacksmith Survey: Reaper's March
			{ 0.4289, 0.8485, "reapersmarch_survey_woodworker", 57825 }, -- Woodworker Survey: Reaper's March
			{ 0.2470, 0.5320, "reapersmarch_survey_jewelry", 139432 }, -- Jewelry Crafting Survey: Reaper's March
		},
	},
	-- SubPin:  Rawlkha
	[312] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.0751, 0.4507, "treasuremap_ce_aldmeri_reapersmarch_06", 44941 }, -- Reaper's March CE Treasure Map
		},
	},
-- Bleakrock Isle
	[74] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4389, 0.4077, "treasuremap_bleakrock_001", 43699 }, -- Bleakrock Treasure Map I
			{ 0.4264, 0.2203, "treasuremap_bleakrock_002", 43700 }, -- Bleakrock Treasure Map II
			{ 0.4630, 0.6490, "treasuremap_ce_ebonheart_bleakrock_01a", 44931 }, -- Bleakrock CE Treasure Map
		},
	},
	-- SubPin: Bleakrock Isle, Bleackrock Village
	[8] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.5540, 0.6710, "treasuremap_ce_ebonheart_bleakrock_01a", 44931 }, -- Bleakrock CE Treasure Map
		},
	},
-- Bal Foyen
	[75] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.6007, 0.7090, "treasuremap_balfoyen_001", 43701 }, -- Bal Foyen Treasure Map I
			{ 0.2400, 0.5300, "treasuremap_balfoyen_002", 43702 }, -- Bal Foyen Treasure Map II
			{ 0.5200, 0.4200, "treasuremap_ce_ebonheart_balfoyen_01b", 44928 }, -- Bal Foyen CE Treasure Map
		},
	},
--Stonefalls
	[7] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.7950, 0.5759, "treasuremap_stonefalls_001", 43655 }, -- Stonefalls Treasure Map I
			{ 0.6040, 0.4904, "treasuremap_stonefalls_002", 43656 }, -- Stonefalls Treasure Map II
			{ 0.4715, 0.5922, "treasuremap_stonefalls_003", 43657 }, -- Stonefalls Treasure Map III
			{ 0.1796, 0.4519, "treasuremap_stonefalls_004", 43658 }, -- Stonefalls Treasure Map IV
			{ 0.1954, 0.5506, "treasuremap_stonefalls_005", 43659 }, -- Stonefalls Treasure Map V
			{ 0.3621, 0.7019, "treasuremap_stonefalls_006", 43660 }, -- Stonefalls Treasure Map VI
			{ 0.5200, 0.6129, "treasuremap_ce_ebonheart_stonefalls_02", 44944 }, -- Stonefalls CE Treasure Map
			{ 0.8230, 0.4010, "glenmoral_weapon_stonefalls_map", 153648 }, -- Glenmoril Wyrd Treasure Map: Stonefalls
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.6718, 0.5741, "stonefalls_survey_blacksmith", 57737 }, -- Blacksmith Survey: Stonefalls
			{ 0.3143, 0.4365, "stonefalls_survey_clothier", 57740 }, -- Clothier Survey: Stonefalls
			{ 0.1590, 0.5593, "stonefalls_survey_woodworker", 57743 }, -- Woodworker Survey: Stonefalls
			{ 0.5591, 0.3908, "stonefalls_survey_alchemist", 57746 }, -- Alchemist Survey: Stonefalls
			{ 0.7502, 0.5841, "stonefalls_survey_enchanter", 57735 }, -- Enchanter Survey: Stonefalls
			{ 0.6835, 0.6396, "stonefalls_survey_jewelry", 139424 }, -- Jewelry Crafting Survey: Stonefalls
		},
	},
	-- SubPin: Ebonheart
	[511] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.7497, 0.5630, "treasuremap_stonefalls_002", 43656 }, -- Stonefalls Treasure Map II
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.5407, 0.0913, "stonefalls_survey_alchemist", 57746 }, -- Alchemist Survey: Stonefalls
		},
	},
-- Deshaan
	[13] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2599, 0.5507, "treasuremap_deshaan_001", 43661 }, -- Deshaan Treasure Map I
			{ 0.1845, 0.4724, "treasuremap_deshaan_002", 43662 }, -- Deshaan Treasure Map II
			{ 0.4631, 0.4056, "treasuremap_deshaan_003", 43663 }, -- Deshaan Treasure Map III
			{ 0.7592, 0.5618, "treasuremap_deshaan_004", 43664 }, -- Deshaan Treasure Map IV
			{ 0.8996, 0.5498, "treasuremap_deshaan_005", 43665 }, -- Deshaan Treasure Map V
			{ 0.7932, 0.5098, "treasuremap_deshaan_006", 43666 }, -- Deshaan Treasure Map VI
			{ 0.3529, 0.6400, "treasuremap_ce_ebonheart_deshaan_03", 44934 }, -- Deshaan CE Treasure Map
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.4760, 0.4204, "deshaan_survey_blacksmith", 57748 }, -- Blacksmith Survey: Deshaan
			{ 0.7877, 0.4082, "deshaan_survey_enchanter", 57751 }, -- Enchanter Survey: Deshaan
			{ 0.2380, 0.4804, "deshaan_survey_clothier", 57755 }, -- Clothier Survey: Deshaan
			{ 0.1484, 0.4960, "deshaan_survey_alchemist", 57772 }, -- Alchemist Survey: Deshaan
			{ 0.6370, 0.5503, "deshaan_survey_woodworker", 57817 }, -- Woodworker Survey: Deshaan
			{ 0.4856, 0.6163, "deshaan_survey_jewelry", 139426 }, -- Jewelry Crafting Survey: Deshaan
		},
	},
	-- SubPin: Narsis
	[537] = {
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.2314, 0.2097, "deshaan_survey_alchemist", 57772 }, -- Alchemist Survey: Deshaan
		},
	},
-- Shadowfen
	[26] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.3697, 0.1501, "treasuremap_shadowfen_01", 43667 }, -- Shadowfen Treasure Map I
			{ 0.7088, 0.3925, "treasuremap_shadowfen_02", 43668 }, -- Shadowfen Treasure Map II
			{ 0.7040, 0.7014, "treasuremap_shadowfen_03", 43669 }, -- Shadowfen Treasure Map III
			{ 0.6093, 0.6119, "treasuremap_shadowfen_04", 43670 }, -- Shadowfen Treasure Map IV
			{ 0.4060, 0.4690, "treasuremap_shadowfen_05", 43671 }, -- Shadowfen Treasure Map V
			{ 0.2383, 0.5640, "treasuremap_shadowfen_06", 43672 }, -- Shadowfen Treasure Map VI
			{ 0.6426, 0.4554, "treasuremap_ce_ebonheart_shadowfen_04", 44943 }, -- Shadowfen CE Treasure Map
			{ 0.4830, 0.7010, "glenmoral_weapon_shadowfen_map", 153647 }, -- Glenmoril Wyrd Treasure Map: Shadowfen
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.7517, 0.4308, "shadowfen_survey_clothier", 57758 }, -- Clothier Survey: Shadowfen
			{ 0.3584, 0.2655, "shadowfen_survey_alchemist", 57775 }, -- Alchemist Survey: Shadowfen
			{ 0.7959, 0.8522, "shadowfen_survey_blacksmith", 57789 }, -- Blacksmith Survey: Shadowfen
			{ 0.4032, 0.6982, "shadowfen_survey_enchanter", 57803 }, -- Enchanter Survey: Shadowfen
			{ 0.5804, 0.6794, "shadowfen_survey_woodworker", 57820 }, -- Woodworker Survey: Shadowfen
			{ 0.8888, 0.6867, "shadowfen_survey_jewelry", 139428 }, -- Jewelry Crafting Survey: Shadowfen
		},
	},
	-- SubPin: Alten Corimont
	[544] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.1231, 0.6281, "treasuremap_shadowfen_04", 43670 }, -- Shadowfen Treasure Map IV
		},
	},
	-- SubPin: Stormhold
	[217] = {
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{-0.1008, 0.4519, "shadowfen_survey_alchemist", 57775 }, -- Alchemist Survey: Shadowfen
		},
	},
-- Eastmarch
	[61] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4413, 0.3742, "treasuremap_eastmarch_01", 43673 }, -- Eastmarch Treasure Map I
			{ 0.3134, 0.4590, "treasuremap_eastmarch_02", 43674 }, -- Eastmarch Treasure Map II
			{ 0.4300, 0.5918, "treasuremap_eastmarch_03", 43675 }, -- Eastmarch Treasure Map III
			{ 0.3667, 0.5990, "treasuremap_eastmarch_04", 43676 }, -- Eastmarch Treasure Map IV
			{ 0.7375, 0.6607, "treasuremap_eastmarch_05", 43677 }, -- Eastmarch Treasure Map V
			{ 0.6059, 0.5391, "treasuremap_eastmarch_06", 43678 }, -- Eastmarch Treasure Map VI
			{ 0.7136, 0.5833, "treasuremap_ce_ebonheart_eastmarch_05", 44935 }, -- Eastmarch CE Treasure Map
			{ 0.4310, 0.5870, "glenmoral_weapon_eastmarch_map", 153643 }, -- Glenmoril Wyrd Treasure Map: Eastmarch
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.6800, 0.6125, "eastmarch_survey_clothier", 57761 }, -- Clothier Survey: Eastmarch
			{ 0.3796, 0.6045, "eastmarch_survey_alchemist", 57778 }, -- Alchemist Survey: Eastmarch
			{ 0.3533, 0.2886, "eastmarch_survey_blacksmith", 57801 }, -- Blacksmith Survey: Eastmarch
			{ 0.5306, 0.4149, "eastmarch_survey_enchanter", 57807 }, -- Enchanter Survey: Eastmarch
			{ 0.4524, 0.4977, "eastmarch_survey_woodworker", 57823 }, -- Woodworker Survey: Eastmarch
			{ 0.3925, 0.6870, "eastmarch_survey_jewelry", 139440 }, -- Jewelry Crafting Survey: Eastmarch
		},
	},
-- The Rift
	[125] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.7412, 0.3782, "treasuremap_therift_01", 43679 }, -- The Rift Treasure Map I
			{ 0.4715, 0.4337, "treasuremap_therift_02", 43680 }, -- The Rift Treasure Map II
			{ 0.2274, 0.3631, "treasuremap_therift_03", 43681 }, -- The Rift Treasure Map III
			{ 0.4791, 0.5563, "treasuremap_therift_04", 43682 }, -- The Rift Treasure Map IV
			{ 0.8385, 0.5716, "treasuremap_therift_05", 43683 }, -- The Rift Treasure Map V
			{ 0.7514, 0.6394, "treasuremap_therift_06", 43684 }, -- The Rift Treasure Map VI
			{ 0.5813, 0.6096, "treasuremap_ce_ebonheart_rift_06", 44947 }, -- The Rift CE Treasure Map
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.6293, 0.3578, "therift_survey_clothier", 57765 }, -- Clothier Survey: The Rift
			{ 0.4170, 0.4220, "therift_survey_alchemist", 57782 }, -- Alchemist Survey: The Rift
			{ 0.7141, 0.5586, "therift_survey_blacksmith", 57794 }, -- Blacksmith Survey: The Rift
			{ 0.1515, 0.2967, "therift_survey_enchanter", 57809 }, -- Enchanter Survey: The Rift
			{ 0.4975, 0.3367, "therift_survey_woodworker", 57826 }, -- Woodworker Survey: The Rift
			{ 0.8035, 0.4203, "therift_survey_jewelry", 139433 }, -- Jewelry Crafting Survey: The Rift
		},
	},
	-- SubPin: Riften
	[198] = {
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.7639, 0.9867, "therift_survey_blacksmith", 57794 }, -- Blacksmith Survey: The Rift
		},
	},
	-- SubPin: Nimalten
	[543] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4156, 0.3237, "treasuremap_therift_03", 43681 }, -- The Rift Treasure Map III
		},
	},
-- Stros M'Kai
	[201] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.5458, 0.6406, "treasuremap_strosmkai_001", 43691 }, -- Stros M'Kai Treasure Map I
			{ 0.0980, 0.6130, "treasuremap_strosmkai_002", 43692 }, -- Stros M'Kai Treasure Map II
			{ 0.7000, 0.3300, "treasuremap_ce_daggerfall_stros_01a", 44946 }, -- Stros M'Kai CE Treasure Map
		},
	},
	-- SubPin: Port Hunding
	[530] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.6013, 0.2807, "treasuremap_ce_daggerfall_stros_01a", 44946 }, -- Stros M'Kai CE Treasure Map
		},
	},
-- Betnikh
	[227] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.1735, 0.3136, "treasuremap_betnikh_001", 43693 }, -- Betnikh Treasure Map I
			{ 0.5680, 0.8759, "treasuremap_betnikh_002", 43694 }, -- Betnikh Treasure Map II
			{ 0.4551, 0.4360, "treasuremap_ce_daggerfall_betnikh_01b", 44930 }, -- Betnikh CE Treasure Map
		},
	},
	-- SubPin: Stonetooth Fortress
	[649] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2410, 0.3252, "treasuremap_ce_daggerfall_betnikh_01b", 44930 }, -- Betnikh CE Treasure Map
		},
	},
-- Glenumbra
	[1] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.5265, 0.7618, "treasuremap_glenumbra_001", 43507 }, -- Glenumbra Treasure Map I
			{ 0.4922, 0.4541, "treasuremap_glenumbra_002", 43525 }, -- Glenumbra Treasure Map II
			{ 0.6595, 0.2617, "treasuremap_glenumbra_003", 43527 }, -- Glenumbra Treasure Map III
			{ 0.7337, 0.5285, "treasuremap_glenumbra_004", 43600 }, -- Glenumbra Treasure Map IV
			{ 0.2766, 0.5282, "treasuremap_glenumbra_005", 43509 }, -- Glenumbra Treasure Map V
			{ 0.5154, 0.2558, "treasuremap_glenumbra_006", 43526 }, -- Glenumbra Treasure Map VI
			{ 0.7030, 0.4668, "treasuremap_ce_daggerfall_glenumbra_02", 44936 }, -- Glenumbra CE Treasure Map
			{ 0.6070, 0.2047, "glenmoral_weapon_daggerfall_map", 153642 }, --Glenmoril Wyrd Treasure Map: Daggerfall
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.7158, 0.3056, "glenumbra_survey_enchanter", 57734 }, -- Enchanter Survey: Glenumbra
			{ 0.4142, 0.5966, "glenumbra_survey_clothier", 57739 }, -- Clothier Survey: Glenumbra
			{ 0.6467, 0.5039, "glenumbra_survey_woodworker", 57742 }, -- Woodworker Survey: Glenumbra
			{ 0.3432, 0.4932, "glenumbra_survey_alchemist", 57745 }, -- Alchemist Survey: Glenumbra
			{ 0.3640, 0.8347, "glenumbra_survey_blacksmith", 57736 }, -- Blacksmith Survey: Glenumbra
			{ 0.2221, 0.5135, "glenumbra_survey_jewelry", 139423 }, -- Jewelry Crafting Survey: Glenumbra
		},
	},
-- Stormhaven
	[12] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2313, 0.5227, "treasuremap_stormhaven_001", 43601 }, -- Stormhaven Treasure Map I
			{ 0.2569, 0.3466, "treasuremap_stormhaven_002", 43602 }, -- Stormhaven Treasure Map II
			{ 0.4029, 0.4737, "treasuremap_stormhaven_003", 43603 }, -- Stormhaven Treasure Map III
			{ 0.4194, 0.5927, "treasuremap_stormhaven_004", 43604 }, -- Stormhaven Treasure Map IV
			{ 0.6905, 0.5019, "treasuremap_stormhaven_005", 43605 }, -- Stormhaven Treasure Map V
			{ 0.7986, 0.5197, "treasuremap_stormhaven_006", 43606 }, -- Stormhaven Treasure Map VI
			{ 0.4750, 0.4470, "treasuremap_ce_daggerfall_stormhaven_03", 44945 }, -- Stormhaven CE Treasure Map
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.3400, 0.5657, "stormhaven_survey_blacksmith", 57749 }, -- Blacksmith Survey: Stormhaven
			{ 0.3445, 0.3443, "stormhaven_survey_enchanter", 57752 }, -- Enchanter Survey: Stormhaven
			{ 0.2683, 0.3162, "stormhaven_survey_clothier", 57756 }, -- Clothier Survey: Stormhaven
			{ 0.7945, 0.5003, "stormhaven_survey_alchemist", 57773 }, -- Alchemist Survey: Stormhaven
			{ 0.5710, 0.4467, "stormhaven_survey_woodworker", 57818 }, -- Woodworker Survey: Stormhaven
			{ 0.2614, 0.4570, "stormhaven_survey_jewelry", 139408 }, -- Jewelry Crafting Survey: Stormhaven
		},
	},
-- Rivenspire
	[10] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.3285, 0.5091, "treasuremap_rivenspire_01", 43607 }, -- Rivenspire Treasure Map I
			{ 0.1774, 0.6288, "treasuremap_rivenspire_02", 43608 }, -- Rivenspire Treasure Map II
			{ 0.7175, 0.4362, "treasuremap_rivenspire_03", 43609 }, -- Rivenspire Treasure Map III
			{ 0.7206, 0.7199, "treasuremap_rivenspire_04", 43610 }, -- Rivenspire Treasure Map IV
			{ 0.7584, 0.3199, "treasuremap_rivenspire_05", 43611 }, -- Rivenspire Treasure Map V
			{ 0.4092, 0.2994, "treasuremap_rivenspire_06", 43612 }, -- Rivenspire Treasure Map VI
			{ 0.7599, 0.1621, "treasuremap_ce_daggerfall_rivenspire_04", 44942 }, -- Rivenspire CE Treasure Map
			{ 0.7060, 0.6960, "glenmoral_weapon_rivenspire_map", 153646 }, -- Glenmoril Wyrd Treasure Map: Rivenspire
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.2971, 0.6413, "rivenspire_survey_clothier", 57759 }, -- Clothier Survey: Rivenspire
			{ 0.8065, 0.3297, "rivenspire_survey_alchemist", 57776 }, -- Alchemist Survey: Rivenspire
			{ 0.6929, 0.6243, "rivenspire_survey_blacksmith", 57790 }, -- Blacksmith Survey: Rivenspire
			{ 0.6182, 0.4312, "rivenspire_survey_enchanter", 57804 }, -- Enchanter Survey: Rivenspire
			{ 0.5439, 0.6434, "rivenspire_survey_woodworker", 57821 }, -- Woodworker Survey: Rivenspire
			{ 0.6750, 0.1182, "rivenspire_survey_jewelry", 139429 }, -- Jewelry Crafting Survey: Rivenspire
		},
	},
	-- SubPin: Rivenspire, North Point
	[513] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2763, 0.1772, "treasuremap_ce_daggerfall_rivenspire_04", 44942 }, -- Rivenspire CE Treasure Map
		},
	},
-- Alik’r Desert
	[30] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.3827, 0.6997, "treasuremap_alikr_001", 43613 }, -- Alik'r Treasure Map I
			{ 0.1135, 0.5218, "treasuremap_alikr_002", 43614 }, -- Alik'r Treasure Map II
			{ 0.6292, 0.6313, "treasuremap_alikr_003", 43615 }, -- Alik'r Treasure Map III
			{ 0.5867, 0.2562, "treasuremap_alikr_004", 43616 }, -- Alik'r Treasure Map IV
			{ 0.7881, 0.5260, "treasuremap_alikr_005", 43617 }, -- Alik'r Treasure Map V
			{ 0.7205, 0.4691, "treasuremap_alikr_06", 43618 }, -- Alik'r Treasure Map VI
			{ 0.3246, 0.3679, "treasuremap_ce_daggerfall_alikr_05", 44926 }, -- Alik'r CE Treasure Map
			{ 0.8541, 0.5570, "glenmoral_weapon_alikr_map", 153639 }, -- Glenmoril Wyrd Treasure Map: Alik'r
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.6176, 0.6096, "alikr_survey_clothier", 57762 }, -- Clothier Survey: Alik'r
			{ 0.4187, 0.6318, "alikr_survey_alchemist", 57779 }, -- Alchemist Survey: Alik'r
			{ 0.1526, 0.4818, "alikr_survey_blacksmith", 57792 }, -- Blacksmith Survey: Alik'r
			{ 0.7821, 0.3621, "alikr_survey_enchanter", 57806 }, -- Enchanter Survey: Alik'r
			{ 0.5870, 0.3790, "alikr_survey_woodworker", 57824 }, -- Woodworker Survey: Alik'r
			{ 0.9007, 0.5329, "alikr_survey_jewelry", 139431 }, -- Jewelry Crafting Survey: Alik'r
		},
	},
	-- SubPin: Sentinel
	[83] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.7745, 0.0504, "treasuremap_ce_daggerfall_alikr_05", 44926 }, -- Alik'r CE Treasure Map
		},
	},
	-- SubPin: Kozanset
	[538] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2252, 0.5950, "treasuremap_alikr_06", 43618 }, -- Alik'r Treasure Map VI
		},
	},
-- Bangkorai
	[20] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4331, 0.2704, "treasuremap_bankorai_01", 43619 }, -- Bangkorai Treasure Map I
			{ 0.6146, 0.2083, "treasuremap_bankorai_02", 43620 }, -- Bangkorai Treasure Map II
			{ 0.7183, 0.3837, "treasuremap_bankorai_03", 43621 }, -- Bangkorai Treasure Map III
			{ 0.3259, 0.4556, "treasuremap_bankorai_04", 43622 }, -- Bangkorai Treasure Map IV
			{ 0.3290, 0.6930, "treasuremap_bankorai_05", 43623 }, -- Bangkorai Treasure Map V
			{ 0.6447, 0.6926, "treasuremap_bankorai_06", 43624 }, -- Bangkorai Treasure Map VI
			{ 0.6092, 0.7593, "treasuremap_ce_daggerfall_bankorai_06", 44929 }, -- Bangkorai CE Treasure Map
			{ 0.5900, 0.4000, "glenmoral_weapon_bangkorai_map", 153641 }, -- Glenmoril Wyrd Treasure Map: Bangkorai
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.5275, 0.1627, "bankorai_survey_enchanter", 57810 }, -- Enchanter Survey: Bangkorai
			{ 0.5800, 0.3761, "bankorai_survey_clothier", 57764 }, -- Clothier Survey: Bangkorai
			{ 0.3583, 0.3841, "bangkorai_survey_alchemist", 57781 }, -- Alchemist Survey: Bangkorai
			{ 0.4730, 0.6153, "bangkorai_survey_blacksmith", 57795 }, -- Blacksmith Survey: Bangkorai
			{ 0.6701, 0.7022, "bangkorai_survey_woodworker", 57827 }, -- Woodworker Survey: Bangkorai
			{ 0.4674, 0.6938, "bangkorai_survey_jewelry", 139434 }, -- Jewelry Crafting Survey: Bangkorai
		},
	},
	-- SubPin: Evermore
	[84] = {
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.1926, 0.6444, "bangkorai_survey_alchemist", 57781 }, -- Alchemist Survey: Bangkorai
		},
	},
-- Coldharbour
	[255] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4072, 0.8319, "treasuremap_coldharbour_01", 43685 }, -- Coldharbour Treasure Map I
			{ 0.4102, 0.5680, "treasuremap_coldharbour_02", 43686 }, -- Coldharbour Treasure Map II
			{ 0.6037, 0.6923, "treasuremap_coldharbour_03", 43687 }, -- Coldharbour Treasure Map III
			{ 0.7559, 0.7763, "treasuremap_coldharbour_04", 43688 }, -- Coldharbour Treasure Map IV
			{ 0.4327, 0.4552, "treasuremap_coldharbour_05", 43689 }, -- Coldharbour Treasure Map V
			{ 0.4975, 0.3993, "treasuremap_coldharbour_06", 43690 }, -- Coldharbour Treasure Map VI
			{ 0.5521, 0.4145, "treasuremap_1_coldharbor", 44932 }, -- Coldharbour CE Treasure Map
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.7457, 0.6646, "coldharbor2_survey_blacksmith", 57796 }, -- Blacksmith Survey: Coldharbour I
			{ 0.7310, 0.7030, "coldharbor1_survey_blacksmith", 57797 }, -- Blacksmith Survey: Coldharbour II
			{ 0.6726, 0.7606, "coldharbor1_survey_clothier", 57766 }, -- Clothier Survey: Coldharbour I
			{ 0.6309, 0.6994, "coldharbor2_survey_clothier", 57767 }, -- Clothier Survey: Coldharbour II
			{ 0.2485, 0.6220, "coldharbor1_survey_enchanter", 57811 }, -- Enchanter Survey: Coldharbour I
			{ 0.2628, 0.6780, "coldharbor2_survey_enchanter", 57812 }, -- Enchanter Survey: Coldharbour II
			{ 0.4138, 0.7758, "coldharbor01_survey_alchemist", 57783 }, -- Alchemist Survey: Coldharbour I
			{ 0.4263, 0.7008, "coldharbor02_survey_alchemist", 57784 }, -- Alchemist Survey: Coldharbour II
			{ 0.4545, 0.5050, "coldharbor1_survey_woodworker", 57828 }, -- Woodworker Survey: Coldharbour I
			{ 0.5500, 0.4475, "coldharbor2_survey_woodworker", 57829 }, -- Woodworker Survey: Coldharbour II
			{ 0.5461, 0.7406, "coldharbor1_survey_jewelry", 139435 }, -- Jewelry Crafting Survey: Coldharbour I
			{ 0.4110, 0.8136, "coldharbor2_survey_jewelry", 139436 }, -- Jewelry Crafting Survey: Coldharbour II
		},
	},
-- Cyrodiil
	[16] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4076, 0.4906, "treasuremap_cyrodiil_ald_01", 43703 }, -- Cyrodiil Treasure Map I
			{ 0.5117, 0.8209, "treasuremap_cyrodiil_ald_02", 43704 }, -- Cyrodiil Treasure Map II
			{ 0.2739, 0.6996, "treasuremap_cyrodiil_ald_03", 43705 }, -- Cyrodiil Treasure Map III
			{ 0.6378, 0.7529, "treasuremap_cyrodiil_ald_04", 43706 }, -- Cyrodiil Treasure Map IV
			{ 0.4862, 0.5355, "treasuremap_cyrodiil_ald_05", 43707 }, -- Cyrodiil Treasure Map V
			{ 0.2391, 0.5559, "treasuremap_cyrodiil_ald_06", 43708 }, -- Cyrodiil Treasure Map VI
			{ 0.5376, 0.1447, "treasuremap_cyrodiil_dag_01", 43709 }, -- Cyrodiil Treasure Map VII
			{ 0.1850, 0.3832, "treasuremap_cyrodiil_dag_02", 43710 }, -- Cyrodiil Treasure Map VIII
			{ 0.3142, 0.3737, "treasuremap_cyrodiil_dag_03", 43711 }, -- Cyrodiil Treasure Map IX
			{ 0.3050, 0.1676, "treasuremap_cyrodiil_dag_04", 43712 }, -- Cyrodiil Treasure Map X
			{ 0.3791, 0.1536, "treasuremap_cyrodiil_dag_05", 43713 }, -- Cyrodiil Treasure Map XI
			{ 0.4742, 0.1768, "treasuremap_cyrodiil_dag_06", 43714 }, -- Cyrodiil Treasure Map XII
			{ 0.8071, 0.2691, "treasuremap_cyrodiil_ebon_01", 43715 }, -- Cyrodiil Treasure Map XIII
			{ 0.6903, 0.5109, "treasuremap_cyrodiil_ebon_02", 43716 }, -- Cyrodiil Treasure Map XIV
			{ 0.6749, 0.4704, "treasuremap_cyrodiil_ebon_03", 43717 }, -- Cyrodiil Treasure Map XV
			{ 0.6798, 0.6329, "treasuremap_cyrodiil_ebon_04", 43718 }, -- Cyrodiil Treasure Map XVI
			{ 0.7720, 0.4671, "treasuremap_cyrodiil_ebon_05", 43719 }, -- Cyrodiil Treasure Map XVII
			{ 0.7360, 0.5147, "treasuremap_cyrodiil_ebon_06", 43720 }, -- Cyrodiil Treasure Map XVIII
		},
	},
-- Craglorn
	[1126] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.2862, 0.6207, "treasuremap_craglorn_01", 43721 }, -- Craglorn Treasure Map I
			{ 0.4184, 0.4744, "treasuremap_craglorn_02", 43722 }, -- Craglorn Treasure Map II
			{ 0.7046, 0.5591, "treasuremap_craglorn_03", 43723 }, -- Craglorn Treasure Map III
			{ 0.6554, 0.6708, "treasuremap_craglorn_04", 43724 }, -- Craglorn Treasure Map IV
			{ 0.5964, 0.3684, "treasuremap_craglorn_05", 43725 }, -- Craglorn Treasure Map V
			{ 0.3603, 0.4482, "treasuremap_craglorn_06", 43726 }, -- Craglorn Treasure Map VI
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.6801, 0.3753, "craglorn1_survey_blacksmith", 57798 }, -- Blacksmith Survey: Craglorn I
			{ 0.4641, 0.3284, "craglorn2_survey_blacksmith", 57799 }, -- Blacksmith Survey: Craglorn II
			{ 0.4359, 0.4483, "craglorn3_survey_blacksmith", 57800 }, -- Blacksmith Survey: Craglorn III
			{ 0.4611, 0.5351, "craglorn1_survey_clothier", 57768 }, -- Clothier Survey: Craglorn I
			{ 0.3984, 0.4804, "craglorn2_survey_clothier", 57769 }, -- Clothier Survey: Craglorn II
			{ 0.3100, 0.4580, "craglorn3_survey_clothier", 57770 }, -- Clothier Survey: Craglorn III
			{ 0.0897, 0.3388, "craglorn1_survey_woodworker", 57830 }, -- Woodworker Survey: Craglorn I
			{ 0.6534, 0.3682, "craglorn2_survey_woodworker", 57831 }, -- Woodworker Survey: Craglorn II
			{ 0.4240, 0.5070, "craglorn3_survey_woodworker", 57832 }, -- Woodworker Survey: Craglorn III
			{ 0.3427, 0.5636, "craglorn03_survey_alchemist", 57785 }, -- Alchemist Survey: Craglorn I
			{ 0.5396, 0.4905, "craglorn02_survey_alchemist", 57786 }, -- Alchemist Survey: Craglorn II
			{ 0.2010, 0.4090, "craglorn01_survey_alchemist", 57787 }, -- Alchemist Survey: Craglorn III
			{ 0.5820, 0.5243, "craglorn1_survey_enchanter", 57813 }, -- Enchanter Survey: Craglorn I
			{ 0.1636, 0.3792, "craglorn2_survey_enchanter", 57814 }, -- Enchanter Survey: Craglorn II
			{ 0.6766, 0.4291, "craglorn3_survey_enchanter", 57815 }, -- Enchanter Survey: Craglorn III
			{ 0.7511, 0.4635, "craglorn1_survey_jewelry", 139437 }, -- Jewelry Crafting Survey: Craglorn I
			{ 0.4424, 0.6745, "craglorn2_survey_jewelry", 139438 }, -- Jewelry Crafting Survey: Craglorn II
			{ 0.3520, 0.5408, "craglorn3_survey_jewelry", 139439 }, -- Jewelry Crafting Survey: Craglorn III
		},
	},
-- Wrothgar
	[667] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4798, 0.7865, "treasuremap_orsinium_01", 43727 }, -- Orsinium Treasure Map I
			{ 0.7647, 0.5651, "treasuremap_orsinium_02", 43728 }, -- Orsinium Treasure Map II
			{ 0.2724, 0.6782, "treasuremap_orsinium_03", 43729 }, -- Orsinium Treasure Map III
			{ 0.4441, 0.4851, "treasuremap_orsinium_04", 43730 }, -- Orsinium Treasure Map IV
			{ 0.7303, 0.3188, "treasuremap_orsinium_05", 43731 }, -- Orsinium Treasure Map V
			{ 0.1850, 0.7600, "treasuremap_orsinium_06", 43732 }, -- Orsinium Treasure Map VI
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.4616, 0.5894, "orsinium_survey_blacksmith_01", 71065 }, -- Blacksmith Survey: Wrothgar I
			{ 0.5060, 0.6489, "orsinium_survey_blacksmith_02", 71066 }, -- Blacksmith Survey: Wrothgar II
			{ 0.6244, 0.2637, "orsinium_survey_blacksmith_03", 71067 }, -- Blacksmith Survey: Wrothgar III
			{ 0.1339, 0.7582, "orsinium_survey_clothier_01", 71068 }, -- Clothier Survey: Wrothgar I
			{ 0.4787, 0.5528, "orsinium_survey_clothier_02", 71069 }, -- Clothier Survey: Wrothgar II
			{ 0.8085, 0.3959, "orsinium_survey_clothier_03", 71070 }, -- Clothier Survey: Wrothgar III
			{ 0.6066, 0.3258, "orsinium_survey_woodworker_01", 71080 }, -- Woodworker Survey: Wrothgar I
			{ 0.5454, 0.5208, "orsinium_survey_woodworker_02", 71081 }, -- Woodworker Survey: Wrothgar II
			{ 0.8207, 0.3089, "orsinium_survey_woodworker_03", 71082 }, -- Woodworker Survey: Wrothgar III
			{ 0.2357, 0.7067, "orsinium_survey_alchemist_01", 71083 }, -- Alchemist Survey: Wrothgar I
			{ 0.7871, 0.2733, "orsinium_survey_alchemist_02", 71084 }, -- Alchemist Survey: Wrothgar II
			{ 0.1884, 0.8059, "orsinium_survey_alchemist_03", 71085 }, -- Alchemist Survey: Wrothgar III
			{ 0.2051, 0.8190, "orsinium_survey_enchanter_01", 71086 }, -- Enchanter Survey: Wrothgar I
			{ 0.4377, 0.6688, "orsinium_survey_enchanter_02", 71087 }, -- Enchanter Survey: Wrothgar II
			{ 0.6893, 0.4434, "orsinium_survey_enchanter_03", 71088 }, -- Enchanter Survey: Wrothgar III
			{ 0.8236, 0.5892, "orsinium_survey_jewelry_01", 139441 }, -- Jewelry Crafting Survey: Wrothgar I
			{ 0.4441, 0.5889, "orsinium_survey_jewelry_02", 139442 }, -- Jewelry Crafting Survey: Wrothgar II
			{ 0.1938, 0.6819, "orsinium_survey_jewelry_03", 139443 }, -- Jewelry Crafting Survey: Wrothgar III
		},
	},
	-- SubPin: Orsinium
	[895] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.8159, 0.1905, "treasuremap_orsinium_02", 43728 }, -- Orsinium Treasure Map II
		},
	},
	-- SubPin: Morkul
	[954] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{-0.0675, 0.6872, "treasuremap_orsinium_04", 43730 }, -- Orsinium Treasure Map IV
		},
	},
-- Hew's Bane
	[994] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4142, 0.8445, "treasuremap_thievesguild_01", 43733 }, -- Hew's Bane Treasure Map I
			{ 0.3840, 0.5771, "treasuremap_thievesguild_02", 43734 }, -- Hew's Bane Treasure Map II
		},
	},
-- Gold Coast
	[1006] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.6440, 0.3296, "treasuremap_darkbrotherhood_01", 43735 }, -- Gold Coast Treasure Map I
			{ 0.4885, 0.3213, "treasuremap_darkbrotherhood_02", 43736 }, -- Gold Coast Treasure Map II
		},
	},
-- Vvardenfell
	[1060] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.6627, 0.5285, "treasuremap_vvardenfell_02", 43743 }, -- Vvardenfell CE Treasure Map I
			{ 0.6346, 0.7002, "treasuremap_vvardenfell_07", 43744 }, -- Vvardenfell CE Treasure Map II
			{ 0.2835, 0.5715, "treasuremap_vvardenfell_09", 43745 }, -- Vvardenfell CE Treasure Map III
			{ 0.6664, 0.8721, "treasuremap_vvardenfell_01", 43737 }, -- Vvardenfell Treasure Map I
			{ 0.7558, 0.3154, "treasuremap_vvardenfell_03", 43738 }, -- Vvardenfell Treasure Map II
			{ 0.1973, 0.4309, "treasuremap_vvardenfell_04", 43739 }, -- Vvardenfell Treasure Map III
			{ 0.4489, 0.6933, "treasuremap_vvardenfell_05", 43740 }, -- Vvardenfell Treasure Map IV
			{ 0.5645, 0.2565, "treasuremap_vvardenfell_06", 43741 }, -- Vvardenfell Treasure Map V
			{ 0.6681, 0.7193, "treasuremap_vvardenfell_08", 43742 }, -- Vvardenfell Treasure Map VI
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.4409, 0.2440, "vvardenfell_survey_enchanter", 126122 }, -- Enchanter Survey: Vvardenfell
			{ 0.8419, 0.7310, "vvardenfell_survey_clothier", 126111 }, -- Clothier Survey: Vvardenfell
			{ 0.2904, 0.3250, "vvardenfell_survey_alchemist", 126113 }, -- Alchemist Survey: Vvardenfell
			{ 0.6724, 0.6263, "vvardenfell_survey_blacksmith", 126110 }, -- Blacksmith Survey: Vvardenfell
			{ 0.3368, 0.7736, "vvardenfell_survey_woodworker", 126112 }, -- Woodworker Survey: Vvardenfell
			{ 0.1748, 0.4099, "vvardenfell_survey_jewelry", 139444 }, -- Jewelry Crafting Survey: Vvardenfell
		},
	},
-- Clockwork City
	[1313] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.1813, 0.5961, "treasuremap_clockworkcity_01", 43746 }, -- Clockwork City Treasure Map I
			{ 0.8030, 0.4237, "treasuremap_clockworkcity_02", 43747 }, -- Clockwork City Treasure Map II
		},
	},
-- Summerset
	[1349] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4869, 0.1972, "treasuremap_summerset_01", 43748 }, -- Summerset Treasure Map I
			{ 0.7016, 0.6787, "treasuremap_summerset_03", 43749 }, -- Summerset Treasure Map II
			{ 0.3672, 0.4004, "treasuremap_summerset_04", 43750 }, -- Summerset Treasure Map III
			{ 0.3567, 0.5688, "treasuremap_summerset_07", 43751 }, -- Summerset Treasure Map IV
			{ 0.1692, 0.3203, "treasuremap_summerset_09", 43752 }, -- Summerset Treasure Map V
			{ 0.6722, 0.7828, "treasuremap_summerset_10_gjadilslegacy", 43753 }, -- Summerset Treasure Map VI
			{ 0.5989, 0.5610, "treasuremap_summerset_02", 139007 }, -- Summerset CE Treasure Map I
			{ 0.3357, 0.3246, "treasuremap_summerset_05", 139008 }, -- Summerset CE Treasure Map II
			{ 0.2042, 0.6270, "treasuremap_summerset_06", 139009 }, -- Summerset CE Treasure Map III
		},
	},
-- Murkmire
	[1484] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.5464, 0.3790, "treasuremap_murkmire_01", 145510 }, -- Murkmire Treasure Map I
			{ 0.4510, 0.4079, "treasuremap_murkmire_02", 145512 }, -- Murkmire Treasure Map II
		},
	},
-- Northern Elsweyr
	[1555] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.6116, 0.4083, "treasuremap_elsweyr_01", 151613 }, -- Northern Elsweyr Treasure Map I
			{ 0.4213, 0.2241, "treasuremap_elsweyr_02", 151614 }, -- Northern Elsweyr Treasure Map II
			{ 0.4007, 0.5826, "treasuremap_elsweyr_03", 151615 }, -- Northern Elsweyr Treasure Map III
			{ 0.2691, 0.7504, "treasuremap_elsweyr_04", 151616 }, -- Northern Elsweyr Treasure Map IV
			{ 0.4872, 0.6790, "treasuremap_elsweyr_05", 151617 }, -- Northern Elsweyr Treasure Map V
			{ 0.6343, 0.4535, "treasuremap_elsweyr_06", 151618 }, -- Northern Elsweyr Treasure Map VI
			{ 0.3193, 0.7255, "treasuremap_elsweyr_CE_01", 147922 }, -- Northern Elsweyr CE Treasure Map I
			{ 0.6995, 0.2519, "treasuremap_elsweyr_CE_02", 147923 }, -- Northern Elsweyr CE Treasure Map II
			{ 0.8115, 0.3619, "treasuremap_elsweyr_CE_03", 147924 }, -- Northern Elsweyr CE Treasure Map III
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.4410, 0.3880, "elsweyr_survey_enchanter", 151602 }, -- Enchanter Survey: Northern Elsweyr
			{ 0.3157, 0.5561, "elsweyr_survey_clothier", 151599 }, -- Clothier Survey: Northern Elsweyr
			{ 0.4283, 0.4209, "elsweyr_survey_alchemist", 151601 }, -- Alchemist Survey: Northern Elsweyr
			{ 0.2685, 0.4400, "elsweyr_survey_blacksmith", 151598 }, -- Blacksmith Survey: Northern Elsweyr
			{ 0.4918, 0.6791, "elsweyr_survey_woodworker", 151600 }, -- Woodworker Survey: Northern Elsweyr
			{ 0.6131, 0.6433, "elsweyr_survey_jewelry", 151603 }, -- Jewelry Crafting Survey: Northern Elsweyr
		},
	},
	-- SubPin: Predator Mesa
	[1616] = {
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.3945, 0.7979, "elsweyr_survey_blacksmith", 151598 }, -- Blacksmith Survey: Northern Elsweyr
		},
	},
-- Southern Elsweyr
	[1654] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.4687, 0.6361, "treasuremap_elsweyr_08", 156716 }, -- Southern Elsweyr Treasure Map I
			{ 0.2936, 0.2569, "treasuremap_elsweyr_07", 156715 }, -- Southern Elsweyr Treasure Map II
		},
	},
-- Western Skyrim
	[1719] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.5402, 0.4627, "treasuremap_skyrim_06", 166040 }, -- Western Skyrim Treasure Map I
			{ 0.5368, 0.5909, "treasuremap_skyrim_07", 166041 }, -- Western Skyrim Treasure Map II
			{ 0.2887, 0.6198, "treasuremap_skyrim_08", 166042 }, -- Western Skyrim Treasure Map III
			{ 0.2640, 0.5540, "treasuremap_skyrim_09", 166043 }, -- Western Skyrim Treasure Map IV
			{ 0.4079, 0.5109, "treasuremap_skyrim_01", 166035 }, -- Western Skyrim CE Treasure Map
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.5638, 0.4892, "skyrim_survey_alchemist", 166459 }, -- Alchemist Survey: Western Skyrim
			{ 0.3326, 0.2961, "skyrim_survey_blacksmith", 166460 }, -- Blacksmith Survey: Western Skyrim
			{ 0.5731, 0.6822, "skyrim_survey_clothier", 166461 }, -- Clothier Survey: Western Skyrim
			{ 0.1957, 0.4281, "skyrim_survey_enchanter", 166462 }, -- Enchanter Survey: Western Skyrim
			{ 0.4394, 0.5822, "skyrim_survey_jewelrycrafting", 166464 }, -- Jewelry Crafting Survey: Western Skyrim
			{ 0.7552, 0.5712, "skyrim_survey_woodworker", 166465 }, -- Woodworker Survey: Western Skyrim
		},
	},
-- Blackreach Greymoor Caverns
	[1747] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.8246, 0.4830, "treasuremap_skyrim_02", 166036 }, -- Blackreach: Greymoor Caverns CE Treasure Map I
			{ 0.8951, 0.5546, "treasuremap_skyrim_03", 166037 }, -- Blackreach: Greymoor Caverns CE Treasure Map II
			{ 0.2103, 0.6743, "treasuremap_skyrim_04", 166038 }, -- Blackreach: Greymoor Caverns Treasure Map I
			{ 0.2240, 0.5868, "treasuremap_skyrim_05", 166039 }, -- Blackreach: Greymoor Caverns Treasure Map II
		},
	},
-- Blackreach: Arkthzand Cavern
	[1850] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.1572, 0.7236, "treasuremap_markarth_02", 171475 }, -- Blackreach: Arkthzand Cavern Treasure Map
		},
	},
-- The Reach
	[1814] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.3866, 0.6818, "treasuremap_markarth_01", 171474 }, -- The Reach Treasure Map
		},
	},
-- Blackwood
	[1887] = {
		[LOST_TREASURE_PIN_TYPE_TREASURE] = {
			{ 0.7649, 0.8541, "treasuremap_blackwood_08", 175544 }, -- Blackwood CE Treasure Map I
			{ 0.6518, 0.4278, "treasuremap_blackwood_09", 175545 }, -- Blackwood CE Treasure Map II
			{ 0.3182, 0.3547, "treasuremap_blackwood_08", 175546 }, -- Blackwood CE Treasure Map III
			{ 0.3111, 0.6475, "treasuremap_blackwood_02", 175547 }, -- Blackwood Treasure Map I
			{ 0.1493, 0.4411, "treasuremap_blackwood_03", 175548 }, -- Blackwood Treasure Map II
			{ 0.8225, 0.7669, "treasuremap_blackwood_04", 175549 }, -- Blackwood Treasure Map III
			{ 0.5549, 0.1495, "treasuremap_blackwood_05", 175550 }, -- Blackwood Treasure Map IV
			{ 0.5276, 0.7004, "treasuremap_blackwood_06", 175551 }, -- Blackwood Treasure Map V
			{ 0.3893, 0.1024, "treasuremap_blackwood_07", 175552 }, -- Blackwood Treasure Map VI
		},
		[LOST_TREASURE_PIN_TYPE_SURVEYS] = {
			{ 0.5174, 0.6547, "blackwood_survey_blacksmith", 178464 }, -- Blacksmith Survey: Blackwood
			{ 0.3716, 0.1853, "blackwood_survey_woodworker", 178465 }, -- Woodworker Survey: Blackwood
			{ 0.7330, 0.5589, "blackwood_survey_jewelrycrafting", 178466 }, -- Jewelry Crafting Survey: Blackwood
			{ 0.4515, 0.4494, "blackwood_survey_clothier", 178467 }, -- Clothier Survey: Blackwood
			{ 0.5686, 0.1545, "blackwood_survey_enchanter", 178468 }, -- Enchanter Survey: Blackwood
			{ 0.7333, 0.8096, "blackwood_survey_alchemist", 178469 }, -- Alchemist Survey: Blackwood
		},
	},
}

LostTreasure.LOST_TREASURE_BOOKID_TO_ITEMID =
{
	[5116] = 139408, -- Jewelry Crafting Survey: Stormhaven
	[5124] = 139422, -- Jewelry Crafting Survey: Auridon
	[5125] = 139423, -- Jewelry Crafting Survey: Glenumbra
	[5126] = 139424, -- Jewelry Crafting Survey: Stonefalls
	[5127] = 139425, -- Jewelry Crafting Survey: Grahtwood
	[5128] = 139426, -- Jewelry Crafting Survey: Deshaan
	[5129] = 139427, -- Jewelry Crafting Survey: Greenshade
	[5130] = 139428, -- Jewelry Crafting Survey: Shadowfen
	[5131] = 139429, -- Jewelry Crafting Survey: Rivenspire
	[5132] = 139430, -- Jewelry Crafting Survey: Malabal Tor
	[5133] = 139431, -- Jewelry Crafting Survey: Alik’r
	[5134] = 139432, -- Jewelry Crafting Survey: Reaper’s March
	[5135] = 139433, -- Jewelry Crafting Survey: The Rift
	[5136] = 139434, -- Jewelry Crafting Survey: Bangkorai
	[5142] = 139435, -- Jewelry Crafting Survey: Coldharbour I
	[5143] = 139436, -- Jewelry Crafting Survey: Coldharbour II
	[5144] = 139437, -- Jewelry Crafting Survey: Craglorn I
	[5145] = 139438, -- Jewelry Crafting Survey: Craglorn II
	[5151] = 139439, -- Jewelry Crafting Survey: Craglorn III
	[5137] = 139440, -- Jewelry Crafting Survey: Eastmarch
	[5153] = 139441, -- Jewelry Crafting Survey: Wrothgar I
	[5154] = 139442, -- Jewelry Crafting Survey: Wrothgar II
	[5155] = 139443, -- Jewelry Crafting Survey: Wrothgar III
	[5156] = 139444, -- Jewelry Crafting Survey: Vvardenfell
}


local itemIdCache = { }
setmetatable(itemIdCache,{ __mode = "k" })

local function GetPinTypeItemIds(pinType)
	local itemIds = itemIdCache[pinType]
	if itemIds then
		return itemIds
	end

	itemIdCache[pinType] = { }

	for subZoneData, pinTypeData in pairs(LostTreasure.LOST_TREASURE_DATA) do
		for _pinType, _pinData in pairs(pinTypeData) do
			if _pinType == pinType then
				for _, _pinTypeData in ipairs(_pinData) do
					itemIdCache[pinType][_pinTypeData[LOST_TREASURE_DATA_INDEX_ITEMID]] = true
				end
			end
		end
	end

	return itemIdCache[pinType]
end

function LostTreasure:GetAllData()
	return self.LOST_TREASURE_DATA
end

function LostTreasure:GetPinTypeItemIds(pinType)
	return LOST_TREASURE_PIN_TYPE_DATA[pinType] and GetPinTypeItemIds(pinType) or nil
end

function LostTreasure:GetMapIdData(mapId)
	return self.LOST_TREASURE_DATA[mapId]
end

function LostTreasure:GetBookItemId(bookId)
	return self.LOST_TREASURE_BOOKID_TO_ITEMID[bookId]
end
