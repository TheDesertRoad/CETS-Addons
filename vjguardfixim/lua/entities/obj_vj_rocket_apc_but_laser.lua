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

ENT.SoundTbl_Idle = "weapons/physcannon/energy_sing_loop4.wav"
ENT.SoundTbl_OnCollide = {"weapons/physcannon/energy_disintegrate4.wav", "weapons/physcannon/energy_disintegrate5.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw( true )

	local light = ents.Create( "env_sprite" )
	light:SetKeyValue( "model","sprites/strider_blackball.spr" )
	light:SetKeyValue( "rendercolor","255 255 255" )
	light:SetKeyValue( "renderamt","255" )
	light:SetKeyValue( "rendermode","8" )
	light:SetPos( self:GetAttachment(1).Pos )
	light:SetParent( self,1 )
	light:SetKeyValue( "scale",".1" )
	light:Spawn()
	self:DeleteOnRemove(light)

	util.SpriteTrail(self, 1, Color(0, 255, 255), true, 12, 0, 1, 1 / 6 * 0.5, "sprites/bluelaser1")
end
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
	local myPos = self:GetPos()
	VJ.EmitSound(self, "weapons/physcannon/energy_sing_explosion2.wav", 100, 100)
	util.ScreenShake(myPos, 100, 200, 1, 1024)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "2")
	expLight:SetKeyValue("distance", "256")
	expLight:SetLocalPos(myPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "10 128 255")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)

	local myPos = self:GetPos()
	effects.BeamRingPoint(myPos, 0.2, 12, 1024, 64, 0, Color(0, 0, 225, 32), {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})
	effects.BeamRingPoint(myPos, 0.5, 12, 1024, 64, 0, Color(0, 0, 225, 32), {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})
end