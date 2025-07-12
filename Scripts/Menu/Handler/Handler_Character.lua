-- HANDLER_CHARACTER.LUA
-- AUTHOR	: ALTAMURENZA


---------------------------------
-- # THREAD: MOVEMENT & TOGGLES #
---------------------------------

-- MOVEMENT

local function IsPlayerFree(Movement, Style)
	return PedIsPlaying(gPlayer, '/Global/Player/Default_KEY', true)
		or PedIsPlaying(gPlayer, Style..'/Default_KEY', true)
		or PedIsPlaying(gPlayer, '/Global/'..Movement..'/Default_KEY/ExecuteNodes/Free/WalkBasic', true)
		or PedIsPlaying(gPlayer, '/Global/'..Movement..'/Default_KEY/ExecuteNodes/Free/RunBasic', true)
		or PedIsPlaying(gPlayer, '/Global/'..Movement..'/Default_KEY/ExecuteNodes/Free/SprintBasic', true)
end

local function IsUsingMovement(Code)
	if Code == 'Player' then
		return
	end
	
	return PedGetControllerID(gPlayer) == 0
		and PlayerHasControl()
		and PedHasWeapon(gPlayer, -1)
		and not PedGetFlag(gPlayer, 2)
		and not PlayerIsInAnyVehicle()
end

local function IsThumbShifting()
	local MoveLR = math.abs(GetStickValue(16, 0))
	local MoveFB = math.abs(GetStickValue(17, 0))
	
	return MoveLR + MoveFB >= 0.1 and not IsButtonPressed(10, 0)
end

local function DetermineMotion(TapCount, HoldTime)
	if TapCount > 1 then
		return 'SprintBasic'
	elseif IsButtonPressed(7, 0) or GetTimer() < HoldTime + 300 then
		return 'RunBasic'
	end
	
	return 'WalkBasic'
end

local function ExecuteMotion(Movement, Motion)
	local Animation = '/Global/'..Movement[1]..'/Default_KEY/ExecuteNodes/Free/'..Motion
	PedSetActionNode(gPlayer, Animation, 'Act/Anim/'..Movement[1]..'.act')
	
	local Target = PedGetTargetPed(gPlayer)
	if IsButtonBeingPressed(8, 0) then
		PedSetActionNode(gPlayer, '/Global/Player/JumpActions/Jump', 'Act/Anim/Player.act')
	end
	if PedIsValid(Target) and IsButtonBeingPressed(9, 0) then
		PedSetActionNode(gPlayer, '/Global/Actions/Grapples/RunningTakedown', 'Act/Globals.act')
	end
	
	local RunningAttack = ({
		['RunBasic'] = {
			'/Global/Actions/Offense/RunningAttacks/RunningAttacksDirect', 
			'Act/Globals.act'
		},
		['SprintBasic'] = {
			'/Global/Player/Attacks/Strikes/RunningAttacks/HeavyAttacks/RunShoulder', 
			'Act/Player.act'
		}
	})[Motion]
	if IsButtonBeingPressed(6, 0) and RunningAttack then
		PedSetActionNode(gPlayer, unpack(RunningAttack))
	end
end

local function HandleMovement(Movement, Style)
	if IsButtonBeingPressed(7, 0) then
		Movement[3], Movement[4] = Movement[3] + 1, GetTimer()
	elseif GetTimer() >= Movement[4] + 300 then
		Movement[3] = 0
	end
	
	if not IsPlayerFree(Movement[1], Style[1]) then
		return
	end
	if IsThumbShifting() then
		Movement[2] = true
		
		local Motion = DetermineMotion(Movement[3], Movement[4])
		ExecuteMotion(Movement, Motion)
	elseif Movement[2] then
		Movement[2] = false
		PedSetActionNode(gPlayer, unpack(Style))
	end
end

-- TOGGLE

local function ToggleImmortal()
	if not PedGetFlag(gPlayer, 58) then
		PedSetFlag(gPlayer, 58, true)
	end
	
	if PedGetHealth(gPlayer) < 1 then
		local Node = 'Front/KD_DROP_Default'
		local Enemy = PedGetWhoHitMeLast(gPlayer)
		if PedIsValid(Enemy) then
			Node = PedIsFacingObject(gPlayer, Enemy, 2, 180) and Node or 'Rear/Rear'
		end
		
		PedSetActionNode(gPlayer, '/Global/HitTree/KnockOuts/'..Node, 'Act/HitTree.act')
		PedSetHealth(gPlayer, 50)
	end
	
	local Target = PedGetGrappleTargetPed(gPlayer)
	if not PedIsValid(Target) or not PedMePlaying(Target, 'EarGrab') then
		return
	end
	if not PedMePlaying(gPlayer, 'Break_GIVE') then
		PedSetActionNode(gPlayer, 
			'/Global/Actions/Grapples/GrappleReversals/StandingReversals/GrappleBreak/Break_GIVE', 
			'Act/Globals.act'
		)
	end
end

local function ToggleInvisible()
	if not PedGetFlag(gPlayer, 9) then
		PedSetFlag(gPlayer, 9, true)
	end
end

local function ToggleInnocent()
	DisablePunishmentSystem(true)
	if PedGetFlag(gPlayer, 117) then
		PedSetFlag(gPlayer, 117, false)
	end
	
	if PlayerGetPunishmentPoints() > 0 then
		PlayerSetPunishmentPoints(0)
	end
	
	local Stimulus = {
		[66] = true, [67] = true, [68] = true, 
		[78] = true, [79] = true
	}
	for Stimuli in pairs(Stimulus) do
		if PedHasGeneratedStimulusOfType(gPlayer, Stimuli) then
			PedRemoveStimulus(gPlayer, Stimuli)
		end
	end
end

local function ToggleLethalHit(Ped)
	if not PedIsValid(Ped) or Ped == gPlayer then
		return
	end
	if PedMePlaying(Ped, 'HitTree') and PedGetWhoHitMeLast(Ped) == gPlayer then
		PedApplyDamage(Ped, PedGetMaxHealth(Ped) + 5)
	end
end

local function ToggleMute(Ped)
	if not PedIsValid(Ped) or Ped == gPlayer then
		return
	end
	if not PedGetFlag(Ped, 129) then
		PedSetFlag(Ped, 129, true)
	end
end

local function ToggleAmmo()
	if not PedGetFlag(gPlayer, 24) then
		PedSetFlag(gPlayer, 24, true)
	end
	
	if PedHasWeapon(gPlayer, -1) or not IsButtonBeingReleased(12, 0) then
		return
	end
	local Weapon = PedGetWeapon(gPlayer)
	local Ammo = ({[305] = 316, [396] = 316, [307] = 308})[Weapon]
	GiveAmmoToPlayer(Ammo or Weapon, 50, false)
end

-- THREAD

CreateThread(function()
	while true do
		if IsUsingMovement(PlayerSettings.Movement[1]) then
			HandleMovement(PlayerSettings.Movement, PlayerSettings.Style)
		end
		
		if PlayerSettings.Immortal then
			ToggleImmortal()
		end
		if PlayerSettings.Invisible then
			ToggleInvisible()
		end
		if PlayerSettings.Innocent then
			ToggleInnocent()
		end
		if PlayerSettings.LethalHit then
			for Ped in AllPeds() do
				ToggleLethalHit(Ped)
			end
		end
		if PlayerSettings.InfiniteAmmo then
			ToggleAmmo()
		end
		if not NPCSettings.Population then
			StopPedProduction(true)
		end
		
		Wait(0)
	end
end)


----------------------------------------
-- # THREAD: FIX MODEL & PLAYER ACTION #
----------------------------------------

-- FIX MODEL

local IncompatibleMissions = {
	'1_02B',
	'3_08',
	'2_08',
	'2_09',
	'3_01C',
	'4_05',
	'4_06',
	'6_01',
	'5_03',
	'3_R09_J3',
	'C_WRESTLING_1',
	'C_WRESTLING_2',
	'C_WRESTLING_3',
	'C_WRESTLING_4',
	'C_WRESTLING_5',
	'1_11x1',
	'1_11x2',
	'3_01C',
	'3_R09_P3',
	'2_R11_Chad',
	'2_R11_Bryce',
	'2_R11_Justin',
	'2_R11_Parker',
	'2_R11_Random',
	'C_Dodgeball_1',
	'C_Dodgeball_2',
	'C_Dodgeball_3',
	'C_Dodgeball_4',
	'C_Dodgeball_5',
}

local function IsMissionCompatibleWithModels()
	for _, Code in ipairs(IncompatibleMissions) do
		if MissionActiveSpecific(Code) then
			return false
		end
	end
	return true
end

local function ChangeToPlayerUntil(Key)
	if type(Key) == 'nil' then
		SetModel(true, PlayerSettings.Model, PlayerSettings.Style)
		return
	end
	
	PlayerSwapModel('player')
	repeat
		Wait(0)
	until not shared[Key]
	SetModel(true, PlayerSettings.Model, PlayerSettings.Style)
end

local function HandleModel(IsJimmy)
	if IsJimmy then
		return
	end
	
	if shared.PlayerInClothingManager then
		ChangeToPlayerUntil('PlayerInClothingManager')
	elseif shared.playerShopping and AreaGetVisible() ~= 50 then
		ChangeToPlayerUntil('playerShopping')
	end
	if MissionActive() and not IsMissionCompatibleWithModels() then
		ChangeToPlayerUntil()
	end
end

-- PLAYER ACTION

local PedCategories = {
	ADULT_MALE = {
		[56] = true, [76] = true, [77] = true, [84] = true, [86] = true, [89] = true, 
		[100] = true, [101] = true, [103] = true, [104] = true, [105] = true, [108] = true,
		[113] = true, [114] = true, [115] = true, [116] = true, [123] = true, [124] = true, 
		[127] = true, [128] = true, [144] = true, [148] = true, [149] = true, [152] = true, 
		[156] = true, [180] = true, [190] = true, [194] = true, [195] = true, [222] = true, 
		[223] = true, [236] = true, [237] = true, [252] = true, [253] = true, [254] = true,
	},
	ADULT_FEMALE = {
		[78] = true, [79] = true, [80] = true, [81] = true, [120] = true, [143] = true, 
		[191] = true, [192] = true, [193] = true,
	},
	TEACHER_MALE = {
		[55] = true, [56] = true, [57] = true, [61] = true, [64] = true, [65] = true, 
		[229] = true, [248] = true, [249] = true,
	},
	TEACHER_FEMALE = {
		[54] = true, [58] = true, [59] = true, [60] = true, [62] = true, [63] = true, [221] = true,
	},
	STUDENT_FEMALE = {
		[2] = true, [3] = true, [14] = true, [25] = true, [38] = true, [39] = true, 
		[48] = true, [67] = true, [90] = true, [93] = true, [94] = true, [95] = true, 
		[96] = true, [166] = true, [167] = true, [175] = true, [180] = true, [181] = true, 
		[182] = true, [230] = true
	},
	PREFECT = {
		[49] = true, [50] = true, [51] = true, [52] = true,
	},
	ORDERLY = {
		[53] = true, [158] = true,
	}
}

local function IsButtonBeingPressed_S(Button, Controller)
	local Type, Code = GetInputHardware(Button, Controller)
	if type(STRAFE_KEY) == 'table' and Type == 'keyboard' and STRAFE_KEY[Code] then
		return false
	end
	return IsButtonBeingPressed(Button, Controller)
end

local function IsPedCategory(Ped, Category)
	local Group = PedCategories[Category]
	return Group and Group[PedGetModelId(Ped)] or false
end

local function ExecuteGrapple(Target, Style)
	local IsUsingMaleStyle = string.find(Style, 'GS_Male_A') or string.find(Style, 'CV_Male_A')
	local IsUsingAuthorityStyle = string.find(Style, 'Authority') or string.find(Style, 'LE_Orderly_A')
	local IsAdult = IsPedCategory(gPlayer, 'ADULT_MALE')
	local IsAuthority = IsPedCategory(gPlayer, 'PREFECT') or IsPedCategory(gPlayer, 'ORDERLY') or IsPedCategory(gPlayer, 'TEACHER_MALE')

	PedSetGrappleTarget(gPlayer, Target)
	if IsAdult and IsUsingMaleStyle then
		PedSetActionNode(gPlayer, '/Global/Actions/Grapples/Front/Grapples/GrappleMoves/Adult_Takedown', 'Act/Globals.act')
	elseif IsAuthority or IsUsingAuthorityStyle then
		PedSetActionNode(gPlayer, '/Global/Actions/Grapples/Front/Grapples/GrappleMoves/Tonfa_Impale/TonfaImpale', 'Act/Globals.act')
	end
end

local function HandleTauntOrShove(Target, Taunt)
	if PedIsDead(Target) then
		PedSetActionNode(gPlayer, '/Global/Player/Social_Speech/Taunts', 'Act/Player.act')
		if not SoundSpeechPlaying(gPlayer, Taunt) then
			SoundPlayAmbientSpeechEvent(gPlayer, Taunt)
		end
		return
	end

	local CanHumiliate = PedGetHealth(Target) <= GameGetPedStat(Target, 63)
	if CanHumiliate then
		PedSetGrappleTarget(gPlayer, Target)
		PedSetActionNode(gPlayer, '/Global/Ambient/SocialAnims/SocialHumiliateAttack/AnimLoadTrigger', 'Act/Anim/Ambient.act')
		return
	end

	PedSetActionNode(gPlayer, '/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove', 'Act/Player.act')
	if not SoundSpeechPlaying(gPlayer, Taunt) then
		SoundPlayAmbientSpeechEvent(gPlayer, Taunt)
	end
end

local function HandleInteraction(IsJimmy, Style)
	if not PedMePlaying(gPlayer, 'DEFAULT_KEY') or PedGetControllerID(gPlayer) ~= 0 or not PlayerHasControl() then
		return
	end

	local IsMoving = GetStickValue(17, 0) >= 0.1
	local IsUsingPlayerStyle = string.find(Style, 'Player')
	local IsBareFist = PedHasWeapon(gPlayer, -1)
	if not IsMoving and not IsUsingPlayerStyle and IsBareFist and IsButtonBeingPressed_S(15, 0) then
		PedSetFlag(gPlayer, 2, not PedGetFlag(gPlayer, 2))
	end

	local Target = PedGetTargetPed(gPlayer)
	if not PedIsValid(Target) then
		return 
	end

	local IsCrouching = PedGetFlag(gPlayer, 2)
	if IsCrouching then
		if IsButtonBeingPressed_S(9, 0) then
			local GrappleNode = IsButtonPressed(7, 0) and 'RunningTakedown' or 'Front/Grapples/GrappleAttempt'
			PedSetActionNode(gPlayer, '/Global/Actions/Grapples/' .. GrappleNode, 'Act/Globals.act')
		end
		return
	end

	local X1, Y1, Z1 = PlayerGetPosXYZ()
	local X2, Y2, Z2 = PedGetPosXYZ(Target)
	local Dist = DistanceBetweenCoords3d(X1, Y1, Z1, X2, Y2, Z2)

	local Taunt = IsJimmy and 'PLAYER_TAUNT' or 'TAUNT'
	local Greet = IsJimmy and 'PLAYER_GREET' or 'GREET'

	if not IsUsingPlayerStyle and IsBareFist then
		if Dist > 2 then
			if IsButtonBeingPressed_S(8, 0) then
				PedSetActionNode(gPlayer, '/Global/Player/Social_Speech/Taunts', 'Act/Player.act')
				if not SoundSpeechPlaying(gPlayer, Taunt) then
					SoundPlayAmbientSpeechEvent(gPlayer, Taunt)
				end
			end
			return
		end

		if IsButtonBeingPressed_S(9, 0) then
			ExecuteGrapple(Target, Style)
			return
		end

		if IsButtonBeingPressed_S(8, 0) then
			HandleTauntOrShove(Target, Taunt)
		end
	elseif IsUsingPlayerStyle or not IsBareFist then
		if IsButtonBeingPressed_S(8, 0) and not SoundSpeechPlaying(gPlayer, Taunt) then
			SoundPlayAmbientSpeechEvent(gPlayer, Taunt)
		elseif IsButtonBeingPressed_S(7, 0) and not SoundSpeechPlaying(gPlayer, Greet) then
			SoundPlayAmbientSpeechEvent(gPlayer, Greet)
		end
	end
end

local function HandleRunning(IsJimmy, Style)
	if MissionActiveSpecific('3_B') or not PedHasWeapon(gPlayer, -1) or PedGetFlag(gPlayer, 2) then
		return
	end
	
	local IsUsingPlayerStyle = string.find(Style, 'Player')
	if not IsJimmy or not IsUsingPlayerStyle then
		PedSetAITree(gPlayer, '/Global/PlayerAI', 'Act/PlayerAI.act')
	end
end

local function HandleWeapon()
	local HasDigitalCamera = PedHasWeapon(gPlayer, 426)
	if PedHasWeapon(gPlayer, 328) or HasDigitalCamera then
		HUDPhotographySetColourUpgrade(HasDigitalCamera)
	end
	
	local Node = '/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove/SmashInnaFaceStink'
	if not PedHasWeapon(gPlayer, 309) or not PedIsPlaying(gPlayer, Node, true) then
		return
	end
	local IsCheating = PedGetFlag(gPlayer, 24)
	PedSetFlag(gPlayer, 24, true)
	
	repeat
		Wait(0)
	until not PedIsPlaying(gPlayer, Node, true)
	PedSetFlag(gPlayer, 24, IsCheating)
	
	if IsCheating then
		GiveAmmoToPlayer(309, 1, false)
	end
end

-- THREAD

CreateThread(function()
	while true do
		local IsPlayerJimmy = PedIsModel(gPlayer, 0)
		
		if not IsPlayerJimmy or PlayerSettings.Style[1] ~= '/Global/Player' then
			--HandleModel(IsPlayerJimmy)
			HandleInteraction(IsPlayerJimmy, PlayerSettings.Style[1])
		end
		HandleRunning(IsPlayerJimmy, PlayerSettings.Style[1])
		HandleWeapon()
		
		Wait(0)
	end
end)


----------------------------
-- # THREAD: CUSTOM ACTION #
----------------------------

local Conditional ={
	['/Global/BoxingPlayer/EvadeBank/Evades/Left'] = 'AI_FLAG',
	['/Global/BoxingPlayer/EvadeBank/Evades/Right'] = 'AI_FLAG',
	['/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/LeftCharge'] = 'AI_FLAG',
	['/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/RightCharge'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Defense/Evade/EvadeDuck'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Defense/Evade/EvadeRight'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Defense/Evade/EvadeLeft'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Offense/Medium/Medium/HeavyAttacks/JAB'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Offense/Short/Strikes/HeavyAttacks/Hook2'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftJab'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftHook'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Offense/Short/Strikes/Unblockable/HeavyPunchCharge/HeavyPunch'] = 'AI_FLAG',
	['/Global/BOSS_Darby/Offense/Special/Dash/Dash/Uppercut/ShortDarby'] = 'AI_FLAG',
	['/Global/P_Bif/Offense/Short/LightAttacks'] = 'AI_FLAG',
	['/Global/P_Bif/Offense/Short/HeavyAttacks/LeftHook'] = 'AI_FLAG',
	['/Global/P_Bif/Offense/Short/HeavyAttacks/RightHook'] = 'AI_FLAG',
	['/Global/P_Bif/Offense/Medium/HeavyAttacks/GutPunch'] = 'AI_FLAG',
	['/Global/P_Bif/Offense/Medium/HeavyAttacks/StraightPunch'] = 'AI_FLAG',
	['/Global/P_Bif/Defense/Evade/EvadeLeft'] = 'AI_FLAG',
	['/Global/P_Bif/Defense/Evade/EvadeRight'] = 'AI_FLAG',
	['/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeLeftPunch'] = 'AI_FLAG',
	['/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeRightPunch'] = 'AI_FLAG',
	['/Global/G_Johnny/Offense/Short/Strikes/LightAttacks'] = 'AI_FLAG',
	['/Global/G_Johnny/Offense/Short/Strikes/HeavyKick/HeavyKick'] = 'AI_FLAG',
	['/Global/G_Johnny/Offense/Medium/Strikes/HeavyAttack'] = 'AI_FLAG',
	['/Global/G_Johnny/Offense/Medium/Strikes/HeavyAttack/HeavyKick'] = 'AI_FLAG',
	['/Global/G_Melee_A/Offense/Medium/Strikes/HeavyAttacks/HeavyKick'] = 'AI_FLAG',
	['/Global/J_Striker_A/Offense/Medium/Grapples/GrapplesAttempt'] = 'AI_FLAG',
	['/Global/J_Grappler_A/Offense/Medium/Strikes/HeavyAttacks/RightPunch'] = 'AI_FLAG',
	['/Global/J_Mascot/Offense/Short'] = 'AI_FLAG',
	['/Global/J_Ted/Default_KEY/ExecuteNodes/BlockProjectiles'] = 'AI',
	['/Global/J_Ted/Offense/Medium/Grapples/GrapplesAttempt'] = 'AI',
	['/Global/Crazy_Basic/Offense/Medium'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/Mount/GrappleMoves/FacePunch/Hit1'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Player/KneeDrop'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Player/Spit'] = 'AI',
	['/Global/Actions/Grapples/Mount/GrappleMoves/Headbutt'] = 'AI',
	['/Global/Actions/Grapples/Mount/MountOpps/Dropout/HeadButt'] = 'AI',
	['/Global/Actions/Grapples/Mount/MountOpps/Dropout/KneeDrop'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Jock/FacePunch'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Jock/KneeDrop'] = 'AI',
	['/Global/G_Johnny/Offense/Short/Strikes/HeavyKick/HeavyKick/Grabknees/GV'] = 'AI',
	['/Global/G_Striker_A/Offense/Short/Strikes/HeavyAttacks/HeavyKick/GrabKnees'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/GrappleOpps/Melee/Greaser/GrabKnees/GV'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BearHug'] = 'AI',
	['/Global/J_Damon/Offense/Medium/Grapples/GrapplesAttempt/TakeDown'] = 'AI',
	['/Global/J_Mascot/Offense/Special/Mascot/Mascot/SpecialChoose/Headbutt/Invincible/Headbutt'] = 'AI',
	['/Global/J_Mascot/Offense/Dance/Dancing'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/GrappleMoves/Adult_Takedown'] = 'AI',
	['/Global/Actions/Grapples/Front/Grapples/GrappleMoves/TandemGrapple'] = 'AI',
	['/Global/WrestlingACT/Attacks/Grapples/Grapples/BackGrapples/Choke'] = 'AI',
}
local CannotBeForced = {
	['/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BackBreaker'] = true,
	['/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BearHug'] = true,
	['/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BodySlam'] = true,
	['/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GirlFight/GirlFight_START'] = true,
	['/Global/Actions/Grapples/Front/Grapples/GrappleOpps/Default/DirectionalPush/PushFwd'] = true,
	['/Global/Actions/Grapples/Front/Grapples/Mount/GrappleMoves/FacePunch/Hit1'] = true,
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Jock/FacePunch'] = true,
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Jock/KneeDrop'] = true,
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Player/KneeDrop'] = true,
	['/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Player/Spit'] = true,
	['/Global/Authority/Defense/Counter/Counter'] = true,
	['/Global/Authority/Defense/Counter/Grapple'] = true,
	['/Global/BOSS_Darby/Defense/Block/Block/BlockHits'] = true,
	['/Global/BOSS_Darby/Defense/Evade/EvadeDuck'] = true,
	['/Global/BOSS_Darby/Defense/Evade/EvadeLeft'] = true,
	['/Global/BOSS_Darby/Defense/Evade/EvadeRight'] = true,
	['/Global/BOSS_Darby/Offense/Medium/Medium/HeavyAttacks/JAB'] = true,
	['/Global/BOSS_Darby/Offense/Medium/Medium/HeavyAttacks/JAB/Cross'] = true,
	['/Global/BOSS_Darby/Offense/NonCombatActions/Hopback'] = true,
	['/Global/BOSS_Darby/Offense/Short/Grapples/HeavyAttacks/Catch_Throw'] = true,
	['/Global/BOSS_Darby/Offense/Short/Grapples/HeavyAttacks/Catch_Throw/Finisher'] = true,
	['/Global/BOSS_Darby/Offense/Short/Strikes/HeavyAttacks/Hook2'] = true,
	['/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftHook'] = true,
	['/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftJab'] = true,
	['/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftJab/Hook'] = true,
	['/Global/BOSS_Darby/Offense/Short/Strikes/Unblockable/HeavyPunchCharge/HeavyPunch'] = true,
	['/Global/BOSS_Darby/Offense/Special/Dash/Dash/Uppercut/ShortDarby'] = true,
	['/Global/BOSS_Darby/Offense/Special/HeavyAttacks'] = true,
	['/Global/BOSS_Russell/Defense/Evade/EvadeInterrupt/EvadeInterrupt'] = true,
	['/Global/BOSS_Russell/Offense/GroundAttack/GroundStomp1'] = true,
	['/Global/BOSS_Russell/Offense/Medium/Strikes/Unblockable/DoubleAxeHandle'] = true,
	['/Global/BOSS_Russell/Offense/Short/Strikes/LightAttacks/OverHand'] = true,
	['/Global/BOSS_Russell/Offense/Special/Invincible/BarserkGrapple'] = true,
	['/Global/BOSS_Russell/Offense/Special/Invincible/HeadButt/HeadButt_AnticStart'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left1/Release/JAB'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left1/Release/Unblockable'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left3/Release/Hook'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left3/Release/Unblockable'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left5/Release/Unblockable'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left5/Release/Uppercut'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right2/Release/Cross'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right2/Release/Unblockable'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right4/Release/GutPunch'] = true,
	['/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right4/Release/Unblockable'] = true,
	['/Global/BoxingPlayer/EvadeBank/Evades/Duck'] = true,
	['/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/BackCharge'] = true,
	['/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/LeftCharge'] = true,
	['/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/RightCharge'] = true,
	['/Global/BoxingPlayer/EvadeBank/Evades/Left'] = true,
	['/Global/BoxingPlayer/EvadeBank/Evades/Right'] = true,
	['/Global/CV_Male_A/Defense/Counter/Counter'] = true,
	['/Global/Crazy_Basic/Offense/Medium/GrapplesNEW/GrapplesAttempt'] = true,
	['/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R'] = true,
	['/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R/WindMill_L'] = true,
	['/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R/WindMill_L/HeavyAttacks/SwingPunch_R'] = true,
	['/Global/DO_Edgar/Defense/Evade/DropAndCounter'] = true,
	['/Global/DO_Edgar/Defense/Evade/DropAndCounter/Unblockable2/DuckCharge'] = true,
	['/Global/DO_Edgar/Defense/Evade/DropToFloor'] = true,
	['/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1'] = true,
	['/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1/Punch2'] = true,
	['/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1/Punch2/HeavyAttacks/Punch3'] = true,
	['/Global/DO_Striker_A/Offense/Short/LightAttacks/Punch1'] = true,
	['/Global/DO_Striker_A/Offense/Short/LightAttacks/Punch1/Punch2'] = true,
	['/Global/DO_Striker_A/Offense/Short/LightAttacks/Punch1/Punch2/HeavyAttacks/Punch3'] = true,
	['/Global/G_Johnny/Offense/Short/Strikes/HeavyKick/HeavyKick'] = true,
	['/Global/G_Johnny/Offense/Short/Strikes/HeavyKick/HeavyKick/Grabknees/GV'] = true,
	['/Global/G_Johnny/Offense/Short/Strikes/LightAttacks'] = true,
	['/Global/G_Ranged_A/Offense/Medium/Strikes/HeavyAttacks/HeavyKnee'] = true,
	['/Global/G_Ranged_A/Offense/Short/Strikes/LightAttacks/RightHook'] = true,
	['/Global/G_Ranged_A/Offense/Short/Strikes/LightAttacks/RightHook/HeavyKnee'] = true,
	['/Global/G_Striker_A/Offense/Short/Strikes/HeavyAttacks/HeavyKick/GrabKnees/GV'] = true,
	['/Global/G_Striker_A/Offense/Taunts/Taunt_B'] = true,
	['/Global/J_Damon/Offense/Medium/Grapples/GrapplesAttempt/TakeDown'] = true,
	['/Global/J_Damon/Offense/SpecialStart/StartRun'] = true,
	['/Global/J_Mascot/Offense/Dance/Dancing'] = true,
	['/Global/J_Mascot/Offense/Medium/Strikes/LightAttacks/WindMill_R/HeavyAttacks/SwingPunch_R'] = true,
	['/Global/J_Ted/Default_KEY/ExecuteNodes/BlockProjectiles'] = true,
	['/Global/J_Ted/Defense/Block/Block/BlockHits'] = true,
	['/Global/J_Ted/Offense/Medium/Grapples/GrapplesAttempt'] = true,
	['/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB'] = true,
	['/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB/Elbow'] = true,
	['/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB/Elbow/HeavyAttacks/Uppercut'] = true,
	['/Global/N_Earnest/Offense/FireSpudGun'] = true,
	['/Global/N_Earnest/Offense/ThrowBombs'] = true,
	['/Global/N_Ranged_A/Defense/Flail'] = true,
	['/Global/Nemesis/Offense/Medium/Strikes/LightAttacks/OverHandR/HeavyAttacks​/Knee'] = true,
	['/Global/P_Bif/Defense/Evade/EvadeDuck'] = true,
	['/Global/P_Bif/Defense/Evade/EvadeLeft'] = true,
	['/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeDuckPunch'] = true,
	['/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeLeftPunch'] = true,
	['/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeRightPunch'] = true,
	['/Global/P_Bif/Defense/Evade/EvadeRight'] = true,
	['/Global/P_Bif/Offense/Medium/HeavyAttacks/GutPunch'] = true,
	['/Global/P_Bif/Offense/Medium/HeavyAttacks/StraightPunch'] = true,
	['/Global/P_Bif/Offense/Short/HeavyAttacks/LeftHook'] = true,
	['/Global/P_Bif/Offense/Short/HeavyAttacks/RightHook'] = true,
	['/Global/P_Bif/Offense/Short/LightAttacks/JAB'] = true,
	['/Global/P_Bif/Offense/Short/LightAttacks/Jab/Cross'] = true,
	['/Global/P_Bif/Offense/Special/HeavyAttacks'] = true,
	['/Global/P_Striker_A/Defense/Evade/EvadeBack'] = true,
	['/Global/P_Striker_A/Defense/Evade/EvadeCounter'] = true,
	['/Global/Player/Attacks/Strikes/LightAttacks/Left1/Release/JAB'] = true,
	['/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Release/Hook'] = true,
	['/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Right4/Release/Unblockable/HighKick'] = true,
	['/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Release/Cross'] = true,
	['/Global/Russell_102/Offense/Short/Medium/RisingAttacks'] = true,
	['/Global/TO_Siamese/Offense/Short/HeavyAttacks'] = true,
	['/Global/TO_Siamese/Offense/Short/LightAttacks/Slap'] = true,
	['/Global/WrestlingACT/Attacks/Grapples/Grapples/BackGrapples/Choke'] = true,
}

local function GetAnim(List, Current, Mode)
	-- look for different animations, but with the same key and purpose
	local Animations = {}
	for _, Content in ipairs(List) do
		if Content.Anim ~= Current.Anim and Mode == 'BIND' then
			if Content.Key == Current.Key and Content.Grapple == Current.Grapple and Content.Mount == Current.Mount then
				table.insert(Animations, {Content.Anim, Content.Act})
			end
		end
	end
	table.insert(Animations, {Current.Anim, Current.Act})
	
	-- get a random one
	local Index = math.random(1, table.getn(Animations))
	return Animations[Index][1], Animations[Index][2]
end

local function SetAnim(Anim, Act)
	local Condition = Conditional[Anim]
	local OverrideTargeting = Condition and string.find(Condition, 'FLAG') or false
	local IsChokeRequested = string.find(Anim, 'Choke')
	
	if Condition then
		PedSetAITree(gPlayer, '/Global/DarbyAI', 'Act/AI_DARBY_2_B.act')
		if OverrideTargeting then
			PedSetFlag(gPlayer, 87, true)
		end
		if IsChokeRequested then
			PedSetFlag(gPlayer, 2, true)
		end
	end
	
	local Func = CannotBeForced[Anim] and PedSetActionNode or ForceActionNode
	Func(gPlayer, Anim, Act)
	
	if Condition then
		if IsChokeRequested then
			PedSetFlag(gPlayer, 2, false)
		end
		if OverrideTargeting then
			PedSetFlag(gPlayer, 87, false)
		end
		PedSetAITree(gPlayer, '/Global/PlayerAI', 'Act/PlayerAI.act')
	end
end

local function HandleAction_Key(Table, Content, Grab)
	local IsStanding = PedMePlaying(gPlayer, 'DEFAULT_KEY') and not PedMePlaying(gPlayer, 'RisingAttacks')
	if not Content.Grapple and not Content.Mount then
		if IsStanding and IsKeyBeingPressed(Content.Key) then
			SetAnim(GetAnim(Table, Content, 'BIND'))
		end
	end
	
	local IsGrappling = (PedMePlaying(gPlayer, 'Hold_Idle') and PedMePlaying(gPlayer, 'GrappleRotate')) or PedMePlaying(gPlayer, 'Punch_Hold_Idle')
	if Content.Grapple and PedIsValid(Grab) and IsGrappling and IsKeyBeingPressed(Content.Key) then
		SetAnim(GetAnim(Table, Content, 'BIND'))
	end
	
	local IsMounting = PedMePlaying(gPlayer, 'MountIdle') and not PedMePlaying(gPlayer, 'Rcv')
	if Content.Mount and PedIsValid(Grab) and IsMounting and IsKeyBeingPressed(Content.Key) then
		SetAnim(GetAnim(Table, Content, 'BIND'))
	end
end

local function HandleAction_Condition(Table, Content)
	if not PedIsPlaying(gPlayer, Content.Trigger, true) then
		return false
	end
	if Content.Method == 1 then
		SetAnim(GetAnim(Table, Content, 'CONDITION'))
		return true
	end
	
	while PedIsPlaying(gPlayer, Content.Trigger, true) do
		if PedIsHit(gPlayer, 2, 100) then
			return false
		end
		if Content.Key and IsKeyBeingPressed(Content.Key) then
			break
		end
		Wait(0)
	end
	
	if Content.Key and not PedIsPlaying(gPlayer, Content.Trigger, true) then
		return false
	end
	SetAnim(GetAnim(Table, Content, 'CONDITION'))
	return false
end

local function HanldeAction_Block(Table, Target)
	local IsBeingAttacked = PedMePlaying(Target, 'Offense')
		or PedMePlaying(Target, 'Attacks') 
		or PedMePlaying(Target, 'Counter') 
		or PedMePlaying(Target, 'RisingAttacks')
	
	if PedMePlaying(gPlayer, 'DEFAULT_KEY') and IsBeingAttacked and IsButtonPressed(10, 0) then
		local Index = math.random(1, table.getn(Table))
		SetAnim(Table[Index].Anim, Table[Index].Act)
	end
end

local function HandleAction_Damon(Style, Target)
	if not string.find(Style, 'J_Damon') or not PedIsValid(Target) then
		return
	end
	
	if PedMePlaying(gPlayer, 'DEFAULT_KEY') and IsButtonBeingPressed_S(9, 0) then
		SetAnim(gPlayer, '/Global/J_Damon/Offense/SpecialStart/StartRun', 'Act/Anim/J_Damon.act')
	end
end

CreateThread(function()
	while true do
		local Target = PedGetTargetPed(gPlayer)
		local Grab = PedGetGrappleTargetPed(gPlayer)
		local IsSelecting = shared.PlayerInClothingManager or shared.playerShopping
		local IsControlling = PedGetControllerID(gPlayer) == 0 and PlayerHasControl()
		
		if PedHasWeapon(gPlayer, -1) and not IsSelecting and IsControlling then
			local Table = PlayerSettings.Strafe.Bind
			for _, Content in ipairs(Table) do
				HandleAction_Key(Table, Content, Grab)
			end
			
			Table = PlayerSettings.Strafe.Conditional
			for _, Content in ipairs(Table) do
				if HandleAction_Condition(Table, Content) then
					break
				end
			end
			
			Table = PlayerSettings.Strafe.Block
			if next(Table) and PedIsValid(Target) then
				HanldeAction_Block(Table, Target)
			end
			HandleAction_Damon(PlayerSettings.Style[1], Target)
		end
		
		Wait(0)
	end
end)


-----------------------------------
-- # EVENT: INVISIBLE & FREE SHOP #
-----------------------------------

local function HackDetection(Env)
	if Env.PedSetStealthBehavior then
		Env.PedSetStealthBehavior = function(...)
			local Args = arg
			Args[3] = Args[3] and function() end or Args[3]
			Args[4] = Args[4] and function() end or Args[4]
			
			_G.PedSetStealthBehavior(unpack(Args))
		end
	end
	
	if Env.PedCanSeeObject then
		Env.PedCanSeeObject = function(...)
			local Args = arg
			if Args[2] == gPlayer then
				return false
			end
			return _G.PedCanSeeObject(unpack(Args))
		end
	end
	
	if Env.PedIsSpotted then
		Env.PedIsSpotted = function(...)
			local Args = arg
			if Args[1] == gPlayer then
				return false
			end
			return _G.PedIsSpotted(unpack(Args))
		end
	end
end

local function HackShopPrice(Env)
	local SetPrice = function(Func, Args, PriceArg)
		Args[PriceArg] = 0
		Func(unpack(Args))
	end
	
	if Env.ClothingStoreAdd then
		Env.ClothingStoreAdd = function(...)
			SetPrice(_G.ClothingStoreAdd, arg, 3)
		end
	end
	if Env.BarberShopAdd then
		Env.BarberShopAdd = function(...)
			SetPrice(_G.BarberShopAdd, arg, 3)
		end
	end
	if Env.ShopAddItem then
		Env.ShopAddItem = function(...)
			SetPrice(_G.ShopAddItem, arg, 5)
		end
	end
	if Env.TattooStoreAdd then
		Env.TattooStoreAdd = function(...)
			SetPrice(_G.TattooStoreAdd, arg, 4)
		end
	end
end

RegisterLocalEventHandler('NativeScriptLoaded', function(Name, Env)
	if PlayerSettings.Invisible then
		HackDetection(Env)
	end
	if PlayerSettings.FreeShop then
		HackShopPrice(Env)
	end
end)