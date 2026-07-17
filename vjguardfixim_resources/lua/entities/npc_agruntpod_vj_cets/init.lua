AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/props_cets_aliens/agruntpod.mdl"
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

ENT.BreathSoundPitch = 40
ENT.BreathSoundLevel = 100

ENT.SoundTbl_Breath = {"hl1/ambience/alien_twow.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(50, 50, 120), Vector(-50, -50, 0))
	self:AddFlags(FL_NOTARGET)
	self:SetSpawnEffect(true)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
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
	util.ScreenShake(self:GetPos(),88,1000,2,1000)
	ParticleEffect("gonarch_gas2", self:GetPos(), Angle(0,0,0), nil)
	VJ.EmitSound(self, "physics/cardboard/cardboard_box_break" .. math.random(1, 3) .. ".wav", 80)

	self.Body = ents.Create("npc_aliengrunt_vj_cets")
	self.Body:SetPos(self:GetPos() + self:GetUp() * 4)
	self.Body:SetAngles(self:GetAngles())
	self.Body:Spawn()
	self.Body:Activate() 

	self:CreateGibEntity("obj_vj_gib", "models/props_cets_aliens/gib_agruntpod_strut01.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(-10, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/props_cets_aliens/gib_agruntpod_strut01.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(10, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/props_cets_aliens/gib_agruntpod_strut01.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(-10, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/props_cets_aliens/gib_agruntpod_strut01.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(10, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/props_cets_aliens/gib_agruntpod_base.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(-10, 1, 15))})
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