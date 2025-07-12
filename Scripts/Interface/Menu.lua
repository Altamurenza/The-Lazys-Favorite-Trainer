-- MENU.LUA
-- AUTHOR	: ALTAMURENZA


local Scale = 0.8
local Font = 'Roboto'

UI = {{Title = '- MAIN MENU -'}}

--[[
	TERMINOLOGY NOTICE
	
	In this script, the terms "columns" and "rows" are defined as follows:
	- "Columns" → Represent vertical elements, can be navigated using mouse scroll or mouse clicks.
	- "Rows"    → Represent horizontal layers, they cannot be navigated, and are used mainly for adjusting total width.
	
	┌────────────────┐   ← Example layout (3 columns, multiple rows)
	│ [Character]    │   ← Column 1 (Top ↓ Bottom)
	│ [Action Style] │   ← Column 2
	│ [Vehicle]      │   ← Column 3
	└────────────────┘
	 ↑ ↑ ↑
	 │ │ └── Row 3 and so on..
	 │ └────── Row 2
	 └────────── Row 1
	
	In summary:
	- Vertical navigation = "changing columns".
	- Rows exist primarily for layout scaling (width), not for traversal.
	
	Keep this convention in mind when modifying layout logic or naming variables to prevent confusion.
]]

local W, H = MeasureTextInline('~xy+scale+Font~'..UI[1].Title, 0.5, 0.5, Scale, Font, 0, 3)
local ContentHeight = H * 1.1
local SpaceBetweenPads = 0
local SpaceToContent = 0.02
local Size = ContentHeight + SpaceToContent + SpaceBetweenPads

local Option = 1
local MaxRow = 8
local MaxCol = 7

local X = 0.25
local Y = 0.5
local Top = (Y * 2 - Size * MaxCol) / 2
local PadW = Size * MaxRow * GetTAR('Ebox')
local PadH = ContentHeight + SpaceToContent

local BorderC = Top + (Size * MaxCol / 2) + ContentHeight / 2
local BorderW = Size * (MaxRow + 2) * GetTAR('Ebox')
local BorderH = Size * MaxCol

local Transition = {}

local MessageQueue = {}
local MessageThread = nil
local MessageStop = false

local ShowKey = GetConfigNumber(GetScriptConfig(), 'show_hide_key', 59)
local Show = false

PlayerSettings = {}
NPCSettings = {}


-- # INPUT OUTPUT #

GetMenuTable = function()
	local Table = {}
	
	for Found in FindFiles('Scripts/Menu/*.lua') do
		if not Found.directory and string.find(Found.name, '^%d+ %- ([^%.]+)%.lua$') then
			local Index
			string.gsub(Found.name, '^(%d+)', function(Result)
				if type(Index) ~= 'number' then
					Index = tonumber(Result)
				end
			end)
			Table[Index] = Found.name
		end
	end
	
	for Id, File in pairs(Table) do
		LoadScript('Scripts/Menu/'..File)
		
		local Name = string.gsub(File, '^%d+%s%-%s(.-)%.lua$', '%1')
		SetTUD(Name, CreateTexture('Graphics/Menu/'..Name..'.png'))
		SetTAR(Name, GetTextureDisplayAspectRatio(GetTUD(Name)))
	end
end

GetMenuSettings = function()
	local Save = GetPersistentDataTable('TheLazysFavoriteTrainer')
	if not next(Save) then
		return
	end
	
	Scale = Save.Scale
	MaxRow = Save.MaxRow
	MaxCol = Save.MaxCol
	X = Save.X
	Y = Save.Y
	
	UpdateMenuSettings()
end
SaveMenuSettings = function()
	UpdateMenuSettings()
	
	local Save = GetPersistentDataTable('TheLazysFavoriteTrainer')
	
	Save.Scale = Scale
	Save.MaxRow = MaxRow
	Save.MaxCol = MaxCol
	Save.X = X
	Save.Y = Y
	
	SavePersistentDataTables()
end
UpdateMenuSettings = function()
	UpdateTAR()
	
	W, H = MeasureTextInline('~xy+scale+Font~'..UI[1].Title, 0.5, 0.5, Scale, Font, 0, 3)
	ContentHeight = H * 1.1
	Size = ContentHeight + SpaceToContent + SpaceBetweenPads
	
	Top = (Y * 2 - Size * MaxCol) / 2
	PadW = Size * MaxRow * GetTAR('Ebox')
	PadH = ContentHeight + SpaceToContent
	
	BorderC = Top + (Size * MaxCol / 2) + ContentHeight / 2
	BorderW = Size * (MaxRow + 2) * GetTAR('Ebox')
	BorderH = Size * MaxCol
end


-- # PAD #

GetPadY = function(Col, Text)
	local ColPosition = Size * Col - Size / 2
	return Top + ColPosition + (Text and 0 or ContentHeight / 2)
end
GetPadsRectangle = function()
	return X - PadW / 2, BorderC - Size * MaxCol, X + PadW / 2, BorderC + Size * MaxCol
end
GetPadRectangle = function(Col)
	local Y = GetPadY(Col)
	return X - PadW / 2, Y - PadH / 2, X + PadW / 2, Y + PadH / 2
end


-- # LAYOUT #

IsMenuShowing = function()
	return Show
end
IsMenuAvailable = function(Table, Index, Col)
	if not Table[Index] and IsPointerInRectangle(GetPadRectangle(Col)) then
		SetPointerSelection(nil)
	end
	return Table[Index]
end
IsMenuHeader = function(Text)
	return string.find(Text, "^%- .+ %-$")
end
IsMenuTrackbar = function(Text)
	return string.find(Text, '^%d+=%d+=%d+$')
end
IsMenuPicker = function(Text)
	return string.find(Text, '^%d+>%d+<%d+$')
end
IsMenuToggle = function(Text)
	return string.find(Text, '^(.-)%=%(XO%)$')
end
IsMenuRemoval = function(Text)
	return string.find(Text, '^(.-)%=%(T%)$')
end
GetContentHeight = function()
	return ContentHeight
end
GetMenuPosition = function()
	return X, Y
end
GetMenuOption = function(Index)
	return Option
end
GetMenuCol = function()
	return MaxCol
end
GetMenuScale = function()
	return Scale
end
GetMenuSize = function()
	return Size
end
GetMenuBorderSettings = function()
	return BorderC, BorderW, BorderH
end
GetMenuTrackbarValues = function(Text)
	local Values = {}
	string.gsub(Text, '(%d+)', function(Result)
		table.insert(Values, tonumber(Result))
	end)
	return unpack(Values)
end
GetMenuPickerValues = function(Text)
	local Values = {}
	string.gsub(Text, '(%d+)', function(Result)
		table.insert(Values, tonumber(Result))
	end)
	return unpack(Values)
end
GetThumbInfo = function(Items, Columns, Option)
	local MenuY, MenuW, MenuH = GetMenuBorderSettings()
	
	local ThumbW = GetMenuScale() * 0.0125 * GetTAR('Ebox')
	local ThumbH = math.max(0.02, Columns / Items * MenuH)
	local ScrollRange = MenuH - ThumbH
	local ScrollRatio = Clamp((Option - 1) / (Items - Columns), 0, 1)
	
	local ThumbX = GetMenuPosition() + MenuW / 2 - ThumbW / 2 * GetTAR('Ebox')
	local ThumbY = MenuY - MenuH / 2 + ThumbH / 2 + ScrollRange * ScrollRatio
	
	return ThumbW, ThumbH, ScrollRange, ScrollRatio, ThumbX, ThumbY
end
SetMenuPosition = function(NewX, NewY)
	X = NewX
	Y = NewY
	Top = (Y * 2 - Size * MaxCol) / 2
	BorderC = Top + (Size * MaxCol / 2) + ContentHeight / 2
end
SetMenuOption = function(Index)
	Option = Index
end
SetMenuRow = function(Rows)
	local LastMax = MaxRow
	Rows = math.floor(Rows + 0.5)
	if Rows >= 1 then
		MaxRow = MaxRow + Rows > 10 and 10 or MaxRow + Rows
	elseif Rows <= -1 then
		MaxRow = MaxRow + Rows < 8 and 8 or MaxRow + Rows
	end
	
	PadW = Size * MaxRow * GetTAR('Ebox')
	BorderW = Size * (MaxRow + 2) * GetTAR('Ebox')
	local Inc = (MaxRow - LastMax) * PadH * GetTAR('Ebox')
	if X - BorderW / 2 < 0 then
		X = X + Inc
	elseif X + BorderW / 2 > 1 then
		X = X - Inc
	end
end
SetMenuCol = function(Cols)
	local LastMax = MaxCol
	Cols = math.floor(Cols + 0.5)
	if Cols >= 1 then
		MaxCol = MaxCol + Cols > 12 and 12 or MaxCol + Cols
	elseif Cols <= -1 then
		MaxCol = MaxCol + Cols < 3 and 3 or MaxCol + Cols
	end
	
	BorderH = Size * MaxCol
	local Inc = (MaxCol - LastMax) * PadH
	if Y - BorderH / 2 + ContentHeight / 2 < 0 then
		Y = Y + Inc
	elseif Y + BorderH / 2 + ContentHeight / 2 > 1 then
		Y = Y - Inc
	end
	Top = (Y * 2 - Size * MaxCol) / 2
	BorderC = Top + (Size * MaxCol / 2) + ContentHeight / 2
end
SetMenuScale = function(NewScale)
	if NewScale < 0.65 or NewScale > 1.5 then
		return
	end
	
	local LastScale = Scale
	Scale = NewScale
	W, H = MeasureTextInline('~xy+scale+Font~'..UI[1].Title, 0.5, 0.5, Scale, Font, 0, 3)
	ContentHeight = H * 1.1
	Size = ContentHeight + SpaceToContent + SpaceBetweenPads
	
	Top = (Y * 2 - Size * MaxCol) / 2
	PadW = Size * MaxRow * GetTAR('Ebox')
	PadH = ContentHeight + SpaceToContent
	
	BorderC = Top + (Size * MaxCol / 2) + ContentHeight / 2
	BorderW = Size * (MaxRow + 2) * GetTAR('Ebox')
	BorderH = Size * MaxCol
	
	-- prevent the rescaling expand beyond the boundaries
	local Inc = NewScale - LastScale
	if X - BorderW / 2 < 0 then
		X = X + Inc
	elseif X + BorderW / 2 > 1 then
		X = X - Inc
	end
	if Y - BorderH / 2 + ContentHeight / 2 < 0 then
		Y = Y + Inc
	elseif Y + BorderH / 2 + ContentHeight / 2 > 1 then
		Y = Y - Inc
	end
end
local ChangeLayout_Scale = function(MouseDX, MouseDY, OnTOP, OnLEFT)
	local Inc, Dec
	local Threshold = 0.001
	if OnTOP then
		Inc = OnLEFT and (MouseDX < -Threshold and MouseDY < -Threshold)
			or (MouseDX > Threshold and MouseDY < -Threshold)
		Dec = OnLEFT and (MouseDX > Threshold and MouseDY > Threshold)
			or (MouseDX < -Threshold and MouseDY > Threshold)
	else
		Inc = OnLEFT and (MouseDX < -Threshold and MouseDY > Threshold)
			or (MouseDX > Threshold and MouseDY > Threshold)
		Dec = OnLEFT and (MouseDX > Threshold and MouseDY < -Threshold)
			or (MouseDX < -Threshold and MouseDY < -Threshold)
	end
	
	if Inc or Dec then
		SetMenuScale(GetMenuScale() + (Inc and 0.01 or -0.01))
	end
	local X1, Y1, X2, Y2 = GetPointerRectangle()
	SetPointerPosition(OnLEFT and X1 or X2, OnTOP and Y1 or Y2)
end
local MouseDX_Total = 0
local MouseDY_Total = 0
local ChangeLayout_Rows = function(MouseDX, OnLEFT)
	MouseDX_Total = MouseDX_Total + MouseDX
	
	local Direction = (MouseDX_Total > 0.04 and (OnLEFT and -1 or 1))
		or (MouseDX_Total < -0.04 and (OnLEFT and 1 or -1))
	if Direction then
		SetMenuRow(Direction)
		MouseDX_Total = 0
	end
	
	local X1, _, X2 = GetPointerRectangle()
	SetPointerPosition(OnLEFT and X1 or X2)
end
local ChangeLayout_Cols = function(MouseDY, OnTOP, Table, Option)
	MouseDY_Total = MouseDY_Total + MouseDY
	
	local Direction = (MouseDY_Total > 0.02 and (OnTOP and -1 or 1))
		or (MouseDY_Total < -0.02 and (OnTOP and 1 or -1))
	if Direction then
		Option = SetMenuCol(Direction)
		MouseDY_Total = 0
	end
	
	local _, Y1, _, Y2 = GetPointerRectangle()
	SetPointerPosition(nil, OnTOP and Y1 or Y2)
end
local ThumbOffset = 0
local DragThumb = function(MouseDX, MouseDY, Items, Columns, Range, ThumbY)
	local PX, PY = GetPointerPosition()
	local PX_Min, PY_Min, PX_Max, PY_Max = GetPointerRectangle()
	
	if IsMouseBeingPressed(0) then
		ThumbOffset = PY - ThumbY
	end
	local MenuC, _, MenuH = GetMenuBorderSettings()
	local DragY = Clamp(PY - ThumbOffset, MenuC - MenuH / 2, MenuC + MenuH / 2)
	local DragR = (DragY - (MenuC - MenuH / 2)) / Range
	
	SetPointerPosition(
		Clamp(PX + MouseDX, PX_Min, PX_Max), 
		Clamp(PY + MouseDY, PY_Min, PY_Max)
	)
	return Clamp(math.floor(DragR * (Items - Columns) + 1), 1, Items - Columns + 1)
end
local Traverse = function(MouseDX, MouseDY, Items, Columns, Option)
	local Scroll = GetMouseScroll()
	local MaxOption = math.max(1, Items - Columns + 1)

	if Scroll >= 120 then
		Option = Option - 1 < 1 and MaxOption or Option - 1
	elseif Scroll <= -120 then
		Option = Option + 1 > MaxOption and 1 or Option + 1
	end

	local PX, PY = GetPointerPosition()
	local PX_Min, PY_Min, PX_Max, PY_Max = GetPointerRectangle()
	SetPointerPosition(
		Clamp(PX + MouseDX, PX_Min, PX_Max), 
		Clamp(PY + MouseDY, PY_Min, PY_Max)
	)
	return Option
end
UpdateMenuLayout = function(Table, Option)
	if not Show or not MouseDX or not MouseDY then
		return Option
	end
	local Items = table.getn(Table)
	local Columns = GetMenuCol()
	
	-- get pointer pos and bounds
	local PX, PY = GetPointerPosition()
	local PX_Min, PY_Min, PX_Max, PY_Max = GetPointerRectangle()
	
	-- get pointer interaction
	local Interaction = GetPointerInteraction()
	
	-- thumb
	local ThumbW, ThumbH, Range, Ratio, ThumbX, ThumbY = GetThumbInfo(Items, Columns, Option)
	if Items > Columns then
		local RGB = Interaction == 'THUMB' and {75, 75, 75} or {58, 58, 58}
		DrawTexture2(GetTUD('Ebox'), ThumbX, ThumbY, ThumbW * GetTAR('Ebox'), ThumbH, 0, unpack(RGB))
	end
	
	if GetPointerStatus() ~= 1 then
		return Option
	end
	
	-- interaction
	if string.find(Interaction, 'SCALE') and IsMousePressed(0) then
		local T = string.sub(Interaction, 7, 7) == 'T'
		local L = string.sub(Interaction, 8, 8) == 'L'
		ChangeLayout_Scale(MouseDX, MouseDY, T, L)
	elseif Interaction == 'ROWS' and IsMousePressed(0) then
		ChangeLayout_Rows(MouseDX, PX == PX_Min)
	elseif Interaction == 'COLS' and IsMousePressed(0) then
		ChangeLayout_Cols(MouseDY, PY == PY_Min)
	elseif Interaction == 'POSITION' and IsMousePressed(0) then
		--[[
			NOTE: MOVED TO "Pointer.lua"
			
			Due to the script's execution flow, changing the menu position here causes
			a delay in rendering each component. The border updates the fastest, while
			the last-drawn elements may appear slightly delayed (misaligned).
		]]
	elseif Interaction == 'THUMB' and IsMousePressed(0) then
		Option = DragThumb(MouseDX, MouseDY, Items, Columns, Range, ThumbY)
	else
		Option = Traverse(MouseDX, MouseDY, Items, Columns, Option)
	end
	
	-- failsafe: prevent empty columns
	return Clamp(Option, 1, math.max(1, Items - Columns + 1))
end


-- # BUTTON #

IsMenuPressed = function(Key)
	if not Show or GetPointerStatus() == 3 then
		return false
	end
	local IsPointerAllowed = ({
		[0] = true,
		[4] = true,
		[5] = true,
	})[GetPointerIndex()]
	if IsPointerAllowed and IsMouseBeingReleased(Key) and not Transition[Key] then
		Transition[Key] = {false, CreateThread(function(Key)
			while IsMouseBeingReleased(Key) do
				Wait(0)
			end
			
			Transition[Key][1] = true
		end, Key)}
	end
	
	if next(Transition) and type(Transition[Key]) == 'table' then
		local Value = Transition[Key][1]
		if Transition[Key][1] then
			Transition[Key] = nil
		end
		
		return Value
	end
	return false
end


-- # TEXT #

IsMessageQueuing = function()
	return next(MessageQueue) and type(MessageThread) ~= 'thread'
end
GetQueuedMessage = function(Index)
	return MessageQueue[Index][1], MessageQueue[Index][2], MessageQueue[Index][3], MessageQueue[Index][4]
end
SetQueuedMessage = function(Header, Message, Second, Textures)
	table.insert(MessageQueue, {Header, Message, Second, Textures})
end
ShowQueuedMessage = function(Header, Message, Second, Textures)
	MessageThread = CreateThread(function(Header, Message, Second, Textures)
		if Second == -1 then
			Second = 9999
		end
		
		local LastArgs = (type(Textures) == 'table' and next(Textures)) and Textures or {}
		table.insert(LastArgs, 0)
		table.insert(LastArgs, 3)
		
		local Scale = 0.8
		local Space = 0.01
		local BoxW = 0.3
		
		local Text, Lines = JustifyTails(Message, Scale, Font, 3, BoxW - 0.02, Textures)
		local MessageW, MessageH = MeasureTextInline('~scale+font+white~'..Text, Scale, Font, unpack(LastArgs))
		local ContentH = MessageH * 1.1
		local BoxH = MessageH + 0.02
		BoxH = BoxH + (Header and MessageH / Lines * 2 or 0)
		
		local Status = true
		local Factor = 0.2
		local InY, OutY = 0 + BoxH / 2 + Space, 0 - BoxH / 2 - Space
		local X, Y = 0.5, OutY
		
		repeat
			if type(Status) == 'number' and Y == InY and (Status < GetTimer() or MessageStop) then
				Status = false
			end
			if type(Status) == 'boolean' then
				local DestY = Status and InY or OutY
				Y = Y + (DestY - Y) * Factor
				if math.abs(Y - DestY) < 0.001 then
					Y = DestY
					Status = GetTimer() + (Y == InY and Second * 1000 or 250)
				end
			end
			
			if IsMenuShowing() then
				-- pad
				DrawTexture2(GetTUD('Ebox'), X, Y, BoxW, BoxH, 0, 26, 26, 26, 255)
				
				-- content
				local Specifiers = '~xy+scale+font+white~'
				local ContentX = X - BoxW / 2 + Space
				local ContentY = Y - ContentH / 2.25
				
				if Header then
					DrawTextInline(Specifiers..Header, X, ContentY - MessageH / Lines, Scale, Font, 0, 1)
					ContentY = ContentY + MessageH / Lines
				end
				DrawTextInline(Specifiers..Text, ContentX, ContentY, Scale, Font, unpack(LastArgs))
			end
			
			Wait(0)
		until type(Status) == 'number' and Y == OutY
		table.remove(MessageQueue, 1)
		MessageStop = false
		MessageThread = nil
	end, Header, Message, Second, Textures)
end
StopQueueMessage = function()
	if not next(MessageQueue) then
		return
	end
	CreateThread(function()
		while MessageStop do
			Wait(0)
		end
		MessageStop = true
	end)
end
TrimHeader = function(Text, Normalize)
	local Header = string.sub(Text, 3, string.len(Text) - 2)
	if Normalize then
		local First = string.sub(Header, 1, 1)
		local Rest = string.lower(string.sub(Header, 2))
		Header = First..Rest
	end
	return Header
end
TrimTails = function(Inline, Length)
	if MeasureTextInline(unpack(Inline)) < Length then
		return Inline
	end
	
	local Specifiers = string.gsub(Inline[1], '(~.-~).*', '%1')
	local Text = string.gsub(Inline[1], '^~.-~', '')
	
	while MeasureTextInline(unpack(Inline)) > Length do
		Text = string.sub(Text, 1, string.len(Text) - 1)
		Inline[1] = Specifiers..Text
	end
	return Inline
end
JustifyTails = function(Text, Scale, Font, Style, Max, Textures)
	local RawLines, FinalLines = {}, {}
	local Pos, Len = 1, string.len(Text)

	-- parse based on new lines (\n)
	while Pos <= Len do
		local Start, End = string.find(Text, '\n', Pos, true)
		if Start then
			table.insert(RawLines, string.sub(Text, Pos, Start - 1))
			Pos = End + 1
			if Pos > Len then
				table.insert(RawLines, '')
			end
		else
			table.insert(RawLines, string.sub(Text, Pos))
			break
		end
	end
	
	-- parse based on length (Max)
	local T_Count = 0
	local T_Pos = 1
	
	local InlineArgs = function(Line)
		local Text = '~scale+font~'..Line
		
		-- if no texture needed
		if T_Count < 1 then
			return Text, Scale, Font, 0, 3
		end
		
		-- set the last args to textures, show time, pre-defined style
		local Args = {Text, Scale, Font}
		for Index = 1, T_Count do
			table.insert(Args, Textures[Index])
		end
		table.insert(Args, 0)
		table.insert(Args, 3)
		
		return unpack(Args)
	end
	local ConstructLine = function(Line, Word)
		local Len = string.len(Line)
		local TestLine = Len == 0 and Word or Line..' '..Word
		
		-- detect a texture
		local Start, End = string.find(TestLine, '~t~', T_Pos, true)
		if Start then
			T_Count = T_Count + 1
			T_Pos = End + 1
		end
		
		-- measure the line's width
		if MeasureTextInline(InlineArgs(TestLine)) > Max then
			table.insert(FinalLines, Line)
			return Word
		end
		return TestLine
	end
	local GetLine = function(Raw)
		-- parse the raw table based on space
		local Words, Line = {}, ''
		string.gsub(Raw, '%S+', function(Word)
			table.insert(Words, Word) end
		)
		
		-- get line
		if not next(Words) then
			return ''
		end
		for _, Word in ipairs(Words) do
			Line = ConstructLine(Line, Word)
		end
		
		-- reset texture count and last pos
		T_Count = 0
		T_Pos = 1
		return Line
	end
	
	for _, Raw in ipairs(RawLines) do
		table.insert(FinalLines, GetLine(Raw))
	end
	return table.concat(FinalLines, '\n'), table.getn(FinalLines)
end


-- # DRAW #

local GetIconX = function(Index)
	return X - PadW / 2 + PadH / 2 * GetTAR(UI[Index].Title)
end
ToggleShow = function()
	if IsKeyBeingPressed(ShowKey) then
		Show = not Show
		if not Show then
			collectgarbage()
		end
	end
end
ShowMenuBorder = function()
	ToggleShow()
	if not Show then
		return
	end
	
	if not IsPointerInRectangle(GetPadsRectangle()) then
		SetPointerSelection(nil)
	end
	local Center, Width, Height = GetMenuBorderSettings()
	DrawTexture2(GetTUD('Ebox'), GetMenuPosition(), Center, Width, Height, 0, 10, 10, 10, 255)
end
ShowMenuHeader = function(Text, Index, Col)
	if not Show then
		return
	end
	if IsPointerInRectangle(GetPadRectangle(Col)) then
		SetPointerSelection(nil)
	end
	local Specifiers = '~xy+scale+rgb+font~'
	Text = TrimHeader(Text)
	
	local X = GetMenuPosition() - PadW / 2
	local Inline = {Specifiers..Text, X, 0.5, Scale * 0.7, 220, 220, 220, Font, 0, 3}
	local W, H = MeasureTextInline(unpack(Inline))
	Inline[3] = GetPadY(Col) + Size / 2 - H * 1.2
	
	DrawTextInline(unpack(Inline))
end
ShowMenuPad = function(Index, Col)
	if not Show then
		return
	end
	local Pointed = IsPointerInRectangle(GetPadRectangle(Col))
	local RGB = Pointed and 58 or 26
	if Pointed then
		SetPointerSelection(Index)
	end
	
	DrawTexture2(GetTUD('Ebox'), GetMenuPosition(), GetPadY(Col), PadW, PadH, 0, RGB, RGB, RGB)
end
ShowMenuTrackbar = function(Table, Index, Col, Key)
	if not Show then
		return
	end
	local PadX_Min, PadY_Min, PadX_Max, PadY_Max = GetPadRectangle(Col)
	if IsPointerInRectangle(PadX_Min, PadY_Min, PadX_Max, PadY_Max) then
		SetPointerSelection(nil)
	end
	DrawTexture2(GetTUD('Ebox'), GetMenuPosition(), GetPadY(Col), PadW, PadH, 0, 26, 26, 26)
	
	-- trackbar setup
	local Min, Current, Max = GetMenuTrackbarValues(Table[Index][Key])
	local X2 = (Current - Min) / (Max - Min)
	
	local TrackbarW = PadW * 0.6
	local TrackbarH = GetMenuScale() * 0.00625
	local TrackbarX = GetMenuPosition() + PadW / 2 - TrackbarW / 2 - PadH / 2 * GetTAR('Ebox')
	local TrackbarY = GetPadY(Col)
	local LX = TrackbarX - (TrackbarW / 2) -- left corner
	local RX = TrackbarX + (TrackbarW / 2) -- right corner
	
	-- handle setup
	local HandleSize = GetMenuScale() * 0.025
	local HandleX = LX + (TrackbarW * X2)
	
	-- drag & type
	Table[Index].TrackbarValue = (Current - Min) / (Max - Min)
	if GetPointerIndex() == 0 then
		local MarginLX = LX - PadH / 2 * GetTAR('Ebox')
		local IsFree = not Table[Index].IsTyping and not Table[Index].IsDragging
		
		-- type toggle & pad
		local IsTypePointed = IsPointerInRectangle(PadX_Min, PadY_Min, MarginLX, PadY_Max)
		if IsTypePointed and IsFree and IsMenuPressed(0) then
			SetPointerStatus(3)
			SetQueuedMessage('GIVE US A NUMBER', string.format([[
				Pick a number, any number, as long as it's between %d and %d. Lower or higher? It'll be capped.
				Press ~t~ to undo.
				Press ~t~ or ~t~ to confirm.
				Press ~t~ to cancel.
			]], Min, Max), -1, {
				GetHudTexture('Button_Backspace'),
				GetHudTexture('Button_Left_Mouse_Button'),
				GetHudTexture('Button_Enter'),
				GetHudTexture('Button_Right_Mouse_Button')
			})
			
			Table[Index].Type = ''
			Table[Index].IsTyping = true
		end
		if IsTypePointed or Table[Index].IsTyping then
			DrawTexture2(GetTUD('Ebox'), GetMenuPosition() - PadW / 2 + (MarginLX - PadX_Min) / 2, TrackbarY, MarginLX - PadX_Min, PadH, 0, 58, 58, 58)
		end
		
		-- type logic
		if Table[Index].IsTyping then
			local Len = string.len(Table[Index].Type)
			if IsKeyBeingPressed(14) and Len > 0 then
				Table[Index].Type = string.sub(Table[Index].Type, 1, Len - 1)
			end
			
			if Len < 6 then
				for _, Key in ipairs({'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}) do
					if IsKeyBeingPressed(Key) then
						Table[Index].Type = Table[Index].Type..Key
					end
				end
			end
			
			local Specifiers = '~xy+scale+white+font~'
			DrawTextInline(Specifiers..Table[Index].Type, GetMenuPosition() - PadW / 2 + PadH / 2 * GetTAR('Ebox'), GetPadY(Col, true), Scale, Font, 0, 3)
			
			local WasConfirmed = IsKeyBeingPressed(28) or IsMouseBeingReleased(0)
			local WasCancelled = IsMouseBeingReleased(1)
			if WasConfirmed or WasCancelled then
				Current = WasConfirmed and Clamp(tonumber(Table[Index].Type) or Current, Min, Max) or Current
				SetPointerStatus(1)
				StopQueueMessage()
				Table[Index].IsTyping = false
			end
		end
		
		-- drag toggle & pad
		local IsDragPointed = IsPointerInRectangle(MarginLX, PadY_Min, PadX_Max, PadY_Max)
		if IsDragPointed and IsFree and IsMouseBeingPressed(0) then
			Table[Index].IsDragging = true
		end
		if IsDragPointed or Table[Index].IsDragging then
			DrawTexture2(GetTUD('Ebox'), TrackbarX, TrackbarY, PadX_Max - MarginLX, PadH, 0, 58, 58, 58)
		end
		
		-- drag logic
		if Table[Index].IsDragging then
			local PX = GetPointerPosition()
			Table[Index].TrackbarValue = Clamp((PX - LX) / (RX - LX), 0, 1)
			Current = math.floor(Min + (Max - Min) * Table[Index].TrackbarValue + 0.5)
			
			if not IsMousePressed(0) then
				Table[Index].IsDragging = false
			end
		end
	else
		Table[Index].IsDragging = false
		Table[Index].IsTyping = false
	end
	
	-- text
	if not Table[Index].IsTyping then
		local Specifiers = '~xy+scale+white+font~'
		DrawTextInline(Specifiers..Current, GetMenuPosition() - PadW / 2 + PadH / 2 * GetTAR('Ebox'), GetPadY(Col, true), Scale, Font, 0, 3)
	end
	
	-- full track
	SetTextureBounds(GetTUD('Ebox'), 0, 0, 1, 1)
	DrawTexture2(GetTUD('Ebox'), TrackbarX, TrackbarY, TrackbarW, TrackbarH, 0)
	
	-- current track
	SetTextureBounds(GetTUD('Ebox'), 0, 0, X2, 1)
	DrawTexture2(GetTUD('Ebox'),
		TrackbarX - (TrackbarW * (1 - X2)) / 2,
		TrackbarY,
		TrackbarW * X2,
		TrackbarH,
		0, 15, 130, 255
	)
	
	-- handle
	DrawTexture2(GetTUD('Ebox'), HandleX, TrackbarY, HandleSize * GetTAR('Ebox'), HandleSize, 0)
	
	-- set new format min=current=max
	Table[Index][Key] = string.format("%d=%d=%d", Min, Current, Max)
end
ShowMenuPicker = function(Table, Index, Col, Key)
	if not Show then
		return
	end
	local Pointed = IsPointerInRectangle(GetPadRectangle(Col))
	if Pointed then
		SetPointerSelection(nil)
	end
	local Color = Pointed and 58 or 26
	DrawTexture2(GetTUD('Ebox'), GetMenuPosition(), GetPadY(Col), PadW, PadH, 0, Color, Color, Color)
	
	-- navigation
	local Min, Current, Max = GetMenuPickerValues(Table[Index][Key])
	local ArrowH = PadH - SpaceToContent * 0.4
	local LX = X - PadW / 2 + PadH / 2 * GetTAR('Arrow')
	local RX = X + PadW / 2 - PadH / 2 * GetTAR('Arrow')
	DrawTexture2(GetTUD('Arrow'), LX, GetPadY(Col), ArrowH * GetTAR('Arrow'), ArrowH, 0)
	DrawTexture2(GetTUD('Arrow'), RX, GetPadY(Col), ArrowH * GetTAR('Arrow'), ArrowH , 180)
	
	-- display the converted number
	local Specifiers = '~xy+scale+white+font~'
	local Name = Table[Index].Strings[Current]
	DrawTextInline(Specifiers..Name, GetMenuPosition(), GetPadY(Col, true), Scale, Font, 0, 1)
	
	-- adjust value
	if IsPointerInRectangle(
		LX - ArrowH / 2 * GetTAR('Arrow'),
		GetPadY(Col) - ArrowH / 2,
		LX + ArrowH / 2 * GetTAR('Arrow'),
		GetPadY(Col) + ArrowH / 2
	) and IsMenuPressed(0) then
		Current = Current - 1 < Min and Max or Current - 1
	end
	if IsPointerInRectangle(
		RX - ArrowH / 2 * GetTAR('Arrow'),
		GetPadY(Col) - ArrowH / 2,
		RX + ArrowH / 2 * GetTAR('Arrow'),
		GetPadY(Col) + ArrowH / 2
	) and IsMenuPressed(0) then
		Current = Current + 1 > Max and Min or Current + 1
	end
	
	-- set new format min>current<max
	Table[Index][Key] = string.format("%d>%d<%d", Min, Current, Max)
end
ShowMenuToggle = function(Icon, Table, Index, Col, Key)
	if not Show then
		return
	end
	local Pointed = IsPointerInRectangle(GetPadRectangle(Col))
	if Pointed then
		SetPointerSelection(nil)
	end
	local Color = Pointed and 58 or 26
	DrawTexture2(GetTUD('Ebox'), GetMenuPosition(), GetPadY(Col), PadW, PadH, 0, Color, Color, Color)
	
	local Space = SpaceToContent * 0.4
	local IconH = PadH - Space
	local IconX = X - PadW / 2 + PadH / 2 * GetTAR(Icon)
	local TextX = IconX + PadH * GetTAR(Icon)
	local ToggBorW = PadH * 2.75 * GetTAR('Ebox')
	local ToggBorH = PadH - Space
	local ToggX = X + PadW / 2 - ToggBorW / 2 * GetTAR('Ebox') - Space / 2 * GetTAR('Ebox')
	
	-- icon
	DrawTexture2(GetTUD('Ebox'), IconX, GetPadY(Col), IconH * GetTAR(Icon), IconH, 0, 200, 200, 200)
	IconH = PadH - SpaceToContent * 0.5
	DrawTexture2(GetTUD(Icon), IconX, GetPadY(Col), IconH * GetTAR(Icon), IconH, 0)
	
	-- text
	local Specifiers = '~xy+scale+white+font~'
	local Name = string.gsub(Table[Index][Key], '%=%b()', '')
	local Text = {Specifiers..Name, TextX, GetPadY(Col, true), Scale, Font, 0, 3}
	Text = TrimTails(Text, ToggX - PadH * GetTAR(Icon) - TextX)
	DrawTextInline(unpack(Text))
	
	-- toggle border
	DrawTexture2(GetTUD('Ebox'), ToggX, GetPadY(Col), ToggBorW * GetTAR('Ebox'), ToggBorH, 0)
	
	-- toggle background
	Space = SpaceToContent * 0.5
	local ToggBacW = ToggBorW - Space / 2 * GetTAR('Ebox')
	local ToggBacH = PadH - Space
	local RGB = Table[Index].XO and {47, 209, 89} or {57, 56, 61}
	DrawTexture2(GetTUD('Ebox'), ToggX, GetPadY(Col), ToggBacW * GetTAR('Ebox'), ToggBacH, 0, unpack(RGB))
	
	-- toggle knob
	local KnobH = PadH - SpaceToContent * 0.7
	local LX = ToggX - ToggBacW / 2 * GetTAR('Ebox') + KnobH / 2 * GetTAR('Ebox') + (ToggBorW - ToggBacW) / 2 * GetTAR('Ebox')
	local RX = ToggX + ToggBacW / 2 * GetTAR('Ebox') - KnobH / 2 * GetTAR('Ebox') - (ToggBorW - ToggBacW) / 2 * GetTAR('Ebox')
	DrawTexture2(GetTUD('Ebox'), Table[Index].XO and RX or LX, GetPadY(Col), KnobH * GetTAR(Icon), KnobH, 0)
	
	if Pointed and IsMenuPressed(0) then
		Table[Index].XO = not Table[Index].XO
		Table[Index].Func(Table[Index].XO)
	end
end
local MenuCol_Removal = function(Table, Index, Col, Callback)
	local Pointed = IsPointerInRectangle(GetPadRectangle(Col))
	local Y = GetPadY(Col)
	
	-- pad
	local Color = Pointed and 58 or 26
	DrawTexture2(GetTUD('Ebox'), GetMenuPosition(), Y, PadW, PadH, 0, Color, Color, Color)
	
	-- delete icon
	local DeleteX = X + PadW / 2 - PadH / 2 * GetTAR('Ebox')
	local DeleteH = PadH - SpaceToContent * 0.5
	local DeleteRect = IsPointerInRectangle(
		DeleteX - DeleteH / 2 * GetTAR('Ebox'),
		Y - DeleteH / 2,
		DeleteX + DeleteH / 2 * GetTAR('Ebox'),
		Y + DeleteH / 2
	)
	DrawTexture2(GetTUD('Ebox'), DeleteX, Y, DeleteH * GetTAR('Ebox'), DeleteH, 0, 216, 39, 38)
	
	local MinusH = PadH * 0.1
	local MinusW = MinusH * 3
	DrawTexture2(GetTUD('Ebox'), DeleteX, Y, MinusW * GetTAR('Ebox'), MinusH, 0)
	
	-- show name
	local TextX = X - PadW / 2
	local Name = string.gsub(Table[Index].Name, '%=%b()', '')
	local Specifiers = '~xy+scale+white+font~  '
	local Text = {Specifiers..Name, TextX, GetPadY(Col, true), Scale, Font, 0, 3}
	Text = TrimTails(Text, DeleteX - PadH * GetTAR('Ebox') - TextX)
	DrawTextInline(unpack(Text))
	
	-- removal
	if DeleteRect and IsMenuPressed(0) then
		Callback(Index)
	end
end
local MenuCol_Normal = function(Table, Index, Col)
	local Color = IsPointerInRectangle(GetPadRectangle(Col)) and 58 or 26
	DrawTexture2(GetTUD('Ebox'), GetMenuPosition(), GetPadY(Col), PadW, PadH, 0, Color, Color, Color)
	
	local Specifiers = '~xy+scale+white+font~  '
	DrawTextInline(Specifiers..Table[Index].Name, X - PadW / 2, GetPadY(Col, true), Scale, Font, 0, 3)
end
ShowMenuRemoval = function(Table, Option, Callback)
	if not Show then
		return
	end
	SetPointerSelection(nil)
	
	for Col = 1, GetMenuCol() do
		local Index = Option + Col - 1
		
		if IsMenuAvailable(Table, Index, Col) then
			local Pointed = IsPointerInRectangle(GetPadRectangle(Col))
			if IsMenuHeader(Table[Index].Name) then
				ShowMenuHeader(Table[Index].Name, Index, Col)
			elseif IsMenuRemoval(Table[Index].Name) then
				MenuCol_Removal(Table, Index, Col, Callback)
			else
				MenuCol_Normal(Table, Index, Col)
			end
		end
	end
	ShowPointer()
end
ShowMenuContent = function(Icon, Text, Index, Col, Symbol)
	if not Show then
		return
	end
	local IconX = X - PadW / 2 + PadH / 2 * GetTAR(Icon)
	local TextX = IconX + PadH * GetTAR(Icon)
	local SymbX = X + PadW / 2 - PadH / 2 * GetTAR(Icon)
	
	-- frame
	local IconH = PadH - SpaceToContent * 0.4
	DrawTexture2(GetTUD('Ebox'), IconX, GetPadY(Col), IconH * GetTAR(Icon), IconH, 0, 200, 200, 200)
	
	-- icon
	IconH = PadH - SpaceToContent * 0.5
	DrawTexture2(GetTUD(Icon), IconX, GetPadY(Col), IconH * GetTAR(Icon), IconH, 0)
	
	local Specifiers = '~xy+scale+white+font~'
	local Text = {Specifiers..Text, TextX, GetPadY(Col, true), Scale, Font, 0, 3}
	Text = TrimTails(Text, SymbX - PadH * GetTAR(Icon) - TextX)
	DrawTextInline(unpack(Text))
	
	if Symbol then
		Specifiers = '~xy+scale+rgb+font~'
		DrawTextInline(Specifiers..'>', SymbX, GetPadY(Col, true), Scale, 200, 200, 200, Font, 0, 1)
	end
end
ShowMenu = function(Table, Option, Key, Icon, Symbol)
	if not Show then
		return
	end
	
	for Col = 1, GetMenuCol() do
		local Index = Option + Col - 1
		
		if IsMenuAvailable(Table, Index, Col) then
			if IsMenuHeader(Table[Index][Key]) then
				ShowMenuHeader(Table[Index][Key], Index, Col)
			elseif IsMenuTrackbar(Table[Index][Key]) then
				ShowMenuTrackbar(Table, Index, Col, Key)
			elseif IsMenuPicker(Table[Index][Key]) then
				ShowMenuPicker(Table, Index, Col, Key)
			elseif IsMenuToggle(Table[Index][Key]) then
				ShowMenuToggle(Icon, Table, Index, Col, Key)
			else
				ShowMenuPad(Index, Col)
				ShowMenuContent(Icon, Table[Index][Key], Index, Col, Symbol)
			end
		end
	end
	ShowPointer()
end
