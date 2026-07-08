AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/mortarsynth.mdl"
ENT.StartHealth = GetConVar("sk_mortar_health"):GetInt()
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.CanChatMessage = false
ENT.TurningSpeed = 3
ENT.EntitiesToNoCollide = {"npc_mortarsynth_vj_cets", "obj_vj_gib"}
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Aerial_FlyingSpeed_Calm = 200
ENT.Aerial_FlyingSpeed_Alerted = 600
ENT.Aerial_AnimTbl_Calm = ACT_IDLE
ENT.Aerial_AnimTbl_Alerted = "mortar_forward"
ENT.AA_GroundLimit = 128
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Blue"
ENT.BloodDecal = "VJ_CETS_BBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK1
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 30
ENT.TimeUntilMeleeAttackDamage = 0.7
ENT.NextAnyAttackTime_Melee = 1.3
ENT.MeleeAttackDamage = 30

ENT.HasDeathCorpse = true
ENT.HasExtraMeleeAttackSounds = true

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackProjectiles = {"grenade_ar2", "obj_vj_cguard_extractor"}
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 2
ENT.RangeAttackMaxDistance = 2500
ENT.RangeAttackMinDistance = 1

ENT.CanFlinch = true
ENT.FlinchChance = 3
ENT.FlinchCooldown = 2
ENT.AnimTbl_Flinch = {"Mortar_Flinch_Front"}

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 1
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_ammo_smg1_grenade",
	"item_ammo_ar2_altfire",
}

ENT.BreathSoundLevel = 75
ENT.AlertSoundLevel = 90

ENT.SoundTbl_Breath = {"npc/mortar/hover.wav"}

ENT.SoundTbl_Idle = {
	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/mortar/attack_cue.wav",
	"npc/mortar/attack_cue01.wav",
	"npc/mortar/attack_cue1.wav",
	"npc/mortar/attack_cue02.wav",
}

ENT.SoundTbl_Alert = {
	"npc/mortar/alert1.wav",
	"npc/mortar/alert2.wav",
	"npc/mortar/alert3.wav",
}

ENT.SoundTbl_Pain = {
	"npc/mortar/pain1.wav",
	"npc/mortar/pain2.wav",
	"npc/mortar/pain3.wav",
}

ENT.SoundTbl_RangeAttack = {"npc/mortar/laser_fire.wav"}

ENT.SoundTbl_Death = {"npc/roller/mine/rmine_tossed1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(33, 33, 26), Vector(-33, -33, -30))

	self:PhysicsInit(SOLID_VPHYSICS) // SOLID_BBOX
	self:SetAngles(self:GetAngles() + Angle(0, 0, 0))

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(10)
	end

	local glowFX = ents.Create("light_dynamic")
	glowFX:SetKeyValue("brightness", "2")
	glowFX:SetKeyValue("distance", "125")
	glowFX:SetLocalPos(self:GetPos() +self:OBBCenter() +self:GetForward() *20 +self:GetUp() *-4)
	glowFX:SetLocalAngles(self:GetAngles())
	glowFX:Fire("Color", "0 50 255")
	glowFX:SetParent(self)
	glowFX:Spawn()
	glowFX:Activate()
	glowFX:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(glowFX)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "Init" then
		local dmgtype = dmginfo:GetDamageType()
		if (dmgtype == DMG_BULLET or dmgtype == DMG_SLASH or dmgtype == DMG_BLAST) then
			self.AnimTbl_Flinch = {"Mortar_Flinch_Back", "Mortar_Flinch_Left", "Mortar_Flinch_Right", "Mortar_Flinch_Front"}
		else
			self.AnimTbl_Flinch = {"Mortar_BigFlinch_Back", "Mortar_BigFlinch_Left", "Mortar_BigFlinch_Right", "Mortar_BigFlinch_Front"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) then 
			self:VJ_ACT_PLAYACTIVITY("Mortar_Flinch_Back",true,4,false)
			self.MovementType = VJ_MOVETYPE_AERIAL
			self.CanTurnWhileStationary = false
			self.HasLeapAttack = false
			self.SightDistance = 1 
			self.IsGuard = true
			self.CallForHelp = false

			timer.Simple(2,function() if IsValid(self) then
			self.SightDistance = 6000 
			self.IsGuard = false
			self.CallForHelp = true
			self.MovementType = VJ_MOVETYPE_AERIAL
			self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 10 + self:GetForward() * -20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Curve", projectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1200)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CrashChance = GetConVar("sk_mortar_crash_chance"):GetInt()
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect( "Explosion", effectdata )

	if math.random(1, self.CrashChance) == 1 then -- Crash

		local targetpos = self:GetPos() + self:GetForward() * 100 - Vector(0,0,100)
		if IsValid(self:GetEnemy()) then
			targetpos = self:GetEnemy():GetPos()
		end

		local crashdir = targetpos - self:GetPos()

		local CrashingScannerProp = ents.Create("base_gmodentity")
		CrashingScannerProp:SetModel(self:GetModel())
		CrashingScannerProp:SetPos(self:GetPos())
		CrashingScannerProp:SetAngles(crashdir:Angle())
		CrashingScannerProp:Spawn()
		CrashingScannerProp:SetMoveType(MOVETYPE_FLY)
		CrashingScannerProp:SetSolid(SOLID_VPHYSICS)
		CrashingScannerProp.VJ_NPC_Class = self.VJ_NPC_Class
		if file.Exists("autorun/server/sv_entdamageoverlay.lua", "LUA") then
			self:CopyEntDamageOverlays(CrashingScannerProp)
		end

		CrashingScannerProp.Explode = function()
			util.VJ_SphereDamage(Entity(0),Entity(0),CrashingScannerProp:GetPos(),300,100,DMG_BLAST,false,false,false,false)
			local effectdata = EffectData()
			effectdata:SetOrigin(CrashingScannerProp:GetPos())
			util.Effect( "Explosion", effectdata )
			CrashingScannerProp:EmitSound( "Explo.ww2bomb", 130, 100)
			CrashingScannerProp:Remove()
		end

		CrashingScannerProp.Think = function()
			CrashingScannerProp:SetVelocity(crashdir:GetNormalized() * 30)
			CrashingScannerProp:SetAngles(CrashingScannerProp:GetAngles() + Angle(0,0,3))
			CrashingScannerProp:NextThink(CurTime())
			local tr = util.TraceLine({
				start = CrashingScannerProp:GetPos(),
				endpos = CrashingScannerProp:GetPos() + crashdir:GetNormalized() * 3000,
				filter = self
			})

			sound.EmitHint(SOUND_DANGER, tr.HitPos, 300, 0.5)
			return true
		end

		CrashingScannerProp.StartTouch = function()
			CrashingScannerProp:Explode()
		end
		timer.Simple(2, function() if IsValid(CrashingScannerProp) then CrashingScannerProp:Explode() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:EmitSound( "NPC_Vortigaunt.ZapPowerup", 100, 150, 1, CHAN_AUTO, SND_STOP )
end