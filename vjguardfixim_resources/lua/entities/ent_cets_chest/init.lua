AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local LootTables = {
	weapons = {
		{class = "weapon_crowbar", weight = 30},
		{class = "weapon_stunstick", weight = 30},
		{class = "weapon_pistol", weight = 30},
		{class = "weapon_smg1", weight = 30},
		{class = "weapon_vj_cets_mp5k", weight = 30},
		{class = "weapon_vj_cets_mp5sd", weight = 30},
		{class = "weapon_vj_cets_glock", weight = 30},

		{class = "weapon_ar2", weight = 20},
		{class = "weapon_vj_cets_oicw", weight = 20},
		{class = "weapon_ply_shockroach", weight = 20},
		{class = "weapon_ply_hornetgun", weight = 20},

		{class = "weapon_shotgun", weight = 10},
		{class = "weapon_357", weight = 10},
		{class = "weapon_physcannon", weight = 10},

		{class = "weapon_crossbow", weight = 5},
		{class = "weapon_rpg", weight = 5},
		{class = "weapon_vj_cets_hmg", weight = 5},
		{class = "weapon_vj_cets_tau", weight = 5},
		{class = "weapon_vj_cets_hecusniper", weight = 5},
	},

	ammo = {
		{class = "item_ammo_pistol", weight = 40},

		{class = "item_ammo_smg1", weight = 35},
		{class = "item_ammo_ar2", weight = 35},

		{class = "item_box_buckshot", weight = 15},
		{class = "item_ammo_357", weight = 15},
		{class = "item_ammo_smg1_grenade", weight = 15},
		{class = "item_ammo_ar2_altfire", weight = 15},

		{class = "item_ammo_crossbow", weight = 10},
		{class = "ent_cets_sniper_ammo", weight = 10},
		{class = "item_rpg_round", weight = 10},
		{class = "item_ammo_pistol_large", weight = 10},
		{class = "item_ammo_smg1_large", weight = 10},
		{class = "item_ammo_ar2_large", weight = 10},
		{class = "item_ammo_357_large", weight = 10},
	},

	utility = {
		{class = "weapon_frag", weight = 40},
		{class = "item_health_pen", weight = 40},
		{class = "weapon_ply_xenbionade", weight = 40},
		{class = "weapon_ply_comgr", weight = 40},
		{class = "weapon_ply_comgr_s", weight = 40},
		{class = "weapon_ply_fragnade", weight = 40},

		{class = "item_healthvial", weight = 25},
		{class = "item_armor_c", weight = 25},
		{class = "item_health_vial_c", weight = 25},
		{class = "ent_cets_mp5grenades", weight = 25},
		{class = "weapon_ply_snark", weight = 25},

		{class = "item_healthkit", weight = 15},
		{class = "ent_cets_atomic_ammo", weight = 15},
		{class = "item_health_kit_c", weight = 15},
		{class = "weapon_ply_moly", weight = 15},
		{class = "weapon_ply_comgr_a", weight = 15},
	}
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props/cs_militia/footlocker01_closed.mdl")
	self:SetSolid(SOLID_VPHYSICS)

	self:EmitSound("hl1/ambience/signalgear1.wav", 40, 25)

	self.Opened = false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function RollWeighted(tbl)
	local totalWeight = 0

	for _, item in ipairs(tbl) do
		totalWeight = totalWeight + item.weight
	end

	local roll = math.Rand(0, totalWeight)

	local current = 0

	for _, item in ipairs(tbl) do
		current = current + item.weight

		if roll <= current then
			return item.class
		end
	end

	return tbl[1].class
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GiveLoot(ply)
	local rewards = {
		RollWeighted(LootTables.weapons),
		RollWeighted(LootTables.ammo),
		RollWeighted(LootTables.utility)
	}

	for _, class in ipairs(rewards) do
		if weapons.Get(class) then
			ply:Give(class)
		else
			local ent = ents.Create(class)

		if IsValid(ent) then
			ent:SetPos(ply:GetPos() + Vector(0, 0, 50))
			ent:Spawn()

			end
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator)
	if self.Opened then return end
	if not IsValid(activator) or not activator:IsPlayer() then return end
	
	self.Opened = true

	self:EmitSound("hl1/items/protect3.wav")
	self:StopSound("hl1/ambience/signalgear1.wav")

	self:GiveLoot(activator)

	self:SetModel("models/props/cs_militia/footlocker01_open.mdl")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:StopSound("hl1/ambience/signalgear1.wav")
end