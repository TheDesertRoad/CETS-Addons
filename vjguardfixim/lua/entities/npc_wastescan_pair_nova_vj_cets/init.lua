AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_wscanner_tri.mdl"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetSkin(1)
	self:SetCollisionBounds(Vector(66, 33, 52), Vector(-66, -33, -30))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_VEHICLE ) or dmginfo:IsDamageType( DMG_SONIC ) or dmginfo:IsDamageType( DMG_BLAST ) or dmginfo:IsDamageType( DMG_SONIC ) or dmginfo:IsDamageType( DMG_DISSOLVE ) then 
		self:Remove(self)
		self:EmitSound("npc/waste_scanner/detach.wav",100,math.random(90, 110))
		ParticleEffect("assassin_projectile_explosion_1",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

		self.Scan1 = ents.Create("npc_wastescan_vj_cets_ns")
		self.Scan1:SetAngles(self:GetAngles())
		self.Scan1:SetPos(self:GetPos() + self:GetUp()*20)
		self.Scan1:Spawn()
		self.Scan1:SetSkin(1)
		self.Scan1:Activate() 
		self.Scan1:SetOwner(self)
		self:SetGroundEntity(NULL)

		self.Scan2 = ents.Create("npc_wastescan_vj_cets_ns")
		self.Scan2:SetAngles(self:GetAngles())
		self.Scan2:SetPos(self:GetPos() + self:GetUp()*-12 + self:GetRight()*-20)
		self.Scan2:Spawn()
		self.Scan2:SetSkin(1)
		self.Scan2:Activate() 
		self.Scan2:SetOwner(self)
		self:SetGroundEntity(NULL)

		self.Scan3 = ents.Create("npc_wastescan_vj_cets_ns")
		self.Scan3:SetAngles(self:GetAngles())
		self.Scan3:SetPos(self:GetPos() + self:GetUp()*-12 + self:GetRight()*20)
		self.Scan3:Spawn()
		self.Scan3:SetSkin(1)
		self.Scan3:Activate() 
		self.Scan3:SetOwner(self)
		self:SetGroundEntity(NULL)
	end
end