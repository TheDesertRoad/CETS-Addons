/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_cets_gascan_x2"
ENT.PrintName		= "Explosive Gascan"
ENT.Author 			= "DrVrej"

ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.Active		= false

local PartEffGasLeak = "gascan_gasleak2"
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then

function ENT:Initialize()
	self:SetModel("models/misc/cube025x025x025.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetNoDraw( true )
	self:DrawShadow( false )
	self.PhysgunDisabled = false
		
	local phys = self:GetPhysicsObject()	
		if (phys:IsValid()) then
			phys:Wake()
		end	
	end
end