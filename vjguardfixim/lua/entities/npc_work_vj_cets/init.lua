AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/workernpc.mdl"}
ENT.StartHealth = 50

ENT.Weapon_Accuracy = 10
ENT.Weapon_MinDistance = 2 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 400 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 200
ENT.UsePoseParameterMovement = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"pushplayer"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 0
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 60 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 120 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 20 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 20 -- How far does the damage go?

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 4
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_health_pen",
}

ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?
ENT.Elite_CanHaveManhack = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_9mmpistol")
	self:SetSkin(math.random(0, 2))
	if game.GetGlobalState("gordon_precriminal") == 1 then 
		self.Behavior = VJ_BEHAVIOR_NEUTRAL
		self.IdleAlwaysWander = true
		self.EnemyTouchDetection = true
		self.BecomeEnemyToPlayer = true
		self.AlliedWithPlayerAllies = true
		self.CanReceiveOrders = false
		self.FollowPlayer = false
		self.YieldToAlliedPlayers = false
		self:Give("weapon_vj_cets_nothing")
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 2 then
		if ent:IsPlayer() then
			self:PlaySoundSystem("Alert", sdAlertFreeman)
		return

		elseif ent.VJ_ID_Headcrab or ent:GetClass() == "CLASS_ZOMBIE" then
			self:PlaySoundSystem("Alert", sdAlertZombies)
		return

		elseif ent:GetClass() == "CLASS_FUNGUS" then
			self:PlaySoundSystem("Alert", sdAlertFungal)
		return

		elseif ent:GetClass() == "npc_stinger_vj_cets" or ent:GetClass() == "npc_stinger_r_vj_cets" then
			self:PlaySoundSystem("Alert", sdAlertStinger)
		return

		elseif ent:GetClass() == "npc_alyx" or ent.IsVJBaseSNPC_Human then
			self:PlaySoundSystem("Alert", sdAlertAC2)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() && CurTime() > self.NextDance then
		self:VJ_ACT_PLAYACTIVITY("idleonfire", true, true, true)
		self.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "idleonfire" ))
		self.Bleeds = false
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "idleonfire" )))
		timer.Simple(self:SequenceDuration(self:LookupSequence( "idleonfire" )), function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioDefaultZones = {
	"block",
	"zone",
	"sector",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioTrainZones = {
	"stationblock",
	"transitblock",
	"workforceintake",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioCanalZones = {
	"canalblock",
	"stormsystem",
	"wasteriver",
	"deservicedarea",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioEliZones = {
	"industrialzone",
	"restrictedblock",
	"repurposedarea",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioPhystownZones = {
	"condemnedzone",
	"infestedzone",
	"nonpatrolregion",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioCoastZones = {
	"externaljurisdiction",
	"stabilizationjurisdiction",
	"outlandzone",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioPrisonZones = {
	"externaljurisdiction",
	"stabilizationjurisdiction",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioC17Zones = {
	"residentialblock",
	"404zone",
	"distributionblock",
	"productionblock",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioCitadelZones = {
	"highpriorityregion",
	"terminalrestrictionzone",
	"controlsection",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioNumbers = {
	"zero",
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine"
}
---------------------------------------------------------------------------------------------------------------------------------------------
local RadioNames = {
	"defender",
	"hero",
	"jury",
	"king",
	"line",
	"patrol",
	"quick",
	"roller",
	"stick",
	"tap",
	"union",
	"victor",
	"xray",
	"yellow",
	"vice",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Default = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioDefaultZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioDefaultZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioDefaultZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Trainstation = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioTrainZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioTrainZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioTrainZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Canal = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCanalZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCanalZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCanalZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Eli = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioEliZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioEliZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioEliZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Ravenholm = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioPhystownZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioPhystownZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioPhystownZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Coast = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCoastZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCoastZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCoastZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Prison = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioPrisonZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioPrisonZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioPrisonZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_City = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioC17Zones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioC17Zones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioC17Zones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadio_Citadel = {
	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/teamsreportstatus.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdeserviced.wav",
		"npc/overwatch/radiovoice/remainingunitscontain.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNames) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCitadelZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCitadelZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/off2.wav",
	},

	{
		"npc/overwatch/radiovoice/on3.wav",
		"npc/overwatch/radiovoice/unitdownat.wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioCitadelZones) .. ".wav",
		"npc/overwatch/radiovoice/" .. table.Random(RadioNumbers) .. ".wav",
		"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
		"npc/overwatch/radiovoice/off2.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
local DeathRadioMaps = {
	["d1_trainstation_01"] = DeathRadio_Trainstation,
	["d1_trainstation_02"] = DeathRadio_Trainstation,
	["d1_trainstation_03"] = DeathRadio_Trainstation,
	["d1_trainstation_04"] = DeathRadio_Trainstation,
	["d1_trainstation_05"] = DeathRadio_Trainstation,
	["d1_trainstation_06"] = DeathRadio_Trainstation,

	["d1_canals_01"] = DeathRadio_Canal,
	["d1_canals_01a"] = DeathRadio_Canal,
	["d1_canals_02"] = DeathRadio_Canal,
	["d1_canals_03"] = DeathRadio_Canal,
	["d1_canals_04"] = DeathRadio_Canal,
	["d1_canals_05"] = DeathRadio_Canal,
	["d1_canals_06"] = DeathRadio_Canal,
	["d1_canals_07"] = DeathRadio_Canal,
	["d1_canals_08"] = DeathRadio_Canal,
	["d1_canals_09"] = DeathRadio_Canal,
	["d1_canals_10"] = DeathRadio_Canal,
	["d1_canals_11"] = DeathRadio_Canal,
	["d1_canals_12"] = DeathRadio_Canal,
	["d1_canals_13"] = DeathRadio_Canal,

	["d1_eli_01"] = DeathRadio_Eli,
	["d1_eli_02"] = DeathRadio_Eli,

	["d1_town_01"] = DeathRadio_Ravenholm,
	["d1_town_01a"] = DeathRadio_Ravenholm,
	["d1_town_02"] = DeathRadio_Ravenholm,
	["d1_town_02a"] = DeathRadio_Ravenholm,
	["d1_town_03"] = DeathRadio_Ravenholm,
	["d1_town_04"] = DeathRadio_Ravenholm,
	["d1_town_05"] = DeathRadio_Ravenholm,

	["d2_coast_01"] = DeathRadio_Coast,
	["d2_coast_02"] = DeathRadio_Coast,
	["d2_coast_03"] = DeathRadio_Coast,
	["d2_coast_04"] = DeathRadio_Coast,
	["d2_coast_05"] = DeathRadio_Coast,
	["d2_coast_06"] = DeathRadio_Coast,
	["d2_coast_07"] = DeathRadio_Coast,
	["d2_coast_08"] = DeathRadio_Coast,
	["d2_coast_09"] = DeathRadio_Coast,
	["d2_coast_10"] = DeathRadio_Coast,
	["d2_coast_11"] = DeathRadio_Coast,
	["d2_coast_12"] = DeathRadio_Coast,

	["d2_prison_01"] = DeathRadio_Prison,
	["d2_prison_02"] = DeathRadio_Prison,
	["d2_prison_03"] = DeathRadio_Prison,
	["d2_prison_04"] = DeathRadio_Prison,
	["d2_prison_05"] = DeathRadio_Prison,
	["d2_prison_06"] = DeathRadio_Prison,
	["d2_prison_05"] = DeathRadio_Prison,
	["d2_prison_06"] = DeathRadio_Prison,

	["d3_c17_01"] = DeathRadio_City,
	["d3_c17_02"] = DeathRadio_City,
	["d3_c17_03"] = DeathRadio_City,
	["d3_c17_04"] = DeathRadio_City,
	["d3_c17_05"] = DeathRadio_City,
	["d3_c17_06"] = DeathRadio_City,
	["d3_c17_06a"] = DeathRadio_City,
	["d3_c17_06b"] = DeathRadio_City,
	["d3_c17_05"] = DeathRadio_City,
	["d3_c17_06"] = DeathRadio_City,
	["d3_c17_07"] = DeathRadio_City,
	["d3_c17_08"] = DeathRadio_City,
	["d3_c17_09"] = DeathRadio_City,
	["d3_c17_10"] = DeathRadio_City,
	["d3_c17_10a"] = DeathRadio_City,
	["d3_c17_10b"] = DeathRadio_City,
	["d3_c17_11"] = DeathRadio_City,
	["d3_c17_12"] = DeathRadio_City,
	["d3_c17_12a"] = DeathRadio_City,
	["d3_c17_12b"] = DeathRadio_City,
	["d3_c17_13"] = DeathRadio_City,

	["d3_citadel_01"] = DeathRadio_Citadel,
	["d3_citadel_02"] = DeathRadio_Citadel,
	["d3_citadel_03"] = DeathRadio_Citadel,
	["d3_citadel_04"] = DeathRadio_Citadel,

	["d3_breen_01"] = DeathRadio_Citadel,

	["ep1_citadel_00"] = DeathRadio_Citadel,
	["ep1_citadel_01"] = DeathRadio_Citadel,
	["ep1_citadel_02"] = DeathRadio_Citadel,
	["ep1_citadel_02b"] = DeathRadio_Citadel,
	["ep1_citadel_03"] = DeathRadio_Citadel,
	["ep1_citadel_04"] = DeathRadio_Citadel,

	["ep1_c17_00"] = DeathRadio_City,
	["ep1_c17_00a"] = DeathRadio_City,
	["ep1_c17_01"] = DeathRadio_City,
	["ep1_c17_01b"] = DeathRadio_City,
	["ep1_c17_02"] = DeathRadio_City,
	["ep1_c17_02a"] = DeathRadio_City,
	["ep1_c17_02b"] = DeathRadio_City,
	["ep1_c17_03"] = DeathRadio_City,
	["ep1_c17_04"] = DeathRadio_City,
	["ep1_c17_05"] = DeathRadio_City,
	["ep1_c17_06"] = DeathRadio_City,
}
---------------------------------------------------------------------------------------------------------------------------------------------
local function GetDeathRadioTable()
	return DeathRadioMaps[game.GetMap()] or DeathRadio_Default
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function PlayDeathRadio(pos)
	local radioSet = GetDeathRadioTable()
	local chain = table.Random(radioSet)

	if not chain then return end

	local delay = 0

	for _, snd in ipairs(chain) do
		local duration = SoundDuration(snd)

		if duration <= 0 then
			duration = 2
		end

		timer.Simple(delay, function()
			sound.Play(snd, pos, 80, math.random(100, 105))
		end)

		delay = delay + duration
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hit_gr, rag)
	if self.PlayedDeathRadio then return end
	self.PlayedDeathRadio = true

	local myPos = self:GetPos()

	self:SetBodygroup(1, 0)

	if math.random(1, 2) == 1 then
		timer.Simple(3, function()
			PlayDeathRadio(myPos)
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local pistol = ents.Create("weapon_pistol")
		pistol:SetPos(att.Pos)
		pistol:SetAngles(att.Ang)
		pistol:Spawn()
	end
end