AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_spikewall_sized.mdl"}
ENT.StartHealth = 100
ENT.Weapon_Accuracy = 3
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 800 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 50
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 20
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 200 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 12
ENT.MeleeAttackKnockBack_Up2 = 12
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.HasGrenadeAttack = true 

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
	"weapon_ply_comgr",
}

local Weapon_None = -1
local Weapon_HMG = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)

	local flags = self:GetSpawnFlags()

	if bit.band(flags, 64) ~= 0 or self:HasSpawnFlags(64) then
		self.Weapon_Rand = 1
		self:SetSkin(0)
		self:Give("weapon_vj_cets_supp_hmg")

	elseif bit.band(flags, 128) ~= 0 or self:HasSpawnFlags(128) then
		self.Weapon_Rand = 2
		self:SetSkin(1)
		self:Give("weapon_vj_cets_hev_shot")

	else
		if math.random(1,2) == 1 then
			self.Weapon_Rand = 1
			self:SetSkin(0)
			self:Give("weapon_vj_cets_supp_hmg")
		else

			self.Weapon_Rand = 2
			self:SetSkin(1)
			self:Give("weapon_vj_cets_hev_shot")
		end
	end

	self:SetBodygroup( 5, math.random( 0, 3 ) )
	if game.GetGlobalState("gordon_precriminal") == 1 then 
		self.Behavior = VJ_BEHAVIOR_NEUTRAL
		self.IdleAlwaysWander = true
		self.EnemyTouchDetection = true
		self.BecomeEnemyToPlayer = true
		self.AlliedWithPlayerAllies = true
		self.CanReceiveOrders = false
		self.FollowPlayer = false
		self.YieldToAlliedPlayers = false
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
	end

	self.wall = ents.Create("obj_vj_cets_generic_shit")
	self.wall:SetModel("models/misc/cube025x075x025.mdl")
	self.wall:SetPos( self:GetPos() + self:GetForward() * 18 + self:GetUp() * 62  + self:GetRight() * -18 )
	self.wall:SetAngles( self:GetAngles())
	self.wall:SetOwner(self)
	self.wall:SetNoDraw( true )
	self.wall:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall:Spawn()
	self.wall:Activate()

	self.wall2 = ents.Create("obj_vj_cets_generic_shit")
	self.wall2:SetModel("models/misc/cube025x075x025.mdl")
	self.wall2:SetPos( self:GetPos() + self:GetForward() * 2 + self:GetUp() * 60  + self:GetRight() * -18 )
	self.wall2:SetAngles( self:GetAngles())
	self.wall2:SetOwner(self)
	self.wall2:SetNoDraw( true )
	self.wall2:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall2:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall2:Spawn()
	self.wall2:Activate()

	self.wall3 = ents.Create("obj_vj_cets_generic_shit")
	self.wall3:SetModel("models/misc/cube025x075x025.mdl")
	self.wall3:SetPos( self:GetPos() + self:GetForward() * 10 + self:GetUp() * 62  + self:GetRight() * -18 )
	self.wall3:SetAngles( self:GetAngles())
	self.wall3:SetOwner(self)
	self.wall3:SetNoDraw( true )
	self.wall3:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall3:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall3:Spawn()
	self.wall3:Activate()

	self.wall4 = ents.Create("obj_vj_cets_generic_shit")
	self.wall4:SetModel("models/misc/cube025x075x025.mdl")
	self.wall4:SetPos( self:GetPos() + self:GetForward() * 10 + self:GetUp() * 52  + self:GetRight() * -18 )
	self.wall4:SetAngles( self:GetAngles())
	self.wall4:SetOwner(self)
	self.wall4:SetNoDraw( true )
	self.wall4:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall4:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall4:Spawn()
	self.wall4:Activate()

	self.wall5 = ents.Create("obj_vj_cets_generic_shit")
	self.wall5:SetModel("models/misc/cube025x075x025.mdl")
	self.wall5:SetPos( self:GetPos() + self:GetForward() * 18 + self:GetUp() * 52  + self:GetRight() * -18 )
	self.wall5:SetAngles( self:GetAngles())
	self.wall5:SetOwner(self)
	self.wall5:SetNoDraw( true )
	self.wall5:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall5:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall5:Spawn()
	self.wall5:Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")

	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE && self.VJCE_NPC.Spik_HasManhack then
			self.VJCE_NPC:Spik_DeployManhack()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()

	if self.Weapon_Rand == 1 then
		self:CreateGibEntity("physics_prop", "models/weapons/w_ihmg.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local ammo = ents.Create("item_ammo_ar2")
			ammo:SetPos(att.Pos)
			ammo:SetAngles(att.Ang)
			ammo:Spawn()
		end
	else
		self:CreateGibEntity("physics_prop", "models/weapons/w_ishotgun.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local ammo = ents.Create("item_ammo_ar2")
			ammo:SetPos(att.Pos)
			ammo:SetAngles(att.Ang)
			ammo:Spawn()
		end
	end
end