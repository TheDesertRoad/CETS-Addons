local Gestures = {
}

local ActSounds = {
	zombie = "friends/act_zombie1.wav",
	dance = "friends/act_dance.wav",
	salute = "hl1/events/task_complete.wav",
	laugh = "friends/act_laugh.wav",
	agree = "hl1/events/tutor_msg.wav",
	disagree = "hl1/events/friend_died.wav",
	//dance = "hl1/player/hoot" .. math.random(5, 6) .. ".wav",
}

if SERVER then 
	util.AddNetworkString("Gesture")

	concommand.Add("gesture", function(ply, _, args)
		if not IsValid(ply) or ply:InVehicle() then
			return
		end

		local name = string.lower(args[1] or "")
		local seqName = Gestures[name]

		if ActSounds[name] && GetConVar("cets_dance_music"):GetInt() == 1 then
			surface.PlaySound(ActSounds[name])
		else

		end

		if not seqName then
			ply:ConCommand("act " .. name)
			return
		end

		if ply:LookupSequence(seqName) < 0 then
			ply:ConCommand("act " .. name)
			return
		end

		net.Start("Gesture")
			net.WriteEntity(ply)
			net.WriteString(seqName)
		net.Broadcast()
	end)
end

if CLIENT then
	CreateClientConVar("cets_dance_use_gestures", "1", true, false, "Use gestures instead of acts")

	local function PlayAnim(name)

	if ActSounds[name] && GetConVar("cets_dance_music"):GetInt() == 1 then
		surface.PlaySound(ActSounds[name])
	else

	end

	if GetConVar("cets_dance_use_gestures"):GetBool() and Gestures[name] then
			RunConsoleCommand("gesture", name)
		else
			RunConsoleCommand("act", name)
		end
	end

	hook.Add("PopulateMenuBar", "Dance_MenuBar",function(MenuBar)
		if GetConVar("cets_dance_spawn_menu"):GetInt() == 0 then return end
		local M = MenuBar:AddOrGetMenu("Dance Menu") 

		M:AddCVar("Dance", "act", "dance") 
		M:AddCVar("Robot", "act", "robot") 
		M:AddCVar("Zombie", "act", "zombie") 
		M:AddCVar("Muscle", "act", "muscle") 

		M:AddSpacer() 

		M:AddCVar("Wave", "act", "wave")
		M:AddCVar("Laugh", "act", "laugh")
		M:AddCVar("Bow", "act", "bow")
		M:AddCVar("Cheer", "act", "cheer")
		M:AddCVar("Agree", "act", "agree") 
		M:AddCVar("Disagree", "act", "disagree")

		M:AddSpacer() 

		M:AddCVar("Salute", "act", "salute")
		M:AddCVar("Forward", "act", "forward")
		M:AddCVar("Becon", "act", "becon")
		M:AddCVar("Group", "act", "group")
		M:AddCVar("Halt", "act", "halt")
	end)

	local MenuOpen = false

	local function OpenDanceMenu()
		if MenuOpen then return end
		MenuOpen = true

		local menu = DermaMenu()

		local dances, _ = menu:AddSubMenu("Dances")
		dances:AddOption("Dance", function() PlayAnim("dance") end)
		dances:AddOption("Robot", function() PlayAnim("robot") end)
		dances:AddOption("Zombie", function() PlayAnim("zombie") end)
		dances:AddOption("Muscle", function() PlayAnim("muscle") end)

		local social, _ = menu:AddSubMenu("Expressions")
		social:AddOption("Wave", function() PlayAnim("wave") end)
		social:AddOption("Laugh", function() PlayAnim("laugh") end)
		social:AddOption("Bow", function() PlayAnim("bow") end)
		social:AddOption("Cheer", function() PlayAnim("cheer") end)
		social:AddOption("Agree", function() PlayAnim("agree") end)
		social:AddOption("Disagree", function() PlayAnim("disagree") end)

		local indicate, _ = menu:AddSubMenu("Indicate")
		indicate:AddOption("Salute", function() PlayAnim("salute") end)
		indicate:AddOption("Forward", function() PlayAnim("forward") end)
		indicate:AddOption("Beckon", function() PlayAnim("beckon") end)
		indicate:AddOption("Group", function() PlayAnim("group") end)
		indicate:AddOption("Halt", function() PlayAnim("halt") end)

		menu:AddSpacer()

		menu:AddOption("Exit", function()
			RunConsoleCommand("act", "exittsmenu")
		end)

		menu.OnRemove = function()
			MenuOpen = false
		end

		menu:Open()
		menu:SetPos(ScrW() / 2 - menu:GetWide() / 2,ScrH() / 2 - menu:GetTall() / 2)
	end

	local LastP = false

	hook.Add("Think", "DanceMenuKey", function()
		if GetConVar("cets_dance_context_menu"):GetInt() ~= 1 then return end
		if gui.IsGameUIVisible() or vgui.GetKeyboardFocus() then
			return
		end

		local Pressed = input.IsKeyDown(KEY_P)

		if Pressed and not LastP then
			if not MenuOpen then
			OpenDanceMenu()
			MenuOpen = true
		end
	end

	LastP = Pressed

	end)
end