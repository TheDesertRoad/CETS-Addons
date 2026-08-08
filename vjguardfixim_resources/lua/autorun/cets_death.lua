if SERVER then
	util.AddNetworkString("MissionFailed")

	hook.Add("PlayerDeath", "MissionFailedReload", function()
		if GetConVar("sv_cets_mission_fail_check"):GetInt() == 0 then return end
		for _, ply in ipairs(player.GetHumans()) do
			if ply:Alive() then
				return
			end
		end

		MissionFailed = true

		net.Start("MissionFailed")
		net.Broadcast()

		timer.Simple(8, function()
			RunConsoleCommand("changelevel", game.GetMap())
		end)
	end)

	hook.Add("PlayerDeathThink", "MissionFailedNoRespawn", function(ply)
		if MissionFailed then
			return false
		end
	end)
else
	surface.CreateFont("MissionFailedTitle", {
		font = "Trebuchet MS",
		size = 64,
		weight = 900,
		antialias = true
	})

	surface.CreateFont("MissionFailedSub", {
		font = "Trebuchet MS",
		size = 28,
		weight = 600,
		antialias = true
	})

	local active = false
	local startTime = 0
	local failSounds = {
		"music/hl2_score2.mp3",
		"music/hl2_score4.mp3",
		"music/hl2_score5.mp3",
		"music/hl2_score6.mp3"
	}

	net.Receive("MissionFailed", function()
		active = true
		startTime = CurTime()

		surface.PlaySound(table.Random(failSounds))
	end)

	local hide = {
		CHudHealth = true,
		CHudBattery = true,
		CHudAmmo = true,
		CHudSecondaryAmmo = true,
		CHudCrosshair = true,
		CHudWeaponSelection = true,
		CHudQuickInfo = true,
		CHudSuitPower = true,
		CHudDamageIndicator = true,
		CHudHistoryResource = true,
		CHudVehicle = true,
		CHudZoom = true,
		CHudPoisonDamageIndicator = true,
		CHudSquadStatus = true,
	}

	hook.Add("HUDShouldDraw", "MissionFailedHideHUD", function(name)
			if active and hide[name] then
			return false
		end
	end)

	hook.Add("HUDPaint", "MissionFailedScreen", function()
		if not active then return end

		local elapsed = CurTime() - startTime
		local bgAlpha = math.Clamp(elapsed / 3, 0, 1) * 255
		local textAlpha = math.Clamp((elapsed - 1.5) / 1, 0, 1) * 255

		surface.SetDrawColor(0, 0, 0, bgAlpha)
		surface.DrawRect(0, 0, ScrW(), ScrH())

		local title = "MISSION FAILED"
		local subtitle = "YOU DIED! EVERYTHING IS LOST, THERE IS NOTHING WE CAN DO..."
		local titleSpeed = 18
		local subtitleSpeed = 32
		local titleStart = 1.8
		local subtitleStart = 2.0
		local titleChars = math.floor(math.max(0, elapsed - titleStart) * titleSpeed)
		local subtitleChars = math.floor(math.max(0, elapsed - subtitleStart) * subtitleSpeed)
		local shownTitle = string.sub(title, 1, titleChars)
		local shownSubtitle = string.sub(subtitle, 1, subtitleChars)

		draw.SimpleText(shownTitle, "MissionFailedTitle", ScrW() / 2, ScrH() / 2 - 30, Color(255, 128, 64, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(shownSubtitle, "MissionFailedSub", ScrW() / 2, ScrH() / 2 + 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end