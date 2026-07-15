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

ENT.Model = {"models/weapons/w_comgrenade_sonic.mdl"}

ENT.SoundTbl_OnCollide = {"physics/metal/metal_grenade_impact_hard1.wav", "physics/metal/metal_grenade_impact_hard2.wav", "physics/metal/metal_grenade_impact_hard3.wav"}

ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 65
ENT.CollisionDecal = "Scorch"

ENT.RadiusDamageRadius = 320 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 75 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageType = DMG_SONIC

ENT.VJ_ID_Grabbable = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.StartTime = CurTime()
	self.NextBlip = CurTime()

	local pos = self:GetPos()
	local pitch = math.random(105, 115)
	local function beepSound(time, snd)
		timer.Simple(time, function()
			sound.Play(snd, pos, 80, pitch)
		end)
	end

	beepSound(0, "weapons/grenade/timebomb1.wav")
	beepSound(1.0, "weapons/grenade/timebomb1.wav")
	beepSound(1.9, "weapons/grenade/timebomb2.wav")

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

	util.SpriteTrail(self, 1, Color(0, 100, 255), true, 8, 0.5, 1.0, 0.1, "effects/blueblacklargebeam")

	timer.Simple(2, function()
		if IsValid(self) then
			self:Destroy()
			VJ.ApplyRadiusDamage(self, self, self:GetPos(), self.RadiusDamageRadius, self.RadiusDamage, self.RadiusDamageType, true, true, {DisableVisibilityCheck=true, Force=80})
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(plyUse)
	plyUse:PickupObject( self )
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)

local color1 = Color(32, 100, 225, 16)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()

	self:SetLocalPos(myPos + vecZ4) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos - vezZ100,
		filter = self
	})

	if self:WaterLevel() > 1 then 
		local surface = myPos
		local ed = EffectData()
		ed:SetOrigin(myPos)
		util.Effect("WaterSurfaceExplosion", ed, true, true)

		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos + Vector(0,0,32768),
			mask = MASK_WATER
		})

		if tr.Hit then
			local effect = EffectData()
			effect:SetOrigin(tr.HitPos - tr.HitNormal)
			effect:SetNormal(tr.HitNormal)
			util.Effect("WaterSurfaceExplosion", effect)
		end

		VJ.EmitSound(self, "weapons/underwater_explode" .. math.random(3, 4) .. ".wav", 80, 100)
		util.ScreenShake(myPos, 5, 35, 1, 313)
	else
		VJ.EmitSound(self, "weapons/sonic_explode.wav", 100, math.random(95, 105))
		VJ.EmitSound(self, "hl1/misc/ear_ringing.wav", 70, 100)
		util.ScreenShake(myPos, 60, 70, 1, 4096)

		effects.BeamRingPoint(myPos, 0.5, 30, 1024, 75, 0, color1)

		ParticleEffect("hunter_projectile_explosion_1", self:GetPos(), Angle(0,0,0))

		local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "2")
		expLight:SetKeyValue("distance", "256")
		expLight:SetLocalPos(myPos)
		expLight:SetLocalAngles(self:GetAngles())
		expLight:Fire("Color", "32 100 255")
		expLight:SetParent(self)
		expLight:Spawn()
		expLight:Activate()
		expLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(expLight)

		self:DealDamage()
	end

	util.Decal(VJ.PICK(self.CollisionDecal), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
end