AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/assassin.mdl"}
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.StartHealth = GetConVar("sk_assassin_synth_health"):GetInt()
ENT.TurningSpeed = 12
ENT.CanChatMessage = false
ENT.DeathCorpseSkin = 1
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(8, 0, 0), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18
ENT.BackAwayFromEnemyDist = 500

ENT.MeleeAttackDamage = 40
ENT.AnimTbl_MeleeAttack = {"stab"} -- Melee Attack Animations
ENT.SoundTbl_MeleeAttack = {"NPC_FastZombie.AttackHit"}
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 150 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 175 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyTime = 0.33 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 15 -- How many repetitions?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {"stab"}
ENT.RangeAttackEntityToSpawn = "obj_vj_knife" -- The entity that is spawned when range attacking

ENT.RangeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the range attack animation?
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 75 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.5 -- How much time until the projectile code is ran?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.NextRangeAttackTime = 0.4 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 3 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 600 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 300 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead

ENT.FootStepTimeRun = 0.2
ENT.FootStepTimeWalk = 0.5

ENT.FootStepSoundLevel = 80
ENT.PainSoundLevel = 75
ENT.DeathSoundLevel = 75

ENT.MainSoundPitch = VJ.SET(110, 130)

ENT.SoundTbl_FootStep = {
	"npc/fast_zombie/foot1.wav",
	"npc/fast_zombie/foot2.wav",
	"npc/fast_zombie/foot3.wav",
	"npc/fast_zombie/foot4.wav",
}

ENT.SoundTbl_Death = {
	"npc/vortsynth/die01.wav",
	"npc/vortsynth/die02.wav",
}

ENT.SoundTbl_Pain = {
	"npc/vortsynth/pain01.wav",
	"npc/vortsynth/pain02.wav",
	"npc/vortsynth/pain03.wav",
	"npc/vortsynth/pain04.wav",
	"npc/vortsynth/pain05.wav",
}

ENT.KnifeSpeed = 3000
ENT.InvisVal = 255
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self:SetCollisionBounds(Vector(-16,-16,0), Vector(16,16,90))
	self.CurrentCloak = "uncloaked"

	self.Eye1 = ents.Create( "env_sprite" )
	self.Eye2 = ents.Create( "env_sprite" )
	local eyes = {
	{
		ent = self.Eye1,
		attachment = 2,
	},
	{
		ent = self.Eye2,
		attachment = 3,
		},
	}

	for _,eye_data in pairs(eyes) do
	local eye = eye_data.ent
		eye:SetKeyValue( "model","sprites/blueflare1.spr" )
		eye:SetKeyValue( "rendercolor","35 155 35" )
		eye:SetPos( self:GetAttachment(eye_data.attachment).Pos )
		eye:SetParent( self, eye_data.attachment )
		eye:SetKeyValue( "scale","0.12" )
		eye:SetKeyValue( "rendermode","7" )
		eye:Spawn()
		self.eye_trail = util.SpriteTrail(eye, 0, Color(35,255,0,64), true, 2, 0, 0.35, 0.008, "sprites/baku_burntcer_smoke")
		self:DeleteOnRemove(eye)
	end

	self.BlackAmount = 0
	self.ColValue = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("SPACE (jump key): Toggle Invisibility (you cannot attack while you're invisible)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:IsOnFire() then
		self.Bleeds = false
		//self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.3, 1)
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
		timer.Simple(12, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end

	self.ColValue = math.Round(Lerp(self.BlackAmount, 255, 90))
	//self:SetColor(Color(self.ColValue, self.ColValue, self.ColValue, self.InvisVal))

	local enemy = self:GetEnemy()

	if self.Behavior == VJ_BEHAVIOR_AGRESSIVE && IsValid(enemy) && !self.VJ_IsBeingControlled then
		local enemydist = self:GetPos():Distance(enemy:GetPos())
		if self:Visible(enemy) && !self:IsBusy() && enemydist < self.BackAwayFromEnemyDist && enemydist > self.NoChaseAfterCertainRange_CloseDistance then
			local tr = util.TraceLine({
				start = self:GetPos()+self:OBBCenter(),
				endpos = self:GetPos()+self:OBBCenter() + (self:GetPos() - enemy:GetPos()):GetNormalized()*self.BackAwayFromEnemyDist,
			})

			self:SetLastPosition( tr.HitPos )
			self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
        	end
	end

	if self.VJ_IsBeingControlled then
		if self.CurrentCloak != "fullcloaked" then
			self:ChangeCloak("halfcloaked")
		end

		if self.VJ_TheController:KeyDown(IN_JUMP) then
			if self.CurrentCloak != "fullcloaked" then
				self:ChangeCloak("fullcloaked")
			else
				self:ChangeCloak("halfcloaked")
			end
		end
	else
		if IsValid(enemy) then
			if self.ShouldFullCloak then
				self:ChangeCloak("fullcloaked")
			else
				self:ChangeCloak("halfcloaked")
			end
		else
			self:ChangeCloak("uncloaked")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChangeCloak(cloak_mode,doAnim)
	if cloak_mode == self.CurrentCloak or self.ChangingCloak then return end
		self.ChangingCloak = true
	if doAnim == nil then doAnim = true end

	local time_until_cloak = 0.5
	local last_cloak_mode = self.CurrentCloak

	timer.Simple(time_until_cloak, function() if IsValid(self) then
			if cloak_mode == "uncloaked" then
				self.InvisVal = 255
				self:SetColor(Color(self.ColValue, self.ColValue, self.ColValue, self.InvisVal))
        		elseif cloak_mode == "halfcloaked" then
				self.InvisVal = 64
				self:SetColor(Color(self.ColValue, self.ColValue, self.ColValue, self.InvisVal))
			elseif cloak_mode == "fullcloaked" then
				self.InvisVal = 0
				self:SetColor(Color(self.ColValue, self.ColValue, self.ColValue, self.InvisVal))
			end

			if cloak_mode == "halfcloaked" or cloak_mode == "uncloaked" then
				self.Eye1:SetKeyValue( "rendercolor","35 155 35" )
				self.Eye2:SetKeyValue( "rendercolor","35 155 35" )
				self.Eye1_Trail = util.SpriteTrail(self.Eye1, 0, Color(35,255,0,64), true, 2, 0, 0.35, 0.008, "sprites/baku_burntcer_smoke")
				self.Eye2_Trail = util.SpriteTrail(self.Eye2, 0, Color(35,255,0,64), true, 2, 0, 0.35, 0.008, "sprites/baku_burntcer_smoke")
			elseif cloak_mode == "uncloaked" then
				self.Eye1:SetKeyValue( "rendercolor","0 0 0" )
				self.Eye2:SetKeyValue( "rendercolor","0 0 0" )
				self.Eye1_Trail:Remove()
				self.Eye2_Trail:Remove()
			end

			if cloak_mode == "fullcloaked" then
				VJ.EmitSound(self, "npc/misc/laugh_special.wav", 80)
				self.Behavior = VJ_BEHAVIOR_PASSIVE
				self:AddFlags(FL_NOTARGET)
			elseif last_cloak_mode == "fullcloaked" then
				self.Behavior = VJ_BEHAVIOR_AGRESSIVE
				self:RemoveFlags(FL_NOTARGET)
			end

			if last_cloak_mode == "fullcloaked" or cloak_mode == "fullcloaked" then
				local effectdata = EffectData()
				effectdata:SetStart(self:GetPos()+self:OBBCenter())
				util.Effect("assassin_cloak_z",effectdata)
			end

			self.ChangingCloak = false

			end 
		end)

	self.CurrentCloak = cloak_mode

	if doAnim then
		self:VJ_ACT_PLAYACTIVITY("smoke", true, time_until_cloak, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	if math.random(1, 2) == 1 then
		local mypos = self:GetPos()+self:OBBCenter()
		local tr = util.TraceEntity( { start = mypos, endpos = mypos+Vector(0,0,100), mask = MASK_NPCWORLDSTATIC }, self )
	if !tr.HitWorld then
		self.AnimTbl_RangeAttack = {"jumpbackt"}
		end
	else
		self.AnimTbl_RangeAttack = {"stab"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local source = self:GetAttachment(1).Pos
	local shootdir = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter() - (source + VectorRand(-20,20))

	local knife = ents.Create("obj_vj_knife")
		knife:SetOwner(self)
		knife:SetPos(source)
		knife:SetAngles(shootdir:Angle())
		knife:Spawn()
		knife:GetPhysicsObject():SetVelocity(shootdir:GetNormalized() * self.KnifeSpeed)
		knife.Target = self:GetEnemy()
		knife.VJ_NPC_Class = self.VJ_NPC_Class

	if math.random(1, 3) == 1 then
		self.ShouldFullCloak = true
		timer.Create("AssassinStopCloakTimer_Z_" .. self:EntIndex(), math.Rand(2,4), 1,  function() if IsValid(self) then self.ShouldFullCloak = false end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		self.CurrentCloak = "uncloaked"
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