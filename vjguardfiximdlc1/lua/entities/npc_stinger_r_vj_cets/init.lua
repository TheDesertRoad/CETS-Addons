AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.HasBloodPool = true
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Green"
ENT.BloodDecal = "VJ_CETS_GBlood"
ENT.BloodParticle = "blood_impact_antlion_worker_01"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSkin(1)
	self:SetCollisionBounds(Vector(20, 20, 45),  Vector(-20, -20, 0))

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end