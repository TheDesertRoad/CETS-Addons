AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_pit_drone.mdl"
ENT.VJ_NPC_Class = {"CLASS_FUNGUS"}
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

ENT.BreathSoundPitch = 80
ENT.BreathSoundLevel = 40

ENT.SoundTbl_Breath = {"hl1/ambience/alien_hollow.wav"}
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
	ParticleEffectAttach("jeff_gas",PATTACH_POINT_FOLLOW,self,0)
	ParticleEffectAttach("jeff_floaters",PATTACH_POINT_FOLLOW,self,0)
	util.VJ_SphereDamage(self,self,self:GetPos(),60,0.2,DMG_NERVEGAS,true,true)
end