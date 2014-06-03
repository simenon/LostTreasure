if TreM == nil then TreM = {} end

-- MerchantsData format: locX, locY, NPCName, NPCType, [moreInfo]
--		moreInfo:
--			nil = default
--			1 = on city map
--			2 = in solo dungeon
--			3 = in public dungeon
--			4 = in cave 

TreM.TreasureMapData = { 
----Auridon (Aldmeri lvl 5-15)
	["Auridon"] = {
	    {0.49, 0.88, "Auridon Treasure Map I", 1},
	    {0.48, 0.63, "Auridon Treasure Map II", 1},
	    {0.44, 0.50, "Auridon Treasure Map III", 1},
	    {0.66, 0.41, "Auridon Treasure Map IV", 1},
	    {0.50, 0.26, "Auridon Treasure Map V", 1},--checked
	    {0.32, 0.11, "Auridon Treasure Map VI", 1},
		{0.686322, 0.959787, "Auridon CE Treasure Map", 1},--checked
	},

----Bal Foyen (Ebonheart lvl 1-5)
	["Bal Foyen"] = {				--75
	    {0.58, 0.71, "Bal Foyen Treasure Map I", 1},
	    {0.24, 0.53, "Bal Foyen Treasure Map II", 1},--checked
		{0.522, 0.420, "Bal Foyen CE Treasure Map", 1},--checked
	},
	
----Eastmarch (Ebonheart lvl 31-37)
	["Eastmarch"] = {				--75
	    {0.43, 0.36, "Eastmarch Treasure Map I", 1},
	    {0.31, 0.45, "Eastmarch Treasure Map II", 1},
	    {0.43, 0.58, "Eastmarch Treasure Map III", 1},
	    {0.36, 0.58, "Eastmarch Treasure Map IV", 1},
	    {0.72, 0.65, "Eastmarch Treasure Map V", 1},
	    {0.60, 0.53, "Eastmarch Treasure Map VI", 1},
		{0.7136, 0.5833, "Eastmarch CE Treasure Map", 1},--checked
	},

----Betnikh (Daggerfall, lvl 1-5)
	["Betnikh"] = {				--227
	    {0.16, 0.30, "Betnikh Treasure Map I", 1},
	    {0.56, 0.87, "Betnikh Treasure Map II", 1},
	    {0.45, 0.43, "Betnikh CE Treasure Map", 1},--checked
	},
	
----Stormhaven (Daggerfall, lvl 16-23)
	["Stormhaven"] = {				--227
    	{0.21, 0.51, "Stormhaven Treasure Map I", 1},
	    {0.24, 0.34, "Stormhaven Treasure Map II", 1},
	    {0.39, 0.46, "Stormhaven Treasure Map III", 1},
	    {0.41, 0.58, "Stormhaven Treasure Map IV", 1},
	    {0.68, 0.49, "Stormhaven Treasure Map V", 1},
	    {0.79, 0.51, "Stormhaven Treasure Map VI", 1},
	    {0.474951, 0.447037, "Stormhaven CE Treasure Map", 1},--checked
	},
	
----Rivenspire (Daggerfall, lvl 25-30)
	["Rivenspire"] = {				--227
	    {0.32, 0.50, "Rivenspire Treasure Map I", 1},
	    {0.17, 0.61, "Rivenspire Treasure Map II", 1},
	    {0.71, 0.43, "Rivenspire Treasure Map III", 1},
	    {0.71, 0.70, "Rivenspire Treasure Map IV", 1},
	    {0.75, 0.30, "Rivenspire Treasure Map V", 1},
	    {0.40, 0.29, "Rivenspire Treasure Map VI", 1},
	    {0.75, 0.16, "Rivenspire CE Treasure Map", 1},
		
	},
	
    ["Northpoint"] = {	
       {0.276732, 0.176966, "Rivenspire CE Treasure Map", 1},
    },	
	
----Alik’r Desert (Daggerfall, lvl 31-37)
	["Alik'r Desert"] = {				--227
	    {0.35, 0.72, "Alik'r Desert Treasure Map I", 1},
	    {0.04, 0.52, "Alik'r Desert Treasure Map II", 1},
		{0.63, 0.63, "Alik'r Desert Treasure Map III", 1},
		{0.59, 0.21, "Alik'r Desert Treasure Map IV", 1},
		{0.82, 0.52, "Alik'r Desert Treasure Map V", 1},
		{0.74, 0.45, "Alik'r Desert Treasure Map VI", 1},
	    {0.29, 0.34, "Alik'r Desert CE Treasure Map", 1},
	},
	
----Bangkorai (Daggerfall, lvl 37-43)
	["Bangkorai"] = {				--227
    	{0.42, 0.26, "Bangkorai Treasure Map I", 1},
	    {0.61, 0.20, "Bangkorai Treasure Map II", 1},
	    {0.718, 0.384, "Bangkorai Treasure Map III", 1},--checked
	    {0.31, 0.45, "Bangkorai Treasure Map IV", 1},
	    {0.32, 0.68, "Bangkorai Treasure Map V", 1},
	    {0.64, 0.69, "Bangkorai Treasure Map VI", 1},
	    {0.609, 0.758, "Bangkorai CE Treasure Map", 1},--checked
	},

----Bleakrock Isle (Ebonheart, lvl 1-5)
	["Bleakrock Isle"] = {		--74
	    {0.43, 0.40, "Bleakrock Treasure Map I", 1},
	    {0.42, 0.20, "Bleakrock Treasure Map II", 1},
		{0.463, 0.649, "Bleakrock CE Treasure Map", 1},--checked
	},
	
	["Bleakrock Village"] = {
        {0.554, 0.671, "Bleakrock CE Treasure Map", 1},--checked
    },

----Deshaan (Ebonheart, lvl 16-23)
    ["Deshaan"] = {					--13
	    {0.25, 0.54, "Deshaan Treasure Map I", 1},
	    {0.17, 0.46, "Deshaan Treasure Map II", 1},
	    {0.45, 0.40, "Deshaan Treasure Map III", 1},
	    {0.75, 0.55, "Deshaan Treasure Map IV", 1},
	    {0.89, 0.54, "Deshaan Treasure Map V", 1},
	    {0.78, 0.50, "Deshaan Treasure Map VI", 1},
		{0.35, 0.64, "Deshaan CE Treasure Map", 1},--checked
    },

----Glenumbra (Daggerfall, lvl 5-15)
	["Glenumbra"] = {					--1
	    {0.52, 0.75, "Glenumbra Treasure Map I", 1},
		{0.492010, 0.454225, "Glenumbra Treasure Map II", 1},--checked
		{0.65, 0.25, "Glenumbra Treasure Map III", 1},
		{0.72, 0.52, "Glenumbra Treasure Map IV", 1},
		{0.27, 0.52, "Glenumbra Treasure Map V", 1},
		{0.51, 0.24, "Glenumbra Treasure Map VI", 1},
		{0.73, 0.46, "Glenumbra CE Treasure Map", 1},
	},

----Grahtwood (Aldmeri, lvl 16-23)
	["Grahtwood"] = {					--9
	    {0.39, 0.66, "Grahtwood Treasure Map I", 1},
	    {0.64, 0.47, "Grahtwood Treasure Map II", 1},
		{0.629, 0.381, "Grahtwood Treasure Map III", 1},--checked
	    {0.46, 0.33, "Grahtwood Treasure Map IV", 1},
	    {0.35, 0.35, "Grahtwood Treasure Map V", 1},
	    {0.45, 0.44, "Grahtwood Treasure Map VI", 1},
		{0.312846, 0.600579, "Grahtwood CE Treasure Map", 1},--double checked
 	},
	
----Greenshade (Aldmeri lvl 25-30)
	["Greenshade"] = {			--300
	    {0.63, 0.81, "Greenshade Treasure Map I", 1},
	    {0.72, 0.73, "Greenshade Treasure Map II", 1},
	    {0.35, 0.49, "Greenshade Treasure Map III", 1},
	    {0.32, 0.32, "Greenshade Treasure Map IV", 1},
	    {0.24, 0.14, "Greenshade Treasure Map V", 1},
	    {0.59, 0.37, "Greenshade Treasure Map VI", 1},
		{0.58, 0.80, "Greenshade CE Treasure Map", 1},
	},
	
----Khenarthi's Roost (Aldmeri, lvl 1-5)
	["Khenarthi's Roost"] = {	--258
	    {0.62, 0.75, "Khenarthi's Roost Treasure Map I", 1},
		{0.21, 0.31, "Khenarthi's Roost Treasure Map II", 1},
		{0.4102, 0.5848, "Khenarthi's Roost Treasure Map III", 1},--checked
		{0.77, 0.33, "Khenarthi's Roost Treasure Map IV", 1},
		{0.616874, 0.833037, "Khenarthi's Roost CE Treasure Map I", 1},--checked
	    {0.399012, 0.366474, "Khenarthi's Roost CE Treasure Map II", 1},--checked
	},
	
----Malabal Tor (Aldmeri, lvl 31-37)
	["Malabal Tor"] = {			--22
	    {0.19, 0.49, "Malabal Tor Treasure Map I", 1},
	    {0.04, 0.47, "Malabal Tor Treasure Map II", 1},
	    {0.49, 0.67, "Malabal Tor Treasure Map III", 1},
	    {0.6520, 0.7010, "Malabal Tor Treasure Map IV", 1},--checked
	    {0.79, 0.27, "Malabal Tor Treasure Map V", 1},
	    {0.66, 0.21, "Malabal Tor Treasure Map VI", 1},
        {0.11, 0.51, "Malabal Tor CE Treasure Map", 1},
	},
	
----Reaper’s March (Aldmeri, lvl 37-43)
	["Reaper's March"] = {			--22
	    {0.37, 0.42, "Reaper's March Treasure Map I", 1},
	    {0.32, 0.12, "Reaper's March Treasure Map II", 1},
	    {0.26, 0.64, "Reaper's March Treasure Map III", 1},
	    {0.43, 0.67, "Reaper's March Treasure Map IV", 1},
	    {0.551, 0.416, "Reaper's March Treasure Map V", 1},--checked
	    {0.66, 0.22, "Reaper's March Treasure Map VI", 1},
		{0.40, 0.53, "Reaper's March CE Treasure Map", 1},
	},	
				
----Shadowfen (Ebonheart, lvl 25-30)
	["Shadowfen"] = {				--26
	    {0.3697, 0.1501, "Shadowfen Treasure Map I", 1},--checked
	    {0.7088, 0.3925, "Shadowfen Treasure Map II", 1},--checked
	    {0.70, 0.69, "Shadowfen Treasure Map III", 1},
	    {0.60, 0.60, "Shadowfen Treasure Map IV", 1},
	    {0.39, 0.46, "Shadowfen Treasure Map V", 1},
	    {0.23, 0.55, "Shadowfen Treasure Map VI", 1},
		{0.6426, 0.4554, "Shadowfen CE Treasure Map", 1},--checked
	},

--Stonefalls (Ebonheart, lvl 5-15)
	["Stonefalls"] = {			--7 
	    {0.78, 0.56, "Stonefalls Treasure Map I", 1},
	    {0.6241, 0.5102, "Stonefalls Treasure Map II", 1},--checked
	    {0.47, 0.58, "Stonefalls Treasure Map III", 1},
	    {0.17, 0.44, "Stonefalls Treasure Map IV", 1},
	    {0.19, 0.54, "Stonefalls Treasure Map V", 1},
	    {0.36, 0.70, "Stonefalls Treasure Map VI", 1},--checked
	    {0.5200, 0.6129, "Stonefalls CE Treasure Map", 1},--checked
    },

----Stros M'Kai (Daggerfall, lvl 1-5)
    ["Stros M'Kai"] = {			--201
	    {0.53, 0.63, "Stros M'Kai Treasure Map I", 1},
	    {0.09, 0.87, "Stros M'Kai Treasure Map II", 1},
		{0.70, 0.33, "Stros M'Kai CE Treasure Map", 1},--checked
	},

----The Rift (Ebonheart, lvl 37-43)
	["The Rift"] = {				--125
	    {0.73, 0.36, "The Rift Treasure Map I", 1},
	    {0.46, 0.43, "The Rift Treasure Map II", 1},
	    {0.22, 0.35, "The Rift Treasure Map III", 1},
	    {0.46, 0.54, "The Rift Treasure Map IV", 1},
	    {0.83, 0.56, "The Rift Treasure Map V", 1},
	    {0.74, 0.63, "The Rift Treasure Map VI", 1},
	    {0.5813, 0.6096, "The Rift CE Treasure Map", 1},--checked
	},
	
----Coldharbour (Shared, lvl 43-50)
	["Coldharbour"] = {				--125
	    {0.3929, 0.8172, "Coldharbour Treasure Map I", 1},
	    {0.3916, 0.5561, "Coldharbour Treasure Map II", 1},
	    {0.5913, 0.6919, "Coldharbour Treasure Map III", 1},
	    {0.7441, 0.7637, "Coldharbour Treasure Map IV", 1},
	    {0.4229, 0.4438, "Coldharbour Treasure Map V", 1},
	    {0.4908, 0.3838, "Coldharbour Treasure Map VI", 1},
	    {0.5417, 0.4046, "Coldharbour CE Treasure Map", 1},
	},
	
----Cyrodiil (Shared, lvl 43-50)
	["Cyrodiil"] = {				--125
	    --{0.0, 0.0, "Cyrodiil Treasure Map I", 1},
	    --{0.0, 0.0, "Cyrodiil Treasure Map II", 1},
	    --{0.0, 0.0, "Cyrodiil Treasure Map III", 1},
	    --{0.0, 0.0, "Cyrodiil Treasure Map IV", 1},
	    {0.4765, 0.5234, "Cyrodiil Treasure Map V", 1},
	    {0.2258, 0.5469, "Cyrodiil Treasure Map VI", 1},
	    {0.5378, 0.1279, "Cyrodiil Treasure Map VII", 1},
		{0.1723, 0.3746, "Cyrodiil Treasure Map VIII", 1},
		{0.3054, 0.3590, "Cyrodiil Treasure Map IX", 1},
		--{0.0, 0.0, "Cyrodiil Treasure Map X", 1},
		{0.3681, 0.1383, "Cyrodiil Treasure Map XI", 1},
		--{0.0, 0.0, "Cyrodiil Treasure Map XII", 1},
		--{0.0, 0.0, "Cyrodiil Treasure Map XIII", 1},
		--{0.0, 0.0, "Cyrodiil Treasure Map XIV", 1},
		{0.6605, 0.4647, "Cyrodiil Treasure Map XV", 1},
		{0.6684, 0.6253, "Cyrodiil Treasure Map XVI", 1},
		{0.7650, 0.4621, "Cyrodiil Treasure Map XVII", 1},
		--{0.0, 0.0, "Cyrodiil Treasure Map XVIII", 1},
	},
	
}