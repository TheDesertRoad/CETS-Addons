AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/xen_tree.mdl"
ENT.StartHealth = 20000
ENT.SightDistance = 200
ENT.SightAngle = 200
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.TurningSpeed = 0
ENT.CanTurnWhileStationary = false
ENT.HullType = HULL_LARGE
ENT.GodMode = false

ENT.CanChatMessage = false

ENT.AllowIgnition = false
ENT.AnimTbl_Idle = "idle1"

ENT.ControllerParams = {
    ThirdP_Offset = Vector(40, 0, -100),
    FirstP_Bone = "",
    FirstP_Offset = Vector(15, 0, 15),
	FirstP_ShrinkBone = false,
}

ENT.HealthRegenParams = {
	Enabled = true, 
	Amount = 10, 
	Delay = VJ.SET(0.1, 0.2), 
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.Bleeds = true
ENT.BloodDecalUseGMod = true
ENT.HasBloodDecal = false
ENT.BloodParticle = {"blood_zombie_split", "blood_impact_red_01"}
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.MeleeAttackDistance = 100 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 110 -- How far does the damage go?
ENT.MeleeAttackDistance = 100
ENT.MeleeAttackAngleRadius = 50
ENT.MeleeAttackDamageAngleRadius = 50
ENT.MeleeAttackDamage = 33
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.TimeUntilMeleeAttackDamage = 0.4
ENT.NextMeleeAttackTime = 1.5 -- How much time until it can use a melee attack?
ENT.AnimTbl_MeleeAttack = "attack"

ENT.GibOnDeathFilter = false

ENT.SoundTbl_MeleeAttack = {"npc/barnacle/bcl_chew1.wav", "npc/barnacle/bcl_chew2.wav", "npc/barnacle/bcl_chew3.wav"}
ENT.SoundTbl_MeleeAttackMiss = "weapons/iceaxe/iceaxe_swing1.wav"
ENT.SoundTbl_Pain = {"npc/zombigaunt/hurt1.wav", "npc/zombigaunt/hurt2.wav", "npc/zombigaunt/hurt3.wav", "npc/zombigaunt/hurt4.wav", "npc/zombigaunt/hurt5.wav"}
ENT.SoundTbl_Idle = "npc/zombigaunt/ranged2.wav"
ENT.SoundTbl_Death = "npc/barnacle/bcl_die1.wav"

ENT.MainSoundPitch = 100
ENT.MeleeAttackMissSoundPitch = 40
ENT.MeleeAttackMissSoundLevel = 70
ENT.IdleSoundPitch = 50
ENT.IdleSoundLevel = 50
ENT.PainSoundPitch = 40
ENT.PainSoundLevel = 40
ENT.DeathSoundPitch = 50
ENT.DeathSoundLevel = 60
ENT.MeleeAttackSoundPitch = 90
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(20, 20, 190), Vector(-20, -20, 0))
	self:AddFlags(FL_NOTARGET)

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanFlinch = "DamageTypes"
ENT.FlinchChance = 2
ENT.AnimTbl_Flinch = {"flinch2_type1","flinch2_type2","flinch2_type3","flinch1_type1","flinch1_type2","flinch1_type3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "PreInit" then
		return (self.VJ_IsBeingControlled or enemy.VJ_ID_Boss)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.1, 1)
		timer.Simple(128, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end