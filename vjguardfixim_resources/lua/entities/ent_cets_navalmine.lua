AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = true
ENT.PrintName 		= "Sea Mine"
ENT.Category	= "Half-Life 2"
ENT.Author 			= "VALVe"

ENT.RopeCreated = false
ENT.Exploded = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if CLIENT then return end

	self:SetModel("models/props_cets/roller_spikes.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableGravity(false)
		end

	self:SetTrigger(true)

	if self:WaterLevel() > 0 then
		timer.Simple(math.Rand(0.05, 0.2), function()
			if not IsValid(self) then return end
			if self.RopeCreated then return end

			self.RopeCreated = true

			local pos = self:GetPos()
			local surface = pos

			for z = pos.z, pos.z + 5000, 8 do
				local p = Vector(pos.x, pos.y, z)

				if bit.band(util.PointContents(p), CONTENTS_WATER) == 0 then
				surface = Vector(pos.x, pos.y, z - 8)
					break
				end
			end

			self:SetPos(surface - Vector(0, 0, 16))

			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self:GetPos() - Vector(0, 0, 10000),
				mask = MASK_SOLID_BRUSHONLY,
				filter = self
			})

			if not tr.Hit then return end

			constraint.Rope(self, game.GetWorld(), 0, 0, vector_origin, tr.HitPos, self:GetPos():Distance(tr.HitPos), 0, 0, 1, "cable/hose_black1", false)
		end)
	else
		self:SetCollisionBounds(Vector(2, 2, 5), Vector(-2, -2, -5))
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if CLIENT then return end

	if self:WaterLevel() > 0 then
		local phys = self:GetPhysicsObject()
		if not IsValid(phys) then return end

		local t = CurTime()
		local strength = 2
		local speed = 0.2
		local fx = math.sin(t * speed) * strength
		local fy = math.cos(t * speed) * strength
		local force = Vector(fx, fy, 0)

		phys:ApplyForceCenter(force)

		self:NextThink(CurTime())

		return true
	else

	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(ent)
	if self.Exploded then return end
	if IsValid(ent) then
		self:Detonate()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmg)
	self:Detonate()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Detonate()
	if self.Exploded then return end
	self.Exploded = true
	self.LastDet = CurTime()

	local pos = self:GetPos()

	util.BlastDamage(self, self, pos, 300, 400)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 4) .. ".wav", 100, 100)

	if self:WaterLevel() > 0 then
		local ef = EffectData()
		ef:SetOrigin(pos)
		ef:SetScale(2)
		util.Effect("WaterSurfaceExplosion", ef)
	else
		local ef = EffectData()
		ef:SetOrigin(pos)
		ef:SetScale(2)
		util.Effect("Explosion", ef)
	end

	self:Remove()
end