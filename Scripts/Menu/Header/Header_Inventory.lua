-- HEADER_INVENTORY.LUA
-- AUTHOR	: ALTAMURENZA


function SetWeapon(Player, Index)
	local Ped = Player and gPlayer or SelectPed(false)
	if not PedIsValid(Ped) then
		return
	end
	PedSetWeapon(Ped, Index, 50)
end

function CreateWeapon(Index)
	local X, Y, Z = SelectSpot()
	if type(X) ~= 'number' then
		return
	end
	PickupCreateXYZ(Index, X, Y, Z)
end

function ThrowProjectile(Index)
	local PosX, PosY, PosZ, LookX, LookY, LookZ = CameraGetXYZ()
	local Pitch, Roll, Yaw = CameraGetRotation()
	Yaw = Yaw + math.pi / 2
	
	SetQueuedMessage("THROWING PROJECTILES", [[
		Fly the camera around, anything in the center gets a projectile to the face.
		Press ~t~ ~t~ ~t~ ~t~ to move around.
		Move ~t~ to adjust the angle.
		Press ~t~ to throw.
		Press ~t~ to stop.
	]], -1, {
		GetHudTexture('Button_W'),
		GetHudTexture('Button_A'),
		GetHudTexture('Button_S'),
		GetHudTexture('Button_D'),
		GetHudTexture('Button_Mouse_Button_plain'),
		GetHudTexture('Button_Left_Mouse_Button'),
		GetHudTexture('Button_Right_Mouse_Button')
	})
	
	local Projectile = ({
		[303] = 304,
		[305] = 316,
		[306] = 322,
		[307] = 308,
		[396] = 316,
	})[Index] or Index
	local Damage = GetProjectileDamage(Projectile)
	local Timer = nil
	
	SoundSetAudioFocusCamera()
	repeat
		ToggleShow()
		if PlayerHasControl() then
			PlayerSetControl(0)
		end
		
		CameraAllowChange(true)
		PosX, PosY, PosZ, LookX, LookY, LookZ, Pitch, Yaw = GetCameraTransformFromInput(
			PosX, PosY, PosZ, Pitch, Yaw, 1, 1.5
		)
		CameraSetXYZ(PosX, PosY, PosZ, LookX, LookY, LookZ)
		CameraAllowChange(false)
		
		if IsMouseBeingPressed(0) or (Timer and Timer < GetTimer()) then
			if Timer and Timer < GetTimer() then
				local DirX, DirY, DirZ = GetVectorForward(Pitch, Yaw)
				CreateProjectile(Projectile, PosX, PosY, PosZ, DirX, DirY, DirZ, Damage)
				Timer = GetTimer() + 100
			elseif IsMouseBeingPressed(0) then
				local DirX, DirY, DirZ = GetVectorForward(Pitch, Yaw)
				CreateProjectile(Projectile, PosX, PosY, PosZ, DirX, DirY, DirZ, Damage)
				Timer = GetTimer() + 500
			end
		elseif not IsMousePressed(0) then
			Timer = nil
		end
		
		Wait(0)
	until IsMenuPressed(1)
	SoundSetAudioFocusPlayer()
	StopQueueMessage()
	PlayerSetControl(1)
	
	CameraAllowChange(true)
	CameraReturnToPlayer(false)
end

function GetProjectileDamage(Index)
	return ({
		[301] = 60,
		[302] = 10,
		[304] = 15,
		[308] = 80,
		[309] = 0,
		[310] = 3,
		[311] = 5,
		[312] = 3,
		[313] = 5,
		[314] = 3,
		[315] = 10,
		[316] = 80,
		[317] = 3,
		[318] = 40,
		[319] = 25,
		[320] = 1,
		[322] = 20,
		[324] = 50,
		[325] = 40,
		[327] = 5,
		[329] = 10,
		[330] = 10,
		[331] = 15,
		[332] = 30,
		[333] = 3,
		[334] = 3,
		[335] = 5,
		[336] = 3,
		[337] = 50,
		[338] = 10,
		[339] = 1,
		[340] = 1,
		[341] = 1,
		[343] = 5,
		[344] = 3,
		[354] = 20,
		[353] = 20,
		[345] = 20,
		[346] = 5,
		[348] = 5,
		[349] = 5,
		[350] = 10,
		[351] = 15,
		[352] = 5,
		[355] = 5,
		[356] = 3,
		[358] = 5,
		[359] = 5,
		[361] = 1,
		[362] = 5,
		[363] = 3,
		[365] = 10,
		[366] = 5,
		[369] = 5,
		[367] = 3,
		[368] = 3,
		[370] = 3,
		[371] = 3,
		[373] = 5,
		[374] = 5,
		[375] = 10,
		[376] = 5,
		[378] = 3,
		[379] = 5,
		[380] = 25,
		[381] = 3,
		[382] = 20,
		[383] = 3,
		[384] = 15,
		[385] = 3,
		[386] = 1,
		[388] = 5,
		[392] = 1,
		[393] = 1,
		[394] = 5,
		[398] = 1,
		[399] = 3,
		[401] = 3,
		[404] = 3,
		[305] = 5,
		[413] = 5,
		[414] = 5,
		[415] = 5,
		[416] = 5,
		[417] = 70,
		[406] = 3,
		[407] = 3,
		[408] = 5,
		[412] = 5,
		[419] = 5,
		[421] = 3,
		[422] = 3,
		[423] = 1,
		[424] = 20,
		[425] = 3,
		[427] = 3,
		[428] = 3,
		[429] = 3,
		[430] = 3,
		[431] = 3,
		[432] = 3,
		[433] = 5,
		[434] = 1,
		[435] = 3,
		[436] = 3,
		[438] = 3,
		[439] = 1,
		[440] = 1,
		[441] = 1,
		[442] = 1,
		[443] = 1,
		[444] = 1,
	})[Index] or 0
end