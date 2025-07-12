-- FASHION.LUA
-- AUTHOR	: ALTAMURENZA


local Path = debug.getinfo(1, 'S').source
local Name = string.gsub(GetFileName(Path), '^%d+%s%-%s', '')
local Icon = Name

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
	{Name = "Head", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {}
				table.insert(Table, {Name = "- HEAD: "..string.upper(Selected.Name).." -"})
				table.insert(Table, {Name = "Change Headwear", Func = function()
					if GetCutsceneRunning() ~= 0 then
						SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
						return
					end
					if not PedIsModel(gPlayer, 0) then
						SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
						return
					end
					ClothingSetPlayer(0, Selected.Code)
					ClothingBuildPlayer()
				end})
				if Select > 2 then
					table.insert(Table, {Name = "Store to Wardrobe", Func = function()
						ClothingGivePlayer(Selected.Code, 0)
					end})
				end
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
		{Name = "- DEFAULT -"},
		{Name = "Hair", Code = "Hair"},
		
		{Name = "- RICH -"},
		{Name = "Luxury Stud Hat Black", Code = "R_Hat3"},
		{Name = "Luxury Stud Hat Brown", Code = "R_Hat2"},
		{Name = "Luxury Stud Hat Gray", Code = "R_Hat1"},
		{Name = "Panama Hat", Code = "R_Hat4"},
		{Name = "Porkpie Hat", Code = "R_Hat5"},
		{Name = "Top Hat", Code = "R_Hat6"},
		
		{Name = "- POOR -"},
		{Name = "Army Bucket Hat", Code = "P_Army2"},
		{Name = "Army Cap", Code = "P_Army1"},
		{Name = "Army Wool Hat", Code = "P_Army3"},
		{Name = "Bandana Black", Code = "P_Bandana3"},
		{Name = "Bandana Blue", Code = "P_Bandana1"},
		{Name = "Bandana Red", Code = "P_Bandana2"},
		{Name = "Cap Black & Red", Code = "P_BHat6"},
		{Name = "Cap Blue", Code = "P_BHat1"},
		{Name = "Cap Purple & Black", Code = "P_BHat2"},
		{Name = "Cap Red & Tan", Code = "P_BHat3"},
		{Name = "Cap White & Black", Code = "P_BHat4"},
		{Name = "Cap Yellow & Black", Code = "P_BHat5"},
		
		{Name = "- CARNIVAL -"},
		{Name = "Angelic Halo", Code = "C_AngelHalo"},
		{Name = "Checkered Party Hat", Code = "C_CanadaHat"},
		{Name = "Clown Wig", Code = "C_ClownWig"},
		{Name = "Devil Horns", Code = "C_DevilHorns"},
		{Name = "Strange Hat", Code = "C_StrangeHat"},
		
		{Name = "- BULLWORTH -"},
		{Name = "Ball Cap Black", Code = "B_BHat2"},
		{Name = "Ball Cap Blue & White", Code = "B_BHat1"},
		{Name = "Ball Cap Quartered", Code = "B_BHat4"},
		{Name = "Ball Cap White", Code = "B_BHat3"},
		{Name = "Ball Cap White & Blue", Code = "B_BHat6"},
		{Name = "Ball Cap White & Green", Code = "B_BHat5"},
		{Name = "Beach Bucket Hat", Code = "B_Bucket1"},
		{Name = "Cowboy Hat Brown", Code = "B_Various5"},
		{Name = "Lumberjack Hat", Code = "B_Various1"},
		{Name = "Newsie Hat", Code = "B_Hunter1"},
		{Name = "Old Time Racing Hat", Code = "B_Hunter2"},
		{Name = "Shortbeacked Hat", Code = "B_Various2"},
		{Name = "Tradesman Cap Blue", Code = "B_Various3"},
		{Name = "Tradesman Cap Brown", Code = "B_Various4"},
		{Name = "Unionist Hat", Code = "B_Hunter3"},
		{Name = "Urban Bucket Hat", Code = "B_Bucket2"},
		
		{Name = "- SCHOOL -"},
		{Name = "Bullworth Cap Classic", Code = "S_BHat1"},
		{Name = "Bullworth Cap Green", Code = "S_BHat3"},
		{Name = "Bullworth Cap Team", Code = "S_BHat2"},
		{Name = "Bullworth Visor Classic", Code = "S_Sunvisor1"},
		{Name = "Bullworth Visor Green", Code = "S_Sunvisor3"},
		{Name = "Bullworth Visor Red", Code = "S_Sunvisor2"},
		
		{Name = "- SPECIAL -"},
		{Name = "80's Rocker", Code = "SP_80Rocker_H"},
		{Name = "Alien Mask", Code = "SP_Alien_H"},
		{Name = "BMX Helmet", Code = "SP_BMXhelmet"},
		{Name = "Bandit Mask", Code = "SP_Zorromask"},
		{Name = "Bass Hat", Code = "SP_Basshat"},
		{Name = "Bike Helmet", Code = "SP_BikeHelmet"},
		{Name = "Black Ninja Mask", Code = "SP_Ninja_H"},
		{Name = "Burns & Shades", Code = "SP_Goldsuit_H"},
		{Name = "Cowboy Hat Black", Code = "SP_Cowboyhat"},
		{Name = "Dunce Cap", Code = "SP_Duncehat"},
		{Name = "Edna Mask", Code = "SP_EdnaMask"},
		{Name = "Eiffel Tower Hat", Code = "SP_EiffelHat"},
		{Name = "Elf Hat", Code = "SP_Elf_H"},
		{Name = "Explorer Hat", Code = "SP_Colum_H"},
		{Name = "Firefighter Helmet", Code = "SP_Firehat"},
		{Name = "Frice Headpiece", Code = "SP_Fries_H"},
		{Name = "Genius Hat", Code = "SP_Einstein"},
		{Name = "Gnome Hat", Code = "SP_Gnome_H"},
		{Name = "Graduation Hat", Code = "SP_MortarBhat"},
		{Name = "Green Ninja Mask", Code = "SP_NinjaW_H"},
		{Name = "Hazmat Headgear", Code = "SP_Hazmat"},
		{Name = "Incognito Hat", Code = "SP_GymDisguise"},
		{Name = "Marching Band Hat", Code = "SP_MBand_H"},
		{Name = "Mascot Head", Code = "SP_Mascot_H"},
		{Name = "Nerd Glasses", Code = "SP_Nerd_H"},
		{Name = "Nutcracker Hat", Code = "SP_Nutcrack_H"},
		{Name = "Panda Head", Code = "SP_Panda_H"},
		{Name = "Pig Head", Code = "SP_PigMask"},
		{Name = "Pirate Hat", Code = "SP_PirateHat"},
		{Name = "Pith Helmet", Code = "SP_PithHelmet"},
		{Name = "Pumpkin Head", Code = "SP_Pumpkin_head"},
		{Name = "Racing Hat", Code = "SP_Nascar_H"},
		{Name = "Red Ninja Mask", Code = "SP_NinjaR_H"},
		{Name = "Reindeer Antlers", Code = "SP_Antlers"},
		{Name = "Skull Mask", Code = "SP_Ween_H"},
		{Name = "Two Can Hat", Code = "SP_Pophat"},
		{Name = "Viking Helmet Plastic", Code = "SP_VHelmet"},
		{Name = "Werewolf Mask", Code = "SP_Werewolf"},
		{Name = "Wrestling Helmet", Code = "SP_Wrestling_H"},
		{Name = "Crash Helmet", Code = "SP_GK_Helmet"},
	}},
	{Name = "Torso", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- TORSO: "..string.upper(Selected.Name).." -"},
					{Name = "Change Topwear", Func = function()
						if GetCutsceneRunning() ~= 0 then
							SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
							return
						end
						if not PedIsModel(gPlayer, 0) then
							SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
							return
						end
						ClothingSetPlayer(1, Selected.Code)
						ClothingBuildPlayer()
					end},
					{Name = "Store to Wardrobe", Func = function()
						ClothingGivePlayer(Selected.Code, 1)
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
		{Name = "- RICH -"},
		{Name = "AB Casual Polo Black", Code = "R_SSleeves4"},
		{Name = "AB Casual Polo Blue", Code = "R_SSleeves6"},
		{Name = "AB Casual Polo Brown", Code = "R_SSleeves5"},
		{Name = "Aquaberry Shirt", Code = "R_LSleeves1"},
		{Name = "Aquaberry Sweater", Code = "R_Sweater5"},
		{Name = "Aquaberry Vest", Code = "R_Sweater1"},
		{Name = "Duffel Coat", Code = "R_Jacket2"},
		{Name = "LS Casual Jacket", Code = "R_Jacket5"},
		{Name = "LS Training Jacket", Code = "R_Sweater4"},
		{Name = "Lambswool V-Neck Sweater", Code = "R_Sweater3"},
		{Name = "Rough 'n Rich Shirt Blue", Code = "R_SSleeves2"},
		{Name = "Rough 'n Rich Shirt White", Code = "R_SSleeves1"},
		{Name = "Tuxedo Jacket", Code = "R_Jacket1"},
		{Name = "Urban Parade Sweater", Code = "R_Sweater2"},
		{Name = "Zip Sewater Crimson", Code = "R_LSleeves2"},
		{Name = "Zip Sweater Coal", Code = "R_LSleeves5"},
		{Name = "Zip Sweater Forest", Code = "R_LSleeves4"},
		
		{Name = "- POOR -"},
		{Name = "Arctic Camo Jacket", Code = "P_Jacket5"},
		{Name = "Army Jacket", Code = "P_Jacket4"},
		{Name = "Army Sweater Black", Code = "P_Sweater3"},
		{Name = "Army Sweater Green", Code = "P_Sweater2"},
		{Name = "Black Bomber Jacket", Code = "P_Jacket1"},
		{Name = "Creepy Clown T-Shirt", Code = "P_SSleeves2"},
		{Name = "Fool Hammer T-Shirt", Code = "P_SSleeves5"},
		{Name = "Forest Camo Jacket", Code = "P_Jacket6"},
		{Name = "Hoodie Black", Code = "P_Sweater4"},
		{Name = "Hoodie Blue", Code = "P_Sweater5"},
		{Name = "Hoodie Gray", Code = "P_Sweater6"},
		{Name = "Leather Jacket", Code = "P_Jacket2"},
		{Name = "Long T-Shirt Black", Code = "P_LSleeves7"},
		{Name = "Long T-Shirt Dark Blue", Code = "P_LSleeves2"},
		{Name = "Long T-Shirt Gray", Code = "P_LSleeves8"},
		{Name = "Long T-Shirt Green", Code = "P_LSleeves6"},
		{Name = "Long T-Shirt Light Blue", Code = "P_LSleeves3"},
		{Name = "Long T-Shirt Red", Code = "P_LSleeves4"},
		{Name = "Long T-Shirt White", Code = "P_LSleeves1"},
		{Name = "Long T-Shirt Yellow", Code = "P_LSleeves5"},
		{Name = "Metal T-Shirt", Code = "P_SSleeves1"},
		{Name = "New Flannel Shirt", Code = "P_LSleeves9"},
		{Name = "Old School Punk Vest", Code = "P_Jacket3"},
		{Name = "Punk Hoodie", Code = "P_Sweater1"},
		{Name = "Rock On Shirt", Code = "P_Sweater7"},
		{Name = "Rocker Hoodie", Code = "P_Sweater8"},
		{Name = "T-Shirt Black", Code = "P_SSleeves9"},
		{Name = "T-Shirt Blue", Code = "P_SSleeves4"},
		{Name = "T-Shirt Gray", Code = "P_SSleeves10"},
		{Name = "T-Shirt Green", Code = "P_SSleeves8"},
		{Name = "T-Shirt Red", Code = "P_SSleeves6"},
		{Name = "T-Shirt White", Code = "P_SSleeves3"},
		{Name = "T-Shirt Yellow", Code = "P_SSleeves7"},
		{Name = "Undershirt Black", Code = "P_SSleeves12"},
		{Name = "Undershirt Blue", Code = "P_SSleeves13"},
		{Name = "Undershirt Gray", Code = "P_SSleeves14"},
		{Name = "Undershirt White", Code = "P_SSleeves11"},
		{Name = "Worn Flannel Shirt", Code = "P_LSleeves10"},
		
		{Name = "- CARNIVAL -"},
		{Name = "Stupid T-Shirt", Code = "C_StpdShrt"},
		
		{Name = "- BULLWORTH -"},
		{Name = "68 Long T-Shirt", Code = "B_LSleeves3"},
		{Name = "Black Hooded Jacket", Code = "B_Jacket2"},
		{Name = "Bright Side Baseball Jersey", Code = "B_Jersey1"},
		{Name = "Brown Jacket", Code = "B_Jacket6"},
		{Name = "Conduct Hoodie", Code = "B_Sweater4"},
		{Name = "Dark Side Baseball Jersey", Code = "B_SSleeves1"},
		{Name = "Football Jersey Black", Code = "B_Jersey8"},
		{Name = "Football Jersey Green", Code = "B_Jersey7"},
		{Name = "Green Bomber Jacket", Code = "B_Jacket1"},
		{Name = "Hawaiian Shirt", Code = "B_SSleeves3"},
		{Name = "Hockey Jersey Black", Code = "B_Jersey10"},
		{Name = "Hockey Jersey Blue", Code = "B_Jersey9"},
		{Name = "Jean Jacket", Code = "B_Jacket3"},
		{Name = "Lips Long T-Shirt", Code = "B_LSleeves2"},
		{Name = "Rugby Jersey Celt", Code = "B_Jersey6"},
		{Name = "Rugby Jersey LB", Code = "B_Jersey5"},
		{Name = "Sevener Black Hoodie", Code = "B_Sweater3"},
		{Name = "Soccer Polo Emerald", Code = "B_Jersey4"},
		{Name = "Soccer Polo Snow", Code = "B_Jersey3"},
		{Name = "Tiki Shirt", Code = "B_SSleeves2"},
		{Name = "Urban Sports Long T-Shirt", Code = "B_LSleeves4"},
		{Name = "Zip Up Black Hoodie", Code = "B_Sweater2"},
		
		{Name = "- SCHOOL -"},
		{Name = "Astronomy Club Vest", Code = "S_Sweater1"},
		{Name = "Bullworth Hoodie Blue", Code = "S_LSleeves2"},
		{Name = "Bullworth Hoodie Gray", Code = "S_LSleeves1"},
		{Name = "Bullworth Letterman Jacket", Code = "S_Jacket3"},
		{Name = "Bullworth Sport Jacket", Code = "S_Jacket4"},
		{Name = "Bullworth Vest", Code = "S_Sweater5"},
		{Name = "School Sweater", Code = "S_Sweater2"},
		{Name = "Team Zip-Up", Code = "S_LSleeves3"},
		{Name = "Team Zip-Up Green", Code = "S_LSleeves4"},
		
		{Name = "- SPECIAL -"},
		{Name = "80's Rocket Coat", Code = "SP_80Rocker_T"},
		{Name = "Alien Shirt", Code = "SP_Alien_T"},
		{Name = "Band Shirt", Code = "SP_BandShirt"},
		{Name = "Bike Jersey", Code = "SP_BikeJersey"},
		{Name = "Black Ninja Jacket", Code = "SP_Ninja_T"},
		{Name = "Boxing Tank Top", Code = "SP_Boxing_T"},
		{Name = "Cheerful Reindeer Sweater", Code = "SP_XmsSweater"},
		{Name = "Elf Jacket", Code = "SP_Elf_T"},
		{Name = "Explorer Coat", Code = "SP_Colum_T"},
		{Name = "Glamor Jacket", Code = "SP_Goldsuit_T"},
		{Name = "Gnome Tunic", Code = "SP_Gnome_T"},
		{Name = "Green Ninja Jacket", Code = "SP_NinjaW_T"},
		{Name = "Gym Shirt", Code = "SP_Wrestling_T"},
		{Name = "Hip 2B Squared Shirt", Code = "SP_HipShirt"},
		{Name = "Marching Band Coat", Code = "SP_MBand_T"},
		{Name = "Math Shirt", Code = "SP_MathShirt"},
		{Name = "Minimum Wage Shirt", Code = "SP_Fries_T"},
		{Name = "Muscle Shirt", Code = "SP_MuscleShirt"},
		{Name = "Music Jammie Shirt", Code = "SP_MusicPJ_T"},
		{Name = "Music Keys Shirt", Code = "SP_MusicShirt"},
		{Name = "Nerd Shirt", Code = "SP_Nerd_T"},
		{Name = "Nutcracker Jacket", Code = "SP_Nutcrack_T"},
		{Name = "Orderly Shirt", Code = "SP_Orderly_T"},
		{Name = "Prison Shirt", Code = "SP_Prison_T"},
		{Name = "Racing Shirt", Code = "SP_Nascar_T"},
		{Name = "Red Ninja Jacket", Code = "SP_NinjaR_T"},
		{Name = "Shut Your Pi Hole Shirt", Code = "SP_PieShirt"},
		{Name = "Skeleton Shirt", Code = "SP_Ween_T"},
		{Name = "Skull Jammie Shirt", Code = "SP_PJ_T"},
	}},
	{Name = "Left Hand", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {}
				table.insert(Table, {Name = "- LEFT HAND: "..string.upper(Selected.Name).." -"})
				table.insert(Table, {Name = "Change Accessory", Func = function()
					if GetCutsceneRunning() ~= 0 then
						SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
						return
					end
					if not PedIsModel(gPlayer, 0) then
						SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
						return
					end
					ClothingSetPlayer(2, Selected.Code)
					ClothingBuildPlayer()
				end})
				if Select > 2 then
					table.insert(Table, {Name = "Store to Wardrobe", Func = function()
						ClothingGivePlayer(Selected.Code, 2)
					end})
				end
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
		{Name = "- DEFAULT -"},
		{Name = "No Accessory", Code = "none"},
		
		{Name = "- RICH -"},
		{Name = "Aquaberry Watch Gold", Code = "R_Watch1"},
		{Name = "Aquaberry Watch Silver", Code = "R_Watch3"},
		{Name = "Aquaberry Watch Steel", Code = "R_Watch2"},
		{Name = "Aquaberry Watch White Gold", Code = "R_Watch4"},
		
		{Name = "- POOR -"},
		{Name = "Cheap Digital Watch", Code = "P_Watch1"},
		
		{Name = "- CARNIVAL -"},
		{Name = "Novelty Watch", Code = "C_PinkWatch"},
		
		{Name = "- SCHOOL -"},
		{Name = "Team Sweatband Blue", Code = "S_Wristband1"},
		{Name = "Team Sweatband Red", Code = "S_Wristband4"},
		{Name = "Team Sweatband White", Code = "S_Wristband6"},
		
		{Name = "- SPECIAL -"},
		{Name = "Boxing Glove", Code = "SP_Boxing_G_L"},
	}},
	{Name = "Right Hand", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {}
				table.insert(Table, {Name = "- RIGHT HAND: "..string.upper(Selected.Name).." -"})
				table.insert(Table, {Name = "Change Accessory", Func = function()
					if GetCutsceneRunning() ~= 0 then
						SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
						return
					end
					if not PedIsModel(gPlayer, 0) then
						SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
						return
					end
					ClothingSetPlayer(3, Selected.Code)
					ClothingBuildPlayer()
				end})
				if Select > 2 then
					table.insert(Table, {Name = "Store to Wardrobe", Func = function()
						ClothingGivePlayer(Selected.Code, 3)
					end})
				end
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
		{Name = "- DEFAULT -"},
		{Name = "No Accessory", Code = "none"},
		
		{Name = "- RICH -"},
		{Name = "Bracelet Gold", Code = "R_Wristband1"},
		{Name = "Bracelet Onyx", Code = "R_Wristband4"},
		{Name = "Bracelet Silver", Code = "R_Wristband2"},
		{Name = "Bracelet Steel", Code = "R_Wristband3"},
		
		{Name = "- POOR -"},
		{Name = "Black Bracelet", Code = "P_Wristband8"},
		{Name = "Black Restraint Brace", Code = "P_Wristband7"},
		{Name = "Leather Archer Brace", Code = "P_Wristband6"},
		{Name = "Narrow Studded Punk Brace", Code = "P_Wristband2"},
		{Name = "Red Bandana", Code = "P_Wristband1"},
		{Name = "Spiky Studded Punk Brace", Code = "P_Wristband5"},
		{Name = "Square Studded Brace", Code = "P_Wristband3"},
		{Name = "Wide Studded Punk Brace", Code = "P_Wristband4"},
		
		{Name = "- BULLWORTH -"},
		{Name = "Good Luck Wrist Band", Code = "B_Wristband1"},
		{Name = "Wide Wrist Band Black", Code = "B_Wristband2"},
		{Name = "Wide Wrist Band Brown", Code = "B_Wristband3"},
		{Name = "Wristband Black", Code = "B_Wristband4"},
		{Name = "Wristband Brown", Code = "B_Wristband5"},
		
		{Name = "- SCHOOL -"},
		{Name = "Team Sweatband Blue", Code = "S_Wristband2"},
		{Name = "Team Sweatband Red", Code = "S_Wristband3"},
		{Name = "Team Sweatband White", Code = "S_Wristband5"},
		
		{Name = "- SPECIAL -"},
		{Name = "Boxing Glove", Code = "SP_Boxing_G_R"},
		{Name = "Nerd Watch", Code = "SP_NerdWatch"},
	}},
	{Name = "Legs", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- LEGS: "..string.upper(Selected.Name).." -"},
					{Name = "Change Legwear", Func = function()
						if GetCutsceneRunning() ~= 0 then
							SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
							return
						end
						if not PedIsModel(gPlayer, 0) then
							SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
							return
						end
						ClothingSetPlayer(4, Selected.Code)
						ClothingBuildPlayer()
					end},
					{Name = "Store to Wardrobe", Func = function()
						ClothingGivePlayer(Selected.Code, 4)
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
		{Name = "- RICH -"},
		{Name = "Aquaberry Slacks Cream", Code = "R_Pants5"},
		{Name = "Aquaberry Slacks Slate", Code = "R_Pants4"},
		{Name = "LS Casual Pants Black", Code = "R_Pants3"},
		{Name = "LS Casual Pants Gray", Code = "R_Pants2"},
		{Name = "RnR Shorts Black", Code = "R_Shorts1"},
		{Name = "RnR Shorts Blue", Code = "R_Shorts5"},
		{Name = "RnR Shorts Burgundy", Code = "R_Shorts2"},
		{Name = "RnR Shorts Green", Code = "R_Shorts3"},
		{Name = "RnR Shorts Tan", Code = "R_Shorts4"},
		{Name = "Tuxedo Pants", Code = "R_Pants1"},
		
		{Name = "- POOR -"},
		{Name = "Black Cargo Pants", Code = "P_Pants5"},
		{Name = "Forest Camo Cargo Pants", Code = "P_Pants6"},
		{Name = "High Cuffed Jeans", Code = "P_Pants3"},
		{Name = "Jogging Pants", Code = "P_Pants7"},
		{Name = "Pistol Pants", Code = "P_Pants4"},
		{Name = "Plaid Punk Pants", Code = "P_Pants1"},
		{Name = "Ripped Jeans", Code = "P_Pants2"},
		
		{Name = "- CARNIVAL -"},
		{Name = "Clown Pants", Code = "C_ClownPants"},
		
		{Name = "- BULLWORTH -"},
		{Name = "3/4 Shorts Black", Code = "B_Shorts7"},
		{Name = "3/4 Shorts Brown", Code = "B_Shorts6"},
		{Name = "3/4 Shorts Tan", Code = "B_Shorts2"},
		{Name = "Army Cargo Pants", Code = "B_Pants1"},
		{Name = "Beach Shorts", Code = "B_Shorts1"},
		{Name = "Cargo Shorts", Code = "B_Shorts3"},
		{Name = "Crisp Jeans", Code = "B_Pants4"},
		{Name = "Desert Cargo Pants", Code = "B_Pants8"},
		{Name = "Jeans Casual", Code = "B_Pants2"},
		{Name = "Ratty Jeans", Code = "B_Pants3"},
		{Name = "Soccer Shorts Emerald", Code = "B_Shorts5"},
		{Name = "Soccer Shorts Snow", Code = "B_Shorts4"},
		{Name = "Track Pants Black", Code = "B_Pants7"},
		{Name = "Track Pants Green", Code = "B_Pants6"},
		
		{Name = "- SCHOOL -"},
		{Name = "Bullworth Gym Pants", Code = "S_Pants3"},
		{Name = "Bullworth Gym Shorts Blue", Code = "S_Shorts4"},
		{Name = "Bullworth Gym Shorts Red", Code = "S_Shorts6"},
		{Name = "Bullworth Gym Shorts White", Code = "S_Shorts5"},
		{Name = "School Shorts", Code = "S_Shorts1"},
		{Name = "School Slacks", Code = "S_Pants1"},
		
		{Name = "- SPECIAL -"},
		{Name = "80's Rocker Pants", Code = "SP_80Rocker_L"},
		{Name = "Alien Pants", Code = "SP_Alien_L"},
		{Name = "Bike Shorts", Code = "SP_BikeShorts"},
		{Name = "Black Ninja Pants", Code = "SP_Ninja_L"},
		{Name = "Boxing Shorts", Code = "SP_Boxing_L"},
		{Name = "Elf Pants", Code = "SP_Elf_L"},
		{Name = "Explorer Pants", Code = "SP_Colum_L"},
		{Name = "Glamor Pants", Code = "SP_Goldsuit_L"},
		{Name = "Gnome Trousers", Code = "SP_Gnome_L"},
		{Name = "Green Ninja Pants", Code = "SP_NinjaW_L"},
		{Name = "Gym Shorts", Code = "SP_Wrestling_L"},
		{Name = "Marching Band Pants", Code = "SP_MBand_L"},
		{Name = "Minimum Wage Pants", Code = "SP_Fries_L"},
		{Name = "Music Jammie Pants", Code = "SP_MusicPJ_L"},
		{Name = "Nerd Slacks", Code = "SP_Nerd_L"},
		{Name = "Nutcracker Pants", Code = "SP_Nutcrack_L"},
		{Name = "Orderly Pants", Code = "SP_Orderly_P"},
		{Name = "Prison Pants", Code = "SP_Prison_L"},
		{Name = "Racing Pants", Code = "SP_Nascar_L"},
		{Name = "Red Ninja Pants", Code = "SP_NinjaR_L"},
		{Name = "Running Shorts", Code = "SP_Shorts"},
		{Name = "Skeleton Pants", Code = "SP_Ween_L"},
		{Name = "Tightic Whities", Code = "SP_Briefs"},
		{Name = "Tiny Swimsuit", Code = "SP_Swimsuit"},
		{Name = "Jammie Pants", Code = "SP_PJ_L"},
	}},
	{Name = "Feet", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- FEET: "..string.upper(Selected.Name).." -"},
					{Name = "Change Footwear", Func = function()
						if GetCutsceneRunning() ~= 0 then
							SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
							return
						end
						if not PedIsModel(gPlayer, 0) then
							SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
							return
						end
						ClothingSetPlayer(5, Selected.Code)
						ClothingBuildPlayer()
					end},
					{Name = "Store to Wardrobe", Func = function()
						ClothingGivePlayer(Selected.Code, 5)
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
		{Name = "- RICH -"},
		{Name = "Aquaberry Boots", Code = "R_Boots2"},
		{Name = "Aquaberry Loafers", Code = "R_Sneakers4"},
		{Name = "Country Boots", Code = "R_Boots3"},
		{Name = "Italian Shoes", Code = "R_Sneakers1"},
		{Name = "LS Casual Moccasins", Code = "R_Sneakers2"},
		{Name = "LS Casual Sneakers", Code = "R_Sneakers3"},
		{Name = "RnR Suede Sneakers", Code = "R_Sneakers5"},
		
		{Name = "- POOR -"},
		{Name = "Army Boots", Code = "P_Boots4"},
		{Name = "Blue Runners", Code = "P_Sneakers16"},
		{Name = "Brown Runners", Code = "P_Sneakers18"},
		{Name = "Classic White Sneakers", Code = "P_Sneakers2"},
		{Name = "Fat Sneakers Black & Red", Code = "P_Sneakers17"},
		{Name = "Fat Sneakers Black & White", Code = "P_Sneakers9"},
		{Name = "Fat Sneakers Gray", Code = "P_Sneakers14"},
		{Name = "Fat Sneakers Gray & White", Code = "P_Sneakers10"},
		{Name = "Fat Sneakers Red & Gold", Code = "P_Sneakers15"},
		{Name = "Low Tops Black", Code = "P_Sneakers3"},
		{Name = "Low Tops Brown", Code = "P_Sneakers7"},
		{Name = "Low Tops Gray", Code = "P_Sneakers4"},
		{Name = "Low Tops Green", Code = "P_Sneakers5"},
		{Name = "Low Tops Red", Code = "P_Sneakers6"},
		{Name = "Motorcycle Boots", Code = "P_Boots3"},
		{Name = "Old Worn Boots", Code = "P_Boots1"},
		{Name = "Shiny White Sneakers", Code = "P_Sneakers8"},
		{Name = "Skate Shoes Black", Code = "P_Sneakers19"},
		{Name = "Skate Shoes Brown & Tan", Code = "P_Sneakers13"},
		{Name = "Skate Shoes Green", Code = "P_Sneakers11"},
		{Name = "Skate Shoes Red", Code = "P_Sneakers12"},
		{Name = "White B-Ball Shoes", Code = "P_Sneakers1"},
		{Name = "Work Boots", Code = "P_Boots2"},
		
		{Name = "- CARNIVAL -"},
		{Name = "Clown Shoes", Code = "C_ClownShoes"},
		
		{Name = "- BULLWORTH -"},
		{Name = "Brown Loafers", Code = "B_Sneakers3"},
		{Name = "Budget Basketball Sneaks", Code = "B_Sneakers12"},
		{Name = "Country Shoes", Code = "B_Sneakers2"},
		{Name = "Cowboy Boots", Code = "B_Boots2"},
		{Name = "Fancy Angst Boots", Code = "B_Boots1"},
		{Name = "Fashion Boots Brown", Code = "B_Boots4"},
		{Name = "Fashion Boots Tan", Code = "B_Boots3"},
		{Name = "Riot Shoes Black", Code = "B_Sneakers10"},
		{Name = "Riot Shoes Caramel", Code = "B_Sneakers8"},
		{Name = "Riot Shoes Chocolate", Code = "B_Sneakers9"},
		{Name = "Riot Shoes Classic", Code = "B_Sneakers6"},
		{Name = "Skate Shoes Black", Code = "B_Sneakers1"},
		{Name = "Urban Loafers Black", Code = "B_Sneakers5"},
		{Name = "Urban Loafers Brown", Code = "B_Sneakers4"},
		{Name = "Urban Walker Canvas", Code = "B_Sneakers13"},
		{Name = "Urban Walker Classic", Code = "B_Sneakers11"},
		{Name = "Workman Boots", Code = "B_Boots5"},
		
		{Name = "- SCHOOL -"},
		{Name = "Cheap Dress Shoes", Code = "S_Sneakers2"},
		{Name = "Gym Shoes", Code = "S_Sneakers1"},
		
		{Name = "- SPECIAL -"},
		{Name = "80's Rocker Boots", Code = "SP_80Rocker_FT"},
		{Name = "Black Ninja Socks", Code = "SP_Ninja_FT"},
		{Name = "Boxing Boots", Code = "SP_Boxing_ft"},
		{Name = "Elf Boots", Code = "SP_Elf_FT"},
		{Name = "Explorer Shoes", Code = "SP_Colum_FT"},
		{Name = "Glamor Shoes", Code = "SP_Goldsuit_ft"},
		{Name = "Gnome Boots", Code = "SP_Gnome_ft"},
		{Name = "Green Ninja Socks", Code = "SP_NinjaW_FT"},
		{Name = "Marching Band Shoes", Code = "SP_MBand_FT"},
		{Name = "Mascot Boots", Code = "SP_Mascot_B"},
		{Name = "Nerd Shoes", Code = "SP_Nerd_FT"},
		{Name = "Nutcracker Boots", Code = "SP_Nutcrack_FT"},
		{Name = "Orderly Boots", Code = "SP_Orderly_B"},
		{Name = "Panda Boots", Code = "SP_Panda_B"},
		{Name = "Racing Shoes", Code = "SP_Nascar_FT"},
		{Name = "Red Ninja Socks", Code = "SP_NinjaR_FT"},
		{Name = "Socks", Code = "SP_Socks"},
		{Name = "Wrestling Shoes", Code = "SP_Wrestling_ft"},
	}},
	{Name = "Outfit", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- OUTFIT: "..string.upper(Selected.Name).." -"},
					{Name = "Change Outfit", Func = function()
						if GetCutsceneRunning() ~= 0 then
							SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
							return
						end
						if not PedIsModel(gPlayer, 0) then
							SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
							return
						end
						ClothingSetPlayerOutfit(Selected.Code)
						ClothingBuildPlayer()
					end},
					{Name = "Store to Wardrobe", Func = function()
						ClothingGivePlayerOutfit(Selected.Code)
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
		{Name = "- DEFAULT -"},
		{Name = 'Underwear', Code = 'Underwear'},
		{Name = 'Starting', Code = 'Starting'},
		{Name = 'Pajamas', Code = 'PJ'},
		{Name = 'School Uniform', Code = 'Uniform'},
		
		{Name = "- MISSION REWARD -"},
		{Name = 'Skeleton Costume', Code = 'Halloween'},
		{Name = 'Red Ninja', Code = 'Ninja_RED'},
		{Name = 'Wrestling Uniform', Code = 'Wrestling'},
		{Name = 'Boxing', Code = 'Boxing NG'},
		{Name = 'Fast Food Uniform', Code = 'Fast Food'},
		{Name = 'BMX Set', Code = 'BMX Champion'},
		{Name = 'Dodgeball Outfit', Code = 'Gym Strip'},
		{Name = 'Explorer Outfit', Code = 'Columbus'},
		{Name = 'Green Ninja', Code = 'Ninja_WHT'},
		{Name = 'Nutcrackin', Code = 'Nutcracker'},
		{Name = 'Elf Outfit', Code = 'Elf'},
		{Name = 'Nerd', Code = 'NerdJimmy'},
		{Name = 'Alien', Code = 'Alien'},
		{Name = 'Rocker', Code = '80 Rocker'},
		{Name = 'Marching Band', Code = 'Marching Band'},
		{Name = 'Mascot', Code = 'Mascot'},
		{Name = 'Orderly Uniform', Code = 'Orderly'},
		{Name = 'Prisoner', Code = 'Prison'},
		{Name = 'Grotto Master', Code = 'Grotto Master'},
		{Name = 'Gnome', Code = 'Gnome'},
		{Name = 'Black Ninja', Code = 'Ninja_BLK'},
		{Name = 'Gold Suit', Code = 'Gold Suit'},
		
		{Name = "- MISSION ONLY -"},
		{Name = 'Headless Mascot', Code = 'MascotNoHead'},
		{Name = 'Complete Boxing', Code = 'Boxing'},
		
		{Name = "- UNUSED -"},
		{Name = 'Panda', Code = 'Panda'},
		{Name = 'Nascar', Code = 'Nascar'},
	}},
	{Name = "Hairstyle", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				if GetCutsceneRunning() ~= 0 then
					SetQueuedMessage('NOT NOW', "Jimmy's in the middle of something Oscar-worthy. Let him finish.", 4)
				elseif not PedIsModel(gPlayer, 0) then
					SetQueuedMessage("YOU'RE NOT JIMMY", "Unless you're the one and only Jimmy, those fashion choices are locked.", 4)
				else
					ClothingSetPlayersHair(Sub.Data[Select].Code)
					ClothingBuildPlayer()
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- DEFAULT -"},
		{Name = 'Buzz Cut', Code = 'B_Buzz'},
		{Name = 'Bald', Code = 'B_Bald'},
		
		{Name = "- CAESAR -"},
		{Name = 'Copper', Code = 'B_Caesar_01'},
		{Name = 'Auburn', Code = 'B_Caesar_02'},
		{Name = 'Chestnut', Code = 'B_Caesar_03'},
		{Name = 'Chocolate', Code = 'B_Caesar_04'},
		
		{Name = "- CREW CUT -"},
		{Name = 'Copper', Code = 'B_CrewCut_01'},
		{Name = 'Auburn', Code = 'B_CrewCut_02'},
		{Name = 'Chestnut', Code = 'B_CrewCut_03'},
		{Name = 'Chocolate', Code = 'B_CrewCut_04'},
		
		{Name = "- FLAT TOP -"},
		{Name = 'Copper', Code = 'B_FlatTop_01'},
		{Name = 'Auburn', Code = 'B_FlatTop_02'},
		{Name = 'Chestnut', Code = 'B_FlatTop_03'},
		{Name = 'Chocolate', Code = 'B_FlatTop_04'},
		
		{Name = "- FADE -"},
		{Name = 'Copper', Code = 'B_MFade_01'},
		{Name = 'Auburn', Code = 'B_MFade_02'},
		{Name = 'Chestnut', Code = 'B_MFade_03'},
		{Name = 'Chocolate', Code = 'B_MFade_04'},
		
		{Name = "- FAUX HAWK -"},
		{Name = 'Blond', Code = 'P_Fauhawk_01'},
		{Name = 'Light Brown', Code = 'P_Fauhawk_02'},
		{Name = 'Medium Brown', Code = 'P_Fauhawk_03'},
		{Name = 'Black', Code = 'P_Fauhawk_04'},
		
		{Name = "- FLAT HAWK -"},
		{Name = 'Blond', Code = 'P_Mh_Flat_01'},
		{Name = 'Light Brown', Code = 'P_Mh_Flat_02'},
		{Name = 'Medium Brown', Code = 'P_Mh_Flat_03'},
		{Name = 'Black', Code = 'P_Mh_Flat_04'},
		
		{Name = "- SPIKE HAWK -"},
		{Name = 'Blond', Code = 'P_Mh_Spike_01'},
		{Name = 'Green', Code = 'P_Mh_Spike_02'},
		{Name = 'Blue', Code = 'P_Mh_Spike_03'},
		{Name = 'Red', Code = 'P_Mh_Spike_04'},
		
		{Name = "- SPIKES -"},
		{Name = 'Blond', Code = 'P_Spiky_01'},
		{Name = 'Green', Code = 'P_Spiky_02'},
		{Name = 'Blue', Code = 'P_Spiky_03'},
		{Name = 'Red', Code = 'P_Spiky_04'},
		
		{Name = "- TAPER -"},
		{Name = 'Blond', Code = 'P_Taper_01'},
		{Name = 'Light Brown', Code = 'P_Taper_02'},
		{Name = 'Medium Brown', Code = 'P_Taper_03'},
		{Name = 'Black', Code = 'P_Taper_04'},
		
		{Name = "- LIGHNTING -"},
		{Name = 'Blond', Code = 'P_Details1_01'},
		{Name = 'Light Brown', Code = 'P_Details1_02'},
		{Name = 'Medium Brown', Code = 'P_Details1_03'},
		{Name = 'Black', Code = 'P_Details1_04'},
		
		{Name = "- I'M A STAR -"},
		{Name = 'Blond', Code = 'P_Details2_01'},
		{Name = 'Light Brown', Code = 'P_Details2_02'},
		{Name = 'Medium Brown', Code = 'P_Details2_03'},
		{Name = 'Black', Code = 'P_Details2_04'},
		
		{Name = "- GOOD BOY -"},
		{Name = 'Copper', Code = 'R_GoodBoy_01'},
		{Name = 'Auburn', Code = 'R_GoodBoy_02'},
		{Name = 'Chestnut', Code = 'R_GoodBoy_03'},
		{Name = 'Chocolate', Code = 'R_GoodBoy_04'},
		
		{Name = "- SMART -"},
		{Name = 'Copper', Code = 'R_SSmart_01'},
		{Name = 'Auburn', Code = 'R_SSmart_02'},
		{Name = 'Chestnut', Code = 'R_SSmart_03'},
		{Name = 'Chocolate', Code = 'R_SSmart_04'},
		
		{Name = "- HOLLYWOOD -"},
		{Name = 'Copper', Code = 'R_Hwood_01'},
		{Name = 'Auburn', Code = 'R_Hwood_02'},
		{Name = 'Chestnut', Code = 'R_Hwood_03'},
		{Name = 'Chocolate', Code = 'R_Hwood_04'},
		{Name = 'Copper', Code = 'R_HThrob_01'},
		{Name = 'Auburn', Code = 'R_HThrob_02'},
		{Name = 'Chestnut', Code = 'R_HThrob_03'},
		{Name = 'Chocolate', Code = 'R_HThrob_04'},
		
		{Name = "- IVY LEAGUE -"},
		{Name = 'Copper', Code = 'R_ILeague_01'},
		{Name = 'Auburn', Code = 'R_ILeague_02'},
		{Name = 'Chestnut', Code = 'R_ILeague_03'},
		{Name = 'Chocolate', Code = 'R_ILeague_04'},
		
		{Name = "- SHORT & SHAGGY -"},
		{Name = 'Copper', Code = 'R_SShag_01'},
		{Name = 'Auburn', Code = 'R_SShag_02'},
		{Name = 'Chestnut', Code = 'R_SShag_03'},
		{Name = 'Chocolate', Code = 'R_SShag_04'},
	}},
	{Name = "Settings", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- WARDROBE -"},
		{Name = "Lock Wardrobe=(XO)", XO = false, Func = function(Boolean)
			shared.lockClothingManager = Boolean
		end},
		
		{Name = "- WARDROBE SELECTION -"},
		{Name = "Lock Head=(XO)", XO = false, Func = function(Boolean)
			shared.cm_lockHead = Boolean
		end},
		{Name = "Lock Torso=(XO)", XO = false, Func = function(Boolean)
			shared.cm_lockTorso = Boolean
		end},
		{Name = "Lock Left Hand=(XO)", XO = false, Func = function(Boolean)
			shared.cm_lockLWrist = Boolean
		end},
		{Name = "Lock Right Hand=(XO)", XO = false, Func = function(Boolean)
			shared.cm_lockRWrist = Boolean
		end},
		{Name = "Lock Legs=(XO)", XO = false, Func = function(Boolean)
			shared.cm_lockLegs = Boolean
		end},
		{Name = "Lock Feet=(XO)", XO = false, Func = function(Boolean)
			shared.cm_lockFeet = Boolean
		end},
		{Name = "Lock Outfit=(XO)", XO = false, Func = function(Boolean)
			shared.cm_lockOutfit = Boolean
		end},
	}},
}})