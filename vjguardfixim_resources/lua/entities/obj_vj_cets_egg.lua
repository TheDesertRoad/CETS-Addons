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

ENT.Model = {"models/props_phx/misc/egg.mdl"}

ENT.SoundTbl_OnCollide = {"physics/metal/metal_grenade_impact_hard1.wav", "physics/metal/metal_grenade_impact_hard2.wav", "physics/metal/metal_grenade_impact_hard3.wav"}

ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 65
ENT.CollisionDecal = "Scorch"

ENT.RadiusDamageRadius = 250 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 75 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy

ENT.VJ_ID_Grabbable = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.StartTime = CurTime()
	self.NextBlip = CurTime()

	local pos = self:GetPos()

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
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
    if data.Speed > 1 then
        self:Fire("Break", "", 0)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(plyUse)
	plyUse:PickupObject( self )
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()
	VJ.EmitSound(self, "weapons/explode_alt" .. math.random(3, 5) .. ".wav", 80, 100)
end