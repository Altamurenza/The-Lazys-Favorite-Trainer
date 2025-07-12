-- HEADER_CHARACTER.LUA
-- AUTHOR	: ALTAMURENZA


PlayerSettings.Model = 'Player'
PlayerSettings.Style = {
	'/Global/Player', 
	'Act/Anim/Player.act'
}
PlayerSettings.Movement = {
	'Player', 
	false, 
	0,
	GetTimer(), 
	GetTimer()
}
PlayerSettings.Strafe = {
	Bind = {},
	Conditional = {},
	Block = {}
}

PlayerSettings.Immortal = false
PlayerSettings.InfiniteAmmo = false
PlayerSettings.Invisible = false
PlayerSettings.LethalHit = false
PlayerSettings.Innocent = false
PlayerSettings.FreeShop = false
PlayerSettings.MindControl = false

NPCSettings.Population = true

function IsAlreadyAlly(Leader, Target)
	while PedHasAllyFollower(Leader) do
		Leader = PedGetAllyFollower(Leader)
		if Leader == Target then
			return true
		end
	end
	return false
end

function SetAlly(Ped, Target, Chained)
	if not PedIsValid(Ped) then
		return
	end
	
	if not Chained then
		PedRecruitAlly(Ped, Target)
		return
	end
	
	local Leader = Ped
	while PedHasAllyFollower(Leader) do
		Leader = PedGetAllyFollower(Leader)
	end
	PedRecruitAlly(Leader, Target)
end

function SetModel(Player, Model, Style)
	local Ped = Player and gPlayer or SelectPed(false)
	if not PedIsValid(Ped) then
		return
	end
	
	PedSwapModel(Ped, Model)
	if not Player then
		PedSetActionTree(Ped, unpack(Style))
		return
	end
	
	local IsCivil = string.find(Style[1], 'CV_Male_A')
	local IsDamon = string.find(Style[1], 'J_Damon')
	if IsCivil then
		Style = {'/Global/GS_Male_A', 'Act/Anim/GS_Male_A.act'}
	elseif IsDamon then
		Style = {'/Global/J_Striker_A', 'Act/Anim/J_Striker_A.act'}
	end
	
	PedSetActionTree(gPlayer, unpack(Style))
	PedSetAITree(gPlayer, '/Global/PlayerAI', 'Act/PlayerAI.act')
	PedSetInfiniteSprint(gPlayer, true)
	
	PlayerSettings.Model = Model
	PlayerSettings.Style = IsDamon and {
		'/Global/J_Damon', 'Act/Anim/J_Damon.act'
	} or Style
end

function SetStyle(Player, Code)
	local Ped = Player and gPlayer or SelectPed(false)
	if not PedIsValid(Ped) then
		return
	end
	
	if Code == '3_05_Norton' then
		while not PedHasWeapon(Ped, 324) do
			if Ped == gPlayer then
				PlayerSetWeapon(324, 1, false)
			else
				PedSetWeapon(Ped, 324, 1)
			end
			
			Wait(0)
		end
		PedSetActionTree(Ped, '/Global/Norton', 'Act/Anim/'..Code..'.act')
	elseif Code == 'J_Damon' and Ped == gPlayer then
		PedSetActionTree(Ped, '/Global/J_Striker_A', 'Act/Anim/J_Striker_A.act')
	else
		PedSetActionTree(Ped, '/Global/'..Code, 'Act/Anim/'..Code..'.act')
	end
	
	local Anim = Ped == gPlayer and 'PlayerAI' or 'AI'
	local Act = Ped == gPlayer and 'PlayerAI' or 'AI/AI'
	PedSetAITree(Ped, '/Global/'..Anim, 'Act/'..Act..'.act')
	if Ped == gPlayer then
		PedSetInfiniteSprint(Ped, true)
		
		PlayerSettings.Style = Code == '3_05_Norton' and {
			'/Global/Norton', 'Act/Anim/3_05_Norton.act'
		} or {'/Global/'..Code, 'Act/Anim/'..Code..'.act'}
	end
end

function SetMovement(Code)
	if PedMePlaying(gPlayer, 'WalkBasic') or PedMePlaying(gPlayer, 'RunBasic') or PedMePlaying(gPlayer, 'SprintBasic') then
		PlayerSettings.Movement[2] = false
		PedSetActionNode(gPlayer, unpack(PlayerSettings.Style))
	end
	PlayerSettings.Movement[1] = Code
end

function CreatePed(Index, Companionship)
	local X, Y, Z, Heading = SelectSpot()
	if type(X) ~= 'number' then
		return
	end
	local Ped = PedCreateXYZ(Index == 0 and math.random(2, 258) or Index, X, Y, Z)
	
	if Index == 0 then
		PedSwapModel(Ped, 'player')
	end
	PedMakeAmbient(Ped)
	PedFaceHeading(Ped, Heading)
	
	if Companionship == 0 then
		PedSetPedToTypeAttitude(Ped, 13, 0)
		PedSetEmotionTowardsPed(Ped, gPlayer, 0)
		PedAttackPlayer(Ped, 3)
	elseif Companionship == 2 then
		SetAlly(gPlayer, Ped, true)
	end
end