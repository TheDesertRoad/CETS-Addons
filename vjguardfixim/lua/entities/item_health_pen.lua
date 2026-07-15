AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_vj_animatable"
ENT.PrintName = "Health Pen"
ENT.SubCategory = "Ammo and Items"
ENT.Author = "VALVe"
ENT.Spawnable = true
ENT.Category = "Half-Life 2"
ENT.trigger = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/hl2_healthpen.mdl")
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
function ENT:Use(ply)
	if not ply:IsPlayer() then return end
	if self:Touch(ply) then return end
	ply:PickupObject(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Plastic_Box.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Plastic_Box.ImpactHard" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	local maxHealth = ply:GetMaxHealth()
	local currentHealth = ply:Health()

	local healAmount = 5
	ply:SetHealth(math.min(currentHealth + healAmount, maxHealth))

	if currentHealth < maxHealth then
		self:EmitSound("hl1/items/medshot5.wav")
		self:EmitSound("weapons/crossbow/hitbod1.wav")
		self:Remove()
	elseif currentHealth == maxHealth then
		return false
	end

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local pen = ents.Create("prop_physics")
	pen:SetModel("models/hl2_healthpen.mdl")
	pen:SetSkin(1)
	pen:SetPos(pos)
	pen:SetAngles(ang)
	pen:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	pen:Spawn()
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end