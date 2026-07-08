AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_stinger.mdl"
ENT.StartHealth = 100
ENT.SightAngle = 280
ENT.SightDistance = 2000
ENT.HullType = HULL_WIDE_SHORT
ENT.VJ_NPC_Class = {"CLASS_FUNGUS"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanChatMessage = false

ENT.JumpParams = {
	Enabled = false, -- Can it do movement jumps?
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = true
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "launch_point"
ENT.RangeAttackEntityToSpawn = "obj_vj_stinger_spit"
ENT.RangeDistance = 1000
ENT.RangeToMeleeDistance = 60
ENT.TimeUntilRangeAttackProjectileRelease = 0.2
ENT.RangeAttackExtraTimers = false
ENT.NextRangeAttackTime = 4

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = "melee_attack1"
ENT.TimeUntilMeleeAttackDamage = 0.5
ENT.HasExtraMeleeAttackSounds = true
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 200
ENT.MeleeAttackKnockBack_Forward2 = 320
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackDamageDistance = 125
ENT.MeleeAttackDistance = 60

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 2 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 8 -- How many repetitions?

ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 90 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 4 -- How much time until player's Speed resets

ENT.CanFlinch = 0
ENT.AnimTbl_IdleStand = {"idle_standing", "idle_scratching", "idle_eating"}

ENT.FootStepSoundLevel = 80
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.7 -- Next foot step sound when it is walking

ENT.MainSoundPitch = 100

ENT.SoundTbl_FootStep = {"npc/fast_zombie/foot1.wav", "npc/fast_zombie/foot2.wav", "npc/fast_zombie/foot3.wav", "npc/fast_zombie/foot4.wav"}

ENT.SoundTbl_Idle = {
	"npc/stinger/idle01.wav",
	"npc/stinger/idle02.wav",
	"npc/stinger/idle03.wav",
}

ENT.SoundTbl_Alert = {
	"npc/stinger/stinger_panic01.wav",
	"npc/stinger/stinger_panic02.wav",
}

ENT.SoundTbl_Pain = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}

ENT.SoundTbl_Death = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}

ENT.SoundTbl_FollowPlayer = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}

ENT.SoundTbl_UnFollowPlayer = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(20, 20, 45),  Vector(-20, -20, 0))

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 1 then
		self:PlayAnim({"startle"}, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 2 then
			self.AnimTbl_RangeAttack = "range_attack1"
			self.RangeAttackExtraTimers = false
			self.SoundTbl_BeforeRangeAttack = false
			self.SoundTbl_RangeAttack = "npc/stinger/stinger_spray02.wav"
		elseif randRange == 1 then
			self.RangeAttackExtraTimers = {0.3, 0.4, 0.5}
			self.AnimTbl_RangeAttack = "range_attack2"
			self.SoundTbl_BeforeRangeAttack = {"npc/barnacle/bcl_die3.wav"}
			self.SoundTbl_RangeAttack = "npc/stinger/stinger_spray02.wav"
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute()
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*75 ,Angle(0,0,0),nil)
	ParticleEffectAttach("stinger_spray", PATTACH_POINT_FOLLOW, self, 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Line", self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot3.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
	util.ScreenShake(self:GetPos(),22,500,1,500)
	ParticleEffect("antlion_gib_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end