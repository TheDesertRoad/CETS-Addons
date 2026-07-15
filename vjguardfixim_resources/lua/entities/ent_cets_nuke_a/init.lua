AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_phx/mk-82.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(50)
		phys:Wake()
	end

	self:SetUseType(SIMPLE_USE)
	self:SetActivated(false)
	self.Exploded = false

	self.TickSound = CreateSound(self, "hl1/common/nuke_ticking.wav")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	if self:GetActivated() then
		self:SetActivated(false)

		if self.TickSound then
			self.TickSound:Stop()
			self:EmitSound("hl1/weapons/c4_disarmed.wav", 100, 100)
		end
	else
		self:SetActivated(true)

		if self.TickSound then
			self.TickSound:Play()
			self:EmitSound("hl1/weapons/c4_plant.wav", 100, 100)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmg)
	if not self:GetActivated() then return end
	self:Explode()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	if self.TickSound then
		self.TickSound:Stop()
	end

	local pos = self:GetPos()

	self:EmitSound("weapons/nuke_xplode.wav", 100, 100)
	ParticleEffect("cets_nuke_a", pos, angle_zero)

	self:Remove()

	local timerName = "EntityDamage_" .. self:EntIndex()

	timer.Create(timerName, 0.1, 160, function()
		for _, ent in ipairs(ents.FindInSphere(pos, 20000)) do
			if not IsValid(ent) or ent == self then continue end

			if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
				local dmg = DamageInfo()
				dmg:SetDamage(ent:GetMaxHealth())
				dmg:SetDamageType(bit.bor(DMG_PLASMA, DMG_ALWAYSGIB, DMG_BLAST, DMG_NERVEGAS))
				dmg:SetDamagePosition(pos)

				ent:TakeDamageInfo(dmg)
			end
		end
	end)
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

	if not self:GetActivated() then return end

	if data.Speed >= 800 then
		self:Explode()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if self.TickSound then
		self.TickSound:Stop()
	end
end