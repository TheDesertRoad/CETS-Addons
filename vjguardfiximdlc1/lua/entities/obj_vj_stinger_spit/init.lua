/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_superspit"
ENT.PrintName		= "Acid Spit"

ENT.IdleSoundPitch = VJ.SET(120,140)
ENT.IdleSoundLevel = 80

ENT.SoundTbl_Idle = {"npc/antlion/antlion_poisonball1.wav", "npc/antlion/antlion_poisonball2.wav"}
ENT.SoundTbl_OnCollide = "npc/stinger/stinger_impact01.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNoDraw(true)
	ParticleEffectAttach("acid_trails_fungal",PATTACH_ABSORIGIN_FOLLOW,self,0)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())

	util.SpriteTrail(self, 1, Color(255, 16, 86, 32), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")
	util.SpriteTrail(self, 1, Color(16, 255, 86, 32), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")

	self.CollisionDecal = {"BeerSplash"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("fungal_floaters",data.HitPos,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit",data.HitPos,Angle(0,0,0),nil)
end