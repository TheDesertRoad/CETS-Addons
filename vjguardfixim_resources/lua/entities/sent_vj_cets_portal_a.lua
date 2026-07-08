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

local Aliens = {
	"npc_aliencontroller_vj_cets",
	"npc_aliengrunt_vj_cets",
	"npc_bullchicken_water_vj_cets",
	"npc_bullchicken_vj_cets",
	"npc_hound_explo_vj_cets",
	"npc_hound_normal_vj_cets",
	"npc_panthereye_vj_cets",
	"npc_slave_vj_cets",
	"npc_stukabat_vj_cets",
	"npc_headcrab",
	"npc_headcrab_black",
	"npc_headcrab_fast",
}
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ45 = Vector(0, 0, 45)
local vecNZ20 = Vector(0, 0, -20)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	local entTbl = Aliens
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