AddCSLuaFile()
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_grenade"
ENT.PrintName		= "Extractor"
ENT.Author 			= ""
ENT.Spawnable = false

ENT.Model = {"models/weapons/w_hopwire.mdl"}

ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 65
ENT.CollisionDecal = "BeerSplash"

ENT.SoundTbl_OnCollide = {"hl1/player/pl_organic1.wav", "hl1/player/pl_organic2.wav", "hl1/player/pl_organic3.wav", "hl1/player/pl_organic4.wav"}

ENT.RadiusDamageRadius = 120 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 56 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy

ENT.VJ_ID_Grabbable = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.StartTime = CurTime()
	self.NextBlip = CurTime()

	hook.Add("GravGunOnPickedUp", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
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

	util.SpriteTrail(self, 1, Color(16, 255, 170), true, 6, 1, 1.0, 0.1, "sprites/baku_burntcer_smoke")

	timer.Simple(3, function()
		if IsValid(self) then
			self:Destroy()
		end
	end)

	local pos = self:GetPos()
	local function beepSound(time, snd)
		timer.Simple(time, function()
			sound.Play(snd, pos, 100)
		end)
	end

	beepSound(0, "weapons/grenade/bio_tick1.wav", 70)
	beepSound(1, "weapons/grenade/bio_tick1.wav", 80)
	beepSound(2, "weapons/grenade/bio_tick1.wav", 90)
	beepSound(3, "weapons/grenade/bio_tick1.wav", 100)
end
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
local color2 = Color(16, 255, 170, 32)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()
	
	ParticleEffect("assassin_projectile_explosion_1", myPos, defAngle)
	ParticleEffect("gas_misc_cets1", myPos, defAngle)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 80, math.random(90, 100))
	VJ.EmitSound(self, "hl1/weapons/splauncher_fire.wav", 100, 100)
	VJ.EmitSound(self, "npc/ministrider/flechette_explode" .. math.random(1, 3) .. ".wav", 100, math.random(90, 100))
	util.ScreenShake(myPos, 10, 100, 1, 400)
	VJ.ApplyRadiusDamage(self, self, myPos, 360, 25, bit.bor(DMG_PARALYZE, DMG_BLAST), true, true, {DisableVisibilityCheck=true, Force=80})

	local myPos = self:GetPos()
	effects.BeamRingPoint(myPos, 0.3, 12, 1024, 24, 0, color2)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "5")
	expLight:SetKeyValue("distance", "512")
	expLight:SetLocalPos(myPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "16 255 150")
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
	util.Decal(VJ.PICK(self.CollisionDecal), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	
	self:DealDamage()
end