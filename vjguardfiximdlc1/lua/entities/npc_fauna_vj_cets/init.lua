AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/fungalfauna.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_FUNGUS"}
ENT.TimeUntilEnemyLost = 3000 
ENT.LastSeenEnemyTimeUntilReset = 6000 -- Time until it resets its enemy if its current enemy is not visible

ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true 
ENT.SightDistance = 800
ENT.TurningSpeed = 0
ENT.SightAngle = 360
ENT.HasBloodPool = true 
ENT.PushProps = true 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecal = "VJ_CETS_Fungpon_Blood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true

ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_stinger_spit"
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 2
ENT.RangeAttackMaxDistance = 500
ENT.RangeAttackAngle = 180
ENT.RangeAttackMinDistance = 50

ENT.DropDeathLoot = false

ENT.SoundTbl_Breath = {"npc/alienfauna/toxicemit.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"npc/alienfauna/growl.wav"}
ENT.SoundTbl_RangeAttack = {"npc/alienfauna/spit1.wav","npc/alienfauna/spit2.wav"}
ENT.SoundTbl_Pain = {"npc/alienfauna/pain1.wav","npc/alienfauna/pain2.wav","npc/alienfauna/pain3.wav"}
ENT.SoundTbl_Death = {"npc/alienfauna/die1.wav","npc/alienfauna/die2.wav"}
ENT.SoundTbl_Idle = {"npc/alienfauna/idle1.wav","npc/alienfauna/idle2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self:SetSkin(math.random(0, 2))
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 90000 -- -- How far away the SNPC's call for help goes | Counted in World Units
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	util.VJ_SphereDamage(self,self,self:GetPos(),100,1,DMG_NERVEGAS,true,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	ParticleEffectAttach("fungal_gas2",PATTACH_POINT_FOLLOW,self,6)
	ParticleEffectAttach("fungal_floaters",PATTACH_POINT_FOLLOW,self,6)
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

	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth(), self, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	VJ.EmitSound(self, "npc/alienfauna/growl.wav", 80)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if math.random(1,6) == 1 then
	VJ_EmitSound(self,"npc/antlion/antlion_shoot2.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot3.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
	util.ScreenShake(self:GetPos(),44,1000,2,1000)
	ParticleEffect("antlion_gib_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("fungal_gas2",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

	self.Body = ents.Create("sent_fungalfaunabody_vj_cets")
	self.Body:SetPos(self:GetPos() + self:GetUp() * -4)
	self.Body:SetSkin(self:GetSkin())
	self.Body:SetAngles(self:GetAngles())
	self.Body:Spawn()
	self.Body:Activate() 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathCorpse(dmginfo, hitgroup)
	if self.HasDeathCorpse && self.HasDeathRagdoll != false then
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.HasGibDeathParticles == false then -- Taken from black mesa SNPCs I think Xdddddd
			local bloodeffect = EffectData()
				bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
				bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
        			bloodeffect:SetScale(1)
       			util.Effect("VJ_Blood2",bloodeffect)
			end
	return true
end