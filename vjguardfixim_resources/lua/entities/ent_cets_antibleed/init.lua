AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/items/classic_misc_consume.mdl")
	self:SetSkin(2)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self:SetTrigger(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Grenade.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Grenade.ImpactHard" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local BLEED_IMMUNITY_TIME = GetConVar("sk_cets_antibleed_time"):GetInt()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTouch(ent)
	if not IsValid(ent) or not ent:IsPlayer() then return end

	ent.CETS_BleedImmuneUntil = CurTime() + BLEED_IMMUNITY_TIME

	timer.Remove("timer_melee_bleed" .. ent:EntIndex())

	ent:EmitSound("hl1/fvox/hiss.wav")

	timer.Create("CETS_BleedImmunity_" .. ent:EntIndex(), BLEED_IMMUNITY_TIME, 1, function()
		if not IsValid(ent) then return end

		ent.CETS_BleedImmuneUntil = nil
		ent:EmitSound("hl1/items/r_item1.wav")
	end)

	self:Remove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "CETS_BleedImmunity", function(ent, dmginfo)
	if not ent:IsPlayer() then return end
	if not ent.CETS_BleedImmuneUntil then return end
	if CurTime() >= ent.CETS_BleedImmuneUntil then return end

	if VJ and dmginfo:GetDamageCustom() == VJ.DMG_BLEED then
		dmginfo:SetDamage(0)
		return true
	end

	if dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_NEVERGIB) then
		dmginfo:SetDamage(0)
		return true
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Move", "CETS_BleedImmunitySpeed", function(ply, mv)
	if not ply.CETS_BleedImmuneUntil then return end
	if CurTime() >= ply.CETS_BleedImmuneUntil then return end

	if ply:GetWalkSpeed() ~= 200 then
		ply:SetWalkSpeed(200)
	end

	if ply:GetRunSpeed() ~= 400 then
		ply:SetRunSpeed(400)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "CETS_BleedImmunityDSP", function()
	for _, ply in ipairs(player.GetAll()) do
		if not ply.CETS_BleedImmuneUntil then continue end
		if CurTime() >= ply.CETS_BleedImmuneUntil then continue end

		ply:SetDSP(0, false)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath", "CETS_BleedImmunityCleanup", function(ply)
	timer.Remove("CETS_BleedImmunity_" .. ply:EntIndex())
	timer.Remove("timer_melee_bleed" .. ply:EntIndex())

	ply.CETS_BleedImmuneUntil = nil
end)