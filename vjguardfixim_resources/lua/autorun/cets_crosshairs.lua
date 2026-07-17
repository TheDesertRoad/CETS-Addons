if SERVER then return end

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

local hudColor = GetHUDColor()
		
r = hudColor.r
g = hudColor.g
b = hudColor.b

local glowAlpha = 255

local FontCache = {}

local function GetCrosshairFont(size)
	local name = "WeaponCrosshair_" .. size

	if not FontCache[name] then
		surface.CreateFont(name, {
			font = "CETSCROSSHAIRS", -- Change to your font
			size = size,
			weight = 500,
			antialias = true
		})

		FontCache[name] = true
	end

	return name
end

local Presets = {
	alien = {
		char = "l",
		size = 16,
		color = Color(r, g, b, alpha)
	},

	alien_shoot = {
		char = "m",
		size = 16,
		color = Color(r, g, b, alpha)
	},

	pistol = {
		char = "c",
		size = 16,
		color = Color(r, g, b, alpha)
	},

	basic = {
		char = "a",
		size = 8,
		color = Color(r, g, b, alpha)
	},

	gauss = {
		char = "h",
		size = 24,
		color = Color(r, g, b, alpha)
	},

	revolver = {
		char = "e",
		size = 12,
		color = Color(r, g, b, alpha)
	},

	physcannon = {
		char = "b",
		size = 16,
		color = Color(r, g, b, alpha)
	},

	shotgun = {
		char = "f",
		size = 16,
		color = Color(r, g, b, alpha)
	},

	smg = {
		char = "d",
		size = 16,
		color = Color(r, g, b, alpha)
	},

	ar2 = {
		char = "k",
		size = 24,
		color = Color(r, g, b, alpha)
	},

	oicw = {
		char = "n",
		size = 24,
		color = Color(r, g, b, alpha)
	},

	rpg = {
		char = "g",
		size = 24,
		color = Color(r, g, b, alpha)
	},

	cross = {
		char = "j",
		size = 16,
		color = Color(r, g, b, alpha)
	},

	egon = {
		char = "i",
		size = 24,
		color = Color(r, g, b, alpha)
	},
}

local WeaponCrosshairs = {
	weapon_crowbar = "basic",
	weapon_stunstick = "basic",
	weapon_physgun = "basic",
	gmod_tool = "basic",

	weapon_frag = "basic",
	weapon_ply_fragnade = "basic",
	weapon_ply_moly = "basic",
	weapon_slam = "basic",
	weapon_ply_comgr = "basic",
	weapon_ply_comgr_a = "basic",
	weapon_ply_comgr_s = "basic",
	weapon_ply_cguard_extractor = "basic",
	weapon_ply_gasser_extractor = "basic",
	weapon_ply_egg = "basic",
	manhack_welder = "basic",

	weapon_physcannon = "physcannon",
	weapon_vj_cets_confetti = "physcannon",
	weapon_vj_cets_confetti_arg = "physcannon",

	weapon_pistol = "pistol",
	weapon_vj_cets_glock = "pistol",

	weapon_ar2 = "ar2",

	weapon_vj_cets_oicw = "oicw",

	weapon_rpg = "rpg",

	weapon_crossbow = "cross",
	weapon_vj_cets_hecusniper = "cross",

	weapon_smg1 = "smg",
	weapon_vj_cets_mp5k = "smg",
	weapon_vj_cets_mp5sd = "smg",
	weapon_flechettegun = "smg",

	weapon_fists = "shotgun",
	weapon_medkit = "shotgun",
	weapon_shotgun = "shotgun",
	weapon_vj_cets_hmg = "shotgun",

	weapon_357 = "revolver",
	weapon_ply_ki_comb1 = "revolver",
	weapon_ply_ki_comb2 = "revolver",

	weapon_vj_cets_tau = "gauss",

	weapon_vj_cets_egon = "egon",

	weapon_ply_snark = "alien",
	weapon_ply_xenbionade = "alien",
	weapon_ply_brickbat = "alien",
	weapon_bugbait = "alien",

	weapon_ply_hornetgun = "alien_shoot",
	weapon_ply_shockroach = "alien_shoot",
}

hook.Add("HUDShouldDraw", "CustomCrosshair", function(name)
	if not GetConVar("cl_cets_custom_crosshairs"):GetBool() then return end
	if name ~= "CHudCrosshair" then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end

	if WeaponCrosshairs[wep:GetClass()] then
		return false
	end
end)

hook.Add("HUDPaint", "DrawCustomCrosshair", function()
	if not GetConVar("cl_cets_custom_crosshairs"):GetBool() then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end

	local presetName = WeaponCrosshairs[wep:GetClass()]
	if not presetName then return end

	local info = Presets[presetName]
	if not info then return end

	draw.SimpleText(info.char, GetCrosshairFont(info.size), ScrW() / 2, ScrH() / 2, info.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)
