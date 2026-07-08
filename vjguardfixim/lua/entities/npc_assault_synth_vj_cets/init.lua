AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/assault_synth.mdl"
ENT.CanChatMessage = false
ENT.StartHealth = 170
ENT.HullType = HULL_WIDE_SHORT
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.SightAngle = 280
ENT.SightDistance = 2000
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true
ENT.PropInteraction = "OnlyPush" -- Controls how it should interact with props
	-- false = Disable both damaging and pushing | true = Damage and push | "OnlyDamage" = Damage but don't push | "OnlyPush" = Push but don't damage
ENT.PropInteraction_MaxScale = 500 -- Max prop size multiplier | x < 1  = Smaller props | x > 1  = Larger props
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_impact_synth_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = true
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "gun"
ENT.AnimTbl_RangeAttack = "shoot"
ENT.RangeAttackEntityToSpawn = "obj_vj_rocket_apc_but_laser"
ENT.RangeDistance = 2000
ENT.TimeUntilRangeAttackProjectileRelease = 0.2
ENT.NextRangeAttackTime = 3.2
ENT.RangeToMeleeDistance = 120

ENT.TimeUntilMeleeAttackDamage = 0.2
ENT.HasExtraMeleeAttackSounds = true
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 200
ENT.MeleeAttackKnockBack_Forward2 = 200
ENT.MeleeAttackKnockBack_Up1 = 100
ENT.MeleeAttackKnockBack_Up2 = 100
ENT.MeleeAttackDamage = 32
ENT.MeleeAttackDamageDistance = 125
ENT.MeleeAttackDistance = 60

ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.6 -- Next foot step sound when it is walking

ENT.MainSoundPitch = 150
ENT.FootStepSoundPitch = 120

ENT.FootStepSoundLevel = 60
ENT.SoundTbl_FootStep = {"npc/vj_combine_guard_z/cguard_footstep_walk01.wav", "npc/vj_combine_guard_z/cguard_footstep_walk02.wav", "npc/vj_combine_guard_z/cguard_footstep_walk03.wav", "npc/vj_combine_guard_z/cguard_footstep_walk04.wav", "npc/vj_combine_guard_z/cguard_footstep_walk05.wav", "npc/vj_combine_guard_z/cguard_footstep_walk06.wav", "npc/vj_combine_guard_z/cguard_footstep_walk07.wav", "npc/vj_combine_guard_z/cguard_footstep_walk08.wav", "npc/vj_combine_guard_z/cguard_footstep_walk09.wav"}

ENT.SoundTbl_Idle = {
	"npc/crabsynth/cs_idle01.wav",
	"npc/crabsynth/cs_idle02.wav",
	"npc/crabsynth/cs_idle03.wav",
}

ENT.SoundTbl_CombatIdle = ENT.SoundTbl_Idle

ENT.SoundTbl_Investigate = {
	"npc/crabsynth/cs_distant01.wav",
	"npc/crabsynth/cs_distant02.wav",
}

ENT.SoundTbl_Alert = {
	"npc/crabsynth/cs_alert01.wav",
	"npc/crabsynth/cs_alert02.wav",
	"npc/crabsynth/cs_alert03.wav",
}

ENT.SoundTbl_Pain = {
	"npc/crabsynth/cs_roar01.wav",
	"npc/crabsynth/cs_roar02.wav",
}

ENT.SoundTbl_MeleeAttackExtra = {
	"ambient/machines/slicer1.wav",
	"ambient/machines/slicer2.wav",
	"ambient/machines/slicer3.wav",
	"ambient/machines/slicer4.wav",
}

ENT.SoundTbl_Death = {"npc/crabsynth/cs_die.wav"}

ENT.SoundTbl_BeforeMeleeAttack = {"npc/crabsynth/cs_pissed01.wav"}

ENT.SoundTbl_BeforeRangeAttack = {"npc/assault/assault_cannon.wav"}

ENT.SoundTbl_MeleeAttack = {"npc/crabsynth/cs_skewer.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSurroundingBounds(Vector(100, 100, 100), Vector(-100, -100, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	self.HasPainSounds = false
	self.Bleeds = false
	local infl = dmginfo:GetInflictor()
	local comballdamage = false

	if infl && IsValid(infl) then
		if infl:GetClass() == "prop_combine_ball" then
			infl:Fire("Explode")
			comballdamage = true
	end

	if !infl.DamagedVJ_ZHunter && infl:GetClass() == "obj_vj_combineball" then
		infl.DamagedVJ_ZHunter = true
		infl:DeathEffects()
			comballdamage = true
		end
	end

	if !( dmginfo:GetDamagePosition().z < (self:GetPos()+self:OBBCenter()+Vector(0,0,-8)).z && dmginfo:IsExplosionDamage() ) && !comballdamage then

		dmginfo:SetDamage(dmginfo:GetDamage()*1)

		if math.random(1, 2) == 1 then
			self.Bleeds = true
			self:EmitSound("physics/metal/metal_barrel_impact_hard" .. math.random(1, 3) .. ".wav", 92, math.random(70, 90))
			self:EmitSound("ambient/energy/zap" .. math.random(1, 9) .. ".wav", 92, math.random(70, 90))
			self.BloodParticle = "blood_spurt_synth_01"
		end

		else
			self.Bleeds = true
			self.HasPainSounds = true
			self.BloodParticle = "blood_impact_synth_01"

	if comballdamage then
			dmginfo:SetDamage(25)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_CRUSH ) then 
			self:VJ_ACT_PLAYACTIVITY("shoot",true,2,false)
			VJ_EmitSound(self, "hl1/weapons/electro" .. math.random(4, 6) .. ".wav", 100, 100)
			ParticleEffect("Explosion_2_FireSmoke",self:GetPos() + self:GetUp()* 25 + self:GetForward()*-15 ,Angle(0,0,0),nil)
			self.Spark1 = ents.Create("env_spark")
  			self.Spark1:SetPos(self:GetPos())
 			self.Spark1:Spawn()
			self.Spark1:Fire("StartSpark", "", 0)
			self.Spark1:Fire("StopSpark", "", 0.2)
			self.HasMeleeAttack = false
			self.HasRangeAttack = false
			self.SightDistance = 1 
			self.CallForHelp = true
			timer.Simple(1.8,function() if IsValid(self) then
			self.SightDistance = 60000 
			self.CallForHelp = true
			self.HasMeleeAttack = true
			self.HasRangeAttack = true
			self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end
end