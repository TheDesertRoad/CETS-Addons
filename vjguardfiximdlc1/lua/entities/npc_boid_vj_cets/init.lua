AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_boid.mdl"
ENT.StartHealth = 25
ENT.HullType = HULL_TINY
ENT.TurningSpeed = 12
ENT.TurningUseAllAxis = true
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 130
ENT.Aerial_FlyingSpeed_Alerted = 130
ENT.AA_GroundLimit = 400
ENT.AA_MinWanderDist = 300
ENT.IdleAlwaysWander = true
ENT.CanOpenDoors = false
ENT.CanChatMessage = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
ENT.ControllerParams = {
	FirstP_Bone = "bone01",
	FirstP_Offset = Vector(10, 0, 0),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.HasDeathCorpse = true
ENT.HasExtraMeleeAttackSounds = false

ENT.SoundTbl_Idle = {
	"npc/boid/boid_idle1.wav",
	"npc/boid/boid_idle2.wav",
	"npc/boid/boid_idle3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/boid/boid_alert1.wav",
	"npc/boid/boid_alert2.wav",
}

ENT.SoundTbl_Death = {
	"npc/boid/boid_alert2.wav",
	"npc/boid/boid_alert2.wav",
}

ENT.Boid_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(18, 18, 10), Vector(-18, -18, 0))
	self.Boid_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	if !IsValid(Bird_Leader) then
		VJ.Bird_Leader = self
	end

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

	if self.VJ_IsBeingControlled then return end
	local leader = VJ.Bird_Leader
	if IsValid(leader) then
		if leader != self then
			self.DisableWandering = true
			self:AA_MoveTo(leader, true, "Calm", {AddPos=self.Boid_FollowOffsetPos, IgnoreGround=true})
		end
	else
		self.IsGuard = false
		self.DisableWandering = false
		VJ.Bird_Leader = self
	end
end