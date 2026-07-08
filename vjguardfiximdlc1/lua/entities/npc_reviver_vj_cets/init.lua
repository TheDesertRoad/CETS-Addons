AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_reviver.mdl"
ENT.StartHealth = GetConVar("sk_cets_reviver_health"):GetInt()
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HullType = HULL_TINY
ENT.CanChatMessage = false

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HeadcrabClassic.SpineControl",
    FirstP_Offset = Vector(3, 0, -1),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Blue"
ENT.BloodDecal = "VJ_CETS_BBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = "rhc_aggro_jumpattack_loop"
ENT.LeapAttackMaxDistance = 120
ENT.LeapAttackMinDistance = 0
ENT.TimeUntilLeapAttackDamage = 0.3
ENT.NextLeapAttackTime = 1
ENT.NextAnyAttackTime_Leap = 0.85
ENT.TimeUntilLeapAttackVelocity = 0.1
ENT.LeapAttackVelocityForward = 40
ENT.LeapAttackVelocityUp = 100
ENT.LeapAttackDamage = 10
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1}
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 20

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = "rhc_ability_spit"
ENT.RangeAttackEntityToSpawn = "obj_vj_electricspit" -- The entity that is spawned when range attacking
ENT.NextRangeAttackTime = 1.5 -- How much time until it can use a range attack? //2.33333
ENT.RangeDistance = 400 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 0 -- How close does it have to be until it uses melee?

ENT.HasExtraMeleeAttackSounds = true
ENT.FootstepSoundTimerRun = 0.2
ENT.FootstepSoundTimerWalk = 0.2

ENT.MainSoundPitch = 100
ENT.FootstepSoundLevel = 50

ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav", "npc/headcrab_poison/ph_step2.wav", "npc/headcrab_poison/ph_step3.wav", "npc/headcrab_poison/ph_step4.wav"}

ENT.SoundTbl_Idle = {
	"npc/reviver/idle_01.wav",
	"npc/reviver/idle_02.wav",
	"npc/reviver/idle_03.wav",
	"npc/reviver/idle_04.wav",
	"npc/reviver/idle_05.wav",
	"npc/reviver/idle_06.wav",
}

ENT.SoundTbl_LeapAttackJump = {
	"npc/reviver/taunt_screech_01.wav",
	"npc/reviver/taunt_screech_02.wav",
	"npc/reviver/taunt_screech_03.wav",
}

ENT.SoundTbl_Pain = {
	"npc/reviver/pain_01.wav",
	"npc/reviver/pain_02.wav",
	"npc/reviver/pain_03.wav",
	"npc/reviver/pain_04.wav",
	"npc/reviver/pain_05.wav",
	"npc/reviver/pain_06.wav",
}

ENT.SoundTbl_Death = {
	"npc/reviver/death.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/reviver/tail_shake_01.wav",
	"npc/reviver/tail_shake_02.wav",
	"npc/reviver/tail_shake_03.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/reviver/tail_shake_01.wav",
	"npc/reviver/tail_shake_02.wav",
	"npc/reviver/tail_shake_03.wav",
}

ENT.SoundTbl_Alert = {
	"npc/reviver/growl_01.wav",
	"npc/reviver/growl_02.wav",
}

ENT.SoundTbl_RangeAttack = {
	"npc/reviver/ranged_shoot_01.wav",
	"npc/reviver/ranged_shoot_02.wav",
	"npc/reviver/ranged_shoot_03.wav",
}

ENT.SoundTbl_LeapAttackDamage = "npc/headcrab/headbite.wav"

ENT.SoundTbl_BeforeRangeAttack = "npc/reviver/ranged_warning.wav"

ENT.SearchRadius = 256
ENT.ReviveRadius = 16
ENT.ReviveDelay = 1
ENT.NextScan = 0
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.ModelReplacementExact = {
	["models/combine_soldier.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/combine_super_soldier.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/police.mdl"] = "models/Zombie/classic.mdl",

	["models/mossman.mdl"] = "models/Zombie/burnzie.mdl",
	["models/alyx.mdl"] = "models/Zombie/burnzie.mdl",
	["models/Barney.mdl"] = "models/Zombie/burnzie.mdl",
	["models/breen.mdl"] = "models/Zombie/burnzie.mdl",
	["models/Eli.mdl"] = "models/Zombie/burnzie.mdl",
	["models/gman_high.mdl"] = "models/Zombie/burnzie.mdl",
	["models/Kleiner.mdl"] = "models/Zombie/burnzie.mdl",
	["models/monk.mdl"] = "models/Zombie/burnzie.mdl",
	["models/odessa.mdl"] = "models/Zombie/burnzie.mdl",
	["models/magnusson.mdl"] = "models/Zombie/burnzie.mdl",
	["models/lostcoast/fisherman/fisherman.mdl"] = "models/Zombie/burnzie.mdl",

	["models/Zombie/Classic.mdl"] = "models/zombie/classic.mdl",
	["models/Zombie/Fast.mdl"] = "models/Zombie/Fast.mdl",
	["models/Zombie/Poison.mdl"] = "models/Zombie/Poison.mdl",
	["models/Humans/corpse1.mdl"] = "models/Zombie/Fast.mdl",

	["models/combine_gasser.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/combine_hunter.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/combine_sniper.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/elitepolice.mdl"] = "models/Zombie/classic.mdl",
	["models/hl2_alienranger.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/hl2_combine_engineer.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/hl2_combine_grunt.mdl"] = "models/Zombie/zombie_hl2_combine_grunt.mdl",
	["models/hl2_combine_hazmat.mdl"] = "models/Zombie/zombie_hl2_combine_hazmat.mdl",
	["models/hl2_combine_medic.mdl"] = "models/Zombie/burnzie.mdl",
	["models/hl2_combine_ordinal.mdl"] = "models/Zombie/zordinal.mdl",
	["models/hl2_combine_spikewall_sized.mdl"] = "models/Zombie/zombie_hl2_combine_grunt.mdl",
	["models/hl2_combine_suppressor.mdl"] = "models/Zombie/zombie_hl2_combine_grunt.mdl",
	["models/hl2_combine_transitionperiod.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/hl2_combine_wallhammer.mdl"] = "models/Zombie/armored_zombie_charger.mdl",
	["models/hl2_fassassin.mdl"] = "models/Zombie/burnzie.mdl",
	["models/hl2_flamercomb_soldier.mdl"] = "models/zombie/zombie_soldier.mdl",
	["models/hl2_outfassassin.mdl"] = "models/Zombie/burnzie.mdl",
	["models/workernpc.mdl"] = "models/Zombie/armored.mdl",

	["models/Zombie/armored.mdl"] = "models/Zombie/armored.mdl",
	["models/Zombie/armored_zombie_charger.mdl"] = "models/Zombie/armored_zombie_charger.mdl",
	["models/Zombie/classic_armored.mdl"] = "models/Zombie/classic_armored.mdl",
	["models/Zombie/zombie_hl2_combine_grunt.mdl"] = "models/Zombie/zombie_hl2_combine_grunt.mdl",
	["models/Zombie/zombie_soldier_armored.mdl"] = "models/Zombie/zombie_soldier_armored.mdl",
	["models/hl2_jeff.mdl"] = "models/hl2_jeff.mdl",
	["models/hl2_gonome.mdl"] = "models/hl2_gonome.mdl",

	["models/hl2_consul.mdl"] = "models/Zombie/classic.mdl",
	["models/interloper_high.mdl"] = "models/Zombie/classic.mdl",
	["models/otis.mdl"] = "models/Zombie/classic.mdl",
	["models/headcrab_cultists/cultist_01.mdl"] = "models/Zombie/classic.mdl",
	["models/headcrab_cultists/player_cultist.mdl"] = "models/Zombie/classic.mdl",
}

ENT.ModelReplacementFolders = {
	{
		prefix = "models/humans/grunt",
		replacement = "models/Zombie/soldier_zombie.mdl",
	},

	{
		prefix = "models/humans/",
		replacement = "models/Zombie/classic.mdl",
	},

	{
		prefix = "models/player/",
		replacement = "models/Zombie/Fast.mdl",
	},
}

ENT.AllowedModelFolders = {
	"models/humans/",
	"models/humans/scientist",
	"models/player/",
}

ENT.AllowedExactModels = {
	["models/combine_soldier.mdl"] = true,
	["models/combine_super_soldier.mdl"] = true,
	["models/police.mdl"] = true,

	["models/mossman.mdl"] = true,
	["models/alyx.mdl"] = true,
	["models/Barney.mdl"] = true,
	["models/breen.mdl"] = true,
	["models/Eli.mdl"] = true,
	["models/gman_high.mdl"] = true,
	["models/Kleiner.mdl"] = true,
	["models/monk.mdl"] = true,
	["models/odessa.mdl"] = true,
	["models/magnusson.mdl"] = true,
	["models/lostcoast/fisherman/fisherman.mdl"] = true,

	["models/Zombie/Classic.mdl"] = true,
	["models/Zombie/Fast.mdl"] = true,
	["models/Zombie/Poison.mdl"] = true,

	["models/combine_gasser.mdl"] = true,
	["models/combine_hunter.mdl"] = true,
	["models/combine_sniper.mdl"] = true,
	["models/elitepolice.mdl"] = true,
	["models/hl2_alienranger.mdl"] = true,
	["models/hl2_combine_engineer.mdl"] = true,
	["models/hl2_combine_grunt.mdl"] = true,
	["models/hl2_combine_hazmat.mdl"] = true,
	["models/hl2_combine_medic.mdl"] = true,
	["models/hl2_combine_ordinal.mdl"] = true,
	["models/hl2_combine_spikewall_sized.mdl"] = true,
	["models/hl2_combine_suppressor.mdl"] = true,
	["models/hl2_combine_transitionperiod.mdl"] = true,
	["models/hl2_combine_wallhammer.mdl"] = true,
	["models/hl2_fassassin.mdl"] = true,
	["models/hl2_flamercomb_soldier.mdl"] = true,
	["models/hl2_outfassassin.mdl"] = true,
	["models/workernpc.mdl"] = true,

	["models/Zombie/armored.mdl"] = true,
	["models/Zombie/armored_zombie_charger.mdl"] = true,
	["models/Zombie/classic_armored.mdl"] = true,
	["models/Zombie/zombie_hl2_combine_grunt.mdl"] = true,
	["models/Zombie/zombie_soldier_armored.mdl"] = true,
	["models/hl2_jeff.mdl"] = true,
	["models/hl2_gonome.mdl"] = true,

	["models/hl2_consul.mdl"] = true,
	["models/interloper_high.mdl"] = true,
	["models/otis.mdl"] = true,
	["models/headcrab_cultists/cultist_01.mdl"] = true,
	["models/headcrab_cultists/player_cultist.mdl"] = true,
}

ENT.ModelSkinOverrides = {
	["models/combine_soldier.mdl"] = 0,
	["models/combine_super_soldier.mdl"] = 3,
	["models/police.mdl"] = 6,
	["models/elitepolice.mdl"] = 6,
	["models/otis.mdl"] = 6,

	["models/elitepolice.mdl"] = 6,
	["models/otis.mdl"] = 6,

	["models/mossman.mdl"] = 0,
	["models/alyx.mdl"] = 0,
	["models/barney.mdl"] = 0,
	["models/breen.mdl"] = 0,
}

ENT.ModelSkinFolderOverrides = {
	{
		prefix = "models/humans/Group01",
		skin = 1
	},

	{
		prefix = "models/humans/Group02",
		skin = 0
	},

	{
		prefix = "models/humans/Group03",
		skin = 3
	},

	{
		prefix = "models/humans/Group03m",
		skin = 4
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 10, 15), Vector(-8, -10, 0))

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
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

	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
		self.IsGuard = true
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self:PlayAnim({"rhc_injured_walk"}, true, false, true)
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(1.5)
		self:SetGravity(0)
		self:SetGravity(1)
	end

	if CurTime() < (self.NextScan or 0) then return end
	self.NextScan = CurTime() + 1

	local searchRadius = self.SearchRadius
	local reviveRadius = self.ReviveRadius

	local myPos = self:GetPos()

	local nearestCorpse = nil
	local nearestDist = math.huge

	for _, ent in ipairs(ents.FindInSphere(myPos, searchRadius)) do
		if self:CanRevive(ent) then
			local dist = myPos:DistToSqr(ent:GetPos())

		if dist < nearestDist then
			nearestDist = dist
			nearestCorpse = ent
			end
		end
	end

	if IsValid(nearestCorpse) then
		self:SetLastPosition(nearestCorpse:GetPos())
		self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
	end

	if IsValid(nearestCorpse) then
		local distToCorpse = myPos:DistToSqr(nearestCorpse:GetPos())
		if distToCorpse <= (reviveRadius * reviveRadius) then
			self:ReviveCorpse(nearestCorpse)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if not dmginfo:IsDamageType(DMG_PHYSGUN) then return end

	local ply = dmginfo:GetAttacker()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	local dir = ply:GetAimVector()

	local velocity =
		(dir * 1200) +   -- forward force
		Vector(0, 0, 220) -- slight lift

	self:SetVelocity(velocity)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 20 + self:GetForward() * 30
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function IsValidCorpse(ent)
	if not IsValid(ent) then return false end

	local class = ent:GetClass()
	if class == "prop_ragdoll" then return true end

	if ent.VJ_IsCorpse or ent.IsVJBaseCorpse then
		return true
	end

	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function StartsWith(str, prefix)
	return string.sub(str, 1, #prefix) == prefix
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsModelAllowed(mdl)
	if not mdl then return false end
	mdl = string.lower(mdl)

	if self.AllowedExactModels[mdl] then
		return true
	end

	for _, folder in ipairs(self.AllowedModelFolders) do
		if StartsWith(mdl, folder) then
			return true
		end
	end

	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function StartsWith(str, prefix)
	return string.sub(str, 1, #prefix) == prefix
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetReplacedSkin(mdl, corpse)
	if not mdl then return 0 end
	mdl = string.lower(mdl)

	if self.ModelSkinOverrides[mdl] ~= nil then
		return self.ModelSkinOverrides[mdl]
	end

	for _, data in ipairs(self.ModelSkinFolderOverrides or {}) do
		if StartsWith(mdl, string.lower(data.prefix)) then
			return data.skin or 0
		end
	end

	if IsValid(corpse) then
		return corpse:GetSkin() or 0
	end

	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetReplacedModel(mdl) 
	if not mdl then return nil end mdl = string.lower(mdl)

	if self.ModelReplacementExact[mdl] then 
		return self.ModelReplacementExact[mdl] 
	end 

	for _, data in ipairs(self.ModelReplacementFolders) do 
		if StartsWith(mdl, data.prefix) then 
				return data.replacement 
			end 
		end 
	return mdl 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanRevive(ent)
	if not IsValidCorpse(ent) then return false end

	local mdl = string.lower(ent:GetModel() or "")
	if not self:IsModelAllowed(mdl) then return false end

	if ent.RevivedByVJReanimator then return false end

	return true
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ReviveCorpse(corpse)
	if not IsValid(corpse) then return end
	if corpse.RevivedByVJReanimator then return end

	corpse.RevivedByVJReanimator = true

	local mdl = string.lower(corpse:GetModel() or "")
	local pos = corpse:GetPos()
	local ang = corpse:GetAngles()

	timer.Simple(0.1, function()
		if IsValid(self) then
			self:VJ_ACT_PLAYACTIVITY("zombie_reviver_activate_host_infest",true,3.6,false)
			VJ_EmitSound(self, "npc/reviver/host_choose.wav", 80, 100)
			VJ_EmitSound(self, "npc/reviver/host_submerge_0" .. math.random(1, 2) .. ".wav", 90, 100)

			ParticleEffect("blood_advisor_pierce_spray",self:GetPos(),Angle(0,0,0),nil)
		end
	end)

	timer.Simple(self.ReviveDelay, function()
		if not IsValid(corpse) then return end

		local npc = ents.Create("npc_reviverzom_vj_cets")
		if not IsValid(npc) then
			corpse.RevivedByVJReanimator = nil
			return
		end

		npc:SetPos(pos)
		npc:SetAngles(ang)
		//npc:SetModel(corpse:GetModel(mdl))
		npc:SetModel(self:GetReplacedModel(mdl))
		npc:SetSkin(self:GetReplacedSkin(mdl, corpse))

		npc:Spawn()
		npc:Activate()

		if npc.VJ_DoSetEnemy then
			npc:VJ_DoSetEnemy(nil)
		end

		corpse:Remove()

		-- remove reanimator only AFTER success
		if IsValid(self) then
			self:Remove()
		end
	end)
end