AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_crabsynth.mdl"}
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.StartHealth = GetConVar("sk_crabsynth_health"):GetInt()
ENT.TurningSpeed = 12 -- How fast it can turn
ENT.VJ_IsHugeMonster = true
ENT.VJ_ID_Boss = true
ENT.CanChatMessage = false
ENT.RunAwayOnUnknownDamage = false -- Should run away on damage
ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(-50, 0, 50), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "Bip02 Neck", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(25, 0, 25), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true
ENT.PropInteraction = "OnlyPush" -- Controls how it should interact with props
	-- false = Disable both damaging and pushing | true = Damage and push | "OnlyDamage" = Damage but don't push | "OnlyPush" = Push but don't damage
ENT.PropInteraction_MaxScale = 500 -- Max prop size multiplier | x < 1  = Smaller props | x > 1  = Larger props
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_impact_synth_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.InvestigateSoundDistance = 4000
ENT.CallForHelpDistance = 10000 -- -- How far away the SNPC's call for help goes | Counted in World Units
ENT.TimeUntilMeleeAttackDamage = 0.2 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 32
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 200 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 150 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 120 -- How close does it have to be until it attacks?
ENT.NextMeleeAttackTime = 0.8 -- How much time until it can use a melee attack?
ENT.MeleeAttackDamageDistance = 130 -- How far does the damage go?

ENT.HasRangeAttack = false
ENT.RangeAttackProjectiles = "obj_vj_nothing_of_the_lazyness"
ENT.NextRangeAttackTime = 99999999999999999999999999999999

ENT.MinPrioritizeShootDist = 1000 -- If the enemy is closer than this then start prioritizing the charge attack instead.
ENT.MaxShootDist = 2000
ENT.MinShootDist = 500
ENT.MaxShootHeightDifference = 300

ENT.BulletSpread = 0.1

ENT.CurrentShootCoolDown = ENT.ShootCooldown_Far

ENT.ShootDuration_Far = 5
ENT.ShootDuration_Close = 2

ENT.ShootCooldown_Far = 5
ENT.ShootCooldown_Close = 8

ENT.ChargeDuration = 3
ENT.ChargeCooldown = 5
ENT.ChargeDamage = GetConVar("sk_crabsynth_charge_dmg"):GetInt()

ENT.FootStepSoundLevel = 80
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events

ENT.AlertSoundLevel = 100
ENT.PainSoundLevel = 80
ENT.DeathSoundLevel = 100
ENT.InvestigateSoundLevel = 80
ENT.CombatIdleSoundLevel = 80

ENT.BeforeMeleeAttackSoundPitch = VJ_Set(85, 115)
ENT.BeforeMeleeAttackSoundLevel = 100

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.DeathCorpseApplyForce = false
ENT.AnimTbl_Death = {
	"death01",
	"death02",
	"death03",
}

ENT.SoundTbl_FootStep = {"NPC_Strider.Footstep"}

ENT.SoundTbl_Idle = {
	"npc/crabsynth/cs_idle01.wav",
	"npc/crabsynth/cs_idle02.wav",
	"npc/crabsynth/cs_idle03.wav",
}

ENT.SoundTbl_CombatIdle = ENT.SoundTbl_Idle

ENT.SoundTbl_Investigate = {
	"npc/crabsynth/cs_distant01.wav",
	"npc/crabsynth/cs_distant02.wav",
}

ENT.SoundTbl_Alert = {
	"npc/crabsynth/cs_alert01.wav",
	"npc/crabsynth/cs_alert02.wav",
	"npc/crabsynth/cs_alert03.wav",
}

ENT.SoundTbl_Pain = {
	"npc/crabsynth/cs_roar01.wav",
	"npc/crabsynth/cs_roar02.wav",
}

ENT.SoundTbl_Death = {"npc/crabsynth/cs_die.wav"}

ENT.SoundTbl_BeforeMeleeAttack = {"npc/crabsynth/cs_pissed01.wav"}

ENT.SoundTbl_MeleeAttack = {"npc/crabsynth/cs_skewer.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(-50,-50,0), Vector(50,50,85))

	self.FireGunLoop = CreateSound(self,"npc/crabsynth/minigun_loop.wav")
	self.FireGunLoop:SetSoundLevel(140)

	self.NextShootTime = CurTime()
	self.NextChargeTime = CurTime()

	self.Bullseye = ents.Create("base_anim")
	self.Bullseye:SetModel("models/hunter/blocks/cube1x1x025.mdl")
	self.Bullseye:SetParent(self)
	self.Bullseye:SetPos(self:GetPos() + self:GetForward()*100 + Vector(0,0,15))
	self.Bullseye:Spawn()
	self.Bullseye:SetNoDraw(true)
	self.Bullseye:DrawShadow(false)
	self.Bullseye:SetSolid(SOLID_NONE)
	self.Bullseye.VJ_NPC_Class = self.VJ_NPC_Class

	if GetConVar("npc_crabsynth_disable_charge"):GetInt() == 1 then
		self.ChargeDuration = 0
		self.ChargeCooldown = 4096
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("MOUSE2 (secondary attack key): Fire Minigun")
	ply:ChatPrint("SPACE (jump key): Charge Attack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
	end

	self.Bullseye.VJ_NPC_Class = self.VJ_NPC_Class

	if GetConVar("ai_disabled"):GetInt() == 1 then
		self:StopFiringRoutine(true)
	end

	if !self.GunAttacking && self.FireGunLoop:IsPlaying() then
		self.FireGunLoop:Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.DeathAnimationCodeRan then return end
	local enemy = self:GetEnemy()

	if IsValid(enemy) then

	if self.VJ_IsBeingControlled then
	local controller = self.VJ_TheController
		if !self:Attacking() then
			if controller:KeyDown(IN_ATTACK2) then
				self:StartGunAttack(3)
			elseif controller:KeyDown(IN_JUMP) && self.NextChargeTime < CurTime() then
				self:ChargeAtEnemy(5)
			end
		end
	else
		local enemydist = self:GetPos():Distance(enemy:GetPos())
		local fireduration = self.ShootDuration_Far
				self.CurrentShootCoolDown = self.ShootCooldown_Far
        
		if enemydist < self.MinPrioritizeShootDist then
			fireduration = self.ShootDuration_Close
			self.CurrentShootCoolDown = self.ShootCooldown_Close

		if !self:Attacking() && self.NextChargeTime < CurTime() && self:CanChargeEnemy() then
			self:ChargeAtEnemy(self.ChargeDuration)
		end
	end

	if self:Visible(self:GetEnemy()) then
		self:TryUpdateShootPos()
	end

	if !self:Attacking() && self.NextShootTime < CurTime() && enemydist < self.MaxShootDist && ( enemydist > self.MinShootDist or !self:CanChargeEnemy() ) then
		local mypos = self:GetPos() + self:OBBCenter()
		local targetpos = self.ShootPos or enemy:GetPos()

		if (self:Visible(enemy) or self.ShootPos) && math.abs(mypos.z - targetpos.z) < self.MaxShootHeightDifference then
			self:StartGunAttack(fireduration)
		end
	end

	if !self:Visible(enemy) && !self.ShootPos then
		self:StopFiringRoutine(true)
		end
	end

	if self.ShootPos && self.GunAttacking then self:VisuallyAimGunTowardsEnemy() end
	if self.Charging then self:ChargeThink() end

	elseif !IsValid(enemy) then
		if self.Charging then
			self:StopCharging(true,self.ChargeCooldown*0.5)
        end

	if self.GunAttacking then
		self:StopFiringRoutine(true)
	end
		self.ShootPos = nil
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	self.HasPainSounds = false
	self.Bleeds = false
	local infl = dmginfo:GetInflictor()
	local comballdamage = false

	if infl && IsValid(infl) then
		if infl:GetClass() == "prop_combine_ball" then
			infl:Fire("Explode")
			comballdamage = true
	end

	if !infl.DamagedVJ_ZHunter && infl:GetClass() == "obj_vj_combineball" then
		infl.DamagedVJ_ZHunter = true
		infl:DeathEffects()
			comballdamage = true
		end
	end

	if !( dmginfo:GetDamagePosition().z < (self:GetPos()+self:OBBCenter()+Vector(0,0,-8)).z && dmginfo:IsExplosionDamage() ) && !comballdamage then

		dmginfo:SetDamage(dmginfo:GetDamage()*0.8)

		if math.random(1, 4) == 1 then
			self.Bleeds = true
			self:EmitSound("physics/metal/metal_barrel_impact_hard" .. math.random(1, 3) .. ".wav", 92, math.random(70, 90))
			self:EmitSound("ambient/energy/zap" .. math.random(1, 9) .. ".wav", 92, math.random(70, 90))
			self.BloodParticle = "blood_spurt_synth_01"
		end

		else
			self.Bleeds = true
			self.HasPainSounds = true
			self.BloodParticle = "blood_impact_synth_01"

	if comballdamage then
			dmginfo:SetDamage(35)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	if ev == 1004 then self:FootStepSoundCode() end
	if ev == 28 && self.GunAttacking then
		self:FireGun()
			if !self.FireGunLoop:IsPlaying() then
				self.FireGunLoop:Play()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer(seed)
	timer.Simple(0.2, function() if IsValid(self) && !self.DeathAnimationCodeRan then self:CustomMeleeDamage(self.MeleeDamage) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomMeleeDamage(damage,damagetype)
	damagetype = damagetype or DMG_SLASH
	local realisticRadius = false
	local damaged_ents = util.VJ_SphereDamage(self, self, self:GetPos() + self:GetForward() * 50, 50, damage, damagetype, true, realisticRadius)
	local NPCWasHit = false

	if self.Charging then
		for _, ent in pairs(damaged_ents) do
			local dir = self:GetVelocity():GetNormalized()

			if dir == vector_origin then
				dir = self:GetForward()
			end

			local speed = math.max(self:GetVelocity():Length(), 400)
			local knockback = dir * (speed * 0.65)
			knockback.z = math.Clamp(speed * 0.55, 180, 300)

			local center = self:GetPos() + self:GetForward() * 60

			for _, ent in ipairs(ents.FindInSphere(center, 48)) do
				if ent == self then continue end

				local class = ent:GetClass()

				if class == "func_breakable" then
					local dmg = DamageInfo()
					dmg:SetAttacker(self)
					dmg:SetInflictor(self)
					dmg:SetDamage(500)
					dmg:SetDamageType(bit.bor(DMG_CLUB, DMG_CRUSH))
					ent:TakeDamageInfo(dmg)

				return

				elseif class == "func_breakable_surf" then
					ent:Fire("Shatter")
					return
				end
			end

			if ent:IsNPC() or ent:IsPlayer() then
				if ent:IsPlayer() then
					ent:SetVelocity(knockback)
				elseif !ent.VJ_IsHugeMonster then
					ent:SetVelocity(knockback / 2)
				end

				NPCWasHit = true
			end
		end

		if NPCWasHit then
			self:EmitSound("npc/crabsynth/cs_skewer.wav",85,math.random(90, 110))
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Attacking() if self.Charging or self.GunAttacking or self.MeleeAttacking then return true end end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VisuallyAimGunTowardsEnemy()
	local bullet_source = self:GetAttachment(1).Pos
	local fire_dir = ( self.ShootPos - bullet_source ):GetNormalized()
	local fire_ang = self:WorldToLocalAngles(fire_dir:Angle())

	local poseparam_yaw = math.Clamp( fire_ang.y*2.5, -45, 45 )

	self:SetPoseParameter( "weapon_yaw", poseparam_yaw )
	self:SetPoseParameter( "weapon_pitch", fire_ang.x )

	if math.abs(poseparam_yaw) == 45 then
		self:SetIdealYawAndUpdate(fire_dir:Angle().y)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartGunAttack(duration)
	if self.GunAttacking then return end
	self.GunAttacking = true

	local timeuntilstartfire = 2
	self:EmitSound("npc/crabsynth/minigun_start.wav",105,math.random(90, 110))

	self:VJ_ACT_PLAYACTIVITY(ACT_ARM, true, timeuntilstartfire, true)

	timer.Simple(timeuntilstartfire, function() if IsValid(self) && self.GunAttacking && !self.DeathAnimationCodeRan then
			self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1, true, duration, false)

	timer.Simple(duration, function() if IsValid(self) && self.GunAttacking then
			self:StopFiringRoutine()
		end end)
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FireGun()
	local bullet_source = self:GetAttachment(1).Pos
	local shootpos = self.ShootPos or bullet_source+self:GetForward()*100
	local fire_dir = ( (shootpos) - bullet_source ):GetNormalized()

	if math.random(1, 2) == 1 then
		local expLight = ents.Create("light_dynamic")
			expLight:SetKeyValue("brightness", "2")
			expLight:SetKeyValue("distance", "128")
			expLight:Fire("Color", "0 75 255")
			expLight:SetPos(bullet_source)
			expLight:Spawn()
			expLight:SetParent(self,1)
			expLight:Fire("TurnOn", "", 0)
		timer.Simple(0.1,function() if IsValid(expLight) then expLight:Remove() end end)
		self:DeleteOnRemove(expLight)
		ParticleEffect("ar2_muzzleflash_cets",bullet_source,self:GetAttachment(2).Ang)
	end

	self:FireBullets({
		Src = bullet_source,
		Dir = fire_dir,
			Damage = 2,
			Force = 25,
	TracerName = "AirboatGunHeavyTracer",
	Tracer = 2,
	Spread = Vector( self.BulletSpread,self.BulletSpread,self.BulletSpread ),
	Num = 1,
		Callback = function(attacker, tracer)
			if math.random(1, 4) == 1 then
				local effectdata = EffectData()
				effectdata:SetOrigin(tracer.HitPos)
				effectdata:SetNormal(tracer.HitNormal)
				effectdata:SetRadius( 10 )
			util.Effect( "cball_bounce", effectdata )
		end
		effects.BeamRingPoint( tracer.HitPos, 0.3, 0, 70, 12, 6, Color(32,16,255,200) )
			util.VJ_SphereDamage(self,self,tracer.HitPos,20,3,DMG_SONIC,true,false,false,false)
		end,
	})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TryUpdateShootPos()
	local enemy = self:GetEnemy()
    
	if IsValid(enemy) && self:Visible(enemy) then
		self.ShootPos = enemy:GetPos() + enemy:OBBCenter()
	end

	local mypos = self:GetPos() + self:OBBCenter()
	if self.ShootPos then
		self.ShootPos = Vector( self.ShootPos.x , self.ShootPos.y , math.Clamp(self.ShootPos.z,mypos.z-self.MaxShootHeightDifference,mypos.z+self.MaxShootHeightDifference) )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopFiringRoutine(skipcooldown)
	if !self.GunAttacking or self.DeathAnimationCodeRan then return end

	self.ShootPos = nil
	self.GunAttacking = false

	self.FireGunLoop:Stop()

	self:EmitSound("npc/crabsynth/minigun_stop.wav",105,math.random(90, 110))
	self:VJ_ACT_PLAYACTIVITY(ACT_IDLE, true, 0)

	if !skipcooldown then
		self.NextShootTime = CurTime() + self.CurrentShootCoolDown
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsNearEdge(dist)
	dist = dist or 90
 
	local pos = self:GetPos()
	local forward = self:GetForward()
	local right = self:GetRight()
 
	local groundTr = util.TraceLine({
		start = pos + Vector(0, 0, 10),
		endpos = pos - Vector(0, 0, 70),
		mask = MASK_NPCWORLDSTATIC
	})
 
	local groundZ = groundTr.Hit and groundTr.HitPos.z or pos.z
 
	local checks = {pos + forward * dist, pos + forward * dist + right * 24, pos + forward * dist - right * 24}
 
	for _, checkPos in ipairs(checks) do
		local tr = util.TraceHull({
			start = checkPos + Vector(0, 0, 10),
			endpos = checkPos - Vector(0, 0, 90),
			mins = Vector(-6, -6, 0),
			maxs = Vector(6, 6, 6),
			mask = MASK_NPCWORLDSTATIC
		})
 
		if !tr.Hit or (groundZ - tr.HitPos.z) > 60 then
			return true
		end
	end
 
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanChargeEnemy()
	local forward = self:GetForward()
	local right = self:GetRight()

	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetEnemy():GetPos(),
		mask = MASK_NPCWORLDSTATIC,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs(),
	})

	if self:IsNearEdge(280) then
		return false
	end

	if self:Visible(self:GetEnemy()) && self:GetEnemy():IsOnGround() && !tr.Hit then
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChargeThink()
	if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) then
		self:SetIdealYawAndUpdate( (self:GetEnemy():GetPos() - self:GetPos() ):Angle().y )
	end

	if !self.Charge_ApplyForceCountdownStarted && self:GetActivity() == ACT_SPECIAL_ATTACK1 then
		self.Charge_ApplyForceCountdownStarted = true
		timer.Simple(0.6, function() if IsValid(self) then
				self.Charge_ShouldApplyForce = true
			end
		end)
	end

	local speed = 1256

	if self.Charge_ShouldApplyForce && self:IsOnGround() then
		local vel = self:GetVelocity()
		local forwardVel = vel:Dot(self:GetForward())

		if forwardVel < speed then
			self:SetVelocity(self:GetForward() * (speed - forwardVel))
			util.ScreenShake(self:GetPos(), 12, 1, 0.18, 650)
		end
	end

	if self:CustomMeleeDamage(self.ChargeDamage, bit.bor(DMG_CLUB,DMG_CRUSH,DMG_SLASH)) == true then -- Player or NPC was hit.
		self:StopCharging(false,self.ChargeCooldown)
		self:EmitSound("physics/metal/metal_sheet_impact_hard" .. math.random(6, 8) .. ".wav", 100, math.random(90,110))
		self:VJ_ACT_PLAYACTIVITY("chargeend", true, duration, true)
	end

	local wallHullMins, wallHullMaxs = self:OBBMins(), self:OBBMaxs()

	local wallTrace = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos() + self:GetForward() * 60,
		mins = Vector(wallHullMins.x, wallHullMins.y, 32),
		maxs = self:OBBMaxs(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY
	})

	if wallTrace.Hit then
		local normal = wallTrace.HitNormal

		if normal.z > 0.25 then
			return
		end

		self:EmitSound("physics/metal/metal_sheet_impact_hard" .. math.random(6, 8) .. ".wav", 90, math.random(80,110))
		self:StopCharging(true, self.ChargeCooldown * 0.5)
		self:TakeDamage(5)
		return
	end

	local sidePositions = {
		self:GetPos() + self:GetForward() * 60,
		self:GetPos() + self:GetForward() * 60 + self:GetRight() * 30,
		self:GetPos() + self:GetForward() * 60 - self:GetRight() * 30,
	}

	for _, sidePos in ipairs(sidePositions) do
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = sidePos,
			mins = Vector(-18, -18, 32),
			maxs = Vector(18, 18, 72),
			filter = self,
			mask = MASK_SOLID
		})
 
		if tr.Hit then
			self:StopCharging(true, self.ChargeCooldown * 0.5)
			return
		end
	end

	if self:IsNearEdge() then
		self:StopCharging(true, self.ChargeCooldown * 0.5)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChargeAtEnemy(duration)
	if self.Charging then return end
	self.Charging = true
	self.Charge_ApplyForceCountdownStarted = false
	self.Charge_ShouldApplyForce = false

	self:VJ_ACT_PLAYACTIVITY(ACT_SPECIAL_ATTACK1, true, duration, false)

	timer.Simple(duration, function() if IsValid(self) && self.Charging then
		self:StopCharging(true,self.ChargeCooldown)
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopCharging(UseAnimation,nextcharge)
	if self.DeathAnimationCodeRan then return end

	self.MovementType = VJ_MOVETYPE_STATIONARY
	self.CanTurnWhileStationary = false
	self.HasMeleeAttack = false
	self.HasRangeAttack = false
	self.IsGuard = true
	self.CallForHelp = false

	if UseAnimation then self:VJ_ACT_PLAYACTIVITY("chargeend", true, self:SequenceDuration(self:LookupSequence( "mgrunt_charge_crash" )), true) end

	timer.Simple(self:SequenceDuration(self:LookupSequence( "chargeend" )), function() if IsValid(self) then
		self.MovementType = VJ_MOVETYPE_GROUND
		self.CanTurnWhileStationary = true
		self.HasMeleeAttack = true
		self.HasRangeAttack = true
		self.IsGuard = false
		self.CallForHelp = true
	end end)

	self.Charging = false
	self.Charge_ShouldApplyForce = false

	self.NextChargeTime = CurTime() + nextcharge
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.FireGunLoop:Stop()
end