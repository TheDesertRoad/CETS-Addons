AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_stukabat.mdl"
ENT.StartHealth = 50
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
ENT.TurningSpeed = 16
ENT.Aerial_FlyingSpeed_Calm = 300
ENT.Aerial_FlyingSpeed_Alerted = 500
ENT.Aerial_AnimTbl_Calm = "hover"
ENT.Aerial_AnimTbl_Alerted = "hover"
ENT.AA_GroundLimit = 64
ENT.IdleAlwaysWander = true
ENT.IsGuard = false
ENT.AnimTbl_Idle = "hover"
ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = "attack_claw"
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 30
ENT.TimeUntilMeleeAttackDamage = 0.7
ENT.NextAnyAttackTime_Melee = 1.3
ENT.MeleeAttackDamage = 45
ENT.SlowPlayerOnMeleeAttack = true
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 160 
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 150 
ENT.SlowPlayerOnMeleeAttackTime = 5 

ENT.HasDeathCorpse = true
ENT.HasExtraMeleeAttackSounds = true

ENT.HasRangeAttack = true
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 1.5
ENT.RangeAttackMaxDistance = 2500
ENT.RangeAttackMinDistance = 16

ENT.CanFlinch = false

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.HasItemDropsOnDeath = false

ENT.AlertSoundLevel = 100

ENT.SoundTbl_Breath = {"npc/stukabat/stkb_wings1.wav", "npc/stukabat/stkb_wings2.wav", "npc/stukabat/stkb_wings3.wav"}

ENT.SoundTbl_Idle = "npc/stukabat/stkb_idle1.wav"

ENT.SoundTbl_RangeAttack = {"npc/stukabat/stkb_fire1.wav", "npc/stukabat/stkb_fire2.wav"}

ENT.SoundTbl_Death = "npc/stukabat/stkb_die1.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSurroundingBounds(Vector(48, 48, 58), Vector(-48, -48, 0))
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	ParticleEffect("racex_arc_01_gas_b",self:GetPos() + self:GetUp()* 12,Angle(0,0,0),nil)
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
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.AnimTbl_RangeAttack = "attack_bomb"
			self.RangeAttackProjectiles = {"obj_vj_batspit"}
			self.TimeUntilRangeAttackProjectileRelease = 1
			self.RangeAttackExtraTimers = {0.4, 0.6, 0.8, 0.9, 1}
		elseif randRange == 2 then
			self.AnimTbl_RangeAttack = "attack_bomb"
			self.RangeAttackProjectiles = {"obj_vj_batspit"}
			self.TimeUntilRangeAttackProjectileRelease = 1
			self.RangeAttackExtraTimers = false
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Curve", self:GetAttachment(self:LookupAttachment("mouth")).Pos, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() + VectorRand(-5, 5), 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	util.VJ_SphereDamage(self,self,self:GetPos(),100,0.4,DMG_NERVEGAS,true,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations()
	self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK1
	self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_RANGE_ATTACK1
	self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK1
	self.AnimationTranslations[ACT_RELOAD] 						= ACT_FLY
	self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_FLY
	self.AnimationTranslations[ACT_RELOAD_LOW] 					= ACT_FLY
	
	self.AnimationTranslations[ACT_IDLE] 						= ACT_FLY
	self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_FLY
	
	self.AnimationTranslations[ACT_WALK] 						= ACT_FLY
	self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_FLY
	self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_FLY
	self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_FLY
	
	self.AnimationTranslations[ACT_RUN] 						= ACT_FLY
	self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_FLY
	self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_FLY
	self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_FLY
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot1.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
	ParticleEffect("antlion_gib_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("racex_arc_02_gas",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end