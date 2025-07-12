-- VEHICLE.LUA
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
		local GetHeader = function(Select)
			while not IsMenuHeader(Sub.Data[Select].Name) do
				Select = Select - 1
			end
			return TrimHeader(Sub.Data[Select].Name)
		end
		
		repeat
			local Select = GetPointerSelection()
			if Select and IsMenuPressed(0) then
				if Select ~= 2 then
					if table.getn(PlayerSettings.Vehicles) < 8  then
						CreateVehicle(GetHeader(Select), Sub.Data[Select].Code, Sub.Data[Select].Name)
					else
						SetQueuedMessage('VEHICLE OVERLOAD', "That's enough vehicles for now. No more can be spawned until some are deleted.", 4)
					end
				elseif Select == 2 then
					Sub.Data[Select].Func()
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- DATA -"},
		{Name = "Created Vehicle", Func = function()
			local Table = {}
			local Option = 1
			
			-- "Type" is the header of the selected column
			local InsertType = function(Type)
				table.insert(Table, {Name = "- "..Type.." -"})
				
				local Found = false
				for Id, Content in ipairs(PlayerSettings.Vehicles) do
					if Content.Type == Type then
						table.insert(Table, {Table = PlayerSettings.Vehicles, Index = Id, Name = Content.Name..'=(T)'})
						if not Found then Found = true end
					end
				end
				
				if not Found then
					table.insert(Table, {Name = 'None'})
				end
			end
			
			-- callback
			local SetTable = function(Index)
				if next(Table) then
					local Vehicle = Table[Index].Table[Table[Index].Index].Vehicle
					if PlayerIsInVehicle(Vehicle) then
						SetQueuedMessage('DELETION CANCELED', "As much fun as deleting yourself sounds... let's not. Exit the vehicle before removing it.", 4)
						return
					end
					
					if VehicleIsValid(Vehicle) then
						VehicleDelete(Vehicle)
					end
					table.remove(Table[Index].Table, Table[Index].Index)
				end
				
				Table = {}
				for _, Type in ipairs({'BIKE', 'MOTORCYCLE', 'CAR', 'MISCELLANEOUS'}) do
					InsertType(Type)
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
		
		{Name = "- BIKE -"},
		{Name = "Green BMX", Code = 272},
		{Name = "Retro Bike", Code = 273},
		{Name = "Crap Bike", Code = 274},
		{Name = "Bicycle", Code = 279},
		{Name = "Red BMX", Code = 277},
		{Name = "Blue BMX", Code = 278},
		{Name = "Mountain Bike", Code = 280},
		{Name = "Lady Bike", Code = 281},
		{Name = "Aquaberry Bike", Code = 283},
		{Name = "Racer Bike", Code = 282},
		
		{Name = "- MOTORCYCLE -"},
		{Name = "Scooter", Code = 276},
		{Name = "Cop Bike", Code = 275},
		
		{Name = "- CAR -"},
		{Name = "Taxi", Code = 286},
		{Name = "Limo", Code = 290},
		{Name = "Foreign Car", Code = 292},
		{Name = "Regular Car", Code = 293},
		{Name = "Cop Car", Code = 295},
		{Name = "70 Wagon", Code = 294},
		{Name = "Delivery Truck", Code = 291},
		{Name = "Domestic Car", Code = 296},
		{Name = "Truck", Code = 297},
		{Name = "Dozer", Code = 288},
		
		{Name = "- MISCELLANEOUS -"},
		{Name = "Mower", Code = 284},
		{Name = "Go-Kart", Code = 289},
		{Name = "Spaceship 1", Code = 298},
		{Name = "Spaceship 2", Code = 287},
		{Name = "Spaceship 3", Code = 285},
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
				local Vehicle = SelectVehicle()
				if VehicleIsValid(Vehicle) then
					if Select == 3 then
						while not IsMenuPicker(Sub.Data[Select].Name) do
							Select = Select - 1
						end
						
						local Min, Current, Max = GetMenuPickerValues(Sub.Data[Select].Name)
						Sub.Data[Select].Func(Vehicle, Current)
					elseif Select == 6 then
						while not IsMenuTrackbar(Sub.Data[Select].Name) do
							Select = Select - 1
						end
						
						local Min, Current, Max = GetMenuTrackbarValues(Sub.Data[Select].Name)
						Sub.Data[Select].Func(Vehicle, Current)
					end
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- COLOR -"},
		{Name = "0>1<99", Strings = GetVehicleColorsName(), Func = function(Vehicle, Value)
			VehicleSetColor(Vehicle, Value)
		end},
		{Name = "Change Vehicle Color"},
		
		{Name = "- SPEED -"},
		{Name = "0=0=100", Func = function(Vehicle, Value)
			VehicleSetAccelerationMult(Vehicle, Value / 25)
			VehicleSetCruiseSpeed(Vehicle, Value * 100 / 10)
		end},
		{Name = "Set Vehicle Speed"},
	}},
}})