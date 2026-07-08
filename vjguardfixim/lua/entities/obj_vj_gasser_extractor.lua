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

ENT.Model = {"models/weapons/w_eq_smokegrenade_thrown.mdl"}

ENT.SoundTbl_OnCollide = "weapons/smokegrenade/grenade_hit1.wav"

ENT.RadiusDamageRadius = 30 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 20 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:AddFlags(FL_GRENADE)
	timer.Simple(1, function()
		if IsValid(self) then
			self:Destroy()
		end
	end)
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()

	if self:WaterLevel() > 1 then 
		VJ.EmitSound(self, "weapons/smokegrenade/sg_explode.wav", 100, 100)
		util.ScreenShake(myPos, 50, 100, 1, 512)

		ParticleEffect("water_gren_test1", self:GetPos(), Angle(0,0,0), nil)
	else
		VJ.EmitSound(self, "weapons/smokegrenade/sg_explode.wav", 100, 100)

		self.Gas = ents.Create("npc_toxic_gas_vj_cets")
		self.Gas:SetPos(self:GetPos() + self:GetUp()*-2)
		self.Gas:Spawn()
		self.Gas:Activate() 
		self.Gas:SetOwner(self)
		self:SetGroundEntity(NULL)
	end
end