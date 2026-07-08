AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.IdleAlwaysWander = true
ENT.IsGuard = false
ENT.CanFlinch = 0
ENT.AnimTbl_CallForHelp = false

ENT.HasMeleeAttack = true

ENT.HasGrenadeAttack = false

local mdlMisfits = {
	"models/humans/hobo.mdl",
	"models/humans/hobo2.mdl",
	"models/humans/milkdrinker.mdl",
	"models/humans/larry.mdl",
	"models/humans/alyn.mdl",
}

local Weapon_None = -1
local Weapon_MP5K = 1
local Weapon_Shotgun = 2
local Weapon_SMG1 = 3

ENT.Weapon_Rand = Weapon_None

ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	local flags = self:GetSpawnFlags()
	self.Model = mdlMisfits
	self.Weapon_CanReload = true

	if bit.band(flags, 64) ~= 0 or self:HasSpawnFlags(64) then
		self.Weapon_Rand = 1
		self:MaleSounds()
		self.AnimTbl_WeaponReload = "reload_smg1_original"
		self.AnimTbl_WeaponReloadCovered = "reload_smg1_alt_original"
		self:Give("weapon_vj_cets_mp5k")

	elseif bit.band(flags, 128) ~= 0 or self:HasSpawnFlags(128) then
		self.Weapon_Rand = 2
		self:MaleSounds()
		self.AnimTbl_WeaponReload = "reload_shotgun_original"
		self.AnimTbl_WeaponReloadCovered = "reload_shotgun_alt_original"
		self:Give("weapon_vj_cets_spas12")

	elseif bit.band(flags, 256) ~= 0 or self:HasSpawnFlags(256) then
		self.Weapon_Rand = 3
		self:MaleSounds()
		self.AnimTbl_WeaponReload = "reload_smg1_original"
		self.AnimTbl_WeaponReloadCovered = "reload_smg1_alt_original"
		self:Give("weapon_vj_cets_smg1")

	else
		if math.random(1, 3) == 1 then
			self.Weapon_Rand = 1
			self:MaleSounds()
			self.AnimTbl_WeaponReload = "reload_smg1_original"
			self.AnimTbl_WeaponReloadCovered = "reload_smg1_alt_original"
			self:Give("weapon_vj_cets_mp5k")

		elseif math.random(1, 3) == 2 then
			self.Weapon_Rand = 2
			self:MaleSounds()
			self.AnimTbl_WeaponReload = "reload_shotgun_original"
			self.AnimTbl_WeaponReloadCovered = "reload_shotgun_alt_original"
			self:Give("weapon_vj_cets_spas12")

		else
			self.Weapon_Rand = 3
			self:MaleSounds()
			self.AnimTbl_WeaponReload = "reload_smg1_original"
			self.AnimTbl_WeaponReloadCovered = "reload_smg1_alt_original"
			self:Give("weapon_vj_cets_smg1")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self.BlackAmount = 0

	self.Squadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	local flags = self:GetSpawnFlags()

	if !IsValid(SquadC_Leader) or bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
		VJ.SquadC_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_yield_leader = vj_ai_schedule.New("SCHEDULE_YIELD_LEADER")
schedule_yield_leader:EngTask("TASK_MOVE_AWAY_PATH", 120)
schedule_yield_leader:EngTask("TASK_WALK_PATH", 0)
schedule_yield_leader:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schedule_yield_leader.TurnData = {Type = VJ.FACE_ENTITY_VISIBLE, Target = nil}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink(ent)
	local flags = self:GetSpawnFlags()

	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))

	local leader = VJ.SquadC_Leader

	if IsValid(leader) then
		if leader ~= self then
			self.DisableWandering = true
			if IsValid(self:GetEnemy()) or self:IsBusy() then return end

			local targetPos = leader:GetPos() + self.Squadrant_FollowOffsetPos
			local leaderSpeed = leader:GetVelocity():Length()

			local pos = leader:GetPos() + self.Squadrant_FollowOffsetPos
			local dist = self:GetPos():Distance(leader:GetPos())

			if dist < 75 and not self:IsBusy() then
				schedule_yield_leader.TurnData.Target = leader
				self:StartSchedule(schedule_yield_leader)
				return
			end

			self.DisableWandering = true

			if leaderSpeed < 5 and dist < 100 then
				self:StopMoving()
				return
			end

			if not self.NextLeaderMove or CurTime() > self.NextLeaderMove then
				self.NextLeaderMove = CurTime() + 0.5
				self:SetLastPosition(leader:GetPos() + self.Squadrant_FollowOffsetPos)

				if leader.Alerted then
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
				else
					self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
				end
			end
		end
	else
		self.DisableWandering = false
		if bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) or self:IsValid() then
			VJ.SquadC_Leader = self
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	if self.Weapon_Rand == 1 then
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local mp5k = ents.Create("weapon_vj_cets_mp5k")
			mp5k:SetPos(att.Pos)
			mp5k:SetAngles(att.Ang)
			mp5k:Spawn()
		end

	elseif self.Weapon_Rand == 2 then
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local shotgun = ents.Create("weapon_shotgun")
			shotgun:SetPos(att.Pos)
			shotgun:SetAngles(att.Ang)
			shotgun:Spawn()
		end

	elseif self.Weapon_Rand == 3 then
		for i = 1, 1 do
			local att = self:GetAttachment(1 +i)
			local smg1 = ents.Create("weapon_smg1")
			smg1:SetPos(att.Pos)
			smg1:SetAngles(att.Ang)
			smg1:Spawn()
		end
	end
end