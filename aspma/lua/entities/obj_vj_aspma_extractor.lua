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

ENT.Model = {"models/weapons/portal_lemon_w.mdl"}

ENT.SoundTbl_OnCollide = {"physics/plaster/ceiling_tile_impact_soft1.wav", "physics/plaster/ceiling_tile_impact_soft2.wav", "physics/plaster/ceiling_tile_impact_soft3.wav"}

ENT.RadiusDamageRadius = 650 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 75 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy

ENT.FireCount = 8
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	timer.Remove("VJ_Z_ExtractorBlipTimer")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit()
	VJ.EmitSound(self, "weapons/lemon_mtov/throw" .. math.random(1, 2) .. ".wav", 90, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(1, function()
		if IsValid(self) then
			self:Destroy()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()
	
	ParticleEffect("barrel_explosion", myPos, defAngle)
	VJ.EmitSound(self, "weapons/lemon_mtov/detonate.wav")
	util.ScreenShake(myPos, 100, 100, 1, 1000)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "3")
	expLight:SetKeyValue("distance", "150")
	expLight:SetLocalPos(myPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "255 80 0")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)

	for i = 1,self.FireCount do
		self.FireThrows = ents.Create("npc_fire_throw_vj_cets")
		self.FireThrows:SetPos(self:GetPos() + Vector(math.random(-86, 86), math.random(-86, 86), 0))
		self.FireThrows:Spawn()
		self.FireThrows:Activate() 
		self.FireThrows:SetOwner(self)
		self:SetGroundEntity(NULL)
	end
end