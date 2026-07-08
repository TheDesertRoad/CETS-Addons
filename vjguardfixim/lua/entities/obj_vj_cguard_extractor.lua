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

ENT.Model = {"models/weapons/w_cgrenade.mdl"}

ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 65

ENT.SoundTbl_Idle = "weapons/physcannon/energy_sing_loop4.wav"
ENT.SoundTbl_OnCollide = {"phx/epicmetal_hard.wav", "phx/epicmetal_hard1.wav", "phx/epicmetal_hard2.wav", "phx/epicmetal_hard3.wav", "phx/epicmetal_hard4.wav", "phx/epicmetal_hard5.wav", "phx/epicmetal_hard6.wav", "phx/epicmetal_hard7.wav"}

ENT.RadiusDamageRadius = 400 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 15 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy

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

	util.SpriteTrail(self, 1, Color(255, 255, 204), true, 10, 1, 1.0, 0.1, "sprites/physbeam2")

	timer.Simple(3, function()
		if IsValid(self) then
			self:Destroy()
		end
	end)

	timer.Create("VJ_Z_ExtractorBlipTimer", 0.4, 0, function() self:EmitSound("npc/scanner/scanner_electric" .. math.random(1, 2) .. ".wav", 85, math.random(120, 150)) end)

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
local color2 = Color(255, 255, 225, 32)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()
	
	ParticleEffect("grenade_explosion_01", myPos, defAngle)
	VJ.EmitSound(self, "hl1/weapons/hegrenade-" .. math.random(1, 2) .. ".wav", 80, 100)
	VJ.EmitSound(self, "hl1/weapons/sgun1.wav", 80, 100)
	VJ.EmitSound(self, "weapons/physcannon/energy_sing_explosion2.wav", 85, math.random(80, 90))
	util.ScreenShake(myPos, 20, 150, 1, 1250)
	VJ.ApplyRadiusDamage(self, self, myPos, 400, 25, bit.bor(DMG_SONIC, DMG_BLAST, DMG_DISSOLVE), true, true, {DisableVisibilityCheck=true, Force=80})
	
	local effectData = EffectData()
	effectData:SetOrigin(myPos)
	effectData:SetScale(500)
	util.Effect("HelicopterMegaBomb", effectData)
	util.Effect("ThumperDust", effectData)

	local myPos = self:GetPos()
	effects.BeamRingPoint(myPos, 0.2, 12, 1024, 64, 0, color1, {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})
	effects.BeamRingPoint(myPos, 0.5, 12, 1024, 64, 0, color2, {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})

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
	util.Decal(VJ.PICK(self.CollisionDecal), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	
	self:DealDamage()
end