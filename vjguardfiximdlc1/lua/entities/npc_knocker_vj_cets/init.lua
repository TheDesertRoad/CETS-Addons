AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/charger_xen.mdl"}
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.StartHealth = GetConVar("sk_knocker_health"):GetInt()
ENT.TurningSpeed = 12 -- How fast it can turn
ENT.VJ_IsHugeMonster = true
ENT.VJ_ID_Boss = true
ENT.CanChatMessage = false
ENT.RunAwayOnUnknownDamage = false -- Should run away on damage
ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(-50, 0, 50), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "Bip02 Neck", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(25, 0, 25), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true
ENT.PropInteraction = "OnlyPush" -- Controls how it should interact with props
	-- false = Disable both damaging and pushing | true = Damage and push | "OnlyDamage" = Damage but don't push | "OnlyPush" = Push but don't damage
ENT.PropInteraction_MaxScale = 500 -- Max prop size multiplier | x < 1  = Smaller props | x > 1  = Larger props
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_impact_synth_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.InvestigateSoundDistance = 4000
ENT.CallForHelpDistance = 10000 -- -- How far away the SNPC's call for help goes | Counted in World Units

ENT.DisableDefaultMeleeAttackDamageCode = true -- Disables the default melee attack damage code
ENT.MeleeAttackDistance = 120 -- How close does it have to be until it attacks?
ENT.NextMeleeAttackTime = 1.66 -- How much time until it can use a melee attack?
ENT.MeleeDamage = 12

ENT.ChargeDuration = 5
ENT.ChargeCooldown = 3
ENT.ChargeDamage = GetConVar("sk_knocker_charge_dmg"):GetInt()

ENT.FootStepSoundLevel = 80
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events

ENT.AlertSoundLevel = 100
ENT.PainSoundLevel = 80
ENT.DeathSoundLevel = 100
ENT.InvestigateSoundLevel = 80
ENT.CombatIdleSoundLevel = 80

ENT.BeforeMeleeAttackSoundPitch = VJ_Set(85, 115)
ENT.BeforeMeleeAttackSoundLevel = 100

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.DeathCorpseApplyForce = false
ENT.AnimTbl_Death = {
	"death01",
	"death02",
	"death03",
}

ENT.SoundTbl_FootStep = {"NPC_Strider.Footstep"}

ENT.SoundTbl_Idle = {
	"npc/crabsynth/cs_idle01.wav",
	"npc/crabsynth/cs_idle02.wav",
	"npc/crabsynth/cs_idle03.wav",
}

ENT.SoundTbl_CombatIdle = ENT.SoundTbl_Idle

ENT.SoundTbl_Investigate = {
	"npc/crabsynth/cs_distant01.wav",
	"npc/crabsynth/cs_distant02.wav",
}

ENT.SoundTbl_Alert = {
	"npc/crabsynth/cs_alert01.wav",
	"npc/crabsynth/cs_alert02.wav",
	"npc/crabsynth/cs_alert03.wav",
}

ENT.SoundTbl_Pain = {
	"npc/crabsynth/cs_roar01.wav",
	"npc/crabsynth/cs_roar02.wav",
}

ENT.SoundTbl_Death = {"npc/crabsynth/cs_die.wav"}

ENT.SoundTbl_BeforeMeleeAttack = {"npc/crabsynth/cs_pissed01.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(-50,-50,0), Vector(50,50,85))

	self.NextChargeTime = CurTime()

	self.Bullseye = ents.Create("obj_vj_Bullseye")
	self.Bullseye:SetModel("models/hunter/blocks/cube1x1x025.mdl")
	self.Bullseye:SetParent(self)
	self.Bullseye:SetPos(self:GetPos() + self:GetForward()*100 + Vector(0,0,15))
	self.Bullseye:Spawn()
	self.Bullseye:SetNoDraw(true)
	self.Bullseye:DrawShadow(false)
	self.Bullseye:SetSolid(SOLID_NONE)
	self.Bullseye.VJ_NPC_Class = self.VJ_NPC_Class
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("SPACE (jump key): Charge Attack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
	end

	self.Bullseye.VJ_NPC_Class = self.VJ_NPC_Class
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.DeathAnimationCodeRan then return end
	local enemy = self:GetEnemy()

	if IsValid(enemy) then

	if self.VJ_IsBeingControlled then
		local controller = self.VJ_TheController
			if !self:Attacking() then
				if controller:KeyDown(IN_JUMP) && self.NextChargeTime < CurTime() then
					self:ChargeAtEnemy(5)
				end
			end
	else
			if !self:Attacking() && self.NextChargeTime < CurTime() && self:CanChargeEnemy() then
				self:ChargeAtEnemy(self.ChargeDuration)
				end
			end

		end

		if self.Charging then self:ChargeThink() end

		if !IsValid(enemy) then
			if self.Charging then
				self:StopCharging(true,self.ChargeCooldown*0.5)
			end
		self.ShootPos = nil
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	self.HasPainSounds = false
	self.Bleeds = false
	local infl = dmginfo:GetInflictor()
	local comballdamage = false

	if infl && IsValid(infl) then
		if infl:GetClass() == "prop_combine_ball" then
			infl:Fire("Explode")
			comballdamage = true
	end

	if !infl.DamagedVJ_ZHunter && infl:GetClass() == "obj_vj_combineball" then
		infl.DamagedVJ_ZHunter = true
		infl:DeathEffects()
			comballdamage = true
		end
	end

	if !( dmginfo:GetDamagePosition().z < (self:GetPos()+self:OBBCenter()+Vector(0,0,-8)).z && dmginfo:IsExplosionDamage() ) && !comballdamage then

		dmginfo:SetDamage(dmginfo:GetDamage()*0.8)

		if math.random(1, 4) == 1 then
			self.Bleeds = true
			self:EmitSound("physics/metal/metal_barrel_impact_hard" .. math.random(1, 3) .. ".wav", 92, math.random(70, 90))
			self:EmitSound("ambient/energy/zap" .. math.random(1, 9) .. ".wav", 92, math.random(70, 90))
			self.BloodParticle = "blood_spurt_synth_01"
		end

		else
			self.Bleeds = true
			self.HasPainSounds = true
			self.BloodParticle = "blood_impact_synth_01"

	if comballdamage then
			dmginfo:SetDamage(35)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	if ev == 1004 then self:FootStepSoundCode() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer(seed)
	timer.Simple(0.2, function() if IsValid(self) && !self.DeathAnimationCodeRan then self:CustomMeleeDamage(self.MeleeDamage) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomMeleeDamage(damage,damagetype)
	damagetype = damagetype or DMG_SLASH
	local realisticRadius = false
	local damaged_ents = util.VJ_SphereDamage(self, self, self:GetPos() + self:GetForward()*50, 50, damage, damagetype, true, realisticRadius)
	local NPCWasHit = false

	for _,ent in pairs(damaged_ents) do

		local hitpos = ent:GetPos() + ent:OBBCenter()
		local attack_dir = (hitpos - self:GetPos()):GetNormalized()

		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("Shatter")
		end

		if ent:IsNPC() or ent:IsPlayer() then
			if ent:IsPlayer() then
				ent:SetVelocity( Vector( attack_dir.x , attack_dir.y , 0 ) + Vector(0,0,250) )
			elseif !ent.VJ_IsHugeMonster then
				ent:SetVelocity( Vector( attack_dir.x , attack_dir.y , 0 )*1500 + Vector(0,0,250) )
			end
			NPCWasHit = true
		end

		if ent:GetMoveType() == MOVETYPE_VPHYSICS && ent:IsSolid() then
			local physobj = ent:GetPhysicsObject()
				if IsValid(physobj) then
				physobj:SetVelocity(attack_dir * 400)
			end
		end
	end

	if NPCWasHit then
		self:EmitSound("npc/crabsynth/cs_skewer.wav",85,math.random(90, 110))
		self:EmitSound("NPC_Hunter.ChargeHitEnemy")
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Attacking() if self.Charging or self.MeleeAttacking or self.RangeAttacking then return true end end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanChargeEnemy()
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetEnemy():GetPos(),
		mask = MASK_NPCWORLDSTATIC,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs(),
	})

	if self:Visible(self:GetEnemy()) && self:GetEnemy():IsOnGround() && !tr.Hit then
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChargeThink()
	if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) then
		self:SetIdealYawAndUpdate( (self:GetEnemy():GetPos() - self:GetPos() ):Angle().y )
	end

	if !self.Charge_ApplyForceCountdownStarted && self:GetActivity() == "chargerun" then
		self.Charge_ApplyForceCountdownStarted = true
	timer.Simple(0.6, function() if IsValid(self) then
			self.Charge_ShouldApplyForce = true
		end end)
	end

	local speed = 512
	if self.Charge_ShouldApplyForce && self:IsOnGround() then
		self:SetVelocity(self:GetForward()*speed)
	end

	if self:CustomMeleeDamage(self.ChargeDamage, bit.bor(DMG_CLUB,DMG_CRUSH,DMG_SLASH)) == true then -- Player or NPC was hit.
		self:StopCharging(false,self.ChargeCooldown)
		self:VJ_ACT_PLAYACTIVITY("mgrunt_charge_start", true, duration, true)
	end

	local collision_positions = {
		self:GetPos() + self:GetForward()*100,
		self:GetPos() + self:GetForward()*100 + self:GetRight() * 65,
		self:GetPos() + self:GetForward()*100 - self:GetRight() * 65,
	}

	for k,pos in pairs(collision_positions) do
		if bit.band( util.PointContents(pos) , CONTENTS_SOLID ) == CONTENTS_SOLID then
			self:StopCharging(true,self.ChargeCooldown*0.5)
			break
		end
	end

	local trStartPos = self:GetPos()+self:GetForward()*50
	local tr = util.TraceLine({
		start = trStartPos,
		endpos = trStartPos - Vector(0,0,15),
		mask = MASK_NPCWORLDSTATIC,
	})

	if !tr.Hit then
		self:StopCharging(true,self.ChargeCooldown*0.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChargeAtEnemy(duration)
	if self.Charging then return end
	self.Charging = true
	self.Charge_ApplyForceCountdownStarted = false
	self.Charge_ShouldApplyForce = false

	self:VJ_ACT_PLAYACTIVITY("chargerun", true, duration, false)

	timer.Simple(duration, function() if IsValid(self) && self.Charging then
		self:StopCharging(true,self.ChargeCooldown)
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopCharging(UseAnimation,nextcharge)
	if self.DeathAnimationCodeRan then return end

	if UseAnimation then self:VJ_ACT_PLAYACTIVITY("mgrunt_charge_stop", true, duration, true) end

	self.Charging = false
	self.Charge_ShouldApplyForce = false

	self.NextChargeTime = CurTime() + nextcharge
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()

end