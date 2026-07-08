AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_snark.mdl"
ENT.StartHealth = 2
ENT.HullType = HULL_TINY

ENT.CanChatMessage = false
ENT.EntitiesToNoCollide = {"npc_snark_vj_cets", "npc_babycrab_vj_cets"}
ENT.VJ_NPC_Class = {"CLASS_SNARK"}

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HeadcrabClassic.SpineControl",
    FirstP_Offset = Vector(3, 0, -1),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
ENT.HasDeathCorpse = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.Snark_Exp = false
ENT.AnimTbl_Run = "run"

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = {"glide1", "glide2", "glide3"}
ENT.LeapAttackMaxDistance = 300
ENT.LeapAttackMinDistance = 0
ENT.TimeUntilLeapAttackDamage = 0.1
ENT.NextLeapAttackTime = 0.6
ENT.NextAnyAttackTime_Leap = 0.85
ENT.TimeUntilLeapAttackVelocity = 0.1
ENT.LeapAttackVelocityForward = 70
ENT.LeapAttackVelocityUp = 200
ENT.LeapAttackDamage = 1
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1}
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 40

ENT.HasExtraMeleeAttackSounds = true
ENT.FootstepSoundTimerRun = 0.2
ENT.FootstepSoundTimerWalk = 0.2

ENT.FootstepSoundPitch = 150
ENT.LeapAttackDamageSoundPitch = 150
ENT.MainSoundPitch = 100
ENT.FootstepSoundLevel = 50

ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav", "npc/headcrab_poison/ph_step2.wav", "npc/headcrab_poison/ph_step3.wav", "npc/headcrab_poison/ph_step4.wav"}

ENT.SoundTbl_Death = "npc/squeek/sqk_die1.wav"
ENT.SoundTbl_LeapAttackDamage = "npc/headcrab/headbite.wav"

ENT.SoundTbl_LeapAttackJump = {
	"npc/squeek/sqk_hunt1.wav",
	"npc/squeek/sqk_hunt2.wav",
	"npc/squeek/sqk_hunt3.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(4, 5, 7), Vector(-4, -5, 0))
	self.Snark_Lifetime = CurTime() + math.Rand(5, 10)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if !self.Snark_Exp && CurTime() > self.Snark_Lifetime then
		self.Snark_Exp = true
		self:PlaySoundSystem("Death")
		self.HasDeathSounds = false
		self:SetGroundEntity(NULL)
		self:SetLocalVelocity(self:GetUp() * 400)
		timer.Simple(0.7, function()
			if IsValid(self) then
				self:TakeDamage(self:Health(), self, self)
			end
		end)
	end

	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth(), self, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if not dmginfo:IsDamageType(DMG_PHYSGUN) then return end

	local ply = dmginfo:GetAttacker()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	local dir = ply:GetAimVector()

	local velocity =
		(dir * 2000) +   -- forward force
		Vector(0, 0, 400) -- slight lift

	self:SetVelocity(velocity)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/squeek/sqk_blast1.wav",100,100)
	util.BlastDamage(self,self,self:GetPos(),360,32,DMG_ACID,true,true)
	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.4, 2, 380, 10, 4, Color(255, 255, 32, 64))
	ParticleEffect("gonarch_gas2", self:GetPos(), Angle(0,0,0), nil)
end