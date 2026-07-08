AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vortigaunt_synth/VJ_vortigaunt_synth_Z.mdl"}
ENT.StartHealth = GetConVar("sk_cets_vortsynth_health"):GetInt()
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.MaxJumpLegalDistance = VJ_Set(150, 280) -- The max distance the NPC can jump (Usually from one node to another) | ( UP, DOWN )
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(5, 0, 0), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18

ENT.TimeUntilMeleeAttackDamage = 0.4 -- This counted in seconds | This calculates the time until it hits something
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 150 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackDamage = 20
ENT.AnimTbl_RangeAttack = {"zapattack1"} -- Range Attack Animations
ENT.RangeDistance = 2500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 150 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = 0.85 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 4 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 5 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.MaxDispellDist = 400
ENT.DispellAttackDamage = GetConVar("sk_vortigaunt_zap_range"):GetInt()
ENT.VortDispellCooldown = 5

ENT.HealDistance = 60
ENT.VortHealCooldown = 3

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.FootStepSoundLevel = 80
ENT.IdleSoundLevel = 85
ENT.CombatIdleSoundLevel = 90
ENT.InvestigateSoundLevel = 90
ENT.AlertSoundLevel = 90
ENT.PainSoundLevel = 90
ENT.DeathSoundLevel = 90

ENT.FootStepPitch = VJ_Set(70, 80)

ENT.SoundTbl_FootStep = {
	"npc/stalker/stalker_footstep_left1.wav",
	"npc/stalker/stalker_footstep_left2.wav",
	"npc/stalker/stalker_footstep_right1.wav",
	"npc/stalker/stalker_footstep_right2.wav",
}

ENT.SoundTbl_Idle = {
	"npc/vortsynth/kill01.wav",
	"npc/vortsynth/kill02.wav",
	"npc/vortsynth/kill03.wav",
	"npc/vortsynth/kill04.wav",
	"npc/vortsynth/kill05.wav",
}

ENT.SoundTbl_CombatIdle = ENT.SoundTbl_Idle

ENT.SoundTbl_Alert = {
	"npc/vortsynth/alert01.wav",
	"npc/vortsynth/alert02.wav",
	"npc/vortsynth/alert03.wav",
}

ENT.SoundTbl_Investigate = ENT.SoundTbl_Alert

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

ENT.SoundTbl_MeleeAttack = {"NPC_FastZombie.AttackHit"}

ENT.SoundTbl_MeleeAttackMiss = {"NPC_Vortigaunt.Swing"}

local hurtgests = {
	"flinch_01",
	"flinch_02",
	"flinch_03",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("SPACE (jump key): Dispell")
	ply:ChatPrint("ALT (walk key): Heal Orbs")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self.VortChargeTimerName = "VJ_VortSynth_Z_ChargeTimer" .. self:EntIndex()
	self.VortHealOrbsTimerName = "VJ_VortSynth_Z_HealOrbTimer" .. self:EntIndex()
	self.NextDispell = CurTime()
	self.NextHeal = CurTime()
	self.NextFindHurtAllyT = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:IsOnFire() then
		self.Bleeds = false
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end

	if !self.VJ_IsBeingControlled then
		if !self:Attacking() && self.NextFindHurtAllyT < CurTime() && self.NextHeal < CurTime() then
			local hurt_ally = self:FindHurtAlly()

	if hurt_ally then
			self:VortHeal(false,hurt_ally)
		end
	end

	if self.VortHeal_CurrentAlly && IsValid(self.VortHeal_CurrentAlly) then
			self:SetIdealYawAndUpdate( (self.VortHeal_CurrentAlly:GetPos() - self:GetPos()):Angle().y )
		end
	end

	local enemy = self:GetEnemy()
		if IsValid(enemy) then

		if self:Visible(enemy) then
			self.RangeAttackPos = enemy:GetPos()+enemy:OBBCenter()
	end

	if !self.VJ_IsBeingControlled then
		if self:Visible(enemy) then

		local enemydist = enemy:GetPos():Distance(self:GetPos())

		if !self:Attacking() && self.NextDispell < CurTime() && enemydist < self.MaxDispellDist then
			self:DispellAttack()
		end

		if !self:Attacking() && self.NextHeal < CurTime() && enemydist < self.HealDistance && enemydist > self.RangeToMeleeDistance then
			local tr = util.TraceLine({
				start = self:GetPos()+self:OBBCenter(),
				endpos = enemy:GetPos()+enemy:OBBCenter(),
				mask = MASK_NPCWORLDSTATIC
		})

	if !tr.Hit then
				self:VortHeal(true,enemy) -- HURT enemy, not heal.
			end
		end
	end

	else

	local controller = self.VJ_TheController

	if !self:Attacking() && self.NextDispell < CurTime() && controller:KeyDown(IN_JUMP) then
		self:DispellAttack()
	end

	if !self:Attacking() && self.NextHeal < CurTime() && controller:KeyDown(IN_WALK) then
			self:VortHeal(true,enemy)
		end
	end

	else
		self.RangeAttackPos = nil
	end

	if self.DoingHeal then
		self.HasRangeAttack = false
		self.HasMeleeAttack = false 
	else
		self.HasRangeAttack = true
		self.HasMeleeAttack = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo)
	if math.random(1, 4) == 1 then
		self:AddGesture( self:GetSequenceActivity(self:LookupSequence(table.Random(hurtgests))) )
	end

	if !dmginfo:IsExplosionDamage() then
		dmginfo:ScaleDamage(0.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer(seed)
	self:VortCharge(3)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	self:EmitSound("npc/vortsynth/vort_attack_shoot" .. math.random(3, 4) .. ".wav",100,math.random(90, 110))
	if self.RangeAttackPos then
		for i = 3,4 do
			local source = self:GetAttachment(i).Pos
			local tr = util.TraceLine({
				start = source,
 				endpos = source + (self.RangeAttackPos - (source+VectorRand(-20,20))):GetNormalized()*10000,
				mask = MASK_SHOT,
				filter = self,
		})
		util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Black",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),i)
		util.VJ_SphereDamage(self,self,tr.HitPos,75,self.RangeAttackDamage*0.5,bit.bor(DMG_DISSOLVE,DMG_SHOCK),true,true,false,false)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		local randRange = math.random(1, 3)
		if randRange == 1 then
			self.MeleeAttackDamage = GetConVar("sk_vortigaunt_dmg_claw"):GetInt()
			self.AnimTbl_MeleeAttack = {"meleehigh1", "meleehigh2"}
		elseif randRange == 2 then
			self.MeleeAttackDamage = GetConVar("sk_vortigaunt_dmg_claw"):GetInt()
			self.AnimTbl_MeleeAttack = "meleelow"
		elseif randRange == 3 then
			self.MeleeAttackDamage = GetConVar("sk_vortigaunt_dmg_rake"):GetInt()
			self.AnimTbl_MeleeAttack = "meleehigh3"
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindHurtAlly()
	local hurt_allies = {}

	for _,ent in pairs(ents.FindInSphere(self:GetPos(), self.HealDistance)) do
		if ent:GetClass() != self:GetClass() && ent:IsNPC() && self:Visible(ent) && ent.VJ_NPC_Class then

		local tr = util.TraceLine({
			start = self:GetPos()+self:OBBCenter(),
			endpos = ent:GetPos()+ent:OBBCenter(),
			mask = MASK_NPCWORLDSTATIC
		})

		if tr.Hit then continue end

		local isAlly = false
			for _,npcclass in pairs(ent.VJ_NPC_Class) do
				for _,mynpcclass in pairs(self.VJ_NPC_Class) do
					if npcclass == mynpcclass then
					isAlly = true
					break
			end
		end
	end

	if !isAlly then continue end
		local healthratio = ent:Health()/ent:GetMaxHealth()
		local priority = tostring(1-healthratio)
		if healthratio < 1 && !ent.VJ_IsHugeMonster then hurt_allies[priority] = ent end
		end
	end

	local highestPriority = 0
	local ally_to_heal = nil
	for priority,ally in pairs(hurt_allies) do
		if tonumber(priority) > highestPriority then
			ally_to_heal = ally
			highestPriority = tonumber(priority)
		end
	end

	self.NextFindHurtAllyT = CurTime() + 3
	return ally_to_heal
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VortHeal(agressive,target)
	if self.DoingHeal then return end
	self.DoingHeal = true
	self:VortCharge(GetConVar("sk_vortigaunt_armor_charge"):GetInt())

	if !agressive then
		self.VortHeal_CurrentAlly = target
	end

	local healduration = 2
	self:AddGesture(self:GetSequenceActivity(self:LookupSequence("gest_heal")))
	self:EmitSound("npc/vort/health_charge.wav",90,math.random(140, 150))

	timer.Simple(1.25, function() if IsValid(self) then

	timer.Create(self.VortHealOrbsTimerName, 0.16, 6, function()
		local speed = 650
		local orb = ents.Create("obj_vj_combvort_orb")
			orb:SetPos(self:GetAttachment(4).Pos)
			orb:SetAngles(self:GetForward():Angle())
			orb:SetOwner(self)
			orb.VJ_NPC_Class = self.VJ_NPC_Class
			orb.Target = target
			orb.Speed = speed
		if agressive then
			orb.TrackRatio = 0.19
		else
			orb.TrackRatio = 0.75
		end
			orb:Spawn()
		local dir = self:GetForward()
		if self.RangeAttackPos then
			dir = ( self.RangeAttackPos-self:GetPos() ):GetNormalized()
		end
		orb:GetPhysicsObject():SetVelocity( dir*speed )
		end)
	end end)

	timer.Simple(healduration, function() if IsValid(self) then
		self.VortHeal_CurrentAlly = nil
		self.DoingHeal = false
		self.NextHeal = CurTime()+self.VortHealCooldown
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VortCharge(effectreps)
	if !IsValid(self.ChargeLight1) then
		self.ChargeLight1 = ents.Create("light_dynamic")
		self.ChargeLight1:SetKeyValue("brightness", "2")
		self.ChargeLight1:SetKeyValue("distance", "150")
		self.ChargeLight1:Fire("Color", "0 75 255")
		self.ChargeLight1:SetPos(self:GetAttachment(3).Pos)
		self.ChargeLight1:SetParent(self,3)
		self.ChargeLight1:Spawn()
		self.ChargeLight1:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.ChargeLight1)
	end

	if !IsValid(self.ChargeLight2) then
		self.ChargeLight2 = ents.Create("light_dynamic")
		self.ChargeLight2:SetKeyValue("brightness", "2")
		self.ChargeLight2:SetKeyValue("distance", "150")
		self.ChargeLight2:Fire("Color", "0 75 255")
		self.ChargeLight2:SetPos(self:GetAttachment(4).Pos)
		self.ChargeLight2:SetParent(self,4)
		self.ChargeLight2:Spawn()
		self.ChargeLight2:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.ChargeLight2)
	end

	timer.Create(self.VortChargeTimerName, 0.3, effectreps, function()
		ParticleEffectAttach("st_elmos_fire_cp0", PATTACH_POINT_FOLLOW, self, 4)
		ParticleEffectAttach("st_elmos_fire_cp0", PATTACH_POINT_FOLLOW, self, 3)
	if timer.RepsLeft(self.VortChargeTimerName) == 0 then
			self.ChargeLight1:Remove()
			self.ChargeLight2:Remove()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Attacking()
	if self.RangeAttacking or self.MeleeAttacking or self.DispellAttacking or self.DoingHeal then return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DispellAttack()
	if self.DispellAttacking then return end
	self.DispellAttacking = true
	self:EmitSound("npc/vortsynth/vort_Dispell.wav",100,math.random(90, 110))
	self:VortCharge(4)

	local duration = self:SequenceDuration(self:LookupSequence("Dispel"))
	local impacttime = duration-0.33
	self:VJ_ACT_PLAYACTIVITY("Dispel",true,duration,false)

	timer.Simple(impacttime, function() if IsValid(self) then
		local Dispellpos = self:GetPos()+self:GetUp()*4
			util.VJ_SphereDamage(self,self,Dispellpos,self.MaxDispellDist*1.25,self.DispellAttackDamage,bit.bor(DMG_DISSOLVE,DMG_SHOCK,DMG_BLAST),true,true,false,false)
			util.ScreenShake(Dispellpos, 16, 200, 1, self.MaxDispellDist*4)
			self:EmitSound("weapons/physcannon/energy_sing_explosion2.wav",100,math.random(70, 80))

	local effectdata = EffectData()
		effectdata:SetOrigin(Dispellpos)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetRadius( self.MaxDispellDist*0.25 )
		effectdata:SetScale( 150 )
	util.Effect( "cball_bounce", effectdata )
	util.Effect( "ThumperDust", effectdata )

	local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "4")
		expLight:SetKeyValue("distance", tostring(self.MaxDispellDist*2))
		expLight:Fire("Color", "0 75 255")
		expLight:SetPos(Dispellpos)
		expLight:Spawn()
		expLight:Fire("TurnOn", "", 0)
			timer.Simple(0.1,function() if IsValid(expLight) then expLight:Remove() end end)
			self:DeleteOnRemove(expLight)
		effects.BeamRingPoint( Dispellpos, 0.35, 0, self.MaxDispellDist*2, 50, 5, Color(0,75,255) )
	end end)

	timer.Simple(duration, function() if IsValid(self) then
		self.DispellAttacking = false
		self.NextDispell = CurTime() + self.VortDispellCooldown
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if timer.Exists(self.VortChargeTimerName) then
		timer.Remove(self.VortChargeTimerName)
	end

	if timer.Exists(self.VortHealOrbsTimerName) then
		timer.Remove(self.VortHealOrbsTimerName)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
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
			corpse:Ignite(math.Rand(8, 10), 0)
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