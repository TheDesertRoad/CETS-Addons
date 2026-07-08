AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/skitch.mdl"
ENT.StartHealth = GetConVar("sk_cets_skitch_health"):GetInt()
ENT.HealthRegenParams = {
	Enabled = true, 
	Amount = 2, 
	Delay = VJ.SET(0.1, 1), 
	ResetOnDmg = true
}
ENT.HullType = HULL_HUMAN
ENT.Immune_Toxic = true

ENT.CanChatMessage = false

ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY_VITAL", "CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true

ENT.JumpParams = {
	MaxRise = 500,
	MaxDrop = 1000,
	MaxDistance = 1000
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"swipe"}
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true
ENT.TimeUntilMeleeAttackDamage = 0.3
ENT.MeleeAttackDistance = 64 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.NextMeleeAttackTime = 0.1 -- How much time until it can use a melee attack?
ENT.MeleeAttackDamage = 100
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 10 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1. -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 3 -- How many repetitions?

ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_Postures = "Moving"
ENT.ConstantlyFaceEnemy_MinDistance = 200

ENT.FootStepSoundLevel = 70
ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.4 -- Next foot step sound when it is walking

ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav", "npc/zombie/foot2.wav", "npc/zombie/foot3.wav"}

ENT.SoundTbl_Idle = {
	"npc/skitch/skitch_hiss01.wav",
	"npc/skitch/skitch_hiss02.wav",
	"npc/skitch/skitch_hiss03.wav",
	"npc/skitch/skitch_hiss04.wav",
	"npc/skitch/skitch_hiss05.wav",
}
ENT.SoundTbl_Alert = {
	"npc/skitch/skitch_roar01.wav",
	"npc/skitch/skitch_roar02.wav",
}
ENT.SoundTbl_Pain = {
	"npc/skitch/skitch_squeak01.wav",
	"npc/skitch/skitch_squeak02.wav",
	"npc/skitch/skitch_squeak03.wav",
	"npc/skitch/skitch_squeak04.wav",
}
ENT.SoundTbl_Death = {
	"npc/skitch/skitch_growl01.wav",
}
ENT.SoundTbl_FollowPlayer = {
	"npc/skitch/skitch_excitedsqueak01.wav",
	"npc/skitch/skitch_excitedsqueak02.wav",
}
ENT.SoundTbl_UnFollowPlayer = {
	"npc/skitch/skitch_sadsqueak01.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"npc/skitch/gentlesqueak01.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/skitch/skitch_growl01.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSurroundingBounds(Vector(110, 60, 35), Vector(-90, -60, 0))
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:SetLocalVelocity(self:GetMoveVelocity() * 1)

	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.3, 1)
		timer.Simple(24, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Follow(ent, stopIfFollowing)
	if !IsValid(ent) or self.Dead or !VJ_CVAR_AI_ENABLED or self == ent then return false, 0 end
	
	local isPly = ent:IsPlayer()
	local isLiving = ent.VJ_ID_Living
	if (!isLiving) or (ent:Alive() && ((isPly && !VJ_CVAR_IGNOREPLAYERS) or (!isPly))) then
		local followData = self.FollowData
		-- Refusals
		if isLiving && self:GetClass() != ent:GetClass() && (self:Disposition(ent) == D_HT or self:Disposition(ent) == D_NU) then -- Check for enemy/neutral
			if isPly && self.CanChatMessage then
				ent:PrintMessage(HUD_PRINTTALK, self:GetName() .. " isn't friendly so it won't follow you.")
			end
			return false, 3
		elseif self.IsFollowing && ent != followData.Target then -- Already following another entity
			if isPly && self.CanChatMessage then
				ent:PrintMessage(HUD_PRINTTALK, self:GetName() .. " is following another entity so it won't follow you.")
			end
			return false, 2
		elseif self.MovementType == VJ_MOVETYPE_STATIONARY or self.MovementType == VJ_MOVETYPE_PHYSICS then
			if isPly && self.CanChatMessage then
				ent:PrintMessage(HUD_PRINTTALK, self:GetName() .. " is currently stationary so it can't follow you.")
			end
			return false, 1
		end
		
		if !self.IsFollowing then
			if isPly then
				if self.CanChatMessage then
					ent:PrintMessage(HUD_PRINTTALK, self:GetName() .. " is now following you.")
				end
				self:PlaySoundSystem("FollowPlayer")
				self:PlayAnim("headshake", 1, false)
				-- Reset the guarding data
				self.GuardData.Position = false
				self.GuardData.Direction = true
			end
			followData.Target = ent
			followData.MinDist = self.FollowMinDistance + self:OBBMaxs().y + ent:OBBMaxs().y
			self.IsFollowing = true
			self:SetTarget(ent)
			if !self:IsBusy("Activities") then -- Face the entity and then move to it
				self:StopMoving()
				self:SCHEDULE_FACE("TASK_FACE_TARGET", function(x)
					x.RunCode_OnFinish = function()
						if IsValid(self.FollowData.Target) then
							self:SCHEDULE_GOTO_TARGET(((self:GetPos():Distance(self.FollowData.Target:GetPos()) < (followData.MinDist * 1.5)) and "TASK_WALK_PATH") or "TASK_RUN_PATH", function(y) y.CanShootWhenMoving = true y.TurnData = {Type = VJ.FACE_ENEMY} end)
						end
					end
				end)
			end
			self:OnFollow("Start", ent)
			return true, 0
		elseif stopIfFollowing then -- Unfollow the entity
			if isPly then
				self:PlaySoundSystem("UnFollowPlayer")
			end
			self:PlayAnim("sad", 1, false)
			self:StopMoving()
			self.NextWanderTime = CurTime() + 2
			if !self:IsBusy("Activities") then
				self:SCHEDULE_FACE("TASK_FACE_TARGET")
			end
			self:ResetFollowBehavior()
			self:OnFollow("Stop", ent)
		end
	end
	return false, 0
end