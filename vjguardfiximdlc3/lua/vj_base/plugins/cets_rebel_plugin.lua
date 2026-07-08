/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("CETS", "NPC", "Humans Expansion")

local vCat = "Humans + Resistance"
local spawnCategory = "CETS"

VJ.AddNPCWeapon("VJ-CETS Gauss Gun", "weapon_vj_cets_tau", spawnCategory)

VJ.AddNPCWeapon("VJ-CETS Resistance Sniper", "weapon_vj_cets_r_sniper", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS Gauss Gun", "weapon_vj_cets_tau", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS MP5SD", "weapon_vj_cets_mp5sd", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS Glock-18", "weapon_vj_cets_glock", spawnCategory)
VJ.AddNPCWeapon("VJ-CETS HECU Sniper", "weapon_vj_cets_hecusniper", spawnCategory)

VJ.AddCategoryInfo(spawnCategory, {Icon = "games/16/hl2.png"})
VJ.AddNPC("Conscript","npc_conscript_vj_cets",vCat)
VJ.AddNPC("Gauss Holder","npc_tau_vj_cets",vCat)
VJ.AddNPC("Suicidal","npc_bomber_vj_cets",vCat)
VJ.AddNPC("Headcrab Cultist","npc_cultist_vj_cets",vCat)
VJ.AddNPC("Combine Loyal","npc_loyal_vj_cets",vCat)
VJ.AddNPC("Rebel Sniper","npc_resniper_vj_cets",vCat)
VJ.AddNPC("Infiltrator","npc_spy_vj_cets",vCat)
VJ.AddNPC("The Consul","npc_consul_vj_cets",vCat)
VJ.AddNPC("Otis Laurey","npc_otis_vj_cets",vCat)
VJ.AddNPC("Scientist","npc_scientist_vj_cets",vCat)
VJ.AddNPC("Security Guard","npc_secguard_vj_cets",vCat)
VJ.AddNPC("HECU Soldier","npc_hecu_vj_cets",vCat)
VJ.AddNPC("The Worker","npc_rengi_vj_cets",vCat)
VJ.AddNPC("HECU Sniper","npc_hecusniper_vj_cets",vCat)
VJ.AddNPC("Conscript APC","npc_conscript_apc_vj_cets",vCat)
VJ.AddNPC("Heavy Conscript","npc_heavy_conscript_vj_cets",vCat)
VJ.AddNPC("HECU Shotgunner","npc_hecu_shotgunner_vj_cets",vCat)
VJ.AddNPC("HECU Mechanical Unit","npc_hecu_robot_vj_cets",vCat)
VJ.AddNPC("Caste","npc_caste_vj_cets",vCat)
VJ.AddNPC("Citylesszen","npc_citylesszen_vj_cets",vCat)
//VJ.AddNPC("Black Ops. Assassin","npc_blackops_assassin_vj_cets",vCat)

VJ.AddConVar("radiobroad_volume", 75, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_barney_voice", 1, FCVAR_ARCHIVE)
VJ.AddConVar("npc_cets_hecu_voice", 1, FCVAR_ARCHIVE)

VJ.AddConVar("sk_apc_conscript_health", 400, FCVAR_ARCHIVE)

game.AddDecal("VJ_CETS_Gauss", {"decals/cets_gauss"})
game.AddDecal("VJ_CETS_Gauss_B", {"decals/cets_gauss_b"})

game.AddParticles("particles/vjguardfiximdlc3particles.pcf")

VJ.AddConVar("sk_max_cets_mp5sd", 50, FCVAR_ARCHIVE)
VJ.AddConVar("sk_max_cets_mp5sd_bullet", 200, FCVAR_ARCHIVE)
VJ.AddConVar("sk_plr_cets_dmg_mp5sd", 4, FCVAR_ARCHIVE)

VJ.AddConVar("sk_max_cets_hecsnip", 15, FCVAR_ARCHIVE)
VJ.AddConVar("sk_max_cets_hecsnip_bullet", 5, FCVAR_ARCHIVE)
VJ.AddConVar("sk_plr_cets_dmg_hecsnip", 100, FCVAR_ARCHIVE)