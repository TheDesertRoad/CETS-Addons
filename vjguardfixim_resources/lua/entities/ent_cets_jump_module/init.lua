AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/weapons/w_hl2_longjump.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(true)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(activator)
	if not IsValid(activator) or not activator:IsPlayer() then return end
	if not activator:Alive() then return end

	if activator:GetNWBool("HasLongJump", false) then
		return
	end

	activator:SetNWBool("HasLongJump", true)
	activator:EmitSound("hl1/fvox/bloop.wav")

	self:Remove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	if self.NextImpactSound == nil then
		self.NextImpactSound = 0
	end

	if data.Speed > 60 and CurTime() >= self.NextImpactSound then
		self:EmitSound("physics/metal/metal_box_impact_hard" .. math.random(1, 3) .. ".wav", math.Clamp(data.Speed / 10, 60, 90), 100)

		self.NextImpactSound = CurTime() + 0.15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end