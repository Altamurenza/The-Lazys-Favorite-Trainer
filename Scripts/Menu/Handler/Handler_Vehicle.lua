-- HANDLER_VEHICLE.LUA
-- AUTHOR	: ALTAMURENZA


-------------------------------------------------
-- # THREAD: DRIVING COP BIKE, CAR, & SPACESHIP #
-------------------------------------------------

-- CHECK VEHICLE

local Cars = {
	[286] = true, [288] = true, [290] = true, [291] = true, [292] = true,
	[293] = true, [294] = true, [295] = true, [296] = true, [297] = true,
}
local Spaceships = {
	[285] = true, [287] = true, [298] = true,
}

local function IsPedDriving(Ped, Vehicle)
	if not PedIsValid(Ped) or Ped == gPlayer then
		return
	end
	return VehicleFromDriver(Ped) == Vehicle and PedMePlaying(Ped, 'Driver')
end

local function GetVehicleType(Vehicle)
	local Index = VehicleGetModelId(Vehicle)
	if Index == 275 then
		return 'BIKE'
	elseif Cars[Index] then
		return 'CAR'
	elseif Spaceships[Index] then
		return 'SPACESHIP'
	end
	
	return 'UNKNOWN'
end

local function CanPlayerEnterVehicle(Vehicle)
	if not VehicleIsValid(Vehicle) or GetVehicleType(Vehicle) == 'UNKNOWN' then
		return
	end
	local IsFree = PedMePlaying(gPlayer, 'DEFAULT_KEY')
	local IsRiding = PlayerIsInAnyVehicle()
	local IsTargeting = PedIsValid(PedGetTargetPed(gPlayer))
	if not IsFree or IsRiding or IsTargeting then
		return
	end
	local X1, Y1, Z1 = PlayerGetPosXYZ()
	local X2, Y2, Z2 = VehicleGetPosXYZ(Vehicle)
	
	local Range = VehicleIsModel(Vehicle, 288) and 6 or 4
	local IsApproaching = DistanceBetweenCoords3d(X1, Y1, Z1, X2, Y2, Z2) <= Range
	if not IsApproaching then
		return
	end
	return VehicleGetPassenger(Vehicle, 0) == -1
end

-- ENTER VEHICLE

local function EnterBike(Vehicle)
	local Node = '/Global/Vehicles/Motorcycle/MoveToVehicle'
	PedEnterVehicle(gPlayer, Vehicle)
	PedSetActionNode(gPlayer, Node, 'Act/Vehicles.act')
	
	local Side = 'LHS'
	local Time = GetTimer()
	repeat
		if PedMePlaying(gPlayer, 'MoveToVehicleRHS') then
			Side = 'RHS'
		end
		
		if Time + 5000 < GetTimer() then
			PlayerStopAllActionControllers()
		end
		Wait(0)
	until not PedIsPlaying(gPlayer, Node, true)
	return PedMePlaying(gPlayer, 'Vehicles_Ride') or PedMePlaying(gPlayer, 'GetInVehicle'), Side
end

local function ForceEnterBike(Vehicle, Side)
	local Node = '/Global/Vehicles/Bikes/MoveToVehicle/AtBike'..Side..'/BikeUpright/GetInVehicle'
	PedSetActionNode(gPlayer, Node, 'Act/Vehicles.act')
	repeat
		Wait(0)
	until PlayerIsInVehicle(Vehicle)
	
	PlayerDetachFromVehicle()
	repeat
		Wait(0)
	until not PlayerIsInVehicle(Vehicle)
	Node = '/Global/Vehicles/Motorcycle/MoveToVehicle/AtBike/GetInVehicle/Base/GetOn'
	PedSetActionNode(gPlayer, Node, 'Act/Vehicles.act')
end

local function GetOnBike(Vehicle)
	local Success, Side = EnterBike(Vehicle)
	if Success then
		return
	end
	ForceEnterBike(Vehicle, Side)
end

local function GetOnCar(Vehicle)
	local Node = '/Global/Vehicles/Cars/MoveToVehicle/MoveToVehicleLHS/MoveTo'
	PedEnterVehicle(gPlayer, Vehicle)
	PedSetActionNode(gPlayer, Node, 'Act/Vehicles.act')
	while PedIsPlaying(gPlayer, Node, true) do
		Wait(0)
	end
	
	if PedMePlaying(gPlayer, 'Vehicles_CarRide') or PedMePlaying(gPlayer, 'GetInVehicle') then
		return
	end
	Node = '/Global/Vehicles/Cars/MoveToVehicle/AtCar/GetInVehicle/LeftHandSide/Sedan'
	PedSetActionNode(gPlayer, Node, 'Act/Vehicles.act')
end

local function GetOnSpaceship(Vehicle)
	PedWarpIntoCar(gPlayer, Vehicle)
	while IsButtonBeingReleased(9, 0) do
		Wait(0)
	end
end

local function GetOnVehicle(Vehicle)
	local Type = GetVehicleType(Vehicle)
	local Func = ({
		['BIKE'] = GetOnBike,
		['CAR'] = GetOnCar,
		['SPACESHIP'] = GetOnSpaceship,
	})[Type]
	
	Func(Vehicle)
end

local function GetOffVehicle(Vehicle)
	local Offset = math.random(1, 2) == 1 and 1.5 or -1.5
	local VX, VY, VZ = PedGetOffsetInWorldCoords(gPlayer, Offset, 0, 0)
	local PX, PY, PZ = PlayerGetPosXYZ()
	
	VehicleStop(Vehicle)
	PedWarpOutOfCar(gPlayer, Vehicle)
	Wait(50)
	
	PlayerSetPosSimple(PX, PY, PZ)
	VehicleSetPosXYZ(VEHICLE, VX, VY, VZ)
	Wait(500)
end

-- THREAD

CreateThread(function()
	while true do
		for Vehicle in AllVehicles() do
			if CanPlayerEnterVehicle(Vehicle) and IsButtonBeingReleased(9, 0) then
				GetOnVehicle(Vehicle)
			end
		end
		
		if PlayerIsInAnyVehicle() then
			local Vehicle = VehicleFromDriver(gPlayer)
			local Type = GetVehicleType(Vehicle)
			if Type == 'SPACESHIP' and IsButtonBeingReleased(9, 0) then
				GetOffVehicle(Vehicle)
			end
			
			if (Type == 'BIKE' or Type == 'CAR') and IsButtonBeingPressed(8, 0) then
				VehicleUseHorn(Vehicle)
			end
		end
		
		Wait(0)
	end
end)