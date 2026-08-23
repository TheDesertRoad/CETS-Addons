/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Energy Orb"

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 32
ENT.RadiusDamage = 25
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_SHOCK
ENT.DoesDirectDamage = true
ENT.DirectDamage = 128
ENT.DirectDamageType = DMG_DISSOLVE
ENT.CollisionDecal = "Scorch"
ENT.SoundTbl_OnCollide = {"npc/alien_controller/energyorb_exp.wav", "npc/alien_controller/energyorb_exp2.wav", "npc/alien_controller/energyorb_exp3.wav"}
ENT.SoundTbl_Idle = "npc/alien_controller/energyorb_loop.wav"

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Ent = NULL
ENT.Track_Position = defVec
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.Vort_Lifetime = CurTime() + math.Rand(6, 12)

	self:EmitSound("hl1/weapons/mine_charge.wav", 70, 50)

	self:SetSpawnEffect(true)
	self:DrawShadow(false)
	self:SetNoDraw(true)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	ParticleEffectAttach("gargantua_stomp",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("gargantua_stomp3",PATTACH_ABSORIGIN_FOLLOW,self,0)

	util.SpriteTrail(self, 0, Color(255, 0, 0), true, 32, 0, 2, 1, "sprites/baku_burntcer_smoke.vmt")

	self:PhysicsInitSphere(1)
	construct.SetPhysProp(self:GetOwner(), self, 0, self:GetPhysicsObject(), {GravityToggle = false})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local trackedEnt = self.Track_Ent
	if !self.Vort_Exp && CurTime() > self.Vort_Lifetime then
		self.Vort_Exp = true
		self.HasDeathSounds = false
		self:Destroy(data, phys)
		self:SetGroundEntity(NULL)
		self:StopSound("hl1/weapons/mine_charge.wav")
		VJ.EmitSound(self, self.SoundTbl_OnCollide)
	end

	hook.Add("GravGunOnPickedUp", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	if IsValid(trackedEnt) && self.Tracking == 1 then -- Homing Behavior
		local pos = trackedEnt:GetPos() + trackedEnt:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end

		local phys = self:GetPhysicsObject()
		if IsValid(phys) && self.Tracking == 1 then
			phys:SetVelocity(VJ.CalculateTrajectory(self, trackedEnt, "Line", self:GetPos(), self.Track_Position, 200))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GravGunPunt(ply)
	self.Tracking = 0
	self:GetPhysicsObject():EnableMotion(true)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	self:StopSound("hl1/weapons/mine_charge.wav")
	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.4, 2, 255, 32, 3, Color(255, 128, 128, 128))
end