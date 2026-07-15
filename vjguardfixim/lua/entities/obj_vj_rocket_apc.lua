AddCSLuaFile()
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_rocket"
ENT.PrintName		= "Missile"
ENT.Spawnable = false

ENT.RadiusDamage = GetConVar("sk_apc_missile_damage"):GetInt()
ENT.RadiusDamageRadius = 130
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(0.2, function() if IsValid(self) then

		local timer_name = "vj_timer_rock" .. self:EntIndex()
		timer.Create(timer_name, 0.05, 0, function()
			if IsValid(self) && self.Target && IsValid(self.Target) then

				local own = self:GetOwner()
				local enemyvisible = false
				if IsValid(own) && IsValid(own:GetEnemy()) then
					enemyvisible = own:Visible(own:GetEnemy())
				end

				if enemyvisible then
					local idealang = ( self.Target:GetPos()+self.Target:OBBCenter() - self:GetPos() ):Angle()
					local ang = LerpAngle(0.22,self:GetAngles(),idealang)
					self:SetAngles(ang)
					self:GetPhysicsObject():SetVelocity( self:GetForward()*self.Speed )
				end

				local targetdist = self:GetPos():Distance(self.Target:GetPos())
				if targetdist < 200 then
					timer.Remove(timer_name)
				end

			else
				timer.Remove(timer_name)
			end
		end)

	end end)

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:GetPhysicsObject():GetAngleVelocity() != Vector(0,0,0) then
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function GetWaterSurface(myPos)
	local surface = myPos

	while bit.band(util.PointContents(surface), CONTENTS_WATER) ~= 0 do
		surface = surface + Vector(0, 0, 8)
	end

	return surface
end
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffectAttach("vj_rocket_idle1", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end