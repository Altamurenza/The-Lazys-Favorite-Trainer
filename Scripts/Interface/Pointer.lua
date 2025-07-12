-- POINTER.LUA
-- AUTHOR	: ALTAMURENZA


local Pointer = true
local Pointer_Speed = GetConfigNumber(GetScriptConfig(), 'pointer_speed', 1)
local Pointer_Status = 1
-- status:
-- 0: locked, usually used for a specific purpose
-- 1: free
-- 2: selecting object
-- 3: typing
local Pointer_Index = 0
local Pointer_Rotation = 0
local Pointer_X = GetMenuPosition()
local Pointer_Y = GetMenuBorderSettings()
local Pointer_Select = nil


IsPointerInRectangle = function(X_Min, Y_Min, X_Max, Y_Max)
	return ((Pointer_X > X_Min and Pointer_Y > Y_Min) and (Pointer_X < X_Max and Pointer_Y < Y_Max))
end
GetPointerStatus = function()
	return Pointer_Status
end
GetPointerRotation = function()
	return Pointer_Rotation
end
GetPointerIndex = function()
	return Pointer_Index
end
GetPointerPosition = function()
	return Pointer_X, Pointer_Y
end
GetPointerRectangle = function()
	local X = GetMenuPosition()
	local C, W, H = GetMenuBorderSettings()
	return X - W / 2, C - H / 2, X + W / 2, C + H / 2
end
GetPointerInteraction = function()
	if GetPointerStatus() ~= 1 then
		return
	end
	local PX, PY = GetPointerPosition()
	local PX_Min, PY_Min, PX_Max, PY_Max = GetPointerRectangle()
	local Margin = 0.005 -- threshold for edge
	
	local TL = PX <= PX_Min + Margin and PY <= PY_Min + Margin
	local TR = PX >= PX_Max - Margin and PY <= PY_Min + Margin
	local BL = PX <= PX_Min + Margin and PY >= PY_Max - Margin
	local BR = PX >= PX_Max - Margin and PY >= PY_Max - Margin
	
	local TB = PY <= PY_Min + Margin or PY >= PY_Max - Margin
	local LR = PX <= PX_Min + Margin or PX >= PX_Max - Margin
	
	if TL then
		SetPointerRotation(315)
		SetPointerIndex(1)
		return 'SCALE_TL'
	elseif TR then
		SetPointerRotation(45)
		SetPointerIndex(1)
		return 'SCALE_TR'
	elseif BL then
		SetPointerRotation(45)
		SetPointerIndex(1)
		return 'SCALE_BL'
	elseif BR then
		SetPointerRotation(315)
		SetPointerIndex(1)
		return 'SCALE_BR'
	elseif LR then
		SetPointerRotation(90)
		SetPointerIndex(1)
		return 'ROWS'
	elseif TB then
		SetPointerRotation(0)
		SetPointerIndex(1)
		return 'COLS'
	elseif IsPointerInRectangle(
		PX_Min + 0.001, 
		PY_Min + 0.001,
		PX_Min + GetMenuSize() * GetTAR('Ebox') - 0.001, 
		PY_Min + GetMenuSize() * GetMenuCol() - 0.001
	) then
		SetPointerRotation(0)
		SetPointerIndex(2)
		return 'POSITION'
	elseif IsPointerInRectangle(
		PX_Max - GetMenuSize() * GetTAR('Ebox') + 0.001, 
		PY_Min + 0.001, 
		PX_Max - 0.001, 
		PY_Max - 0.001
	) then
		SetPointerRotation(0)
		SetPointerIndex(3)
		return 'THUMB'
	end
	SetPointerRotation(0)
	SetPointerIndex(0)
	return 'NONE'
end
GetPointerSelection = function()
	if not IsMenuShowing() then
		return nil
	end
	return Pointer_Select
end
SetPointerStatus = function(Status)
	Pointer_Status = Status
end
SetPointerPosition = function(X, Y)
	Pointer_X = X or Pointer_X
	Pointer_Y = Y or Pointer_Y
end
SetPointerIndex = function(Index)
	if GetPointerIndex() == Index then
		return
	end
	SetTUD('Pointer', CreateTexture('Graphics/Interface/Pointer'..Index..'.png'))
	SetTAR('Pointer', GetTextureDisplayAspectRatio(GetTUD('Pointer')))
	Pointer_Index = Index
end
SetPointerRotation = function(Rot)
	Pointer_Rotation = Rot
end
SetPointerSelection = function(Index)
	Pointer_Select = Index
end
ShowPointer = function(R, G, B)
	if not IsMenuShowing() then
		return
	end
	local X, Y = GetPointerPosition()
	local Rotation = GetPointerRotation()
	
	local Red = R or 255
	local Green = G or 255
	local Blue = B or 255
	DrawTexture2(GetTUD('Pointer'), X, Y, 0.1 * GetTAR('Pointer'), 0.1, Rotation, Red, Green, Blue)
end


----------------------------------------------
-- # EVENT: POINTER & CONTROLLER CANCELATION #
----------------------------------------------

local CancelInput = function(Stick)
	for ButtonID = 0, 24 do
		local Type = Stick and 'mouse_movement' or 'mouse_button'
		local Func = Stick and SetStickValue or SetButtonPressed
		if GetInputHardware(ButtonID, 0) == Type then
			Func(ButtonID, 0, Stick and 0 or false)
		end
	end
end
local Positioning = false

RegisterLocalEventHandler('ControllerUpdating', function()
	if not IsMenuShowing() or PedGetControllerID(gPlayer) ~= 0 then
		return
	end
	CancelInput(false)
end)
RegisterLocalEventHandler('ControllersUpdated', function()
	-- custom mouse delta
	local FrameTime = GetFrameTime()
	local DX, DY = GetMouseInput()
	DX, DY = DX / 300, DY / 300 * GetDisplayAspectRatio()
	
	MouseDX = Lerp(MouseDX or 0, DX * FrameTime * 5 * Pointer_Speed, 0.5)
	MouseDY = Lerp(MouseDY or 0, DY * FrameTime * 5 * Pointer_Speed, 0.5)
	
	if not IsMenuShowing() or PedGetControllerID(gPlayer) ~= 0 then
		return
	end
	
	-- special pointer & layout adjustment
	local PX, PY = GetPointerPosition()
	if GetPointerStatus() == 2 then
		SetPointerPosition(Clamp(PX + MouseDX, 0, 1), Clamp(PY + MouseDY, 0, 1))
	end
	
	if GetPointerInteraction() == 'POSITION' and not Positioning and IsMouseBeingPressed(0) then
		SetPointerStatus(0)
		Positioning = true
	end
	
	if Positioning then
		if not IsMousePressed(0) then
			SetPointerStatus(1)
			Positioning = false
		end
			
		local MX, MY = GetMenuPosition()
		local PX, PY = GetPointerPosition()
		local DestX = MX + MouseDX
		local DestY = MY + MouseDY
		
		local MenuC, MenuW, MenuH = GetMenuBorderSettings()
		local L = DestX - MenuW / 2
		local R = DestX + MenuW / 2
		local T = DestY - MenuH / 2 + GetContentHeight() / 2
		local B = DestY + MenuH / 2 + GetContentHeight() / 2
		
		MouseDX = (L < 0 or R > 1) and 0 or MouseDX
		MouseDY = (T < 0 or B > 1) and 0 or MouseDY
		
		SetMenuPosition(MX + MouseDX, MY + MouseDY)
		SetPointerPosition(PX + MouseDX, PY + MouseDY)
	end
	CancelInput(true)
end)