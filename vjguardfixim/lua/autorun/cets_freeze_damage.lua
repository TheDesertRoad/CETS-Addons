if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
util.AddNetworkString("CETS_DMG_FreezingDamageFade")
util.AddNetworkString("CETS_DMG_FreezingDamageIcon")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityKeyValue", "CETS_Freezing_KeyValue", function(ent, key, value)
	if ent:GetClass() ~= "trigger_hurt" then return end

	if string.lower(key) == "freezing" then
		ent.CETS_Freezing = tonumber(value) == 1
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "CETS_Freezing_Damage", function(ply, dmginfo)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	if dmginfo:GetDamageType() ~= DMG_GENERIC then
		return
	end

	if dmginfo:GetDamageCustom() == 467565 then
		net.Start("CETS_DMG_FreezingDamageFade")
		net.Send(ply)

		net.Start("CETS_DMG_FreezingDamageIcon")
		net.Send(ply)
		return
	end

	local mins, maxs = ply:WorldSpaceAABB()

	for _, trigger in ipairs(ents.FindInBox(mins, maxs)) do

		if not IsValid(trigger) then continue end
		if trigger:GetClass() ~= "trigger_hurt" then continue end

		if trigger.CETS_Freezing ~= true then continue end

		net.Start("CETS_DMG_FreezingDamageFade")
		net.Send(ply)

		net.Start("CETS_DMG_FreezingDamageIcon")
		net.Send(ply)

		return
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else --- Hace chuy
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_DMG_FreezingDamageFade", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	ply:ScreenFade(SCREENFADE.IN, Color(200, 255, 255, 16), 0.5, 0)

	local sound = "hl1/player/pl_snow" .. math.random(1, 4) .. ".wav"
	local pitch = math.random(80, 150)

	ply:EmitSound(sound, 60, pitch, 1)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end