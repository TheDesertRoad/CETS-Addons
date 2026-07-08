/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("CETS", "NPC", "Base/Default")

local vCat = "Combine"
local vCat1 = "Other"
local spawnCategory = "CETS"

VJ.AddCategoryInfo(spawnCategory, {Icon = "games/16/hl2.png"})

game.AddDecal("VJ_CETS_Beam1", {"sprites/tp_beam002"})

game.AddDecal("VJ_CETS_BBlood", {"decals/bblood1", "decals/bblood2", "decals/bblood3", "decals/bblood4", "decals/bblood5", "decals/bblood6"})
game.AddDecal("VJ_CETS_GBlood", {"decals/gblood1", "decals/gblood2", "decals/gblood3", "decals/gblood4", "decals/gblood5", "decals/gblood6"})
game.AddDecal("VJ_CETS_OBlood", {"decals/oblood1", "decals/oblood2", "decals/oblood3", "decals/oblood4", "decals/oblood5", "decals/oblood6"})
game.AddDecal("VJ_CETS_WBlood", {"decals/wblood1", "decals/wblood2", "decals/wblood3", "decals/wblood4", "decals/wblood5", "decals/wblood6"})
game.AddDecal("VJ_CETS_PBlood", {"decals/pblood1", "decals/pblood2", "decals/pblood3", "decals/pblood4", "decals/pblood5", "decals/pblood6"})
game.AddDecal("VJ_CETS_RCBlood", {"decals/rcblood1", "decals/rcblood2", "decals/rcblood3", "decals/rcblood4", "decals/rcblood5", "decals/rcblood6"})
game.AddDecal("VJ_CETS_NBlood", {"decals/nblood1", "decals/nblood2", "decals/nblood3", "decals/nblood4", "decals/nblood5", "decals/nblood6", "decals/nblood7", "decals/nblood8"})
game.AddDecal("VJ_CETS_BurntScorch1", {"decals/burnt_scorch1"})
game.AddDecal("VJ_CETS_BurntScorch2", {"decals/burnt_scorch2"})
game.AddDecal("VJ_CETS_BurntScorch3", {"decals/burnt_scorch3"})

VJ.AddNPCWeapon("VJ-CETS OICW", "weapon_vj_cets_oicw", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS MP5k", "weapon_vj_cets_mp5k", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS HMG", "weapon_vj_cets_hmg", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS 9mm Pistol", "weapon_vj_cets_9mmpistol", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS .357 Magnum", "weapon_vj_cets_357", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS Pulse-Rifle", "weapon_vj_cets_ar2", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS SMG", "weapon_vj_cets_smg1", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS Shotgun", "weapon_vj_cets_spas12", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS Combine Spear", "weapon_vj_cets_comb_spear", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS NOTHING!", "weapon_vj_cets_nothing", spawnCategory)

VJ.AddNPC("Combine Guard","npc_combineguard_vj_cets",vCat)
VJ.AddNPC("Cremator","npc_cremator_vj_cets",vCat)
VJ.AddNPC("Overwatch Assassin","npc_fassassin_vj_cets",vCat)
VJ.AddNPC("Crab Synth","npc_crabsynth_vj_cets",vCat)
VJ.AddNPC("Mortar Synth","npc_mortarsynth_vj_cets",vCat)
VJ.AddNPC("Metro-Police Elite","npc_elitemetropolice_vj_cets",vCat)
VJ.AddNPC("Combine Grunt","npc_echo_vj_cets",vCat)
VJ.AddNPC("Combine Ordinal","npc_ordinal_vj_cets",vCat)
VJ.AddNPC("Combine Charger","npc_wallhammer_vj_cets",vCat)
VJ.AddNPC("Combine Suppressor","npc_suppressor_vj_cets",vCat)
VJ.AddNPC("Combine Hazmat","npc_haz_vj_cets",vCat)
VJ.AddNPC("Combine Worker","npc_work_vj_cets",vCat)
VJ.AddNPC("Combine Gasser","npc_gasser_vj_cets",vCat)
VJ.AddNPC("Assassin Synth","npc_assassin_synth_vj_cets",vCat)
VJ.AddNPC("Vortigaunt Synth","npc_vortigaunt_synth_vj_cets",vCat)
VJ.AddNPC("Combine APC","npc_combine_apc_vj_cets",vCat)
VJ.AddNPC("Combine Sniper","npc_combsniper_vj_cets",vCat)
VJ.AddNPC("Combine Spikewall","npc_spikewall_vj_cets",vCat)
VJ.AddNPC("Transition Soldier","npc_transold_vj_cets",vCat)
VJ.AddNPC("Combine Prisioner Transport","npc_combine_swat_vj_cets",vCat)
VJ.AddNPC("Wasteland Scanner","npc_wastescan_vj_cets",vCat)
VJ.AddNPC("Synth Soldier","npc_synthsoldier_vj_cets",vCat)
VJ.AddNPC("Elite Synth Soldier","npc_synthsoldier_elite_vj_cets",vCat)
VJ.AddNPC("Outlands Soldier","npc_huntersold_vj_cets",vCat)
VJ.AddNPC("Alien Supporter","npc_xrang_vj_cets",vCat)
VJ.AddNPC("Combine Flamer","npc_flamer_vj_cets",vCat)
VJ.AddNPC("Combine Engineer","npc_engi_vj_cets",vCat)
VJ.AddNPC("Combine Medic","npc_medic_vj_cets",vCat)

VJ.AddNPC("Wasteland Scanner (Paired)","npc_wastescan_pair_vj_cets",vCat1)
VJ.AddNPC("Super Synth","npc_supersynth_vj_cets",vCat1)
VJ.AddNPC("Assault Synth","npc_assault_synth_vj_cets",vCat1)

game.AddParticles("particles/vjguardfixim_particles.pcf")

VJ.AddConVar("sk_healthpen", 5, FCVAR_ARCHIVE)

VJ.AddConVar("sk_max_cets_mp5k", 30, FCVAR_ARCHIVE)
VJ.AddConVar("sk_max_cets_mp5k_bullet", 120, FCVAR_ARCHIVE)
VJ.AddConVar("sk_plr_cets_dmg_mp5k", 6, FCVAR_ARCHIVE)

VJ.AddConVar("sk_max_cets_hmg", 100, FCVAR_ARCHIVE)
VJ.AddConVar("sk_max_cets_hmg_bullet", 200, FCVAR_ARCHIVE)
VJ.AddConVar("sk_plr_cets_dmg_hmg", 10, FCVAR_ARCHIVE)

VJ.AddConVar("sk_max_cets_oicw", 30, FCVAR_ARCHIVE)
VJ.AddConVar("sk_max_cets_oicw_bullet", 120, FCVAR_ARCHIVE)
VJ.AddConVar("sk_plr_cets_dmg_oicw", 6, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_ar2scrotums_enable", 1, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_ar2scrotums_dirdam", 200, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_ar2scrotums_dirdamply", 400, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_ar2scrotums_dieraddam", 25, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_kiscrotums_enable", 1, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_kiscrotums_dirdam", 30, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_kiscrotums_dirdamply", 400, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_kiscrotums_dieraddam", 56, FCVAR_ARCHIVE)

VJ.AddConVar("sk_crabsynth_health", 700, FCVAR_ARCHIVE)
VJ.AddConVar("sk_crabsynth_charge_dmg", 60, FCVAR_ARCHIVE)
VJ.AddConVar("npc_crabsynth_disable_charge", 0, FCVAR_ARCHIVE)

VJ.AddConVar("npc_apc_cets_hacks", 0, FCVAR_ARCHIVE)

VJ.AddConVar("sk_assassin_synth_health", 150, FCVAR_ARCHIVE)

VJ.AddConVar("sk_combswat_health", 600, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cguard_health", 500, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cguard_dmg_shove", 60, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cguard_suck_radius", 155, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cguard_dmg_exp", 86, FCVAR_ARCHIVE)

VJ.AddConVar("sk_supsynth_health", 450, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_wscanner_bionade", 1, FCVAR_ARCHIVE)
VJ.AddConVar("sk_wscanner_health", 35, FCVAR_ARCHIVE)
VJ.AddConVar("sk_wscanner_crash_chance", 0, FCVAR_ARCHIVE)

VJ.AddConVar("sk_charger_stunbaton_chance", 1, FCVAR_ARCHIVE)

VJ.AddConVar("sk_csniper_health", 50, FCVAR_ARCHIVE)
VJ.AddConVar("sk_csniper_accurancy", 0.001, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cremator_health", 300, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cremator_cremate_dur", 4.4, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cremator_cremate_damage", 4, FCVAR_ARCHIVE)

VJ.AddConVar("sk_mortar_health", 65, FCVAR_ARCHIVE)
VJ.AddConVar("sk_mortar_crash_chance", 1, FCVAR_ARCHIVE)

VJ.AddConVar("sk_fassassin_health", 65, FCVAR_ARCHIVE)
VJ.AddConVar("sk_fassassin_dmg_melee", 25, FCVAR_ARCHIVE)
VJ.AddConVar("sk_fassassin_cloak_time", 30, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_vortsynth_health", 120, FCVAR_ARCHIVE)

VJ.AddConVar("sk_aspma_health", 75, FCVAR_ARCHIVE)

VJ.AddConVar("cets_keepcorpses_collide", 0, FCVAR_ARCHIVE)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("CreateEntityRagdoll", "stop_ragdoll_collide", function(owner, ragdoll)
	if GetConVarNumber("cets_keepcorpses_collide") == 0 then  
		ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	else
		ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local hiddenNPCs = {
	["npc_fire_throw_vj_cets"] = true,
	["npc_acid_throw_vj_cets"] = true,
	["npc_toxic_gas_vj_cets"] = true,
	["npc_boomplant_vj_cets"] = true,
	["npc_jeff_fungalgas_vj_cets"] = true,
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("OnNPCKilled", "SuppressKillFeed", function(npc, attacker, inflictor)
	if hiddenNPCs[npc:GetClass()] then
		return false
	end
end)