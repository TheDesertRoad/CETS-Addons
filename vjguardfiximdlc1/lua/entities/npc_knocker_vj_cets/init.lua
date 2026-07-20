AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_knocker.mdl"
ENT.StartHealth = GetConVar("sk_cets_agrunt_health"):GetInt()
ENT.HullType = HULL_HUMAN
ENT.CanChatMessage = false
ENT.VJ_NPC_Class = {"CLASS_XVORTIGAUNT", "CLASS_XEN"}
ENT.ControllerParams = {
	FirstP_Bone = "bip01 head",
	FirstP_Offset = Vector(12, 0, 5),
	FirstP_ShrinkBone = false,
}
 
ENT.JumpParams = {
	Enabled = false, -- Can it do movement jumps?
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
 
ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = GetConVar("sk_agrunt_dmg_punch"):GetInt()
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 200 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 150 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
 
ENT.HasRangeAttack = false
ENT.RangeAttackProjectiles = "obj_vj_nothing_of_the_lazyness"

ENT.ChargeDuration = math.random(3, 4)
ENT.ChargeCooldown = math.random(2, 8)
ENT.ChargeDamage = GetConVar("sk_cets_agrunt_dmg_charge"):GetInt()
 
ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"
 
ENT.CanFlinch = true -- Can it flinch? | false = Don't flinch | true = Always flinch | "DamageTypes" = Flinch only from certain damages types
ENT.FlinchDamageTypes = {DMG_BLAST} -- Which types of damage types should it flinch from when "DamageTypes" is used?
ENT.FlinchChance = 24 -- Chance of flinching from 1 to x | 1 = Always flinch
ENT.FlinchCooldown = 4 -- How much time until it can flinch again? | false = Base auto calculates the duration
ENT.AnimTbl_Flinch = "big_flinch"
 
ENT.FootStepSoundLevel = 60
ENT.FootStepSoundPitch = 70
 
ENT.SoundTbl_FootStep = {"npc/vort/vort_foot1.wav", "npc/vort/vort_foot2.wav", "npc/vort/vort_foot3.wav", "npc/vort/vort_foot4.wav"}
 
ENT.SoundTbl_Idle = {
	"npc/alien_grunt/ag_idle1.wav",
	"npc/alien_grunt/ag_idle2.wav",
	"npc/alien_grunt/ag_idle3.wav",
	"npc/alien_grunt/ag_idle4.wav",
	"npc/alien_grunt/ag_idle5.wav",
}
 
ENT.SoundTbl_CombatIdle = {
	"npc/alien_grunt/ag_hide1.wav",
	"npc/alien_grunt/ag_hide2.wav",
	"npc/alien_grunt/ag_hide3.wav",
	"npc/alien_grunt/ag_hide4.wav",
}
 
ENT.SoundTbl_Alert = {
	"npc/alien_grunt/ag_alert1.wav",
	"npc/alien_grunt/ag_alert2.wav",
	"npc/alien_grunt/ag_alert3.wav",
	"npc/alien_grunt/ag_alert4.wav",
	"npc/alien_grunt/ag_alert5.wav",
}
 
ENT.SoundTbl_MeleeAttackMiss = {
	"npc/vort/claw_swing1.wav",
	"npc/vort/claw_swing2.wav",
}
 
ENT.SoundTbl_MeleeAttack = {
	"npc/fast_zombie/claw_strike1.wav",
	"npc/fast_zombie/claw_strike2.wav",
	"npc/fast_zombie/claw_strike3.wav",
}
 
ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/alien_grunt/ag_attack1.wav",
	"npc/alien_grunt/ag_attack2.wav",
	"npc/alien_grunt/ag_attack3.wav",
}
 
ENT.SoundTbl_BeforeRangeAttack = {
	"npc/alien_grunt/ag_attack1.wav",
	"npc/alien_grunt/ag_attack2.wav",
	"npc/alien_grunt/ag_attack3.wav",
}
 
ENT.SoundTbl_RangeAttack = {
	"npc/alien_grunt/ag_fire1.wav",
	"npc/alien_grunt/ag_fire2.wav",
	"npc/alien_grunt/ag_fire3.wav",
}
 
ENT.SoundTbl_Pain = {
	"npc/alien_grunt/ag_pain1.wav",
	"npc/alien_grunt/ag_pain2.wav",
	"npc/alien_grunt/ag_pain3.wav",
	"npc/alien_grunt/ag_pain4.wav",
	"npc/alien_grunt/ag_pain5.wav",
}
 
ENT.SoundTbl_Death = {
	"npc/alien_grunt/ag_die1.wav",
	"npc/alien_grunt/ag_die2.wav",
	"npc/alien_grunt/ag_die3.wav",
	"npc/alien_grunt/ag_die4.wav",
	"npc/alien_grunt/ag_die5.wav",
}

ENT.ChargeStepHeight = 21
ENT.ChargeObstacleCheckDistance = 24
ENT.ChargeStepScanIncrement = 0.1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(10, 10, 85), Vector(-10, -10, 0))
 
	self.NextChargeTime = CurTime()
	self:SetStepHeight(self.ChargeStepHeight)
 
	self.Bullseye = ents.Create("base_anim")
	self.Bullseye:SetModel("models/hunter/blocks/cube1x1x025.mdl")
	self.Bullseye:SetParent(self)
	self.Bullseye:SetPos(self:GetPos() + self:GetForward()*100 + Vector(0,0,15))
	self.Bullseye:Spawn()
	self.Bullseye:SetNoDraw(true)
	self.Bullseye:DrawShadow(false)
	self.Bullseye:SetSolid(SOLID_NONE)
	self.Bullseye.VJ_NPC_Class = self.VJ_NPC_Class
 
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartChargeTrail()

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopChargeTrail()

end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_yield_leader = vj_ai_schedule.New("SCHEDULE_YIELD_LEADER")
schedule_yield_leader:EngTask("TASK_MOVE_AWAY_PATH", 120)
schedule_yield_leader:EngTask("TASK_WALK_PATH", 0)
schedule_yield_leader:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schedule_yield_leader.TurnData = {Type = VJ.FACE_ENTITY_VISIBLE, Target = nil}
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
 
	self.Bullseye.VJ_NPC_Class = self.VJ_NPC_Class
 
	if self.DeathAnimationCodeRan then return end
	local enemy = self:GetEnemy()
 
	if IsValid(enemy) then
 
	if self.VJ_IsBeingControlled then
		local controller = self.VJ_TheController
			if !self:Attacking() then
				if controller:KeyDown(IN_JUMP) && self.NextChargeTime < CurTime() then
					self:ChargeAtEnemy(5)
					VJ.EmitSound(self, "npc/alien_grunt/ag_charging1.wav", 70)
					self:StartChargeTrail()
				end
			end
	else
			if !self:Attacking() && self.NextChargeTime < CurTime() && self:CanChargeEnemy() && self.EnemyData.DistanceNearest > 256 then
					VJ.EmitSound(self, "npc/alien_grunt/ag_charging1.wav", 70)
					self:StartChargeTrail()
					self:ChargeAtEnemy(self.ChargeDuration)
				end
			end
		end
 
		if self.Charging then self:ChargeThink() end
 
		if !IsValid(enemy) then
			if self.Charging then
				self:StopCharging(true,self.ChargeCooldown*0.5)
			end
		self.ShootPos = nil
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	if ev == 1004 then self:FootStepSoundCode() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer(seed)
	timer.Simple(0.2, function() if IsValid(self) && !self.DeathAnimationCodeRan then self:CustomMeleeDamage(self.MeleeDamage) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomMeleeDamage(damage,damagetype)
	damagetype = damagetype or DMG_SLASH
	local realisticRadius = false
	local damaged_ents = util.VJ_SphereDamage(self, self, self:GetPos() + self:GetForward() * 50, 50, damage, damagetype, true, realisticRadius)
	local NPCWasHit = false
 
	if self.Charging then
		for _, ent in pairs(damaged_ents) do
			local dir = self:GetVelocity():GetNormalized()
 
			if dir == vector_origin then
				dir = self:GetForward()
			end
 
			local speed = math.max(self:GetVelocity():Length(), 400)
			local knockback = dir * (speed * 0.75)
			knockback.z = math.Clamp(speed * 0.55, 180, 300)
 
			local center = self:GetPos() + self:GetForward() * 60
 
			for _, ent in ipairs(ents.FindInSphere(center, 48)) do
				if ent == self then continue end
 
				local class = ent:GetClass()
 
				if class == "func_breakable" then
					local dmg = DamageInfo()
					dmg:SetAttacker(self)
					dmg:SetInflictor(self)
					dmg:SetDamage(500)
					dmg:SetDamageType(bit.bor(DMG_CLUB, DMG_CRUSH))
					ent:TakeDamageInfo(dmg)
 
				return
 
				elseif class == "func_breakable_surf" then
					ent:Fire("Shatter")
					return
				end
			end
 
			if ent:IsNPC() or ent:IsPlayer() then
				if ent:IsPlayer() then
					ent:SetVelocity(knockback)
				elseif !ent.VJ_IsHugeMonster then
					ent:SetVelocity(knockback / 2)
				end
 
				NPCWasHit = true
			end
		end
 
		if NPCWasHit then
			self:PlaySoundSystem("MeleeAttack", SoundTbl_MeleeAttack)
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsNearEdge(dist)
	dist = dist or 90
 
	local pos = self:GetPos()
	local forward = self:GetForward()
	local right = self:GetRight()
 
	local groundTr = util.TraceLine({
		start = pos + Vector(0, 0, 10),
		endpos = pos - Vector(0, 0, 70),
		mask = MASK_NPCWORLDSTATIC
	})
 
	local groundZ = groundTr.Hit and groundTr.HitPos.z or pos.z
 
	local checks = {pos + forward * dist, pos + forward * dist + right * 24, pos + forward * dist - right * 24}
 
	for _, checkPos in ipairs(checks) do
		local tr = util.TraceHull({
			start = checkPos + Vector(0, 0, 10),
			endpos = checkPos - Vector(0, 0, 90),
			mins = Vector(-6, -6, 0),
			maxs = Vector(6, 6, 6),
			mask = MASK_NPCWORLDSTATIC
		})
 
		if !tr.Hit or (groundZ - tr.HitPos.z) > 60 then
			return true
		end
	end
 
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Attacking() if self.Charging or self.MeleeAttacking then return true end end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanChargeEnemy()
	local enemy = self:GetEnemy()
	if !IsValid(enemy) then return false end
 
	local heightOffset = Vector(0, 0, 40)
 
	local tr = util.TraceHull({
		start = self:GetPos() + heightOffset,
		endpos = enemy:GetPos() + heightOffset,
		mask = MASK_NPCWORLDSTATIC,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs(),
	})
 
	if self:IsNearEdge() then
		return false
	end
 
	if self:Visible(enemy) && enemy:IsOnGround() && !tr.Hit then
		return true
	end
 
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChargeThink()
	if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) then
		self:SetIdealYawAndUpdate( (self:GetEnemy():GetPos() - self:GetPos() ):Angle().y )
	end

	if !self.Charge_ApplyForceCountdownStarted && self:GetActivity() == ACT_SPECIAL_ATTACK1 then
		self.Charge_ApplyForceCountdownStarted = true
		timer.Simple(0.6, function() if IsValid(self) then
				self.Charge_ShouldApplyForce = true
			end
		end)
	end

	local speed = 2048

	if self.Charge_ShouldApplyForce && self:IsOnGround() then
		local vel = self:GetVelocity()
		local forwardVel = vel:Dot(self:GetForward())

		if forwardVel < speed then
			self:SetVelocity(self:GetForward() * (speed - forwardVel))
		end
	end

	if self:CustomMeleeDamage(self.ChargeDamage, bit.bor(DMG_CLUB,DMG_CRUSH,DMG_SLASH)) == true then -- Player or NPC was hit.
		self:StopCharging(false,self.ChargeCooldown)
		self:EmitSound("npc/alien_grunt/ag_charger_smash_0" .. math.random(1, 3) .. ".wav", 90, math.random(90,110))
		ParticleEffect("gonarch_footstep_4", self:GetPos() + self:GetUp()*30, Angle(0,0,0))
		self:VJ_ACT_PLAYACTIVITY("charge_crash", true, duration, true)
	end

	local wallHullMins, wallHullMaxs = self:OBBMins(), self:OBBMaxs()

	local wallTrace = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos() + self:GetForward() * 60,
		mins = Vector(wallHullMins.x, wallHullMins.y, 32),
		maxs = self:OBBMaxs(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY
	})

	if wallTrace.Hit then
		local normal = wallTrace.HitNormal

		if normal.z > 0.25 then
			return
		end

		self:EmitSound("npc/alien_grunt/ag_charger_smash_0" .. math.random(1, 3) .. ".wav", 90, math.random(90,110))
		ParticleEffect("gonarch_footstep_4", self:GetPos() + self:GetUp() * 30, Angle(0,0,0))

		self:StopCharging(true, self.ChargeCooldown * 0.5)
		self:TakeDamage(5)
		return
	end

	local sidePositions = {
		self:GetPos() + self:GetForward() * 60,
		self:GetPos() + self:GetForward() * 60 + self:GetRight() * 30,
		self:GetPos() + self:GetForward() * 60 - self:GetRight() * 30,
	}

	for _, sidePos in ipairs(sidePositions) do
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = sidePos,
			mins = Vector(-18, -18, 32),
			maxs = Vector(18, 18, 72),
			filter = self,
			mask = MASK_SOLID
		})
 
		if tr.Hit then
			self:StopCharging(true, self.ChargeCooldown * 0.5)
			return
		end
	end

	if self:IsNearEdge() then
		self:StopCharging(true, self.ChargeCooldown * 0.5)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChargeAtEnemy(duration)
	if self.Charging then return end
	self.Charging = true
	self.Charge_ApplyForceCountdownStarted = false
	self.Charge_ShouldApplyForce = false
 
	self:VJ_ACT_PLAYACTIVITY(ACT_SPECIAL_ATTACK1, true, duration, false)
 
	timer.Simple(duration, function() if IsValid(self) && self.Charging then
		self:StopCharging(true,self.ChargeCooldown)
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopCharging(UseAnimation,nextcharge)
	if self.DeathAnimationCodeRan then return end
	self:StopSound("npc/alien_grunt/ag_charging1.wav")
 
	self.MovementType = VJ_MOVETYPE_STATIONARY
	self.CanTurnWhileStationary = false
	self.HasMeleeAttack = false
	self.HasRangeAttack = false
	self.IsGuard = true
	self.CallForHelp = false
 
	if UseAnimation then self:VJ_ACT_PLAYACTIVITY("charge_crash", true, self:SequenceDuration(self:LookupSequence( "charge_crash" )), true) end
 
	timer.Simple(self:SequenceDuration(self:LookupSequence( "charge_crash" )), function() if IsValid(self) then
		self.MovementType = VJ_MOVETYPE_GROUND
		self.CanTurnWhileStationary = true
		self.HasMeleeAttack = true
		self.HasRangeAttack = true
		self.IsGuard = false
		self.CallForHelp = true
	end end)
 
	self.Charging = false
	self.Charge_ShouldApplyForce = false
 
	self:StopChargeTrail()
 
	self.NextChargeTime = CurTime() + nextcharge
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:StopSound("npc/alien_grunt/ag_charging1.wav")
	self:StopChargeTrail()
end