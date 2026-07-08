//Doc's vehicles // Modified by TheDesertRoad
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("JeepGunToggle")

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
else
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