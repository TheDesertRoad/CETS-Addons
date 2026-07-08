AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/props_interiors/Furniture_chair01a.mdl"
ENT.VJ_NPC_Class = {"CLASS_NONE"}
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

ENT.BreathSoundLevel = 100

ENT.SoundTbl_Breath = {"weapons/misc/fire_loop.wav"}
ENT.SoundTbl_Death = {"weapons/misc/fire_fadeout.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize ()
	self:SetSpawnEffect(true)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self.MovementType = VJ_MOVETYPE_STATIONARY

	self.DynamicLight = ents.Create("light_dynamic")
	self.DynamicLight:SetKeyValue("brightness", "0.6")
	self.DynamicLight:SetKeyValue("distance", "256")
	self.DynamicLight:SetLocalPos(self:GetPos())
	self.DynamicLight:SetLocalAngles(self:GetAngles())
	self.DynamicLight:Fire("Color", "255 128 4")
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Spawn()
	self.DynamicLight:Activate()
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Fire("SetParentAttachment", "Origin", 0)
	self.DynamicLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.DynamicLight)

	ParticleEffectAttach("asp_lemon_01",PATTACH_POINT_FOLLOW,self,0)

	local myPos = self:GetPos()
	self:SetLocalPos(myPos + vecZ4) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos - vezZ100,
		filter = self
	})
	util.Decal(VJ.PICK("VJ_CETS_BurntScorch1"), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:AddFlags(FL_NOTARGET)
	self:RemoveFlags(FL_AIMTARGET)

	util.VJ_SphereDamage(self,self,self:GetPos(),36,0.4,DMG_BURN,true,true, {Force = 1}, function(ent) if !ent:IsOnFire() && (ent:IsPlayer() or ent:IsNPC()) then ent:Ignite(4) end end)

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
		self:TakeDamage(5)
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