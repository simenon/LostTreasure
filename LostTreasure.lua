local LAM = LibStub:GetLibrary("LibAddonMenu-1.0")
local LMP = LibStub:GetLibrary("LibMapPins-1.0")
local LOST_TREASURE = ZO_Object:Subclass()

local AddonName = "LostTreasure" 
local Author = "CrazyDutchGuy"


LT =
{	
	defaults = 
	{
    	showTreasure = true,	
		showtreasureswithoutmap = false,
	}
}

local pinLayout_Treasure = 
{ 
		level = 40,		
		texture = "LostTreasure/Icons/map.dds",
		size = 32,	
}

--Handles info on TreasureMap
local function GetInfoFromTag(pin)
	local _, pinTag = pin:GetPinTypeAndTag()
	
	return pinTag[LOST_TREASURE_INDEX.MAP_NAME] 
end

--Creates ToolTip from treasure info
local pinTooltipCreator = {
	creator = function(pin)				
		InformationTooltip:AddLine(GetInfoFromTag(pin), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())--name color
	end,
	tooltip = InformationTooltip,
}
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function hasMap(mapName)  	
    for i=1,GetNumViewableTreasureMaps() do
        local map, _ = GetTreasureMapInfo(i)        
        if map == mapName then 
            return true
        end
    end
    return false
end

local function pinCreator_Treasure(pinManager)
    if not LT.SavedVariables.showTreasure then
        return
    end
         
    local data = LOST_TREASURE_DATA[GetCurrentMapZoneIndex()]
    if GetMapType() == 1 then  --subzone in the current map, derive info from texture instead of mapname to avoid issues with french en german clients
    	subzone = string.match(GetMapTileTexture(), "%w+/%w+/%w+/(%w+)_%w+_%d.dds")
    	data = LOST_TREASURE_DATA[subzone]
    end
    
    if not data then
        return
    end
           
    for _, pinData in pairs(data) do
	    if LT.SavedVariables.showtreasureswithoutmap == true then
            LMP:CreatePin( AddonName.."MapPin", pinData, pinData[LOST_TREASURE_INDEX.X], pinData[LOST_TREASURE_INDEX.Y],nil)
		else
		    if hasMap(pinData[LOST_TREASURE_INDEX.MAP_NAME]) then 		    	
		        LMP:CreatePin( AddonName.."MapPin", pinData, pinData[LOST_TREASURE_INDEX.X], pinData[LOST_TREASURE_INDEX.Y],nil)
            end
		end	
    end
end
	
local function ShowTreasure()	
	if LT.SavedVariables.showTreasure == true then  				
		LMP:Enable(AddonName.."MapPin" )	     		 
	else
		LMP:Disable(AddonName.."MapPin" )	     		 
    end
    LMP:RefreshPins(AddonName.."MapPin" )
end

local function GetTreasure()
	return LT.SavedVariables.showTreasure
end

local function SetTreasure()		
    LT.SavedVariables.showTreasure = not LT.SavedVariables.showTreasure	
    ShowTreasure()
end

local function GetWithoutMap()
	return LT.SavedVariables.showtreasureswithoutmap
end

local function SetWithoutMap()
    LT.SavedVariables.showtreasureswithoutmap = not LT.SavedVariables.showtreasureswithoutmap
    ShowTreasure()
end

function LOST_TREASURE:EVENT_SHOW_TREASURE_MAP(event, treasureMapIndex)
	ShowTreasure()
end


function LOST_TREASURE:EVENT_ADD_ON_LOADED(event, name)
   	if name == AddonName then 

   		EVENT_MANAGER:RegisterForEvent(AddonName, EVENT_SHOW_TREASURE_MAP, function(...) LOST_TREASURE:EVENT_SHOW_TREASURE_MAP(...) end)	

   		LT.SavedVariables = ZO_SavedVars:New("LOST_TREASURE_SV", 2, nil, LT.defaults)		
   		
   		LMP:AddPinType(AddonName.."MapPin", pinCreator_Treasure, nil, pinLayout_Treasure, pinTooltipCreator)

		if GetWithoutMap() or GetTreasure() then
			ShowTreasure()
		end
	
		local addonMenu = LAM:CreateControlPanel(AddonName.."OptionsPanel", "Lost Treasure")
		LAM:AddHeader(addonMenu, AddonName.."OptionsHeader", "Settings")
		LAM:AddCheckbox(addonMenu, AddonName.."showTreasure", "Show Used Treasure Map", "Show/hide Used Treasure Map.", GetTreasure, SetTreasure)
		LAM:AddCheckbox(addonMenu, AddonName.."showtreasureswithoutmap", "Show All Treasure Maps ", "Show/hide All Treasure Map Locations.", GetWithoutMap, SetWithoutMap)
		LAM:AddHeader(addonMenu, AddonName.."DescriptionHeader", "Description")
		LAM:AddDescription(addonMenu, AddonName.."_Description", "Icons will show on map only if the treasure map is used from your inventory.")
		LAM:AddHeader(addonMenu, AddonName.."InfoHeader", "Info")
		LAM:AddDescription(addonMenu, AddonName.."Author", "Author: " .. Author )

		EVENT_MANAGER:UnregisterForEvent(AddonName, EVENT_ADD_ON_LOADED)

	end
end

function TreasureMap_OnInitialized()	
	EVENT_MANAGER:RegisterForEvent(AddonName, EVENT_ADD_ON_LOADED, function(...) LOST_TREASURE:EVENT_ADD_ON_LOADED(...) end)
end
