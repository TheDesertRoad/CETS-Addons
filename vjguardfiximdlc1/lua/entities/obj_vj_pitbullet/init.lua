/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Pit Bullet"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/racex/hl2_pitdrone_spike.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true
ENT.DirectDamage = 17
ENT.DirectDamageType = DMG_ACID
ENT.CollisionDecal = "YellowBlood"
ENT.SoundTbl_OnCollide = {"npc/ministrider/flechette_impact_stick1.wav", "npc/ministrider/flechette_impact_stick2.wav", "npc/ministrider/flechette_impact_stick3.wav", "npc/ministrider/flechette_impact_stick4.wav", "npc/ministrider/flechette_impact_stick5.wav"}
ENT.SoundTbl_Idle = {"npc/ministrider/flechetteltor01.wav", "npc/ministrider/flechetteltor02.wav", "npc/ministrider/flechetteltor03.wav", "npc/ministrider/flechetteltor04.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if self:WaterLevel() > 0 then 
		ParticleEffectAttach("acid_trails_water",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())

		util.SpriteTrail(self, 1, Color(255, 16, 86, 32), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")
		util.SpriteTrail(self, 1, Color(16, 255, 86, 32), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")
	else
		ParticleEffectAttach("antlion_spit_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		ParticleEffect("antlion_spit",self:GetPos(),Angle(0,0,0),nil)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:WaterLevel() > 0 then 
		local pos = self:GetPos() +self:GetAngles():Forward()
		effects.BubbleTrail(pos +Vector(-1, -1, -1), pos +Vector(1, 1, 1), math.random(3, 6), 0, 20, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("antlion_spit_02",data.HitPos,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit_03",data.HitPos,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit_05",data.HitPos,Angle(0,0,0),nil)
end