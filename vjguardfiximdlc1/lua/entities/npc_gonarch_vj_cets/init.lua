AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_gonarch.mdl"
ENT.StartHealth = 2000
ENT.HullType = HULL_LARGE
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.VJ_ID_Boss = true
ENT.HasWorldShakeOnMove = true
ENT.CanChatMessage = false
ENT.EntitiesToNoCollide = {"npc_headcrab", "npc_headcrab_black", "npc_headcrab_fast", "npc_armorhead_vj_cets", "npc_babycrab_vj_cets"}
ENT.ControllerParams = {
    ThirdP_Offset = Vector(-100, 0, -70),
    FirstP_Bone = "Bip01 Neck",
    FirstP_Offset = Vector(0, 0, -5),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01" -- Particles to spawn when it's damaged
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.MeleeAttackDistance = 200 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 250 -- How far does the damage go?
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.NextMeleeAttackTime = 1
ENT.HasMeleeAttackKnockBack = true
ENT.HasExtraMeleeAttackSounds = true

ENT.HasRangeAttack = true
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 500
ENT.NextRangeAttackTime = 5

ENT.HasDeathAnimation = true
ENT.HasDeathCorpse = false
ENT.AnimTbl_Death = {"death"}
ENT.IdleSoundsWhileAttacking = true

ENT.AllyDeathSoundChance = 1

ENT.MainSoundLevel = 100
ENT.FootstepSoundLevel = 85
ENT.FootstepSoundTimerRun = 0.4
ENT.FootstepSoundTimerWalk = 0.8

ENT.SoundTbl_FootStep = {"npc/gonarch/gon_step1.wav", "npc/gonarch/gon_step2.wav", "npc/gonarch/gon_step3.wav"}

ENT.SoundTbl_Idle = {
	"npc/gonarch/gon_sack1.wav",
	"npc/gonarch/gon_sack2.wav",
	"npc/gonarch/gon_sack3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = "npc/gonarch/gon_swish1.wav"

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/gonarch/gon_attack1.wav",
	"npc/gonarch/gon_attack2.wav",
	"npc/gonarch/gon_attack3.wav"
}

ENT.SoundTbl_Pain = {
	"npc/gonarch/gon_pain2.wav",
	"npc/gonarch/gon_pain4.wav",
	"npc/gonarch/gon_pain5.wav",
}

ENT.SoundTbl_Alert = {
	"npc/gonarch/gon_alert1.wav",
	"npc/gonarch/gon_alert2.wav",
	"npc/gonarch/gon_alert3.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/gonarch/gon_childdie1.wav",
	"npc/gonarch/gon_childdie2.wav",
	"npc/gonarch/gon_childdie3.wav",
}

ENT.SoundTbl_Death = "npc/gonarch/gon_die1.wav"
ENT.SoundTbl_MeleeAttackExtra = {"npc/gonarch/gon_impact1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSkin(1)
	self:SetCollisionBounds(Vector(100, 100, 200), Vector(-100, -100, 0))

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.1, 1)
		timer.Simple(24, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 1) == 1 then
		self:PlayAnim({"roar"}, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 3)
		if randRange == 1 then
			self.TimeUntilMeleeAttackDamage = 0.2
			self.MeleeAttackDamage = 33
			self.MeleeAttackDamageType = DMG_CLUB
			self.AnimTbl_MeleeAttack = {"meleestab1", "meleestab2"}
		elseif randRange == 2 then
			self.TimeUntilMeleeAttackDamage = 0.4
			self.MeleeAttackDamage = 20
			self.MeleeAttackDamageType = DMG_CLUB
			self.AnimTbl_MeleeAttack = {"sack_whack_attack"}
		elseif randRange == 3 then
			self.TimeUntilMeleeAttackDamage = 0.8
			self.MeleeAttackDamage = 56
			self.MeleeAttackDamageType = DMG_CLUB
			self.AnimTbl_MeleeAttack = {"web_slash"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBebcrab()
	if self:IsValid() then
		self.Headcrab = ents.Create("npc_babycrab_vj_cets")
		self.Headcrab:SetPos(self:GetPos() + self:GetUp()*10)
		self.Headcrab:SetAngles(self:GetAngles())
		self.Headcrab:SetSpawnFlags(8192)
		self.Headcrab:AddSpawnFlags(8192)
		self.Headcrab:Spawn()
		self.Headcrab:Activate() 
		self.Headcrab:SetOwner(self)
		self:SetGroundEntity(NULL)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 4)

		if randRange == 1 then
			VJ.EmitSound(self, "npc/gonarch/gon_attack" .. math.random(1, 3) .. ".wav", 100, 100)
			ParticleEffectAttach("gonarch_muzzleflash", PATTACH_POINT_FOLLOW, self, 1)
			self.TimeUntilRangeAttackProjectileRelease = 0.4
			self.RangeAttackProjectiles = "obj_vj_gonarchspit"
			self.AnimTbl_RangeAttack = {"ballspit"}

		elseif randRange == 2 then
			VJ.EmitSound(self, "npc/gonarch/gon_attack" .. math.random(1, 3) .. ".wav", 100, 100)
			ParticleEffectAttach("gonarch_muzzleflash", PATTACH_POINT_FOLLOW, self, 1)
			self.TimeUntilRangeAttackProjectileRelease = 0.4
			self.RangeAttackProjectiles = "obj_vj_gonarchspit"
			self.RangeAttackExtraTimers = {0.9,2.1}
			self.AnimTbl_RangeAttack = {"ballspit_3x"}

		elseif randRange == 3 then
			VJ.EmitSound(self, "npc/gonarch/gon_attack" .. math.random(1, 3) .. ".wav", 100, 100)
			ParticleEffectAttach("gonarch_muzzleflash", PATTACH_POINT_FOLLOW, self, 1)
			self.TimeUntilRangeAttackProjectileRelease = 2.8
			self.RangeAttackProjectiles = "obj_vj_gonarchspit_baby"
			self.RangeAttackExtraTimers = {3.0,3.2}
			self.AnimTbl_RangeAttack = {"mortarspit"}

		elseif randRange == 4 then
			VJ.EmitSound(self, "npc/gonarch/gon_birth" .. math.random(1, 3) .. ".wav", 100, 100)
			self.RangeAttackMaxDistance = 10000
			self.RangeAttackMinDistance = 1
			self.TimeUntilRangeAttackProjectileRelease = 1
			self.RangeAttackProjectiles = "obj_vj_nothing_of_the_lazyness"

			self:SpawnBebcrab()
			self:SpawnBebcrab()

			self.AnimTbl_RangeAttack = {"bebcrabspawn"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 180
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return (self:GetEnemy():GetPos() - self:GetPos()) *0.45 + self:GetUp() *500
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	local infl = dmginfo:GetInflictor()
	local comballdamage = false

	if infl && IsValid(infl) then
		if infl:GetClass() == "prop_combine_ball" then
			infl:Fire("Explode")
			comballdamage = true
	end

	if !infl.DamagedVJ_ZHunter && infl:GetClass() == "obj_vj_combineball" then
			infl.DamagedVJ_ZHunter = true
			infl:DeathEffects()
			comballdamage = true
		end
	end

	if comballdamage then
		dmginfo:SetDamage(200)
	elseif !dmginfo:IsExplosionDamage() then
		dmginfo:ScaleDamage(1.2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self:SpawnBebcrab()
	self:SpawnBebcrab()
	self:SpawnBebcrab()
	self:SpawnBebcrab()

	ParticleEffect("gonarch_bebcrab_spawn", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("gonarch_explode", self:GetPos(), Angle(0,0,0), nil)

	VJ_EmitSound(self,"npc/gonarch/gon_explode.wav", 100, 100)

	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib1.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib2.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib3.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib4.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib5.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib6.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib1.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib2.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib3.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib4.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib5.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib6.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib1.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib2.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib3.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib4.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib5.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib6.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
end