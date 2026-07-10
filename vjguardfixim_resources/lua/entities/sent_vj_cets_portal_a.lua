/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "obj_vj_spawner_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Portal"
ENT.Author 			= "VALVe"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.SingleSpawner = true
ENT.PauseSpawning = true

ENT.Spawner_Distance = 400
ENT.Spawner_NextCheckT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ45 = Vector(0, 0, 45)
local vecNZ20 = Vector(0, 0, -20)

local Aliens = {
	[2] = "npc_aliencontroller_vj_cets",
	[4] = "npc_aliengrunt_vj_cets",
	[8] = "npc_bullchicken_water_vj_cets",
	[16] = "npc_bullchicken_vj_cets",
	[32] = "npc_hound_explo_vj_cets",
	[64] = "npc_hound_normal_vj_cets",
	[128] = "npc_panthereye_vj_cets",
	[256] = "npc_slave_vj_cets",
	[512] = "npc_stukabat_vj_cets",
	[1024] = "npc_headcrab",
	[2048] = "npc_headcrab_black",
	[4096] = "npc_headcrab_fast",
	[8192] = "npc_reviver_vj_cets",
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
function ENT:OnThink()
	if self.PauseSpawning && VJ_CVAR_AI_ENABLED && CurTime() > self.Spawner_NextCheckT then
		for _, v in ipairs(ents.FindInSphere(self:GetPos(), self.Spawner_Distance)) do
			if v:IsPlayer() && (v.VJ_IsControllingNPC or VJ_CVAR_IGNOREPLAYERS) then continue end
			if v.VJ_ID_Living && v:Alive() && !v:IsFlagSet(FL_NOTARGET) && self:Visible(v) && (!v.VJ_NPC_Class or !VJ.HasValue(v.VJ_NPC_Class)) then
				self:ActivateSpawner(v)
				break
			end
		end
		self.Spawner_NextCheckT = CurTime() + 0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ActivateSpawner(eneEnt)
	local myPos = self:GetPos()
	self.PauseSpawning = false

	self:SetAngles(Angle(self:GetAngles().x, ((eneEnt:GetPos()) - myPos):Angle().y, self:GetAngles().z)) -- Make sure it spawns the entity facing the enemy

	VJ.CETS_Effect_SpwPrtl(myPos, nil, "0 255 0" or nil, function()
		-- onSpawn
		if IsValid(self) then
			for k, v in ipairs(self.EntitiesToSpawn) do
				self:SpawnEntity(k, v, true)
			end
		end
	end)
end