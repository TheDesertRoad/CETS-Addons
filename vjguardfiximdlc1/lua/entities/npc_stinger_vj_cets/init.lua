AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_stinger.mdl"
ENT.StartHealth = 100
ENT.SightAngle = 280
ENT.SightDistance = 2000
ENT.HullType = HULL_WIDE_SHORT
ENT.VJ_NPC_Class = {"CLASS_FUNGUS"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanChatMessage = false

ENT.JumpParams = {
	Enabled = false, -- Can it do movement jumps?
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = true
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "launch_point"
ENT.RangeAttackEntityToSpawn = "obj_vj_stinger_spit"
ENT.RangeDistance = 1000
ENT.RangeToMeleeDistance = 60
ENT.TimeUntilRangeAttackProjectileRelease = 0.2
ENT.RangeAttackExtraTimers = false
ENT.NextRangeAttackTime = 4

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = "melee_attack1"
ENT.TimeUntilMeleeAttackDamage = 0.5
ENT.HasExtraMeleeAttackSounds = true
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 200
ENT.MeleeAttackKnockBack_Forward2 = 320
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackDamageDistance = 125
ENT.MeleeAttackDistance = 60

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 2 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 8 -- How many repetitions?

ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 90 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 4 -- How much time until player's Speed resets

ENT.CanFlinch = 0
ENT.AnimTbl_IdleStand = {"idle_standing", "idle_scratching", "idle_eating"}

ENT.FootStepSoundLevel = 80
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.7 -- Next foot step sound when it is walking

ENT.MainSoundPitch = 100

ENT.SoundTbl_FootStep = {"npc/fast_zombie/foot1.wav", "npc/fast_zombie/foot2.wav", "npc/fast_zombie/foot3.wav", "npc/fast_zombie/foot4.wav"}

ENT.SoundTbl_Idle = {
	"npc/stinger/idle01.wav",
	"npc/stinger/idle02.wav",
	"npc/stinger/idle03.wav",
}

ENT.SoundTbl_Alert = {
	"npc/stinger/stinger_panic01.wav",
	"npc/stinger/stinger_panic02.wav",
}

ENT.SoundTbl_Pain = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}

ENT.SoundTbl_Death = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}

ENT.SoundTbl_FollowPlayer = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}

ENT.SoundTbl_UnFollowPlayer = {
	"npc/stinger/stinger_use01.wav",
	"npc/stinger/stinger_use02.wav",
	"npc/stinger/stinger_use03.wav",
}

ENT.FSquadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(20, 20, 45),  Vector(-20, -20, 0))

	self.BlackAmount = 0

	self.FSquadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	if not IsValid(VJ.SquadC_Leader) then
		for _, ent in ipairs(ents.GetAll()) do
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_stampeder_vj_cets" then
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

			local targetPos = leader:GetPos() + self.FSquadrant_FollowOffsetPos
			local leaderSpeed = leader:GetVelocity():Length()

			local pos = leader:GetPos() + self.FSquadrant_FollowOffsetPos
			local dist = self:GetPos():Distance(leader:GetPos())

			if dist < 256 and not self:IsBusy() then
				schedule_yield_leader.TurnData.Target = leader
				self:StartSchedule(schedule_yield_leader)
				return
			end

			self.DisableWandering = true

			if leaderSpeed < 5 and dist < 260 then
				self:StopMoving()
				return
			end

			if not self.NextLeaderMove or CurTime() > self.NextLeaderMove then
				self.NextLeaderMove = CurTime() + 0.5
				self:SetLastPosition(leader:GetPos() + self.FSquadrant_FollowOffsetPos)

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
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_stampeder_vj_cets" then
					VJ.SquadC_Leader = ent
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 1 then
		self:PlayAnim({"startle"}, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 2 then
			self.AnimTbl_RangeAttack = "range_attack1"
			self.RangeAttackExtraTimers = false
			self.SoundTbl_BeforeRangeAttack = false
			self.SoundTbl_RangeAttack = "npc/stinger/stinger_spray02.wav"
		elseif randRange == 1 then
			self.RangeAttackExtraTimers = {0.3, 0.4, 0.5}
			self.AnimTbl_RangeAttack = "range_attack2"
			self.SoundTbl_BeforeRangeAttack = {"npc/barnacle/bcl_die3.wav"}
			self.SoundTbl_RangeAttack = "npc/stinger/stinger_spray02.wav"
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute()
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*75 ,Angle(0,0,0),nil)
	ParticleEffectAttach("stinger_spray", PATTACH_POINT_FOLLOW, self, 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Line", self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot3.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
	util.ScreenShake(self:GetPos(),22,500,1,500)
	ParticleEffect("antlion_gib_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end