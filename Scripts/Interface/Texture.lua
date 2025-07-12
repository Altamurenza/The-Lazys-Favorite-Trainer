-- TEXTURE.LUA
-- AUTHOR	: ALTAMURENZA


local TUD = {} -- texture userdata
local TAR = {} -- texture aspect ratio

TUD.Ebox = CreateTexture('Graphics/Interface/Ebox.png')
TAR.Ebox = GetTextureDisplayAspectRatio(TUD.Ebox)
TUD.Cbox = CreateTexture('Graphics/Interface/Cbox.png')
TAR.Cbox = GetTextureDisplayAspectRatio(TUD.Cbox)
TUD.Circle = CreateTexture('Graphics/Interface/Circle.png')
TAR.Circle = GetTextureDisplayAspectRatio(TUD.Circle)
TUD.Pointer = CreateTexture('Graphics/Interface/Pointer0.png')
TAR.Pointer = GetTextureDisplayAspectRatio(TUD.Pointer)
TUD.Arrow = CreateTexture('Graphics/Interface/Arrow.png')
TAR.Arrow = GetTextureDisplayAspectRatio(TUD.Arrow)

GetTUD = function(Key)
	return TUD[Key]
end
GetTAR = function(Key)
	return TAR[Key]
end
SetTUD = function(Key, UserData)
	TUD[Key] = UserData
end
SetTAR = function(Key, AspectRatio)
	TAR[Key] = AspectRatio
end

UpdateTAR = function()
	for Key in pairs(TAR) do
		TAR[Key] = GetTextureDisplayAspectRatio(TUD[Key])
	end
end