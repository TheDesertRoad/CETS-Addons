AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_hazmat.mdl"}
ENT.StartHealth = 50
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 4
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 500 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 50
ENT.Weapon_CanCrouchAttack = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 5
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 200 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
}

ENT.Elite_CanHaveManhack = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_spas12")
	self:SetBodygroup( 2, math.random( 0, 3 ) )
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

	self.gascan = ents.Create("obj_vj_cets_gascan_x2")
	self.gascan:SetPos( self:GetPos() + self:GetForward() * -6 + self:GetUp() * 50 + self:GetRight() * 6 )
	self.gascan:SetAngles( self:GetAngles() + Angle(0,0,-90) )
	self.gascan:SetOwner(self)
	self.gascan:SetParent(self, self:LookupAttachment( "zipline" ))
	self.gascan:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.gascan:Spawn()
	self.gascan:Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_BeforeMeleeAttack, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Pain, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Death, sdFile) then return end
	VJ.EmitSound(self, "npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self, "npc/metropolice/vo/off" .. math.random(1, 4) .. ".wav") end end)
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
			sound.Play(snd, pos, 80, 100)
		end)

		delay = delay + duration
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hit_gr, rag)
	if self.PlayedDeathRadio then return end
	self.PlayedDeathRadio = true

	local myPos = self:GetPos()

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
		local shot = ents.Create("weapon_shotgun")
		shot:SetPos(att.Pos)
		shot:SetAngles(att.Ang)
		shot:Spawn()
	end
end