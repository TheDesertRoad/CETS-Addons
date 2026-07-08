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


	timer.Simple(math.Rand(0.05, 0.2), function()
		if not IsValid(self) then return end

		local pos = self:GetPos()
		if self.RopeCreated then return end
		self.RopeCreated = true

			for z = pos.z, pos.z + 5000, 16 do
				if bit.band(util.PointContents(Vector(pos.x, pos.y, z)), CONTENTS_WATER) == 0 then
					pos.z = z - 16
				break
			end
		end

		self:SetPos(pos)

		local tr = util.TraceLine({
			start = pos,
			endpos = pos - Vector(0,0,10000),
			filter = self
		})

		constraint.Rope(self, game.GetWorld(), 0, 0, vector_origin, tr.HitPos, pos:Distance(tr.HitPos), 0, 0, 1, "cable/hose_black1", false)
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if CLIENT then return end

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

	local ef = EffectData()
	ef:SetOrigin(pos)
	util.Effect("Explosion", ef)

	self:Remove()
end