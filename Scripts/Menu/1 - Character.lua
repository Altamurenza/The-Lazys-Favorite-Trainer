-- CHARACTER.LUA
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
	{Name = "Model", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- MODEL: "..string.upper(Selected.Name).." -"},
					{Name = "Change Player Model", Func = SetModel, Args = {true, Selected.Model[1], {Selected.Tree[1], Selected.Tree[2]}}},
					{Name = "Change NPC Model", Func = SetModel, Args = {false, Selected.Model[1], {Selected.Tree[1], Selected.Tree[2]}}},
					{Name = "Create NPC", Func = CreatePed, Args = {Selected.Index, 1}},
					{Name = "Create NPC as Ally", Func = CreatePed, Args = {Selected.Index, 2}},
					{Name = "Create NPC as Enemy", Func = CreatePed, Args = {Selected.Index, 0}}
				}
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Table[Select].Func(unpack(Table[Select].Args))
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
		{Name = "- PLAYER -"},
		{Index = 0, Model = {"player", "player"}, Sex = 0, Size = "Medium", Faction = "PLAYER1", Stat = "STAT_PLAYER", Spawn = -1, Tree = {"/Global/Player", "Act/Player.act"}, Name = "Original"},
		{Index = 98, Model = {"Player_OWres", "Player_Owres"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_PLAYER", Spawn = -1, Tree = {"/Global/Player", "Act/Player.act"}, Name = "Wrestling"},
		{Index = 88, Model = {"Player_Mascot", "Player_Mascot_W"}, Sex = 0, Size = "Medium", Faction = "JOCK", Stat = "STAT_J_MASCOT", Spawn = -1, Tree = {"/Global/Player", "Act/Anim/Player.act"}, Name = "Mascot"},
		
		{Name = "- BULLY -"},
		{Index = 75, Model = {"DOlead_Russell", "DOlead_Russell_W"}, Sex = 0, Size = "Huge", Faction = "BULLY", Stat = "STAT_B_RUSSELL_A", Spawn = -1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Russell"},
		{Index = 85, Model = {"GN_Bully03", "GN_Bully03_W"}, Sex = 0, Size = "Large", Faction = "BULLY", Stat = "STAT_B_STRIKER_B", Spawn = 1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Trent"},
		{Index = 99, Model = {"GN_Bully02", "GN_Bully02_W"}, Sex = 0, Size = "Medium", Faction = "BULLY", Stat = "STAT_B_STRIKER_A", Spawn = 1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Davis"},
		{Index = 102, Model = {"GN_Bully01", "GN_Bully01_W"}, Sex = 0, Size = "Large", Faction = "BULLY", Stat = "STAT_B_STRIKER_B", Spawn = 1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Troy"},
		{Index = 145, Model = {"GN_Bully04", "GN_Bully04_W"}, Sex = 0, Size = "Large", Faction = "BULLY", Stat = "STAT_B_STRIKER_B", Spawn = 1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Ethan"},
		{Index = 146, Model = {"GN_Bully05", "GN_Bully05_W"}, Sex = 0, Size = "Medium", Faction = "BULLY", Stat = "STAT_B_STRIKER_A", Spawn = 1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Wade"},
		{Index = 147, Model = {"GN_Bully06", "GN_Bully06_W"}, Sex = 0, Size = "Large", Faction = "BULLY", Stat = "STAT_B_STRIKER_B", Spawn = 1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Tom"},
		
		{Name = "- PREP -"},
		{Index = 37, Model = {"PRlead_Darby", "PRlead_Darby_W"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Darby"},
		{Index = 30, Model = {"PRH1_Gord", "PRH1_Gord_W"}, Sex = 0, Size = "Medium", Faction = "PREPPY", Stat = "STAT_P_STRIKER_A", Spawn = 1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Gord"},
		{Index = 31, Model = {"PRH1a_Tad", "PRH1a_Tad_W"}, Sex = 0, Size = "Medium", Faction = "PREPPY", Stat = "STAT_P_STRIKER_A", Spawn = 1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Tad"},
		{Index = 32, Model = {"PRH2a_Chad", "PRH2_Chad_W"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_GRAPPLER_A", Spawn = 1, Tree = {"/Global/P_Grappler_A", "Act/Anim/P_Grappler_A.act"}, Name = "Chad"},
		{Index = 33, Model = {"PR2nd_Bif", "PR2nd_Bif_W"}, Sex = 0, Size = "Huge", Faction = "PREPPY", Stat = "STAT_P_BOXING_Bif", Spawn = 1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Bif"},
		{Index = 34, Model = {"PRH3_Justin", "PRH3_Justin_W"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_STRIKER_B", Spawn = 1, Tree = {"/Global/P_Striker_B", "Act/Anim/P_Striker_B.act"}, Name = "Justin"},
		{Index = 40, Model = {"PRH3a_Parker", "PRH3a_Parker_W"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_STRIKER_B", Spawn = 1, Tree = {"/Global/P_Striker_B", "Act/Anim/P_Striker_B.act"}, Name = "Parker"},
		{Index = 35, Model = {"PRH2_Bryce", "PRH2_Bryce_W"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_GRAPPLER_A", Spawn = 1, Tree = {"/Global/P_Grappler_A", "Act/Anim/P_Grappler_A.act"}, Name = "Bryce"},
		{Index = 38, Model = {"PRGirl_Pinky", "PRGirl_Pinky_W"}, Sex = 1, Size = "Medium", Faction = "PREPPY", Stat = "STAT_GS_FEMALE_A", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Pinky"},
		
		{Name = "- GREASER -"},
		{Index = 23, Model = {"GRlead_Johnny", "GRlead_Johnny_W"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_JOHNNY", Spawn = -1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Johnny"},
		{Index = 21, Model = {"GR2nd_Peanut", "GR2nd_Peanut_W"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_STRIKER_A", Spawn = 1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Peanut"},
		{Index = 22, Model = {"GRH2A_Hal", "GRH2A_Hal"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_GRAPPLER_A", Spawn = 1, Tree = {"/Global/G_Grappler_A", "Act/Anim/G_Grappler_A.act"}, Name = "Hal"},
		{Index = 24, Model = {"GRH1_Lefty", "GRH1_Lefty_W"}, Sex = 0, Size = "Medium", Faction = "GREASER", Stat = "STAT_G_MELEE_A", Spawn = 1, Tree = {"/Global/G_Melee_A", "Act/Anim/G_Melee_A.act"}, Name = "Lefty"},
		{Index = 26, Model = {"GRH3_Lucky", "GRH3_Lucky_W"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_STRIKER_A", Spawn = 1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Lucky"},
		{Index = 27, Model = {"GRH1a_Vance", "GRH1a_Vance"}, Sex = 0, Size = "Medium", Faction = "GREASER", Stat = "STAT_G_MELEE_A", Spawn = 1, Tree = {"/Global/G_Melee_A", "Act/Anim/G_Melee_A.act"}, Name = "Vance"},
		{Index = 28, Model = {"GRH3a_Ricky", "GRH3a_Ricky_W"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_STRIKER_A", Spawn = 1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Ricky"},
		{Index = 29, Model = {"GRH2_Norton", "GRH2_Norton"}, Sex = 0, Size = "Huge", Faction = "GREASER", Stat = "STAT_G_GRAPPLER_A", Spawn = 1, Tree = {"/Global/G_Grappler_A", "Act/Anim/G_Grappler_A.act"}, Name = "Norton"},
		{Index = 25, Model = {"GRGirl_Lola", "GRGirl_Lola_W"}, Sex = 1, Size = "Medium", Faction = "GREASER", Stat = "STAT_GS_FEMALE_A", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Lola"},
		
		{Name = "- NERD -"},
		{Index = 10, Model = {"NDLead_Earnest", "NDlead_Earnest_W"}, Sex = 0, Size = "Medium", Faction = "NERD", Stat = "STAT_N_EARNEST", Spawn = -1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Earnest"},
		{Index = 4, Model = {"NDH1a_Algernon", "NDH1a_Algernon_W"}, Sex = 0, Size = "Fat", Faction = "NERD", Stat = "STAT_N_STRIKER_B", Spawn = 1, Tree = {"/Global/N_Striker_B", "Act/Anim/N_Striker_B.act"}, Name = "Algernon"},
		{Index = 5, Model = {"NDH1_Fatty", "NDH1_Fatty_W"}, Sex = 0, Size = "Fat", Faction = "NERD", Stat = "STAT_N_STRIKER_A", Spawn = 1, Tree = {"/Global/N_Striker_A", "Act/Anim/N_Striker_A.act"}, Name = "Fatty"},
		{Index = 155, Model = {"NDH1_FattyChocolate", "NDH1_FattyChocolate"}, Sex = 0, Size = "Fat", Faction = "NERD", Stat = "STAT_N_STRIKER_A", Spawn = -1, Tree = {"/Global/N_Striker_A", "Act/Anim/N_Striker_A.act"}, Name = "Fatty (Choco)"},
		{Index = 6, Model = {"ND2nd_Melvin", "ND2nd_Melvin_W"}, Sex = 0, Size = "Fat", Faction = "NERD", Stat = "STAT_N_STRIKER_A", Spawn = 1, Tree = {"/Global/N_Striker_A", "Act/Anim/N_Striker_A.act"}, Name = "Melvin"},
		{Index = 7, Model = {"NDH2_Thad", "NDH2_Thad_W"}, Sex = 0, Size = "Large", Faction = "NERD", Stat = "STAT_N_MELEE_A", Spawn = 1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Thad"},
		{Index = 8, Model = {"NDH3_Bucky", "NDH3_Bucky_W"}, Sex = 0, Size = "Medium", Faction = "NERD", Stat = "STAT_N_RANGED_A", Spawn = 1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Bucky"},
		{Index = 11, Model = {"NDH3a_Donald", "NDH3a_Donald_W"}, Sex = 0, Size = "Medium", Faction = "NERD", Stat = "STAT_N_RANGED_A", Spawn = 1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Donald"},
		{Index = 9, Model = {"NDH2a_Cornelius", "NDH2a_Cornelius_W"}, Sex = 0, Size = "Large", Faction = "NERD", Stat = "STAT_N_MELEE_A", Spawn = 1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Cornelius"},
		{Index = 3, Model = {"NDGirl_Beatrice", "NDGirl_Beatrice_W"}, Sex = 1, Size = "Medium", Faction = "NERD", Stat = "STAT_GS_FEMALE_A", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Beatrice"},
		
		{Name = "- JOCK -"},
		{Index = 19, Model = {"JKlead_Ted", "JKlead_Ted_W"}, Sex = 0, Size = "Large", Faction = "JOCK", Stat = "STAT_J_TED", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Ted"},
		{Index = 12, Model = {"JKH1_Damon", "JKH1_Damon_W"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_DAMON", Spawn = 1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Damon"},
		{Index = 13, Model = {"JKH1a_Kirby", "JKH1a_KirbyWinter"}, Sex = 0, Size = "Medium", Faction = "JOCK", Stat = "STAT_J_STRIKER_A", Spawn = 1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Kirby"},
		{Index = 15, Model = {"JKH2_Dan", "JKH2_DanWinter"}, Sex = 0, Size = "Medium", Faction = "JOCK", Stat = "STAT_J_STRIKER_A", Spawn = 1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Dan"},
		{Index = 16, Model = {"JKH2a_Luis", "JKH2a_Luis_W"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_GRAPPLER_B", Spawn = 1, Tree = {"/Global/J_Grappler_A", "Act/Anim/J_Grappler_A.act"}, Name = "Luis"},
		{Index = 17, Model = {"JKH3_Casey", "JKH3_Casey_W"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_MELEE_A", Spawn = 1, Tree = {"/Global/J_Melee_A", "Act/Anim/J_Melee_A.act"}, Name = "Casey"},
		{Index = 18, Model = {"JKH3a_Bo", "JKH3a_Bo_W"}, Sex = 0, Size = "Large", Faction = "JOCK", Stat = "STAT_J_MELEE_A", Spawn = 1, Tree = {"/Global/J_Melee_A", "Act/Anim/J_Melee_A.act"}, Name = "Bo"},
		{Index = 20, Model = {"JK2nd_Juri", "JK2nd_Juri_W"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_GRAPPLER_A", Spawn = 1, Tree = {"/Global/J_Grappler_A", "Act/Anim/J_Grappler_A.act"}, Name = "Juri"},
		{Index = 14, Model = {"JKGirl_Mandy", "JKGirl_Mandy_W"}, Sex = 1, Size = "Medium", Faction = "JOCK", Stat = "STAT_GS_FEMALE_A", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Mandy"},
		
		{Name = "- DROPOUT -"},
		{Index = 91, Model = {"DOLead_Edgar", "DOLead_Edgar_W"}, Sex = 0, Size = "Large", Faction = "DROPOUT", Stat = "STAT_DO_EDGAR", Spawn = -1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Edgar"},
		{Index = 41, Model = {"DOH2_Jerry", "DOH2_Jerry_W"}, Sex = 0, Size = "Large", Faction = "DROPOUT", Stat = "STAT_DO_GRAPPLER_A", Spawn = 1, Tree = {"/Global/DO_Grappler_A", "Act/Anim/DO_Grappler_A.act"}, Name = "Jerry"},
		{Index = 42, Model = {"DOH1a_Otto", "DOH1a_Otto_W"}, Sex = 0, Size = "Medium", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = 1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Otto"},
		{Index = 43, Model = {"DOH2a_Leon", "DOH2a_Leon"}, Sex = 0, Size = "Huge", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = 1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Leon"},
		{Index = 44, Model = {"DOH1_Duncan", "DOH1_Duncan_W"}, Sex = 0, Size = "Medium", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = 1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Duncan"},
		{Index = 45, Model = {"DOH3_Henry", "DOH3_Henry_W"}, Sex = 0, Size = "Large", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = 1, Tree = {"/Global/DO_Grappler_A", "Act/Anim/DO_Grappler_A.act"}, Name = "Henry"},
		{Index = 46, Model = {"DOH3a_Gurney", "DOH3a_Gurney_W"}, Sex = 0, Size = "Huge", Faction = "DROPOUT", Stat = "STAT_DO_GRAPPLER_A", Spawn = 1, Tree = {"/Global/DO_Grappler_A", "Act/Anim/DO_Grappler_A.act"}, Name = "Gurney"},
		{Index = 47, Model = {"DO2nd_Omar", "DO2nd_Omar"}, Sex = 0, Size = "Huge", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = 1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Omar"},
		{Index = 48, Model = {"DOGirl_Zoe", "DOGirl_Zoe_W"}, Sex = 1, Size = "Medium", Faction = "DROPOUT", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Zoe"},
		
		{Name = "- MALE STUDENT -"},
		{Index = 130, Model = {"Nemesis_Gary", "Nemesis_Gary_W"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_GARY", Spawn = -1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Gary"},
		{Index = 134, Model = {"Peter", "Peter_W"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Peter"},
		{Index = 70, Model = {"GN_Greekboy", "GN_Greekboy_W"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_TATTLER", Spawn = 1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Constantinos"},
		{Index = 139, Model = {"GN_WhiteBoy", "GN_WhiteBoy_W"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = 1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Gordon"},
		{Index = 71, Model = {"GN_Fatboy", "GN_Fatboy_W"}, Sex = 0, Size = "Fat", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = 1, Tree = {"/Global/GS_Fat_A", "Act/Anim/GS_Fat_A.act"}, Name = "Ray"},
		{Index = 72, Model = {"GN_Boy01", "GN_Boy01_W"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = 1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Ivan"},
		{Index = 73, Model = {"GN_Boy02", "GN_Boy02_W"}, Sex = 0, Size = "Large", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = 1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Trevor"},
		{Index = 142, Model = {"GN_SkinnyBboy", "GN_SkinnyBboy_W"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = 1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Lance"},
		{Index = 66, Model = {"GN_Littleblkboy", "GN_Littleblkboy_W"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_MALE_SMKID", Spawn = 1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Sheldon"},
		{Index = 69, Model = {"GN_Hispanicboy", "GN_Hispanicboy_W"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_MALE_SMKID", Spawn = 1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Pedro"},
		
		{Name = "- FEMALE STUDENT -"},
		{Index = 67, Model = {"GN_SexyGirl", "GN_SexyGirl_W"}, Sex = 1, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_S", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Christy"},
		{Index = 2, Model = {"DOgirl_Zoe_EG", "DOgirl_Zoe_EG"}, Sex = 1, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Zoe"},
		{Index = 39, Model = {"GN_Asiangirl", "GN_Asiangirl_W"}, Sex = 1, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_A", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Angie"},
		{Index = 74, Model = {"GN_Fatgirl", "GN_Fatgirl_W"}, Sex = 1, Size = "Fat", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_A", Spawn = 1, Tree = {"/Global/GS_Fat_A", "Act/Anim/GS_Fat_A.act"}, Name = "Eunice"},
		{Index = 68, Model = {"GN_Littleblkgirl", "GN_Littleblkgirl_W"}, Sex = 1, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_SMKID", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Gloria"},
		{Index = 137, Model = {"GN_LittleGirl_2", "GN_LittleGirl_2_W"}, Sex = 1, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_SMKID", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Melody"},
		{Index = 138, Model = {"GN_LittleGirl_3", "GN_LittleGirl_3_W"}, Sex = 1, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_SMKID", Spawn = 1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Karen"},
		
		{Name = "- PREFECT -"},
		{Index = 52, Model = {"PFlead_Karl", "PFlead_Karl_W"}, Sex = 0, Size = "Large", Faction = "PREFECT", Stat = "STAT_PF_BASIC_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Karl"},
		{Index = 49, Model = {"PF2nd_Max", "PF2nd_Max_W"}, Sex = 0, Size = "Huge", Faction = "PREFECT", Stat = "STAT_PF_BASIC_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Max"},
		{Index = 50, Model = {"PFH1_Seth", "PFH1_Seth_W"}, Sex = 0, Size = "Huge", Faction = "PREFECT", Stat = "STAT_PF_BASIC_S", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Seth"},
		{Index = 51, Model = {"PFH2_Edward", "PFH2_Edward_W"}, Sex = 0, Size = "Huge", Faction = "PREFECT", Stat = "STAT_PF_BASIC_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Edward"},
		
		{Name = "- COP -"},
		{Index = 83, Model = {"TO_Cop", "TO_Cop"}, Sex = 0, Size = "Huge", Faction = "COP", Stat = "STAT_LE_OFFICER_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Morrison"},
		{Index = 97, Model = {"TO_Cop2", "TO_Cop2"}, Sex = 0, Size = "Huge", Faction = "COP", Stat = "STAT_LE_OFFICER_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Williams"},
		{Index = 234, Model = {"TO_Cop3", "TO_Cop3"}, Sex = 0, Size = "Huge", Faction = "COP", Stat = "STAT_LE_OFFICER_A", Spawn = 0, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Monson"},
		{Index = 238, Model = {"TO_Cop4", "TO_Cop4"}, Sex = 0, Size = "Huge", Faction = "COP", Stat = "STAT_LE_OFFICER_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Ivanovich"},
		
		{Name = "- ORDERLY -"},
		{Index = 53, Model = {"TO_Orderly", "TO_Orderly_W"}, Sex = 0, Size = "Huge", Faction = "PREFECT", Stat = "STAT_LE_ORDERLY_A", Spawn = -1, Tree = {"/Global/LE_Orderly_A", "Act/Anim/LE_Orderly_A.act"}, Name = "Theo"},
		{Index = 158, Model = {"TO_Orderly2", "TO_Orderly2_W"}, Sex = 0, Size = "Huge", Faction = "PREFECT", Stat = "STAT_LE_ORDERLY_A", Spawn = -1, Tree = {"/Global/LE_Orderly_A", "Act/Anim/LE_Orderly_A.act"}, Name = "Gregory"},
		
		{Name = "- MALE TEACHER -"},
		{Index = 65, Model = {"TE_Principal", "TE_Principal_W"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = -1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Crabblesnitch"},
		{Index = 55, Model = {"TE_GymTeacher", "TE_GymTeacher_W"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Burton"},
		{Index = 229, Model = {"TE_Gym_Incog", "TE_Gym_Incog_W"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = -1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Burton (Incognito)"},
		{Index = 57, Model = {"TE_English", "TE_English_W"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Galloway"},
		{Index = 61, Model = {"TE_MathTeacher", "TE_MathTeacher_W"}, Sex = 0, Size = "Fat", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Huntingdon"},
		{Index = 106, Model = {"TE_Chemistry", "TE_Chemistry_W"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Watts"},
		{Index = 64, Model = {"TE_Biology", "TE_Biology_W"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Slawter"},
		{Index = 248, Model = {"TE_Geography", "TE_Geography"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = -1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Matthews"},
		{Index = 151, Model = {"TE_History", "TE_History"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = 1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Wiggins"},
		{Index = 126, Model = {"TE_Autoshop", "TE_Autoshop_W"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = -1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Neil"},
		{Index = 56, Model = {"TE_Janitor", "TE_Janitor"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_TE_JANITOR", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Luntz"},
		
		{Name = "- FEMALE TEACHER -"},
		{Index = 59, Model = {"TE_Secretary", "TE_Secretary"}, Sex = 1, Size = "Large", Faction = "TEACHER", Stat = "STAT_TE_FEMALE_A", Spawn = -1, Tree = {"/Global/TE_Female_A", "Act/Anim/TE_Female_A"}, Name = "Danvers"},
		{Index = 63, Model = {"TE_Art", "TE_Art"}, Sex = 1, Size = "Large", Faction = "TEACHER", Stat = "STAT_TE_FEMALE_A", Spawn = 1, Tree = {"/Global/TE_Female_A", "Act/Anim/TE_Female_A.act"}, Name = "Phillips"},
		{Index = 58, Model = {"TE_Cafeteria", "TE_Cafeteria_W"}, Sex = 1, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = -1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Edna"},
		{Index = 221, Model = {"TE_CafeMU_W", "TE_CafeMU_W"}, Sex = 1, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = -1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Edna (Winter)"},
		{Index = 62, Model = {"TE_Librarian", "TE_Librarian_W"}, Sex = 1, Size = "Large", Faction = "TEACHER", Stat = "STAT_TE_FEMALE_A", Spawn = 1, Tree = {"/Global/TE_Female_A", "Act/Anim/TE_Female_A.act"}, Name = "Carvin"},
		{Index = 54, Model = {"TE_HallMonitor", "TE_Hallmonitor_W"}, Sex = 1, Size = "Large", Faction = "TEACHER", Stat = "STAT_TE_FEMALE_A", Spawn = 1, Tree = {"/Global/TE_Female_A", "Act/Anim/TE_Female_A.act"}, Name = "Peabody"},
		{Index = 60, Model = {"TE_Nurse", "TE_Nurse_W"}, Sex = 1, Size = "Large", Faction = "TEACHER", Stat = "STAT_TE_FEMALE_A", Spawn = 1, Tree = {"/Global/TE_Female_A", "Act/Anim/TE_Female_A"}, Name = "Mc Rae"},
		{Index = 249, Model = {"TE_Music", "TE_Music"}, Sex = 1, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_FEMALE_A", Spawn = -1, Tree = {"/Global/TE_Female_A", "Act/Anim/TE_Female_A.act"}, Name = "Peters"},
		
		{Name = "- MALE ADULT -"},
		{Index = 76, Model = {"TO_Business1", "TO_Business_01_W"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Bambillo"},
		{Index = 77, Model = {"TO_Business2", "TO_Business2_W"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Sullivan"},
		{Index = 100, Model = {"TO_RichM1", "TO_RichM1_W"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Brekindale"},
		{Index = 101, Model = {"TO_RichM2", "TO_RichM2_W"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Doolin"},
		{Index = 104, Model = {"TO_CSOwner_2", "TO_CSOwner_2"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Carmichael"},
		{Index = 105, Model = {"TO_CSOwner_3", "TO_CSOwner_3"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Nicky"},
		{Index = 114, Model = {"TO_Carny01", "TO_Carny01"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Dorsey"},
		{Index = 113, Model = {"TO_Carny02", "TO_Carny02_W"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Freeley"},
		{Index = 124, Model = {"TO_Associate", "TO_Associate"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Ian"},
		{Index = 108, Model = {"TO_MotelOwner", "TO_Motelowner_W"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Mihailovich"},
		{Index = 123, Model = {"TO_Industrial", "TO_Industrial_W"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Chuck"},
		{Index = 127, Model = {"TO_Mailman", "TO_Mailman_W"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Svenson"},
		{Index = 135, Model = {"TO_RichM3", "TO_RichM3_W"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Smith"},
		{Index = 144, Model = {"TO_Business3", "TO_Business_03_W"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Martin"},
		{Index = 148, Model = {"TO_Business4", "TO_Business4_W"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Ramirez"},
		{Index = 149, Model = {"TO_Business5", "TO_Business5_W"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Huntingdon"},
		{Index = 195, Model = {"TO_GN_Workman", "TO_GN_Workman"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Castillo"},
		{Index = 222, Model = {"TO_Millworker", "TO_Millworker"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "McInnis"},
		{Index = 223, Model = {"TO_Dockworker", "TO_Dockworker"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Buckingham"},
		{Index = 236, Model = {"TO_Construct01", "TO_Construct01"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "McInnis"},
		{Index = 237, Model = {"TO_Construct02", "TO_Construct02"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Chuck"},
		{Index = 87, Model = {"TO_Hobo", "TO_Hobo_W"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_HOBO", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Hobo"},
		{Index = 82, Model = {"TO_Fireman", "TO_Fireman"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "O'Rouke"},
		{Index = 116, Model = {"TO_Poorman2", "TO_Poorman2_W"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_A", Spawn = 2, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Osbourne"},
		{Index = 115, Model = {"TO_CarnyMidget", "TO_CarnyMidget_W"}, Sex = 0, Size = "Small", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Hector"},
		{Index = 157, Model = {"TO_Handy", "TO_Handy_W"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_OLD", Spawn = 2, Tree = {"/Global/CV_OLD", "Act/Anim/CV_OLD.act"}, Name = "Handy"},
		{Index = 131, Model = {"TO_Oldman2", "TO_Oldman2_W"}, Sex = 0, Size = "Large", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_OLD", Spawn = 2, Tree = {"/Global/CV_OLD", "Act/Anim/CV_OLD.act"}, Name = "Krakauer"},
		{Index = 183, Model = {"TO_NH_Res_01", "TO_NH_Res_01"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_OLD", Spawn = -1, Tree = {"/Global/CV_OLD", "Act/Anim/CV_OLD.act"}, Name = "Buba"},
		{Index = 184, Model = {"TO_NH_Res_02", "TO_NH_Res_02"}, Sex = 0, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_OLD", Spawn = -1, Tree = {"/Global/CV_OLD", "Act/Anim/CV_OLD.act"}, Name = "Gordon"},
		
		{Name = "- FEMALE ADULT -"},
		{Index = 78, Model = {"TO_BusinessW1", "TO_BusinessW1_W"}, Sex = 1, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = 2, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Kopke"},
		{Index = 79, Model = {"TO_BusinessW2", "TO_BusinessW2_W"}, Sex = 1, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = 2, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Rushinski"},
		{Index = 80, Model = {"TO_RichW1", "TO_RichW1_W"}, Sex = 1, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = 2, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Isaacs"},
		{Index = 81, Model = {"TO_RichW2", "TO_RichW2_W"}, Sex = 1, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = 2, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Bethany"},
		{Index = 143, Model = {"TO_Carnie_female", "TO_Carnie_fem_W"}, Sex = 1, Size = "Large", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = -1, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Crystal"},
		{Index = 140, Model = {"TO_FMidget", "TO_FMidget"}, Sex = 1, Size = "Small", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Brandy"},
		{Index = 107, Model = {"TO_Poorwoman", "TO_Poorwoman_W"}, Sex = 1, Size = "Large", Faction = "SHOPKEEP", Stat = "STAT_CV_FEMALE_OLD", Spawn = 1, Tree = {"/Global/CV_OLD", "Act/Anim/CV_OLD.act"}, Name = "Abby"},
		{Index = 185, Model = {"TO_NH_Res_03", "TO_NH_Res_03"}, Sex = 1, Size = "Medium", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_OLD", Spawn = -1, Tree = {"/Global/CV_OLD", "Act/Anim/CV_OLD.act"}, Name = "Lisburn"},
		
		{Name = "- SHOPKEEPER -"},
		{Index = 84, Model = {"TO_Comic", "TO_Comic"}, Sex = 0, Size = "Fat", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Owens"},
		{Index = 86, Model = {"TO_Bikeowner", "TO_Bikeowner"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Tobias"},
		{Index = 89, Model = {"TO_GroceryOwner", "TO_GroceryOwner"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Oh"},
		{Index = 156, Model = {"TO_GroceryClerk", "TO_GroceryClerk"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Stan"},
		{Index = 103, Model = {"TO_FireOwner", "TO_FireOwner"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Nate"},
		{Index = 187, Model = {"TO_PunkBarber", "TO_PunkBarber"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Betty"},
		{Index = 132, Model = {"TO_BarberPoor", "TO_BarberPoor"}, Sex = 0, Size = "Large", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Moratti"},
		{Index = 120, Model = {"TO_BarberRich", "TO_BarberRich"}, Sex = 1, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = -1, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Maria"},
		{Index = 128, Model = {"TO_Tattooist", "TO_Tattooist"}, Sex = 0, Size = "Huge", Faction = "SHOPKEEP", Stat = "STAT_CV_MALE_A", Spawn = 1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Denny"},
		{Index = 152, Model = {"TO_Record", "TO_Record_W"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Floyd"},
		
		{Name = "- FREAKSHOW -"},
		{Index = 188, Model = {"FightingMidget_01", "FightingMidget_01"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_P_STRIKER_A", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Lighning"},
		{Index = 189, Model = {"FightingMidget_02", "FightingMidget_02"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_G_STRIKER_A", Spawn = -1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Zeke"},
		{Index = 190, Model = {"TO_Skeletonman", "TO_Skeletonman"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Alfred"},
		{Index = 191, Model = {"TO_Beardedwoman", "TO_Beardedwoman"}, Sex = 1, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = -1, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Paris"},
		{Index = 192, Model = {"TO_CarnieMermaid", "TO_CarnieMermaid"}, Sex = 1, Size = "Medium", Faction = "TOWNPERSON", Stat = "STAT_CV_FEMALE_A", Spawn = -1, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Courtney"},
		{Index = 193, Model = {"TO_Siamesetwin2", "TO_Siamesetwin2"}, Sex = 1, Size = "Medium", Faction = "TOWNPERSON", Stat = "STAT_TO_SIAMESE", Spawn = -1, Tree = {"/Global/CV_Female_A", "Act/Anim/CV_Female_A.act"}, Name = "Delilah"},
		{Index = 194, Model = {"TO_Paintedman", "TO_Paintedman"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Drew"},
		
		{Name = "- ASYLUM PATIENT -"},
		{Index = 125, Model = {"TO_Asylumpatient", "TO_Asylumpatient"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_DO_STRIKER_A", Spawn = -1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Fenwick"},
		{Index = 129, Model = {"TE_Assylum", "TE_Assylum"}, Sex = 0, Size = "Huge", Faction = "TEACHER", Stat = "STAT_TE_MALE_A", Spawn = -1, Tree = {"/Global/Authority", "Act/Anim/Authority.act"}, Name = "Galloway"},
		{Index = 150, Model = {"DO_Otto_asylum", "DO_Otto_asylum"}, Sex = 0, Size = "Medium", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = -1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Otto"},
		{Index = 153, Model = {"DO_Leon_Assylum", "DO_Leon_Assylum"}, Sex = 0, Size = "Huge", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = -1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Leon"},
		{Index = 154, Model = {"DO_Henry_Assylum", "DO_Henry_Assylum"}, Sex = 0, Size = "Large", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = -1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Henry"},
		
		{Name = "- FIT BOXER -"},
		{Index = 133, Model = {"PR2nd_Bif_OBOX", "PR2nd_Bif_OBOX"}, Sex = 0, Size = "Huge", Faction = "PREPPY", Stat = "STAT_P_BOXING_Bif", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Bif"},
		{Index = 36, Model = {"PRH2_Bryce_OBOX", "PRH2_Bryce_OBOX"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Bryce"},
		{Index = 117, Model = {"PRH2A_Chad_OBOX", "PRH2A_Chad_OBOX"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Chad", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Chad"},
		{Index = 118, Model = {"PRH3_Justin_OBOX", "PRH3_Justin_OBOX"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Justin", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Justin"},
		{Index = 119, Model = {"PRH3a_Parker_OBOX", "PRH3a_Parker_OBOX"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Parker", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Parker"},
		
		{Name = "- INJURED BOXER -"},
		{Index = 172, Model = {"PR2nd_Bif_OBOX_D1", "PR2nd_Bif_OBOX_D1"}, Sex = 0, Size = "Huge", Faction = "PREPPY", Stat = "STAT_P_BOXING_Bif", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Bif"},
		{Index = 239, Model = {"PRH2_Bryce_OBOX_D1", "PRH2_Bryce_OBOX_D1"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Bryce", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Bryce"},
		{Index = 241, Model = {"PRH2A_Chad_OBOX_D1", "PRH2A_Chad_OBOX_D1"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Chad", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Chad"},
		{Index = 244, Model = {"PRH3_Justin_OBOX_D1", "PRH3_Justin_OBOX_D1"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Justin", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Justin"},
		{Index = 246, Model = {"PRH3a_Prkr_OBOX_D1", "PRH3a_Prkr_OBOX_D1"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Parker", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Parker"},
		
		{Name = "- WOUNDED BOXER -"},
		{Index = 243, Model = {"PR2nd_Bif_OBOX_D2", "PR2nd_Bif_OBOX_D2"}, Sex = 0, Size = "Huge", Faction = "PREPPY", Stat = "STAT_P_BOXING_Bif", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Bif"},
		{Index = 240, Model = {"PRH2_Bryce_OBOX_D2", "PRH2_Bryce_OBOX_D2"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Bryce", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Bryce"},
		{Index = 242, Model = {"PRH2A_Chad_OBOX_D2", "PRH2A_Chad_OBOX_D2"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Chad", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Chad"},
		{Index = 245, Model = {"PRH3_Justin_OBOX_D2", "PRH3_Justin_OBOX_D2"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Justin", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Justin"},
		{Index = 247, Model = {"PRH3a_Prkr_OBOX_D2", "PRH3a_Prkr_OBOX_D2"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING_Parker", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Parker"},
		
		{Name = "- WRESTLER -"},
		{Index = 121, Model = {"GenericWrestler", "GenericWrestler"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_WRESTLING_GEN", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Bob"},
		{Index = 122, Model = {"ND_FattyWrestle", "ND_FattyWrestle"}, Sex = 0, Size = "Fat", Faction = "NERD", Stat = "STAT_WRESTLING_FAT", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Fatty"},
		{Index = 92, Model = {"JK_LuisWrestle", "JK_LuisWrestle"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_WRESTLING_LUIS", Spawn = -1, Tree = {"/Global/J_Grappler_A", "Act/Anim/J_Grappler_A.act"}, Name = "Luis"},
		
		{Name = "- FOOTBALLER -"},
		{Index = 110, Model = {"JKTed_FB", "JKTed_FB"}, Sex = 0, Size = "Large", Faction = "JOCK", Stat = "STAT_J_TED", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Ted"},
		{Index = 112, Model = {"JKDamon_FB", "JKDamon_FB"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_DAMON", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Damon"},
		{Index = 109, Model = {"JKKirby_FB", "JKKirby_FB"}, Sex = 0, Size = "Medium", Faction = "JOCK", Stat = "STAT_J_STRIKER_A", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Kirby"},
		{Index = 111, Model = {"JKDan_FB", "JKDan_FB"}, Sex = 0, Size = "Medium", Faction = "JOCK", Stat = "STAT_J_STRIKER_A", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Dan"},
		{Index = 231, Model = {"JK_Bo_FB", "JK_Bo_FB"}, Sex = 0, Size = "Large", Faction = "JOCK", Stat = "STAT_J_MELEE_A", Spawn = -1, Tree = {"/Global/J_Melee_A", "Act/Anim/J_Melee_A.act"}, Name = "Bo"},
		{Index = 232, Model = {"JK_Casey_FB", "JK_Casey_FB"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_MELEE_A", Spawn = -1, Tree = {"/Global/J_Melee_A", "Act/Anim/J_Melee_A.act"}, Name = "Casey"},
		
		{Name = "- SPORT -"},
		{Index = 196, Model = {"DOLead_Edgar_GS", "DOLead_Edgar_GS"}, Sex = 0, Size = "Large", Faction = "DROPOUT", Stat = "STAT_DO_EDGAR", Spawn = -1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Edgar"},
		{Index = 197, Model = {"DOH3a_Gurney_GS", "DOH3a_Gurney_GS"}, Sex = 0, Size = "Huge", Faction = "DROPOUT", Stat = "STAT_DO_GRAPPLER_A", Spawn = -1, Tree = {"/Global/DO_Grappler_A", "Act/Anim/DO_Grappler_A.act"}, Name = "Gurney"},
		{Index = 198, Model = {"DOH2_Jerry_GS", "DOH2_Jerry_GS"}, Sex = 0, Size = "Large", Faction = "DROPOUT", Stat = "STAT_DO_GRAPPLER_A", Spawn = -1, Tree = {"/Global/DO_Grappler_A", "Act/Anim/DO_Grappler_A.act"}, Name = "Jerry"},
		{Index = 199, Model = {"DOH2a_Leon_GS", "DOH2a_Leon_GS"}, Sex = 0, Size = "Huge", Faction = "DROPOUT", Stat = "STAT_DO_STRIKER_A", Spawn = -1, Tree = {"/Global/DO_Striker_A", "Act/Anim/DO_Striker_A.act"}, Name = "Leon"},
		{Index = 200, Model = {"GRH2a_Hal_GS", "GRH2a_Hal_GS"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_GRAPPLER_A", Spawn = -1, Tree = {"/Global/G_Grappler_A", "Act/Anim/G_Grappler_A.act"}, Name = "Hal"},
		{Index = 201, Model = {"GRH2_Norton_GS", "GRH2_Norton_GS"}, Sex = 0, Size = "Huge", Faction = "GREASER", Stat = "STAT_G_GRAPPLER_A", Spawn = -1, Tree = {"/Global/G_Grappler_A", "Act/Anim/G_Grappler_A.act"}, Name = "Norton"},
		{Index = 202, Model = {"GR2nd_Peanut_GS", "GR2nd_Peanut_GS"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_STRIKER_A", Spawn = -1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Peanut"},
		{Index = 203, Model = {"GRH1a_Vance_GS", "GRH1a_Vance_GS"}, Sex = 0, Size = "Medium", Faction = "GREASER", Stat = "STAT_G_MELEE_A", Spawn = -1, Tree = {"/Global/G_Melee_A", "Act/Anim/G_Melee_A.act"}, Name = "Vance"},
		{Index = 204, Model = {"JKH3a_Bo_GS", "JKH3a_Bo_GS"}, Sex = 0, Size = "Large", Faction = "JOCK", Stat = "STAT_J_MELEE_A", Spawn = -1, Tree = {"/Global/J_Melee_A", "Act/Anim/J_Melee_A.act"}, Name = "Bo"},
		{Index = 205, Model = {"JKH1_Damon_GS", "JKH1_Damon_GS"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_DAMON", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Damon"},
		{Index = 206, Model = {"JK2nd_Juri_GS", "JK2nd_Juri_GS"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_GRAPPLER_A", Spawn = -1, Tree = {"/Global/J_Grappler_A", "Act/Anim/J_Grappler_A.act"}, Name = "Juri"},
		{Index = 207, Model = {"JKH1a_Kirby_GS", "JKH1a_Kirby_GS"}, Sex = 0, Size = "Medium", Faction = "JOCK", Stat = "STAT_J_STRIKER_A", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Kirby"},
		{Index = 208, Model = {"NDH1a_Algernon_GS", "NDH1a_Algernon_GS"}, Sex = 0, Size = "Fat", Faction = "NERD", Stat = "STAT_N_STRIKER_B", Spawn = -1, Tree = {"/Global/N_Striker_B", "Act/Anim/N_Striker_B.act"}, Name = "Algernon"},
		{Index = 209, Model = {"NDH3_Bucky_GS", "NDH3_Bucky_GS"}, Sex = 0, Size = "Large", Faction = "NERD", Stat = "STAT_N_RANGED_S", Spawn = -1, Tree = {"/Global/N_Ranged_A", "Act/ANim/N_Ranged_A.act"}, Name = "Bucky"},
		{Index = 210, Model = {"NDH2_Thad_GS", "NDH2_Thad_GS"}, Sex = 0, Size = "Large", Faction = "NERD", Stat = "STAT_N_MELEE_A", Spawn = -1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Thad"},
		{Index = 211, Model = {"PRH3a_Parker_GS", "PRH3a_Parker_GS"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_STRIKER_B", Spawn = -1, Tree = {"/Global/P_Striker_B", "Act/Anim/P_Striker_B.act"}, Name = "Parker"},
		{Index = 212, Model = {"PRH3_Justin_GS", "PRH3_Justin_GS"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_STRIKER_B", Spawn = -1, Tree = {"/Global/P_Striker_B", "Act/Anim/P_Striker_B.act"}, Name = "Justin"},
		{Index = 213, Model = {"PRH1a_Tad_GS", "PRH1a_Tad_GS"}, Sex = 0, Size = "Medium", Faction = "PREPPY", Stat = "STAT_P_STRIKER_A", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Tad"},
		{Index = 214, Model = {"PRH1_Gord_GS", "PRH1_Gord_GS"}, Sex = 0, Size = "Medium", Faction = "PREPPY", Stat = "STAT_P_STRIKER_A", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Gord"},
		
		{Name = "- CHEERLEADER -"},
		{Index = 180, Model = {"GN_Asiangirl_CH", "GN_Asiangirl_CH"}, Sex = 1, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Angie"},
		{Index = 181, Model = {"GN_Sexygirl_CH", "GN_Sexygirl_CH"}, Sex = 1, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_S", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Christy"},
		{Index = 182, Model = {"PRGirl_Pinky_CH", "PRGirl_Pinky_CH"}, Sex = 1, Size = "Medium", Faction = "PREPPY", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Pinky"},
		
		{Name = "- HALLOWEEN -"},
		{Index = 160, Model = {"Nemesis_Ween", "Nemesis_Ween"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Gary"},
		{Index = 165, Model = {"Peter_Ween", "Peter_Ween"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Peter"},
		{Index = 159, Model = {"GN_Hboy_Ween", "GN_Hboy_Ween"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Pedro"},
		{Index = 161, Model = {"GRH3_Lucky_Ween", "GRH3_Lucky_Ween"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_STRIKER_A", Spawn = -1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Lucky"},
		{Index = 162, Model = {"NDH3a_Donald_ween", "NDH3a_Donald_ween"}, Sex = 0, Size = "Medium", Faction = "NERD", Stat = "STAT_N_RANGED_A", Spawn = -1, Tree = {"/Global/N_Ranged_A", "Act/ANim/N_Ranged_A.act"}, Name = "Donald"},
		{Index = 163, Model = {"PRH3a_Parker_Ween", "PRH3a_Parker_Ween"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_STRIKER_B", Spawn = -1, Tree = {"/Global/P_Striker_B", "Act/Anim/P_Striker_B.act"}, Name = "Parker"},
		{Index = 164, Model = {"JKH3_Casey_Ween", "JKH3_Casey_Ween"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_MELEE_A", Spawn = -1, Tree = {"/Global/J_Melee_A", "Act/Anim/J_Melee_A.act"}, Name = "Casey"},
		{Index = 168, Model = {"JKH1_Damon_ween", "JKH1_Damon_ween"}, Sex = 0, Size = "Huge", Faction = "JOCK", Stat = "STAT_J_DAMON", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Damon"},
		{Index = 169, Model = {"GN_WhiteBoy_Ween", "GN_WhiteBoy_Ween"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Gordon"},
		{Index = 170, Model = {"GN_Bully01_Ween", "GN_Bully01_Ween"}, Sex = 0, Size = "Large", Faction = "BULLY", Stat = "STAT_B_STRIKER_B", Spawn = -1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Ivan"},
		{Index = 171, Model = {"GN_Boy02_Ween", "GN_Boy02_Ween"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_B_STRIKER_B", Spawn = -1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Trevor"},
		{Index = 173, Model = {"GRH1a_Vance_Ween", "GRH1a_Vance_Ween"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_G_PIRATE", Spawn = -1, Tree = {"/Global/G_Melee_A", "Act/Anim/G_Melee_A.act"}, Name = "Vance"},
		{Index = 174, Model = {"NDH2_Thad_Ween", "NDH2_Thad_Ween"}, Sex = 0, Size = "Large", Faction = "NERD", Stat = "STAT_N_MELEE_A", Spawn = -1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Thad"},
		{Index = 167, Model = {"PRGirl_Pinky_Ween", "PRGirl_Pinky_Ween"}, Sex = 1, Size = "Medium", Faction = "PREPPY", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Pinky"},
		{Index = 166, Model = {"GN_AsianGirl_Ween", "GN_AsianGirl_Ween"}, Sex = 1, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Angie"},
		
		{Name = "- CHRISTMAS -"},
		{Index = 252, Model = {"TO_HoboSanta", "TO_HoboSanta"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_HOBO", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Rudy Santa"},
		{Index = 253, Model = {"TO_Santa", "TO_Santa"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Fake Santa"},
		{Index = 254, Model = {"TO_Santa_NB", "TO_Santa_NB"}, Sex = 0, Size = "Huge", Faction = "TOWNPERSON", Stat = "STAT_CV_MALE_A", Spawn = -1, Tree = {"/Global/CV_Male_A", "Act/Anim/CV_Male_A.act"}, Name = "Fake Santa II"},
		{Index = 250, Model = {"TO_ElfF", "TO_ElfF"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Female Elves"},
		{Index = 251, Model = {"TO_ElfM", "TO_ElfM"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Male Elves"},
		{Index = 255, Model = {"Peter_Nutcrack", "Peter_Nutcrack"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Peter"},
		{Index = 256, Model = {"GN_Fatgirl_Fairy", "GN_Fatgirl_Fairy"}, Sex = 1, Size = "Fat", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Fat_A", "Act/Anim/GS_Fat_A.act"}, Name = "Eunice"},
		{Index = 257, Model = {"GN_Lgirl_2_Flower", "GN_Lgirl_2_Flower"}, Sex = 1, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_SMKID", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Melody"},
		{Index = 258, Model = {"GN_Hboy_Flower", "GN_Hboy_Flower"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_MALE_SMKID", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Pedro"},
		
		{Name = "- BULLWORTH -"},
		{Index = 177, Model = {"PRH1a_Tad_BW", "PRH1a_Tad_BW"}, Sex = 0, Size = "Medium", Faction = "PREPPY", Stat = "STAT_P_STRIKER_A", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Tad"},
		{Index = 178, Model = {"PRH2_Bryce_BW", "PRH2_Bryce_BW"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_GRAPPLER_A", Spawn = -1, Tree = {"/Global/P_Grappler_A", "Act/Anim/P_Grappler_A.act"}, Name = "Bryce"},
		{Index = 179, Model = {"PRH3_Justin_BW", "PRH3_Justin_BW"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_STRIKER_B", Spawn = -1, Tree = {"/Global/P_Striker_B", "Act/Anim/P_Striker_B.act"}, Name = "Justin"},
		{Index = 175, Model = {"PRGirl_Pinky_BW", "PRGirl_Pinky_BW"}, Sex = 1, Size = "Medium", Faction = "PREPPY", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Pinky"},
		
		{Name = "- GROTTOS & GREMLINS -"},
		{Index = 186, Model = {"NDH1_Fatty_DM", "NDH1_Fatty_DM"}, Sex = 0, Size = "Fat", Faction = "NERD", Stat = "STAT_N_STRIKER_A", Spawn = -1, Tree = {"/Global/N_Striker_A", "Act/Anim/N_Striker_A.act"}, Name = "Fatty"},
		
		{Name = "- MALE PAJAMA -"},
		{Index = 224, Model = {"NDH2_Thad_PJ", "NDH2_Thad_PJ"}, Sex = 0, Size = "Large", Faction = "NERD", Stat = "STAT_N_MELEE_A", Spawn = -1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Thad"},
		{Index = 225, Model = {"GN_Lblkboy_PJ", "GN_Lblkboy_PJ"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Sheldon"},
		{Index = 226, Model = {"GN_Hboy_PJ", "GN_Hboy_PJ"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Pedro"},
		{Index = 227, Model = {"GN_Boy01_PJ", "GN_Boy01_PJ"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Ivan"},
		{Index = 228, Model = {"GN_Boy02_PJ", "GN_Boy02_PJ"}, Sex = 0, Size = "Large", Faction = "STUDENT", Stat = "STAT_GS_MALE_A", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Trevor"},
		
		{Name = "- FEMALE PAJAMA -"},
		{Index = 90, Model = {"GN_Sexygirl_UW", "GN_Sexygirl_UW"}, Sex = 1, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_FEMALE_S", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Christy"},
		{Index = 93, Model = {"JKGirl_MandyUW", "JKGirl_MandyUW"}, Sex = 1, Size = "Medium", Faction = "JOCK", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Mandy"},
		{Index = 94, Model = {"PRGirl_PinkyUW", "PRGirl_PinkyUW"}, Sex = 1, Size = "Medium", Faction = "PREPPY", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Pinky"},
		{Index = 95, Model = {"NDGirl_BeatriceUW", "NDGirl_BeatriceUW"}, Sex = 1, Size = "Medium", Faction = "NERD", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Beatrice"},
		{Index = 96, Model = {"GRGirl_LolaUW", "GRGirl_LolaUW"}, Sex = 1, Size = "Medium", Faction = "GREASER", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Lola"},
		
		{Name = "- TOWEL -"},
		{Index = 230, Model = {"JK_Mandy_Towel", "JK_Mandy_Towel"}, Sex = 1, Size = "Medium", Faction = "JOCK", Stat = "STAT_GS_FEMALE_A", Spawn = -1, Tree = {"/Global/GS_Female_A", "Act/Anim/GS_Female_A.act"}, Name = "Mandy"},
		
		{Name = "- UNDERWEAR -"},
		{Index = 235, Model = {"GN_GreekboyUW", "GN_GreekboyUW"}, Sex = 0, Size = "Medium", Faction = "STUDENT", Stat = "STAT_GS_MALE_TATTLER", Spawn = -1, Tree = {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"}, Name = "Constantinos"},
		
		{Name = "- MAYHEM -"},
		{Index = 176, Model = {"DOlead_Russell_BU", "DOlead_Russell_BU"}, Sex = 0, Size = "Huge", Faction = "BULLY", Stat = "STAT_B_STRIKER_S", Spawn = -1, Tree = {"/Global/B_Striker_A", "Act/Anim/B_Striker_A.act"}, Name = "Russell"},
		{Index = 215, Model = {"NDLead_Earnest_EG", "NDLead_Earnest_EG"}, Sex = 0, Size = "Medium", Faction = "NERD", Stat = "STAT_N_EARNEST", Spawn = -1, Tree = {"/Global/N_Ranged_A", "Act/Anim/N_Ranged_A.act"}, Name = "Earnest"},
		{Index = 216, Model = {"JKlead_Ted_EG", "JKlead_Ted_EG"}, Sex = 0, Size = "Large", Faction = "JOCK", Stat = "STAT_J_TED", Spawn = -1, Tree = {"/Global/J_Striker_A", "Act/Anim/J_Striker_A.act"}, Name = "Ted"},
		{Index = 217, Model = {"GRlead_Johnny_EG", "GRlead_Johnny_EG"}, Sex = 0, Size = "Large", Faction = "GREASER", Stat = "STAT_G_JOHNNY", Spawn = -1, Tree = {"/Global/G_Striker_A", "Act/Anim/G_Striker_A.act"}, Name = "Johnny"},
		{Index = 218, Model = {"PRlead_Darby_EG", "PRlead_Darby_EG"}, Sex = 0, Size = "Large", Faction = "PREPPY", Stat = "STAT_P_BOXING", Spawn = -1, Tree = {"/Global/P_Striker_A", "Act/Anim/P_Striker_A.act"}, Name = "Darby"},
		
		{Name = "- DOG -"},
		{Index = 141, Model = {"Dog_Pitbull", "Dog_Pitbull"}, Sex = 0, Size = "Small", Faction = "TOWNPERSON", Stat = "STAT_AN_DOG_A", Spawn = -1, Tree = {"/Global/AN_DOG", "Act/Anim/AN_DOG.act"}, Name = "Pitbull I"},
		{Index = 219, Model = {"Dog_Pitbull2", "Dog_Pitbull2"}, Sex = 0, Size = "Small", Faction = "TOWNPERSON", Stat = "STAT_AN_DOG_A", Spawn = -1, Tree = {"/Global/AN_DOG", "Act/Anim/AN_DOG.act"}, Name = "Pitbull II"},
		{Index = 220, Model = {"Dog_Pitbull3", "Dog_Pitbull3"}, Sex = 0, Size = "Small", Faction = "TOWNPERSON", Stat = "STAT_AN_DOG_A", Spawn = -1, Tree = {"/Global/AN_DOG", "Act/Anim/AN_DOG.act"}, Name = "Pitbull III"},
		
		{Name = "- RAT -"},
		{Index = 136, Model = {"Rat_Ped", "Rat_Ped"}, Sex = 0, Size = "Small", Faction = "STUDENT", Stat = "STAT_AN_RAT_A", Spawn = -1, Tree = {"/Global/AN_Rat", "Act/Anim/AN_RAT.act"}, Name = "Rat"},
		
		{Name = "- PUNCHBAG -"},
		{Index = 233, Model = {"PunchBag", "PunchBag"}, Sex = 0, Size = "Large", Faction = "BULLY", Stat = "STAT_B_STRIKER_B", Spawn = -1, Tree = {"/Global/PunchBagBS", "Act/Anim/PunchBagBS.act"}, Name = "PunchBag"},
	}},
	{Name = "Action", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				
				local Table = {}
				table.insert(Table, {Name = "- STYLE: "..string.upper(Selected.Name).." -"})
				table.insert(Table, {Name = "Set Player Style", Func = SetStyle, Args = {true, Selected.Code}})
				
				local Exception = {
					['BoxingPlayer']	= true,
					['WrestlingACT']	= true,
					['3_05_Norton']		= true,
					['PunchBagBS']		= true,
					['TO_Siamese']		= true,
					['AN_DOG']			= true,
				}
				if not Exception[Selected.Code] then
					table.insert(Table, {Name = "Set Player Movement", Func = SetMovement, Args = {Selected.Code}})
				end
				table.insert(Table, {Name = "Set NPC Style", Func = SetStyle, Args = {false, Selected.Code}})
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Table[Select].Func(unpack(Table[Select].Args))
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
		{Name = "- PLAYER -"},
		{Name = "Jimmy", Code = "Player"},
		{Name = "Boxing", Code = "BoxingPlayer"},
		
		{Name = "- BOSS -"},
		{Name = "Russell", Code = "BOSS_Russell"},
		{Name = "Darby", Code = "BOSS_Darby"},
		{Name = "Johnny", Code = "G_Johnny"},
		{Name = "Earnest", Code = "N_Earnest"},
		{Name = "Ted", Code = "J_Ted"},
		{Name = "Edgar", Code = "DO_Edgar"},
		{Name = "Gary", Code = "Nemesis"},
		{Name = "Russell II", Code = "Russell_102"},
		{Name = "Bif", Code = "P_Bif"},
		{Name = "Norton Hammer", Code = "3_05_Norton"},
		{Name = "Damon", Code = "J_Damon"},
		
		{Name = "- AUTHORITY -"},
		{Name = "Prefect/Cop", Code = "Authority"},
		{Name = "Orderly", Code = "LE_Orderly_A"},
		{Name = "Secretary", Code = "TE_Secretary"},
		{Name = "Female", Code = "TE_Female_A"},
		
		{Name = "- BULLY -"},
		{Name = "Striker", Code = "B_Striker_A"},
		{Name = "Davis", Code = "1_03_Davis"},
		
		{Name = "- PREP -"},
		{Name = "Striker I", Code = "P_Striker_A"},
		{Name = "Striker II", Code = "P_Striker_B"},
		{Name = "Grappler", Code = "P_Grappler_A"},
		
		{Name = "- GREASER -"},
		{Name = "Striker", Code = "G_Striker_A"},
		{Name = "Melee", Code = "G_Melee_A"},
		{Name = "Grappler", Code = "G_Grappler_A"},
		{Name = "Ranged", Code = "G_Ranged_A"},
		
		{Name = "- NERD -"},
		{Name = "Striker I", Code = "N_Striker_A"},
		{Name = "Striker II", Code = "N_Striker_B"},
		{Name = "Ranged", Code = "N_Ranged_A"},
		
		{Name = "- JOCK -"},
		{Name = "Striker", Code = "J_Striker_A"},
		{Name = "Melee", Code = "J_Melee_A"},
		{Name = "Grappler", Code = "J_Grappler_A"},
		{Name = "Mascot", Code = "J_Mascot"},
		
		{Name = "- DROPOUT -"},
		{Name = "Striker", Code = "DO_Striker_A"},
		{Name = "Melee", Code = "DO_Melee_A"},
		{Name = "Grappler", Code = "DO_Grappler_A"},
		
		{Name = "- ETC -"},
		{Name = "Male", Code = "GS_Male_A"},
		{Name = "Female", Code = "GS_Female_A"},
		{Name = "Adult Female", Code = "CV_Female_A"},
		{Name = "Adult Male", Code = "CV_Male_A"},
		{Name = "Elderly", Code = "CV_OLD"},
		{Name = "Asylum Patient", Code = "Crazy_Basic"},
		{Name = "Hobo", Code = "Hobo_Blocker"},
		{Name = "Siamese", Code = "TO_Siamese"},
		{Name = "Wrestling", Code = "WrestlingACT"},
		{Name = "Drunk", Code = "CV_Drunk"},
		{Name = "Fat", Code = "GS_Fat_A"},
		{Name = "Dog", Code = "AN_DOG"},
		{Name = "Punch Bags", Code = "PunchBagBS"},
	}},
	{Name = "Custom Action", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		
		local KeyListener = function(Header, Message)
			Message = Message..'\nPress ~t~ to cancel'
			SetQueuedMessage(Header, Message, -1, {GetHudTexture('Button_Right_Mouse_Button')})
			
			repeat
				local Key = GetAnyKeyBeingPressed()
				if Key then
					StopQueueMessage()
					return Key
				end
				Wait(0)
			until IsMenuPressed(1)
			
			StopQueueMessage()
			return nil
		end
		local NodeListener = function(Header, Message)
			Message = Message..'\nPress ~t~ to confirm\nPress ~t~ to cancel'
			SetQueuedMessage(Header, Message, -1, {
				GetHudTexture('Button_Left_Mouse_Button'), 
				GetHudTexture('Button_Right_Mouse_Button')
			})
			
			repeat
				if IsMenuPressed(0) and not PedMePlaying(gPlayer, 'DEFAULT_KEY') then
					StopQueueMessage()
					return PedGetActionNode(gPlayer, {})
				end
				Wait(0)
			until IsMenuPressed(1)
			
			StopQueueMessage()
			return nil
		end
		local GetHeader = function(Select)
			while not IsMenuHeader(Sub.Data[Select].Name) do
				Select = Select - 1
			end
			return string.gsub(TrimHeader(Sub.Data[Select].Name, true), ' %b()', '')
		end
		
		repeat
			local Select = GetPointerSelection()
			
			local IsMenuBlock = false
			local IsMenuSetting = false
			if Select then
				IsMenuBlock = string.find(Sub.Data[Select].Name, '^.+ %(B%)$')
				IsMenuSetting = Sub.Data[Select].Func
			end
			
			if Select and not IsMenuBlock and IsMenuSetting and IsMenuPressed(0) then
				Sub.Data[Select].Func()
			elseif Select and IsMenuBlock and not IsMenuSetting and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				table.insert(PlayerSettings.Strafe.Block, {Name = GetHeader(Select)..': '..Selected.Name, Anim = Selected[1], Act = Selected[2]})
			elseif Select and not IsMenuBlock and not IsMenuSetting and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Header = GetHeader(Select)
				local Name = string.gsub(Sub.Data[Select].Name, ' %b()', '')
				local Table = {
					{Name = "- "..string.upper(Header)..": "..string.upper(Selected.Name).." -"},
					{Name = "Set Key Trigger", Func = function()
						local IsGrapple = string.find(Sub.Data[Select].Name, '^.+ %(F%)$')
						local IsMount = string.find(Sub.Data[Select].Name, '^.+ %(M%)$')
						
						local Desc = {Type = 'fist', Condition = 'hit'}
						if IsGrapple then
							Desc = {Type = 'grapple', Condition = 'grappled'}
						elseif IsMount then
							Type = {Type = 'mount', Condition = 'mounted'}
						end
						
						local Key = KeyListener('SETTING KEY TRIGGER', 'Press any key to assign the "'..Name..'" move. During '..Desc.Type..' combat and not being '..Desc.Condition..' by someone, pressing that key will trigger the bound move.')
						if type(Key) ~= 'number' then
							return
						end
						
						table.insert(PlayerSettings.Strafe.Bind, {Name = Header..': '..Selected.Name, Anim = Selected[1], Act = Selected[2], Key = Key, Grapple = IsGrapple, Mount = IsMount})
						if not IsGrapple and not IsMount then
							if not STRAFE_KEY then STRAFE_KEY = {} end
							STRAFE_KEY[Key] = true
						end
					end},
					{Name = "Set as Action Override", Func = function()
						local Node = NodeListener('SETTING ACTION OVERRIDE', 'Perform the action you would like to override. "'..Name..'" will play whenever that action is triggered.')
						if type(Node) == 'string' then
							table.insert(PlayerSettings.Strafe.Conditional, {Name = Header..': '..Selected.Name, Anim = Selected[1], Act = Selected[2], Trigger = Node, Key = nil, Method = 1})
						end
					end},
					{Name = "Set as Post-Action", Func = function()
						local Node = NodeListener('SETTING POST-ACTION', 'Perform the action you would like to follow up. "'..Name..'" will automatically play after that action finishes.')
						if type(Node) == 'string' then
							table.insert(PlayerSettings.Strafe.Conditional, {Name = Header..': '..Selected.Name, Anim = Selected[1], Act = Selected[2], Trigger = Node, Key = nil, Method = 2})
						end
					end},
					{Name = "Set as Mid-Action", Func = function()
						local Key = KeyListener('STEP ONE: SETTING MID-ACTION', 'Press any key to assign it as the trigger. This key will be used to activate the "'..Name..'" during the monitored action.')
						if type(Key) ~= 'number' then
							return
						end
						local Node = NodeListener('STEP TWO: SETTING MID-ACTION', 'Now, perform the action you would like to monitor. Whenever that key is pressed while this action is playing, the "'..Name..'" will immediately play.')
						if type(Node) == 'string' then
							table.insert(PlayerSettings.Strafe.Conditional, {Name = Header..': '..Selected.Name, Anim = Selected[1], Act = Selected[2], Trigger = Node, Key = Key, Method = 2})
						end
					end},
				}
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Table[Select].Func()
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
		{Name = "- DATA -"},
		{Name = "Saved Customization", Func = function()
			local Table = {}
			local Option = 1
			
			local SetTable = function(Index)
				if next(Table) then
					table.remove(Table[Index].Table, Table[Index].Index)
				end
				
				Table = {}
				table.insert(Table, {Name = "- KEY TRIGGER -"})
				if next(PlayerSettings.Strafe.Bind) then
					for Id, Content in ipairs(PlayerSettings.Strafe.Bind) do
						table.insert(Table, {Table = PlayerSettings.Strafe.Bind, Index = Id, Name = Content.Name..'=(T)'})
					end
				else
					table.insert(Table, {Name = 'None'})
				end
				table.insert(Table, {Name = "- ACTION OVERRIDE / POST-ACTION / MID-ACTION -"})
				if next(PlayerSettings.Strafe.Conditional) then
					for Id, Content in ipairs(PlayerSettings.Strafe.Conditional) do
						table.insert(Table, {Table = PlayerSettings.Strafe.Conditional, Index = Id, Name = Content.Name..'=(T)'})
					end
				else
					table.insert(Table, {Name = 'None'})
				end
				table.insert(Table, {Name = "- BLOCK -"})
				if next(PlayerSettings.Strafe.Block) then
					for Id, Content in ipairs(PlayerSettings.Strafe.Block) do
						table.insert(Table, {Table = PlayerSettings.Strafe.Block, Index = Id, Name = Content.Name..'=(T)'})
					end
				else
					table.insert(Table, {Name = 'None'})
				end
			end
			
			SetTable()
			repeat
				ShowMenuBorder()
				
				Option = UpdateMenuLayout(Table, Option)
				ShowMenuRemoval(Table, Option, SetTable)
				Wait(0)
			until IsMenuPressed(1)
		end},
		
		{Name = "- JIMMY -"},
		{Name = "Jab", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Release/JAB", "act/anim/Player.act"},
		{Name = "Cross", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Release/Cross", "act/anim/Player.act"},
		{Name = "Hook", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Release/Hook", "act/anim/Player.act"},
		{Name = "Gut Punch", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Right4/Release/GutPunch", "act/anim/Player.act"},
		{Name = "Last Uppercut", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Right4/Left5/Release/UpperCut", "act/anim/Player.act"},
		{Name = "Uppercut", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Release/HeavyAttacks", "act/anim/Player.act"},
		{Name = "Leg Kick", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Release/Unblockable/LegKickReleaseMax", "act/anim/Player.act"},
		{Name = "Jackie Kick", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Release/Unblockable/JackieKick", "act/anim/Player.act"},
		{Name = "Roundhouse Kick", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Right4/Release/Unblockable/HighKick", "act/anim/Player.act"},
		{Name = "Overhead Punch", "/Global/Player/Attacks/Strikes/LightAttacks/Left1/Right2/Left3/Right4/Left5/Release/Unblockable", "act/anim/Player.act"},
		{Name = "Ground Kick", "/Global/Player/Attacks/GroundAttacks/GroundAttacks/Strikes/HeavyAttacks/GroundKick", "act/anim/Player.act"},
		{Name = "Running Punch", "/Global/Player/Attacks/Strikes/RunningAttacks/HeavyAttacks", "act/anim/Player.act"},
		{Name = "Shove", "/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove", "Act/Player.act"},
		{Name = "Smashing Egg", "/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove/SmashInnaFace", "Act/Anim/Player.act"},
		{Name = "Smashing Bomb", "/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove/SmashInnaFaceStink", "Act/Anim/Player.act"},
		{Name = "Face Punch (M)", "/Global/Actions/Grapples/Front/Grapples/Mount/GrappleMoves/FacePunch/Hit1", "act/anim/Player.act"},
		{Name = "Knee Drop (M)", "/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Player/KneeDrop", "act/anim/Player.act"},
		{Name = "Ground Spit (M)", "/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Player/Spit", "act/anim/Player.act"},
		{Name = "Block Hit (B)", "/Global/Actions/Defence/Block/Block/BlockHits", "Act/Anim/HitTree.act"},
		
		{Name = "- BOXING -"},
		{Name = "Jab", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left1/Release/JAB", "act/anim/BoxingPlayer.act"},
		{Name = "Cross", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right2/Release/Cross", "act/anim/BoxingPlayer.act"},
		{Name = "Hook", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left3/Release/Hook", "act/anim/BoxingPlayer.act"},
		{Name = "Gut Punch", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right4/Release/GutPunch", "act/anim/BoxingPlayer.act"},
		{Name = "Last Uppercut", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left5/Release/Uppercut", "act/anim/BoxingPlayer.act"},
		{Name = "Heavy Uppercut", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left1/Release/Unblockable", "act/anim/BoxingPlayer.act"},
		{Name = "Heavy Cross", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right2/Release/Unblockable", "act/anim/BoxingPlayer.act"},
		{Name = "Heavy Hook", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left3/Release/Unblockable", "act/anim/BoxingPlayer.act"},
		{Name = "Heavy Cross II", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Right4/Release/Unblockable", "act/anim/BoxingPlayer.act"},
		{Name = "Heavy Finisher", "/Global/BoxingPlayer/Attacks/BoxingAttacks/LightAttacks/Left5/Release/Unblockable", "act/anim/BoxingPlayer.act"},
		{Name = "Duck Evade", "/Global/BoxingPlayer/EvadeBank/Evades/Duck", "act/anim/BoxingPlayer.act"},
		{Name = "Left Evade", "/Global/BoxingPlayer/EvadeBank/Evades/Left", "act/anim/BoxingPlayer.act"},
		{Name = "Right Evade","/Global/BoxingPlayer/EvadeBank/Evades/Right", "act/anim/BoxingPlayer.act"},
		{Name = "Duck Evade Counter", "/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/BackCharge", "act/anim/BoxingPlayer.act"},
		{Name = "Left Evade Counter", "/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/LeftCharge", "act/anim/BoxingPlayer.act"},
		{Name = "Right Evade Counter", "/Global/BoxingPlayer/EvadeBank/Evades/EvadeAttacks/RightCharge", "act/anim/BoxingPlayer.act"},
		
		{Name = "- RUSSELL -"},
		{Name = "Overhand", "/Global/BOSS_Russell/Offense/Short/Strikes/LightAttacks/OverHand", "act/anim/BOSS_Russell.act"},
		{Name = "Ground Stomp", "/Global/BOSS_Russell/Offense/GroundAttack/GroundStomp1", "act/anim/BOSS_Russell.act"},
		{Name = "Power Bomb (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/PowerBomb", "Globals/BOSS_Russell.act"},
		{Name = "Running Headbutt", "/Global/BOSS_Russell/Offense/Special/Invincible/HeadButt/HeadButt_AnticStart", "act/anim/BOSS_Russell.act"},
		{Name = "Barserk Grapple", "/Global/BOSS_Russell/Offense/Special/Invincible/BarserkGrapple", "act/anim/BOSS_Russell.act"},
		{Name = "Double Axe Handle", "/Global/BOSS_Russell/Offense/Medium/Strikes/Unblockable/DoubleAxeHandle", "act/anim/BOSS_Russell.act"},
		{Name = "Chest Counter", "/Global/BOSS_Russell/Defense/Evade/EvadeInterrupt/EvadeInterrupt", "act/anim/BOSS_Russell.act"},
		{Name = "1_02 Chest Counter","/Global/Russell_102/Offense/Short/Medium/RisingAttacks", "act/anim/Russell_102.act" },
		
		{Name = "- DARBY -"},
		{Name = "Jab", "/Global/BOSS_Darby/Offense/Medium/Medium/HeavyAttacks/JAB", "act/anim/BOSS_Darby.act"},
		{Name = "Cross", "/Global/BOSS_Darby/Offense/Medium/Medium/HeavyAttacks/JAB/Cross", "act/anim/BOSS_Darby.act"},
		{Name = "Hook", "/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftHook", "Act/Anim/BOSS_Darby.act"},
		{Name = "6 Hit + Finisher", "/Global/BOSS_Darby/Offense/Short/Grapples/HeavyAttacks/Catch_Throw", "Act/Anim/BOSS_Darby.act"},
		{Name = "Finisher", "/Global/BOSS_Darby/Offense/Short/Grapples/HeavyAttacks/Catch_Throw/Finisher", "act/anim/BOSS_Darby.act"},
		{Name = "Unblockable", "/Global/BOSS_Darby/Offense/Short/Strikes/Unblockable/HeavyPunchCharge/HeavyPunch", "act/anim/BOSS_Darby.act"},
		{Name = "Left Jab", "/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftJab", "Act/Anim/BOSS_Darby.act"},
		{Name = "Left Hook", "/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftJab/Hook", "Act/Anim/BOSS_Darby.act"},
		{Name = "Body Hook", "/Global/BOSS_Darby/Offense/Short/Strikes/HeavyAttacks/Hook2", "act/anim/BOSS_Darby.act"},
		{Name = "Heavy Attacks", "/Global/BOSS_Darby/Offense/Special/HeavyAttacks", "act/anim/BOSS_Darby.act"},
		{Name = "Chase Uppercut", "/Global/BOSS_Darby/Offense/Special/Dash/Dash/Uppercut/ShortDarby", "Act/anim/BOSS_Darby.act"},
		{Name = "Duck Evade", "/Global/BOSS_Darby/Defense/Evade/EvadeDuck", "act/anim/BOSS_Darby.act"},
		{Name = "Right Evade", "/Global/BOSS_Darby/Defense/Evade/EvadeRight", "act/anim/BOSS_Darby.act"},
		{Name = "Left Evade", "/Global/BOSS_Darby/Defense/Evade/EvadeLeft", "act/anim/BOSS_Darby.act"},
		{Name = "Hopback", "/Global/BOSS_Darby/Offense/NonCombatActions/Hopback", "Act/Anim/BOSS_Darby.act"},
		{Name = "Block Hit (B)", "/Global/BOSS_Darby/Defense/Block/Block/BlockHits", "Act/Anim/BOSS_Darby.act"},
		
		{Name = "- BIF -"},
		{Name = "Light Jab", "/Global/P_Bif/Offense/Short/LightAttacks/JAB", "Act/Anim/P_Bif.act"},
		{Name = "Light Cross", "/Global/P_Bif/Offense/Short/LightAttacks/Jab/Cross", "Act/Anim/P_Bif.act"},
		{Name = "Straight Punch", "/Global/P_Bif/Offense/Medium/HeavyAttacks/StraightPunch", "Act/Anim/P_Bif.act"},
		{Name = "Special", "/Global/P_Bif/Offense/Special/HeavyAttacks","Act/Anim/P_Bif.act"},
		{Name = "Duck Evade", "/Global/P_Bif/Defense/Evade/EvadeDuck", "Act/Anim/P_Bif.act"},
		{Name = "Left Evade", "/Global/P_Bif/Defense/Evade/EvadeLeft", "Act/Anim/P_Bif.act"},
		{Name = "Right Evade", "/Global/P_Bif/Defense/Evade/EvadeRight", "Act/Anim/P_Bif.act"},
		{Name = "Duck Evade Counter", "/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeDuckPunch", "Act/Anim/P_Bif.act"},
		{Name = "Left Evade Counter", "/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeLeftPunch", "Act/Anim/P_Bif.act"},
		{Name = "Right Evade Counter", "/Global/P_Bif/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeRightPunch", "Act/Anim/P_Bif.act"},
		{Name = "Gut Punch", "/Global/P_Bif/Offense/Medium/HeavyAttacks/GutPunch","Act/Anim/P_Bif.act"},
		{Name = "Left Hook", "/Global/P_Bif/Offense/Short/HeavyAttacks/LeftHook", "Act/Anim/P_Bif.act"},
		{Name = "Right Hook", "/Global/P_Bif/Offense/Short/HeavyAttacks/RightHook", "Act/Anim/P_Bif.act"},
		
		{Name = "- JOHNNY -"},
		{Name = "Combo", "/Global/G_Johnny/Offense", "Act/Anim/G_Johnny.act"},
		{Name = "Light Attacks", "/Global/G_Johnny/Offense/Short/Strikes/LightAttacks", "Act/Anim/G_Johnny.act"},
		{Name = "Overhead kick combo", "/Global/G_Johnny/Offense/Special/SpecialActions/LightAttacks", "Act/Anim/G_Johnny.act"},
		{Name = "Right kick", "/Global/G_Johnny/Offense/Short/Strikes/HeavyKick/HeavyKick", "act/anim/G_Johnny.act"},
		{Name = "Kick / Punch", "/Global/G_Johnny/Offense/Medium/Strikes/HeavyAttack", "act/anim/G_Johnny.act"},
		{Name = "Left kick", "/Global/G_Johnny/Offense/Medium/Strikes/HeavyAttack/HeavyKick", "act/anim/G_Johnny.act"},
		{Name = "Haymaker", "/Global/G_Johnny/Offense/Special/SpecialActions/Grapples/Dash", "Act/Anim/G_Johnny.act"},
		{Name = "Special Haymaker", "/Global/G_Johnny/Cinematic/ThroatGrab", "act/anim/G_Johnny.act"},
		{Name = "Grabknees (F)", "/Global/G_Johnny/Offense/Short/Strikes/HeavyKick/HeavyKick/Grabknees/GV", "act/anim/G_Johnny.act"},
		{Name = "Tornado Kick", "/Global/G_Johnny/Default_KEY/RisingAttacks/HeavyAttacks/RisingAttacks", "Act/Anim/G_Johnny.act"},
		
		{Name = "- TED -"},
		{Name = "Jab", "/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB", "act/anim/J_Ted.act"},
		{Name = "Elbow", "/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB/Elbow", "act/anim/J_Ted.act"},
		{Name = "Uppercut", "/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB/Elbow/HeavyAttacks/Uppercut", "act/anim/J_Ted.act"},
		{Name = "Duck Evades", "/Global/J_Ted/Default_KEY/ExecuteNodes/BlockProjectiles", "act/anim/J_Ted.act"},
		{Name = "Grapple", "/Global/J_Ted/Offense/Medium/Grapples/GrapplesAttempt", "act/anim/J_Ted.act"},
		{Name = "Block Hit (B)", "/Global/J_Ted/Defense/Block/Block/BlockHits", "Act/Anim/J_Ted.act"},
		
		{Name = "- DAMON -"},
		{Name = "Throwing Ped (F)", "/Global/J_Damon/Offense/Medium/Grapples/GrapplesAttempt/TakeDown", "act/anim/J_Damon.act"},
		{Name = "Running Grab", "/Global/J_Damon/Offense/SpecialStart/StartRun", "act/anim/J_Damon.act"},
		
		{Name = "- EARNEST -"},
		{Name = "Spud Gun", "/Global/N_Earnest/Offense/FireSpudGun", "act/anim/N_Earnest.act"},
		{Name = "Throw Bombs", "/Global/N_Earnest/Offense/ThrowBombs", "act/anim/N_Earnest.act"},
		
		{Name = "- EDGAR -"},
		{Name = "Punch", "/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1", "Act/Anim/DO_Edgar.act"},
		{Name = "Knee Kick", "/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1/Punch2", "Act/Anim/DO_Edgar.act"},
		{Name = "Double Axe Handle", "/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1/Punch2/HeavyAttacks/Punch3", "Act/Anim/DO_Edgar.act"},
		{Name = "Evade", "/Global/DO_Edgar/Defense/Evade/DropToFloor", "act/anim/DO_Edgar.act"},
		{Name = "Evade + Counter", "/Global/DO_Edgar/Defense/Evade/DropAndCounter", "act/anim/DO_Edgar.act"},
		{Name = "Counter Attack", "/Global/DO_Edgar/Defense/Evade/DropAndCounter/Unblockable2/DuckCharge", "act/anim/DO_Edgar.act"},
		
		{Name = "- NEMESIS -"},
		{Name = "Left Hook", "/Global/Nemesis/Offense/Short/Strikes/LightAttacks/LeftHook", "Act/Anim/Nemesis.act"},
		{Name = "Right Cross", "/Global/Nemesis/Offense/Short/Strikes/LightAttacks/LeftHook/RightCross", "Act/Anim/Nemesis.act"},
		{Name = "Left Uppercut", "/Global/Nemesis/Offense/Short/Strikes/LightAttacks/LeftHook/RightCross/HeavyAttacks", "Act/Anim/Nemesis.act"},
		{Name = "Heavy Punch", "/Global/Nemesis/Offense/Short/Strikes/HeavyAttacks/HeavyPunch1", "Act/Anim/Nemesis.act"},
		{Name = "Heavy Uppercut", "/Global/Nemesis/Offense/Short/Strikes/HeavyAttacks/HeavyPunch2", "Act/Anim/Nemesis.act"},
		{Name = "Jab", "/Global/Nemesis/Offense/Short/Strikes/LightAttacks/JAB", "Act/Anim/Nemesis.act"},
		{Name = "Super Uppercut", "/Global/Nemesis/Offense/Short/Strikes/LightAttacks/JAB/HeavyAttacks/SuperUppercut", "Act/Anim/Nemesis.act"},
		{Name = "Knee I", "/Global/Nemesis/Offense/Short/Strikes/LightAttacks/JAB/HeavyAttacks/SuperUppercut/Knee", "Act/Anim/Nemesis.act"},
		{Name = "Gut Punch", "/Global/Nemesis/Offense/Medium/Strikes/LightAttacks/OverHandR", "Act/Anim/Nemesis.act"},
		{Name = "Knee II", "/Global/Nemesis/Offense/Medium/Strikes/LightAttacks/OverHandR/HeavyAttacks​/Knee", "Act/Anim/Nemesis.act"},
		{Name = "Gut kick", "/Global/Nemesis/Offense/Medium/Strikes/HeavyAttacks/JackieKick", "Act/Anim/Nemesis.act"},
		{Name = "Rooftop Grab", "/Global/Nemesis/Special/GarySpecialGrapple", "Act/Anim/Nemesis.act"},
		{Name = "Evade Back", "/Global/Nemesis/Defense/Evade/Back", "Act/Anim/Nemesis.act"},
		
		{Name = "- BULLY -"},
		{Name = "Right Punch", "/Global/B_Striker_A/Offense/Short/Strikes/LightAttacks/WindMill_R", "Act/Anim/B_Striker_A.act"},
		{Name = "Left Punch", "/Global/B_Striker_A/Offense/Short/Strikes/LightAttacks/WindMill_R/WindMill_L", "Act/Anim/B_Striker_A.act"},
		{Name = "Gut kick", "/Global/B_Striker_A/Offense/Short/Strikes/HeavyAttacks/GutKick/GutKick_R", "Act/Anim/B_Striker_A.act"},
		{Name = "Swing Punch", "/Global/B_Striker_A/Offense/Short/Strikes/HeavyAttacks/SwingPunch/SwingPunch_R", "Act/Anim/B_Striker_A.act"},
		
		{Name = "- PREPPY (STRIKER TYPE I) -"},
		{Name = "Jab", "/Global/P_Striker_A/Offense/Short/Strikes/LightAttacks/JAB", "act/anim/P_Striker_A.act"},
		{Name = "Cross", "/Global/P_Striker_A/Offense/Short/Strikes/LightAttacks/JAB/Cross", "Act/Anim/P_Striker_A.act"},
		{Name = "Left Hook", "/Global/P_Striker_A/Offense/Short/Strikes/LightAttacks/LeftHook", "act/anim/P_Striker_A.act"},
		{Name = "Uppercut", "/Global/P_Striker_A/Offense/Short/Strikes/HeavyAttacks/Uppercut", "act/anim/P_Striker_A.act"},
		{Name = "Finishing Cross", "/Global/P_Striker_A/Offense/Short/Strikes/LightAttacks/LeftHook/FinishingCross", "Act/Anim/P_Striker_A.act"},
		{Name = "Heavy Shoulder + Punch", "/Global/P_Striker_A/Offense/Medium/HeavyAttacks", "act/anim/P_Striker_A.act"},
		{Name = "Evade", "/Global/P_Striker_A/Defense/Evade/EvadeBack", "act/anim/P_Striker_A.act"},
		{Name = "Evade Back Punch", "/Global/P_Striker_A/Defense/Evade/EvadeCounter", "Act/Anim/P_Striker_A.act"},
		
		{Name = "- PREPPY (STRIKER TYPE II) -"},
		{Name = "Left Jab", "/Global/P_Striker_B/Offense/Short/Strikes/LightAttacks/LeftJab", "act/anim/P_Striker_B.act"},
		{Name = "Hook", "/Global/P_Striker_B/Offense/Short/Strikes/LightAttacks/LeftJab/Hook", "act/anim/P_Striker_B.act"},
		{Name = "Heavy Side Punch", "/Global/P_Striker_B/Offense/Short/Strikes/HeavyAttacks/Hook2", "act/anim/P_Striker_B.act"},
		{Name = "Unblockable", "/Global/P_Striker_B/Offense/Short/Strikes/Unblockable/HeavyPunchCharge", "act/anim/P_Striker_B.act"},
		{Name = "Heavy Punch / Combo", "/Global/P_Striker_B/Offense/Short/Grapples/HeavyAttacks/Catch_Throw", "act/anim/P_Striker_B.act"},
		{Name = "Crouch Evade", "/Global/P_Striker_B/Defense/Evade/EvadeBack/EvadeBack", "act/anim/P_Striker_B.act"},
		
		{Name = "- PREPPY (GRAPPLER) -"},
		{Name = "Right Cross", "/Global/P_Grappler_A/Offense/Short/Strikes/HeavyAttacks/RightCross", "Act/Anim/P_Grappler_A.act"},
		{Name = "Left Down", "/Global/P_Grappler_A/Offense/Short/Strikes/HeavyAttacks/RightCross/LeftDown", "Act/Anim/P_Grappler_A.act"},
		{Name = "Left Jab Head", "/Global/P_Grappler_A/Offense/Short/Strikes/LightAttacks/LeftJabHead", "Act/Anim/P_Grappler_A.act"},
		{Name = "Left Jab Body", "/Global/P_Grappler_A/Offense/Short/Strikes/LightAttacks/LeftJabHead/LeftJabBody", "Act/Anim/P_Grappler_A.act"},
		{Name = "Unblockable Punch", "/Global/P_Grappler_A/Offense/Short/Strikes/Unblockable/HeavyPunchCharge", "act/anim/P_Grappler_A.act"},
		{Name = "Kick", "/Global/P_Grappler_A/Offense/Medium/Strikes/Kick", "act/anim/P_Grappler_A.act"},
		{Name = "Crouch Evade", "/Global/P_Grappler_A/Defense/Evade/EvadeBack/Evade", "act/anim/P_Grappler_A.act"},
		{Name = "Hopback", "/Global/P_Grappler_A/Offense/NonCombatActions/Hopback", "Act/Anim/P_Grappler_A.act"},
		
		{Name = "- GREASER (STRIKER TYPE I) -"},
		{Name = "Right Hook", "/Global/G_Striker_A/Offense/Short/Strikes/LightAttacks/RightHook", "act/anim/G_Striker_A.act"},
		{Name = "Left Hook", "/Global/G_Striker_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook", "act/anim/G_Striker_A.act"},
		{Name = "Finsiher", "/Global/G_Striker_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook/RightStomach", "act/anim/G_Striker_A.act"},
		{Name = "Groundpunch", "/Global/G_Striker_A/Offense/GroundAttack/GroundPunch", "Act/Anim/G_Striker_A.act"},
		{Name = "Hopkick", "/Global/G_Striker_A/Offense/Medium/Strikes/HeavyAttack/KickThrust", "Act/Anim/G_Striker_A.act"},
		{Name = "Rissing Attacks", "/Global/Actions/RisingAttacks/HeavyAttacks/RisingAttacks", "Globals/G_Striker_A.act"},
		{Name = "Grabknees (F)", "/Global/G_Striker_A/Offense/Short/Strikes/HeavyAttacks/HeavyKick/GrabKnees/GV", "act/anim/G_Striker_A.act"},
		{Name = "Heavy Knee", "/Global/G_Striker_A/Offense/Short/Strikes/HeavyAttacks/HeavyKnee", "Act/Anim/G_Striker_A.act"},
		{Name = "3 Punch Taunt", "/Global/G_Striker_A/Offense/Taunts/Taunt_A", "act/anim/G_Striker_A.act"},
		{Name = "Hopkick taunt", "/Global/G_Striker_A/Offense/Taunts/Taunt_B", "act/anim/G_Striker_A.act"},
		
		{Name = "- GREASER (STRIKER TYPE II) -"},
		{Name = "Right Hook", "/Global/G_Melee_A/Offense/Short/Strikes/LightAttacks/RightHook", "act/anim/G_Melee_A.act"},
		{Name = "Left Hook", "/Global/G_Melee_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook", "act/anim/G_Melee_A.act"},
		{Name = "Finisher", "/Global/G_Melee_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook/RightStomach", "act/anim/G_Melee_A.act"},
		{Name = "Groundpunch", "/Global/G_Melee_A/Offense/GroundAttack/GroundPunch", "act/anim/G_Melee_A.act"},
		{Name = "Takedown (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleOpps/Melee/Greaser/Takedown", "Act/Anim/G_Melee_A.act"},
		{Name = "Grabknees (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleOpps/Melee/Greaser/GrabKnees/GV","Globals/G_Melee_A.act"},
		{Name = "Dash Punch", "/Global/G_Melee_A/Offense/Medium/Strikes/HeavyAttacks", "act/anim/G_Melee_A.act"},
		{Name = "Inverted Roundhouse", "/Global/G_Melee_A/Offense/Medium/Strikes/HeavyAttacks/HeavyKick", "act/anim/G_Melee_A.act"},
		{Name = "Sloppy Kick", "/Global/G_Melee_A/Offense/Short/Strikes/HeavyAttacks", "act/anim/G_Melee_A.act"},
		{Name = "Dash Punch Taunt", "/Global/G_Melee_A/Offense/Taunts/Taunt_B", "act/anim/G_Melee_A.act"},
		
		{Name = "- GREASER (GRAPLLER) -"},
		{Name = "Right Hook", "/Global/G_Grappler_A/Offense/Short/Strikes/HeavyAttacks/RightHook", "Globals/G_Grappler_A.act"},
		{Name = "Uppercut", "/Global/G_Grappler_A/Offense/Short/Strikes/HeavyAttacks/RightHook/Uppercut", "act/anim/G_Grappler_A.act"},
		{Name = "Bear Hug (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BearHug", "Globals/G_Grappler_A.act"},
		{Name = "Boot Kick", "/Global/G_Grappler_A/Offense/Short/Strikes/HeavyAttacks/BootKick", "act/anim/G_Grappler_A.act"},
		
		{Name = "- GREASER (RANGED) -"},
		{Name = "Right Hook", "/Global/G_Ranged_A/Offense/Short/Strikes/LightAttacks/RightHook", "act/anim/G_Ranged_A.act"},
		{Name = "Knee Kick", "/Global/G_Ranged_A/Offense/Short/Strikes/LightAttacks/RightHook/HeavyKnee", "act/anim/G_Ranged_A.act"},
		{Name = "Heavy Knee", "/Global/G_Ranged_A/Offense/Medium/Strikes/HeavyAttacks/HeavyKnee", "act/anim/G_Ranged_A.act"},
		
		{Name = "- NERD (STRIKER TYPE I) -"},
		{Name = "Jab", "/Global/N_Striker_A/Offense/Short/Strikes/LightAttacks/NerdJab", "act/anim/N_Striker_A.act"},
		{Name = "Hook", "/Global/N_Striker_A/Offense/Short/Strikes/LightAttacks/NerdJab/NerdHook", "act/anim/N_Striker_A.act"},
		{Name = "Fat Slap", "/Global/N_Striker_A/Offense/Short/Strikes/HeavyAttacks/FatSlap", "act/anim/N_Striker_A.act"},
		{Name = "Body Shoulder", "/Global/N_Striker_A/Offense/Short/Strikes/HeavyAttacks/FatSlap/AssThrust", "act/anim/N_Striker_A.act"},
		
		{Name = "- NERD (STRIKER TYPE II) -"},
		{Name = "Jab", "/Global/N_Striker_B/Offense/Short/Strikes/LightAttacks/NerdJab", "act/anim/N_Striker_B.act"},
		{Name = "Hook", "/Global/N_Striker_B/Offense/Short/Strikes/LightAttacks/NerdJab/NerdHook", "act/anim/N_Striker_B.act"},
		{Name = "Random Punches", "/Global/N_Striker_B/Offense/Short/Strikes/HeavyAttacks/Flail", "act/anim/N_Striker_B.act"},
		
		{Name = "- NERD (RANGED) -"},
		{Name = "Jab", "/Global/N_Ranged_A/Offense/Short/Strikes/LightAttacks/NerdJab", "act/anim/N_Ranged_A.act"},
		{Name = "Hook", "/Global/N_Ranged_A/Offense/Short/Strikes/LightAttacks/NerdJab/NerdHook", "act/anim/N_Ranged_A.act"},
		{Name = "Trip Attack", "/Global/N_Ranged_A/Offense/Medium/Strikes/HeavyAttacks", "act/anim/N_Ranged_A.act"},
		{Name = "Random Punches", "/Global/N_Ranged_A/Defense/Flail", "act/anim/N_Ranged_A.act"},
		
		{Name = "- JOCK (STRIKER TYPE I) -"},
		{Name = "Jab", "/Global/J_Striker_A/Offense/Short/Strikes/LightAttacks/JAB", "act/anim/J_Striker_A.act"},
		{Name = "Elbow", "/Global/J_Striker_A/Offense/Short/Strikes/LightAttacks/JAB/Elbow", "act/anim/J_Striker_A.act"},
		{Name = "Uppercut", "/Global/J_Striker_A/Offense/Short/Strikes/LightAttacks/JAB/Elbow/HeavyAttacks/Uppercut", "act/anim/J_Striker_A.act"},
		{Name = "Grapple", "/Global/J_Striker_A/Offense/Medium/Grapples/GrapplesAttempt", "Act/Anim/J_Striker_A.act"},
		{Name = "Face Punch (M)", "/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Jock/FacePunch", "act/anim/J_Striker_A.act"},
		{Name = "Knee Drop (M)", "/Global/Actions/Grapples/Front/Grapples/Mount/MountOpps/Jock/KneeDrop", "act/anim/J_Striker_A.act"},
		
		{Name = "- JOCK (STRIKER TYPE II) -"},
		{Name = "Right Punch", "/Global/J_Melee_A/Offense/Short/Strikes/LightAttacks/RightHand", "act/anim/J_Melee_A.act"},
		{Name = "Left Punch", "/Global/J_Melee_A/Offense/Short/Strikes/LightAttacks/RightHand/LeftHand", "act/anim/J_Melee_A.act"},
		{Name = "Heavy Punch", "/Global/J_Melee_A/Offense/Medium/Strikes/HeavyAttacks/HeavyRight", "act/anim/J_Melee_A.act"},
		
		{Name = "- JOCK (GRAPPLER) -"},
		{Name = "Stomatch Punch", "/Global/J_Grappler_A/Offense/Medium/Strikes/HeavyAttacks/RightPunch", "act/anim/J_Grappler_A.act"},
		{Name = "Axe Handle", "/Global/J_Grappler_A/Offense/Medium/Strikes/HeavyAttacks/RightPunch/Axehandle", "act/anim/J_Grappler_A.act"},
		{Name = "Back Breaker (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BackBreaker", "Globals/J_Grappler_A.act"},
		{Name = "Body Slam (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BodySlam", "Globals/J_Grappler_A.act"},
		
		{Name = "- MASCOT -"},
		{Name = "Right Punch", "/Global/J_Mascot/Offense/Medium/Strikes/LightAttacks/WindMill_R", "act/anim/J_Mascot.act"},
		{Name = "Left Punch", "/Global/J_Mascot/Offense/Medium/Strikes/LightAttacks/WindMill_R/WindMill_L", "act/anim/J_Mascot.act"},
		{Name = "Swing Punch", "/Global/J_Mascot/Offense/Medium/Strikes/LightAttacks/WindMill_R/HeavyAttacks/SwingPunch_R", "act/anim/J_Mascot.act"},
		{Name = "Running Headbutt", "/Global/J_Mascot/Offense/Special/Mascot/Mascot/SpecialChoose/Headbutt/Invincible/Headbutt/HeadButt_AnticStart", "act/anim/J_Mascot.act"},
		{Name = "Dance", "/Global/J_Mascot/Offense/Dance/Dancing", "act/anim/J_Mascot.act"},
		
		{Name = "- DROPOUT (STRIKER) -"},
		{Name = "Punch", "/Global/DO_Striker_A/Offense/Short/LightAttacks/Punch1", "Act/Anim/DO_Edgar.act"},
		{Name = "Knee Kick", "/Global/DO_Striker_A/Offense/Short/LightAttacks/Punch1/Punch2", "Act/Anim/DO_Edgar.act"},
		{Name = "Double Axe Handle", "/Global/DO_Striker_A/Offense/Short/LightAttacks/Punch1/Punch2/HeavyAttacks/Punch3", "Act/Anim/DO_Edgar.act"},
		{Name = "Lariat", "/Global/DO_Striker_A/Offense/Medium/HeavyAttacks/OverhandSwing", "Act/Anim/DO_Striker_A.act"},
		{Name = "Headbutt (M)", "/Global/Actions/Grapples/Mount/GrappleMoves/Headbutt", "Globals/DO_Striker_A.act"},
		
		{Name = "- DROPOUT (GRAPPLER) -"},
		{Name = "Headbutt (M)", "/Global/Actions/Grapples/Mount/MountOpps/Dropout/HeadButt", "Globals/DO_Grappler_A.act"},
		{Name = "Kneedrop (M)", "/Global/Actions/Grapples/Mount/MountOpps/Dropout/KneeDrop", "Globals/DO_Grappler_A.act"},
		
		{Name = "- CIVILIAN MALE -"},
		{Name = "Jab", "/Global/CV_Male_A/Offense/Short/LightAttacks/SloppyJAB", "act/anim/CV_Male_A.act"},
		{Name = "Cross", "/Global/CV_Male_A/Offense/Short/LightAttacks/SloppyJAB/SloppyCross", "act/anim/CV_Male_A.act"},
		{Name = "Slap", "/Global/CV_Male_A/Defense/Counter/Counter", "act/anim/CV_Male_A.act"},
		{Name = "Takedown (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/Adult_Takedown", "Act/Globals.act"},
		
		{Name = "- CIVILIAN FEMALE -"},
		{Name = "Slap", "/Global/CV_Female_A/Offense/Short/LightAttacks/Slap", "act/anim/CV_Female_A.act"},
		{Name = "Groin Knee", "/Global/CV_Female_A/Offense/Short/HeavyAttacks/NutKick", "act/anim/CV_Female_A.act"},
		
		{Name = "- ASYLUM PATIENT -"},
		{Name = "Right Punch", "/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R", "act/anim/Crazy_Basic.act"},
		{Name = "Left Punch", "/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R/WindMill_L", "act/anim/Crazy_Basic.act"},
		{Name = "Swing Punch", "/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R/WindMill_L/HeavyAttacks/SwingPunch_R", "act/anim/Crazy_Basic.act"},
		{Name = "Blood Sucker", "/Global/Crazy_Basic/Offense/Medium/GrapplesNEW/GrapplesAttempt", "Act/Anim/Crazy_Basic.act"},
		
		{Name = "- MALE -"},
		{Name = "Jab", "/Global/GS_Male_A/Offense/Short/LightAttacks/SloppyJAB", "act/anim/GS_Male_A.act"},
		{Name = "Cross", "/Global/GS_Male_A/Offense/Short/LightAttacks/SloppyJAB/SloppyCross", "act/anim/GS_Male_A.act"},
		{Name = "Shove 2 Hands", "/Global/GS_Male_A/Offense/Short/HeavyAttacks/Shove2Hand", "act/anim/GS_Male_A.act"},
		
		{Name = "- FEMALE -"},
		{Name = "Slap", "/Global/GS_Female_A/Offense/Short/Strikes/LightAttacks/Slap", "act/anim/GS_Female_A.act"},
		{Name = "Groin Knee", "/Global/GS_Female_A/Offense/Short/Strikes/HeavyAttacks/NutKick", "act/anim/GS_Female_A.act"},
		{Name = "Girl Fight (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GirlFight/GirlFight_START", "Act/Globals.act"},
		
		{Name = "- SIAMESE -"},
		{Name = "Slap", "/Global/TO_Siamese/Offense/Short/LightAttacks/Slap", "act/anim/TO_Siamese.act"},
		{Name = "Groin Knee", "/Global/TO_Siamese/Offense/Short/HeavyAttacks", "act/anim/TO_Siamese.act"},
		
		{Name = "- AUTHORITY -"},
		{Name = "Slap Counter", "/Global/Authority/Defense/Counter/Counter", "Act/Anim/Authority.act"},
		{Name = "Grapple Counter", "/Global/Authority/Defense/Counter/Grapple", "Act/Anim/Authority.act"},
		{Name = "Ear Grab (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/EarGrab", "act/anim/Authority.act"},
		{Name = "Busting (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/Tonfa_Impale/TonfaImpale", "Globals/Authority.act"},
		{Name = "Takedown (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/Busted/GIVE", "Globals/Authority.act"},
		
		{Name = "- GENERAL -"},
		{Name = "Running Punch", "/Global/Actions/Offense/RunningAttacks/RunningAttacksDirect", "Globals/GlobalActions.act"},
		{Name = "Running Headbutt", "/Global/Player/Attacks/Strikes/RunningAttacks/HeavyAttacks/RunShoulder", "act/anim/Player.act"},
		{Name = "Running Takedown", "/Global/Actions/Grapples/RunningTakedown", "Act/Globals.act"},
		{Name = "Grapple Attempt", "/Global/Actions/Grapples/Front/Grapples/GrappleAttempt", "Act/Globals.act"}, 
		{Name = "Humiliate (F)", "/Global/Ambient/SocialAnims/SocialHumiliateAttack/AnimLoadTrigger", "Act/Anim/Ambient.act"},
		{Name = "Tandem Grapple (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/TandemGrapple", "Act/Globals.act"},
		{Name = "Punch 1 (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GrappleStrikes/HitA", "Act/Globals.act"},
		{Name = "Charged Punch 1 (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GrappleStrikes/HitA/Charge/Release", "Act/Globals.act"},
		{Name = "Punch 2 (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GrappleStrikes/HitB", "Act/Globals.act"},
		{Name = "Charged Punch 2 (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GrappleStrikes/HitB/Charge/Release", "Act/Globals.act"},
		{Name = "Knee (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GrappleStrikes/HitC", "Act/Globals.act"},
		{Name = "Charged Knee (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/GrappleStrikes/HitC/Charge/Release", "Act/Globals.act"},
		{Name = "Push Forward (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleOpps/Default/DirectionalPush/PushFwd", "Act/Globals.act"},
		{Name = "Grapple Break (F)", "/Global/Actions/Grapples/GrappleReversals/StandingReversals/GrappleBreak/Break_GIVE", "Act/Globals.act"},
		{Name = "Grapple Choke (F)", "/Global/WrestlingACT/Attacks/Grapples/Grapples/BackGrapples/Choke", "Act/Anim/WrestlingACT.act"},
		--{Name = "Mount Break (M)", "/Global/Actions/Grapples/GrappleReversals/MountReversals/Pushoff/GIVE", "Act/Globals.act"},
		--{Name = "Counter Mount (M)", "/Global/Actions/Grapples/GrappleReversals/MountReversals/MountReversalToPunch/GIVE", "Act/Globals.act"},
		{Name = "Steal Weapon (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/WeaponSteal", "Act/Globals.act"},
		{Name = "Steal Kick (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/WeaponSteal/Steal/Give", "Act/Globals.act"},
		{Name = "Wall Smash (F)", "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/WallSmash", "Act/Globals.act"},
	}},
	{Name = "Alliance", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				if Select == 2 or Select == 3 then
					Sub.Data[Select].Func()
				else
					while not IsMenuTrackbar(Sub.Data[Select].Name) do
						Select = Select - 1
					end
					local Min, Current, Max = GetMenuTrackbarValues(Sub.Data[Select].Name)
					Sub.Data[Select].Func(Current)
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- FOLLOWER -"},
		{Name = "Recruit", Func = function()
			SetQueuedMessage("WHO'S THE FOLLOWER?", [[
				Pick someone to be a loyal sidekick. They'll follow their leader around and maybe even help if they feel like it.
				Press ~t~ to confirm.
				Press ~t~ to cancel.
			]], -1, {
				GetHudTexture('Button_Left_Mouse_Button'),
				GetHudTexture('Button_Right_Mouse_Button')
			})
			local Follower = SelectPed(false, true)
			StopQueueMessage()
			
			if not PedIsValid(Follower) then
				return
			end
			SetQueuedMessage("WHO'S IN CHARGE?", [[
				Now choose the boss. The follower will stick to them like glue... until they get bored or get punched in the face.
				Press ~t~ to confirm.
				Press ~t~ to cancel.
			]], -1, {
				GetHudTexture('Button_Left_Mouse_Button'),
				GetHudTexture('Button_Right_Mouse_Button')
			})
			local Leader = SelectPed(true, true)
			StopQueueMessage()
			
			-- the recruitment is cancelled
			if not PedIsValid(Leader) then
				return
			end
			
			-- human error:
			if not PedIsValid(Follower) then
				SetQueuedMessage('TOO LATE', 'That potential follower wandered off... Turns out they have a life too. Try to be quicker next time.', 4)
				return
			end
			if Follower == Leader then
				SetQueuedMessage('THE SAME PERSON?', "So... they're trying to follow themself who's leading themself while following themself. That’s a paradox, and illegal.", 4)
				return
			end
			
			if PedIsValid(Follower) and PedIsValid(Leader) and (not PedHasAllyFollower(Leader) or not IsAlreadyAlly(Leader, Follower)) then
				SetAlly(Leader, Follower, true)
			end
		end},
		{Name = "Dismiss", Func = function()
			SetQueuedMessage("WHO'S ABOUT TO BE KICKED?", [[
				Pick someone who's following a leader. They'll stop tagging along and go back to doing... whatever they were doing.
				Press ~t~ to confirm.
				Press ~t~ to cancel.
			]], -1, {
				GetHudTexture('Button_Left_Mouse_Button'),
				GetHudTexture('Button_Right_Mouse_Button')
			})
			
			local Follower = SelectPed(false, true)
			if PedIsValid(Follower) then
				PedDismissAlly(PedGetAllyLeader(Follower), Follower)
			end
			StopQueueMessage()
		end},
		
		{Name = "- BULLY -"},
		{Name = "0="..GetFactionRespect(11).."=100", Func = function(Value)
			SetFactionRespect(11, Value)
			PedSetDefaultTypeToTypeAttitude(11, 13, math.floor(Value / 25))
		end},
		{Name = "Set Bullies Respect"},
		
		{Name = "- PREP -"},
		{Name = "0="..GetFactionRespect(5).."=100", Func = function(Value)
			SetFactionRespect(5, Value)
			PedSetDefaultTypeToTypeAttitude(5, 13, math.floor(Value / 25))
		end},
		{Name = "Set Preppies Respect"},
		
		{Name = "- GREASER -"},
		{Name = "0="..GetFactionRespect(4).."=100", Func = function(Value)
			SetFactionRespect(4, Value)
			PedSetDefaultTypeToTypeAttitude(4, 13, math.floor(Value / 25))
		end},
		{Name = "Set Greasers Respect"},
		
		{Name = "- NERD -"},
		{Name = "0="..GetFactionRespect(1).."=100", Func = function(Value)
			SetFactionRespect(1, Value)
			PedSetDefaultTypeToTypeAttitude(1, 13, math.floor(Value / 25))
		end},
		{Name = "Set Nerds Respect"},
		
		{Name = "- JOCK -"},
		{Name = "0="..GetFactionRespect(2).."=100", Func = function(Value)
			SetFactionRespect(2, Value)
			PedSetDefaultTypeToTypeAttitude(2, 13, math.floor(Value / 25))
		end},
		{Name = "Set Jocks Respect"},
		
		{Name = "- DROPOUT -"},
		{Name = "0="..GetFactionRespect(3).."=100", Func = function(Value)
			SetFactionRespect(3, Value)
			PedSetDefaultTypeToTypeAttitude(3, 13, math.floor(Value / 25))
		end},
		{Name = "Set Dropouts Respect"},
		
		{Name = "- PREFECT -"},
		{Name = "0="..GetFactionRespect(0).."=100", Func = function(Value)
			SetFactionRespect(0, Value)
			PedSetDefaultTypeToTypeAttitude(0, 13, math.floor(Value / 25))
		end},
		{Name = "Set Prefects Respect"},
		
		{Name = "- TEACHER -"},
		{Name = "0="..GetFactionRespect(8).."=100", Func = function(Value)
			SetFactionRespect(8, Value)
			PedSetDefaultTypeToTypeAttitude(8, 13, math.floor(Value / 25))
		end},
		{Name = "Set Teachers Respect"},
		
		{Name = "- COP -"},
		{Name = "0="..GetFactionRespect(7).."=100", Func = function(Value)
			SetFactionRespect(7, Value)
			PedSetDefaultTypeToTypeAttitude(7, 13, math.floor(Value / 25))
		end},
		{Name = "Set Cops Respect"},
		
		{Name = "- ADULTS -"},
		{Name = "0="..GetFactionRespect(9).."=100", Func = function(Value)
			SetFactionRespect(9, Value)
			PedSetDefaultTypeToTypeAttitude(9, 13, math.floor(Value / 25))
		end},
		{Name = "Set Adults Respect"},
		
		{Name = "- MERCHANT -"},
		{Name = "0="..GetFactionRespect(10).."=100", Func = function(Value)
			SetFactionRespect(10, Value)
			PedSetDefaultTypeToTypeAttitude(10, 13, math.floor(Value / 25))
		end},
		{Name = "Set Merchants Respect"},
	}},
	{Name = "Status", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Ped = string.find(Sub.Data[Select].Name, 'Player') and gPlayer or SelectPed(false)
				if PedIsValid(Ped) then
					while not IsMenuTrackbar(Sub.Data[Select].Name) do
						Select = Select - 1
					end
					
					local Min, Current, Max = GetMenuTrackbarValues(Sub.Data[Select].Name)
					Sub.Data[Select].Func(Ped, Current)
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- HEALTH POINTS -"},
		{Name = "0=200=10000", Func = function(Ped, Value)
			PedSetMaxHealth(Ped, Value)
			PedSetHealth(Ped, Value)
		end},
		{Name = "Change Player Health"},
		{Name = "Change NPC Health"},
		
		{Name = "- PUNISHMENT POINTS -"},
		{Name = "0=150=300", Func = function(Ped, Value)
			PedSetPunishmentPoints(Ped, Value)
		end},
		{Name = "Set Player Points"},
		{Name = "Set NPC Points"},
		
		{Name = "- ANIMATION SPEED -"},
		{Name = "0=100=500", Func = function(Ped, Value)
			GameSetPedStat(Ped, 20, Value)
		end},
		{Name = "Change Player Speed"},
		{Name = "Change NPC Speed"},
		
		{Name = "- WEAPON DAMAGE SCALE -"},
		{Name = "0=100=5000", Func = function(Ped, Value)
			GameSetPedStat(Ped, 31, Value)
		end},
		{Name = "Set Player WDS"},
		{Name = "Set NPC WDS"},
		
		{Name = "- MONEY -"},
		{Name = "0=100=99999", Func = function(Ped, Value)
			if Ped == gPlayer then
				PlayerSetMoney(0)
				PlayerAddMoney(Value * 100, true)
			else
				PedSetMoney(Value * 100)
			end
		end},
		{Name = "Set Player Money"},
		{Name = "Set NPC Money"},
		
		{Name = "- PLAYER TOGGLE -"},
		{Name = "Immortal=(XO)", XO = PlayerSettings.Immortal, Func = function(Boolean)
			PlayerSettings.Immortal = Boolean
			if not Boolean then
				PedSetFlag(gPlayer, 58, false)
			end
		end},
		{Name = "Infinite Ammo=(XO)", XO = PlayerSettings.InfiniteAmmo, Func = function(Boolean)
			PlayerSettings.InfiniteAmmo = Boolean
			if not Boolean then
				PedSetFlag(gPlayer, 24, false)
			end
		end},
		{Name = "Invisible=(XO)", XO = PlayerSettings.Invisible, Func = function(Boolean)
			PlayerSettings.Invisible = Boolean
			if not Boolean then
				PedSetFlag(gPlayer, 9, false)
			end
		end},
		{Name = "Lethal Hit=(XO)", XO = PlayerSettings.LethalHit, Func = function(Boolean)
			PlayerSettings.LethalHit = Boolean
		end},
		{Name = "Innocent=(XO)", XO = PlayerSettings.Innocent, Func = function(Boolean)
			PlayerSettings.Innocent = Boolean
			if not Boolean then
				DisablePunishmentSystem(false)
				PedSetFlag(gPlayer, 117, true)
			end
		end},
		{Name = "Free Shop=(XO)", XO = PlayerSettings.FreeShop, Func = function(Boolean)
			PlayerSettings.FreeShop = Boolean
		end},
	}},
	{Name = "Existence", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
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
		{Name = "- GENERAL -"},
		{Name = "NPC Population=(XO)", XO = NPCSettings.Population, Func = function(Boolean)
			NPCSettings.Population = Boolean
			if NPCSettings.Population then
				StopPedProduction(false)
			end
		end},
		
		{Name = "- PERSONAL -"},
		{Name = "Force Knocked Out", Func = function()
			local Ped = SelectPed(true)
			if PedIsValid(Ped) then
				PedApplyDamage(Ped, PedGetMaxHealth(Ped) + 100)
			end
		end},
		{Name = "Force Delete", Func = function()
			local Ped = SelectPed(false)
			if PedIsValid(Ped) then
				PedDelete(Ped)
			end
		end},
	}},
	{Name = "Mind", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
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
		{Name = "- MIND -"},
		{Name = "Control", Func = function()
			local Ped = SelectPed(false)
			if not PedIsValid(Ped) then
				return
			end
			
			-- setup
			local Name = GetLocalizedText(string.upper(PedGetName(Ped)))
			local Style = {PedGetActionTree(Ped)}
			local Faction = PedGetFaction(Ped)
			
			PedSetControllerID(Ped, 0)
			PedStop(Ped)
			PedLockTarget(Ped, -1)
			PedSetActionTree(Ped, '/Global/Player', 'Act/Player.act')
			PedSetAITree(Ped, '/Global/PlayerAI', 'Act/PlayerAI.act')
			PedSetFaction(Ped, 13)
			
			CameraFollowPed(Ped)
			SoundSetAudioFocusCamera()
			
			PedSetActionNode(gPlayer, unpack(PlayerSettings.Style))
			PedSetFlag(gPlayer, 87, true)
			SetPointerStatus(0)
			
			-- ped's behavior
			local Control = function()
				if not PedMePlaying(Ped, 'DEFAULT_KEY') or PedIsInAnyVehicle(Ped) then
					return
				end
				
				if PedHasWeapon(Ped, 328) or PedHasWeapon(Ped, 426) then
					PlayerLockButtonInputsExcept(true, 0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 24)
					if CameraGetActive() == 13 or CameraGetActive() == 2 then
						CameraSetActive(1, 0.5, false)
					end
				else
					PlayerLockButtonInputsExcept(false)
				end
				if PedGetWeapon(Ped) ~= PedGetWeapon(gPlayer) then
					PedSetWeapon(Ped, PedGetWeapon(gPlayer) == 437 and -1 or PedGetWeapon(gPlayer), 100)
				end
			end
			
			-- info
			SetQueuedMessage('CONTROLLING "'..Name..'"', [[
				Control this puppet to go wherever you want, annoy someone you dislike or troll their gang members.
				Press ~t~ to back.
			]], -1, {GetHudTexture('Button_Q')})
			
			repeat
				if not PedIsValid(Ped) or PedGetHealth(Ped) <= 0 or PedGetHealth(gPlayer) <= 0 then
					break
				end
				
				Control()
				Wait(0)
			until IsKeyBeingReleased('Q')
			
			-- clean up
			StopQueueMessage()
			if PedIsValid(Ped) then
				if PedHasWeapon(Ped, 328) or PedHasWeapon(Ped, 426) then
					PlayerLockButtonInputsExcept(false)
				end
				PedSetControllerID(Ped, -1)
				PedSetFaction(Ped, Faction)
				PedLockTarget(Ped, -1)
				PedSetWeapon(Ped, -1)
				
				if PedGetHealth(Ped) > 0 then
					PedSetActionTree(Ped, unpack(Style))
					PedSetAITree(Ped, '/Global/AI', 'Act/AI/AI.act')
					PedMakeAmbient(Ped)
				else
					PedPlayHitReaction(Ped)
				end
			end
			
			PedSetFlag(gPlayer, 87, false)
			PedSetControllerID(gPlayer, 0)
			SetModel(true, PlayerSettings.Model, PlayerSettings.Style)
			PlayerStopAllActionControllers()
			if string.upper(PlayerSettings.Model) == 'PLAYER' then
				ClothingBuildPlayer()
			end
			PedSetWeapon(gPlayer, -1)
			
			CameraFollowPed(gPlayer)
			SoundSetAudioFocusPlayer()
			if PedGetHealth(gPlayer) < 1 then
				PedPlayHitReaction(gPlayer)
			end
			SetPointerStatus(1)
		end},
		{Name = "Provoke", Func = function()
			SetQueuedMessage('SELECTING THE PROVOCATEUR', [[
				The Provocateur is an NPC that will attack the selected target. Move your cursor and point at the provocateur's bounding box.
				Press ~t~ to confirm.
				Press ~t~ to cancel.
			]], -1, {
				GetHudTexture('Button_Left_Mouse_Button'), 
				GetHudTexture('Button_Right_Mouse_Button')
			})
			
			local Provocateur = SelectPed(false, true)
			StopQueueMessage()
			
			if not PedIsValid(Provocateur) then
				return
			end
			SetQueuedMessage('SELECTING THE TARGET', [[
				Choose a Target for the Provocateur to attack. Move your cursor and point at the provoked party's bounding box.
				Press ~t~ to confirm.
				Press ~t~ to cancel.
			]], -1, {
				GetHudTexture('Button_Left_Mouse_Button'), 
				GetHudTexture('Button_Right_Mouse_Button')
			})
			
			local Target = SelectPed(true, true)
			StopQueueMessage()
			
			-- cancelled
			if not PedIsValid(Target) then
				return
			end
			
			-- human error
			if not PedIsValid(Provocateur) then
				SetQueuedMessage('TOO LATE', 'That provocateur wandered off... Turns out they have a life too. Try to be quicker next time.', 4)
				return
			end
			if Target == Provocateur then
				SetQueuedMessage('THE SAME PERSON?', "So... they're trying to provoke themself and wanting to attack themself. Next time, pick someone else.", 4)
				return
			end
			
			PedStop(Provocateur)
			PedClearObjectives(Provocateur)
			
			if Target ~= gPlayer then
				PedStop(Target)
				PedClearObjectives(Target)
				
				if PedGetFaction(Provocateur) == PedGetFaction(Target) then
					PedSetPedToTypeAttitude(Provocateur, PedGetFaction(Target), 3)
					PedSetPedToTypeAttitude(Target, PedGetFaction(Provocateur), 3)
					
					PedSetEmotionTowardsPed(Provocateur, Target, 0)
					PedSetEmotionTowardsPed(Target, Provocateur, 0)
				end
				
				PedAttack(Provocateur, Target, 2)
				PedAttack(Target, Provocateur, 2)
				return
			end
			if PedGetPedToTypeAttitude(Provocateur, 13) == 4 then
				PedSetPedToTypeAttitude(Provocateur, 13, 0)
				PedSetEmotionTowardsPed(Provocateur, Target, 0)
			end
			
			PedAttackPlayer(Provocateur, 2)
		end},
	}},
}})
