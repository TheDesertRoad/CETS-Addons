AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_ichthy.mdl"
ENT.StartHealth = 1000
ENT.SightAngle = 225
ENT.HullType = HULL_LARGE
ENT.TurningUseAllAxis = true

ENT.CanChatMessage = false
ENT.HullType = HULL_LARGE
ENT.ConstantlyFacingEnemy = true
ENT.IdleAlwaysWander = true 

ENT.MovementType = VJ_MOVETYPE_AQUATIC

ENT.Aquatic_SwimmingSpeed_Calm = 80
ENT.Aquatic_SwimmingSpeed_Alerted = 500
ENT.AA_GroundLimit = 0
ENT.Aquatic_AnimTbl_Calm = {"swimslow"}
ENT.Aquatic_AnimTbl_Alerted = {"swim"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 70
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.AnimTbl_MeleeAttack = {"attackmiss"}
ENT.TimeUntilMeleeAttackDamage = 0.3
ENT.NextAnyAttackTime_Melee = 1
ENT.MeleeAttackDistance = 80
ENT.MeleeAttackDamageDistance = 85

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {"thrashflinch"}
ENT.FlinchChance = 75

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {"die"}

ENT.SoundTbl_Breath = {"npc/ichthyosaur/water_breath.wav"}

ENT.SoundTbl_Idle = {
	"npc/ichthyosaur/ichy_idle1.wav",
	"npc/ichthyosaur/ichy_idle2.wav",
	"npc/ichthyosaur/ichy_idle3.wav",
	"npc/ichthyosaur/ichy_idle4.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/ichthyosaur/attack_growl1.wav",
	"npc/ichthyosaur/attack_growl2.wav", 
	"npc/ichthyosaur/attack_growl3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/ichthyosaur/ichy_pain1.wav",
	"npc/ichthyosaur/ichy_pain2.wav",
	"npc/ichthyosaur/ichy_pain3.wav",
	"npc/ichthyosaur/ichy_pain5.wav",
}

ENT.SoundTbl_Death = {
	"npc/ichthyosaur/ichy_die1.wav",
	"npc/ichthyosaur/ichy_die2.wav",
	"npc/ichthyosaur/ichy_die3.wav",
	"npc/ichthyosaur/ichy_die4.wav",
}

ENT.SoundTbl_Alert = {
	"npc/ichthyosaur/water_growl1.wav",
	"npc/ichthyosaur/water_growl2.wav",
	"npc/ichthyosaur/water_growl3.wav",
	"npc/ichthyosaur/water_growl4.wav",
	"npc/ichthyosaur/water_growl5.wav"
}

ENT.SoundTbl_Investigate = {
	"npc/ichthyosaur/ping1.wav",
	"npc/ichthyosaur/ping2.wav",
}

ENT.SoundTbl_IdleDialogue =  {
	"npc/ichthyosaur/voice1.wav",
	"npc/ichthyosaur/voice2.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/ichthyosaur/voice1.wav",
	"npc/ichthyosaur/voice2.wav",
}

ENT.SoundTbl_MeleeAttack = {"npc/ichthyosaur/snap_miss.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/ichthyosaur/snap.wav"}

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("npc_cets_ichthy_xenfriends"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
	else
		self.VJ_NPC_Class = {"CLASS_XFISH"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(60, 40, 35), Vector(-60, -40, -30))

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateBubbles(amountMin, amountMax)
	if self:WaterLevel() <= 0 then return end

	local mins = self:GetPos() + (self:OBBMins() * 0.5)
	local maxs = self:GetPos() + (self:OBBMaxs() * 0.5)

	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() + Vector(0, 0, 8192),
		mask = MASK_WATER
	})

	if tr.Hit then
		maxs.z = math.min(maxs.z, tr.HitPos.z - 2)
	end

	if maxs.z <= mins.z then
		maxs.z = mins.z + 2
	end

	effects.Bubbles(mins, maxs, math.random(amountMin, amountMax), math.random(40, 80), 1)
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

	if math.random(1, 10) == 1 && self:WaterLevel() > 0 then
		self:CreateBubbles(1, 4)
	end

	if self:WaterLevel() < 1 then
		self.Bleeds = false
		self:TakeDamage(16)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	if status == "Init" then
		local pos = self:GetPos() +self:GetAngles():Forward() *35
		self:CreateBubbles(32, 64)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_CRUSH ) then 
			self:VJ_ACT_PLAYACTIVITY("thrash",true,2,false)
			self.HasMeleeAttack = false
			self.SightDistance = 1 
			self.CallForHelp = true
			self:CreateBubbles(32, 64)
			timer.Simple(2.2,function() if IsValid(self) then
			self.SightDistance = 60000 
			self.CallForHelp = true
			self.HasMeleeAttack = true
			self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end

	if dmginfo:IsDamageType( DMG_SONIC ) then 
			self:VJ_ACT_PLAYACTIVITY("thrash",true,1,false)
			self.HasMeleeAttack = false
			self.SightDistance = 1 
			self.CallForHelp = true
			self:CreateBubbles(32, 64)
			timer.Simple(1.2,function() if IsValid(self) then
			self.SightDistance = 60000 
			self.CallForHelp = true
			self.HasMeleeAttack = true
			self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end
end