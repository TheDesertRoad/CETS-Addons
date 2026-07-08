AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_suppressor.mdl"}
ENT.StartHealth = 160
ENT.Weapon_Accuracy = 2
ENT.Weapon_MinDistance = 30 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 900 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 30
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 0.82 -- Time until the grenade is released

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

ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"weapon_ply_comgr",
	"item_battery",
	"item_health_pen",
}

ENT.FootStepSoundPitch = 100
ENT.IdleSoundPitch = 90
ENT.IdleDialogueSoundPitch = 90
ENT.IdleDialogueAnswerSoundPitch = 90
ENT.CombatIdleSoundPitch = 90
ENT.InvestigateSoundPitch = 90
ENT.LostEnemySoundPitch = 90
ENT.AlertSoundPitch = 90
ENT.WeaponReloadSoundPitch = 90
ENT.GrenadeAttackSoundPitch = 90
ENT.OnGrenadeSightSoundPitch = 90
ENT.OnDangerSightSoundPitch = 90
ENT.OnKilledEnemySoundPitch = 90
ENT.AllyDeathSoundPitch = 90
ENT.PainSoundPitch = 90
ENT.DeathSoundPitch = 90

local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_supp_hmg")

	self.wall = ents.Create("obj_vj_cets_generic_shit")
	self.wall:SetModel("models/misc/cube025x075x025.mdl")
	self.wall:SetPos( self:GetPos() + self:GetForward() * 18 + self:GetUp() * 54  + self:GetRight() * -18 )
	self.wall:SetAngles( self:GetAngles())
	self.wall:SetOwner(self)
	self.wall:SetNoDraw( true )
	self.wall:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall:Spawn()
	self.wall:Activate()

	self.wall2 = ents.Create("obj_vj_cets_generic_shit")
	self.wall2:SetModel("models/misc/cube025x075x025.mdl")
	self.wall2:SetPos( self:GetPos() + self:GetForward() * 2 + self:GetUp() * 54  + self:GetRight() * -18 )
	self.wall2:SetAngles( self:GetAngles())
	self.wall2:SetOwner(self)
	self.wall2:SetNoDraw( true )
	self.wall2:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall2:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall2:Spawn()
	self.wall2:Activate()

	self.wall3 = ents.Create("obj_vj_cets_generic_shit")
	self.wall3:SetModel("models/misc/cube025x075x025.mdl")
	self.wall3:SetPos( self:GetPos() + self:GetForward() * 10 + self:GetUp() * 54  + self:GetRight() * -18 )
	self.wall3:SetAngles( self:GetAngles())
	self.wall3:SetOwner(self)
	self.wall3:SetNoDraw( true )
	self.wall3:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall3:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall3:Spawn()
	self.wall3:Activate()

	self.wall4 = ents.Create("obj_vj_cets_generic_shit")
	self.wall4:SetModel("models/misc/cube025x075x025.mdl")
	self.wall4:SetPos( self:GetPos() + self:GetForward() * 10 + self:GetUp() * 48  + self:GetRight() * -18 )
	self.wall4:SetAngles( self:GetAngles())
	self.wall4:SetOwner(self)
	self.wall4:SetNoDraw( true )
	self.wall4:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall4:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall4:Spawn()
	self.wall4:Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	self:CreateGibEntity("physics_prop", "models/weapons/w_ihmg.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ammo = ents.Create("item_ammo_ar2")
		ammo:SetPos(att.Pos)
		ammo:SetAngles(att.Ang)
		ammo:Spawn()
	end
end