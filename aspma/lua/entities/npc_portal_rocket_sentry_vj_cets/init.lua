AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/props_bts/rocket_sentry.mdl"
ENT.StartHealth = 2000000000
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 2000
ENT.SightAngle = 360
ENT.VJ_NPC_Class = {"CLASS_APERTURE"}
ENT.EntitiesToNoCollide = {"npc_engi_vj_cets"}
ENT.MovementType = VJ_MOVETYPE_GROUND
ENT.CanTurnWhileStationary = true
ENT.HasDeathCorpse = false
ENT.ConstantlyFaceEnemy = true
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.CanTurnWhileMoving = true
ENT.TurningSpeed = 0

ENT.ControllerParams = {
    FirstP_Bone = "barrel",
    FirstP_Offset = Vector(0, 6, 6),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AllowIgnition = true -- Can it be set on fire?
ENT.Immune_Bullet = true  -- Immune to bullet damages
ENT.Immune_Melee = true  -- Immune to melee damages (Ex: Slashes, stabs, punches, claws, crowbar, blunt attacks)
ENT.Immune_Explosive = true  -- Immune to explosive damages (Ex: Grenades, rockets, bombs, missiles)
ENT.Immune_Dissolve = true  -- Immune to dissolving damage (Ex: Combine ball)
ENT.Immune_Toxic = true  -- Immune to toxic effect damages (Ex: Acid, poison, radiation, gas)
ENT.Immune_Fire = true  -- Immune to fire / flame damages
ENT.Immune_Electricity = true -- Immune to electrical damages (Ex: Shocks, lasers, gravity gun)
ENT.Immune_Sonic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.CanChatMessage = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = false
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 1
ENT.RangeAttackAngleRadius = 360
ENT.TimeUntilRangeAttackProjectileRelease = 2
ENT.NextRangeAttackTime = 6
ENT.RangeAttackProjectiles = "obj_vj_rocket_sentry"
ENT.NextAnyAttackTime_Range = 6

ENT.CanReceiveOrders = false
ENT.VJ_ID_Healable = false
ENT.EnemyTimeout = 5

ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav"}
local sdKillMe = "npc/turret_floor/die.wav"

local sdFiring = {"npc/turret_floor/shoot1.wav", "npc/turret_floor/shoot2.wav", "npc/turret_floor/shoot3.wav"} 
local sdPicked = {"npc/turret_floor/turret_pickup_1.wav", "npc/turret_floor/turret_pickup_2.wav", "npc/turret_floor/turret_pickup_3.wav", "npc/turret_floor/turret_pickup_4.wav", "npc/turret_floor/turret_pickup_5.wav", "npc/turret_floor/turret_pickup_6.wav", "npc/turret_floor/turret_pickup_7.wav", "npc/turret_floor/turret_pickup_8.wav", "npc/turret_floor/turret_pickup_9.wav", "npc/turret_floor/turret_pickup_10.wav"} 

local TURRET_STATUS_UNKNOWN = -1 -- Usually for transitioning from deploying to another status
local TURRET_STATUS_IDLE = 0 -- Was last detected as idle
local TURRET_STATUS_DEPLOYING = 1 -- Was last detected attempting to deploy the gun
local TURRET_STATUS_SEEKING = 2 -- Was last detected seeking / scanning a target
local TURRET_STATUS_TARGETING = 3 -- Was last detected targeting an active enemy
ENT.Turret_HasLOS = false -- Has line of sight
ENT.Turret_Status = TURRET_STATUS_UNKNOWN
ENT.Turret_StandDown = true
ENT.Turret_CurrentParameter = 0
ENT.Turret_ScanDirSide = 0
ENT.Turret_ScanDirUp = 0
ENT.Turret_NextScanBeepT = 0
ENT.Turret_ControllerStatus = 0 -- Current status of the controller | 0 = Idle | 1 = Alerted
ENT.Turret_IdleAnim = ACT_IDLE -- Will be replaced on initialize
ENT.Turret_IdleAngryAnim = ACT_IDLE -- Will be replaced on initialize
ENT.Turret_Down = 1
ENT.IsGoingDown = 0
ENT.Turret_Picked = 0

ENT.MainSoundPitch = 100

-- Pose Parameters:
	-- aim_yaw -60 / 60
	-- aim_pitch -15 / 15
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 63), Vector(-13, -13, 0))

	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "sprites/glow1.vmt")
	spr:SetKeyValue("scale", "0.4")
	spr:SetKeyValue("rendermode", "9") -- kRenderWorldGlow
	spr:SetKeyValue("renderfx", "14") -- kRenderFxNoDissipation
	spr:SetKeyValue("rendercolor", "255 0 0")
	spr:SetKeyValue("renderamt", "200")
	spr:SetParent(self)
	spr:Fire("SetParentAttachment", "light")
	spr:Spawn()
	spr:Activate()
	spr:Fire("ShowSprite")
	self:DeleteOnRemove(spr)
	self.Turret_Sprite = spr
	
	self.Turret_IdleAnim = self:GetSequenceActivity(self:LookupSequence("idle"))
	self.Turret_IdleAngryAnim = self:GetSequenceActivity(self:LookupSequence("idlealert"))
	self.TurretSD_Turning = CreateSound(self, "npc/turret_wall/turret_loop1.wav")
	self.TurretSD_Turning:SetSoundLevel(60)
	self.TurretSD_Alarm = CreateSound(self, "npc/turret_floor/alarm.wav")
	self.TurretSD_Alarm:SetSoundLevel(75)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Activate / Deactivate")
	
	self.Turret_ControllerStatus = 0
	self.HasPoseParameterLooking = false -- Initially, we are going to start as idle, we do NOT want the turret turning!
	self.NextAlertSoundT = CurTime() + 1 -- So it doesn't play the alert sound as soon as it enters the NPC!
	
	function controlEnt:OnKeyPressed(key)
		local npc = self.VJCE_NPC
		if key == KEY_SPACE then
			if npc.Turret_ControllerStatus == 0 then
				npc.Turret_ControllerStatus = 1
				npc.HasPoseParameterLooking = true
				npc:PlaySoundSystem("Alert")
				npc:Turret_Activate()
			else
				npc.Turret_ControllerStatus = 0
				npc.HasPoseParameterLooking = false
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
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if !self.Turret_StandDown then
			return self.Turret_IdleAngryAnim
		else
			return self.Turret_IdleAnim
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self.MovementType = VJ_MOVETYPE_PHYSICS
	-- Turning sound
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Turret_CurrentParameter then
		self.TurretSD_Turning:PlayEx(1, 100)
	else
		VJ.STOPSOUND(self.TurretSD_Turning)
	end
	self.Turret_CurrentParameter = parameter

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	local phys = self:GetPhysicsObject()
	local angles = self:GetAngles()
	local fire_dir = ( self:GetPos() ):GetNormalized()
 	local localang = self:WorldToLocalAngles(fire_dir:Angle() + Angle(0,-90,0))

	local eneValid = IsValid(self:GetEnemy())
	if self.Turret_Status != TURRET_STATUS_DEPLOYING then
		-- Alerted behavior
		if ((self.Turret_ControllerStatus == 1) or (!self.VJ_IsBeingControlled && (eneValid or (self.Alerted && !self.EnemyData.Reset)))) then
			self.Turret_StandDown = false
			
			local doScan = false
			
			-- Make it scan around if the enemy is behind, which is unreachable for it!
			if eneValid && !self.Turret_HasLOS && (math.abs(self.EnemyData.VisibleTime - CurTime()) >= 1) then
				doScan = true
				self.HasPoseParameterLooking = true
			else
				-- If it just started targeting, then play the gun "activate" sound
				if self.Turret_Status != TURRET_STATUS_TARGETING then
					VJ.EmitSound(self, "npc/turret_floor/active.wav", 70, 100)
					self.NextDoAnyAttackT = CurTime() + 0.5
				end
				self.Turret_Status = TURRET_STATUS_TARGETING
				self.HasPoseParameterLooking = true
			end
			
			-- Look around randomly when the enemy is not found or hidden
			if !eneValid or doScan == true then
				self.Turret_Status = TURRET_STATUS_SEEKING
				-- Playing a beeping noise
				if self.Turret_NextScanBeepT < CurTime() then
					VJ.EmitSound(self, "npc/turret_floor/ping.wav", 75, 100)
					self.Turret_NextScanBeepT = CurTime() + 1
				end
				-- LEFT TO RIGHT
				-- Change the rotation direction when the max number is reached for a direction
				local yaw = self:GetPoseParameter("aim_yaw")
				if yaw >= 0 then
					self.Turret_ScanDirSide = 1
				elseif yaw <= 0 then
					self.Turret_ScanDirSide = 0
				end
				self:SetPoseParameter("aim_yaw", yaw + (self.Turret_ScanDirSide == 1 and -5 or 5))
				-- UP AND DOWN
				-- Change the rotation direction when the max number is reached for a direction
				local pitch = self:GetPoseParameter("aim_pitch")
				if pitch >= 15 then
					self.Turret_ScanDirUp = 1
				elseif pitch <= -15 then
					self.Turret_ScanDirUp = 0
				end
				self:SetPoseParameter("aim_pitch", pitch + (self.Turret_ScanDirUp == 1 and -1 or 1))
			end
		else -- Idle behavior
			self.Turret_Status = TURRET_STATUS_IDLE
			-- Play the retracting sequence and sound
			if ((self.Turret_ControllerStatus == 0) or (!self.VJ_IsBeingControlled && !self.Alerted)) && !self.Turret_StandDown then
				self.Turret_StandDown = true
				self.HasPoseParameterLooking = true
				self:PlayAnim("retract", true, 1)
				VJ.EmitSound(self, "npc/turret_floor/retract.wav", 70, 100)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PropSpawn()
	self.turret = ents.Create("prop_physics")
	self.turret:SetModel("models/combine_turrets/floor_turret.mdl")
	self.turret:SetPos(self:GetPos())
	self.turret:SetAngles(self:GetAngles())
	self.turret:Spawn()
	self.turret:Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdatePoseParamTracking(resetPoses)
	-- Alerted with no active enemy, so don't reset its pose parameters (Ex: Transitioning from Alert to Idle)
	if self:GetNPCState() == NPC_STATE_ALERT then return end
	return self.BaseClass.UpdatePoseParamTracking(self, resetPoses)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	-- Otherwise "self.Turret_HasLOS" will true all the time when it's deploying, retracting, etc. (Basically whenever its not supposed to aim)
	if !self.HasPoseParameterLooking or self:GetNPCState() != NPC_STATE_COMBAT then
		self.Turret_HasLOS = false
		return
	end
	
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10) then
		self.Turret_HasLOS = false
	else
		self.Turret_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	self:Turret_Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Turret_Activate()
	if IsValid(self) then
		self.HasPoseParameterLooking = false -- Make it not aim at the enemy right away!
		self.Turret_Status = TURRET_STATUS_DEPLOYING
		timer.Simple(0.6, function()
			if IsValid(self) then
				self.Turret_Status = TURRET_STATUS_UNKNOWN
			end
		end)
		self:PlayAnim("deploy", true, false)
		VJ.EmitSound(self, "npc/turret_floor/deploy.wav", 70, 100)
		self.TurretSD_Alarm:PlayEx(1, 100)
		timer.Simple(0.8, function() VJ.STOPSOUND(self.TurretSD_Alarm) end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(plyUse)
	plyUse:PickupObject(self)

	if IsValid(self) && self.Turret_Picked == 0 && self.IsGoingDown == 0 then
		VJ.EmitSound(self, sdPicked, 70, 100)
		self.Turret_Picked = 1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("barrel")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "PreInit" then
		-- Only fire if we have LOS and not in stand down mode!
		return self.Turret_StandDown or !self.Turret_HasLOS
	end

	if IsValid(self) then
		VJ.EmitSound(self, "weapons/rocket/rocket_locked_beep1.wav", 70, 100)
		timer.Simple(0.1, function() if IsValid(self) then
				self:SetSkin(1)
			end
			timer.Simple(0.6, function() if IsValid(self) then
					self:SetSkin(2)
				end
				timer.Simple(2.1, function() if IsValid(self) then
						self:SetSkin(0)
					end
				end)
			end)
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
local sdGibCollide = {"physics/metal/metal_box_impact_hard1.wav", "physics/metal/metal_box_impact_hard2.wav", "physics/metal/metal_box_impact_hard3.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	ParticleEffect("explosion_turret_break", self:WorldSpaceCenter() + self:GetUp()*12, defAng, NULL)
	util.BlastDamage(self, self, self:WorldSpaceCenter() + self:GetUp()*12, 120, 15)
	self:CreateGibEntity("prop_physics", "models/combine_turrets/floor_turret_gib1.mdl",  {BloodType="", Pos=self:LocalToWorld(Vector(0, 0, 40)),  CollisionSound=sdGibCollide})
	self:CreateGibEntity("prop_physics", "models/combine_turrets/floor_turret_gib2.mdl",  {BloodType="", Pos=self:LocalToWorld(Vector(0, 0, 20)),  CollisionSound=sdGibCollide})
	self:CreateGibEntity("prop_physics", "models/combine_turrets/floor_turret_gib3.mdl",  {BloodType="", Pos=self:LocalToWorld(Vector(0, 0, 30)),  CollisionSound=sdGibCollide})
	self:CreateGibEntity("prop_physics", "models/combine_turrets/floor_turret_gib4.mdl",  {BloodType="", Pos=self:LocalToWorld(Vector(0, 0, 35)),  CollisionSound=sdGibCollide})
	self:CreateGibEntity("prop_physics", "models/combine_turrets/floor_turret_gib5.mdl",  {BloodType="", Pos=self:LocalToWorld(Vector(0, 0, 37)),  CollisionSound=sdGibCollide})
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	if self.Turret_Down == 0 then
		ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpse, 2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.TurretSD_Turning)
	VJ.STOPSOUND(self.TurretSD_Alarm)
end