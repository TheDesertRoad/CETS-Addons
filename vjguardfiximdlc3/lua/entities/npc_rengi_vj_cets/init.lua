AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 80
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.IdleAlwaysWander = true
ENT.IsGuard = false
ENT.UsePoseParameterMovement = true
ENT.CanFlinch = 0
ENT.AnimTbl_CallForHelp = false

ENT.HasMeleeAttack = false

ENT.HasGrenadeAttack = false

local Weapon_None = -1
local Weapon_MP5K = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None

ENT.Combine_TurretEnt = NULL
ENT.Combine_TurretPlacing = false
ENT.Combine_NextTurretCheckT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Weapon_Rand = 2
	self.Model = "models/humans/worker/worker_04.mdl"
	self:MaleSounds()
	self:Give("weapon_vj_cets_spas12")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Combine_DeployTurret()
	local angles = self:GetAngles()
	local mypos = self:GetPos()
	self.IsDeployingTurret = 1

	if self.Combine_NextTurretCheckT < CurTime() && !self.Combine_TurretPlacing && !IsValid(self.Combine_TurretEnt) then
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*80,
			filter = self
		})
		-- Make sure not to place it if the front of the NPC is blocked!
		if !tr.Hit then
			self.Combine_NextTurretCheckT = CurTime() + 30
			self.Combine_TurretPlacing = true
			self:PlayAnim("reload_shotgun_original" , true, false, false)
			timer.Simple(0.9, function()
				if IsValid(self) && !IsValid(self.Combine_TurretEnt) then
					local turret = ents.Create("npc_rengi_sentry_vj_cets")
					turret:SetPos(self:GetPos() + self:GetForward()*50)
					turret:SetAngles(self:GetAngles())
					turret:Spawn()
					turret:Activate()
					turret.VJ_NPC_Class = self.VJ_NPC_Class
					turret:SetState(VJ_STATE_FREEZE, 1)
					VJ.EmitSound(turret, "npc/roller/blade_cut.wav", 75, 100)
					self.Combine_TurretEnt = turret
					self.Combine_TurretPlacing = false
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if !self.VJ_IsBeingControlled && IsValid(self:GetEnemy()) && self.EnemyData.Visible then
		self:Combine_DeployTurret()
	end

	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local shotgun = ents.Create("weapon_shotgun")
		shotgun:SetPos(att.Pos)
		shotgun:SetAngles(att.Ang)
		shotgun:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
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