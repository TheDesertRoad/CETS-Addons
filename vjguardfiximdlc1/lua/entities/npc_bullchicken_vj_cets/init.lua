AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_bullsquid.mdl"
ENT.CanChatMessage = false
ENT.StartHealth = GetConVar("sk_cets_bull_health"):GetInt()
ENT.HullType = HULL_WIDE_SHORT
ENT.SightAngle = 280
ENT.SightDistance = 2000
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Aquatic_SwimmingSpeed_Alerted = 200
ENT.Aquatic_AnimTbl_Calm = {ACT_SWIM}
ENT.Aquatic_AnimTbl_Alerted = {ACT_SWIM}
ENT.Aquatic_AnimTbl_Idle = {ACT_SWIM}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = true
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "Mouth"
ENT.AnimTbl_RangeAttack = {"vjseq_spit"}
ENT.RangeAttackEntityToSpawn = "obj_vj_bullspit"
ENT.RangeDistance = 2000
ENT.TimeUntilRangeAttackProjectileRelease = 0.2
ENT.NextRangeAttackTime = 2.8
ENT.RangeToMeleeDistance = 60

ENT.HasExtraMeleeAttackSounds = true
ENT.MeleeAttackKnockBack_Forward1 = 300
ENT.MeleeAttackKnockBack_Forward2 = 300
ENT.MeleeAttackKnockBack_Up1 = 200
ENT.MeleeAttackKnockBack_Up2 = 200
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackDamageDistance = 125
ENT.MeleeAttackDistance = 60

ENT.CanEat = true
ENT.EatCooldown = 30 

ENT.CanFlinch = 0
ENT.FlinchChance = 0
ENT.AnimTbl_Flinch = {ACT_HOP}
ENT.NextFlinchTime = 2.6
ENT.AnimTbl_IdleStand = {ACT_IDLE,"activeidle","idle02"}

ENT.SoundTbl_Idle = {
	"npc/bullsquid/idle1.wav",
	"npc/bullsquid/idle2.wav",
	"npc/bullsquid/idle3.wav",
	"npc/bullsquid/idle4.wav",
	"npc/bullsquid/idle5.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_BeforeRangeAttack = {
	"npc/bullsquid/attack1.wav",
	"npc/bullsquid/attack2.wav",
	"npc/bullsquid/attack3.wav"
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/bullsquid/attackgrowl1.wav",
	"npc/bullsquid/attackgrowl2.wav",
	"npc/bullsquid/attackgrowl3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/bullsquid/pain1.wav",
	"npc/bullsquid/pain2.wav",
	"npc/bullsquid/pain3.wav",
	"npc/bullsquid/pain4.wav",
}

ENT.SoundTbl_Death = {
	"npc/bullsquid/die1.wav",
	"npc/bullsquid/die2.wav",
	"npc/bullsquid/die3.wav",
}

ENT.SoundTbl_Alert = {"npc/bullsquid/excited1.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/zombie/zombie_hit.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("npc_cets_bulls_xenfriends"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
	else
		self.VJ_NPC_Class = {"CLASS_BULL"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.BlackAmount = 0

	if self:WaterLevel() > 0 then 
		self.MovementType = VJ_MOVETYPE_AQUATIC
		self.Behavior = VJ_BEHAVIOR_NEUTRAL
		self.RangeAttackEntityToSpawn = "obj_vj_acidspit_w"
		self:SetCollisionBounds(Vector(15, 15, 10), Vector(-15, -15, 0))
		self.TurningUseAllAxis = true
		self.HasMeleeAttack = false
		self.HasRangeAttack = false
		self.CanFlinch = 0
		self.IdleAlwaysWander = true
		self.AnimTbl_IdleStand = {ACT_SWIM}
		self.CanEat = false
	else
		self:SetSurroundingBounds(Vector(100, 100, 100), Vector(-100, -100, 0))
		self.MovementType = VJ_MOVETYPE_GROUND
		self.RangeDistance = 2000
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
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
			self.AnimTbl_RangeAttack = {"vjges_spit_additive"}
			self.RangeAttackAnimationStopMovement = false
			self.HasRangeAttack = true
		else
			if self.EnemyData.DistanceNearest > 100 && self.EnemyData.DistanceNearest < 2000 then
				self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
				self.RangeAttackAnimationStopMovement = true
				self.HasRangeAttack = true
			else
				self.HasRangeAttack = false
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self:WaterLevel() < 1 then 
		if math.random(1, 2) == 1 then
			self:PlayAnim({"hop"}, true, false, true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnResetEnemy() 
	self:SetMaxLookDistance(2000)
	if self:WaterLevel() > 0 then 
		self.CanFlinch = 0
		self.AnimTbl_IdleStand = {ACT_SWIM}
	else
		self.CanFlinch = 1
		self.AnimTbl_IdleStand = {ACT_IDLE,"activeidle","idle02"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.RangeAttackExtraTimers = false
		elseif randRange == 2 then
			VJ.EmitSound(self, "hl1/ambience/disgusting.wav", 70, 100)
			self.RangeAttackExtraTimers = {0.4,0.6}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.MeleeAttackKnockBack_Forward1 = 300
			self.MeleeAttackKnockBack_Forward2 = 300
			self.MeleeAttackKnockBack_Up1 = 200
			self.MeleeAttackKnockBack_Up2 = 200
			self.MeleeAttackDamage = 25
			self.TimeUntilMeleeAttackDamage = 0.5
			self.AnimTbl_MeleeAttack = "tailwhip"
			self.SoundTbl_MeleeAttack = "npc/bullsquid/tail_whip1.wav"
		elseif randRange == 2 then
			self.MeleeAttackKnockBack_Forward1 = 200
			self.MeleeAttackKnockBack_Forward2 = 300
			self.MeleeAttackKnockBack_Up1 = 120
			self.MeleeAttackKnockBack_Up2 = 180
			self.MeleeAttackDamage = 35
			self.TimeUntilMeleeAttackDamage = 0.5
			self.AnimTbl_MeleeAttack = "spit"
			self.SoundTbl_MeleeAttack = {"npc/bullsquid/bite1.wav", "npc/bullsquid/bite2.wav", "npc/bullsquid/bite3.wav"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute()
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*35 ,Angle(0,0,0),nil)
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*35 ,Angle(0,0,0),nil)
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*35 ,Angle(0,0,0),nil)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Curve", self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() + VectorRand(-5, 5), 1500)
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
		VJ.EmitSound(self, "npc/barnacle/bcl_chew" .. math.random(1, 3) .. ".wav", 70, 80)
		-- Health changes
		local food = self.EatingData.Target
		local damage = 30 -- How much damage food will receive
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
			return select(2, self:PlayAnim("eatdone", true, false))
		end
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "event_emit Foot" then
		self:FootStepSoundCode()
		VJ_EmitSound(self,"npc/bullsquid/water/footl"..math.random(1,4)..".mp3",63,math.random(65,75))
		VJ_EmitSound(self,"npc/bullsquid/water/footr"..math.random(1,4)..".mp3",57,math.random(115,125))
	end
	if key == "Snort" then
		VJ_EmitSound(self,"npc/bullsquids/snort"..math.random(1, 3)..".wav",60,math.random(95,105))
	end
	if key == "Tread" then
		VJ_EmitSound(self,"npc/fast_zombie/foot"..math.random(1,4)..".wav",63,math.random(65,75))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self.EnemyData.DistanceNearest > 800 && self.EnemyData.DistanceNearest < 5000 then
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