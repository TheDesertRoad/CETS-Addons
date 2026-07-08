AddCSLuaFile()
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Extractor"
ENT.Author 			= ""
ENT.Spawnable = false

ENT.Model = "models/effects/combineball.mdl"
ENT.CollisionBehavior = VJ.PROJ_COLLISION_PERSIST
ENT.ProjectileType = VJ.PROJ_TYPE_PROP
ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 65

ENT.SoundTbl_Idle = "weapons/physcannon/energy_sing_loop4.wav"
ENT.SoundTbl_OnCollide = false
ENT.CollisionDecal = false

ENT.RadiusDamageRadius = 1 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 1 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy

ENT.VJ_ID_Grabbable = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("obj_vj_combineball", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "prop_combine_ball")

	function ENT:Draw()
		self:DrawModel()
		self:SetAngles((LocalPlayer():EyePos() - self:GetPos()):Angle())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdHit = {"weapons/physcannon/energy_disintegrate4.wav", "weapons/physcannon/energy_disintegrate5.wav"}
--
function ENT:OnCollision(data, phys)
	local owner = self:GetOwner()
	local dataEnt = data.HitEntity

	if IsValid(self) && dataEnt:IsNPC() or dataEnt:IsPlayer() then
		self:Destroy()
		util.BlastDamage(self, owner, data.HitPos, 500, 50)
		local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(GetConVar("sk_cets_kiscrotums_dirdam"):GetInt())
			dmgInfo:SetDamageType(DMG_DISSOLVE)
			dmgInfo:SetAttacker(owner)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamagePosition(data.HitPos)
			VJ.DamageSpecialEnts(owner, dataEnt, dmgInfo)
			dataEnt:TakeDamageInfo(dmgInfo, self)
	end
	
	local dataF = EffectData()
	local dataAng = self:GetAngles()
	dataF:SetOrigin(data.HitPos)

	VJ.CreateSound(dataEnt, sdHit, 80)
	dataF = EffectData()
	dataF:SetOrigin(data.HitPos)
	dataF:SetAngles(dataAng)
	dataF:SetScale(10)
	dataF:SetNormal(data.HitNormal)
	util.Effect("AR2Impact", dataF)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCoreType(capture)
	if capture then
		self:SetSubMaterial(0, "models/effects/comball_glow1")
	else
		self:SetSubMaterial(0, "vj_base/effects/comball_glow2")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GravGunPunt(ply)
	self:SetCoreType(false)
	self:GetPhysicsObject():EnableMotion(true)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.StartTime = CurTime()
	self.NextBlip = CurTime()

	self:DrawShadow(false)
	self:ResetSequence("idle")
	self:SetCoreType(false)

	ParticleEffectAttach("comball_cets",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("comball_glow_cets",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	local owner = self:GetOwner()
	if IsValid(owner) && owner:IsPlayer() then
		self.DirectDamage = GetConVar("sk_cets_kiscrotums_dirdamply"):GetInt()
	end

	ParticleEffectAttach("combineball", PATTACH_POINT_FOLLOW, self, 1)
	util.SpriteTrail(self, 0, colorWhite, true, 24, 1, 1, 1 / 6 * 0.5, "sprites/combineball_trail_black_1.vmt")

	hook.Add("GravGunOnPickedUp", self, function(_, ply, ent)
		if ent == self then
			self:SetCoreType(true)
		end
	end)

	hook.Add("GravGunOnDropped", self, function(_, ply, ent)
		if ent == self then
			self:SetCoreType(false)
		end
	end)

	hook.Add("OnPlayerPhysicsPickup", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	hook.Add("OnPhysgunPickup", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	timer.Simple(6, function()
		if IsValid(self) then
			self:Destroy()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorWhite = Color(255, 255, 255, 72)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	timer.Remove("VJ_Z_ExtractorBlipTimer")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(plyUse)
	plyUse:PickupObject( self )
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)

local color1 = Color(255, 255, 225, 16)
local color2 = Color(255, 255, 225, 32)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()
	
	VJ.EmitSound(self, "weapons/physcannon/energy_sing_explosion2.wav", 85, math.random(95, 105))
	util.ScreenShake(myPos, 20, 150, 1, 1250)
	VJ.ApplyRadiusDamage(self, self, myPos, 500, GetConVar("sk_cets_kiscrotums_dieraddam"):GetInt(), bit.bor(DMG_SONIC, DMG_BLAST, DMG_DISSOLVE), true, true, {DisableVisibilityCheck=true, Force=80})
	
	local effectData = EffectData()
	effectData:SetOrigin(myPos)
	effectData:SetScale(500)
	util.Effect("HelicopterMegaBomb", effectData)
	util.Effect("ThumperDust", effectData)

	local myPos = self:GetPos()
	effects.BeamRingPoint(myPos, 0.3, 12, 1024, 72, 0, color1, {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})
	effects.BeamRingPoint(myPos, 0.6, 12, 1024, 72, 0, color2, {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})

	local effectData = EffectData()
	effectData:SetOrigin(myPos)
	util.Effect("cball_explode", effectData)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "300")
	expLight:SetLocalPos(myPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "255 150 0")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)

	self:SetLocalPos(myPos + vecZ4) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos - vezZ100,
		filter = self
	})
	
	self:DealDamage()
end