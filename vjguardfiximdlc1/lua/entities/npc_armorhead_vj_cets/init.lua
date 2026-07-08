AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/Zombie/headcrabarmored.mdl"
ENT.StartHealth = GetConVar("sk_cets_armhead_health"):GetInt()
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HullType = HULL_TINY
ENT.CanChatMessage = false

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HeadcrabClassic.SpineControl",
    FirstP_Offset = Vector(3, 0, -1),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01" -- Particles to spawn when it's damaged
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = ACT_RANGE_ATTACK1
ENT.LeapAttackMaxDistance = 300
ENT.LeapAttackMinDistance = 0
ENT.TimeUntilLeapAttackDamage = 0.3
ENT.NextLeapAttackTime = 2
ENT.NextAnyAttackTime_Leap = 0.85
ENT.TimeUntilLeapAttackVelocity = 0.1
ENT.LeapAttackVelocityForward = 70
ENT.LeapAttackVelocityUp = 200
ENT.LeapAttackDamage = 8
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1}
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 40

ENT.HasExtraMeleeAttackSounds = true
ENT.FootstepSoundTimerRun = 0.2
ENT.FootstepSoundTimerWalk = 0.2

ENT.MainSoundPitch = 100
ENT.FootstepSoundLevel = 50

ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav", "npc/headcrab_poison/ph_step2.wav", "npc/headcrab_poison/ph_step3.wav", "npc/headcrab_poison/ph_step4.wav"}

ENT.SoundTbl_Idle = {
	"npc/headcrab/idle1.wav",
	"npc/headcrab/idle2.wav",
	"npc/headcrab/idle3.wav",
}

ENT.SoundTbl_LeapAttackJump = {
	"npc/headcrab/attack1.wav",
	"npc/headcrab/attack2.wav",
	"npc/headcrab/attack3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/headcrab/pain1.wav",
	"npc/headcrab/pain2.wav",
	"npc/headcrab/pain3.wav",
}

ENT.SoundTbl_Death = {
	"npc/headcrab/die1.wav",
	"npc/headcrab/die2.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/headcrab/idle1.wav",
	"npc/headcrab/idle2.wav",
	"npc/headcrab/idle3.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/headcrab/idle1.wav",
	"npc/headcrab/idle2.wav",
	"npc/headcrab/idle3.wav",
}

ENT.SoundTbl_Alert = "npc/headcrab/alert1.wav"

ENT.SoundTbl_LeapAttackDamage = "npc/headcrab/headbite.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 10, 15), Vector(-8, -10, 0))

	self.BlackAmount = 0
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
		self:PlayAnim({"drown"}, true, false, true)
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(1)
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
		(dir * 1000) +   -- forward force
		Vector(0, 0, 200) -- slight lift

	self:SetVelocity(velocity)
end