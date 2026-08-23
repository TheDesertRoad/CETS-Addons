AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "AR3 Emplacement"
ENT.Category = "Half-Life 2"
ENT.SubCategory = "Emplacements"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Author 			= "VALVe"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

ENT.Model = "models/props_combine/bunker_gun01.mdl"
ENT.InvModel = "models/props_combine/bunker_gun01_nogun.mdl"

ENT.ShootDelay = 0.055
ENT.Ammo = -1
ENT.Automatic = true
ENT.DoNetworking = true
ENT.HideGunModel = false

ENT.Damage = 15
ENT.NPCDamage = 12

ENT.NPCFire = true

ENT.NPC_NextPrimaryFire = 0.1
ENT.NPC_TimeUntilFire = 0
ENT.NPC_TimeUntilFireExtraTimers = {0.055, 0.4}

ENT.Spread = Vector(1, 1, 0) * 0.02
ENT.NPCSpread = Vector(1, 1, 0) * 0.08

ENT.EnableZoom = false
ENT.ZoomFOV = 20
ENT.ZoomTransition = 0.5

ENT.EnableScope = false
ENT.ScopeMaterial = "effects/cets/hmg_scope1_s"
ENT.ZoomInSound = "weapons/sniper/sniper_zoomin.wav"
ENT.ZoomOutSound = "weapons/sniper/sniper_zoomout.wav"
ENT.ZoomSoundLevel = 100
ENT.ZoomSoundPitch = 100

ENT.PitchOffset = 10

ENT.UseDistance = 64
ENT.YawLimit = 60
ENT.PitchMin = -35
ENT.PitchMax = 60

ENT.ActivateSequence = 1
ENT.RetractSequence = 3
ENT.ShootSequence = 2
ENT.IdleSequence = 0

ENT.ShootMode = "hitscan"

ENT.ProjectileClass = "obj_vj_rocket_apc"
ENT.ProjectileSpeed = 2500
ENT.ProjectileDamage = 50
ENT.ProjectileRadius = 8
ENT.ProjectileOwner = true

ENT.EnableNPC = true
ENT.NPCAimDistance = 65535
ENT.NPCUseEnemy = true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EmplacementVehicleTable = EmplacementVehicleTable or {}
EmplacementMannedTable = EmplacementMannedTable or {}
EmplacementRegisteredClasses = EmplacementRegisteredClasses or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoInit()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRemove()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnStartShooting()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnStopShooting()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnStartAttack()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnStopAttack()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnActivateGun()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeactivateGun()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoShootThink()
	return false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self.User = NULL
	self.UserPrevWeapon = NULL

	self.Vehicle = NULL

	self.Active = false
	self.DriveMode = false

	self.NPCTarget = NULL
	self.NPCNextSearch = 0
	self.NPCNextThink = 0
	self.NPCFailedSearches = 0

	self.NPCWasManning = false

	self.ShootTimer = 0

	self.NPCFireTimer = 0
	self.NPCFirstShot = true

	self.UseTimer = 0
	self.SequenceTimer = math.huge

	self.IsShooting = false
	self.IsKeyDown = false

	self.InputAttack = false
	self.InputAttack2 = false
	self.PreviousInputAttack2 = false

	self.OriginalAimYaw = 0
	self.OriginalAimPitch = 0

	self.LastAimYaw = 0
	self.LastAimPitch = 0

	self.Zoomed = false
	self.Retracted = true

	self.VJOriginalData = nil

	self:DoInit()

	if self.HideGunModel then
		self:SetModel(self.InvModel)
	else
		self:SetModel(self.Model)
	end

	self:PhysicsInitBox(Vector(-8, -8, 0), Vector(8, 8, 8))

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	self:SetUseType(USE_TOGGLE)

	self:SetNWBool("Active", false)
	self:SetNWBool("DriveMode", false)
	self:SetNWEntity("User", NULL)
	self:SetNWBool("Zoomed", false)

	self:SetNWFloat("AimYaw", 0)
	self:SetNWFloat("AimPitch", 0)

	self:ResetSequence(self.RetractSequence)
	self:SetCycle(1)

	self:SetPoseParameter("aim_yaw", 0)
	self:SetPoseParameter("aim_pitch", self.PitchOffset)

	EmplacementRegisteredClasses[self:GetClass()] = true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MarkManned(state)
	local user = self.User

	if not IsValid(user) then
		return
	end

	local index = user:EntIndex()

	if state then
		EmplacementMannedTable[index] = self
	else
		if EmplacementMannedTable[index] == self then
			EmplacementMannedTable[index] = nil
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsManned(user)
	if not IsValid(user) then
		return false
	end

	return IsValid(EmplacementMannedTable[user:EntIndex()])
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetEmplacementStandPos()
	return self:GetPos() + self:GetForward() * -40 + self:GetUp() * -35
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNPCAcquireDistance()
	local failed = self.NPCFailedSearches or 0

	return math.Clamp(self.NPCAimDistance + failed * 100, 0, 420)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsVJBaseNPC(npc)
	if not IsValid(npc) then
		return false
	end

	if not npc:IsNPC() then
		return false
	end

	return npc.IsVJBaseSNPC == true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNPCEnemy(npc)
	if not IsValid(npc) then
		return NULL
	end

	if self:IsVJBaseNPC(npc) then
		if npc.EnemyData && IsValid(npc.EnemyData.Target) then
			return npc.EnemyData.Target
		end

		if npc.GetEnemy then
			local enemy = npc:GetEnemy()

			if IsValid(enemy) then
				return enemy
			end
		end

		if IsValid(npc:GetEnemy()) then
			return npc:GetEnemy()
		end

		return NULL
	end

	if npc.GetEnemy then
		return npc:GetEnemy()
	end

	return NULL
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNPCFireDelay()
	if self.NPC_TimeUntilFireExtraTimers
	and istable(self.NPC_TimeUntilFireExtraTimers)
	and #self.NPC_TimeUntilFireExtraTimers > 0 then

		return self.NPC_NextPrimaryFire
			+ self.NPC_TimeUntilFireExtraTimers[
				math.random(#self.NPC_TimeUntilFireExtraTimers)
			]
	end

	return self.NPC_NextPrimaryFire
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupVJBaseNpc(npc)
	if not self:IsVJBaseNPC(npc) then
		return
	end

	if not npc.CETS_EmplacementOriginalData then
		npc.CETS_EmplacementOriginalData = {DisableWandering = npc.DisableWandering, DisableChasingEnemy = npc.DisableChasingEnemy, PauseAttacks = npc.PauseAttacks}
	end

	npc.CETS_Emplacement = self
	npc.DisableWandering = true
	npc.DisableChasingEnemy = true
	npc.PauseAttacks = true

	npc.CETS_EmplacementLocked = true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RestoreVJBaseNpc(npc)
	if not IsValid(npc) then
		return
	end

	if not self:IsVJBaseNPC(npc) then
		return
	end

	if npc.CETS_Emplacement == self then
		npc.CETS_Emplacement = nil
	end

	npc.CETS_EmplacementLocked = nil

	local data = npc.CETS_EmplacementOriginalData

	if data then
		npc.DisableWandering = data.DisableWandering
		npc.DisableChasingEnemy = data.DisableChasingEnemy
		npc.PauseAttacks = data.PauseAttacks

		npc.CETS_EmplacementOriginalData = nil
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsNPCManner(npc)
	if not IsValid(npc) then
		return false
	end

	if not npc:IsNPC() then
		return false
	end

	if npc.OnEmplacementBlacklist then
		return false
	end

	if npc:Health() <= 0 then
		return false
	end

	if IsValid(npc.CETS_Emplacement) then
		return false
	end

	local manGun = npc:LookupSequence("Man_Gun")
	local manGunAimAll = npc:LookupSequence("Man_Gun_Aim_All")

	if not manGun or manGun < 0 then
		return false
	end

	if not manGunAimAll or manGunAimAll < 0 then
		return false
	end

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanNPCTakeEmplacement(npc)
	if not self.EnableNPC then
		return false
	end

	if not IsValid(npc) then
		return false
	end

	if not self:IsNPCManner(npc) then
		return false
	end

	if IsValid(self.User) then
		return false
	end

	local standPos = self:GetEmplacementStandPos()
	local distance = npc:GetPos():Distance(standPos)

	if distance > self:GetNPCAcquireDistance() then
		return false
	end

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindNPCToMan()
	if not self.EnableNPC then
		return
	end

	if self.Active then
		return
	end

	if IsValid(self.User) then
		return
	end

	if self.NPCNextSearch > CurTime() then
		return
	end

	self.NPCNextSearch = CurTime() + 5 + ((self.NPCFailedSearches or 0) * 0.25)

	local standPos = self:GetEmplacementStandPos()
	local distance = self:GetNPCAcquireDistance()
	local candidates = ents.FindInSphere(standPos, distance)

	table.sort(candidates, function(a, b) return a:GetPos():DistToSqr(standPos) < b:GetPos():DistToSqr(standPos) end)

	for _, npc in ipairs(candidates) do
		if self:CanNPCTakeEmplacement(npc) then
			self.NPCTarget = npc
			self.NPCFailedSearches = 0

			if self:IsVJBaseNPC(npc) then
				if not npc.CETS_EmplacementOriginalData then
					npc.CETS_EmplacementOriginalData = {DisableWandering = npc.DisableWandering, DisableChasingEnemy = npc.DisableChasingEnemy, PauseAttacks = npc.PauseAttacks}
				end

				npc.DisableWandering = true
				npc.DisableChasingEnemy = true
				npc.PauseAttacks = true
			end

			npc:SetLastPosition(standPos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
			npc.WasRunningToEmplacement = true

			return
		end
	end

	self.NPCFailedSearches = (self.NPCFailedSearches or 0) + 1
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EnterEmplacement(npc)
	if not IsValid(self) then
		return false
	end

	if not IsValid(npc) then
		return false
	end

	if not self:CanNPCTakeEmplacement(npc) then
		return false
	end

	local standPos = self:GetEmplacementStandPos()

	npc:ClearSchedule()
	npc:StopMoving()

	if self:IsVJBaseNPC(npc) then
		self:SetupVJBaseNpc(npc)
	end

	self.User = npc
	self.NPCTarget = NULL

	self.NPCWasManning = true

	npc.CETS_Emplacement = self

	self:MarkManned(true)

	self.OriginalAimYaw = tonumber(self:GetPoseParameter("aim_yaw")) or 0
	self.OriginalAimPitch = tonumber(self:GetPoseParameter("aim_pitch")) or 0
	self.LastAimYaw = math.NormalizeAngle(self.OriginalAimYaw)
	self.LastAimPitch = math.Clamp(self.OriginalAimPitch - self.PitchOffset, self.PitchMin, self.PitchMax)

	self.InputAttack = false
	self.InputAttack2 = false
	self.PreviousInputAttack2 = false

	self.IsShooting = false
	self.IsKeyDown = false

	self.ShootTimer = 0
	self.Zoomed = false

	self.Active = true
	self.Retracted = false

	self:SetNWBool("Active", true)
	self:SetNWBool("DriveMode", false)
	self:SetNWEntity("User", npc)
	self:SetNWBool("Zoomed", false)

	self:SetNWFloat("AimYaw", self.LastAimYaw)
	self:SetNWFloat("AimPitch", self.LastAimPitch)

	self:ResetSequence(self.ActivateSequence)
	self:SetCycle(0)

	self.SequenceTimer = CurTime() + self:SequenceDuration()

	self:EmitSound("weapons/shotgun/shotgun_cock.wav")

	npc:SetPos(standPos)
	npc:SetAngles(Angle(0, self:GetAngles().y, 0))
	npc:StopMoving()
	npc:ClearSchedule()
	npc:SetNPCState(NPC_STATE_SCRIPT)

	local weapon = npc:GetActiveWeapon()

	if IsValid(weapon) then
		weapon:SetNoDraw(true)
	end

	local seq = npc:LookupSequence("Man_Gun")

	if seq && seq >= 0 then
		npc:SetSequence(seq)
		npc:SetCycle(0)
	end

	self:OnActivateGun()

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExitNPCEmplacement()
	local npc = self.User

	if not IsValid(npc) then
		self.NPCWasManning = false
		self.NPCTarget = NULL
		return
	end

	if self:IsVJBaseNPC(npc) then
		self:RestoreVJBaseNpc(npc)
	end

	npc.CETS_Emplacement = nil
	npc.WasRunningToEmplacement = nil

	local weapon = npc:GetActiveWeapon()

	if IsValid(weapon) then
		weapon:SetNoDraw(false)
	end

	if npc.ExitScriptedSequence then
		npc:ExitScriptedSequence()
	end

	npc:SetNPCState(NPC_STATE_ALERT)

	if self:IsVJBaseNPC(npc) then
		npc:ClearSchedule()
		npc:StopMoving()

		timer.Simple(0, function()
			if not IsValid(npc) then
				return
			end

			if IsValid(npc.CETS_Emplacement) then
				return
			end

			npc.CETS_EmplacementLocked = nil

		end)
	end

	self.NPCWasManning = false
	self.NPCTarget = NULL
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNPCAimPoint()
	local npc = self.User

	if not IsValid(npc) then
		return nil
	end

	if not npc:IsNPC() then
		return nil
	end

	local enemy = self:GetNPCEnemy(npc)

	if not IsValid(enemy) then
		return nil
	end

	if enemy:Health() <= 0 then
		return nil
	end

	if self.EntShootPos then
		local pos = self:EntShootPos(enemy)

		if pos then
			return pos
		end
	end

	return enemy:WorldSpaceCenter()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNPCAimDirection()
	local targetPos = self:GetNPCAimPoint()

	if not targetPos then
		return nil
	end

	local attachment = self:GetAttachment(1)

	if not attachment then
		return nil
	end

	local localAngles = self:WorldToLocalAngles((targetPos - attachment.Pos):Angle())
	local yaw = math.NormalizeAngle(localAngles.y)
	local pitch = math.NormalizeAngle(localAngles.p)

	yaw = math.Clamp(yaw, -self.YawLimit, self.YawLimit)
	pitch = math.Clamp(pitch, self.PitchMin, self.PitchMax)

	local constrained = Angle(pitch, yaw, 0)
	local worldAngles = self:LocalToWorldAngles( constrained)

	return worldAngles:Forward(), yaw, pitch
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsNPCEnemyInRange(npc, enemy)
	if not IsValid(npc) then
		return false
	end

	if not IsValid(enemy) then
		return false
	end

	local attachment = self:GetAttachment(1)

	if not attachment then
		return false
	end

	local targetPos = enemy:WorldSpaceCenter()
	local localAngles = self:WorldToLocalAngles((targetPos - attachment.Pos):Angle())
	local yaw = math.NormalizeAngle(localAngles.y)
	local pitch = math.NormalizeAngle(localAngles.p)

	if yaw < -self.YawLimit or yaw > self.YawLimit then
		return false
	end

	if pitch < self.PitchMin or pitch > self.PitchMax then

		return false
	end

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThinkNPC()
	if not self.EnableNPC then
		return
	end

	if IsValid(self.User) && self.User:IsPlayer() then
		return
	end

	if not IsValid(self.User) then
		if IsValid(self.NPCTarget) then
			local npc = self.NPCTarget

			if not IsValid(npc) or not npc:IsNPC() or npc:Health() <= 0 then
				self.NPCTarget = NULL
				return
			end

			if IsValid(npc.CETS_Emplacement) then
				self.NPCTarget = NULL
				return
			end

			local standPos = self:GetEmplacementStandPos()
			local distance = npc:GetPos():Distance(standPos)

			if distance <= self.UseDistance then
				self.NPCTarget = NULL
				self:EnterEmplacement(npc)
				return
			end

			npc:SetLastPosition(standPos)

			if not npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) then
				npc:SetSchedule(SCHED_FORCED_GO_RUN)
			end

			return
		end

		self:FindNPCToMan()

		return
	end

	local npc = self.User

	if not IsValid(npc) or not npc:IsNPC() then
		self:DeactivateEmplacement()
		return
	end

	if npc:Health() <= 0 then
		self:DeactivateEmplacement()
		return
	end

	if self:IsVJBaseNPC(npc) then
		npc.CETS_Emplacement = self
		npc.CETS_EmplacementLocked = true

		npc.DisableWandering = true
		npc.DisableChasingEnemy = true
		npc.PauseAttacks = true

		npc:ClearSchedule()
		npc:StopMoving()
	end

	local standPos = self:GetEmplacementStandPos()
	local distance = npc:GetPos():Distance(standPos)

	if distance > self.UseDistance * 2 then
		self:DeactivateEmplacement()
		return
	end

	if distance > 8 then
		npc:SetPos(standPos)
		npc:StopMoving()
	end

	npc:SetAngles(Angle(0, self:GetAngles().y, 0))
	npc:SetNPCState(NPC_STATE_SCRIPT)

	local manGun = npc:LookupSequence("Man_Gun")

	if manGun && manGun >= 0 then
		if npc:GetSequence() ~= manGun then
			npc:SetSequence(manGun)
			npc:SetCycle(0)
		end
	end

	local weapon = npc:GetActiveWeapon()

	if IsValid(weapon) then
		weapon:SetNoDraw(true)
	end

	local enemy = self:GetNPCEnemy(npc)

	if not IsValid(enemy) or enemy:Health() <= 0 then
		if self.IsShooting then
			self.IsShooting = false
			self:OnStopShooting()
		end

		self.NPCFirstShot = true
		self.NPCFireTimer = 0
		return
	end

	if not self:IsNPCEnemyInRange(npc, enemy) then
		if self.IsShooting then
			self.IsShooting = false
			self:OnStopShooting()
		end

		self.NPCFirstShot = true
		self.NPCFireTimer = 0

		npc.OnEmplacementBlacklist = true

		self:DeactivateEmplacement()

		timer.Simple(1, function()
			if not IsValid(npc) then
				return
			end

			npc.OnEmplacementBlacklist = nil
		end)

		return
	end

	local direction, yaw, pitch = self:GetNPCAimDirection()

	if not direction then
		return
	end

	self.LastAimYaw = yaw
	self.LastAimPitch = pitch

	if self.DoNetworking then
		self:SetNWFloat("AimYaw", yaw)
		self:SetNWFloat("AimPitch", pitch)
	end

	self:SetPoseParameter("aim_yaw", yaw)
	self:SetPoseParameter("aim_pitch", pitch + self.PitchOffset)

	local attachment = self:GetAttachment(1)

	if not attachment then
		return
	end

	local targetPos = self:GetNPCAimPoint()

	if not targetPos then
		return
	end

	local trace =
		util.TraceLine({
			start = attachment.Pos,
			endpos = targetPos,
			filter = {self, npc},

			mask = MASK_SHOT
		})

	local canShoot = not trace.Hit or trace.Entity == enemy

	if not canShoot then
		if self.IsShooting then
			self.IsShooting = false
			self:OnStopShooting()
		end

		self.NPCFirstShot = true
		self.NPCFireTimer = 0

		return
	end

	if not self.NPCFire then
		if self.IsShooting then
			self.IsShooting = false
			self:OnStopShooting()
		end

		return
	end

	if self.Ammo >= 0 && self.Ammo <= 0 then
		if self.IsShooting then
			self.IsShooting = false
			self:OnStopShooting()
		end

		return
	end

	local currentTime = CurTime()

	if self.NPCFirstShot then
		if self.NPCFireTimer <= 0 then
			self.NPCFireTimer = currentTime + (self.NPC_TimeUntilFire or 0.1)
			return
		end

		if currentTime < self.NPCFireTimer then
			return
		end

		self.NPCFirstShot = false
	end

	if currentTime < self.NPCFireTimer then
		return
	end

	self:DoShoot(direction)

	if self.Ammo > 0 then
		self.Ammo = self.Ammo - 1
	end

	self.NPCFireTimer = currentTime + self:GetNPCFireDelay()

	self:ResetSequence(self.ShootSequence)
	self:SetCycle(0)

	self.SequenceTimer = currentTime + self:SequenceDuration()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetPlayerScope(ply)
	if not IsValid(ply) then
		return
	end

	if not ply:IsPlayer() then
		return
	end

	if ply:GetNWBool("Scoped", true) then
		ply:SetNWBool("Scoped", false)
	end

	if ply:GetNWBool("Scoped", false) then
		ply:SetNWBool("Scoped", false)
	end

	self.Zoomed = false
	self:SetNWBool("Zoomed", false)

	ply:SetFOV(0, self.ZoomTransition)
	ply:DrawViewModel(true)
	ply:SetCanZoom(true)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ActivateEmplacement()
	if self.Active then
		return
	end

	if not IsValid(self.User) then
		return
	end

	self.OriginalAimYaw = tonumber(self:GetPoseParameter("aim_yaw")) or 0
	self.OriginalAimPitch =tonumber(self:GetPoseParameter("aim_pitch")) or 0
	self.LastAimYaw = math.NormalizeAngle(self.OriginalAimYaw)
	self.LastAimPitch = math.Clamp(self.OriginalAimPitch - self.PitchOffset, self.PitchMin, self.PitchMax)

	self.InputAttack = false
	self.InputAttack2 = false
	self.PreviousInputAttack2 = false

	self.IsShooting = false
	self.IsKeyDown = false

	self.ShootTimer = 0

	local user = self.User

	if user:IsPlayer() then
		self:ResetPlayerScope(user)
	end

	if user:IsPlayer() then
		user.CETS_Emplacement = self
		user:SetNWEntity("CETS_Emplacement", self)

		if not self.DriveMode then
			self.UserPrevWeapon = user:GetActiveWeapon()
		end
	end

	self:MarkManned(true)

	self.Active = true
	self.Retracted = false

	self:SetNWBool("Active", true)
	self:SetNWBool("DriveMode", self.DriveMode)
	self:SetNWEntity("User", self)
	self:SetNWEntity("User", user)
	self:SetNWFloat("AimYaw", self.LastAimYaw)
	self:SetNWFloat("AimPitch", self.LastAimPitch)

	self:ResetSequence(self.ActivateSequence)
	self:SetCycle(0)
	self.SequenceTimer = CurTime() + self:SequenceDuration()

	self:EmitSound("weapons/shotgun/shotgun_cock.wav")

	if user:IsNPC() then
		if self:IsVJBaseNPC(user) then
			self:SetupVJBaseNpc(user)
		end

		user:SetNPCState(NPC_STATE_SCRIPT)

		local seq = user:LookupSequence("Man_Gun")

		if seq && seq >= 0 then
			user:SetSequence(seq)
			user:SetCycle(0)
		end

		local weapon = user:GetActiveWeapon()

		if IsValid(weapon) then
			weapon:SetNoDraw(true)
		end
	end

	self:OnActivateGun()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeactivateEmplacement()
	if not self.Active && not IsValid(self.User) then
		return
	end

	self:ResetZoom()

	if self.IsShooting then
		self.IsShooting = false
		self:OnStopShooting()
	end

	if self.IsKeyDown then
		self.IsKeyDown = false
		self:OnStopAttack()
	end

	self.InputAttack = false
	self.InputAttack2 = false
	self.PreviousInputAttack2 = false

	self.LastAimYaw = math.NormalizeAngle(tonumber(self.LastAimYaw) or 0)
	self.LastAimPitch = math.Clamp(tonumber(self.LastAimPitch) or 0, self.PitchMin,self.PitchMax)

	self:SetNWFloat("AimYaw", self.LastAimYaw)
	self:SetNWFloat("AimPitch", self.LastAimPitch)

	self:MarkManned(false)

	local user = self.User

	if IsValid(user) then
		if user:IsPlayer() then
			user.CETS_Emplacement = nil
			user:SetNWEntity("CETS_Emplacement", NULL)

			if not self.DriveMode && IsValid(self.UserPrevWeapon) then
				user:SelectWeapon(self.UserPrevWeapon:GetClass())
			end

		elseif user:IsNPC() then
			self:ExitNPCEmplacement()
		end
	end

	self.Active = false

	self:SetNWBool("Active", false)
	self:SetNWBool("DriveMode", self.DriveMode)
	self:SetNWEntity("User", NULL)

	self.Retracted = false

	self:ResetSequence(self.RetractSequence)
	self:SetCycle(0)

	self.SequenceTimer = CurTime() + self:SequenceDuration()

	self:SetPoseParameter("aim_yaw", self.LastAimYaw)
	self:SetPoseParameter("aim_pitch", self.LastAimPitch + self.PitchOffset)

	self:EmitSound("weapons/shotgun/shotgun_cock.wav")

	self:OnDeactivateGun()

	self.User = NULL
	self.UserPrevWeapon = NULL
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetDriveMode(state)
	self.DriveMode = state == true

	self:SetNWBool("DriveMode", self.DriveMode)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindVehicleEmplacement(vehicle)
	if not IsValid(vehicle) then
		return nil
	end

	local constraints = constraint.GetAllConstrainedEntities(vehicle)

	if constraints then
		for ent in pairs(constraints) do
			if IsValid(ent) && ent ~= vehicle then
				if EmplacementRegisteredClasses[ent:GetClass()] then
					return ent
				end
			end
		end
	end

	for _, ent in ipairs(ents.FindInSphere(vehicle:GetPos(), 250)) do
		if IsValid(ent) && EmplacementRegisteredClasses[ent:GetClass()] && ent:GetPos():DistToSqr(vehicle:GetPos()) <= (250 * 250) then
			return ent
		end
	end

	return nil
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RegisterVehicle(vehicle)
	if not IsValid(vehicle) then
		return false
	end

	self.Vehicle = vehicle
	self.DriveMode = true

	EmplacementVehicleTable[vehicle:EntIndex()] = self

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UnregisterVehicle()
	if IsValid(self.Vehicle) then
		local index = self.Vehicle:EntIndex()

		if EmplacementVehicleTable[index] == self then
			EmplacementVehicleTable[index] = nil
		end
	end

	self.Vehicle = NULL
	self.DriveMode = false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator)
	if not IsValid(activator) or not activator:IsPlayer() then
		return
	end

	local weapon = activator:GetActiveWeapon()

	if IsValid(weapon) then
		weapon:SetNWBool("Scoped", false)
	end

	if self.UseTimer > CurTime() then
		return
	end

	if activator:EyePos():DistToSqr(self:GetPos()) > self.UseDistance * self.UseDistance then
		return
	end

	if not IsValid(self.User) then
		if self:IsManned(activator) then
			return
		end

		self.User = activator
		self:ActivateEmplacement()

	elseif self.User == activator then

		self:DeactivateEmplacement()
	end

	self.UseTimer = CurTime() + 0.5
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsGunShooting()
	return self.Active && IsValid(self.User) && self.InputAttack == true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAimPoint()
	if not IsValid(self.User) then
		return nil
	end

	if self.User:IsNPC() then
		return self:GetNPCAimPoint()
	end

	local ply = self.User
	local filter = {self, ply}

	if ply:InVehicle() then
		local vehicle = ply:GetVehicle()

		if IsValid(vehicle) then
			table.insert(filter, vehicle)
		end
	end

	local eyePos = ply:EyePos()
	local aimDir = ply:EyeAngles():Forward()

	local trace =
		util.TraceLine({
			start = eyePos,
			endpos = eyePos + aimDir * 65535,
			filter = filter,
			mask = MASK_SHOT
		})

	return trace.HitPos
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetConstrainedAim()
	if not IsValid(self.User) then
		return nil
	end

	if self.User:IsNPC() then
		local direction, yaw, pitch = self:GetNPCAimDirection()

		if not direction then
			return nil
		end

		return {yaw = yaw, pitch = pitch, direction = direction}
	end

	local attachment = self:GetAttachment(1)

	if not attachment then
		return nil
	end

	local worldDirection = self.User:EyeAngles():Forward()
	local localAngles = self:WorldToLocalAngles(worldDirection:Angle())
	local yaw = math.NormalizeAngle(localAngles.y)
	local pitch = math.NormalizeAngle(localAngles.p)

	yaw = math.Clamp(yaw, -self.YawLimit, self.YawLimit)
	pitch = math.Clamp(pitch, self.PitchMin, self.PitchMax)

	local constrained = Angle(pitch, yaw, 0)
	local worldAngles = self:LocalToWorldAngles(constrained)

	return {yaw = yaw, pitch = pitch, direction = worldAngles:Forward()}
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAimDirection()
	local aim = self:GetConstrainedAim()

	if not aim then
		return nil
	end

	return aim.direction
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoShootProjectile(direction)
	local attachment = self:GetAttachment(1)

	if not attachment then
		return nil
	end

	if not direction then
		return nil
	end

	direction = direction:GetNormalized()

	local projectile = ents.Create(self.ProjectileClass)

	if not IsValid(projectile) then
		return nil
	end

	local spawnPos = attachment.Pos+ direction * 8

	projectile:SetPos(spawnPos)
	projectile:SetAngles(direction:Angle())

	if IsValid(self.User) then

		projectile:SetOwner(self.User)

		projectile.CETS_Emplacement = self
		projectile.CETS_Attacker = self.User
	end

	projectile:Spawn()
	projectile:Activate()

	projectile.CETS_Direction = direction
	projectile.CETS_Speed = self.ProjectileSpeed
	projectile.CETS_Damage = self.ProjectileDamage

	local phys = projectile:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(direction * self.ProjectileSpeed)
	end

	if projectile.SetVelocity then
		projectile:SetVelocity(direction * self.ProjectileSpeed)
	end

	return projectile
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoShoot(destination)
	if not destination then
		return
	end

	local damage = self.Damage or 15

	if IsValid(self.User) && self.User:IsNPC() then
		damage = self.NPCDamage or damage
	end

	if self.ShootMode == "projectile" then
		local projectile = self:DoShootProjectile(destination)

		if not IsValid(projectile) then
			return
		end

		if IsValid(self.User) && self.User:IsNPC() then
			projectile.CETS_Damage = self.NPCProjectileDamage or self.ProjectileDamage or 50

		else
			projectile.CETS_Damage = self.ProjectileDamage or 50

		end

		self:EmitSound("Weapon_RPG.Single")

		local effect = EffectData()

		effect:SetEntity(self)
		effect:SetAttachment(1)
		effect:SetFlags(7)

		util.Effect("MuzzleFlash", effect)

		return projectile
	end

	local attachment = self:GetAttachment(1)

	if not attachment then
		return
	end

	local spread = self.Spread or Vector(1, 1, 0) * 0.02

	if IsValid(self.User) && self.User:IsNPC() then
		spread = self.NPCSpread or spread
	end


	local bullet = {
		TracerName = "AR2Tracer",
		Damage = damage,
		Force = 5,
		Spread = spread,
		Src = attachment.Pos,
		Dir = destination,
		Attacker = IsValid(self.User) && self.User or self,
		Inflictor = self,
		Callback = function(att, tr, dmg)
			dmg:SetDamage(damage)
			if IsValid(tr.Entity) then
				if tr.Entity:IsPlayer() or tr.Entity:IsVehicle() then
					dmg:SetDamage(damage)
				end
			end

			dmg:SetDamageType(DMG_AIRBOAT)

			local effectdata = EffectData()

			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetRadius(1)

			util.Effect("AR2Impact", effectdata)

		end
	}


	self:FireBullets(bullet)
	self:EmitSound("Weapon_AR2.NPC_Single")

	local effect = EffectData()

	effect:SetEntity(self)
	effect:SetAttachment(1)
	effect:SetFlags(5)

	util.Effect("MuzzleFlash", effect)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetZoom(state)
	if not self.EnableZoom then
		state = false
	end

	state = state == true

	if self.Zoomed == state then
		return
	end

	self.Zoomed = state

	self:SetNWBool("Zoomed", state)

	if IsValid(self.User) && self.User:IsPlayer() then
		if state then
			if self.ZoomInSound && self.ZoomInSound ~= "" then
				self.User:EmitSound(self.ZoomInSound, self.ZoomSoundLevel, self.ZoomSoundPitch)
			end

			self.User:SetFOV(self.ZoomFOV, self.ZoomTransition)
			self.User:DrawViewModel(false)
			self.User:SetCanZoom(false)
		else

			if self.ZoomOutSound && self.ZoomOutSound ~= "" then
				self.User:EmitSound(self.ZoomOutSound, self.ZoomSoundLevel, self.ZoomSoundPitch)
			end

			self.User:SetFOV(0, self.ZoomTransition)
			self.User:DrawViewModel(true)
			self.User:SetCanZoom(true)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetZoom()
	self.Zoomed = false

	self:SetNWBool("Zoomed", false)

	if IsValid(self.User) && self.User:IsPlayer() then
		self.User:SetFOV(0, self.ZoomTransition)
		self.User:DrawViewModel(true)
		self.User:SetCanZoom(true)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.EnableNPC && (not IsValid(self.User) or self.User:IsNPC()) then
		self:ThinkNPC()
	end

	if self.Active then
		if not IsValid(self.User) then
			self:DeactivateEmplacement()
			self:NextThink(CurTime())
			return true
		end

		if self.User:IsPlayer() && not self.DriveMode then
			if not self.User:Alive() or self.User:EyePos():DistToSqr(self:GetPos()) > self.UseDistance * self.UseDistance then
				self:DeactivateEmplacement()
				self:NextThink(CurTime())
				return true
			end
		end

		if self.InputAttack2 && not self.PreviousInputAttack2 then
			self:SetZoom(not self.Zoomed)
		end

		self.PreviousInputAttack2 = self.InputAttack2

		if self.User:IsPlayer() then
			local aim = self:GetConstrainedAim()

			if aim then
				self.LastAimYaw = aim.yaw
				self.LastAimPitch = aim.pitch

				if self.DoNetworking then
					self:SetNWFloat("AimYaw", aim.yaw)
					self:SetNWFloat("AimPitch", aim.pitch)
				end

				self:SetPoseParameter("aim_yaw", aim.yaw)
				self:SetPoseParameter("aim_pitch", aim.pitch + self.PitchOffset)

				if self:IsGunShooting() then
					if not self.IsKeyDown then
						self.IsKeyDown = true
						self:OnStartAttack()
					end

					if self.ShootTimer <= CurTime() && (self.Automatic or not self.IsShooting) then
						if self.Ammo < 0 or self.Ammo > 0 then
							if not self.IsShooting then
								self.IsShooting = true
								self:OnStartShooting()
							end

							if not self:DoShootThink() then
								self:DoShoot(aim.direction)
								self.ShootTimer = CurTime() + self.ShootDelay

								if self.Ammo > 0 then
									self.Ammo = self.Ammo - 1
								end

								self:ResetSequence(self.ShootSequence)
								self:SetCycle(0)

								self.SequenceTimer = CurTime() + self:SequenceDuration()
							end
						end
					end
				else

					if self.IsShooting then
						self.IsShooting = false
						self:OnStopShooting()
					end

					if self.IsKeyDown then
						self.IsKeyDown = false
						self:OnStopAttack()
					end
				end
			end
		end

	if self.SequenceTimer <= CurTime() then
		self:ResetSequence(self.IdleSequence)
		self:SetCycle(0)
		self.SequenceTimer = CurTime() + self:SequenceDuration()
	end

	elseif self.Retracted then
		self:ResetSequence(self.RetractSequence)
		self:SetCycle(1)

		self:SetPoseParameter("aim_yaw", self.LastAimYaw or 0)
		self:SetPoseParameter("aim_pitch", (self.LastAimPitch or 0) + self.PitchOffset)
	end

	self:NextThink(CurTime())

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if self.Active or IsValid(self.User) then
		self:DeactivateEmplacement()
	end

	if IsValid(self.NPCTarget) then
		if self:IsVJBaseNPC(self.NPCTarget) then
			self:RestoreVJBaseNpc(self.NPCTarget)
		end

		self.NPCTarget = NULL
	end

	if IsValid(self.Vehicle) then
		EmplacementVehicleTable[self.Vehicle:EntIndex()] = nil
	end

	self:DoRemove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("StartCommand", "CETS_EmplacementWeaponBlock", function(ply, cmd)
	local emplacement = ply.CETS_Emplacement

	if not IsValid(emplacement) or not emplacement.Active then
		return
	end

	local buttons = cmd:GetButtons()

	emplacement.InputAttack = bit.band(buttons, IN_ATTACK) ~= 0
	emplacement.InputAttack2 = bit.band(buttons, IN_ATTACK2) ~= 0

	buttons = bit.band(buttons, bit.bnot(IN_ATTACK))
	buttons = bit.band(buttons, bit.bnot(IN_ATTACK2))
	buttons = bit.band(buttons, bit.bnot(IN_RELOAD))

	cmd:SetButtons(buttons)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSwitchWeapon", "CETS_EmplacementWeaponSwitch", function(ply, oldWeapon, newWeapon)
	local emplacement = ply.CETS_Emplacement

	if IsValid(emplacement) && emplacement.Active then
		return true
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerEnteredVehicle", "CETS_EmplacementVehicleEnter", function(ply, vehicle)
	local previous = EmplacementMannedTable[ply:EntIndex()]

	if IsValid(previous) then
		previous:DeactivateEmplacement()
	end

	local emplacement = EmplacementVehicleTable[vehicle:EntIndex()]

	if not IsValid(emplacement) then
		for _, ent in ipairs(ents.FindByClass("ent_cets_emplacement")) do
			if not IsValid(ent) then
				continue
			end

			local foundVehicle = ent:FindVehicleEmplacement(vehicle)

			if IsValid(foundVehicle) then
				emplacement = foundVehicle
				break
			end
		end
	end

	if not IsValid(emplacement) then
		return
	end

	emplacement.DriveMode = true
	emplacement.Vehicle = vehicle
	emplacement.User = ply

	EmplacementVehicleTable[vehicle:EntIndex()] = emplacement

	emplacement:ActivateEmplacement()
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerLeaveVehicle", "CETS_EmplacementVehicleLeave", function(ply, vehicle)
	local emplacement = EmplacementVehicleTable[vehicle:EntIndex()]

	if not IsValid(emplacement) then
		return
	end

	if emplacement.User == ply then
		emplacement:DeactivateEmplacement()
	end

	emplacement:UnregisterVehicle()
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local CETS_TauCrosshair = Material("sprites/hud/v_crosshair1")

local CETS_CrosshairYaw = nil
local CETS_CrosshairPitch = nil
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "CETS_EmplacementCrosshair", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local emplacement = ply:GetNWEntity("CETS_Emplacement", NULL)

	if not IsValid(emplacement) then
		return
	end

	if not emplacement:GetNWBool("Active", false) then
		return
	end

	if emplacement:GetNWEntity("User", NULL) ~= ply then
		return
	end

	 local vehicle = ply:GetVehicle()

	if not IsValid(vehicle) then
		return
	end

	local viewAngles = ply:EyeAngles()
	local viewDirection = viewAngles:Forward()

	local localAngles = emplacement:WorldToLocalAngles(viewDirection:Angle())

	local yaw = math.NormalizeAngle(localAngles.y)
	local pitch = math.NormalizeAngle(localAngles.p)

	local yawLimit = math.abs(tonumber(emplacement.YawLimit) or 90)

	local pitchMin = tonumber(emplacement.PitchMin) or -45
	local pitchMax = tonumber(emplacement.PitchMax) or 45

	local outsideLimits = yaw < -yawLimit or yaw > yawLimit or pitch < pitchMin or pitch > pitchMax

	local speed = 14
	local fraction = math.Clamp(FrameTime() * speed, 0, 1)

	if emplacement.CETS_CrosshairYaw == nil then
		emplacement.CETS_CrosshairYaw = yaw
	end

	if emplacement.CETS_CrosshairPitch == nil then
		emplacement.CETS_CrosshairPitch = pitch
	end

	emplacement.CETS_CrosshairYaw = Lerp(fraction, emplacement.CETS_CrosshairYaw, yaw)
	emplacement.CETS_CrosshairPitch = Lerp(fraction, emplacement.CETS_CrosshairPitch, pitch)

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	local crosshairColor

	if outsideLimits then
		crosshairColor = Color(255, 0, 0, 255)
	else
		crosshairColor = Color(255, 220, 0, 255)
	end

	local sprite = Material("sprites/hud/v_crosshair1")

	if sprite:IsError() then
		return
	end

	local size = 32

	surface.SetMaterial(sprite)
	surface.SetDrawColor(crosshairColor.r, crosshairColor.g, crosshairColor.b, crosshairColor.a)

	surface.DrawTexturedRect(x - size * 0.5, y - size * 0.5, size, size)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoInit()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRemove()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnActivateGun()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeactivateGun()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoThink()

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupCustomModel(mdl, bone, rendergroup)
	if IsValid(self._CustomGunModel) then
		self._CustomGunModel:SetModel(mdl)
	else
		rendergroup = rendergroup or RENDERGROUP_TRANSLUCENT

		self._CustomGunModel = ClientsideModel(mdl, rendergroup)
		self._CustomGunModel:SetNoDraw(true)
	end

	self._CModelBone = bone or self._CModelBone or 0

	return self._CustomGunModel
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DrawCustomGunModel()
	if not IsValid(self._CustomGunModel) then
		return
	end

	self:SetupBones()
	self._CustomGunModel:SetupBones()

	local gunBone = self:GetBoneMatrix(4)

	if not gunBone then
		return
	end

	local gunMatrix = self._GunModelMatrix or Matrix()

	local matrix = gunBone * gunMatrix

	self._CustomGunModel:SetPos(self:GetPos())
	self._CustomGunModel:SetBoneMatrix(self._CModelBone or 0, matrix)
	self._CustomGunModel:DrawModel()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	local mins, maxs = self:GetModelBounds()

	self:SetRenderBounds(mins, maxs, Vector(1, 1, 1) * 30)

	self.Active = false
	self.User = NULL
	self.DriveMode = false
	self.Retracted = true

	self.LastAimYaw = 0
	self.LastAimPitch = 0

	self.ClientAimYaw = 0
	self.ClientAimPitch = 0

	self._CModelBone = 0
	self._GunModelMatrix = Matrix()

	self:DoInit()

	if IsValid(self._CustomGunModel) then
		self._CustomGunModel:SetNoDraw(true)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local active = self:GetNWBool("Active", false)
	local user = self:GetNWEntity("User", NULL)
	local driveMode = self:GetNWBool("DriveMode", false)
	local targetYaw = self:GetNWFloat("AimYaw", 0)
	local targetPitch = self:GetNWFloat("AimPitch", 0)

	if self.Active ~= active then
		self.Active = active

		self.User = user
		self.DriveMode = driveMode

		self.ClientAimYaw = targetYaw
		self.ClientAimPitch = targetPitch
		if active then
			self.Retracted = false
			self:OnActivateGun()
		else
			self.Retracted = true
			self:OnDeactivateGun()
		end
	else
		self.User = user
		self.DriveMode = driveMode
	end

	local smoothing = 18
	local fraction = 1 - math.exp(-smoothing * FrameTime())
	local yawDifference = math.AngleDifference(targetYaw, self.ClientAimYaw)

	self.ClientAimYaw = self.ClientAimYaw + yawDifference * fraction
	self.ClientAimPitch = Lerp(fraction, self.ClientAimPitch, targetPitch)
	self:SetPoseParameter("aim_yaw", self.ClientAimYaw)
	self:SetPoseParameter("aim_pitch", self.ClientAimPitch + self.PitchOffset)

	self:DoThink()
	self:NextThink(CurTime())

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self:DrawModel()

	if IsValid(self._CustomGunModel) then
		self:DrawCustomGunModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if IsValid(self._CustomGunModel) then
		self._CustomGunModel:Remove()
		self._CustomGunModel = nil
	end

	self:DoRemove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetScopeMaterial()
	if not self.EnableScope then
		return nil
	end

	if not self.ScopeMaterial or self.ScopeMaterial == "" then
		return nil
	end

	if not self.CETS_ScopeMaterial then
		self.CETS_ScopeMaterial = Material(self.ScopeMaterial)
	end

	return self.CETS_ScopeMaterial
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DrawScope()
	if not self.EnableScope then
		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	if self:GetNWEntity("User", NULL) ~= ply then
		return
	end

	if not self:GetNWBool("Active", false) then
		return
	end

	if not self:GetNWBool("Zoomed", false) then
		return
	end

	local mat = self:GetScopeMaterial()

	if not mat or mat:IsError() then
		return
	end

	local w = ScrW()
	local h = ScrH()

	local matW = mat:Width()
	local matH = mat:Height()

	if matW <= 0 or matH <= 0 then
		return
	end

	local size = math.min(w, h)
	local aspect = matW / matH

	local drawW = size
	local drawH = size

	if aspect > 1 then
		drawH = size / aspect
	else
		drawW = size * aspect
	end

	local x = (w - drawW) * 0.5
	local y = (h - drawH) * 0.5

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, y)
	surface.DrawRect(0, y + drawH, w, h - (y + drawH))
	surface.DrawRect(0, y, x, drawH)
	surface.DrawRect(x + drawW, y, w - (x + drawW), drawH)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(x, y, drawW, drawH)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "CETS_EmplacementScope", function()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local emplacement = ply:GetNWEntity("CETS_Emplacement", NULL)

	if not IsValid(emplacement) then
		return
	end

	if not emplacement:GetNWBool("Active", false) then
		return
	end

	if emplacement:GetNWEntity("User", NULL) ~= ply then
		return
	end

	if not emplacement:GetNWBool("Zoomed", false) then
		return
	end

	if not emplacement.EnableScope then
		return
	end

	emplacement:DrawScope()
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PreDrawViewModel", "CETS_EmplacementHideViewModel", function(vm, ply, weapon)
	if ply ~= LocalPlayer() then
		return
	end

	local emplacement = ply:GetNWEntity("CETS_Emplacement", NULL)

	if not IsValid(emplacement) then
		return
	end

	if not emplacement:GetNWBool("Active", false) then
		return
	end

	if emplacement:GetNWEntity("User", NULL) ~= ply then
		return
	end

	return true
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end