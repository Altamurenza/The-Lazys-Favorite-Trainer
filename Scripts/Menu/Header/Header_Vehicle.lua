-- HEADER_VEHICLE.LUA
-- AUTHOR	: ALTAMURENZA


PlayerSettings.Vehicles = {}

function CreateVehicle(Header, Code, Name)
	local X, Y, Z, Heading = SelectSpot()
	if type(X) ~= 'number' then
		return
	end
	
	local Vehicle = VehicleCreateXYZ(Code, X, Y, Z)
	VehicleFaceHeading(Vehicle, Heading)
	VehicleSetOwner(Vehicle, gPlayer)
	
	table.insert(PlayerSettings.Vehicles, {Vehicle = Vehicle, Index = Code, Type = Header, Name = Name})
end