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
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ45 = Vector(0, 0, 45)
local vecNZ20 = Vector(0, 0, -20)

local Aliens = {
	[2] = "npc_shocktrooper_vj_cets",
	[4] = "npc_voltigore_vj_cets",
	[8] = "npc_voltigore_baby_vj_cets",
	[16] = "npc_pitdrone_vj_cets",
	[32] = "npc_shockroach_vj_cets",
	[64] = "npc_sporefish_vj_cets",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	local entTbl = Aliens
	local flags = self:GetSpawnFlags()
	local HasFlags = false
	
	for flag, npc in pairs(Aliens) do
		if bit.band(flags, flag) ~= 0 or self:HasSpawnFlags(flag) then
			entTbl = {npc}
			HasFlags = true
			break
		end
	end

	if not HasFlags then
		local npcList = {}

		for _, npc in pairs(Aliens) do
			table.insert(npcList, npc)
		end

		entTbl = {npcList[math.random(#npcList)]}
	end

	timer.Simple(0.02, function()
		if IsValid(self) then
			self:SetPos(self:GetPos() + vecZ45)
		end
	end)

	self.EntitiesToSpawn = {{Entities = entTbl, SpawnPosition = vecNZ20}}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ActivateSpawner(eneEnt)
	local myPos = self:GetPos()
	self.PauseSpawning = false

	self:SetAngles(Angle(self:GetAngles().x, ((eneEnt:GetPos()) - myPos):Angle().y, self:GetAngles().z)) -- Make sure it spawns the entity facing the enemy
	VJ.CETS_Effect_SpwPrtl_RX(myPos, nil, "255 86 255" or nil, function()
		-- onSpawn
		if IsValid(self) then
			for k, v in ipairs(self.EntitiesToSpawn) do
				self:SpawnEntity(k, v, true)
			end
		end
	end)
end