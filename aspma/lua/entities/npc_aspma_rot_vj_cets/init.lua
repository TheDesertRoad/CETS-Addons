AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/portal_aspma.mdl"}
ENT.StartHealth = 75
ENT.Weapon_Accuracy = 4
ENT.VJ_NPC_Class = {"CLASS_APERTURE"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_impact_synth_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = false
ENT.Immune_Melee = false
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = true
ENT.AnimTbl_GrenadeAttack = {"throwitem"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 1 -- Time until the grenade is released
ENT.GrenadeAttackEntity = "obj_vj_aspma_extractor"
ENT.ThrowGrenadeChance = 5

ENT.AnimTbl_Medic_GiveHealth = {"throwitem"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.IsMedic = false -- Should it heal allied entities?
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
ENT.MainSoundPitch = 60
ENT.FootStepSoundLevel = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSkin(1)
	self:Give("weapon_vj_cets_aspgun_rot")
end
