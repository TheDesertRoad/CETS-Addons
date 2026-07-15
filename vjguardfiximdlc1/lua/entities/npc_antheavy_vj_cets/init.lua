AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/Antlions/soldier_ant.mdl"
ENT.StartHealth = GetConVar("sk_cets_anthev_health"):GetInt()
ENT.HullType = HULL_HUMAN
ENT.CanChatMessage = false
ENT.JumpParams = {
	MaxRise = 250,
	MaxDrop = 500,
	MaxDistance = 500
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.BloodParticle = "blood_impact_antlion_01"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true

ENT.HasMeleeAttack = true
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 200 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 250 -- How far it will push you forward | Second in math.random
ENT.TimeUntilMeleeAttackDamage = 0.2
ENT.MeleeAttackDistance = 64 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 74 -- How far does the damage go?
ENT.NextMeleeAttackTime = 0.2 -- How much time until it can use a melee attack?
ENT.MeleeAttackDamageType = DMG_CLUB

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 3 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 3 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 2 -- How many repetitions?

ENT.HasRangeAttack = false

ENT.LeapAttackMaxDistance = 512
ENT.LeapAttackMinDistance = 128
ENT.TimeUntilLeapAttackDamage = 0.2
ENT.NextLeapAttackTime = 12
ENT.LeapAttackDamage = GetConVar("sk_antlion_air_attack_dmg"):GetInt()

ENT.MainSoundLevel = 70
ENT.MainSoundPitch = 80

ENT.PainSoundPitch = VJ.SET(70,85)
ENT.DeathSoundPitch = VJ.SET(60,75)
ENT.AlertSoundPitch = 70

ENT.BreathSoundPitch = VJ.SET(40,50)
ENT.BreathSoundLevel = 60

ENT.FootStepSoundLevel = 70
ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.4 -- Next foot step sound when it is walking

ENT.SoundTbl_Breath = {"npc/antlion/antlion_poisonball1.wav", "npc/antlion/antlion_poisonball2.wav"}

ENT.ThumperSoundPos = nil
ENT.ThumperFearUntil = 0
ENT.ThumperLookUntil = 0

ENT.NextThumperMove = 0
ENT.NextThumperSound = 0

ENT.ThumperFearRadius = 1000
ENT.ThumperSafeDistance = 1500
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if game.GetGlobalState("antlion_allied") == 1 then
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_ANTLION"}
		self.AlliedWithPlayerAllies = false
	else
		self.VJ_NPC_Class = {"CLASS_ANTLION"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(20, 20, 64), Vector(-20, -20, 0))
	self:SetSkin(math.random(0, 3))

	self.IsDigging = false
	self.HasDeathCorpse = true
	self:Dig()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	util.VJ_SphereDamage(self,self,self:GetPos(),80,0.3,DMG_NERVEGAS,true,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ReactToThumper()
	if not self.ThumperSoundPos then return end
 
	if CurTime() > self.ThumperFearUntil then 
		return 
	end 

	local dist = self:GetPos():Distance(self.ThumperSoundPos) 

	if CurTime() > self.NextThumperSound then 
		self.NextThumperSound = CurTime() + math.Rand(2,4) 

		local snd = table.Random({"npc/antlion/pain1.wav", "npc/antlion/pain2.wav"}) 
		self:EmitSound(snd, 70, 80) 
	end 

	if CurTime() > self.NextThumperMove then 
		self.NextThumperMove = CurTime() + math.Rand(1,2) 

		local dir = self:GetPos() - self.ThumperSoundPos dir.z = 0 

		if dir:Length() <= 1 then 
			dir = VectorRand() dir.z = 0 
		end 

		dir:Normalize() 

		local fleePos = self:GetPos() + dir * math.random(800,1400) 

		self:SetLastPosition(fleePos) 
		self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH") 
		self.ThumperLookUntil = CurTime() + 3 
	end 

	if CurTime() < self.ThumperLookUntil then 
		local ang =(self.ThumperSoundPos - self:GetPos()):Angle() 
		self:SetAngles(Angle(0,ang.y,0)) 
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckThumperProtection()
	if not self.ThumperSoundPos then return end

	local enemy = self:GetEnemy()

	if not IsValid(enemy) then return end

	local protected = enemy:GetPos():Distance(self.ThumperSoundPos) <= self.ThumperFearRadius

	if protected then
		if self:GetEnemy() == enemy then
			self:SetEnemy(nil)
			if self.ClearEnemyMemory then
				self:ClearEnemyMemory(enemy)
			end
		end
		self:AddEntityRelationship(enemy, D_LI, 99)

		self.DisableChasingEnemy = true
		self.HasMeleeAttack = false
		self.HasRangeAttack = false
		self.HasLeapAttack = false
		self.IsAbleToLeapAttack = false
	else
		self:AddEntityRelationship(enemy, D_HT, 99)

		self.DisableChasingEnemy = false
		self.HasMeleeAttack = true
		self.HasRangeAttack = true
		self.HasLeapAttack = true
		self.IsAbleToLeapAttack = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckThumperStatus()
	if CurTime() < (self.ThumperFearUntil or 0) then return end

	self.ThumperSoundPos = nil
	self.DisableChasingEnemy = false
	self.HasMeleeAttack = true
	self.HasLeapAttack = true
	self.IsAbleToLeapAttack = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function GetWaterSurface(myPos)
	local surface = myPos

	while bit.band(util.PointContents(surface), CONTENTS_WATER) ~= 0 do
		surface = surface + Vector(0, 0, 8)
	end

	return surface
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink(ent)
	self:ReactToThumper()
	self:CheckThumperProtection()
	self:CheckThumperStatus()

	ParticleEffect("gasser_gas2",self:GetPos() + self:GetUp()* 5,Angle(0,0,0),nil)

	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth())
	end

	local myPos = self:GetPos()

	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth())
	end

	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self:SetBodygroup(1,0)
		self:StopSound("npc/antlion/fly1.wav")
		self.IsGuard = true
		self.CallForHelp = false
		self:PlayAnim({"drown"}, true, false, true)
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false

		self:SetLocalVelocity(vector_origin)
		self:SetVelocity(-self:GetVelocity())
		self:StopMoving()

		self.NextSplash = self.NextSplash or 0

		if CurTime() >= self.NextSplash then
			self.NextSplash = CurTime() + 1
			local surface = myPos

			while bit.band(util.PointContents(surface), CONTENTS_WATER) ~= 0 do
				surface = surface + Vector(0, 0, 4)
			end

			local waterType = util.PointContents(surface - Vector(0,0,4))
			if bit.band(waterType, CONTENTS_SLIME) == 0 then
				local ed = EffectData()
				ed:SetOrigin(surface)
				ed:SetScale(8)
				ed:SetFlags(2)
				util.Effect("watersplash", ed, true, true)

				self:EmitSound("ambient/water/water_splash" .. math.random(1,3) .. ".wav", 70, 100)
			end

			self:EmitSound("ambient/water/water_splash" .. math.random(1, 3) .. ".wav", 70, 100) 
		end

		timer.Simple(6, function() if self:IsValid() && self:WaterLevel() > 1 then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self:StopSound("npc/antlion/fly1.wav")
	if dmginfo:IsDamageType( DMG_BUCKSHOT ) && self.EnemyData.DistanceNearest < 400 then 
		self.HasDeathCorpse = false

		VJ_EmitSound(self, "npc/antlion/antlion_burst" .. math.random(1, 2) .. ".wav", 75, 80)
		util.VJ_SphereDamage(self,self,self:GetPos(),200,21,DMG_NERVEGAS,true,true)
		ParticleEffect("AntlionGib",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("gasser_gas1",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_1.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_2.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3a.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_1.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_2.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3a.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
	end

	if dmginfo:IsDamageType( DMG_CRUSH ) or dmginfo:IsDamageType( DMG_BLAST ) or dmginfo:IsDamageType( DMG_VEHICLE ) then 
		self.HasDeathCorpse = false

		VJ_EmitSound(self, "npc/antlion/antlion_burst" .. math.random(1, 2) .. ".wav", 75, 80)
		util.VJ_SphereDamage(self,self,self:GetPos(),200,21,DMG_NERVEGAS,true,true)
		ParticleEffect("AntlionGib",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("gasser_gas3",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_1.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_2.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3a.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_1.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_2.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/antlion_gib_medium_3a.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local attackTimers = {
	[VJ.ATTACK_TYPE_MELEE] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("attack_melee_reset" .. self:EntIndex(), self:GetAttackTimer(self.NextAnyAttackTime_Melee, self.TimeUntilMeleeAttackDamage, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		timer.Create("attack_melee_reset_able" .. self:EntIndex(), self:GetAttackTimer(self.NextMeleeAttackTime), 1, function()
			self.IsAbleToMeleeAttack = true
		end)
	end,
	[VJ.ATTACK_TYPE_RANGE] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("attack_range_reset" .. self:EntIndex(), self:GetAttackTimer(self.NextAnyAttackTime_Range, self.TimeUntilRangeAttackProjectileRelease, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		timer.Create("attack_range_reset_able" .. self:EntIndex(), self:GetAttackTimer(self.NextRangeAttackTime), 1, function()
			self.IsAbleToRangeAttack = true
		end)
	end,
	[VJ.ATTACK_TYPE_LEAP] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("attack_leap_reset" .. self:EntIndex(), self:GetAttackTimer(self.NextAnyAttackTime_Leap, self.TimeUntilLeapAttackDamage, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				VJ.EmitSound(self, "npc/antlion/land1.wav", 75, 75)
				self:StopSound("npc/antlion/fly1.wav")
				self:MaintainAlertBehavior()
			end)
		end
		timer.Create("attack_leap_reset_able" .. self:EntIndex(), self:GetAttackTimer(self.NextLeapAttackTime), 1, function()
			self.IsAbleToLeapAttack = true
		end)
	end
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExecuteLeapAttack()
	local selfData = self:GetTable()
	if selfData.Dead or selfData.PauseAttacks or selfData.Flinching or (selfData.LeapAttackStopOnHit && selfData.AttackState == VJ.ATTACK_STATE_EXECUTED_HIT) then return end
	local skip = self:OnLeapAttackExecute("Init")
	local hitRegistered = false
	if !skip then
		local myClass = self:GetClass()
		for _, ent in ipairs(ents.FindInSphere(self:GetPos(), selfData.LeapAttackDamageDistance)) do
			if ent == self or ent:GetClass() == myClass or (ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled) then continue end
			if ent:IsPlayer() && (ent.VJ_IsControllingNPC or !ent:Alive() or VJ_CVAR_IGNOREPLAYERS) then continue end
			if (ent.VJ_ID_Living && self:Disposition(ent) != D_LI) or ent.VJ_ID_Attackable or ent.VJ_ID_Destructible then
				if self:OnLeapAttackExecute("PreDamage", ent) == true then continue end
				local dmgAmount = self:ScaleByDifficulty(selfData.LeapAttackDamage)
				-- Damage
				if !selfData.DisableDefaultLeapAttackDamageCode then
					local dmgInfo = DamageInfo()
					dmgInfo:SetDamage(dmgAmount)
					dmgInfo:SetInflictor(self)
					dmgInfo:SetDamageType(selfData.LeapAttackDamageType)
					dmgInfo:SetAttacker(self)
					if ent.VJ_ID_Living then dmgInfo:SetDamageForce(self:GetForward() * ((dmgInfo:GetDamage() + 100) * 70)) end
					ent:TakeDamageInfo(dmgInfo, self)
				end
				if ent:IsPlayer() then
					ent:ViewPunch(Angle(math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount))
				end
				hitRegistered = true
				if selfData.LeapAttackStopOnHit then break end
			end
		end
	end
	if selfData.AttackState < VJ.ATTACK_STATE_EXECUTED then
		selfData.AttackState = VJ.ATTACK_STATE_EXECUTED
		if selfData.TimeUntilLeapAttackDamage then
			attackTimers[VJ.ATTACK_TYPE_LEAP](self)
		end
	end
	if !skip then
		if hitRegistered then
			self:PlaySoundSystem("LeapAttackDamage")
			selfData.AttackState = VJ.ATTACK_STATE_EXECUTED_HIT
		else
			self:OnLeapAttackExecute("Miss")
			self:PlaySoundSystem("LeapAttackDamageMiss")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttackJump()
	VJ.EmitSound(self, "npc/antlion/fly1.wav", 75, 70)
	local ene = self:GetEnemy()
	if !IsValid(ene) then return end
	self:SetGroundEntity(NULL)
	self.LeapAttackHasJumped = true
	-- Classic velocity, useful for more straight line jumps
	//return ((ene:GetPos() + ene:OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal() * 400 + self:GetForward() * 200 + self:GetUp() * 100
	self:SetLocalVelocity(self:OnLeapAttack("Jump", ene) or VJ.CalculateTrajectory(self, ene, "Curve", self:GetPos() + self:OBBCenter(), ene:GetPos() + ene:OBBCenter(), 1))
	self:SetBodygroup(1,1)
	self:PlaySoundSystem("LeapAttackJump")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	self:SetBodygroup(1,0)
	self:StopSound("npc/antlion/fly1.wav")
	if !self:Alive() then return end
	local selfData = self:GetTable()
	if selfData.VJ_DEBUG && GetConVar("vj_npc_debug_attack"):GetInt() == 1 then VJ.DEBUG_Print(self, "StopAttacks", "Attack type = " .. selfData.AttackType) end
	
	if checkTimers && attackTimers[selfData.AttackType] && selfData.AttackState < VJ.ATTACK_STATE_EXECUTED then
		attackTimers[selfData.AttackType](self, true)
	end
	
	selfData.AttackType = VJ.ATTACK_TYPE_NONE
	selfData.AttackState = VJ.ATTACK_STATE_DONE
	selfData.AttackSeed = 0
	selfData.LeapAttackHasJumped = false

	self:MaintainAlertBehavior()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:StopSound("npc/antlion/fly1.wav")
end