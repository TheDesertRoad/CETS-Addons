AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_mompod.mdl"
ENT.StartHealth = 500
ENT.VJ_NPC_Class = {"CLASS_COMBINE", "CLASS_ZOMBIE"}
ENT.TimeUntilEnemyLost = 3000 
ENT.LastSeenEnemyTimeUntilReset = 6000 -- Time until it resets its enemy if its current enemy is not visible

ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true 
ENT.SightDistance = 1000
ENT.TurningSpeed = 0
ENT.Sightangle = 360
ENT.HasBloodPool = false
ENT.PushProps = true 
ENT.Bleeds = false

ENT.HasMeleeAttack = false
ENT.HasDeathCorpse = false
ENT.IdleSoundsWhileAttacking = true

ENT.HasRangeAttack = true
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 10
ENT.NextRangeAttackTime = 3

ENT.BreathSoundlevel = 200
ENT.BreathSoundPitch = 90
ENT.IdleSoundPitch = 50
ENT.AlertSoundLevel = 70
ENT.AlertSoundPitch = 30

ENT.SoundTbl_Idle = {
	"npc/gonarch/gon_childdie1.wav",
	"npc/gonarch/gon_childdie2.wav",
	"npc/gonarch/gon_childdie3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/gonarch/gon_sack1.wav",
	"npc/gonarch/gon_sack2.wav",
	"npc/gonarch/gon_sack3.wav",
}

ENT.SoundTbl_BeforeRangeAttack = {
	"npc/gonarch/gon_birth1.wav",
	"npc/gonarch/gon_birth2.wav",
	"npc/gonarch/gon_birth3.wav",
}

ENT.SoundTbl_Breath = {"npc/alienfauna/toxicemit.wav"}
ENT.SoundTbl_Alert = {"ambient/machines/spinup.wav"}

ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 90000 -- -- How far away the SNPC's call for help goes | Counted in World Units
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(100, 100, 100), Vector(-100, -100, -20))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		timer.Simple(12, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 3)
		if randRange == 1 then
			self.TimeUntilRangeAttackProjectileRelease = 0.4
			self.RangeAttackProjectiles = "obj_vj_gonarchspit"
		elseif randRange == 2 then
			self.TimeUntilRangeAttackProjectileRelease = 0.2
			self.RangeAttackProjectiles = "obj_vj_gonarchspit"
			self.RangeAttackExtraTimers = {0.9,2.1}
		elseif randRange == 3 then
			self.TimeUntilRangeAttackProjectileRelease = 2.8
			self.RangeAttackProjectiles = "obj_vj_gonarchspit_baby"
			self.RangeAttackExtraTimers = {3.0,3.2}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 120
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return (self:GetEnemy():GetPos() - self:GetPos()) *0.35 + self:GetUp() *500
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	util.VJ_SphereDamage(self,self,self:GetPos(),150,1,DMG_NERVEGAS,true,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	ParticleEffectAttach("gonarch_gas1",PATTACH_POINT_FOLLOW,self,0)
	ParticleEffectAttach("gonarch_bebcrab_spawn",PATTACH_POINT_FOLLOW,self,0)
	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
		self.IsGuard = true
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(1)
		self:SetGravity(0)
		self:SetGravity(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	ParticleEffect("gonarch_explode_a", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("gonarch_explode_b", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("gonarch_gas2", self:GetPos(), Angle(0,0,0), nil)

	local effectdata = EffectData()
	effectdata:SetScale( 500 )
	effectdata:SetOrigin(self:GetPos())
	util.Effect("Explosion", effectdata)
	util.ScreenShake(self:GetPos(),44,1000,2,1000)

	util.BlastDamage(self,self,self:GetPos(),300,33,DMG_PARALYZE,true,true)

	VJ_EmitSound(self,"npc/antlion/antlion_shoot1.wav",100,80)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot2.wav",100,70)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot3.wav",100,70)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 150, 100)
	VJ_EmitSound(self,"ambient/alarms/warningbell1.wav",100,100)

	self.Headcrab = ents.Create("npc_babycrab_vj_cets")
	self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*5  + self:GetForward()*-5 + self:GetUp()*16)
	self.Headcrab:SetAngles(self:GetAngles())
	self.Headcrab:Spawn()
	self.Headcrab:Activate() 
	self.Headcrab:SetOwner(self)
	self:SetGroundEntity(NULL)
	self.Headcrab = ents.Create("npc_babycrab_vj_cets")
	self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*5  + self:GetForward()*5 + self:GetUp()*16)
	self.Headcrab:SetAngles(self:GetAngles())
	self.Headcrab:Spawn()
	self.Headcrab:Activate() 
	self.Headcrab:SetOwner(self)
	self:SetGroundEntity(NULL)
	self.Headcrab = ents.Create("npc_babycrab_vj_cets")
	self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*-5  + self:GetForward()*-5 + self:GetUp()*16)
	self.Headcrab:SetAngles(self:GetAngles())
	self.Headcrab:Spawn()
	self.Headcrab:Activate() 
	self.Headcrab:SetOwner(self)
	self:SetGroundEntity(NULL)
	self.Headcrab = ents.Create("npc_babycrab_vj_cets")
	self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*-5  + self:GetForward()*5 + self:GetUp()*16)
	self.Headcrab:SetAngles(self:GetAngles())
	self.Headcrab:Spawn()
	self.Headcrab:Activate() 
	self.Headcrab:SetOwner(self)
	self:SetGroundEntity(NULL)

	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib1.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib2.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib3.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib4.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib5.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib6.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/container_chunk05.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/combine_apc_destroyed_gib02.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/combine_apc_destroyed_gib03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/props_combine/tprotato2_chunk01.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/props_combine/tprotato2_chunk03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 48))})
	self:CreateGibEntity("obj_vj_gib", "models/props_combine/tprotato2_chunk05.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 48))})
end