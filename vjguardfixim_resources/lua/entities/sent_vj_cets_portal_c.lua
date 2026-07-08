/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "sent_vj_cets_portal_a"
ENT.Type 			= "anim"
ENT.PrintName 		= "Portal"
ENT.Author 			= "VALVe"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local AliensANT = {
	"npc_antlion",
	"npc_antlion_worker",
	"npc_antlionguard",
	"npc_antheavy_vj_cets",
	"npc_antspitter_vj_cets",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ45 = Vector(0, 0, 45)
local vecNZ20 = Vector(0, 0, -20)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	local entTbl = AliensANT
	timer.Simple(0.02, function()
		if IsValid(self) then
			self:SetPos(self:GetPos() + vecZ45)
		end
	end)

	self.EntitiesToSpawn = {{
		Entities = entTbl,
		SpawnPosition = vecNZ20 -- Make the NPC spawn little bit down otherwise it tends to get stuck in ceilings
	}}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ActivateSpawner(eneEnt)
	local myPos = self:GetPos()
	self.PauseSpawning = false

	self:SetAngles(Angle(self:GetAngles().x, ((eneEnt:GetPos()) - myPos):Angle().y, self:GetAngles().z)) -- Make sure it spawns the entity facing the enemy
	VJ.CETS_Effect_SpwPrtl_ANT(myPos, nil, "255 255 0" or nil, function()
		-- onSpawn
		if IsValid(self) then
			for k, v in ipairs(self.EntitiesToSpawn) do
				self:SpawnEntity(k, v, true)
			end
		end
	end)
end