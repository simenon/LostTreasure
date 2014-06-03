-----------------------
-- TreasureMaps v1.95 --
-----------------------
--READ NOTE TO MYSELFS!--
if TreM == nil then TreM = {} end

local AddonName = "TreasureMaps"
local Author = "Mitsarugi"
local Version = 1.95

--Used to not show message every update(second)
local CounterNeed = 20
local CounterCurrent =1
local OnDirtMountMessage = "You are right on top of the Dirt Mount!"

-- strings for localization
TreM.moreInfo = { 
    [1] = "Treasure Location",
}

-- default settings for saved variables
TreM.defaults = {
    showTreasure = true,
	showAlert = true,
	showtreasureswithoutmap = false,
	--NOTE TO SELF: add language support!
	--language = "En",
}

-- Pins
-- USE "/iv" INGAME TO SEE ICONS , at 718 map starts
TreM.pinLayout_Treasure = { 
	level = 40,
	texture = "TreasureMaps/Icons/on.dds",
	size = 25,
}

--NOTE TO SELF: add pins for collected treasures!
-- TreM.pinLayout_Treasure_Collected = { 
	-- level = 40,
	-- texture = "TreasureMaps/Icons/off.dds",
	-- size = 25,
-- }

--num = given number, idp = rounding number (i.e: 2 = 2,85 an 1 = 2,8)
function Round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

--Handles info on TreasureMap
local function GetInfoFromTag(pin)
	local _, pinTag = pin:GetPinTypeAndTag()
	local treasurename = pinTag[3] 
	local treasuretype = TreM.moreInfo[pinTag[4]] 
	local description = "[" .. Round(pinTag[1] * 100) .. ";" .. Round(pinTag[2] * 100) .. "]"
	if pinTag[6] ~= nil and pinTag[7] == nil then
	     local moredescription = "[" .. TreM.moreInfo[pinTag[6]] .. "]"
		 return treasurename, treasuretype, description, moredescription
	elseif pinTag[6] ~= nil and pinTag[7] ~= nil then	 
		 local moredescription = "[" .. TreM.moreInfo[pinTag[6]] .. "]"
		 local evenmoredescription = "[" .. TreM.moreInfo[pinTag[7]] .. "]"
		 return treasurename, treasuretype, description, moredescription, evenmoredescription
	else
		 return treasurename, treasuretype, description
	end
end

--Creates ToolTip from treasure info
TreM.pinTooltipCreator = {
	creator = function(pin)
		local treasurename, treasuretype, description, moredescription, evenmoredescription = GetInfoFromTag(pin)
		InformationTooltip:AddLine(treasurename, "", ZO_HIGHLIGHT_TEXT:UnpackRGB())--name color
		--InformationTooltip:AddLine("EsoUI/Art/Miscellaneous/horizontalDivider.dds")
		InformationTooltip:AddLine(treasuretype, "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())--type color
		if description ~= nil and moredescription == nil and evenmoredescription == nil then
		     InformationTooltip:AddLine(description, "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
	    elseif description ~= nil and moredescription ~= nil and evenmoredescription == nil then
			 InformationTooltip:AddLine(description, "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
		     InformationTooltip:AddLine(moredescription, "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
		elseif description ~= nil and moredescription ~= nil and evenmoredescription ~= nil then
		     InformationTooltip:AddLine(description, "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
		     InformationTooltip:AddLine(moredescription, "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
			 InformationTooltip:AddLine(evenmoredescription, "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
		end
	end,
	tooltip = InformationTooltip,
}
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 function TreM.pinCreator_Treasure(pinManager)
        if not TreM.SavedVariables.showTreasure then
            return
        end
           
        local subzone = GetMapName()
        local treasures = TreM.TreasureMapData[subzone]
        if not treasures then
            return
        end
           
        for _, pinData in pairs(treasures) do
		    if TreM.SavedVariables.showtreasureswithoutmap == true then
                pinManager:CreatePin( _G["TreMMapPin_Treasure"], pinData, pinData[1], pinData[2])
		    else
		        if hasMap(pinData[3]) then --third entry is the treasure map name
		            pinManager:CreatePin( _G["TreMMapPin_Treasure"], pinData, pinData[1], pinData[2])
                end
		    end	
        end--for
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
function TreasureMapOnUpdate()
    CounterCurrent = (CounterCurrent+1)
    local SelfX, SelfY, SelfH = GetMapPlayerPosition('player')
    local subzone = GetMapName()
    local treasures = TreM.TreasureMapData[subzone]
    if not treasures then
        return
    end      
    for _, pinData in pairs(treasures) do
        if hasMap(pinData[3]) then --third entry is the trasure map name
		    --NOTE TO SELF: Add a message to tell player he/she's close (i.e: "more to the right" "more to the left" "Distance")
            if SelfX >= pinData[1]-0.0005 and SelfY >= pinData[2]-0.0005 and SelfX <= pinData[1]+0.0005 and SelfY <= pinData[2]+0.0005 and treasures then
			    --NOTE TO SELF: Add if player is at SelfX;SelfY and item is removed change icon for the map
				if TreM.SavedVariables.showAlert == true then 
				if CounterCurrent == CounterNeed then
                ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.DEFAULT_CLICK, OnDirtMountMessage)
                CounterCurrent = 1
				end
				end
			end
        end
    end
end
 
--when game loads -> adds pins, creates menu
function TreM.OnLoad(event, name)
   	if name ~= "TreasureMaps" then return end
	SLASH_COMMANDS["/setmapnum"] = SetMapNum 
	
    TreM.SavedVariables = ZO_SavedVars:New("TreM_SavedVariables", 1, nil, TreM.defaults)
	TreM.MapPins = CustomMapPins:New() 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Condition placing Icons OnLoad only if Saved Variable is True (UIRELOAD FIX)

    if TreM.SavedVariables.showTreasure == false then
	         TreM.MapPins:enablePins( "TreMMapPin_Treasure", disable )
	else
		     TreM.MapPins:CreatePinType("TreMMapPin_Treasure", TreM.pinLayout_Treasure, TreM.pinTooltipCreator, TreM.pinCreator_Treasure)
	end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	TreM.MapPins:RefreshPins()

	-- addon menu
	local LAM = LibStub:GetLibrary("LibAddonMenu-1.0")
	local addonMenu = LAM:CreateControlPanel("TreasureMaps_OptionsPanel", AddonName)
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--Treasure
	local function GetTreasure()
		return TreM.SavedVariables.showTreasure
	end

	local function SetTreasure()
		if TreM.SavedVariables.showTreasure == true then
	         TreM.SavedVariables.showTreasure = not TreM.SavedVariables.showTreasure
			 TreM.MapPins:enablePins( "TreMMapPin_Treasure", disable )
		else
		     TreM.SavedVariables.showTreasure = not TreM.SavedVariables.showTreasure
			 TreM.MapPins:CreatePinType("TreMMapPin_Treasure", TreM.pinLayout_Treasure, TreM.pinTooltipCreator, TreM.pinCreator_Treasure)
	    end
		TreM.MapPins:RefreshPins()
	end
	
	--Alert
	local function GetAlert()
		return TreM.SavedVariables.showAlert
	end

	local function SetAlert()
		if TreM.SavedVariables.showAlert == true then
	         TreM.SavedVariables.showAlert = not TreM.SavedVariables.showAlert
		else
		     TreM.SavedVariables.showAlert = not TreM.SavedVariables.showAlert
		end
	end

	--WithoutMap
	local function GetWithoutMap()
		return TreM.SavedVariables.showtreasureswithoutmap
	end

	local function SetWithoutMap()
		if TreM.SavedVariables.showtreasureswithoutmap == true then
	         TreM.SavedVariables.showtreasureswithoutmap = not TreM.SavedVariables.showtreasureswithoutmap
		else
		     TreM.SavedVariables.showtreasureswithoutmap = not TreM.SavedVariables.showtreasureswithoutmap
		end
	end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	LAM:AddHeader(addonMenu, "TreasureMaps_OptionsHeader", "Settings")
	LAM:AddCheckbox(addonMenu, "TreasureMaps_showTreasure", "Show TreasureMap Locations", "Show/hide TreasureMap Locations.", GetTreasure, SetTreasure)
	LAM:AddCheckbox(addonMenu, "TreasureMaps_showAlert", "Show Alert Message", "Show/hide Alert Message.", GetAlert, SetAlert)
	LAM:AddCheckbox(addonMenu, "TreasureMaps_showtreasureswithoutmap", "Show Treasure Without Map", "Show/hide Treasure Locations for those that you don't have a map.", GetWithoutMap, SetWithoutMap)
	LAM:AddHeader(addonMenu, "TreasureMaps_DescriptionHeader", "Description")
	LAM:AddDescription(addonMenu, "TreasureMaps_Description", "Icons will show on map only if the TreasureMap is used and will be removed if you change from one map to an other once it is found.")
	LAM:AddHeader(addonMenu, "TreasureMaps_InfoHeader", "Info")
	LAM:AddDescription(addonMenu, "TreasureMaps_Author", "Author: " .. Author .. "    Version: " .. Version)
	LAM:AddDescription(addonMenu, "TreasureMaps_Source", "Source: http://tamrieljournal.com/treasure-map-locations/")		
	
	EVENT_MANAGER:UnregisterForEvent("TreasureMaps", EVENT_ADD_ON_LOADED)
end

	-- Both Name & Texture -- /script d(GetTreasureMapInfo())
	-- Map Texture -- /script _, map = GetTreasureMapInfo() d(map)
	-- Map Name -- /script map ,_ = GetTreasureMapInfo() d(map)
	-- /script hasMap("/esoui/art/treasuremaps/treasuremap_ce_ebonheart_rift_06.dds")
	-- /script map ,_ = GetTreasureMapInfo() hasMap(map)

	function hasMap(mapName)
        local num = GetNumViewableTreasureMaps()
        local map
        for i=1,num do
            map = GetTreasureMapInfo(i)
            if map == mapName then --player has a map with the given map name
                return true
            end
        end
        return false
    end
	
	local mapset 
	function SetMapNum(num)
	  mapset = num
	end

	function TreasureMapsInfo()
	    d("== TreasureMaps Info ==")
	    d("To see the unfinished mini treasure map representation feature use")
	    d("/script MiniRepresMapDisplay()")
		d("in the chat (/reloadui to remove it)") 
	end
	
function MiniRepresMapDisplay()
    --main control
	local wm = GetWindowManager()
    local c = wm:CreateTopLevelWindow()
    c:SetDimensions(260,260)
    c:SetAnchor(TOPLEFT,GuiRoot,TOPLEFT,0,0)
	c:SetHidden(false)
    c:SetMovable(true)
    c:SetMouseEnabled(true)
    c:SetClampedToScreen(true)
    c:SetHandler("OnReceiveDrag", function(self) self:StartMoving() end)
    c:SetHandler("OnMouseUp", function(self) self:StopMovingOrResizing() end)

    --background
    --templates: ZO_DefaultBackdrop, ZO_ThinBackdrop, ZO_InsetBackdrop, ZO_InsetTexture, ZO_CenterlessBackdrop
    c.bg = wm:CreateControlFromVirtual(nil, c, "ZO_DefaultBackdrop")
    --alternative without using a template
    --c.bg = wm:CreateControl(nil, c, CT_BACKDROP)
    --c.bg:SetCenterColor(0, 0, 0, .5)
    --c.bg:SetEdgeColor(0, 0, 0, 0.5)
    c.bg:SetAnchorFill(c)

    --texture referencing a local media folder
    -- c.icon = wm:CreateControl(nil, c, CT_TEXTURE)
    -- c.icon:SetTexture(self.addonName.."/media/purple_shield.dds")
    -- c.icon:SetDimensions(64,64)
    -- c.icon:SetAnchor(TOPLEFT,c,TOPLEFT,0,0)

	local num = GetNumViewableTreasureMaps()
    local texture
	local mapname
	_, texture = GetTreasureMapInfo(mapset)
	d("== Viewable Treasure Maps == ")
	for i=1,num do
	   mapname ,_ = GetTreasureMapInfo(i)
	   d("- " .. mapname .. " - #" .. i)
    end
	
	d("Number of Viewable Treasure Maps: " ..num)
	d("== Slash commands ==")
	d("/setmapnum <#map>")
	d("sets the mini treasure map representation to that number")
	d("(a treasure map has to be used to recreate a new window(UNFINISHED!))")
	
    --test icon with path to ESOUI folder
    c.icon2 = wm:CreateControl(nil, c, CT_TEXTURE)
    c.icon2:SetTexture(texture)--ESOUI
    c.icon2:SetDimensions(280,280)
    c.icon2:SetAnchor(CENTER,c,CENTER,0,0)

    return c
end


EVENT_MANAGER:RegisterForEvent("TreasureMaps_GetTreasureMapName", EVENT_SHOW_TREASURE_MAP, TreasureMapsInfo)	
EVENT_MANAGER:RegisterForEvent("TreasureMaps_OnLoad", EVENT_ADD_ON_LOADED, TreM.OnLoad)
