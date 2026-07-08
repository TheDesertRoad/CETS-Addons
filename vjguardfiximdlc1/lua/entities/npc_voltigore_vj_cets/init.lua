AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_voltigore.mdl"
ENT.StartHealth = 800
ENT.HullType = HULL_LARGE
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
ENT.CanChatMessage = false
ENT.VJ_IsHugeMonster = true
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
ENT.NextMeleeAttackTime = 1
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 150 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 95
ENT.MeleeAttackDamageDistance = 100

ENT.CanEat = true
ENT.EatCooldown = 30 

ENT.HasDeathAnimation = true
ENT.HasDeathCorpse = false
ENT.AnimTbl_Death = {"diesimple", "diesideways", "dieforward"}

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = {"obj_vj_racexenergyorb"}
ENT.AnimTbl_RangeAttack = {"attack_electric"}
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 100
ENT.RangeAttackExtraTimers = {1.1, 1.2, 1.3, 1.4}
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 5

ENT.HasExtraMeleeAttackSounds = true

ENT.SoundTbl_FootStepLevel = 120

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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(60, 60, 95), Vector(-60, -60, 0))
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.3, 1)
		timer.Simple(12, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.MeleeAttackDamage = 30
			self.AnimTbl_MeleeAttack = {"melee_leftpaw"}
			self.TimeUntilMeleeAttackDamage = 0.2
			self.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
			self.MeleeAttackKnockBack_Forward2 = 150 -- How far it will push you forward | Second in math.random
		elseif randRange == 2 then
			self.MeleeAttackDamage = 60
			self.AnimTbl_MeleeAttack = {"melee_bothpaw1", "melee_bothpaw2"}
			self.TimeUntilMeleeAttackDamage = 1
			self.MeleeAttackKnockBack_Forward1 = 180 -- How far it will push you forward | First in math.random
			self.MeleeAttackKnockBack_Forward2 = 220 -- How far it will push you forward | Second in math.random
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("electric")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	local elecTime = 0.6

	ParticleEffectAttach("racex_arc_01_parent",PATTACH_POINT_FOLLOW,self,2)
	ParticleEffectAttach("racex_arc_01_parent",PATTACH_POINT_FOLLOW,self,3)
	ParticleEffectAttach("racex_floaters2",PATTACH_POINT_FOLLOW,self,4)

	if status == "PostInit" then
		local endPos = self:GetAttachment(self:LookupAttachment("electric")).Pos 
		for att = 1, 4 do
			local tr = util.TraceLine({
				start = self:GetAttachment(att).Pos,
				endpos = endPos,
				filter = self
			})
			local elec = EffectData()
			elec:SetStart(tr.StartPos)
			elec:SetOrigin(tr.HitPos)
			elec:SetEntity(self)
			elec:SetAttachment(att)
			elec:SetScale(elecTime)
			util.Effect("cets_alien_beam1", elec)
		end
		
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "sprites/misc/lightflare.vmt")
		spr:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("Color", "255 86 255")
		spr:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
		spr:SetKeyValue("renderamt", "255") -- Transparency
		spr:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
		spr:SetKeyValue("framerate", "10.0") -- Rate at which the sprite should animate, if at all.
		spr:SetKeyValue("spawnflags", "0")
		spr:SetParent(self)
		spr:Fire("SetParentAttachment", "electric")
		spr:Spawn()
		spr:Activate()
		self:DeleteOnRemove(spr)
		timer.Simple(elecTime, function() if IsValid(self) && IsValid(spr) then spr:Remove() end end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------
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

	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.8, 2, 400, 32, 3, Color(255, 25, 255, 64))

	VJ_EmitSound(self,"phx/eggcrack.wav",100,70)
	VJ_EmitSound(self,"hl1/weapons/lhit.wav",100,70)
	VJ_EmitSound(self,"npc/antlion_grub/agrub_squish1.wav",100,50)
	VJ_EmitSound(self,"npc/antlion_grub/agrub_squish2.wav",100,50)
	VJ_EmitSound(self,"npc/antlion_grub/agrub_squish3.wav",100,50)

	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_1.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_2.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_small_3.mdl", {BloodType="Yellow", CollisionDecal="VJ_CETS_Voltigore_Blood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
end