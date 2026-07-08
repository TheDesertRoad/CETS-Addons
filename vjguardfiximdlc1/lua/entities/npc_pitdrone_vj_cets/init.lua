AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_pit_drone.mdl"
ENT.StartHealth = 100
ENT.SightAngle = 230
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanEat = true
ENT.EatCooldown = 30 

ENT.CanChatMessage = false

ENT.TimeUntilMeleeAttackDamage = 0.6
ENT.MeleeAttackDamage = 24
ENT.NextMeleeAttackTime = VJ.SET(0.6, 0.7)
ENT.MeleeAttackDistance = 40
ENT.MeleeAttackDamageDistance = 70

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_pitbullet"
ENT.AnimTbl_RangeAttack = {"range"}
ENT.RangeAttackMaxDistance = 1500
ENT.RangeAttackMinDistance = 100
ENT.TimeUntilRangeAttackProjectileRelease = 0.1
ENT.NextRangeAttackTime = VJ.SET(1, 5)

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = ACT_GLIDE
ENT.LeapAttackMaxDistance = 1000
ENT.LeapAttackMinDistance = 100
ENT.TimeUntilLeapAttackDamage = 0.3
ENT.NextLeapAttackTime = 4
ENT.NextAnyAttackTime_Leap = 0.8
ENT.TimeUntilLeapAttackVelocity = 0.1
ENT.LeapAttackVelocityForward = 300
ENT.LeapAttackVelocityUp = 200
ENT.LeapAttackDamage = 20
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1}
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 20

ENT.LeapAttackSoundLevel = 70

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {"flinchb"}

ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav", "npc/zombie/foot2.wav", "npc/zombie/foot3.wav", "npc/zombie/foot_slide1.wav", "npc/zombie/foot_slide2.wav", "npc/zombie/foot_slide3.wav"}

ENT.SoundTbl_Idle = {
	"npc/pitdrone/pit_drone_communicate1.wav",
	"npc/pitdrone/pit_drone_communicate2.wav",
	"npc/pitdrone/pit_drone_communicate3.wav",
	"npc/pitdrone/pit_drone_communicate4.wav",
	"npc/pitdrone/pit_drone_idle1.wav",
	"npc/pitdrone/pit_drone_idle2.wav",
	"npc/pitdrone/pit_drone_idle3.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/pitdrone/pit_drone_communicate1.wav",
	"npc/pitdrone/pit_drone_communicate2.wav",
	"npc/pitdrone/pit_drone_communicate3.wav",
	"npc/pitdrone/pit_drone_communicate4.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/pitdrone/pit_drone_communicate1.wav",
	"npc/pitdrone/pit_drone_communicate2.wav",
	"npc/pitdrone/pit_drone_communicate3.wav",
	"npc/pitdrone/pit_drone_communicate4.wav",
}

ENT.SoundTbl_Investigate = {
	"npc/pitdrone/pit_drone_hunt1.wav",
	"npc/pitdrone/pit_drone_hunt2.wav",
	"npc/pitdrone/pit_drone_hunt3.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/pitdrone/pit_drone_hunt1.wav",
	"npc/pitdrone/pit_drone_hunt2.wav",
	"npc/pitdrone/pit_drone_hunt3.wav",
}

ENT.SoundTbl_Alert = {
	"npc/pitdrone/pit_drone_alert1.wav",
	"npc/pitdrone/pit_drone_alert2.wav",
	"npc/pitdrone/pit_drone_alert3.wav",
}

ENT.SoundTbl_LeapAttack = {
	"npc/pitdrone/pit_drone_melee_attack1.wav",
	"npc/pitdrone/pit_drone_melee_attack2.wav",
}

ENT.SoundTbl_LeapAttackDamage = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard4.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
}

ENT.SoundTbl_MeleeAttack = {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_BeforeRangeAttack = {
	"npc/pitdrone/pit_drone_attack_spike1.wav",
	"npc/pitdrone/pit_drone_attack_spike2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/pitdrone/pit_drone_pain1.wav",
	"npc/pitdrone/pit_drone_pain2.wav",
	"npc/pitdrone/pit_drone_pain3.wav",
	"npc/pitdrone/pit_drone_pain4.wav",
}

ENT.SoundTbl_Death = {
	"npc/pitdrone/pit_drone_die1.wav",
	"npc/pitdrone/pit_drone_die2.wav",
	"npc/pitdrone/pit_drone_die3.wav",
}

ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(18, 18, 55), Vector(-18, -18, 0))
	self:SetBodygroup(1, 1)

	self.BlackAmount = 0

	self.Squadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	if not IsValid(VJ.SquadC_Leader) then
		for _, ent in ipairs(ents.GetAll()) do
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_shocktrooper_vj_cets" then
					VJ.SquadC_Leader = ent
				break
			end
		end
	end
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

	local leader = VJ.SquadC_Leader

	if IsValid(leader) then
		if leader ~= self then
			self.DisableWandering = true
			if IsValid(self:GetEnemy()) or self:IsBusy() then return end

			local targetPos = leader:GetPos() + self.Squadrant_FollowOffsetPos
			local leaderSpeed = leader:GetVelocity():Length()

			local pos = leader:GetPos() + self.Squadrant_FollowOffsetPos
			local dist = self:GetPos():Distance(leader:GetPos())

			if dist < 75 and not self:IsBusy() then
				schedule_yield_leader.TurnData.Target = leader
				self:StartSchedule(schedule_yield_leader)
				return
			end

			self.DisableWandering = true

			if leaderSpeed < 5 and dist < 100 then
				self:StopMoving()
				return
			end

			if not self.NextLeaderMove or CurTime() > self.NextLeaderMove then
				self.NextLeaderMove = CurTime() + 0.5
				self:SetLastPosition(leader:GetPos() + self.Squadrant_FollowOffsetPos)

				if leader.Alerted then
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
				else
					self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
				end
			end
		end
	else
		self.DisableWandering = false
		for _, ent in ipairs(ents.GetAll()) do
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_shocktrooper_vj_cets" then
					VJ.SquadC_Leader = ent
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ50 = Vector(0, 0, -50)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnEat(status, statusData)
	-- The following code is a ideal example based on Half-Life 1 Zombie
	//VJ.DEBUG_Print(self, "OnEat", status, statusData)
	if status == "CheckFood" then
		return true //statusData.owner.BloodData && statusData.owner.BloodData.Color == VJ.BLOOD_COLOR_RED
	elseif status == "BeginEating" then
		self.AnimationTranslations[ACT_IDLE] = ACT_GESTURE_RANGE_ATTACK1 -- Eating animation
		return select(2, self:PlayAnim(ACT_ARM, true, false))
	elseif status == "Eat" then
		VJ.EmitSound(self, "barnacle/bcl_chew" .. math.random(1, 3) .. ".wav", 55)
		-- Health changes
		local food = self.EatingData.Target
		local damage = 60 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
		self:PlayAnim("eat", true, true)
		-- Blood effects
		local bloodData = food.BloodData
		if bloodData then
			local bloodPos = food:GetPos() + food:OBBCenter()
			local bloodParticle = VJ_PICK(bloodData.Particle)
			if bloodParticle then
				ParticleEffect(bloodParticle, bloodPos, self:GetAngles())
			end
			local bloodDecal = VJ_PICK(bloodData.Decal)
			if bloodDecal then
				local tr = util.TraceLine({start = bloodPos, endpos = bloodPos + vecZ50, filter = {food, self}})
				util.Decal(bloodDecal, tr.HitPos + tr.HitNormal + Vector(math.random(-45, 45), math.random(-45, 45), 0), tr.HitPos - tr.HitNormal, food)
			end
		end
		return 2 -- Eat every this seconds
	elseif status == "StopEating" then
		if statusData != "Dead" && self.EatingData.AnimStatus != "None" then -- Do NOT play anim while dead or has NOT prepared to eat
			return select(2, self:PlayAnim("inspect", true, false))
		end
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.AnimTbl_MeleeAttack = "bite"
			self.MeleeAttackExtraTimers = false
			self.SoundTbl_BeforeMeleeAttack = "npc/pitdrone/pit_drone_melee_attack1.wav"
		elseif randRange == 2 then
			self.AnimTbl_MeleeAttack = "whip"
			self.MeleeAttackExtraTimers = {0.9}
			self.SoundTbl_BeforeMeleeAttack = "npc/pitdrone/pit_drone_melee_attack2.wav"
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 40
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	local projPos = projectile:GetPos()
	ParticleEffect("antlion_gib_02_juice", projPos + projectile:GetForward() * 30, self:GetForward():Angle(), projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projPos, 1, 2000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PostSpawn" then
		-- Behavior: If spikes are empty, go hide and reload
		local bg = self:GetBodygroup(1)
		if bg == 0 or bg == 6 then
			self:SetBodygroup(1, 0)
			self.HasRangeAttack = false
			if !self.VJ_IsBeingControlled then
				-- Run from the enemy, then play the reload animation and set the body group
				self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
				timer.Simple(0.1, function()
					if IsValid(self) then
						self.TakingCoverT = CurTime() + self:GetPathTimeToGoal()
						timer.Simple(self:GetPathTimeToGoal(), function()
							if IsValid(self) then
								self:PlayAnim("reload", true, false, true, 0, {OnFinish=function(interrupted2, anim2)
									self.HasRangeAttack = true
									self:SetBodygroup(1, 1)
								end})
							end
						end)
					end
				end)
			end
		else
			self:SetBodygroup(1, bg + 1)
		end
	end
end