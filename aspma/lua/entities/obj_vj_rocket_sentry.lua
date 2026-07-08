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
ENT.Model = "models/props_bts/rocket.mdl"
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
function ENT:OnDestroy(data, phys)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 150, 100)
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale( 500 )
	util.Effect("Explosion", effectdata )

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "300")
	expLight:SetLocalPos(data.HitPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "255 150 0")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffectAttach("vj_rocket_idle1", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end