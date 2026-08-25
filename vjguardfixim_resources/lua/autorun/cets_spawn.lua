hook.Add("PopulatePropMenu", "CETS_Spawnlist", function()
	local contents = {
		-- Bad Guys
		{
			type = "header",
			text = "Bad Guys"
		},

		{ type = "model", model = "models/assassin.mdl" },
		{ type = "model", model = "models/combine_gasser.mdl" },
		{ type = "model", model = "models/hl2_combine_ordinal.mdl" },
		{ type = "model", model = "models/hl2_combine_transitionperiod.mdl" },
		{ type = "model", model = "models/hl2_combine_wallhammer.mdl" },
		{ type = "model", model = "models/combine_sniper.mdl" },
		{ type = "model", model = "models/combine_hunter.mdl" },
		{ type = "model", model = "models/elitepolice.mdl" },
		{ type = "model", model = "models/hl2_flamercomb_soldier.mdl" },
		{ type = "model", model = "models/hl2_alienranger.mdl" },
		{ type = "model", model = "models/hl2_combine_engineer.mdl" },
		{ type = "model", model = "models/hl2_combine_grunt.mdl" },
		{ type = "model", model = "models/hl2_combine_medic.mdl" },
		{ type = "model", model = "models/hl2_combine_spikewall_sized.mdl" },
		{ type = "model", model = "models/hl2_combine_suppressor.mdl" },
		{ type = "model", model = "models/hl2_combine_hazmat.mdl" },
		{ type = "model", model = "models/workernpc.mdl" },
		{ type = "model", model = "models/hl2_crabsynth.mdl" },
		{ type = "model", model = "models/hl2_elite_brown.mdl" },
		{ type = "model", model = "models/hl2_elite_green.mdl" },
		{ type = "model", model = "models/hl2_fassassin.mdl" },
		{ type = "model", model = "models/hl2_outfassassin.mdl" },
		{ type = "model", model = "models/vj_combine_guard_z.mdl" },
		{ type = "model", model = "models/cremator/cremator.mdl" },
		{ type = "model", model = "models/vortigaunt_synth/vj_vortigaunt_synth_z.mdl" },
		{ type = "model", model = "models/synth_soldier.mdl" },
		{ type = "model", model = "models/hl2_wscanner.mdl" },
		{ type = "model", model = "models/hl2_wscanner_pair.mdl" },
		{ type = "model", model = "models/hl2_wscanner_tri.mdl" },
		{ type = "model", model = "models/hl2_construction_strider.mdl" },
		{ type = "model", model = "models/hl2_advisor.mdl" },
		{ type = "model", model = "models/combine_advisor_juvenile.mdl" },
		{ type = "model", model = "models/hl2_alien_elite.mdl" },
		{ type = "model", model = "models/assault_synth.mdl" },
		{ type = "model", model = "models/mortarsynth.mdl" },

		-- Vehicles
		{
			type = "header",
			text = "Vehicles"
		},

		{ type = "model", model = "models/vehicles/comb_swat.mdl" },
		{ type = "model", model = "models/vehicles/comb_swat_wheelcollision.mdl" },

		-- Items & Pickups
		{
			type = "header",
			text = "Items & Pickups"
		},

		{ type = "model", model = "models/items/crafting_metal/resin_puck01.mdl" },
		{ type = "model", model = "models/items/crafting_metal/resin_puck02.mdl" },
		{ type = "model", model = "models/items/crafting_metal/resin_puck03.mdl" },
		{ type = "model", model = "models/items/crafting_metal/resin_puck_stack.mdl" },
		{ type = "model", model = "models/weapons/w_hopwire.mdl" },
		{ type = "model", model = "models/hl2_healthpen.mdl" },

		-- Weapons
		{
			type = "header",
			text = "Weapons"
		},

		{ type = "model", model = "models/weapons/w_cgrenade.mdl" },
		{ type = "model", model = "models/weapons/w_comgrenade.mdl" },
		{ type = "model", model = "models/weapons/w_comgrenade_acid.mdl" },
		{ type = "model", model = "models/weapons/w_comgrenade_sonic.mdl" },
		{ type = "model", model = "models/cguard_gun.mdl" },
		{ type = "model", model = "models/weapons/w_hl2psmg.mdl" },
		{ type = "model", model = "models/weapons/w_hmg1.mdl" },
		{ type = "model", model = "models/weapons/w_ihmg.mdl" },
		{ type = "model", model = "models/weapons/w_immolator.mdl" },
		{ type = "model", model = "models/weapons/w_ishotgun.mdl" },
		{ type = "model", model = "models/weapons/w_oicw.mdl" },
		{ type = "model", model = "models/weapons/w_smg2.mdl" },
		{ type = "model", model = "models/weapons/w_ar1.mdl" },
		{ type = "model", model = "models/weapons/w_combinesniper.mdl" },
		{ type = "model", model = "models/weapons/w_spear.mdl" },
		{ type = "model", model = "models/weapons/w_flamethrower.mdl" },

		-- Props
		{
			type = "header",
			text = "Props"
		},

		{ type = "model", model = "models/weapons/assassin_flechette.mdl" },
		{ type = "model", model = "models/misc/cube025x025x025.mdl" },
		{ type = "model", model = "models/misc/cube025x05x025.mdl" },
		{ type = "model", model = "models/misc/cube025x075x025.mdl" },

		-- NPC Gibs
		{
			type = "header",
			text = "NPC Gibs"
		},

		{ type = "model", model = "models/cremator/cremator_body.mdl" },
		{ type = "model", model = "models/cremator/cremator_head.mdl" },
		{ type = "model", model = "models/gibs/msynth_gibs1.mdl" },
		{ type = "model", model = "models/gibs/msynth_gibs2.mdl" },
		{ type = "model", model = "models/gibs/msynth_gibs3.mdl" },
		{ type = "model", model = "models/gibs/msynth_gibs4.mdl" },
		{ type = "model", model = "models/gibs/msynth_gibs5.mdl" },
		{ type = "model", model = "models/gibs/msynth_gibs6.mdl" }
	}

	spawnmenu.AddPropCategory("cets_spawnlist", "CETS", contents, "icon32/spawn_cetsCMB.png", 37, nil)
end)

hook.Add("PopulatePropMenu", "CETS_AliensPack_Spawnlist", function()

	local contents = {

		-- Effects
		{
			type = "header",
			text = "Effects"
		},

		{
			type = "model",
			model = "models/energyball_xen.mdl"
		},


		-- Fauna
		{
			type = "header",
			text = "Fauna"
		},

		{
			type = "model",
			model = "models/hl2_agrunt.mdl"
		},
		{
			type = "model",
			model = "models/hl2_agrunt_unarmored.mdl"
		},
		{
			type = "model",
			model = "models/hl2_controller.mdl"
		},
		{
			type = "model",
			model = "models/hl2_panthereye.mdl"
		},
		{
			type = "model",
			model = "models/hl2_stinger.mdl"
		},
		{
			type = "model",
			model = "models/hl2_stukabat.mdl"
		},
		{
			type = "model",
			model = "models/skitch.mdl"
		},
		{
			type = "model",
			model = "models/hl2_knocker.mdl"
		},
		{
			type = "model",
			model = "models/hl2_exhoundeye.mdl"
		},
		{
			type = "model",
			model = "models/hl2_houndeye.mdl"
		},
		{
			type = "model",
			model = "models/hl2_rhoundeye.mdl"
		},
		{
			type = "model",
			model = "models/hl2_stampeder.mdl"
		},
		{
			type = "model",
			model = "models/hl2_ichthy.mdl"
		},
		{
			type = "model",
			model = "models/hl2_gargantua.mdl"
		},
		{
			type = "model",
			model = "models/hl2_hydra_large.mdl"
		},
		{
			type = "model",
			model = "models/hl2_tentacle.mdl"
		},
		{
			type = "model",
			model = "models/racex/hl2_voltigore.mdl"
		},
		{
			type = "model",
			model = "models/racex/hl2_shock_trooper.mdl"
		},
		{
			type = "model",
			model = "models/racex/hl2_pit_drone.mdl",
			body = "B010000000"
		},
		{
			type = "model",
			model = "models/xen_tree.mdl"
		},
		{
			type = "model",
			model = "models/racex/hl2_shockroach.mdl"
		},
		{
			type = "model",
			model = "models/racex/hl2_sporefish.mdl"
		},
		{
			type = "model",
			model = "models/hl2_bullsquid.mdl"
		},
		{
			type = "model",
			model = "models/hl2_bullsquid_water.mdl"
		},
		{
			type = "model",
			model = "models/Antlions/soldier_ant.mdl"
		},
		{
			type = "model",
			model = "models/Antlions/spitter_ant.mdl"
		},
		{
			type = "model",
			model = "models/hl2_flock_float.mdl"
		},
		{
			type = "model",
			model = "models/hl2_hopper.mdl"
		},
		{
			type = "model",
			model = "models/hl2_snark.mdl"
		},
		{
			type = "model",
			model = "models/hl2_snarknest.mdl"
		},
		{
			type = "model",
			model = "models/hl2_archer.mdl"
		},
		{
			type = "model",
			model = "models/hl2_boid.mdl"
		},
		{
			type = "model",
			model = "models/hl2_hornet.mdl"
		},
		{
			type = "model",
			model = "models/fungalfauna.mdl"
		},
		{
			type = "model",
			model = "models/hl2_sandacle.mdl"
		},
		{
			type = "model",
			model = "models/afauna1.mdl"
		},


		-- Undead Guys
		{
			type = "header",
			text = "Undead Guys"
		},

		{
			type = "model",
			model = "models/hl2_babycrab.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/headcrabarmored.mdl"
		},
		{
			type = "model",
			model = "models/hl2_reviver.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/classic_armored.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/zombie_scientist.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/zordinal.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/armored.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/soldier_zombie.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/armored_zombie_charger.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/zombie_hl2_combine_grunt.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/zombie_hl2_combine_hazmat.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/Revived_Classic.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/zombie_soldier_armored.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/vortigaunt_zombie.mdl"
		},
		{
			type = "model",
			model = "models/hl2_jeff.mdl"
		},
		{
			type = "model",
			model = "models/hl2_gonome.mdl"
		},
		{
			type = "model",
			model = "models/hl2_mompod.mdl"
		},
		{
			type = "model",
			model = "models/hl2_gonarch.mdl",
			skin = 1
		},


		-- Items & Pickups
		{
			type = "header",
			text = "Items & Pickups"
		},

		{
			type = "model",
			model = "models/hl2_organest.mdl"
		},
		{
			type = "model",
			model = "models/weapons/w_hl2_hgun.mdl"
		},
		{
			type = "model",
			model = "models/weapons/w_hl2_snark.mdl"
		},
		{
			type = "model",
			model = "models/weapons/w_shock_rifle.mdl"
		},


		-- Props
		{
			type = "header",
			text = "Props"
		},

		{
			type = "model",
			model = "models/props_cets_aliens/boomerplant_01.mdl"
		},
		{
			type = "model",
			model = "models/props_cets_aliens/boomerplant_exploded.mdl"
		},
		{
			type = "model",
			model = "models/props_cets_aliens/xen_flower_p1.mdl"
		},
		{
			type = "model",
			model = "models/props_cets_aliens/xen_flower_p2.mdl"
		},
		{
			type = "model",
			model = "models/props_cets_aliens/combine_flashlight.mdl"
		},
		{
			type = "model",
			model = "models/props_cets_aliens/zombie_bloater.mdl"
		},


		-- Foliage
		{
			type = "header",
			text = "Foliage"
		},

		{
			type = "model",
			model = "models/props_cets_aliens/xen_flower_s.mdl"
		},
		{
			type = "model",
			model = "models/hl2_sporelarge.mdl"
		},
		{
			type = "model",
			model = "models/hl2_sporemid.mdl"
		},
		{
			type = "model",
			model = "models/hl2_sporesmall.mdl"
		},
		{
			type = "model",
			model = "models/hl2_xenlight.mdl"
		},
		{
			type = "model",
			model = "models/props_cets_aliens/xen_grenade_plant.mdl"
		},


		-- NPC Gibs
		{
			type = "header",
			text = "NPC Gibs"
		},

		{
			type = "model",
			model = "models/Antlions/gibs/spitter_ant_gib_large_1.mdl"
		},
		{
			type = "model",
			model = "models/Antlions/gibs/spitter_ant_gib_large_2.mdl"
		},
		{
			type = "model",
			model = "models/Antlions/gibs/spitter_ant_gib_large_3.mdl"
		},
		{
			type = "model",
			model = "models/props_cets_aliens/gargantua_brain.mdl"
		},
		{
			type = "model",
			model = "models/fungalfauna_body.mdl"
		},
		{
			type = "model",
			model = "models/Zombie/armoredcrab_shell.mdl"
		},
		{
			type = "model",
			model = "models/racex/hl2_pitdrone_spike.mdl"
		}
	}


	spawnmenu.AddPropCategory("cets_aliens_pack", "Aliens Pack", contents, "icon32/spawn_cetsALN.png", 38, 37)
end)

hook.Add("PopulatePropMenu", "CETS_HumansPack_Spawnlist", function()

	local contents = {

		-- Main Characters
		{
			type = "header",
			text = "Main Characters"
		},

		{ type = "model", model = "models/hl2_consul.mdl" },
		{ type = "model", model = "models/interloper_high.mdl" },
		{ type = "model", model = "models/otis.mdl" },
		{ type = "model", model = "models/humans/conscripts/capt_vance.mdl" },
		{ type = "model", model = "models/humans/scientist/young_kleiner.mdl" },
		{ type = "model", model = "models/humans/security/bm_barney.mdl" },
		{ type = "model", model = "models/humans/gman_spy/spy_04.mdl" },
		{ type = "model", model = "models/humans/worker/worker_04.mdl" },


		-- Rebels
		{
			type = "header",
			text = "Rebels"
		},

		{ type = "model", model = "models/humans/7eleven_clerk.mdl" },
		{ type = "model", model = "models/humans/alyn.mdl" },
		{ type = "model", model = "models/humans/caste_f_npc.mdl" },
		{ type = "model", model = "models/humans/caste_npc.mdl" },
		{ type = "model", model = "models/humans/cets_male_03.mdl" },
		{ type = "model", model = "models/humans/cets_male_05.mdl" },
		{ type = "model", model = "models/humans/cets_male_07.mdl" },
		{ type = "model", model = "models/humans/human_workers/group01/male_01.mdl" },
		{ type = "model", model = "models/humans/human_workers/group01/male_09.mdl" },
		{ type = "model", model = "models/humans/human_workers/group02/male_01.mdl" },
		{ type = "model", model = "models/humans/human_workers/group02/male_09.mdl" },
		{ type = "model", model = "models/humans/human_workers/group03/male_01_bloody.mdl" },
		{ type = "model", model = "models/humans/human_workers/group03/male_09_bloody.mdl" },
		{ type = "model", model = "models/humans/human_workers/group03m/male_01.mdl" },
		{ type = "model", model = "models/humans/human_workers/group03m/male_09.mdl" },
		{ type = "model", model = "models/humans/group05/female01.mdl" },
		{ type = "model", model = "models/humans/group05/male01.mdl" },
		{ type = "model", model = "models/humans/greg.mdl" },
		{ type = "model", model = "models/humans/hobo.mdl" },
		{ type = "model", model = "models/humans/hobo2.mdl" },
		{ type = "model", model = "models/humans/larry.mdl" },
		{ type = "model", model = "models/humans/male_bomber.mdl" },
		{ type = "model", model = "models/humans/milkdrinker.mdl" },
		{ type = "model", model = "models/humans/rebel_sniper.mdl" },
		{ type = "model", model = "models/humans/rotten.mdl" },
		{ type = "model", model = "models/humans/sandro.mdl" },
		{ type = "model", model = "models/humans/vic.mdl" },
		{ type = "model", model = "models/humans/vinnie.mdl" },
		{ type = "model", model = "models/humans/emo_09.mdl" },


		-- Conscripts
		{
			type = "header",
			text = "Conscripts"
		},

		{ type = "model", model = "models/humans/conscripts/male_02.mdl" },
		{ type = "model", model = "models/humans/conscripts/male_02_test.mdl" },
		{ type = "model", model = "models/humans/conscripts/male_07.mdl" },
		{ type = "model", model = "models/humans/conscripts/male_09.mdl" },
		{ type = "model", model = "models/humans/conscripts/male_masked.mdl" },
		{ type = "model", model = "models/humans/conscripts/pm_conscript.mdl" },
		{ type = "model", model = "models/humans/conscripts_heavy/male_02.mdl" },
		{ type = "model", model = "models/humans/conscripts_heavy/male_07.mdl" },
		{ type = "model", model = "models/humans/conscripts_heavy/male_masked.mdl" },


		-- Black Mesa & Military Humans
		{
			type = "header",
			text = "Black Mesa & Military Humans"
		},

		{ type = "model", model = "models/humans/scientist/dr_cohrt.mdl" },
		{ type = "model", model = "models/humans/scientist/dr_einstein.mdl" },
		{ type = "model", model = "models/humans/scientist/female_01.mdl" },
		{ type = "model", model = "models/humans/scientist/female_02.mdl" },
		{ type = "model", model = "models/humans/scientist/female_03.mdl" },
		{ type = "model", model = "models/humans/scientist/female_04.mdl" },
		{ type = "model", model = "models/humans/scientist/female_05.mdl" },
		{ type = "model", model = "models/humans/scientist/female_06.mdl" },
		{ type = "model", model = "models/humans/scientist/male_01.mdl" },
		{ type = "model", model = "models/humans/scientist/male_02.mdl" },
		{ type = "model", model = "models/humans/scientist/male_03.mdl" },
		{ type = "model", model = "models/humans/scientist/male_04.mdl" },
		{ type = "model", model = "models/humans/scientist/male_05.mdl" },
		{ type = "model", model = "models/humans/scientist/male_06.mdl" },
		{ type = "model", model = "models/humans/scientist/male_07.mdl" },
		{ type = "model", model = "models/humans/scientist/male_08.mdl" },
		{ type = "model", model = "models/humans/scientist/male_09.mdl" },
		{ type = "model", model = "models/humans/security/bm_guard1.mdl" },
		{ type = "model", model = "models/humans/security/bm_guard2.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt1.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt1_mask.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt2.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt2_mask.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt3.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt4.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt5.mdl" },
		{ type = "model", model = "models/humans/grunt/hgrunt_robot.mdl" },
		{ type = "model", model = "models/humans/blackops/hassassin.mdl" },
		{ type = "model", model = "models/npcs/sentry_ground.mdl" },


		-- Bad Guys
		{
			type = "header",
			text = "Bad Guys"
		},

		{ type = "model", model = "models/humans/ej_loyalists/male_01.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_02.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_03.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_04.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_05.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_06.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_07.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_08.mdl" },
		{ type = "model", model = "models/humans/ej_loyalists/male_09.mdl" },


		-- Undead Guys
		{
			type = "header",
			text = "Undead Guys"
		},

		{ type = "model", model = "models/headcrab_cultists/cultist_01.mdl" },
		{ type = "model", model = "models/zombie/divzombine.mdl" },


		-- Vehicles
		{
			type = "header",
			text = "Vehicles"
		},

		{ type = "model", model = "models/cnapc.mdl" },
		{ type = "model", model = "models/vehicles/APC/apc.mdl" },
		{ type = "model", model = "models/vehicles/APC/conscript_apc.mdl" },
		{ type = "model", model = "models/hl_tank_chasis.mdl" },
		{ type = "model", model = "models/hl_tank_turret.mdl" },


		-- Wheels & Bits
		{
			type = "header",
			text = "Wheels & Bits"
		},

		{ type = "model", model = "models/vehicles/APC/apc_tire001.mdl" },


		-- Items & Pickups
		{
			type = "header",
			text = "Items & Pickups"
		},

		{ type = "model", model = "models/items/classic_healthkit.mdl" },
		{ type = "model", model = "models/items/classic_healthvial.mdl" },
		{ type = "model", model = "models/items/classic_battery.mdl" },
		{ type = "model", model = "models/weapons/w_hl2_gaussammo.mdl" },
		{ type = "model", model = "models/weapons/hl2_mp5_grenade.mdl" },
		{ type = "model", model = "models/items/boxsniperroundz.mdl" },
		{ type = "model", model = "models/props_marines/tow_missile_projectile.mdl" },
		{ type = "model", model = "models/props_marines/triplaser.mdl" },


		-- Weapons
		{
			type = "header",
			text = "Weapons"
		},

		{ type = "model", model = "models/weapons/W_hl2_taucannon.mdl" },
		{ type = "model", model = "models/weapons/w_hl2_egon.mdl" },
		{ type = "model", model = "models/weapons/w_hl2_m16.mdl" },
		{ type = "model", model = "models/weapons/w_hl2_mp5.mdl" },
		{ type = "model", model = "models/weapons/w_sniper.mdl" },
		{ type = "model", model = "models/weapons/w_hl2_m40a1.mdl" },
		{ type = "model", model = "models/weapons/w_g18_pistol.mdl" },
		{ type = "model", model = "models/weapons/w_molotov.mdl" },
		{ type = "model", model = "models/weapons/w_frag.mdl" },
		{ type = "model", model = "models/weapons/w_chefsknife.mdl" },


		-- Props
		{
			type = "header",
			text = "Props"
		},

		{ type = "model", model = "models/props_cets/health_bmcharger001.mdl" },
		{ type = "model", model = "models/props_cets/suit_bmcharger001.mdl" },
		{ type = "model", model = "models/props_marines/50_cal_destroyed.mdl" },
		{ type = "model", model = "models/props_marines/50_cal_static.mdl" },
		{ type = "model", model = "models/props_marines/50cal.mdl" },
		{ type = "model", model = "models/props_marines/alicepack.mdl" },
		{ type = "model", model = "models/props_marines/ammo_crate.mdl" },
		{ type = "model", model = "models/props_marines/ammo_crate02.mdl" },
		{ type = "model", model = "models/props_marines/ammo_crate02_static.mdl" },
		{ type = "model", model = "models/props_marines/ammobox01.mdl" },
		{ type = "model", model = "models/props_marines/ammocrate01.mdl" },
		{ type = "model", model = "models/props_marines/ammocrate01_static.mdl" },
		{ type = "model", model = "models/props_marines/army_radio.mdl" },
		{ type = "model", model = "models/props_marines/bayonet.mdl" },
		{ type = "model", model = "models/props_marines/broken_granade_box.mdl" },
		{ type = "model", model = "models/props_marines/c4_explosive.mdl" },
		{ type = "model", model = "models/props_marines/cot.mdl" },
		{ type = "model", model = "models/props_marines/etool.mdl" },
		{ type = "model", model = "models/props_marines/missile_crate.mdl" },
		{ type = "model", model = "models/props_marines/missile_crate_open.mdl" },
		{ type = "model", model = "models/props_marines/missile_crate_lid.mdl" },
		{ type = "model", model = "models/props_marines/ordnance_crate.mdl" },
		{ type = "model", model = "models/props_marines/prc77_radio.mdl" },
		{ type = "model", model = "models/props_marines/sandbag.mdl" },
		{ type = "model", model = "models/props_marines/sandbag_static.mdl" },
		{ type = "model", model = "models/props_marines/sandbags_long128.mdl" },
		{ type = "model", model = "models/props_marines/sandbags_semicircle.mdl" },
		{ type = "model", model = "models/props_marines/tow_missile_system.mdl" },
		{ type = "model", model = "models/props_marines/tow_missile_system_mp.mdl" },
		{ type = "model", model = "models/props_marines/sentry_undeployed.mdl" },
		{ type = "model", model = "models/props_marines/mil_flashlight.mdl" },
		{ type = "model", model = "models/props_marines/ivstand_bag.mdl" },
		{ type = "model", model = "models/props_marines/ivstand.mdl" }
	}


	spawnmenu.AddPropCategory("cets_humans_pack", "Humans Pack", contents, "icon32/spawn_cetsHMS.png", 39, 37)
end)

hook.Add("PopulatePropMenu", "PortalPack_Spawnlist", function()

	local contents = {

		-- Characters
		{
			type = "header",
			text = "Characters"
		},

		{
			type = "model",
			model = "models/props/cake/cake.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/player/chell.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/player/mel.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/portal_aspma.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props/turret_01.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props_bts/rocket_sentry.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props_bts/glados_body.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/gladdysdestruction/gladdysbody.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props/metal_box.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props/metal_box_2006.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props/metal_box_skull.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props/e3/metal_box_e3.mdl",
			wide = 128,
			tall = 128
		},
		{
			type = "model",
			model = "models/props/metal_box_gel.mdl",
			wide = 128,
			tall = 128
		},

		{
			type = "model",
			model = "models/props_bts/glados_ball_reference.mdl"
		},
		{
			type = "model",
			model = "models/test_animation/wheatley_crab.mdl"
		},
		{
			type = "model",
			model = "models/cores/para/core.mdl"
		},
		{
			type = "model",
			model = "models/npcs/hover_turret.mdl"
		},
		{
			type = "model",
			model = "models/npcs/beta_wheatley.mdl"
		},
		{
			type = "model",
			model = "models/npcs/beta_boss_cores.mdl"
		},
		{
			type = "model",
			model = "models/npcs/core_era_sphere.mdl"
		},
		{
			type = "model",
			model = "models/cores/e3wh/core.mdl"
		},


		-- Props
		{
			type = "header",
			text = "Props"
		},

		{
			type = "model",
			model = "models/props/switch001.mdl"
		},
		{
			type = "model",
			model = "models/props/switchskull.mdl"
		},
		{
			type = "model",
			model = "models/props/button_base_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/button_top_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/bed_body_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/bed_cover_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/box_dropper.mdl"
		},
		{
			type = "model",
			model = "models/props/box_dropper_cover.mdl"
		},
		{
			type = "model",
			model = "models/props/box_dropper_cover_broken.mdl"
		},
		{
			type = "model",
			model = "models/props/box_dropper_cover_broken_cover.mdl"
		},
		{
			type = "model",
			model = "models/props/clock.mdl"
		},
		{
			type = "model",
			model = "models/props/combine_ball_catcher.mdl"
		},
		{
			type = "model",
			model = "models/props/combine_ball_launcher.mdl"
		},
		{
			type = "model",
			model = "models/props/door_01_frame_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/door_01_frame_wide_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/door_01_rtdoor_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/door_01_lftdoor_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/door_02.mdl"
		},
		{
			type = "model",
			model = "models/props/futbol_dispenser.mdl"
		},
		{
			type = "model",
			model = "models/props/hospital_ivstand01.mdl"
		},
		{
			type = "model",
			model = "models/props/lift_platform.mdl"
		},
		{
			type = "model",
			model = "models/props/light_rail_corner.mdl"
		},
		{
			type = "model",
			model = "models/props/light_rail_endcap.mdl"
		},
		{
			type = "model",
			model = "models/props/light_rail_platform.mdl"
		},
		{
			type = "model",
			model = "models/props/light_rail_platform_02.mdl"
		},
		{
			type = "model",
			model = "models/props/light_rail_wall_emitter.mdl"
		},
		{
			type = "model",
			model = "models/props/pedestal_base_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/pedestal_center_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/portal_cleanser_1.mdl"
		},
		{
			type = "model",
			model = "models/props/radio_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/round_elevator_body.mdl"
		},
		{
			type = "model",
			model = "models/props/futbol.mdl"
		},
		{
			type = "model",
			model = "models/props/metal_box_2005.mdl"
		},
		{
			type = "model",
			model = "models/props/round_elevator_doors.mdl"
		},
		{
			type = "model",
			model = "models/props/security_camera.mdl"
		},
		{
			type = "model",
			model = "models/props/security_camera_prop_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/sphere.mdl"
		},
		{
			type = "model",
			model = "models/props/table_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/toilet_body_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/toilet_lid_reference.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set01/128_fuse_set01.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set02/128_fuse_set02.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set03/128_fuse_set03.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set04/128_fuse_set04.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set05/128_fuse_set05.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set06/128_fuse_set06.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set07/128_fuse_set07.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set08/128_fuse_set08.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set09/128_fuse_set09.mdl"
		},
		{
			type = "model",
			model = "models/props/128_fuse_set10/128_fuse_set10.mdl"
		},
		{
			type = "model",
			model = "models/props/autoportal_frame/autoportal_frame.mdl"
		},
		{
			type = "model",
			model = "models/props/bts_bed/bts_bed.mdl"
		},
		{
			type = "model",
			model = "models/props/claw/claw.mdl"
		},
		{
			type = "model",
			model = "models/props/claw/claw_body.mdl"
		},
		{
			type = "model",
			model = "models/props/claw/claw_pincer01.mdl"
		},
		{
			type = "model",
			model = "models/props/claw/claw_pincer02.mdl"
		},
		{
			type = "model",
			model = "models/props/elevator_caps/elevator_caps.mdl"
		},
		{
			type = "model",
			model = "models/props/elevatorshaft_wall/elevatorshaft_wall.mdl"
		},
		{
			type = "model",
			model = "models/props/food_can/food_can.mdl"
		},
		{
			type = "model",
			model = "models/props/food_can/food_can_open.mdl"
		},
		{
			type = "model",
			model = "models/props/glados_ceiling_light/glados_ceiling_light.mdl"
		},
		{
			type = "model",
			model = "models/props/glados_pillar/glados_pillar.mdl"
		},
		{
			type = "model",
			model = "models/props/kb_mouse/keyboard.mdl"
		},
		{
			type = "model",
			model = "models/props/kb_mouse/mouse.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_chair/lab_chair.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_desk01/lab_desk01.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_desk02/lab_desk02.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_desk03/lab_desk03.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_desk04/lab_desk04.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_desk05/lab_desk05.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_shelf/lab_shelf.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_shelf_small/lab_shelf_small.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_monitor_pose01/lab_monitor_pose01.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_monitor_pose01/lab_monitor_pose02.mdl"
		},
		{
			type = "model",
			model = "models/props/lab_monitor_pose01/lab_monitor_pose03.mdl"
		},
		{
			type = "model",
			model = "models/props/milk_carton/milk_carton.mdl"
		},
		{
			type = "model",
			model = "models/props/milk_carton/milk_carton_open.mdl"
		},
		{
			type = "model",
			model = "models/props/pc_case02/pc_case02.mdl"
		},
		{
			type = "model",
			model = "models/props/pc_case_open/pc_case_open.mdl"
		},
		{
			type = "model",
			model = "models/props/rot_door/rot_door_frame.mdl"
		},
		{
			type = "model",
			model = "models/props/saucepan/saucepan.mdl"
		},
		{
			type = "model",
			model = "models/props/server_wall/server_wall.mdl"
		},
		{
			type = "model",
			model = "models/props/sign_frame01/sign_frame01.mdl"
		},
		{
			type = "model",
			model = "models/props/sign_frame02/sign_frame02.mdl"
		},
		{
			type = "model",
			model = "models/props/speaker_system01/speaker_system01.mdl"
		},
		{
			type = "model",
			model = "models/props/speaker_system01/speaker_system02.mdl"
		},
		{
			type = "model",
			model = "models/props/water_bottle/water_bottle.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/betty_reference.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/bts_chair.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/bts_chair_static.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/bts_clipboard.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/bts_stool_static.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/bts_table_static.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/bts_turret.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/cage_light.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/fan01.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/fan01_small.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_aperturedoor.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_floorlight.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/lab_floorlight.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_platform_reference.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_bunker.mdl"
		},
		{
			type = "model",
			model = "models/props/glados_stairs.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/ladder_01.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/phone_body.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/phone_reciever.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/projector.mdl"
		},
		{
			type = "model",
			model = "models/props_facemovie/wet_floor_sign/wet_floor_sign.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_screenborder_curve.mdl"
		},
		{
			type = "model",
			model = "models/props_junk/garbage_coffeemug001a_forevergibs.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_disc_01.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_disc_02.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_disc_03.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_disc_04.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/glados_generator.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/generatormain.mdl"
		},


		-- Background Props
		{
			type = "header",
			text = "Background Props"
		},

		{
			type = "model",
			model = "models/props/gladosroom_shelves.mdl"
		},
		{
			type = "model",
			model = "models/props/shelf128/shelf128_group01.mdl"
		},
		{
			type = "model",
			model = "models/props/shelf128/shelf128_group02.mdl"
		},
		{
			type = "model",
			model = "models/props/shelf128/shelf128_group03.mdl"
		},
		{
			type = "model",
			model = "models/props/shelf128/shelf128.mdl"
		},
		{
			type = "model",
			model = "models/props/gladosroom_spherecenter.mdl"
		},
		{
			type = "model",
			model = "models/props/gladosroom_spheremid.mdl"
		},
		{
			type = "model",
			model = "models/props/vert_door/vert_door_frame.mdl"
		},
		{
			type = "model",
			model = "models/props/vert_door/vert_door_lower.mdl"
		},
		{
			type = "model",
			model = "models/props/vert_door/vert_door_upper.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_bend01/wall_pipes_bend01.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_bend01/wall_pipes_bend01_flipped.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_bend02/wall_pipes_bend02.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_bend03/wall_pipes_bend03.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_corner/wall_pipes_corner.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_horiz/wall_pipes_horiz.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_terminate01/wall_pipes_terminate01.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_tjunc01/wall_pipes_tjunc01.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_wave/wall_pipes_wave.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_wave/wall_pipes_wave_flipped.mdl"
		},
		{
			type = "model",
			model = "models/props/wall_pipes_corner02/wall_pipes_corner02.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/vertical_large_piston_base.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/vertical_small_piston_base.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/vertical_med_piston_base.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/horizontal_piston_base.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/vertical_small_piston_body.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/vertical_med_piston_body.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/horizontal_piston_body.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/mini_piston_inside.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/vertical_large_piston_body.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/mini_piston_body.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/clear_tube_90deg.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/clear_tube_broken.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/clear_tube_straight.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/clear_tube_tjoint.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/debris1.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/debris2.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/generatorpipes.mdl"
		},
		{
			type = "model",
			model = "models/props/rot_door/rot_door_hinges.mdl"
		},
		{
			type = "model",
			model = "models/props/geodome_exterior_3072_exo.mdl"
		},
		{
			type = "model",
			model = "models/props/geodome_exterior_destroyed.mdl"
		},
		{
			type = "model",
			model = "models/props/geodome_interior_destroyed.mdl"
		},
		{
			type = "model",
			model = "models/props/geodome_exo_support.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/metal_block.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/machinecoarserb2.mdl"
		},


		-- Weapons
		{
			type = "header",
			text = "Weapons"
		},

		{
			type = "model",
			model = "models/weapons/w_portalgun.mdl"
		},
		{
			type = "model",
			model = "models/weapons/aspgun_w.mdl"
		},
		{
			type = "model",
			model = "models/weapons/portal_lemon_w.mdl"
		},
		{
			type = "model",
			model = "models/props_bts/rocket.mdl"
		},


		-- Chamber Signs
		{
			type = "header",
			text = "Chamber Signs"
		},

		{
			type = "model",
			model = "models/props_animsigns/signage_num00.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num01.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num02.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num03.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num04.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num05.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num06.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num07.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num08.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num09.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num10.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num11.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num12.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num13.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num14.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num15.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num16.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num17.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num18.mdl",
			skin = 6
		},
		{
			type = "model",
			model = "models/props_animsigns/signage_num19.mdl",
			skin = 6
		},


		-- Gibs
		{
			type = "header",
			text = "Gibs"
		},

		{
			type = "model",
			model = "models/props/futbol_gib01.mdl"
		},
		{
			type = "model",
			model = "models/props/futbol_gib02.mdl"
		},
		{
			type = "model",
			model = "models/props/futbol_gib03.mdl"
		},
		{
			type = "model",
			model = "models/props/futbol_gib04.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/glados_junk_05_.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/glados_junk_01_.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/glados_junk_02_.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/glados_junk_03_.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/glados_junk_04_.mdl"
		},
		{
			type = "model",
			model = "models/gladdysdestruction/glados_junk_06_.mdl"
		}
	}

	spawnmenu.AddPropCategory("portal_pack", "Portal Pack", contents, "icon32/spawn_cetsPRT.png", 40, 37)
end)


hook.Add("PopulatePropMenu", "CETS_ResourcesMisc_Spawnlist", function()

	local contents = {
		{
			type = "header",
			text = "Effects"
		},

		{ type = "model", model = "models/de_shipped/shipped_sea.mdl" },
		{ type = "model", model = "models/de_shipped/shipped_sea2.mdl" },
		{ type = "model", model = "models/de_shipped/shipped_sea_plane.mdl" },
		{ type = "model", model = "models/de_shipped/shipped_sea_sway.mdl" },
		{ type = "model", model = "models/oceanic/rays.mdl" },
		{ type = "model", model = "models/oceanic/leviathan.mdl" },
		{ type = "model", model = "models/oceanic/fish.mdl" },
		{ type = "model", model = "models/oceanic/construct.mdl" },
		{ type = "model", model = "models/oceanic/clouds.mdl" },
		{ type = "model", model = "models/props_extra_effect/firefly.mdl" },
		{ type = "model", model = "models/props_extra_effect/fog.mdl" },
		{ type = "model", model = "models/props_extra_effect/rain1.mdl" },
		{ type = "model", model = "models/props_extra_effect/rain2.mdl" },
		{ type = "model", model = "models/props_cets/vol_light_fix.mdl" },
		{ type = "model", model = "models/props_cets/vol_light_small_fix.mdl" },
		{ type = "model", model = "models/props_cets/vol_light_spot_fix.mdl" },
		{ type = "model", model = "models/props_cets/vol_light_spot_small_fix.mdl" },
		{ type = "model", model = "models/props_cets/sohald_spike/vol_light/vol_light.mdl" },
		{ type = "model", model = "models/props_cets/sohald_spike/vol_light/vol_light_small.mdl" },
		{ type = "model", model = "models/props_cets/sohald_spike/vol_light/vol_light_spot.mdl" },
		{ type = "model", model = "models/props_cets/sohald_spike/vol_light/vol_light_spot_small.mdl" },
		{ type = "model", model = "models/props_cets/ground_fog.mdl" },
		{ type = "model", model = "models/props_cets/ground_fog_flat.mdl" },
		{ type = "model", model = "models/props_cets/wall_fog.mdl" },
		{ type = "model", model = "models/misc/cube2x6x1.mdl" },

		{
			type = "header",
			text = "Main Characters"
		},

		{ type = "model", model = "models/player/freeman.mdl" },

		{
			type = "header",
			text = "Props"
		},

		{ type = "model", model = "models/props_cets/monitor01c.mdl" },
		{ type = "model", model = "models/props_cets/monitor01c_shell.mdl" },
		{ type = "model", model = "models/props_cets/oscilloscope01.mdl" },
		{ type = "model", model = "models/props_lab/fusebox001a.mdl" },
		{ type = "model", model = "models/props_lab/hifisystem001a.mdl" },
		{ type = "model", model = "models/props_lab/hifisystem002a.mdl" },
		{ type = "model", model = "models/props_lab/hifituner001a.mdl" },
		{ type = "model", model = "models/props_lab/hifituner002a.mdl" },
		{ type = "model", model = "models/props_lab/hifituner003a.mdl" },
		{ type = "model", model = "models/props_lab/hifituner004a.mdl" },
		{ type = "model", model = "models/props_lab/hifituner005a.mdl" },
		{ type = "model", model = "models/props_lab/hifituner006a.mdl" },
		{ type = "model", model = "models/props_lab/labcomputer001a.mdl" },
		{ type = "model", model = "models/props_lab/labcomputer002a.mdl" },
		{ type = "model", model = "models/props_lab/labdrivestorage001a.mdl" },
		{ type = "model", model = "models/props_lab/labkeyboard001a.mdl" },
		{ type = "model", model = "models/props_lab/labmonitor001a.mdl" },
		{ type = "model", model = "models/props_lab/labmonitor002a.mdl" },
		{ type = "model", model = "models/props_lab/labmonitor002b.mdl" },
		{ type = "model", model = "models/props_lab/labmonitor004a.mdl" },
		{ type = "model", model = "models/props_lab/labmonitor005a.mdl" },
		{ type = "model", model = "models/props_lab/labmonitor006a.mdl" },
		{ type = "model", model = "models/props_lab/shelfcart001a.mdl" },
		{ type = "model", model = "models/props_canal/generator_panel01.mdl" },
		{ type = "model", model = "models/props_lab/smallmetalbox001a.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_controlpanel001a.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_controlpanel002a.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_phone001a.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_phone001b.mdl" },
		{ type = "model", model = "models/props_combine/breendesk2.mdl" },
		{ type = "model", model = "models/props_combine/breendesk3.mdl" },
		{ type = "model", model = "models/props_combine/breendesk4.mdl" },
		{ type = "model", model = "models/props_interiors/furniture_bed01a.mdl" },
		{ type = "model", model = "models/props_interiors/furniture_bed01b.mdl" },
		{ type = "model", model = "models/props_interiors/furniture_drawer01a.mdl" },
		{ type = "model", model = "models/props_interiors/furniture_drawer01b.mdl" },
		{ type = "model", model = "models/props_interiors/tv_stand.mdl" },
		{ type = "model", model = "models/props_quarantine/piano.mdl" },
		{ type = "model", model = "models/props_cets/dumpster_fixed.mdl" },
		{ type = "model", model = "models/jewel/jewel_l.mdl" },
		{ type = "model", model = "models/jewel/jewel_m.mdl" },
		{ type = "model", model = "models/jewel/jewel_s.mdl" },
		{ type = "model", model = "models/mallparking/box_stack.mdl" },
		{ type = "model", model = "models/mallparking/checkout.mdl" },
		{ type = "model", model = "models/mallparking/securitysystems.mdl" },
		{ type = "model", model = "models/mallparking/models/store_plastic_strip.mdl" },
		{ type = "model", model = "models/oceanic/boat_fishing01animated.mdl" },
		{ type = "model", model = "models/oceanic/handball.mdl" },
		{ type = "model", model = "models/oceanic/jaw.mdl" },
		{ type = "model", model = "models/oceanic/noahstatue.mdl" },
		{ type = "model", model = "models/oceanic/ribbone.mdl" },
		{ type = "model", model = "models/oceanic/ribbonesm.mdl" },
		{ type = "model", model = "models/oceanic/skull.mdl" },
		{ type = "model", model = "models/prop_cables/cable_floor_04.mdl" },
		{ type = "model", model = "models/prop_cables/cable_short_bundle_01.mdl" },
		{ type = "model", model = "models/props_c17/furnituredrawer001b.mdl" },
		{ type = "model", model = "models/props_c17/furnituredrawer001c.mdl" },
		{ type = "model", model = "models/props_c17/furnituremattress001b.mdl" },
		{ type = "model", model = "models/props_c17/furnituretable001b.mdl" },
		{ type = "model", model = "models/props_c17/furnituretoilet001a_seat.mdl" },
		{ type = "model", model = "models/props_c17/lockers001a_single.mdl" },
		{ type = "model", model = "models/props_c17/lockers001b_single.mdl" },
		{ type = "model", model = "models/props_canal/boxcar_door2.mdl" },
		{ type = "model", model = "models/props_cets/oildrum001_explosive.mdl" },
		{ type = "model", model = "models/props_cets/barrel_bent1.mdl" },
		{ type = "model", model = "models/props_cets/barrel_bent2.mdl" },
		{ type = "model", model = "models/props_cets/bathtub01_l4d1.mdl" },
		{ type = "model", model = "models/props_cets/beaker01a.mdl" },
		{ type = "model", model = "models/props_cets/beaker01b.mdl" },
		{ type = "model", model = "models/props_cets/bike_rack001.mdl" },
		{ type = "model", model = "models/props_cets/blastdoor001_left.mdl" },
		{ type = "model", model = "models/props_cets/blastdoor001_right.mdl" },
		{ type = "model", model = "models/props_cets/borealis_fusebox001.mdl" },
		{ type = "model", model = "models/props_cets/borealis_panel004.mdl" },
		{ type = "model", model = "models/props_cets/borealis_panel005a.mdl" },
		{ type = "model", model = "models/props_cets/borealis_panel005b.mdl" },
		{ type = "model", model = "models/props_cets/canister_propane02a.mdl" },
		{ type = "model", model = "models/props_cets/compressor01.mdl" },
		{ type = "model", model = "models/props_cets/consolebox02a.mdl" },
		{ type = "model", model = "models/props_cets/consolebox04a.mdl" },
		{ type = "model", model = "models/props_cets/construction_lift.mdl" },
		{ type = "model", model = "models/props_cets/dome001.mdl" },
		{ type = "model", model = "models/props_cets/dome001_bottom.mdl" },
		{ type = "model", model = "models/props_cets/dome002.mdl" },
		{ type = "model", model = "models/props_cets/engine_fan001.mdl" },
		{ type = "model", model = "models/props_cets/firepipe01_l4d1.mdl" },
		{ type = "model", model = "models/props_cets/firepipe02_l4d1.mdl" },
		{ type = "model", model = "models/props_cets/furniture_desk01_l4d2a.mdl" },
		{ type = "model", model = "models/props_cets/hmg1_mount_gun01.mdl" },
		{ type = "model", model = "models/props_cets/korespond_furnituredresser001a.mdl" },
		{ type = "model", model = "models/props_cets/lab_stool.mdl" },
		{ type = "model", model = "models/props_cets/labcupboard_tall01a.mdl" },
		{ type = "model", model = "models/props_cets/labcupboard_tall01a_door.mdl" },
		{ type = "model", model = "models/props_cets/lamppost01a.mdl" },
		{ type = "model", model = "models/props_cets/lamppost01e.mdl" },
		{ type = "model", model = "models/props_cets/luggage1.mdl" },
		{ type = "model", model = "models/props_cets/luggage2.mdl" },
		{ type = "model", model = "models/props_cets/luggage3.mdl" },
		{ type = "model", model = "models/props_cets/luggage4.mdl" },
		{ type = "model", model = "models/props_cets/luggage_pile1.mdl" },
		{ type = "model", model = "models/props_cets/mailbox01.mdl" },
		{ type = "model", model = "models/props_cets/mobiletable01.mdl" },
		{ type = "model", model = "models/props_cets/mobiletable01_static.mdl" },
		{ type = "model", model = "models/props_cets/news_paper_stand001.mdl" },
		{ type = "model", model = "models/props_cets/newspaper_dispensers.mdl" },
		{ type = "model", model = "models/props_cets/openable_controlroom_storagecloset001a.mdl" },
		{ type = "model", model = "models/props_cets/petridish01d.mdl" },
		{ type = "model", model = "models/props_cets/roller.mdl" },
		{ type = "model", model = "models/props_cets/roller_spikes.mdl" },
		{ type = "model", model = "models/props_cets/satellitedish01.mdl" },
		{ type = "model", model = "models/props_cets/sink01_dirty.mdl" },
		{ type = "model", model = "models/props_cets/solderingiron01a.mdl" },
		{ type = "model", model = "models/props_cets/storescale01a.mdl" },
		{ type = "model", model = "models/props_cets/substance_tray.mdl" },
		{ type = "model", model = "models/props_cets/table_cafeteria.mdl" },
		{ type = "model", model = "models/props_cets/table_console.mdl" },
		{ type = "model", model = "models/props_cets/table_motel.mdl" },
		{ type = "model", model = "models/props_cets/tank_cooling01a.mdl" },
		{ type = "model", model = "models/props_cets/toolbox.mdl" },
		{ type = "model", model = "models/props_cets/tracksteps01.mdl" },
		{ type = "model", model = "models/props_cets/trash_can001.mdl" },
		{ type = "model", model = "models/props_cets/tv_ceiling.mdl" },
		{ type = "model", model = "models/props_cets/unit_pwr.mdl" },
		{ type = "model", model = "models/props_cets/valve001.mdl" },
		{ type = "model", model = "models/props_cets/valvewheel001b.mdl" },
		{ type = "model", model = "models/props_cets/valvewheel002b.mdl" },
		{ type = "model", model = "models/props_cets/wire_spool_01.mdl" },
		{ type = "model", model = "models/props_cets/wire_spool_02.mdl" },
		{ type = "model", model = "models/props_cets_aliens/agruntpod.mdl" },
		{ type = "model", model = "models/props_cets_aliens/f1rocketengine.mdl" },
		{ type = "model", model = "models/props_equipment/firehosebox01.mdl" },
		{ type = "model", model = "models/props_equipment/snack_machine.mdl" },
		{ type = "model", model = "models/props_equipment/snack_machine_glass.mdl" },
		{ type = "model", model = "models/props_interiors/artefactoventana.mdl" },
		{ type = "model", model = "models/props_interiors/bancosdt.mdl" },
		{ type = "model", model = "models/props_interiors/bustosm.mdl" },
		{ type = "model", model = "models/props_interiors/pelotavoley.mdl" },
		{ type = "model", model = "models/props_interiors/redvoley.mdl" },
		{ type = "model", model = "models/props_interiors/ventanabar01a.mdl" },
		{ type = "model", model = "models/props_interiors/ventanabar02a.mdl" },
		{ type = "model", model = "models/props_interiors/ventanabar02b.mdl" },
		{ type = "model", model = "models/props_junk/wood_crate001b.mdl" },
		{ type = "model", model = "models/props_junk/wood_crate001a_half.mdl" },
		{ type = "model", model = "models/props_junk/wood_crate002a_half.mdl" },
		{ type = "model", model = "models/props_junk/wood_crate003a.mdl" },
		{ type = "model", model = "models/props_lab/cactus02a.mdl" },
		{ type = "model", model = "models/props_lab/clipboard002a.mdl" },
		{ type = "model", model = "models/props_lab/corkboard001_physics.mdl" },
		{ type = "model", model = "models/props_lab/corkboard002_physics.mdl" },
		{ type = "model", model = "models/props_lab/cornerunit2b.mdl" },
		{ type = "model", model = "models/props_lab/filedesk01a.mdl" },
		{ type = "model", model = "models/props_lab/labshelf001a.mdl" },
		{ type = "model", model = "models/props_lab/notepad001a.mdl" },
		{ type = "model", model = "models/props_lab/paperbin001a.mdl" },
		{ type = "model", model = "models/props_lab/papersheet001a.mdl" },
		{ type = "model", model = "models/props_lab/workspacetable001.mdl" },
		{ type = "model", model = "models/props_lab/workspacetable002.mdl" },
		{ type = "model", model = "models/props_lab/workspacetable003.mdl" },
		{ type = "model", model = "models/props_mall/cash_register.mdl" },
		{ type = "model", model = "models/props_street/electrical_box01.mdl" },
		{ type = "model", model = "models/props_street/electrical_box02.mdl" },
		{ type = "model", model = "models/props_unique/atm01.mdl" },
		{ type = "model", model = "models/props_unique/escalatortall.mdl" },
		{ type = "model", model = "models/props_unique/grocerystorechiller01.mdl" },
		{ type = "model", model = "models/props_unique/mopbucket01.mdl" },
		{ type = "model", model = "models/props_wasteland/cargo_containerdoor01a.mdl" },
		{ type = "model", model = "models/props_wasteland/cargo_containerdoor01b.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_drawer001a.mdl" },
		{ type = "model", model = "models/urban/cryo_sign.mdl" },
		{ type = "model", model = "models/urban/pillar1.mdl" },
		{ type = "model", model = "models/urban/urban_pipe.mdl" },
		{ type = "model", model = "models/urban/white_awning.mdl" },
		{ type = "model", model = "models/watch/watch.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_lever001a.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_microphone001a.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_storagecloset001a_base.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_storagecloset001a_door.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_switchbase001a.mdl" },
		{ type = "model", model = "models/props_wasteland/controlroom_switchbase002a.mdl" },
		{ type = "model", model = "models/props_wasteland/kitchen_counter002a.mdl" },
		{ type = "model", model = "models/props_wasteland/kitchen_counter002b.mdl" },
		{ type = "model", model = "models/props_wasteland/kitchen_counter002c.mdl" },
		{ type = "model", model = "models/props_wasteland/kitchen_counter002d.mdl" },
		{ type = "model", model = "models/props_wasteland/kitchen_counter002e.mdl" },
		{ type = "model", model = "models/props_wasteland/kitchen_counter002f.mdl" },
		{ type = "model", model = "models/props_wasteland/kitchen_stove003a.mdl" },
		{ type = "model", model = "models/props_wasteland/mounted_fencing001a.mdl" },
		{ type = "model", model = "models/props_wasteland/mounted_fencing001b.mdl" },
		{ type = "model", model = "models/props_wasteland/mounted_fencing002a.mdl" },
		{ type = "model", model = "models/props_wasteland/mounted_fencing002b.mdl" },
		{ type = "model", model = "models/props_wasteland/mounted_fencing003a.mdl" },
		{ type = "model", model = "models/props_wasteland/mounted_fencing003b.mdl" },
		{ type = "model", model = "models/props_wasteland/panel_monitor001a.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_securitydoor001a.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_securitydoorframe001a.mdl" },
		{ type = "model", model = "models/props_c17/furniturecouch001b.mdl" },
		{ type = "model", model = "models/props_c17/furniturecouch001c.mdl" },
		{ type = "model", model = "models/props_c17/furniturecouch001d.mdl" },
		{ type = "model", model = "models/props_c17/furniturecouch003a.mdl" },
		{ type = "model", model = "models/props_cets/chairlobby01.mdl" },
		{ type = "model", model = "models/props_cets/patio_chair2_white.mdl" },
		{ type = "model", model = "models/props_interiors/furniture_stool01a.mdl" },
		{ type = "model", model = "models/props_urban/plastic_chair001.mdl" },
		{ type = "model", model = "models/seats/armchair.mdl" },
		{ type = "model", model = "models/seats/barstool01.mdl" },
		{ type = "model", model = "models/seats/chair_office.mdl" },
		{ type = "model", model = "models/seats/chair_office01.mdl" },
		{ type = "model", model = "models/seats/chair_office02.mdl" },
		{ type = "model", model = "models/seats/chair_plastic01.mdl" },
		{ type = "model", model = "models/seats/chair_stool01a.mdl" },
		{ type = "model", model = "models/nova/chair_wood02.mdl" },
		{ type = "model", model = "models/seats/chairantique.mdl" },
		{ type = "model", model = "models/seats/controlroom_chair001a.mdl" },
		{ type = "model", model = "models/seats/furniture_chair01a.mdl" },
		{ type = "model", model = "models/seats/furniture_chair03a.mdl" },
		{ type = "model", model = "models/seats/furniture_couch02a.mdl" },
		{ type = "model", model = "models/seats/furniturearmchair001a.mdl" },
		{ type = "model", model = "models/seats/furniturecouch001a.mdl" },
		{ type = "model", model = "models/seats/furnituretoilet001a.mdl" },
		{ type = "model", model = "models/seats/patio_chair.mdl" },
		{ type = "model", model = "models/seats/patio_chair2.mdl" },
		{ type = "model", model = "models/seats/sofa_chair.mdl" },
		{ type = "model", model = "models/props_c17/chair01a.mdl" },
		{ type = "model", model = "models/props_c17/chair_kleiner03a_seat.mdl" },
		{ type = "model", model = "models/props_c17/chair_stool01a_seat.mdl" },
		{ type = "model", model = "models/seats/traincar_seats001.mdl" },
		{ type = "model", model = "models/props_cets/no_smoke.mdl" },
		{ type = "model", model = "models/props_cets/elev.mdl" },
		{ type = "model", model = "models/props_cets/military_sign01.mdl" },
		{ type = "model", model = "models/props_cets/military_big_sign01.mdl" },
		{ type = "model", model = "models/props_cets/sign6.mdl" },
		{ type = "model", model = "models/props_cets/passport.mdl" },
		{ type = "model", model = "models/props_cets/highvolt.mdl" },
		{ type = "model", model = "models/props_cets/highvolt2.mdl" },
		{ type = "model", model = "models/props_cets/highvolt3.mdl" },
		{ type = "model", model = "models/props_cets/restricted.mdl" },
		{ type = "model", model = "models/props_cets/sign1.mdl" },
		{ type = "model", model = "models/props_cets/highsec_facility.mdl" },
		{ type = "model", model = "models/props_cets/sign2.mdl" },
		{ type = "model", model = "models/props_cets/sign3.mdl" },
		{ type = "model", model = "models/props_cets/alarm.mdl" },
		{ type = "model", model = "models/props_cets/authorized.mdl" },
		{ type = "model", model = "models/props_cets/bmrf.mdl" },
		{ type = "model", model = "models/props_cets/bmrf_map.mdl" },
		{ type = "model", model = "models/props_cets/coolant.mdl" },
		{ type = "model", model = "models/props_cets/danger.mdl" },
		{ type = "model", model = "models/props_cets/sign4.mdl" },
		{ type = "model", model = "models/props_cets/sign5.mdl" },
		{ type = "model", model = "models/props_cets/sign7.mdl" },
		{ type = "model", model = "models/props_cets/sign8.mdl" },
		{ type = "model", model = "models/props_wasteland/cargo_container01.mdl" },
		{ type = "model", model = "models/props_wasteland/cargo_container01b.mdl" },
		{ type = "model", model = "models/props_wasteland/cargo_container01d.mdl" },
		{ type = "model", model = "models/props_cets/triage_tent.mdl" },

		{
			type = "header",
			text = "Lightning"
		},

		{ type = "model", model = "models/props_cets/stick.mdl" },
		{ type = "model", model = "models/props_cets/lantern.mdl" },
		{ type = "model", model = "models/props_cets/light01a_on.mdl" },
		{ type = "model", model = "models/props_cets/light_lightcage01_on.mdl" },
		{ type = "model", model = "models/props_cets/light_lightshade01_on.mdl" },
		{ type = "model", model = "models/props_interiors/lamparahall.mdl" },
		{ type = "model", model = "models/props_lab/desklamp02.mdl" },
		{ type = "model", model = "models/props_lab/desklamp03.mdl" },
		{ type = "model", model = "models/props/hl2_knees.mdl" },

		{
			type = "header",
			text = "Combine Props"
		},

		{ type = "model", model = "models/hl2_cmb_vault.mdl" },
		{ type = "model", model = "models/props_combine/breenwindow.mdl" },
		{ type = "model", model = "models/props_combine/bunker_gun01_nogun.mdl" },
		{ type = "model", model = "models/props_combine/cmb-computer-main.mdl" },
		{ type = "model", model = "models/props_combine/combine_ball_gen.mdl" },
		{ type = "model", model = "models/props_combine/combine_ball_launcher.mdl" },
		{ type = "model", model = "models/props_combine/combine_ceiling_unit.mdl" },
		{ type = "model", model = "models/props_combine/combine_fence_bridge.mdl" },
		{ type = "model", model = "models/props_combine/combine_fence_bridge_indicators.mdl" },
		{ type = "model", model = "models/props_combine/combine_interface_modular.mdl" },
		{ type = "model", model = "models/props_combine/combine_smallmonitor001.mdl" },
		{ type = "model", model = "models/props_cets/airvent01.mdl" },
		{ type = "model", model = "models/props_cets/pistons01.mdl" },
		{ type = "model", model = "models/props_combine/combine_tank_bio01a.mdl" },
		{ type = "model", model = "models/props_combine/combine_tank_energy01a.mdl" },
		{ type = "model", model = "models/props_combine/combine_tank_resin01a.mdl" },
		{ type = "model", model = "models/props_combine/combine_transformer01.mdl" },
		{ type = "model", model = "models/props_combine/combinebutton02.mdl" },
		{ type = "model", model = "models/props_quarantine/barrel_stirrer.mdl" },
		{ type = "model", model = "models/props_quarantine/bluebarrel002.mdl" },
		{ type = "model", model = "models/props_quarantine/bodybag_01.mdl" },
		{ type = "model", model = "models/props_quarantine/combine_fence01a.mdl" },
		{ type = "model", model = "models/props_quarantine/combine_fence01b.mdl" },
		{ type = "model", model = "models/props_quarantine/foam_tank.mdl" },
		{ type = "model", model = "models/props_quarantine/hazard_bucket.mdl" },
		{ type = "model", model = "models/props_quarantine/hazard_crate_full.mdl" },
		{ type = "model", model = "models/props_quarantine/hazard_crate_locked.mdl" },
		{ type = "model", model = "models/props_quarantine/hazard_crate_open.mdl" },
		{ type = "model", model = "models/props_cets/combine_gate.mdl" },
		{ type = "model", model = "models/props_cets/dave/combine_crafting_station_2.mdl" },
		{ type = "model", model = "models/osaka_con/terminal.mdl" },

		{
			type = "header",
			text = "Dead Guys"
		},

		{ type = "model", model = "models/combine_soldier_corpse1.mdl" },
		{ type = "model", model = "models/combine_soldier_corpse2.mdl" },
		{ type = "model", model = "models/corpses/cit_corpse01.mdl" },
		{ type = "model", model = "models/corpses/cit_corpse02.mdl" },
		{ type = "model", model = "models/corpses/cit_corpse03.mdl" },
		{ type = "model", model = "models/corpses/cit_corpse04.mdl" },
		{ type = "model", model = "models/corpses/cit_corpse05.mdl" },
		{ type = "model", model = "models/corpses/cit_corpse06.mdl" },
		{ type = "model", model = "models/corpses/cit_corpse07.mdl" },

		{
			type = "header",
			text = "Items & Pickups"
		},

		{ type = "model", model = "models/weapons/w_hl2_longjump.mdl" },
		{ type = "model", model = "models/weapons/w_packatb.mdl" },
		{ type = "model", model = "models/weapons/w_packatc.mdl" },
		{ type = "model", model = "models/weapons/w_packate.mdl" },
		{ type = "model", model = "models/weapons/w_packati.mdl" },
		{ type = "model", model = "models/weapons/w_packatl.mdl" },
		{ type = "model", model = "models/weapons/w_packatm.mdl" },
		{ type = "model", model = "models/weapons/w_packatp.mdl" },
		{ type = "model", model = "models/props_cets/ammo_stack.mdl" },
		{ type = "model", model = "models/props_cets/coffeeammo.mdl" },
		{ type = "model", model = "models/buggy_ammobox.mdl" },
		{ type = "model", model = "models/items/cets_nvg.mdl" },
		{ type = "model", model = "models/items/classic_misc_consume.mdl" },
		{ type = "model", model = "models/items/hevsuit.mdl" },

		{
			type = "header",
			text = "Weapons"
		},

		{ type = "model", model = "models/weapons/w_mach_m60.mdl" },
		{ type = "model", model = "models/weapons/emplacement_mach_m249para.mdl" },

		{
			type = "header",
			text = "Vehicles"
		},

		{ type = "model", model = "models/props_vehicles/car001c.mdl" },
		{ type = "model", model = "models/props_vehicles/car001d.mdl" },
		{ type = "model", model = "models/props_vehicles/car002a_base.mdl" },
		{ type = "model", model = "models/props_vehicles/car002b_2_physics.mdl" },
		{ type = "model", model = "models/props_vehicles/car002c.mdl" },
		{ type = "model", model = "models/props_vehicles/car002d.mdl" },
		{ type = "model", model = "models/props_vehicles/car003c.mdl" },
		{ type = "model", model = "models/props_vehicles/car01a.mdl" },
		{ type = "model", model = "models/props_vehicles/car01b.mdl" },
		{ type = "model", model = "models/props_vehicles/car02a.mdl" },
		{ type = "model", model = "models/props_vehicles/car02b.mdl" },
		{ type = "model", model = "models/props_vehicles/car03a.mdl" },
		{ type = "model", model = "models/props_vehicles/car03b.mdl" },
		{ type = "model", model = "models/props_vehicles/car_couch.mdl" },
		{ type = "model", model = "models/props_vehicles/car_mini01.mdl" },
		{ type = "model", model = "models/props_vehicles/car_mini02.mdl" },
		{ type = "model", model = "models/props_vehicles/car_mini03.mdl" },
		{ type = "model", model = "models/props_vehicles/trailer001b.mdl" },
		{ type = "model", model = "models/props_vehicles/truck002b.mdl" },
		{ type = "model", model = "models/props_vehicles/truck003b.mdl" },
		{ type = "model", model = "models/props_vehicles/van001b.mdl" },
		{ type = "model", model = "models/vehicles/brute.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_airport_baggage_tractor.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_airport_fuel_truck.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_ambulance_skin0.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_army_truck.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_cement_truck01.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_css_car.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_css_forklift.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_css_truck.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_css_truck_closed.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_css_utility_truck.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_css_van_militia.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_front_loader01.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_car001a_hatchback_skin0.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_car002a.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_car003a.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_car004a.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_car005a.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_digger.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_forklift_ep2.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_jetski.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_motorbike_01.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_motorbike_02.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_truck001c_01.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_truck002a_cab.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_truck003a_01.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_van001a_01.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_van001a_01_nodoor.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hl2_vehicle_van.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_hmmwv.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_humvee.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_news_van.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_police_car_lights_on.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_suv_2001_black_mesa.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_taxi_cab.mdl" },
		{ type = "model", model = "models/misc_vehicles/boxtruck.mdl" },
		{ type = "model", model = "models/postapoc_vehicles/econoline1.mdl" },
		{ type = "model", model = "models/postapoc_vehicles/econoline2.mdl" },
		{ type = "model", model = "models/props/betabus.mdl" },
		{ type = "model", model = "models/props/betabus2.mdl" },
		{ type = "model", model = "models/props/brute_destroyed.mdl" },
		{ type = "model", model = "models/props_cets/ambulance.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_tractor01.mdl" },
		{ type = "model", model = "models/vehicles/CETS/cets_van_militia.mdl" },
		{ type = "model", model = "models/vehicles/CETS/lunar_rover.mdl" },
		{ type = "model", model = "models/props_vehicles/car004c.mdl" },
		{ type = "model", model = "models/props_vehicles/car005a_base.mdl" },
		{ type = "model", model = "models/props_cets/tram001.mdl" },
		{ type = "model", model = "models/props_cets/truck001.mdl" },
		{ type = "model", model = "models/props_cets/truck01.mdl" },
		{ type = "model", model = "models/props_cets/inbound_tram.mdl" },
		{ type = "model", model = "models/props_cets/oar_awesome_tram.mdl" },
		{ type = "model", model = "models/props_cets/oar_tram.mdl" },

		{
			type = "header",
			text = "Wheels & Bits"
		},

		{ type = "model", model = "models/props_c17/engine_boxer.mdl" },
		{ type = "model", model = "models/props_c17/engine_i4.mdl" },
		{ type = "model", model = "models/props_c17/engine_i6.mdl" },
		{ type = "model", model = "models/props_cets/inbound_tram_door.mdl" },
		{ type = "model", model = "models/props_vehicles/car001a_hatchback_bonnet.mdl" },
		{ type = "model", model = "models/props_vehicles/car001a_hatchback_couch.mdl" },
		{ type = "model", model = "models/props_vehicles/car001a_hatchback_roof.mdl" },
		{ type = "model", model = "models/props_vehicles/car001a_hatchback_seat.mdl" },
		{ type = "model", model = "models/props_vehicles/car002a_ldoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car002a_rdoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car003a_hatch.mdl" },
		{ type = "model", model = "models/props_vehicles/car003a_ldoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car003a_rdoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car004a_ldoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car004a_rdoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car005a_ldoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car005a_rdoor.mdl" },
		{ type = "model", model = "models/props_vehicles/car005a_seat.mdl" },
		{ type = "model", model = "models/props_vehicles/carparts_door01b.mdl" },
		{ type = "model", model = "models/props_vehicles/carparts_seat01a.mdl" },
		{ type = "model", model = "models/props_vehicles/carparts_tire01b.mdl" },
		{ type = "model", model = "models/props_vehicles/carparts_tire01c.mdl" },
		{ type = "model", model = "models/props_vehicles/f16.mdl" },
		{ type = "model", model = "models/props_vehicles/f16_bw.mdl" },
		{ type = "model", model = "models/props_vehicles/f16_fw.mdl" },
		{ type = "model", model = "models/props_vehicles/generatortrailer01_exhaust.mdl" },
		{ type = "model", model = "models/seats/airboat_seat.mdl" },
		{ type = "model", model = "models/seats/seat001a_hatchback.mdl" },
		{ type = "model", model = "models/seats/seat_truck001a.mdl" },
		{ type = "model", model = "models/airboat_engine.mdl" },
		{ type = "model", model = "models/airboat_pontoon.mdl" },
		{ type = "model", model = "models/buggy_base.mdl" },
		{ type = "model", model = "models/buggy_front.mdl" },
		{ type = "model", model = "models/buggy_front_wheel.mdl" },
		{ type = "model", model = "models/buggy_rear_wheel.mdl" },

		{
			type = "header",
			text = "Debris"
		},

		{ type = "model", model = "models/props_wasteland/prison_brokenwall001a.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_brokenwall001b.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_brokenwall001c.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_wallpile001a.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_wallpile001b.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_wallpile001c.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_wallpile002b.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_wallpile002c.mdl" },
		{ type = "model", model = "models/props_wasteland/prison_wallpile002d.mdl" },

		{
			type = "header",
			text = "Junk"
		},

		{ type = "model", model = "models/apple.mdl" },
		{ type = "model", model = "models/cabbage.mdl" },
		{ type = "model", model = "models/carrot.mdl" },
		{ type = "model", model = "models/hext_candy_chocolate.mdl" },
		{ type = "model", model = "models/pear.mdl" },
		{ type = "model", model = "models/pineapple.mdl" },
		{ type = "model", model = "models/pound_cheese.mdl" },
		{ type = "model", model = "models/props_junk/cassettetape001a.mdl" },
		{ type = "model", model = "models/props_junk/garbage_newspaper001b.mdl" },
		{ type = "model", model = "models/props_cets/w_garb_beerbottle3.mdl" },
		{ type = "model", model = "models/props_cets/w_garb_papercup.mdl" },
		{ type = "model", model = "models/props_cets/w_garb_popcan.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticbottle003a_6pack.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticbox001a.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticbox001b.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticbox002a.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticbox002b.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticcan001a.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticcup001a.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticcup002a.mdl" },
		{ type = "model", model = "models/props_junk/garbage_plasticsyringe001a.mdl" },
		{ type = "model", model = "models/props_junk/garbage_trash.mdl" },
		{ type = "model", model = "models/props_cets/trashcluster02a.mdl" },
		{ type = "model", model = "models/props_junk/garbagebig001a.mdl" },
		{ type = "model", model = "models/props_junk/garbagebig001b.mdl" },
		{ type = "model", model = "models/props_junk/popcan02a.mdl" },
		{ type = "model", model = "models/props_junk/soda_box001a.mdl" },
		{ type = "model", model = "models/props_junk/soda_box001a_open.mdl" },
		{ type = "model", model = "models/props_junk/spraycan01a.mdl" },
		{ type = "model", model = "models/eggs/bullsquid_egg.mdl" },
		{ type = "model", model = "models/props_junk/pushcart02a.mdl" },
		{ type = "model", model = "models/props_junk/pushcart03a.mdl" },
		{ type = "model", model = "models/props_junk/pushcart04a.mdl" },
		{ type = "model", model = "models/props_junk/pushcart05a.mdl" },
		{ type = "model", model = "models/donald/props_junk/pushcart02a.mdl" },
		{ type = "model", model = "models/donald/props_junk/pushcart03a.mdl" },
		{ type = "model", model = "models/donald/props_junk/pushcart04a.mdl" },
		{ type = "model", model = "models/donald/props_junk/pushcart05a.mdl" },

		{
			type = "header",
			text = "Foliage"
		},

		{ type = "model", model = "models/cod4/dead_pine_lg.mdl" },
		{ type = "model", model = "models/cod4/dead_pine_med.mdl" },
		{ type = "model", model = "models/cod4/dead_pine_sm.mdl" },
		{ type = "model", model = "models/cod4/dead_pine_xl.mdl" },
		{ type = "model", model = "models/cod4/desertbushy_brown.mdl" },
		{ type = "model", model = "models/cod4/desertpalm.mdl" },
		{ type = "model", model = "models/cod4/desertpalm2.mdl" },
		{ type = "model", model = "models/cod4/desertshrub.mdl" },
		{ type = "model", model = "models/cod4/desertshrub2.mdl" },
		{ type = "model", model = "models/cod4/destroyed1.mdl" },
		{ type = "model", model = "models/cod4/destroyed2.mdl" },
		{ type = "model", model = "models/cod4/lightgrass.mdl" },
		{ type = "model", model = "models/cod4/red_pine_lg.mdl" },
		{ type = "model", model = "models/cod4/red_pine_sm.mdl" },
		{ type = "model", model = "models/cod4/red_pine_trunk_lg.mdl" },
		{ type = "model", model = "models/cod4/red_pine_trunk_med.mdl" },
		{ type = "model", model = "models/cod4/red_pine_trunk_sm.mdl" },
		{ type = "model", model = "models/cod4/red_pine_trunk_xl.mdl" },
		{ type = "model", model = "models/cod4/red_pine_xl.mdl" },
		{ type = "model", model = "models/cod4/red_pine_xxl.mdl" },
		{ type = "model", model = "models/cod4/riverreeds.mdl" },
		{ type = "model", model = "models/cod4/riverreeds_cattails.mdl" },
		{ type = "model", model = "models/cod4/riverreeds_cattails_2.mdl" },
		{ type = "model", model = "models/cod4/tree_oak_lg.mdl" },
		{ type = "model", model = "models/cod4/tree_oak_med.mdl" },
		{ type = "model", model = "models/cod4/tree_oak_sm.mdl" },
		{ type = "model", model = "models/cod4/tree_oak_xl.mdl" },
		{ type = "model", model = "models/oceanic/bloodkelp01.mdl" },
		{ type = "model", model = "models/oceanic/kelp01.mdl" },
		{ type = "model", model = "models/oceanic/kelp02.mdl" },
		{ type = "model", model = "models/oceanic/seagrass01.mdl" },
		{ type = "model", model = "models/oceanic/tubecoral.mdl" },
		{ type = "model", model = "models/props_cets_aliens/ferns02_cluster.mdl" },
		{ type = "model", model = "models/props_cets_aliens/plant1a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/plant1c.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tubulars_cluster_a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tubulars_cluster_b.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tubulars_cluster_c.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tubulars_cluster_d.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tubulars_single_a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tubulars_single_b.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tubulars_single_c.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_antlion_cluster001.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_antlion_cluster002.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_antlion_cluster003.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_headcrab_cluster001.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_headcrab_cluster002.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_headcrab_cluster003.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_coralear01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_coralear03.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_coralear04.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenflower_cluster3.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenflower_single_a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenflower_single_b.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jump_pad.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jump_pad_mini_large.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jump_pad_mini_small.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jump_pad_mini_medium.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pod_structure002_burst.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_vort_plant.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_plant2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_plant3.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_rot2_roots.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_shrub_a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_shrub_b.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_small_mold_cluster_1.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_tendril_01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_tendril_03.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_v2_danglies_floories.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_vines_a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_vines_b.mdl" },
		{ type = "model", model = "models/props_foliage2/grass-wasteland02.mdl" },
		{ type = "model", model = "models/props_foliage2/grass01.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_0asis.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_golf1.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_golf2.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_wasteland1.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_wasteland3.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_wasteland4.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_wasteland5.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_wasteland6.mdl" },
		{ type = "model", model = "models/props_foliage2/grass_wasteland7.mdl" },
		{ type = "model", model = "models/props_foliage2/greengrass1.mdl" },
		{ type = "model", model = "models/props_foliage2/greengrass2.mdl" },
		{ type = "model", model = "models/props_foliage2/greengrass3.mdl" },
		{ type = "model", model = "models/props_foliage3/colourmix_field.mdl" },
		{ type = "model", model = "models/props_foliage3/greenfield.mdl" },
		{ type = "model", model = "models/props_foliage3/greenyellow_field.mdl" },
		{ type = "model", model = "models/props_foliage3/red_field.mdl" },
		{ type = "model", model = "models/props_foliage3/whiskers_field.mdl" },
		{ type = "model", model = "models/props_foliage3/yellowfield.mdl" },
		{ type = "model", model = "models/props_foliage4/blood_root.mdl" },
		{ type = "model", model = "models/props_foliage4/ferns.mdl" },
		{ type = "model", model = "models/props_foliage4/fruit_plant.mdl" },
		{ type = "model", model = "models/props_foliage4/red_plant.mdl" },
		{ type = "model", model = "models/props_foliage4/root_plant.mdl" },
		{ type = "model", model = "models/props_foliage4/stalk_plant.mdl" },
		{ type = "model", model = "models/props_foliage4/sun_plant.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_1.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_10.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_16.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_17.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_18.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_19.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_2.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_20.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_3.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_4.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_5.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_6.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_7.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_8.mdl" },
		{ type = "model", model = "models/props_plants_extras/plant_9.mdl" },
		{ type = "model", model = "models/oceanic/fancoral.mdl" },
		{ type = "model", model = "models/props_cets/sea_bush1.mdl" },
		{ type = "model", model = "models/props_cets/sea_bush1_small.mdl" },
		{ type = "model", model = "models/props_cets/sea_plant2.mdl" },
		{ type = "model", model = "models/props_cets/mushroom_group.mdl" },
		{ type = "model", model = "models/props_cets/mushroom_medium.mdl" },
		{ type = "model", model = "models/props_cets/mushroom_small.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_bush1.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_bush1_small.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_hair.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_hair_medium.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_hair_small.mdl" },
		{ type = "model", model = "models/props_cets_aliens/root_02.mdl" },
		{ type = "model", model = "models/props_cets_aliens/root_03.mdl" },
		{ type = "model", model = "models/props_cets_aliens/root_04.mdl" },
		{ type = "model", model = "models/props_cets_aliens/root_05.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jumppad_root_big1.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jumppad_root_big2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jumppad_root_med.mdl" },
		{ type = "model", model = "models/props_cets_aliens/jumppad_root_thin.mdl" },
		{ type = "model", model = "models/props_cets_aliens/root_01.mdl" },

		{
			type = "header",
			text = "Rocks"
		},

		{ type = "model", model = "models/props_cets/cets_planet.mdl" },
		{ type = "model", model = "models/props_cets_aliens/alien_light.mdl" },
		{ type = "model", model = "models/props_cets_aliens/crystal.mdl" },
		{ type = "model", model = "models/props_cets_aliens/crystal1_rotate.mdl" },
		{ type = "model", model = "models/props_cets_aliens/crystal_purestsample.mdl" },
		{ type = "model", model = "models/props_cets_aliens/gib_agruntpod_base.mdl" },
		{ type = "model", model = "models/props_cets_aliens/gib_agruntpod_strut01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/gib_agruntpod_top.mdl" },
		{ type = "model", model = "models/props_cets_aliens/healing_shower.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock02.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock03.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock04.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock05.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock06.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock07.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rock08.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rotating_plat.mdl" },
		{ type = "model", model = "models/props_cets_aliens/rotating_tele.mdl" },
		{ type = "model", model = "models/props_cets_aliens/sky_islands1.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tele_conctere.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tele_nih_room.mdl" },
		{ type = "model", model = "models/props_cets_aliens/tele_nih_room_a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/vort2_elev2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/vort_elev.mdl" },
		{ type = "model", model = "models/props_cets_aliens/vort_mechanism.mdl" },
		{ type = "model", model = "models/props_cets_aliens/vort_mechanism_claw.mdl" },
		{ type = "model", model = "models/props_cets_aliens/vort_mechanism_claw2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_healingpool.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_healingpool_01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_healingpool_02.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_healingpool_03.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_healingpool_full.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_healingpool_refract.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_healingpool_refract_origin.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_op.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_op2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_op3.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar02.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar03.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar_broken01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar_broken02.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar_broken03.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar_broken04.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar_p1.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar_p2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_pillar_small01.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_stalactite_01_large.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_stalactite_01_medium.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_stalactite_02_large.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_stalactite_02_medium.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_stalactite_cluster_large.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xen_stalactite_cluster_large_2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xeno_island1.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xeno_island2.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenrock_01a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenrock_01b.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenrock_02b.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenrock_02c.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenrock_03a.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenrock_fl_02.mdl" },
		{ type = "model", model = "models/props_cets_aliens/xenrock_fl_01.mdl" }
	}

	spawnmenu.AddPropCategory("resources_misc", "Resources & Misc.", contents, "icon32/spawn_cetsALL.png", 46, 37)
end)