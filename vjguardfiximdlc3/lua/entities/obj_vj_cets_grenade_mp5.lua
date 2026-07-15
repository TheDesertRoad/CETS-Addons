/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "MP5 Grenade"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"

ENT.VJ_ID_Danger = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("obj_vj_grenade_rifle", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "grenade_ar2")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/weapons/hl2_mp5_grenade.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 150
ENT.RadiusDamage = 80
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_BLAST
ENT.RadiusDamageForce = 90
ENT.CollisionDecal = "Scorch"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	self:PhysicsInitSphere(5, "metal_bouncy")
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddAngleVelocity(Vector(0, math.random(300, 400), 0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffectAttach("Rocket_Smoke_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
--
function ENT:OnDestroy(data, phys)
	local myPos = self:GetPos()

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
		VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 100, 100)
		util.ScreenShake(myPos, 100, 200, 1, 1024)
	
		local effectData = EffectData()
		effectData:SetOrigin(myPos)
		util.Effect("Explosion", effectData)

		local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "2")
		expLight:SetKeyValue("distance", "256")
		expLight:SetLocalPos(myPos)
		expLight:SetLocalAngles(self:GetAngles())
		expLight:Fire("Color", "255 128 10")
		expLight:SetParent(self)
		expLight:Spawn()
		expLight:Activate()
		expLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(expLight)
	end
end