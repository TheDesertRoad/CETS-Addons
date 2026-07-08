AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.AlliedWithPlayerAllies = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 4
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"throw1"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.GrenadeAttackEntity = {"npc_grenade_frag", "obj_vj_cets_extractor"} -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.ThrowGrenadeChance = 2 -- Chance that it will throw the grenade | Set to 1 to throw all the time

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
ENT.ItemDropsOnDeath_EntityList = {
	"item_health_pen",
	"item_healthvial",
	"item_ammo_smg1_grenade",
	"item_ammo_ar2_altfire",
	"weapon_ply_comgr",
	"weapon_frag",
}

local Weapon_SMG = 1
local Weapon_AR2 = 2

local mdlLoyals = {
	"models/humans/ej_loyalists/male_01.mdl",
	"models/humans/ej_loyalists/male_02.mdl",
	"models/humans/ej_loyalists/male_03.mdl",
	"models/humans/ej_loyalists/male_04.mdl",
	"models/humans/ej_loyalists/male_05.mdl",
	"models/humans/ej_loyalists/male_06.mdl",
	"models/humans/ej_loyalists/male_07.mdl",
	"models/humans/ej_loyalists/male_08.mdl",
	"models/humans/ej_loyalists/male_09.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Model = mdlLoyals
	self:MaleSounds()
	if self.Weapon_Rand == 1 or (self.Weapon_Rand == -1 && math.random(1, 2) == 1) then
		self.Weapon_Rand = 1
		self:Give("weapon_vj_cets_smg1")
	else
		self.Weapon_Rand = 2
		self:Give("weapon_vj_cets_ar2")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	if self.Weapon_Rand == 1 then
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local smg1 = ents.Create("weapon_smg1")
			smg1:SetPos(att.Pos)
			smg1:SetAngles(att.Ang)
			smg1:Spawn()
		end

	elseif self.Weapon_Rand == 2 then
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local ar2 = ents.Create("weapon_ar2")
			ar2:SetPos(att.Pos)
			ar2:SetAngles(att.Ang)
			ar2:Spawn()
		end
	end
end