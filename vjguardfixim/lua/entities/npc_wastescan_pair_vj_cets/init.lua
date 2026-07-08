AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_wscanner_tri.mdl"
ENT.StartHealth = GetConVar("sk_wscanner_health"):GetInt() * 3
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.CanChatMessage = false
ENT.TurningSpeed = 2
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.EntitiesToNoCollide = {"npc_wastescan_vj_cets", "npc_wastescan_vj_cets_ns", "obj_vj_gib", "obj_vj_xen_bionade"}
ENT.IdleAlwaysWander = TRUE
ENT.AlwaysWander = TRUE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Aerial_FlyingSpeed_Calm = 64
ENT.Aerial_FlyingSpeed_Alerted = 128
ENT.AA_GroundLimit = 64
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
ENT.NextRangeAttackTime = 3
ENT.RangeAttackDamage = 24 
ENT.RangeAttackAttachment = "1" 
ENT.RangeAttackMaxDistance = 1600
ENT.RangeAttackMinDistance = 1
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.CanFlinch = false

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
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

ENT.SoundTbl_Death = {"ambient/explosions/explode_7.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(33, 33, 52), Vector(-33, -33, -30))
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
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_VEHICLE ) or dmginfo:IsDamageType( DMG_SONIC ) or dmginfo:IsDamageType( DMG_BLAST ) or dmginfo:IsDamageType( DMG_SONIC ) or dmginfo:IsDamageType( DMG_DISSOLVE )  or dmginfo:IsDamageType( DMG_CLUB ) then 
		self:Remove(self)
		self:EmitSound("npc/waste_scanner/detach.wav",100,math.random(90, 110))
		ParticleEffect("assassin_projectile_explosion_1",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

		self.Scan1 = ents.Create("npc_wastescan_vj_cets_ns")
		self.Scan1:SetAngles(self:GetAngles())
		self.Scan1:SetPos(self:GetPos() + self:GetUp()*20)
		self.Scan1:Spawn()
		self.Scan1:SetSkin(0)
		self.Scan1:Activate() 
		self.Scan1:SetOwner(self)
		self:SetGroundEntity(NULL)

		self.Scan2 = ents.Create("npc_wastescan_vj_cets_ns")
		self.Scan2:SetAngles(self:GetAngles())
		self.Scan2:SetPos(self:GetPos() + self:GetUp()*-12 + self:GetRight()*-20)
		self.Scan2:Spawn()
		self.Scan1:SetSkin(0)
		self.Scan2:Activate() 
		self.Scan2:SetOwner(self)
		self:SetGroundEntity(NULL)

		self.Scan3 = ents.Create("npc_wastescan_vj_cets_ns")
		self.Scan3:SetAngles(self:GetAngles())
		self.Scan3:SetPos(self:GetPos() + self:GetUp()*-12 + self:GetRight()*20)
		self.Scan3:Spawn()
		self.Scan1:SetSkin(0)
		self.Scan3:Activate() 
		self.Scan3:SetOwner(self)
		self:SetGroundEntity(NULL)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	self:EmitSound("npc/vortsynth/vort_attack_shoot" .. math.random(3, 4) .. ".wav",100,math.random(90, 110))
	self:StopSound("npc/vort/attack_charge.wav")
	if self.RangeAttackPos then
			local source = self:GetAttachment(1).Pos
			local tr = util.TraceLine({
				start = source,
 				endpos = source + (self.RangeAttackPos - (source+VectorRand(-20,20))):GetNormalized()*10000,
				mask = MASK_SHOT,
				filter = self,
		})
		util.ParticleTracerEx("wasteland_scanner_beam",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),1)
		util.ParticleTracerEx("assassin_flechette_trail",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),1)
		util.VJ_SphereDamage(self,self,tr.HitPos,200,self.RangeAttackDamage,bit.bor(DMG_SHOCK),true,true,false,false)
	end

	if self.RangeAttackPos then
			local source = self:GetAttachment(2).Pos
			local tr = util.TraceLine({
				start = source,
 				endpos = source + (self.RangeAttackPos - (source+VectorRand(-20,20))):GetNormalized()*10000,
				mask = MASK_SHOT,
				filter = self,
		})
		util.ParticleTracerEx("wasteland_scanner_beam",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),2)
		util.ParticleTracerEx("assassin_flechette_trail",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),2)
		util.VJ_SphereDamage(self,self,tr.HitPos,400,self.RangeAttackDamage,bit.bor(DMG_SHOCK),true,true,false,false)
	end

	if self.RangeAttackPos then
			local source = self:GetAttachment(3).Pos
			local tr = util.TraceLine({
				start = source,
 				endpos = source + (self.RangeAttackPos - (source+VectorRand(-20,20))):GetNormalized()*10000,
				mask = MASK_SHOT,
				filter = self,
		})
		util.ParticleTracerEx("wasteland_scanner_beam",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),3)
		util.ParticleTracerEx("assassin_flechette_trail",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),3)
		util.VJ_SphereDamage(self,self,tr.HitPos,200,self.RangeAttackDamage,bit.bor(DMG_SHOCK),true,true,false,false)
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
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	local myPos = self:GetPos()
	local defAngle = Angle(0, 0, 0)

	ParticleEffect("CoolFireball", myPos, defAngle)
	ParticleEffect("grenade_explosion_01", myPos, defAngle)
	VJ.EmitSound(self, "npc/roller/mine/rmine_explode_shock1.wav", 80, 100)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 90, 100)
	VJ.ApplyRadiusDamage(self, self, myPos, 128, 36, bit.bor(DMG_BLAST), true, true, {DisableVisibilityCheck=true, Force=150})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:EmitSound( "NPC_Vortigaunt.ZapPowerup", 100, 150, 1, CHAN_AUTO, SND_STOP )
end