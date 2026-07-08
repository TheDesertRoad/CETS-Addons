AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_shockroach.mdl"
ENT.StartHealth = 50
ENT.HullType = HULL_TINY

ENT.CanChatMessage = false

ENT.VJ_NPC_Class = {"CLASS_RACE_X"}

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HeadcrabClassic.SpineControl",
    FirstP_Offset = Vector(3, 0, -1),
}

---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Blue"
ENT.BloodDecal = "VJ_CETS_BBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {"flinch"}
ENT.RangeAttackProjectiles = {"obj_vj_racexenergyorb_b"}
ENT.TimeUntilRangeAttackProjectileRelease = 0.1
ENT.NextRangeAttackTime = 5
ENT.RangeAttackMaxDistance = 2500
ENT.RangeAttackMinDistance = 300

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = {"jump", "jump_variation1", "jump_variation2"}
ENT.LeapAttackMaxDistance = 300
ENT.LeapAttackMinDistance = 0
ENT.TimeUntilLeapAttackDamage = 0.3
ENT.NextLeapAttackTime = 2
ENT.NextAnyAttackTime_Leap = 0.85
ENT.TimeUntilLeapAttackVelocity = 0.1
ENT.LeapAttackVelocityForward = 70
ENT.LeapAttackVelocityUp = 200
ENT.LeapAttackDamage = 16
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1}
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 40

ENT.HasExtraMeleeAttackSounds = true
ENT.FootstepSoundTimerRun = 0.2
ENT.FootstepSoundTimerWalk = 0.2

ENT.SoundTbl_FootStep = {"npc/shockroach/shock_walk.wav"}
ENT.SoundTbl_Alert = {"npc/shockroach/shock_angry.wav"}
ENT.SoundTbl_Idle = {"npc/shockroach/shock_idle1.wav", "npc/shockroach/shock_idle2.wav", "npc/shockroach/shock_idle3.wav"}
ENT.SoundTbl_LeapAttackJump = {"npc/shockroach/shock_jump1.wav", "npc/shockroach/shock_jump2.wav"}
ENT.SoundTbl_LeapAttackDamage = {"npc/shockroach/shock_bite.wav"}
ENT.SoundTbl_Pain = {"npc/shockroach/shock_flinch.wav"}
ENT.SoundTbl_Death = {"npc/shockroach/shock_die.wav"}
ENT.SoundTbl_IdleDialogue = {"npc/shockroach/shock_idle1.wav", "npc/shockroach/shock_idle2.wav", "npc/shockroach/shock_idle3.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"npc/shockroach/shock_idle1.wav", "npc/shockroach/shock_idle2.wav", "npc/shockroach/shock_idle3.wav"}

ENT.MainSoundPitch = 100
ENT.FootstepSoundLevel = 80

ENT.Shock_Die = false
ENT.Flipped = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 10, 15), Vector(-8, -10, 0))

	self.Shock_Lifetime = CurTime() + math.Rand(30, 60)
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	ParticleEffectAttach("racex_arc_02_cp0", PATTACH_POINT_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
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

	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
		self.IsGuard = true
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(1)
		self:SetGravity(0)
		self:SetGravity(1)
	end

	if GetConVar("npc_cets_shockroach_dienohost"):GetInt() == 1 && !self.Shock_Die && CurTime() > self.Shock_Lifetime then
		self:TakeDamage(1000)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) && self.Flipped == 0 then 
			self:VJ_ACT_PLAYACTIVITY("dieback",true,2.1,false)
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.Flipped = 1
			self.CanTurnWhileStationary = false
			self.HasLeapAttack = false
			self.SightDistance = 1 
			self.IsGuard = true
			self.CallForHelp = false
			timer.Simple(2.1,function() if IsValid(self) then
				self.SightDistance = 6000 
				self.Flipped = 0
				self.IsGuard = false
				self.CallForHelp = true
				self.CanTurnWhileStationary = true
				self.HasLeapAttack = true
				self.MovementType = VJ_MOVETYPE_GROUND
				self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end

	if not dmginfo:IsDamageType(DMG_PHYSGUN) then return end

	local ply = dmginfo:GetAttacker()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	local dir = ply:GetAimVector()

	local velocity =
		(dir * 900) +   -- forward force
		Vector(0, 0, 170) -- slight lift

	self:SetVelocity(velocity)
end