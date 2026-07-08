AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/portal_aspma.mdl"}
ENT.StartHealth = GetConVar("sk_aspma_health"):GetInt()
ENT.Weapon_Accuracy = 0.8
ENT.VJ_NPC_Class = {"CLASS_APERTURE"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_impact_synth_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Melee = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = true
ENT.AnimTbl_GrenadeAttack = {"throwitem"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 1 -- Time until the grenade is released
ENT.GrenadeAttackEntity = "obj_vj_aspma_extractor"
ENT.ThrowGrenadeChance = 1

ENT.AnimTbl_Medic_GiveHealth = {"throwitem"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.IsMedic = true -- Should it heal allied entities?
ENT.Medic_CheckDistance = 600 -- Max distance to check for injured allies
ENT.Medic_HealDistance = 30 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealAmount = 75 -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(10, 15) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/gibs/scanner_gib04.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on

ENT.AnimTbl_MeleeAttack = {"meleeattack01"} -- Melee Attack Animations

ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?

ENT.HasItemDropsOnDeath = false
ENT.DropWeaponOnDeath = false

ENT.FootStepSoundPitch = 180
ENT.MainSoundPitch = 90
ENT.FootStepSoundLevel = 60
ENT.MedicOnHealSoundLevel = 50

ENT.SoundTbl_FootStep = {"player/futureshoes1.wav", "player/futureshoes2.wav"}

ENT.SoundTbl_Investigate = {
	"npc/turret_floor/turret_search_1.wav",
	"npc/turret_floor/turret_search_2.wav",
}

ENT.SoundTbl_Idle = {
	"npc/turret_floor/turret_autosearch_1.wav",
	"npc/turret_floor/turret_autosearch_2.wav",
	"npc/turret_floor/turret_autosearch_3.wav",
	"npc/turret_floor/turret_autosearch_4.wav",
	"npc/turret_floor/turret_autosearch_5.wav",
	"npc/turret_floor/turret_autosearch_6.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/turret_floor/turret_autosearch_1.wav",
	"npc/turret_floor/turret_autosearch_2.wav",
	"npc/turret_floor/turret_autosearch_3.wav",
	"npc/turret_floor/turret_autosearch_4.wav",
	"npc/turret_floor/turret_autosearch_5.wav",
	"npc/turret_floor/turret_autosearch_6.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/turret_floor/turret_active_1.wav",
	"npc/turret_floor/turret_active_2.wav",
	"npc/turret_floor/turret_active_3.wav",
	"npc/turret_floor/turret_active_4.wav",
	"npc/turret_floor/turret_active_5.wav",
	"npc/turret_floor/turret_active_6.wav",
	"npc/turret_floor/turret_active_7.wav",
	"npc/turret_floor/turret_active_8.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/turret_floor/turret_autosearch_1.wav",
	"npc/turret_floor/turret_autosearch_2.wav",
	"npc/turret_floor/turret_autosearch_3.wav",
	"npc/turret_floor/turret_autosearch_4.wav",
	"npc/turret_floor/turret_autosearch_5.wav",
	"npc/turret_floor/turret_autosearch_6.wav",
}

ENT.SoundTbl_Alert = {
	"npc/turret_floor/turret_active_1.wav",
	"npc/turret_floor/turret_active_2.wav",
	"npc/turret_floor/turret_active_3.wav",
	"npc/turret_floor/turret_active_4.wav",
	"npc/turret_floor/turret_active_5.wav",
	"npc/turret_floor/turret_active_6.wav",
	"npc/turret_floor/turret_active_7.wav",
	"npc/turret_floor/turret_active_8.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan3.wav",
}

ENT.SoundTbl_GrenadeAttack  = {
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan3.wav",
}

ENT.SoundTbl_WeaponReload = {
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan3.wav",
}

ENT.SoundTbl_Hurt = {
	"npc/turret_floor/turret_shotat_1.wav",
	"npc/turret_floor/turret_shotat_2.wav",
	"npc/turret_floor/turret_shotat_3.wav",
}

ENT.SoundTbl_Pain = table.Add({"npc/turret_floor/turret_pickup_1.wav","npc/turret_floor/turret_pickup_2.wav","npc/turret_floor/turret_pickup_3.wav","npc/turret_floor/turret_pickup_4.wav","npc/turret_floor/turret_pickup_5.wav","npc/turret_floor/turret_pickup_6.wav","npc/turret_floor/turret_pickup_7.wav","npc/turret_floor/turret_pickup_8.wav","npc/turret_floor/turret_pickup_9.wav","npc/turret_floor/turret_pickup_10.wav"},ENT.SoundTbl_Hurt)

ENT.SoundTbl_LostEnemy = {
	"npc/turret_floor/turret_autosearch_1.wav",
	"npc/turret_floor/turret_autosearch_2.wav",
	"npc/turret_floor/turret_autosearch_3.wav",
	"npc/turret_floor/turret_autosearch_4.wav",
	"npc/turret_floor/turret_autosearch_5.wav",
	"npc/turret_floor/turret_autosearch_6.wav",
}

ENT.SoundTbl_OnDangerSight = {
	"npc/mortar/alert1.wav",
	"npc/mortar/alert2.wav",
	"npc/mortar/alert3.wav",
}

ENT.SoundTbl_OnGrenadeSight = {
	"npc/mortar/alert1.wav",
	"npc/mortar/alert2.wav",
	"npc/mortar/alert3.wav",
}

ENT.SoundTbl_OnKilledEnemy = {
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan3.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/mortar/attack_cue01.wav",
	"npc/mortar/pain1.wav",
}

ENT.SoundTbl_Death = {
	"npc/turret_floor/turret_disabled_1.wav",
	"npc/turret_floor/turret_disabled_2.wav",
	"npc/turret_floor/turret_disabled_3.wav",
	"npc/turret_floor/turret_disabled_4.wav",
	"npc/turret_floor/turret_disabled_5.wav",
	"npc/turret_floor/turret_disabled_6.wav",
	"npc/turret_floor/turret_disabled_7.wav",
	"npc/turret_floor/turret_disabled_8.wav",
}

ENT.SoundTbl_OnKilledEnemy = {
	"npc/turret_floor/turret_shotat_1.wav",
	"npc/turret_floor/turret_shotat_2.wav",
	"npc/turret_floor/turret_shotat_3.wav",
}

ENT.SoundTbl_MedicOnHeal = "hl1/buttons/button4.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_aspgun")

	util.SpriteTrail(self, 1, Color(255, 0, 0), true, 12, 1, 0.25, 1 /(25 +1) *0.5, "sprites/bluelaser1.vmt")

	local spriteGlow = ents.Create("env_sprite")
		spriteGlow:SetKeyValue("rendercolor", "255 0 0")
		spriteGlow:SetKeyValue("GlowProxySize", "2.0")
		spriteGlow:SetKeyValue("HDRColorScale", "1.0")
		spriteGlow:SetKeyValue("renderfx", "14")
		spriteGlow:SetKeyValue("rendermode", "3")
		spriteGlow:SetKeyValue("renderamt", "255")
		spriteGlow:SetKeyValue("disablereceiveshadows", "0")
		spriteGlow:SetKeyValue("mindxlevel", "0")
		spriteGlow:SetKeyValue("maxdxlevel", "0")
		spriteGlow:SetKeyValue("framerate", "10.0")
		spriteGlow:SetKeyValue("model", "sprites/orangeglow1.vmt")
		spriteGlow:SetKeyValue("spawnflags", "0")
		spriteGlow:SetKeyValue("scale", "0.15")
		spriteGlow:SetParent(self)
		spriteGlow:Fire("SetParentAttachment", "eyes")
		spriteGlow:Spawn()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	local blast = ents.Create("env_explosion")
    	self:SetBodygroup(1,1)
	blast:SetPos(self:GetPos())
	blast:SetKeyValue( "iMagnitude", "100" )
	blast:SetKeyValue( "iRadiusOverride", "128" )
	blast:SetKeyValue( "DamageForce", "100" )
	blast:Spawn()
	blast:Activate()
	blast:SetOwner(self)
	blast:Fire("explode","",0.01)
	
	self:SetHealth(1)
	VJ.EmitSound(self, "ambient/energy/weld" .. math.random(1, 2) .. ".wav")

	util.VJ_SphereDamage(self,self,self:GetPos(),100,30,self.MeleeAttackDamageType,true,true,{Force140})
	ParticleEffect("Explosion_2",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end
