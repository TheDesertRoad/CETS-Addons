AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/Antlions/spitter_ant.mdl"
ENT.StartHealth = GetConVar("sk_cets_antsp_health"):GetInt()
ENT.HullType = HULL_HUMAN
ENT.CanChatMessage = false
ENT.EntitiesToNoCollide = {"npc_babycrab_vj_cets", "npc_snark_vj_cets", "obj_vj_alienhornet", "obj_vj_alienhornet_ng", "obj_vj_alienhornet_ply"}
ENT.JumpParams = {
	Enabled = true, -- Can it do movement jumps?
	MaxRise = 512, -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = 512, -- How low it can jump down (E -> S)
	MaxDistance = 1024, -- Maximum distance between Start and End
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecal = "VJ_CETS_GBlood"
ENT.BloodParticle = "blood_impact_antlion_worker_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true

ENT.HasMeleeAttack = true
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 180 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 210 -- How far it will push you forward | Second in math.random
ENT.TimeUntilMeleeAttackDamage = 0.2
ENT.MeleeAttackDistance = 64 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 74 -- How far does the damage go?
ENT.NextMeleeAttackTime = 0.3 -- How much time until it can use a melee attack?
ENT.MeleeAttackDamageType = DMG_SLASH

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1. -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 5 -- How many repetitions?

ENT.HasRangeAttack = true

ENT.AnimTbl_RangeAttack = "spit"

ENT.RangeAttackProjectiles = {"obj_vj_antlionspit"}
ENT.TimeUntilRangeAttackProjectileRelease = 0.2
ENT.NextRangeAttackTime = 2
ENT.RangeAttackMaxDistance = 1000
ENT.RangeAttackExtraTimers = {0.4, 0.6, 0.9}
ENT.RangeAttackMinDistance = 86

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = ACT_JUMP
ENT.LeapAttackMaxDistance = 1024
ENT.LeapAttackMinDistance = 128
ENT.TimeUntilLeapAttackDamage = 0.2
ENT.NextLeapAttackTime = 6
ENT.NextAnyAttackTime_Leap = 1
ENT.LeapAttackStopOnHit = true
ENT.TimeUntilLeapAttackVelocity = 0.2
ENT.LeapAttackDamage = GetConVar("sk_antlion_air_attack_dmg"):GetInt()
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.4}
ENT.LeapAttackDamageDistance = 40

ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_Postures = "Moving"
ENT.ConstantlyFaceEnemy_MinDistance = 200

ENT.FootStepSoundLevel = 70
ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.4 -- Next foot step sound when it is walking

ENT.HasExtraMeleeAttackSounds = true

ENT.SoundTbl_FootStep = {"npc/antlion/foot1.wav", "npc/antlion/foot2.wav", "npc/antlion/foot3.wav", "npc/antlion/foot4.wav"}

ENT.SoundTbl_LeapAttackDamage = false

ENT.SoundTbl_Idle = {
	"npc/antlion/idle1.wav",
	"npc/antlion/idle2.wav",
	"npc/antlion/idle3.wav",
	"npc/antlion/idle4.wav",
	"npc/antlion/idle5.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/antlion/attack_single1.wav",
	"npc/antlion/attack_single2.wav",
	"npc/antlion/attack_single3.wav",
}

ENT.SoundTbl_Alert = {
	"npc/antlion/distract1.wav",
}

ENT.SoundTbl_Pain = {
	"npc/antlion/pain1.wav",
	"npc/antlion/pain2.wav",
}

ENT.SoundTbl_Death = {
	"npc/antlion/pain1.wav",
	"npc/antlion/pain2.wav",
}

ENT.SoundTbl_RangeAttack = {
	"npc/antlion/antlion_shoot1.wav",
	"npc/antlion/antlion_shoot2.wav",
	"npc/antlion/antlion_shoot3.wav",
}

ENT.SoundTbl_MeleeAttack = {"npc/zombie/claw_strike1.wav", "npc/zombie/claw_strike2.wav", "npc/zombie/claw_strike3.wav"}

local sdDrowning = {""}

ENT.Flipped = 0

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

	self.ThumperPauseUntil = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnLeapAttack(status, enemy)
	if status == "Jump" then
		self.Antlion_StartedLeapAttack = true
		return self:CalculateProjectile("Curve", self:GetPos(), self:GetAimPosition(enemy, self:GetPos(), 1, 1100), 1100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if GetConVar("npc_cets_antlions_dig"):GetInt() == 1 then
		if self.IsDiging == true then return end
	end
	if math.random(1, 12) == 1 then
		local tbl = VJ.PICK({"distract", "roar"})
		self:PlayAnim(tbl, true, VJ.AnimDuration(self, tbl), false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 3)
		if randRange == 1 then
			self.SoundTbl_BeforeMeleeAttack = {"npc/antlion/attack_single1.wav", "npc/antlion/attack_single2.wav", "npc/antlion/attack_single3.wav"}
			self.MeleeAttackDamage = GetConVar("sk_antlion_swipe_damage"):GetInt()
			self.AnimTbl_MeleeAttack = {"attack1", "attack2", "attack3", "attack4", "attack5", "attack6"}
		elseif randRange == 3 then
			self.SoundTbl_BeforeMeleeAttack = {"npc/antlion/attack_double1.wav", "npc/antlion/attack_double2.wav"}
			self.MeleeAttackDamage = GetConVar("sk_antlion_jump_damage"):GetInt()
			self.AnimTbl_MeleeAttack = {"pounce", "pounce2"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute()
	self:StopSound("npc/antlion/fly1.wav")
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*-15 ,Angle(0,0,0),nil)
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*-15 ,Angle(0,0,0),nil)
	ParticleEffect("blood_impact_antlion_01",self:GetPos() + self:GetUp()* 25 + self:GetForward()*-15 ,Angle(0,0,0),nil)
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
		self:EmitSound(snd, 70, 100) 
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
function ENT:CustomOnThink(ent)
	self:ReactToThumper()
	self:CheckThumperProtection()
	self:CheckThumperStatus()

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
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) && self.Flipped == 0 then 
			self:VJ_ACT_PLAYACTIVITY("flip1",true,4,false)
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.CanTurnWhileStationary = false
			self.HasLeapAttack = false
			self.SightDistance = 1 
			self.IsGuard = true
			self:SetBodygroup(1,0)
			self:StopSound("npc/antlion/fly1.wav")
			self.Flipped = 1
			self.CallForHelp = false

			timer.Simple(4.2,function() if IsValid(self) then
				self.SightDistance = 6000 
				self.IsGuard = false
				self.CallForHelp = true
				self.CanTurnWhileStationary = true
				self.HasLeapAttack = true
				self.Flipped = 0
				self.MovementType = VJ_MOVETYPE_GROUND
				self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end

	if not dmginfo:IsDamageType(DMG_PHYSGUN) then return end

	local ply = dmginfo:GetAttacker()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	local dir = ply:GetAimVector()

	local velocity =
		(dir * 900) +   -- forward force
		Vector(0, 0, 200) -- slight lift

	self:SetVelocity(velocity)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self:StopSound("npc/antlion/fly1.wav")
	if dmginfo:IsDamageType( DMG_BUCKSHOT ) && self.EnemyData.DistanceNearest < 400 then 
		self.HasDeathCorpse = false

		VJ_EmitSound(self, "npc/antlion/antlion_burst" .. math.random(1, 2) .. ".wav", 75, 100)
		util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
		ParticleEffect("AntlionGib",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_slime",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

		self:CreateGibEntity("obj_vj_gib", "models/Antlions/gibs/spitter_ant_gib_large_2.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/Antlions/gibs/spitter_ant_gib_large_1.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/Antlions/gibs/spitter_ant_gib_large_3.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
	end

	if dmginfo:IsDamageType( DMG_CRUSH ) or dmginfo:IsDamageType( DMG_BLAST ) or dmginfo:IsDamageType( DMG_VEHICLE ) then 
		self.HasDeathCorpse = false

		VJ_EmitSound(self, "npc/antlion/antlion_burst" .. math.random(1, 2) .. ".wav", 75, 100)
		util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_POISON,true,true)
		ParticleEffect("AntlionGib",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_slime",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

		self:CreateGibEntity("obj_vj_gib", "models/Antlions/gibs/spitter_ant_gib_large_2.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/Antlions/gibs/spitter_ant_gib_large_1.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
		self:CreateGibEntity("obj_vj_gib", "models/Antlions/gibs/spitter_ant_gib_large_3.mdl", {BloodType=false, CollisionDecal=false, CollisionSound=false, Pos=self:LocalToWorld(Vector(0, 1, 5))})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsDirt(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos -Vector(0, 0, 40),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	local mat = tr.MatType
	return tr.HitWorld && (mat == MAT_SAND || mat == MAT_DIRT || mat == MAT_FOLIAGE || mat == MAT_SLOSH || mat == 85)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dig(ignoreDirt)
	if GetConVar("npc_cets_antlions_dig"):GetInt() == 1 then
		if !ignoreDirt && self:IsDirt(self:GetPos()) or ignoreDirt then
			self:SetNoDraw(true)
			self.IsDigging = true
			timer.Simple(0.02, function()
				if IsValid(self) then
					self:EmitSound("physics/concrete/concrete_break2.wav", 80, 100)
					VJ.EmitSound(self, "npc/antlion/digup1.wav", 75, 100)
					ParticleEffect("advisor_plat_break", self:GetPos(), self:GetAngles(), self)
					ParticleEffect("strider_impale_ground", self:GetPos(), self:GetAngles(), self)
					self:PlayAnim("digout", true, VJ.AnimDuration(self, "digout"), false)
					self.HasMeleeAttack = false
					timer.Simple(0.15, function() if IsValid(self) then self:SetNoDraw(false) end end)
					timer.Simple(VJ.AnimDuration(self, "digout"), function() if IsValid(self) then self.HasMeleeAttack = true self.IsDigging = false end end)
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 20 + self:GetForward() * 30
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
				VJ.EmitSound(self, "npc/antlion/land1.wav", 75, 100)
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
    local ene = self:GetEnemy()
    if not IsValid(ene) then return end

    self:SetGroundEntity(NULL)
    self.LeapAttackHasJumped = true

    self:SetBodygroup(1, 1)
    self:EmitSound("npc/antlion/fly1.wav", 75, 100)

    self:SetLocalVelocity(
        self:OnLeapAttack("Jump", ene) or
        VJ.CalculateTrajectory(
            self,
            ene,
            "Curve",
            self:GetPos() + self:OBBCenter(),
            ene:GetPos() + ene:OBBCenter(),
            1
        )
    )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	self:SetBodygroup(1,0)
	if self.LeapAttackHasJumped then
		self:StopSound("npc/antlion/fly1.wav")
		self.LeapAttackHasJumped = false
	end
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathCorpse(dmginfo, hitgroup)
	local vj_npc_corpse_undo = GetConVar("vj_npc_corpse_undo")
	local vj_npc_corpse_fade = GetConVar("vj_npc_corpse_fade")
	local vj_npc_corpse_fadetime = GetConVar("vj_npc_corpse_fadetime")
	local ai_serverragdolls = GetConVar("ai_serverragdolls")
	local math_min = math.min
	local math_max = math.max
	local math_rad = math.rad
	local math_cos = math.cos
	local math_angApproach = math.ApproachAngle
	local colorGrey = Color(255, 255, 255)
		-- NOTE: dmginfo at this point can be incorrect/corrupted, but its better than leaving the self.SavedDmgInfo empty!
	if !self.SavedDmgInfo then
		self.SavedDmgInfo = {
			dmginfo = dmginfo, -- The actual CTakeDamageInfo object | WARNING: Can be corrupted after a tick, recommended not to use this!
			attacker = dmginfo:GetAttacker(),
			inflictor = dmginfo:GetInflictor(),
			amount = dmginfo:GetDamage(),
			pos = dmginfo:GetDamagePosition(),
			type = dmginfo:GetDamageType(),
			force = dmginfo:GetDamageForce(),
			ammoType = dmginfo:GetAmmoType(),
			hitgroup = hitgroup,
		}
	end
	
	if self.HasDeathCorpse && self.HasDeathRagdoll != false then
		local corpseMdl = self:GetModel()
		if corpseMdlCustom then corpseMdl = corpseMdlCustom end
		local corpseClass = "prop_physics"
		if self.DeathCorpseEntityClass then
			corpseClass = self.DeathCorpseEntityClass
		else
			if util.IsValidRagdoll(corpseMdl) then
				corpseClass = "prop_ragdoll"
			elseif !util.IsValidProp(corpseMdl) or !util.IsValidModel(corpseMdl) then
				if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end
				return false
			end
		end
		self.Corpse = ents.Create(corpseClass)
		local corpse = self.Corpse
		corpse:SetModel(corpseMdl)
		corpse:SetPos(self:GetPos())
		corpse:SetAngles(self:GetAngles())
		corpse:Spawn()
		corpse:Activate()
		corpse:SetSkin(self:GetSkin())
		for i = 0, self:GetNumBodyGroups() do
			corpse:SetBodygroup(i, self:GetBodygroup(i))
		end
		corpse:SetColor(self:GetColor())
		corpse:SetMaterial(self:GetMaterial())
		if !corpseMdlCustom && self.DeathCorpseSubMaterials then -- Take care of sub materials
			for _, x in ipairs(self.DeathCorpseSubMaterials) do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end
			 -- This causes lag, not a very good way to do it.
			/*for x = 0, #self:GetMaterials() do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end*/
		end
		//corpse:SetName("corpse" .. self:EntIndex())
		//corpse:SetModelScale(self:GetModelScale())
		corpse.FadeCorpseType = (corpse:GetClass() == "prop_ragdoll" and "FadeAndRemove") or "kill"
		corpse.IsVJBaseCorpse = true
		corpse.DamageInfo = dmginfo
		corpse.ChildEnts = self.DeathCorpse_ChildEnts or {}
		corpse.BloodData = {Color = self.BloodColor, Particle = self.BloodParticle, Decal = self.BloodDecal}

		if self.Bleeds && self.HasBloodPool && vj_npc_blood_pool:GetInt() == 1 then
			self:SpawnBloodPool(dmginfo, hitgroup, corpse)
		end
		
		-- Collision
		corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if ai_serverragdolls:GetInt() == 1 then
			undo.ReplaceEntity(self, corpse)
		else -- Keep corpses is not enabled...
			VJ.Corpse_Add(corpse)
			if vj_npc_corpse_undo:GetInt() == 1 then undo.ReplaceEntity(self, corpse) end -- Undoable
		end
		cleanup.ReplaceEntity(self, corpse) -- Delete on cleanup
		
		-- On fire
		if self:IsOnFire() then
			if !self.Immune_Fire then -- Don't darken the corpse if we are immune to fire!
				corpse:SetColor(colorGrey)
				//corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
			end
		end
		
		-- Dissolve
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			corpse:Dissolve(0, 1)
		end
		
		-- Bone and Angle
		-- If it's a bullet, it will use localized velocity on each bone depending on how far away the bone is from the dmg position
		local useLocalVel = (bit.band(self.SavedDmgInfo.type, DMG_BULLET) != 0 and self.SavedDmgInfo.pos != defPos) or false
		local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if self.DeathAnimationCodeRan then
			useLocalVel = false
			dmgForce = self:GetGroundSpeedVelocity()
		end
		local totalSurface = 0
		local physCount = corpse:GetPhysicsObjectCount()
		for childNum = 0, physCount - 1 do -- 128 = Bone Limit
			local childPhysObj = corpse:GetPhysicsObjectNum(childNum)
			if IsValid(childPhysObj) then
				totalSurface = totalSurface + childPhysObj:GetSurfaceArea()
				local childPhysObj_BonePos, childPhysObj_BoneAng = self:GetBonePosition(corpse:TranslatePhysBoneToBone(childNum))
				if childPhysObj_BonePos then
					if self.DeathCorpseSetBoneAngles then childPhysObj:SetAngles(childPhysObj_BoneAng) end
					childPhysObj:SetPos(childPhysObj_BonePos)
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and childPhysObj_BonePos:Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				-- If it's 1, then it's likely a regular physics model with no bones
				elseif physCount == 1 then
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and corpse:GetPos():Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				end
			end
		end
		
		-- Health & stink system
		if corpse:Health() <= 0 then
			local hpCalc = totalSurface / 60
			corpse:SetMaxHealth(hpCalc)
			corpse:SetHealth(hpCalc)
		end
		VJ.Corpse_AddStinky(corpse, true)
		
		if IsValid(self.WeaponEntity) then corpse.ChildEnts[#corpse.ChildEnts + 1] = self.WeaponEntity end
		if self.DeathCorpseFade then corpse:Fire(corpse.FadeCorpseType, nil, self.DeathCorpseFade) end
		if vj_npc_corpse_fade:GetInt() == 1 then corpse:Fire(corpse.FadeCorpseType, nil, vj_npc_corpse_fadetime:GetInt()) end
		self:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
		if corpse:IsFlagSet(FL_DISSOLVING) then
			if IsValid(self.WeaponEntity) then
				self.WeaponEntity:Dissolve(0, 1)
			end
			if corpse.ChildEnts then
				for _, child in ipairs(corpse.ChildEnts) do
					child:Dissolve(0, 1)
				end
			end
		end
		corpse:CallOnRemove("vj_" .. corpse:EntIndex(), function(ent, childPieces)
			for _, child in ipairs(childPieces) do
				if IsValid(child) then
					if child:GetClass() == "prop_ragdoll" then -- Make ragdolls fade
						child:Fire("FadeAndRemove")
					else
						child:Fire("kill")
					end
				end
			end
		end, corpse.ChildEnts)
		hook.Call("CreateEntityRagdoll", nil, self, corpse)
		return corpse
	else
		if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end -- Remove dropped weapon
		-- Remove child entities | No fade effects as it will look weird, remove it instantly!
		if self.DeathCorpse_ChildEnts then
			for _, child in ipairs(self.DeathCorpse_ChildEnts) do
				child:Remove()
			end
		end
	end
end