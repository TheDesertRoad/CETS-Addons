AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.VJ_ID_Boss = true
ENT.Model = "models/hl2_tentacle.mdl"
ENT.StartHealth = GetConVar("sk_cets_tentacle_health"):GetInt()
ENT.TurningSpeed = 8
ENT.SightDistance = 1299
ENT.TimeUntilEnemyLost = 5
ENT.IsGuard = true
ENT.SightAngle = 180
ENT.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}	
ENT.VJ_ID_Boss = true
ENT.HullType = HULL_LARGE
ENT.MovementType = VJ_MOVETYPE_GROUND
ENT.CanChatMessage = false
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
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 500
ENT.MeleeAttackDamageDistance = 380
ENT.MeleeAttackDamageAngleRadius = 10

ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathAnimationTime = 17

ENT.GibOnDeathFilter = false
ENT.HasDeathCorpse = false
ENT.ConstantlyFacingEnemy = false

ENT.IdleSoundsWhileAttacking = true

ENT.MainSoundPitch = 100
ENT.BreathSoundLevel = 100
ENT.DeathSoundLevel = 110

ENT.SoundTbl_Breath = "npc/tentacle/te_flies1.wav"

ENT.SoundTbl_Idle = {
	"npc/tentacle/te_sing1.wav",
	"npc/tentacle/te_sing2.wav",
}

ENT.SoundTbl_Alert = {
	"npc/tentacle/te_alert1.wav",
	"npc/tentacle/te_alert2.wav",
}

ENT.SoundTbl_Investigate = {
	"npc/tentacle/te_search1.wav",
	"npc/tentacle/te_search2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/tentacle/te_roar1.wav",
	"npc/tentacle/te_roar2.wav",
}

ENT.SoundTbl_Death = "npc/tentacle/te_death2.wav"

local sdBeakStrike = {
	"npc/gonarch/gon_impact1.wav",
	"npc/gonarch/gon_impact1.wav",
}

local sdBeakStrikeDirtyAhh = {
	"npc/tentacle/te_strike1.wav",
	"npc/tentacle/te_strike2.wav",
}	

local sdChangeLevel = {
	"npc/tentacle/te_swoosh1.wav",
	"npc/tentacle/te_swoosh2.wav",
	"npc/tentacle/te_swoosh3.wav",
}

ENT.Tentacle_Level = 0
ENT.Tentacle_Dam = 0
ENT.Tentacle_DamAt = 0
//0 = Floor level
//1 = Medium Level
//2 = High Level
//3 = Extreme Level

local vecN = Vector(-20, -20, 0)
local vecLvl0 = Vector(20, 20, 160)
local vecLvl1 = Vector(20, 20, 380)
local vecLvl2 = Vector(20, 20, 580)
local vecLvl3 = Vector(20, 20, 650)

ENT.ExplosionInvestigateRange = 360
ENT.ExplosionMemoryTime = 5
ENT.ExplosionTurnSpeed = 8

ENT.ExplosionSoundRange = 256
ENT.ExplosionSoundMemory = 5
ENT.ExplosionSoundTurnSpeed = 8

ENT.SoundAlertRange = 360
ENT.SoundAlertDuration = 8
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 160), Vector(-20, -20, 0))
	self:SetSurroundingBounds(Vector(-300, -300, 0), Vector(300, 300, 750))
	self:SetLocalVelocity(self:GetMoveVelocity() * 0)

	self.BlackAmount = 0

	if GetConVar("npc_cets_tentacle_death_anim"):GetInt() == 1 then
		self.HasDeathAnimation = true
	else
		self.HasDeathAnimation = false
	end

	if GetConVar("npc_cets_tentacle_regen"):GetInt() == 1 then
		self.HealthRegenParams = {
			Enabled = true, 
			Amount = 3.33, 
			Delay = VJ.SET(0.1, 2), 
			ResetOnDmg = false
		}
	end

	self.LockTopLevel = false
	self.ImDying = false
	self.DeathSequence = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Cycle through height levels")
	
	self.CanTurnWhileStationary = true
	controlEnt.LastTentacleLevel = self.Tentacle_Level
	
	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE then
			local npc = self.VJCE_NPC
			local curLvl = npc.Tentacle_Level
			//print("Cur: " .. curLvl)
			//print("Last: " .. self.LastTentacleLevel)
			if curLvl == 0 then
				npc:Tentacle_CalculateLevel(170)
			elseif curLvl == 1 then
				npc:Tentacle_CalculateLevel(self.LastTentacleLevel == 2 and 0 or 430)
			elseif curLvl == 2 then
				npc:Tentacle_CalculateLevel(self.LastTentacleLevel == 3 and 0 or 570)
			elseif curLvl == 3 then
				npc:Tentacle_CalculateLevel(0)
			end
			self.LastTentacleLevel = curLvl
		end
	end
	
	function controlEnt:OnStopControlling(keyPressed)
		self.CanTurnWhileStationary = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "attack" && GetConVar("npc_cets_tentacle_strike_non_metal"):GetInt() == 0 then
		self:ExecuteMeleeAttack()
		self:PlaySoundSystem("MeleeAttack", sdBeakStrikeDirtyAhh)
		local ene = self:GetEnemy()
		if IsValid(ene) then self:SetAngles(self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle())) end

	elseif key == "attack" && GetConVar("npc_cets_tentacle_strike_non_metal"):GetInt() == 1 then
		self:ExecuteMeleeAttack()
		self:PlaySoundSystem("MeleeAttack", sdBeakStrike)
		local ene = self:GetEnemy()
		if IsValid(ene) then self:SetAngles(self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle())) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self.MovementType = VJ_MOVETYPE_STATIONARY
	if self.VJ_IsBeingControlled then return end
	local ene = self:GetEnemy()

	if not IsValid(self:GetEnemy()) && self.LastExplosionSoundPos && CurTime() < self.LastExplosionSoundTime then
		local targetAng = self:GetTurnAngle((self.LastExplosionSoundPos - self:GetPos()):Angle())
		local ang = self:GetAngles()

		ang.y = math.ApproachAngle(ang.y, targetAng.y, FrameTime() * self.ExplosionSoundTurnSpeed * 100)
		self:SetAngles(ang)
	end

	if not IsValid(self:GetEnemy()) && self.LastExplosionPos && CurTime() < self.LastExplosionTime then
		local targetAng = self:GetTurnAngle((self.LastExplosionPos - self:GetPos()):Angle())
		local curAng = self:GetAngles()

		curAng.y = math.ApproachAngle(curAng.y, targetAng.y, FrameTime() * self.ExplosionTurnSpeed * 100)
		self:SetAngles(curAng)
	end

	if self.LastExplosionPos then
		local dist = self:GetPos():Distance(self.LastExplosionPos)

		if dist > 1 then
			self:Tentacle_CalculateLevel(dist)
		end
	end

	if IsValid(ene) then
		local targetAng = self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle())
		local curAng = self:GetAngles()

		curAng.y = math.ApproachAngle(curAng.y, targetAng.y, FrameTime() * self.TurningSpeed * 100)

		self:SetAngles(curAng)
	end

	if IsValid(ene) then
		if (ene:IsNPC() && ene:IsMoving()) or (VJ.GetMoveVelocity(ene):Length() > 50 && ene:IsOnGround()) then
			self.CanTurnWhileStationary = true
		else
			self.CanTurnWhileStationary = false
		end
		
		if self.CanTurnWhileStationary == true && not self.DeathSequence then
			self:Tentacle_CalculateLevel((self:GetEnemyLastKnownPos() - self:GetPos()).z)
		end
	else
		self.CanTurnWhileStationary = false
	end

	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.2, 1)
		timer.Simple(24, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if self.Tentacle_Level == 1 then
			return ACT_IDLE_RELAXED
		elseif self.Tentacle_Level == 2 then
			return ACT_IDLE_ANGRY_MELEE
		elseif self.Tentacle_Level == 3 then
			return ACT_IDLE_ANGRY
		end
	end

	if act == ACT_SIGNAL1 then
		if self.Tentacle_Dam == 1 then
			return false
		end
	end

	if act == ACT_SIGNAL2 then
		if self.Tentacle_Dam == 1 then
			return false
		end
	end

	if act == ACT_SIGNAL3 then
		if self.Tentacle_Dam == 1 then
			return false
		end
	end

	if act == ACT_SIGNAL_ADVANCE then
		if self.Tentacle_Dam == 1 then
			return false
		end
	end

	if act == ACT_SIGNAL_FORWARD then
		if self.Tentacle_Dam == 1 then
			return false
		end
	end

	if act == ACT_SIGNAL_HALT then
		if self.Tentacle_Dam == 1 then
			return false
		end
	end

	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	local randRange = math.random(1, 75)

	if dmginfo:IsDamageType( DMG_BLAST ) && GetConVar("npc_cets_tentacle_forehide"):GetInt() == 1 or randRange == 75 && GetConVar("npc_cets_tentacle_forehide"):GetInt() == 1 then 
			ParticleEffect("gonarch_footstep_2", self:GetPos(), Angle(0,0,0), nil)
			self:VJ_ACT_PLAYACTIVITY("pit_idle",true,4,false)
			VJ_EmitSound(self,"npc/antlion/rumble1.wav",100,100)
			VJ_EmitSound(self,"npc/antlion/muffled_boulder_impact_hard" .. math.random(1, 3) .. ".wav",100,100)
			VJ_EmitSound(self,"npc/tentacle/te_roar" .. math.random(1, 2) .. ".wav",100,70)
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.HasMeleeAttack = false
			self.IsGuard = true
			self.CallForHelp = false
			self.Tentacle_Dam = 1
			self.CanInvestigate = false
			self.EnemyDetection = false
			self.GodMode = true
			timer.Simple(4,function() if IsValid(self) then
				ParticleEffect("gonarch_footstep_3", self:GetPos(), Angle(0,0,0), nil)
				self:VJ_ACT_PLAYACTIVITY("rise_to_temp1",true,3.6,false)
				VJ_EmitSound(self,"npc/antlion/rumble1.wav",100,120)
				VJ_EmitSound(self,"npc/antlion/muffled_boulder_impact_hard" .. math.random(1, 3) .. ".wav",100,120)
				VJ_EmitSound(self,"npc/tentacle/te_alert" .. math.random(1, 2) .. ".wav",100,50)
				self.MovementType = VJ_MOVETYPE_STATIONARY
				self.HasMeleeAttack = false
				self.IsGuard = true
				self.CallForHelp = false
				self.Tentacle_Dam = 1
				self.CanInvestigate = false
				self.EnemyDetection = false
				self.GodMode = true
				timer.Simple(3.6,function() if IsValid(self) then
					self.MovementType = VJ_MOVETYPE_STATIONARY
					self.HasMeleeAttack = true
					self.IsGuard = true
					self.Tentacle_Level = 1
					self.CallForHelp = true
					self.Tentacle_Dam = 0
					self.CanInvestigate = true
					self.EnemyDetection = true
					self.GodMode = false
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo)
	if self.DeathSequence then return end

	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()

	if self:Health() - dmginfo:GetDamage() <= 0 then
	  	self.DeathSequence = true

		dmginfo:SetDamage(0)
		self:SetHealth(1)
		self.GodMode = true

		local function RiseAndDie()
			if not IsValid(self) then return end

			if self.Tentacle_Level == 0 then
				self:Tentacle_CalculateLevel(170)
				timer.Simple(0.5, RiseAndDie)

			elseif self.Tentacle_Level == 1 then
				self:Tentacle_CalculateLevel(430)
				timer.Simple(0.5, RiseAndDie)

			elseif self.Tentacle_Level == 2 then
				self:Tentacle_CalculateLevel(570)
				timer.Simple(0.5, RiseAndDie)
			else
				self.GodMode = false
				self:TakeDamage(999999, attacker, inflictor)
			end
		end

		RiseAndDie()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	local attapeak = self:GetAttachment(1)

	if GetConVar("npc_cets_tentacle_strike_non_metal"):GetInt() == 0 then
		self.Spark1 = ents.Create("env_spark")
			self.Spark1:SetPos(attapeak.Pos + self:GetForward()*-20 )
			self.Spark1:Spawn()
			self.Spark1:SetKeyValue("Magnitude",1)
			self.Spark1:SetKeyValue("Spark Trail Length",2)
			self.Spark1:Fire("StartSpark", "", 0)
			self.Spark1:Fire("StopSpark", "", 0.1)
			self.Spark1:SetSpawnFlags( 256 )
		self:DeleteOnRemove(self.Spark1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tentacle_DoLevelChange(num)
	local lvl = self.Tentacle_Level + num
	VJ.EmitSound(self, sdChangeLevel)

	if lvl == 0 then
		self.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
		self.Tentacle_Level = 0
		self:SetCollisionBounds(vecLvl0, vecN)
	elseif lvl == 1 then
		self.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK2
		self.Tentacle_Level = 1
		self:SetCollisionBounds(vecLvl1, vecN)
	elseif lvl == 2 then
		self.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK1_LOW
		self.Tentacle_Level = 2
		self:SetCollisionBounds(vecLvl2, vecN)
	elseif lvl == 3 then
		self.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK2_LOW
		self.Tentacle_Level = 3
		self:SetCollisionBounds(vecLvl3, vecN)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- 0 to 1 = ACT_SIGNAL1				1 to 2 = ACT_SIGNAL2			2 to 3 = ACT_SIGNAL3
-- 1 to 0 = ACT_SIGNAL_ADVANCE		2 to 1 = ACT_SIGNAL_FORWARD		3 to 2 = ACT_SIGNAL_HALT
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tentacle_CalculateLevel(eneDist)
	if self.NextLevelChange && CurTime() < self.NextLevelChange then
		return
	end

	self.NextLevelChange = CurTime() + 1.0 

	local targetLevel

	if eneDist >= 570 then
		targetLevel = 3
	elseif eneDist >= 430 then
		targetLevel = 2
	elseif eneDist >= 170 then
		targetLevel = 1
	else
		targetLevel = 0
	end

	if self.Tentacle_Level == targetLevel then return end

	if self.Tentacle_Level < targetLevel then
		if self.Tentacle_Level == 0 then
			self:PlayAnim(ACT_SIGNAL1, true, false, false)
		elseif self.Tentacle_Level == 1 then
			self:PlayAnim(ACT_SIGNAL2, true, false, false)
		elseif self.Tentacle_Level == 2 then
			self:PlayAnim(ACT_SIGNAL3, true, false, false)
		end

		self:Tentacle_DoLevelChange(1)
		return
	end

	if self.Tentacle_Level > targetLevel then
		if self.Tentacle_Level == 3 then
			self:PlayAnim(ACT_SIGNAL_HALT, true, false, false)
		elseif self.Tentacle_Level == 2 then
			self:PlayAnim(ACT_SIGNAL_FORWARD, true, false, false)
		elseif self.Tentacle_Level == 1 then
			self:PlayAnim(ACT_SIGNAL_ADVANCE, true, false, false)
		end

		self:Tentacle_DoLevelChange(-1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleGibOnDeath()
	self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled()
	self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
	self.MovementType = VJ_MOVETYPE_STATIONARY
	self.HasMeleeAttack = false
	self.IsGuard = true
	self.CallForHelp = false
	self.EnemyDetection = false

	VJ_EmitSound(self,"phx/explode00.wav",100,100)
	VJ_EmitSound(self,"npc/gonarch/gon_explode.wav",100,100)

	util.ScreenShake(self:GetPos(),22,500,1,500)
	ParticleEffect("gonarch_explode_alternate2", self:GetPos(), Angle(0,0,0), nil)
end