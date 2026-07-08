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
ENT.Model = {"models/vj_base/projectiles/spit_acid_medium.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true
ENT.DirectDamage = 10	
ENT.DirectDamageType = DMG_ACID
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = {"BeerSplash"}

ENT.IdleSoundPitch = VJ.SET(120,160)
ENT.OnCollideSoundPitch = VJ.SET(100,105)

ENT.SoundTbl_Idle = {"npc/antlion/antlion_poisonball1.wav", "npc/antlion/antlion_poisonball2.wav"}
ENT.SoundTbl_OnCollide = {"npc/antlion_grub/squashed.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetModelScale(1, 1.5)
	ParticleEffectAttach("antlion_spit_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("antlion_spit",data.HitPos,Angle(0,0,0),nil)
end