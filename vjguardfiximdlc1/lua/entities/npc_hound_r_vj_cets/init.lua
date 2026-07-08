AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_rhoundeye.mdl"
ENT.StartHealth = GetConVar("sk_cets_houndr_health"):GetInt()
ENT.HullType = HULL_WIDE_SHORT
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AlliedWithPlayerAllies = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Blue"
ENT.BloodDecal = "VJ_CETS_BBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanChatMessage = false

ENT.CanEat = true
ENT.EatCooldown = 30 

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {"vjseq_flinch_small"}

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HoundEye.Head",
    FirstP_Offset = Vector(4, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	local allies = {}
	local alliesNum = 0
	local isPassive = self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE
	local myClass = self:GetClass()
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), dist or 800)) do
		local entData = ent:GetTable()
		if ent != self && entData.IsVJBaseSNPC && entData.CanReceiveOrders && ent:Alive() && (ent:GetClass() == myClass or (ent:Disposition(self) == D_LI or entData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE)) then
			if isPassive then
				if entData.Behavior == VJ_BEHAVIOR_PASSIVE or entData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
					alliesNum = alliesNum + 1
					allies[alliesNum] = ent
				end
			else
				alliesNum = alliesNum + 1
				allies[alliesNum] = ent
			end
		end
	end

	if status == "Init" then
		if self.HasSounds && self.HasMeleeAttackSounds then
			VJ.EmitSound(self, "npc/houndeye/he_blast" .. math.random(1, 3) .. ".wav", 100, math.random(80, 100))
		end

		if alliesNum == 0 then
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 700, 16, 0, Color(255, 130, 255))
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 300, 32, 0, Color(255, 130, 255))

			VJ.ApplyRadiusDamage(self, self, self:GetPos(), 400, 15, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=30})

		elseif alliesNum == 1 then
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 700, 16, 0, Color(255, 100, 255))
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 300, 32, 0, Color(255, 100, 255))

			VJ.ApplyRadiusDamage(self, self, self:GetPos(), 400, 30, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=60})

		elseif alliesNum == 2 then
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 700, 16, 0, Color(255, 70, 255))
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 300, 32, 0, Color(255, 70, 255))

			VJ.ApplyRadiusDamage(self, self, self:GetPos(), 400, 45, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=90})

		elseif alliesNum == 3 then
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 700, 16, 0, Color(230, 40, 255))
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 300, 32, 0, Color(230, 40, 255))

			VJ.ApplyRadiusDamage(self, self, self:GetPos(), 400, 60, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=120})

		elseif alliesNum > 3 then
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 700, 16, 0, Color(200, 10, 255))
			effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.6, 2, 300, 32, 0, Color(200, 10, 255))

			VJ.ApplyRadiusDamage(self, self, self:GetPos(), 400, 75, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=180})
		end
	end
end