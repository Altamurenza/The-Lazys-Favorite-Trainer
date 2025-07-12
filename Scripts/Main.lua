-- MAIN.LUA
-- AUTHOR	: ALTAMURENZA


------------
-- # SETUP #
------------

LoadScript('Scripts/Interface/Utility.lua')
LoadScript('Scripts/Interface/Texture.lua')
LoadScript('Scripts/Interface/Menu.lua')
LoadScript('Scripts/Interface/Pointer.lua')

CreateThread(function()
	while not SystemIsReady() or AreaIsLoading() do
		Wait(0)
	end
	
	local LastArea = AreaGetVisible()
	while true do
		if IsMessageQueuing() then
			ShowQueuedMessage(GetQueuedMessage(1))
		end
		
		if AreaGetVisible() ~= LastArea then
			SaveMenuSettings()
			LastArea = AreaGetVisible()
		end
		
		Wait(0)
	end
end)


-----------
-- # MAIN #
-----------

main = function()
	while not SystemIsReady() or AreaIsLoading() do
		Wait(0)
	end
	
	GetMenuTable()
	GetMenuSettings()
	
	local UnusedArea = {
		[22] = 'AreaScripts/Island3.lua',
		[31] = 'AreaScripts/TestArea.lua',
	}
	for Code, File in pairs(UnusedArea) do
		AreaRegisterAreaScript(Code, File)
	end
	
	while true do
		local Select = GetPointerSelection()
		if Select and IsMenuPressed(0) then
			if type(UI[Select].Func) == 'function' then
				UI[Select].Func({Select})
			else
				PrintWarning('UI['..Select..'].Func does not exist!')
			end
		end
		
		ShowMenuBorder()
		if IsMenuShowing() then
			local Option = UpdateMenuLayout(UI, GetMenuOption())
			SetMenuOption(Option)
			
			for Col = 1, GetMenuCol() do
				local Index = GetMenuOption() + Col - 1
				
				if IsMenuAvailable(UI, Index, Col) then
					if IsMenuHeader(UI[Index].Title) then
						ShowMenuHeader(UI[Index].Title, Index, Col)
					else
						ShowMenuPad(Index, Col)
						ShowMenuContent(UI[Index].Title, UI[Index].Title, Index, Col, true)
					end
				end
			end
			ShowPointer()
		end
	
		Wait(0)
	end
end
