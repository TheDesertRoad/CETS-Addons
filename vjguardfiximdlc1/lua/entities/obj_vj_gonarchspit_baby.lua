/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Gonarch Spit"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 120
ENT.RadiusDamage = 15
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_ACID
ENT.CollisionDecal = "VJ_CETS_Mom"

ENT.IdleSoundPitch = VJ.SET(60, 65)
ENT.OnCollideSoundPitch = VJ.SET(60, 65)

ENT.SoundTbl_Idle = {"npc/antlion/antlion_poisonball1.wav", "npc/antlion/antlion_poisonball2.wav"}
ENT.SoundTbl_OnCollide = {"npc/stinger/stinger_impact01.wav"}

local defAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	self:DrawShadow(false)
	ParticleEffect("gonarch_gas1", self:GetPos(), defAng)
	ParticleEffectAttach("gonarch_floaters", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("gonarch_trails_2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	ParticleEffect("gonarch_gas1", data.HitPos, defAng)
	self.Headcrab = ents.Create("npc_babycrab_vj_cets")
	self.Headcrab:SetPos(self:GetPos() + self:GetUp()*16)
	self.Headcrab:Spawn()
	self.Headcrab:Activate() 
	self.Headcrab:SetOwner(self)
	self:SetGroundEntity(NULL)
end