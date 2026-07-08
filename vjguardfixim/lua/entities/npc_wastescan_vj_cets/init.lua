AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_wscanner.mdl"
ENT.StartHealth = GetConVar("sk_wscanner_health"):GetInt()
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.CanChatMessage = false
ENT.TurningSpeed = 16
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.EntitiesToNoCollide = {"npc_wastescan_vj_cets", "npc_wastescan_vj_cets_ns", "obj_vj_gib", "obj_vj_xen_bionade"}
ENT.IdleAlwaysWander = TRUE
ENT.AlwaysWander = TRUE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Aerial_FlyingSpeed_Calm = 220
ENT.Aerial_FlyingSpeed_Alerted = 650
ENT.AA_GroundLimit = 70
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Green"
ENT.BloodDecal = "VJ_CETS_GBlood"
ENT.BloodParticle = "blood_impact_antlion_worker_01"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.HasDeathCorpse = false
ENT.HasExtraMeleeAttackSounds = true

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.TimeUntilRangeAttackProjectileRelease = 0.5
ENT.NextRangeAttackTime = 4.6
ENT.RangeAttackAttachment = "1" 
ENT.RangeAttackMaxDistance = 1600
ENT.RangeAttackMinDistance = 1
ENT.DisableDefaultRangeAttackCode = false -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.CanFlinch = false

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 1
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
}

ENT.BreathSoundLevel = 75
ENT.AlertSoundLevel = 90

ENT.SoundTbl_Breath = {"npc/waste_scanner/hover.wav"}

ENT.SoundTbl_Idle = {
	"npc/waste_scanner/rol_idle1.wav",
	"npc/waste_scanner/rol_idle2.wav",
	"npc/waste_scanner/rol_idle3.wav",
	"npc/waste_scanner/rol_idle4.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/waste_scanner/rol_idle1.wav",
	"npc/waste_scanner/rol_idle2.wav",
	"npc/waste_scanner/rol_idle3.wav",
	"npc/waste_scanner/rol_idle4.wav",
}

ENT.SoundTbl_Alert = {
	"npc/waste_scanner/alarm1.wav",
}

ENT.SoundTbl_RangeAttack = {"npc/waste_scanner/grenade_fire.wav"}

ENT.SoundTbl_BeforeDeath = {"npc/waste_scanner/hover_alarm.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("npc_cets_wscanner_bionade"):GetInt() == 1 then
		self.RangeAttackProjectiles = {"obj_vj_xen_bionade"}
	else
		self.RangeAttackProjectiles = {"obj_vj_cets_grenade_rifle"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(20, 20, 26), Vector(-20, -20, -12))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local enemy = self:GetEnemy()
		if IsValid(enemy) then

		if self:Visible(enemy) then
			self.RangeAttackPos = enemy:GetPos()+enemy:OBBCenter()
		end
	end

	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
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
ENT.CrashChance = GetConVar("sk_wscanner_crash_chance"):GetInt()
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	local myPos = self:GetPos()
	local defAngle = Angle(0, 0, 0)

	ParticleEffect("Barrel_Explosion", myPos, defAngle)
	VJ.EmitSound(self, "npc/vort/vort_explode" .. math.random(1, 2) .. ".wav", 80, 100)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 90, 100)
	VJ.ApplyRadiusDamage(self, self, myPos, 64, 18, bit.bor(DMG_BLAST), true, true, {DisableVisibilityCheck=true, Force=150})

	if self.CrashChance == 1 then -- Crash

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
	self:StopSound("npc/waste_scanner/hover_alarm.wav")
	self:EmitSound( "NPC_Vortigaunt.ZapPowerup", 100, 150, 1, CHAN_AUTO, SND_STOP )
end