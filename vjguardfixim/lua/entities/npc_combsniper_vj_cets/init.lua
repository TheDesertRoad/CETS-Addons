AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/combine_sniper.mdl"}
ENT.StartHealth = GetConVar("sk_csniper_health"):GetInt()
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.BloodColor = "Red"
ENT.Weapon_Accuracy = GetConVar("sk_csniper_accurancy"):GetInt()
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 40000 -- Max distance it can fire a weapon
ENT.Weapon_Strafe = true
ENT.Weapon_CanCrouchAttack = false

ENT.PropInteraction = true
ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 1000
ENT.InvestigateSoundDistance = 18

ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 4 -- Chance of it flinching from 1 to x | 1 will make it always flinch

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 15
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 200 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 300 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.HasGrenadeAttack = false

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial"
}

ENT.CanBeMedic = false

ENT.SoundTbl_Idle = false
ENT.SoundTbl_IdleDialogue = false
ENT.SoundTbl_Investigate = false
ENT.SoundTbl_CombatIdle = false
ENT.SoundTbl_Alert = false
ENT.SoundTbl_WeaponReload = false
ENT.SoundTbl_OnDangerSight = false
ENT.SoundTbl_OnKilledEnemy = false
ENT.SoundTbl_AllyDeath = false
ENT.SoundTbl_LostEnemy = false

ENT.SoundTbl_OnGrenadeSight = {
	"npc/sniper/sn_blockdown.wav"
}

ENT.Metrocop_CanHaveManhack = false

ENT.NextDance = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_combine_sniper")
	self:SetBodygroup( 3, math.random( 0, 3 ) )
	self.MovementType = VJ_MOVETYPE_STATIONARY
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Deploy Manhack (if available)")
	
	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE && self.VJCE_NPC.Metrocop_HasManhack then
			self.VJCE_NPC:Metrocop_DeployManhack()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.VJ_IsBeingControlled then return end
	if self.Metroelite_HasManhack && IsValid(self:GetEnemy()) then
		local eneData = self.EnemyData
		if eneData.Distance <= 1000 && eneData.Distance > 300 then
			self:Metrocop_DeployManhack()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	self.MovementType = VJ_MOVETYPE_GROUND
	self.IsGuard = false
	self.CallForHelp = true
	self.SightDistance = 6000 
	self:Give("weapon_vj_cets_smg1_ng")
	self.Weapon_Accuracy = 1
	self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)

	if !( (VJ_HasValue(self.SoundTbl_Pain, sdFile) && !VJ_HasValue(self.SoundTbl_Hurt, sdFile)) or VJ_HasValue(DefaultSoundTbl_MedicAfterHeal, sdFile) or VJ_HasValue(self.DefaultSoundTbl_MeleeAttack, sdFile) or VJ_HasValue(self.SoundTbl_NovaProspektIdle, sdFile)  ) then

        self:EmitSound(table.Random(self.SoundTbl_RadioOn),90,math.random(85, 115))
        timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then self:EmitSound(table.Random(self.SoundTbl_RadioOff),70,math.random(85, 115)) end end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_BeforeMeleeAttack, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Pain, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Death, sdFile) then return end
	VJ.EmitSound(self, "npc/combine_soldier/vo/on" .. math.random(1, 2) .. ".wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self, "npc/combine_soldier/vo/off" .. math.random(1, 3) .. ".wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ammo = ents.Create("item_ammo_ar2")
		ammo:SetPos(att.Pos)
		ammo:SetAngles(att.Ang)
		ammo:Spawn()
	end
end