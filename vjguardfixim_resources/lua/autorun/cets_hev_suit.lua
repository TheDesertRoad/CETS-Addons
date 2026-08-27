if CLIENT then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local HEV = false
local HEVModel = nil
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CETS_AuxPower then
	CETS_AuxPower.HUDActive = false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local HEV_START = 0
local HEV_END = 0

local FadeStarted = false
local HUDReturned = false
local PlayedSounds = {}
local LastSuitState = false
local WasAlive = true

local TrackedSuitItems = {}
local SUIT_PICKUP_DISTANCE = 48

local MODEL = "models/weapons/addon/v_hands_anim.mdl"
local ANIMATION = "admire"

local FADE_START = 11
local FADE_IN_TIME = 0.5
local FADE_OUT_TIME = 0.2
local HUD_RETURN_TIME = 11.3
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local SOUNDS = {
	{
		time = 1.0,
		sound = "player/cets_hev_hand_admire.wav"
	},

	{
		time = 3.6,
		sound = "player/cets_hev_helmet_handling.wav"
	},

	{
		time = 11.2,
		sound = "hl1/fvox/fuzz.wav"
	},

	{
		time = 11.3,
		sound = "hl1/fvox/fuzz.wav"
	},

	{
		time = 11.4,
		sound = "items/suitchargeok1.wav"
	},

	{
		time = 11.45,
		sound = "hl1/fvox/hev_logon_hl2.wav",
		cvar = "cl_cets_custom_hev_voice"
	},

	{
		time = 22,
		sound = "hl1/fvox/powerarmor_on.wav",
		cvar = "cl_cets_custom_hev_voice"
	},

	{
		time = 26,
		sound = "hl1/fvox/atmospherics_on.wav",
		cvar = "cl_cets_custom_hev_voice"
	},

	{
		time = 30.5,
		sound = "hl1/fvox/vitalsigns_on.wav",
		cvar = "cl_cets_custom_hev_voice"
	},

	{
		time = 33.5,
		sound = "hl1/fvox/weaponselect_on.wav",
		cvar = "cl_cets_custom_hev_voice"
	},

	{
		time = 37.5,
		sound = "hl1/fvox/munitionview_on.wav",
		cvar = "cl_cets_custom_hev_voice"
	},

	{
		time = 41,
		sound = "hl1/fvox/communications_on.wav",
		cvar = "cl_cets_custom_hev_voice"
	},

	{
		time = 44.5,
		sound = "hl1/fvox/safe_day.wav",
		cvar = "cl_cets_custom_hev_voice"
	}

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local HEVSoundSequenceActive = false
local HEVSoundStart = 0

local HEVPickupGeneration = 0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HEVEnabled()
	local cvar = GetConVar("cl_cets_custom_hev_wear")

	if not cvar then
		return true
	end

	return cvar:GetBool()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function IsSoundAllowed(soundData)
	if not soundData.cvar then
		return true
	end

	local cvar = GetConVar(soundData.cvar)

	if not cvar then
		return false
	end

	return cvar:GetBool()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function RestoreViewModel()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local vm = ply:GetViewModel()

	if IsValid(vm) then
		vm:SetNoDraw(false)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function StopHEV()
	HEV = false

	if CETS_AuxPower then
		CETS_AuxPower.HUDActive = false
	end

	FadeStarted = false
	HUDReturned = false

	HEV_START = 0
	HEV_END = 0

	PlayedSounds = {}

	HEVSoundSequenceActive = false
	HEVSoundStart = 0

	HEVPickupGeneration = HEVPickupGeneration + 1

	if IsValid(HEVModel) then
		HEVModel:Remove()
		HEVModel = nil
	end

	RestoreViewModel()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function StartHEVSoundSequence()
	HEVSoundSequenceActive = true
	HEVSoundStart = CurTime()

	PlayedSounds = {}
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function UpdateHEVSounds(ply)
	if not HEVSoundSequenceActive then
		return
	end

	if not HEVEnabled() then
		HEVSoundSequenceActive = false
		return
	end

	if not IsValid(ply) then
		HEVSoundSequenceActive = false
		return
	end

	if not ply:Alive() then
		HEVSoundSequenceActive = false
		return
	end

	local elapsed = CurTime() - HEVSoundStart

	for id, soundData in ipairs(SOUNDS) do
		if not PlayedSounds[id] and elapsed >= soundData.time then
			PlayedSounds[id] = true

			if IsSoundAllowed(soundData) then
				ply:EmitSound(soundData.sound)
			end
		end
	end

	if #SOUNDS > 0 and PlayedSounds[#SOUNDS] then
		HEVSoundSequenceActive = false
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function StartHEV()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not HEVEnabled() then
		return
	end

	if not ply:Alive() then
		return
	end

	if HEV then
		return
	end

	HEVPickupGeneration = HEVPickupGeneration + 1

	HEV = true

	FadeStarted = false
	HUDReturned = false

	StartHEVSoundSequence()

	local vm = ply:GetViewModel()

	if IsValid(vm) then
		vm:SetNoDraw(true)
	end

	if IsValid(HEVModel) then
		HEVModel:Remove()
		HEVModel = nil
	end

	HEVModel = ClientsideModel(
		MODEL,
		RENDERGROUP_VIEWMODEL
	)

	if not IsValid(HEVModel) then
		StopHEV()
		return
	end

	HEVModel:SetNoDraw(true)

	local sequence = HEVModel:LookupSequence(ANIMATION)

	if sequence < 0 then
		StopHEV()
		return
	end

	HEVModel:ResetSequence(sequence)
	HEVModel:SetCycle(0)
	HEVModel:SetPlaybackRate(1)

	local duration = HEVModel:SequenceDuration(sequence)

	HEV_START = CurTime()
	HEV_END = HEV_START + duration
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function TrackSuitItems(ply)
	if not HEVEnabled() then
		return
	end

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		return
	end

	local suits = ents.FindByClass("item_suit")

	for _, ent in ipairs(suits) do
		if IsValid(ent) then
			local distance = ply:GetPos():Distance(ent:GetPos())

			if distance <= SUIT_PICKUP_DISTANCE then
				TrackedSuitItems[ent] = {
					position = ent:GetPos(),
					time = CurTime(),
					generation = HEVPickupGeneration
				}
			end
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityRemoved", "HEV_ItemSuitPickup", function(ent)
	if ent:GetClass() ~= "item_suit" then
		return
	end

	if not HEVEnabled() then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		TrackedSuitItems[ent] = nil
		return
	end

	local tracked = TrackedSuitItems[ent]

	if not tracked then
		return
	end

	TrackedSuitItems[ent] = nil

	if tracked.generation ~= HEVPickupGeneration then
		return
	end

	local distance = ply:GetPos():Distance(tracked.position)

	if distance <= SUIT_PICKUP_DISTANCE then
		StartHEV()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function CleanTrackedSuits()
	for ent, data in pairs(TrackedSuitItems) do
		if not IsValid(ent) then
			TrackedSuitItems[ent] = nil
		elseif CurTime() - data.time > 2 then
			TrackedSuitItems[ent] = nil
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("InitPostEntity", "HEV_Init", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	LastSuitState = ply:IsSuitEquipped()
	WasAlive = ply:Alive()

	TrackedSuitItems = {}
	HEVPickupGeneration = HEVPickupGeneration + 1
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("CreateMove", "HEV_FreezeMovement", function(cmd)
	if not HEV then
		return
	end

	if not GetConVar("cl_cets_custom_hev_freeze"):GetBool() then
		return
	end

	if HEVModel and CurTime() < HEV_END then
		cmd:SetForwardMove(0)
		cmd:SetSideMove(0)
		cmd:SetUpMove(0)

		cmd:ClearButtons()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "HEV_Think", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not HEVEnabled() then
		if HEV or HEVSoundSequenceActive then
			StopHEV()
		end

		TrackedSuitItems = {}
		HEVPickupGeneration = HEVPickupGeneration + 1

		WasAlive = ply:Alive()

		return
	end

	local alive = ply:Alive()

	if WasAlive and not alive then
		StopHEV()
		TrackedSuitItems = {}
		HEVPickupGeneration = HEVPickupGeneration + 1
		PlayedSounds = {}
		return
	end

	if not alive then
		StopHEV()
		TrackedSuitItems = {}
		WasAlive = false
		return
	end

	WasAlive = true
	TrackSuitItems(ply)
	CleanTrackedSuits()

	UpdateHEVSounds(ply)

	if HEV and IsValid(HEVModel) then

		if not ply:Alive() then
			StopHEV()
			return
		end

		HEVModel:FrameAdvance(FrameTime())

		local elapsed = CurTime() - HEV_START

		if elapsed >= FADE_START and not FadeStarted then
			FadeStarted = true
			ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), FADE_IN_TIME, FADE_OUT_TIME)
		end

		if elapsed >= HUD_RETURN_TIME and not HUDReturned then
			HUDReturned = true

			if CETS_AuxPower then
				CETS_AuxPower.HUDActive = true
			end
		end
	end

	if HEV and CurTime() >= HEV_END then
		HEV = false

		if IsValid(HEVModel) then
			HEVModel:Remove()
			HEVModel = nil
		end

		RestoreViewModel()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDShouldDraw", "HEV_HideHUD", function(name)
	if not HEV then
		return
	end

	if HUDReturned then
		return
	end

	return false
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PostDrawOpaqueRenderables", "HEV_DrawModel", function()
	if not HEV then
		return
	end

	if not IsValid(HEVModel) then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		return
	end

	local pos = ply:EyePos()
	local ang = ply:EyeAngles()

	pos = pos + ang:Forward() * -14
	pos = pos + ang:Up() * 2

	HEVModel:SetPos(pos)
	HEVModel:SetAngles(ang)
	HEVModel:SetupBones()
	HEVModel:DrawModel()
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("cl_cets_custom_hev_wear", function(name, oldValue, newValue)
	if tonumber(newValue) == 0 then
		StopHEV()

		TrackedSuitItems = {}
		HEVPickupGeneration = HEVPickupGeneration + 1
	end
end, "HEV_MasterSwitch")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("ShutDown", "HEV_Shutdown", function()
	HEV = false
	HEVSoundSequenceActive = false

	PlayedSounds = {}
	TrackedSuitItems = {}

	HEVPickupGeneration = HEVPickupGeneration + 1

	if IsValid(HEVModel) then
		HEVModel:Remove()
		HEVModel = nil
	end

	RestoreViewModel()
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end