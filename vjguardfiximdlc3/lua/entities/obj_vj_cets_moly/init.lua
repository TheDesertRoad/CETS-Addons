AddCSLuaFile("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Acid Spit"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/weapons/w_molotov.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 80
ENT.RadiusDamage = 60
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_BURN
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = {"Scorch"}

ENT.MainSoundLevel = 90

ENT.IdleSoundPitch = VJ.SET(90,110)
ENT.OnCollideSoundPitch = VJ.SET(95,105)

ENT.SoundTbl_Idle = false
ENT.SoundTbl_OnCollide = {"ambient/fire/mtov_break1.wav", "ambient/fire/mtov_break2.wav"}
ENT.FireCount = 6
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:WaterLevel() > 0 then 
		local pos = self:GetPos() +self:GetAngles():Forward()
		effects.BubbleTrail(pos +Vector(-1, -1, -1), pos +Vector(1, 1, 1), math.random(0.3, 0.8), 0, 6, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	local myPos = self:GetPos()

	if self:WaterLevel() > 1 then 
		VJ.EmitSound(self, "weapons/underwater_explode" .. math.random(3, 4) .. ".wav", 100, 200)
		VJ.EmitSound(self, "ambient/fire/mtov_flame" .. math.random(1, 3) .. ".wav", 90)
		util.ScreenShake(myPos, 50, 50, 1, 500)

		ParticleEffect("water_gren_test1", self:GetPos(), Angle(0,0,0), nil)
		ParticleEffect("nigga_fire", myPos, defAngle)
	else
		ParticleEffect("nigga_fire", myPos, defAngle)
		VJ.EmitSound(self, "ambient/fire/mtov_flame" .. math.random(1, 3) .. ".wav", 90)
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
end