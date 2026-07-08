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
ENT.RadiusDamageRadius = 10
ENT.RadiusDamage = 10
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_SHOCK
ENT.DoesDirectDamage = true
ENT.DirectDamage = 10
ENT.DirectDamageType = DMG_SHOCK
ENT.CollisionDecal = "VJ_CETS_Burnt1_Small"
ENT.SoundTbl_OnCollide = {"ambient/energy/weld1.wav", "ambient/energy/weld2.wav"}
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
	sprite:SetKeyValue("scale", "0.1")
	sprite:SetPos(self:GetPos())
	sprite:Spawn()
	sprite:SetParent(self)
	self:DeleteOnRemove(sprite)
	self.GlowSprite = sprite

	util.SpriteTrail(self, 0, colorWhite, true, 15, 0, 0.1, 1 / 6 * 0.5, "sprites/Vortal/orb_trail_3.vmt")

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
	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.2, 1, 200, 8, 3, Color(0, 86, 255, 64))
end