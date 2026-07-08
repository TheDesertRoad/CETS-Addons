/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Fungal Fauna Body"
ENT.Author 			= "VALVe"

if !SERVER then return end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/fungalfauna_body.mdl")
	self:SetCollisionBounds(Vector(6, 6, 32), Vector(-6, -6, 2))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)

	self.Nugger = ents.Create("item_grubnugget")
	self.Nugger:SetPos(self:GetPos() + self:GetUp() * 72 + self:GetForward() * math.random(-24, 24)  + self:GetRight() * math.random(-24, 24))
	self.Nugger:SetSkin(self:GetSkin())
	self.Nugger:SetAngles(self:GetAngles())
	self.Nugger:Spawn()
	self.Nugger:Activate()
	self.Nugger:SetModelScale(2)
end