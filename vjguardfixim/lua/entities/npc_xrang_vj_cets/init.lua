AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_alienranger.mdl"}
ENT.StartHealth = 150
ENT.Weapon_Accuracy  = 1.3
ENT.JumpParams = {
	Enabled = true,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Melee = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 0.82 -- Time until the grenade is released
ENT.GrenadeAttackEntity = "obj_vj_cets_extractor_acid" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations
ENT.MeleeAttackDamage = 33 -- Melee Attack Animations

ENT.CanUseSecondaryOnWeaponAttack = true -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
}

ENT.IsMedic = true -- Should it heal allied entities?
ENT.Medic_CheckDistance = 900 -- Max distance to check for injured allies
ENT.Medic_HealDistance = 50 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_TimeUntilHeal = false -- Time until the ally receives health | false = Base auto calculates the duration
ENT.AnimTbl_Medic_GiveHealth = ACT_SPECIAL_ATTACK1 -- Animations to play when it heals an ally | false = Don't play an animation
ENT.Medic_HealAmount = 33 -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(2, 8) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on

ENT.FootStepSoundPitch = 100
ENT.IdleSoundPitch = 80
ENT.IdleDialogueSoundPitch = 80
ENT.IdleDialogueAnswerSoundPitch = 80
ENT.CombatIdleSoundPitch = 80
ENT.InvestigateSoundPitch = 80
ENT.LostEnemySoundPitch = 80
ENT.AlertSoundPitch = 80
ENT.WeaponReloadSoundPitch = 80
ENT.GrenadeAttackSoundPitch = 80
ENT.OnGrenadeSightSoundPitch = 80
ENT.OnDangerSightSoundPitch = 80
ENT.OnKilledEnemySoundPitch = 80
ENT.AllyDeathSoundPitch = 80
ENT.PainSoundPitch = 80
ENT.DeathSoundPitch = 80

ENT.SoundTbl_MeleeAttack = {
	"weapons/knife/knife_hit1.wav",
	"weapons/knife/knife_hit2.wav",
	"weapons/knife/knife_hit3.wav",
	"weapons/knife/knife_hit4.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"weapons/knife/knife_slash2.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_comb_spear")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive(dmginfo)
	if self.EnemyData.DistanceNearest > 1 && self.EnemyData.DistanceNearest < 700 then
		self:SetLocalVelocity(self:GetMoveVelocity() * 0.8)
	else
		self:SetLocalVelocity(self:GetMoveVelocity() * 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	self:CreateGibEntity("physics_prop", "models/weapons/w_spear.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 30))})
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