AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/props_interiors/Furniture_chair01a.mdl"
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.StartHealth = 2000
ENT.SightDistance = 10000
ENT.Sightangle = 360
ENT.TurningSpeed = 0
ENT.HullType = HULL_LARGE
ENT.TimeUntilEnemyLost = 500000 
ENT.LastSeenEnemyTimeUntilReset = 100000 -- Time until it resets its enemy if its current enemy is not visible
ENT.InvestigateSoundDistance = 100000 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
ENT.CanChatMessage = false
ENT.EnemyXRayDetection = true
ENT.ConstantlyFaceEnemy = true
ENT.IdleAlwaysWander = false
ENT.VJ_ID_Boss = false

ENT.BreathSoundPitch = 150
ENT.BreathSoundLevel = 50

ENT.SoundTbl_Breath = {"hl1/ambience/rocket_steam1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = false
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bleeds = false
ENT.BloodColor = "Orange"
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false
ENT.HasBloodPool = false

ENT.HasDeathCorpse = false

ENT.HasWorldShakeOnMove = false
ENT.CanGib = false

ENT.CallForHelp = false
ENT.HasMeleeAttack = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize ()
	self:SetSpawnEffect(true)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self.MovementType = VJ_MOVETYPE_STATIONARY
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:AddFlags(FL_NOTARGET)
	self:RemoveFlags(FL_AIMTARGET)

	ParticleEffectAttach("gasser_gas1",PATTACH_POINT_FOLLOW,self,0)
	VJ.ApplyRadiusDamage(self,self,self:GetPos(),128,0.4,DMG_NERVEGAS,true,true)
	VJ.ApplyRadiusDamage(self,self,self:GetPos(),32,0.8,DMG_NERVEGAS,true,true)

	if self:IsOnGround() then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self.GodMode = false
		self:TakeDamage(1)
		self:SetGravity(0)
		self:SetGravity(1)
	else
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(25)
		self.GodMode = false
		self:SetGravity(0)
		self:SetGravity(1)
	end

	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(500)
		self.GodMode = false
		self:SetGravity(0)
		self:SetGravity(1)
	end

	if self:IsOnFire() then
		self.Bleeds = false

	end
end