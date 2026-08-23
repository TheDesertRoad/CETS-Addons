AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/humans/blackops/hassassin.mdl"
ENT.StartHealth = GetConVar("sk_cets_hassassin_health"):GetInt()
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"}
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_MinDistance = 20
ENT.Weapon_MaxDistance = 4000
ENT.Weapon_RetreatDistance = 0
ENT.Weapon_Accuracy = 0.05
ENT.Weapon_CanMoveFire = false
ENT.Weapon_CanReload = true
ENT.Weapon_IgnoreSpawnMenu = true
ENT.Weapon_Strafe = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.DisableWeaponReloadAnimation = true
ENT.AnimTbl_WeaponAttackGesture = true
ENT.AnimTbl_ShootWhileMovingRun = {ACT_SPRINT}
ENT.AnimTbl_ShootWhileMovingWalk = {ACT_RUN}
ENT.AnimTbl_TakingCover = {ACT_IDLE_ANGRY}

ENT.CanChatMessage = false
ENT.CanTurnWhileMoving = false

ENT.JumpParams = {
	Enabled = true,
	MaxRise = 620,
	MaxDrop = 620,
	MaxDistance = 620
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanDetectDangers = true
ENT.DangerDetectionDistance = 400

ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_IfVisible = true
ENT.ConstantlyFaceEnemy_IfAttacking = false

ENT.DamageResponse = true
ENT.AnimTbl_DamageAllyResponse = ACT_SIGNAL_GROUP
ENT.DamageAllyResponse_Cooldown = VJ.SET(9, 12)
ENT.DamageAllyResponse = true

ENT.AnimTbl_CallForHelp = false
ENT.DisableFootStepSoundTimer = true

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = GetConVar("sk_fassassin_dmg_melee"):GetInt()
ENT.AnimTbl_MeleeAttack = {"melee", "melee2"}
ENT.MeleeAttackDistance = 55
ENT.MeleeAttackDamageDistance = 100

ENT.Assassin_NextJumpT = 0
ENT.Assassin_OffGround = false
ENT.Assassin_NextCloakT = 0
ENT.Assassin_CloakEndT = 0
ENT.Assassin_Cloaking = false
ENT.Assassin_ControllerCloakLevel = 0
ENT.Assassin_NextDodgeT = 0
ENT.Assassin_NextDodge2T = 0
ENT.Assassin_NextLeapT = 0
ENT.Assassin_Leaping = false
ENT.Assassin_NextGrenadeT = 0
ENT.Assassin_GrenadeActive = false
ENT.Assassin_CloakMinTime = 8
ENT.Assassin_CloakMaxTime = 18
ENT.Assassin_CloakCooldownMin = 5
ENT.Assassin_CloakCooldownMax = 10
ENT.Assassin_LeapDistance = 512
ENT.Assassin_LeapCooldown = 8
ENT.Assassin_LeapDamage = 10
ENT.Assassin_GrenadeCooldown = 5
ENT.Assassin_GrenadeDelay = 1.5

ENT.MainSoundPitch = VJ.SET(90, 110)

ENT.SoundTbl_Idle = false
ENT.SoundTbl_IdleDialogue = ENT.SoundTbl_Idle
ENT.SoundTbl_IdleDialogueAnswer = false
ENT.SoundTbl_Investigate = false
ENT.SoundTbl_CombatIdle = false
ENT.SoundTbl_Alert = false
ENT.SoundTbl_WeaponReload = false
ENT.SoundTbl_OnDangerSight = false
ENT.SoundTbl_OnGrenadeSight = false
ENT.SoundTbl_OnKilledEnemy = false
ENT.SoundTbl_AllyDeath = false
ENT.SoundTbl_LostEnemy = false
ENT.SoundTbl_Hurt = false

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/hassassin/kick01.wav",
	"npc/hassassin/kick02.wav",
	"npc/hassassin/kick03.wav",
	"npc/hassassin/kick04.wav",
	"npc/hassassin/kick05.wav",
	"npc/hassassin/kick06.wav",
}

ENT.SoundTbl_Pain = {
	"npc/hassassin/pain01.wav",
	"npc/hassassin/pain02.wav",
	"npc/hassassin/pain03.wav",
	"npc/hassassin/pain04.wav",
	"npc/hassassin/pain05.wav",
	"npc/hassassin/pain06.wav",
}

ENT.SoundTbl_Death = {
	"npc/hassassin/death01.wav",
	"npc/hassassin/death02.wav",
	"npc/hassassin/death03.wav",
	"npc/hassassin/death04.wav",
	"npc/hassassin/death05.wav",
	"npc/hassassin/death06.wav",
}

ENT.SoundTbl_RadioOn = false
ENT.SoundTbl_RadioOff = false
ENT.SoundTbl_CombatIdle = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	local flags = self:GetSpawnFlags()

	if bit.band(flags, 512) ~= 0 or self:HasSpawnFlags(512) then
		self.EnemyTouchDetection = true
		self.AlliedWithPlayerAllies = true
		self.CanReceiveOrders = true
		self.FollowPlayer = true
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_BLACKOPS", "CLASS_UNITED_STATES"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.MainSoundLevel = 20
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 8, 60), Vector(-8, -8, 0))

	self.Assassin_NextCloakT = CurTime() + math.Rand(5, 10)
	self.Assassin_NextLeapT = CurTime() + math.Rand(3, 7)
	self.Assassin_NextDodgeT = CurTime() + math.Rand(2, 5)
	self.Assassin_NextDodge2T = CurTime() + math.Rand(2, 5)
	self.Assassin_NextGrenadeT = CurTime() + math.Rand(4, 10)

	util.SpriteTrail(self, 5, Color(255, 0, 0), true, 1, 0, 0.6, 1 / 26 * 0.5, "sprites/laserbeam")
	util.SpriteTrail(self, 6, Color(255, 0, 0), true, 1, 0, 0.6, 1 / 26 * 0.5, "sprites/laserbeam")

	local spriteGlow = ents.Create("env_sprite")
	spriteGlow:SetKeyValue("rendercolor", "255 0 0")
	spriteGlow:SetKeyValue("GlowProxySize", "1.0")
	spriteGlow:SetKeyValue("HDRColorScale", "1.0")
	spriteGlow:SetKeyValue("renderfx", "14")
	spriteGlow:SetKeyValue("rendermode", "3")
	spriteGlow:SetKeyValue("renderamt", "255")
	spriteGlow:SetKeyValue("disablereceiveshadows", "0")
	spriteGlow:SetKeyValue("mindxlevel", "0")
	spriteGlow:SetKeyValue("maxdxlevel", "0")
	spriteGlow:SetKeyValue("framerate", "10.0")
	spriteGlow:SetKeyValue("model", "VJ_Base/sprites/glow.vmt")
	spriteGlow:SetKeyValue("spawnflags", "0")
	spriteGlow:SetKeyValue("scale", "0.04")
	spriteGlow:SetParent(self)
	spriteGlow:Fire("SetParentAttachment", "EyeLeft")
	spriteGlow:Spawn()

	self:DeleteOnRemove(spriteGlow)

	local spriteGlow1 = ents.Create("env_sprite")
	spriteGlow1:SetKeyValue("rendercolor", "255 0 0")
	spriteGlow1:SetKeyValue("GlowProxySize", "1.0")
	spriteGlow1:SetKeyValue("HDRColorScale", "1.0")
	spriteGlow1:SetKeyValue("renderfx", "14")
	spriteGlow1:SetKeyValue("rendermode", "3")
	spriteGlow1:SetKeyValue("renderamt", "255")
	spriteGlow1:SetKeyValue("disablereceiveshadows", "0")
	spriteGlow1:SetKeyValue("mindxlevel", "0")
	spriteGlow1:SetKeyValue("maxdxlevel", "0")
	spriteGlow1:SetKeyValue("framerate", "10.0")
	spriteGlow1:SetKeyValue("model", "VJ_Base/sprites/glow.vmt")
	spriteGlow1:SetKeyValue("spawnflags", "0")
	spriteGlow1:SetKeyValue("scale", "0.04")
	spriteGlow1:SetParent(self)
	spriteGlow1:Fire("SetParentAttachment", "EyeRight")
	spriteGlow1:Spawn()

	self:DeleteOnRemove(spriteGlow1)

	self:Give("weapon_vj_cets_dualpistol_bo")

	self.BlackAmount = 0
	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	timer.Simple(10, function()
		if IsValid(self) then
			self:SetRenderMode(RENDERMODE_TRANSALPHA)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)

		if not self.Assassin_FireDamageT or CurTime() >= self.Assassin_FireDamageT then
			self.Assassin_FireDamageT = CurTime() + 6
			self:TakeDamage(self:GetMaxHealth(), self, self)
		end
	else
		self.HasIdleSounds = true
		self.Assassin_FireDamageT = nil
		self.BlackAmount = math.max(self.BlackAmount - FrameTime() * 0.4, 0)
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	local alpha = self.Assassin_Cloaking && 16 or 255

	self:SetColor(Color(value, value, value, alpha))

	if self.VJ_IsBeingControlled && IsValid(self.VJ_TheController) then
		if self.VJ_TheController:KeyDown(IN_RELOAD) && not self.Assassin_ControllerReloadHeld then
			self.Assassin_ControllerReloadHeld = true

			if self.Assassin_Cloaking then
				self:ASSASSIN_RESETCLOAK()
			else
				self:ASSASSIN_DOCLOAK()
			end
		elseif not self.VJ_TheController:KeyDown(IN_RELOAD) then
			self.Assassin_ControllerReloadHeld = false
		end
	end

	local enemy = self:GetEnemy()

	if not self.VJ_IsBeingControlled && IsValid(enemy) then
		local distance = self:GetPos():Distance(enemy:GetPos())
		local enemyVisible = self:Visible(enemy)

		if self.Assassin_Cloaking then
			if CurTime() >= self.Assassin_CloakEndT then
				self:ASSASSIN_RESETCLOAK()
			end
		else
			if CurTime() >= self.Assassin_NextCloakT then
				if distance > 350 or not enemyVisible then
					self:ASSASSIN_DOCLOAK()
				elseif math.random(1, 100) <= 35 then
					self:ASSASSIN_DOCLOAK()
				end
			end
		end

		if not self.Assassin_Cloaking && CurTime() >= self.Assassin_NextGrenadeT then
			if distance >= 300 && distance <= 1200 then
				self:ThrowGrenade(enemy)
			end
		end

		if not self.Assassin_Leaping && CurTime() >= self.Assassin_NextLeapT then
			if distance >= 180 && distance <= self.Assassin_LeapDistance && enemyVisible then
				self:LeapAttack(enemy)
			end
		end
	end

	if self.Assassin_OffGround then
		if self:IsOnGround() or self:GetVelocity().z == 0 then
			self.Assassin_OffGround = false
			self:ClearSchedule()
			self:StopMoving()
			self:PlayAnim("jumpland", true, false, false)
			self.AnimTbl_IdleStand = {ACT_IDLE}
		else
			if self:GetActivity() ~= ACT_GLIDE then
				self:PlayAnim(ACT_GLIDE, true, false, false)
			end
		end
	end

	if not self.Assassin_Leaping && not self.Assassin_OffGround then
		if (self.VJ_IsBeingControlled && IsValid(self.VJ_TheController) && self.VJ_TheController:KeyDown(IN_JUMP) or IsValid(enemy) && not self.VJ_IsBeingControlled && CurTime() > self.Assassin_NextDodgeT && not self:IsMoving() && not self:Dodge() && not self:Dodge2() && self:GetPos():Distance(enemy:GetPos()) < 750) && self:IsOnGround() then
			self:Dodge()
		end
	end

	if IsValid(enemy) && not self.VJ_IsBeingControlled && not self.Assassin_Leaping then
		if CurTime() > self.Assassin_NextJumpT && not self:IsMoving() && self:GetPos():Distance(enemy:GetPos()) < 1400 then
			self:PerformCombatJump(enemy)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PerformCombatJump(enemy)
	if not IsValid(enemy) or self.Assassin_Leaping then return end

	self:StopMoving()
	self:SetGroundEntity(NULL)

	local direction = (enemy:GetPos() - self:GetPos()):GetNormalized()
	local side = math.random(0, 1) == 1 && 1 or -1
	local velocity = direction * 200 + self:GetUp() * 500 + self:GetRight() * side * 80

	self:SetLocalVelocity(velocity)

	self.AnimTbl_IdleStand = {ACT_GLIDE}

	self:PlayAnim(ACT_JUMP, true, false, true, 0, {}, function()
		if not IsValid(self) then return end

		self.Assassin_OffGround = true
		self:PlayAnim(ACT_GLIDE, true, false, false)
	end)

	self.Assassin_NextJumpT = CurTime() + 8
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttack(enemy)
	if not IsValid(enemy) then return false end
	if self.Assassin_Leaping then return false end
	if CurTime() < self.Assassin_NextLeapT then return false end
	if not self:IsOnGround() then return false end
	if self:IsBusy() then return false end

	self.Assassin_Leaping = true
	self.Assassin_NextLeapT = CurTime() + self.Assassin_LeapCooldown

	self:StopMoving()
	self:ClearSchedule()
	self:SetGroundEntity(NULL)

	local targetPos = enemy:WorldSpaceCenter()
	local startPos = self:WorldSpaceCenter()
	local direction = (targetPos - startPos):GetNormalized()
	local distance = startPos:Distance(targetPos)

	local forwardVelocity = math.Clamp(distance * 1.15, 350, 800)
	local verticalVelocity = math.Clamp(280 + distance * 0.25, 350, 600)

	self:SetLocalVelocity(direction * forwardVelocity + self:GetUp() * verticalVelocity)

	self:PlayAnim("jumploop", true, false, true, 0, {}, function()
		if not IsValid(self) then return end
	end)

	timer.Simple(0.35, function()
		if not IsValid(self) then return end

		if IsValid(enemy) && self:GetPos():Distance(enemy:GetPos()) <= 150 then
			local dmg = DamageInfo()
			dmg:SetDamage(self.Assassin_LeapDamage)
			dmg:SetDamageType(DMG_CLUB)
			dmg:SetAttacker(self)
			dmg:SetInflictor(self)
			dmg:SetDamagePosition(enemy:WorldSpaceCenter())
			dmg:SetDamageForce(self:GetForward() * 5000)

			enemy:TakeDamageInfo(dmg)

			local push = (enemy:GetPos() - self:GetPos()):GetNormalized()
			enemy:SetVelocity(push * 250 + Vector(0, 0, 120))
		end
	end)

	timer.Simple(0.65, function()
		if not IsValid(self) then return end

		self.Assassin_Leaping = false
		self.Assassin_OffGround = false

		if self:IsOnGround() then
			self:PlayAnim("jumpland", true, false, false)
		else
			self.Assassin_OffGround = true
		end
	end)

	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThrowGrenade(enemy)
	if not IsValid(enemy) then return false end
	if self.Assassin_GrenadeActive then return false end
	if CurTime() < self.Assassin_NextGrenadeT then return false end

	self.Assassin_GrenadeActive = true
	self.Assassin_NextGrenadeT = CurTime() + self.Assassin_GrenadeCooldown

	local startPos = self:WorldSpaceCenter() + self:GetForward() * 25 + self:GetUp() * 20
	local targetPos = enemy:WorldSpaceCenter()
	local distance = startPos:Distance(targetPos)
	local flightTime = math.Clamp(distance / 900, 0.35, 1.2)
	local gravity = 600

	local velocity = (targetPos - startPos) / flightTime
	velocity.z = velocity.z + gravity * flightTime * 0.5

	local grenade = ents.Create("obj_vj_cets_hecxtrac")

	if not IsValid(grenade) then
		self.Assassin_GrenadeActive = false
		return false
	end

	grenade:SetPos(startPos)
	grenade:SetAngles(AngleRand())
	grenade:SetOwner(self)
	grenade:Spawn()
	grenade:Activate()

	local phys = grenade:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetVelocity(velocity)
		phys:AddAngleVelocity(VectorRand() * 500)
	end

	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "Foot" then
		VJ.EmitSound(self, "npc/footsteps/hardboot_generic2.wav", 72, 100)
		VJ.EmitSound(self, {"npc/stalker/stalker_footstep_left1.wav", "npc/stalker/stalker_footstep_left2.wav", "npc/stalker/stalker_footstep_right1.wav", "npc/stalker/stalker_footstep_right2.wav"}, 75)
	end

	if key == "left" or key == "right" then
		local wep = self:GetActiveWeapon()

		if IsValid(wep) then
			wep.CurrentMuzzle = key
		end
	end

	if string.StartWith(key, "melee") then
		self:ExecuteMeleeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
	self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK1
	self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] = ACT_RANGE_ATTACK1
	self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK1
	self.AnimationTranslations[ACT_RELOAD] = ACT_IDLE_ANGRY
	self.AnimationTranslations[ACT_COVER_LOW] = ACT_IDLE_ANGRY
	self.AnimationTranslations[ACT_RELOAD_LOW] = ACT_IDLE_ANGRY

	self.AnimationTranslations[ACT_IDLE] = ACT_IDLE
	self.AnimationTranslations[ACT_IDLE_ANGRY] = ACT_IDLE_ANGRY

	self.AnimationTranslations[ACT_WALK] = ACT_WALK
	self.AnimationTranslations[ACT_WALK_AIM] = ACT_WALK
	self.AnimationTranslations[ACT_WALK_CROUCH] = ACT_WALK
	self.AnimationTranslations[ACT_WALK_CROUCH_AIM] = ACT_WALK

	self.AnimationTranslations[ACT_RUN] = ACT_RUN
	self.AnimationTranslations[ACT_RUN_AIM] = ACT_RUN
	self.AnimationTranslations[ACT_RUN_CROUCH] = ACT_RUN
	self.AnimationTranslations[ACT_RUN_CROUCH_AIM] = ACT_RUN
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ASSASSIN_RESETCLOAK()
	if not self.Assassin_Cloaking then return end

	self.Assassin_Cloaking = false
	self.Assassin_CloakEndT = 0
	self:SetColor(Color(255, 255, 255, 255))
	self:DrawShadow(true)
	self:RemoveFlags(FL_NOTARGET)

	VJ.EmitSound(self, "buttons/combine_button5.wav", 72, 100)

	local curWep = self:GetActiveWeapon()

	if IsValid(curWep) then
		if IsValid(self.SecondGun) then
			self.SecondGun:SetColor(color_white)
			self.SecondGun:DrawShadow(true)
		end

		curWep:SetDrawWorldModel(true)
	end

	if not self.VJ_IsBeingControlled then
		self.Assassin_NextCloakT = CurTime() + math.Rand(self.Assassin_CloakCooldownMin, self.Assassin_CloakCooldownMax)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ASSASSIN_DOCLOAK()
	if self.Assassin_Cloaking then return end

	self.Assassin_Cloaking = true
	self:AddFlags(FL_NOTARGET)
	self:SetColor(Color(255, 255, 255, 16))
	self:DrawShadow(false)

	local curWep = self:GetActiveWeapon()

	if IsValid(curWep) then
		if IsValid(self.SecondGun) then
			self.SecondGun:SetColor(Color(255, 255, 255, 16))
			self.SecondGun:DrawShadow(false)
		end

		curWep:SetDrawWorldModel(false)
	end

	self.Assassin_CloakEndT = CurTime() + math.Rand(self.Assassin_CloakMinTime, self.Assassin_CloakMaxTime)
	self.Assassin_NextCloakT = self.Assassin_CloakEndT + math.Rand(self.Assassin_CloakCooldownMin, self.Assassin_CloakCooldownMax)

	VJ.EmitSound(self, "buttons/combine_button7.wav", 72, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponCanFire()
	if self.Assassin_OffGround then return false end
	if self.Assassin_Leaping then return false end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFireBullet(data)
	self.Assassin_CloakLevel = 0

	for _, attachmentName in ipairs({"LeftMuzzle", "RightMuzzle"}) do
		local attachment = self:LookupAttachment(attachmentName)

		if attachment > 0 then
			local ef = EffectData()
			ef:SetEntity(self)
			ef:SetAttachment(attachment)
			ef:SetFlags(4)

			util.Effect("MuzzleFlash", ef)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dodge()
	if self:IsBusy() then return false end

	if self.VJ_IsBeingControlled then
		local ply = self.VJ_TheController

		if not IsValid(ply) then return false end

		self:PlayAnim((ply:KeyDown(IN_MOVELEFT) && "FlipLeft") or (ply:KeyDown(IN_MOVERIGHT) && "FlipRight") or (ply:KeyDown(IN_FORWARD) && "FlipForwardB") or "flipback", true, false, true)

		self.Assassin_NextDodgeT = CurTime() + math.Rand(2, 6)
		return true
	end

	local checkdist = self:VJ_CheckAllFourSides(400)
	local randmove = {}

	if checkdist.Backward then randmove[#randmove + 1] = "Backward" end
	if checkdist.Right then randmove[#randmove + 1] = "Right" end
	if checkdist.Left then randmove[#randmove + 1] = "Left" end
	if checkdist.Forward then randmove[#randmove + 1] = "Forward" end

	if #randmove <= 0 then return false end

	local pickmove = VJ.PICK(randmove)
	local anim = "flipback"

	if pickmove == "Right" then anim = "FlipRight" end
	if pickmove == "Left" then anim = "FlipLeft" end
	if pickmove == "Forward" then anim = "FlipForwardB" end

	self:PlayAnim(anim, true, false, true)
	self.Assassin_NextDodgeT = CurTime() + math.Rand(2, 4)

	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dodge2()
	if self:IsBusy() then return false end

	if self.VJ_IsBeingControlled then
		local ply = self.VJ_TheController

		if not IsValid(ply) then return false end

		self:PlayAnim((ply:KeyDown(IN_MOVELEFT) && "FlipLeft") or (ply:KeyDown(IN_MOVERIGHT) && "FlipRight") or (ply:KeyDown(IN_FORWARD) && "FlipForwardB") or "flipback", true, false, true)

		self.Assassin_NextDodge2T = CurTime() + math.Rand(2, 6)
		return true
	end

	local checkdist = self:VJ_CheckAllFourSides(400)
	local randmove = {}

	if checkdist.Backward then randmove[#randmove + 1] = "Backward" end
	if checkdist.Right then randmove[#randmove + 1] = "Right" end
	if checkdist.Left then randmove[#randmove + 1] = "Left" end
	if checkdist.Forward then randmove[#randmove + 1] = "Forward" end

	if #randmove <= 0 then return false end

	local pickmove = VJ.PICK(randmove)
	local anim = "flipback"

	if pickmove == "Right" then anim = "FlipRight" end
	if pickmove == "Left" then anim = "FlipLeft" end
	if pickmove == "Forward" then anim = "FlipForwardB" end

	self:PlayAnim(anim, true, false, true)
	self.Assassin_NextDodge2T = CurTime() + math.Rand(1, 3)

	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnBleed(dmginfo, hitgroup)
	if self.VJ_IsBeingControlled then return end
	if self.Assassin_Leaping then return end
	if CurTime() < self.Assassin_NextDodge2T then return end
	if self:IsMoving() then return end
	if not self:IsOnGround() then return end

	self:Dodge()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		self.Assassin_Cloaking = false
		self.Assassin_Leaping = false
		self:RemoveFlags(FL_NOTARGET)
		self:SetColor(Color(255, 255, 255, 255))
		self:DrawShadow(true)
		self:SetBodygroup(1, 1)
	end
end