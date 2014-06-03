-- mappins helper by Shinni

CustomMapPins = ZO_Object:Subclass()

function CustomMapPins:New( ... )
	local result = ZO_Object.New( self )
	result:Initialize( ... )
	return result
end

function CustomMapPins:Initialize( ... )
	self.defaultIcon = "EsoUI/Art/MapPins/hostile_pin.dds"
	self.pins = {}
end

-- redraws the pins for the given pinType (removes them, if the pinType is disabled)
-- redraws all pinTypes if parameter ommited
function CustomMapPins:RefreshPins( pinType )
	ZO_WorldMap_RefreshCustomPinsOfType( _G[pinType] )
end

-- removes the pin with given pintype and tag
-- you may want to call refreshPins after removing pins
function CustomMapPins:RemovePin( pinType, pinTag )
	self.pins[pinType][pinTag] = nil
end

-- creates a pin of pinType on the given location (subzone, locx, locy).
-- pinType will be created with the default icon if undefined
-- radius may be omitted/nil if it's a real pin instead of an area
-- pinTag should be an uniqe identifier but can be ommited
-- after adding your pins you want to call RefreshPins, so the pins are actually drawn to the map
function CustomMapPins:CreatePin( pinType, subzone, locx, locy, radius, pinTag )
	if not self.pins[pinType] then
		self:CreatePinType( pinType )
	end
	
	--create default pinTag if no parameter given
	if not pinTag then
		pinTag = { pinType, subzone, locx, locy }
	end
	
	self.pins[pinType][pinTag] = { area = subzone, x = locx, y = locy, radius = radius }
end

-- creates a new pinType
-- eg:
-- CreatePinType( "Jute", { level = 20, texture = "MyAddon/That_nice_icon_esohead_is_using_for_their_map.dds" } , "delicous Jute... gather me now!" )
-- attributes for pinLayoutData:
-- level (priority of the tag; player has 160, groupmembers 130, quest 110, keeps 30)
-- texture: quote: 
-- 	"How the texturing data works:
-- 	The texture can come from a string or a callback function
-- 	If it's a callback function it must return first the base icon texture, and second the pin's pulseTexture"
-- size, minSize, isAnimated, insetX, insetY
function CustomMapPins:CreatePinType( pinType, pinLayoutData, pinTooltipCreator, addCallback )
	--simple tooltip, showing only the given string
	if type(pinTooltipCreator) == "string" then
		local tooltip = pinTooltipCreator
		pinTooltipCreator = { creator = function(pin) InformationTooltip:AddLine(tooltip) end, tooltip = InformationTooltip }
	end
	
	--use default pin icon and move pins of this type behind all other pins (level 20)
	if not pinLayoutData then
		pinLayoutData = { level = 20, texture = self.defaultIcon }
	end
	
	if not addCallback then
		addCallback = function( g_mapPinManager )
			for pinTag, pin in pairs(self.pins[pinType]) do
				--only draw pin, if player is on the correct map
				if pin.zone == GetMapName() then
					if pin.radius then
						g_mapPinManager:CreatePin( _G[pinType], pinTag, pin.x, pin.y, pin.radius )
					else
						g_mapPinManager:CreatePin( _G[pinType], pinTag, pin.x, pin.y )
					end
				end
			end
		end
	
	end
	
	ZO_WorldMap_AddCustomPin(
		pinType,
		-- this function is called everytime, the customs pins of the given pinType are to be drawn (map update because of zone/area change or RefreshPins call)
		addCallback,
		nil, -- a function to be called, when the map is resized... no need when using default pins
		pinLayoutData,
		pinTooltipCreator
	)
	self.pins[pinType] = {}
	--enable this pinTag by default
	self:enablePins( pinType, true)
end

-- en-/disables the given pinType
-- this function allows the implementation of filters
function CustomMapPins:enablePins( pinType, enable )
	ZO_WorldMap_SetCustomPinEnabled( _G[pinType], enable )
end