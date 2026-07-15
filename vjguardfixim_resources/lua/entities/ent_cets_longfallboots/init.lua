AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props/hl2_knees.mdl")

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
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTouch(ent)
	if not IsValid(ent) or not ent:IsPlayer() then return end
	if ent:GetNWBool("HasFallDampener") then return end

	ent:SetNWBool("HasFallDampener", true)
	ent:EmitSound("weapons/rocket/rocket_locking_beep1.wav")
	ent:EmitSound("items/ammo_pickup.wav")

	self:Remove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	if self.NextImpactSound == nil then
		self.NextImpactSound = 0
	end

	if data.Speed > 64 and CurTime() >= self.NextImpactSound then
		self:EmitSound("physics/metal/weapon_impact_hard" .. math.random(1, 3) .. ".wav", math.Clamp(data.Speed / 10, 60, 90), 100)

		self.NextImpactSound = CurTime() + 0.15
	end

	if data.Speed > 2 and CurTime() >= self.NextImpactSound then
		self:EmitSound("physics/metal/weapon_impact_soft" .. math.random(1, 3) .. ".wav", math.Clamp(data.Speed / 10, 60, 90), 100)

		self.NextImpactSound = CurTime() + 0.15
	end
end