hook.Add("InitPostEntity", "MoveGrigoriCategory", function()
	if not GetConVar("cets_grigori_right"):GetBool() then return end

	local npcList = list.GetForEdit("NPC")
	if not npcList then return end

	local monk = npcList["npc_monk"]
	if not monk then return end

	monk.Category = "#spawnmenu.category.humans_resistance"
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
list.Set("PlayerOptionsModel", "Freeman", "models/player/freeman.mdl")
player_manager.AddValidModel("Freeman", "models/player/freeman.mdl")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
list.Set("PlayerOptionsModel", "Freeman", "models/weapons/addon/c_arms_freeman.mdl")
player_manager.AddValidHands( "Freeman", "models/weapons/addon/c_arms_freeman.mdl", 0, "00000000" )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
list.Set("PlayerOptionsModel", "Worker", "models/humans/worker/worker_04.mdl")
player_manager.AddValidModel("Worker", "models/humans/worker/worker_04.mdl")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
list.Set("PlayerOptionsModel", "Worker", "models/humans/worker/c_worker_arms.mdl")
player_manager.AddValidHands( "Worker", "models/humans/worker/c_worker_arms.mdl", 0, "00000000" )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
list.Set("PlayerOptionsModel", "Infiltrator", "models/humans/gman_spy/spy_04.mdl")
player_manager.AddValidModel("Infiltrator", "models/humans/gman_spy/spy_04.mdl")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
list.Set("PlayerOptionsModel", "Infiltrator", "models/weapons/addon/c_spy_arms.mdl")
player_manager.AddValidHands( "Infiltrator", "models/weapons/addon/c_spy_arms.mdl", 0, "00000000" )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
list.Set("PlayerOptionsModel", "Cultist", "models/headcrab_cultists/player_cultist.mdl")
player_manager.AddValidModel("Cultist", "models/headcrab_cultists/player_cultist.mdl")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//JUMPMODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("cets_remove_longjump", function(ply)
		if not IsValid(ply) or not ply:IsPlayer() then return end
		ply:SetNWBool("HasLongJump", false)
		ply.jumpmodule_can_use = nil
		ply.jumpmodule_keypress = nil
		ply.LongJumpBattery = nil
		ply.LongJumpRecharge = nil
	end)

	local function CETS_DoJump(ply)

		if not ply.jumpmodule_can_use then return end

		local vel = ply:GetVelocity()
		vel.x = math.Clamp(vel.x, -500, 500)
		vel.y = math.Clamp(vel.y, -500, 500)
		vel.z = math.Clamp(vel.z, 470, 270)

		ply.CETS_LongJumpBoost = vel

		ply:SetVelocity(vel)
		ply.jumpmodule_can_use = false

		ply:EmitSound("player/cets_jumpmod_boost1.wav", 70, math.random(100,110))
	end

	local played_sound

	hook.Add("KeyPress", "CETS_LongJumpUpgrade", function(ply, key)

		if not ply:GetNWBool("HasLongJump", false) then return end
		if ply:GetMoveType() ~= MOVETYPE_WALK then return end

		if ply:Crouching() and key == IN_JUMP then
			local longjump = ply.jumpmod_keypress and CurTime() - ply.jumpmod_keypress < 0.4 and not ply:OnGround()

			if longjump then
				CETS_DoJump(ply)
			else
				ply.jumpmod_keypress = CurTime()
			end
		end

		if SERVER and key == IN_BACK and not ply.jumpmodule_can_use and not played_sound and ply.CETS_LongJumpBoost then
			ply:SetVelocity(-ply.CETS_LongJumpBoost)
			ply.CETS_LongJumpBoost = nil

			played_sound = true
			ply:EmitSound("hl1/fvox/buzz.wav", 100, 100)
		end
	end)

	hook.Add("OnPlayerHitGround", "CETS_LongJumpUpgrade", function(ply, water, float, speed)
		if not ply:GetNWBool("HasLongJump", false) then return end
		if water then return end

		ply.jumpmodule_can_use = true
		played_sound = nil
	end)

	hook.Add("PlayerDeath", "CETS_LongJumpRemove", function(ply)
		ply:SetNWBool("HasLongJump", false)
		ply.jumpmodule_can_use = nil
		ply.jumpmod_keypress = nil
	end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//KNEEGGER
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("cets_remove_advancedknees", function(ply)
		if not IsValid(ply) or not ply:IsPlayer() then return end
		ply:SetNWBool("HasFallDampener", false)
	end)

	hook.Add("EntityTakeDamage", "CETS_KneeReplaceDamage", function(ent, dmginfo)
		if not ent:IsPlayer() then return end
		if not ent:GetNWBool("HasFallDampener", false) then return end

		if dmginfo:IsDamageType(DMG_FALL) then
			dmginfo:SetDamage(0)
			return true
		end
	end)

	hook.Add("PlayerDeath", "CETS_KneeReplaceReset", function(ply)
		ply:SetNWBool("HasFallDampener", false)
	end)

	hook.Add("GetFallDamage", "CETS_KneeReplace", function(ply, speed)
		if ply:GetNWBool("HasFallDampener", false) then
			return 0
		end
	end)

	local FootstepSounds = {
		"player/futureshoes1.wav",
		"player/futureshoes2.wav"
	}

	hook.Add("OnPlayerHitGround", "CETS_KneeReplaceLanding", function(ply, inWater, onFloater, speed)
		if not ply:GetNWBool("HasFallDampener", false) then return end
		if inWater then return true end

		if speed >= 360 then
			ply:EmitSound(FootstepSounds[math.random(#FootstepSounds)], 70, math.random(95, 105))
		end
	end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//ADRENALINE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	hook.Add("PlayerDeath", "CETS_SpeedBoostReset", function(ply)
		timer.Remove("CETS_SpeedBoost_" .. ply:EntIndex())

		if ply.CETS_OriginalWalkSpeed then
			ply:SetWalkSpeed(ply.CETS_OriginalWalkSpeed)
		end

		if ply.CETS_OriginalRunSpeed then
			ply:SetRunSpeed(ply.CETS_OriginalRunSpeed)
		end

		ply.CETS_OriginalWalkSpeed = nil
		ply.CETS_OriginalRunSpeed = nil
		ply:SetNWBool("HasSpeedBoost", false)
	end)
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
	local HeldMoveType = {}
	local HeldLastPos = {}
	local HeldVelocity = {}

	local THROW_SMOOTHING = 0.56
	local MAX_THROW_SPEED = 8192

	hook.Add("PhysgunPickup", "GrabPlayers_AllowPickup", function(ply, ent)
		if GetConVar("cets_grab_players_phys"):GetInt() == 0 then return end
		if ent:IsPlayer() then
			HeldAngles[ent] = ent:GetAngles()
			HeldBy[ent] = ply
			HeldMoveType[ent] = ent:GetMoveType()
			HeldLastPos[ent] = ent:GetPos()
			HeldVelocity[ent] = vector_origin

			ent:SetVelocity(-ent:GetVelocity())
			ent:Freeze(true)
			ent:SetMoveType(MOVETYPE_NONE)
			return true
		end
	end)

	hook.Add("PhysgunDrop", "GrabPlayers_RestoreAngles", function(ply, ent)
		if ent:IsPlayer() and HeldAngles[ent] then
			ent:SetAngles(HeldAngles[ent])
			ent:SetMoveType(HeldMoveType[ent] or MOVETYPE_WALK)
			ent:Freeze(false)

			local throwVel = HeldVelocity[ent] or vector_origin

			if throwVel:Length() > MAX_THROW_SPEED then
				throwVel = throwVel:GetNormalized() * MAX_THROW_SPEED
			end

			ent:SetVelocity(throwVel)

			HeldAngles[ent] = nil
			HeldBy[ent] = nil
			HeldMoveType[ent] = nil
			HeldLastPos[ent] = nil
			HeldVelocity[ent] = nil
		end
	end)

	hook.Add("Think", "GrabPlayers_LookAtHolder", function()
		local ft = FrameTime()
		for ent, holder in pairs(HeldBy) do
			if not IsValid(ent) or not IsValid(holder) then
				if IsValid(ent) then
					ent:Freeze(false)
					ent:SetMoveType(HeldMoveType[ent] or MOVETYPE_WALK)
					HeldMoveType[ent] = nil
				end
				HeldBy[ent] = nil
				HeldLastPos[ent] = nil
				HeldVelocity[ent] = nil
				continue
			end

			local ang = (holder:GetPos() - ent:GetPos()):Angle()
			ang.pitch = 0
			ang.roll = 0
			ent:SetEyeAngles(ang)
			ent:SetAngles(ang)

			if ft > 0 then
				local currentPos = ent:GetPos()
				local rawVel = (currentPos - (HeldLastPos[ent] or currentPos)) / ft
				HeldVelocity[ent] = LerpVector(1 - THROW_SMOOTHING, HeldVelocity[ent] or vector_origin, rawVel)
				HeldLastPos[ent] = currentPos
			end
		end
	end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//PHYSNPC
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local HeldBy = {}
	local HeldLastPos = {}
	local HeldVelocity = {}

	local THROW_SMOOTHING = 0.72
	local MAX_THROW_SPEED = 2048

	hook.Add("PhysgunPickup", "GrabNPCs_AllowPickup", function(ply, ent)
		if GetConVar("cets_better_npc_phys"):GetInt() == 0 then return end
		if ent:IsNPC() then
			HeldBy[ent] = ply
			HeldLastPos[ent] = ent:GetPos()
			HeldVelocity[ent] = vector_origin

			ent:SetVelocity(-ent:GetVelocity())
			ent:SetSchedule(SCHED_NPC_FREEZE)
			return true
		end
	end)

	hook.Add("PhysgunDrop", "GrabNPCs_ThrowVelocity", function(ply, ent)
		if ent:IsNPC() and HeldBy[ent] then
			ent:SetCondition(COND.NPC_UNFREEZE) -- let its AI take back over

			local throwVel = HeldVelocity[ent] or vector_origin

			if throwVel:Length() > MAX_THROW_SPEED then
				throwVel = throwVel:GetNormalized() * MAX_THROW_SPEED
			end

			ent:SetVelocity(throwVel)

			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				phys:SetVelocity(throwVel)
			end

			HeldBy[ent] = nil
			HeldLastPos[ent] = nil
			HeldVelocity[ent] = nil
		end
	end)

	hook.Add("Think", "GrabNPCs_TrackVelocity", function()

		local ft = FrameTime()
		for ent, holder in pairs(HeldBy) do
			if not IsValid(ent) or not IsValid(holder) then
				if IsValid(ent) then
					ent:SetCondition(COND.NPC_UNFREEZE)
				end

				HeldBy[ent] = nil
				HeldLastPos[ent] = nil
				HeldVelocity[ent] = nil
				continue
			end

			if not ent:IsCurrentSchedule(SCHED_NPC_FREEZE) then
				ent:SetSchedule(SCHED_NPC_FREEZE)
			end

			if ft > 0 then
				local currentPos = ent:GetPos()
				local rawVel = (currentPos - (HeldLastPos[ent] or currentPos)) / ft
				HeldVelocity[ent] = LerpVector(1 - THROW_SMOOTHING, HeldVelocity[ent] or vector_origin, rawVel)
				HeldLastPos[ent] = currentPos
			end
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//PLAYERSOCIAL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
//QUAKESOUNDS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	hook.Add("SetupMove", "QuakeLandSounds", function(ply, mv)
		if not IsValid(ply) or not ply:Alive() then return end
		if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
		if GetConVar("cets_quake_jump_sounds"):GetInt() == 0 then return end

		local jumped = mv:KeyPressed(IN_JUMP)

		if jumped and ply:OnGround() then
			ply.Jumping = true
			ply:EmitSound("hl1/player/PLYRJMP8.WAV", 65, 100)
		end
	end)


	hook.Add("OnPlayerHitGround", "QuakeFallSounds", function(ply, inWater, onFloater, speed)
		if not IsValid(ply) or not ply:Alive() then return end
		if inWater then return end
		if speed < 256 then return end
		if GetConVar("cets_quake_jump_sounds"):GetInt() == 0 then return end

		timer.Simple(0, function()
			if not IsValid(ply) then return end
			if ply.TookFallDamage then
				ply:EmitSound("hl1/player/LAND2.WAV", 65, 100)
			else
				ply:EmitSound("hl1/player/LAND.WAV", 65, 100)
			end

			ply.TookFallDamage = false
		end)
	end)

	hook.Add("EntityTakeDamage", "DetectFallDamage", function(ent, dmg)
		if GetConVar("cets_quake_jump_sounds"):GetInt() == 0 then return end
		if not ent:IsPlayer() then return end

		if dmg:IsFallDamage() then
			ent.TookFallDamage = true
		end
	end)

	hook.Add("EntityEmitSound", "MuteDefaultSounds", function(data)
		if GetConVar("cets_quake_burn_sounds"):GetInt() == 0 then return end
		local snd = string.lower(data.SoundName)

		if snd:find("player/pl_burnpain1.wav") or snd:find("player/pl_burnpain2.wav") or snd:find("player/pl_burnpain3.wav") then return false end
	end)

	hook.Add("Think", "QuakeOnFire", function()
		if GetConVar("cets_quake_burn_sounds"):GetInt() == 0 then return end
		for _, ply in ipairs(player.GetAll()) do
			if not IsValid(ply) or not ply:Alive() then continue end

			if ply:IsOnFire() then
				if not ply.NextFireSound or CurTime() >= ply.NextFireSound then
					ply:EmitSound("hl1/player/LBURN" .. math.random(1, 2) .. ".WAV", 65, 100)
					ply.NextFireSound = CurTime() + 0.4
				end
			else
				ply.NextFireSound = nil
			end
		end
	end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//NUKECOMMANDSOUNDS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	cvars.AddChangeCallback("cets_spawnable_nuke", function(name, old, new)
		if tonumber(new) == 1 && GetConVar("cets_spawnable_nuke_cvar_sound"):GetInt() == 1 then
				sound.Play("friends/cvar_nuke_activate.wav", Vector(0,0,0))
			end
	end, "NukeSoundCvar")
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
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//WINDSOUNDS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local windSound
	local targetVolume = 0
	local currentVolume = 0
	local windFile = "player/fling_whoosh.wav"

	CreateClientConVar("cets_falling_wind", "1", true, false)

	local function StopWindSound()
		if windSound then
			windSound:Stop()
			windSound = nil
		end

		currentVolume = 0
		targetVolume = 0
	end

	hook.Add("Think", "FallingWindSound", function()
		local ply = LocalPlayer()

		if not IsValid(ply) or not ply:Alive() then
			StopWindSound()
			return
		end

		if not GetConVar("cets_falling_wind"):GetBool() then
			StopWindSound()

		elseif ply:GetMoveType() == MOVETYPE_NOCLIP then
			StopWindSound()

		else
			local velocity = ply:GetVelocity()
			local speed = velocity:Length()

			if speed > 490 and not ply:IsOnGround() then
				targetVolume = math.Clamp((speed - 490) / 800, 0, 1)

				if not windSound then
					windSound = CreateSound(ply, windFile)
					windSound:PlayEx(0, 100)
				end
			else
				StopWindSound()
			end
		end

		currentVolume = Lerp(FrameTime() * 3, currentVolume, targetVolume)

		if windSound then
			windSound:ChangeVolume(currentVolume, 0)
			windSound:ChangePitch(100 + currentVolume * 50, 0)

			if currentVolume <= 0.01 then
				StopWindSound()
			end
		end
	end)
end