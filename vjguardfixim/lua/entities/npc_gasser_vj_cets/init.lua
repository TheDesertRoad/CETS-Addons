AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/combine_gasser.mdl"}
ENT.StartHealth = 100
ENT.Weapon_Accuracy = 2
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 0.82 -- Time until the grenade is released

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.GrenadeAttackEntity = "obj_vj_gasser_extractor" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.ThrowGrenadeChance = 1 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackMinDistance = 100 -- Min distance it can throw a grenade
ENT.GrenadeAttackMaxDistance = 1500 -- Max distance it can throw a grenade

ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_oicw")

	self.gascan = ents.Create("obj_vj_cets_gascan_x2")
	self.gascan:SetPos( self:GetPos() + self:GetForward() * 16 + self:GetUp() * 52 + self:GetRight() * 6 )
	self.gascan:SetAngles( self:GetAngles() + Angle(0,0,-90) )
	self.gascan:SetOwner(self)
	self.gascan:SetParent(self, self:LookupAttachment( "zipline" ))
	self.gascan:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.gascan:Spawn()
	self.gascan:Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local oicw = ents.Create("weapon_vj_cets_oicw")
		oicw:SetPos(att.Pos)
		oicw:SetAngles(att.Ang)
		oicw:Spawn()
	end
end