-- AUDIO.LUA
-- AUTHOR	: ALTAMURENZA


local Path = debug.getinfo(1, 'S').source
local Name = string.gsub(GetFileName(Path), '^%d+%s%-%s', '')
local Icon = Name

LoadScript('Scripts/Menu/Header/Header_'..Name..'.lua')
LoadScript('Scripts/Menu/Handler/Handler_'..Name..'.lua')

table.insert(UI, {Title = Name, Option = 1, Func = function(Selects)
	local Sub = UI[Selects[1]]
	repeat
		local Select = GetPointerSelection()
		if Select and IsMenuPressed(0) then
			table.insert(Selects, Select)
			Sub.Data[Select].Func(Selects)
			table.remove(Selects, table.getn(Selects))
		end
		ShowMenuBorder()
		
		Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
		ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
		
		Wait(0)
	until IsMenuPressed(1)
end,
Data = {
	{Name = "- "..string.upper(Name).." -"},
	{Name = "Ambience", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				if Select > 4 then
					local Selected = Sub.Data[Select]
					local Table = {
						{Name = "- PLAY AS: "..string.upper(Selected.Name).." -"},
						{Name = "Ambience", Func = SoundPlayAmbience},
						{Name = "Music", Func = SoundPlayStream},
						{Name = "Interactive Music", Func = function(Code, Volume)
							SoundPlayInteractiveStream(Code, Volume)
							SoundSetMidIntensityStream(Code, Volume)
							SoundSetHighIntensityStream(Code, Volume)
						end}
					}
					local Option = 1
					
					repeat
						local Select = GetPointerSelection()
						if Select and IsMenuPressed(0) then
							Table[Select].Func(Selected.Name, MUSIC_DEFAULT_VOLUME)
						end
						ShowMenuBorder()
						
						Option = UpdateMenuLayout(Table, Option)
						ShowMenu(Table, Option, 'Name', Icon, false)
						Wait(0)
					until IsMenuPressed(1)
				else
					Sub.Data[Select].Func()
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- STOP CURRENT SOUND -"},
		{Name = "Stop Ambience", Func = SoundStopAmbiences},
		{Name = "Stop Stream", Func = SoundStopStream},
		{Name = "Stop Interactive Stream", Func = SoundStopInteractiveStream},
		
		{Name = "- INDEX: A -"},
		{Name = "AutoShopClassIAmb.rsm"},
		{Name = "AutoShopClassEmit.rsm"},
		{Name = "AtticWind03.rsm"},
		{Name = "AssylumAmbPLII.rsm"},
		{Name = "AutoBodyShop.rsm"},
		
		{Name = "- INDEX: B -"},
		{Name = "BarFight.rsm"},
		{Name = "Birds01.rsm"},
		{Name = "Birds2.rsm"},
		{Name = "BoysDormRoom04.rsm"},
		{Name = "BusyMorningSchHallOCLDEDPLII.rsm"},
		{Name = "BoysDormRoom01.rsm"},
		{Name = "BarCrowd02.rsm"},
		{Name = "Bus_ConvenienceStoreREV.rsm"},
		{Name = "Busy3pmSchoolHallOCLDEDPLII.rsm"},
		{Name = "BusyLunchSchHall.rsm"},
		{Name = "BusyLunchHallOCLDEDPLII.rsm"},
		{Name = "Busy3pmSchHall.rsm"},
		{Name = "BarCrowdMx.rsm"},
		{Name = "BusyMorningSchHal.rsm"},
		{Name = "BarCrowd.rsm"},
		{Name = "BabyCry02.rsm"},
		
		{Name = "- INDEX: C -"},
		{Name = "CarnivalAmbienceOCCLDPLII.rsm"},
		{Name = "Craneyard.rsm"},
		{Name = "ChemPlantMain.rsm"},
		{Name = "CafeteriaLunch.rsm"},
		{Name = "ChildrenPlay03.rsm"},
		{Name = "ChemPlantLower.rsm"},
		{Name = "CoasterEmitOCLD.rsm"},
		{Name = "ClassAmb01EQREV.rsm"},
		{Name = "ChildrenPlay01.rsm"},
		{Name = "ChemPlantTunnel.rsm"},
		{Name = "CarnivalAmbEQEmtr.rsm"},
		{Name = "Crow2.rsm"},
		{Name = "CarnivalAmbience.rsm"},
		{Name = "CoasterEmit.rsm"},
		{Name = "Crow.rsm"},
		{Name = "Crowd_Resturant.rsm"},
		{Name = "CafeteriaBreakfast.rsm"},
		
		{Name = "- INDEX: D -"},
		{Name = "DownTownBusyStreet01a.rsm"},
		{Name = "DownTownBusyStreet02a.rsm"},
		{Name = "DometicFight01.rsm"},
		{Name = "DownTownBusyPeople03.rsm"},
		{Name = "DownTownBusyPeople02.rsm"},
		{Name = "DowntownPark.rsm"},
		{Name = "DowntownBusyStreet03a.rsm"},
		{Name = "DomesticFight03.rsm"},
		{Name = "DockMachines01.rsm"},
		{Name = "DockMachines02.rsm"},
		{Name = "DownTownBusyPeople01.rsm"},
		{Name = "DockForkLift.rsm"},
		{Name = "DomesticFight02.rsm"},
		{Name = "DowntownBusyStreet03b.rsm"},
		{Name = "DockMachines03.rsm"},
		
		{Name = "- INDEX: F -"},
		{Name = "Fight_Group_Lrg_Int.rsm"},
		{Name = "FunUpsideDownRoom.rsm"},
		{Name = "Fight_Group_Med_Ext.rsm"},
		{Name = "Freak_BeardedLadyTV.rsm"},
		{Name = "FunMineShaft.rsm"},
		{Name = "FerrisWheel.rsm"},
		{Name = "Fight_Group_Med_Int.rsm"},
		{Name = "ForestNight.rsm"},
		{Name = "Freak_SkeletonManMx.rsm"},
		{Name = "Fight_Group_Sml_Ext.rsm"},
		{Name = "FREAK_FreakHouseBarker.rsm"},
		{Name = "ForestDay.rsm"},
		{Name = "Freak_MidgetWrestling.rsm"},
		{Name = "Fight_Group_Lrg_Ext.rsm"},
		{Name = "Fight_Group_Sml_Int.rsm"},
		{Name = "FunBigTongue.rsm"},
		{Name = "FunGraveYard.rsm"},
		{Name = "Freak_MermaidTank.rsm"},
		{Name = "Freak_Twins.rsm"},
		{Name = "FootballGameAmbience.rsm"},
		{Name = "Freak_Screams.rsm"},
		{Name = "FunHauntedMaze.rsm"},
		{Name = "FlyMeLounge.rsm"},
		{Name = "FunAuditorium.rsm"},
		
		{Name = "- INDEX: G -"},
		{Name = "GirlsDormRoom02.rsm"},
		{Name = "GasStation.rsm"},
		{Name = "GenericWinter.rsm"},
		{Name = "GirlsDormRoom01.rsm"},
		{Name = "GenericWinterWindNite.rsm"},
		{Name = "Graveyard02.rsm"},
		
		{Name = "- INDEX: H -"},
		{Name = "HallBtwnClass.rsm"},
		
		{Name = "- INDEX: I -"},
		{Name = "IND_SequirtytRoom.rsm"},
		{Name = "IND_FanAndSparks.rsm"},
		{Name = "IND_ElecGenerator.rsm"},
		{Name = "IND_SqueakyFan.rsm"},
		{Name = "IND_PowerstaionRelaysLoop.rsm"},
		
		{Name = "- INDEX: K -"},
		{Name = "KidsPlay.rsm"},
		
		{Name = "- INDEX: L -"},
		{Name = "LargeFight.rsm"},
		{Name = "Lounge.rsm"},
		{Name = "LakeLoon.rsm"},
		
		{Name = "- INDEX: M -"},
		{Name = "MexicanResturant.rsm"},
		{Name = "MusicClassIntro.rsm"},
		{Name = "MournfulWind01.rsm"},
		{Name = "MedFight.rsm"},
		
		{Name = "- INDEX: N -"},
		{Name = "NewDormDayOCCLD.rsm"},
		{Name = "NewSchoolOutdoor_F.rsm"},
		{Name = "NightDog02.rsm"},
		{Name = "NewSchoolOutdoor_B22.rsm"},
		{Name = "NightDog03a.rsm"},
		{Name = "NightDog01.rsm"},
		{Name = "NightDog03.rsm"},
		{Name = "NewDormDay.rsm"},
		{Name = "NightDog02a.rsm"},
		
		{Name = "- INDEX: O -"},
		{Name = "OutDoorSchoolYardWinter.rsm"},
		
		{Name = "- INDEX: P -"},
		{Name = "Preacher_04.rsm"},
		{Name = "Preacher_09.rsm"},
		{Name = "PoolHall.rsm"},
		{Name = "Poor_Emitter_05.rsm"},
		{Name = "Preacher_10.rsm"},
		{Name = "Poor_Emitter_04.rsm"},
		{Name = "Preacher_03.rsm"},
		{Name = "Poor_Emitter_02.rsm"},
		{Name = "Preacher_05.rsm"},
		{Name = "PizzaParlourMx.rsm"},
		{Name = "Preacher_01.rsm"},
		{Name = "Poor_CarAlarm.rsm"},
		{Name = "Preacher_06.rsm"},
		{Name = "Poor_Emitter_03.rsm"},
		{Name = "Preacher_02.rsm"},
		{Name = "Poor_Emitter_01.rsm"},
		{Name = "Preacher_08.rsm"},
		{Name = "Preacher_07.rsm"},
		
		{Name = "- INDEX: R -"},
		{Name = "RoofWind.rsm"},
		{Name = "Rich_OutdoorCoutyard01REV.rsm"},
		{Name = "Rich_OutdoorCoutyard02REV.rsm"},
		{Name = "RainRoof.rsm"},
		{Name = "RainGutters.rsm"},
		
		{Name = "- INDEX: S -"},
		{Name = "SmallFight.rsm"},
		{Name = "Sirens02.rsm"},
		{Name = "SquidRide.rsm"},
		{Name = "SchoolHallNiteErrie.rsm"},
		{Name = "SchoolYardWinterClassOut.rsm"},
		{Name = "SchoolNight.rsm"},
		{Name = "SeaGulls.rsm"},
		{Name = "Sirens01.rsm"},
		{Name = "SawMill.rsm"},
		
		{Name = "- INDEX: T -"},
		{Name = "Truckyard.rsm"},
		{Name = "Train01.rsm"},
		
		{Name = "- INDEX: W -"},
		{Name = "WolfHowls.rsm"},
	}},
	{Name = "Music", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				if Select > 4 then
					local Selected = Sub.Data[Select]
					local Table = {
						{Name = "- PLAY AS: "..string.upper(Selected.Name).." -"},
						{Name = "Ambience", Func = SoundPlayAmbience},
						{Name = "Music", Func = SoundPlayStream},
						{Name = "Interactive Music", Func = function(Code, Volume)
							SoundPlayInteractiveStream(Code, Volume)
							SoundSetMidIntensityStream(Code, Volume)
							SoundSetHighIntensityStream(Code, Volume)
						end}
					}
					local Option = 1
					
					repeat
						local Select = GetPointerSelection()
						if Select and IsMenuPressed(0) then
							Table[Select].Func(Selected.Name, MUSIC_DEFAULT_VOLUME)
						end
						ShowMenuBorder()
						
						Option = UpdateMenuLayout(Table, Option)
						ShowMenu(Table, Option, 'Name', Icon, false)
						Wait(0)
					until IsMenuPressed(1)
				else
					Sub.Data[Select].Func()
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- STOP CURRENT SOUND -"},
		{Name = "Stop Ambience", Func = SoundStopAmbiences},
		{Name = "Stop Stream", Func = SoundStopStream},
		{Name = "Stop Interactive Stream", Func = SoundStopInteractiveStream},
		
		{Name = "- INDEX: 1 -"},
		{Name = "1-06_HoboNIS.rsm"},
		
		{Name = "- INDEX: 5 -"},
		{Name = "5-06_HarleyLeavesExplode_NIS.rsm"},
		{Name = "5-05_NIS_PottyFall.rsm"},
		{Name = "5-06_Garage_NIS.rsm"},
		
		{Name = "- INDEX: A -"},
		{Name = "ArcRaceMXmidi02SPLASHBED01.rsm"},
		{Name = "ArcRaceMXmidi02SPLASH.rsm"},
		{Name = "ArcRaceMXmidi02SPLASHBED05.rsm"},
		{Name = "ArcRaceMXmidi02Drive02.rsm"},
		{Name = "Arc_MonkeyFlingGame01.rsm"},
		{Name = "ArcRaceMXmidi02SPLASHBED06.rsm"},
		{Name = "ArcRaceMXmidi02LOSE01.rsm"},
		{Name = "ArcRaceMXmidi02LOSE02.rsm"},
		{Name = "ArcRaceMXmidi02SPLASHBED02.rsm"},
		{Name = "Arc_MonkeyFlingWin.rsm"},
		{Name = "ArcRaceMXmidi02WIN.rsm"},
		{Name = "Arc_SUMO_Win.rsm"},
		{Name = "ArcRaceMXmidi02SPLASHBED03.rsm"},
		{Name = "Arc_FlyingSquirrelWin.rsm"},
		{Name = "Arc_MonkeyFlingMenu01.rsm"},
		{Name = "Arc_FlyingSquirrelGameMx01.rsm"},
		{Name = "Arc_MonkeyFlingGame02.rsm"},
		{Name = "ArcRaceMXmidi02SPLASHBED04.rsm"},
		{Name = "Arc_MonkeyFlingGame03.rsm"},
		{Name = "Arc_FlyingSquirrelGameMx03.rsm"},
		{Name = "Arc_FlyingSquirrelLose.rsm"},
		{Name = "Arc_FlyingSquirrelGameMx02.rsm"},
		{Name = "Arc_SUMO_Menu.rsm"},
		{Name = "Arc_MonkeyFlingMenu02.rsm"},
		{Name = "Arc_MonkeyFlingLose.rsm"},
		{Name = "ArcRaceMXmidi02Drive01.rsm"},
		{Name = "Arc_SUMO_Lose.rsm"},
		{Name = "Arc_SUMO_Game01.rsm"},
		{Name = "Arc_FlyingSquirrelMenu.rsm"},
		{Name = "ArcRaceMXmidi02Drive03.rsm"},
		
		{Name = "- INDEX: E -"},
		{Name = "EX_XmasTreeEmitter04.rsm"},
		{Name = "EX_BikeShopMX.rsm"},
		{Name = "E_TatooTrailerMX.rsm"},
		{Name = "E_HQMX_Dropouts.rsm"},
		{Name = "EX_XmasTreeEmitter03.rsm"},
		{Name = "E_HQMX_Jocks.rsm"},
		{Name = "E_HairSaloonPoorMX.rsm"},
		{Name = "EX_ClothingStoreRichMX.rsm"},
		{Name = "E_HairSaloonRichMX.rsm"},
		{Name = "EX_TatooTrailerMX.rsm"},
		{Name = "EX_ComicShopMX.rsm"},
		{Name = "EX_XmasTreeEmitter01.rsm"},
		{Name = "EX_HairSaloonRichMX.rsm"},
		{Name = "EX_JanitorRoomMX.rsm"},
		{Name = "EX_HairSalonPoorMX.rsm"},
		{Name = "E_JanitorRoomMX.rsm"},
		{Name = "EX_ClothingStorePoorMX.rsm"},
		{Name = "E_BoxClub_DownstairsMX.rsm"},
		{Name = "E_ComicShopMX.rsm"},
		{Name = "E_BikeShopMX.rsm"},
		{Name = "E_HQMX_Nerds.rsm"},
		{Name = "EX_XmasTreeEmitter02.rsm"},
		{Name = "E_GeneralStoreMX.rsm"},
		{Name = "E_ClothingStorePoorMX.rsm"},
		{Name = "E_ClothingStoreRichMX.rsm"},
		{Name = "E_HQMX_Preppies.rsm"},
		{Name = "EX_GeneralStoreMX.rsm"},
		
		{Name = "- INDEX: F -"},
		{Name = "FIGHT01EndFade.rsm"},
		{Name = "FIGHT01EFade.rsm"},
		{Name = "FIGHT01D.rsm"},
		{Name = "FIGHT01F.rsm"},
		{Name = "FIGHT01C.rsm"},
		{Name = "FIGHT01B.rsm"},
		{Name = "FIGHT01A.rsm"},
		
		{Name = "- INDEX: M -"},
		{Name = "MS_CarnivalFunhouseAmbient.rsm"},
		{Name = "MS_Somower.rsm"},
		{Name = "MS_RomanceHigh.rsm"},
		{Name = "MS_MusicClass_Turkey.rsm"},
		{Name = "MS_WIldstyleHigh.rsm"},
		{Name = "MS_5-05_MeetZoe_NIS.rsm"},
		{Name = "MS_RunningMid.rsm"},
		{Name = "MS_Candidate.rsm"},
		{Name = "MS_EpicConfrontationHighPart2.rsm"},
		{Name = "MS_EnglishClassEnd.rsm"},
		{Name = "MS_FinalShowdown03Low.rsm"},
		{Name = "MS_EpicConfrontationLow.rsm"},
		{Name = "MS_StealthHigh.rsm"},
		{Name = "MS_FriendshipAllyHigh.rsm"},
		{Name = "MS_OnFootFailure.rsm"},
		{Name = "MS_MusicClass_Washing.rsm"},
		{Name = "MS_CarnivalFunhouseMaze.rsm"},
		{Name = "MS_BikeFunMid.rsm"},
		{Name = "MS_RussellInTheHole.rsm"},
		{Name = "MS_ChaseAdult.rsm"},
		{Name = "MS_3-B_ENDTAG.rsm"},
		{Name = "MS_ActionLow.rsm"},
		{Name = "MS_MiniStingSuccess.rsm"},
		{Name = "MS_Misbehaving_NISPrankInfo.rsm"},
		{Name = "MS_StreetFightLargeLow_Boxing.rsm"},
		{Name = "MS_XmasBellsRudylow.rsm"},
		{Name = "MS_MusicClass_MasterP.rsm"},
		{Name = "MS_FinalShowdownMid.rsm"},
		{Name = "MS_Misbehaving_NISPrankSucess.rsm"},
		{Name = "MS_TenementsLow.rsm"},
		{Name = "MS_BikeDay.rsm"},
		{Name = "MS_ActionMid.rsm"},
		{Name = "MS_InTroubleHigh.rsm"},
		{Name = "MS_PhotographyClass.rsm"},
		{Name = "MS_FinalShowdown03Mid.rsm"},
		{Name = "MS_RunningHigh.rsm"},
		{Name = "MS_XmasJingleMiracleMid.rsm"},
		{Name = "MS_MusicClass_Carols01.rsm"},
		{Name = "MS_TenementsHigh.rsm"},
		{Name = "MS_XmasJingleMiracle.rsm"},
		{Name = "MS_NerdFight.rsm"},
		{Name = "MS_GoKart02.rsm"},
		{Name = "MS_BiologyClass.rsm"},
		{Name = "MS_EnglishClass.rsm"},
		{Name = "MS_FootStealthLow.rsm"},
		{Name = "MS_XmasBellsRudyHigh.rsm"},
		{Name = "MS_HalloweenMid.rsm"},
		{Name = "MS_Ambient01.rsm"},
		{Name = "MS_SearchingHigh.rsm"},
		{Name = "MS_FightMid01.rsm"},
		{Name = "MS_DestructionVandalismMid.rsm"},
		{Name = "MS_BoxingBossFight.rsm"},
		{Name = "MS_ShowdownAtThePlantLow.rsm"},
		{Name = "MS_ActionHigh.rsm"},
		{Name = "MS_BikeFailure.rsm"},
		{Name = "MS_SneakDate_Romantic.rsm"},
		{Name = "MS_FightingNerds.rsm"},
		{Name = "MS_Tired.rsm"},
		{Name = "MS_RunningLow02.rsm"},
		{Name = "MS_NerdPassStinger.rsm"},
		{Name = "MS_5-05_BurtonPee_NIS.rsm"},
		{Name = "MS_XmasComeRudyMid.rsm"},
		{Name = "MS_RomanceFailStinger.rsm"},
		{Name = "MS_FightHigh02.rsm"},
		{Name = "MS_XmasFavoriteBallsHigh.rsm"},
		{Name = "MS_ChaseMid.rsm"},
		{Name = "MS_BikeChaseMid.rsm"},
		{Name = "MS_FearTensionMid.rsm"},
		{Name = "MS_ChaseLow.rsm"},
		{Name = "MS_FinalShowdown03High.rsm"},
		{Name = "MS_GenericStingFail.rsm"},
		{Name = "MS_BikeRace01.rsm"},
		{Name = "MS_FightingJohnnyVincentBikeRide.rsm"},
		{Name = "MS_RomanceLow.rsm"},
		{Name = "MS_EpicConfrontationMid.rsm"},
		{Name = "MS_Carnival02.rsm"},
		{Name = "MS_BikeActionMid.rsm"},
		{Name = "MS_Confrontation_NIS.rsm"},
		{Name = "MS_XmasComeRudyHigh.rsm"},
		{Name = "MS_BikeRace02.rsm"},
		{Name = "MS_FightingJohnnyVincentFight.rsm"},
		{Name = "MS_MusicClass_Coming.rsm"},
		{Name = "MS_SearchingLow.rsm"},
		{Name = "MS_InTroubleLow.rsm"},
		{Name = "MS_MathClass.rsm"},
		{Name = "MS_StealthLow.rsm"},
		{Name = "MS_ClassSuccessStinger.rsm"},
		{Name = "MS_BikePractice.rsm"},
		{Name = "MS_FinalShowdownHigh.rsm"},
		{Name = "MS_BiologyClassEnd.rsm"},
		{Name = "MS_RomancePassStinger.rsm"},
		{Name = "MS_HalloweenLow.rsm"},
		{Name = "MS_FightingPreps.rsm"},
		{Name = "MS_BikeFunHigh.rsm"},
		{Name = "MS_GoKarts01A.rsm"},
		{Name = "MS_FootStealthHigh.rsm"},
		{Name = "MS_FightingGeneric.rsm"},
		{Name = "MS_ClassFailureStinger.rsm"},
		{Name = "MS_JockBossBattle.rsm"},
		{Name = "MS_GoKart 01.rsm"},
		{Name = "MS_StreetFightLargeMid_Boxing.rsm"},
		{Name = "MS_FightingBullies.rsm"},
		{Name = "MS_BikeChaseHigh.rsm"},
		{Name = "MS_PrepFight.rsm"},
		{Name = "MS_FightingJocks.rsm"},
		{Name = "MS_NerdBossBattle.rsm"},
		{Name = "MS_EnglishClassShort.rsm"},
		{Name = "MS_MusicClassTestDrum.rsm"},
		{Name = "MS_Gobble.rsm"},
		{Name = "MS_Fighting01.rsm"},
		{Name = "MS_TournySuccessStinger.rsm"},
		{Name = "MS_ArtClass.rsm"},
		{Name = "MS_KidsPlay.rsm"},
		{Name = "MS_MisbehavingHigh.rsm"},
		{Name = "MS_NerdFailStinger.rsm"},
		{Name = "MS_StealthMidA.rsm"},
		{Name = "MS_FightingPrepsLow.rsm"},
		{Name = "MS_EpicConfrontationHigh.rsm"},
		{Name = "MS_XmasJingleMiracleHigh.rsm"},
		{Name = "MS_ChaseHigh.rsm"},
		{Name = "MS_FightLow03.rsm"},
		{Name = "MS_SneakDate_SexyGirl.rsm"},
		{Name = "MS_FootStealthMid.rsm"},
		{Name = "MS_FightMid03.rsm"},
		{Name = "MS_3B_JohhnyV_NIS.rsm"},
		{Name = "MS_BikeFastMid.rsm"},
		{Name = "MS_FriendshipAllyMid.rsm"},
		{Name = "MS_GymClass.rsm"},
		{Name = "MS_5-09_CrowdNIS.rsm"},
		{Name = "MS_XmasComeRudyLow.rsm"},
		{Name = "MS_ActionBeatBreak.rsm"},
		{Name = "MS_FunHigh.rsm"},
		{Name = "MS_FightMid02.rsm"},
		{Name = "MS_FunLow.rsm"},
		{Name = "MS_FinalShowdownLow.rsm"},
		{Name = "MS_PunishmentDetention.rsm"},
		{Name = "MS_ChasePrefect.rsm"},
		{Name = "MS_BikeNight.rsm"},
		{Name = "MS_FightingGreasers.rsm"},
		{Name = "MS_MusicClass_Liberty.rsm"},
		{Name = "MS_GoKarts02.rsm"},
		{Name = "MS_ActionHigh_NISReturn.rsm"},
		{Name = "MS_MisbehavingHigh_NIS03.rsm"},
		{Name = "MS_BikeFunLow.rsm"},
		{Name = "MS_GoKarts01B.rsm"},
		{Name = "MS_BikeFastLow.rsm"},
		{Name = "MS_FightingJohnnyVincentBossFight.rsm"},
		{Name = "MS_FightingDropouts.rsm"},
		{Name = "MS_GenericStingSuccess.rsm"},
		{Name = "MS_LockPicking.rsm"},
		{Name = "MS_MisbehavingHigh_NIS02.rsm"},
		{Name = "MS_6B_EndlessSummerCreditsNIS.rsm"},
		{Name = "MS_XmasJingleMiracleLow.rsm"},
		{Name = "MS_BoxingReg.rsm"},
		{Name = "MS_GeographyClass.rsm"},
		{Name = "MS_ShowdownAtThePlantHigh.rsm"},
		{Name = "MS_MisbehavingMid.rsm"},
		{Name = "MS_StealthMid.rsm"},
		{Name = "MS_XmasBellsRudyMid.rsm"},
		{Name = "MS_DestructionVandalismHigh.rsm"},
		{Name = "MS_ChasePolice.rsm"},
		{Name = "MS_FriendshipAllyLow.rsm"},
		{Name = "MS_ChemistryClassMulti.rsm"},
		{Name = "MS_TournySuccessStinger2.rsm"},
		{Name = "MS_TenementsMid.rsm"},
		{Name = "MS_HalloweenHigh.rsm"},
		{Name = "MS_BikeActionHigh.rsm"},
		{Name = "MS_OnFootVictory.rsm"},
		{Name = "MS_Carnival01.rsm"},
		{Name = "MS_SearchingMid.rsm"},
		{Name = "MS_MathClassEnd.rsm"},
		{Name = "MS_EpicConfrantation_NIS.rsm"},
		{Name = "MS_EpicConfrontationEnding.rsm"},
		{Name = "MS_MovieTixRomance.rsm"},
		{Name = "MS_XmasFavoriteBallsMed.rsm"},
		{Name = "MS_ShopClass.rsm"},
		{Name = "MS_MissionEnd01.rsm"},
		{Name = "MS_XmasFavoriteBallsLow.rsm"},
		{Name = "MS_WIldstyleLow.rsm"},
		{Name = "MS_CarnivalFunhouseMiner.rsm"},
		{Name = "MS_BikeChaseLow.rsm"},
		{Name = "MS_WIldstyleMid.rsm"},
		{Name = "MS_RomanceMid.rsm"},
		{Name = "MS_ChemistryClass.rsm"},
		{Name = "MS_DishonorableFight.rsm"},
		{Name = "MS_BikeFastHigh.rsm"},
		{Name = "MS_BikeVictory.rsm"},
		{Name = "MS_RunningFight-2 MIX TR.rsm"},
		{Name = "MS_MisbehavingHigh_NIS01.rsm"},
		{Name = "MS_TensionBuilder01.rsm"},
		{Name = "MS_RunningLow.rsm"},
		{Name = "MS_BikeFun_NIS.rsm"},
		{Name = "MS_StreetFightLargeHigh_Boxing.rsm"},
		{Name = "MS_FunMid.rsm"},
	}},
	{Name = "Cutscene Audio", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				if Select > 4 then
					local Selected = Sub.Data[Select]
					local Table = {
						{Name = "- PLAY AS: "..string.upper(Selected.Name).." -"},
						{Name = "Ambience", Func = SoundPlayAmbience},
						{Name = "Music", Func = SoundPlayStream},
						{Name = "Interactive Music", Func = function(Code, Volume)
							SoundPlayInteractiveStream(Code, Volume)
							SoundSetMidIntensityStream(Code, Volume)
							SoundSetHighIntensityStream(Code, Volume)
						end}
					}
					local Option = 1
					
					repeat
						local Select = GetPointerSelection()
						if Select and IsMenuPressed(0) then
							Table[Select].Func(Selected.Name, MUSIC_DEFAULT_VOLUME)
						end
						ShowMenuBorder()
						
						Option = UpdateMenuLayout(Table, Option)
						ShowMenu(Table, Option, 'Name', Icon, false)
						Wait(0)
					until IsMenuPressed(1)
				else
					Sub.Data[Select].Func()
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- STOP CURRENT SOUND -"},
		{Name = "Stop Ambience", Func = SoundStopAmbiences},
		{Name = "Stop Stream", Func = SoundStopStream},
		{Name = "Stop Interactive Stream", Func = SoundStopInteractiveStream},
		
		{Name = "- INDEX: 1 -"},
		{Name = "1-09.rsm"},
		{Name = "1-03.rsm"},
		{Name = "1-11.rsm"},
		{Name = "1-02D.rsm"},
		{Name = "1-02B.rsm"},
		{Name = "1-1-1.rsm"},
		{Name = "1-BB.rsm"},
		{Name = "1-1-2.rsm"},
		{Name = "1-07.rsm"},
		{Name = "1-B.rsm"},
		{Name = "1-S01.rsm"},
		{Name = "1-BC.rsm"},
		{Name = "1-G1.rsm"},
		{Name = "1-08.rsm"},
		{Name = "1-06.rsm"},
		{Name = "1-05.rsm"},
		{Name = "1-01.rsm"},
		{Name = "1-02E.rsm"},
		{Name = "1-04.rsm"},
		{Name = "1-10.rsm"},
		{Name = "1-06B.rsm"},
		
		{Name = "- INDEX: 2 -"},
		{Name = "2-01.rsm"},
		{Name = "2-07.rsm"},
		{Name = "2-05.rsm"},
		{Name = "2-04.rsm"},
		{Name = "2-BB.rsm"},
		{Name = "2-G2.rsm"},
		{Name = "2-S02.rsm"},
		{Name = "2-S07.rsm"},
		{Name = "2-0.rsm"},
		{Name = "2-02-W.rsm"},
		{Name = "2-02.rsm"},
		{Name = "2-S05C.rsm"},
		{Name = "2-08.rsm"},
		{Name = "2-B.rsm"},
		{Name = "2-S04.rsm"},
		{Name = "2-09B.rsm"},
		{Name = "2-S04-W.rsm"},
		{Name = "2-S05B.rsm"},
		{Name = "2-S05.rsm"},
		{Name = "2-S05C-W.rsm"},
		{Name = "2-03B.rsm"},
		{Name = "2-06.rsm"},
		{Name = "2-09.rsm"},
		{Name = "2-03.rsm"},
		{Name = "2-S06.rsm"},
		
		{Name = "- INDEX: 3 -"},
		{Name = "3-B-W.rsm"},
		{Name = "3-02-W.rsm"},
		{Name = "3-B.rsm"},
		{Name = "3-BD.rsm"},
		{Name = "3-03.rsm"},
		{Name = "3-04.rsm"},
		{Name = "3-BD-W.rsm"},
		{Name = "3-R07.rsm"},
		{Name = "3-01-W.rsm"},
		{Name = "3-S11.rsm"},
		{Name = "3-01CB.rsm"},
		{Name = "3-0.rsm"},
		{Name = "3-R05B.rsm"},
		{Name = "3-05.rsm"},
		{Name = "3-06.rsm"},
		{Name = "3-01DB.rsm"},
		{Name = "3-G3.rsm"},
		{Name = "3-01CA.rsm"},
		{Name = "3-G3-W.rsm"},
		{Name = "3-R05A.rsm"},
		{Name = "3-S11C.rsm"},
		{Name = "3-S08.rsm"},
		{Name = "3-01DA.rsm"},
		{Name = "3-S10.rsm"},
		{Name = "3-01.rsm"},
		{Name = "3-01AB.rsm"},
		{Name = "3-01DC.rsm"},
		{Name = "3-01AA.rsm"},
		{Name = "3-01BB.rsm"},
		{Name = "3-01BA.rsm"},
		{Name = "3-05-W.rsm"},
		{Name = "3-BB.rsm"},
		{Name = "3-04B.rsm"},
		{Name = "3-06-W.rsm"},
		{Name = "3-BC.rsm"},
		{Name = "3-S03.rsm"},
		{Name = "3-02.rsm"},
		
		{Name = "- INDEX: 4 -"},
		{Name = "4-B1.rsm"},
		{Name = "4-S12B.rsm"},
		{Name = "4-B1B.rsm"},
		{Name = "4-0.rsm"},
		{Name = "4-01.rsm"},
		{Name = "4-02.rsm"},
		{Name = "4-B1D.rsm"},
		{Name = "4-B1C.rsm"},
		{Name = "4-04.rsm"},
		{Name = "4-B2b.rsm"},
		{Name = "4-B2.rsm"},
		{Name = "4-05.rsm"},
		{Name = "4-G4.rsm"},
		{Name = "4-S12.rsm"},
		{Name = "4-03.rsm"},
		{Name = "4-06.rsm"},
		
		{Name = "- INDEX: 5 -"},
		{Name = "5-09B.rsm"},
		{Name = "5-05.rsm"},
		{Name = "5-G5.rsm"},
		{Name = "5-02.rsm"},
		{Name = "5-06.rsm"},
		{Name = "5-06_HarleyLeaves.rsm"},
		{Name = "5-BC.rsm"},
		{Name = "5-0.rsm"},
		{Name = "5-02B.rsm"},
		{Name = "5-03.rsm"},
		{Name = "5-07.rsm"},
		{Name = "5-05B.rsm"},
		{Name = "5-01.rsm"},
		{Name = "5-B.rsm"},
		{Name = "5-09.rsm"},
		
		{Name = "- INDEX: 6 -"},
		{Name = "6-0.rsm"},
		{Name = "6-B.rsm"},
		{Name = "6-BB.rsm"},
		{Name = "6-02B.rsm"},
		{Name = "6-02.rsm"},
		{Name = "6-B_SkyliteClimax.rsm"},
		{Name = "6-BC.rsm"},
		
		{Name = "- INDEX: B -"},
		{Name = "Barrels_Fall.rsm"},
		
		{Name = "- INDEX: C -"},
		{Name = "Coaster.rsm"},
		
		{Name = "- INDEX: F -"},
		{Name = "FerrisWheel.rsm"},
		
		{Name = "- INDEX: S -"},
		{Name = "SquidRide.rsm"},
	}},
	{Name = "Player Line", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- DEFAULT: "..string.upper(Selected.Name).." -"},
					{Name = "Play Random Line", Func = function()
						SoundPlayAmbientSpeechEvent(gPlayer, Selected.Name)
					end},
					
					{Name = "- CUSTOM: "..string.upper(Selected.Name).." -"},
					{Name = "0=0=10000"},
					{Name = "Play Specific Line", Func = function(Table, Select)
						local Line = GetArguments(2, GetMenuTrackbarValues(Table[Select - 1].Name))
						SoundPlayAmbientSpeechEventSpecific(gPlayer, Selected.Name, Line)
					end}
				}
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Table[Select].Func(Table, Select)
					end
					ShowMenuBorder()
					
					Option = UpdateMenuLayout(Table, Option)
					ShowMenu(Table, Option, 'Name', Icon, false)
					Wait(0)
				until IsMenuPressed(1)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- INDEX: A -"},
		{Name = "PLAYER_AFFIRMATIVE"},
		{Name = "PLAYER_APOLOGY_AUTHORITY_GOOD"},
		{Name = "PLAYER_APOLOGY_AUTHORITY_POOR"},
		{Name = "PLAYER_APOLOGY_BEG"},
		{Name = "PLAYER_APOLOGY_CHILL"},
		{Name = "PLAYER_APOLOGY_GENERIC"},
		{Name = "PLAYER_APOLOGY_GIRL"},
		{Name = "PLAYER_APOLOGY_SMOOTH"},
		
		{Name = "- INDEX: B -"},
		{Name = "PLAYER_BEATEN"},
		{Name = "PLAYER_BIKE_CRASH"},
		{Name = "PLAYER_BIKE_STEALING"},
		{Name = "PLAYER_BIKE_STOLEN"},
		{Name = "PLAYER_BINNING"},
		{Name = "PLAYER_BOOT"},
		
		{Name = "- INDEX: C -"},
		{Name = "PLAYER_CAMERA"},
		{Name = "PLAYER_CAMERA_BAD"},
		{Name = "PLAYER_CAMERA_GOOD"},
		
		{Name = "- INDEX: D -"},
		{Name = "PLAYER_DEFEAT_INDIVIDUAL"},
		{Name = "PLAYER_DEFEAT_TEAM"},
		{Name = "PLAYER_DEJECTED"},
		{Name = "PLAYER_DRINK"},
		
		{Name = "- INDEX: E -"},
		{Name = "PLAYER_ENTER_RIDE"},
		{Name = "PLAYER_EXCUSE"},
		{Name = "PLAYER_EXIT_RIDE"},
		
		{Name = "- INDEX: F- "},
		{Name = "PLAYER_FLIRT_DEFAULT"},
		{Name = "PLAYER_FLIRT_GOOD"},
		{Name = "PLAYER_FLIRT_POOR"},
		
		{Name = "- INDEX: G -"},
		{Name = "PLAYER_GET_COLLECTIBLE"},
		{Name = "PLAYER_GET_MONEY"},
		{Name = "PLAYER_GET_WEAPON"},
		{Name = "PLAYER_GIFT_GENERAL"},
		{Name = "PLAYER_GIFT_GIVE_DOG"},
		{Name = "PLAYER_GIFT_GIVE_EXTORTION"},
		{Name = "PLAYER_GIFT_GIVE_GIRL"},
		{Name = "PLAYER_GREET_ADULT_FEMALE"},
		{Name = "PLAYER_GREET_ADULT_MALE"},
		{Name = "PLAYER_GREET_ASSIST"},
		{Name = "PLAYER_GREET_FRIENDLY_DOG"},
		{Name = "PLAYER_GREET_GENERIC"},
		{Name = "PLAYER_GREET_GENERIC_BOY"},
		{Name = "PLAYER_GREET_GENERIC_GIRL"},
		{Name = "PLAYER_GREET_HARASS"},
		
		{Name = "- INDEX: H -"},
		{Name = "PLAYER_HIT_SWITCH"},
		
		{Name = "- INDEX: I -"},
		{Name = "PLAYER_IDLE"},
		{Name = "PLAYER_IDLE_CLASS"},
		{Name = "PLAYER_IDLE_RAIN"},
		{Name = "PLAYER_IDLE_SHIVER"},
		{Name = "PLAYER_IDLE_TIRED"},
		{Name = "PLAYER_IDLE_WINTER"},
		{Name = "PLAYER_INFIRMARY"},
		
		{Name = "- INDEX: J -"},
		{Name = "PLAYER_JEER"},
		
		{Name = "- INDEX: L -"},
		{Name = "PLAYER_LAUGH_CRUEL"},
		{Name = "PLAYER_LAUGH_FRIENDLY"},
		{Name = "PLAYER_LOCKED"},
		{Name = "PLAYER_LOCKERING"},
		
		{Name = "- INDEX: M -"},
		{Name = "PLAYER_MAKE_OUT"},
		{Name = "PLAYER_MISCHIEVOUS"},
		{Name = "PLAYER_MISSION_SUCCESS"},
		
		{Name = "- INDEX: N -"},
		{Name = "PLAYER_NEGATIVE"},
		
		{Name = "- INDEX: O -"},
		{Name = "PLAYER_OFFICE"},
		
		{Name = "- INDEX: P -"},
		{Name = "PLAYER_PRIZE_TICKETS"},
		
		{Name = "- INDEX: S -"},
		{Name = "PLAYER_STEALTH"},
		{Name = "PLAYER_STEALTH_POTTY"},
		{Name = "PLAYER_SUCCESS"},
		
		{Name = "- INDEX: T -"},
		{Name = "PLAYER_TAG_COMPLETE"},
		{Name = "PLAYER_TAUNT"},
		{Name = "PLAYER_TAUNT_AUTHORITY"},
		{Name = "PLAYER_TAUNT_BURN"},
		{Name = "PLAYER_TAUNT_COMBAT"},
		{Name = "PLAYER_TAUNT_COMBAT_SHOVE"},
		{Name = "PLAYER_TAUNT_CONTINUED"},
		{Name = "PLAYER_TAUNT_DOG"},
		{Name = "PLAYER_TAUNT_DROPOUT"},
		{Name = "PLAYER_TAUNT_FACTION"},
		{Name = "PLAYER_TAUNT_FLEE"},
		{Name = "PLAYER_TAUNT_FLIRT_INSULT"},
		{Name = "PLAYER_TAUNT_GIRL"},
		{Name = "PLAYER_TAUNT_GREASER"},
		{Name = "PLAYER_TAUNT_HARASS"},
		{Name = "PLAYER_TAUNT_HARASS_FEMALE"},
		{Name = "PLAYER_TAUNT_HARASS_MALE"},
		{Name = "PLAYER_TAUNT_HUMILIATE"},
		{Name = "PLAYER_TAUNT_HUMILIATE_HIT"},
		{Name = "PLAYER_TAUNT_JOCK"},
		{Name = "PLAYER_TAUNT_KO"},
		{Name = "PLAYER_TAUNT_NERD"},
		{Name = "PLAYER_TAUNT_PREP"},
		{Name = "PLAYER_TAUNT_VICTIM"},
		{Name = "PLAYER_THROW_BALL"},
		{Name = "PLAYER_TIRED"},
		{Name = "PLAYER_TOILET_DUNK"},
		{Name = "PLAYER_TRASH_TALK"},
		
		{Name = "- INDEX: U -"},
		{Name = "PLAYER_URINATING"},
		
		{Name = "- INDEX: V -"},
		{Name = "PLAYER_VICTORY_INDIVIDUAL"},
		{Name = "PLAYER_VICTORY_TEAM"},
		
		{Name = "- INDEX: W -"},
		{Name = "PLAYER_WHEE"},
		
		{Name = "- MULTIPLAYER -"},
		{Name = "MP_TAUNT_JIMMY"},
	}},
	{Name = "NPC Line", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- DEFAULT: "..string.upper(Selected.Name).." -"},
					{Name = "Play Random Line", Func = function()
						local Ped = SelectPed(false)
						SoundPlayAmbientSpeechEvent(Ped, Selected.Name)
					end},
					
					{Name = "- CUSTOM: "..string.upper(Selected.Name).." -"},
					{Name = "0=0=10000"},
					{Name = "Play Specific Line", Func = function(Select)
						local Ped = SelectPed(false)
						local Line = GetArguments(2, GetMenuTrackbarValues(Table[Select - 1].Name))
						SoundPlayAmbientSpeechEventSpecific(Ped, Selected.Name, Line)
					end}
				}
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Table[Select].Func(Select)
					end
					ShowMenuBorder()
					
					Option = UpdateMenuLayout(Table, Option)
					ShowMenu(Table, Option, 'Name', Icon, false)
					Wait(0)
				until IsMenuPressed(1)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- INDEX: A -"},
		{Name = "ALLY_ABOUT_TO_LEAVE"},
		{Name = "ALLY_ACCEPT_ALLIANCE"},
		{Name = "ALLY_CHATTER"},
		{Name = "ALLY_HELP_ME"},
		{Name = "AMBIENT_SCENARIO"},
		{Name = "ART"},
		{Name = "ASS_PINCHED"},
		{Name = "ASYLUM"},
		{Name = "ASYLUM_PA"},
		{Name = "ATTACKED"},
		
		{Name = "- INDEX: B -"},
		{Name = "BASEBALL"},
		{Name = "BIKE_CRASH"},
		{Name = "BIKE_SEE_TRICK"},
		{Name = "BIKE_SEE_TRICK_FAIL"},
		{Name = "BIKE_STEALING"},
		{Name = "BIKE_STOLEN"},
		{Name = "BOISTEROUS"},
		{Name = "BRAG_FOUNTAIN"},
		{Name = "BUMPED"},
		{Name = "BUMP_FRIENDLY"},
		{Name = "BUMP_IN_CAR"},
		{Name = "BUMP_RUDE"},
		{Name = "BUMP_RUDE_DROPOUT"},
		{Name = "BUMP_RUDE_FALLEN"},
		{Name = "BUMP_RUDE_GREASER"},
		{Name = "BUMP_RUDE_IN_CAR"},
		{Name = "BUMP_RUDE_JOCK"},
		{Name = "BUMP_RUDE_NERD"},
		{Name = "BUMP_RUDE_OUT_OF_CAR"},
		{Name = "BUMP_RUDE_PREP"},
		{Name = "BUMP_VEHICLE"},
		{Name = "BURTON_COACH"},
		{Name = "BUS"},
		{Name = "BUSTED_CLASS"},
		{Name = "BUSTING"},
		{Name = "BUSTING_JIMMY"},
		{Name = "BYE"},
		
		{Name = "- INDEX: C -"},
		{Name = "CALL_FOR_HELP"},
		{Name = "CARNIE_FUNHOUSE_ATTRACT"},
		{Name = "CARNIE_FUNHOUSE_ATTRACT_PLAYER"},
		{Name = "CARNIE_FUNHOUSE_EXIT"},
		{Name = "CARNIE_GAME_ATTRACT"},
		{Name = "CARNIE_GAME_ATTRACT_PLAYER"},
		{Name = "CARNIE_GAME_EXIT_LOSE"},
		{Name = "CARNIE_GAME_EXIT_WIN"},
		{Name = "CARNIE_GAME_SELL"},
		{Name = "CARNIE_GOCART_ATTRACT"},
		{Name = "CARNIE_GOCART_ATTRACT_PLAYER"},
		{Name = "CARNIE_GOCART_EXIT_LOSE"},
		{Name = "CARNIE_GOCART_EXIT_WIN"},
		{Name = "CARNIE_GOCART_SELL"},
		{Name = "CARNIE_HAVE_FUN"},
		{Name = "CARNIE_RIDE_ATTRACT"},
		{Name = "CARNIE_RIDE_ATTRACT_PLAYER"},
		{Name = "CARNIE_RIDE_EXIT"},
		{Name = "CARNIE_TICKETS_BROWSE"},
		{Name = "CARNIE_TICKETS_NOT_ENOUGH"},
		{Name = "CARNIE_TICKETS_TRADE"},
		{Name = "CARNIVAL_EXIT_COMMENT"},
		{Name = "CHASE"},
		{Name = "CHASE_ESCAPE"},
		{Name = "CHASE_OUT_OF_BREATH"},
		{Name = "CHATTER"},
		{Name = "CHEERLEADING"},
		{Name = "CHEM"},
		{Name = "CITIZEN_ARREST"},
		{Name = "COMPLAIN"},
		{Name = "CONFUSED"},
		{Name = "CONGRATULATIONS"},
		{Name = "CONVERSATION_CONTINUATION"},
		{Name = "CONVERSATION_END"},
		{Name = "CONVERSATION_GOSSIP"},
		{Name = "CONVERSATION_GOSSIP_CHAPTER_1"},
		{Name = "CONVERSATION_GOSSIP_CHAPTER_2"},
		{Name = "CONVERSATION_GOSSIP_CHAPTER_3"},
		{Name = "CONVERSATION_GOSSIP_CHAPTER_4"},
		{Name = "CONVERSATION_GOSSIP_CHAPTER_5"},
		{Name = "CONVERSATION_GOSSIP_CHAPTER_6"},
		{Name = "CONVERSATION_GOSSIP_PERSONAL_PRIVATE"},
		{Name = "CONVERSATION_GOSSIP_PRIVATE"},
		{Name = "CONVERSATION_GOSSIP_REPLY"},
		{Name = "CONVERSATION_NEGATIVE_PERSONAL"},
		{Name = "CONVERSATION_NEGATIVE_REPLY"},
		{Name = "CONVERSATION_NEGATIVE_STATEMENT"},
		{Name = "CONVERSATION_PARTING"},
		{Name = "CONVERSATION_POSITIVE_PERSONAL"},
		{Name = "CONVERSATION_POSITIVE_PRIVATE"},
		{Name = "CONVERSATION_POSITIVE_REPLY"},
		{Name = "CONVERSATION_QUESTION"},
		{Name = "CONVERSATION_QUESTION_PRIVATE"},
		{Name = "CONVERSATION_QUESTION_REPLY"},
		{Name = "CONVERSATION_QUESTION_RESPONSE"},
		{Name = "CONVERSATION_START"},
		
		{Name = "- INDEX: D -"},
		{Name = "DARE"},
		{Name = "DEFEAT_INDIVIDUAL"},
		{Name = "DEFEAT_TEAM"},
		{Name = "DISGUST"},
		{Name = "DONT_HIT"},
		{Name = "DUNK_TANK"},
		
		{Name = "- INDEX: F -"},
		{Name = "FAKE_ID"},
		{Name = "FIGHTING"},
		{Name = "FIGHTING_DROPOUT"},
		{Name = "FIGHTING_GREASER"},
		{Name = "FIGHTING_JOCK"},
		{Name = "FIGHTING_NERD"},
		{Name = "FIGHTING_PREP"},
		{Name = "FIGHT_BEATEN"},
		{Name = "FIGHT_FLEE"},
		{Name = "FIGHT_INITIATE"},
		{Name = "FIGHT_SACKED"},
		{Name = "FIGHT_SPAT_UPON"},
		{Name = "FIGHT_WATCH"},
		{Name = "FIGHT_WTF"},
		{Name = "FIREALARM_REACTION"},
		{Name = "FLEE"},
		{Name = "FLUSTERED"},
		{Name = "FOOD_FIGHT"},
		{Name = "FOOT_STOMPED"},
		{Name = "FOR_SALE"},
		{Name = "FREAKSHOW_REACTION"},
		{Name = "FREAK_OUT_GIRL"},
		{Name = "FREAK_OUT_GIRL_DORM"},
		{Name = "FREAK_SHOW"},
		
		{Name = "- INDEX: G -"},
		{Name = "GENERIC_GIFT_REQUEST"},
		{Name = "GIFT_RECEIVE"},
		{Name = "GIFT_RECEIVE_EXTORTION"},
		{Name = "GIFT_RECEIVE_ROMANTIC"},
		{Name = "GIFT_REQUEST_EXTORTION"},
		{Name = "GIFT_REQUEST_GIRL"},
		{Name = "GIVE"},
		{Name = "GRAFFITI"},
		{Name = "GREAT_ESCAPE"},
		{Name = "GREET"},
		{Name = "GREET_AUTHORITY_FEMALE"},
		{Name = "GREET_AUTHORITY_MALE"},
		{Name = "GREET_CLOTHES_LIKE"},
		{Name = "GREET_GIRL_WON"},
		{Name = "GREET_HOT_GIRL"},
		{Name = "GREET_PANTS_LIKE"},
		{Name = "GREET_PLAYER_CLOTHES_LIKE"},
		{Name = "GREET_PLAYER_HAIRCUT_LIKE"},
		{Name = "GREET_PLAYER_HAT_LIKE"},
		{Name = "GREET_PLAYER_PANTS_LIKE"},
		{Name = "GREET_PLAYER_SHIRT_LIKE"},
		{Name = "GREET_PLAYER_SHOES_LIKE"},
		{Name = "GREET_PLAYER_TATTOO_LIKE"},
		{Name = "GROOMING"},
		{Name = "GROOOMING"},
		
		{Name = "- INDEX: H -"},
		{Name = "HELP_EXPLANATION"},
		{Name = "HELP_REQUIRED"},
		{Name = "HISTRIKE"},
		{Name = "HOMELESS_HELP"},
		{Name = "HUMILIATION_ANIM"},
		
		{Name = "- INDEX: I -"},
		{Name = "INDIGNANT"},
		{Name = "INFIRMARY"},
		{Name = "INTIMIDATED_HELLO"},
		
		{Name = "- INDEX: J -"},
		{Name = "JEER"},
		
		{Name = "- INDEX: K -"},
		{Name = "KEEPUPS"},
		
		{Name = "- INDEX: L -"},
		{Name = "LAUGH"},
		{Name = "LAUGH_CRUEL"},
		{Name = "LAUGH_FRIENDLY"},
		{Name = "LAWNMOWER"},
		
		{Name = "- INDEX: M -"},
		{Name = "MAKE_OUT_READY"},
		{Name = "MAKING_OUT"},
		{Name = "MAKING_OUT_FINISHED"},
		{Name = "MP_TAUNT_GARY"},
		{Name = "MP_TAUNT_LMG"},
		{Name = "MP_TAUNT_MS"},
		{Name = "MP_TAUNT_WMG"},
		{Name = "MYSTERY_MEAT"},
		
		{Name = "- INDEX: P -"},
		{Name = "PAIN"},
		{Name = "PAYBACK"},
		{Name = "PENALTY"},
		{Name = "PHOTOGRAPHER"},
		{Name = "PRANK"},
		{Name = "PRIOFF"},
		{Name = "PUKE"},
		{Name = "PUKE_START"},
		
		{Name = "- INDEX: R -"},
		{Name = "RAT_HIT"},
		{Name = "RAT_KILLER"},
		{Name = "RESPONSE_GREET_DISS"},
		{Name = "RESPONSE_GREET_FRIENDLY"},
		{Name = "RESPONSE_IGNORE"},
		{Name = "RESPONSE_UNINTERESTED"},
		
		{Name = "- INDEX: S -"},
		{Name = "SCARED"},
		{Name = "SCARED_CRY"},
		{Name = "SEE_ALLY_ATTACKED"},
		{Name = "SEE_BOY_IN_DORM"},
		{Name = "SEE_SOMETHING_COOL"},
		{Name = "SEE_SOMETHING_CRAP"},
		{Name = "SEE_VANDALISM"},
		{Name = "SEE_WEAPON_FIRED"},
		{Name = "SHIPPING"},
		{Name = "SOLD"},
		{Name = "STEALTH_CONFUSION"},
		{Name = "STEALTH_DISCOVERING"},
		{Name = "STEALTH_INVESTIGATING"},
		{Name = "STEALTH_PURSUIT"},
		{Name = "STEALTH_TARGET_LOST"},
		{Name = "STINK_BOMB"},
		{Name = "STORE_BYE_BUY"},
		{Name = "STORE_BYE_NOBUY"},
		{Name = "STORE_BYE_NO_BUY"},
		{Name = "STORE_CHASE_VANDAL"},
		{Name = "STORE_CLOTHES_BROWSING"},
		{Name = "STORE_CLOTHING_COMMENT"},
		{Name = "STORE_VIOLENCE_RESPONSE"},
		{Name = "STORE_WELCOME"},
		{Name = "STRANGE_HOBO"},
		{Name = "SUCKING_UP"},
		
		{Name = "- INDEX: T -"},
		{Name = "TAGGING_DISAPPROVE"},
		{Name = "TATTLE"},
		{Name = "TATTLED"},
		{Name = "TATTLED_TO"},
		{Name = "TAUNT"},
		{Name = "TAUNT_AGGRO"},
		{Name = "TAUNT_BACK_DOWN"},
		{Name = "TAUNT_HARASS"},
		{Name = "TAUNT_KICK"},
		{Name = "TAUNT_NEIGHBOURHOOD_DROPOUT"},
		{Name = "TAUNT_NEIGHBOURHOOD_GREASER"},
		{Name = "TAUNT_NEIGHBOURHOOD_PREP"},
		{Name = "TAUNT_NEW_KID"},
		{Name = "TAUNT_PLAYER_DISLIKE_CLOTHES"},
		{Name = "TAUNT_PLAYER_DISLIKE_HAIR"},
		{Name = "TAUNT_PLAYER_DISLIKE_HAT"},
		{Name = "TAUNT_PLAYER_DISLIKE_PANTS"},
		{Name = "TAUNT_PLAYER_DISLIKE_SHIRT"},
		{Name = "TAUNT_PLAYER_DISLIKE_SHOES"},
		{Name = "TAUNT_PLAYER_DISLIKE_TATTOO"},
		{Name = "TAUNT_PLAYER_EGGS"},
		{Name = "TAUNT_PLAYER_FALLEN"},
		{Name = "TAUNT_PLAYER_LIKES_CLOTHES"},
		{Name = "TAUNT_RESPONSE"},
		{Name = "TAUNT_RESPONSE_CRY"},
		{Name = "TAUNT_RESPONSE_DONT_CARE"},
		{Name = "TAUNT_RESPONSE_PLEAD"},
		{Name = "THANKS_JIMMY"},
		{Name = "THANK_YOU"},
		{Name = "THIS_WAY"},
		{Name = "TOILET_DUNK_DEFEAT"},
		{Name = "TOILET_DUNK_STRUGGLE"},
		{Name = "TRASH_TALK_PERSONAL"},
		{Name = "TRASH_TALK_TEAM"},
		
		{Name = "- INDEX: U -"},
		{Name = "UNKNOWN"},
		{Name = "UNKOWN"},
		
		{Name = "- INDEX: V -"},
		{Name = "VENDETTA_NERD"},
		{Name = "VICTIMIZED"},
		{Name = "VICTMIZING"},
		{Name = "VICTORY_INDIVIDUAL"},
		{Name = "VICTORY_TEAM"},
		
		{Name = "- INDEX: W -"},
		{Name = "WAIT_FOR_ME"},
		{Name = "WARNING_CLOTHING_RESPONSE"},
		{Name = "WARNING_COMING_TO_CATCH"},
		{Name = "WARNING_CURFEW"},
		{Name = "WARNING_GET_TO_CLASS"},
		{Name = "WARNING_MINOR_INFRACTION"},
		{Name = "WARNING_TRESPASSING"},
		{Name = "WARNING_TRUANCY"},
		{Name = "WHAT_IS_THAT"},
		{Name = "WHERES_YOUR_COSTUME"},
		{Name = "WHINE"},
		{Name = "Wrestling1"},
		{Name = "WTF_TV"},
		
		{Name = "- INDEX: Y -"},
		{Name = "YEARBOOK"},
	}},
	{Name = "Mission Dialogue", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		local Informed = false
		
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				
				local BruteForceSpeech = function(Ped)
					SoundStopCurrentSpeechEvent(Ped)
					
					local SpeechID = Selected.Index
					for ID = Selected.Index + 1, 151 do
						if not SoundSpeechPlaying(Ped) then
							SoundPlayScriptedSpeechEvent(Ped, Selected.Name, ID, 'xtralarge')
						else
							Selected.Index = ID - 1
							break
						end
					end
					if Selected.Index == SpeechID then
						Selected.Index = -1
					end
				end
				local Table = {
					{Name = "- DEFAULT: "..string.upper(Selected.Name).." -"},
					{Name = "Play Player Dialogue", Func = function()
						BruteForceSpeech(gPlayer)
					end},
					{Name = "Play NPC Dialogue", Func = function()
						local Ped = SelectPed(false)
						if not PedIsValid(Ped) then
							return
						end
						BruteForceSpeech(Ped)
					end},
					
					{Name = "- CUSTOM: "..string.upper(Selected.Name).." -"},
					{Name = "0=0=1000"},
					{Name = "Play Specific Dialogue", Func = function(Table, Select)
						local Ped = SelectPed(true)
						if not PedIsValid(Ped) then
							return
						end
						local Line = GetArguments(2, GetMenuTrackbarValues(Table[Select - 1].Name))
						SoundPlayAmbientSpeechEventSpecific(gPlayer, Selected.Name, Line)
					end}
				}
				local Option = 1
				
				if not Informed then
					SetQueuedMessage('JUST SO YOU KNOW', "If you're not hearing any voices, it's not your speakers' fault. That character simply has nothing to say in this mission.", 4)
					Informed = true
				end
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Table[Select].Func(Table, Select)
					end
					ShowMenuBorder()
					
					Option = UpdateMenuLayout(Table, Option)
					ShowMenu(Table, Option, 'Name', Icon, false)
					Wait(0)
				until IsMenuPressed(1)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- INDEX: C -", Index = -1},
		{Name = "ClassArt", Index = -1},
		{Name = "ClassBiology", Index = -1},
		{Name = "ClassChem", Index = -1},
		{Name = "ClassEnglish", Index = -1},
		{Name = "ClassGeography", Index = -1},
		{Name = "ClassMath", Index = -1},
		{Name = "ClassMusic", Index = -1},
		{Name = "ClassPhoto", Index = -1},
		{Name = "ClassShop", Index = -1},
		
		{Name = "- INDEX: E -", Index = -1},
		{Name = "ENGLISH", Index = -1},
		
		{Name = "- INDEX: M -", Index = -1},
		{Name = "M_1_01", Index = -1},
		{Name = "M_1_02", Index = -1},
		{Name = "M_1_02A", Index = -1},
		{Name = "M_1_02B", Index = -1},
		{Name = "M_1_03", Index = -1},
		{Name = "M_1_04", Index = -1},
		{Name = "M_1_05", Index = -1},
		{Name = "M_1_06", Index = -1},
		{Name = "M_1_06_01", Index = -1},
		{Name = "M_1_07", Index = -1},
		{Name = "M_1_08", Index = -1},
		{Name = "M_1_09", Index = -1},
		{Name = "M_1_10", Index = -1},
		{Name = "M_1_11", Index = -1},
		{Name = "M_1_11X1", Index = -1},
		{Name = "M_1_11X2", Index = -1},
		{Name = "M_1_B", Index = -1},
		{Name = "M_1_G1", Index = -1},
		{Name = "M_1_S01", Index = -1},
		{Name = "M_2_01", Index = -1},
		{Name = "M_2_02", Index = -1},
		{Name = "M_2_03", Index = -1},
		{Name = "M_2_04", Index = -1},
		{Name = "M_2_05", Index = -1},
		{Name = "M_2_06", Index = -1},
		{Name = "M_2_07", Index = -1},
		{Name = "M_2_08", Index = -1},
		{Name = "M_2_09", Index = -1},
		{Name = "M_2_B", Index = -1},
		{Name = "M_2_G2", Index = -1},
		{Name = "M_2_R03", Index = -1},
		{Name = "M_2_R11", Index = -1},
		{Name = "M_2_S02", Index = -1},
		{Name = "M_2_S04", Index = -1},
		{Name = "M_2_S05", Index = -1},
		{Name = "M_2_S06", Index = -1},
		{Name = "M_2_S07", Index = -1},
		{Name = "M_3_01", Index = -1},
		{Name = "M_3_01A", Index = -1},
		{Name = "M_3_01B", Index = -1},
		{Name = "M_3_01C", Index = -1},
		{Name = "M_3_01D", Index = -1},
		{Name = "M_3_02", Index = -1},
		{Name = "M_3_03", Index = -1},
		{Name = "M_3_04", Index = -1},
		{Name = "M_3_05", Index = -1},
		{Name = "M_3_06", Index = -1},
		{Name = "M_3_07", Index = -1},
		{Name = "M_3_08", Index = -1},
		{Name = "M_3_B", Index = -1},
		{Name = "M_3_B_2D", Index = -1},
		{Name = "M_3_G3", Index = -1},
		{Name = "M_3_R05A", Index = -1},
		{Name = "M_3_R06", Index = -1},
		{Name = "M_3_R07", Index = -1},
		{Name = "M_3_R08", Index = -1},
		{Name = "M_3_R09", Index = -1},
		{Name = "M_3_R09_D", Index = -1},
		{Name = "M_3_R09_G", Index = -1},
		{Name = "M_3_R09_J", Index = -1},
		{Name = "M_3_R09_N", Index = -1},
		{Name = "M_3_R09_P", Index = -1},
		{Name = "M_3_S03", Index = -1},
		{Name = "M_3_S08", Index = -1},
		{Name = "M_3_S10", Index = -1},
		{Name = "M_3_S11", Index = -1},
		{Name = "M_4_01", Index = -1},
		{Name = "M_4_02", Index = -1},
		{Name = "M_4_02_2D", Index = -1},
		{Name = "M_4_03", Index = -1},
		{Name = "M_4_03_2D", Index = -1},
		{Name = "M_4_04", Index = -1},
		{Name = "M_4_05", Index = -1},
		{Name = "M_4_06", Index = -1},
		{Name = "M_4_07", Index = -1},
		{Name = "M_4_B1", Index = -1},
		{Name = "M_4_B2", Index = -1},
		{Name = "M_4_B3", Index = -1},
		{Name = "M_4_G4", Index = -1},
		{Name = "M_4_G5", Index = -1},
		{Name = "M_4_G6", Index = -1},
		{Name = "M_4_S11", Index = -1},
		{Name = "M_4_S12", Index = -1},
		{Name = "M_5_01", Index = -1},
		{Name = "M_5_02", Index = -1},
		{Name = "M_5_03", Index = -1},
		{Name = "M_5_04", Index = -1},
		{Name = "M_5_05", Index = -1},
		{Name = "M_5_06", Index = -1},
		{Name = "M_5_07", Index = -1},
		{Name = "M_5_07A", Index = -1},
		{Name = "M_5_09", Index = -1},
		{Name = "M_5_B", Index = -1},
		{Name = "M_5_G5", Index = -1},
		{Name = "M_6_02", Index = -1},
		{Name = "M_6_03", Index = -1},
		{Name = "M_6_B", Index = -1},
		{Name = "M_E", Index = -1},
		{Name = "M_SPEECH_EVENTS", Index = -1},
		
		{Name = "- INDEX: N -", Index = -1},
		{Name = "NARRATION", Index = -1},
		
		{Name = "- INDEX: P -", Index = -1},
		{Name = "PHOTOGRAPHY", Index = -1},
		{Name = "PRINCIPAL_LECTURING", Index = -1},
		{Name = "PA_CHRISTMAS_JIMMY", Index = -1},
		{Name = "PA_FIREALARM", Index = -1},
		{Name = "PA_GALLOWAY", Index = -1},
		{Name = "PA_GALLOWAY_BACK", Index = -1},
		{Name = "PA_GENERAL", Index = -1},
		{Name = "PA_JIMMY_OFFICE_MILD", Index = -1},
		{Name = "PA_JIMMY_OFFICE_STRONG", Index = -1},
		
		{Name = "- INDEX: S -", Index = -1},
		{Name = "SHOP_CLASS", Index = -1},
		{Name = "SNOW_SHOVELLING", Index = -1},
		
		{Name = "- INDEX: W -", Index = -1},
		{Name = "WRESTLING", Index = -1},
	}},
	{Name = "Settings", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		local GetHeader = function(Select)
			while not IsMenuHeader(Sub.Data[Select].Name) do
				Select = Select - 1
			end
			return TrimHeader(Sub.Data[Select].Name)
		end
		
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Header = GetHeader(Select)
				if Header == 'MUSIC VOLUME' then
					local Current = GetArguments(2, GetMenuTrackbarValues(Sub.Data[Select - 1].Name))
					Sub.Data[Select].Func(Current)
				elseif Header == 'SPEECH VOLUME' then
					local Current = GetArguments(2, GetMenuPickerValues(Sub.Data[Select - 1].Name))
					Sub.Data[Select].Func(Current)
				else
					Sub.Data[Select].Func()
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- GENERAL -"},
		{Name = "Pause Audio", Func = SoundPause},
		{Name = "Resume Audio", Func = SoundContinue},
		{Name = "Mute NPC=(XO)", XO = NPCSettings.Mute, Func = function(Boolean)
			NPCSettings.Mute = Boolean
			
			if not NPCSettings.Mute then
				for Ped in AllPeds() do
					if Ped ~= gPlayer and PedGetFlag(Ped, 129) then
						PedSetFlag(Ped, 129, false)
					end
				end
			end
		end},
		
		{Name = "- MUSIC VOLUME -"},
		{Name = "0=10=100"},
		{Name = "Set Default Music Volume", Func = function(Value)
			MUSIC_DEFAULT_VOLUME = Value / 10
		end},
		
		{Name = "- SPEECH VOLUME -"},
		{Name = "0>0<7", Strings = GetSpeechVolumeName()},
		{Name = "Set Default Speech Volume", Func = function(Value)
			NPCSettings.SpeechVolume = Value
		end},
	}},
}})