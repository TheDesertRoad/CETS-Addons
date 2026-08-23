ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Gargantua"
ENT.Author 			= "VALVe"
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("GargantuaSpecialStompBlur")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local GargStompBlurEnd = 0

	net.Receive("GargantuaSpecialStompBlur", function()
		GargStompBlurEnd = CurTime() + 4
	end)

	hook.Add("RenderScreenspaceEffects", "GargantuaSpecialStompBlur", function()
		if GargStompBlurEnd <= CurTime() then return end

		local remaining = GargStompBlurEnd - CurTime()
		local strength = math.Clamp(remaining, 0, 1) * 1

		DrawMotionBlur(0.1, strength, 0.02)
	end)
end