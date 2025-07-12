-- INVENTORY.LUA
-- AUTHOR	: ALTAMURENZA


local Path = debug.getinfo(1, 'S').source
local Name = string.gsub(GetFileName(Path), '^%d+%s%-%s', '')
local Icon = Name

LoadScript('Scripts/Menu/Header/Header_'..Name..'.lua')

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
	{Name = "Weapon", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				if Sub.Data[Select].Func then
					Sub.Data[Select].Func()
				else
					local Selected = Sub.Data[Select]
					local Table = {
						{Name = "- WEAPON: "..string.upper(Selected.Name).." -"},
						{Name = "Set Player Weapon", Func = SetWeapon, Args = {true, Selected.Code}},
						{Name = "Set NPC Weapon", Func = SetWeapon, Args = {false, Selected.Code}},
						{Name = "Create Weapon", Func = CreateWeapon, Args = {Selected.Code}},
					}
					if WeaponGetType(Selected.Code) == 0 then
						local Ammo = ({
							[303] = 'Marble',
							[305] = 'Potato',
							[306] = 'Super Marble',
							[307] = 'Rocket',
							[396] = 'Potato',
						})[Selected.Code] or Selected.Name
						table.insert(Table, {Name = "- PROJECTILE: "..string.upper(Ammo).." -"})
						table.insert(Table, {Name = "Throw Projectile", Func = ThrowProjectile, Args = {Selected.Code}})
					end
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
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- CONSUMABLE -"},
		{Name = "Apple", Code = 310},
		{Name = "Banana", Code = 358},
		
		{Name = "- PRANK -"},
		{Name = "Big Firework", Code = 397},
		{Name = "Dead Rat", Code = 346},
		{Name = "Kick Me", Code = 372},
		{Name = "Poo Bag",Code = 399},
		
		{Name = "- BALL -"},
		{Name = "Baseball", Code = 302},
		{Name = "Basket Ball", Code = 381},
		{Name = "Soccer Ball", Code = 329},
		{Name = "Football", Code = 331},
		{Name = "Football (Bomb)", Code = 400},
		{Name = "Snowball", Code = 313},
		{Name = "Big Snowball", Code = 330},
		
		{Name = "- SCHOOL EQUIPMENT -"},
		{Name = "Book 1", Code = 405},
		{Name = "Book 2", Code = 413},
		{Name = "Book 3", Code = 414},
		{Name = "Book 4", Code = 415},
		{Name = "Book 5", Code = 416},
		{Name = "Vase 1", Code = 354},
		{Name = "Vase 2", Code = 353},
		{Name = "Vase 3", Code = 345},
		{Name = "Dish", Code = 338},
		{Name = "Broom", Code = 377},
		{Name = "Pom-Pom", Code = 341},
		{Name = "Frisbee", Code = 335},
		{Name = "Wood Plank", Code = 323},
		{Name = "Wood Paddle", Code = 357},
		{Name = "Tissue Roll", Code = 403},
		{Name = "Cafeteria Tray", Code = 348},
		{Name = "Fire Extinguisher", Code = 326},
		
		{Name = "- DAILY EQUIPMENT -"},
		{Name = "Umbrella", Code = 404},
		{Name = "Yardstick", Code = 299},
		{Name = "Bat", Code = 300},
		{Name = "Brick", Code = 311},
		{Name = "Trash Lid", Code = 315},
		{Name = "Plate", Code = 355},
		{Name = "Metal Plate", Code = 360},
		
		{Name = "- MISSION EQUIPMENT -"},
		{Name = "Pinky Wand", Code = 410},
		{Name = "Devil Fork", Code = 409},
		{Name = "Whip", Code = 411},
		{Name = "Poison Gun", Code = 395},
		{Name = "Sledge Hammer", Code = 324},
		{Name = "Gold Pipe", Code = 418},
		{Name = "Water Pipe 1", Code = 342},
		{Name = "Water Pipe 2", Code = 402},
		{Name = "Water Pipe 3", Code = 401},
		{Name = "Shield", Code = 387},
		
		{Name = "- INVENTORY -"},
		{Name = "Skateboard", Code = 437},
		{Name = "Camera", Code = 328},
		{Name = "Digital Camera", Code = 426},
		{Name = "Fire Cracker", Code = 301},
		{Name = "Stink Bomb", Code = 309},
		{Name = "Itchy Powder", Code = 394},
		{Name = "Egg", Code = 312},
		{Name = "Marbles", Code = 349},
		{Name = "Spray Can", Code = 321},
		{Name = "Slingshot", Code = 303},
		{Name = "Super Slingshot", Code = 306},
		{Name = "Spud Gun", Code = 305},
		{Name = "Super Spud Gun", Code = 396},
		{Name = "Rocket Launcher", Code = 307},
		{Name = "Rubber Band", Code = 325},
		{Name = "News Roll", Code = 320},
		{Name = "Flashlight", Code = 420},
		
		{Name = "- ARTILLERY -"},
		{Name = "Spud Turret", Func = function()
			local X, Y, Z, Heading = SelectSpot()
			if type(X) == 'number' then
				local Area = AreaGetVisible()
				CreatePersistentEntity('WPTurret', X, Y, Z, Heading, Area)
				CreatePersistentEntity('WPCannon', X, Y, Z + 0.75, Heading, Area)
				
				--[[
				local Index, Pool = PAnimGetPoolIndex('WPCannon', X, Y, Z + 0.75, 1)
				PAnimSetPropFlag(Index, Pool, 251, false)
				PAnimSetPropFlag(Index, Pool, 385, false)
				PAnimSetPropFlag(Index, Pool, 386, true)
				PAnimSetPropFlag(Index, Pool, 397, false)
				PAnimSetPropFlag(Index, Pool, 404, false)
				PAnimSetPropFlag(Index, Pool, 490, false)
				PAnimSetPropFlag(Index, Pool, 527, false)
				PAnimSetPropFlag(Index, Pool, 592, false)
				PAnimSetPropFlag(Index, Pool, 623, false)
				PAnimSetPropFlag(Index, Pool, 624, true)
				PAnimSetPropFlag(Index, Pool, 668, true)
				PAnimSetPropFlag(Index, Pool, 717, true)
				PAnimSetPropFlag(Index, Pool, 722, false)
				PAnimSetPropFlag(Index, Pool, 765, false)
				PAnimSetPropFlag(Index, Pool, 830, false)
				PAnimSetPropFlag(Index, Pool, 861, false)
				PAnimSetPropFlag(Index, Pool, 862, true)
				]]
			end
		end},
	}},
	{Name = "Item", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- ITEM: "..string.upper(Selected.Name).." -"},
					{Name = "0="..ItemGetCurrentNum(Selected.Code).."=999", Func = function(Value)
						ItemSetCurrentNum(Selected.Code, Value)
					end},
					{Name = "Set Item Quantity"},
				}
				local Option = 1
				
				repeat
					local Select = GetPointerSelection()
					if Select and IsMenuPressed(0) then
						local Min, Current, Max = GetMenuTrackbarValues(Table[Select - 1].Name)
						Table[Select - 1].Func(Current)
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
		{Name = "- PRESENT -"},
		{Name = "Flower", Code = 475},
		{Name = "Chocolate Box", Code = 478},
		
		{Name = "- OBJECTIVE -"},
		{Name = "Panties", Code = 515},
		{Name = "Lab Notes", Code = 488},
		{Name = "Crab", Code = 523},
		{Name = "Package", Code = 521},
		{Name = "Photos", Code = 526},
		{Name = "Paper Stack", Code = 477},
		{Name = "Bolt Cutter", Code = 487},
		{Name = "Algie Jacket", Code = 524},
		{Name = "Drug Bottle", Code = 522},
		{Name = "Beatrice Diary", Code = 483},
		{Name = "Perfume Bottle", Code = 490},
		{Name = "Tad House Key", Code = 493},
		{Name = "Orderly Uniform", Code = 510},
		{Name = "Harrington House Key", Code = 493},
		{Name = "Red Dress", Code = 492},
		{Name = "HEM-O Key Card", Code = 480},
		{Name = "Admission Ticket", Code = 479},
		{Name = "Carnival Ticket", Code = 495},
	}},
	{Name = "Collectible", Option = 1, Func = function(Selects)
		local Sub = UI[Selects[1]].Data[Selects[2]]
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				local Selected = Sub.Data[Select]
				local Table = {
					{Name = "- COLLECTIBLE: "..string.upper(Selected.Name).." -"},
					{Name = "Spawn", Func = CollectiblesSetTypeAvailable, Args = {Selected.Code, true}},
					{Name = "Despawn", Func = CollectiblesSetTypeAvailable, Args = {Selected.Code, false}},
					{Name = "Show on Map", Func = CollectibleOnMapEnable, Args = {Selected.Code, true}},
					{Name = "Hide on Map", Func = CollectibleOnMapEnable, Args = {Selected.Code, false}},
					{Name = "Collect", Func = CollectiblesSetAllAsCollected, Args = {Selected.Code}},
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
		{Name = "- COLLECTIBLE -"},
		{Name = "Garden Gnome", Code = 0},
		{Name = "Transistors", Code = 1},
		{Name = "Rubber Band", Code = 2},
		{Name = "Grottos & Gremlins", Code = 3},
		{Name = "Pumpkin Head", Code = 4},
		{Name = "Tombstone", Code = 5},
	}},
}})