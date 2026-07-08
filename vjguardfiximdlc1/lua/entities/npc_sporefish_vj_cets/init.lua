AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_sporefish.mdl"
ENT.StartHealth = 70
ENT.HullType = HULL_SMALL
ENT.TurningUseAllAxis = true

ENT.CanChatMessage = false
ENT.ConstantlyFacingEnemy = true

ENT.MovementType = VJ_MOVETYPE_AQUATIC

ENT.Aquatic_SwimmingSpeed_Calm = 80
ENT.Aquatic_SwimmingSpeed_Alerted = 200
ENT.Aquatic_GroundLimit = 16
ENT.Aquatic_AnimTbl_Idle = {"idle1", "idle2", "idle3"}
ENT.Aquatic_AnimTbl_Calm = {"swim"}
ENT.Aquatic_AnimTbl_Alerted = {"swim_fast"}
ENT.Aquatic_AnimTbl_Alert = {"swim"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Green"
ENT.BloodDecal = "VJ_CETS_GBlood"
ENT.BloodParticle = "blood_impact_antlion_worker_01"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.AnimTbl_MeleeAttack = {"bite"}
ENT.TimeUntilMeleeAttackDamage = 0.03
ENT.NextAnyAttackTime_Melee = 0.8
ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 55

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {"shoot", "burst_small"}
ENT.RangeUseBoneForPos = true
ENT.RangeUseBoneForPosID = "Dummy12"
ENT.RangeAttackEntityToSpawn = "obj_vj_acidspit"
ENT.RangeDistance = 2000
ENT.RangeToMeleeDistance = 60
ENT.TimeUntilRangeAttackProjectileRelease = 0.4
ENT.RangeAttackExtraTimers = {0.5,0.6,0.7}
ENT.NextRangeAttackTime = 2.2

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {"flinch1", "flinch2"}
ENT.FlinchChance = 6

ENT.SoundTbl_MeleeAttack = {"hl1/weapons/splauncher_altfire.wav"}
ENT.SoundTbl_Idle = {"hl1/weapons/splauncher_pet.wav"}
ENT.SoundTbl_RangeAttack = {"hl1/weapons/splauncher_fire.wav"}
ENT.SoundTbl_Pain = {"hl1/weapons/splauncher_pet.wav"}
ENT.SoundTbl_Death = {"hl1/weapons/splauncher_pet.wav"}

ENT.MainSoundPitch = 100
ENT.PainSoundPitch = 150
ENT.DeathSoundPitch = 150
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 10, 15), Vector(-8, -10, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth(), self, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projectile:GetPos() + VectorRand(-15, 15), 0, 0.001)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	if self:WaterLevel() > 0 then 
		if status == "Init" then
			local pos = self:GetPos() +self:GetAngles():Forward() *25
			effects.Bubbles(pos +Vector(-8, -8, -8), pos +Vector(8, 8, 8), math.random(4, 24), math.random(100, 300), 1)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self, "garrysmod/balloon_pop_cute.wav", 75, 100)
	VJ_EmitSound(self, "phx/eggcrack.wav", 150, 100)
	util.VJ_SphereDamage(self,self,self:GetPos(),80,23,DMG_ACID,true,true)
	ParticleEffect("AntlionGib",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_slime",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end