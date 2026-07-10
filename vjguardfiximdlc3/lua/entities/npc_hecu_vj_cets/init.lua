AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.AlliedWithPlayerAllies = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 1
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_MeleeAttack = "kick" -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 10
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.GrenadeAttackEntity = "obj_vj_cets_hecxtrac" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.ThrowGrenadeChance = 1 -- Chance that it will throw the grenade | Set to 1 to throw all the time

local mdlHECU = {
	"models/humans/grunt/hgrunt1.mdl",
	"models/humans/grunt/hgrunt2.mdl",
}

local mdlHECUL = {
	"models/humans/grunt/hgrunt1.mdl",
	"models/humans/grunt/hgrunt2.mdl",
	"models/humans/grunt/hgrunt3.mdl",
}

local Weapon_None = -1
local Weapon_MP5SD = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 3
ENT.ItemDropsOnDeath_EntityList = {
	"ent_cets_mp5grenades",
	"item_armor_c",
	"item_health_vial_c",
}

local sdAlertComb = ENT.SoundTbl_Alert 

local sdAlertCP = ENT.SoundTbl_Alert 

local sdAlertZombies = ENT.SoundTbl_Alert 

local sdAlertCrabs = ENT.SoundTbl_Alert

local sdAlertManhacks = ENT.SoundTbl_Alert 

local sdAlertStrider = ENT.SoundTbl_Alert 

ENT.NextDance = 0
ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	local flags = self:GetSpawnFlags()

	self.Weapon_Rand = 1
	if bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
		self.Model = "models/humans/grunt/hgrunt3.mdl"
	elseif math.random(1,2) == 1 then
		self.Model = mdlHECUL
	else
		self.Model = mdlHECU
	end

	self:MaleSounds()
	self:Give("weapon_vj_cets_mp5sd")

	if GetConVar("npc_cets_hecu_voice"):GetInt() == 1 then
		self:HecuSounds()
	else
		self:MaleSounds()
	end
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

	self.Squadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	local flags = self:GetSpawnFlags()

	if !IsValid(SquadC_Leader) && string.lower(self:GetModel()) == "models/humans/grunt/hgrunt3.mdl" or bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
		VJ.SquadC_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) && GetConVar("npc_cets_hecu_voice"):GetInt() == 1 then
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
	elseif self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) && GetConVar("npc_cets_hecu_voice"):GetInt() == 0 then
		self:PlaySoundSystem("Pain", MaleFirePain)
	end		

	if self:Health() > 0 && dmginfo:IsDamageType(DMG_NERVEGAS) then
		self.Bleeds = false
	end

	if status == "PostDamage" && self:Health() > 0 && math.random(1, 2) == 1 then
		if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			self:PlaySoundSystem("Pain", sdPainArm_M)
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			self:PlaySoundSystem("Pain", sdPainLeg_M)
		elseif hitgroup == HITGROUP_STOMACH then
			self:PlaySoundSystem("Pain", sdPainGut_M)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAllyKilled(ent)
	if ent:IsPlayer() then
		self:PlaySoundSystem("AllyDeath", self.SoundTbl_Pain)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_yield_leader = vj_ai_schedule.New("SCHEDULE_YIELD_LEADER")
schedule_yield_leader:EngTask("TASK_MOVE_AWAY_PATH", 120)
schedule_yield_leader:EngTask("TASK_WALK_PATH", 0)
schedule_yield_leader:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schedule_yield_leader.TurnData = {Type = VJ.FACE_ENTITY_VISIBLE, Target = nil}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local flags = self:GetSpawnFlags()

	if self:IsOnFire() && CurTime() > self.NextDance then
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.9, 1)
		self:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
		self.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))
		self.Bleeds = false
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
		timer.Simple(self:SequenceDuration(self:LookupSequence( "bugbait_hit" )), function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	if self:IsOnFire() then
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.9, 1)
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
		if string.lower(self:GetModel()) == "models/humans/grunt/hgrunt3.mdl" or bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
			VJ.SquadC_Leader = self
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	if self.Weapon_Rand == 1 then
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local mp5sd = ents.Create("weapon_vj_cets_mp5sd")
			mp5sd:SetPos(att.Pos)
			mp5sd:SetAngles(att.Ang)
			mp5sd:Spawn()
		end
	else
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local shotgun = ents.Create("weapon_shotgun")
			shotgun:SetPos(att.Pos)
			shotgun:SetAngles(att.Ang)
			shotgun:Spawn()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HecuSounds()
	self.SoundTbl_Idle = {
		"npc/hgrunt/hg_idle1.wav",
		"npc/hgrunt/hg_idle2.wav",
		"npc/hgrunt/hg_idle3.wav",
	}

	self.SoundTbl_IdleDialogue = {
		"npc/hgrunt/hg_question1.wav",
		"npc/hgrunt/hg_question2.wav",
		"npc/hgrunt/hg_question3.wav",
		"npc/hgrunt/hg_question4.wav",
		"npc/hgrunt/hg_question5.wav",
		"npc/hgrunt/hg_question6.wav",
		"npc/hgrunt/hg_question7.wav",
		"npc/hgrunt/hg_question8.wav",
		"npc/hgrunt/hg_question9.wav",
		"npc/hgrunt/hg_question10.wav",
		"npc/hgrunt/hg_question11.wav",
		"npc/hgrunt/hg_question12.wav",
	}

	self.SoundTbl_IdleDialogueAnswer = {
		"npc/hgrunt/hg_answer1.wav",
		"npc/hgrunt/hg_answer2.wav",
		"npc/hgrunt/hg_answer3.wav",
		"npc/hgrunt/hg_answer4.wav",
		"npc/hgrunt/hg_answer5.wav",
		"npc/hgrunt/hg_answer6.wav",
		"npc/hgrunt/hg_answer7.wav",
	}

	self.SoundTbl_CombatIdle = {
		"npc/hgrunt/hg_combat1.wav",
		"npc/hgrunt/hg_combat2.wav",
		"npc/hgrunt/hg_combat3.wav",
		"npc/hgrunt/hg_combat4.wav",
	}

	self.SoundTbl_ReceiveOrder = false

	self.SoundTbl_FollowPlayer = false

	self.SoundTbl_UnFollowPlayer = false

	self.SoundTbl_YieldToPlayer = false

	self.SoundTbl_MedicBeforeHeal = false

	self.SoundTbl_OnPlayerSight = {
		"npc/hgrunt/freeman!.wav",
		"npc/hgrunt/freeman.wav",
	}

	self.SoundTbl_Investigate = {
		"npc/hgrunt/hg_check1.wav",
		"npc/hgrunt/hg_check2.wav",
		"npc/hgrunt/hg_check3.wav",
		"npc/hgrunt/hg_check4.wav",
		"npc/hgrunt/hg_check5.wav",
		"npc/hgrunt/hg_check6.wav",
		"npc/hgrunt/hg_check7.wav",
		"npc/hgrunt/hg_check8.wav",
	}

	self.SoundTbl_LostEnemy = {
		"npc/hgrunt/hg_clear1.wav",
		"npc/hgrunt/hg_clear2.wav",
		"npc/hgrunt/hg_clear3.wav",
		"npc/hgrunt/hg_clear4.wav",
		"npc/hgrunt/hg_clear5.wav",
		"npc/hgrunt/hg_clear6.wav",
		"npc/hgrunt/hg_clear7.wav",
		"npc/hgrunt/hg_clear8.wav",
		"npc/hgrunt/hg_clear9.wav",
		"npc/hgrunt/hg_clear10.wav",
		"npc/hgrunt/hg_clear11.wav",
		"npc/hgrunt/hg_clear12.wav",
	}

	self.SoundTbl_Alert = {
		"npc/hgrunt/hg_alert1.wav",
		"npc/hgrunt/hg_alert2.wav",
		"npc/hgrunt/hg_alert3.wav",
		"npc/hgrunt/hg_alert4.wav",
		"npc/hgrunt/hg_alert5.wav",
		"npc/hgrunt/hg_alert6.wav",
		"npc/hgrunt/hg_alert7.wav",
		"npc/hgrunt/hg_alert8.wav",
		"npc/hgrunt/hg_alert9.wav",
		"npc/hgrunt/hg_alert10.wav",
	}

	self.SoundTbl_CallForHelp = {
		"npc/hgrunt/hg_cover1.wav",
		"npc/hgrunt/hg_cover2.wav",
		"npc/hgrunt/hg_cover3.wav",
		"npc/hgrunt/hg_cover4.wav",
		"npc/hgrunt/hg_cover5.wav",
		"npc/hgrunt/hg_cover6.wav",
		"npc/hgrunt/hg_cover7.wav",
		"npc/hgrunt/hg_cover8.wav",
		"npc/hgrunt/hg_cover9.wav",
	}

	self.SoundTbl_BecomeEnemyToPlayer = false

	self.SoundTbl_WeaponReload = {
		"npc/hgrunt/hg_reload1.wav",
	}

	self.SoundTbl_GrenadeSight = {
		"npc/hgrunt/hg_grenadealert1.wav",
		"npc/hgrunt/hg_grenadealert2.wav",
		"npc/hgrunt/hg_grenadealert3.wav",
		"npc/hgrunt/hg_grenadealert4.wav",
		"npc/hgrunt/hg_grenadealert5.wav",
		"npc/hgrunt/hg_grenadealert6.wav",
	}

	self.SoundTbl_DangerSight = false

	self.SoundTbl_KilledEnemy = {
		"npc/hgrunt/hg_taunt1.wav",
		"npc/hgrunt/hg_taunt2.wav",
		"npc/hgrunt/hg_taunt3.wav",
		"npc/hgrunt/hg_taunt4.wav",
		"npc/hgrunt/hg_taunt5.wav",
		"npc/hgrunt/hg_taunt6.wav",
	}

	self.SoundTbl_AllyDeath = {
		"npc/hgrunt/hg_allydeath.wav",
	}

	self.SoundTbl_Pain = {
		"npc/hgrunt/hg_pain1.wav",
		"npc/hgrunt/hg_pain2.wav",
		"npc/hgrunt/hg_pain3.wav",
		"npc/hgrunt/hg_pain4.wav",
		"npc/hgrunt/hg_pain5.wav",
	}

	self.SoundTbl_Death = {
		"npc/hgrunt/hg_die1.wav",
		"npc/hgrunt/hg_die2.wav",
		"npc/hgrunt/hg_die3.wav",
	}
end