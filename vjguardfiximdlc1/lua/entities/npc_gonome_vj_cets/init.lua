AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_gonome.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 750
ENT.HullType = HULL_WIDE_HUMAN
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.CanChatMessage = false
ENT.IdleAlwaysWander = true
ENT.TimeUntilEnemyLost = 5000 
ENT.SightDistance = 10000
ENT.TurningSpeed = 20
ENT.Sightangle = 90 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01" -- Particles to spawn when it's damaged
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanEat = true
ENT.EatCooldown = 30 

ENT.CallForHelp = true
ENT.CallForHelpDistance = 2000
ENT.HasCallForHelpAnimation = true
ENT.InvestigateSoundDistance = 100 
ENT.LastSeenEnemyTimeUntilReset = 1000
ENT.AnimTbl_CallForHelp = {"attack2"} -- Call For Help Animations

ENT.ConstantlyFacingEnemy = true

ENT.CanFlinch = 0
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 55 -- How far does the damage go?
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.NextMeleeAttackTime = 2
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds

ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1 
ENT.MeleeAttackBleedEnemyDamage = 1 
ENT.MeleeAttackBleedEnemyTime = 1
ENT.MeleeAttackBleedEnemyReps = 5

ENT.SlowPlayerOnMeleeAttack = true
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 120 
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 
ENT.SlowPlayerOnMeleeAttackTime = 3 

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {"attack3"}
ENT.RangeAttackProjectiles = {"obj_vj_gonomespit"}
ENT.TimeUntilRangeAttackProjectileRelease = 1.7
ENT.NextRangeAttackTime = 4
ENT.RangeAttackMaxDistance = 5000
ENT.RangeAttackMinDistance = 500
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "0" 

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttackStop = {"jump_glide_end_new"}
ENT.AnimTbl_LeapAttack = {"jump_glide_mid"}
ENT.AnimTbl_BeforeLeapAttack = {"jump_glide_start"}
ENT.LeapAttackMaxDistance = 3000
ENT.LeapAttackMinDistance = 500
ENT.TimeUntilLeapAttackDamage = 0.3
ENT.NextLeapAttackTime = 8
ENT.NextAnyAttackTime_Leap = 0.4
ENT.TimeUntilLeapAttackVelocity = 0.1
ENT.LeapAttackVelocityForward = 400
ENT.LeapAttackVelocityUp = 320
ENT.LeapAttackDamage = 40
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 40

ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking

ENT.MainSoundPitch = 100
ENT.FootStepSoundPitch = 50

ENT.MeleeAttackMissSoundLevel = 60

ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav", "npc/zombie/foot2.wav", "npc/zombie/foot3.wav"}

ENT.SoundTbl_BeforeLeapAttack = {"npc/gonome/gonome_jumpattack.wav"}

ENT.SoundTbl_MeleeAttack = {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav",
}

ENT.SoundTbl_Alert = {
	"npc/zombie/zombie_alert1.wav",
	"npc/zombie/zombie_alert2.wav",
	"npc/zombie/zombie_alert3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/gonome/gonome_pain1.wav",
	"npc/gonome/gonome_pain2.wav",
	"npc/gonome/gonome_pain3.wav",
	"npc/gonome/gonome_pain4.wav",
}

ENT.SoundTbl_Death = {
	"npc/gonome/gonome_death2.wav",
	"npc/gonome/gonome_death3.wav",
	"npc/gonome/gonome_death4.wav",
}

ENT.SoundTbl_Idle = {
	"npc/gonome/gonome_idle1.wav",
	"npc/gonome/gonome_idle2.wav",
	"npc/gonome/gonome_idle3.wav",
}

ENT.SoundTbl_LeapAttackJump = {"npc/gonome/gonome_jumpattack.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize ()
	self:SetSpawnEffect(true)
	self:SetBodygroup(1,0)

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.AnimTbl_Walk = {"walk"}
		self.AnimTbl_Run = {"runlong"}
		self.AnimTbl_IdleStand = {"Idle1", "Idle2"}

		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.3, 1)
		timer.Simple(12, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.AnimTbl_IdleStand = {"idle1", "idle2"}
		self.AnimTbl_Walk = {"walk_new"}
		self.AnimTbl_Run = {"runlong_new_blend"}

		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if math.random(1,5) == 1 then
		self:VJ_ACT_PLAYACTIVITY("Tantrum",true,1,false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.SoundTbl_BeforeMeleeAttack = {"npc/gonome/gonome_melee1.wav"}
			self.TimeUntilMeleeAttackDamage = 0.3
			self.MeleeAttackExtraTimers = {0.6}
			self.MeleeAttackDamage = 15
			self.AnimTbl_MeleeAttack = {"attack1"}
		elseif randRange == 2 then
			self.SoundTbl_BeforeMeleeAttack = {"npc/gonome/gonome_melee2.wav"}
			self.TimeUntilMeleeAttackDamage = 0.2
			self.MeleeAttackExtraTimers = {0.4, 0.6, 0.8}
			self.MeleeAttackDamage = 15
			self.AnimTbl_MeleeAttack = "attack2"
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
		local damage = 30 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
		self:PlayAnim("eat_loop", true, true)
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