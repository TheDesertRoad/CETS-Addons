AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_vj_animatable"
ENT.PrintName = "Classic Health Kit"
ENT.Author = "VALVe"
ENT.Spawnable = true
ENT.Category = "Half-Life 2"
ENT.trigger = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/items/classic_healthkit.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	hook.Add("GravGunOnPickedUp", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	hook.Add("OnPlayerPhysicsPickup", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	hook.Add("OnPhysgunPickup", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	if SERVER then
		self:SetTrigger(true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(ply)
	if not ply:IsPlayer() then return end
	if self:Touch(ply) then return end
	ply:PickupObject(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	local maxHealth = ply:GetMaxHealth()
	local currentHealth = ply:Health()

	local healAmount = 30
	ply:SetHealth(math.min(currentHealth + healAmount, maxHealth))

	if currentHealth < maxHealth then
		self:EmitSound("items/smallmedkit1.wav")
		self:Remove()
	elseif currentHealth == maxHealth then
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end