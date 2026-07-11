AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_babycrab.mdl"
ENT.StartHealth = 5
ENT.HullType = HULL_TINY
ENT.CanChatMessage = false
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HeadcrabClassic.SpineControl",
    FirstP_Offset = Vector(3, 0, -1),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01" -- Particles to spawn when it's damaged
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.EntitiesToNoCollide = {"npc_babycrab_vj_cets", "npc_snark_vj_cets", "npc_gonarch_vj_cets"}

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = ACT_RANGE_ATTACK1
ENT.LeapAttackMaxDistance = 300
ENT.LeapAttackMinDistance = 0
ENT.TimeUntilLeapAttackDamage = 0.3
ENT.NextLeapAttackTime = 2
ENT.NextAnyAttackTime_Leap = 0.85
ENT.TimeUntilLeapAttackVelocity = 0.1
ENT.LeapAttackVelocityForward = 70
ENT.LeapAttackVelocityUp = 200
ENT.LeapAttackDamage = 1
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1}
ENT.LeapAttackStopOnHit = true
ENT.LeapAttackDamageDistance = 40

ENT.HasExtraMeleeAttackSounds = true
ENT.FootstepSoundTimerRun = 0.2
ENT.FootstepSoundTimerWalk = 0.2

ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav", "npc/headcrab_poison/ph_step2.wav", "npc/headcrab_poison/ph_step3.wav", "npc/headcrab_poison/ph_step4.wav"}
ENT.SoundTbl_Alert = {"npc/headcrab/alert1.wav"}
ENT.SoundTbl_Idle = {"npc/headcrab/idle1.wav", "npc/headcrab/idle2.wav", "npc/headcrab/idle3.wav"}
ENT.SoundTbl_LeapAttackJump = {"npc/headcrab/attack1.wav", "npc/headcrab/attack2.wav", "npc/headcrab/attack3.wav"}
ENT.SoundTbl_LeapAttackDamage = {"npc/headcrab/headbite.wav"}
ENT.SoundTbl_Pain = {"npc/headcrab/pain1.wav", "npc/headcrab/pain2.wav", "npc/headcrab/pain3.wav"}
ENT.SoundTbl_Death = {"npc/headcrab/die1.wav", "npc/headcrab/die2.wav"}
ENT.SoundTbl_IdleDialogue = {"npc/headcrab/idle1.wav", "npc/headcrab/idle2.wav", "npc/headcrab/idle3.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"npc/headcrab/alert1.wav", "npc/headcrab/idle1.wav", "npc/headcrab/idle2.wav", "npc/headcrab/idle3.wav"}

ENT.MainSoundPitch = 150
ENT.FootstepSoundPitch = 120
ENT.FootstepSoundLevel = 50

ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 10, 15), Vector(-8, -10, 0))

	local flags = self:GetSpawnFlags()

	if bit.band(flags, 8192) ~= 0 or self:HasSpawnFlags(8192) then
		VJ.EmitSound(self, "npc/headcrab/alert1.wav", 60, 70)
		timer.Simple(60, function() if self:IsValid() then self:TakeDamage(self:GetMaxHealth()) end end)
	end

	self.Squadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	if not IsValid(VJ.SquadC_Leader) then
		for _, ent in ipairs(ents.GetAll()) do
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_gonarch_vj_cets" then
					VJ.SquadC_Leader = ent
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_yield_leader = vj_ai_schedule.New("SCHEDULE_YIELD_LEADER")
schedule_yield_leader:EngTask("TASK_MOVE_AWAY_PATH", 120)
schedule_yield_leader:EngTask("TASK_WALK_PATH", 0)
schedule_yield_leader:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schedule_yield_leader.TurnData = {Type = VJ.FACE_ENTITY_VISIBLE, Target = nil}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(self:GetMaxHealth())
	end

	if self:WaterLevel() > 1 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
		self.IsGuard = true
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self:PlayAnim({"drown"}, true, false, true)
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(1)
		self:SetGravity(0)
		self:SetGravity(1)
	end


	local leader = VJ.SquadC_Leader

	if IsValid(leader) then
		if leader ~= self then
			self.DisableWandering = true
			if IsValid(self:GetEnemy()) or self:IsBusy() then return end

			local targetPos = leader:GetPos() + self.Squadrant_FollowOffsetPos
			local leaderSpeed = leader:GetVelocity():Length()

			local pos = leader:GetPos() + self.Squadrant_FollowOffsetPos
			local dist = self:GetPos():Distance(leader:GetPos())

			if dist < 10 and not self:IsBusy() then
				schedule_yield_leader.TurnData.Target = leader
				self:StartSchedule(schedule_yield_leader)
				return
			end

			self.DisableWandering = true

			if leaderSpeed < 5 and dist < 20 then
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
		for _, ent in ipairs(ents.GetAll()) do
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_gonarch_vj_cets" then
					VJ.SquadC_Leader = ent
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if not dmginfo:IsDamageType(DMG_PHYSGUN) then return end

	local ply = dmginfo:GetAttacker()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	local dir = ply:GetAimVector()

	local velocity =
		(dir * 1500) +   -- forward force
		Vector(0, 0, 300) -- slight lift

	self:SetVelocity(velocity)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTouch(ent)
	if (ent:IsPlayer() or ent:IsNPC()) && GetConVar("npc_bebcrab_stomp"):GetInt() == 1 then
		self:TakeDamage(self:Health() + 1, ent, ent)
		VJ.EmitSound(self, "npc/antlion_grub/explode.wav", 60, 70)
		ParticleEffectAttach("blood_impact_zombie_01",PATTACH_POINT_FOLLOW,self,0)

		local myPos = self:GetPos()
		self:SetLocalPos(myPos + vecZ4) -- Because the entity is too close to the ground
		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos - vezZ100,
			filter = self
		})

		util.Decal(VJ.PICK("YellowBlood"), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if dmginfo:IsDamageType( DMG_CRUSH ) or dmginfo:IsDamageType( DMG_BLAST ) or dmginfo:IsDamageType( DMG_VEHICLE ) or dmginfo:IsDamageType( DMG_BURN ) or self:IsOnFire() then 
		self.HasDeathCorpse = false
		VJ.EmitSound(self, "npc/antlion_grub/explode.wav", 60, 70)
		ParticleEffectAttach("blood_impact_zombie_01",PATTACH_POINT_FOLLOW,self,0)

		local myPos = self:GetPos()
		self:SetLocalPos(myPos + vecZ4) -- Because the entity is too close to the ground
		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos - vezZ100,
			filter = self
		})

		util.Decal(VJ.PICK("YellowBlood"), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathCorpse(dmginfo, hitgroup)
	local vj_npc_corpse_undo = GetConVar("vj_npc_corpse_undo")
	local vj_npc_corpse_fade = GetConVar("vj_npc_corpse_fade")
	local vj_npc_corpse_fadetime = GetConVar("vj_npc_corpse_fadetime")
	local ai_serverragdolls = GetConVar("ai_serverragdolls")
	local math_min = math.min
	local math_max = math.max
	local math_rad = math.rad
	local math_cos = math.cos
	local math_angApproach = math.ApproachAngle
	local colorGrey = Color(255, 255, 255)
		-- NOTE: dmginfo at this point can be incorrect/corrupted, but its better than leaving the self.SavedDmgInfo empty!
	if !self.SavedDmgInfo then
		self.SavedDmgInfo = {
			dmginfo = dmginfo, -- The actual CTakeDamageInfo object | WARNING: Can be corrupted after a tick, recommended not to use this!
			attacker = dmginfo:GetAttacker(),
			inflictor = dmginfo:GetInflictor(),
			amount = dmginfo:GetDamage(),
			pos = dmginfo:GetDamagePosition(),
			type = dmginfo:GetDamageType(),
			force = dmginfo:GetDamageForce(),
			ammoType = dmginfo:GetAmmoType(),
			hitgroup = hitgroup,
		}
	end
	
	if self.HasDeathCorpse && self.HasDeathRagdoll != false then
		local corpseMdl = self:GetModel()
		if corpseMdlCustom then corpseMdl = corpseMdlCustom end
		local corpseClass = "prop_physics"
		if self.DeathCorpseEntityClass then
			corpseClass = self.DeathCorpseEntityClass
		else
			if util.IsValidRagdoll(corpseMdl) then
				corpseClass = "prop_ragdoll"
			elseif !util.IsValidProp(corpseMdl) or !util.IsValidModel(corpseMdl) then
				if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end
				return false
			end
		end
		self.Corpse = ents.Create(corpseClass)
		local corpse = self.Corpse
		corpse:SetModel(corpseMdl)
		corpse:SetPos(self:GetPos())
		corpse:SetAngles(self:GetAngles())
		corpse:Spawn()
		corpse:Activate()
		corpse:SetSkin(self:GetSkin())
		for i = 0, self:GetNumBodyGroups() do
			corpse:SetBodygroup(i, self:GetBodygroup(i))
		end
		corpse:SetColor(self:GetColor())
		corpse:SetMaterial(self:GetMaterial())
		if !corpseMdlCustom && self.DeathCorpseSubMaterials then -- Take care of sub materials
			for _, x in ipairs(self.DeathCorpseSubMaterials) do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end
			 -- This causes lag, not a very good way to do it.
			/*for x = 0, #self:GetMaterials() do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end*/
		end
		//corpse:SetName("corpse" .. self:EntIndex())
		//corpse:SetModelScale(self:GetModelScale())
		corpse.FadeCorpseType = (corpse:GetClass() == "prop_ragdoll" and "FadeAndRemove") or "kill"
		corpse.IsVJBaseCorpse = true
		corpse.DamageInfo = dmginfo
		corpse.ChildEnts = self.DeathCorpse_ChildEnts or {}
		corpse.BloodData = {Color = self.BloodColor, Particle = self.BloodParticle, Decal = self.BloodDecal}

		if self.Bleeds && self.HasBloodPool && vj_npc_blood_pool:GetInt() == 1 then
			self:SpawnBloodPool(dmginfo, hitgroup, corpse)
		end
		
		-- Collision
		corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if ai_serverragdolls:GetInt() == 1 then
			undo.ReplaceEntity(self, corpse)
		else -- Keep corpses is not enabled...
			VJ.Corpse_Add(corpse)
			if vj_npc_corpse_undo:GetInt() == 1 then undo.ReplaceEntity(self, corpse) end -- Undoable
		end
		cleanup.ReplaceEntity(self, corpse) -- Delete on cleanup
		
		-- On fire
		if self:IsOnFire() then
			if !self.Immune_Fire then -- Don't darken the corpse if we are immune to fire!
				corpse:SetColor(colorGrey)
				//corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
			end
		end
		
		-- Dissolve
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			corpse:Dissolve(0, 1)
		end
		
		-- Bone and Angle
		-- If it's a bullet, it will use localized velocity on each bone depending on how far away the bone is from the dmg position
		local useLocalVel = (bit.band(self.SavedDmgInfo.type, DMG_BULLET) != 0 and self.SavedDmgInfo.pos != defPos) or false
		local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if self.DeathAnimationCodeRan then
			useLocalVel = false
			dmgForce = self:GetGroundSpeedVelocity()
		end
		local totalSurface = 0
		local physCount = corpse:GetPhysicsObjectCount()
		for childNum = 0, physCount - 1 do -- 128 = Bone Limit
			local childPhysObj = corpse:GetPhysicsObjectNum(childNum)
			if IsValid(childPhysObj) then
				totalSurface = totalSurface + childPhysObj:GetSurfaceArea()
				local childPhysObj_BonePos, childPhysObj_BoneAng = self:GetBonePosition(corpse:TranslatePhysBoneToBone(childNum))
				if childPhysObj_BonePos then
					if self.DeathCorpseSetBoneAngles then childPhysObj:SetAngles(childPhysObj_BoneAng) end
					childPhysObj:SetPos(childPhysObj_BonePos)
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and childPhysObj_BonePos:Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				-- If it's 1, then it's likely a regular physics model with no bones
				elseif physCount == 1 then
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and corpse:GetPos():Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				end
			end
		end

		timer.Simple(240, function() if corpse:IsValid() then corpse:Remove() end end)
		
		-- Health & stink system
		if corpse:Health() <= 0 then
			local hpCalc = totalSurface / 60
			corpse:SetMaxHealth(hpCalc)
			corpse:SetHealth(hpCalc)
		end
		VJ.Corpse_AddStinky(corpse, true)
		
		if IsValid(self.WeaponEntity) then corpse.ChildEnts[#corpse.ChildEnts + 1] = self.WeaponEntity end
		if self.DeathCorpseFade then corpse:Fire(corpse.FadeCorpseType, nil, self.DeathCorpseFade) end
		if vj_npc_corpse_fade:GetInt() == 1 then corpse:Fire(corpse.FadeCorpseType, nil, vj_npc_corpse_fadetime:GetInt()) end
		self:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
		if corpse:IsFlagSet(FL_DISSOLVING) then
			if IsValid(self.WeaponEntity) then
				self.WeaponEntity:Dissolve(0, 1)
			end
			if corpse.ChildEnts then
				for _, child in ipairs(corpse.ChildEnts) do
					child:Dissolve(0, 1)
				end
			end
		end
		corpse:CallOnRemove("vj_" .. corpse:EntIndex(), function(ent, childPieces)
			for _, child in ipairs(childPieces) do
				if IsValid(child) then
					if child:GetClass() == "prop_ragdoll" then -- Make ragdolls fade
						child:Fire("FadeAndRemove")
					else
						child:Fire("kill")
					end
				end
			end
		end, corpse.ChildEnts)
		hook.Call("CreateEntityRagdoll", nil, self, corpse)
		return corpse
	else
		if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end -- Remove dropped weapon
		-- Remove child entities | No fade effects as it will look weird, remove it instantly!
		if self.DeathCorpse_ChildEnts then
			for _, child in ipairs(self.DeathCorpse_ChildEnts) do
				child:Remove()
			end
		end
	end
end