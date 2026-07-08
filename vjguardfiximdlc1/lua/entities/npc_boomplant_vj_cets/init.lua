AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/props_cets_aliens/boomerplant_01.mdl"
ENT.StartHealth = 5
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.MovementType = VJ_MOVETYPE_STATIONARY
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
ENT.BloodDecal = "VJ_CETS_GBlood"
ENT.BloodParticle = "blood_impact_antlion_worker_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true

ENT.HasMeleeAttack = false

ENT.HasRangeAttack = false

ENT.DropDeathLoot = false

ENT.BreathSoundPitch = 80
ENT.BreathSoundLevel = 100

ENT.SoundTbl_Breath = {"hl1/ambience/alien_twow.wav"}
ENT.SoundTbl_Death = {"hl1/ambience/disgusting.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(24, 16, 24), Vector(-24, -16, 2))
	self:AddFlags(FL_NOTARGET)
	self:SetSpawnEffect(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 90000 -- -- How far away the SNPC's call for help goes | Counted in World Units
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth(), self, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/antlion/antlion_shoot3.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),250,75,DMG_POISON,true,true)
	util.ScreenShake(self:GetPos(),88,1000,2,1000)
	ParticleEffect("antlion_gib_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_spit_02",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

	self.Body = ents.Create("sent_boomplantbody_vj_cets")
	self.Body:SetPos(self:GetPos() + self:GetUp() * -4)
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