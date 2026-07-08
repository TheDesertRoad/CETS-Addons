AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_engineer.mdl"}
ENT.StartHealth = 50
ENT.Weapon_Accuracy = 2
ENT.Weapon_MinDistance = 8 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 1500 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 80
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 0.82 -- Time until the grenade is released
ENT.GrenadeAttackEntity = "npc_grenade_frag" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations

ENT.CanUseSecondaryOnWeaponAttack = true -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
	"weapon_frag",
}

ENT.Combine_TurretEnt = NULL
ENT.Combine_TurretPlacing = false
ENT.Combine_NextTurretCheckT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_spas12")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Combine_DeployTurret()
	local angles = self:GetAngles()
	local mypos = self:GetPos()
	self.IsDeployingTurret = 1

	if self.Combine_NextTurretCheckT < CurTime() && !self.Combine_TurretPlacing && !IsValid(self.Combine_TurretEnt) then
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*80,
			filter = self
		})
		-- Make sure not to place it if the front of the NPC is blocked!
		if !tr.Hit then
			self.Combine_NextTurretCheckT = CurTime() + 30
			self.Combine_TurretPlacing = true
			self:PlayAnim("vjseq_Turret_Drop" , true, false, false)
			timer.Simple(0.9, function()
				if IsValid(self) && !IsValid(self.Combine_TurretEnt) then
					local turret = ents.Create("npc_engi_sentry_vj_cets")
					turret:SetPos(self:GetPos() + self:GetForward()*50)
					turret:SetAngles(self:GetAngles())
					turret:Spawn()
					turret:Activate()
					turret.VJ_NPC_Class = self.VJ_NPC_Class
					turret:SetState(VJ_STATE_FREEZE, 1)
					VJ.EmitSound(turret, "npc/roller/blade_cut.wav", 75, 100)
					self.Combine_TurretEnt = turret
					self.Combine_TurretPlacing = false
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if !self.VJ_IsBeingControlled && IsValid(self:GetEnemy()) && self.EnemyData.Visible then
		self:Combine_DeployTurret()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local shotgun = ents.Create("weapon_shotgun")
		shotgun:SetPos(att.Pos)
		shotgun:SetAngles(att.Ang)
		shotgun:Spawn()
	end
end