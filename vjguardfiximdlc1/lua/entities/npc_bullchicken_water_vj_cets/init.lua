AddCSLuaFile( "shared.lua" )
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_bullsquid_water.mdl"
ENT.VJ_NPC_Class = {"CLASS_BULL"}
ENT.StartHealth = GetConVar("sk_cets_bullwat_health"):GetInt()
ENT.CanChatMessage = false
ENT.HullType = HULL_WIDE_SHORT
ENT.SightAngle = 280
ENT.SightDistance = 2000
ENT.TurningSpeed = 7
ENT.AnimTbl_Walk = {"walk", "walk_original"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Aquatic_SwimmingSpeed_Alerted = 80
ENT.Aquatic_AnimTbl_Calm = {ACT_SWIM}
ENT.Aquatic_AnimTbl_Alerted = {ACT_SWIM}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.MeleeAttackAnimationAllowOtherTasks = true
ENT.MeleeAttackDamage = 20
ENT.MeleeAttackDamageDistance = 125
ENT.MeleeAttackDistance = 60
ENT.TimeUntilMeleeAttackDamage = false
ENT.HasExtraMeleeAttackSounds = true
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 390
ENT.MeleeAttackKnockBack_Forward2 = 390
ENT.MeleeAttackKnockBack_Up1 = 170
ENT.MeleeAttackKnockBack_Up2 = 170
ENT.AnimTbl_MeleeAttack = {"melee1", "melee2"}

ENT.HasRangeAttack = true
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "Mouth"
ENT.RangeAttackEntityToSpawn = "obj_vj_bullspit"
ENT.TimeUntilRangeAttackProjectileRelease = 0.3
ENT.RangeAttackExtraTimers = {0.4,0.6,0.9}
ENT.NextRangeAttackTime = 3.5
ENT.NextRangeAttackTime_DoRand = 4.5
ENT.RangeToMeleeDistance = 0

ENT.ExtraMeleeSoundPitch = VJ_Set(95, 105)
ENT.MeleeAttackMissSoundPitch = VJ_Set(75, 85)

ENT.VJC_Data = {
	CameraMode = 1,
	ThirdP_Offset = Vector(0, 0, 0),
	FirstP_Bone = "Bullsquid.Head",
	FirstP_Offset = Vector(20, 0, 8),
	FirstP_ShrinkBone = false,
}

ENT.SoundTbl_Idle = {
	"npc/bullsquid/idle1.wav",
	"npc/bullsquid/idle2.wav",
	"npc/bullsquid/idle3.wav",
	"npc/bullsquid/idle4.wav",
	"npc/bullsquid/idle5.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/bullsquid/attack1.wav",
	"npc/bullsquid/attack2.wav",
	"npc/bullsquid/attack3.wav"
}

ENT.SoundTbl_RangeAttack = {
	"npc/bullsquid/attackgrowl1.wav",
	"npc/bullsquid/attackgrowl2.wav",
	"npc/bullsquid/attackgrowl3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/bullsquid/pain1.wav",
	"npc/bullsquid/pain2.wav",
	"npc/bullsquid/pain3.wav",
	"npc/bullsquid/pain4.wav",
}

ENT.SoundTbl_Death = {
	"npc/bullsquid/die1.wav",
	"npc/bullsquid/die2.wav",
	"npc/bullsquid/die3.wav",
}

ENT.SoundTbl_Alert = {"npc/bullsquid/excited1.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/zombie/zombie_hit.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("npc_cets_bulls_xenfriends"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
	else
		self.VJ_NPC_Class = {"CLASS_BULL"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSurroundingBounds(Vector(100, 100, 100), Vector(-100, -100, 0))

	self.BlackAmount = 0

	if self:WaterLevel() > 0 then 
		self.MovementType = VJ_MOVETYPE_AQUATIC
		self:SetCollisionBounds(Vector(15, 15, 3), Vector(-15, -15, -17))
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1_LOW}
		self.AnimTbl_MeleeAttack = {"vjges_bite"}
		self.TurningUseAllAxis = true
		self.LimitChaseDistance = "OnlyRange"
		self.HasMeleeAttack = true
		self.RangeDistance = 1000
		self.RangeAttackAngleRadius = 180
		self.RangeAttackAnimationStopMovement = true
		self.HasMeleeAttackKnockBack = true
	else
		self.MovementType = VJ_MOVETYPE_GROUND
		self.RangeDistance = 2000
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
self.NextFootstepSoundT = CurTime() + 1

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

	if self.MovementType == VJ_MOVETYPE_GROUND then
		if self.VJ_IsBeingControlled == true then
			self.AnimTbl_RangeAttack = {"vjges_spit_additive"}
			self.RangeAttackAnimationStopMovement = false
			self.HasRangeAttack = true
		else
			if self.EnemyData.DistanceNearest > 200 && self.EnemyData.DistanceNearest < 2000 then
				self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
				self.RangeAttackAnimationStopMovement = true
				self.HasRangeAttack = true
			else
				self.HasRangeAttack = false
			end
		end
	end
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if self:GetAbsVelocity():Length() < 1 then
			self.TurningUseAllAxis = false
			if self:GetAngles().x > 1 then
				self:SetAngles(Angle(self:GetAngles().x-1,self:GetAngles().y,self:GetAngles().z))
			elseif self:GetAngles().x < -1 then
				self:SetAngles(Angle(self:GetAngles().x+1,self:GetAngles().y,self:GetAngles().z))
			else
				self.TurningUseAllAxis = true
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	self:SetMaxLookDistance(10000)
	timer.Destroy("timer_range_finished_abletorange" .. self:EntIndex())
	self.IsAbleToRangeAttack = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	self:SetMaxLookDistance(10000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_BeforeStartTimer(seed)
	self:SetLocalVelocity(Vector(0, 0, 0))
	self.AA_CurrentMoveTime = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnResetEnemy() 
	self:SetMaxLookDistance(2000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute()
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*38 ,Angle(0,0,0),nil)
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*38 ,Angle(0,0,0),nil)
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*38 ,Angle(0,0,0),nil)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	if self:WaterLevel() > 0 then 
		return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projectile:GetPos() + VectorRand(-15, 15), 0, 0.01)
	else
		return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projectile:GetPos() + VectorRand(-15, 15), 1, 50)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "event_emit FootL" then
		self:FootStepSoundCode()
		VJ_EmitSound(self,"npc/bullsquid/water/footl"..math.random(1,4)..".mp3",70,100)
	end

	if key == "event_emit FootR" then
		self:FootStepSoundCode()
		VJ_EmitSound(self,"npc/bullsquid/water/footr"..math.random(1,4)..".mp3",70,100)
	end

	if key == "event_emit Swim" then
		VJ_EmitSound(self,"npc/bullsquid/water/swim"..math.random(1,7)..".mp3",65,math.random(120,130))
	end

	if key == "Melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self.EnemyData.DistanceNearest > 1500 && self.EnemyData.DistanceNearest < 2500 then
		if act == ACT_RUN then
			return ACT_WALK
		end
	end

	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if act == ACT_IDLE then
			return ACT_IDLE_STEALTH
		end
	end

	return self.BaseClass.TranslateActivity(self, act)
end