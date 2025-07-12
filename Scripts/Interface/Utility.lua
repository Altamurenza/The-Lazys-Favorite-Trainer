-- UTILITY.LUA
-- AUTHOR	: ALTAMURENZA


SelectPed = function(IncludePlayer, CustomMessage)
	local SelectedPed = nil
	SetPointerStatus(2)
	SetPointerRotation(0)
	SetPointerIndex(4)
	
	if not CustomMessage then
		local Header = 'CHOOSING TARGET'
		local Body = [[
			Find the target with a bounding box and point at them using your mouse.
			Press ~t~ to confirm.
			Press ~t~ to cancel.
		]]
		SetQueuedMessage(Header, Body, -1, {
			GetHudTexture('Button_Left_Mouse_Button'), 
			GetHudTexture('Button_Right_Mouse_Button')
		})
	end
	
	local DrawBoundingBox = function(Ped)
		local PedCheck = IncludePlayer and true or Ped ~= gPlayer
		if not PedCheck or not PedIsOnScreen(Ped) or PedGetHealth(Ped) < 1 then
			return
		end
		local Valid, X1, Y1, X2, Y2 = GetBoundingBox('PED', Ped)
		if not Valid then
			return
		end
		
		DrawTexture(GetTUD('Cbox'), X1, Y1, X2 - X1, Y2 - Y1)
		if IsPointerInRectangle(X1, Y1, X2, Y2) and IsMenuPressed(0) then
			SelectedPed = Ped
		end
	end
	
	repeat
		ToggleShow()
		if IsMenuShowing() then
			for Ped in AllPeds() do
				DrawBoundingBox(Ped)
			end
			ShowPointer()
		end
		Wait(0)
	until SelectedPed or IsMenuPressed(1)
	
	if not CustomMessage then
		StopQueueMessage()
	end
	SetPointerStatus(1)
	return SelectedPed
end
SelectVehicle = function(CustomMessage)
	local SelectedVeh = nil
	SetPointerStatus(2)
	SetPointerRotation(0)
	SetPointerIndex(4)
	
	if not CustomMessage then
		local Header = 'CHOOSING VEHICLE'
		local Body = [[
			Find the vehicle with a bounding box and point at them using your mouse.
			Press ~t~ to confirm.
			Press ~t~ to cancel.
		]]
		SetQueuedMessage(Header, Body, -1, {
			GetHudTexture('Button_Left_Mouse_Button'), 
			GetHudTexture('Button_Right_Mouse_Button')
		})
	end
	
	local DrawBoundingBox = function(Vehicle)
		if not VehicleIsValid(Vehicle) then
			return
		end
		local Valid, X1, Y1, X2, Y2 = GetBoundingBox('VEHICLE', Vehicle)
		if not Valid then
			return
		end
		
		DrawTexture(GetTUD('Cbox'), X1, Y1, X2 - X1, Y2 - Y1)
		if IsPointerInRectangle(X1, Y1, X2, Y2) and IsMenuPressed(0) then
			SelectedVeh = Vehicle
		end
	end
	
	repeat
		ToggleShow()
		if IsMenuShowing() then
			for Vehicle in AllVehicles() do
				DrawBoundingBox(Vehicle)
			end
			ShowPointer()
		end
		Wait(0)
	until SelectedVeh or IsMenuPressed(1)
	
	if not CustomMessage then
		StopQueueMessage()
	end
	SetPointerStatus(1)
	return SelectedVeh
end
SelectSpot = function(CustomMessage)
	local X, Y, Z, Heading = nil, nil, nil
	SetPointerStatus(2)
	SetPointerRotation(0)
	SetPointerIndex(5)
	
	if not CustomMessage then
		local Header = 'CHOOSING SPOT'
		local Body = [[
			Move your cursor over a valid ground spot. A good spot should be flat and clear of any obstacles.
			Press ~t~ to confirm.
			Press ~t~ to cancel.
		]]
		SetQueuedMessage(Header, Body, -1, {
			GetHudTexture('Button_Left_Mouse_Button'), 
			GetHudTexture('Button_Right_Mouse_Button')
		})
	end
	
	repeat
		ToggleShow()
		if IsMenuShowing() then
			if IsMenuPressed(0) then
				X, Y, Z, Heading = GetWorldCoords(GetPointerPosition())
			end
			ShowPointer()
		end
		
		Wait(0)
	until type(X) == 'number' or IsMenuPressed(1)
	
	if not CustomMessage then
		StopQueueMessage()
	end
	SetPointerStatus(1)
	return X, Y, Z, Heading
end

GetBoundingBox = function(Type, Object)
	if Type == 'PED' then
		return GetPedBoundingBox(Object)
	elseif Type == 'VEHICLE' then
		return GetVehicleBoundingBox(Object)
	end
	return nil
end
GetPedBoundingBox = function(Ped)
	local PX, PY, PZ = PedGetPosXYZ(Ped)
	
	-- get the eight corners by using ped offset
	local W = 0.6
	local MinH = -0.2
	local MaxH = (GetArguments(3, PedGetHeadPos(Ped)) - PZ) * 1.3 -- approximately, head + hat is 30% of the whole body
	local BoxCorners = {
		-- lower
		{PedGetOffsetInWorldCoords(Ped, -W, -W, MinH)},		-- LB
		{PedGetOffsetInWorldCoords(Ped, W, -W, MinH)},		-- RB
		{PedGetOffsetInWorldCoords(Ped, -W, W, MinH)},		-- LF
		{PedGetOffsetInWorldCoords(Ped, W, W, MinH)},		-- RF
		
		-- upper
		{PedGetOffsetInWorldCoords(Ped, -W, -W, MaxH)},		-- LB
		{PedGetOffsetInWorldCoords(Ped, W, -W, MaxH)},		-- RB
		{PedGetOffsetInWorldCoords(Ped, -W, W, MaxH)},		-- LF
		{PedGetOffsetInWorldCoords(Ped, W, W, MaxH)},		-- RF
	}
	
	-- get screen coords
	local ScreenXs, ScreenYs = {}, {}
	for _, Corner in ipairs(BoxCorners) do
		local ScreenX, ScreenY = GetScreenCoords(Corner[1], Corner[2], Corner[3])
		if not ScreenX or not ScreenY then
			return nil
		end
		table.insert(ScreenXs, ScreenX)
		table.insert(ScreenYs, ScreenY)
	end
	
	local X1, Y1 = math.min(unpack(ScreenXs)), math.min(unpack(ScreenYs))
	local X2, Y2 = math.max(unpack(ScreenXs)), math.max(unpack(ScreenYs))
	return true, X1, Y1, X2, Y2
end
GetVehicleBoundingBox = function(Vehicle)
	local VX, VY, VZ = VehicleGetPosXYZ(Vehicle)
	local Pitch, Roll, Yaw = VehicleGetRotation(Vehicle)
	
	-- get the eight corners
	--[[
		NOTE:
		
		This feature is NOT COMPATIBLE with customized, replaced, or remodeled vehicles because
		there is no reliable method to determine a vehicle's dimensions automatically. The pivot point
		of each vehicle model may vary, some use the bottom as their center, while others are centered
		around the middle of the mesh. Let alone new vehicles.
		
		In conclusion, manual adjustment is strongly recommended.
	]]
	local Dimension = ({
		-- bikes
		[272] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[273] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[274] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[279] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[277] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[278] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[280] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[281] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[283] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		[282] = {W = 1, L = 2.2, H = 1.4, Z = 0.1},
		
		-- motorcycles
		[276] = {W = 1, L = 2.2, H = 1.4, Z = 0.6},
		[275] = {W = 1.4, L = 2.8, H = 2.1, Z = 0.9},
		
		-- cars
		[286] = {W = 2.6, L = 5.6, H = 2.1, Z = -0.2},
		[290] = {W = 2.6, L = 5.8, H = 2.1, Z = -0.2},
		[292] = {W = 2.6, L = 5.6, H = 1.8, Z = -0.3},
		[293] = {W = 2.6, L = 6.5, H = 1.8, Z = -0.2},
		[295] = {W = 2.4, L = 5.4, H = 2.4, Z = -0.1},
		[294] = {W = 2.4, L = 5.4, H = 2.1, Z = -0.3},
		[291] = {W = 2.6, L = 5.8, H = 2.7, Z = -0.2},
		[296] = {W = 2.4, L = 4.7, H = 2.0, Z = -0.2},
		[297] = {W = 2.6, L = 5.2, H = 2.4, Z = -0.2},
		[288] = {W = 4.0, L = 7.7, H = 3.5, Z = -0.3},
		
		-- others
		[284] = {W = 1.7, L = 2.5, H = 1.6, Z = 0},
		[289] = {W = 1.4, L = 2.5, H = 1.4, Z = 0},
		[298] = {W = 1.7, L = 3.5, H = 0.9, Z = 0.4},
		[287] = {W = 2.4, L = 3.7, H = 1.3, Z = 0.2},
		[285] = {W = 1.8, L = 3.6, H = 1.0, Z = 0},
	})[VehicleGetModelId(Vehicle)]
	
	local HW = Dimension.W / 2
	local HL = Dimension.L / 2
	local HH = Dimension.H / 2
	local BoxCorners = {
		-- lower
		{-HW, -HL, -HH},	-- LB
		{HW, -HL, -HH},		-- RB
		{-HW, HL, -HH},		-- LF
		{HW, HL, -HH},		-- RF
		
		-- upper
		{-HW, -HL, HH},		-- LB
		{HW, -HL, HH},		-- RB
		{-HW, HL, HH},		-- LF
		{HW, HL, HH},		-- RF
	}
	
	-- get screen coords
	local CosY, SinY = math.cos(Yaw), math.sin(Yaw)
	local ScreenXs, ScreenYs = {}, {}
	for _, Corner in ipairs(BoxCorners) do
		local WorldX = VX + Corner[1] * CosY - Corner[2] * SinY
		local WorldY = VY + Corner[1] * SinY + Corner[2] * CosY
		local WorldZ = VZ + Dimension.Z + Corner[3]
		
		local ScreenX, ScreenY = GetScreenCoords(WorldX, WorldY, WorldZ)
		if not ScreenX or not ScreenY then
			return nil
		end
		table.insert(ScreenXs, ScreenX)
		table.insert(ScreenYs, ScreenY)
	end
	
	local X1, Y1 = math.min(unpack(ScreenXs)), math.min(unpack(ScreenYs))
	local X2, Y2 = math.max(unpack(ScreenXs)), math.max(unpack(ScreenYs))
	return true, X1, Y1, X2, Y2
end
GetObjectBoundingBox = function(Obj)
	local OX, OY, OZ = ObjectGetPosXYZ(Obj)
	local Pitch, Roll, Yaw = ObjectGetRotation(Obj)
	
	-- get the eight corners
	local Dimension = {
		W = 1,
		L = 1,
		H = 1,
		Z = 0
	}
	
	local HW = Dimension.W / 2
	local HL = Dimension.L / 2
	local HH = Dimension.H / 2
	local BoxCorners = {
		-- lower
		{-HW, -HL, -HH},	-- LB
		{HW, -HL, -HH},		-- RB
		{-HW, HL, -HH},		-- LF
		{HW, HL, -HH},		-- RF
		
		-- upper
		{-HW, -HL, HH},		-- LB
		{HW, -HL, HH},		-- RB
		{-HW, HL, HH},		-- LF
		{HW, HL, HH},		-- RF
	}
	
	-- get screen coords
	local CosY, SinY = math.cos(Yaw), math.sin(Yaw)
	local ScreenXs, ScreenYs = {}, {}
	for _, Corner in ipairs(BoxCorners) do
		local WorldX = OX + Corner[1] * CosY - Corner[2] * SinY
		local WorldY = OY + Corner[1] * SinY + Corner[2] * CosY
		local WorldZ = OZ + Dimension.Z + Corner[3]
		
		local ScreenX, ScreenY = GetScreenCoords(WorldX, WorldY, WorldZ)
		if not ScreenX or not ScreenY then
			return nil
		end
		table.insert(ScreenXs, ScreenX)
		table.insert(ScreenYs, ScreenY)
	end
	
	local X1, Y1 = math.min(unpack(ScreenXs)), math.min(unpack(ScreenYs))
	local X2, Y2 = math.max(unpack(ScreenXs)), math.max(unpack(ScreenYs))
	return true, X1, Y1, X2, Y2
end

GetWorldCoords = function(PointerX, PointerY)
	local CX, CY, CZ = CameraGetXYZ()
	local PX, PY, PZ = PlayerGetPosXYZ()
	local Pitch, Roll, Yaw = CameraGetRotation() -- radians
	
	-- avoid horizontal rays & fix yaw
	if Pitch > -0.1 and Pitch < 0.1 then
		Pitch = (Pitch < 0) and -0.1 or 0.1
	end
	Yaw = Yaw + math.pi / 2
	
	-- vector: forward, right, and up
	local FX, FY, FZ = GetVectorForward(Pitch, Yaw)
	local RX, RY, RZ = GetVectorRight(FX, FY, FZ)
	RX, RY, RZ = GetVectorNormalized(RX, RY, RZ)
	local UX, UY, UZ = GetVectorUp(FX, FY, FZ, RX, RY, RZ)
	UX, UY, UZ = GetVectorNormalized(UX, UY, UZ)
	
	-- convert normalized pointer to screen offset (-1 to 1)
	local Offset = CameraGetActive() == 14 and 2 or -2
	local OffsetX = (PointerX - 0.5) * Offset
	local OffsetY = (PointerY - 0.5) * Offset
	
	-- raycast direction: forward + right * X offset + up * Y offset
	local AR = GetDisplayAspectRatio()
	local FOV_Scale = math.tan(math.rad(CameraGetFOV()) / 2)
	local DirX = FX + RX * OffsetX * FOV_Scale + UX * OffsetY * (FOV_Scale / AR)
	local DirY = FY + RY * OffsetX * FOV_Scale + UY * OffsetY * (FOV_Scale / AR)
	local DirZ = FZ + RZ * OffsetX * FOV_Scale + UZ * OffsetY * (FOV_Scale / AR)
	DirX, DirY, DirZ = GetVectorNormalized(DirX, DirY, DirZ)
	
	-- check intersection with ground (since the object would be placed on ground)
	local Dist = (PZ - CZ) / DirZ
	if Dist < 0 or Dist > 100 then
		return nil
	end
	
	return CX + DirX * Dist, CY + DirY * Dist, CZ + DirZ * Dist, math.deg(Yaw - math.pi / 2)
end

GetVectorNormalized = function(X, Y, Z)
	-- normalize the vector to unit length (magnitude = 1)
	local Length = math.sqrt(X * X + Y * Y + Z * Z)
	return X / Length, Y / Length, Z / Length
end
GetVectorForward = function(Pitch, Yaw)
	local X = math.cos(Pitch) * math.cos(Yaw)
    local Y = math.cos(Pitch) * math.sin(Yaw)
    local Z = math.sin(Pitch)
	return X, Y, Z
end
GetVectorRight = function(FX, FY, FZ)
	local UX, UY, UZ = GetVectorUp()
	
	-- cross product (up x forward)
	local X = UY * FZ - UZ * FY
	local Y = UZ * FX - UX * FZ
	local Z = UX * FY - UY * FX
	return X, Y, Z
end
GetVectorUp = function(...)
	local Args = arg
	if not Args[1] then
		return 0, 0, 1 -- (world up vector / Z+ / Z constant whatever)
	end
	
	-- cross product (forward x right)
	local FX, FY, FZ = Args[1], Args[2], Args[3]
	local RX, RY, RZ = Args[4], Args[5], Args[6]
	
	local X = FY * RZ - FZ * RY
	local Y = FZ * RX - FX * RZ
	local Z = FX * RY - FY * RX
	return X, Y, Z
end

GetCameraRotationFromMouse = function(Pitch, Yaw, Sensitivity)
	Yaw = Yaw - MouseDX * Sensitivity
	Pitch = Pitch - MouseDY * Sensitivity
	Pitch = Clamp(Pitch, -math.pi / 2 + 0.01, math.pi / 2 - 0.01)
	return Pitch, Yaw
end
GetCameraPositionFromMovement = function(PosX, PosY, PosZ, FX, FY, FZ, RX, RY, RZ, Speed)
	if IsUsingJoystick(0) then
		return PosX, PosY, PosZ
	end
	local WS = GetStickValue(17, 0) / 10 * Speed
	local AD = GetStickValue(16, 0) / 10 * Speed
	
	local DirX = FX * WS + RX * AD
	local DirY = FY * WS + RY * AD
	local DirZ = FZ * WS + RZ * AD
	
	return PosX + DirX, PosY + DirY, PosZ + DirZ
end
GetCameraTransformFromInput = function(PosX, PosY, PosZ, Pitch, Yaw, Speed, Sensitivity)
	Pitch, Yaw = GetCameraRotationFromMouse(Pitch, Yaw, Sensitivity)
	local FX, FY, FZ = GetVectorForward(Pitch, Yaw)
	local RX, RY, RZ = GetVectorRight(FX, FY, FZ)
	RX, RY, RZ = GetVectorNormalized(RX, RY, RZ)
	
	PosX, PosY, PosZ = GetCameraPositionFromMovement(PosX, PosY, PosZ, FX, FY, FZ, RX, RY, RZ, Speed)
	
	local Dist = 4
	local LookX = PosX + FX * Dist
	local LookY = PosY + FY * Dist
	local LookZ = PosZ + FZ * Dist
	
	return PosX, PosY, PosZ, LookX, LookY, LookZ, Pitch, Yaw
end

GetArguments = function(...)
	if type(arg[1]) ~= 'number' and arg[1] ~= '#' then
		PrintOutput("bad argument #1 to 'GetArguments' (expected index, got "..tostring(arg[1])..")")
		return
	end
	
	if type(arg[1]) == 'number' and arg[1] + 1 <= table.getn(arg) then
		local result = {}
		for id = arg[1] + 1, table.getn(arg) do
			result[table.getn(result) + 1] = arg[id]
		end
		return unpack(result)
	end
	if arg[1] == '#' then
		return table.getn(arg) - 1
	end
	
	return
end
GetScriptEnv = function(Path)
	local Chunk, Message = loadfile(Path)
	if type(Chunk) ~= 'function' then
		print('Unable to load "'..Path..'": '..Message)
		return
	end
	
	local Env = {}
	setmetatable(Env, {__index = _G})
	setfenv(Chunk, Env)
	
	local Success, Result = pcall(Chunk)
	if not Success then
		print('Failed to execute "'..Path..'": '..Result)
		return
	end
	
	return Env
end
SwapEnv = function(...)
	local Args = arg
	local Path = string.format('%s%s/%s.lua', GetScriptFilePath(), 'Scripts/Native', Args[2])
	local Env = GetScriptEnv(Path)
	if type(Env) ~= 'table' then
		return
	end
	
	for Index = 3, table.getn(Args) do
		Args[1][Args[Index]] = Env[Args[Index]]
	end
end
Clamp = function(Value, Min, Max)
	return math.max(Min, math.min(Max, Value))
end
Lerp = function(Start, End, Time)
	return Start + (End - Start) * Time
end
GetFileName = function(Path)
	return string.gsub(Path, '^.+/(.-)%.%a+$', '%1')
end


-- # STRING #

GetSpeechVolumeName = function()
	return {
		[0] = 'Default',
		[1] = 'Speech',
		[2] = 'Generic',
		[2] = 'Small',
		[3] = 'Medium',
		[4] = 'Large',
		[5] = 'Extralarge',
		[6] = 'Jumbo',
		[7] = 'Supersize',
	}
end
GetVehicleColorsName = function()
	return {
		[0] = 'Black',
		[1] = 'White',
		[2] = 'Dark Blue',
		[3] = 'Cherry Red',
		[4] = 'Midnight Blue',
		[5] = 'Purple',
		[6] = 'Yellow',
		[7] = 'Striking Blue',
		[8] = 'Light Blue',
		[9] = 'Green',
		[10] = 'Red 01',
		[11] = 'Red 02',
		[12] = 'Red 03',
		[13] = 'Red 04',
		[14] = 'Red 05',
		[15] = 'Red 06',
		[16] = 'Red 07',
		[17] = 'Red 08',
		[18] = 'Red 09',
		[19] = 'Red 10',
		[20] = 'Orange 01',
		[21] = 'Orange 02',
		[22] = 'Orange 03',
		[23] = 'Orange 04',
		[24] = 'Orange 05',
		[25] = 'Orange 06',
		[26] = 'Orange 07',
		[27] = 'Orange 08',
		[28] = 'Orange 09',
		[29] = 'Orange 10',
		[30] = 'Yellow 01',
		[31] = 'Yellow 02',
		[32] = 'Yellow 03',
		[33] = 'Yellow 04',
		[34] = 'Yellow 05',
		[35] = 'Yellow 06',
		[36] = 'Yellow 07',
		[37] = 'Yellow 08',
		[38] = 'Yellow 09',
		[39] = 'Yellow 10',
		[40] = 'Green 01',
		[41] = 'Green 02',
		[42] = 'Green 03',
		[43] = 'Green 04',
		[44] = 'Green 05',
		[45] = 'Green 06',
		[46] = 'Green 07',
		[47] = 'Green 08',
		[48] = 'Green 09',
		[49] = 'Green 10',
		[50] = 'Blue 01',
		[51] = 'Blue 02',
		[52] = 'Blue 03',
		[53] = 'Blue 04',
		[54] = 'Blue 05',
		[55] = 'Blue 06',
		[56] = 'Blue 07',
		[57] = 'Blue 08',
		[58] = 'Blue 09',
		[59] = 'Blue 10',
		[60] = 'Purple 01',
		[61] = 'Purple 02',
		[62] = 'Purple 03',
		[63] = 'Purple 04',
		[64] = 'Purple 05',
		[65] = 'Purple 06',
		[66] = 'Purple 07',
		[67] = 'Purple 08',
		[68] = 'Purple 09',
		[69] = 'Purple 10',
		[70] = 'Grey 01',
		[71] = 'Grey 02',
		[72] = 'Grey 03',
		[73] = 'Grey 04',
		[74] = 'Grey 05',
		[75] = 'Grey 06',
		[76] = 'Grey 07',
		[77] = 'Grey 08',
		[78] = 'Grey 09',
		[79] = 'Grey 10',
		[80] = 'Light 01',
		[81] = 'Light 02',
		[82] = 'Light 03',
		[83] = 'Light 04',
		[84] = 'Light 05',
		[85] = 'Light 06',
		[86] = 'Light 07',
		[87] = 'Light 08',
		[88] = 'Light 09',
		[89] = 'Light 10',
		[90] = 'Dark 01',
		[91] = 'Dark 02',
		[92] = 'Dark 03',
		[93] = 'Dark 04',
		[94] = 'Dark 05',
		[95] = 'Blue',
		[96] = 'Green',
		[97] = 'Red',
		[98] = 'Blue',
		[99] = 'Off White'
	}
end