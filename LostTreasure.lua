local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
local LMP = LibStub:GetLibrary("LibMapPins-1.0")
local LOST_TREASURE = ZO_Object:Subclass()

local Addon =
{
    Name = "LostTreasure",
    NameSpaced = "Lost Treasure",
    Author = "CrazyDutchGuy",
    Version = "1.15",
}

local LT =
{	
	defaults = 
	{		
        pinFilter = true, -- For LMP to toggle on WorldMap
        pinTexture = 1,
        markMapMenuOption = 2,
        showMiniTreasureMap = true,
        miniTreasureMap = 
        { 
            point = TOPLEFT, 
            relativeTo = GuiRoot, 
            relativePoint = TOPLEFT, 
            offsetX = 100, 
            offsetY = 100, 
        },
	},    
}

local markMapMenuOptions =
{
    [1] = [[Mark on use]],
    [2] = [[Mark all in inventory]],
    [3] = [[Mark all locations]]
}

local pinTexturesList = 
{
    [1] = [[X red]],
    [2] = [[X black]],
    [3] = [[Map black]],
    [4] = [[Map white]],
}

local pinTextures = 
{
    [1] = [[LostTreasure/Icons/x_red.dds]],
    [2] = [[LostTreasure/Icons/x_black.dds]],
    [3] = [[LostTreasure/Icons/map_black.dds]],
    [4] = [[LostTreasure/Icons/map_white.dds]],
}

local pinLayout_Treasure = 
{ 
		level = 40,		
		--texture = "LostTreasure/Icons/x_black.dds",
		size = 32,	
}

local LostTreasureTLW = nil

--Handles info on TreasureMap
local function GetInfoFromTag(pin)
	local _, pinTag = pin:GetPinTypeAndTag()
	
	return pinTag[LOST_TREASURE_INDEX.MAP_NAME] 
end

--Creates ToolTip from treasure info
local pinTooltipCreator = {
	creator = function(pin)		
        local _, pinTag = pin:GetPinTypeAndTag()		
		InformationTooltip:AddLine(pinTag[LOST_TREASURE_INDEX.MAP_NAME], "", ZO_HIGHLIGHT_TEXT:UnpackRGB())--name color
        InformationTooltip:AddLine(string.format("%.2f",pinTag[LOST_TREASURE_INDEX.X]*100).."x"..string.format("%.2f",pinTag[LOST_TREASURE_INDEX.Y]*100), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())--name color
	end,
	tooltip = InformationTooltip,
}
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function hasMap(mapName, mapTexture)  	
    for i=1,GetNumViewableTreasureMaps() do
        local name, textureName  = GetTreasureMapInfo(i)  -- This will most likely return a localized name, use the texturename instead ? ...            
        local mapTextureName = string.match(textureName, "%w+/%w+/%w+/(.+)%.dds")
        if mapTexture then
        	if mapTextureName == mapTexture then
        		return true
        	end
        else        	
        	if name == mapName then 
           		return true
        	end
        end
    end
    return false
end

local function scanBagForMaps(data)
    local _, bagSlots = GetBagInfo(BAG_BACKPACK)    
               
    for _, pinData in pairs(data) do  
        for bagSlot = 0, bagSlots do
            local itemID = select(4,ZO_LinkHandler_ParseLink(GetItemLink(BAG_BACKPACK, bagSlot)))

            if itemID and tonumber(itemID) == pinData[LOST_TREASURE_INDEX.ITEMID] then                    
                LMP:CreatePin( Addon.Name.."MapPin", pinData, pinData[LOST_TREASURE_INDEX.X], pinData[LOST_TREASURE_INDEX.Y],nil)    
            end  
        end              
    end        
        
end

local function pinCreator_Treasure(pinManager)
         
    local data = LOST_TREASURE_DATA[GetCurrentMapZoneIndex()]
    if GetMapType() == 1 then  --subzone in the current map, derive info from texture instead of mapname to avoid issues with french and german clients
    	local subzone = string.match(GetMapTileTexture(), "%w+/%w+/%w+/(%w+)_%w+_%d.dds")        
    	data = LOST_TREASURE_DATA[subzone]
    end
    
    if not data then
        return
    end
    
    if LT.SavedVariables.markMapMenuOption == 1 then
        for _, pinData in pairs(data) do
            if hasMap(pinData[LOST_TREASURE_INDEX.MAP_NAME],pinData[LOST_TREASURE_INDEX.TEXTURE]) then              
                LMP:CreatePin( Addon.Name.."MapPin", pinData, pinData[LOST_TREASURE_INDEX.X], pinData[LOST_TREASURE_INDEX.Y],nil)
            end
        end
    elseif LT.SavedVariables.markMapMenuOption == 2 then
        scanBagForMaps(data)
    elseif LT.SavedVariables.markMapMenuOption == 3 then
        for _, pinData in pairs(data) do
            LMP:CreatePin( Addon.Name.."MapPin", pinData, pinData[LOST_TREASURE_INDEX.X], pinData[LOST_TREASURE_INDEX.Y],nil)
        end
    end    
end
	
local function ShowTreasure()	
    LMP:RefreshPins(Addon.Name.."MapPin" )
end

local function showMiniTreasureMap(texture)
    if LT.SavedVariables.showMiniTreasureMap then
        LostTreasureTLW:SetHidden( false )  
        LostTreasureTLW.map:SetTexture(texture)
    end
end

local function createMiniTreasureMap()
    LostTreasureTLW = WINDOW_MANAGER:CreateTopLevelWindow(nil)
    LostTreasureTLW:SetMouseEnabled(true)      
    LostTreasureTLW:SetMovable( true )
    LostTreasureTLW:SetClampedToScreen(true)
    LostTreasureTLW:SetDimensions( 400 , 400 )
    LostTreasureTLW:SetAnchor( 
        LT.SavedVariables.miniTreasureMap.point, 
        LT.SavedVariables.miniTreasureMap.relativeTo,
        LT.SavedVariables.miniTreasureMap.relativePoint, 
        LT.SavedVariables.miniTreasureMap.offsetX, 
        LT.SavedVariables.miniTreasureMap.offsetY )
    LostTreasureTLW:SetHidden( true )  
    LostTreasureTLW:SetHandler("OnMoveStop", function(self,...)                         
            local _, point, relativeTo, relativePoint, offsetX, offsetY = self:GetAnchor()
            LT.SavedVariables.miniTreasureMap.point = point
            LT.SavedVariables.miniTreasureMap.relativeTo = relativeTo
            LT.SavedVariables.miniTreasureMap.relativePoint = relativePoint
            LT.SavedVariables.miniTreasureMap.offsetX = offsetX
            LT.SavedVariables.miniTreasureMap.offsetY = offsetY
        end) 
        
    LostTreasureTLW.map = WINDOW_MANAGER:CreateControl(nil,  LostTreasureTLW, CT_TEXTURE)
    --LostTreasureTLW.map:SetDimensions(400,400)    
    LostTreasureTLW.map:SetAnchorFill(LostTreasureTLW)  

    LostTreasureTLW.map.close = WINDOW_MANAGER:CreateControlFromVirtual(nil, LostTreasureTLW.map, "ZO_CloseButton")
    LostTreasureTLW.map.close:SetHandler("OnClicked", function(...) LostTreasureTLW:SetHidden(true) end)      
end

function LOST_TREASURE:EVENT_SHOW_TREASURE_MAP(event, treasureMapIndex)	
    local name, textureName  = GetTreasureMapInfo(treasureMapIndex)
    showMiniTreasureMap(textureName)
	--
	--  Temporary till all textures are known ...
	--	
	local name, textureName  = GetTreasureMapInfo(treasureMapIndex)  -- This will most likely return a localized name, use the texturename instead ? ...            
    local mapTextureName = string.match(textureName, "%w+/%w+/%w+/(.+)%.dds")
    for _, v in pairs(LOST_TREASURE_DATA) do
    	for _, pinData in pairs(v) do    	
    		if mapTextureName == pinData[LOST_TREASURE_INDEX.TEXTURE] then                
    			return
    		end
    	end
    end

    d("Sending update to addon author for map " .. name )    
    RequestOpenMailbox()        
    SendMail("@CrazyDutchGuy", "Lost Treasure " .. Addon.Version .. " :  ".. name,  name .. "::" .. textureName .."::" .. mapTextureName .. "::" )  
end

local function createLAM2Panel()
    local treasureMapIcon
    local panelData = 
    {
        type = "panel",
        name = Addon.NameSpaced,
        displayName = "|cFFFFB0" .. Addon.NameSpaced .. "|r",
        author = Addon.Author,
        version = Addon.Version,
        registerForRefresh = true,
    }

    local optionsData = 
    {
        [1] = 
        {
            type = "dropdown",
            name = "Pin Textures",
            tooltip = "Which pin texture to use.",
            choices = pinTexturesList,
            getFunc = function() return pinTexturesList[LT.SavedVariables.pinTexture] end,
            setFunc = function(value) 
                for i,v in pairs(pinTexturesList) do
                    if v == value then
                        LT.SavedVariables.pinTexture = i
                        pinLayout_Treasure.texture = pinTextures[i]
                        treasureMapIcon:SetTexture(pinTextures[i])
                    end
                end
            end,
        },
        [2] =
        {            
            type = "dropdown",
            name = "Map Marking",
            tooltip = "When to mark the map.",
            choices = markMapMenuOptions,
            getFunc = function() return markMapMenuOptions[LT.SavedVariables.markMapMenuOption] end,
            setFunc = function(value) 
                for i,v in pairs(markMapMenuOptions) do
                    if v == value then
                        LT.SavedVariables.markMapMenuOption = i
                        ShowTreasure()
                    end
                end
            end,            
        },     
        [3] =
        {
            type = "checkbox",
            name = "Show Mini Treasure Map",
            tooltip = "Show the mini treasure map on screen when using map from inventory.",
            getFunc = function() return LT.SavedVariables.showMiniTreasureMap end,
            setFunc = function(value) LT.SavedVariables.showMiniTreasureMap = value end,
        },   
        [4] =
        {
            type = "description",
            text = "Lost Treasure will put a marker on your map if you use the treasure map from your inventory.",
        }
    }   

    local myPanel = LAM2:RegisterAddonPanel(Addon.Name.."LAM2Options", panelData)
    
    LAM2:RegisterOptionControls(Addon.Name.."LAM2Options", optionsData)
    
    local SetupLAMMapIcon = function(control)
        if not treasureMapIcon and control == myPanel then
            treasureMapIcon = WINDOW_MANAGER:CreateControl(nil, control.controlsToRefresh[1], CT_TEXTURE)
            treasureMapIcon:SetAnchor(RIGHT, control.controlsToRefresh[1].dropdown:GetControl(), LEFT, -10, 0)
            treasureMapIcon:SetTexture(pinTextures[LT.SavedVariables.pinTexture])
            treasureMapIcon:SetDimensions(pinLayout_Treasure.size, pinLayout_Treasure.size)
            CALLBACK_MANAGER:UnregisterCallback("LAM-PanelControlsCreated", SetupLAMMapIcon)
        end
    end
    CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", SetupLAMMapIcon)
end    

function LOST_TREASURE:EVENT_ADD_ON_LOADED(event, name)
   	if name == Addon.Name then 

        LT.SavedVariables = ZO_SavedVars:New("LOST_TREASURE_SV", 3, nil, LT.defaults)  

        if GetCVar("language.2") == "de" then
            LOST_TREASURE_INDEX.MAP_NAME = LOST_TREASURE_INDEX.MAP_NAME_DE
        elseif GetCVar("language.2") == "fr" then
            LOST_TREASURE_INDEX.MAP_NAME = LOST_TREASURE_INDEX.MAP_NAME_FR
        else
            LOST_TREASURE_INDEX.MAP_NAME = LOST_TREASURE_INDEX.MAP_NAME_EN
        end

        createMiniTreasureMap()

   		EVENT_MANAGER:RegisterForEvent(Addon.Name, EVENT_SHOW_TREASURE_MAP, function(...) LOST_TREASURE:EVENT_SHOW_TREASURE_MAP(...) end)	
   		

        pinLayout_Treasure.texture = pinTextures[LT.SavedVariables.pinTexture]
   		
   		LMP:AddPinType(Addon.Name.."MapPin", pinCreator_Treasure, nil, pinLayout_Treasure, pinTooltipCreator)
        LMP:AddPinFilter(Addon.Name.."MapPin", "Lost Treasure Maps", false, LT.SavedVariables, "pinFilter")			
	    		
        createLAM2Panel()
        
        EVENT_MANAGER:UnregisterForEvent(Addon.Name, EVENT_ADD_ON_LOADED)
	end
end

function TreasureMap_OnInitialized()	
	EVENT_MANAGER:RegisterForEvent(Addon.Name, EVENT_ADD_ON_LOADED, function(...) LOST_TREASURE:EVENT_ADD_ON_LOADED(...) end)    
end
