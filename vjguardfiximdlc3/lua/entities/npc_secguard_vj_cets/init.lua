AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 50
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

ENT.IsMedic = false

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = false

local mdlMal = {
	"models/humans/security/bm_guard2.mdl",
	"models/humans/security/bm_guard1.mdl",
	"models/humans/security/bm_barney.mdl",
}

local sdAlertComb = ENT.SoundTbl_DangerSight
local sdAlertCP = ENT.SoundTbl_DangerSight
local sdAlertZombies = ENT.SoundTbl_DangerSight
local sdAlertCrabs = ENT.SoundTbl_DangerSight
local sdAlertManhacks = ENT.SoundTbl_DangerSight
local sdAlertStrider = ENT.SoundTbl_DangerSight

local Sex_None = -1
local Sex_M = 1
local Sex_F = 2

ENT.Sex_Rand = Sex_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Model = mdlMal
	self:Give("weapon_vj_cets_glock")

	if GetConVar("npc_cets_barney_voice"):GetInt() == 1 then
		self:BarneySounds()
	else
		self:MaleSounds()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSkin(math.random(0, 12))
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

	self.gascan = ents.Create("base_anim")
	self.gascan:SetModel("models/misc/cube025x025x025.mdl")
	self.gascan:SetPos(self:GetPos() + self:GetUp() * 72 + self:GetRight() * -2)
	self.gascan:PhysicsInit( SOLID_VPHYSICS )
	self.gascan:SetMoveType( MOVETYPE_VPHYSICS )
	self.gascan:SetSolid( SOLID_VPHYSICS )
	self.gascan:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.gascan:SetParent(self, self:LookupAttachment( "eyes" ))
	self.gascan:SetAngles( self:GetAngles() + Angle(0,0,0) )
	self.gascan:SetOwner(self)
	self.gascan:SetNoDraw( true )
	self.gascan:DrawShadow( false )
	self.gascan:Spawn()
	self.gascan:Activate()

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", self.SoundTbl_Pain)
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
function ENT:OnAlert(ent)
	if math.random(1, 2) == 1 then
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
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAllyKilled(ent)
	if ent:IsPlayer() then
		self:PlaySoundSystem("AllyDeath", sdAllyDeathPly_M)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath( dmginfo, hit_gr, rag )
	self:SetBodygroup(1, 0)
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local glock = ents.Create("weapon_vj_cets_glock")
		glock:SetPos(att.Pos)
		glock:SetAngles(att.Ang)
		glock:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BarneySounds()
	self.SoundTbl_Idle = {
		"vo/npc/barney/whatisthat.wav",
		"vo/npc/barney/somethingstinky.wav",
		"vo/npc/barney/somethingdied.wav",
		"vo/npc/barney/guyresponsible.wav",
		"vo/npc/barney/coldone.wav",
		"vo/npc/barney/ba_gethev.wav",
		"vo/npc/barney/badfeeling.wav",
		"vo/npc/barney/bigmess.wav",
		"vo/npc/barney/bigplace.wav",
	}

	self.SoundTbl_IdleDialogue = {
		"vo/npc/barney/youeverseen.wav",
		"vo/npc/barney/workingonstuff.wav",
		"vo/npc/barney/whatsgoingon.wav",
		"vo/npc/barney/thinking.wav",
		"vo/npc/barney/survive.wav",
		"vo/npc/barney/stench.wav",
		"vo/npc/barney/somethingmoves.wav",
		"vo/npc/barney/nodrill.wav",
		"vo/npc/barney/missingleg.wav",
		"vo/npc/barney/luckwillturn.wav",
		"vo/npc/barney/gladof38.wav",
		"vo/npc/barney/gettingcloser.wav",
		"vo/npc/barney/crewdied.wav",
		"vo/npc/barney/badarea.wav",
		"vo/npc/barney/beertopside.wav",
	}


	self.SoundTbl_IdleDialogueAnswer = {
		"vo/npc/barney/yup.wav",
		"vo/npc/barney/youtalkmuch.wav",
		"vo/npc/barney/yougotit.wav",
		"vo/npc/barney/youbet.wav",
		"vo/npc/barney/yessir.wav", 
		"vo/npc/barney/soundsright.wav",
		"vo/npc/barney/noway.wav",
		"vo/npc/barney/nope.wav",
		"vo/npc/barney/nosir.wav",
		"vo/npc/barney/notelling.wav",
		"vo/npc/barney/maybe.wav",
		"vo/npc/barney/justdontknow.wav",
		"vo/npc/barney/ireckon.wav",
		"vo/npc/barney/iguess.wav",
		"vo/npc/barney/icanhear.wav",
		"vo/npc/barney/guyresponsible.wav",
		"vo/npc/barney/dontreckon.wav",
		"vo/npc/barney/dontguess.wav",
		"vo/npc/barney/dontfigure.wav",
		"vo/npc/barney/dontbuyit.wav",
		"vo/npc/barney/dontbet.wav",
		"vo/npc/barney/dontaskme.wav",
		"vo/npc/barney/cantfigure.wav",
		"vo/npc/barney/bequiet.wav",
		"vo/npc/barney/alreadyasked.wav",
	}

	self.SoundTbl_CombatIdle = {
		"vo/npc/barney/whatgood.wav",
		"vo/npc/barney/targetpractice.wav",
		"vo/npc/barney/easily.wav",
		"vo/npc/barney/getanyworse.wav",
	}

	self.SoundTbl_ReceiveOrder = false

	self.SoundTbl_FollowPlayer = {
		"vo/npc/barney/yougotit.wav",
		"vo/npc/barney/wayout.wav",
		"vo/npc/barney/teamup1.wav",
		"vo/npc/barney/teamup2.wav",
		"vo/npc/barney/rightway.wav",
		"vo/npc/barney/letsgo.wav",
		"vo/npc/barney/letsmoveit.wav",
		"vo/npc/barney/imwithyou.wav",
		"vo/npc/barney/gladtolendhand.wav",
		"vo/npc/barney/dobettertogether.wav",
	}

	self.SoundTbl_UnFollowPlayer = {
		"vo/npc/barney/waitin.wav",
		"vo/npc/barney/stop2.wav",
		"vo/npc/barney/standguard.wav",
		"vo/npc/barney/slowingyoudown.wav",
		"vo/npc/barney/seeya.wav",
		"vo/npc/barney/iwaithere.wav",
		"vo/npc/barney/illwait.wav",
		"vo/npc/barney/helpothers.wav",
		"vo/npc/barney/aintgoin.wav",
	}

	self.SoundTbl_YieldToPlayer = false

	self.SoundTbl_MedicBeforeHeal = false

	self.SoundTbl_OnPlayerSight = {
		"vo/npc/barney/mrfreeman.wav",
		"vo/npc/barney/howyoudoing.wav",
		"vo/npc/barney/howdy.wav",
		"vo/npc/barney/heybuddy.wav",
		"vo/npc/barney/heyfella.wav",
		"vo/npc/barney/hellonicesuit.wav",
		"vo/npc/barney/armedforces.wav",
	}

	self.SoundTbl_Investigate = {
		"vo/npc/barney/youhearthat.wav",
		"vo/npc/barney/soundsbad.wav",
		"vo/npc/barney/icanhear.wav",
		"vo/npc/barney/hearsomething2.wav",
		"vo/npc/barney/hearsomething.wav",
		"vo/npc/barney/ambush.wav",
	}

	self.SoundTbl_LostEnemy = {}

	self.SoundTbl_Alert = self.SoundTbl_DangerSight

	self.SoundTbl_CallForHelp = false

	self.SoundTbl_BecomeEnemyToPlayer = {
		"vo/npc/barney/ba_uwish.wav",
		"vo/npc/barney/ba_tomb.wav",
		"vo/npc/barney/ba_somuch.wav",
		"vo/npc/barney/ba_mad3.wav",
		"vo/npc/barney/ba_iwish.wav",
		"vo/npc/barney/ba_endline.wav",
		"vo/npc/barney/aintscared.wav",
	}

	self.SoundTbl_WeaponReload = false

	self.SoundTbl_GrenadeSight = false

	self.SoundTbl_DangerSight = {
		"vo/npc/barney/standback.wav",
		"vo/npc/barney/ba_attack1.wav",
	}

	self.SoundTbl_KilledEnemy = {
		"vo/npc/barney/soundsbad.wav",
		"vo/npc/barney/ba_seethat.wav",
		"vo/npc/barney/ba_kill0.wav",
		"vo/npc/barney/ba_gotone.wav",
		"vo/npc/barney/ba_firepl.wav",
		"vo/npc/barney/ba_buttugly.wav",
		"vo/npc/barney/ba_another.wav",
		"vo/npc/barney/ba_close.wav",
	}

	self.SoundTbl_AllyDeath = false

	self.SoundTbl_Pain = {
		"vo/npc/barney/imhit.wav",
		"vo/npc/barney/hitbad.wav",
		"vo/npc/barney/ba_pain1.wav",
		"vo/npc/barney/ba_pain2.wav",
		"vo/npc/barney/ba_pain3.wav",
	}

	self.SoundTbl_Death = {
		"vo/npc/barney/ba_die1.wav",
		"vo/npc/barney/ba_die2.wav",
		"vo/npc/barney/ba_die3.wav",
	}
end