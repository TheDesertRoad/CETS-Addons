AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/vortigaunt_zombie.mdl"}
ENT.StartHealth = GetConVar("sk_cets_vortigauntz_health"):GetInt()
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01" -- Particles to spawn when it's damaged
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.BreathSoundLevel = 60
ENT.FootStepSoundLevel = 50
ENT.IdleSoundLevel = 75
ENT.CombatIdleSoundLevel = 75
ENT.InvestigateSoundLevel = 75
ENT.AlertSoundLevel = 75
ENT.PainSoundLevel = 75
ENT.DeathSoundLevel = 80

ENT.FootStepPitch = VJ_Set(70, 80)

ENT.SoundTbl_FootStep = {
	"npc/vort/vort_foot1.wav",
	"npc/vort/vort_foot2.wav",
	"npc/vort/vort_foot3.wav",
	"npc/vort/vort_foot4.wav",
}

ENT.SoundTbl_Idle = {
	"npc/zombigaunt/idle1.wav",
	"npc/zombigaunt/idle2.wav",
	"npc/zombigaunt/idle2.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/zombigaunt/idle1.wav",
	"npc/zombigaunt/idle2.wav",
	"npc/zombigaunt/idle2.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/zombigaunt/idle1.wav",
	"npc/zombigaunt/idle2.wav",
	"npc/zombigaunt/idle2.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/zombigaunt/idle1.wav",
	"npc/zombigaunt/idle2.wav",
	"npc/zombigaunt/idle2.wav",
}

ENT.SoundTbl_Alert = {
	"npc/zombigaunt/alert1.wav",
	"npc/zombigaunt/alert2.wav",
}

ENT.SoundTbl_Investigate = {
	"npc/zombigaunt/idle1.wav",
	"npc/zombigaunt/idle2.wav",
	"npc/zombigaunt/idle2.wav",
}

ENT.SoundTbl_Death = {
	"npc/zombigaunt/die1.wav",
	"npc/zombigaunt/die2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/zombigaunt/hurt1.wav",
	"npc/zombigaunt/hurt2.wav",
	"npc/zombigaunt/hurt3.wav",
	"npc/zombigaunt/hurt4.wav",
	"npc/zombigaunt/hurt5.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {"NPC_Vortigaunt.Swing"}
ENT.SoundTbl_BeforeRangeAttack = {"npc/vort/attack_charge.wav"}
ENT.SoundTbl_Breath = {"npc/zombigaunt/background.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self.TeamZ = 1
	self.VortChargeTimerName = "VJ_VortSynth_Z_ChargeTimer" .. self:EntIndex()
	self.VortHealOrbsTimerName = "VJ_VortSynth_Z_HealOrbTimer" .. self:EntIndex()
	self.NextDispell = CurTime()
	self.NextHeal = CurTime()
	self.NextFindHurtAllyT = CurTime()

	self.BlackAmount = 0

	if self.TeamZ == 1 then
		self.VJ_NPC_Class = {"CLASS_ZOMBIE"}	
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_CLUB) or math.random(1,8) == 1 then
			self:SetBodygroup(1,1)
			self.Headcrab = ents.Create("npc_headcrab_fast")
			self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
			self.Headcrab:SetAngles(self:GetAngles())
			self.Headcrab:Spawn()
			self.Headcrab:Activate() 
			self.Headcrab:SetOwner(self)
			self:SetGroundEntity(NULL)
	end
end