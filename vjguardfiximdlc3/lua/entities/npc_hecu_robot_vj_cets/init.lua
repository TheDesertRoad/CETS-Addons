AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 67
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.AlliedWithPlayerAllies = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 1
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_impact_synth_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
local mdlHECU = {
	"models/humans/grunt/hgrunt_robot.mdl",
}

local Weapon_None = -1
local Weapon_MP5SD = 1
local Weapon_Shotgun = 2

ENT.Weapon_Rand = Weapon_None

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 3
ENT.ItemDropsOnDeath_EntityList = {
	"item_armor_c",
	"item_health_vial_c",
}

ENT.BreathSoundLevel = 50
ENT.BreathSoundPitch = 100
ENT.MainSoundLevel = 50
ENT.MainSoundPitch = 120

ENT.SoundTbl_MetalFootStep = {"player/footsteps/metalgrate1.wav", "player/footsteps/metalgrate2.wav", "player/footsteps/metalgrate3.wav", "player/footsteps/metalgrate4.wav"}

local sdAlertComb = ENT.SoundTbl_Alert 

local sdAlertCP = ENT.SoundTbl_Alert 

local sdAlertZombies = ENT.SoundTbl_Alert 

local sdAlertCrabs = ENT.SoundTbl_Alert

local sdAlertManhacks = ENT.SoundTbl_Alert 

local sdAlertStrider = ENT.SoundTbl_Alert 

ENT.NextDance = 0
ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	local flags = self:GetSpawnFlags()

	self.Weapon_Rand = 1
	self.Model = mdlHECU
	self:MaleSounds()
	self:Give("weapon_vj_cets_mp5sd")
	self:HecuSounds()

	util.SpriteTrail(self, 1, Color(255, 0, 0), true, 2, 0, 0.2, 1 /(25 +1) *0.5, "sprites/laserbeam")

	local spriteGlow = ents.Create("env_sprite")
		spriteGlow:SetKeyValue("rendercolor", "255 0 0")
		spriteGlow:SetKeyValue("GlowProxySize", "1.0")
		spriteGlow:SetKeyValue("HDRColorScale", "1.0")
		spriteGlow:SetKeyValue("renderfx", "14")
		spriteGlow:SetKeyValue("rendermode", "3")
		spriteGlow:SetKeyValue("renderamt", "255")
		spriteGlow:SetKeyValue("disablereceiveshadows", "0")
		spriteGlow:SetKeyValue("mindxlevel", "0")
		spriteGlow:SetKeyValue("maxdxlevel", "0")
		spriteGlow:SetKeyValue("framerate", "10.0")
		spriteGlow:SetKeyValue("model", "VJ_Base/sprites/glow.vmt")
		spriteGlow:SetKeyValue("spawnflags", "0")
		spriteGlow:SetKeyValue("scale", "0.07")
		spriteGlow:SetParent(self)
		spriteGlow:Fire("SetParentAttachment", "eyes")
		spriteGlow:Spawn()
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
				VJ.EmitSound(self, "player/footsteps/metalgrate1.wav", selfData.FootstepSoundLevel, self:GetSoundPitch(selfData.FootstepSoundPitch))
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

			local tbl = SurfaceFootsteps[tr.MatType] && selfData.SoundTbl_MetalFootStep
			local pickedSD = customSD and PICK(customSD) or PICK(tbl)
			if pickedSD then
				if selfData.FootstepSoundTimerRun && self:GetMovementActivity() == ACT_RUN then
					VJ.EmitSound(self, pickedSD, 70, 100)
					VJ.EmitSound(self, "player/footsteps/metalgrate1.wav", 70, 100)
					local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Run", pickedSD) end
					selfData.NextFootstepSoundT = CurTime() + selfData.FootstepSoundTimerRun
				elseif selfData.FootstepSoundTimerWalk && self:GetMovementActivity() == ACT_WALK then
					VJ.EmitSound(self, pickedSD, 70, 100)
					VJ.EmitSound(self, "player/footsteps/metalgrate1.wav", 70, 100)
					local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Walk", pickedSD) end
					selfData.NextFootstepSoundT = CurTime() + selfData.FootstepSoundTimerWalk
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSpark(pos,intensity)
	intensity = intensity or 1
	local spark = ents.Create("env_spark")
		spark:SetKeyValue("Magnitude",tostring(intensity))
		spark:SetKeyValue("Spark Trail Length",tostring(intensity))
		spark:SetPos(pos)
		spark:Spawn()
		spark:Fire("StartSpark", "", 0)
	timer.Simple(0.1, function() if IsValid(spark) then spark:Remove() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	self.HasPainSounds = true -- If set to false, it won't play the pain sounds
	if !dmginfo:IsExplosionDamage() then
			if math.random(1, 4) == 1 then
				self:EmitSound("physics/metal/metal_sheet_impact_bullet1.wav", 92, math.random(70, 90))
				self.Spark1 = ents.Create("env_spark")
				self.Spark1:SetPos(dmginfo:GetDamagePosition())
				self.Spark1:Spawn()
				self.Spark1:Fire("StartSpark", "", 0)
				self.Spark1:Fire("StopSpark", "", 0.001)
				self:DeleteOnRemove(self.Spark1)
		end
		self.HasPainSounds = false -- If set to false, it won't play the pain sounds
	else
		self:DoSpark(dmginfo:GetDamagePosition(),5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HecuSounds()
	self.SoundTbl_Breath = {
		"npc/rgrunt/rb_engine.wav",
		"npc/rgrunt/rb_engine_alt.wav",
	}

	self.SoundTbl_Idle = {
		"npc/rgrunt/rb_idle1.wav",
		"npc/rgrunt/rb_idle2.wav",
		"npc/rgrunt/rb_idle3.wav",
	}

	self.SoundTbl_IdleDialogue = {
		"npc/rgrunt/rb_question1.wav",
		"npc/rgrunt/rb_question2.wav",
		"npc/rgrunt/rb_question3.wav",
		"npc/rgrunt/rb_question4.wav",
		"npc/rgrunt/rb_question5.wav",
	}

	self.SoundTbl_IdleDialogueAnswer = {
		"npc/rgrunt/rb_answer1.wav",
		"npc/rgrunt/rb_answer2.wav",
		"npc/rgrunt/rb_answer3.wav",
		"npc/rgrunt/rb_answer4.wav",
		"npc/rgrunt/rb_answer5.wav",
	}

	self.SoundTbl_CombatIdle = {
		"npc/rgrunt/rb_combat1.wav",
		"npc/rgrunt/rb_combat2.wav",
		"npc/rgrunt/rb_combat3.wav",
		"npc/rgrunt/rb_combat4.wav",
	}

	self.SoundTbl_ReceiveOrder = false

	self.SoundTbl_FollowPlayer = false

	self.SoundTbl_UnFollowPlayer = false

	self.SoundTbl_YieldToPlayer = false

	self.SoundTbl_MedicBeforeHeal = false

	self.SoundTbl_OnPlayerSight = false

	self.SoundTbl_Investigate = false

	self.SoundTbl_LostEnemy = false

	self.SoundTbl_Alert = {
		"npc/rgrunt/rb_alert1.wav",
		"npc/rgrunt/rb_alert2.wav",
		"npc/rgrunt/rb_alert3.wav",
		"npc/rgrunt/rb_alert4.wav",
		"npc/rgrunt/rb_alert5.wav",
	}

	self.SoundTbl_CallForHelp = {
		"npc/rgrunt/rb_cover1.wav",
		"npc/rgrunt/rb_cover2.wav",
	}

	self.SoundTbl_BecomeEnemyToPlayer = false

	self.SoundTbl_WeaponReload = false

	self.SoundTbl_GrenadeSight = {
		"npc/rgrunt/rb_gren1.wav",
		"npc/rgrunt/rb_gren2.wav",
		"npc/rgrunt/rb_gren3.wav",
	}

	self.SoundTbl_DangerSight = false

	self.SoundTbl_KilledEnemy = {
		"npc/rgrunt/rb_taunt1.wav",
		"npc/rgrunt/rb_taunt2.wav",
		"npc/rgrunt/rb_taunt3.wav",
	}

	self.SoundTbl_AllyDeath = {
		"npc/rgrunt/rb_allydeath1.wav",
		"npc/rgrunt/rb_allydeath2.wav",
	}

	self.SoundTbl_Pain = false

	self.SoundTbl_Death = {
		"npc/rgrunt/rb_killed1.wav",
		"npc/rgrunt/rb_killed2.wav",
		"npc/rgrunt/rb_killed3.wav",
		"npc/rgrunt/rb_killed4.wav",
	}
end