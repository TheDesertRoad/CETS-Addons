/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "XEnergy Orb"

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 33
ENT.DirectDamageType = DMG_SHOCK

ENT.CollisionDecal = {"Scorch"}
ENT.IdleSoundLevel = 60
ENT.OnCollideSoundLevel = 80
ENT.OnCollideSoundPitch = VJ.SET(100)

ENT.SoundTbl_OnCollide = {"hl1/weapons/electro4.wav", "hl1/weapons/electro5.wav", "hl1/weapons/electro6.wav"}
ENT.SoundTbl_Idle = {"hl1/ambience/electrical_hum1.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Ent = NULL
ENT.Track_Position = defVec

ENT.Tracking = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	self:PhysicsInitSphere(1)
	construct.SetPhysProp(self:GetOwner(), self, 0, self:GetPhysicsObject(), {GravityToggle = false})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:DrawShadow(false)
	self:SetNoDraw(true)
	ParticleEffectAttach("electricball_2",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("model", "sprites/Vortal/vortalenergyorb_b.vmt")
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
	sprite:SetKeyValue("scale", "0.15")
	sprite:SetPos(self:GetPos())
	sprite:Spawn()
	sprite:SetParent(self)
	self:DeleteOnRemove(sprite)
	self.GlowSprite = sprite

	util.SpriteTrail(self, 0, colorWhite, true, 15, 0, 0.1, 1 / 6 * 0.5, "sprites/Vortal/orb_trail_2.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local trackedEnt = self.Track_Ent
	-- Homing Behavior

	hook.Add("GravGunOnPickedUp", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	if IsValid(trackedEnt) then
		self.DirectDamage = 33
		if IsValid(self.GlowSprite) then
			self.GlowSprite:SetKeyValue("scale", "0.2")
		end
		local pos = trackedEnt:GetPos() + trackedEnt:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self, trackedEnt, "Line", self:GetPos(), self.Track_Position, 700))
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
	util.VJ_SphereDamage(self,self,self:GetPos(),48,15,DMG_SHOCK,true,true)
	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.2, 1, 400, 16, 3, Color(255, 0, 255, 64))
end