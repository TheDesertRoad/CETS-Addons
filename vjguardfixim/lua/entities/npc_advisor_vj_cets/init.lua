AddCSLuaFile("shared.lua")
include("shared.lua")
AddCSLuaFile("cl_init.lua")
util.AddNetworkString("AdvisorBlindOverlay")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_advisor.mdl"
ENT.StartHealth = 600
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.CanChatMessage = false
ENT.TurningSpeed = 16
ENT.EntitiesToNoCollide = {"obj_vj_gib"}
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.ConstantlyFaceEnemy = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Aerial_FlyingSpeed_Calm = 100
ENT.Aerial_FlyingSpeed_Alerted = 400
ENT.Aerial_AnimTbl_Calm = ACT_IDLE
ENT.AA_GroundLimit = 128
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_advisor_puncture"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = "melee"
ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 67
ENT.TimeUntilMeleeAttackDamage = 0.5
ENT.NextAnyAttackTime_Melee = 1.3
ENT.MeleeAttackDamage = 15
 
ENT.HasDeathCorpse = true
ENT.HasExtraMeleeAttackSounds = true
 
ENT.HasRangeAttack = false
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackProjectiles = {"grenade_ar2", "obj_vj_cguard_extractor"}
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 2
ENT.RangeAttackMaxDistance = 2500
ENT.RangeAttackMinDistance = 1
 
ENT.CanFlinch = true
ENT.FlinchChance = 3
ENT.FlinchCooldown = 2
ENT.AnimTbl_Flinch = {"Mortar_Flinch_Front"}
 
ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"
 
ENT.HasItemDropsOnDeath = false
ENT.BreathSoundLevel = 75
ENT.AlertSoundLevel = 90
 
ENT.SoundTbl_Idle = {
	"npc/advisor/advisor_speak_idle.wav",
}
 
ENT.SoundTbl_CombatIdle = {
	"npc/advisor/advisor_speak1.wav",
	"npc/advisor/advisor_speak2.wav",
	"npc/advisor/advisor_speak3.wav",
	"npc/advisor/advisor_speak4.wav",
	"npc/advisor/advisor_speak5.wav",
	"npc/advisor/advisor_speak6.wav",
	"npc/advisor/advisor_speak7.wav",
}
 
ENT.SoundTbl_Alert = ENT.SoundTbl_CombatIdle
 
ENT.SoundTbl_Pain = ENT.SoundTbl_CombatIdle
 
ENT.SoundTbl_Death = {
	"npc/advisor/advisor_death1.wav",
	"npc/advisor/advisor_death2.wav",
	"npc/advisor/advisor_death3.wav",
}

ENT.HasBlackHoleAttack = true
ENT.BlackHoleParticle = "Advisor_Psychic_Shield_Idle" 

ENT.HasBlackHoleShield = false	
ENT.ShieldEnrageHealth = 400
ENT.ShieldMaxHealth = 250		
ENT.ShieldDamageReduction = 1		   
ENT.ShieldBrokenDuration = 3		  
ENT.ShieldImpactParticle = "Advisor_Psychic_Shield_Impact"
ENT.ShieldIdleParticle = "Advisor_Psychic_Shield_Idle"
ENT.ShieldImpactEffectCooldown = 0.15   
ENT.ShieldActivateSensitivity = 175
ENT.ShieldHealPerSecond = 24
ENT.ShieldDamageScale = 0 

ENT.HasHealAllies = true
ENT.HealAlliesRadius = 900			  
ENT.HealAlliesAmount = 10			  
ENT.HealAlliesInterval = 1
		
ENT.HasBlindAttack = true
ENT.BlindAttackRadius = 2048			
ENT.BlindAttackRequireLOS = true		
ENT.BlindAttackCooldownMin = 16
ENT.BlindAttackCooldownMax = 65
ENT.BlindDuration = 4				  
ENT.SlowDuration = 8					
ENT.SlowAmount = 0.5	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(33, 33, 26), Vector(-33, -33, -30))
 
	self.BlackHoleActive = false
	self.BlackHoleEndTime = 0
	self.NextBlackHoleAttack = CurTime() + math.Rand(4, 6)
 
	self.NextHealAlliesTick = 0
	self.NextBlindAttack = CurTime() + math.Rand(4, 12)

	self.NextDestroyCombineBallTime = 0
 
	self.ShieldHealth = self.ShieldMaxHealth
	self.ShieldActive = false

	self.CurrentDamageReceivedAmount = 0
	self.NextDamageReceivedUpdate = CurTime()

	self.NextShieldHeal = CurTime()
	self.NextShieldImpactEffect = 0
 
	self.GravityAffectedPlayers = {}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TryActivateShield()
	if self.ShieldActive then return end
	if self.ShieldHealth < self.ShieldMaxHealth then return end
	if !self.HasBlackHoleShield then return end

	self.ShieldActive = true
	self:AddEFlags(EFL_NO_DISSOLVE)
	self.CanBleed = false

	ParticleEffectAttach(self.ShieldIdleParticle, PATTACH_ABSORIGIN_FOLLOW, self, 0)

	self:EmitSound("npc/advisor/advisor_blast6.wav", 90, math.random(90,110))
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeactivateShield()
	if not self.ShieldActive then return end

	self.ShieldActive = false
	self:RemoveEFlags(EFL_NO_DISSOLVE)
	self.CanBleed = true
	self:StopParticles()
	self:SetRenderMode(RENDERMODE_NORMAL)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DestroyVisibleCombineBalls()
	for _,comball in pairs(ents.FindInSphere(self:GetPos(), 265)) do
		if comball:GetClass() == "prop_combine_ball" or comball:GetClass() == "obj_vj_cets_combineball" or comball:GetClass() == "obj_vj_xrang_extractor" or comball:GetClass() == "obj_vj_xrang_extractor_a" && !comball.WillBeAdvisorThrown && IsValid(comball:GetOwner()) && self:HasEnemyMemory(comball:GetOwner()) then
			
			self:ClearGoal() -- Stop moving and start destroying combineball.

			comball:GetPhysicsObject():SetVelocity(Vector(0,0,0))
			comball.WillBeAdvisorThrown = true
			self.IsDestroyingCombineBall = true

			util.ParticleTracerEx( "vortigaunt_beam_advisor_pushback", self:GetPos(), comball:GetPos(), false, self:EntIndex(),0 )
			comball:EmitSound("npc/advisor/advisor_blast6.wav", 100, math.random(90, 110))

			timer.Simple(1, function() 
				if IsValid(self) then
					self.IsDestroyingCombineBall = nil
					if IsValid(comball) then
						local phys = comball:GetPhysicsObject()
						if IsValid(phys) then
							comball:EmitSound("npc/advisor/advisor_blast1.wav", 100, math.random(90, 110))
							local vel = (comball:GetOwner():WorldSpaceCenter() - self:WorldSpaceCenter()):GetNormalized()*1900
							comball:SetOwner(self)
							phys:SetVelocity( vel )
						end
					end
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
	end
 
	if self.HasBlackHoleAttack then
		self:BlackHole_Think()
	end
 
	if self.HasHealAllies then
		self:HealAllies_Think()
	end
 
	if self.HasBlindAttack then
		self:BlindAttack_Think()
	end
 
	if not self.HasBlackHoleShield and self:Health() <= self.ShieldEnrageHealth then
		self.HasBlackHoleShield = true
	end

	if self.NextDestroyCombineBallTime < CurTime() then
		self:DestroyVisibleCombineBalls()
		self.NextDestroyCombineBallTime = CurTime() + 0.2
	end

	local enemy = self:GetEnemy()

	if self.HasBlackHoleShield && not self.ShieldActive && self:Health() <= (self:GetMaxHealth() * 0.5) && IsValid(enemy) then
		self:TryActivateShield()
	end

	if self.NextDamageReceivedUpdate < CurTime() then
		self.CurrentDamageReceivedAmount = 0
		self.NextDamageReceivedUpdate = CurTime() + 2
	end

	if !self.ShieldActive && self.NextShieldHeal < CurTime() && self.ShieldHealth < self.ShieldMaxHealth then
		self.ShieldHealth = math.min(self.ShieldHealth + self.ShieldHealPerSecond, self.ShieldMaxHealth)
		self.NextShieldHeal = CurTime() + 1
	end

	if self.ShieldActive && !IsValid(enemy) then
		self:DeactivateShield()
	end

	local randRange = math.random(1, 100)

	if randRange == 1 && self:Health() <= 120 then 
		ParticleEffectAttach("blood_advisor_shrapnel_impact", PATTACH_POINT_FOLLOW, self, 10)
		VJ_EmitSound(self,"ambient/water/water_spray" .. math.random(1, 3) .. ".wav",100, 40)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackHole_Think()
	local enemy = self:GetEnemy()

	if self.BlackHoleActive then
		self:BlackHole_Pull()
 
		if CurTime() >= self.BlackHoleEndTime then
			self:BlackHole_Release()
		end
 
		return
	end
 
	if IsValid(enemy) and self:GetNPCState() == NPC_STATE_COMBAT and CurTime() >= self.NextBlackHoleAttack then
		if self:GetPos():Distance(enemy:GetPos()) > 512 then
			self:BlackHole_Start()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackHole_Start()
	self.BlackHoleActive = true
	self.BlackHoleEndTime = CurTime() + 5

	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0, 0, 2048),
		filter = self
	})

	self.BlackHoleEffectPos = tr.HitPos + Vector(0, 0, 2) -- adjust this if needed

	ParticleEffect("derbis_particle_c1", self.BlackHoleEffectPos, angle_zero)

	self:EmitSound("npc/advisor/advisorheadvx0" .. math.random(1, 6) .. ".wav", 90, 100)

	self.BlackHoleAnchor = ents.Create("info_target")

	if IsValid(self.BlackHoleAnchor) then
		self.BlackHoleAnchor:SetPos(self.BlackHoleEffectPos)
		self.BlackHoleAnchor:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackHole_CanSee(ent)
	local points = {
		ent:GetPos(),
		ent:WorldSpaceCenter(),
		ent:GetPos() + Vector(0,0,ent:OBBMaxs().z)
	}

	local start = self:WorldSpaceCenter()

	for _, pos in ipairs(points) do
		local tr = util.TraceLine({
			start = start,
			endpos = pos,
			filter = {self, ent},
			mask = MASK_SOLID
		})

		if not tr.Hit then
			return true
		end
	end

	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackHole_Pull()
	local center = self:GetPos()

	for _, ent in ipairs(ents.FindInSphere(center, 2048)) do
		if ent == self then continue end
		if ent:IsWorld() then continue end
		if IsValid(ent:GetParent()) then continue end
		if not self:BlackHole_CanSee(ent) then continue end
		if ent:IsNPC() and self:Disposition(ent) == D_LI then continue end

		if ent:IsPlayer() or ent:IsNPC() && math.random(1, 4) == 1 then
			local targetPos = self:GetPos() + self:GetForward() * (self.MeleeAttackDistance - 10) + self:GetUp() * 16
			local dir = targetPos - ent:GetPos()
			local dist = dir:Length()

			if dist > 5 then
				dir:Normalize()

				if ent:IsPlayer() then
					if not self.GravityAffectedPlayers[ent] then
						ent:SetGravity(0)
						self.GravityAffectedPlayers[ent] = true
					end
				end

				ent:SetGroundEntity(NULL)
				local speed = math.Clamp(dist * 1, 60, 90)
				ent:SetVelocity(dir * speed - ent:GetVelocity() * 0.2)
			end
		else
			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				local diff = center - ent:GetPos()
				local dist = diff:Length()

				if dist > 1 then
					local dir = diff / dist
					local force = 256

					if dist <= 256 then
						dir = -dir
						force = 128
					end

					phys:Wake()
					phys:ApplyForceCenter(dir * force * phys:GetMass())
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackHole_RestoreGravity()
	for ply in pairs(self.GravityAffectedPlayers) do
		if IsValid(ply) then
			ply:SetGravity(1)
		end
	end
 
	self.GravityAffectedPlayers = {}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackHole_Release()
	local center = self:GetPos()
	if IsValid(self.BlackHoleAnchor) then
		self.BlackHoleAnchor:StopParticles()
		self.BlackHoleAnchor:Remove()
		self.BlackHoleAnchor = nil
	end

	if IsValid(self.BlackHoleAnchor1) then
		self.BlackHoleAnchor1:StopParticles()
		self.BlackHoleAnchor1:Remove()
		self.BlackHoleAnchor1 = nil
	end

	self.BlackHoleEffectPos = nil
 
	for _, ent in ipairs(ents.FindInSphere(center, 2048)) do
		if ent == self then continue end
		if ent:IsWorld() then continue end
		if ent:IsNPC() and self:Disposition(ent) == D_LI then continue end
 
		local diff = ent:GetPos() - center
		local dist = diff:Length()
		local dir = dist > 1 and (diff / dist) or VectorRand()
 
		if ent:IsPlayer() or ent:IsNPC() then
			ent:SetVelocity(dir * 256)
		else
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:ApplyForceCenter(dir * 4096 * phys:GetMass())
			end
		end

		local dmg = DamageInfo()
		if ent:IsPlayer() then
			dmg:SetDamage(12)
		else
			dmg:SetDamage(64)
		end
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		dmg:SetDamageType(DMG_BLAST)
		ent:TakeDamageInfo(dmg)
	end
 
	self:EmitSound("npc/advisor/advisor_pushback.wav", 90, 100)
 
	self:BlackHole_RestoreGravity()
 
	self.BlackHoleActive = false
	self.NextBlackHoleAttack = CurTime() + math.Rand(4, 6)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HealAllies_Think()
	if CurTime() < self.NextHealAlliesTick then return end
	self.NextHealAlliesTick = CurTime() + self.HealAlliesInterval
 
	local center = self:GetPos()
 
	for _, ent in ipairs(ents.FindInSphere(center, self.HealAlliesRadius)) do
		if ent == self then continue end
		if not ent:IsNPC() then continue end
		if self:Disposition(ent) ~= D_LI then continue end -- only heal allies
		if not ent:Health() or ent:Health() >= ent:GetMaxHealth() then continue end
 
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + self.HealAlliesAmount))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlindAttack_Think()
	if self.BlackHoleActive then return end -- don't overlap with the black hole attack
	if CurTime() < self.NextBlindAttack then return end
 
	local enemy = self:GetEnemy()
	if not (IsValid(enemy) and self:GetNPCState() == NPC_STATE_COMBAT) then return end
 
	self:BlindAttack_Start()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlindAttack_Start()
	self.NextBlindAttack = CurTime() + math.Rand(self.BlindAttackCooldownMin, self.BlindAttackCooldownMax)
 
	self:EmitSound("npc/advisor/advisorheadvx0" .. math.random(1, 6) .. ".wav", 90, 100)
 
	for _, ply in ipairs(player.GetAll()) do
		if not IsValid(ply) or not ply:Alive() then continue end
		if ply:GetPos():Distance(self:GetPos()) > self.BlindAttackRadius then continue end
 
		if self.BlindAttackRequireLOS then
			local tr = util.TraceLine({
				start = self:EyePos(),
				endpos = ply:EyePos(),
				filter = {self, ply},
				mask = MASK_OPAQUE,
			})
			if tr.Hit then continue end
		end
 
		ply:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), self.BlindDuration, 0)

		net.Start("AdvisorBlindOverlay")
		net.WriteFloat(self.BlindDuration)
		net.Send(ply)
 
		ply:SetLaggedMovementValue(self.SlowAmount)
 
		local timerName = "AdvisorNPC_UnSlow_" .. self:EntIndex() .. "_" .. ply:EntIndex()
		timer.Create(timerName, self.SlowDuration, 1, function()
			if IsValid(ply) then
				ply:SetLaggedMovementValue(1)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------.
function ENT:BlackHole_RestoreGravity()
	for ply in pairs(self.GravityAffectedPlayers) do
		if IsValid(ply) then
			ply:SetGravity(1)
		end
	end
 
	self.GravityAffectedPlayers = {}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HealAllies_Think()
	if CurTime() < self.NextHealAlliesTick then return end
	self.NextHealAlliesTick = CurTime() + self.HealAlliesInterval
 
	local center = self:GetPos()
 
	for _, ent in ipairs(ents.FindInSphere(center, self.HealAlliesRadius)) do
		if ent == self then continue end
		if not ent:IsNPC() then continue end
		if self:Disposition(ent) ~= D_LI then continue end
		if not ent:Health() or ent:Health() >= ent:GetMaxHealth() then continue end
 
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + self.HealAlliesAmount))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlindAttack_Think()
	if self.BlackHoleActive then return end
	if CurTime() < self.NextBlindAttack then return end
 
	local enemy = self:GetEnemy()
	if not (IsValid(enemy) and self:GetNPCState() == NPC_STATE_COMBAT) then return end
 
	self:BlindAttack_Start()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlindAttack_Start()
	self.NextBlindAttack = CurTime() + math.Rand(self.BlindAttackCooldownMin, self.BlindAttackCooldownMax)
 
	self:EmitSound("npc/advisor/advisorheadvx0" .. math.random(1, 6) .. ".wav", 90, 100)
 
	for _, ply in ipairs(player.GetAll()) do
		if not IsValid(ply) or not ply:Alive() then continue end
		if ply:GetPos():Distance(self:GetPos()) > self.BlindAttackRadius then continue end
 
		if self.BlindAttackRequireLOS then
			local tr = util.TraceLine({
				start = self:EyePos(),
				endpos = ply:EyePos(),
				filter = {self, ply},
				mask = MASK_OPAQUE,
			})
			if tr.Hit then continue end
		end

 		net.Start("AdvisorBlindOverlay")
		net.WriteFloat(8)
		net.Send(ply)

		ply:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), self.BlindDuration, 0)
		ply:SetLaggedMovementValue(self.SlowAmount)
 
		local timerName = "AdvisorNPC_UnSlow_" .. self:EntIndex() .. "_" .. ply:EntIndex()
		timer.Create(timerName, self.SlowDuration, 1, function()
			if IsValid(ply) then
				ply:SetLaggedMovementValue(1)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:IsDamageType(DMG_CRUSH) then
		dmginfo:SetDamage(0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()

	if IsValid(attacker) then
		if attacker:IsPlayer() then
			self.CurrentDamageReceivedAmount =
				self.CurrentDamageReceivedAmount + dmginfo:GetDamage() * 0.5
		else
			self.CurrentDamageReceivedAmount =
				self.CurrentDamageReceivedAmount + dmginfo:GetDamage()
		end
	end

	if self.ShieldActive then
		if CurTime() >= self.NextShieldImpactEffect then
			self.NextShieldImpactEffect = CurTime() + self.ShieldImpactEffectCooldown

			local hitPos = dmginfo:GetDamagePosition()
			if hitPos == vector_origin then
				hitPos = self:GetPos()
			end
		end

		self.ShieldHealth = math.Clamp(self.ShieldHealth - dmginfo:GetDamage(), 0, self.ShieldMaxHealth)

		if self.ShieldHealth <= 0 then
			self:DeactivateShield()
			self:EmitSound("npc/advisor/advisor_blast1.wav", 90, math.random(110,130))
		end

		if self.ShieldActive then
			dmginfo:ScaleDamage(self.ShieldDamageScale)
		end

	end
	self.BaseClass.OnTakeDamage(self, dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:EmitSound( "NPC_Vortigaunt.ZapPowerup", 100, 150, 1, CHAN_AUTO, SND_STOP )
	self:BlackHole_RestoreGravity()
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

		timer.Create("AdvisorCorpseSeizure_" .. corpse:EntIndex(), 0.08, 64, function()
			if !IsValid(corpse) then
				timer.Remove("AdvisorCorpseSeizure_" .. corpse:EntIndex())
				return
			end

			local boneCount = corpse:GetBoneCount()
			if !boneCount or boneCount <= 0 then return end

			for i = 0, corpse:GetPhysicsObjectCount() - 1 do
				local phys = corpse:GetPhysicsObjectNum(i)

				if IsValid(phys) then
					phys:Wake()
					phys:AddVelocity(VectorRand() * math.Rand(10, 40))
					phys:AddAngleVelocity(VectorRand() * math.Rand(300, 600))
				end
			end
		end)

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