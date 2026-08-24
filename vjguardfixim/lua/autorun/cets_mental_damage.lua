if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
util.AddNetworkString("CETS_DMG_MentalDamageFade")
util.AddNetworkString("CETS_DMG_MentalDamageIcon")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityKeyValue", "CETS_Mental_KeyValue", function(ent, key, value)
	if ent:GetClass() ~= "trigger_hurt" then
		return
	end

	if string.lower(key) == "mental" then
		ent.CETS_Mental = tonumber(value) == 1
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "CETS_Mental_Damage", function(ply, dmginfo)
	if not IsValid(ply) or not ply:IsPlayer() then
		return
	end

	if dmginfo:GetDamageType() ~= DMG_GENERIC then
		return
	end

	if dmginfo:GetDamageCustom() == 657416 then
		net.Start("CETS_DMG_MentalDamageFade")
		net.Send(ply)

		net.Start("CETS_DMG_MentalDamageIcon")
		net.Send(ply)
		return
	end

	local mins, maxs = ply:WorldSpaceAABB()

	for _, trigger in ipairs(ents.FindInBox(mins, maxs)) do
		if not IsValid(trigger) then
			continue
		end

		if trigger:GetClass() ~= "trigger_hurt" then
			continue
		end

		if trigger.CETS_Mental ~= true then
			continue
		end

		net.Start("CETS_DMG_MentalDamageFade")
		net.Send(ply)

		net.Start("CETS_DMG_MentalDamageIcon")
		net.Send(ply)
		return
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MentalOverlayEnd = 0
local MentalOverlayFadeStart = 0
local MentalOverlayDuration = 2
local MentalOverlayFadeTime = 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_DMG_MentalDamageFade", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	ply:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 40), 0.25, 0)

	local curTime = CurTime()

	MentalOverlayFadeStart = curTime
	MentalOverlayEnd = curTime + MentalOverlayDuration
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mat = Material("effects/advisoreffect/advisorblast1_cets")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("RenderScreenspaceEffects", "CETS_MentalDamageOverlay", function()
	local curTime = CurTime()

	if curTime >= MentalOverlayEnd then
		return
	end

	local elapsed = curTime - MentalOverlayFadeStart
	local progress = math.Clamp(elapsed / MentalOverlayDuration,0, 1)

	progress = progress * progress * (3 - 2 * progress)

	local value = Lerp(progress, 1, 0.1)

	mat:SetVector("$color", Vector(value, value, value))

	render.SetMaterial(mat)

	DrawMaterialOverlay("effects/advisoreffect/advisorblast1_cets", 1)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end