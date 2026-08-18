if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
util.AddNetworkString("HL1TrainHUD_State")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local TRAIN_NAMES = {
	[0] = "OFF",
	[1] = "STOPPED",
	[2] = "SPEED 1",
	[3] = "SPEED 2",
	[4] = "SPEED 3",
	[5] = "REVERSE"
}

local lastTrainState = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "HL1TrainHUD_DetectState", function()
	for _, ply in ipairs(player.GetAll()) do
		if not ply:IsFlagSet(FL_ONTRAIN) then
			lastTrainState[ply] = nil
			continue
		end

		local value = ply:GetInternalVariable("m_iTrain")

		if not isnumber(value) then
			continue
		end

		local state = bit.band(value, 0x0F)

		if lastTrainState[ply] ~= state then
			lastTrainState[ply] = state
			local name = TRAIN_NAMES[state] or ("UNKNOWN (" .. state .. ")")

			net.Start("HL1TrainHUD_State")
			net.WriteUInt(state, 3)
			net.Send(ply)

			//ply:PrintMessage(HUD_PRINTCONSOLE, "[TrainHUD] " .. name .. "\n")
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDisconnected", "HL1TrainHUD_StateCleanup", function(ply)
	lastTrainState[ply] = nil
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local TRAIN_OFF      = 0
local TRAIN_STOPPED  = 1
local TRAIN_SPEED1   = 2
local TRAIN_SPEED2   = 3
local TRAIN_SPEED3   = 4
local TRAIN_REVERSE  = 5

local trainState = TRAIN_OFF

local BASE_W = 1920
local BASE_H = 1080
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function ScaleX(x)
	return x * (ScrW() / BASE_W)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function ScaleY(y)
	return y * (ScrH() / BASE_H)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function ScaleFont(size)
	local scale = math.min(ScrW() / BASE_W, ScrH() / BASE_H)

	return math.floor(size * scale)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetHUDColor()
	local path = "resource/ClientScheme.res"

	if not file.Exists(path, "GAME") then
		return Color(255, 220, 0, 220)
	end

	local contents = file.Read(path, "GAME")

	if not contents then
		return Color(255, 220, 0, 220)
	end

	local r, g, b, a = contents:match([["FgColorHud"%s*"(%d+)%s+(%d+)%s+(%d+)%s+(%d+)]])

	if not r then
		return Color(255, 220, 0, 220)
	end

	return Color(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local hudColor = GetHUDColor()
local TrainHUD_FontCache = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetTrainHUDFont(size, glow)
	local scaledSize = ScaleFont(size)

	local name = "HL1TrainHUD_"
		.. scaledSize
		.. (glow and "_Glow" or "")

	if not TrainHUD_FontCache[name] then
		surface.CreateFont(name, {
			font = "CETSTRAIN",
			size = scaledSize,
			weight = 250,
			antialias = true,

			additive = glow or false,

			blursize = glow and ScaleFont(5) or 0,
			scanlines = glow and ScaleFont(2) or 0
		})

		TrainHUD_FontCache[name] = true
	end

	return name
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local TrainPresets = {
	reverse = {
		char = "B",
		size = 86
	},

	stopped = {
		char = "C",
		size = 86
	},

	speed1 = {
		char = "D",
		size = 86
	},

	speed2 = {
		char = "E",
		size = 86
	},

	speed3 = {
		char = "F",
		size = 86
	}
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local TrainStates = {
	[TRAIN_STOPPED] = "stopped",
	[TRAIN_SPEED1]  = "speed1",
	[TRAIN_SPEED2]  = "speed2",
	[TRAIN_SPEED3]  = "speed3",
	[TRAIN_REVERSE] = "reverse"
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("HL1TrainHUD_State", function()
	trainState = net.ReadUInt(3)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDShouldDraw", "HL1TrainHUD_HideDefault", function(name)
	local cvar = GetConVar("cl_cets_custom_train_hud")

	if not cvar or not cvar:GetBool() then
		return
	end

	if name ~= "CHudTrain" then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if ply:IsFlagSet(FL_ONTRAIN) then
		return false
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local glowAlpha = 255
local lastTrainInput = CurTime()
local wasOnTrain = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("KeyPress", "HL1TrainHUD_GlowInput", function(ply, key)
	if ply ~= LocalPlayer() then
		return
	end

	if not ply:IsFlagSet(FL_ONTRAIN) then
		return
	end

	if key == IN_FORWARD or key == IN_BACK then
		lastTrainInput = CurTime()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "HL1TrainHUD_GlowTrainInteraction", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		wasOnTrain = false
		return
	end

	local onTrain = ply:IsFlagSet(FL_ONTRAIN)

	if onTrain and not wasOnTrain then
		lastTrainInput = CurTime()
		glowAlpha = 255
	end

	wasOnTrain = onTrain
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "HL1TrainHUD_Draw", function()
	local cvar = GetConVar("cl_cets_custom_train_hud")

	if not cvar or not cvar:GetBool() then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:IsFlagSet(FL_ONTRAIN) then
		return
	end

	local stateName = TrainStates[trainState]

	if not stateName then
		return
	end

	local preset = TrainPresets[stateName]

	if not preset then
		return
	end

	local x = ScaleX(86.4)
	local y = ScaleY(540)

	local boxW = ScaleX(100)
	local boxH = ScaleY(128)

	local boxX = x - boxW * 0.5
	local boxY = y - boxH * 0.5

	local idleTime = CurTime() - lastTrainInput

	if idleTime <= 2 then
		glowAlpha = 255
	else
		local fadeTime = 2

		local fadeProgress = math.Clamp((idleTime - 2) / fadeTime, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	draw.RoundedBox(ScaleX(8), boxX, boxY, boxW, boxH, Color(0, 0, 0, 100))

	if glowAlpha > 0 then
		draw.SimpleText(preset.char, GetTrainHUDFont(preset.size, true), x, y, Color(hudColor.r, hudColor.g, hudColor.b, glowAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(preset.char, GetTrainHUDFont(preset.size, false), x, y, hudColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end