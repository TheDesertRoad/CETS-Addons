AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/combine_hunter.mdl"}
ENT.StartHealth = 75
ENT.Weapon_Accuracy  = 2
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 0.82 -- Time until the grenade is released
ENT.GrenadeAttackEntity = "obj_vj_cets_extractor_sonic" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"

ENT.IsMedic = true
ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations

ENT.CanUseSecondaryOnWeaponAttack = true -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"weapon_ply_comgr_s",
	"item_battery",
	"item_healthvial",
	"item_ammo_ar2_altfire",
}

ENT.SoundTbl_MedicOnHeal = "hl1/items/smallmedkit2.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_ar2")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ar2 = ents.Create("weapon_ar2")
		ar2:SetPos(att.Pos)
		ar2:SetAngles(att.Ang)
		ar2:Spawn()
	end
end