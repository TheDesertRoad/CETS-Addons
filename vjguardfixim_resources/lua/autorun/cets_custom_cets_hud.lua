local DamageIcons = {
	[DMG_RADIATION] = {
		char = "h",
		size = 44
	},

	[DMG_POISON] = {
		char = "c",
		size = 44
	},

	[DMG_PARALYZE] = {
		char = "c",
		size = 44
	},

	[DMG_ACID] = {
		char = "a",
		size = 44
	},

	[DMG_NERVEGAS] = {
		char = "e",
		size = 48
	},

	[DMG_DROWN] = {
		char = "b",
		size = 40
	},

	[DMG_SHOCK] = {
		char = "d",
		size = 44
	},

	[DMG_ENERGYBEAM] = {
		char = "d",
		size = 44
	},

	[DMG_PLASMA] = {
		char = "m",
		size = 44
	},

	[DMG_PHYSGUN] = {
		char = "d",
		size = 44
	},

	[DMG_BURN] = {
		char = "g",
		size = 44
	},

	[DMG_SLOWBURN] = {
		char = "g",
		size = 44
	},

	[DMG_SONIC] = {
		char = "n",
		size = 44
	},

	[DMG_DISSOLVE] = {
		char = "m",
		size = 44
	},
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local EffectIcons = {
	SpeedBoost = {
		char = "s",
		size = 48
	},

	Antitoxin = {
		char = "t",
		size = 48
	},

	BleedImmunity = {
		char = "b",
		size = 48
	}
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CETS_AuxPower = CETS_AuxPower or {}

util.AddNetworkString("CETS_AuxPower_Power")
util.AddNetworkString("CETS_AuxPower_ShowHUD")
util.AddNetworkString("CETS_AuxPower_FlashlightPower")
util.AddNetworkString("CETS_AuxPower_ShowFlashlightHUD")
util.AddNetworkString("CETS_DMG_CustomHUD_DamageIndicator")
util.AddNetworkString("CETS_AuxPower_ShowHUD")
util.AddNetworkString("CETS_AuxPower_HideHUD")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local CETS_DamageIndicatorTypes = {
	DMG_RADIATION,
	DMG_POISON,
	DMG_PARALYZE,
	DMG_ACID,
	DMG_NERVEGAS,
	DMG_DROWN,
	DMG_SHOCK,
	DMG_ENERGYBEAM,
	DMG_PLASMA,
	DMG_PHYSGUN,
	DMG_BURN,
	DMG_SONIC,
	DMG_DISSOLVE,
	DMG_SLOWBURN
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "CETS_DMG_CustomHUD_DamageIndicator", function(target, damageInfo)
	if not IsValid(target) then
		return
	end

	if not target:IsPlayer() then
		return
	end

	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	local damageType = damageInfo:GetDamageType()
	local iconType

	for _, damageFlag in ipairs(CETS_DamageIndicatorTypes) do
		if bit.band(damageType, damageFlag) ~= 0 then
			iconType = damageFlag
			break
		end
	end

	if not iconType then
		return
	end

	net.Start("CETS_DMG_CustomHUD_DamageIndicator")
	net.WriteUInt(iconType, 32)
	net.Send(target)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local auxData = {}

local MAX_POWER = 100
local REGEN_RATE = 10
local REGEN_DELAY = 0.5

local SPRINT_RATE = 8
local FLASHLIGHT_RATE = 2

local OXYGEN_SUPPLY_RATE = 10
local OXYGEN_DRAIN_RATE = 0.07
local OXYGEN_DROWN_DAMAGE_RATE = 1
local OXYGEN_DROWN_RECOVERY_RATE = 2
local OXYGEN_DROWN_DAMAGE_AMOUNT = 10

local FLASHLIGHT_MAX_POWER = 100
local FLASHLIGHT_DRAIN_RATE = 2
local FLASHLIGHT_REGEN_RATE = 8
local FLASHLIGHT_REGEN_DELAY = 0.5
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function CreateData()
	return {
		power = MAX_POWER,
		lastUse = 0,

		expenses = {},

		flashlightPower = FLASHLIGHT_MAX_POWER,
		lastFlashlightUse = 0,

		oxygen = 1,
		oxygenTick = 0,

		drownHealth = 0,
		drownHealthTick = 0,

		hudVisible = false,
		flashlightHUDVisible = false
	}
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetData(ply)
	if not auxData[ply] then
		auxData[ply] = CreateData()
	end

	return auxData[ply]
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.ShowHUD(ply)
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	net.Start("CETS_AuxPower_ShowHUD")
	net.Send(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.HideHUD(ply)
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	if not data.hudVisible then
		return
	end

	data.hudVisible = false

	net.Start("CETS_AuxPower_HideHUD")
	net.Send(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.ShowFlashlightHUD(ply)
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	if data.flashlightHUDVisible then
		return
	end

	data.flashlightHUDVisible = true

	net.Start("CETS_AuxPower_ShowFlashlightHUD")
	net.Send(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.HideFlashlightHUD(ply)
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	if not data.flashlightHUDVisible then
		return
	end

	data.flashlightHUDVisible = false

	net.Start("CETS_AuxPower_HideFlashlightHUD")
	net.Send(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetData(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not auxData[ply] then
		auxData[ply] = CreateData()
	end


	return auxData[ply]
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function SyncPower(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	net.Start("CETS_AuxPower_Power")
	net.WriteFloat(data.power)
	net.Send(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.GetPower(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return 0
	end

	return GetData(ply).power
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.SetPower(ply, amount)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)
	data.power = math.Clamp(amount, 0, MAX_POWER)

	SyncPower(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.AddPower(ply, amount)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return
	end

	CETS_AuxPower.SetPower(ply, GetData(ply).power + amount)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.HasPower(ply, amount)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return false
	end

	amount = amount or 0

	return GetData(ply).power >= amount
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.AddExpense(ply, id, rate)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	data.expenses[id] = rate
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.RemoveExpense(ply, id)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)
	data.expenses[id] = nil
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.HasExpenses(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return false
	end

	return next(GetData(ply).expenses) ~= nil
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function TakeDrowningDamage(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return
	end

	local damage = 10
	local dmginfo = DamageInfo()

	dmginfo:SetDamage(damage)
	dmginfo:SetDamageType(DMG_DROWN)
	dmginfo:SetAttacker(ply)
	dmginfo:SetInflictor(ply)
	dmginfo:SetDamageForce(Vector(0, 0, 0))

	ply:TakeDamageInfo(dmginfo)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function RegenerateOxygen(ply, data)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if data.oxygenTick < CurTime() then
		data.oxygen = math.Clamp(data.oxygen + 0.03, 0, 1)
		data.oxygenTick = CurTime() + 0.14
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function PlayerUnderwater(ply, data)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	CETS_AuxPower.AddExpense(ply, "oxygen", 1)

	if data.power <= 0 or not ply:IsSuitEquipped() then
		if data.oxygenTick < CurTime() then
			if data.oxygen > 0 then
				data.oxygen = math.Clamp(data.oxygen - 0.01, 0, 1)
				data.oxygenTick = CurTime() + 0.07
			else
				TakeDrowningDamage(ply)

				data.drownHealth = data.drownHealth + 10
				data.oxygenTick = CurTime() + 1
			end
		end
	else
		RegenerateOxygen(ply, data)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function PlayerBreathe(ply, data)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	CETS_AuxPower.RemoveExpense(ply, "oxygen")
	RegenerateOxygen(ply, data)

	if data.drownHealth > 0&& data.drownHealthTick < CurTime() then
		local regen = math.min(10, data.drownHealth)
		local health = ply:Health() + regen
		local breathe = math.max(data.drownHealth - 10, 0)

		health = math.Clamp(health, 0, ply:GetMaxHealth())

		if health >= ply:GetMaxHealth() then
			breathe = 0
		end

		ply:SetHealth(health)

		data.drownHealth = breathe
		data.drownHealthTick = CurTime() + 2
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function SyncFlashlightPower(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	net.Start("CETS_AuxPower_FlashlightPower")
	net.WriteFloat(data.flashlightPower)
	net.Send(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "CETS_AuxPower_Initialize", function(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	if not auxData[ply] then
		auxData[ply] = CreateData()
	end

	timer.Simple(1, function()
		if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

		if not IsValid(ply) then
			return
		end

		SyncPower(ply)
		SyncFlashlightPower(ply)
	end)
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSpawn", "CETS_AuxPower_Reset", function(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then
		return
	end

	if not auxData[ply] then
		auxData[ply] = CreateData()
	end

	local data = auxData[ply]

	data.power = MAX_POWER
	data.lastUse = 0
	data.flashlightPower = FLASHLIGHT_MAX_POWER
	data.lastFlashlightUse = 0
	data.expenses = {}
	data.oxygen = 1
	data.oxygenTick = 0
	data.drownHealth = 0
	data.drownHealthTick = 0

	timer.Simple(0.1, function()
		if not IsValid(ply) then
			return
		end

		SyncPower(ply)
		SyncFlashlightPower(ply)
	end)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDisconnected", "CETS_AuxPower_Cleanup", function(ply)
	auxData[ply] = nil
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.GetFlashlightPower(ply)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	if not IsValid(ply) then
		return 0
	end

	return GetData(ply).flashlightPower
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.SetFlashlightPower(ply, amount)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	data.flashlightPower = math.Clamp(amount, 0, 100)

	SyncFlashlightPower(ply)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.AddFlashlightPower(ply, amount)
	if not GetConVar("cets_cl_custom_aux_sys_hud_episodic_flashlight"):GetBool() then return end

	if not IsValid(ply) then
		return
	end

	local data = GetData(ply)

	CETS_AuxPower.SetFlashlightPower(ply, data.flashlightPower + amount)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.HasFlashlightPower(ply, amount)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	if not IsValid(ply) then
		return false
	end

	amount = amount or 0

	return GetData(ply).flashlightPower >= amount
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "CETS_AuxPower_Think", function()
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	local tick = engine.TickInterval()
	local curTime = CurTime()

	local separateFlashlight = GetConVar("cets_cl_custom_aux_sys_hud_episodic_flashlight"):GetBool()

	for _, ply in ipairs(player.GetAll()) do
		if not IsValid(ply) then
			continue
		end

		local data = GetData(ply)

		if not ply:Alive() then
			data.expenses = {}
			continue
		end

		if not ply:IsSuitEquipped() then
			data.expenses = {}
			continue
		end

		local sprinting = false
		local flashlight = false

		if ply:KeyDown(IN_SPEED)&& ply:GetVelocity():Length2D() > 10&& ply:GetMoveType() ~= MOVETYPE_NOCLIP then
			sprinting = true
		end

		if ply:FlashlightIsOn() then
			flashlight = true
		end

		data.expenses["flashlight"] = nil

		if separateFlashlight then
			if flashlight then
				if data.flashlightPower > 0 then
					data.lastFlashlightUse = curTime

					CETS_AuxPower.ShowFlashlightHUD(ply)

					local oldPower = data.flashlightPower

					data.flashlightPower = math.max(data.flashlightPower - FLASHLIGHT_DRAIN_RATE * tick, 0)

					if math.floor(oldPower) ~= math.floor(data.flashlightPower) then
						SyncFlashlightPower(ply)
					end

					if data.flashlightPower <= 0 then
						ply:Flashlight(false)
						flashlight = false
					end
				else
					ply:Flashlight(false)
					flashlight = false
				end
			else
				if curTime - data.lastFlashlightUse >= FLASHLIGHT_REGEN_DELAY then
					local oldPower = data.flashlightPower

					data.flashlightPower = math.min(data.flashlightPower + FLASHLIGHT_REGEN_RATE * tick, FLASHLIGHT_MAX_POWER)

					if math.floor(oldPower) ~= math.floor(data.flashlightPower) then
						SyncFlashlightPower(ply)
					end
				end
			end
		else
			if flashlight&& data.power > 0 then
				CETS_AuxPower.AddExpense(ply, "flashlight", FLASHLIGHT_RATE)
				CETS_AuxPower.ShowHUD(ply)
			else
				CETS_AuxPower.RemoveExpense(ply, "flashlight")
			end
		end

		if sprinting&& data.power > 0 then
			CETS_AuxPower.AddExpense(ply, "sprint", SPRINT_RATE)
			CETS_AuxPower.ShowHUD(ply)
		else
			CETS_AuxPower.RemoveExpense(ply, "sprint")
		end

		if ply:WaterLevel() >= 3 then
			CETS_AuxPower.ShowHUD(ply)

			PlayerUnderwater(ply, data)
		else
			PlayerBreathe(ply, data)
		end

		local totalRate = 0

		for _, rate in pairs(data.expenses) do
			totalRate = totalRate + rate
		end

		if totalRate > 0 then
			local oldPower = data.power

			data.power = math.max(data.power - totalRate * tick, 0)
			data.lastUse = curTime

			if math.floor(oldPower) ~= math.floor(data.power) then
				SyncPower(ply)
			end
		else
			if curTime - data.lastUse >= REGEN_DELAY then
				local oldPower = data.power

				data.power = math.min(data.power + REGEN_RATE * tick, MAX_POWER)

				if math.floor(oldPower) ~= math.floor(data.power) then
					SyncPower(ply)
				end
			end
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("SetupMove", "CETS_AuxPower_BlockSprint", function(ply, mv)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		return
	end

	if not ply:IsSuitEquipped() then
		return
	end

	local data = GetData(ply)

	if data.power <= 0 then
		mv:SetMaxSpeed(ply:GetWalkSpeed())
		mv:SetMaxClientSpeed(ply:GetWalkSpeed())
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSwitchFlashlight", "CETS_AuxPower_BlockFlashlight", function(ply, enabled)
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	if not enabled then
		return
	end

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		return false
	end

	if not ply:IsSuitEquipped() then
		return false
	end

	local data = GetData(ply)
	local separateFlashlight = GetConVar("cets_cl_custom_aux_sys_hud_episodic_flashlight"):GetBool()

	if separateFlashlight then
		if data.flashlightPower <= 0 then
			return false
		end
	else
		if data.power <= 0 then
			return false
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else ---Aqui viene lo bueno uWu
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local HUD_BASE_W = 1920
local HUD_BASE_H = 1080
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HUDScaleX()
	return ScrW() / HUD_BASE_W
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HUDScaleY()
	return ScrH() / HUD_BASE_H
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HUDX(value)
	return value * HUDScaleX()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HUDY(value)
	return value * HUDScaleY()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HS(value)
	return value * HUDScaleX()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HV(value)
	return value * HUDScaleY()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HUDFontSize(value)
	return math.max(math.floor(value * HUDScaleX() + 0.5), 1)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HUDPos(x, y)
	return HUDX(x), HUDY(y)
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

	local r, g, b, a = contents:match([["FgColorHud"%s*"(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"]])

	if not r then
		return Color(255, 220, 0, 220)
	end

	return Color(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function LerpColor(t, from, to)
	return Color(Lerp(t, from.r, to.r), Lerp(t, from.g, to.g), Lerp(t, from.b, to.b), Lerp(t, from.a, to.a))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local HUD_NORMAL_COLOR = GetHUDColor()
local HUD_CRITICAL_COLOR = Color(255, 0, 0, HUD_NORMAL_COLOR.a)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetDynamicHUDColor(value, criticalThreshold)
	return LerpColor(math.Clamp((criticalThreshold - value) / criticalThreshold, 0, 1), HUD_NORMAL_COLOR, HUD_CRITICAL_COLOR)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local healthHUDColor = HUD_NORMAL_COLOR
local suitHUDColor = HUD_NORMAL_COLOR
local auxHUDColor = HUD_NORMAL_COLOR
local flashlightHUDColor = HUD_NORMAL_COLOR
local primaryAmmoHUDColor = HUD_NORMAL_COLOR
local reserveAmmoHUDColor = HUD_NORMAL_COLOR
local secondaryAmmoHUDColor = HUD_NORMAL_COLOR

local glowAlpha = 255
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local FontCache = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetHealthHUDFont(size, glow)
	local scaledSize = HUDFontSize(size)
	local name = "HL2HealthHUD_" .. scaledSize .. (glow&& "_Glow" or "")

	if not FontCache[name] then
		surface.CreateFont(name, {
			font = "CETSTRAIN",
			size = scaledSize,
			weight = 500,
			antialias = true,

			additive = glow or false,
			blursize = glow&& HUDFontSize(5) or 0,
			scanlines = glow&& HUDFontSize(2) or 0
		})

		FontCache[name] = true
	end

	return name
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetHealthHUD_NFont(size, glow)
	local scaledSize = HUDFontSize(size)
	local name = "HL2HealthNHUD_" .. scaledSize .. (glow&& "_Glow" or "")

	if not FontCache[name] then
		surface.CreateFont(name, {
			font = "HalfLife2",
			size = scaledSize,
			weight = 1500,
			antialias = true,

			additive = glow or false,
			blursize = glow&& HUDFontSize(5) or 0,
			scanlines = glow&& HUDFontSize(2) or 0
		})

		FontCache[name] = true
	end

	return name
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetHealthHUD_WFont(size, glow)
	local scaledSize = HUDFontSize(size)
	local name = "HL2HealthWHUD_" .. scaledSize .. (glow&& "_Glow" or "")

	if not FontCache[name] then
		surface.CreateFont(name, {
			font = "D-DIN",
			size = scaledSize,
			weight = 5500,
			antialias = true,

			additive = glow or false,
			blursize = glow&& HUDFontSize(5) or 0,
			scanlines = glow&& HUDFontSize(2) or 0
		})

		FontCache[name] = true
	end

	return name
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetHealthHUD_AFont(size, glow)
	local scaledSize = HUDFontSize(size)
	local name = "HL2HealthAHUD_" .. scaledSize .. (glow&& "_Glow" or "")

	if not FontCache[name] then
		surface.CreateFont(name, {
			font = "CETSAmmo",
			size = scaledSize,
			weight = 60,
			antialias = true,

			additive = glow or false,
			blursize = glow&& HUDFontSize(5) or 0,
			scanlines = glow&& HUDFontSize(2) or 0
		})

		FontCache[name] = true
	end

	return name
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local HEALTH_HUD_ENABLED = GetConVar("cl_cets_custom_hud"):GetInt()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CETS_AuxPower = CETS_AuxPower or {}
CETS_AuxPower.Power = 100

local lastAuxPower = 100
local lastAuxChange = CurTime()
local lastAuxHUDCall = 0
local lastAuxColorPower = nil

local auxHUDVisible = false
local auxHUDExiting = false
local auxHUDSlideStart = 0

local AUX_SLIDE_TIME = 0.16
local AUX_FADE_TIME = 2
local AUX_HIDE_DELAY = 3
local AUX_BOX_SMOOTH_SPEED = 12

local auxHUDBoxHeight = 120
local auxHUDTargetBoxHeight = 120

CETS_AuxPower.FlashlightPower = 100

local lastFlashlightPower = 100
local lastFlashlightChange = CurTime()
local lastFlashlightHUDCall = 0

local lastFlashlightColorPower = nil
local flashlightHUDVisible = false
local flashlightHUDExiting = false
local flashlightHUDSlideStart = 0

local FLASHLIGHT_HIDE_DELAY = 3
local FLASHLIGHT_SLIDE_TIME = 0.16
local FLASHLIGHT_FADE_TIME = 2

local DamageIconsActive = {}

local CachedHUDColor = nil
local CachedScreenW = 0
local CachedScreenH = 0

local MaxDamageIcons = 6

local DamageIconSpacing = 40
local DamageIconRight = 1890
local DamageIconTop = 36
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function UpdateAuxHUDColor()
	local power = math.floor(math.Clamp(CETS_AuxPower.Power, 0, 100))

	if power == lastAuxColorPower then
		return
	end

	lastAuxColorPower = power
	auxHUDColor = GetDynamicHUDColor(power, 25)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function UpdateFlashlightHUDColor()
	local power = math.floor(math.Clamp(CETS_AuxPower.FlashlightPower, 0, 100))

	if power == lastFlashlightColorPower then
		return
	end

	lastFlashlightColorPower = power
	flashlightHUDColor = GetDynamicHUDColor(power, 32)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_AuxPower_ShowHUD", function()
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	if not CETS_AuxPower then
		return
	end

	CETS_AuxPower.ShowHUD()
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_AuxPower_Power", function()
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	local newPower = math.Clamp(net.ReadFloat(), 0, 100)

		if newPower ~= lastAuxPower then
			lastAuxPower = newPower
			CETS_AuxPower.Power = newPower
			lastAuxChange = CurTime()

		UpdateAuxHUDColor()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_AuxPower_FlashlightPower", function()
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end
	local newPower = math.Clamp(net.ReadFloat(), 0, 100)

	if newPower ~= lastFlashlightPower then
		lastFlashlightPower = newPower
		CETS_AuxPower.FlashlightPower = newPower
		lastFlashlightChange = CurTime()

		UpdateFlashlightHUDColor()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_AuxPower_ShowFlashlightHUD", function()
	if not IsValid(LocalPlayer()) then
		return
	end

	if not LocalPlayer():Alive() then
		return
	end

	if not LocalPlayer():IsSuitEquipped() then
		return
	end

	if CETS_AuxPower.FlashlightPower <= 0 then
		return
	end

	lastFlashlightHUDCall = CurTime()

	if not flashlightHUDVisible then
		flashlightHUDVisible = true
		flashlightHUDExiting = false
		flashlightHUDSlideStart = CurTime()

	elseif flashlightHUDExiting then
		flashlightHUDExiting = false
		flashlightHUDSlideStart = CurTime()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.GetPower()
	return CETS_AuxPower.Power
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CETS_AuxPower.ShowHUD()
	if not IsValid(LocalPlayer()) then
		return
	end

	if not LocalPlayer():Alive() then
		return
	end

	if not LocalPlayer():IsSuitEquipped() then
		return
	end

	if CETS_AuxPower.Power <= 0 then
		return
	end

	lastAuxHUDCall = CurTime()

	if not auxHUDVisible then
		auxHUDVisible = true
		auxHUDExiting = false
		auxHUDSlideStart = CurTime()

	elseif auxHUDExiting then
		auxHUDExiting = false
		auxHUDSlideStart = CurTime()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetAUXConsumers()
	local consumers = {}
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return consumers
	end

	if not ply:Alive() then
		return consumers
	end

	if not ply:IsSuitEquipped() then
		return consumers
	end

	local power = CETS_AuxPower.Power

	if ply:KeyDown(IN_SPEED)&& ply:GetVelocity():Length2D() > 10&& ply:GetMoveType() ~= MOVETYPE_NOCLIP then
		if power > 0 then
			table.insert(consumers, "SPRINT")
		end
	end

	if ply:FlashlightIsOn()&& not GetConVar("cets_cl_custom_aux_sys_hud_episodic_flashlight"):GetBool() then
		table.insert(consumers, "FLASHLIGHT")
	end

	if ply:WaterLevel() >= 3 then
		table.insert(consumers, "OXYGEN")
	end

	return consumers
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local LastAuxSprint = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "CETS_AuxPower_SprintSound", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local sprinting = false

	if ply:Alive() && ply:IsSuitEquipped() && CETS_AuxPower.Power > 0 && ply:KeyDown(IN_SPEED) && ply:GetVelocity():Length2D() > 10 && ply:GetMoveType() ~= MOVETYPE_NOCLIP then
		sprinting = true
	end

	if sprinting && not LastAuxSprint then
		ply:EmitSound("player/suit_sprint.wav")
	end

	LastAuxSprint = sprinting
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "CETS_AuxPower_Draw", function()
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then
		return
	end

	if not HEALTH_HUD_ENABLED then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		auxHUDVisible = false
		auxHUDExiting = false
		return
	end

	if not ply:IsSuitEquipped() then
		if auxHUDVisible&& not auxHUDExiting then
			auxHUDExiting = true
			auxHUDSlideStart = CurTime()
		end
	else
		if auxHUDVisible && not auxHUDExiting && CurTime() - lastAuxHUDCall >= AUX_HIDE_DELAY then

			auxHUDExiting = true
			auxHUDSlideStart = CurTime()
		end
	end

	if CETS_AuxPower.Power <= 0 then
		if auxHUDVisible&& not auxHUDExiting then
			auxHUDExiting = true
			auxHUDSlideStart = CurTime()
		end
	end

	if not auxHUDVisible then
		return
	end

	local _, targetY = HUDPos(1920 * 0.076, 1080 * 0.78)
	local startY = targetY + HS(120)

	local progress = math.Clamp((CurTime() - auxHUDSlideStart) / AUX_SLIDE_TIME, 0, 1)

	progress = 1 - math.pow(1 - progress, 3)

	local y

	if auxHUDExiting then
		y = Lerp(progress, targetY, startY)

		if progress >= 1 then
			auxHUDVisible = false
			auxHUDExiting = false
			return
		end
	else
		y = Lerp(progress, startY, targetY)
	end

	local x = select(1, HUDPos(1920 * 0.076, 1080 * 0.78))

	local consumers = GetAUXConsumers()

	local baseBoxW = 250
	local baseBoxH = 120
	local consumerLineH = 20
	local consumerPadding = 10
	local consumerHeight = 10

	if #consumers > 0 then
		consumerHeight = consumerPadding + (#consumers * consumerLineH)
	end

	auxHUDTargetBoxHeight = baseBoxH + consumerHeight

	local smooth = 1 - math.exp(-AUX_BOX_SMOOTH_SPEED * FrameTime())

	auxHUDBoxHeight = Lerp(smooth, auxHUDBoxHeight, auxHUDTargetBoxHeight)

	local boxW = HS(baseBoxW)
	local boxH = HS(auxHUDBoxHeight - 36)

	local boxBottom = y + HS(baseBoxH / 2)
	local boxTop = boxBottom - boxH

	draw.RoundedBox(HS(8), x - boxW / 2.5, boxTop, boxW, boxH, Color(0, 0, 0, 100))

	local glowTime = CurTime() - lastAuxChange
	local glowAlpha = 255

	if glowTime > 1 then
		local fadeProgress = math.Clamp((glowTime - 1) / AUX_FADE_TIME, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	local iconX = x - HS(48)
	local iconY = y - HS(6)

	draw.SimpleText("*", GetHealthHUD_NFont(64, false), iconX, iconY, auxHUDColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	local numberX = x + HS(105)
	local numberY = y + HS(28)

	local powerText = tostring(math.floor(CETS_AuxPower.Power))

	if glowAlpha > 0 then
		draw.SimpleText(powerText, GetHealthHUD_NFont(36, true), numberX, numberY, auxHUDColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(powerText, GetHealthHUD_NFont(36, false), numberX, numberY, auxHUDColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local labelX = x - HS(82)
	local labelY = y + HS(32)

	draw.SimpleText("AUX POWER", GetHealthHUD_WFont(22, false), labelX, labelY, auxHUDColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	local segments = 10
	local segmentGap = 4
	local segmentW = 11
	local segmentH = 8

	local totalW = (segments * segmentW) + ((segments - 1) * segmentGap)

	local startX = x - HS(totalW / 2) +HS(56)
	local segmentY = y

	local power = math.Clamp(CETS_AuxPower.Power, 0, 100)
	local filled = math.ceil((power / 100) * segments)

	for i = 1, segments do
		local segmentX = startX + HS((i - 1) * (segmentW + segmentGap))

		local alpha = 70

		if i <= filled then
			alpha = 255
		end

		draw.RoundedBox(HS(2), segmentX, segmentY, HS(segmentW), HS(segmentH), Color(auxHUDColor.r, auxHUDColor.g, auxHUDColor.b, alpha))
	end

	if #consumers > 0 then
		local consumerX = x - HS(78)

		local consumerStartY = boxTop + HS(consumerPadding) + HS(consumerLineH / 2)

		for i, consumer in ipairs(consumers) do
			local consumerY = consumerStartY + HS((i - 1) * consumerLineH)

			draw.SimpleText( consumer, GetHealthHUD_WFont(18, false), consumerX, consumerY, auxHUDColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "CETS_AuxPower_Flashlight_Draw", function()
	if not GetConVar("cets_cl_custom_aux_sys_hud"):GetBool() then return end

	local glowColor = Color(flashlightHUDColor.r, flashlightHUDColor.g, flashlightHUDColor.b, glowAlpha)

	if not HEALTH_HUD_ENABLED then
		return
	end

	if not GetConVar("cets_cl_custom_aux_sys_hud_episodic_flashlight"):GetBool() then
		flashlightHUDVisible = false
		flashlightHUDExiting = false
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		flashlightHUDVisible = false
		flashlightHUDExiting = false
		return
	end

	if not ply:IsSuitEquipped() then
		flashlightHUDVisible = false
		flashlightHUDExiting = false
		return
	end

	flashlightHUDVisible = true
	flashlightHUDExiting = false

	local x, y = HUDPos(1920 * 0.92, 1080 * 0.06)
	local boxW = HS(210)
	local boxH = HS(90)

	local boxBottom = y + HS(60)
	local boxTop = boxBottom - boxH

	draw.RoundedBox(HS(8), x - boxW / 2.5, boxTop, boxW, boxH, Color(0, 0, 0, 100))

	local glowTime = CurTime() - lastFlashlightChange
	local glowAlpha = 255

	if glowTime > 1 then
		local fadeProgress = math.Clamp((glowTime - 1) / FLASHLIGHT_FADE_TIME, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	local drawColor = Color(flashlightHUDColor.r, flashlightHUDColor.g, flashlightHUDColor.b, 255)
	local glowColor = Color(flashlightHUDColor.r, flashlightHUDColor.g, flashlightHUDColor.b, glowAlpha)

	local numberX = x + HS(80)
	local numberY = y + HS(32)

	local powerText = tostring(math.floor(math.Clamp(CETS_AuxPower.FlashlightPower, 0, 100)))

	if glowAlpha > 0 then
		draw.SimpleText(powerText, GetHealthHUD_NFont(36, true), numberX, numberY, glowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(powerText, GetHealthHUD_NFont(36, false), numberX, numberY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local iconX = x - HS(12)
	local iconY = y

	local flashlightIcon

	if ply:FlashlightIsOn() then
		flashlightIcon = "©"
	else
		flashlightIcon = "®"
	end

	draw.SimpleText(flashlightIcon, GetHealthHUD_NFont(58, false), iconX, iconY, drawColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	draw.SimpleText("FLASHLIGHT", GetHealthHUD_WFont(20, false), x - HS(64), y + HS(35), drawColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	local segments = 10
	local segmentGap = 3
	local segmentW = 7
	local segmentH = 6

	local totalW = (segments * segmentW) + ((segments - 1) * segmentGap)
	local startX = x - HS(totalW / 2) + HS(56)

	local segmentY = y
	local power = math.Clamp(CETS_AuxPower.FlashlightPower, 0, 100)

	local filled = math.ceil((power / 100) * segments)

	for i = 1, segments do
		local segmentX = startX + HS((i - 1) * (segmentW + segmentGap))

		local alpha = 70

		if i <= filled then
			alpha = 255
		end

		draw.RoundedBox(HS(2), segmentX, segmentY, HS(segmentW), HS(segmentH), Color(flashlightHUDColor.r, flashlightHUDColor.g, flashlightHUDColor.b, alpha))
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local lastHealth = 100
local lastHealthChange = CurTime()
local glowAlpha = 0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "HL2HealthHUD_HealthChange", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local health = math.max(ply:Health(), 0)

	if health ~= lastHealth then
		lastHealth = health
		lastHealthChange = CurTime()

		healthHUDColor = GetDynamicHUDColor(health, 25)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local lastSuitCharge = 0
local lastSuitChange = CurTime()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "HL2HUD_SuitChargeChange", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		return
	end

	local suitCharge = math.max(ply:Armor(), 0)

	if suitCharge ~= lastSuitCharge then
		lastSuitCharge = suitCharge
		lastSuitChange = CurTime()

		suitHUDColor = GetDynamicHUDColor(suitCharge, 25)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDShouldDraw", "HL2HUD_HideDefault", function(name)
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	if not HEALTH_HUD_ENABLED then
		return
	end

	if name == "CHudHealth" then
		return false
	end

	if name == "CHudBattery" then
		return false
	end

	if name == "CHudAmmo" or name == "CHudSecondaryAmmo" then
		return false
	end

	if name == "CHudSuitPower" then
		return false
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local healthHUDWasVisible = false
local healthHUDExiting = false
local healthHUDSlideStart = 0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "HL2HealthHUD_Draw", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end


	if not HEALTH_HUD_ENABLED then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		healthHUDWasVisible = false
		healthHUDExiting = false
		return
	end

	if not ply:IsSuitEquipped() then
		healthHUDWasVisible = false
		healthHUDExiting = false
		return
	end

	if not ply:Alive() then
		healthHUDWasVisible = false
		healthHUDExiting = false
		return
	end

	local health = math.max(ply:Health(), 0)

	local x, targetY = HUDPos(1920 * 0.065, 1080 * 0.91)
	local boxW = HS(200)
	local boxH = HS(120)

	local startY = targetY + HS(100)

	if not healthHUDWasVisible then
		healthHUDWasVisible = true
		healthHUDExiting = false
		healthHUDSlideStart = CurTime()
	end

	local slideDuration = 0.16
	local slideProgress =math.Clamp((CurTime() - healthHUDSlideStart) / slideDuration, 0, 1)

	slideProgress = 1 - math.pow(1 - slideProgress, 3)

	local y

	if healthHUDExiting then
		y = Lerp(slideProgress, targetY, startY)

		if slideProgress >= 1 then
			healthHUDWasVisible = false
			healthHUDExiting = false
			return
		end
	else
		y = Lerp(slideProgress, startY, targetY)
	end

	draw.RoundedBox(HS(8), x - boxW / 2.5, y - boxH / 2, boxW, boxH, Color(0, 0, 0, 100))

	local glowTime = CurTime() - lastHealthChange
	local glowAlpha = 255

	if glowTime > 1 then
		local fadeProgress = math.Clamp((glowTime - 1) / 2, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	local drawColor = Color(healthHUDColor.r, healthHUDColor.g, healthHUDColor.b, 255)
	local glowColor = Color(healthHUDColor.r, healthHUDColor.g, healthHUDColor.b, glowAlpha)

	local numberX = x + HS(60)
	local numberY = y - HS(4)

	if glowAlpha > 0 then
		draw.SimpleText(tostring(health), GetHealthHUD_NFont(72, true), numberX, numberY,glowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(tostring(health), GetHealthHUD_NFont(72, false), numberX, numberY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local iconX = x - HS(4)
	local iconY = y - HS(6)

	draw.SimpleText("G", GetHealthHUDFont(62, false), iconX, iconY, drawColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	local labelX = x - HS(64)
	local labelY = y + HS(32)

	draw.SimpleText("HEALTH", GetHealthHUD_WFont(22, false), labelX, labelY, healthHUDColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local suitHUDSlideStart = 0
local suitHUDWasVisible = false
local suitHUDExiting = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "HL2SuitHUD_Draw", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	if not HEALTH_HUD_ENABLED then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		suitHUDWasVisible = false
		suitHUDExiting = false
		return
	end

	if not ply:IsSuitEquipped() then
		suitHUDWasVisible = false
		suitHUDExiting = false
		return
	end

	if not ply:Alive() then
		suitHUDWasVisible = false
		suitHUDExiting = false
		return
	end

	local suitCharge = math.max(ply:Armor(), 0)

	local x, targetY = HUDPos(1920 * 0.180, 1080 * 0.91)

	local boxW = HS(200)
	local boxH = HS(120)

	local startY = targetY + HS(100)

	if suitCharge > 0&& not suitHUDWasVisible then
		suitHUDWasVisible = true
		suitHUDExiting = false
		suitHUDSlideStart = CurTime()
	end

	if suitCharge <= 0&& suitHUDWasVisible&& not suitHUDExiting then
		suitHUDExiting = true
		suitHUDSlideStart = CurTime()
	end

	if not suitHUDWasVisible then
		return
	end

	local slideDuration = 0.16
	local slideProgress = math.Clamp( (CurTime() - suitHUDSlideStart) / slideDuration, 0, 1)

	slideProgress = 1 - math.pow(1 - slideProgress, 3)

	local y

	if suitHUDExiting then
		y = Lerp(slideProgress, targetY, startY)

		if slideProgress >= 1 then
			suitHUDWasVisible = false
			suitHUDExiting = false
			return
		end
	else
		y = Lerp(slideProgress, startY, targetY)
	end

	draw.RoundedBox(HS(8), x - boxW / 2.5, y - boxH / 2, boxW, boxH, Color(0, 0, 0, 100))

	local glowTime = CurTime() - lastSuitChange
	local glowAlpha = 255

	if glowTime > 1 then
		local fadeProgress = math.Clamp((glowTime - 1) / 2, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	local drawColor = Color(suitHUDColor.r, suitHUDColor.g, suitHUDColor.b, 255)
	local glowColor = Color(suitHUDColor.r, suitHUDColor.g, suitHUDColor.b, glowAlpha)

	local numberX = x + HS(60)
	local numberY = y - HS(4)

	if glowAlpha > 0 then
		draw.SimpleText(tostring(suitCharge), GetHealthHUD_NFont(72, true), numberX, numberY, glowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(tostring(suitCharge), GetHealthHUD_NFont(72, false), numberX, numberY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local iconX = x - HS(10)
	local iconY = y - HS(6)

	draw.SimpleText("H", GetHealthHUDFont(62, false), iconX, iconY, drawColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	local labelX = x - HS(64)
	local labelY = y + HS(32)

	draw.SimpleText("CHARGE", GetHealthHUD_WFont(22, false), labelX, labelY, drawColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local primaryClipVisible = false
local primaryClipExiting = false
local primaryClipSlideStart = 0

local reserveHUDVisible = false
local reserveHUDExiting = false
local reserveHUDSlideStart = 0

local reserveHUDMode = nil
local lastReserveAmmo = -1
local lastPrimaryReserveChange = CurTime()

local secondaryVisible = false
local secondaryExiting = false
local secondarySlideStart = 0

local lastPrimaryClip = -1
local lastSecondaryAmmo = -1

local lastPrimaryClipChange = CurTime()
local lastSecondaryChange = CurTime()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local PrimaryAmmoIcons = {
	["AR2"] = {
		char = "F",
		size = 64
	}, 

	["AR2AltFire"] = {
		char = "K",
		size = 64
	}, 

	["Pistol"] = {
		char = "A",
		size = 72
	},

	["SMG1"] = {
		char = "C",
		size = 56
	},

	["357"] = {
		char = "B",
		size = 56
	},

	["XBowBolt"] = {
		char = "H",
		size = 36
	},

	["Buckshot"] = {
		char = "D",
		size = 56
	},

	["RPG_Round"] = {
		char = "I",
		size = 36
	},

	["SMG1_Grenade"] = {
		char = "E",
		size = 56
	},

	["Grenade"] = {
		char = "G",
		size = 48
	},

	["slam"] = {
		char = "V",
		size = 56
	},

	["AlyxGun"] = {
		char = "A",
		size = 56
	},

	["SniperRound"] = {
		char = "C",
		size = 56
	},

	["SniperPenetratedRound"] = {
		char = "C",
		size = 56
	},

	["Gravity"] = {
		char = "Q",
		size = 24
	},

	["Battery"] = {
		char = "Q",
		size = 24
	},

	["Thumper"] = {
		char = "Q",
		size = 24
	},

	["GaussEnergy"] = {
		char = "Q",
		size = 24
	},

	["CombineCannon"] = {
		char = "K",
		size = 56
	},

	["AirboatGun"] = {
		char = "F",
		size = 56
	},

	["StriderMinigun"] = {
		char = "F",
		size = 64
	},

	["HelicopterGun"] = {
		char = "F",
		size = 64
	},

	["9mmRound"] = {
		char = "A",
		size = 72
	},

	["357Round"] = {
		char = "B",
		size = 56
	},

	["BuckshotHL1"] = {
		char = "D",
		size = 56
	},

	["XBowBoltHL1"] = {
		char = "L",
		size = 36
	},

	["MP5_Grenade"] = {
		char = "W",
		size = 56
	},

	["Uranium"] = {
		char = "J",
		size = 40
	},

	["GrenadeHL1"] = {
		char = "N",
		size = 36
	},

	["MP5Gr_CETS"] = {
		char = "W",
		size = 56
	},

	["UraniumEnergy_CETS"] = {
		char = "J",
		size = 40
	},

	["HECGren_CETS"] = {
		char = "N",
		size = 36
	},

	["Molotov_CETS"] = {
		char = "R",
		size = 24
	},

	["Sniper_CETS"] = {
		char = "C",
		size = 56
	},

	["Hornet"] = {
		char = "P",
		size = 36
	},

	["Snark"] = {
		char = "O",
		size = 56
	},

	["Hornet_CETS"] = {
		char = "P",
		size = 36
	},

	["Snarks_CETS"] = {
		char = "O",
		size = 56
	},

	["XenBionade_CETS"] = {
		char = "T",
		size = 42
	},

	["ShockR_CETS"] = {
		char = "Q",
		size = 24
	},

	["TripMine"] = {
		char = "V",
		size = 36
	},

	["Satchel"] = {
		char = "U",
		size = 44
	},

	["12mmRound"] = {
		char = "C",
		size = 56
	},

	["StriderMinigunDirect"] = {
		char = "F",
		size = 64
	},

	["CombineHeavyCannon"] = {
		char = "Q",
		size = 24
	},

	["ComGren_CETS"] = {
		char = "S",
		size = 36
	},

	["ComGren_S_CETS"] = {
		char = "S",
		size = 36
	},

	["ComGren_A_CETS"] = {
		char = "S",
		size = 36
	},

	["RPG_Rocket"] = {
		char = "I",
		size = 36
	},
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local DEFAULT_AMMO_ICON = {
	char = "A",
	size = 46
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetPrimaryAmmoIcon(ply, weapon)
	if not IsValid(ply) then
		return DEFAULT_AMMO_ICON
	end

	if not IsValid(weapon) then
		return DEFAULT_AMMO_ICON
	end

	local ammoType = weapon:GetPrimaryAmmoType()

	if ammoType < 0 then
		return DEFAULT_AMMO_ICON
	end

	local ammoName = game.GetAmmoName(ammoType)

	if not ammoName then
		return DEFAULT_AMMO_ICON
	end

	return PrimaryAmmoIcons[ammoName] or DEFAULT_AMMO_ICON
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ReserveAsPrimaryWeapons = {
	["weapon_egon"] = true,
	["weapon_gauss"] = true,
	["weapon_tripmine"] = true,
	["weapon_vj_cets_egon"] = true,
	["weapon_vj_cets_tau"] = true,
	["weapon_ply_xenbionade"] = true,
	["weapon_ply_snark"] = true,
	["weapon_snark"] = true,
	["weapon_ply_shockroach"] = true,
	["weapon_ply_moly"] = true,
	["weapon_hornetgun"] = true,
	["weapon_ply_hornetgun"] = true,
	["weapon_handgrenade"] = true,
	["weapon_ply_fragnade"] = true,
	["weapon_rpg"] = true,
	["weapon_frag"] = true,
	["weapon_ply_hornetgun"] = true,
	["weapon_ply_comgr"] = true,
	["weapon_ply_comgr_a"] = true,
	["weapon_ply_comgr_s"] = true,
	["weapon_satchel"] = true,
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "HL2PrimaryClipHUD_Draw", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	if not HEALTH_HUD_ENABLED then return end

	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	if not ply:Alive() or not ply:IsSuitEquipped() then
		if primaryClipHUDVisible && not primaryClipHUDExiting then
			primaryClipHUDExiting = true
			primaryClipHUDSlideStart = CurTime()
		end

		if not primaryClipHUDVisible then
			return
		end
	else
		local weapon = ply:GetActiveWeapon()

		if IsValid(weapon) then
			local clip = weapon:Clip1()

			if clip >= 0 then
				if not primaryClipHUDVisible then
					primaryClipHUDVisible = true
					primaryClipHUDExiting = false
					primaryClipHUDSlideStart = CurTime()
				end

				if primaryClipHUDExiting then
					primaryClipHUDExiting = false
					primaryClipHUDSlideStart = CurTime()
				end

				if clip ~= lastPrimaryClip then
					lastPrimaryClip = clip
					lastPrimaryClipChange = CurTime()

					local maxClip = weapon:GetMaxClip1()
					local criticalThreshold = maxClip * 0.30

					primaryAmmoHUDColor = GetDynamicHUDColor(clip, criticalThreshold)
				end
			else
				if primaryClipHUDVisible && not primaryClipHUDExiting then
					primaryClipHUDExiting = true
					primaryClipHUDSlideStart = CurTime()
				end
			end
		else
			if primaryClipHUDVisible && not primaryClipHUDExiting then
				primaryClipHUDExiting = true
				primaryClipHUDSlideStart = CurTime()
			end
		end
	end

	if not primaryClipHUDVisible then
		return
	end

	local x, targetY = HUDPos(1920 * 0.80, 1080 * 0.91)
	local startY = targetY + HS(100)
	local slideDuration = 0.16
	local progress = math.Clamp((CurTime() - primaryClipHUDSlideStart) / slideDuration, 0, 1)

	progress = 1 - math.pow(1 - progress, 3)

	local y

	if primaryClipHUDExiting then
		y = Lerp(progress, targetY, startY)

		if progress >= 1 then
			primaryClipHUDVisible = false
			primaryClipHUDExiting = false
			return
		end
	else
		y = Lerp(progress, startY, targetY)
	end

	local weapon = ply:GetActiveWeapon()
	local clip = 0

	if IsValid(weapon) then
		clip = math.max(weapon:Clip1(), 0)
	end

	local boxW = HS(310)
	local boxH = HS(120)

	draw.RoundedBox(HS(8), x - boxW / 2, y - boxH / 2, boxW, boxH, Color(0, 0, 0, 100))

	local glowTime = CurTime() - lastPrimaryClipChange
	local glowAlpha = 255

	if glowTime > 1 then
		local fadeProgress = math.Clamp((glowTime - 1) / 2, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	local numberX = x + HS(32)
	local numberY = y - HS(4)

	local drawColor = Color(primaryAmmoHUDColor.r, primaryAmmoHUDColor.g, primaryAmmoHUDColor.b, 255)
	local glowColor = Color(primaryAmmoHUDColor.r, primaryAmmoHUDColor.g, primaryAmmoHUDColor.b, glowAlpha)

	if glowAlpha > 0 then
		draw.SimpleText(tostring(clip), GetHealthHUD_NFont(72, true), numberX, numberY, glowColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(tostring(clip), GetHealthHUD_NFont(72, false), numberX, numberY, drawColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	local ammoIcon = GetPrimaryAmmoIcon(ply, weapon)

	local iconChar = ammoIcon.char
	local iconSize = ammoIcon.size

	local iconX = x - HS(48)
	local iconY = y - HS(12)

	draw.SimpleText(iconChar, GetHealthHUD_AFont(iconSize, false), iconX, iconY, drawColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	local labelX = x - HS(130)
	local labelY = y + HS(24)

	draw.SimpleText("AMMUNITION", GetHealthHUD_WFont(22, false), labelX, labelY, drawColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "HL2ReserveClipHUD_Draw", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	if not HEALTH_HUD_ENABLED then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		reserveHUDVisible = false
		reserveHUDExiting = false
		reserveHUDMode = nil
		return
	end

	if not ply:Alive() or not ply:IsSuitEquipped() then
		if reserveHUDVisible and not reserveHUDExiting then
			reserveHUDExiting = true
			reserveHUDSlideStart = CurTime()
		end

		if not reserveHUDVisible then
			return
		end
	else
		local weapon = ply:GetActiveWeapon()

		if not IsValid(weapon) then
			if reserveHUDVisible and not reserveHUDExiting then
				reserveHUDExiting = true
				reserveHUDSlideStart = CurTime()
			end

			if not reserveHUDVisible then
				return
			end
		else
			local ammoType = weapon:GetPrimaryAmmoType()

			if ammoType < 0 then
				if reserveHUDVisible and not reserveHUDExiting then
					reserveHUDExiting = true
					reserveHUDSlideStart = CurTime()
				end

				if not reserveHUDVisible then
					return
				end
			else
				local reserve = math.max(ply:GetAmmoCount(ammoType), 0)

				local newMode

				if ReserveAsPrimaryWeapons[weapon:GetClass()] then
					newMode = "primary"
				else
					newMode = "normal"
				end

				if reserve <= 0 and newMode == "primary" then
					if reserveHUDVisible and not reserveHUDExiting then
						reserveHUDExiting = true
						reserveHUDSlideStart = CurTime()
					end
				else
					if not reserveHUDVisible then
						reserveHUDVisible = true
						reserveHUDExiting = false
						reserveHUDMode = newMode
						reserveHUDSlideStart = CurTime()
					elseif reserveHUDExiting then
						reserveHUDExiting = false
						reserveHUDMode = newMode
						reserveHUDSlideStart = CurTime()
					end

					if reserveHUDMode ~= newMode then
						reserveHUDMode = newMode
						reserveHUDSlideStart = CurTime()
					end
				end


				if reserve ~= lastReserveAmmo then
					lastReserveAmmo = reserve
					lastPrimaryReserveChange = CurTime()

					local maxReserve

					if ReserveAsPrimaryWeapons[weapon:GetClass()] then
						maxReserve = weapon:GetMaxClip1()
					else
						maxReserve = game.GetAmmoMax(ammoType)
					end

					if maxReserve and maxReserve > 0 then
						local criticalThreshold = maxReserve * 0.30

						reserveAmmoHUDColor = GetDynamicHUDColor(reserve, criticalThreshold)
					else
						reserveAmmoHUDColor = HUD_NORMAL_COLOR
					end
				end
			end
		end
	end

	if not reserveHUDVisible then
		return
	end

	local weapon = ply:GetActiveWeapon()

	if not IsValid(weapon) then
		return
	end

	local ammoType = weapon:GetPrimaryAmmoType()

	if ammoType < 0 then
		return
	end

	local reserve = math.max(ply:GetAmmoCount(ammoType), 0)

	local glowTime = CurTime() - lastPrimaryReserveChange
	local glowAlpha = 255

	if glowTime > 1 then
		local fadeProgress = math.Clamp((glowTime - 1) / 2, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	local drawColor = Color(reserveAmmoHUDColor.r, reserveAmmoHUDColor.g, reserveAmmoHUDColor.b, 255)
	local glowColor = Color(reserveAmmoHUDColor.r, reserveAmmoHUDColor.g, reserveAmmoHUDColor.b, glowAlpha)

	if reserveHUDMode == "primary" then
		local targetX, y = HUDPos(1920 * 0.895, 1080 * 0.91)

		local startX = ScrW() + HS(250)
		local slideDuration = 0.16

		local progress = math.Clamp((CurTime() - reserveHUDSlideStart) / slideDuration, 0, 1)

		progress = 1 - math.pow(1 - progress, 3)

		local x

		if reserveHUDExiting then
			x = Lerp(progress, targetX, startX)

			if progress >= 1 then
				reserveHUDVisible = false
				reserveHUDExiting = false
				reserveHUDMode = nil
				return
			end
		else
			x = Lerp(progress, startX, targetX)
		end

		local boxW = HS(310)
		local boxH = HS(120)

		draw.RoundedBox(HS(8), x - boxW / 2, y - boxH / 2, boxW, boxH, Color(0, 0, 0, 100))

		local numberX = x + HS(32)
		local numberY = y - HS(4)

		if glowAlpha > 0 then
			draw.SimpleText(tostring(reserve), GetHealthHUD_NFont(72, true), numberX, numberY, glowColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(tostring(reserve), GetHealthHUD_NFont(72, false), numberX, numberY, drawColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		local ammoIcon = GetPrimaryAmmoIcon(ply, weapon)

		if ammoIcon then
			local iconChar = ammoIcon.char
			local iconSize = ammoIcon.size

			local iconX = x - HS(56)
			local iconY = y - HS(12)

			draw.SimpleText(iconChar, GetHealthHUD_AFont(iconSize, false), iconX, iconY, drawColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local labelX = x - HS(130)
		local labelY = y + HS(24)

		draw.SimpleText("AMMUNITION", GetHealthHUD_WFont(22, false), labelX, labelY, drawColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		return
	end

	local x, targetY = HUDPos(1920 * 0.94, 1080 * 0.91)

	local startY = targetY + HS(100)
	local slideDuration = 0.16

	local progress = math.Clamp((CurTime() - reserveHUDSlideStart) / slideDuration, 0, 1)

	progress = 1 - math.pow(1 - progress, 3)

	local y

	if reserveHUDExiting then
		y = Lerp(progress, targetY, startY)

		if progress >= 1 then
			reserveHUDVisible = false
			reserveHUDExiting = false
			reserveHUDMode = nil
			return
		end
	else
		y = Lerp(progress, startY, targetY)
	end

	local boxW = HS(170)
	local boxH = HS(120)

	draw.RoundedBox(HS(8), x - boxW / 2, y - boxH / 2, boxW, boxH, Color(0, 0, 0, 100))

	local numberX = x
	local numberY = y - HS(4)

	if glowAlpha > 0 then
		draw.SimpleText(tostring(reserve), GetHealthHUD_NFont(72, true), numberX, numberY, glowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(tostring(reserve), GetHealthHUD_NFont(72, false), numberX, numberY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "HL2SecondaryClipHUD_Draw", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	if not HEALTH_HUD_ENABLED then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		secondaryHUDVisible = false
		secondaryHUDExiting = false
		return
	end

	if not ply:Alive() or not ply:IsSuitEquipped() then
		if secondaryHUDVisible and not secondaryHUDExiting then
			secondaryHUDExiting = true
			secondaryHUDSlideStart = CurTime()
		end

		if not secondaryHUDVisible then
			return
		end
	else
		local weapon = ply:GetActiveWeapon()

		if not IsValid(weapon) then
			if secondaryHUDVisible and not secondaryHUDExiting then
				secondaryHUDExiting = true
				secondaryHUDSlideStart = CurTime()
			end

			if not secondaryHUDVisible then
				return
			end
		else
			local ammoType = weapon:GetSecondaryAmmoType()

			if ammoType < 0 then
				if secondaryHUDVisible and not secondaryHUDExiting then
					secondaryHUDExiting = true
					secondaryHUDSlideStart = CurTime()
				end

				if not secondaryHUDVisible then
					return
				end
			else
				local secondary = math.max(ply:GetAmmoCount(ammoType), 0)

				if secondary <= 0 then
					if secondaryHUDVisible and not secondaryHUDExiting then
						secondaryHUDExiting = true
						secondaryHUDSlideStart = CurTime()
					end
				else
					if not secondaryHUDVisible then
						secondaryHUDVisible = true
						secondaryHUDExiting = false
						secondaryHUDSlideStart = CurTime()
					elseif secondaryHUDExiting then
						secondaryHUDExiting = false
						secondaryHUDSlideStart = CurTime()
					end
				end

				if secondary ~= lastSecondaryAmmo then
					lastSecondaryAmmo = secondary
					lastSecondaryChange = CurTime()

					if secondary > 0 then
						local maxSecondary = weapon:GetMaxClip2()

						if maxSecondary and maxSecondary > 0 then
							local criticalThreshold = maxSecondary * 0.30

							secondaryAmmoHUDColor = GetDynamicHUDColor(secondary, criticalThreshold)
						else
							secondaryAmmoHUDColor = HUD_NORMAL_COLOR
						end
					else
						secondaryAmmoHUDColor = HUD_NORMAL_COLOR
					end
				end
			end
		end
	end

	if not secondaryHUDVisible then
		return
	end

	local weapon = ply:GetActiveWeapon()

	if not IsValid(weapon) then
		return
	end

	local ammoType = weapon:GetSecondaryAmmoType()

	if ammoType < 0 then
		return
	end

	local secondary = math.max(ply:GetAmmoCount(ammoType), 0)
	local targetX, y = HUDPos(1920 * 0.875, 1080 * 0.82)

	local startX = ScrW() + HS(250)
	local slideDuration = 0.16

	local progress = math.Clamp((CurTime() - secondaryHUDSlideStart) / slideDuration, 0, 1)

	progress = 1 - math.pow(1 - progress, 3)

	local x

	if secondaryHUDExiting then
		x = Lerp(progress, targetX, startX)

		if progress >= 1 then
			secondaryHUDVisible = false
			secondaryHUDExiting = false
			return
		end
	else
		x = Lerp(progress, startX, targetX)
	end

	local boxW = HS(420)
	local boxH = HS(50)

	draw.RoundedBox(HS(8), x - boxW / 2, y - boxH / 2, boxW, boxH, Color(0, 0, 0, 100))

	local glowTime = CurTime() - lastSecondaryChange
	local glowAlpha = 255

	if glowTime > 1 then
		local fadeProgress = math.Clamp((glowTime - 1) / 2, 0, 1)

		glowAlpha = 255 * (1 - fadeProgress)
	end

	local drawColor = Color(secondaryAmmoHUDColor.r, secondaryAmmoHUDColor.g, secondaryAmmoHUDColor.b, 255)
	local glowColor = Color(secondaryAmmoHUDColor.r, secondaryAmmoHUDColor.g, secondaryAmmoHUDColor.b, glowAlpha)

	local numberX = x + HS(128)
	local numberY = y

	if glowAlpha > 0 then
		draw.SimpleText(tostring(secondary), GetHealthHUD_NFont(36, true), numberX, numberY, glowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleText(tostring(secondary), GetHealthHUD_NFont(36, false), numberX, numberY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local labelX = x - HS(170)
	local labelY = y

	draw.SimpleText("ALT", GetHealthHUD_WFont(22, false), labelX, labelY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local ammoName = game.GetAmmoName(ammoType)
	local ammoIcon = PrimaryAmmoIcons[ammoName]

	if ammoIcon then
		local iconX = x - HS(100)
		local iconY = y
		local iconChar = ammoIcon.char

		if glowAlpha > 0 then
			draw.SimpleText(iconChar, GetHealthHUD_AFont(28, true), iconX, iconY, glowColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(iconChar, GetHealthHUD_AFont(28, false), iconX, iconY, drawColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local DamageIcons = {
	[DMG_RADIATION] = {
		char = "h",
		size = 44
	},

	[DMG_POISON] = {
		char = "c",
		size = 44
	},

	[DMG_PARALYZE] = {
		char = "c",
		size = 44
	},

	[DMG_ACID] = {
		char = "a",
		size = 44
	},

	[DMG_NERVEGAS] = {
		char = "e",
		size = 48
	},

	[DMG_DROWN] = {
		char = "b",
		size = 40
	},

	[DMG_SHOCK] = {
		char = "d",
		size = 44
	},

	[DMG_ENERGYBEAM] = {
		char = "d",
		size = 44
	},

	[DMG_PLASMA] = {
		char = "m",
		size = 44
	},

	[DMG_PHYSGUN] = {
		char = "d",
		size = 44
	},

	[DMG_BURN] = {
		char = "g",
		size = 44
	},

	[DMG_SLOWBURN] = {
		char = "g",
		size = 44
	},

	[DMG_SONIC] = {
		char = "n",
		size = 44
	},

	[DMG_DISSOLVE] = {
		char = "m",
		size = 44
	},
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local StatusIcons = {
	SpeedBoost = {
		char = "j",
		size = 48
	},

	Antitoxin = {
		char = "l",
		size = 48
	},

	BleedImmunity = {
		char = "k",
		size = 48
	},

	LongJump = {
		char = "o",
		size = 36
	},

	NightVision = {
		char = "p",
		size = 36
	},

	LongFall = {
		char = "q",
		size = 48
	},
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local DamageIconsActive = {}

local MaxDamageIcons = 8

local DamageIconSpacing = 80
local DamageIconRight = 1890
local DamageIconTop = 36
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function AddDamageIcon(damageType)
	local info = DamageIcons[damageType]

	if not info then
		return
	end

	local id = "damage_" .. damageType
	local timerName = "CETS_DMG_CustomHUD_Damage_" .. damageType

	for _, icon in ipairs(DamageIconsActive) do
		if icon.id == id then
			timer.Remove(timerName)

			timer.Create(timerName, 1.5, 1, function()
				for i = #DamageIconsActive, 1, -1 do
					if DamageIconsActive[i].id == id then
						table.remove(DamageIconsActive, i)
						break
					end
				end
			end)

			return
		end
	end

	table.insert(DamageIconsActive, {
		id = id,
		char = info.char,
		size = info.size,
		persistent = false
	})

	while #DamageIconsActive > MaxDamageIcons do
		local removed = table.remove(DamageIconsActive, 1)

		if removed and removed.id then
			local damageTypeID = removed.id:match("^damage_(.+)$")

			if damageTypeID then
				timer.Remove("CETS_DMG_CustomHUD_Damage_" .. damageTypeID)
			end
		end
	end

	timer.Remove(timerName)

	timer.Create(timerName, 1.5, 1, function()
		for i = #DamageIconsActive, 1, -1 do
			if DamageIconsActive[i].id == id then
				table.remove(DamageIconsActive, i)
				break
			end
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function AddStatusIcon(id, info)
	if not info then
		return
	end

	for _, icon in ipairs(DamageIconsActive) do
		if icon.id == id then
			return
		end
	end

	table.insert(DamageIconsActive, {
		id = id,
		char = info.char,
		size = info.size,
		persistent = true
	})
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function RemoveStatusIcon(id)
	for i = #DamageIconsActive, 1, -1 do
		if DamageIconsActive[i].id == id then
			table.remove(DamageIconsActive, i)
			return
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local LastStatusUpdate = 0
local StatusUpdateInterval = 0.1

local LastSpeedBoost = false
local LastAntitoxin = false
local LastBleedImmunity = false
local LastLongJump = false
local LastNightVision = false
local LastLongFall = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function UpdateStatusIcons(ply)
	if not IsValid(ply) then
		return
	end

	local speedBoost = ply:GetNWBool("HasSpeedBoost", false)

	if speedBoost ~= LastSpeedBoost then
		LastSpeedBoost = speedBoost

		if speedBoost then
			AddStatusIcon("status_speedboost", StatusIcons.SpeedBoost)
		else
			RemoveStatusIcon("status_speedboost")
		end
	end

	local antitoxin = ply:GetNWBool("HasAntitoxin", false)

	if antitoxin ~= LastAntitoxin then
		LastAntitoxin = antitoxin

		if antitoxin then
			AddStatusIcon("status_antitoxin", StatusIcons.Antitoxin)
		else
			RemoveStatusIcon("status_antitoxin")
		end
	end

	local bleedImmunity = ply:GetNWBool("HasBleedImmunity", false)

	if bleedImmunity ~= LastBleedImmunity then
		LastBleedImmunity = bleedImmunity

		if bleedImmunity then
			AddStatusIcon("status_bleedimmunity", StatusIcons.BleedImmunity)
		else
			RemoveStatusIcon("status_bleedimmunity")
		end
	end

	local longJump = ply:GetNWBool("HasLongJump", false)

	if longJump ~= LastLongJump then
		LastLongJump = longJump

		if longJump then
			AddStatusIcon("status_longjump", StatusIcons.LongJump)
		else
			RemoveStatusIcon("status_longjump")
		end
	end

	local nightVision = ply:GetNWBool("HasNV", false)

	if nightVision ~= LastNightVision then
		LastNightVision = nightVision

		if nightVision then
			AddStatusIcon("status_nightvision", StatusIcons.NightVision)
		else
			RemoveStatusIcon("status_nightvision")
		end
	end

	local longFall = ply:GetNWBool("HasFallDampener", false)

	if longFall ~= LastLongFall then
		LastLongFall = longFall

		if longFall then
			AddStatusIcon("status_longfall", StatusIcons.LongFall)
		else
			RemoveStatusIcon("status_longfall")
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
timer.Create("CETS_DMG_CustomHUD_StatusUpdate", StatusUpdateInterval, 0, function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		if LastSpeedBoost then
			LastSpeedBoost = false
			RemoveStatusIcon("status_speedboost")
		end

		if LastAntitoxin then
			LastAntitoxin = false
			RemoveStatusIcon("status_antitoxin")
		end

		if LastBleedImmunity then
			LastBleedImmunity = false
			RemoveStatusIcon("status_bleedimmunity")
		end

		if LastLongJump then
			LastLongJump = false
			RemoveStatusIcon("status_longjump")
		end

		if LastNightVision then
			LastNightVision = false
			RemoveStatusIcon("status_nightvision")
		end

		if LastLongFall then
			LastLongFall = false
			RemoveStatusIcon("status_longfall")
		end

		return
	end

	UpdateStatusIcons(ply)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local FreezeDamageHUD = {
	id = "damage_freezing",
	char = "f",
	size = 44,
	duration = 1.5
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local FreezeDamageActive = false
local FreezeDamageTimer = "CETS_DMG_CustomHUD_FreezeDamage"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function RemoveFreezeDamageHUD()
	FreezeDamageActive = false

	timer.Remove(FreezeDamageTimer)

	for i = #DamageIconsActive, 1, -1 do
		if DamageIconsActive[i].id == FreezeDamageHUD.id then
			table.remove(DamageIconsActive, i)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function AddFreezeDamageHUD()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() then
		return
	end

	if not HEALTH_HUD_ENABLED then
		return
	end

	if not ply:IsSuitEquipped() then
		return
	end

	if FreezeDamageActive then
		timer.Remove(FreezeDamageTimer)

		timer.Create(FreezeDamageTimer, FreezeDamageHUD.duration, 1, function()
			RemoveFreezeDamageHUD()
		end)

		return
	end

	FreezeDamageActive = true

	table.insert(DamageIconsActive, {
		id = FreezeDamageHUD.id,
		char = FreezeDamageHUD.char,
		size = FreezeDamageHUD.size,
		persistent = false,
		freeze = true
	})

	while #DamageIconsActive > MaxDamageIcons do
		local removed = table.remove(DamageIconsActive, 1)

		if removed and removed.id then
			local damageTypeID = removed.id:match("^damage_(.+)$")

			if damageTypeID then
				timer.Remove("CETS_DMG_CustomHUD_Damage_" .. damageTypeID)
			end

			if removed.id == FreezeDamageHUD.id then
				FreezeDamageActive = false
				timer.Remove(FreezeDamageTimer)
			end
		end
	end

	timer.Remove(FreezeDamageTimer)

	timer.Create(FreezeDamageTimer, FreezeDamageHUD.duration, 1, function()
		RemoveFreezeDamageHUD()
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "CETS_DMG_DrawDamageIndicators", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() or not HEALTH_HUD_ENABLED then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if not ply:Alive() or not ply:IsSuitEquipped() then
		return
	end

	DamageHUDVisible = DamageHUDVisible or false
	DamageHUDExiting = DamageHUDExiting or false
	DamageHUDSlideStart = DamageHUDSlideStart or 0
	DamageHUDBoxWidth = DamageHUDBoxWidth or 0

	if #DamageIconsActive > 0 then
		if not DamageHUDVisible then
			DamageHUDVisible = true
			DamageHUDExiting = false
			DamageHUDSlideStart = CurTime()
		elseif DamageHUDExiting then
			DamageHUDExiting = false
			DamageHUDSlideStart = CurTime()
		end

	elseif DamageHUDVisible and not DamageHUDExiting then
		DamageHUDExiting = true
		DamageHUDSlideStart = CurTime()
	end

	if not DamageHUDVisible then
		return
	end

	local targetX = HUDX(30)
	local targetY = HUDY(64)

	local startX = targetX - HUDX(40)

	local slideTime = 0.16

	local progress = math.Clamp((CurTime() - DamageHUDSlideStart) / slideTime, 0, 1)

	progress = 1 - math.pow(1 - progress, 3)

	local x

	if DamageHUDExiting then
		x = Lerp(progress, targetX, startX)

		if progress >= 1 then
			DamageHUDVisible = false
			DamageHUDExiting = false
			DamageHUDBoxWidth = 0
			return
		end
	else
		x = Lerp(progress, startX, targetX)
	end

	local maxWidth = HUDX(512)
	local boxHeight = HUDY(72)

	local padding = HUDX(40)
	local spacing = HUDX(40)

	local targetWidth = 0

	if #DamageIconsActive > 0 then
		targetWidth = (#DamageIconsActive * spacing) + padding

		targetWidth = math.min(targetWidth, maxWidth)
	end

	local resizeSmooth = 1 - math.exp(-12 * FrameTime())

	DamageHUDBoxWidth = Lerp(resizeSmooth, DamageHUDBoxWidth, targetWidth)

	if DamageHUDBoxWidth <= 0.1 then
		return
	end

	local boxY = targetY - boxHeight * 0.5

	local hudColor = Color(HUD_NORMAL_COLOR.r, HUD_NORMAL_COLOR.g, HUD_NORMAL_COLOR.b, HUD_NORMAL_COLOR.a)

	draw.RoundedBox(HS(8), x, boxY, DamageHUDBoxWidth, boxHeight, Color(0, 0, 0, 100))

	for i, icon in ipairs(DamageIconsActive) do
		local iconX = x + padding + ((i - 1) * spacing)
		local iconY = boxY + boxHeight * 0.5

		local glowFont = GetHealthHUD_AFont(icon.size, true)

		local normalFont = GetHealthHUD_AFont(icon.size, false)

		draw.SimpleText(icon.char, glowFont, iconX, iconY, hudColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(icon.char, normalFont, iconX, iconY, hudColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_DMG_CustomHUD_DamageIndicator", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	local damageType = net.ReadUInt(32)

	AddDamageIcon(damageType)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("ShutDown", "CETS_DMG_CustomHUD_Cleanup", function()
	timer.Remove("CETS_DMG_CustomHUD_StatusUpdate")

	for damageType, _ in pairs(DamageIcons) do
		timer.Remove("CETS_DMG_CustomHUD_Damage_" .. damageType)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("CETS_DMG_FreezingDamageIcon", function()
	if not GetConVar("cl_cets_custom_hud"):GetBool() then
		return
	end

	AddFreezeDamageHUD()
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end