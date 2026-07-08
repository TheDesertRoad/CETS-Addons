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
ENT.Weapon_Accuracy = 3
ENT.Weapon_CanCrouchAttack = true -- Can it crouch while firing a weapon?
ENT.Weapon_CrouchAttackChance = 1
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 2000 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 0
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

ENT.AnimTbl_MeleeAttack = "meleeattack01" -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 10
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"throw1"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.GrenadeAttackEntity = "npc_grenade_frag" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.ThrowGrenadeChance = 2 -- Chance that it will throw the grenade | Set to 1 to throw all the time

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
ENT.ItemDropsOnDeath_EntityList = {
	"item_health_pen",
}

ENT.CanBeMedic = false

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

ENT.SoundTbl_FootStep = "npc/combine_soldier/vo/_period.wav"

local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}

local sdAlertComb = {
	"vo/npc/male01/combine01.wav",
	"vo/npc/male01/combine02.wav",
}

local sdAlertCP = {
	"vo/npc/male01/cps01.wav",
	"vo/npc/male01/civilprotection01.wav",
	"vo/npc/male01/cps02.wav",
	"vo/npc/male01/civilprotection02.wav",
}

local sdAlertZombies = {
	"vo/npc/male01/zombies01.wav",
	"vo/npc/male01/zombies02.wav",
}

local sdAlertCrabs = {
	"vo/npc/male01/headcrabs01.wav",
	"vo/npc/male01/headcrabs02.wav",
}

local sdAlertManhacks = {
	"vo/npc/male01/hacks01.wav",
	"vo/npc/male01/hacks02.wav",
	"vo/npc/male01/itsamanhack01.wav",
	"vo/npc/male01/itsamanhack02.wav",
}

local sdAlertStrider = {
	"vo/npc/male01/strider.wav",
	"vo/npc/male01/strider_run.wav",
}

local sdAlertCombF = {
	"vo/npc/male01/combine01.wav",
	"vo/npc/male01/combine02.wav",
}

local sdAlertCPF = {
	"vo/npc/male01/cps01.wav",
	"vo/npc/male01/civilprotection01.wav",
	"vo/npc/male01/cps02.wav",
	"vo/npc/male01/civilprotection02.wav",
}

local sdAlertZombiesF = {
	"vo/npc/male01/zombies01.wav",
	"vo/npc/male01/zombies02.wav",
}

local sdAlertCrabsF = {
	"vo/npc/male01/headcrabs01.wav",
	"vo/npc/male01/headcrabs02.wav",
}

local sdAlertManhacksF = {
	"vo/npc/male01/hacks01.wav",
	"vo/npc/male01/hacks02.wav",
	"vo/npc/male01/itsamanhack01.wav",
	"vo/npc/male01/itsamanhack02.wav",
}

local sdAlertStriderF = {
	"vo/npc/male01/strider.wav",
	"vo/npc/male01/strider_run.wav",
}

ENT.NextDance = 0

local mdlNormal = {
	"models/humans/conscripts/male_02.mdl",
	"models/humans/conscripts/male_07.mdl",
	"models/humans/conscripts/male_09.mdl",
}

local mdlShotgunner = "models/humans/conscripts/male_masked.mdl"

local MaleFirePain = {
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/no02.wav",
	"vo/npc/male01/ow01.wav",
	"vo/npc/male01/ow02.wav",
}

local FemaleFirePain = {
	"vo/npc/female01/no01.wav",
	"vo/npc/female01/no02.wav",
	"vo/npc/female01/ow01.wav",
	"vo/npc/female01/ow02.wav",
}

local sdGiveAmmo_M = {
	"vo/npc/male01/ammo01.wav",
	"vo/npc/male01/ammo02.wav",
	"vo/npc/male01/ammo03.wav",
	"vo/npc/male01/ammo04.wav",
	"vo/npc/male01/ammo05.wav",
}

local sdSuggestReloadPly_M = {
	"vo/npc/male01/dontforgetreload01.wav",
	"vo/npc/male01/reloadfm01.wav",
	"vo/npc/male01/reloadfm02.wav",
	"vo/npc/male01/youdbetterreload01.wav",
}

local sdPainArm_M = {
	"vo/npc/male01/myarm01.wav",
	"vo/npc/male01/myarm02.wav",
}

local sdPainLeg_M = {
	"vo/npc/male01/myleg01.wav",
	"vo/npc/male01/myleg02.wav",
}

local sdPainGut_M = {
	"vo/npc/male01/hitingut01.wav",
	"vo/npc/male01/hitingut02.wav",
	"vo/npc/male01/mygut02.wav",
}

local sdAllyDeathPly_M = {
	"vo/npc/male01/gordead_ans01.wav",
	"vo/npc/male01/gordead_ans02.wav",
	"vo/npc/male01/gordead_ans03.wav",
	"vo/npc/male01/gordead_ans04.wav",
	"vo/npc/male01/gordead_ans05.wav",
	"vo/npc/male01/gordead_ans06.wav",
	"vo/npc/male01/gordead_ans07.wav",
	"vo/npc/male01/gordead_ans08.wav",
	"vo/npc/male01/gordead_ans09.wav",
	"vo/npc/male01/gordead_ans10.wav",
	"vo/npc/male01/gordead_ans11.wav",
	"vo/npc/male01/gordead_ans12.wav",
	"vo/npc/male01/gordead_ans13.wav",
	"vo/npc/male01/gordead_ans14.wav",
	"vo/npc/male01/gordead_ans15.wav",
	"vo/npc/male01/gordead_ans16.wav",
	"vo/npc/male01/gordead_ans17.wav",
	"vo/npc/male01/gordead_ans18.wav",
	"vo/npc/male01/gordead_ans19.wav",
	"vo/npc/male01/gordead_ans20.wav",
	"vo/npc/male01/gordead_ques01.wav",
	"vo/npc/male01/gordead_ques02.wav",
	"vo/npc/male01/gordead_ques03.wav",
	"vo/npc/male01/gordead_ques04.wav",
	"vo/npc/male01/gordead_ques05.wav",
	"vo/npc/male01/gordead_ques06.wav",
	"vo/npc/male01/gordead_ques07.wav",
	"vo/npc/male01/gordead_ques08.wav",
	"vo/npc/male01/gordead_ques09.wav",
	"vo/npc/male01/gordead_ques10.wav",
	"vo/npc/male01/gordead_ques11.wav",
	"vo/npc/male01/gordead_ques12.wav",
	"vo/npc/male01/gordead_ques13.wav",
	"vo/npc/male01/gordead_ques14.wav",
	"vo/npc/male01/gordead_ques15.wav",
	"vo/npc/male01/gordead_ques16.wav",
	"vo/npc/male01/gordead_ques17.wav",
}

local sdGiveAmmo_F = {
	"vo/npc/female01/ammo01.wav",
	"vo/npc/female01/ammo02.wav",
	"vo/npc/female01/ammo03.wav",
	"vo/npc/female01/ammo04.wav",
	"vo/npc/female01/ammo05.wav",
}
local sdSuggestReloadPly_F = {
	"vo/npc/female01/dontforgetreload01.wav",
	"vo/npc/female01/reloadfm01.wav",
	"vo/npc/female01/reloadfm02.wav",
	"vo/npc/female01/youdbetterreload01.wav",
}

local sdPainArm_F = {
	"vo/npc/female01/myarm01.wav",
	"vo/npc/female01/myarm02.wav",
}

local sdPainLeg_F = {
	"vo/npc/female01/myleg01.wav",
	"vo/npc/female01/myleg02.wav",
}

local sdPainGut_F = {
	"vo/npc/female01/hitingut01.wav",
	"vo/npc/female01/hitingut02.wav",
	"vo/npc/female01/mygut02.wav",
}

local sdAllyDeathPly_F = {
	"vo/npc/female01/gordead_ans01.wav",
	"vo/npc/female01/gordead_ans02.wav",
	"vo/npc/female01/gordead_ans03.wav",
	"vo/npc/female01/gordead_ans04.wav",
	"vo/npc/female01/gordead_ans05.wav",
	"vo/npc/female01/gordead_ans06.wav",
	"vo/npc/female01/gordead_ans07.wav",
	"vo/npc/female01/gordead_ans08.wav",
	"vo/npc/female01/gordead_ans09.wav",
	"vo/npc/female01/gordead_ans10.wav",
	"vo/npc/female01/gordead_ans11.wav",
	"vo/npc/female01/gordead_ans12.wav",
	"vo/npc/female01/gordead_ans13.wav",
	"vo/npc/female01/gordead_ans14.wav",
	"vo/npc/female01/gordead_ans15.wav",
	"vo/npc/female01/gordead_ans16.wav",
	"vo/npc/female01/gordead_ans17.wav",
	"vo/npc/female01/gordead_ans18.wav",
	"vo/npc/female01/gordead_ans19.wav",
	"vo/npc/female01/gordead_ans20.wav",
	"vo/npc/female01/gordead_ques01.wav",
	"vo/npc/female01/gordead_ques02.wav",
	"vo/npc/female01/gordead_ques03.wav",
	"vo/npc/female01/gordead_ques04.wav",
	"vo/npc/female01/gordead_ques05.wav",
	"vo/npc/female01/gordead_ques06.wav",
	"vo/npc/female01/gordead_ques07.wav",
	"vo/npc/female01/gordead_ques08.wav",
	"vo/npc/female01/gordead_ques09.wav",
	"vo/npc/female01/gordead_ques10.wav",
	"vo/npc/female01/gordead_ques11.wav",
	"vo/npc/female01/gordead_ques12.wav",
	"vo/npc/female01/gordead_ques13.wav",
	"vo/npc/female01/gordead_ques14.wav",
	"vo/npc/female01/gordead_ques15.wav",
	"vo/npc/female01/gordead_ques16.wav",
	"vo/npc/female01/gordead_ques17.wav",
}

local Weapon_None = -1
local Weapon_MP5K = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	local flags = self:GetSpawnFlags()

	if bit.band(flags, 64) ~= 0 or self:HasSpawnFlags(64) then
		self.Weapon_Rand = 1
		self.Model = mdlNormal
		self:MaleSounds()
		self:Give("weapon_vj_cets_mp5k")

	elseif bit.band(flags, 128) ~= 0 or self:HasSpawnFlags(128) then
		self.Weapon_Rand = 2
		self.Model = mdlShotgunner
		self:MaleSounds()
		self:Give("weapon_vj_cets_spas12")

	else
		if math.random(1,2) == 1 then
			self.Weapon_Rand = 1
			self.Model = mdlNormal
			self:MaleSounds()
			self:Give("weapon_vj_cets_mp5k")
		else
			self.Weapon_Rand = 2
			self.Model = mdlShotgunner
			self:MaleSounds()
			self:Give("weapon_vj_cets_spas12")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetBodygroup( 1, math.random( 0, 3 ) )
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

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
local SurfaceFootsteps = {
	[MAT_CONCRETE] = {
		"player/footsteps/concrete1.wav",
		"player/footsteps/concrete2.wav",
		"player/footsteps/concrete3.wav",
		"player/footsteps/concrete4.wav",
	},

	[MAT_DIRT] = {
		"player/footsteps/dirt1.wav",
		"player/footsteps/dirt2.wav",
		"player/footsteps/dirt3.wav",
		"player/footsteps/dirt4.wav",
	},

	[MAT_GRASS] = {
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav",
	},

	[MAT_METAL] = {
		"player/footsteps/metal1.wav",
		"player/footsteps/metal2.wav",
		"player/footsteps/metal3.wav",
		"player/footsteps/metal4.wav",
	},

	[MAT_SAND] = {
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav",
	},

	[MAT_WOOD] = {
		"player/footsteps/wood1.wav",
		"player/footsteps/wood2.wav",
		"player/footsteps/wood3.wav",
		"player/footsteps/wood4.wav",
	},

	[MAT_TILE] = {
		"player/footsteps/tile1.wav",
		"player/footsteps/tile2.wav",
		"player/footsteps/tile3.wav",
		"player/footsteps/tile4.wav",
	},

	[MAT_VENT] = {
		"player/footsteps/duct1.wav",
		"player/footsteps/duct2.wav",
		"player/footsteps/duct3.wav",
		"player/footsteps/duct4.wav",
	},

	[MAT_GRATE] = {
		"player/footsteps/metalgrate1.wav",
		"player/footsteps/metalgrate2.wav",
		"player/footsteps/metalgrate3.wav",
		"player/footsteps/metalgrate4.wav",
	},

	[MAT_GRATE] = {
		"player/footsteps/metalgrate1.wav",
		"player/footsteps/metalgrate2.wav",
		"player/footsteps/metalgrate3.wav",
		"player/footsteps/metalgrate4.wav",
	},

	[MAT_GLASS] = {
		"player/footsteps/woodpanel1.wav",
		"player/footsteps/woodpanel2.wav",
		"player/footsteps/woodpanel3.wav",
		"player/footsteps/woodpanel4.wav",
	},

	[MAT_CLIP] = {
		"player/footsteps/woodpanel1.wav",
		"player/footsteps/woodpanel2.wav",
		"player/footsteps/woodpanel3.wav",
		"player/footsteps/woodpanel4.wav",
	},

	[MAT_EGGSHELL] = {
		"player/footsteps/woodpanel1.wav",
		"player/footsteps/woodpanel2.wav",
		"player/footsteps/woodpanel3.wav",
		"player/footsteps/woodpanel4.wav",
	},

	[MAT_WARPSHIELD] = {
		"player/footsteps/woodpanel1.wav",
		"player/footsteps/woodpanel2.wav",
		"player/footsteps/woodpanel3.wav",
		"player/footsteps/woodpanel4.wav",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayFootstepSound(customSD)
	local metaEntity = FindMetaTable("Entity")
	local PICK = VJ.PICK
	local funcGetTable = metaEntity.GetTable
	local selfData = funcGetTable(self)
	if selfData.HasSounds && selfData.HasFootstepSounds && selfData.MovementType != VJ_MOVETYPE_STATIONARY && self:IsOnGround() then
		if selfData.DisableFootStepSoundTimer then
			-- Use custom table if available, if none found then use the footstep sound table
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0, 0, 5),
		endpos = self:GetPos() - Vector(0, 0, 40),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY
	})

	local tbl = SurfaceFootsteps[tr.MatType] or selfData.SoundTbl_FootStep
	local pickedSD = customSD and PICK(customSD) or PICK(tbl)
			if pickedSD then
				VJ.EmitSound(self, pickedSD, selfData.FootstepSoundLevel, self:GetSoundPitch(selfData.FootstepSoundPitch))
				local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Event", pickedSD) end
			end
		elseif self:IsMoving() && CurTime() > selfData.NextFootstepSoundT && self:GetMoveDelay() <= 0 then
			-- Use custom table if available, if none found then use the footstep sound table
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0, 0, 5),
				endpos = self:GetPos() - Vector(0, 0, 40),
				filter = self,
				mask = MASK_SOLID_BRUSHONLY
			})

			local tbl = SurfaceFootsteps[tr.MatType] or selfData.SoundTbl_FootStep
			local pickedSD = customSD and PICK(customSD) or PICK(tbl)
			if pickedSD then
				if selfData.FootstepSoundTimerRun && self:GetMovementActivity() == ACT_RUN then
					VJ.EmitSound(self, pickedSD, 70, 100)
					local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Run", pickedSD) end
					selfData.NextFootstepSoundT = CurTime() + selfData.FootstepSoundTimerRun
				elseif selfData.FootstepSoundTimerWalk && self:GetMovementActivity() == ACT_WALK then
					VJ.EmitSound(self, pickedSD, 70, 100)
					local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Walk", pickedSD) end
					selfData.NextFootstepSoundT = CurTime() + selfData.FootstepSoundTimerWalk
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", MaleFirePain)
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
	if self.Weapon_Rand == 1 then
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local mp5k = ents.Create("weapon_vj_cets_mp5k")
			mp5k:SetPos(att.Pos)
			mp5k:SetAngles(att.Ang)
			mp5k:Spawn()
		end
	else
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local shotgun = ents.Create("weapon_shotgun")
			shotgun:SetPos(att.Pos)
			shotgun:SetAngles(att.Ang)
			shotgun:Spawn()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaleSounds()
	self.SoundTbl_IdleDialogue = {
		"vo/npc/male01/doingsomething.wav",
		"vo/npc/male01/getgoingsoon.wav",
		"vo/npc/male01/question01.wav",
		"vo/npc/male01/question02.wav",
		"vo/npc/male01/question03.wav",
		"vo/npc/male01/question04.wav",
		"vo/npc/male01/question05.wav",
		"vo/npc/male01/question06.wav",
		"vo/npc/male01/question07.wav",
		"vo/npc/male01/question08.wav",
		"vo/npc/male01/question09.wav",
		"vo/npc/male01/question10.wav",
		"vo/npc/male01/question11.wav",
		"vo/npc/male01/question12.wav",
		"vo/npc/male01/question13.wav",
		"vo/npc/male01/question14.wav",
		"vo/npc/male01/question15.wav",
		"vo/npc/male01/question16.wav",
		"vo/npc/male01/question17.wav",
		"vo/npc/male01/question18.wav",
		"vo/npc/male01/question19.wav",
		"vo/npc/male01/question20.wav",
		"vo/npc/male01/question21.wav",
		"vo/npc/male01/question22.wav",
		"vo/npc/male01/question23.wav",
		"vo/npc/male01/question25.wav",
		"vo/npc/male01/question26.wav",
		"vo/npc/male01/question27.wav",
		"vo/npc/male01/question28.wav",
		"vo/npc/male01/question29.wav",
		"vo/npc/male01/question30.wav",
		"vo/npc/male01/question31.wav",
		"vo/npc/male01/vquestion01.wav",
		"vo/npc/male01/vquestion02.wav",
		"vo/npc/male01/vquestion04.wav",
	}


	self.SoundTbl_IdleDialogueAnswer = {
		"vo/npc/male01/answer01.wav",
		"vo/npc/male01/answer02.wav",
		"vo/npc/male01/answer03.wav",
		"vo/npc/male01/answer04.wav",
		"vo/npc/male01/answer05.wav",
		"vo/npc/male01/answer07.wav",
		"vo/npc/male01/answer08.wav",
		"vo/npc/male01/answer09.wav",
		"vo/npc/male01/answer10.wav",
		"vo/npc/male01/answer11.wav",
		"vo/npc/male01/answer12.wav",
		"vo/npc/male01/answer13.wav",
		"vo/npc/male01/answer14.wav",
		"vo/npc/male01/answer15.wav",
		"vo/npc/male01/answer16.wav",
		"vo/npc/male01/answer17.wav",
		"vo/npc/male01/answer18.wav",
		"vo/npc/male01/answer19.wav",
		"vo/npc/male01/answer20.wav",
		"vo/npc/male01/answer21.wav",
		"vo/npc/male01/answer22.wav",
		"vo/npc/male01/answer23.wav",
		"vo/npc/male01/answer25.wav",
		"vo/npc/male01/answer26.wav",
		"vo/npc/male01/answer27.wav",
		"vo/npc/male01/answer28.wav",
		"vo/npc/male01/answer29.wav",
		"vo/npc/male01/answer30.wav",
		"vo/npc/male01/answer31.wav",
		"vo/npc/male01/answer32.wav",
		"vo/npc/male01/answer33.wav",
		"vo/npc/male01/answer34.wav",
		"vo/npc/male01/answer35.wav",
		"vo/npc/male01/answer36.wav",
		"vo/npc/male01/answer37.wav",
		"vo/npc/male01/answer38.wav",
		"vo/npc/male01/answer39.wav",
		"vo/npc/male01/answer40.wav",
		"vo/npc/male01/vanswer01.wav",
		"vo/npc/male01/vanswer04.wav",
		"vo/npc/male01/vanswer08.wav",
		"vo/npc/male01/vanswer13.wav",
	}

	self.SoundTbl_CombatIdle = {
		"vo/npc/male01/letsgo01.wav",
		"vo/npc/male01/letsgo02.wav",
		"vo/npc/male01/squad_affirm05.wav",
		"vo/npc/male01/squad_affirm06.wav",
	}

	self.SoundTbl_ReceiveOrder = {
		"vo/npc/male01/ok01.wav",
		"vo/npc/male01/ok02.wav",
		"vo/npc/male01/squad_approach02.wav",
		"vo/npc/male01/squad_approach03.wav",
		"vo/npc/male01/squad_approach04.wav",
	}

	self.SoundTbl_FollowPlayer = {
		"vo/npc/male01/leadon01.wav",
		"vo/npc/male01/leadon02.wav",
		"vo/npc/male01/leadtheway01.wav",
		"vo/npc/male01/leadtheway02.wav",
		"vo/npc/male01/okimready01.wav",
		"vo/npc/male01/okimready02.wav",
		"vo/npc/male01/okimready03.wav",
		"vo/npc/male01/readywhenyouare01.wav",
		"vo/npc/male01/readywhenyouare02.wav",
		"vo/npc/male01/squad_affirm01.wav",
		"vo/npc/male01/squad_affirm02.wav",
		"vo/npc/male01/squad_affirm03.wav",
		"vo/npc/male01/squad_affirm04.wav",
		"vo/npc/male01/squad_affirm07.wav",
		"vo/npc/male01/squad_affirm08.wav",
		"vo/npc/male01/squad_affirm09.wav",
		"vo/npc/male01/squad_follow03.wav",
		"vo/npc/male01/yougotit02.wav",
	}

	self.SoundTbl_UnFollowPlayer = {
		"vo/npc/male01/holddownspot01.wav",
		"vo/npc/male01/holddownspot02.wav",
		"vo/npc/male01/illstayhere01.wav",
		"vo/npc/male01/imstickinghere01.wav",
		"vo/npc/male01/littlecorner01.wav",
	}

	self.SoundTbl_YieldToPlayer = {
		"vo/npc/male01/excuseme01.wav",
		"vo/npc/male01/excuseme02.wav",
		"vo/npc/male01/outofyourway02.wav",
		"vo/npc/male01/pardonme01.wav",
		"vo/npc/male01/pardonme02.wav",
		"vo/npc/male01/sorry01.wav",
		"vo/npc/male01/sorry02.wav",
		"vo/npc/male01/sorry03.wav",
		"vo/npc/male01/sorrydoc01.wav",
		"vo/npc/male01/sorrydoc02.wav",
		"vo/npc/male01/sorrydoc04.wav",
		"vo/npc/male01/sorryfm01.wav",
		"vo/npc/male01/sorryfm02.wav",
		"vo/npc/male01/whoops01.wav",
	}

	self.SoundTbl_MedicBeforeHeal = {
		"vo/npc/male01/health01.wav",
		"vo/npc/male01/health02.wav",
		"vo/npc/male01/health03.wav",
		"vo/npc/male01/health04.wav",
		"vo/npc/male01/health05.wav",
	}

	self.SoundTbl_OnPlayerSight = {
		"vo/npc/male01/abouttime01.wav",
		"vo/npc/male01/abouttime02.wav",
		"vo/npc/male01/ahgordon01.wav",
		"vo/npc/male01/ahgordon02.wav",
		"vo/npc/male01/docfreeman01.wav",
		"vo/npc/male01/docfreeman02.wav",
		"vo/npc/male01/freeman.wav",
		"vo/npc/male01/hellodrfm01.wav",
		"vo/npc/male01/hellodrfm02.wav",
		"vo/npc/male01/heydoc01.wav",
		"vo/npc/male01/heydoc02.wav",
		"vo/npc/male01/hi01.wav",
		"vo/npc/male01/hi02.wav",
		"vo/npc/male01/squad_greet01.wav",
		"vo/npc/male01/squad_greet04.wav",
	}

	self.SoundTbl_Investigate = {
		"vo/npc/male01/startle01.wav",
		"vo/npc/male01/startle02.wav",
	}

	self.SoundTbl_LostEnemy = {}

	self.SoundTbl_Alert = {
		"vo/npc/male01/headsup01.wav",
		"vo/npc/male01/headsup02.wav",
		"vo/npc/male01/heretheycome01.wav",
		"vo/npc/male01/incoming02.wav",
		"vo/npc/male01/overhere01.wav",
		"vo/npc/male01/overthere01.wav",
		"vo/npc/male01/overthere02.wav",
		"vo/npc/male01/squad_away02.wav",
		"vo/npc/male01/upthere01.wav",
		"vo/npc/male01/upthere02.wav",
	}

	self.SoundTbl_CallForHelp = {
		"vo/npc/male01/help01.wav",
	}

	self.SoundTbl_BecomeEnemyToPlayer = {
		"vo/npc/male01/heretohelp01.wav",
		"vo/npc/male01/heretohelp02.wav",
		"vo/npc/male01/notthemanithought01.wav",
		"vo/npc/male01/notthemanithought02.wav",
		"vo/npc/male01/wetrustedyou01.wav",
		"vo/npc/male01/wetrustedyou02.wav",
	}

	self.SoundTbl_WeaponReload = {
		"vo/npc/male01/coverwhilereload01.wav",
		"vo/npc/male01/coverwhilereload02.wav",
		"vo/npc/male01/gottareload01.wav",
	}

	self.SoundTbl_GrenadeSight = {
		"vo/npc/male01/getdown02.wav",
		"vo/npc/male01/takecover02.wav",
		"vo/npc/male01/watchout.wav",
	}

	self.SoundTbl_DangerSight = {
		"vo/npc/male01/getdown02.wav",
		"vo/npc/male01/takecover02.wav",
		"vo/npc/male01/uhoh.wav",
		"vo/npc/male01/watchout.wav",
	}

	self.SoundTbl_KilledEnemy = {
		"vo/npc/male01/gotone01.wav",
		"vo/npc/male01/gotone02.wav",
		"vo/npc/male01/nice.wav",
		"vo/npc/male01/yeah02.wav",
	}

	self.SoundTbl_AllyDeath = {
		"vo/npc/male01/goodgod.wav",
	}

	self.SoundTbl_Pain = {
		"vo/npc/male01/ow01.wav",
		"vo/npc/male01/ow02.wav",
		"vo/npc/male01/pain01.wav",
		"vo/npc/male01/pain02.wav",
		"vo/npc/male01/pain03.wav",
		"vo/npc/male01/pain04.wav",
		"vo/npc/male01/pain05.wav",
		"vo/npc/male01/pain06.wav",
	}

	self.SoundTbl_Death = {
		"vo/npc/male01/pain07.wav",
		"vo/npc/male01/pain08.wav",
		"vo/npc/male01/pain09.wav"
	}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FemaleSounds()
	self.SoundTbl_Idle = {}

	self.SoundTbl_IdleDialogue = {
		"vo/npc/female01/doingsomething.wav",
		"vo/npc/female01/getgoingsoon.wav",
		"vo/npc/female01/question01.wav",
		"vo/npc/female01/question02.wav",
		"vo/npc/female01/question03.wav",
		"vo/npc/female01/question04.wav",
		"vo/npc/female01/question05.wav",
		"vo/npc/female01/question06.wav",
		"vo/npc/female01/question07.wav",
		"vo/npc/female01/question08.wav",
		"vo/npc/female01/question09.wav",
		"vo/npc/female01/question10.wav",
		"vo/npc/female01/question11.wav",
		"vo/npc/female01/question12.wav",
		"vo/npc/female01/question13.wav",
		"vo/npc/female01/question14.wav",
		"vo/npc/female01/question15.wav",
		"vo/npc/female01/question16.wav",
		"vo/npc/female01/question17.wav",
		"vo/npc/female01/question18.wav",
		"vo/npc/female01/question19.wav",
		"vo/npc/female01/question20.wav",
		"vo/npc/female01/question21.wav",
		"vo/npc/female01/question22.wav",
		"vo/npc/female01/question23.wav",
		"vo/npc/female01/question25.wav",
		"vo/npc/female01/question26.wav",
		"vo/npc/female01/question27.wav",
		"vo/npc/female01/question28.wav",
		"vo/npc/female01/question29.wav",
		"vo/npc/female01/question30.wav",
		"vo/npc/female01/vquestion01.wav",
		"vo/npc/female01/vquestion02.wav",
		"vo/npc/female01/vquestion04.wav",
	}

	self.SoundTbl_IdleDialogueAnswer = {
		"vo/npc/female01/answer01.wav",
		"vo/npc/female01/answer02.wav",
		"vo/npc/female01/answer03.wav",
		"vo/npc/female01/answer04.wav",
		"vo/npc/female01/answer05.wav",
		"vo/npc/female01/answer07.wav",
		"vo/npc/female01/answer08.wav",
		"vo/npc/female01/answer09.wav",
		"vo/npc/female01/answer10.wav",
		"vo/npc/female01/answer11.wav",
		"vo/npc/female01/answer12.wav",
		"vo/npc/female01/answer13.wav",
		"vo/npc/female01/answer14.wav",
		"vo/npc/female01/answer15.wav",
		"vo/npc/female01/answer16.wav",
		"vo/npc/female01/answer17.wav",
		"vo/npc/female01/answer18.wav",
		"vo/npc/female01/answer19.wav",
		"vo/npc/female01/answer20.wav",
		"vo/npc/female01/answer21.wav",
		"vo/npc/female01/answer22.wav",
		"vo/npc/female01/answer23.wav",
		"vo/npc/female01/answer25.wav",
		"vo/npc/female01/answer26.wav",
		"vo/npc/female01/answer27.wav",
		"vo/npc/female01/answer28.wav",
		"vo/npc/female01/answer29.wav",
		"vo/npc/female01/answer30.wav",
		"vo/npc/female01/answer31.wav",
		"vo/npc/female01/answer32.wav",
		"vo/npc/female01/answer33.wav",
		"vo/npc/female01/answer34.wav",
		"vo/npc/female01/answer35.wav",
		"vo/npc/female01/answer36.wav",
		"vo/npc/female01/answer37.wav",
		"vo/npc/female01/answer38.wav",
		"vo/npc/female01/answer39.wav",
		"vo/npc/female01/answer40.wav",
		"vo/npc/female01/vanswer01.wav",
		"vo/npc/female01/vanswer04.wav",
		"vo/npc/female01/vanswer08.wav",
		"vo/npc/female01/vanswer13.wav",
	}

	self.SoundTbl_CombatIdle = {
		"vo/npc/female01/squad_affirm05.wav",
		"vo/npc/female01/squad_affirm06.wav",
	}

	self.SoundTbl_ReceiveOrder = {
		"vo/npc/female01/ok01.wav",
		"vo/npc/female01/ok02.wav",
	}

	self.SoundTbl_FollowPlayer = {
		"vo/npc/female01/leadon01.wav",
		"vo/npc/female01/leadon02.wav",
		"vo/npc/female01/leadtheway01.wav",
		"vo/npc/female01/leadtheway02.wav",
		"vo/npc/female01/letsgo01.wav",
		"vo/npc/female01/letsgo02.wav",
		"vo/npc/female01/okimready01.wav",
		"vo/npc/female01/okimready02.wav",
		"vo/npc/female01/okimready03.wav",
		"vo/npc/female01/readywhenyouare01.wav",
		"vo/npc/female01/readywhenyouare02.wav",
		"vo/npc/female01/yougotit02.wav",
	}

	self.SoundTbl_UnFollowPlayer = {
		"vo/npc/female01/holddownspot01.wav",
		"vo/npc/female01/holddownspot02.wav",
		"vo/npc/female01/illstayhere01.wav",
		"vo/npc/female01/imstickinghere01.wav",
		"vo/npc/female01/littlecorner01.wav",
	}

	self.SoundTbl_YieldToPlayer = {
		"vo/npc/female01/excuseme01.wav",
		"vo/npc/female01/excuseme02.wav",
		"vo/npc/female01/outofyourway02.wav",
		"vo/npc/female01/pardonme01.wav",
		"vo/npc/female01/pardonme02.wav",
		"vo/npc/female01/sorry01.wav",
		"vo/npc/female01/sorry02.wav",
		"vo/npc/female01/sorry03.wav",
		"vo/npc/female01/sorrydoc01.wav",
		"vo/npc/female01/sorrydoc02.wav",
		"vo/npc/female01/sorrydoc04.wav",
		"vo/npc/female01/sorryfm01.wav",
		"vo/npc/female01/sorryfm02.wav",
		"vo/npc/female01/whoops01.wav",
	}

	self.SoundTbl_MedicBeforeHeal = {
		"vo/npc/female01/health01.wav",
		"vo/npc/female01/health02.wav",
		"vo/npc/female01/health03.wav",
		"vo/npc/female01/health04.wav",
		"vo/npc/female01/health05.wav",
	}

	self.SoundTbl_OnPlayerSight = {
		"vo/npc/female01/abouttime01.wav",
		"vo/npc/female01/abouttime02.wav",
		"vo/npc/female01/ahgordon01.wav",
		"vo/npc/female01/ahgordon02.wav",
		"vo/npc/female01/docfreeman01.wav",
		"vo/npc/female01/docfreeman02.wav",
		"vo/npc/female01/freeman.wav",
		"vo/npc/female01/hellodrfm01.wav",
		"vo/npc/female01/hellodrfm02.wav",
		"vo/npc/female01/heydoc01.wav",
		"vo/npc/female01/heydoc02.wav",
		"vo/npc/female01/hi01.wav",
		"vo/npc/female01/hi02.wav",
		"vo/npc/female01/squad_greet01.wav",
		"vo/npc/female01/squad_greet04.wav",
	}

	self.SoundTbl_Investigate = {
		"vo/npc/female01/startle01.wav",
		"vo/npc/female01/startle02.wav",
	}

	self.SoundTbl_LostEnemy = {}

	self.SoundTbl_Alert = {
		"vo/npc/female01/headsup01.wav",
		"vo/npc/female01/headsup02.wav",
		"vo/npc/female01/heretheycome01.wav",
		"vo/npc/female01/incoming02.wav",
		"vo/npc/female01/overhere01.wav",
		"vo/npc/female01/overthere01.wav",
		"vo/npc/female01/overthere02.wav",
		"vo/npc/female01/squad_away02.wav",
		"vo/npc/female01/upthere01.wav",
		"vo/npc/female01/upthere02.wav",
	}

	self.SoundTbl_CallForHelp = {
		"vo/npc/female01/help01.wav",
	}

	self.SoundTbl_WeaponReload = {
		"vo/npc/female01/coverwhilereload01.wav",
		"vo/npc/female01/coverwhilereload02.wav",
		"vo/npc/female01/gottareload01.wav",
	}

	self.SoundTbl_GrenadeSight = {
		"vo/npc/female01/getdown02.wav",
		"vo/npc/female01/takecover02.wav",
		"vo/npc/female01/watchout.wav",
	}

	self.SoundTbl_DangerSight = {
		"vo/npc/female01/getdown02.wav",
		"vo/npc/female01/takecover02.wav",
		"vo/npc/female01/uhoh.wav",
		"vo/npc/female01/watchout.wav",
	}

	self.SoundTbl_KilledEnemy = {
		"vo/npc/female01/gotone01.wav",
		"vo/npc/female01/gotone02.wav",
		"vo/npc/female01/likethat.wav",
		"vo/npc/female01/yeah02.wav",
	}

	self.SoundTbl_AllyDeath = {
		"vo/npc/female01/goodgod.wav",
		"vo/npc/female01/ohno.wav",
	}

	self.SoundTbl_Pain = {
		"vo/npc/female01/ow01.wav",
		"vo/npc/female01/ow02.wav",
		"vo/npc/female01/pain01.wav",
		"vo/npc/female01/pain02.wav",
		"vo/npc/female01/pain03.wav",
		"vo/npc/female01/pain04.wav",
		"vo/npc/female01/pain05.wav",
	}

	self.SoundTbl_Death = {
		"vo/npc/female01/pain06.wav",
		"vo/npc/female01/pain07.wav",
		"vo/npc/female01/pain08.wav",
		"vo/npc/female01/pain09.wav",
	}
end