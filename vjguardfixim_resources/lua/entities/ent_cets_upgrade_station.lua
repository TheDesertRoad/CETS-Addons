AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = true
ENT.PrintName 		= "Combine Fabricator"
ENT.Category	= "Half-Life 2"
ENT.Author 			= "VALVe"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_cets/dave/combine_crafting_station_2.mdl")
		self:SetSolid(SOLID_VPHYSICS)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if CLIENT then return end

	local myPos = self:GetPos()

	for _, charge in ipairs(ents.FindByClass("item_cets_resin")) do
		if not IsValid(charge) then continue end

		if charge:GetPos():DistToSqr(myPos) > (42 * 42) then
			continue
		end

		local nearestPlayer
		local nearestDist = math.huge

		for _, ply in ipairs(player.GetAll()) do
			local dist = ply:GetPos():DistToSqr(myPos)

			if dist < nearestDist then
				nearestDist = dist
				nearestPlayer = ply
			end
		end

		if not IsValid(nearestPlayer) then continue end

		local wep = nearestPlayer:GetActiveWeapon()

		if not IsValid(wep) then continue end

		nearestPlayer.WeaponBoostMultiplier = (nearestPlayer.WeaponBoostMultiplier or 1) + 0.5

		self:EmitSound("hl1/items/suit.wav", 75, 100)
		charge:Remove()
	end

	self:NextThink(CurTime() + 0.25)
	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "WeaponBoosterDamage", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()

	if not IsValid(attacker) then return end
	if not attacker:IsPlayer() then return end

	local mult = attacker.WeaponBoostMultiplier or 1

	if mult > 1 then
		dmginfo:ScaleDamage(mult)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath", "WeaponBoosterReset", function(ply)
	ply.WeaponBoostMultiplier = 1
end)