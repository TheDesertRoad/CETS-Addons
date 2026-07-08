AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_agrunt.mdl"
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

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_alienhornet_ng"
ENT.TimeUntilRangeAttackProjectileRelease = 0.01
ENT.RangeAttackMaxDistance = 1024
ENT.RangeAttackMinDistance = 128
ENT.NextRangeAttackTime = 0.4
ENT.AnimTbl_RangeAttack = {"fire2", "fire3"}

ENT.ChargeDuration = math.random(8, 16)
ENT.ChargeCooldown = math.random(5, 12)
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(10, 10, 85), Vector(-10, -10, 0))

	self.NextChargeTime = CurTime()

	self.Bullseye = ents.Create("obj_vj_Bullseye")
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
	if IsValid(self.ChargeTrailDummy) then return end

	local dummy = ents.Create("base_anim")
	if not IsValid(dummy) then return end

	dummy:SetPos(self:GetAttachment(8).Pos)
	dummy:SetAngles(self:GetAngles())
	dummy:SetNoDraw(true)
	dummy:Spawn()
	dummy:SetParent(self)

	util.SpriteTrail(dummy, 0, Color(128, 128, 128, 24), false, 64, 0, 1, 0.5 / 48, "sprites/baku_burntcer_smoke")

	self.ChargeTrailDummy = dummy
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopChargeTrail()
	if IsValid(self.ChargeTrailDummy) then
		self.ChargeTrailDummy:Remove()
		self.ChargeTrailDummy = nil
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
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("Muzzle")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	self:StopSound("npc/alien_grunt/ag_charging1.wav")
	self:StopChargeTrail()
	ParticleEffect("jeff_blood_small", self:GetAttachment(self:LookupAttachment("Muzzle")).Pos, self:GetForward():Angle(), self)
	ParticleEffect("stinger_spray_gas_b", self:GetAttachment(self:LookupAttachment("Muzzle")).Pos, self:GetForward():Angle(), self)
	
	if status == "PostSpawn" then
		projectile.Track_Ent = enemy
		local att = self:GetAttachment(self:LookupAttachment("Muzzle"))
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
	local damaged_ents = util.VJ_SphereDamage(self, self, self:GetPos() + self:GetForward()*50, 50, damage, damagetype, true, realisticRadius)
	local NPCWasHit = false

	if self.Charging then

	for _,ent in pairs(damaged_ents) do

		local hitpos = ent:GetPos() + ent:OBBCenter()
		local attack_dir = (hitpos - self:GetPos()):GetNormalized()

		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("Shatter")
		end

		if ent:IsNPC() or ent:IsPlayer() then
			if ent:IsPlayer() then
				ent:SetVelocity( Vector( attack_dir.x , attack_dir.y , 0 )*80 + Vector(0,0,246) )
			elseif !ent.VJ_IsHugeMonster then
				ent:SetVelocity( Vector( attack_dir.x , attack_dir.y , 0 )*150 + Vector(0,0,246) )
			end
			NPCWasHit = true
		end

		if ent:GetMoveType() == MOVETYPE_VPHYSICS && ent:IsSolid() then
			local physobj = ent:GetPhysicsObject()
				if IsValid(physobj) then
				physobj:SetVelocity(attack_dir * 300)
			end
		end
	end

	if NPCWasHit then
		self:PlaySoundSystem("MeleeAttack", SoundTbl_MeleeAttack)
		return true
	end

	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Attacking() if self.Charging or self.MeleeAttacking then return true end end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanChargeEnemy()
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetEnemy():GetPos(),
		mask = MASK_NPCWORLDSTATIC,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs(),
	})

	if self:Visible(self:GetEnemy()) && self:GetEnemy():IsOnGround() && !tr.Hit then
		return true
	end
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

	local speed = 512
	if self.Charge_ShouldApplyForce && self:IsOnGround() then
		self:SetVelocity(self:GetForward()*speed)
	end

	if self:CustomMeleeDamage(self.ChargeDamage, bit.bor(DMG_CLUB,DMG_CRUSH,DMG_SLASH)) == true then -- Player or NPC was hit.
		self:StopCharging(false,self.ChargeCooldown)
		self:EmitSound("npc/gargantua/gar_shove2.wav",90,math.random(90,110))
		ParticleEffect("gonarch_footstep_4", self:GetPos() + self:GetUp()*30, Angle(0,0,0))
		self:VJ_ACT_PLAYACTIVITY("MGrunt_Charge_Crash", true, duration, true)
	end

	local collision_positions = {
		self:GetPos() + self:GetForward()*100,
		self:GetPos() + self:GetForward()*100 + self:GetRight() * 65,
		self:GetPos() + self:GetForward()*100 - self:GetRight() * 65,
	}

	for k,pos in pairs(collision_positions) do
		if bit.band( util.PointContents(pos) , CONTENTS_SOLID ) == CONTENTS_SOLID then
			self:StopCharging(true,self.ChargeCooldown*0.5)
			break
		end
	end

	local trStartPos = self:GetPos()+self:GetForward()*50
	local tr = util.TraceLine({
		start = trStartPos,
		endpos = trStartPos - Vector(0,0,15),
		mask = MASK_NPCWORLDSTATIC,
	})

	if !tr.Hit then
		self:StopCharging(true,self.ChargeCooldown*0.5)
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

	if UseAnimation then self:VJ_ACT_PLAYACTIVITY("MGrunt_Charge_Cancel", true, duration, true) end

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