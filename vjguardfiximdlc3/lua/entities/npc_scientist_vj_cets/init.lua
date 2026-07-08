AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 40
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.CanRedirectGrenades = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18

ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 4 -- Chance of it flinching from 1 to x | 1 will make it always flinch

ENT.HasMeleeAttack = false

ENT.HasGrenadeAttack = false

ENT.IsMedic = true
ENT.Medic_TimeUntilHeal = 2
ENT.Medic_HealAmount = 10 -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(10, 20)
ENT.Medic_SpawnPropOnHeal = false
ENT.Medic_SpawnPropOnHealAttachment = "righthand"

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = false

local mdlFem = {
	"models/humans/scientist/female_01.mdl",
	"models/humans/scientist/female_02.mdl",
	"models/humans/scientist/female_03.mdl",
	"models/humans/scientist/female_04.mdl",
	"models/humans/scientist/female_05.mdl",
	"models/humans/scientist/female_06.mdl",
}

local mdlMal = {
	"models/humans/scientist/male_01.mdl",
	"models/humans/scientist/male_02.mdl",
	"models/humans/scientist/male_03.mdl",
	"models/humans/scientist/male_04.mdl",
	"models/humans/scientist/male_05.mdl",
	"models/humans/scientist/male_06.mdl",
	"models/humans/scientist/male_07.mdl",
	"models/humans/scientist/male_08.mdl",
	"models/humans/scientist/male_09.mdl",
	"models/humans/scientist/young_kleiner.mdl",
	"models/humans/scientist/dr_cohrt.mdl",
	"models/humans/scientist/dr_einstein.mdl",
}

local Sex_None = -1
local Sex_M = 1
local Sex_F = 2

ENT.Sex_Rand = Sex_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if self.Sex_Rand == 1 or (self.Sex_Rand == -1 && math.random(1, 2) == 1) then
		self.Sex_Rand = 1
		self.Model = mdlMal
		self:MaleSounds()
		self.AnimTbl_Medic_GiveHealth = "give_emp"
	else
		self.Sex_Rand = 2
		self.Model = mdlFem
		self:FemaleSounds()
		self.IsMedic = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSkin(math.random(0, 3))
	if game.GetGlobalState("gordon_precriminal") == 1 then 
		self.Behavior = VJ_BEHAVIOR_NEUTRAL
		self.IdleAlwaysWander = true
		self.EnemyTouchDetection = true
		self.BecomeEnemyToPlayer = true
		self.AlliedWithPlayerAllies = true
		self.CanReceiveOrders = false
		self.FollowPlayer = false
		self.YieldToAlliedPlayers = false
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
	end
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) && self.Sex_Rand == 1 then
		self:PlaySoundSystem("Pain", MaleFirePain)

	elseif self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) && self.Sex_Rand == 2 then
		self:PlaySoundSystem("Pain", FemaleFirePain)
	end

	if self:Health() > 0 && dmginfo:IsDamageType(DMG_NERVEGAS) then
		self.Bleeds = false
	end

	if self.Sex_Rand == 1 && status == "PostDamage" && self:Health() > 0 && math.random(1, 2) == 1 then
		if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			self:PlaySoundSystem("Pain", sdPainArm_M)
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			self:PlaySoundSystem("Pain", sdPainLeg_M)
		elseif hitgroup == HITGROUP_STOMACH then
			self:PlaySoundSystem("Pain", sdPainGut_M)
		end

	elseif self.Sex_Rand == 2 && status == "PostDamage" && self:Health() > 0 && math.random(1, 2) == 1 then
		if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			self:PlaySoundSystem("Pain", sdPainArm_F)
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			self:PlaySoundSystem("Pain", sdPainLeg_F)
		elseif hitgroup == HITGROUP_STOMACH then
			self:PlaySoundSystem("Pain", sdPainGut_F)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 1 && self.Sex_Rand == 1 then
		if ent:IsPlayer() then
			self:PlaySoundSystem("Alert", sdAlertFreeman)
		end

		if ent:IsNPC() then
			if ent.IsVJBaseSNPC_Creature then
				for _, v in ipairs(ent.VJ_NPC_Class or {1}) do
					if v == "CLASS_COMBINE" or ent:Classify() == CLASS_COMBINE then
					self:PlaySoundSystem("Alert", sdAlertComb)
				return 
				end
			end
		end

		if ent:IsNPC() then
			if ent.IsVJBaseSNPC_Creature then
				for _, v in ipairs(ent.VJ_NPC_Class or {1}) do
					if v == "CLASS_ZOMBIE" or ent:Classify() == CLASS_ZOMBIE then
					self:PlaySoundSystem("Alert", sdAlertZombies)
				return 
				end
			end
		end

		if ent:GetClass() == "npc_metropolice" or ent:GetClass() == "npc_elitemetropolice_vj_cets" or ent:GetClass() == "npc_combine_swat_vj_cets" then
			self:PlaySoundSystem("Alert", sdAlertCP)
		end

		if ent:GetClass() == "npc_headcrab" or ent:GetClass() == "npc_headcrab_black" or ent:GetClass() == "npc_headcrab_fast" or ent:GetClass() == "npc_armorhead_vj_cets" or ent:GetClass() == "npc_babycrab_vj_cets" then
			self:PlaySoundSystem("Alert", sdAlertCrabs)
		end

		if ent:GetClass() == "npc_manhack" then
			self:PlaySoundSystem("Alert", sdAlertManhacks)
		end

		if ent:GetClass() == "npc_strider" then
			self:PlaySoundSystem("Alert", sdAlertStrider)
				end
			end
		end

	elseif math.random(1, 2) == 1 && self.Sex_Rand == 2 then
		if ent:IsPlayer() then
			self:PlaySoundSystem("Alert", sdAlertFreemanF)
		end

		if ent:IsNPC() then
			if ent.IsVJBaseSNPC_Creature then
				for _, v in ipairs(ent.VJ_NPC_Class or {1}) do
					if v == "CLASS_COMBINE" or ent:Classify() == CLASS_COMBINE then
					self:PlaySoundSystem("Alert", sdAlertCombF)
				return 
				end
			end
		end

		if ent:IsNPC() then
			if ent.IsVJBaseSNPC_Creature then
				for _, v in ipairs(ent.VJ_NPC_Class or {1}) do
					if v == "CLASS_ZOMBIE" or ent:Classify() == CLASS_ZOMBIE then
					self:PlaySoundSystem("Alert", sdAlertZombiesF)
				return 
				end
			end
		end

		if ent:GetClass() == "npc_metropolice" or ent:GetClass() == "npc_elitemetropolice_vj_cets" or ent:GetClass() == "npc_combine_swat_vj_cets" then
			self:PlaySoundSystem("Alert", sdAlertCPF)
		end

		if ent:GetClass() == "npc_headcrab" or ent:GetClass() == "npc_headcrab_black" or ent:GetClass() == "npc_headcrab_fast" or ent:GetClass() == "npc_armorhead_vj_cets" or ent:GetClass() == "npc_babycrab_vj_cets" then
			self:PlaySoundSystem("Alert", sdAlertCrabsF)
		end

		if ent:GetClass() == "npc_manhack" then
			self:PlaySoundSystem("Alert", sdAlertManhacksF)
		end

		if ent:GetClass() == "npc_strider" then
			self:PlaySoundSystem("Alert", sdAlertStriderF)
				end
			end
		end
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAllyKilled(ent)
	if ent:IsPlayer() && self.Sex_Rand == 1 then
		self:PlaySoundSystem("AllyDeath", sdAllyDeathPly_M)
	
	elseif ent:IsPlayer() && self.Sex_Rand == 2 then
		self:PlaySoundSystem("AllyDeath", sdAllyDeathPly_F)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath( dmginfo, hit_gr, rag )
	self:SetBodygroup(1, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Sex_Rand == 1 && self:IsOnFire() && CurTime() > self.NextDance then
		self.Bleeds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	
	elseif self.Sex_Rand == 2 && self:IsOnFire() && CurTime() > self.NextDance then
		self.Bleeds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
end