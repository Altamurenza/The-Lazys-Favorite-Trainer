-- STORYLINE.LUA
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
	{Name = "Main Mission", Option = 1, Func = function(Selects)
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
				local Selected = Sub.Data[Select]
				local Header = GetHeader(Select)
				
				local IsMissionKnown = IsMissionRegistered(Selected.Code)
				local IsMissionIndex = type(Selected.Code) == 'number'
				local Start = IsMissionKnown and (
					IsMissionIndex and ForceStartMissionIndex or ForceStartMission
				) or ForceStartMissionFile
				
				local Table = {}
				table.insert(Table, {Name = "- "..GetHeader(Select)..": "..string.upper(Selected.Name).." -"})
				table.insert(Table, {Name = "Start", Func = Start})
				if not IsMissionIndex or not IsMissionKnown then
					table.insert(Table, {Name = "Spawn", Func = ForceMissionAvailable})
					table.insert(Table, {Name = "Complete", Func = MissionSuccessCountInc})
				end
				local Option = 1
				
				local Execute = function(Func, Select)
					if Select == 2 and MissionActive() then
						SetQueuedMessage('NOT SO FAST', "One mission at a time, champ. You're not saving the world that fast.", 4)
						return
					end
					Func(Selected.Code)
				end
				
				if Selected.Warn then
					SetQueuedMessage('YOU’VE BEEN WARNED', 'This mission is basically held together with duct tape. Expect bugs. Possibly explosions.', 4)
				end
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Execute(Table[Select].Func, Select)
					end
					ShowMenuBorder()
					
					Option = UpdateMenuLayout(Table, Option)
					ShowMenu(Table, Option, 'Name', Icon, false)
					Wait(0)
				until IsMenuPressed(1)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- CHAPTER ONE -"},
		{Name = "Welcome To The Bullworth", Code = "1_01"},
		{Name = "Meet Gary", Code = "1_02A"},
		{Name = "This Is Your School", Code = "1_02B"},
		{Name = "Get to Class", Code = "1_02C"},
		{Name = "The Setup", Code = "1_03"},
		{Name = "The Slingshot", Code = "1_04"},
		{Name = "Save Algie", Code = "1_05"},
		{Name = "A Little Help", Code = "1_06_01"},
		{Name = "Petey Errand", Code = "1_E01"},
		{Name = "Defend Bucky", Code = "1_07"},
		{Name = "That Bitch", Code = "1_08"},
		{Name = "The Candidate", Code = "1_09"},
		{Name = "The Diary", Code = "1_G1"},
		{Name = "Halloween", Code = "1_11x1"},
		{Name = "Halloween Errands", Code = "1_11xp"},
		{Name = "The Big Prank", Code = "1_11x2"},
		{Name = "Help Gary", Code = "1_10"},
		{Name = "Russell In The Hole", Code = "1_B"},
		
		{Name = "- CHAPTER TWO -"},
		{Name = "Chapter Two Transition", Code = "Chapt1Trans"},
		{Name = "Last Minute Shoping", Code = "2_01"},
		{Name = "Klepto Comic", Code = "2_02"},
		{Name = "Movie Tickets", Code = "2_06"},
		{Name = "Carnival Date", Code = "2_G2"},
		{Name = "The Eggs", Code = "2_03"},
		{Name = "Race The Vale", Code = "2_04"},
		{Name = "Race The Vale (Start)", Code = 48},
		{Name = "Beach Rumble", Code = "2_07"},
		{Name = "Weed Killer", Code = "2_08"},
		{Name = "Tad House", Code = "2_05"},
		{Name = "Boxing Challenge", Code = "2_09"},
		{Name = "Dishonorable Fight", Code = "2_B"},
		
		{Name = "- CHAPTER THREE -"},
		{Name = "Chapter Three Transition", Code = "Chapt2Trans"},
		{Name = "Balls of Snow", Code = "3_01A"},
		{Name = "Rudy The Red Nosed Santa", Code = "3_01D"},
		{Name = "Jealous Johnny", Code = "3_01"},
		{Name = "Bait", Code = "3_02"},
		{Name = "Rendezvous", Code = "3_03", Warn = true},
		{Name = "Nutcrackin", Code = "3_01C"},
		{Name = "Christmas Conversation", Code = "3_07", Warn = true},
		{Name = "Christmas Is Here", Code = "3_08_Launch"},
		{Name = "Christmas Is Here (Start)", Code = "3_08"},
		{Name = "Miracle On Bullworth Street", Code = "3_XM"},
		{Name = "Tagging", Code = "3_S10"},
		{Name = "Lola Race", Code = "3_G3"},
		{Name = "The Tenements", Code = "3_05"},
		{Name = "Wrong Part of Town", Code = "3_04"},
		{Name = "The Rumble", Code = "3_06"},
		{Name = "Fighting with Johnny Vincent", Code = "3_B"},
		
		{Name = "- CHAPTER FOUR -"},
		{Name = "Chapter Four Transition", Code = "Chapt3Trans"},
		{Name = "Stronghold Assault", Code = "4_02"},
		{Name = "Nerd Boss Fight", Code = "4_B1"},
		{Name = "Paparazi", Code = "4_01"},
		{Name = "Defender Of Castle", Code = "4_03"},
		{Name = "Discretion Assured", Code = "4_G4"},
		{Name = "Funhouse Fun", Code = "4_04"},
		{Name = "Nice Outfit", Code = "4_05"},
		{Name = "The Big Game", Code = "4_06"},
		{Name = "Fight Ted", Code = "4_B2"},
		
		{Name = "- CHAPTER FIVE -"},
		{Name = "Chapter Five Transition", Code = "Chapt4Trans"},
		{Name = "Making a Mark", Code = "5_09"},
		{Name = "Rats in the library", Code = "5_01"},
		{Name = "Preppies Vandalized", Code = "5_02"},
		{Name = "The Gym Is Burning", Code = "5_04"},
		{Name = "Finding Johnny Vincent", Code = "5_03"},
		{Name = "Revenge On Mr.Button", Code = "5_05"},
		{Name = "Expelled Launcher", Code = "6_01_Launch"},
		{Name = "Expelled", Code = "6_01"},
		{Name = "Busting In Part 1", Code = "5_06"},
		{Name = "Busting In Part 2", Code = "5_07a"},
		{Name = "Showdown at the plant", Code = "5_B"},
		{Name = "Complete Mayhem", Code = "6_02"},
		{Name = "Complete Mayhem II", Code = "6_03"},
		{Name = "Final Showdown", Code = "6_B"},
		
		{Name = "- CHAPTER SIX -"},
		{Name = "Chapter Six Transition", Code = 126},
	}},
	{Name = "Side Mission", Option = 1, Func = function(Selects)
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
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- "..GetHeader(Select)..": "..string.upper(Selected.Name).." -"},
					{Name = "Start", Func = ForceStartMission, Args = {Selected.Code}},
					{Name = "Spawn", Func = ForceMissionAvailable, Args = {Selected.Code}},
					{Name = "Complete", Func = MissionSuccessCountInc, Args = {Selected.Code}}
				}
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						if Select == 2 and MissionActive() then
							SetQueuedMessage('NOT SO FAST', "One mission at a time, champ. You're not saving the world that fast.", 4)
						else
							Table[Select].Func(unpack(Table[Select].Args))
						end
					end
					ShowMenuBorder()
					
					Option = UpdateMenuLayout(Table, Option)
					ShowMenu(Table, Option, 'Name', Icon, false)
					Wait(0)
				until IsMenuPressed(1)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- CHAPTER TWO -"},
		{Name = "Character Sheets", Code = "2_S04"},
		{Name = "Small Offeces", Code = "2_S07"},
		{Name = "Panty Raid", Code = "2_S06"},
		{Name = "Hattrick vs Galloway", Code = "1_S01"},
		
		{Name = "- CHAPTER THREE -"},
		{Name = "Cook's Crush", Code = "2_S05"},
		{Name = "Glass House", Code = "2_S02"},
		{Name = "Cook's Date", Code = "2_S05B"},
		
		{Name = "- CHAPTER FOUR -"},
		{Name = "Galloway Away", Code = "3_S11"},
		{Name = "Discreet Deliveries", Code = "3_R05B"},
		{Name = "Here's to you Ms.Phillips", Code = "4_S12"},
		
		{Name = "- CHAPTER FIVE -"},
		{Name = "Cheating Time", Code = "3_S03"},
		{Name = "The Collector", Code = "3_R07"},
		{Name = "Mailbox Armageddon", Code = "3_S08"},
		{Name = "Smash It Up", Code = "5_G5"},
	}},
	{Name = "Class", Option = 1, Func = function(Selects)
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
				local Selected = Sub.Data[Select]
				local IsMissionIndex = type(Selected.Code) == 'number'
				
				local Table = {}
				table.insert(Table, {Name = "- "..GetHeader(Select)..": "..string.upper(Selected.Name).." -"})
				table.insert(Table, {Name = "Start", Func = IsMissionIndex and ForceStartMissionIndex or ForceStartMission, Args = {Selected.Code}})
				if not IsMissionIndex then
					table.insert(Table, {Name = "Spawn", Func = ForceMissionAvailable, Args = {Selected.Code}})
					table.insert(Table, {Name = "Complete", Func = MissionSuccessCountInc, Args = {Selected.Code}})
				end
				local Option = 1
				
				if Selected.Warn then
					SetQueuedMessage('DEPRECATED AND DANGEROUS', "This multiplayer class was removed by the devs for reasons. Launching it might summon bugs or crash the game.", 4)
				end
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						if Select == 2 and MissionActive() then
							SetQueuedMessage('NOT SO FAST', "One mission at a time, champ. You're not saving the world that fast.", 4)
						else
							Table[Select].Func(unpack(Table[Select].Args))
						end
					end
					ShowMenuBorder()
					
					Option = UpdateMenuLayout(Table, Option)
					ShowMenu(Table, Option, 'Name', Icon, false)
					Wait(0)
				until IsMenuPressed(1)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- CHEMISTRY -"},
		{Name = "Chemistry 1", Code = "C_Chem_1"},
		{Name = "Chemistry 2", Code = "C_Chem_2"},
		{Name = "Chemistry 3", Code = "C_Chem_3"},
		{Name = "Chemistry 4", Code = "C_Chem_4"},
		{Name = "Chemistry 5", Code = "C_Chem_5"},
		
		{Name = "- BIOLOGY -"},
		{Name = "Biology 1", Code = "C_Biology_1"},
		{Name = "Biology 2", Code = "C_Biology_2"},
		{Name = "Biology 3", Code = "C_Biology_3"},
		{Name = "Biology 4", Code = "C_Biology_4"},
		{Name = "Biology 5", Code = "C_Biology_5"},
		
		{Name = "- ART -"},
		{Name = "Art 1", Code = "C_ART_1"},
		{Name = "Art 2", Code = "C_ART_2"},
		{Name = "Art 3", Code = "C_ART_3"},
		{Name = "Art 4", Code = "C_ART_4"},
		{Name = "Art 5", Code = "C_ART_5"},
		
		{Name = "- MATH -"},
		{Name = "Math 1", Code = "C_Math_1"},
		{Name = "Math 2", Code = "C_Math_2"},
		{Name = "Math 3", Code = "C_Math_3"},
		{Name = "Math 4", Code = "C_Math_4"},
		{Name = "Math 5", Code = "C_Math_5"},
		
		{Name = "- GYM -"},
		{Name = "Gym 1", Code = "C_WRESTLING_1"},
		{Name = "Gym 2", Code = "C_WRESTLING_2"},
		{Name = "Gym 3", Code = "C_WRESTLING_3"},
		{Name = "Gym 4", Code = "C_WRESTLING_4"},
		{Name = "Gym 5", Code = "C_WRESTLING_5"},
		
		{Name = "- ENGLISH -"},
		{Name = "English 1", Code = "C_English_1"},
		{Name = "English 2", Code = "C_English_2"},
		{Name = "English 3", Code = "C_English_3"},
		{Name = "English 4", Code = "C_English_4"},
		{Name = "English 5", Code = "C_English_5"},
		
		{Name = "- PHOTOGRAPHY -"},
		{Name = "Photography 1", Code = "C_Photography_2"},
		{Name = "Photography 2", Code = "C_Photography_1"},
		{Name = "Photography 3", Code = "C_Photography_3"},
		{Name = "Photography 4", Code = "C_Photography_4"},
		{Name = "Photography 5", Code = "C_Photography_5"},
		
		{Name = "- SHOP -"},
		{Name = "Shop 1", Code = "C_Shop_1"},
		{Name = "Shop 2", Code = "C_Shop_2"},
		{Name = "Shop 3", Code = "C_Shop_3"},
		{Name = "Shop 4", Code = "C_Shop_4"},
		{Name = "Shop 5", Code = "C_Shop_5"},
		
		{Name = "- GEOGRAPHY -"},
		{Name = "Geography 1", Code = "C_Geography_1"},
		{Name = "Geography 2", Code = "C_Geography_2"},
		{Name = "Geography 3", Code = "C_Geography_3"},
		{Name = "Geography 4", Code = "C_Geography_4"},
		{Name = "Geography 5", Code = "C_Geography_5"},
		
		{Name = "- MUSIC -"},
		{Name = "Music 1", Code = "C_Music_1"},
		{Name = "Music 2", Code = "C_Music_2"},
		{Name = "Music 3", Code = "C_Music_3"},
		{Name = "Music 4", Code = "C_Music_4"},
		{Name = "Music 5", Code = "C_Music_5"},
		
		{Name = "- DODGEBALL -"},
		{Name = "Dodgeball 1", Code = "C_Dodgeball_1"},
		{Name = "Dodgeball 2", Code = "C_Dodgeball_2"},
		{Name = "Dodgeball 3", Code = "C_Dodgeball_3"},
		{Name = "Dodgeball 4", Code = "C_Dodgeball_4"},
		{Name = "Dodgeball 5", Code = "C_Dodgeball_5"},
		
		{Name = "- MULTIPLAYER CLASSES -"},
		{Name = "English", Code = 228, Warn = true},
		{Name = "Math", Code = 229, Warn = true},
		{Name = "Geography", Code = 232, Warn = true},
		{Name = "Art", Code = 233, Warn = true},
		{Name = "Photography", Code = 234, Warn = true},
		{Name = "Biology", Code = 235, Warn = true},
		{Name = "Chemistry", Code = 238, Warn = true},
		{Name = "Music", Code = 239, Warn = true},
	}},
	{Name = "Activity", Option = 1, Func = function(Selects)
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
				local Selected = Sub.Data[Select]
				local IsMissionIndex = type(Selected.Code) == 'number'
				
				local Table = {}
				table.insert(Table, {Name = "- "..GetHeader(Select)..": "..string.upper(Selected.Name).." -"})
				table.insert(Table, {Name = "Start", Func = IsMissionIndex and ForceStartMissionIndex or ForceStartMission, Args = {Selected.Code}})
				if not IsMissionIndex then
					table.insert(Table, {Name = "Spawn", Func = ForceMissionAvailable, Args = {Selected.Code}})
					table.insert(Table, {Name = "Complete", Func = MissionSuccessCountInc, Args = {Selected.Code}})
				end
				local Option = 1
				
				if Selected.Warn then
					SetQueuedMessage('ABANDONED BY THE DEV', "This activity was left half-baked by the devs. Don't be surprised if the game breaks.", 4)
				end
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						if Select == 2 and MissionActive() then
							SetQueuedMessage('NOT SO FAST', "One mission at a time, champ. You're not saving the world that fast.", 4)
						else
							Table[Select].Func(unpack(Table[Select].Args))
						end
					end
					ShowMenuBorder()
					
					Option = UpdateMenuLayout(Table, Option)
					ShowMenu(Table, Option, 'Name', Icon, false)
					Wait(0)
				until IsMenuPressed(1)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- HOBO TRAINING -"},
		{Name = "A Little Help 2", Code = "1_06_02"},
		{Name = "A Little Help 3", Code = "1_06_03"},
		{Name = "A Little Help 4", Code = "1_06_04"},
		{Name = "A Little Help 5", Code = "1_06_07"},
		{Name = "A Little Help 6", Code = "1_06_08"},
		
		{Name = "- BULLWORTH VALE RACE -"},
		{Name = "Race 1", Code = "3_R08_Rich1"},
		{Name = "Race 2", Code = "3_R08_Rich2"},
		{Name = "Race 3", Code = "3_R08_Rich3"},
		{Name = "Race 4", Code = "3_R08_Rich4"},
		{Name = "Race 5", Code = "3_R08_Rich5"},
		{Name = "Race 6", Code = "3_R08_Rich6"},
		{Name = "Race 7", Code = "3_R08_Rich7"},
		
		{Name = "- BULLWORTH TOWN RACE -"},
		{Name = "Race 1", Code = "3_R08_Business1"},
		{Name = "Race 2", Code = "3_R08_Business2"},
		{Name = "Race 3", Code = "3_R08_Business3"},
		{Name = "Race 4", Code = "3_R08_Business4"},
		
		{Name = "- NEW COVENTRY RACE -"},
		{Name = "New Coventry Race 1", Code = "3_R08_Poor1"},
		{Name = "New Coventry Race 2", Code = "3_R08_Poor2"},
		
		{Name = "- SCHOOL RACE -"},
		{Name = "Academy Bike Race", Code = "3_R08_School1"},
		
		{Name = "- GO KART RACE -"},
		{Name = "Race 1", Code = "GoKart_GP1"},
		{Name = "Race 2", Code = "GoKart_GP2"},
		{Name = "Race 3", Code = "GoKart_GP3"},
		{Name = "Race 4", Code = "GoKart_GP4"},
		{Name = "Race 5", Code = "GoKart_GP5"},
		{Name = "Street Race 1", Code = "GoKart_SR1"},
		{Name = "Street Race 2", Code = "GoKart_SR2"},
		{Name = "Street Race 3", Code = "GoKart_SR3"},
		
		{Name = "- DETENTION -"},
		{Name = "Principal Meeting", Code = 261},
		{Name = "Mowing 1 70%", Code = "LawnMowing1a"},
		{Name = "Mowing 1 80%", Code = "LawnMowing1b"},
		{Name = "Mowing 1 90%", Code = "LawnMowing1c"},
		{Name = "Mowing 2 70%", Code = "LawnMowing2a"},
		{Name = "Mowing 2 80%", Code = "LawnMowing2b"},
		{Name = "Mowing 2 90%", Code = "LawnMowing2c"},
		{Name = "Mowing 3 70%", Code = "LawnMowing3a"},
		{Name = "Mowing 3 80%", Code = "LawnMowing3b"},
		{Name = "Mowing 3 90%", Code = "LawnMowing3c"},
		{Name = "Snow Shoveling 1", Code = "P_Snow1"},
		{Name = "Snow Shoveling 2", Code = "P_Snow2"},
		{Name = "Snow Shoveling 3", Code = "P_Snow3"},
		{Name = "Snow Shoveling 4", Code = "P_Snow4"},
		{Name = "Snow Shoveling 5", Code = "P_Snow5"},
		{Name = "Snow Shoveling 6", Code = "P_Snow6"},
		
		{Name = "- JOB -"},
		{Name = "Paper Route Intro", Code = "2_R03"},
		{Name = "Paper Route", Code = "2_R03_X"},
		{Name = "Mowing Park 1", Code = "JobLawnMowing1a"},
		{Name = "Mowing Park 2", Code = "JobLawnMowing1b"},
		{Name = "Mowing Park 3", Code = "JobLawnMowing1c"},
		{Name = "Mowing House 1", Code = "JobLawnMowing2a"},
		{Name = "Mowing House 2", Code = "JobLawnMowing2b"},
		{Name = "Mowing House 3", Code = "JobLawnMowing2c"},
		
		{Name = "- CARNIVAL - "},
		{Name = "Roller Coaster", Code = "Coaster"},
		{Name = "Squid", Code = "Squid"},
		{Name = "Ferris Wheel", Code = "FerrisWheel"},
		{Name = "High Striker", Code = "MGCarniStriker"},
		{Name = "Splish Splash", Code = "MGDunkTank"},
		{Name = "Shooting Gallery", Code = "MGShooting"},
		{Name = "Baseball Toss", Code = "MGBaseballToss"},
		
		{Name = "- BET -"},
		{Name = "Keep Ups", Code = "MGHackySack"},
		{Name = "Penalty Shots", Code = "SoccerPen"},
		
		{Name = "- BOXING -"},
		{Name = "Boxing Chad", Code = "2_R11_Chad"},
		{Name = "Boxing Bryce", Code = "2_R11_Bryce"},
		{Name = "Boxing Justin", Code = "2_R11_Justin"},
		{Name = "Boxing Parker", Code = "2_R11_Parker"},
		{Name = "Boxing (Random)", Code = "2_R11_Random"},
		
		{Name = "- ARCADE -"},
		{Name = "Monkey Fling", Code = "MGFling"},
		{Name = "Flying Squirrel", Code = "MGFend"},
		{Name = "ConSumo", Code = "TrainASumo"},
		{Name = "Future Street Race 2055", Code = "ArcadeRace"},
		{Name = "Future Street Race 3D", Code = "ArcadeRace3D"},
		
		{Name = "- UNFINISHED MINIGAME -"},
		{Name = "Lockpicking", Code = "Lockpick", Warn = true},
		{Name = "BMX Rumble", Code = "BMXRUMBLE", Warn = true},
		{Name = "Demonstration", Code = "ArcadeGame", Warn = true},
		{Name = "Lunar Lander", Code = "LunarLander", Warn = true},
		{Name = "Missile Command", Code = "MissileCommand", Warn = true},
		{Name = "Desert Fighter", Code = "AG_SO", Warn = true},
		{Name = "Grottos and Gremlins", Code = "MGGandG", Warn = true},
		{Name = "Smash TV", Code = "MGSmash", Warn = true},
		{Name = "Nuclear Rain", Code = "MGNuclearRain", Warn = true},
		
		{Name = "- MULTIPLAYER MINIGAME -"},
		{Name = "Nut Shots", Code = 230, Warn = true},
		{Name = "ConSumo", Code = 231, Warn = true},
		{Name = "Lawn Mowing", Code = 236, Warn = true},
		{Name = "Shooting Gallery", Code = 237, Warn = true},
	}},
	{Name = "Cutscene", Option = 1, Func = function(Selects)
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
				if GetCutsceneRunning() ~= 0 then
					SetQueuedMessage('DOUBLE DRAMA DENIED', "You're still watching one cutscene. Chill before rolling the next one.", 4)
				else
					local Exception = ({
						["1-1-02"] 		= {5, -705.90, 227.98, 32, 120000},
						["1-02"] 		= {5, -705.90, 227.98, 32, 60000},
						["1-02C"] 		= {0, 187.94, 151.41, 7, 25000},
						["candidate"] 	= {2, -672.17, 307.40, 6, 81833.32},
						["1-09b"] 		= {19, -618.73, 309.03, 77.2, 20000},
						["1-08b"] 		= {0, 187.94, 151.41, 7, 15000},
						["1-1"] 		= {14, -501.58, 324.11, 7, 60000},
						["2-04B"] 		= {0, 225.64, 247.10, 7, 30000},
						["2-09A"] 		= {6, -709.74, 312.35, 33.3, 81733},
						["6-B2"] 		= {6, -709.74, 312.35, 33.3, 81733},
						["weedkiller"] 	= {6, -709.74, 312.35, 33.3, 81733},
						["3-R05"] 		= {4, -595.01, 325.74, 36, 66833},
						["4-B1C2"] 		= {40, -696.61, 61.63, 23, 15000},
						["4-S11"] 		= {14, -501.58, 324.11, 7, 60000},
						["CS_COUNTER"] 	= {14, -501.58, 324.11, 7, 59166.66},
						["FX-TEST"] 	= {2, -631.53, -278.09, 6, 33333},
						["TEST"] 		= {2, -631.53, -278.09, 6, 33333},
					})[Sub.Data[Select].Code]
					
					CreateThread(function(Exception, Code)
						if Exception then
							local A, X, Y, Z = AreaGetVisible(), PlayerGetPosXYZ()
							CameraFade(1000, 0)
							Wait(1001)
							
							AreaTransitionXYZ(Exception[1], Exception[2], Exception[3], Exception[4], true)
							SoundPause(Code)
							LoadCutscene(Code)
							CutSceneSetActionNode(Code)
							LoadCutsceneSound('1-01')
							CameraDefaultFOV()
							
							repeat
								Wait(0)
							until IsCutsceneLoaded()
							
							StartCutscene()
							CameraFade(1000, 1)
							Wait(1000)
							
							repeat
								Wait(0)
							until GetCutsceneTime() > Exception[5] or IsButtonBeingPressed(7, 0)
							
							SoundFadeWithCamera(true)
							MusicFadeWithCamera(true)
							CameraFade(1000, 0)
							Wait(1001)
							
							StopCutscene()
							CutsceneFadeWithCamera(false)
							CameraSetWidescreen(false)
							AreaDisableCameraControlForTransition(true)
							SoundStopStream()
							AreaRemoveExtraScene()
							AreaTransitionXYZ(A, X, Y, Z, true)
							
							AreaDisableCameraControlForTransition(false)
							CameraReturnToPlayer()
							SoundContinue()
							Wait(500)
							CameraFade(1000, 1)
						else
							PlayCutsceneWithLoad(Code)
						end
					end, Exception, Sub.Data[Select].Code)
					
					while GetCutsceneRunning() == 0 do
						Wait(0)
					end
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- CHAPTER ONE -"},
		{Name = "Original Intro", Code = "1-01"}, 
		{Name = "Welcome To The Bullworth", Code = "1-1-1"}, 
		{Name = "Principal Intro", Code = "1-1-2"}, 
		{Name = "Meet Gary", Code = "1-02B"}, 
		{Name = "Meet Peter", Code = "1-02E"}, 
		{Name = "This Is Your School", Code = "1-02D"}, 
		{Name = "The Setup", Code = "1-03"}, 
		{Name = "The Slingshot", Code = "1-04"}, 
		{Name = "Save Algie", Code = "1-05"}, 
		{Name = "A Little Help", Code = "1-06"}, 
		{Name = "Meet Grant", Code = "1-06B"}, 
		{Name = "Defend Bucky", Code = "1-07"}, 
		{Name = "That Bitch", Code = "1-08"}, 
		{Name = "The Candidate", Code = "1-09"},
		{Name = "Halloween", Code = "1-11"}, 
		{Name = "Help Gary", Code = "1-10"},
		{Name = "Russell In The Hole", Code = "1-B"}, 
		{Name = "Russell's Wins", Code = "1-BB"}, 
		{Name = "Chapter 1 End", Code = "1-BC"}, 
		{Name = "The Diary", Code = "1-G1"}, 
		{Name = "Hattrick vs Galloway", Code = "1-S01"}, 
		
		{Name = "- CHAPTER TWO -"},
		{Name = "Chapter 2 Intro", Code = "2-0"}, 
		{Name = "Last Minute Shoping", Code = "2-01"}, 
		{Name = "Klepto Comic", Code = "2-02"}, 
		{Name = "The Eggs", Code = "2-03"}, 
		{Name = "Race The Vale", Code = "2-04"}, 
		{Name = "Tad House", Code = "2-05"}, 
		{Name = "Movie Tickets", Code = "2-06"}, 
		{Name = "Carnival Date", Code = "2-G2"},
		{Name = "Beach Rumble", Code = "2-07"}, 
		{Name = "Weed Killer", Code = "2-08"}, 
		{Name = "Boxing Challenge", Code = "2-09"}, 
		{Name = "Challenge Accepted", Code = "2-09B"}, 
		{Name = "Dishonorable Fight", Code = "2-B"}, 
		{Name = "Chapter 2 End", Code = "2-BB"}, 
		{Name = "Glass House", Code = "2-S02"}, 
		{Name = "Character Sheets", Code = "2-S04"}, 
		{Name = "Cook's Crush", Code = "2-S05"},
		{Name = "Panty Raid", Code = "2-S06"}, 
		{Name = "Small Offences", Code = "2-S07"}, 
		
		{Name = "- CHAPTER THREE -"},
		{Name = "Chapter 3 Intro", Code = "3-0"}, 
		{Name = "Balls of Snow", Code = "3-01AA"}, 
		{Name = "Balls of Snow End", Code = "3-01AB"}, 
		{Name = "Miracle on Bullworth St", Code = "3-01BA"}, 
		{Name = "Nutcrackin'", Code = "3-01CA"}, 
		{Name = "The Christmas Pageant", Code = "3-01CB"}, 
		{Name = "Rudy the Red Nosed Santa", Code = "3-01DA"}, 
		{Name = "Rudy's Got the Items", Code = "3-01DB"}, 
		{Name = "Rudy's Final Scene", Code = "3-01DC"}, 
		{Name = "Jealous Johnny", Code = "3-01"}, 
		{Name = "Bait", Code = "3-02"}, 
		{Name = "Unused Rendezvous", Code = "3-03"}, 
		{Name = "Wrong Part of Town", Code = "3-04"}, 
		{Name = "Lola's Sweet Talk", Code = "3-04B"}, 
		{Name = "Lola Race", Code = "3-G3"}, 
		{Name = "The Tenements", Code = "3-05"}, 
		{Name = "The Rumble", Code = "3-06"}, 
		{Name = "Fighting With Johnny Vincent", Code = "3-B"}, 
		{Name = "Fall From Bike", Code = "3-BB"}, 
		{Name = "Unused Johnny Magnetized", Code = "3-BC"}, 
		{Name = "Chapter 3 End", Code = "3-BD"}, 
		{Name = "Discreet Deliveries", Code = "3-R05A"}, 
		{Name = "Discreet Deliveries End", Code = "3-R05B"}, 
		{Name = "The Collector", Code = "3-R07"}, 
		{Name = "Cheating Time", Code = "3-S03"}, 
		{Name = "Mailbox Armageddon", Code = "3-S08"}, 
		{Name = "Tagging", Code = "3-S10"}, 
		{Name = "Galloway Away", Code = "3-S11"}, 
		{Name = "Galloway in Cell", Code = "3-S11C"}, 
		
		{Name = "- CHAPTER FOUR -"},
		{Name = "Chapter 4 Intro", Code = "4-0"}, 
		{Name = "Stronghold Assault", Code = "4-02"},
		{Name = "Nerd Boss Fight", Code = "4-B1"}, 
		{Name = "Unused Transition 1", Code = "4-B1B"}, 
		{Name = "Unused Transition 2", Code = "4-B1C"}, 
		{Name = "Earnest Lose", Code = "4-B1D"}, 
		{Name = "Paparazi", Code = "4-01"}, 
		{Name = "Defender Of Castle", Code = "4-03"}, 
		{Name = "Funhouse Fun", Code = "4-04"}, 
		{Name = "Nice Outfit", Code = "4-05"}, 
		{Name = "The Big Game", Code = "4-06"}, 
		{Name = "Jock Boss Fight", Code = "4-B2"}, 
		{Name = "Chapter 4 End", Code = "4-B2B"}, 
		{Name = "Discretion Assured", Code = "4-G4"}, 
		{Name = "Here's to you Ms.Phillips", Code = "4-S12"}, 
		{Name = "Galloway's Date", Code = "4-S12B"}, 
		
		{Name = "- CHAPTER FIVE -"},
		{Name = "Chapter 5 Intro", Code = "5-0"}, 
		{Name = "Making a Mark", Code = "5-09"}, 
		{Name = "Petey Warn", Code = "5-09B"}, 
		{Name = "Rats in the Library", Code = "5-01"}, 
		{Name = "Preppies Vandalized", Code = "5-02"}, 
		{Name = "Prep Distrust", Code = "5-02B"}, 
		{Name = "Finding Johnny Vincent", Code = "5-03"}, 
		{Name = "The Gym is Burning", Code = "5-04"}, 
		{Name = "Revenge On Mr. Burton", Code = "5-05"}, 
		{Name = "Drenched In Poop", Code = "5-05B"}, 
		{Name = "Expelled", Code = "6-0"}, 
		{Name = "Busting In Part 1", Code = "5-06"}, 
		{Name = "Unused Jimmy Plan", Code = "5-07"}, 
		{Name = "Unused Chem Scene", Code = "5-B"}, 
		{Name = "Edgar Lose", Code = "5-BC"}, 
		{Name = "Smash It Up", Code = "5-G5"}, 
		{Name = "Complete Mayhem", Code = "6-02"}, 
		{Name = "School's Front", Code = "6-02B"}, 
		{Name = "Final Showdown 1", Code = "6-B"}, 
		{Name = "Final Showdown 2", Code = "6-BB"}, 
		{Name = "Final Showdown End", Code = "6-BC"},
		
		{Name = "- PLACEHOLDER -"},
		{Name = "Help Gary", Code = "1-1"},
		{Name = "Weed Killer V1", Code = "2-09A"},
		{Name = "Weed Killer V2", Code = "6-B2"},
		{Name = "Making a Mark", Code = "CS_COUNTER"},
		{Name = "Empty Cutscene 1", Code = "FX-TEST"},
		{Name = "Empty Cutscene 2", Code = "TEST"},
	}},
	{Name = "Emergency Control", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		local GetHeader = function(Select)
			while not IsMenuHeader(Sub.Data[Select].Name) do
				Select = Select - 1
			end
			return TrimHeader(Sub.Data[Select].Name)
		end
		
		SetQueuedMessage('HANDLE WITH CARE', "These features aren't toys. Use them only when things truly go sideways.", 4)
		
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				Sub.Data[Select].Func()
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- CURRENT MISSION -"},
		{Name = "Mark as Completed", Func = function()
			if not MissionActive() or MinigameIsShowingCompletion() then
				return
			end
			CreateThread(function()
				SoundPlayMissionEndMusic(true, 9)
				MinigameSetCompletion('M_PASS', true, 0)
				
				while MinigameIsShowingCompletion() do
					Wait(0)
				end
				MissionSucceed(false, false, false)
			end)
		end},
		{Name = "Mark as Failed", Func = function()
			if not MissionActive() or MinigameIsShowingCompletion() then
				return
			end
			CreateThread(function()
				SoundPlayMissionEndMusic(false, 9)
				MinigameSetCompletion('M_FAIL', false, 0)
				
				while MinigameIsShowingCompletion() do
					Wait(0)
				end
				MissionFail(false, false, false)
			end)
		end},
		{Name = "Force Inactive", Func = function()
			if not MissionActive() or MinigameIsShowingCompletion() then
				return
			end
			SetMissionActive(-1)
		end},
		
		{Name = "- CURRENT MINIGAME -"},
		{Name = "Mark as Inactive", Func = function()
			if not MinigameIsActive() then
				return
			end
			CreateThread(function()
				ReplaceFunction('MinigameIsActive', function()
					return false
				end)
				
				while MissionActive() do
					Wait(0)
				end
				ReplaceFunction('MinigameIsActive', nil)
			end)
		end},
		{Name = "Force Inactive", Func = function()
			if not MinigameIsActive() or not MissionActive() then
				return
			end
			SetMinigameActive(-1)
		end},
		
		{Name = "- CURRENT CUTSCENE -"},
		{Name = "Force Timeout", Func = function()
			if GetCutsceneRunning() == 0 then
				return
			end
			CreateThread(function()
				ReplaceFunction('GetCutsceneTime', function()
					return 999999
				end)
				
				while GetCutsceneRunning() ~= 0 do
					Wait(0)
				end
				ReplaceFunction('GetCutsceneTime', nil)
			end)
		end},
		{Name = "Force Stop", Func = function()
			if GetCutsceneRunning() == 0 then
				return
			end
			StopCutscene()
		end},
		
		{Name = "- CURRENT PROGRESS -"},
		{Name = "Force Open Save Book", Func = function()
			local Mission = GetCurrentMissionIndex()
			local Points = PlayerGetPunishmentPoints()
			
			if MissionActive() then
				if Mission == -1 then
					SetQueuedMessage("UNKNOWN MISSION", "Looks like the current mission is not recognized. You might want to contact the dev on the mod's NexusMods page.", 4)
					return
				end
				SetMissionActive(-1)
			end
			PlayerSetPunishmentPoints(0)
			PedSetActionNode(gPlayer, '/Global/AnimSave/PedPropsActions/Save', 'Act/Props/AnimSave.act')
			PlayerSetPunishmentPoints(Points)
			if Mission then
				SetMissionActive(Mission)
			end
		end},
	}},
}})