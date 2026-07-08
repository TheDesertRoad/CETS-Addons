AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 100
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_PLAYER_ALLY_VITAL"}

local Weapon_None = -1
local Weapon_MP5K = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None

local sdAlertComb = {
	"npc/otis/ot_soldiers.wav",
}

local sdAlertCP = {
	"npc/otis/ot_uhohheretheycome.wav",
}

local sdAlertZombies = {
	"npc/otis/ot_uhohheretheycome.wav",
	"npc/otis/ot_ohshit03.wav",
	"npc/otis/ot_openfiregord.wav",
}

local sdAlertCrabs = {
	"npc/otis/ot_headhumpers.wav",
}

local sdAlertManhacks = {
	"npc/otis/ot_uhohheretheycome.wav",
	"npc/otis/ot_ohshit03.wav",
	"npc/otis/ot_openfiregord.wav",
}

local sdAlertStrider = {
	"npc/otis/ot_ohshit03.wav",
	"npc/otis/ot_openfiregord.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Weapon_Rand = 1
	self.Model = "models/otis.mdl"
	self:FattySounds()
	self:Give("weapon_vj_cets_ar2")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", SoundTbl_Pain )
	end

	if self:Health() > 0 && dmginfo:IsDamageType(DMG_NERVEGAS) then
		self.Bleeds = false
	end

	if status == "PostDamage" && self:Health() > 0 && math.random(1, 2) == 1 then
		if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			self:PlaySoundSystem("Pain", sdPainArm_M)
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			self:PlaySoundSystem("Pain", sdPainLeg_M)
		elseif hitgroup == HITGROUP_STOMACH then
			self:PlaySoundSystem("Pain", sdPainGut_M)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
	else
		self.HasIdleSounds = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ar2 = ents.Create("weapon_ar2")
		ar2:SetPos(att.Pos)
		ar2:SetAngles(att.Ang)
		ar2:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FattySounds()
	self.SoundTbl_CombatIdle = {
		"vo/npc/otis/ot_goingdown.wav",
		"vo/npc/otis/ot_damnit.wav",
		"vo/npc/otis/ot_covermegord.wav",
	}

	self.SoundTbl_ReceiveOrder = {
		"vo/npc/otis/ot_imwithyou.wav",
	}

	self.SoundTbl_FollowPlayer = {
		"vo/npc/otis/ot_imwithyou.wav",
		"vo/npc/otis/ot_letsgo.wav",
		"vo/npc/otis/ot_letsdoit.wav",
		"vo/npc/otis/ot_oldtimes.wav",
	}

	self.SoundTbl_UnFollowPlayer = {
		"vo/npc/otis/ot_hurryup.wav",
		"vo/npc/otis/ot_donttakelong.wav",
	}

	self.SoundTbl_OnPlayerSight = {
		"vo/npc/otis/ot_followme01.wav",
		"vo/npc/otis/ot_followme02.wav",
		"vo/npc/otis/ot_followme03.wav",
		"vo/npc/otis/ot_followme05.wav",
	}

	self.SoundTbl_Investigate = {
		"vo/npc/otis/ot_danger01.wav",
		"vo/npc/otis/ot_danger02.wav",
	}

	self.SoundTbl_LostEnemy = {
		"vo/npc/otis/ot_damnit.wav",
	}

	self.SoundTbl_Alert = {
		"vo/npc/otis/ot_bringiton.wav",
		"vo/npc/otis/ot_hereitcomes.wav",
		"vo/npc/otis/ot_heretheycome01.wav",
		"vo/npc/otis/ot_heretheycome02.wavv",
		"vo/npc/otis/ot_openfiregord.wav",
		"vo/npc/otis/ot_uhohheretheycome.wav",
	}

	self.SoundTbl_CallForHelp = {
		"vo/npc/otis/ot_gordonhelp.wav",
		"vo/npc/otis/ot_littlehelphere.wav",
	}

	self.SoundTbl_BecomeEnemyToPlayer = {
		"vo/npc/otis/ot_getoutofway.wav"
	}

	self.SoundTbl_Suppressing = {
		"vo/npc/otis/ot_getoutofway.wav",
	}

	self.SoundTbl_WeaponReload = {
		"vo/npc/otis/ot_covermegord.wav",
		"vo/npc/otis/ot_damnit.wav",
		"vo/npc/otis/ot_lookout.wav",
	}

	self.SoundTbl_GrenadeSight = {
		"vo/npc/otis/ot_damnit.wav",
		"vo/npc/otis/ot_duck.wav",
		"vo/npc/otis/ot_getaway.wav",
		"vo/npc/otis/ot_getdown.wav",
		"vo/npc/otis/ot_getoutofway.wav",
		"vo/npc/otis/ot_grenade01.wav",
		"vo/npc/otis/ot_grenade02.wav",
		"vo/npc/otis/ot_lookout.wav",
	}

	self.SoundTbl_DangerSight = {
		"vo/npc/otis/ot_damnit.wav",
		"vo/npc/otis/ot_duck.wav",
		"vo/npc/otis/ot_getaway.wav",
		"vo/npc/otis/ot_getdown.wav",
		"vo/npc/otis/ot_getoutofway.wav",
		"vo/npc/otis/ot_grenade01.wav",
		"vo/npc/otis/ot_grenade02.wav",
		"vo/npc/otis/ot_lookout.wav",
	}

	self.SoundTbl_KilledEnemy = {
		"vo/npc/otis/ot_downyougo.wav",
		"vo/npc/otis/ot_gotone.wav",
		"vo/npc/otis/ot_laugh01.wav",
		"vo/npc/otis/ot_laugh02.wav",
		"vo/npc/otis/ot_laugh03.wav",
		"vo/npc/otis/ot_laugh04.wav",
		"vo/npc/otis/ot_losttouch.wav",
		"vo/npc/otis/ot_ohyeah.wav",
		"vo/npc/otis/ot_yell.wav",
	}

	self.SoundTbl_Pain = {
		"vo/npc/otis/ot_damnit.wav",
		"vo/npc/otis/ot_pain01.wav",
		"vo/npc/otis/ot_pain02.wav",
		"vo/npc/otis/ot_pain03.wav",
		"vo/npc/otis/ot_pain04.wav",
		"vo/npc/otis/ot_pain05.wav",
		"vo/npc/otis/ot_pain06.wav",
		"vo/npc/otis/ot_pain07.wav",
		"vo/npc/otis/ot_pain08.wav",
		"vo/npc/otis/ot_pain09.wav",
		"vo/npc/otis/ot_pain10.wav",
		"vo/npc/otis/ot_wounded01.wav",
		"vo/npc/otis/ot_wounded02.wav",
		"vo/npc/otis/ot_wounded03.wav",
	}

	self.SoundTbl_DamageByPlayer = {
		"vo/npc/otis/ot_damnit.wav",
		"vo/npc/otis/ot_pain01.wav",
		"vo/npc/otis/ot_pain02.wav",
		"vo/npc/otis/ot_pain03.wav",
		"vo/npc/otis/ot_pain04.wav",
		"vo/npc/otis/ot_pain05.wav",
		"vo/npc/otis/ot_pain06.wav",
		"vo/npc/otis/ot_pain07.wav",
		"vo/npc/otis/ot_pain08.wav",
		"vo/npc/otis/ot_pain09.wav",
		"vo/npc/otis/ot_pain10.wav",
	}

	self.SoundTbl_Death = {
		"vo/npc/otis/ot_no02.wav",
		"vo/npc/otis/ot_no01.wav",
		"vo/npc/otis/ot_ohshit03.wav",
	}
end