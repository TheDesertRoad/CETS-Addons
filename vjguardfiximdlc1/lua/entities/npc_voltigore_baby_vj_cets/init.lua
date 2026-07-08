AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_voltigore.mdl"
ENT.StartHealth = 200
ENT.HullType = HULL_LARGE
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
ENT.CanChatMessage = false
ENT.VJ_IsHugeMonster = false
ENT.GibOnDeathFilter = false
ENT.JumpParams = {
	Enabled = false, -- Can it do movement jumps?
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecal = "VJ_CETS_Voltigore_Blood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.NextMeleeAttackTime = 0.4
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 20 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 50 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 55

ENT.CanEat = true
ENT.EatCooldown = 10 

ENT.HasDeathAnimation = true
ENT.HasDeathCorpse = false
ENT.AnimTbl_Death = {"diesimple", "diesideways", "dieforward"}

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = {"obj_vj_nothing_of_the_lazyness"}
ENT.AnimTbl_RangeAttack = {"attack_electric"}
ENT.RangeAttackMaxDistance = 1000
ENT.RangeAttackMinDistance = 50
ENT.RangeAttackExtraTimers = {1.1, 1.2, 1.3, 1.4}
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 3

ENT.HasExtraMeleeAttackSounds = true

ENT.MainSoundPitch = 150

ENT.SoundTbl_FootStepLevel = 80

ENT.SoundTbl_FootStep = {"npc/voltigore/voltigore_footstep1.wav", "npc/voltigore/voltigore_footstep2.wav", "npc/voltigore/voltigore_footstep3.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"npc/voltigore/voltigore_attack_shock.wav"}

ENT.SoundTbl_Idle = {
	"npc/voltigore/voltigore_idle1.wav",
	"npc/voltigore/voltigore_idle2.wav",
	"npc/voltigore/voltigore_idle3.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/voltigore/voltigore_communicate1.wav",
	"npc/voltigore/voltigore_communicate2.wav",
	"npc/voltigore/voltigore_communicate3.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/voltigore/voltigore_communicate1.wav",
	"npc/voltigore/voltigore_communicate2.wav",
	"npc/voltigore/voltigore_communicate3.wav",
}

ENT.SoundTbl_Alert = {
	"npc/voltigore/voltigore_alert1.wav",
	"npc/voltigore/voltigore_alert2.wav",
	"npc/voltigore/voltigore_alert3.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/voltigore/voltigore_attack_melee1.wav",
	"npc/voltigore/voltigore_attack_melee2.wav",
}

ENT.SoundTbl_MeleeAttackExtra = {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/voltigore/voltigore_pain1.wav",
	"npc/voltigore/voltigore_pain2.wav",
	"npc/voltigore/voltigore_pain3.wav",
	"npc/voltigore/voltigore_pain4.wav",
}

ENT.SoundTbl_Death = {
	"npc/voltigore/voltigore_die1.wav",
	"npc/voltigore/voltigore_die2.wav",
	"npc/voltigore/voltigore_die3.wav",
}

ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(20, 20, 140), Vector(-30, -30, 0))
	self:SetModelScale(0.35)
	self:SetSkin(1)

	self.BlackAmount = 0

	self.Squadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	if not IsValid(VJ.SquadC_Leader) then
		for _, ent in ipairs(ents.GetAll()) do
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_voltigore_vj_cets" then
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
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_voltigore_vj_cets" then
					VJ.SquadC_Leader = ent
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.MeleeAttackDamage = 5
			self.AnimTbl_MeleeAttack = "melee_leftpaw"
			self.TimeUntilMeleeAttackDamage = 0.5
			self.MeleeAttackKnockBack_Forward1 = 50 -- How far it will push you forward | First in math.random
			self.MeleeAttackKnockBack_Forward2 = 60 -- How far it will push you forward | Second in math.random
		elseif randRange == 2 then
			self.MeleeAttackDamage = 20
			self.AnimTbl_MeleeAttack = {"melee_bothpaw1", "melee_bothpaw2"}
			self.TimeUntilMeleeAttackDamage = 1
			self.MeleeAttackKnockBack_Forward1 = 90 -- How far it will push you forward | First in math.random
			self.MeleeAttackKnockBack_Forward2 = 100 -- How far it will push you forward | Second in math.random
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if not dmginfo:IsDamageType(DMG_PHYSGUN) then return end

	local ply = dmginfo:GetAttacker()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	local dir = ply:GetAimVector()

	local velocity =
		(dir * 500) +   -- forward force
		Vector(0, 0, 60) -- slight lift

	self:SetVelocity(velocity)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	ParticleEffectAttach("racex_arc_01_cp0", PATTACH_POINT_FOLLOW, self, 4)
	ParticleEffect("racex_arc_01_gas", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("racex_floaters2", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("racex_arc_02_gas", self:GetPos(), Angle(0,0,0), nil)
end
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
		VJ.EmitSound(self, "npc/voltigore/voltigore_eat.wav", 90)
		-- Health changes
		local food = self.EatingData.Target
		local damage = 150 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
		self:PlayAnim("victoryeat", true, true)
		-- Blood effects
		local bloodData = food.BloodData
		if bloodData then
			local bloodPos = food:GetPos() + food:OBBCenter()
			local bloodParticle = VJ_PICK(bloodData.Particle)
			if bloodParticle then
				ParticleEffect(bloodParticle, bloodPos, self:GetAngles())
			end

		end
		return 2 -- Eat every this seconds
	elseif status == "StopEating" then
		if statusData != "Dead" && self.EatingData.AnimStatus != "None" then -- Do NOT play anim while dead or has NOT prepared to eat
			return select(2, self:PlayAnim("idle1", true, false))
		end
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	ParticleEffect("racex_arc_01_gas", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("racex_floaters2", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("racex_arc_02_gas", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("bebgon_racex", self:GetPos(), Angle(0,0,0), nil)

	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.8, 2, 100, 32, 3, Color(255, 25, 255, 64))

	VJ_EmitSound(self,"phx/eggcrack.wav",100,90)
	VJ_EmitSound(self,"hl1/weapons/lhit.wav",100,90)
	VJ_EmitSound(self,"npc/antlion_grub/agrub_squish1.wav",100,120)

	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
end