AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/armored.mdl"}
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.StartHealth = GetConVar("sk_cets_armwz_health"):GetInt()
ENT.SightDistance = 10000
ENT.Sightangle = 80 
ENT.TurningSpeed = 20
ENT.HullType = HULL_HUMAN
ENT.TimeUntilEnemyLost = 5000 
ENT.LastSeenEnemyTimeUntilReset = 1000 -- Time until it resets its enemy if its current enemy is not visible
ENT.InvestigateSoundDistance = 100 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
ENT.CanChatMessage = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01" -- Particles to spawn when it's damaged
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.MeleeAttackDistance = 35
ENT.MeleeAttackDamageDistance = 65
ENT.TimeUntilNextMeleeAttack = 1.3
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 200
ENT.MeleeAttackKnockBack_Forward2 = 230

ENT.CanFlinch = true
ENT.FlinchChance = 4
ENT.FlinchCooldown = 2
ENT.AnimTbl_Flinch = {"physflinch1", "physflinch2", "physflinch3",}

ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking

ENT.SoundTbl_FootStep = {"npc/zombine/gear1.wav", "npc/zombine/gear2.wav", "npc/zombine/gear3.wav"}

ENT.SoundTbl_Idle = {
	"npc/zombie/zombie_voice_idle1.wav",
	"npc/zombie/zombie_voice_idle2.wav",
	"npc/zombie/zombie_voice_idle3.wav",
	"npc/zombie/zombie_voice_idle4.wav",
	"npc/zombie/zombie_voice_idle5.wav",
	"npc/zombie/zombie_voice_idle6.wav",
	"npc/zombie/zombie_voice_idle7.wav",
	"npc/zombie/zombie_voice_idle8.wav",
	"npc/zombie/zombie_voice_idle9.wav",
	"npc/zombie/zombie_voice_idle10.wav",
	"npc/zombie/zombie_voice_idle11.wav",
	"npc/zombie/zombie_voice_idle12.wav",
	"npc/zombie/zombie_voice_idle13.wav",
	"npc/zombie/zombie_voice_idle14.wav",
	"ambient/levels/prison/radio_random1.wav",
	"ambient/levels/prison/radio_random2.wav",
	"ambient/levels/prison/radio_random3.wav",
	"ambient/levels/prison/radio_random4.wav",
	"ambient/levels/prison/radio_random5.wav",
	"ambient/levels/prison/radio_random6.wav",
	"ambient/levels/prison/radio_random7.wav",
	"ambient/levels/prison/radio_random8.wav",
	"ambient/levels/prison/radio_random9.wav",
	"ambient/levels/prison/radio_random10.wav",
	"ambient/levels/prison/radio_random11.wav",
	"ambient/levels/prison/radio_random12.wav",
	"ambient/levels/prison/radio_random13.wav",
	"ambient/levels/prison/radio_random14.wav",
	"ambient/levels/prison/radio_random15.wav",
}

ENT.SoundTbl_Alert = {
	"npc/zombie/zombie_alert1.wav",
	"npc/zombie/zombie_alert2.wav",
	"npc/zombie/zombie_alert3.wav",
}

ENT.SoundTbl_MeleeAttack = {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/zombie/zombie_pain1.wav",
	"npc/zombie/zombie_pain2.wav",
	"npc/zombie/zombie_pain3.wav",
	"npc/zombine/zombine_pain1.wav",
	"npc/zombine/zombine_pain2.wav",
	"npc/zombine/zombine_pain3.wav",
}

ENT.SoundTbl_Death = {
	"npc/zombine/zombine_die1.wav",
	"npc/zombine/zombine_die2.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetBodygroup(1,1)

	self.BlackAmount = 0

	local bloater_random = math.random(1, 7)
	local bloater_gen = math.random(1, 1)
	
	if bloater_gen == 1 then
		self.bloater = ents.Create("obj_vj_cets_biocan_nd")

		if bloater_random == 1 then
			self.bloater:SetPos(self:GetAttachment(8).Pos)
			self.bloater:SetAngles( self:GetAngles() + Angle(90,0,0) )
			self.bloater:SetParent(self, 8)
		elseif bloater_random == 2 then
			self.bloater:SetPos(self:GetAttachment(7).Pos + self:GetForward()*2)
			self.bloater:SetAngles( self:GetAngles() + Angle(90,90,90) )
			self.bloater:SetParent(self, 7)
		elseif bloater_random == 3 then
			self.bloater:SetPos(self:GetAttachment(6).Pos + self:GetForward()*2)
			self.bloater:SetAngles( self:GetAngles() + Angle(90,90,90) )
			self.bloater:SetParent(self, 6)
		elseif bloater_random == 4 then
			self.bloater:SetPos(self:GetAttachment(9).Pos + self:GetForward()*2)
			self.bloater:SetAngles( self:GetAngles() + Angle(180,90,180) )
			self.bloater:SetParent(self, 9)
		elseif bloater_random == 5 then
			self.bloater:SetPos(self:GetAttachment(10).Pos + self:GetForward()*2)
			self.bloater:SetAngles( self:GetAngles() + Angle(180,90,180) )
			self.bloater:SetParent(self, 10)
		elseif bloater_random == 6 then
			self.bloater:SetPos(self:GetAttachment(11).Pos)
			self.bloater:SetAngles( self:GetAngles() + Angle(180,90,180) )
			self.bloater:SetParent(self, 11)
		elseif bloater_random == 7 then
			self.bloater:SetPos(self:GetAttachment(12).Pos)
			self.bloater:SetAngles( self:GetAngles() + Angle(180,90,180) )
			self.bloater:SetParent(self, 12)
		end

		self.bloater:SetOwner(self)
		self.bloater:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.bloater:Spawn()
		self.bloater:Activate()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if self:IsOnFire() then
			return ACT_IDLE_ON_FIRE
		end
	elseif (act == ACT_RUN or act == ACT_WALK) && self:IsOnFire() then
		return ACT_WALK_ON_FIRE
	end
	return act
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 2)
		if randRange == 1 then
			self.MeleeAttackDamage = 15
			self.AnimTbl_MeleeAttack = {"attacka", "attackb", "attackc", "attackd"}
			self.TimeUntilMeleeAttackDamage = 0.8
			self.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack2.wav"}
		elseif randRange == 2 then
			self.MeleeAttackDamage = 30
			self.AnimTbl_MeleeAttack = {"attacke", "attackf"}
			self.TimeUntilMeleeAttackDamage = 0.9
			self.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack1.wav"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.9, 1)
		timer.Simple(3, function() if self:IsValid() && self:IsOnFire() then self.bloater:Explode(attacker) end end)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
	self.bloater:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if math.random(1,5) == 1 then
		self:VJ_ACT_PLAYACTIVITY("Tantrum",true,1,false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local effectdata = EffectData()
	effectdata:SetOrigin(dmginfo:GetDamagePosition())

	if hitgroup == HITGROUP_HEAD && dmginfo:GetDamageType() then
		dmginfo:ScaleDamage(0.01)
		util.Effect( "inflator_magic", effectdata )  
		VJ_EmitSound("npc/antlion/shell_impact1.wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup,corpseEnt)
	self:StopSound("npc/zombie/moan_loop1.wav")
	if dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_CLUB) then
			self:SetBodygroup(1,0)
			self.Headcrab = ents.Create("npc_armorhead_vj_cets")
			self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
			self.Headcrab:SetAngles(self:GetAngles())
			self.Headcrab:Spawn()
			self.Headcrab:Activate() 
			self.Headcrab:SetOwner(self)
			self:SetGroundEntity(NULL)
	end
end