AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_controller.mdl"
ENT.StartHealth = GetConVar("sk_cets_acontrol_health"):GetInt()
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
ENT.TurningSpeed = 16
ENT.Aerial_FlyingSpeed_Calm = 100
ENT.Aerial_FlyingSpeed_Alerted = 400
ENT.Aerial_AnimTbl_Calm = {"fly_z"}
ENT.Aerial_AnimTbl_Alerted = {"float"}
ENT.AA_GroundLimit = 16
ENT.IdleAlwaysWander = true
ENT.IsGuard = false
ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = "throw"
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 30
ENT.TimeUntilMeleeAttackDamage = 1.2
ENT.NextAnyAttackTime_Melee = 1.6
ENT.MeleeAttackDamage = 30

ENT.HasDeathCorpse = true
ENT.HasExtraMeleeAttackSounds = true

ENT.HasRangeAttack = true
ENT.RangeAttackMaxDistance = 2500
ENT.RangeAttackMinDistance = 35
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "Eyes"

ENT.CanFlinch = true
ENT.FlinchChance = 12 -- Chance of flinching from 1 to x | 1 = Always flinch
ENT.FlinchCooldown = 4 -- How much time until it can flinch again? | false = Base auto calculates the duration
ENT.AnimTbl_Flinch = "flinch1"

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.HasItemDropsOnDeath = false

ENT.AlertSoundLevel = 100

ENT.SoundTbl_Idle = {
	"npc/alien_controller/con_idle1.wav",
	"npc/alien_controller/con_idle2.wav",
	"npc/alien_controller/con_idle3.wav",
	"npc/alien_controller/con_idle4.wav",
	"npc/alien_controller/con_idle5.wav",
}

ENT.SoundTbl_Alert = {
	"npc/alien_controller/con_alert1.wav",
	"npc/alien_controller/con_alert2.wav",
	"npc/alien_controller/con_alert3.wav",
}

ENT.SoundTbl_BeforeRangeAttack = {
	"npc/alien_controller/con_attack1.wav",
	"npc/alien_controller/con_attack2.wav",
	"npc/alien_controller/con_attack3.wav",
}

ENT.SoundTbl_RangeAttack = "npc/alien_controller/con_throw1"

ENT.SoundTbl_Pain = {
	"npc/alien_controller/con_pain1.wav",
	"npc/alien_controller/con_pain2.wav",
	"npc/alien_controller/con_pain3.wav",
}

ENT.SoundTbl_Death = {
	"npc/alien_controller/con_die1.wav",
	"npc/alien_controller/con_die2.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(10, 7, 100), Vector(-10, -7, 0))

	util.SpriteTrail(self, 2, Color(255, 255, 255, 64), true, 16, 1, 0.3, 1 / 3 * 0.5, "sprites/Vortal/orb_trail_1.vmt")
	util.SpriteTrail(self, 3, Color(255, 255, 255, 64), true, 16, 1, 0.3, 1 / 3 * 0.5, "sprites/Vortal/orb_trail_1.vmt")

	ParticleEffectAttach("acon_hands", PATTACH_POINT_FOLLOW, self, 2)
	ParticleEffectAttach("acon_hands", PATTACH_POINT_FOLLOW, self, 3)

	self.BlackAmount = 0
end
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 3)
		if randRange == 1 then
			self.RangeAttackProjectiles = {"obj_vj_vortalenergyorb"}
			self.AnimTbl_RangeAttack = "attack1"
			self.TimeUntilRangeAttackProjectileRelease = 1.6
			self.RangeAttackExtraTimers = {1.7, 1.8}
			self.NextRangeAttackTime = 5.5
		elseif randRange == 2 then
			self.RangeAttackProjectiles = {"obj_vj_vortalenergyorb_b"}
			self.AnimTbl_RangeAttack = "shoot"
			self.TimeUntilRangeAttackProjectileRelease = 1.6
			self.RangeAttackExtraTimers = false
			self.NextRangeAttackTime = 7.5
		elseif randRange == 3 then
			self.RangeAttackProjectiles = {"obj_vj_vortalenergyorb"}
			self.AnimTbl_RangeAttack = "throw"
			self.TimeUntilRangeAttackProjectileRelease = 1.2
			self.RangeAttackExtraTimers = false
			self.NextRangeAttackTime = 1.2
		end

		self.AlienC_NumFired = 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PostSpawn" then
		projectile.Track_Ent = enemy
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * (self.AlienC_HomingAttack and 80 or 20)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_CRUSH ) then 
		self:VJ_ACT_PLAYACTIVITY("flinch2",true,self:SequenceDuration(self:LookupSequence( "flinch2" )),true)
	end
end