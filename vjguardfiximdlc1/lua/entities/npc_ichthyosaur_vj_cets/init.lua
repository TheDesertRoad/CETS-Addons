AddCSLuaFile( "shared.lua" )
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_ichthy.mdl"
ENT.StartHealth = 1000
ENT.CanChatMessage = false
ENT.HullType = HULL_WIDE_SHORT
ENT.SightAngle = 280
ENT.SightDistance = 2000
ENT.TurningSpeed = 7
ENT.AnimTbl_Walk = {"walk", "walk_original"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Aquatic_SwimmingSpeed_Calm = 80
ENT.Aquatic_SwimmingSpeed_Alerted = 500
ENT.Aquatic_AnimTbl_Calm = {"swimslow"}
ENT.Aquatic_AnimTbl_Alerted = {"swim"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 70
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.MeleeAttackDistance = 256
ENT.MeleeAttackDamageDistance = 360 -- How far does the damage go?
ENT.DisableDefaultMeleeAttackDamageCode = true
ENT.AnimTbl_MeleeAttack = false
ENT.MeleeAttackStartAnimation = "attackstart"
ENT.MeleeAttackFinishHitAnimation = "attackend"
ENT.MeleeAttackFinishMissAnimation = "attackmiss"
ENT.MeleeAttackChargeSpeed = 12
ENT.MeleeAttackChargeTime = 1
ENT.NextAnyAttackTime_Melee = 4

ENT.MeleeAttackStarted = false
ENT.MeleeAttackHit = false
ENT.MeleeAttackTarget = nil
ENT.MeleeAttackTimer = nil

ENT.MinWaterDepth = 250
ENT.WaterSurfaceAvoidDistance = 250
ENT.BubbleSurfaceDistance = 20 

ENT.HasRangeAttack = false

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {"die"}

ENT.SoundTbl_Breath = {"npc/ichthyosaur/water_breath.wav"}

ENT.SoundTbl_Idle = {
	"npc/ichthyosaur/ichy_idle1.wav",
	"npc/ichthyosaur/ichy_idle2.wav",
	"npc/ichthyosaur/ichy_idle3.wav",
	"npc/ichthyosaur/ichy_idle4.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/ichthyosaur/attack_growl1.wav",
	"npc/ichthyosaur/attack_growl2.wav", 
	"npc/ichthyosaur/attack_growl3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/ichthyosaur/ichy_pain1.wav",
	"npc/ichthyosaur/ichy_pain2.wav",
	"npc/ichthyosaur/ichy_pain3.wav",
	"npc/ichthyosaur/ichy_pain5.wav",
}

ENT.SoundTbl_Death = {
	"npc/ichthyosaur/ichy_die1.wav",
	"npc/ichthyosaur/ichy_die2.wav",
	"npc/ichthyosaur/ichy_die3.wav",
	"npc/ichthyosaur/ichy_die4.wav",
}

ENT.SoundTbl_Alert = {
	"npc/ichthyosaur/water_growl1.wav",
	"npc/ichthyosaur/water_growl2.wav",
	"npc/ichthyosaur/water_growl3.wav",
	"npc/ichthyosaur/water_growl4.wav",
	"npc/ichthyosaur/water_growl5.wav"
}

ENT.SoundTbl_Investigate = {
	"npc/ichthyosaur/ping1.wav",
	"npc/ichthyosaur/ping2.wav",
}

ENT.SoundTbl_IdleDialogue =  {
	"npc/ichthyosaur/voice1.wav",
	"npc/ichthyosaur/voice2.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/ichthyosaur/voice1.wav",
	"npc/ichthyosaur/voice2.wav",
}

ENT.SoundTbl_MeleeAttack = {"npc/ichthyosaur/snap.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/ichthyosaur/snap_miss.wav"}

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("npc_cets_ichthy_xenfriends"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
	else
		self.VJ_NPC_Class = {"CLASS_XFISH"}
	end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSurroundingBounds(Vector(100, 100, 100), Vector(-100, -100, 0))

	self.BlackAmount = 0

	if self:WaterLevel() > 0 then 
		self.MovementType = VJ_MOVETYPE_AQUATIC
		self:SetCollisionBounds(Vector(15, 15, 3), Vector(-15, -15, -17))
		self.TurningUseAllAxis = true
		self.LimitChaseDistance = "OnlyRange"
		self.HasMeleeAttack = true
		self.HasMeleeAttackKnockBack = true
	else
		self.MovementType = VJ_MOVETYPE_GROUND
		self.RangeDistance = 2000
	end

	self.NextBubbleTime = CurTime() + math.Rand(1, 3)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.NextFootstepSoundT = CurTime() + 1

	local enemy = self:GetEnemy()
	if IsValid(enemy) && enemy:WaterLevel() <= 3  && self:WaterLevel() <= 3 then
		self:ClearEnemyMemory(enemy)
		self:SetEnemy(nil)
		self.MeleeAttackTarget = nil
		self:MaintainAlertBehavior()
	end

	if self:WaterLevel() <= 2 then
		if self.MeleeAttackStarted then
			self:MissChargeAttack()
		end

		local velocity = self:GetVelocity()

		if velocity.z > 0 then
			velocity.z = 0
			self:SetVelocity(velocity)
		end
	end

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

	if self.MovementType == VJ_MOVETYPE_GROUND then
		if self.VJ_IsBeingControlled == true then
			self.RangeAttackAnimationStopMovement = false
			self.HasRangeAttack = false
		else
			if self.EnemyData.DistanceNearest > 200 && self.EnemyData.DistanceNearest < 2000 then
				self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
				self.RangeAttackAnimationStopMovement = true
				self.HasRangeAttack = false
			else
				self.HasRangeAttack = false
			end
		end
	end

	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if self:GetAbsVelocity():Length() < 1 then
			self.TurningUseAllAxis = false
			if self:GetAngles().x > 1 then
				self:SetAngles(Angle(self:GetAngles().x-1,self:GetAngles().y,self:GetAngles().z))
			elseif self:GetAngles().x < -1 then
				self:SetAngles(Angle(self:GetAngles().x+1,self:GetAngles().y,self:GetAngles().z))
			else
				self.TurningUseAllAxis = true
			end
		end
	end

	if self:WaterLevel() > 2 then
		if not IsValid(self) then return end
		if self:WaterLevel() <= 0 then return end

		local pos = self:GetPos()

		local tr = util.TraceLine({
			start = pos,
			endpos = pos + Vector(0, 0, 4096),
			mask = MASK_WATER
		})

		if not tr.Hit then return end

		local waterSurfaceZ = tr.HitPos.z

		local bubbleLimitZ = waterSurfaceZ - (self.BubbleSurfaceDistance or 20)

		local mins = pos + self:OBBMins()
		local maxs = pos + self:OBBMaxs()

		maxs.z = math.min(maxs.z, bubbleLimitZ)

		if maxs.z <= mins.z then
			return
		end

		effects.Bubbles(mins, maxs, math.random(0, 1), math.random(64, 128), 1)
	
	else 

	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	self:SetMaxLookDistance(10000)
	timer.Destroy("timer_range_finished_abletorange" .. self:EntIndex())
	self.IsAbleToRangeAttack = true

	if dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_CRUSH ) then 
		self:VJ_ACT_PLAYACTIVITY("thrash",true,2,false)
		self.HasMeleeAttack = false
		self.SightDistance = 1 
		self.CallForHelp = true

		if self:WaterLevel() > 2 then
			if not IsValid(self) then return end
			if self:WaterLevel() <= 0 then return end

			local pos = self:GetPos()

			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0, 0, 4096),
				mask = MASK_WATER
			})

			if not tr.Hit then return end

			local waterSurfaceZ = tr.HitPos.z

			local bubbleLimitZ = waterSurfaceZ - (self.BubbleSurfaceDistance or 20)

			local mins = pos + self:OBBMins() * 1.5
			local maxs = pos + self:OBBMaxs() * 1.5

			maxs.z = math.min(maxs.z, bubbleLimitZ)

			if maxs.z <= mins.z then
				return
			end

			effects.Bubbles(mins, maxs, math.random(8, 16), math.random(64, 128), 1)
	
			else 

			end

			timer.Simple(self:SequenceDuration(self:LookupSequence( "thrash" )),function() if IsValid(self) then
				self.SightDistance = 60000 
				self.CallForHelp = true
				self.HasMeleeAttack = true
				self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end

	if dmginfo:IsDamageType( DMG_SONIC ) then 
		self:VJ_ACT_PLAYACTIVITY("thrash",true,1,false)
		self.HasMeleeAttack = false
		self.SightDistance = 1 
		self.CallForHelp = true

		if self:WaterLevel() > 2 then
			if not IsValid(self) then return end
			if self:WaterLevel() <= 0 then return end

			local pos = self:GetPos()

			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0, 0, 4096),
				mask = MASK_WATER
			})

			if not tr.Hit then return end

			local waterSurfaceZ = tr.HitPos.z

			local bubbleLimitZ = waterSurfaceZ - (self.BubbleSurfaceDistance or 20)

			local mins = pos + self:OBBMins() * 1.5
			local maxs = pos + self:OBBMaxs() * 1.5

			maxs.z = math.min(maxs.z, bubbleLimitZ)

			if maxs.z <= mins.z then
				return
			end

			effects.Bubbles(mins, maxs, math.random(8, 16), math.random(64, 128), 1)
	
			else 

			end

			timer.Simple(self:SequenceDuration(self:LookupSequence( "thrash" )),function() if IsValid(self) then
				self.SightDistance = 60000 
				self.CallForHelp = true
				self.HasMeleeAttack = true
				self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if IsValid(ent) && ent:WaterLevel() <= 2 then
		self:ClearEnemyMemory(ent)
		return true
	end

	self:SetMaxLookDistance(1024)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnResetEnemy() 
	self:SetMaxLookDistance(1024)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "event_emit Swim" then
		VJ_EmitSound(self,"npc/bullsquid/water/swim"..math.random(1,7)..".mp3",65,math.random(120,130))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self.EnemyData.DistanceNearest > 1500 && self.EnemyData.DistanceNearest < 2500 then
		if act == ACT_RUN then
			return ACT_WALK
		end
	end

	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if act == ACT_IDLE then
			return ACT_IDLE_STEALTH
		end
	end

	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartChargeAttack(enemy)
	if self.MeleeAttackStarted then return end
	if not IsValid(enemy) then return end

	self.MeleeAttackStarted = true
	self.MeleeAttackHit = false
	self.MeleeAttackTarget = enemy

	local targetPos = enemy:WorldSpaceCenter()
	local direction = targetPos - self:WorldSpaceCenter()

	if direction:LengthSqr() <= 1 then
		direction = self:GetForward()
	else
		direction:Normalize()
	end

	self.MeleeAttackChargeDirection = direction

	self:SetVelocity(direction * self.MeleeAttackChargeSpeed)

	self.MeleeAttackChargeAngle = direction:Angle()

	local timerName = "IchthyosaurCharge_" .. self:EntIndex()

	self.MeleeAttackTimer = timerName

	local endTime = CurTime() + self.MeleeAttackChargeTime

	self:VJ_ACT_PLAYACTIVITY(self.MeleeAttackStartAnimation, true, false, true)

	timer.Create(timerName, 0, 0, function()
		if not IsValid(self) then
			timer.Remove(timerName)
			return
		end

		if not self.MeleeAttackStarted then
			timer.Remove(timerName)
			return
		end

	
		local enemy = self:GetEnemy()
		if IsValid(enemy) && enemy:WaterLevel() > 3 then
			self:SetEnemy(nil)
			self:MissChargeAttack()
			return
		end

		local velocity = self.MeleeAttackChargeDirection * self.MeleeAttackChargeSpeed

		if velocity.z > 0 then
			velocity.z = 0
		end

		self:SetVelocity(velocity)

		local hitEnt = self:CheckChargeHit()

		if IsValid(hitEnt) then
			self:FinishChargeAttack(hitEnt)
			return
		end

		if CurTime() >= endTime then
			self:MissChargeAttack()
			return
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckChargeHit()
	local startPos = self:GetPos()

	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()

	mins = mins - Vector(15, 15, 15)
	maxs = maxs + Vector(15, 15, 15)

	local tr = util.TraceHull({
		start = startPos,
		endpos = startPos,
		mins = mins,
		maxs = maxs,

		filter = function(ent)
			if ent == self then
				return false
			end

			if not IsValid(ent) then
				return false
			end

			if ent:IsWeapon() then
				return false
			end

			return true

		end, mask = MASK_SHOT_HULL
	})

	if not tr.Hit then
		return nil
	end

	if not IsValid(tr.Entity) then
		return nil
	end

	if tr.Entity == self then
		return nil
	end

	return tr.Entity
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RestoreChargeAngle()
	if not IsValid(self) then return end

	local ang = self:GetAngles()

	self:SetAngles(Angle(0, ang.y, 0))
	self:SetLocalAngularVelocity(Angle(0, 0, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EndChargeAttack()
	self.MeleeAttackStarted = false
	self.MeleeAttackHit = false
	self.MeleeAttackTarget = nil

	if self.MeleeAttackTimer then
		timer.Remove(self.MeleeAttackTimer)
		self.MeleeAttackTimer = nil
	end

	self:SetVelocity(Vector(0, 0, 0))
	self:SetLocalVelocity(Vector(0, 0, 0))
	self:SetLocalAngularVelocity(Angle(0, 0, 0))
	self:RestoreChargeAngle()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FinishChargeAttack(hitEnt)
	if not self.MeleeAttackStarted then return end
	if not IsValid(hitEnt) then return end

	self.MeleeAttackHit = true

	local dmgInfo = DamageInfo()

	dmgInfo:SetDamage(self.MeleeAttackDamage)
	dmgInfo:SetDamageType(self.MeleeAttackDamageType)
	dmgInfo:SetAttacker(self)
	dmgInfo:SetInflictor(self)
	dmgInfo:SetDamagePosition(hitEnt:WorldSpaceCenter())
	dmgInfo:SetDamageForce(self.MeleeAttackChargeDirection * 500)

	hitEnt:TakeDamageInfo(dmgInfo)

	if hitEnt:IsPlayer() then
		hitEnt:ScreenFade(SCREENFADE.IN, Color(32, 0, 0, 200), 1, 0.2)
		hitEnt:ViewPunch(Angle(math.random(-180, 180), math.random(-270, 270), 0))
	end

	VJ_EmitSound(self, self.SoundTbl_MeleeAttack, 100, math.random(95, 105))

	self:EndChargeAttack()

	self:VJ_ACT_PLAYACTIVITY(self.MeleeAttackFinishHitAnimation, true, false, true)

	timer.Simple(self:SequenceDuration(self:LookupSequence(self.MeleeAttackFinishHitAnimation)) + 0.1, function()
		if not IsValid(self) then return end

		self.MeleeAttackStarted = false
		self.MeleeAttackHit = false

		if IsValid(self:GetEnemy()) then
			self:ClearSchedule()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MissChargeAttack()
	if not self.MeleeAttackStarted then return end

	self.MeleeAttackHit = false

	VJ_EmitSound(self, self.SoundTbl_MeleeAttackMiss, 100, math.random(95, 105))

	self:EndChargeAttack()

	self:VJ_ACT_PLAYACTIVITY(self.MeleeAttackFinishMissAnimation, true, false, true)

	timer.Simple(self:SequenceDuration(self:LookupSequence(self.MeleeAttackFinishMissAnimation)) + 0.1, function()
		if not IsValid(self) then return end

		self.MeleeAttackStarted = false
		self.MeleeAttackHit = false

		self:ClearSchedule()
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		self:StartChargeAttack(enemy)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	if status == "Init" then
		return true
	end
end