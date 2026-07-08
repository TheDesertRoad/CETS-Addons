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
ENT.DoesDirectDamage = true
ENT.DirectDamage = 16
ENT.DirectDamageType = DMG_SHOCK
ENT.CollisionDecal = "VJ_CETS_Burnt1_Small"
ENT.SoundTbl_OnCollide = {"npc/alien_controller/energyorb_exp.wav", "npc/alien_controller/energyorb_exp2.wav", "npc/alien_controller/energyorb_exp3.wav"}
ENT.SoundTbl_Idle = "npc/alien_controller/energyorb_loop.wav"

ENT.MainSoundPitch = VJ.SET(95, 105)
ENT.OnCollideSoundLevel = 60

local defVec = Vector(0, 0, 0)

ENT.Track_Ent = NULL
ENT.Track_Position = defVec

ENT.Vort_Exp = false
ENT.Tracking = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	self:PhysicsInitSphere(1)
	construct.SetPhysProp(self:GetOwner(), self, 0, self:GetPhysicsObject(), {GravityToggle = false})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.Vort_Lifetime = CurTime() + math.Rand(3, 6)
	self:SetSpawnEffect(true)
	self:DrawShadow(false)
	self:SetNoDraw(true)
	ParticleEffectAttach("electricball_3",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("model", "sprites/Vortal/vortalenergyorb.vmt")
	//sprite:SetKeyValue("rendercolor", "0 0 0")
	sprite:SetKeyValue("GlowProxySize", "0.0")
	sprite:SetKeyValue("HDRColorScale", "1")
	sprite:SetKeyValue("renderfx", "14")
	sprite:SetKeyValue("rendermode", "3")
	sprite:SetKeyValue("renderamt", "255")
	sprite:SetKeyValue("disablereceiveshadows", "0")
	sprite:SetKeyValue("mindxlevel", "0")
	sprite:SetKeyValue("maxdxlevel", "0")
	sprite:SetKeyValue("framerate", "11")
	sprite:SetKeyValue("spawnflags", "0")
	sprite:SetKeyValue("scale", "0.1")
	sprite:SetPos(self:GetPos())
	sprite:Spawn()
	sprite:SetParent(self)
	self:DeleteOnRemove(sprite)
	self.GlowSprite = sprite

	util.SpriteTrail(self, 0, colorWhite, true, 15, 0, 0.1, 1 / 6 * 0.5, "sprites/Vortal/orb_trail_1.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local trackedEnt = self.Track_Ent
	if !self.Vort_Exp && CurTime() > self.Vort_Lifetime then
		self.Vort_Exp = true
		self.HasDeathSounds = false
		self:Destroy(data, phys)
		self:SetGroundEntity(NULL)
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
			phys:SetVelocity(VJ.CalculateTrajectory(self, trackedEnt, "Line", self:GetPos(), self.Track_Position, 650))
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
	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.2, 1, 200, 8, 3, Color(255, 128, 0, 64))
end