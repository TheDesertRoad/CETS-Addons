AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Spy_NextCloakT = 30
ENT.Spy_Cloaking = false
ENT.Spy_ControllerCloakLevel = 0

ENT.UsePoseParameterMovement = true
ENT.HasMeleeAttack = false
ENT.HasGrenadeAttack = false

ENT.CanFlinch = 0
ENT.AnimTbl_CallForHelp = false

ENT.HasItemDropsOnDeath = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Weapon_Rand = 1
	self.Model = "models/humans/gman_spy/spy_04.mdl"
	self:Give("weapon_vj_cets_357")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSkin(2)
	self:MaleSounds()
	timer.Simple(10, function() if IsValid(self) then self:SetRenderMode(RENDERMODE_TRANSALPHA) end end)
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSight(ent)
	self.Human_NextPlyReloadSd = CurTime() + math.Rand(5, 40)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)

	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self:IsMoving() then
		self:SetLocalVelocity(self:GetMoveVelocity() * 0.4)
	end

	if self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP) then
		self.VJ_TheController:PrintMessage(HUD_PRINTCENTER, "Changing Camouflage!")
		if self.Spy_ControllerCloakLevel == 0 then
			self.Spy_ControllerCloakLevel = 1
			self:SPY_DOCLOAK()
		elseif self.Spy_ControllerCloakLevel == 1 then
			self.Spy_ControllerCloakLevel = 0
			self:SPY_RESETCLOAK()
		end
	end

	if !self.VJ_IsBeingControlled then
			if IsValid(self:GetEnemy()) then
				if CurTime() > self.Spy_NextCloakT then
					self:SPY_DOCLOAK()
				end
			elseif self:GetNPCState() != NPC_STATE_ALERT && self:GetNPCState() != NPC_STATE_COMBAT then
				if self.Spy_Cloaking == true then self:SPY_RESETCLOAK() end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local revolver = ents.Create("weapon_357")
		revolver:SetPos(att.Pos)
		revolver:SetAngles(att.Ang)
		revolver:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorVis = Color(255, 255, 255, 255)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SPY_RESETCLOAK()
	self.Spy_Cloaking = false
	self:SetNoDraw(false)
	self:DrawShadow(true)
	self:RemoveFlags(FL_NOTARGET)
	VJ.EmitSound(self, "hl1/items/r_item1.wav", 72, 100)
	local curWep = self:GetActiveWeapon()
	ParticleEffect("Cloak_Spy1_cets", self:GetPos(), Angle(0,0,0))
	if IsValid(curWep) then
		if IsValid(self.SecondGun) then
			self.SecondGun:SetColor(colorVis)
			self.SecondGun:DrawShadow(true)
		end
		curWep:SetDrawWorldModel(true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorVis2 = Color(0, 0, 0, 10)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SPY_DOCLOAK()
	self.Spy_Cloaking = true
	self:AddFlags(FL_NOTARGET)
	self:SetNoDraw(true)
	self:DrawShadow(false)

	ParticleEffect("Cloak_Spy1_cets", self:GetPos(), Angle(0,0,0))
	VJ.EmitSound(self, "hl1/items/r_item2.wav", 72, 100)

	local curWep = self:GetActiveWeapon()

	if IsValid(curWep) then
		if IsValid(self.SecondGun) then
			self.SecondGun:SetColor(colorInv)
			self.SecondGun:DrawShadow(false)
		end
		curWep:SetDrawWorldModel(false)
	end

	if self.VJ_IsBeingControlled == false then
		timer.Simple(math.random(5, 10), function() if IsValid(self) then self:SPY_RESETCLOAK() end end)
	end

	self.Spy_NextCloakT = CurTime() + math.random(15, 25)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		self:SPY_RESETCLOAK()
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
	if self.AnimModelSet == VJ.ANIM_SET_PLAYER then
		if !self.Weapon_AimTurnDiff then self.Weapon_AimTurnDiff_Def = 0.61155587434769	end
		self.AnimationTranslations[ACT_COWER] 							= ACT_HL2MP_IDLE_COWER
		self.AnimationTranslations[ACT_RUN_PROTECTED] 					= ACT_HL2MP_RUN_PROTECTED
		
		if wepHoldType == "ar2" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_AR2
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_AR2
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_AR2
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_AR2
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_AR2
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_AR2
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_AR2
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_AR2
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_AR2
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_AR2
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_AR2
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_AR2
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_AR2
		elseif wepHoldType == "pistol" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_PISTOL
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_PISTOL
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_PISTOL
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_PISTOL
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_PISTOL
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_PISTOL
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_PISTOL
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_PISTOL
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_FAST
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_PISTOL
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_PISTOL
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PISTOL
		elseif wepHoldType == "smg" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_SMG1
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_SMG1
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_smg1"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_smg1"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_SMG1
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SMG1
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_SMG1
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_SMG1
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_SMG1
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_SMG1
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_SMG1
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_SMG1
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_SMG1
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_SMG1
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SMG1
		elseif wepHoldType == "shotgun" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_SHOTGUN
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_SHOTGUN
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_shotgun"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_shotgun"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_SHOTGUN
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SHOTGUN
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_SHOTGUN
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_SHOTGUN
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_SHOTGUN
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_SHOTGUN
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_SHOTGUN
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_SHOTGUN
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_SHOTGUN
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_SHOTGUN
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SHOTGUN
		elseif wepHoldType == "rpg" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_RPG
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_RPG
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_RPG
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_RPG
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_RPG
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_RPG
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_RPG
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_RPG
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_RPG
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_RPG
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_RPG
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_RPG
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_RPG
		elseif wepHoldType == "physgun" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_PHYSGUN
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_PHYSGUN
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_PHYSGUN
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_PHYSGUN
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_PHYSGUN
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_PHYSGUN
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_PHYSGUN
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_PHYSGUN
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_PHYSGUN
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_PHYSGUN
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_PHYSGUN
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_PHYSGUN
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PHYSGUN
		elseif wepHoldType == "crossbow" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_CROSSBOW
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_CROSSBOW
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_CROSSBOW
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_CROSSBOW
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_CROSSBOW
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_CROSSBOW
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_CROSSBOW
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_CROSSBOW
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_CROSSBOW
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_CROSSBOW
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CROSSBOW
		elseif wepHoldType == "slam" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_SLAM
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_SLAM
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_SLAM
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SLAM
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_SLAM
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_SLAM
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_SLAM
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_SLAM
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_SLAM
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_SLAM
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_SLAM
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_SLAM
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SLAM
		elseif wepHoldType == "duel" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_DUEL
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_DUEL
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_duel"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_duel"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_DUEL
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_DUEL
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_DUEL
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_DUEL
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_DUEL
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_DUEL
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_DUEL
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_DUEL
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_DUEL
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_DUEL
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_DUEL
		elseif wepHoldType == "revolver" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_REVOLVER
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_REVOLVER
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_revolver"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_revolver"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_REVOLVER
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_REVOLVER
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_REVOLVER
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_REVOLVER
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_REVOLVER
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_REVOLVER
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_REVOLVER
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_REVOLVER
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_REVOLVER
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_REVOLVER
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_REVOLVER
		elseif wepHoldType == "melee" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_MELEE
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_MELEE
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_MELEE
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_MELEE
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_MELEE
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_MELEE
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_MELEE
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_MELEE
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_MELEE
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_MELEE
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_MELEE
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_MELEE
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE
		elseif wepHoldType == "melee2" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_MELEE2
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_MELEE2
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_MELEE2
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_MELEE2
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_MELEE2
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_MELEE2
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_MELEE2
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_MELEE2
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_MELEE2
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_MELEE2
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_MELEE2
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_MELEE2
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE2
		elseif wepHoldType == "knife" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_KNIFE
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_KNIFE
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_KNIFE
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_KNIFE
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_KNIFE
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_KNIFE
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_KNIFE
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_KNIFE
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_KNIFE
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_KNIFE
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_KNIFE
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_KNIFE
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_KNIFE
		elseif wepHoldType == "grenade" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_GRENADE
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_GRENADE
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_GRENADE
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_GRENADE
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_GRENADE
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_GRENADE
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_GRENADE
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_GRENADE
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_GRENADE
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_GRENADE
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_GRENADE
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_GRENADE
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_GRENADE
		elseif wepHoldType == "camera" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_CAMERA
			//self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_CAMERA
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_CAMERA
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_CAMERA
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_CAMERA
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_CAMERA
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_CAMERA
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_CAMERA
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_CAMERA
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_CAMERA
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_CAMERA
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_CAMERA
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_CAMERA
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CAMERA
		else -- Unarmed!
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_ANGRY
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_PISTOL
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_FAST
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
		end
	end
end