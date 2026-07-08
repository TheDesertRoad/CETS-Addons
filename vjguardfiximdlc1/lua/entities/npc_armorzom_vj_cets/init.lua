AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/classic_armored.mdl"}
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.StartHealth = 75
ENT.SightDistance = 10000
ENT.Sightangle = 80 
ENT.TurningSpeed = 20
ENT.HullType = HULL_HUMAN
ENT.TimeUntilEnemyLost = 5000 
ENT.LastSeenEnemyTimeUntilReset = 1000 -- Time until it resets its enemy if its current enemy is not visible
ENT.InvestigateSoundDistance = 100 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
ENT.CanChatMessage = false
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
ENT.MeleeAttackDistance = 35
ENT.MeleeAttackDamageDistance = 65
ENT.TimeUntilNextMeleeAttack = 1.3
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 200
ENT.MeleeAttackKnockBack_Forward2 = 230

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

ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav","npc/zombie/foot_slide1.wav","npc/zombie/foot_slide2.wav","npc/zombie/foot_slide3.wav"}

ENT.SoundTbl_Idle = {
	"npc/zombie/zombie_voice_idle1.wav",
	"npc/zombie/zombie_voice_idle2.wav",
	"npc/zombie/zombie_voice_idle3.wav",
	"npc/zombie/zombie_voice_idle4.wav",
	"npc/zombie/zombie_voice_idle5.wav",
	"npc/zombie/zombie_voice_idle6.wav",
	"npc/zombie/zombie_voice_idle7.wav",
	"npc/zombie/zombie_voice_idle8.wav",
	"npc/zombie/zombie_voice_idle9.wav",
	"npc/zombie/zombie_voice_idle10.wav",
	"npc/zombie/zombie_voice_idle11.wav",
	"npc/zombie/zombie_voice_idle12.wav",
	"npc/zombie/zombie_voice_idle13.wav",
	"npc/zombie/zombie_voice_idle14.wav"
}

ENT.SoundTbl_Alert = {
	"npc/zombie/zombie_alert1.wav",
	"npc/zombie/zombie_alert2.wav",
	"npc/zombie/zombie_alert3.wav",
}

ENT.SoundTbl_MeleeAttack = {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/zombie/zombie_pain1.wav",
	"npc/zombie/zombie_pain2.wav",
	"npc/zombie/zombie_pain3.wav",
	"npc/zombie/zombie_pain4.wav",
	"npc/zombie/zombie_pain5.wav",
	"npc/zombie/zombie_pain6.wav",
}

ENT.SoundTbl_Death = {
	"npc/zombie/zombie_die1.wav",
	"npc/zombie/zombie_die2.wav",
	"npc/zombie/zombie_die3.wav",
}

ENT.ImOnFire = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize ()
	self:SetSpawnEffect(true)
	self:SetBodygroup(1,1)

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
	self:StopFireSound()
	self.HasIdleSounds = true

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
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartFireSound()
	if self.ImOnFire == 0 then
		self:EmitSound("npc/zombie/moan_loop" .. math.random(1, 3) .. ".wav", 90, math.random(100, 120))
		self.ImOnFire = 1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopFireSound()
	self:StopSound("npc/zombie/moan_loop1.wav")
	self:StopSound("npc/zombie/moan_loop2.wav")
	self:StopSound("npc/zombie/moan_loop3.wav")

	if self:IsValid() then
		self:StopSound("npc/zombie/moan_loop1.wav")
		self:StopSound("npc/zombie/moan_loop2.wav")
		self:StopSound("npc/zombie/moan_loop3.wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.SoundTbl_Pain = false
		self.CanFlinch = false
		self.Bleeds = false
		self:StartFireSound()
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.ImOnFire = 0
		self:StopFireSound()
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
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local effectdata = EffectData()
	effectdata:SetOrigin(dmginfo:GetDamagePosition())

	if hitgroup == HITGROUP_HEAD && dmginfo:GetDamageType() then
		dmginfo:ScaleDamage(0.1)
		util.Effect( "inflator_magic", effectdata )  
		VJ_EmitSound("npc/antlion/shell_impact1.wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self:StopFireSound()

	if dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_CLUB) then
			self:SetBodygroup(1,0)
			self.Headcrab = ents.Create("npc_armorhead_vj_cets")
			self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
			self.Headcrab:SetAngles(self:GetAngles())
			self.Headcrab:Spawn()
			self.Headcrab:Activate() 
			self.Headcrab:SetOwner(self)
			self:SetGroundEntity(NULL)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:StopFireSound()
end