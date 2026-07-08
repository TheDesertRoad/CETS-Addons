AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.VJ_ID_Boss = true
ENT.Model = "models/hl2_hydra_large.mdl"
ENT.StartHealth = GetConVar("sk_cets_hydra_health"):GetInt()
ENT.TurningSpeed = 20
ENT.SightDistance = 800
ENT.TimeUntilEnemyLost = 20
ENT.IsGuard = true
ENT.SightAngle = 360	
ENT.VJ_IsHugeMonster = true
ENT.HullType = HULL_LARGE
ENT.CanChatMessage = false
ENT.MovementType = VJ_MOVETYPE_GROUND
ENT.JumpParams = {
	Enabled = false, -- Can it do movement jumps?
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Blue"
ENT.BloodDecal = "VJ_CETS_BBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 50
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB
ENT.TimeUntilMeleeAttackDamage = 0.6
ENT.NextMeleeAttackTime = 0.3
ENT.MeleeAttackDistance = 290
ENT.MeleeAttackDamageDistance = 300
ENT.MeleeAttackDamageAngleRadius = 10

ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1 
ENT.MeleeAttackBleedEnemyDamage = 4 
ENT.MeleeAttackBleedEnemyTime = 0.5
ENT.MeleeAttackBleedEnemyReps = 8

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = "hide"

ENT.GibOnDeathFilter = false
ENT.HasDeathCorpse = false
ENT.ConstantlyFacingEnemy = true

ENT.IdleSoundsWhileAttacking = true

ENT.MainSoundPitch = 100
ENT.BreathSoundLevel = 100

ENT.SoundTbl_Breath = {
	"npc/hydra/hydra_3lungbreathe_loop2.wav",
	"npc/hydra/hydra_3lungbreathe_loop1.wav",
}

ENT.SoundTbl_Idle = {
	"npc/hydra/hydra_heartloop1.wav",
	"npc/hydra/hydra_heartloop2.wav",
}

ENT.SoundTbl_Alert = {
	"npc/hydra/hydra_alert1.wav",
	"npc/hydra/hydra_alert2.wav",
	"npc/hydra/hydra_alert3.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/hydra/hydra_strike1.wav",
	"npc/hydra/hydra_strike2.wav",
	"npc/hydra/hydra_strike3.wav",
}

ENT.SoundTbl_Investigate = {
	"npc/hydra/hydra_search5.wav",
	"npc/hydra/hydra_search6.wav",
	"npc/hydra/hydra_search7.wav",
	"npc/hydra/hydra_search8.wav",
}

ENT.SoundTbl_Pain = {
	"npc/hydra/hydra_pain1.wav",
	"npc/hydra/hydra_pain2.wav",
	"npc/hydra/hydra_pain3.wav",
}

ENT.SoundTbl_Death = ENT.SoundTbl_Pain

ENT.SoundTbl_MeleeAttack = {
	"npc/hydra/hydra_bump1.wav",
	"npc/hydra/hydra_bump2.wav",
	"npc/hydra/hydra_bump3.wav",
}	

ENT.Tentacle_Level = 0
ENT.Tentacle_Dam = 0
ENT.Tentacle_DamAt = 0
//0 = Floor level
//1 = Medium Level
//2 = High Level
//3 = Extreme Level

local vecN = Vector(-20, -20, 0)
local vecLvl0 = Vector(20, 20, 160)
local vecLvl1 = Vector(20, 20, 380)
local vecLvl2 = Vector(20, 20, 580)
local vecLvl3 = Vector(20, 20, 650)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("npc_cets_hydra_xenfriends"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
	else
		self.VJ_NPC_Class = {"CLASS_XFISH"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 160), Vector(-20, -20, -40))
	self:SetLocalVelocity(self:GetMoveVelocity() * 0)

	self.DynamicLight = ents.Create("light_dynamic")
	self.DynamicLight:SetKeyValue("brightness", "1.5")
	self.DynamicLight:SetKeyValue("distance", "450")
	self.DynamicLight:SetLocalPos(self:GetPos())
	self.DynamicLight:SetLocalAngles(self:GetAngles())
	self.DynamicLight:Fire("Color", "64 150 255")
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Spawn()
	self.DynamicLight:Activate()
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Fire("SetParentAttachment", "head")
	self.DynamicLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.DynamicLight)

	if GetConVar("npc_cets_hydra_death_anim"):GetInt() == 1 then
		self.HasDeathAnimation = true
	else
		self.HasDeathAnimation = false
	end

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.VJ_IsBeingControlled then return end
	local ene = self:GetEnemy()
	self.MovementType = VJ_MOVETYPE_STATIONARY

	local randRange = math.random(1, 200)

	if randRange == 200 then 
		ParticleEffectAttach("vomit_hy", PATTACH_POINT_FOLLOW, self, 1)
		VJ_EmitSound(self,"ambient/water/water_spray" .. math.random(1, 3) .. ".wav",100,80)
		VJ_EmitSound(self,"npc/hydra/hydra_search" .. math.random(5, 8) .. ".wav",80,80)
	end

	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 1111, 1)
		timer.Simple(3, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	local randRange = math.random(1, 75)

	if dmginfo:IsDamageType( DMG_BLAST ) && GetConVar("npc_cets_hydra_forehide"):GetInt() == 1 or randRange == 50 && GetConVar("npc_cets_hydra_forehide"):GetInt() == 1 then 
			self:VJ_ACT_PLAYACTIVITY("hide",true,4,false)
			ParticleEffect("gonarch_explode_g_3", self:GetPos(), Angle(0,0,0), nil)
			VJ_EmitSound(self,"npc/antlion/rumble1.wav",100,100)
			VJ_EmitSound(self,"npc/hydra/hydra_pain" .. math.random(1, 3) .. ".wav",100,100)
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.HasMeleeAttack = false
			self.IsGuard = true
			self.CallForHelp = false
			self.Tentacle_Dam = 1
			self.CanInvestigate = false
			self.EnemyDetection = false
			self.GodMode = true
			self.DynamicLight:Fire("Kill", "", 2)
			timer.Simple(4,function() if IsValid(self) then
				self:VJ_ACT_PLAYACTIVITY("deploy",true,1.6,false)
				ParticleEffect("gonarch_explode_g_3", self:GetPos(), Angle(0,0,0), nil)
				VJ_EmitSound(self,"npc/antlion/rumble1.wav",100,120)
				VJ_EmitSound(self,"ambient/water/water_splash" .. math.random(1, 3) .. ".wav",100,120)
				VJ_EmitSound(self,"npc/hydra/hydra_sendtentacle" .. math.random(1, 3) .. ".wav",100,100)
				self.MovementType = VJ_MOVETYPE_STATIONARY
				self.HasMeleeAttack = false
				self.IsGuard = true
				self.CallForHelp = false
				self.Tentacle_Dam = 1
				self.CanInvestigate = false
				self.EnemyDetection = false
				self.GodMode = true

				self.DynamicLight = ents.Create("light_dynamic")
				self.DynamicLight:SetKeyValue("brightness", "1.5")
				self.DynamicLight:SetKeyValue("distance", "450")
				self.DynamicLight:SetLocalPos(self:GetPos())
				self.DynamicLight:SetLocalAngles(self:GetAngles())
				self.DynamicLight:Fire("Color", "64 150 255")
				self.DynamicLight:SetParent(self)
				self.DynamicLight:Spawn()
				self.DynamicLight:Activate()
				self.DynamicLight:SetParent(self)
				self.DynamicLight:Fire("SetParentAttachment", "head")
				self.DynamicLight:Fire("TurnOn", "", 0)
				self:DeleteOnRemove(self.DynamicLight)
				timer.Simple(2.6,function() if IsValid(self) then
					self.MovementType = VJ_MOVETYPE_STATIONARY
					self.HasMeleeAttack = true
					self.IsGuard = true
					self.CallForHelp = true
					self.Tentacle_Dam = 0
					self.CanInvestigate = true
					self.EnemyDetection = true
					self.GodMode = false
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleGibOnDeath(dmginfo,hitgroup)
	self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
	if dmginfo:IsDamageType( DMG_BLAST ) then 
		self.HasDeathAnimation = false
	end

	if dmginfo:IsDamageType( DMG_BURN ) then 
		self.HasDeathAnimation = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled()
	self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
	self.MovementType = VJ_MOVETYPE_STATIONARY
	self.HasMeleeAttack = false
	self.IsGuard = true
	self.CallForHelp = false

	VJ_EmitSound(self,"npc/gonarch/gon_explode.wav",80,300)
	VJ_EmitSound(self,"npc/hydra/hydra_pain" .. math.random(1, 3) .. ".wav",100,60)
	VJ_EmitSound(self,"ambient/water/water_bucket_rain1.wav",100,100)

	util.ScreenShake(self:GetPos(),22,500,1,500)

	ParticleEffect("gonarch_explode_g_3", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("gonarch_explode_d_3", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("gonarch_explode_a_1", self:GetPos(), Angle(0,0,0), nil)
end