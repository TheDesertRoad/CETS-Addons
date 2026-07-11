//Doc's vehicles // Modified by TheDesertRoad
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("JeepGunToggle")
	util.AddNetworkString("KillAnnouncer_Message")
	util.AddNetworkString("KillAnnouncer_FirstBlood")

	local AllowedModels = {
		["models/buggy.mdl"] = true,
	}

	net.Receive("JeepGunToggle", function(_, ply)

	local tr = ply:GetEyeTrace()
	local jeep = tr.Entity

	if not IsValid(jeep) then return end
	if GetConVar("vehicle_weapon_strip"):GetInt() == 0 then return end
	if jeep:GetClass() ~= "prop_vehicle_jeep" then return end

	if not AllowedModels[string.lower(jeep:GetModel())] then
		return
	end

	local bodygroup = jeep:GetBodygroup(1)

	if bodygroup == 1 then
		jeep:SetBodygroup(1, 0)
		jeep:SetKeyValue("EnableGun", "0")

		if not ply:HasWeapon("weapon_vj_cets_tau") then
			jeep:EmitSound("vehicles/cets/weapon_pick.wav", 90, 100)
			local wep = ply:Give("weapon_vj_cets_tau")

			timer.Simple(0, function()

			if not IsValid(ply) then return end
			if not IsValid(wep) then return end

			local primary = wep:GetPrimaryAmmoType()
			end)
		end

	elseif bodygroup == 0 and ply:HasWeapon("weapon_vj_cets_tau") then
		jeep:SetBodygroup(1, 1)
		jeep:SetKeyValue("EnableGun", "1")
		jeep:EmitSound("vehicles/cets/weapon_stay.wav", 90, 100)
		ply:StripWeapon("weapon_vj_cets_tau")

		end
	end)

	local KillstreakSounds = {
		[2] = {
			"friends/ut_announcements/doublekill.wav",
		},

		[3] = {
			"friends/ut_announcements/triplekill.wav",
		},

		[4] = {
			"friends/ut_announcements/play.wav",
		},

		[5] = {
			"friends/ut_announcements/monsterkill.wav",
		},

		[6] = {
			"friends/ut_announcements/rampage.wav",
		},

		[7] = {
			"friends/ut_announcements/killingspree.wav",
		},	

		[8] = {
			"friends/ut_announcements/dominating.wav",
		},	

		[9] = {
			"friends/ut_announcements/impressive.wav",
		},	

		[10] = {
			"friends/ut_announcements/unstoppable.wav",
		},	

		[11] = {
			"friends/ut_announcements/outstanding.wav",
		},	

		[12] = {
			"friends/ut_announcements/megakill.wav",
		},	

		[13] = {
			"friends/ut_announcements/ultrakill.wav",
		},

		[14] = {
			"friends/ut_announcements/eagleeye.wav",
		},	

		[15] = {
			"friends/ut_announcements/ownage.wav",
		},	

		[16] = {
			"friends/ut_announcements/comboking.wav",
		},	

		[17] = {
			"friends/ut_announcements/maniac.wav",
		},	

		[18] = {
			"friends/ut_announcements/ludicrouskill.wav",
		},	

		[19] = {
			"friends/ut_announcements/bullseye.wav",
		},	

		[20] = {
			"friends/ut_announcements/excellent.wav",
		},

		[21] = {
			"friends/ut_announcements/pancake.wav",
		},
	
		[22] = {
			"friends/ut_announcements/headhunter.wav",
		},

		[23] = {
			"friends/ut_announcements/unreal.wav",
		},

		[24] = {
			"friends/ut_announcements/assassin.wav",
		},

		[25] = {
			"friends/ut_announcements/whickedsick.wav",
		},

		[26] = {
			"friends/ut_announcements/massacre.wav",
		},

		[27] = {
			"friends/ut_announcements/killingmachine.wav",
		},

		[28] = {
			"friends/ut_announcements/monsterkill.wav",
		},

		[29] = {
			"friends/ut_announcements/holyshit.wav",
		},	

		[30] = {
			"friends/ut_announcements/godlike.wav",
		},
	}

	hook.Add("PlayerInitialSpawn", "KillAnnouncer_Init", function(ply)
		ply.Killstreak = 0
		ply.FirstKillPlayed = false
	end)

	local function GiveKill(attacker)
		if GetConVar("sv_cets_kill_announcer"):GetInt() == 0 then return end
		if not IsValid(attacker) or not attacker:IsPlayer() then return end

		if not attacker.FirstKillPlayed then
			attacker.FirstKillPlayed = true
			local snd = "friends/ut_announcements/firstblood.wav"

			attacker:EmitSound(snd, 75, 100)

			net.Start("KillAnnouncer_FirstBlood")
			net.WriteString(snd)
			net.Send(attacker)
		end

		attacker.Killstreak = (attacker.Killstreak or 0) + 1

		local tbl = KillstreakSounds[attacker.Killstreak]

		if tbl then
			local snd = table.Random(tbl)
			attacker:EmitSound(table.Random(tbl), 75, 100)

			if GetConVar("sv_cets_kill_announcer_text"):GetInt() == 1 then
				net.Start("KillAnnouncer_Message")
				net.WriteUInt(attacker.Killstreak, 8)
				net.WriteString(snd)
				net.Send(attacker)
			else
			
			end
		end
	end

	hook.Add("PlayerDeath", "KillAnnouncer_PlayerDeath", function(victim, inflictor, attacker)
		if IsValid(victim) then
			victim.Killstreak = 0
		end

		if IsValid(attacker) and attacker:IsPlayer() and attacker ~= victim then
			GiveKill(attacker)
		end
	end)

	hook.Add("OnNPCKilled", "KillAnnouncer_NPCKilled", function(npc, attacker)
		if GetConVar("sv_cets_kill_announce_npc"):GetInt() == 0 then return end

		GiveKill(attacker)
	end)

	hook.Add("PlayerInitialSpawn", "JoinSound", function(ply)
		if not IsValid(ply) then return end
		if GetConVar("sv_cets_friends_join_sound"):GetInt() == 0 then return end

		ply.HasPlayedSpawnSound = false

		for _, v in ipairs(player.GetAll()) do
			v:EmitSound("friends/friend_join.wav", 75, 100)
		end
	end)

	hook.Add("PlayerSpawn", "ImOnline", function(ply)
		if not IsValid(ply) then return end
		if GetConVar("sv_cets_friends_join_sound"):GetInt() == 0 then return end
		if ply.HasPlayedSpawnSound then return end

		ply.HasPlayedSpawnSound = true

		for _, v in ipairs(player.GetAll()) do
			v:EmitSound("friends/friend_online.wav", 75, 100)
		end
	end)

	hook.Add("PlayerSay", "ChatSound", function(ply, text)
		if not IsValid(ply) then return end
		if GetConVar("sv_cets_friends_chat_sound"):GetInt() == 0 then return end

		for _, v in ipairs(player.GetAll()) do
			if GetConVar("sv_cets_friends_chat_sound_hl1"):GetInt() == 0 then
				v:EmitSound("friends/message.wav", 75, 100)
			else
				v:EmitSound("hl1/misc/talk.wav", 75, 100)
			end			
		end
	end)

	local function TeleportCets(ply, cmd, args)
		if not IsValid(ply) then return end
		local targetName = args[1]
		if not targetName then
			ply:ChatPrint("Usage: cets_tp <player>")
			return
		end

		local target

		for _, pl in ipairs(player.GetAll()) do
			if string.find(string.lower(pl:Nick()), string.lower(targetName), 1, true) then	        target = pl	        break	    end	end
				if IsValid(target) then
					ply:SetPos(target:GetPos())
				else
					ply:ChatPrint("Player not found")
				end
		end

	hook.Add("PlayerSpawn", "DisablePlayerCollision", function(ply)	ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR) end)
	
	concommand.Add("cets_tp", TeleportCets)
else

	surface.CreateFont("KillAnnouncerFont", {font = "Trebuchet MS", size = 48, weight = 900, antialias = true})

	local KillMessages = {
		[2] = "DOUBLE KILL",
		[3] = "TRIPLE KILL",
		[4] = "PLAY",
		[5] = "MONSTER KILL",
		[6] = "RAMPAGE",
		[7] = "KILLING SPREE",
		[8] = "DOMINATING",
		[9] = "IMPRESSIVE",
		[10] = "UNSTOPPABLE",
		[11] = "OUTSTANDING",
		[12] = "MEGA KILL",
		[13] = "ULTRA KILL",
		[14] = "EAGLE EYE",
		[15] = "OWNAGE",
		[16] = "COMBO KING",
		[17] = "MANIAC",
		[18] = "LUDICROUS KILL",
		[19] = "BULLSEYE",
		[20] = "EXCELLENT",
		[21] = "PANCAKE",
		[22] = "HEADHUNTER",
		[23] = "UNREAL",
		[24] = "ASSASSIN",
		[25] = "WICKED SICK",
		[26] = "MASSACRE",
		[27] = "KILLING MACHINE",
		[28] = "MONSTER KILL",
		[29] = "HOLY SHIT",
		[30] = "GODLIKE"
	}

	local CurrentKillMessage = ""
	local KillMessageEnd = 0

	net.Receive("KillAnnouncer_Message", function()
		local streak = net.ReadUInt(8)
		local sound = net.ReadString()

		CurrentKillMessage = KillMessages[streak] or ""
		KillMessageEnd = CurTime() + 2

		surface.PlaySound(sound)
	end)

	net.Receive("KillAnnouncer_FirstBlood", function()
		local sound = net.ReadString()

		CurrentKillMessage = "FIRST BLOOD" or ""
		KillMessageEnd = CurTime() + 2

		surface.PlaySound(sound)
	end)

	hook.Add("HUDPaint", "KillAnnouncer_Draw", function()
		if CurTime() > KillMessageEnd then return end
		if CurrentKillMessage == "" then return end

		local flicker = math.abs(math.sin(CurTime() * 12))
		local alpha = math.Clamp(1 / 1, 0, 1) * 128
		alpha = alpha * (0.5 + flicker * 0.5)

		draw.SimpleTextOutlined(CurrentKillMessage, "KillAnnouncerFont", ScrW() / 2, ScrH() * 0.25, Color(255, 128, 0, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha))
	end)

	local pressed = false

	hook.Add("Think", "JeepGunToggleKey", function()
		if input.IsMouseDown(MOUSE_MIDDLE) and not pressed then
			pressed = true
			net.Start("JeepGunToggle")
			net.SendToServer()

		elseif not input.IsMouseDown(MOUSE_MIDDLE) then
			pressed = false
		end
	end)

	hook.Add("OnEntityCreated", "TrackJeepGunState", function(ent)
		timer.Simple(0, function()

		if not IsValid(ent) then return end

		local hasGun = true
		local enableGun = ent:GetInternalVariable("EnableGun")

		if tonumber(enableGun) == 0 then
			hasGun = false
		end

		ent:SetNWBool("HasOriginalGun", hasGun)
		ent:SetNWBool("GunDetached", false)

 		end)
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Category = "Half-Life 2"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MVHL = {
				// Required information
				Name =	"Motorbike",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The fan-made motorbike from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_motorbike_01.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_hl2_motorbike.txt"
				},

				Members = {
								HandleAnimation = HandleBoatVehicleAnimation,
				},
}

list.Set( "Vehicles", "vehicle_cets_hl2_motorbike", MVHL )

local MVHL1 = {
				// Required information
				Name =	"Snowbike",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The fan-made snowbike from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_motorbike_02.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_hl2_motorbike.txt"
				},

				Members = {
								HandleAnimation = HandleBoatVehicleAnimation,
				},
}

list.Set( "Vehicles", "vehicle_cets_hl2_snowbike", MVHL1 )

local WVHL = {
				// Required information
				Name =	"Jetski",
				Class = "prop_vehicle_airboat",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The scrapped jetski from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_jetski.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_hl2_jetski.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_jetski", WVHL )

local VHL = {
				// Required information
				Name =	"Hatchback Car",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "A destroyed car from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_car001a_hatchback_skin0.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}



list.Set( "Vehicles", "vehicle_cets_hl2_destroyed_car", VHL )

local VHL1 = {
				// Required information
				Name =	"Generic Car (Model 002)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "A car from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_car002a.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_car", VHL1 )

local VHL2 = {
				// Required information
				Name =	"Generic Car (Model 003)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "A car from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_car003a.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_car2", VHL2 )

local VHL3 = {
				// Required information
				Name =	"Generic Car (Model 004)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "A car from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_car004a.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_car3", VHL3 )

local VHL4 = {
				// Required information
				Name =	"Generic Car (Model 005)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "A car from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_car005a.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_car4", VHL4 )

local VHL5 = {
				// Required information
				Name =	"Generic Van",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "A van from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_van001a_01.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_van", VHL5 )

local VHL6 = {
				// Required information
				Name =	"Generic Van (No door)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "A van from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_van001a_01_nodoor.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_van_nodoor", VHL6 )

//local VHL7 = {
//				// Required information
//				Name =	"Forklift",
//				Class = "prop_vehicle_jeep",
//				Category = Category,
//
//				// Optional information
//				Author = "VALVe",
//				Information = "The forklift from Half-Life 2",
//				Model =	"models/vehicles/CETS/cets_hl2_forklift_ep2.mdl",
//
//				KeyValues = {
//					vehiclescript = "scripts/vehicles/cets_css_forklift.txt"
//				}
//}
//
//list.Set( "Vehicles", "vehicle_cets_hl2_forklift", VHL7 )

local VHL8 = {
				// Required information
				Name =	"Generic Truck (Model 001)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The truck from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_truck001c_01.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_truck.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_truck1", VHL8 )

local VHL9 = {
				// Required information
				Name =	"Generic Truck (Model 002)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The truck from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_truck002a_cab.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_truck.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_truck2", VHL9 )

local VHL10 = {
				// Required information
				Name =	"Generic Truck (Model 003)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The truck from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_truck003a_01.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_truck.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_truck3", VHL10 )

local VHL11 = {
				// Required information
				Name =	"Shared Jeep",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The jeep from Half-Life 2",
				Model =	"models/buggy.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/jeep_test.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_shared1", VHL11 )

local VHL12 = {
				// Required information
				Name =	"Digger",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The Ravenholm digger from Half-Life 2",
				Model =	"models/vehicles/CETS/cets_hl2_digger.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_hl2_digger.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_hl2_digger", VHL12 )

local V = {
				// Required information
				Name =	"Modern Car",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The car from Counter-Strike: Source",
				Model =	"models/vehicles/cets/cets_css_car.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_css_car", V )

local V1 = {
				// Required information
				Name =	"Modern Truck",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The truck from Counter-Strike: Source",
				Model =	"models/vehicles/CETS/cets_css_truck_closed.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_truck.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_css_truck", V1 )

local V2 = {
				// Required information
				Name =	"Modern Truck (Open)",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The truck from Counter-Strike: Source",
				Model =	"models/vehicles/CETS/cets_css_truck.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_truck.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_css_truck_open", V2 )

local V3 = {
				// Required information
				Name =	"Modern Utility Truck",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The utility truck from Counter-Strike: Source",
				Model =	"models/vehicles/CETS/cets_css_utility_truck.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_car.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_css_utility_truck", V3 )

local V4 = {
				// Required information
				Name =	"Modern Forklift",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The forklift from Counter-Strike: Source",
				Model =	"models/vehicles/CETS/cets_css_forklift.mdl",

				KeyValues = {
					vehiclescript = "scripts/vehicles/cets_css_forklift.txt"
				}
}

list.Set( "Vehicles", "vehicle_cets_css_forklift", V4 )

// ******************************
// CSS CAR SOUNDS
// ******************************

sound.Add( 
{
	name = "CETS_Jetski_engine_start",
	channel = CHAN_STATIC,
	volume = 0.64,
	soundlevel = 20,
	sound = "vehicles/cets/jetski_start.wav"
} )

sound.Add( 
{
	name = "CETS_Jetski_engine_stop",
	channel = CHAN_STATIC,
	volume = 0.64,
	soundlevel = 20,
	sound = "vehicles/cets/jetski_off.wav"
} )

sound.Add( 
{
	name = "CETS_Jetski_engine_idle",
	channel = CHAN_STATIC,
	volume = 0.64,
	soundlevel = 20,
	sound = "vehicles/cets/jetski_idle_loop1.wav"
} )

sound.Add( 
{
	name = "CETS_Jetski_skid_lowfriction",
	channel = CHAN_STATIC,
	volume = 0.64,
	soundlevel = 20,
	sound = "vehicles/cets/jetski_bounce1.wav"
} )

sound.Add( 
{
	name = "CETS_Jetski_skid_normalfriction",
	channel = CHAN_STATIC,
	volume = 0.64,
	soundlevel = 20,
	sound = "vehicles/cets/jetski_bounce2.wav"
} )

sound.Add( 
{
	name = "CETS_Jetski_skid_highfriction",
	channel = CHAN_STATIC,
	volume = 0.64,
	soundlevel = 20,
	sound = "vehicles/cets/jetski_bounce3.wav"
} )

sound.Add( 
{
	name = "CETSCSS_reverse_truck",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "vehicles/cets/truck_reverse.wav"
} )

sound.Add( 
{
	name = "CETSCSS_rev_truck",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "vehicles/cets/truck_rev.wav"
} )

sound.Add( 
{
	name = "CETSCSS_engine_idle_truck",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "vehicles/cets/truck_idle.wav"
} )

sound.Add( 
{
	name = "CETSCSS_firstgear_truck",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "vehicles/cets/truck_1stgear.wav"
} )

sound.Add( 
{
	name = "CETSCSS_secondgear_truck",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "vehicles/cets/truck_2ndgear.wav"
} )

sound.Add( 
{
	name = "CETSCSS_engine_idle",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "vehicles/cets/atv_idle_loop1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_engine_null",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "common/null.wav"
} )

sound.Add( 
{
	name = "CETSCSS_engine_start",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = {"vehicles/cets/atv_start_loop1.wav", "vehicles/cets/atv_start_loop2.wav"}
} )

sound.Add( 
{
	name = "CETSCSS_engine_stop",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	sound = "vehicles/junker/jnk_stop1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_rev",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 95,
	pitchend = 105,
	sound = "vehicles/cets/atv_secondgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_reverse",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 100,
	pitchend = 100,
	sound = "vehicles/cets/atv_secondgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_firstgear",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 100,
	pitchend = 100,
	sound = "vehicles/cets/atv_firstgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_secondgear",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 100,
	pitchend = 100,
	sound = "vehicles/cets/atv_secondgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_thirdgear",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 100,
	pitchend = 100,
	sound = "vehicles/cets/atv_thirdgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_fourthgear",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 105,
	pitchend = 105,
	sound = "vehicles/v8/fourth_cruise_loop2.wav"
} )

sound.Add( 
{
	name = "CETSCSS_firstgear_noshift",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 105,
	pitchend = 105,
	sound = "vehicles/cets/atv_firstgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_secondgear_noshift",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 105,
	pitchend = 105,
	sound = "vehicles/cets/atv_secondgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_thirdgear_noshift",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 105,
	pitchend = 105,
	sound = "vehicles/cets/atv_thirdgear1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_fourthgear_noshift",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 105,
	pitchend = 105,
	sound = "vehicles/v8/fourth_cruise_loop2.wav"
} )

sound.Add( 
{
	name = "CETSCSS_downshift_to_2nd",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 90,
	pitchend = 105,
	sound = "vehicles/cets/atv_downshift_to_2nd_loop1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_downshift_to_1nd",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 90,
	pitchend = 105,
	sound = "vehicles/cets/atv_downshift_to_1st_loop1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_throttleoff_slowspeed",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 90,
	pitchend = 105,
	sound = "vehicles/cets/atv_throttleoff_slow_loop1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_throttleoff_fastspeed",
	channel = CHAN_STATIC,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 90,
	pitchend = 105,
	sound = "vehicles/cets/atv_throttleoff_loop1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_skid_lowfriction",
	channel = CHAN_BODY,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 90,
	pitchend = 110,
	sound = "vehicles/cets/atv_skid_lowfriction.wav"
} )

sound.Add( 
{
	name = "CETSCSS_skid_normalfriction",
	channel = CHAN_BODY,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 90,
	pitchend = 110,
	sound = "vehicles/cets/atv_skid_normalfriction.wav"
} )

sound.Add( 
{
	name = "CETSCSS_skid_highfriction",
	channel = CHAN_BODY,
	volume = 0.34,
	soundlevel = 20,
	pitchstart = 90,
	pitchend = 110,
	sound = "vehicles/cets/atv_skid_highfriction.wav"
} )

sound.Add( 
{
	name = "CETSCSS_impact_heavy",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 80,
	pitchstart = 95,
	pitchend = 110,
	sound = {"vehicles/v8/vehicle_impact_heavy1.wav",
		"vehicles/v8/vehicle_impact_heavy2.wav",
		"vehicles/v8/vehicle_impact_heavy3.wav",
		"vehicles/v8/vehicle_impact_heavy4.wav"}
} )

sound.Add( 
{
	name = "CETSCSS_impact_medium",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 80,
	pitchstart = 95,
	pitchend = 110,
	sound = {"vehicles/v8/vehicle_impact_heavy1.wav",
		"vehicles/v8/vehicle_impact_heavy2.wav",
		"vehicles/v8/vehicle_impact_heavy3.wav",
		"vehicles/v8/vehicle_impact_heavy4.wav"}
} )

sound.Add( 
{
	name = "CETSCSS_rollover",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 80,
	pitchstart = 95,
	pitchend = 110,
	sound = {"vehicles/v8/vehicle_rollover1.wav",
		"vehicles/v8/vehicle_rollover2.wav"}
} )

sound.Add( 
{
	name = "CETSCSS_turbo_on",
	channel = CHAN_ITEM,
	volume = 0.34,
	soundlevel = 80,
	pitchstart = 90,
	pitchend = 110,
	sound = "vehicles/cets/vehicle_turbo_loop3.wav"
} )

sound.Add( 
{
	name = "CETSCSS_turbo_off",
	channel = CHAN_ITEM,
	volume = 0.34,
	soundlevel = 80,
	pitchstart = 90,
	pitchend = 110,
	sound = "vehicles/cets/vehicle_turbo_off1.wav"
} )

sound.Add( 
{
	name = "CETSCSS_start_in_water",
	channel = CHAN_VOICE,
	volume = 1.0,
	soundlevel = 80,
	pitchstart = 100,
	pitchend = 100,
	sound = "vehicles/jetski/jetski_no_gas_start.wav"
} )

sound.Add( 
{
	name = "CETSCSS_stall_in_water",
	channel = CHAN_VOICE,
	volume = 1.0,
	soundlevel = 80,
	pitchstart = 100,
	pitchend = 100,
	sound = "vehicles/jetski/jetski_off.wav"
} )

sound.Add( 

{
	name = "DIG_engine_idle",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "",
	sound = "vehicles/cets/digger_idle_loop1.wav"
} )

sound.Add( 

{
	name = "DIG_engine_start",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "",
	sound = "vehicles/cets/digger_startengine1.wav"
} )
sound.Add( 

{
	name = "DIG_engine_stop",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "",
	sound = "vehicles/cets/digger_stopengine1.wav"
} )
sound.Add( 

{
	name = "DIG_rev",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "85,95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_reverse",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_firstgear",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_secondgear",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "85,95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_thirdgear",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "85,95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_fourthgear",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_firstgear_noshift",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_secondgear_noshift",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_thirdgear_noshift",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_fourthgear_noshift",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_throttleoff_slowspeed",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "85,95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_throttleoff_fastspeed",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "85,95",
	sound = "vehicles/cets/digger_drive_loop1.wav"
} )
sound.Add( 

{
	name = "DIG_turbo_on",
	channel = "CHAN_STATIC",
	volume = "1.0",
	soundlevel = "SNDLVL_80dB",
	pitch = "85,95",
	sound = "vehicles/cets/digger_trottleon1.wav"
} )