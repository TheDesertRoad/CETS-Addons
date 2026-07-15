AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/items/classic_misc_consume.mdl")
	self:SetSkin(0)

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
function ENT:StartTouch(ent)
	if not IsValid(ent) or not ent:IsPlayer() then return end

	ent:SetHealth(math.min(ent:Health() + 5, ent:GetMaxHealth()))

	if not ent:GetNWBool("HasSpeedBoost", false) then
		ent.CETS_OriginalWalkSpeed = ent:GetWalkSpeed()
		ent.CETS_OriginalRunSpeed = ent:GetRunSpeed()
		ent:SetWalkSpeed(ent.CETS_OriginalWalkSpeed * 2)
		ent:SetRunSpeed(ent.CETS_OriginalRunSpeed * 1.75)
		ent:SetNWBool("HasSpeedBoost", true)
	end

	ent:EmitSound("hl1/fvox/hiss.wav")

	timer.Create("CETS_SpeedBoost_" .. ent:EntIndex(), GetConVar("sk_cets_adrenaline_time"):GetInt(), 1, function()
		if not IsValid(ent) then return end

		if ent.CETS_OriginalWalkSpeed then
			ent:SetWalkSpeed(ent.CETS_OriginalWalkSpeed)
		end

		if ent.CETS_OriginalRunSpeed then
			ent:SetRunSpeed(ent.CETS_OriginalRunSpeed)
		end

		ent.CETS_OriginalWalkSpeed = nil
		ent.CETS_OriginalRunSpeed = nil
		ent:SetNWBool("HasSpeedBoost", false)
		ent:EmitSound("hl1/items/r_item1.wav", 75, 100)
	end)

	self:Remove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "CETS_SpeedBoostDamageReduction", function(target, dmginfo)
	if not target:IsPlayer() then return end
	if not target:GetNWBool("HasSpeedBoost", false) then return end

	dmginfo:ScaleDamage(0.5)
end)