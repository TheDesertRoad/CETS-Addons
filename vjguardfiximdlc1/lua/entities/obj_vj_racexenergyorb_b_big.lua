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
ENT.RadiusDamageRadius = 15
ENT.RadiusDamage = 20
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_SHOCK
ENT.DoesDirectDamage = true
ENT.DirectDamage = 30
ENT.DirectDamageType = DMG_SHOCK
ENT.CollisionDecal = "Scorch"
ENT.SoundTbl_OnCollide = {"npc/alien_controller/energyorb_exp.wav", "npc/alien_controller/energyorb_exp2.wav", "npc/alien_controller/energyorb_exp3.wav"}
ENT.SoundTbl_Idle = {"ambient/energy/electric_loop.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Ent = NULL
ENT.Track_Position = defVec
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:DrawShadow(false)
	self:SetNoDraw(true)
	ParticleEffectAttach("racex_arc_03_gas",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("electricball_1",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("model", "sprites/Vortal/vortalenergyorb_c.vmt")
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
	sprite:SetKeyValue("scale", "0.5")
	sprite:SetPos(self:GetPos())
	sprite:Spawn()
	sprite:SetParent(self)
	self:DeleteOnRemove(sprite)
	self.GlowSprite = sprite

	util.SpriteTrail(self, 0, colorWhite, true, 30, 0, 0.3, 1 / 12 * 0.5, "sprites/Vortal/orb_trail_3.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local trackedEnt = self.Track_Ent
	-- Homing Behavior
	if IsValid(trackedEnt) then
		self.DirectDamage = 15
		if IsValid(self.GlowSprite) then
			self.GlowSprite:SetKeyValue("scale", "0.1")
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
function ENT:DeathEffects(data,phys)
	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.2, 4, 200, 8, 3, Color(0, 86, 255, 128))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	local hitEnt = data.HitEntity

	if !IsValid(hitEnt) then return end
	if hitEnt == self then return end

	local timerName = "ShockRifleTesla_" .. hitEnt:EntIndex()

	local attacker = self:GetOwner()

	if !IsValid(attacker) then
		attacker = self
	end

	timer.Remove(timerName)

	local ticks = 0

	hitEnt:EmitSound("ambient/energy/zap" .. math.random(1, 3) .. ".wav", 70, math.random(90, 110))

	timer.Create(timerName, 0.1, 50, function()
		if !IsValid(hitEnt) then
			timer.Remove(timerName)
			return
		end

		ticks = ticks + 1

		local effectdata = EffectData()
		effectdata:SetOrigin(hitEnt:GetPos())
		effectdata:SetEntity(hitEnt)
		effectdata:SetMagnitude(3)
		effectdata:SetScale(1)
		effectdata:SetRadius(1)

		util.Effect("TeslaHitboxes", effectdata, true, true)

		if ticks % 5 == 0 then
			hitEnt:EmitSound("hl1/debris/zap" .. math.random(1, 8) .. ".wav", 65, math.random(90, 110))
		end

		if ticks % 10 == 0 then
			local dmginfo = DamageInfo()

			dmginfo:SetDamage(2)
			dmginfo:SetDamageType(DMG_SHOCK)
			dmginfo:SetAttacker(attacker)
			dmginfo:SetInflictor(IsValid(self) and self or attacker)
			dmginfo:SetDamagePosition(hitEnt:GetPos())

			hitEnt:TakeDamageInfo(dmginfo)
		end
	end)
end