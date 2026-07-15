AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_vj_animatable"
ENT.PrintName = "Classic Health Kit"
ENT.Author = "VALVe"
ENT.Spawnable = true
ENT.Category = "Half-Life 2"
ENT.SubCategory = "Ammo and Items"
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

	if SERVER then
		self:SetTrigger(true)
		self:SetUseType(SIMPLE_USE)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Weapon.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Weapon.ImpactHard" )
	end
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