local Digger = {
	["vehicle_cets_hl2_digger"] = true,
}

local Ambulance = {
	["vehicle_cets_l4d_ambulance_skin"] = true,
}

local Police = {
	["vehicle_cets_l4d_police"] = true,
}

local NewsVan = {
	["vehicle_cets_l4d_news"] = true,
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local DiggerEnabled = {}
local AmbulanceEnabled = {}
local PoliceEnabled = {}
local NewsVanEnabled = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local START_SOUND = "vehicles/cets/digger_grinder_start1.wav"
local LOOP_SOUND  = "vehicles/digger_grinder_loop1.wav"
local STOP_SOUND  = "vehicles/digger_grinder_stop1.wav"

local LOOP_SOUND1  = "ambient/alarms/city_eurosiren_loop1.wav"

local LOOP_SOUND2  = "ambient/alarms/city_eurosiren_loop2.wav"

local LOOP_SOUND3  = "music/tv_music2.wav"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "DiggerDamage", function()
	if IsValid(ply) then return true end
	for _, ply in player.Iterator() do
		local veh = ply:GetVehicle()

		if not IsValid(veh) then continue end
		if veh:GetDriver() ~= ply then continue end
		if not Digger[veh.VehicleName] then continue end

		local sid = ply:SteamID64()

		if ply:KeyDown(IN_ATTACK2) then
			if not ply.DiggerTogglePressed then

			ply.DiggerTogglePressed = true
			DiggerEnabled[sid] = not DiggerEnabled[sid]

			if DiggerEnabled[sid] then
				veh:EmitSound(START_SOUND)
				timer.Simple(1.7, function()
					if not IsValid(veh) then return end
					if not DiggerEnabled[sid] then return end

					if not veh.DiggerDamageSound then
						veh.DiggerDamageSound = CreateSound(veh, LOOP_SOUND)
					end

				veh.DiggerDamageSound:Play()
				end)

			else
				if veh.DiggerDamageSound then
					veh.DiggerDamageSound:Stop()
				end

			veh:EmitSound(STOP_SOUND)
			end
		end
	else
		ply.DiggerTogglePressed = false

	end

	if not DiggerEnabled[sid] then continue end
	ply.NextDiggerDamage = ply.NextDiggerDamage or 0

	if ply.NextDiggerDamage > CurTime() then continue end
	ply.NextDiggerDamage = CurTime() + 0.1

	local center = veh:GetPos() + veh:GetForward() * 120 + veh:GetUp() * 20

	for _, ent in ipairs(ents.FindInSphere(center, 80)) do

		if not IsValid(ent) then continue end
		if ent == veh then continue end
		if ent == ply then continue end

		local dmg = DamageInfo()
		dmg:SetDamage(12)
		dmg:SetAttacker(ply)
		dmg:SetInflictor(veh)
		dmg:SetDamageType(DMG_CRUSH)

		ent:TakeDamageInfo(dmg)
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerLeaveVehicle", "StopDiggerSound", function(ply, veh)
	local sid = ply:SteamID64()

	if DiggerEnabled[sid] then
		DiggerEnabled[sid] = false

		if veh.DiggerDamageSound then
			veh.DiggerDamageSound:Stop()
		end

		veh:EmitSound(STOP_SOUND)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityRemoved", "CleanupDiggerSound", function(ent)
	if ent.DiggerDamageSound then
		ent.DiggerDamageSound:Stop()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "AmbulanceSound", function()
	for _, ply in player.Iterator() do
		local veh = ply:GetVehicle()

		if not IsValid(veh) then continue end
		if veh:GetDriver() ~= ply then continue end
		if not Ambulance[veh.VehicleName] then continue end

		local sid = ply:SteamID64()

		if ply:KeyDown(IN_ATTACK2) then
			if not ply.AmbulanceTogglePressed then
				ply.AmbulanceTogglePressed = true

				AmbulanceEnabled[sid] = not AmbulanceEnabled[sid]

				if AmbulanceEnabled[sid] then
					if not veh.AmbulanceSound then
						veh.AmbulanceSound = CreateSound(veh, LOOP_SOUND1)
					end

					veh.AmbulanceSound:Play()
				else
					if veh.AmbulanceSound then
						veh.AmbulanceSound:Stop()
					end
				end
			end
		else
			ply.AmbulanceTogglePressed = false
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerLeaveVehicle", "StopAmbulanceSound", function(ply, veh)
	local sid = ply:SteamID64()

	if AmbulanceEnabled[sid] then
		AmbulanceEnabled[sid] = false

		if veh.AmbulanceSound then
			veh.AmbulanceSound:Stop()
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityRemoved", "CleanupAmbulanceSound", function(ent)
	if ent.AmbulanceDamageSound then
		ent.AmbulanceDamageSound:Stop()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "PoliceSound", function()
	for _, ply in player.Iterator() do
		local veh = ply:GetVehicle()

		if not IsValid(veh) then continue end
		if veh:GetDriver() ~= ply then continue end
		if not Police[veh.VehicleName] then continue end

		local sid = ply:SteamID64()

		if ply:KeyDown(IN_ATTACK2) then
			if not ply.PoliceTogglePressed then
				ply.PoliceTogglePressed = true

				PoliceEnabled[sid] = not PoliceEnabled[sid]

				if PoliceEnabled[sid] then
					if not veh.PoliceSound then
						veh.PoliceSound = CreateSound(veh, LOOP_SOUND2)
					end

					veh.PoliceSound:Play()
				else
					if veh.PoliceSound then
						veh.PoliceSound:Stop()
					end
				end
			end
		else
			ply.PoliceTogglePressed = false
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerLeaveVehicle", "StopPoliceSound", function(ply, veh)
	local sid = ply:SteamID64()

	if PoliceEnabled[sid] then
		PoliceEnabled[sid] = false

		if veh.PoliceSound then
			veh.PoliceSound:Stop()
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityRemoved", "CleanupPoliceSound", function(ent)
	if ent.PoliceDamageSound then
		ent.PoliceDamageSound:Stop()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "NewsVanSound", function()
	for _, ply in player.Iterator() do
		local veh = ply:GetVehicle()

		if not IsValid(veh) then continue end
		if veh:GetDriver() ~= ply then continue end
		if not NewsVan[veh.VehicleName] then continue end

		local sid = ply:SteamID64()

		if ply:KeyDown(IN_ATTACK2) then
			if not ply.NewsVanTogglePressed then
				ply.NewsVanTogglePressed = true

				NewsVanEnabled[sid] = not NewsVanEnabled[sid]

				if NewsVanEnabled[sid] then
					if not veh.NewsVanSound then
						veh.NewsVanSound = CreateSound(veh, LOOP_SOUND3)
					end

					veh.NewsVanSound:Play()
				else
					if veh.NewsVanSound then
						veh.NewsVanSound:Stop()
					end
				end
			end
		else
			ply.NewsVanTogglePressed = false
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerLeaveVehicle", "StopNewsVanSound", function(ply, veh)
	local sid = ply:SteamID64()

	if NewsVanEnabled[sid] then
		NewsVanEnabled[sid] = false

		if veh.NewsVanSound then
			veh.NewsVanSound:Stop()
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityRemoved", "CleanupNewsVanSound", function(ent)
	if ent.NewsVanDamageSound then
		ent.NewsVanDamageSound:Stop()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local VehicleHorns = {
	["vehicle_cets_misc_lunar"] = "ambient/alarms/warningbell2.wav",

	["vehicle_cets_l4d_airport_baggage_tractor"] = "ambient/alarms/warningbell2.wav",
	["vehicle_cets_l4d_airport_fuel_truck"] = "vehicles/cets/honk2.wav",
	["vehicle_cets_l4d_ambulance_skin"] = "vehicles/cets/honk1.wav",
	["vehicle_cets_l4d_army_truck"] = "vehicles/cets/honk2.wav",
	["vehicle_cets_l4d_cement_truck"] = "vehicles/cets/honk2.wav",
	["vehicle_cets_l4d_HMMWV"] = "vehicles/cets/honk1.wav",
	["vehicle_cets_l4d_HMMWV_desert"] = "vehicles/cets/honk1.wav",
	["vehicle_cets_l4d_news"] = "vehicles/cets/honk1.wav",
	["vehicle_cets_l4d_police"] = "vehicles/cets/honk1.wav",

	["vehicle_cets_hl2_car"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_car2"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_car3"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_car4"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_car5"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_destroyed_car"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_van"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_van_nodoor"] = "vehicles/cets/honk1_b.wav",
	["vehicle_cets_hl2_truck1"] = "vehicles/cets/honk2_b.wav",
	["vehicle_cets_hl2_truck2"] = "vehicles/cets/honk2_b.wav",
	["vehicle_cets_hl2_truck3"] = "vehicles/cets/honk2_b.wav",

	["vehicle_cets_css_car"] = "vehicles/cets/honk1.wav",
	["vehicle_cets_css_utility_truck"] = "vehicles/cets/honk1.wav",
	["vehicle_cets_css_truck"] = "vehicles/cets/honk2.wav",
	["vehicle_cets_css_truck_open"] = "vehicles/cets/honk2.wav",
	["vehicle_cets_css_pvan"] = "vehicles/cets/honk1.wav",
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "VehicleHorn", function()
	if IsValid(ply) then return true end
	for _, ply in player.Iterator() do

		local veh = ply:GetVehicle()

		if not IsValid(veh) then continue end
		if veh:GetDriver() ~= ply then continue end

		local horn = VehicleHorns[veh.VehicleName]

		if not horn then
			continue
		end

		if ply:KeyDown(IN_ATTACK) then
			if not veh.HornPressed then
				veh.HornPressed = true
				veh:EmitSound(horn, 75, 100)
			end
		else
			veh.HornPressed = false
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local PassengerVehicles = {
	["vehicle_cets_l4d_news"] = {
		{Pos = Vector(20,35,40), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_police"] = {
		{Pos = Vector(19,0,17), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(15,-50,17), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(-15,-50,17), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_HMMWV"] = {
		{Pos = Vector(32,8,32), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(32,-33,32), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(-32,-33,32), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_HMMWV_desert"] = {
		{Pos = Vector(32,8,32), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(32,-33,32), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(-32,-33,32), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_airport_baggage_tractor"] = {
		{Pos = Vector(15,-27,40), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_airport_fuel_truck"] = {
		{Pos = Vector(20,85,60), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_ambulance_skin"] = {
		{Pos = Vector(20,35,40), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_army_truck"] = {
		{Pos = Vector(20,43,70), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_l4d_cement_truck"] = {
		{Pos = Vector(20,30,63), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_misc_lunar"] = {
		{Pos = Vector(15,-17,20), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_hl2_shared1"] = {
		{Pos = Vector(18,-36,19), Ang = Angle(0,0,0), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(0,0,0), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(32,-102,48), Ang = Angle(0,180,0), ExitPos = Vector(80,-80,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(0,0,0), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(-32,-102,48), Ang = Angle(0,180,0), ExitPos = Vector(80,-80,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(0,0,0), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_hl2_truck1"] = {
		{Pos = Vector(20,80,50), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_hl2_truck2"] = {
		{Pos = Vector(28,65,62), Ang = Angle(0,0,8), ExitPos = Vector(90,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_hl2_truck3"] = {
		{Pos = Vector(23,0,47), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_hl2_van_nodoor"] = {
		{Pos = Vector(27,38,32), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 5000, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(0,38,32), Ang = Angle(0,0,8), ExitPos = Vector(70,-30,0), EnterRange = 5000, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(30,-42,29), Ang = Angle(0,90,8), ExitPos = Vector(90,30,10), EnterRange = 5000, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(-36,-26,36), Ang = Angle(0,-90,-18), ExitPos = Vector(90,30,10), EnterRange = 5000, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
	},

	["vehicle_cets_hl2_van"] = {
		{Pos = Vector(27,38,32), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 5000, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(0,38,32), Ang = Angle(0,0,8), ExitPos = Vector(70,-30,0), EnterRange = 5000, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(30,-42,29), Ang = Angle(0,90,8), ExitPos = Vector(90,30,10), EnterRange = 5000, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(-36,-26,36), Ang = Angle(0,-90,-18), ExitPos = Vector(90,30,10), EnterRange = 5000, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
	},

	["vehicle_cets_hl2_destroyed_car"] = {
		{Pos = Vector(17,-5,17), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(16,-30,17), Ang = Angle(0,0,8), ExitPos = Vector(70,-20,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(-16,-30,17), Ang = Angle(0,0,8), ExitPos = Vector(-70,-20,0), EnterRange = 500, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true}
	},

	["vehicle_cets_hl2_car"] = {
		{Pos = Vector(16,-5,17), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_hl2_car2"] = {
		{Pos = Vector(17,-5,20), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 5000, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(16,-40,20), Ang = Angle(0,0,8), ExitPos = Vector(70,-20,0), EnterRange = 5000, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(-16,-40,20), Ang = Angle(0,0,8), ExitPos = Vector(-70,-20,0), EnterRange = 5000, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true}
	},

	["vehicle_cets_hl2_car3"] = {
		{Pos = Vector(17,-5,17), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(16,-45,17), Ang = Angle(0,0,8), ExitPos = Vector(70,-20,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(-16,-45,17), Ang = Angle(0,0,8), ExitPos = Vector(-70,-20,0), EnterRange = 500, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true}
	},

	["vehicle_cets_hl2_car4"] = {
		{Pos = Vector(17,-5,25), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(16,-45,25), Ang = Angle(0,0,8), ExitPos = Vector(70,-20,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(-16,-45,25), Ang = Angle(0,0,8), ExitPos = Vector(-70,-20,0), EnterRange = 500, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true}
	},

	["vehicle_cets_css_car"] = {
		{Pos = Vector(20,-2,19), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
		{Pos = Vector(15,-36,17), Ang = Angle(0,0,8), ExitPos = Vector(70,-20,0), EnterRange = 500, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true},
		{Pos = Vector(-15,-36,17), Ang = Angle(0,0,8), ExitPos = Vector(-70,-20,0), EnterRange = 500, ExitAng = Angle(0,90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = false, RadioControl = true}
	},

	["vehicle_cets_css_utility_truck"] = {
		{Pos = Vector(20, -8, 24), Ang = Angle(0,0,8), ExitPos = Vector(70,30,0), EnterRange = 8000, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_css_truck"] = {
		{Pos = Vector(20,70,45), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_css_truck_open"] = {
		{Pos = Vector(20,70,45), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},

	["vehicle_cets_css_pvan"] = {
		{Pos = Vector(20,35,40), Ang = Angle(0,0,8), ExitPos = Vector(80,40,0), EnterRange = 8200, ExitAng = Angle(0,-90,0), ModelOffset = Vector(12,0,4), Hide = true, DoorSounds = true, RadioControl = true},
	},
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function CreatePassengerSeats(ply, vehicle)
	if not IsValid(vehicle) then return end
	if vehicle.LVS then return end
	if vehicle.GetIsLVS and vehicle:GetIsLVS() then return end
				
			if vehicle:GetClass() ~= "prop_vehicle_jeep" then return end

			local vehicleName = vehicle.VehicleName

			if not vehicleName then return end

			local seatData = PassengerVehicles[vehicleName]

			if not seatData then return end

			vehicle.PassengerSeats = vehicle.PassengerSeats or {}

			for _, seatInfo in ipairs(seatData) do

				local seat = ents.Create("prop_vehicle_prisoner_pod")

				if not IsValid(seat) then continue end

				if vehicle:GetVehicleClass()=="vehicle_cets_hl2_shared1" then
					seat:SetModel("models/nova/jeep_seat.mdl")
				else
					seat:SetModel("models/nova/airboat_seat.mdl")		
				end

				seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")

			seat:SetPos(vehicle:LocalToWorld(seatInfo.Pos))
			seat:SetAngles(vehicle:LocalToWorldAngles(seatInfo.Ang))
			seat:SetKeyValue("limitview", "0")

			seat.ExitPos = seatInfo.ExitPos
			seat.ExitAng = seatInfo.ExitAng
			seat.ParentVehicle = vehicle

			local phys = seat:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetMass(1)
				phys:EnableCollisions(false)
				phys:EnableMotion(false)
			end

			if vehicle:GetVehicleClass()=="vehicle_cets_hl2_shared1" then

			else
				seat:SetNoDraw(false)	
				seat:SetRenderMode(RENDERMODE_NONE)
				seat:SetColor(Color(255, 255, 255, 0))
				seat:DrawShadow(false)
				seat:AddEffects(EF_NODRAW)
			end

			seat:Spawn()
			seat:Activate()

			constraint.Weld(seat, vehicle, 0, 0, 0, false)
			seat:SetParent(vehicle)
			seat:DeleteOnRemove(vehicle)
			table.insert(vehicle.PassengerSeats, seat)
		end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSpawnedVehicle", "PassengerSeats_Create", CreatePassengerSeats)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerLeaveVehicle", "PassengerSeats_CustomExit", function(ply, seat)

	if not IsValid(seat) then return end
	if not seat.ParentVehicle then return end
	if not seat.ExitPos then return end

	local vehicle = seat.ParentVehicle

	timer.Simple(0.05, function() if not IsValid(ply) or not IsValid(vehicle) then return end
		if not IsValid(ply) then return end
		if not IsValid(vehicle) then return end

		ply:SetPos(vehicle:LocalToWorld(seat.ExitPos))
	end)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	local TruckGasModel = "models/vehicles/cets/cets_airport_fuel_truck.mdl"

	hook.Add("OnEntityCreated", "TruckGasSpawn", function(ent)
		if GetConVar("cets_vehicle_explosives"):GetInt() == 0 then return end

		timer.Simple(0, function()

			if not IsValid(ent) then return end
			if ent:GetClass() ~= "prop_vehicle_jeep" then return end
			if ent:GetModel() ~= TruckGasModel then return end

			if IsValid(ent.GasEntity) then return end

			ent.GasEntity = gas
			gas = ents.Create("obj_vj_cets_gasctruck")

			gas:SetPos(ent:GetPos() + ent:GetForward() * -80 + ent:GetUp() * 75 + ent:GetRight() * -32)
			gas:SetAngles(Angle(90, ent:GetAngles().y, ent:GetAngles().x))
			gas:Spawn()
			gas:Activate()
			gas.LinkedVehicle = ent
			gas:SetParent(ent)

			ent.GasEntity = gas1
			gas1 = ents.Create("obj_vj_cets_gasctruck")

			gas1:SetPos(ent:GetPos() + ent:GetForward() * -80 + ent:GetUp() * 75 + ent:GetRight() * 32)
			gas1:SetAngles(Angle(90, ent:GetAngles().y, ent:GetAngles().x))
			gas1:Spawn()
			gas1:Activate()
			gas1.LinkedVehicle = ent
			gas1:SetParent(ent)
		end)

	end)

	hook.Add("OnEntityCreated", "TruckLadderSpawn", function(ent)
		timer.Simple(0, function()

			if not IsValid(ent) then return end
			if ent:GetClass() ~= "prop_vehicle_jeep" then return end
			if ent:GetModel() ~= TruckGasModel then return end

			if IsValid(ent.LadderEntity) then return end

			ent.LadderEntity = Ladder
			Ladder = ents.Create("obj_vj_cets_ladder")

			Ladder:SetPos(ent:GetPos() + ent:GetForward() * -235 + ent:GetUp() * 5 + ent:GetRight() * 0)

			local ang = ent:GetAngles()
			ang:RotateAroundAxis(ang:Up(), -90)
			Ladder:SetAngles(ang)

			Ladder:Spawn()
			Ladder:Activate()
			Ladder.LinkedVehicle = ent
			Ladder:SetParent(ent)
		end)
	end)

	local FrontLoaderModel = "models/vehicles/cets/cets_front_loader01.mdl"

	hook.Add("OnEntityCreated", "FrontLoaderLadderSpawn", function(ent)
		timer.Simple(0, function()

			if not IsValid(ent) then return end
			if ent:GetClass() ~= "prop_vehicle_jeep" then return end
			if ent:GetModel() ~= FrontLoaderModel then return end

			if IsValid(ent.FrontLoaderLadderEntity) then return end

			ent.FrontLoaderLadderEntity = FrontLoaderLadder
			FrontLoaderLadder = ents.Create("obj_vj_cets_ladder")

			FrontLoaderLadder:SetPos(ent:GetPos() + ent:GetForward() * -15 + ent:GetUp() * -40 + ent:GetRight() * -60)

			local ang = ent:GetAngles()
			ang:RotateAroundAxis(ang:Up(), -180)
			FrontLoaderLadder:SetAngles(ang)

			FrontLoaderLadder:Spawn()
			FrontLoaderLadder:Activate()
			FrontLoaderLadder.LinkedVehicle = ent
			FrontLoaderLadder:SetParent(ent)

			ent.FrontLoaderLadderEntity = FrontLoaderLadder1
			FrontLoaderLadder1 = ents.Create("obj_vj_cets_ladder")

			FrontLoaderLadder1:SetPos(ent:GetPos() + ent:GetForward() * -15 + ent:GetUp() * -40 + ent:GetRight() * 60)

			local ang = ent:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 0)
			FrontLoaderLadder1:SetAngles(ang)

			FrontLoaderLadder1:Spawn()
			FrontLoaderLadder1:Activate()
			FrontLoaderLadder1.LinkedVehicle = ent
			FrontLoaderLadder1:SetParent(ent)
		end)
	end)
end