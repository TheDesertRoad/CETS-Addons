/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Jeff Vomit"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/vj_base/projectiles/spit_acid_large.mdl", "models/vj_base/projectiles/spit_acid_medium.mdl"} -- The models it should spawn with | Picks a random one from the table

ENT.DoesRadiusDamage = false
ENT.RadiusDamage = 30
ENT.RadiusDamageRadius = 1
ENT.RadiusDamageType = bit.bor(DMG_ACID)

ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = {"BeerSplash"}

ENT.IdleSoundPitch = VJ.SET(85,95)
ENT.OnCollideSoundPitch = VJ.SET(80,100)

ENT.SoundTbl_Idle = {"npc/antlion/antlion_poisonball1.wav", "npc/antlion/antlion_poisonball2.wav"}
ENT.SoundTbl_OnCollide = "npc/stinger/stinger_impact01.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	ParticleEffectAttach("jeff_trails_new",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("jeff_slime_small",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("jeff_gas",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("jeff_gas",PATTACH_ABSORIGIN_FOLLOW,self,0)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
	self:SetNoDraw(true)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:EnableDrag(false)
	phys:SetMass(20)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	util.VJ_SphereDamage(self,self,self:GetPos(),120,30,DMG_NERVEGAS,true,true)
	ParticleEffect("jeff_gas",data.HitPos,Angle(0,0,0),nil)
	ParticleEffect("jeff_vomit",data.HitPos,Angle(0,0,0),nil)
end