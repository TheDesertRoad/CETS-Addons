AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/classic_armored.mdl"}
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.StartHealth = GetConVar("sk_cets_reviverzom_health"):GetInt()
ENT.SightDistance = 10000
ENT.Sightangle = 80 
ENT.TurningSpeed = 20
ENT.HullType = HULL_HUMAN
ENT.TimeUntilEnemyLost = 5000 
ENT.LastSeenEnemyTimeUntilReset = 1000 -- Time until it resets its enemy if its current enemy is not visible
ENT.InvestigateSoundDistance = 100 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
ENT.CanChatMessage = false
ENT.UsePoseParameterMovement = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Blue"
ENT.BloodDecal = "VJ_CETS_BBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.MeleeAttackDistance = 35
ENT.MeleeAttackDamageDistance = 65
ENT.TimeUntilNextMeleeAttack = 0.2
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 250
ENT.MeleeAttackKnockBack_Forward2 = 300
ENT.MeleeAttackDamageType = DMG_SHOCK

ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1 
ENT.MeleeAttackBleedEnemyDamage = 1 
ENT.MeleeAttackBleedEnemyTime = 0.2
ENT.MeleeAttackBleedEnemyReps = 10

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = "tantrum"
ENT.RangeAttackEntityToSpawn = "obj_vj_electricspit" -- The entity that is spawned when range attacking
ENT.NextRangeAttackTime = 1 -- How much time until it can use a range attack? //2.33333
ENT.RangeDistance = 1200 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 0 -- How close does it have to be until it uses melee?

ENT.CanFlinch = true
ENT.FlinchChance = 8
ENT.FlinchCooldown = 3
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS
ENT.FlinchHitGroupMap = {
	{HitGroup = HITGROUP_HEAD, Animation = "vjges_flinch_head"},
	{HitGroup = HITGROUP_CHEST, Animation = "vjges_flinch_chest"},
	{HitGroup = HITGROUP_LEFTARM, Animation = "vjges_flinch_leftArm"},
	{HitGroup = HITGROUP_RIGHTARM, Animation = "vjges_flinch_rightArm"},
	{HitGroup = HITGROUP_LEFTLEG, Animation = ACT_FLINCH_LEFTLEG},
	{HitGroup = HITGROUP_RIGHTLEG, Animation = ACT_FLINCH_RIGHTLEG}
}

ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking

ENT.MainSoundPitch = 100
ENT.FootStepSoundPitch = 100
ENT.MeleeAttackSoundPitch = 100
ENT.MeleeAttackMissSoundPitch = 100

ENT.IdleSoundsWhileAttacking = true

ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav","npc/zombie/foot_slide1.wav","npc/zombie/foot_slide2.wav","npc/zombie/foot_slide3.wav"}

ENT.SoundTbl_Breath = {"npc/reviver/shockwave_projectile_loop.wav"}

ENT.SoundTbl_Idle = {
	"npc/reviver/vox_grunt_misc_01.wav",
	"npc/reviver/vox_grunt_misc_02.wav",
	"npc/reviver/vox_grunt_misc_03.wav",
	"npc/reviver/vox_grunt_misc_04.wav",
	"npc/reviver/vox_grunt_misc_05.wav",
	"npc/reviver/vox_grunt_misc_06.wav",
	"npc/reviver/vox_grunt_misc_07.wav",
	"npc/reviver/vox_grunt_misc_08.wav",
	"npc/reviver/vox_grunt_misc_09.wav",
	"npc/reviver/vox_grunt_misc_010.wav",
	"npc/reviver/vox_grunt_misc_011.wav",
	"npc/reviver/vox_grunt_misc_012.wav",
}

ENT.SoundTbl_Alert = {
	"npc/reviver/shockwave_rise_bass_01.wav",
	"npc/reviver/shockwave_rise_bass_02.wav",
	"npc/reviver/shockwave_rise_bass_03.wav",
}

ENT.SoundTbl_MeleeAttack = {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"weapons/stunstick/stunstick_swing1.wav",
	"weapons/stunstick/stunstick_swing2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/reviver/vox_pain.wav",
}

ENT.SoundTbl_Death = {
	"npc/reviver/vox_abandon_gurgle_01.wav",
	"npc/reviver/vox_abandon_gurgle_02.wav",
	"npc/reviver/vox_abandon_gurgle_03.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize ()
	self:SetSpawnEffect(true)
	self:SetBodygroup(1,0)

	VJ_EmitSound(self, "npc/reviver/vox_revived_screech_0" .. math.random(1, 2) .. ".wav", 90, 100)

	self.NextTesla = CurTime()

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if self:IsOnFire() then
			return ACT_IDLE_ON_FIRE
		end
	elseif (act == ACT_RUN or act == ACT_WALK) && self:IsOnFire() then
		return ACT_WALK_ON_FIRE
	end
	return act
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.MeleeAttackDamage = 10
			self.AnimTbl_MeleeAttack = {"attacka", "attackb", "attackc", "attackd"}
			self.TimeUntilMeleeAttackDamage = 0.8
			self.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack2.wav"}
		elseif randRange == 2 then
			self.MeleeAttackDamage = 25
			self.AnimTbl_MeleeAttack = {"attacke", "attackf"}
			self.TimeUntilMeleeAttackDamage = 0.9
			self.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack1.wav"}
		end

	elseif status == "Init" && self:GetModel("models/Zombie/burnzie.mdl") then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.MeleeAttackDamage = 15
			self.AnimTbl_MeleeAttack = {"attackleft", "attackleft2"}
			self.TimeUntilMeleeAttackDamage = 0.8
			self.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack2.wav"}
		elseif randRange == 2 then
			self.MeleeAttackDamage = 30
			self.AnimTbl_MeleeAttack = {"attackright", "attackright2"}
			self.TimeUntilMeleeAttackDamage = 0.9
			self.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack1.wav"}
		end

	elseif status == "Init" && self:GetModel("models/Zombie/armored_zombie_charger.mdl") or self:GetModel("models/Zombie/zombie_hl2_combine_grunt.mdl") then
		self.MeleeAttackDamage = 30
		self.AnimTbl_MeleeAttack = "melee_swing"
		self.TimeUntilMeleeAttackDamage = 0.8
		self.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack2.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoTeslaEffect()
	local pos = self:GetPos()

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetEntity(self)
	effectdata:SetMagnitude(3)
	effectdata:SetScale(1)
	effectdata:SetRadius(1)

	util.Effect("TeslaHitboxes", effectdata, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:SetLocalVelocity(self:GetMoveVelocity() *1)
	util.VJ_SphereDamage(self,self,self:GetPos(),24,0.2,DMG_SHOCK,true,true)

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

	ParticleEffect("racex_arc_03_gas1",self:GetPos() + self:GetUp()* 5,Angle(0,0,0),nil)

	if self.NextTesla <= CurTime() then
		self:DoTeslaEffect()
		self.NextTesla = CurTime() + 0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self.hnpc = ents.Create("npc_reviver_vj_cets")
	self.hnpc:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
	self.hnpc:VJ_ACT_PLAYACTIVITY("reviver_abandon_host",true,1,false)
	self.hnpc:SetAngles(self:GetAngles())
	self.hnpc:Spawn()
	self.hnpc:Activate() 
	self:SetGroundEntity(NULL)

	VJ_EmitSound(self, "npc/reviver/host_emerge_0" .. math.random(1, 2) .. ".wav", 90, 100)
	ParticleEffect("blood_advisor_pierce_spray",self:GetPos(),Angle(0,0,0),nil)
end