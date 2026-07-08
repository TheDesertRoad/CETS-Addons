AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 200

local Weapon_None = -1
local Weapon_MP5K = 1
local Weapon_Shotgun = 2

local mdlNormal = {
	"models/humans/conscripts_heavy/male_02.mdl",
	"models/humans/conscripts_heavy/male_07.mdl",
	"models/humans/conscripts_heavy/male_masked.mdl",
}

ENT.Weapon_Rand = Weapon_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Weapon_Rand = 1
	self.Model = mdlNormal
	self:MaleSounds()
	self:Give("weapon_vj_cets_hmg")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetBodygroup( 1, math.random( 0, 3 ) )
	self:SetBodygroup( 2, math.random( 0, 3 ) )
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
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local hmg = ents.Create("weapon_vj_cets_hmg")
		hmg:SetPos(att.Pos)
		hmg:SetAngles(att.Ang)
		hmg:Spawn()
	end
end