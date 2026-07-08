AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/props_cets_aliens/xen_flower_s.mdl"
ENT.StartHealth = 50
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanChatMessage = false
ENT.TurningSpeed = 0
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.IdleAlwaysWander = false
ENT.AlwaysWander = false
ENT.SightAngle = 360
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Purple"
ENT.BloodDecal = "VJ_CETS_PBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.HasDeathCorpse = false
ENT.HasExtraMeleeAttackSounds = true

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.NextRangeAttackTime = 1
ENT.RangeAttackDamage = 16 
ENT.RangeAttackMaxDistance = 1600
ENT.RangeAttackMinDistance = 1
ENT.RangeAttackAngleRadius = 180
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.CanFlinch = false

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.HasItemDropsOnDeath = false

ENT.SoundTbl_RangeAttack = {"npc/waste_scanner/grenade_fire.wav"}

ENT.SoundTbl_Death = {"ambient/explosions/explode_7.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(5, 5, -12), Vector(-5, -5, -50))

	self.DynamicLight = ents.Create("light_dynamic")
	self.DynamicLight:SetKeyValue("brightness", "2")
	self.DynamicLight:SetKeyValue("distance", "128")
	self.DynamicLight:SetLocalPos(self:GetPos())
	self.DynamicLight:SetLocalAngles(self:GetAngles())
	self.DynamicLight:Fire("Color", "64 8 255")
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Spawn()
	self.DynamicLight:Activate()
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Fire("SetParentAttachment", "1")
	self.DynamicLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.DynamicLight)

	self.FlareSprite = ents.Create("env_sprite")
	self.FlareSprite:SetKeyValue("model", "sprites/misc/lightflare.vmt")
	self.FlareSprite:SetKeyValue("rendercolor", "64 8 255")
	self.FlareSprite:SetKeyValue("GlowProxySize", "5.0")
	self.FlareSprite:SetKeyValue("HDRColorScale", "1.0")
	self.FlareSprite:SetKeyValue("renderfx", "14")
	self.FlareSprite:SetKeyValue("rendermode", "3")
	self.FlareSprite:SetKeyValue("renderamt", "255")
	self.FlareSprite:SetKeyValue("disablereceiveshadows", "0")
	self.FlareSprite:SetKeyValue("mindxlevel", "0")
	self.FlareSprite:SetKeyValue("maxdxlevel", "0")
	self.FlareSprite:SetKeyValue("framerate", "10.0")
	self.FlareSprite:SetKeyValue("spawnflags", "0")
	self.FlareSprite:SetKeyValue("scale", "4")
	self.FlareSprite:SetPos(self:GetPos())
	self.FlareSprite:Spawn()
	self.FlareSprite:SetParent(self)
	self.FlareSprite:Fire("SetParentAttachment", "Ray", 1)
	self:DeleteOnRemove(self.FlareSprite)

	self.BlackAmount = 0
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
function ENT:CustomRangeAttackCode()
	self:EmitSound("npc/vortsynth/vort_attack_shoot" .. math.random(1, 2) .. ".wav",100,math.random(90, 110))
	self:StopSound("npc/vort/attack_charge.wav")
	if self.RangeAttackPos then
			local source = self:GetAttachment(1).Pos
			local tr = util.TraceLine({
				start = source,
 				endpos = source + (self.RangeAttackPos - (source+VectorRand(-20,20))):GetNormalized()*10000,
				mask = MASK_SHOT,
				filter = self,
		})
		util.ParticleTracerEx("xenflower_beam",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),1)
		util.VJ_SphereDamage(self,self,tr.HitPos,200,self.RangeAttackDamage,bit.bor(DMG_SHOCK),true,true,false,false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * -10 + self:GetForward() * -20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Curve", projectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1200)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	local myPos = self:GetPos() + self:GetUp() * -16
	local defAngle = Angle(0, 0, 0)

	ParticleEffect("gargantua_dead_electro_b2", myPos, defAngle)
	ParticleEffect("racex_arc_01_cp0_COP", myPos, defAngle)
	VJ.EmitSound(self, "npc/squeek/sqk_blast1.wav", 90, 80)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 90, 100)
	VJ.ApplyRadiusDamage(self, self, myPos, 128, 36, bit.bor(DMG_BLAST), true, true, {DisableVisibilityCheck=true, Force=150})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:EmitSound( "NPC_Vortigaunt.ZapPowerup", 100, 150, 1, CHAN_AUTO, SND_STOP )
end