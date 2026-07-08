/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Xen Grenade Plant"
ENT.Author 			= "VALVe"

ENT.GrenGrab = 0

if !SERVER then return end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_cets_aliens/xen_grenade_plant.mdl")
	self:SetCollisionBounds(Vector(6, 24, 24), Vector(-6, -24, 2))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:ResetSequence("idle")
	self:DrawShadow(false)

	self.wall = ents.Create("prop_dynamic_override")
	self.wall:SetModel( "models/weapons/w_hopwire.mdl" )
	self.wall:SetPos(self:GetAttachment(1).Pos)
	self.wall:SetAngles(self:GetAngles())
	self.wall:SetOwner(self)
	self.wall:SetParent(self, self:LookupAttachment( "hand" ))
	self.wall:Spawn()
	self.wall:Activate()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use( entity )
	if entity:IsPlayer() && self.wall:IsValid() then
		self.User = entity
		self.wall:Remove()
		self.GrenGrab = 1

		self:ResetSequence("grenade_picked")

		VJ_EmitSound(self,"npc/misc/xen_grenade_picked.wav", 90, 100)
	end

	local wepUs = self.User:GetActiveWeapon()

	if SERVER and IsValid( self.User ) && self.wall:IsValid() then
		self.User:Give("weapon_ply_xenbionade_zero")
		self.User:GiveAmmo( 1, "XenBionade_CETS" )
	end

	timer.Simple(32,function() if IsValid(self) && self.GrenGrab == 1 then
		self.GrenGrab = 0

		self:ResetSequence("spawn_grenade")

		VJ_EmitSound(self,"npc/misc/xen_grenade_spawn_grenade.wav", 90, 100)

		timer.Simple(2,function() if IsValid(self) then
					self.wall = ents.Create("prop_dynamic_override")
					self.wall:SetModel( "models/weapons/w_hopwire.mdl" )
					self.wall:SetPos(self:GetAttachment(1).Pos)
					self.wall:SetAngles(self:GetAngles())
					self.wall:SetOwner(self)
					self.wall:SetParent(self, self:LookupAttachment( "hand" ))
					self.wall:Spawn()
					self.wall:Activate()

					ParticleEffect("stinger_spray_gas2", self:GetPos() + self:GetUp()*50, Angle(0,0,0), nil)
					VJ_EmitSound(self,"npc/stinger/stinger_spray02.wav", 90, 100)

					self:ResetSequence("idle")
				end
			end)
		end
	end)
end
