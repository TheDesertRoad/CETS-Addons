AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 60
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.AlliedWithPlayerAllies = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 4
ENT.Weapon_CanCrouchAttack = true -- Can it crouch while firing a weapon?
ENT.Weapon_CrouchAttackChance = 1
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 2000 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 150
ENT.Weapon_FindCoverOnReload = false

ENT.CanChatMessage = false

ENT.JumpParams = {
	Enabled = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18

ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 4 -- Chance of it flinching from 1 to x | 1 will make it always flinch

ENT.AnimTbl_MeleeAttack = "meleeattack01" -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 13
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.HasGrenadeAttack = false
ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = false

ENT.CanBeMedic = false

local Weapon_None = -1
local Weapon_Knife = 1
local Weapon_Pipe = 2

ENT.Weapon_Rand = Weapon_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Model = "models/headcrab_cultists/cultist_01.mdl"
	self:CultistSounds()

	if self.Weapon_Rand == 1 or (self.Weapon_Rand == -1 && math.random(1, 2) == 1) then
		self.Weapon_Rand = 1
		self:Give("weapon_vj_cets_knife")
	else
		self.Weapon_Rand = 2
		self:Give("weapon_vj_cets_leadpipe")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetBodygroup( 1, math.random( 0, 3 ) )
	self:SetBodygroup( 3, math.random( 0, 3 ) )
	self:SetSkin( math.random( 0, 3 ) )

	if self:GetBodygroup(1) == 2 then
		self:SetLocalVelocity(self:GetMoveVelocity() * 3)
	end

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if hitgroup == HITGROUP_HEAD && dmginfo:GetDamageType() then
		self:SetBodygroup(2, 1)
		self:EmitSound("physics/plastic/plastic_box_break1.wav")
		self:EmitSound("npc/cultist/fzombie_attack" .. math.random(1, 3) .. ".wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if self.Weapon_Rand == 1 then
		self:CreateGibEntity("prop_physics", "models/weapons/w_chefsknife.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	else
		self:CreateGibEntity("prop_physics", "models/props_canal/mattpipe.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CultistSounds()
	self.SoundTbl_Idle = {
		"npc/cultist/fzombie_idle1.wav",
		"npc/cultist/fzombie_idle2.wav",
		"npc/cultist/fzombie_idle3.wav",
		"npc/cultist/fzombie_idle4.wav",
		"npc/cultist/fzombie_idle5.wav",
	}

	self.SoundTbl_Alert = {
		"npc/cultist/fzombie_alert1.wav",
		"npc/cultist/fzombie_alert2.wav",
		"npc/cultist/fzombie_alert3.wav",
	}

	self.SoundTbl_Pain = {
		"npc/cultist/fzombie_pain1.wav",
		"npc/cultist/fzombie_pain2.wav",
		"npc/cultist/fzombie_pain3.wav",
	}

	self.SoundTbl_Death = {
		"npc/cultist/fzombie_die1.wav",
		"npc/cultist/fzombie_die2.wav",
	}
end