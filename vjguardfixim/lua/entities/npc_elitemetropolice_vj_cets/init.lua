AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/elitepolice.mdl"}
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.StartHealth = 70
ENT.ItemDropsOnDeathChance = 1
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy  = 3
ENT.Weapon_CanCrouchAttack = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false

ENT.MeleeAttackDamage = 10
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 50 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 100 -- How far it will push you forward | Second in math.random
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?

ENT.AnimTbl_MeleeAttack = {"pushplayer"} -- Melee Attack Animations

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
}

ENT.FootStepSoundLevel = 80
ENT.IdleSoundLevel = 85
ENT.IdleDialogueSoundLevel = 85
ENT.IdleDialogueAnswerSoundLevel = 85
ENT.CombatIdleSoundLevel = 90
ENT.InvestigateSoundLevel = 90
ENT.LostEnemySoundLevel = 85
ENT.AlertSoundLevel = 90
ENT.WeaponReloadSoundLevel = 90
ENT.GrenadeAttackSoundLevel = 90
ENT.OnGrenadeSightSoundLevel = 90
ENT.OnDangerSightSoundLevel = 90
ENT.OnKilledEnemySoundLevel = 90
ENT.AllyDeathSoundLevel = 90
ENT.PainSoundLevel = 90
ENT.DeathSoundLevel = 90

ENT.SoundTbl_FootStep = {
	"npc/metropolice/gear1.wav",
	"npc/metropolice/gear2.wav",
	"npc/metropolice/gear3.wav",
	"npc/metropolice/gear4.wav",
	"npc/metropolice/gear5.wav",
	"npc/metropolice/gear6.wav",
}

ENT.SoundTbl_Idle = {
	"npc/metropolice/vo/dispupdatingapb.wav",
	"npc/metropolice/vo/pickingupnoncorplexindy.wav",
	"npc/metropolice/vo/ten97suspectisgoa.wav",
	"npc/metropolice/vo/stillgetting647e.wav",
	"npc/metropolice/vo/404zone.wav",
	"npc/metropolice/vo/standardloyaltycheck.wav",
	"npc/metropolice/vo/anyonepickup647e.wav",
	"npc/metropolice/vo/blockisholdingcohesive.wav",
	"npc/metropolice/vo/checkformiscount.wav",
	"npc/metropolice/vo/catchthatbliponstabilization.wav",
	"npc/metropolice/vo/clearandcode100.wav",
	"npc/metropolice/vo/clearno647no10-107.wav",
	"npc/metropolice/vo/classifyasdbthisblockready.wav",
	"npc/metropolice/vo/control100percent.wav",
	"npc/metropolice/vo/cprequestsallunitsreportin.wav",
	"npc/metropolice/vo/dispreportssuspectincursion.wav",
	"npc/metropolice/vo/wegotadbherecancel10-102.wav",
	"npc/metropolice/vo/localcptreportstatus.wav",
	"npc/metropolice/vo/novisualonupi.wav",
	"npc/metropolice/vo/loyaltycheckfailure.wav",
}

ENT.SoundTbl_IdleDialogue = ENT.SoundTbl_Idle

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/metropolice/vo/rodgerthat.wav",
}

ENT.SoundTbl_Investigate = {
	"npc/metropolice/vo/requestsecondaryviscerator.wav",
	"npc/metropolice/vo/goingtotakealook.wav",
	"npc/metropolice/vo/movetoarrestpositions.wav",
	"npc/metropolice/vo/investigating10-103.wav",
	"npc/metropolice/vo/readytoamputate.wav",
	"npc/metropolice/vo/readytojudge.wav",
	"npc/metropolice/vo/preparingtojudge10-107.wav",
	"npc/metropolice/vo/prepareforjudgement.wav",
	"npc/metropolice/vo/possible10-103alerttagunits.wav",
	"npc/metropolice/vo/possible404here.wav",
	"npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav",
	"npc/metropolice/vo/possible647erequestairwatch.wav",
	"npc/metropolice/vo/positiontocontain.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/metropolice/vo/airwatchsubjectis505.wav",
	"npc/metropolice/vo/assaultpointsecureadvance.wav",
	"npc/metropolice/vo/breakhiscover.wav",
	"npc/metropolice/vo/covermegoingin.wav",
	"npc/metropolice/vo/destroythatcover.wav",
	"npc/metropolice/vo/firingtoexposetarget.wav",
	"npc/metropolice/vo/lockyourposition.wav",
	"npc/metropolice/vo/holdthisposition.wav",
	"npc/metropolice/vo/teaminpositionadvance.wav",
}

ENT.SoundTbl_Alert = {
	"npc/metropolice/vo/allunitscloseonsuspect.wav",
	"npc/metropolice/vo/allunitsmovein.wav",
	"npc/metropolice/vo/contactwith243suspect.wav",
	"npc/metropolice/vo/criminaltrespass63.wav",
	"npc/metropolice/vo/get11-44inboundcleaningup.wav",
	"npc/metropolice/vo/unlawfulentry603.wav",
	"npc/metropolice/vo/malcompliant10107my1020.wav",
	"npc/metropolice/vo/level3civilprivacyviolator.wav",
	"npc/metropolice/vo/ivegot408hereatlocation.wav",
	"npc/metropolice/vo/ihave10-30my10-20responding.wav",
	"npc/metropolice/vo/readytoprosecute.wav",
	"npc/metropolice/vo/priority2anticitizenhere.wav",
	"npc/metropolice/vo/gota10-107sendairwatch.wav",
}

ENT.SoundTbl_WeaponReload = {
	"npc/metropolice/vo/runninglowonverdicts.wav",
	"npc/metropolice/vo/backmeupimout.wav",
	"npc/metropolice/vo/movingtocover.wav",
	"npc/metropolice/vo/finalverdictadministered.wav",
}

ENT.SoundTbl_OnDangerSight = {
	"npc/metropolice/vo/lookout.wav",
	"npc/metropolice/vo/shit.wav",
	"npc/metropolice/vo/takecover.wav",
	"npc/metropolice/vo/getdown.wav",
}

ENT.SoundTbl_OnGrenadeSight = {
	"npc/metropolice/vo/thatsagrenade.wav",
	"npc/metropolice/vo/grenade.wav"
}

ENT.SoundTbl_OnKilledEnemy = {
	"npc/metropolice/vo/chuckle.wav",
	"npc/metropolice/vo/suspectisbleeding.wav",
	"npc/metropolice/vo/sentencedelivered.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/metropolice/vo/11-99officerneedsassistance.wav",
	"npc/metropolice/vo/wehavea10-108.wav",
	"npc/metropolice/vo/reinforcementteamscode3.wav",
	"npc/metropolice/vo/officerneedshelp.wav",
	"npc/metropolice/vo/officerunderfiretakingcover.wav",
	"npc/metropolice/vo/officerneedsassistance.wav",
	"npc/metropolice/vo/officerdowniam10-99.wav",
	"npc/metropolice/vo/officerdowncode3tomy10-20.wav",
	"npc/metropolice/vo/cpiscompromised.wav",
	"npc/metropolice/vo/cpisoverrunwehavenocontainment.wav",
	"npc/metropolice/vo/minorhitscontinuing.wav",
}

ENT.SoundTbl_LostEnemy = {
	"npc/metropolice/vo/hidinglastseenatrange.wav",
	"npc/metropolice/vo/hesgone148.wav",
	"npc/metropolice/vo/searchingforsuspect.wav",
	"npc/metropolice/vo/suspectlocationunknown.wav",
}

ENT.SoundTbl_Death = {
	"npc/metropolice/die1.wav",
	"npc/metropolice/die2.wav",
	"npc/metropolice/die3.wav",
	"npc/metropolice/die4.wav",
}

ENT.SoundTbl_Hurt = {"npc/metropolice/vo/help.wav"}

ENT.SoundTbl_Pain = {
	"npc/metropolice/pain1.wav",
	"npc/metropolice/pain2.wav",
	"npc/metropolice/pain3.wav",
	"npc/metropolice/pain4.wav",
	"npc/metropolice/vo/help.wav",
}

ENT.SoundTbl_RadioOn = {
 	"npc/metropolice/vo/on1.wav",
	"npc/metropolice/vo/on2.wav",
}

ENT.SoundTbl_RadioOff = {
	"npc/metropolice/vo/off1.wav",
	"npc/metropolice/vo/off2.wav",
	"npc/metropolice/vo/off3.wav",
	"npc/metropolice/vo/off4.wav",
}

local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}

local sdAlertFreeman = {
	"npc/metropolice/vo/noncitizen.wav",
	"npc/metropolice/vo/anticitizen.wav",
	"npc/metropolice/vo/matchonapblikeness.wav",
	"npc/metropolice/vo/holditrightthere.wav",
	"npc/metropolice/vo/freeman.wav",
	"npc/metropolice/vo/thereheis.wav",
	"npc/metropolice/vo/therehegoeshesat.wav",
}

local sdAlertZombies = {
	"npc/metropolice/vo/outbreak.wav",
	"npc/metropolice/vo/necrotics.wav",
	"npc/combine_soldier/vo/necroticsinbound.wav",
	"npc/combine_soldier/vo/wehavefreeparasites.wav",
	"npc/combine_soldier/vo/callcontactparasitics.wav",
	"npc/combine_soldier/vo/wehavenontaggedviromes.wav",
	"npc/combine_soldier/vo/weareinaninfestationzone.wav",
}

local sdAlertAliens = {
	"npc/combine_soldier/vo/outbreak.wav",
	"npc/combine_soldier/vo/swarmoutbreakinsector.wav",
	"npc/combine_soldier/vo/visualonexogens.wav",
	"npc/metropolice/vo/outlandbioticinhere.wav",
	"npc/metropolice/vo/infestedzone.wav",
}

local sdAlertAC2 = {
	"npc/metropolice/vo/priority2anticitizenhere.wav",
	"npc/metropolice/vo/noncitizen.wav",
	"npc/metropolice/vo/anticitizen.wav",
	"npc/metropolice/vo/allunitscloseonsuspect.wav",
}

local sdAlertFungal = {
	"npc/metropolice/vo/terminalrestrictionzone.wav",
	"npc/combine_soldier/vo/callcontactparasitics.wav",
	"npc/combine_soldier/vo/wehavenontaggedviromes.wav",
	"npc/combine_soldier/vo/weareinaninfestationzone.wav",
	"npc/metropolice/vo/infestedzone.wav",
}

ENT.Elite_CanHaveManhack = 1
ENT.Elite_HasManhack = false
ENT.Elite_Manhack = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_mp5k")
	if self.Elite_CanHaveManhack == 1 then
		self.Elite_HasManhack = true
		self:SetBodygroup(1, 1)
	end

	if game.GetGlobalState("gordon_precriminal") == 1 then 
		self.Behavior = VJ_BEHAVIOR_NEUTRAL
		self.IsGuard = true
		self.EnemyTouchDetection = true
		self.BecomeEnemyToPlayer = true
		self.AlliedWithPlayerAllies = true
		self.CanReceiveOrders = false
		self.FollowPlayer = false
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if ent:IsPlayer() then
		self:PlaySoundSystem("Alert", sdAlertFreeman)
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

	self:PlaySoundSystem("Alert", sdAlertAliens)

	if ent:Classify() == "CLASS_FUNGUS" then
		self:PlaySoundSystem("Alert", sdAlertFungal)
	end

	if ent:Classify() == "npc_alyx" then
		self:PlaySoundSystem("Alert", sdAlertAC2)

		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Deploy Manhack (if available)")
	
	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE && self.VJCE_NPC.Elite_HasManhack then
			self.VJCE_NPC:Elite_DeployManhack()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Elite_HasManhack && IsValid(self:GetEnemy()) then
		local eneData = self.EnemyData
		if eneData.Distance <= 1000 && eneData.Distance > 100 then
			self:Elite_DeployManhack()
		end
	end

	if self:IsOnFire() && CurTime() > self.NextDance then
		self:VJ_ACT_PLAYACTIVITY("idleonfire", true, true, true)
		self.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "idleonfire" ))
		self.Bleeds = false
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "idleonfire" )))
		timer.Simple(self:SequenceDuration(self:LookupSequence( "idleonfire" )), function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local getEventName = util.GetAnimEventNameByID
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(ev, evTime, evCycle, evType, evOptions)
	local eventName = getEventName(ev)
	if eventName == "AE_METROPOLICE_START_DEPLOY" then
		self:SetBodygroup(1, 0)
		local prop = ents.Create("prop_vj_animatable")
		prop:SetModel("models/manhack.mdl")
		prop:SetLocalPos(self:GetPos())
		prop:SetAngles(self:GetAngles())
		prop:SetParent(self)
		prop:Spawn()
		prop:Fire("SetParentAttachment", "anim_attachment_LH", 0)
		self.Elite_ManhackProp = prop
	elseif eventName == "AE_METROPOLICE_DEPLOY_MANHACK" then
		self:Elite_SpawnManhack()
	end
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
function ENT:Elite_DeployManhack()
	self.Elite_HasManhack = false
	self:PlayAnim("deploy", true, false, true)
	
	timer.Simple(3, function()
		if IsValid(self) && !IsValid(self.Metrocop_Manhack) then
			self:Elite_SpawnManhack()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ250 = Vector(0, 0, 250)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Elite_SpawnManhack()
	local manhack = ents.Create("npc_manhack")
	if IsValid(self.Elite_ManhackProp) then
		self.Elite_ManhackProp:Remove()
		manhack:SetPos(self.Elite_ManhackProp:GetPos())
		manhack:SetAngles(self.Elite_ManhackProp:GetAngles())
	else
		local att = self:GetAttachment(self:LookupAttachment("LHand"))
		manhack:SetPos(att.Pos)
		manhack:SetAngles(att.Ang)
	end
	manhack.VJ_NPC_Class = self.VJ_NPC_Class
	self:SetRelationshipMemory(manhack, VJ.MEM_OVERRIDE_DISPOSITION, D_LI)
	manhack:Spawn()
	manhack:GetPhysicsObject():AddVelocity(vecZ250)
	manhack:Fire("SetMaxLookDistance", self:GetMaxLookDistance())
	manhack:SetKeyValue("spawnflags", "65536")
	manhack:SetEnemy(self:GetEnemy())
	self.Metrocop_Manhack = manhack
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
		local mp5k = ents.Create("weapon_vj_cets_mp5k")
		mp5k:SetPos(att.Pos)
		mp5k:SetAngles(att.Ang)
		mp5k:Spawn()
	end
end