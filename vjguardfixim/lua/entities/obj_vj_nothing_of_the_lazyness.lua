/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "LAZYNESS!!"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_medium.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = false
ENT.RadiusDamageRadius = 0
ENT.RadiusDamage = 0
ENT.RadiusDamageUseRealisticRadius = false
ENT.RadiusDamageType = DMG_GENERIC

local defAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetNotSolid(true)
	self:SetCollisionBounds(Vector(1, 1, 1), Vector(0, 0, 0))

	timer.Simple(0.1, function()
		if IsValid(self) then
			self:TakeDamage(self:Health(), self, self)
		end
	end)
end