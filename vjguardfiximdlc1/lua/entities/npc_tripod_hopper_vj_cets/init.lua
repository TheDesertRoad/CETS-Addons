AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_hopper.mdl"
ENT.StartHealth = 5
ENT.HullType = HULL_SMALL
ENT.Immune_Toxic = true

ENT.CanChatMessage = false

ENT.VJ_NPC_Class = {"CLASS_FUNGUS"}

ENT.JumpParams = {
	MaxRise = 2000,
	MaxDrop = 2500,
	MaxDistance = 2500
}

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "Antlion.Head_Bone",
    FirstP_Offset = Vector(15, 0, 2),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"attack_stab"}
ENT.AttackProps = false -- Should it attack props when trying to move?
ENT.PushProps = true
ENT.TimeUntilMeleeAttackDamage = 0.3
ENT.MeleeAttackDistance = 16 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?
ENT.NextMeleeAttackTime = 0.5 -- How much time until it can use a melee attack?
ENT.HasMeleeAttack = true 
ENT.MeleeAttackDamage = 30
ENT.MeleeAttackDamageType = DMG_SLASH

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1. -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 5 -- How many repetitions?

ENT.HasRangeAttack = true

ENT.AnimTbl_RangeAttack = {"attack_stab"}

ENT.RangeAttackProjectiles = "obj_vj_stinger_spit"
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 3
ENT.RangeAttackMaxDistance = 1500
ENT.RangeAttackMinDistance = 32

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = "attack_jump"
ENT.AnimTbl_StopLeapAttack = "jump_land"
ENT.LeapAttackMaxDistance = 4000
ENT.LeapAttackMinDistance = 200
ENT.TimeUntilLeapAttackDamage = 0.2
ENT.NextLeapAttackTime = 1
ENT.NextAnyAttackTime_Leap = 1
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.4}
ENT.TimeUntilLeapAttackVelocity = 0.2
ENT.LeapAttackDamage = 10
ENT.LeapAttackDamageDistance = 100

ENT.HasExtraMeleeAttackSounds = true
ENT.MainSoundPitch = 100

ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_Postures = "Moving"
ENT.ConstantlyFaceEnemy_MinDistance = 500

ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav", "npc/headcrab_poison/ph_step2.wav", "npc/headcrab_poison/ph_step3.wav", "npc/headcrab_poison/ph_step4.wav"}

ENT.FootStepSoundLevel = 50
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.4 -- Next foot step sound when it is walking

ENT.SoundTbl_Alert = {
	"npc/hopper/hopper_alert1.wav",
	"npc/hopper/hopper_alert2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/alienfauna/pain1.wav",
	"npc/alienfauna/pain2.wav",
}

ENT.SoundTbl_Death = {
	"npc/alienfauna/die1.wav",
	"npc/alienfauna/die2.wav",
}

ENT.SoundTbl_MeleeAttack = {
	"npc/headcrab/headbite.wav",
}

ENT.SoundTbl_LeapAttack = {
	"npc/headcrab/headbite.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_BeforeLeapAttack = "npc/headcrab/attack1.wav"

ENT.SoundTbl_RangeAttack = {
	"npc/alienfauna/spit1.wav",
	"npc/alienfauna/spit2.wav",
}

ENT.Hopp_StartedLeapAttack = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) then 
			self:VJ_ACT_PLAYACTIVITY("sleep_start",true,1,false)
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.CanTurnWhileStationary = false
			self.HasLeapAttack = false
			self.SightDistance = 1 
			self.IsGuard = true
			self.CallForHelp = false
			timer.Simple(1,function() if IsValid(self) then
			self.SightDistance = 6000 
			self.IsGuard = false
			self.CallForHelp = true
			self.CanTurnWhileStationary = true
			self.HasLeapAttack = true
			self.MovementType = VJ_MOVETYPE_GROUND
			self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth(), self, self)
	end

	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
		self.IsGuard = true
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self:PlayAnim({"hop_fwd"}, true, false, true)
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(0.1)
		self:SetGravity(0)
		self:SetGravity(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if not dmginfo:IsDamageType(DMG_PHYSGUN) then return end

	local ply = dmginfo:GetAttacker()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	local dir = ply:GetAimVector()

	local velocity =
		(dir * 1200) +   -- forward force
		Vector(0, 0, 230) -- slight lift

	self:SetVelocity(velocity)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnLeapAttack(status, enemy)
	if status == "Jump" then
		self.Hopp_StartedLeapAttack = true
		return self:CalculateProjectile("Curve", self:GetPos(), self:GetAimPosition(enemy, self:GetPos(), 1, 1100), 1100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Curve", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 1100) +(VectorRand() *28), 1100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 8, 32), Vector(-8, -8, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == "idle" && self.Hopp_StartedLeapAttack then
		return "jump_land"
	end
	return act
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot1.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
	ParticleEffect("antlion_gib_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end