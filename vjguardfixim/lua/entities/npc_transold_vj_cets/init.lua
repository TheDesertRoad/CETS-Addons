AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_transitionperiod.mdl"}
ENT.StartHealth = 50
ENT.Weapon_Accuracy = 2
ENT.Weapon_MinDistance = 8 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 1500 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 80
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 10
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 200 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.GrenadeAttackEntity = "npc_grenade_frag" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
	"weapon_frag",
}

local Weapon_None = -1
local Weapon_SMG1 = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)

	local flags = self:GetSpawnFlags()

	if bit.band(flags, 64) ~= 0 or self:HasSpawnFlags(64) then
		self.Weapon_Rand = 1
		self:SetSkin(1)
		self:Give("weapon_vj_cets_smg1")

	elseif bit.band(flags, 128) ~= 0 or self:HasSpawnFlags(128) then
		self.Weapon_Rand = 2
		self:SetSkin(0)
		self:Give("weapon_vj_cets_spas12")

	else
		if math.random(1,2) == 1 then
			self.Weapon_Rand = 1
			self:SetSkin(1)
			self:Give("weapon_vj_cets_smg1")
		else

			self.Weapon_Rand = 2
			self:SetSkin(0)
			self:Give("weapon_vj_cets_spas12")
		end
	end

	self:SetBodygroup( 1, math.random( 0, 3 ) )
	self:SetBodygroup( 6, math.random( 0, 3 ) )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 2 then
		if ent:IsPlayer() then
			self:PlaySoundSystem("Alert", sdAlertFreeman)
		return

		elseif ent.VJ_ID_Headcrab or ent:GetClass() == "CLASS_ZOMBIE" then
			self:PlaySoundSystem("Alert", sdAlertZombies)
		return

		elseif ent:GetClass() == "CLASS_FUNGUS" then
			self:PlaySoundSystem("Alert", sdAlertFungal)
		return

		elseif ent:GetClass() == "npc_stinger_vj_cets" or ent:GetClass() == "npc_stinger_r_vj_cets" then
			self:PlaySoundSystem("Alert", sdAlertStinger)
		return

		elseif ent:GetClass() == "npc_alyx" or ent.IsVJBaseSNPC_Human then
			self:PlaySoundSystem("Alert", sdAlertAC2)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
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
	else
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local shotgun = ents.Create("weapon_shotgun")
			shotgun:SetPos(att.Pos)
			shotgun:SetAngles(att.Ang)
			shotgun:Spawn()
		end
	end
end