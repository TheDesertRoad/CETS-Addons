AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 200
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.IdleAlwaysWander = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_CanCrouchAttack = false -- Can it crouch while firing a weapon?
ENT.Weapon_MinDistance = 1 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 2 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 1
ENT.Weapon_FindCoverOnReload = false

ENT.CanChatMessage = false

ENT.JumpParams = {
	Enabled = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18

ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 4 -- Chance of it flinching from 1 to x | 1 will make it always flinch

ENT.AnimTbl_MeleeAttack = {"throw1"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 13
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackDamageType = DMG_BLAST
ENT.DisableDefaultMeleeAttackDamageCode = true
ENT.MeleeAttackDSP = 34
ENT.MeleeAttackDSPLimit = false
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?

ENT.HasGrenadeAttack = false

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 4
ENT.ItemDropsOnDeath_EntityList = {
	"weapon_frag",
}

ENT.CanBeMedic = false

ENT.SoundTbl_BeforeMeleeAttack = "npc/assassin/ball_zap1.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Weapon_Rand = 1
	self.Model = "models/humans/male_bomber.mdl"
	self:MaleSounds()
	self:Give("weapon_vj_cets_nothing")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink(ent)
	if self.EnemyData.DistanceNearest > 1 && self.EnemyData.DistanceNearest < 600 then
		self:SetLocalVelocity(self:GetMoveVelocity() * 0.8)
	else
		self:SetLocalVelocity(self:GetMoveVelocity() * 0)
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
function ENT:CustomOnMeleeAttack_BeforeChecks()
	self:SetBodygroup(1, 1)

	ParticleEffect("grenade_explosion_01",self:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("nigga_fire",self:GetPos(),Angle(0,0,0),nil)

	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav")
	VJ.EmitSound(self, "weapons/fire_explode.wav", 90, 70)

	self.DeathCorpseModel = {
		"models/Humans/Charple01.mdl",
		"models/Humans/Charple02.mdl",
		"models/Humans/Charple03.mdl",
		"models/Humans/Charple04.mdl",
	}
	
	self:SetHealth(1)
	--self:Fire("becomeragdoll","",0)
	
	util.BlastDamage(self, self, self:GetPos(), 150, 10)
	util.VJ_SphereDamage(self,self,self:GetPos(),200,200,self.MeleeAttackDamageType,true,true,{Force90}, function(ent) if !ent:IsOnFire() && (ent:IsPlayer() or ent:IsNPC()) then ent:Ignite(4) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if dmginfo:IsDamageType(DMG_BLAST) then
		self:SetBodygroup(1, 1)

		ParticleEffect("grenade_explosion_01",self:GetPos(),Angle(0,0,0),nil)
		ParticleEffect("nigga_fire",self:GetPos(),Angle(0,0,0),nil)

		VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav")
		VJ.EmitSound(self, "weapons/fire_explode.wav", 90, 70)

		self.DeathCorpseModel = {
			"models/Humans/Charple01.mdl",
			"models/Humans/Charple02.mdl",
			"models/Humans/Charple03.mdl",
			"models/Humans/Charple04.mdl",
		}
	
		self:SetHealth(1)
		--self:Fire("becomeragdoll","",0)
	
		--util.BlastDamage(self, self, self:GetPos(), 200, self.MeleeAttackDamage)
		util.VJ_SphereDamage(self,self,self:GetPos(),300,250,self.MeleeAttackDamageType,true,true,{Force180}, function(ent) if !ent:IsOnFire() && (ent:IsPlayer() or ent:IsNPC()) then ent:Ignite(8) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
end