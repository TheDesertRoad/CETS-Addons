AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_shock_trooper.mdl"
ENT.StartHealth = 220
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
ENT.CanTurnWhileMoving = false
ENT.TurningSpeed = 50
ENT.SightAngle = 240
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.EnemyTimeout = 9500 -- Time until the enemy target is reset if it's not visible
ENT.AlertTimeout = VJ.SET(9400, 9600)

ENT.Weapon_Accuracy = 1
ENT.Weapon_IgnoreSpawnMenu = true
ENT.Weapon_CanMoveFire = true
ENT.Weapon_CanCrouchAttack = true -- Can it crouch while firing a weapon?
ENT.Weapon_CrouchAttackChance = 2
ENT.Weapon_MinDistance = 50 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 2000 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 16
ENT.Weapon_Strafe = true
ENT.Weapon_FindCoverOnReload = false

ENT.AnimTbl_WeaponAttackCrouch = {"crouch_shoot_electro", "crouch_shoot_electro_alt"}
ENT.AnimTbl_WeaponAttack = {"stand_shoot_electro", "stand_shoot_electro_alt"}
ENT.AnimTbl_CallForHelp = "signal_flank"
ENT.AnimTbl_DamageAllyResponse = "signal_adv"
ENT.AnimTbl_TakingCover = "cover"

ENT.CanChatMessage = false
ENT.DropWeaponOnDeath = false

ENT.JumpParams = {
	Enabled = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18

ENT.CanFlinch = 1 
ENT.FlinchChance = 4
ENT.AnimTbl_Flinch = {"damage_small"}

ENT.HitGroupFlinching_DefaultWhenNotHit = true
ENT.HitGroupFlinching_Values = {
{HitGroup = {HITGROUP_LEFTARM}, Animation = {"damage_leftarm"}},
{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"damage_rightarm"}},
{HitGroup = {HITGROUP_LEFTLEG}, Animation = {"damage_leftlegs"}},
{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {"damage_rightlegs"}}}

ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = 0.2
ENT.NextMeleeAttackTime = 1.1
ENT.MeleeAttackExtraTimers = {0.9}

ENT.HasRangeAttack = true
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 250

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = false

ENT.CanBeMedic = false

ENT.IdleSoundChance = 1
ENT.IdleDialogueSoundChance = 1
ENT.IdleSoundChance = 1
ENT.IdleDialogueAnswerSoundChance = 1
ENT.CombatIdleSoundChance = 1
ENT.KilledEnemySoundChance = 1
ENT.AllyDeathSoundChance = 1
ENT.FootStepSoundLevel = 50

ENT.SoundTbl_FootStep = {
	"npc/vort/vort_foot1.wav",
	"npc/vort/vort_foot2.wav",
	"npc/vort/vort_foot3.wav",
	"npc/vort/vort_foot4.wav",
}

ENT.SoundTbl_Idle = {
	"npc/shocktrooper/st_idle.wav",
	"npc/shocktrooper/wirt.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/shocktrooper/st_idle.wav",
	"npc/shocktrooper/wirt.wav",
	"npc/shocktrooper/st_gren.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/shocktrooper/st_idle.wav",
	"npc/shocktrooper/wirt.wav",
	"npc/shocktrooper/st_answer.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/shocktrooper/st_check.wav",
	"npc/shocktrooper/st_quest.wav",
}

ENT.SoundTbl_Alert = {
	"npc/shocktrooper/st_alert.wav",
	"npc/shocktrooper/st_alert1.wav",
	"npc/shocktrooper/st_alert2.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/shocktrooper/st_cover.wav",
}

ENT.SoundTbl_Pain = {
	"npc/shocktrooper/shock_trooper_pain1.wav",
	"npc/shocktrooper/shock_trooper_pain2.wav",
	"npc/shocktrooper/shock_trooper_pain3.wav",
	"npc/shocktrooper/shock_trooper_pain4.wav",
	"npc/shocktrooper/shock_trooper_pain5.wav",
}

ENT.SoundTbl_Death = {
	"npc/shocktrooper/shock_trooper_die1.wav",
	"npc/shocktrooper/shock_trooper_die2.wav",
	"npc/shocktrooper/shock_trooper_die3.wav",
	"npc/shocktrooper/shock_trooper_die4.wav",
}

ENT.SoundTbl_MeleeAttack = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard4.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = "npc/shocktrooper/shock_trooper_attack.wav"
ENT.SoundTbl_GrenadeAttack = "npc/shocktrooper/st_throw.wav"
ENT.SoundTbl_DangerSight = "npc/shocktrooper/st_monst.wav"
ENT.SoundTbl_KilledEnemy = "npc/shocktrooper/st_taunt.wav"

ENT.ShockAcid = 0
ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	//self:Give("weapon_vj_cets_shockroach")
	self.BlackAmount = 0
	self.FireInjured = 0

	self.Squadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	local flags = self:GetSpawnFlags()

	if !IsValid(SquadC_Leader) && string.lower(self:GetModel()) == "models/racex/hl2_shock_trooper.mdl" or bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
		VJ.SquadC_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_yield_leader = vj_ai_schedule.New("SCHEDULE_YIELD_LEADER")
schedule_yield_leader:EngTask("TASK_MOVE_AWAY_PATH", 120)
schedule_yield_leader:EngTask("TASK_WALK_PATH", 0)
schedule_yield_leader:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schedule_yield_leader.TurnData = {Type = VJ.FACE_ENTITY_VISIBLE, Target = nil}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink(dmginfo)
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.3, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:SetHealth(54) end end)
		timer.Simple(12, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))

	local randRange = math.random(1, 100)

	if randRange == 1 && self:Health() <= 55 then 
		ParticleEffectAttach("vomit_SHOCK", PATTACH_POINT_FOLLOW, self, 7)
		VJ_EmitSound(self,"ambient/water/water_spray" .. math.random(1, 3) .. ".wav",100,80)
		VJ_EmitSound(self,"npc/shocktrooper/shock_trooper_pain" .. math.random(1, 5) .. ".wav",80,80)
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

			if dist < 100 and not self:IsBusy() then
				schedule_yield_leader.TurnData.Target = leader
				self:StartSchedule(schedule_yield_leader)
				return
			end

			self.DisableWandering = true

			if leaderSpeed < 5 and dist < 140 then
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
		if string.lower(self:GetModel()) == "models/racex/hl2_shock_trooper.mdl" or bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
			VJ.SquadC_Leader = self
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 32)
		if randRange == 1 then
			self.RangeAttackProjectiles = "obj_vj_superspit"
			self.AnimTbl_RangeAttack = {"grenade_launch"}
			self.TimeUntilRangeAttackProjectileRelease = 1.6
			self.NextRangeAttackTime = 1
			self.ShockAcid = 1
		else
			self.RangeAttackProjectiles = "obj_vj_racexenergyorb_b"
			self.AnimTbl_RangeAttack = {"attack_electricity"}
			self.TimeUntilRangeAttackProjectileRelease = 0.001
			self.RangeAttackExtraTimers = false
			self.NextRangeAttackTime = 0.01
			self.ShockAcid = 0
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if self.ShockAcid == 1 then
		ParticleEffectAttach("blood_impact_antlion_01", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("grenade"))
		ParticleEffectAttach("blood_impact_antlion_01", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("grenade"))
	else
		ParticleEffectAttach("racex_arc_02_cp0", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("muzzleflash"))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	if self.ShockAcid == 1 then
		return self:GetAttachment(self:LookupAttachment("grenade")).Pos
	else
		return self:GetAttachment(self:LookupAttachment("muzzleflash")).Pos
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_WALK && self:Health() <= 55 or self.FireInjured == 1 then
		return ACT_WALK_HURT
	elseif act == ACT_RUN && self:Health() <= 55 or self.FireInjured == 1 then
		return ACT_RUN_HURT
	end

	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	local Shockdrop = math.random(1,4)

	if Shockdrop == 1 or 2 then
		self:SetBodygroup(1,0)
	end 

	if Shockdrop == 3 then
	if dmginfo:IsDamageType(DMG_BLAST) or self:IsOnFire() then return false end
		self:SetBodygroup(1,1)
		self.Shock = ents.Create("weapon_ply_shockroach")
		self.Shock:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
		self.Shock:SetAngles(self:GetAngles())
		self.Shock:Spawn()
		self:SetGroundEntity(NULL)
	end

	if Shockdrop == 4 then
	if dmginfo:IsDamageType(DMG_BLAST) or self:IsOnFire() then return false end
		self:SetBodygroup(1,1)
		self.Shock = ents.Create("npc_shockroach_vj_cets")
		self.Shock:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
		self.Shock:SetAngles(self:GetAngles())
		self.Shock:Spawn()
		self.Shock:Activate() 
		self.Shock:SetOwner(self)
		self:SetGroundEntity(NULL)
	end
end