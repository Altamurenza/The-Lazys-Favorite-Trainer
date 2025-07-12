-- WORLD.LUA
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
	{Name = "Atmosphere", Option = 1, Func = function(Selects)
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
				local Func = GetHeader(Select) == 'SEASON' and ChapterSet or WeatherSet
				Func(Sub.Data[Select].Code)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- SEASON -"},
		{Name = "Autumn", Code = 1},
		{Name = "Winter", Code = 2},
		{Name = "Spring", Code = 4},
		{Name = "Summer", Code = 6},
		
		{Name = "- WEATHER -"},
		{Name = "Sunny", Code = 0},
		{Name = "Moody", Code = 1},
		{Name = "Rainy", Code = 2},
		{Name = "Cloudy", Code = 3},
		{Name = "Normal", Code = 4},
		{Name = "Storm", Code = 5},
		{Name = "Fog", Code = 6},
	}},
	{Name = 'Time', Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				while not IsMenuTrackbar(Sub.Data[Select].Name) do
					Select = Select - 1
				end
				local Min, Current, Max = GetMenuTrackbarValues(Sub.Data[Select].Name)
				Sub.Data[Select].Func(Current)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- HOUR -"},
		{Name = "0="..ClockGet().."=23", Func = function(Value)
			ClockSet(Value, 0)
		end},
		{Name = "Set Hour"},
		
		{Name = "- MINUTE -"},
		{Name = "0="..GetArguments(2, ClockGet()).."=59", Func = function(Value)
			ClockSet(ClockGet(), Value)
		end},
		{Name = "Set Minute"},
		
		{Name = "- CLOCK STATUS -"},
		{Name = "Pause Clock=(XO)", XO = PlayerSettings.PauseClock, Func = function(Boolean)
			PlayerSettings.PauseClock = Boolean
			if not Boolean then
				UnpauseGameClock()
			end
		end},
	}},
	{Name = 'Location', Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and not AreaIsLoading() and IsMenuPressed(0) then
				if Sub.Data[Select].Code[1] == 16 then
					Import = 'Tattoos'
				end
				CreateThread(function(Loc)
					AreaTransitionXYZ(unpack(Loc))
				end, Sub.Data[Select].Code)
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- DISTRICT -"},
		{Name = "Bullworth Town", Code = {0,521.8,-89.4,3.7}},
		{Name = "New Conventry", Code = {0,498.2,-239.6,1.9}},
		{Name = "Bullworth Vale", Code = {0,370.1,413.2,21.0}},
		{Name = "Blue Skies", Code = {0,323.7,-436.9,3.1}},
		
		{Name = "- SCHOOL -"},
		{Name = "Boys' Dorm", Code = {14,-496.6,310.6,31.3}},
		{Name = "Girls' Dorm", Code = {35,-439,311,-7}},
		{Name = "Grounds", Code = {0,271,-73,6}},
		{Name = "Hallways", Code = {2,-628.4,-312.5,-0.0}},
		{Name = "Field", Code = {0,-27.9,-73.7,1.0}},
		{Name = "Balcony", Code = {0,164.1,-73.8,14.8}},
		{Name = "Basement", Code = {8,-756.9,-56.2,9.3}},
		{Name = "Auditorium", Code = {19,-769.2,311.1,77.2}},
		{Name = "Class Room", Code = {15,-557.2,317.1,-1.9}},
		{Name = "Biology Class", Code = {6,-702.8,312.3,33.3}},
		{Name = "Chemistry Class", Code = {4,-596,322,36}},
		{Name = "Principal Office", Code = {5,-700,201,32}},
		{Name = "Library", Code = {9,-773.6,203.0,90.1}},
		{Name = "Autoshop", Code = {18,-418.4,380.0,80.9}},
		{Name = "Parking Lot", Code = {0,186.5,-3.0,5.4}},
		{Name = "Harrington House", Code = {32,-565.4 ,133.2 ,46.1}},
		{Name = "Harrington Yard", Code = {0,135.5,-131.7,6.8}},
		{Name = "Gym", Code = {13,-619.0,-59.5,59.6}},
		{Name = "Pool", Code = {13,-676.0,-58.6,55.4}},
		
		{Name = "- FACTION HEADQUARTER -"},
		{Name = "Preppies", Code = {60,-774.3,355.2,6.4}},
		{Name = "Nerds", Code = {30,-726.0,34.2,-2.3}},
		{Name = "Jocks", Code = {59,-749.4,352.2,3.5}},
		{Name = "Greasers", Code = {61,-694.6,346.4,3.2}},
		{Name = "Townies", Code = {57,-656.8,248.8,15.2}},
		
		{Name = "- CARNIVAL -"},
		{Name = "Carnival", Code = {0,188.2,438.3,5.3}},
		{Name = "Prize Tent", Code = {50,-792.6,47.9,6.6}},
		{Name = "Freak Show", Code = {55,-469.4,-71.4,9.7}},
		{Name = "Funhouse", Code = {37,-711,-537,8}},
		{Name = "GoKart Track", Code = {42,-381.9,483.4,1.5}},
		{Name = "Strike Out", Code = {45,-793,90,9}},
		{Name = "Shooting Range", Code = {45,-790,73,9}},
		
		{Name = "- BOXING -"},
		{Name = "Boxing Club", Code = {27,-732.2,378.4,298.0}},
		{Name = "Boxing Ring", Code = {27,-712.3,376.9,295.0}},
		
		{Name = "- BEACH -"},
		{Name = "Southern Beach", Code = {0,283,273,3}},
		{Name = "Eastern Beach", Code = {0,406,73,3}},
		
		{Name = "- ASYLUM -"},
		{Name = "Grounds", Code = {0,-57.0,-312.1,4.3}},
		{Name = "Interior", Code = {38,-735.1,468.8,1.9}},
		
		{Name = "- MISSION SPECIFIC -"},
		{Name = "Tad House", Code = {0,443.5,505.9,22.9}},
		{Name = "Tenements", Code = {36,-544,-44,31}},
		{Name = "Junk Yard", Code = {43,-736.5,-624.6,3.2}},
		{Name = "Observatory Exterior", Code = {0,33,-134,8}},
		{Name = "Observatory Interior", Code = {40,-696.5,74.9,20.2}},
		{Name = "Chem Plant Exterior", Code = {0,53.7,-582.3,32.4}},
		{Name = "Chem Plant Interior", Code = {0,113,-510,2}},
		
		{Name = "- STORE -"},
		{Name = "Yum Yum Market", Code = {26,-573.3,388.5,0.0}},
		{Name = "Worn In Store", Code = {34,-647.1,258.5,0.9}},
		{Name = "Aquaberry Fashions", Code = {33,-708.3,260.0,0.0}},
		{Name = "Shiny Bikes", Code = {29,-785.6,379.6,0.0}},
		{Name = "Dragon's Wing Store", Code = {30,-726.1,14.0,-0.0}},
		{Name = "Tattoo Shop", Code = {16,-655.8,82.6,0.2}},
		
		{Name = "- BARBER -"},
		{Name = "Bullworth Vale Haircuts", Code = {46,-768.5,23.2,2.9}},
		{Name = "The Final Cut", Code = {56,-666.0,389.3,2.4}},
		{Name = "The Happy Mullet", Code = {39,-654.9,126.0,2.9}},
		
		{Name = "- PARK -"},
		{Name = "Bullworth Park", Code = {0,438.5,389.2,17.2}},
		{Name = "BMX Park", Code = {62,-749.2,637.1,30.9}},
		
		{Name = "- ARCADE -"},
		{Name = "Track 1", Code = {51,-5.6,66.2,27.1}},
		{Name = "Track 2", Code = {52,46.6,-23.7,0.9}},
		{Name = "Track 3", Code = {53,0.8,60.1,62.6}},
		
		{Name = "- MISCELLANEOUS -"},
		{Name = "Grave Yard", Code = {0,637,168,19}},
		{Name = "Nursing Home", Code = {0,536.0,374.3,17.1}},
		{Name = "Dike", Code = {0,647.7,83.4,8.5}},
		{Name = "City Hall Rooftop", Code = {0,647,-87,28}},
		{Name = "Pirate Ship", Code = {0,31,190,3}},
		
		{Name = "- UNUSED -"},
		{Name = "Photography MP", Code = {18,-403.8,363.5,81.2}},
		{Name = "Unnamed Minigame 1", Code = {45,-811,73,9}},
		{Name = "Unnamed Minigame 2", Code = {45,-831,73,9}},
		{Name = "Unnamed Minigame 3", Code = {45,-850,73,9}},
		{Name = "Unnamed Minigame 4", Code = {45,-869,73,9}},
		{Name = "Unnamed Minigame 5", Code = {45,-890,73,9}},
		{Name = "Island 3", Code = {22,-72.5,15.6,26.0}},
		{Name = "Test Area", Code = {31,-26.0,-17.5,15.3}},
	}},
	{Name = 'Event', Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and not AreaIsLoading() and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- EVENT: "..string.upper(Selected.Name).." -"},
					{Name = "Create Event Properties", Func = function(Code)
						for _, Entity in ipairs(Code) do
							AreaLoadSpecialEntities(Entity, true)
						end
					end},
					{Name = "Remove Event Properties", Func = function(Code)
						for _, Entity in ipairs(Code) do
							AreaLoadSpecialEntities(Entity, false)
						end
					end},
				}
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						Table[Select].Func(Selected.Code)
						AreaEnsureSpecialEntitiesAreCreated()
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
		{Name = "- SCHOOL AREA -"},
		{Name = "The Candidate", Code = {"vote"}},
		{Name = "Halloween", Code = {"Halloween1", "Halloween2", "Halloween3", "TombstonePost", "PumpkinPost"}},
		{Name = "School Christmas", Code = {"Christmas"}},
		{Name = "Nutcrackin", Code = {"Nutcracker"}},
		{Name = "Discreet Deliveries", Code = {"delivery"}},
		
		{Name = "- CARNIVAL -"},
		{Name = "Small Offences", Code = {"2s07"}},
		
		{Name = "- BULLWORTH TOWN -"},
		{Name = "Rudy the Red Nosed Santa", Code = {"Rudy1", "Rudy2", "Rudy3"}},
		{Name = "Miracle on Bullworth St.", Code = {"Miracle"}},
		
		{Name = "- OLD BULLWORTH TOWN -"},
		{Name = "Race the Vale", Code = {"RL_rich1"}},
	}},
}})