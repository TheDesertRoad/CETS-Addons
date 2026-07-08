AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 80
ENT.BloodColor = "Red"
ENT.Weapon_Accuracy = GetConVar("sk_csniper_accurancy"):GetInt()
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 40000 -- Max distance it can fire a weapon
ENT.Weapon_Strafe = true
ENT.Weapon_CanCrouchAttack = false
ENT.HasGrenadeAttack = false

ENT.PropInteraction = true
ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial"
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Weapon_Rand = 1
	self.Model = "models/humans/rebel_sniper.mdl"
	self:MaleSounds()
	self:Give("weapon_vj_cets_r_sniper")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.MovementType = VJ_MOVETYPE_STATIONARY
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	self.MovementType = VJ_MOVETYPE_GROUND
	self.IsGuard = false
	self.CallForHelp = true
	self.SightDistance = 6000 
	self:Give("weapon_vj_cets_mp5k")
	self.Weapon_Accuracy = 1
	self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ammo = ents.Create("item_ammo_357")
		ammo:SetPos(att.Pos)
		ammo:SetAngles(att.Ang)
		ammo:Spawn()
	end
end