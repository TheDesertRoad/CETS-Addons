AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_vj_animatable"
ENT.PrintName = "Classic Armor"
ENT.Author = "VALVe"
ENT.Spawnable = true
ENT.Category = "Half-Life 2"
ENT.trigger = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/items/classic_battery.mdl")
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

	local maxHealth = ply:GetMaxArmor()
	local currentHealth = ply:Armor()

	local healAmount = 15
	ply:SetArmor(math.min(currentHealth + healAmount, maxHealth))

	self.AppliedCharge = true

	if currentHealth < maxHealth then
		self:EmitSound("items/battery_pickup.wav")
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