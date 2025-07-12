-- DISPLAY.LUA
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
	{Name = "Camera", Option = 1, Func = function(Selects)
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
				if Header == 'RESET' or Header == 'CUSTOM MODE' then
					Sub.Data[Select].Func()
				elseif Header == 'FIELD OF VIEW' then
					local Current = GetArguments(2, GetMenuTrackbarValues(Sub.Data[Select - 1].Name))
					Sub.Data[Select].Func(Current)
				else
					CameraSetActive(Sub.Data[Select].Code, 0.5, false)
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, false)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- RESET -"},
		{Name = "Reset Camera", Func = function()
			CameraReturnToPlayer()
			CameraReset()
		end},
		
		{Name = "- FIELD OF VIEW -"},
		{Name = "30="..CameraGetFOV().."=120"},
		{Name = "Set Camera FOV", Func = function(Value)
			CameraSetFOV(Value)
		end},
		
		{Name = "- DEFAULT MODE -"},
		{Name = "Third Person", Code = 1},
		{Name = "First Person Aim", Code = 2},
		{Name = "Low Angle", Code = 9},
		{Name = "Top Down", Code = 14},
		
		{Name = "- CUSTOM MODE -"},
		{Name = "Free Camera", Func = function()
			local PosX, PosY, PosZ, LookX, LookY, LookZ = CameraGetXYZ()
			local Pitch, Roll, Yaw = CameraGetRotation()
			Yaw = Yaw + math.pi / 2
			
			SetQueuedMessage("YOU'RE THE CAMERA NOW", [[
				You are now a floating entity, liberated from your physical form. No legs, no limits, just pure cinematic freedom.
				Press ~t~ ~t~ ~t~ ~t~ to move around.
				Move ~t~ to adjust the angle.
				Press ~t~ to stop.
			]], -1, {
				GetHudTexture('Button_W'),
				GetHudTexture('Button_A'),
				GetHudTexture('Button_S'),
				GetHudTexture('Button_D'),
				GetHudTexture('Button_Mouse_Button_plain'),
				GetHudTexture('Button_Right_Mouse_Button')
			})
			
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
				
				Wait(0)
			until IsMenuPressed(1)
			SoundSetAudioFocusPlayer()
			StopQueueMessage()
			PlayerSetControl(1)
			
			CameraAllowChange(true)
			CameraReturnToPlayer(false)
		end},
	}},
	{Name = "Display", Option = 1, Func = function(Selects)
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
				if Header == 'FIELD OF VIEW' then
					local Current = GetArguments(2, GetMenuTrackbarValues(Sub.Data[Select - 1].Name))
					Sub.Data[Select].Func(Current)
				else
					CameraSetActive(Sub.Data[Select].Code, 0.5, false)
				end
			end
			ShowMenuBorder()
			
			Sub.Option = UpdateMenuLayout(Sub.Data, Sub.Option)
			ShowMenu(Sub.Data, Sub.Option, 'Name', Icon, true)
			
			Wait(0)
		until IsMenuPressed(1)
	end, Data = {
		{Name = "- ELEMENT -"},
		{Name = "Trouble Meter=(XO)", XO = true, Func = function(Boolean)
			ToggleHUDComponentVisibility(0, Boolean)
		end},
		{Name = "Health Meter=(XO)", XO = true, Func = function(Boolean)
			ToggleHUDComponentVisibility(4, Boolean)
		end},
		{Name = "Mini Map=(XO)", XO = true, Func = function(Boolean)
			ToggleHUDComponentVisibility(11, Boolean)
		end},
		{Name = "Weapon Scroll=(XO)", XO = true, Func = function(Boolean)
			ToggleHUDComponentVisibility(20, Boolean)
		end},
		
		{Name = "- FILTER -"},
		{Name = "Cinematic=(XO)", XO = false, Func = function(Boolean)
			CameraSetWidescreen(Boolean)
		end},
		{Name = "Burning=(XO)", XO = false, Func = function(Boolean)
			EffectSetGymnFireOn(Boolean)
		end},
		{Name = "Funhouse=(XO)", XO = false, Func = function(Boolean)
			ToggleHUDComponentVisibility(39, Boolean)
		end},
	}},
}})