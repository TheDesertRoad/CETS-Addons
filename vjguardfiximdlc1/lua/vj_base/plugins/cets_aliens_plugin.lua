/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("CETS", "NPC", "Aliens Expansion")

local vCat = "Zombies + Enemy Aliens"
local vCat1 = "Humans + Resistance"
local vCat2 = "Other"
local spawnCategory = "CETS"

VJ.AddCategoryInfo(spawnCategory, {Icon = "games/16/hl2.png"})

game.AddDecal("VJ_CETS_Burnt1_Small", {"decals/cets_scorch_small1", "decals/cets_scorch_small2", "decals/cets_scorch_small3"})
game.AddDecal("VJ_CETS_Garg_Burnt1", {"decals/cets_garg_burnt"})
game.AddDecal("VJ_CETS_Mom", {"decals/cets_mom1", "decals/cets_mom2", "decals/cets_mom3", "decals/cets_mom4"})
game.AddDecal("VJ_CETS_Voltigore_Blood", {"decals/pblood1", "decals/pblood2", "decals/pblood3", "decals/pblood4", "decals/pblood5", "decals/pblood6", "decals/yblood1", "decals/yblood2", "decals/yblood3", "decals/yblood4", "decals/yblood5", "decals/yblood6"})
game.AddDecal("VJ_CETS_Fungpon_Blood", {"decals/gblood1", "decals/gblood2", "decals/gblood3", "decals/gblood4", "decals/gblood5", "decals/gblood6", "decals/yblood1", "decals/yblood2", "decals/yblood3", "decals/yblood4", "decals/yblood5", "decals/yblood6"})

game.AddParticles("particles/vjguardfiximdlc1particles.pcf")

VJ.AddNPC("Jeff","npc_jeff_vj_cets",vCat)
VJ.AddNPC("Xenian Vortigaunt","npc_slave_vj_cets",vCat)
VJ.AddNPC("Bullsquid","npc_bullchicken_vj_cets",vCat)
VJ.AddNPC("Aquatic Bullsquid","npc_bullchicken_water_vj_cets",vCat)
VJ.AddNPC("Houndeye","npc_hound_normal_vj_cets",vCat)
VJ.AddNPC("Gonome","npc_gonome_vj_cets",vCat)
VJ.AddNPC("Armored Zombie","npc_armorzom_vj_cets",vCat)
VJ.AddNPC("Armored Headcrab","npc_armorhead_vj_cets",vCat)
VJ.AddNPC("Zombiegaunt","npc_slave_z_vj_cets",vCat)
VJ.AddNPC("Antlion Spitter","npc_antspitter_vj_cets",vCat)
VJ.AddNPC("Fungal Fauna","npc_fauna_vj_cets",vCat)
VJ.AddNPC("Alien Controller","npc_aliencontroller_vj_cets",vCat)
VJ.AddNPC("Alien Grunt","npc_aliengrunt_vj_cets",vCat)
VJ.AddNPC("Gargantua","npc_gargantua_vj_cets",vCat)
VJ.AddNPC("Explosive Houndeye","npc_hound_explo_vj_cets",vCat)
VJ.AddNPC("Xen Tree","npc_xentree_vj_cets",vCat)
VJ.AddNPC("Tripod Hopper","npc_tripod_hopper_vj_cets",vCat)
VJ.AddNPC("Stinger","npc_stinger_vj_cets",vCat)
VJ.AddNPC("Armored Charger","npc_armorcharger_vj_cets",vCat)
VJ.AddNPC("Armored Worker","npc_armorwork_vj_cets",vCat)
VJ.AddNPC("Zombie Grunt","npc_zomgrunt_vj_cets",vCat)
VJ.AddNPC("Antlion Heavy","npc_antheavy_vj_cets",vCat)
VJ.AddNPC("Ichthyosaur","npc_ichthyosaur_vj_cets",vCat)
VJ.AddNPC("Flocking Floater","npc_ffloater_vj_cets",vCat)
VJ.AddNPC("Voltigore","npc_voltigore_vj_cets",vCat)
VJ.AddNPC("Shocktrooper","npc_shocktrooper_vj_cets",vCat)
VJ.AddNPC("Shockroach","npc_shockroach_vj_cets",vCat)
VJ.AddNPC("Pit Drone","npc_pitdrone_vj_cets",vCat)
VJ.AddNPC("Sporefish","npc_sporefish_vj_cets",vCat)
VJ.AddNPC("Gonarch","npc_gonarch_vj_cets",vCat)
VJ.AddNPC("Bebcrab","npc_babycrab_vj_cets",vCat)
VJ.AddNPC("Snark","npc_snark_vj_cets",vCat)
VJ.AddNPC("Stukabat","npc_stukabat_vj_cets",vCat)
VJ.AddNPC("Gargantua (Baby)","npc_gargantua_baby_vj_cets",vCat)
VJ.AddNPC("Panthereye","npc_panthereye_vj_cets",vCat)
VJ.AddNPC("Voltigore (Baby)","npc_voltigore_baby_vj_cets",vCat)
VJ.AddNPC("Tentacle","npc_tentacle_vj_cets",vCat)
VJ.AddNPC("Hydra","npc_hydra_vj_cets",vCat)
VJ.AddNPC("Reviver","npc_reviver_vj_cets",vCat)
VJ.AddNPC("Stampeder","npc_stampeder_vj_cets",vCat)

VJ.AddNPC("Tamed Stinger","npc_stinger_r_vj_cets",vCat1)
VJ.AddNPC("Tamed Houndeye","npc_hound_r_vj_cets",vCat1)
VJ.AddNPC("Skitch","npc_skitch_vj_cets",vCat1)
VJ.AddNPC("Tamed Tripod Hopper","npc_tripod_r_vj_cets",vCat1)
VJ.AddNPC("Lamarr","npc_lamarr_vj_cets",vCat1)

VJ.AddNPC("Hornet","obj_vj_alienhornet",vCat2)
VJ.AddNPC("Pit Bullet","obj_vj_pitbullet",vCat2)
VJ.AddNPC("Energy Orb","obj_vj_vortalenergyorb",vCat2)
VJ.AddNPC("Energy Orb (Big)","obj_vj_vortalenergyorb_b",vCat2)
VJ.AddNPC("Energy Orb (Race X)","obj_vj_racexenergyorb",vCat2)
VJ.AddNPC("Energy Orb 2 (Race X)","obj_vj_racexenergyorb_b",vCat2)
VJ.AddNPC("Particle Storm","npc_particlestorm_vj_cets",vCat2)
VJ.AddNPC("Gonarch Pod","npc_mommapod_vj_cets",vCat2)
VJ.AddNPC("Boid","npc_boid_vj_cets",vCat2)
VJ.AddNPC("Squeek Nest","npc_sqnest_vj_cets",vCat2)
VJ.AddNPC("Boomer Plant","npc_boomplant_vj_cets",vCat2)
VJ.AddNPC("Xen Flower Turret","npc_flowerturret_vj_cets",vCat2)
VJ.AddNPC("Xen Light (Yellow)","sent_xenlight_vj_cets",vCat2)
VJ.AddNPC("Xen Light (Red)","sent_xenlighta_vj_cets",vCat2)
VJ.AddNPC("Xen Light (Blue)","sent_xenlightb_vj_cets",vCat2)
VJ.AddNPC("Xen Light (Green)","sent_xenlightc_vj_cets",vCat2)
VJ.AddNPC("Xen Light (White)","sent_xenlightd_vj_cets",vCat2)
VJ.AddNPC("Xen Spore (Large)","sent_xensporelarge_vj_cets",vCat2)
VJ.AddNPC("Xen Spore (Medium)","sent_xensporemedium_vj_cets",vCat2)
VJ.AddNPC("Xen Spore (Small)","sent_xensporesmall_vj_cets",vCat2)
VJ.AddNPC("Xen Grenade Plant","sent_xenplantgren_vj_cets",vCat2)
VJ.AddNPC("Revived Zombie","npc_reviverzom_vj_cets",vCat2)

VJ.AddConVar("sv_cets_max_bebcrab_npcq", 24, FCVAR_ARCHIVE)
VJ.AddConVar("sv_cets_limit_npcs_spawned", 1, FCVAR_ARCHIVE)

VJ.AddConVar("npc_bebcrab_stomp", 0, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_vortigaunt_health", 100, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_vortigauntz_health", 100, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_antsp_health", 30, FCVAR_ARCHIVE)

VJ.AddConVar("sk_jeff_health", 3500, FCVAR_ARCHIVE)
VJ.AddConVar("sk_jeff_dmg_melee", 100, FCVAR_ARCHIVE)

VJ.AddConVar("sk_knocker_health", 130, FCVAR_ARCHIVE)
VJ.AddConVar("sk_knocker_charge_dmg", 25, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_antlions_dig", 0, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_tentacle_strike_non_metal", 1, FCVAR_ARCHIVE)
VJ.AddConVar("npc_cets_tentacle_death_anim", 0, FCVAR_ARCHIVE)
VJ.AddConVar("npc_cets_tentacle_regen", 0, FCVAR_ARCHIVE)
VJ.AddConVar("npc_cets_tentacle_forehide", 0, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_gargantua_preparation", 0, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_gargantua_health", 2400, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_gargantua_baby_health", 600, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_gargantua_dmg", 50, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_gargantua_baby_dmg", 20, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_tentacle_health", 4000, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_acontrol_health", 200, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_agrunt_health", 350, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_agrunt_dmg_charge", 32, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_anthev_health", 80, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_armchz_health", 175, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_armhead_health", 35, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_armwz_health", 85, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_hound_health", 64, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_houndr_health", 85, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_bull_health", 120, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_bullwat_health", 160, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_skitch_health", 850, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_stampeder_health", 500, FCVAR_ARCHIVE)
VJ.AddConVar("sk_cets_stampeder_dmg_charge", 48, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_bulls_xenfriends", 0, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_hounds_xenfriends", 0, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_hydra_xenfriends", 0, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_ichthy_xenfriends", 1, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_hydra_health", 2000, FCVAR_ARCHIVE)
VJ.AddConVar("npc_cets_hydra_forehide", 1, FCVAR_ARCHIVE)
VJ.AddConVar("npc_cets_hydra_death_anim", 1, FCVAR_ARCHIVE)

VJ.AddConVar("npc_cets_shockroach_dienohost", 1, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_reviver_health", 50, FCVAR_ARCHIVE)

VJ.AddConVar("sk_cets_reviverzom_health", 100, FCVAR_ARCHIVE)

//GetConVar("sk_cets_X_health"):GetInt()
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER and not _G.ThumperPulseHook then
	_G.ThumperPulseHook = true
	hook.Add("EntityEmitSound", "ThumperPulseHook",function(data)
		local ent = data.Entity

		if not IsValid(ent) then return end
		if ent:GetClass() ~= "prop_thumper" then return end

		for _, npc in ipairs(ents.FindByClass("npc_antspitter_vj_cets", "npc_antheavy_vj_cets")) do
			if not IsValid(npc) then continue end

			local dist = npc:GetPos():Distance(ent:GetPos())

			if dist <= npc.ThumperFearRadius then
				npc.ThumperSoundPos = ent:GetPos()
				npc.ThumperFearUntil = CurTime() + 5
			end
		end
	end)
end