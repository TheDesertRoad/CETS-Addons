AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 50
ENT.BloodColor = "Red"
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.Weapon_Accuracy = GetConVar("sk_csniper_accurancy"):GetInt()
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 40000 -- Max distance it can fire a weapon
ENT.Weapon_Strafe = true
ENT.Weapon_CanCrouchAttack = false
ENT.HasGrenadeAttack = false

ENT.PropInteraction = true
ENT.CanChatMessage = false

local mdlHECUS = {
	"models/humans/grunt/hgrunt1_mask.mdl",
	"models/humans/grunt/hgrunt2_mask.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 3
ENT.ItemDropsOnDeath_EntityList = {
	"item_armor_c",
	"item_health_vial_c",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Weapon_Rand = 1
	self.Model = mdlHECUS
	self:Give("weapon_vj_cets_hecusniper")

	if GetConVar("npc_cets_hecu_voice"):GetInt() == 1 then
		self:HecuSounds()
	else
		self:MaleSounds()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.MovementType = VJ_MOVETYPE_STATIONARY
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	self.MovementType = VJ_MOVETYPE_GROUND
	self.IsGuard = false
	self.CallForHelp = true
	self.SightDistance = 6000 
	self:Give("weapon_vj_cets_glock")
	self.Weapon_Accuracy = 1
	self.Behavior = VJ_BEHAVIOR_AGGRESSIVE

	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", self.SoundTbl_Pain)
	end

	if self:Health() > 0 && dmginfo:IsDamageType(DMG_NERVEGAS) then
		self.Bleeds = false
	end

	if status == "PostDamage" && self:Health() > 0 && math.random(1, 2) == 1 then
		if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			self:PlaySoundSystem("Pain", sdPainArm_M)
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			self:PlaySoundSystem("Pain", sdPainLeg_M)
		elseif hitgroup == HITGROUP_STOMACH then
			self:PlaySoundSystem("Pain", sdPainGut_M)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAllyKilled(ent)
	if ent:IsPlayer() then
		self:PlaySoundSystem("AllyDeath", self.SoundTbl_Pain)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local glock = ents.Create("weapon_vj_cets_hecusniper")
		glock:SetPos(att.Pos)
		glock:SetAngles(att.Ang)
		glock:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HecuSounds()
	self.SoundTbl_IdleDialogue = false

	self.SoundTbl_IdleDialogueAnswer = false

	self.SoundTbl_CombatIdle = false

	self.SoundTbl_ReceiveOrder = false

	self.SoundTbl_FollowPlayer = "vo/npc/hgrunt/affirmative.wav"

	self.SoundTbl_UnFollowPlayer = {
		"vo/npc/hgrunt/got.wav",
		"vo/npc/hgrunt/ok.wav",
	}

	self.SoundTbl_YieldToPlayer = false

	self.SoundTbl_MedicBeforeHeal = false

	self.SoundTbl_OnPlayerSight = {
		"vo/npc/hgrunt/freeman!.wav",
		"vo/npc/hgrunt/freeman.wav",
	}

	self.SoundTbl_Investigate = false

	self.SoundTbl_LostEnemy = {}

	self.SoundTbl_Alert = false

	self.SoundTbl_CallForHelp = false

	self.SoundTbl_BecomeEnemyToPlayer = false

	self.SoundTbl_WeaponReload = {
		"vo/npc/hgrunt/cover!.wav",
		"vo/npc/hgrunt/damn!.wav",
	}

	self.SoundTbl_GrenadeSight = {
		"vo/npc/hgrunt/grenade!.wav",
		"vo/npc/hgrunt/down!.wav",
	}

	self.SoundTbl_DangerSight = false

	self.SoundTbl_KilledEnemy = false

	self.SoundTbl_AllyDeath = {
		"vo/npc/hgrunt/mister!.wav",
		"vo/npc/hgrunt/lookout!.wav",
		"vo/npc/hgrunt/position!.wav",
		"vo/npc/hgrunt/down!.wav",
	}

	self.SoundTbl_Pain = {
		"vo/npc/hgrunt/gr_pain1.wav",
		"vo/npc/hgrunt/gr_pain2.wav",
		"vo/npc/hgrunt/gr_pain3.wav",
		"vo/npc/hgrunt/gr_pain4.wav",
		"vo/npc/hgrunt/gr_pain5.wav",
	}

	self.SoundTbl_Death = self.SoundTbl_Pain
end