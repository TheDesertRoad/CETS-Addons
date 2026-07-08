AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_flock_float.mdl"
ENT.StartHealth = 20
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 200
ENT.Aerial_FlyingSpeed_Alerted = 600
ENT.Aerial_AnimTbl_Calm = ACT_IDLE
ENT.Aerial_AnimTbl_Alerted = ACT_IDLE
ENT.AA_GroundLimit = 32
ENT.TurningSpeed = 20
ENT.Immune_Toxic = true
ENT.ConstantlyFacingEnemy = true
ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_FUNGUS"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecal = "VJ_CETS_Voltigore_Blood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasDeathCorpse = true
ENT.HasExtraMeleeAttackSounds = true

ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = false
ENT.TimeUntilRangeAttackProjectileRelease = 0.1
ENT.NextRangeAttackTime = 2
ENT.RangeAttackProjectiles = "obj_vj_stinger_spit"
ENT.RangeAttackMaxDistance = 2500
ENT.RangeAttackMinDistance = 1

ENT.CanFlinch = false

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.SoundTbl_Breath = {"npc/alienfauna/toxicemit.wav"}
ENT.SoundTbl_Idle = {"npc/floater/fl_idle1.wav", "npc/floater/fl_idle2.wav", "npc/floater/fl_idle3.wav", "npc/floater/fl_idle4.wav", "npc/floater/fl_idle5.wav", "npc/floater/fl_idle6.wav", }
ENT.SoundTbl_Alert = {"npc/floater/fl_alert1.wav", "npc/floater/fl_alert2.wav", "npc/floater/fl_alert3.wav", "npc/floater/fl_alert4.wav"}
ENT.SoundTbl_RangeAttack = {"npc/floater/fl_attack1.wav", "npc/floater/fl_attack2.wav", "npc/floater/fl_attack3.wav"}
ENT.SoundTbl_Pain = {"npc/floater/fl_pain1.wav", "npc/floater/fl_pain2.wav"}
ENT.SoundTbl_Death = {"npc/floater/fl_pain1.wav", "npc/floater/fl_pain2.wav"}

ENT.BreathSoundLevel = 65
ENT.AlertSoundLevel = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.HasDeathCorpse = false
	self:SetCollisionBounds(Vector(10, 10, 20), Vector(-10, -10, -22))

	util.SpriteTrail(self, 1, Color(255, 16, 86, 32), true, 30, 0, 1.5, 0.2, "sprites/smoke.vmt")
	util.SpriteTrail(self, 1, Color(16, 255, 86, 32), true, 30, 0, 1.5, 0.2, "sprites/smoke.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	util.VJ_SphereDamage(self,self,self:GetPos(),100,1,DMG_NERVEGAS,true,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	ParticleEffect("fungal_gas1",self:GetPos() + self:GetUp()* 5,Angle(0,0,0),nil)

	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth(), self, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 10 + self:GetForward() * -20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Curve", projectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 600)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot1.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
	ParticleEffect("antlion_gib_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_gas",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end