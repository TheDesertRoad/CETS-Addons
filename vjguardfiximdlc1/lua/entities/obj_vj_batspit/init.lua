AddCSLuaFile("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_acidspit"
ENT.PrintName		= "Acid Spit"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/vj_base/projectiles/spit_acid_medium.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true
ENT.DirectDamage = 10	
ENT.DirectDamageType = DMG_ACID
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = "BeerSplash"

ENT.IdleSoundPitch = VJ.SET(90,110)
ENT.OnCollideSoundPitch = VJ.SET(95,105)

ENT.OnCollideSoundLevel = 55

ENT.SoundTbl_Idle = {"npc/bullsquid/acid1.wav", "npc/bullsquid/acid2.wav"}
ENT.SoundTbl_OnCollide = {"npc/bullsquid/spithit1.wav", "npc/bullsquid/spithit2.wav", "npc/bullsquid/spithit3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if self:WaterLevel() > 0 then 
		self:SetNoDraw(true)
		ParticleEffectAttach("acid_trails_bat_water",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())

		util.SpriteTrail(self, 1, Color(183, 146, 22, 32), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")

		self.CollisionDecal = false
	else
		self:SetModelScale(1.5, 1, 2)
		ParticleEffectAttach("acid_trails_bat",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:SetAngles(self:GetVelocity():GetNormal():Angle())
		self:SetNoDraw(true)
		self.CollisionDecal = "BeerSplash"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("racex_arc_02_gas",data.HitPos,Angle(0,0,0),nil)
end