if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//TELEP
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local function TeleportCets(ply, cmd, args)
		if not IsValid(ply) then return end
		local targetName = args[1]

		if not targetName then
			ply:ChatPrint("Usage: cets_tp <player>")
			return
		end

		local target
			for _, pl in ipairs(player.GetAll()) do
				if string.find(string.lower(pl:Nick()), string.lower(targetName), 1, true) then
				target = pl
				break
			end
		end

		if IsValid(target) then
			ply:SetPos(target:GetPos())
			ply:EmitSound("hl1/misc/r_tele3.wav", 65, 100)
			ParticleEffect("xenpor_arc_01_floaters_blu", ply:GetPos(), Angle(0, 0, 0), nil)
		else
			ply:ChatPrint("Player not found")
		end
	end

	local function TeleportCetsReverse(ply, cmd, args)
		if not IsValid(ply) then return end
		local targetName = args[1]

		if not targetName then
			ply:ChatPrint("Usage: cets_tphere <player>")
			return
		end

		local target
			for _, pl in ipairs(player.GetAll()) do
				if string.find(string.lower(pl:Nick()), string.lower(targetName), 1, true) then
				target = pl
				break
			end
		end

		if IsValid(target) then
			target:SetPos(ply:GetPos())
			target:EmitSound("hl1/misc/r_tele3.wav", 65, 100)
			ParticleEffect("xenpor_arc_01_floaters_blu", target:GetPos(), Angle(0, 0, 0), nil)
		else
			ply:ChatPrint("Player not found")
		end
	end

	hook.Add("PlayerSpawn", "DisablePlayerCollision", function(ply) ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR) end)

	concommand.Add("cets_tp", TeleportCets)
	concommand.Add("cets_tphere", TeleportCetsReverse)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//PHYSPLAY
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local HeldAngles = {}
	local HeldBy = {}

	hook.Add("PhysgunPickup", "GrabPlayers_AllowPickup", function(ply, ent)
		if GetConVar("cets_grab_players_phys"):GetInt() == 0 then return end
		if ent:IsPlayer() then
			HeldAngles[ent] = ent:GetAngles()
			HeldBy[ent] = ply
			return true
		end
	end)

	hook.Add("PhysgunDrop", "GrabPlayers_RestoreAngles", function(ply, ent)
		if ent:IsPlayer() and HeldAngles[ent] then
			ent:SetAngles(HeldAngles[ent])
			HeldAngles[ent] = nil
			HeldBy[ent] = nil
		end
	end)

	hook.Add("GetDamage", "GrabPlayers_NoFallDamage", function(ply, speed)
		if GetConVar("cets_grab_players_phys"):GetInt() == 0 then return end
		if ply:IsPlayerHolding() then
			return 0
		end
	end)

	hook.Add("Think", "GrabPlayers_LookAtHolder", function()
		for ent, holder in pairs(HeldBy) do
			if not IsValid(ent) or not IsValid(holder) then
				HeldBy[ent] = nil
				continue
			end
			local ang = (holder:GetPos() - ent:GetPos()):Angle()
			ang.pitch = 0
			ang.roll = 0
			ent:SetEyeAngles(ang)
			ent:SetAngles(ang)
		end
	end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//KILLSTREAK
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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


	util.AddNetworkString("CETS_FriendJoin")

	hook.Add("PlayerInitialSpawn", "CETS_FriendJoin", function(ply)
		if not GetConVar("sv_cets_friends_join_sound"):GetBool() then return end

		-- Wait until the player is fully connected.
		timer.Simple(1, function()
			if not IsValid(ply) then return end

			net.Start("CETS_FriendJoin")
				net.WriteEntity(ply)
			net.Broadcast()
		end)
	end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else
	local NextOnlineSound = 0

	hook.Add("ChatText", "CETS_FriendOnline", function(index, name, text, typ)

		if typ ~= "joinleave" then return end
		if not GetConVar("sv_cets_friends_join_sound"):GetBool() then return end

		if not string.find(text, "joined the game", 1, true) then return end

		if CurTime() < NextOnlineSound then return end
		NextOnlineSound = CurTime() + 0.5

		surface.PlaySound("friends/friend_online.wav")
	end)

	net.Receive("CETS_FriendJoin", function()
		if not GetConVar("sv_cets_friends_join_sound"):GetBool() then return end

		local ply = net.ReadEntity()

		if not IsValid(ply) then return end
		if ply == LocalPlayer() then return end

		surface.PlaySound("friends/friend_join.wav")

	end)
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
end