AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_panthereye.mdl"
ENT.StartHealth = 220
ENT.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
ENT.HullType = HULL_TINY
ENT.CanChatMessage = false

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HeadcrabClassic.SpineControl",
    FirstP_Offset = Vector(3, 0, -1),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
ENT.PushProps = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.TimeUntilMeleeAttackDamage = 0.3
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.NextMeleeAttackTime = 1 -- How much time until it can use a melee attack?
ENT.MeleeAttackDamage = 20
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.AnimTbl_MeleeAttack = {
	"attack_main_claw",
	"attack_primary",
	"attack_simple_claw",
}

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = "crouch_to_jump"
ENT.LeapAttackMaxDistance = 600
ENT.LeapAttackMinDistance = 100
ENT.TimeUntilLeapAttackDamage = 0.3
ENT.NextLeapAttackTime = 2
ENT.NextAnyAttackTime_Leap = 0.85
ENT.TimeUntilLeapAttackVelocity = 0.6
ENT.LeapAttackVelocityForward = 200
ENT.LeapAttackVelocityUp = 230
ENT.LeapAttackDamage = 35
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1}
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 40

ENT.HasExtraMeleeAttackSounds = true
ENT.FootstepSoundTimerRun = 0.4
ENT.FootstepSoundTimerWalk = 0.8

ENT.MainSoundPitch = 100
ENT.LeapAttackDamageSoundPitch = 150
ENT.FootstepSoundLevel = 60

ENT.SoundTbl_FootStep = {"npc/vort/vort_foot1.wav", "npc/vort/vort_foot2.wav", "npc/vort/vort_foot3.wav", "npc/vort/vort_foot4.wav"}

ENT.SoundTbl_Idle = {
	"npc/panthereye/p_idle1.wav",
	"npc/panthereye/p_idle2.wav",
	"npc/panthereye/p_idle3.wav",
	"npc/panthereye/p_idle4.wav",
}

ENT.SoundTbl_MeleeAttack = {
	"npc/panthereye/pclaw_strike1.wav",
	"npc/panthereye/pclaw_strike2.wav",
	"npc/panthereye/pclaw_strike3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/panthereye/pclaw_miss1.wav",
	"npc/panthereye/pclaw_miss2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/panthereye/p_pain1.wav",
	"npc/panthereye/p_pain2.wav",
}

ENT.SoundTbl_Death = {
	"npc/panthereye/p_die1.wav",
	"npc/panthereye/p_die2.wav",
}

ENT.SoundTbl_Alert = {
	"npc/panthereye/p_alert1.wav",
	"npc/panthereye/p_alert2.wav",
	"npc/panthereye/p_alert3.wav",
}

ENT.SoundTbl_BeforeLeapAttack = {
	"npc/panthereye/p_attack1.wav",
	"npc/panthereye/p_attack2.wav",
	"npc/panthereye/p_attack3.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/panthereye/p_attack1.wav",
	"npc/panthereye/p_attack2.wav",
	"npc/panthereye/p_attack3.wav",
}

ENT.SoundTbl_LeapAttackDamage = {
	"npc/panthereye/pclaw_strike1.wav",
	"npc/panthereye/pclaw_strike2.wav",
	"npc/panthereye/pclaw_strike3.wav",
}

local Skin_None = -1
local Skin_R = 1
local Skin_B = 2

ENT.Skin_Rand = Skin_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(25, 25, 55), Vector(-25, -25, 0))

	local flags = self:GetSpawnFlags()

	if bit.band(flags, 64) ~= 0 or self:HasSpawnFlags(64) then
		self.Skin_Rand = 1
		self:SetSkin(0)
		self.BloodColor = "Red"
		self.BloodDecal = "VJ_CETS_RCBlood"

		self.DynamicLight = ents.Create("light_dynamic")
		self.DynamicLight:SetKeyValue("brightness", "2")
		self.DynamicLight:SetKeyValue("distance", "256")
		self.DynamicLight:SetLocalPos(self:GetPos())
		self.DynamicLight:SetLocalAngles(self:GetAngles())
		self.DynamicLight:Fire("Color", "255 0 0")
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Spawn()
		self.DynamicLight:Activate()
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Fire("SetParentAttachment", "eyes")
		self.DynamicLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.DynamicLight)

	elseif bit.band(flags, 128) ~= 0 or self:HasSpawnFlags(128) then
		self.Skin_Rand = 2
		self:SetSkin(1)
		self.BloodColor = "Blue"
		self.BloodDecal = "VJ_CETS_BBlood"

		self.DynamicLight = ents.Create("light_dynamic")
		self.DynamicLight:SetKeyValue("brightness", "2")
		self.DynamicLight:SetKeyValue("distance", "256")
		self.DynamicLight:SetLocalPos(self:GetPos())
		self.DynamicLight:SetLocalAngles(self:GetAngles())
		self.DynamicLight:Fire("Color", "0 0 255")
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Spawn()
		self.DynamicLight:Activate()
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Fire("SetParentAttachment", "eyes")
		self.DynamicLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.DynamicLight)
	else
		if math.random(1,2) == 1 then
			self.Skin_Rand = 1
			self:SetSkin(0)
			self.BloodColor = "Red"
			self.BloodDecal = "VJ_CETS_RCBlood"

			self.DynamicLight = ents.Create("light_dynamic")
			self.DynamicLight:SetKeyValue("brightness", "2")
			self.DynamicLight:SetKeyValue("distance", "256")
			self.DynamicLight:SetLocalPos(self:GetPos())
			self.DynamicLight:SetLocalAngles(self:GetAngles())
			self.DynamicLight:Fire("Color", "255 0 0")
			self.DynamicLight:SetParent(self)
			self.DynamicLight:Spawn()
			self.DynamicLight:Activate()
			self.DynamicLight:SetParent(self)
			self.DynamicLight:Fire("SetParentAttachment", "eyes")
			self.DynamicLight:Fire("TurnOn", "", 0)
			self:DeleteOnRemove(self.DynamicLight)
		else
			self.Skin_Rand = 2
			self:SetSkin(1)
			self.BloodColor = "Blue"
			self.BloodDecal = "VJ_CETS_BBlood"

			self.DynamicLight = ents.Create("light_dynamic")
			self.DynamicLight:SetKeyValue("brightness", "2")
			self.DynamicLight:SetKeyValue("distance", "256")
			self.DynamicLight:SetLocalPos(self:GetPos())
			self.DynamicLight:SetLocalAngles(self:GetAngles())
			self.DynamicLight:Fire("Color", "0 0 255")
			self.DynamicLight:SetParent(self)
			self.DynamicLight:Spawn()
			self.DynamicLight:Activate()
			self.DynamicLight:SetParent(self)
			self.DynamicLight:Fire("SetParentAttachment", "eyes")
			self.DynamicLight:Fire("TurnOn", "", 0)
			self:DeleteOnRemove(self.DynamicLight)
		end
	end

	self.BlackAmount = 0
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

	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
		self.IsGuard = true
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self:PlayAnim({"drown"}, true, false, true)
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(1)
		self:SetGravity(0)
		self:SetGravity(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local effectdata = EffectData()
	effectdata:SetOrigin(dmginfo:GetDamagePosition())

	if hitgroup == HITGROUP_HEAD && dmginfo:GetDamageType() then
		dmginfo:ScaleDamage(1)
		self:SetBodygroup(1,1)
		VJ_EmitSound(self, "npc/antlion_grub/explode.wav", 90, 60)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup)
	if self.Skin_Rand == 1 then
		for i = 1, 1 do
			self:SetSkin(2)
		end
	else
		for i = 1, 1 do
			self:SetSkin(3)
		end
	end
end