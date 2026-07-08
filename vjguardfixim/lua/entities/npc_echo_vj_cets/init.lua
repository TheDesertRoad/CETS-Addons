AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_grunt.mdl"}
ENT.StartHealth = 50
ENT.Weapon_Accuracy  = 2
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 800 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 50
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 0.82 -- Time until the grenade is released
ENT.GrenadeAttackEntity = "npc_grenade_frag" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations

ENT.CanUseSecondaryOnWeaponAttack = true -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_health_pen",
	"weapon_frag",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_psmg")
	self:SetSkin(math.random(0, 3))

	self.gascan = ents.Create("obj_vj_cets_gascan")
	self.gascan:SetPos( self:GetPos() + self:GetForward() * -8 + self:GetUp() * 68 + self:GetRight() * 0 )
	self.gascan:SetAngles( self:GetAngles() + Angle(0,0,0) )
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
	self:CreateGibEntity("physics_prop", "models/weapons/w_hl2psmg.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local psmg = ents.Create("item_ammo_ar2")
		psmg:SetPos(att.Pos)
		psmg:SetAngles(att.Ang)
		psmg:Spawn()
	end
end