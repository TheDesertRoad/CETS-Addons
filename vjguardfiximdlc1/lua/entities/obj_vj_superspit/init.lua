/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Acid Spit"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/vj_base/projectiles/spit_acid_large.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true
ENT.DirectDamage = 33
ENT.DirectDamageType = DMG_ACID
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = {"VJ_Splat_Acid"}

ENT.IdleSoundPitch = VJ.SET(85,95)
ENT.OnCollideSoundPitch = VJ.SET(80,100)

ENT.SoundTbl_Idle = {"npc/antlion/antlion_poisonball1.wav", "npc/antlion/antlion_poisonball2.wav"}
ENT.SoundTbl_OnCollide = {"npc/antlion_grub/squashed.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if self:WaterLevel() > 0 then 
		self:SetNoDraw(true)
		ParticleEffectAttach("acid_trails_water",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())

		util.SpriteTrail(self, 1, Color(255, 16, 86, 32), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")
		util.SpriteTrail(self, 1, Color(16, 255, 86, 32), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")

		self.CollisionDecal = {"BeerSplash"}
	else
		self:SetModelScale(1.5, 1, 2)
		ParticleEffectAttach("antlion_spit_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())
		self.CollisionDecal = {"VJ_Splat_Acid"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:WaterLevel() > 0 then 
		local pos = self:GetPos() +self:GetAngles():Forward()
		effects.BubbleTrail(pos +Vector(-1, -1, -1), pos +Vector(1, 1, 1), math.random(0.5, 1), 0, 12, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("antlion_gib_02_gas",data.HitPos,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit",data.HitPos,Angle(0,0,0),nil)
end