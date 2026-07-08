/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_superspit"
ENT.PrintName		= "Acid Spit"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = "Blood"

ENT.IdleSoundPitch = VJ.SET(90,110)
ENT.OnCollideSoundPitch = VJ.SET(95,105)

ENT.OnCollideSoundLevel = 55

ENT.SoundTbl_Idle = {"npc/bullsquid/acid1.wav", "npc/bullsquid/acid2.wav"}
ENT.SoundTbl_OnCollide = {"npc/bullsquid/spithit1.wav", "npc/bullsquid/spithit2.wav", "npc/bullsquid/spithit3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNoDraw(true)
	ParticleEffectAttach("blood_impact_red_01",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("blood_zombie_split",PATTACH_ABSORIGIN_FOLLOW,self,0)
	if self:WaterLevel() > 0 then 
		self:SetNoDraw(true)
		ParticleEffectAttach("acid_trails_water_b",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())

		util.SpriteTrail(self, 1, Color(210, 0, 16, 64), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")
	else
		ParticleEffectAttach("gonome_trails",PATTACH_ABSORIGIN_FOLLOW,self,0)
		ParticleEffect("jeff_juice",self:GetPos(),Angle(0,0,0),nil)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())
		self:SetColor(Color(210, 0, 16, 0))
		util.SpriteTrail(self, 1, Color(210, 0, 16, 16), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt") 
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("gonome_gas",data.HitPos,Angle(0,0,0),nil)
	ParticleEffect("jeff_juice",data.HitPos,Angle(0,0,0),nil)
	ParticleEffect("jeff_trailsB",data.HitPos,Angle(0,0,0),nil)
end