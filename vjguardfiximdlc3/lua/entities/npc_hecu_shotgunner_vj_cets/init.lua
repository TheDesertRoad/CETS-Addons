AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.AlliedWithPlayerAllies = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 1
---------------------------------------------------------------------------------------------------------------------------------------------
local mdlHECU = {
	"models/humans/grunt/hgrunt1_mask.mdl",
	"models/humans/grunt/hgrunt2_mask.mdl",
}

local Weapon_None = -1
local Weapon_MP5SD = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 3
ENT.ItemDropsOnDeath_EntityList = {
	"item_armor_c",
	"item_health_vial_c",
}

local sdAlertComb = ENT.SoundTbl_Alert 

local sdAlertCP = ENT.SoundTbl_Alert 

local sdAlertZombies = ENT.SoundTbl_Alert 

local sdAlertCrabs = ENT.SoundTbl_Alert

local sdAlertManhacks = ENT.SoundTbl_Alert 

local sdAlertStrider = ENT.SoundTbl_Alert 

ENT.NextDance = 0
ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	local flags = self:GetSpawnFlags()

	self.Weapon_Rand = 2
	self.Model = mdlHECU
	self:MaleSounds()
	self:Give("weapon_vj_cets_spas12")

	if GetConVar("npc_cets_hecu_voice"):GetInt() == 1 then
		self:HecuSounds()
	else
		self:MaleSounds()
	end
end