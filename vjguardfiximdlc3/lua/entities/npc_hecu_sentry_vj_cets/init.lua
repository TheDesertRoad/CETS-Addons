AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/npcs/sentry_ground.mdl"
ENT.StartHealth = GetConVar("sk_cets_hecu_sentry_health"):GetInt()
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 3000
ENT.SightAngle = 220
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.EntitiesToNoCollide = {"npc_engi_vj_cets"}
ENT.MovementType = VJ_MOVETYPE_PHYSICS
ENT.CanTurnWhileStationary = false
ENT.HasDeathCorpse = true

ENT.ControllerParams = {
    FirstP_Bone = "barrel",
    FirstP_Offset = Vector(0, 6, 6),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AllowIgnition = false  -- Can it be set on fire?
ENT.Immune_Bullet = false  -- Immune to bullet damages
ENT.Immune_Melee = false  -- Immune to melee damages (Ex: Slashes, stabs, punches, claws, crowbar, blunt attacks)
ENT.Immune_Explosive = false  -- Immune to explosive damages (Ex: Grenades, rockets, bombs, missiles)
ENT.Immune_Dissolve = false   -- Immune to dissolving damage (Ex: Combine ball)
ENT.Immune_Toxic = true  -- Immune to toxic effect damages (Ex: Acid, poison, radiation, gas)
ENT.Immune_Fire = true  -- Immune to fire / flame damages
ENT.Immune_Electricity = false -- Immune to electrical damages (Ex: Shocks, lasers, gravity gun)
ENT.Immune_Sonic = false 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false
ENT.CanChatMessage = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = false
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 1
ENT.RangeAttackAngleRadius = 240
ENT.TimeUntilRangeAttackProjectileRelease = 0.04
ENT.NextRangeAttackTime = 0.04
ENT.NextAnyAttackTime_Range = 0.04
ENT.RangeAttackAttachment = "eject"

ENT.CanReceiveOrders = false
ENT.VJ_ID_Healable = false
ENT.EnemyTimeout = 5

ENT.SoundTbl_Impact = {
	"ambient/energy/spark1.wav",
	"ambient/energy/spark2.wav",
	"ambient/energy/spark3.wav",
	"ambient/energy/spark4.wav"
}

ENT.SoundTbl_Death = {
	"npc/hturret/tu_die2.wav",
	"npc/hturret/tu_die3.wav"
}

local sdFiring = {
	"npc/hturret/tu_fire1.wav"
}

local TURRET_STATUS_UNKNOWN   = -1
local TURRET_STATUS_IDLE      = 0
local TURRET_STATUS_DEPLOYING = 1
local TURRET_STATUS_SEEKING   = 2
local TURRET_STATUS_TARGETING = 3

local TURRET_STATUS_SKINS = {
	[TURRET_STATUS_UNKNOWN]   = 0,
	[TURRET_STATUS_IDLE]      = 0,
	[TURRET_STATUS_DEPLOYING] = 1,
	[TURRET_STATUS_SEEKING]   = 2,
	[TURRET_STATUS_TARGETING] = 3
}

ENT.Turret_Status = TURRET_STATUS_UNKNOWN
ENT.Turret_HasLOS = false
ENT.Turret_StandDown = true
ENT.Turret_CurrentParameter = 0
ENT.Turret_ScanDirSide = 0
ENT.Turret_ScanDirUp = 0
ENT.Turret_NextScanBeepT = 0
ENT.Turret_ControllerStatus = 0
ENT.Turret_IdleAnim = ACT_IDLE
ENT.Turret_IdleAngryAnim = ACT_IDLE
ENT.Turret_Down = 1
ENT.IsGoingDown = 0
ENT.Turret_Picked = 0
ENT.Turret_DownLookYaw = 0
ENT.Turret_DownLookPitch = 0
ENT.Turret_DownLookNextT = 0
ENT.Turret_DownLookSpeed = 8
ENT.HasPoseParameterLooking = false
ENT.Turret_IsFiring = false
ENT.Turret_Picked = 0
ENT.Turret_PickedSearching = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 63), Vector(-13, -13, 0))

	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "sprites/glow1.vmt")
	spr:SetKeyValue("scale", "0.4")
	spr:SetKeyValue("rendermode", "9")
	spr:SetKeyValue("renderfx", "14")
	spr:SetKeyValue("rendercolor", "128 128 128")
	spr:SetKeyValue("renderamt", "200")
	spr:SetParent(self)
	spr:Fire("SetParentAttachment", "alarm")
	spr:Spawn()
	spr:Activate()
	spr:Fire("HideSprite")
	self:DeleteOnRemove(spr)
	self.Turret_Sprite = spr

	local spr1 = ents.Create("env_sprite")

	spr1:SetKeyValue("model", "sprites/glow1.vmt")
	spr1:SetKeyValue("scale", "0.2")
	spr1:SetKeyValue("rendermode", "9")
	spr1:SetKeyValue("renderfx", "14")
	spr1:SetKeyValue("rendercolor", "128 0 0")
	spr1:SetKeyValue("renderamt", "200")
	spr1:SetParent(self)
	spr1:Fire("SetParentAttachment", "laser")
	spr1:Spawn()
	spr1:Activate()
	self:DeleteOnRemove(spr1)

	self.BulletOrigin = ents.Create("prop_dynamic")
	self.BulletOrigin:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self.BulletOrigin:SetPos(self:GetPos())
	self.BulletOrigin:SetAngles(self:GetAngles())
	self.BulletOrigin:SetRenderMode(RENDERMODE_NONE)
	self.BulletOrigin:SetMoveType(MOVETYPE_NONE)
	self.BulletOrigin:SetSolid(SOLID_NONE)
	self.BulletOrigin:SetParent(self)
	self.BulletOrigin:Spawn()
	self.BulletOrigin:Activate()

	local ejectID = self:LookupAttachment("eject")

	if ejectID and ejectID > 0 then
		self.BulletOrigin:Fire("SetParentAttachment", "eject")
	end

	self:DeleteOnRemove(self.BulletOrigin)

	self:PhysicsInit(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(30000)
	end

	timer.Simple(2, function()
		if IsValid(phys) then
			phys:SetMass(30)
		end
	end)

	local idleSeq = self:LookupSequence("idle")
	local angrySeq = self:LookupSequence("idlealert")

	if idleSeq >= 0 then
		self.Turret_IdleAnim = self:GetSequenceActivity(idleSeq)
	end

	if angrySeq >= 0 then
		self.Turret_IdleAngryAnim = self:GetSequenceActivity(angrySeq)
	end

	self.TurretSD_Turning = CreateSound(self, "npc/hturret/tu_active.wav")
	self.TurretSD_Turning:SetSoundLevel(60)
	self.TurretSD_Alarm = CreateSound(self, "npc/hturret/tu_alert.wav")
	self.TurretSD_Alarm:SetSoundLevel(75)
	self:SetTurretStatus(TURRET_STATUS_IDLE)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTurretStatus(status)
	if not TURRET_STATUS_SKINS[status] then
		status = TURRET_STATUS_UNKNOWN
	end

	if self.Turret_Status == status then
		return
	end

	self.Turret_Status = status

	local skin = TURRET_STATUS_SKINS[status]

	if self:GetSkin() != skin then
		self:SetSkin(skin)
	end

	if not IsValid(self.Turret_Sprite) then
		return
	end

	if status == TURRET_STATUS_UNKNOWN then
		self.Turret_Sprite:Fire("HideSprite")
	elseif status == TURRET_STATUS_IDLE then
		self.Turret_Sprite:Fire("HideSprite")
	elseif status == TURRET_STATUS_DEPLOYING then
		self.Turret_Sprite:Fire("Color", "0 128 0")
		self.Turret_Sprite:Fire("ShowSprite")
	elseif status == TURRET_STATUS_SEEKING then
		self.Turret_Sprite:Fire("Color", "128 90 0")
		self.Turret_Sprite:Fire("ShowSprite")
	elseif status == TURRET_STATUS_TARGETING then
		self.Turret_Sprite:Fire("Color", "128 0 0")
		self.Turret_Sprite:Fire("ShowSprite")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if not self.Turret_StandDown then
			return self.Turret_IdleAngryAnim
		end

		return self.Turret_IdleAnim
	end

	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local skin = TURRET_STATUS_SKINS[self.Turret_Status]

	if skin != nil and self:GetSkin() != skin then
		self:SetSkin(skin)
	end

	if self.Turret_IsFiring then
		VJ.STOPSOUND(self.TurretSD_Turning)
		return
	end

	local parameter = self:GetPoseParameter("aim_yaw")

	if parameter != self.Turret_CurrentParameter then
		self.TurretSD_Turning:PlayEx(1, 100)
	else
		VJ.STOPSOUND(self.TurretSD_Turning)
	end

	self.Turret_CurrentParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EnterIdleState()
	self.Turret_StandDown = true
	self.HasPoseParameterLooking = false

	self:SetPoseParameter("aim_yaw", 0)
	self:SetPoseParameter("aim_pitch", 0)

	local seq = self:LookupSequence("spindown")

	if seq >= 0 then
		self:ResetSequence(seq)
		self:SetPlaybackRate(1)
		self:SetCycle(0)

		timer.Simple(self:SequenceDuration(seq), function()
			if not IsValid(self) then return end
			if self.Turret_Status != TURRET_STATUS_IDLE then return end

			self:SetCycle(1)
			self:SetPlaybackRate(0)
		end)
	end

	if IsValid(self.Turret_Sprite) then
		self.Turret_Sprite:Fire("HideSprite")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end

	if self.Turret_IsFiring then
		return
	end

	local upright = self:GetUp():Dot(Vector(0, 0, 1))

	if upright < 0.7 then
		if self.IsGoingDown == 0 then
			self:Turret_PhysDown()
			self.IsGoingDown = 1
			self:Turret_DownLookRandom()
		end

		self:Turret_DownLookRandom()

		return
	else
		if self.IsGoingDown == 1 then
			self.IsGoingDown = 0
			self.HasRangeAttack = true
			self:Turret_Activate()
		end
	end

	local enemy = self:GetEnemy()
	local enemyValid = IsValid(enemy)

	if self.Turret_Status == TURRET_STATUS_DEPLOYING then
		return
	end

	if self.Turret_ControllerStatus == 1 or (not self.VJ_IsBeingControlled and (enemyValid or (self.Alerted and self.EnemyData and not self.EnemyData.Reset))) then
		self.Turret_StandDown = false

		local doScan = false

		if enemyValid and not self.Turret_HasLOS and self.EnemyData and math.abs(self.EnemyData.VisibleTime - CurTime()) >= 1 then
			doScan = true
			self.HasPoseParameterLooking = false
		else
			if self.Turret_Status != TURRET_STATUS_TARGETING then
				VJ.EmitSound(self, "npc/hturret/tu_spinup.wav", 70, 100)
				self.NextDoAnyAttackT = CurTime() + 0.5
			end

			self:SetTurretStatus(TURRET_STATUS_TARGETING)
			self.HasPoseParameterLooking = true
		end

		if not enemyValid or doScan then
			self:SetTurretStatus(TURRET_STATUS_SEEKING)
			self.HasPoseParameterLooking = false

			if self.Turret_NextScanBeepT < CurTime() then
				VJ.EmitSound(self, "npc/hturret/tu_ping.wav", 75, 100)

				self.Turret_NextScanBeepT =CurTime() + 1
			end

			local yaw = self:GetPoseParameter("aim_yaw")

			if yaw >= 80 then
				self.Turret_ScanDirSide = 1
			elseif yaw <= -80 then
				self.Turret_ScanDirSide = 0
			end

			if self.Turret_ScanDirSide == 1 then
				yaw = yaw - 5
			else
				yaw = yaw + 5
			end

			self:SetPoseParameter("aim_yaw", yaw)

			local pitch =
				self:GetPoseParameter("aim_pitch")

			if pitch >= 15 then
				self.Turret_ScanDirUp = 1

			elseif pitch <= -15 then
				self.Turret_ScanDirUp = 0
			end

			if self.Turret_ScanDirUp == 1 then
				pitch = pitch - 1
			else
				pitch = pitch + 1
			end

			self:SetPoseParameter("aim_pitch", pitch)
		end

		return
	end

	self:SetTurretStatus(TURRET_STATUS_IDLE)

	if self.Turret_ControllerStatus == 0 or (not self.VJ_IsBeingControlled and not self.Alerted) then
		if not self.Turret_StandDown then
			self.Turret_StandDown = true
			self.HasPoseParameterLooking = false
			self:PlayAnim("retract", true, 1)
			self:EnterIdleState()

			VJ.EmitSound(self, "npc/hturret/tu_spindown.wav", 70, 100)
		end
	end

	if self.Turret_StandDown and self:GetPoseParameter("aim_yaw") == 0 then
		self.Turret_Sprite:Fire("HideSprite")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdatePoseParamTracking(resetPoses)
	if self.Turret_IsFiring then
		return
	end

	if self:GetNPCState() == NPC_STATE_ALERT then
		return
	end

	return self.BaseClass.UpdatePoseParamTracking(self, resetPoses)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	if self.Turret_IsFiring then
		self.Turret_HasLOS = false
		return

	end

	if not self.HasPoseParameterLooking or self:GetNPCState() != NPC_STATE_COMBAT then
		self.Turret_HasLOS = false
		return
	end

	local currentYaw = self:GetPoseParameter("aim_yaw")
	local currentPitch = self:GetPoseParameter("aim_pitch")
	local targetYaw = math.ApproachAngle(currentYaw, yaw, self.PoseParameterLooking_TurningSpeed)
	local targetPitch = math.ApproachAngle(currentPitch, pitch, self.PoseParameterLooking_TurningSpeed)

	if math.abs(math.AngleDifference(currentYaw,targetYaw)) >= 10 or math.abs(math.AngleDifference(currentPitch,targetPitch)) >= 10
	then
		self.Turret_HasLOS = false
	else
		self.Turret_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled then
		return
	end

	self:Turret_Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Turret_Activate()
	if not IsValid(self) then
		return
	end

	self:SetTurretStatus(TURRET_STATUS_DEPLOYING)

	self.HasPoseParameterLooking = false
	self.Turret_HasLOS = false
	self.Turret_StandDown = false

	self:PlayAnim("deploy", true, false)

	VJ.EmitSound(self,"npc/hturret/tu_deploy.wav", 70, 100)

	self.TurretSD_Alarm:PlayEx(1, 100)

	timer.Simple(0.8, function()
		if IsValid(self) then
			VJ.STOPSOUND(self.TurretSD_Alarm)
		end
	end)

	timer.Simple(0.6, function()
		if not IsValid(self) then
			return
		end

		if self.Turret_Status ==
			TURRET_STATUS_DEPLOYING
		then

			if IsValid(self:GetEnemy()) then
				self:SetTurretStatus(TURRET_STATUS_TARGETING)

			else
				self:SetTurretStatus(TURRET_STATUS_SEEKING)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "PreInit" then
		if self.Turret_StandDown then
			return true
		end

		if not self.Turret_HasLOS then
			return true
		end

		if self.Turret_IsFiring then
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local bulletSpread = Vector(0.08716, 0.08716, 0.08716) * 1.25
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
		self:PlayAnim("vjseq_fire", false)
		
		-- Bullet
		local startPos = self:GetAttachment(self:LookupAttachment("muzzle")).Pos
		local bullet = {}
		bullet.Num = 1
		bullet.Src = startPos
		bullet.Dir = (self:GetAimPosition(enemy, startPos) - startPos):GetNormal()
		bullet.Spread = bulletSpread
		bullet.Tracer = 1
		bullet.TracerName = "Tracer"
		bullet.Force = 5
		bullet.Damage = 2
		bullet.AmmoType = "SMG"
		self:FireBullets(bullet)

		ParticleEffectAttach("apc001_muzzleflash2_cets",PATTACH_POINT_FOLLOW,self,3)

		VJ.EmitSound(self, sdFiring, 90, math.random(100, 110))

		-- Effects & Light
		local fireLight = ents.Create("light_dynamic")
		fireLight:SetKeyValue("brightness", "1")
		fireLight:SetKeyValue("distance", "60")
		fireLight:SetPos(startPos)
		fireLight:SetLocalAngles(self:GetAngles())
		fireLight:Fire("Color", "255 128 100")
		fireLight:SetParent(self)
		fireLight:Spawn()
		fireLight:Activate()
		fireLight:Fire("TurnOn", "", 0)
		fireLight:Fire("Kill", "", 0.07)
		self:DeleteOnRemove(fireLight)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local downbulletSpread = Vector(2, 2, 2)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Turret_DownLookRandom()
	if not IsValid(self) then return end

	if self.Turret_DownLookNextT <= CurTime() then
		self.Turret_DownLookYaw = math.Rand(-60, 60)
		self.Turret_DownLookPitch = math.Rand(-15, 15)
		self.Turret_DownLookNextT = CurTime() + math.Rand(0.04, 0.08)
	end

	local yaw = self:GetPoseParameter("aim_yaw")
	local pitch = self:GetPoseParameter("aim_pitch")

	yaw = math.Approach(yaw, self.Turret_DownLookYaw, 30)
	pitch = math.Approach(pitch, self.Turret_DownLookPitch, 24)

	self:SetPoseParameter("aim_yaw", yaw)
	self:SetPoseParameter("aim_pitch", pitch)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Turret_PhysDown()
	if not IsValid(self) then
		return
	end

	self.HasRangeAttack = false
	self.Turret_IsFiring = false
	self.HasPoseParameterLooking = false
	self.Turret_HasLOS = false
	self:SetTurretStatus(TURRET_STATUS_SEEKING)
	self.Turret_DownLookNextT = CurTime()
	self.Turret_DownLookYaw = self:GetPoseParameter("aim_yaw")
	self.Turret_DownLookPitch = self:GetPoseParameter("aim_pitch")
	local ejectID = self:LookupAttachment("eject")

	if not ejectID or ejectID <= 0 then
		return
	end

	local eject = self:GetAttachment(ejectID)

	if not eject then
		return
	end

	local bullet = {}
	bullet.Num = 1
	bullet.Src = eject.Pos
	bullet.Dir = (self:GetPos() - eject.Pos):GetNormalized()
	bullet.Spread = downbulletSpread
	bullet.Tracer = 1
	bullet.TracerName = "Tracer"
	bullet.Force = 5
	bullet.Damage = 2
	bullet.AmmoType = "SMG1"

	for i = 1, 20 do
		timer.Simple(i * 0.1, function()
			if not IsValid(self) then
				return
			end

			self:FireBullets(bullet)
			self:PlayAnim("fire", true, false)
			VJ.EmitSound(self, sdFiring, 70, 100)

			ParticleEffectAttach("apc001_muzzleflash2_cets",PATTACH_POINT_FOLLOW,self,3) 

			local fireLight = ents.Create("light_dynamic")
			fireLight:SetKeyValue("brightness", "1")
			fireLight:SetKeyValue("distance", "60")
			fireLight:SetPos(eject.Pos)
			fireLight:SetLocalAngles(self:GetAngles())
			fireLight:Fire("Color", "255 128 100")
			fireLight:SetParent(self)
			fireLight:Spawn()
			fireLight:Activate()
			fireLight:Fire("TurnOn", "", 0)
			fireLight:Fire("Kill", "", 0.07)
			self:DeleteOnRemove(fireLight)
		end)
	end

	timer.Simple(2, function()
		if not IsValid(self) then
			return
		end

		self.Turret_Down = 1
		self:SetTurretStatus(TURRET_STATUS_UNKNOWN)
		self:SetHealth(1)
		self:TakeDamage(2)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Activate / Deactivate")

	self.Turret_ControllerStatus = 0
	self.HasPoseParameterLooking = false
	self.NextAlertSoundT = CurTime() + 1

	function controlEnt:OnKeyPressed(key)
		local npc = self.VJCE_NPC

		if not IsValid(npc) then
			return
		end

		if key == KEY_SPACE then
			if npc.Turret_ControllerStatus == 0 then
				npc.Turret_ControllerStatus = 1
				npc.HasPoseParameterLooking = true
				npc:PlaySoundSystem("Alert")
				npc:Turret_Activate()
			else
				npc.Turret_ControllerStatus = 0
				npc.HasPoseParameterLooking = false
				npc:SetTurretStatus(TURRET_STATUS_IDLE)
			end
		end
	end

	function controlEnt:OnStopControlling(keyPressed)
		local npc = self.VJCE_NPC
		if IsValid(npc) then
			npc.HasPoseParameterLooking = true
			npc.Turret_ControllerStatus = 0
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(plyUse)
	plyUse:PickupObject(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.TurretSD_Turning)
	VJ.STOPSOUND(self.TurretSD_Alarm)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function CleanupGib(ent)
	if not IsValid(ent) then return end

	local lifetime = math.Rand(10, 30)

	timer.Simple(lifetime - 1, function()
		if IsValid(ent) then
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetRenderFX(kRenderFxFadeFast) -- or kRenderFxFadeSlow
		end
	end)

	timer.Simple(lifetime, function()
		if IsValid(ent) then
			ent:Remove()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	if not IsValid(corpse) then return end

	corpse:SetSkin(3)

	local myPos = corpse:WorldSpaceCenter()
	local myUp = corpse:GetUp()

	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpse, 4)

	timer.Simple(5, function()
		if not IsValid(corpse) then return end
		local explosionPos = corpse:WorldSpaceCenter() + corpse:GetUp() * 8

		ParticleEffect("explosion_turret_break", explosionPos, Angle(0, 0, 0), nil)
		util.BlastDamage(corpse, corpse, explosionPos, 80, 12)

		VJ.EmitSound(corpse, "npc/turret_floor/detonate.wav", 90, math.random(95, 105))

		for i = 1, 6 do
			local gib = ents.Create("prop_physics")

			if IsValid(gib) then
				gib:SetModel("models/gibs/metal_gib" .. math.random(1, 5) .. ".mdl")
				gib:SetPos(explosionPos)
				gib:SetAngles(AngleRand())
				gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				gib:Spawn()
				gib:Activate()

				gib:Ignite(math.random(4, 16))

				CleanupGib(gib)

				local phys = gib:GetPhysicsObject()

				if IsValid(phys) then
					phys:Wake()
					local dir = VectorRand():GetNormalized()

					dir.z = math.abs(dir.z) + 0.5
					dir:Normalize()

					local force = math.random(80, 140)

					phys:SetVelocity(dir * force)
					phys:AddAngleVelocity(VectorRand() * 2000)
				end
			end
		end

		corpse:Remove()
	end)
end