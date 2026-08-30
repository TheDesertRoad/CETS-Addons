AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/synth_soldier.mdl"}
ENT.StartHealth = GetConVar("sk_supsynth_health"):GetInt()
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.VJ_ID_Boss = true

ENT.JumpParams = {
	Enabled = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.Immune_Bullet = true
ENT.Immune_Dissolve = true
ENT.Immune_Sonic = true
ENT.Immune_Melee = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Oil"
ENT.BloodParticle = "blood_impact_synth_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanChatMessage = false
ENT.ConstantlyFacingEnemy = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18

ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages

ENT.MeleeAttackDamage = 66
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.TimeUntilMeleeAttackDamage = 0.4
ENT.HasMeleeAttackKnockBack = true
ENT.AnimTbl_MeleeAttack = {"kick", "punch"}
ENT.MeleeAttackKnockBack_Forward1 = 300 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 350 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 120 -- How far it will push you forward | Second in math.random

ENT.BulletSpread = 0.1

ENT.HasRangeAttack = true
ENT.RangeUseAttachmentForPos = true
ENT.NextRangeAttackTime = 5
ENT.TimeUntilRangeAttackProjectileRelease = 0.3
ENT.RangeDistance = 1024
ENT.RangeToMeleeDistance = 500
ENT.RangeUseAttachmentForPosID = "anim_attachment_RH"
ENT.AnimTbl_RangeAttack = "shoot"
ENT.DisableDefaultRangeAttackCode = true

ENT.HasGrenadeAttack = true
ENT.GrenadeAttackDistance = 2048
ENT.GrenadeAttackCooldown = 6
ENT.GrenadeAttackDamage = 100
ENT.GrenadeAttackRadius = 200

ENT.GrenadeEntity = "obj_vj_cguard_extractor" -- Change this to your custom entity class
ENT.GrenadeAttachment = 4
ENT.GrenadeThrowForce = 1500
ENT.GrenadeThrowUp = 256

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.6

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 1
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
	"weapon_frag",
}

ENT.CanBeMedic = false

ENT.MainSoundPitch = VJ.SET(85, 105)
ENT.MeleeAttackMissSoundPitch = 80

ENT.FootStepSoundLevel = 80
ENT.RangeAttackSoundLevel = 100
ENT.IdleSoundLevel = 85
ENT.IdleDialogueSoundLevel = 85
ENT.IdleDialogueAnswerSoundLevel = 85
ENT.CombatIdleSoundLevel = 90
ENT.InvestigateSoundLevel = 90
ENT.LostEnemySoundLevel = 85
ENT.AlertSoundLevel = 90
ENT.MeleeAttackSoundLevel = 90
ENT.GrenadeAttackSoundLevel = 90
ENT.OnGrenadeSightSoundLevel = 90
ENT.OnDangerSightSoundLevel = 90
ENT.OnKilledEnemySoundLevel = 90
ENT.AllyDeathSoundLevel = 90
ENT.PainSoundLevel = 90
ENT.DeathSoundLevel = 90

ENT.SoundTbl_FootStep = {
	"npc/super_synth/ballsack_walk1.wav",
	"npc/super_synth/ballsack_walk2.wav",
	"npc/super_synth/ballsack_walk3.wav",
	"npc/super_synth/ballsack_walk4.wav",
	"npc/super_synth/ballsack_walk5.wav",
}

ENT.SoundTbl_Investigate = "npc/combine_gunship/ping_search.wav"

ENT.SoundTbl_MeleeAttack = "npc/super_synth/shove1.wav"

ENT.SoundTbl_MeleeAttackMiss ={
	"npc/fast_zombie/claw_miss1.wav",
	"npc/fast_zombie/claw_miss2.wav",
}

ENT.SoundTbl_BeforeRangeAttack = "npc/super_synth/ballsack_recharge.wav"

ENT.SoundTbl_RangeAttack = {
	"weapons/hevsg/charged_fire1.wav",
}

ENT.SoundTbl_Idle = {
	"npc/super_synth/creak1.wav",
	"npc/super_synth/creak2.wav",
	"npc/super_synth/creak3.wav",
	"npc/super_synth/creak4.wav",
}

ENT.SoundTbl_IdleDialogue = {
	"npc/super_synth/ballsack_question1.wav",
	"npc/super_synth/ballsack_question2.wav",
	"npc/super_synth/ballsack_question3.wav",
	"npc/super_synth/ballsack_question4.wav",
}

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/super_synth/ballsack_answer1.wav",
	"npc/super_synth/ballsack_answer3.wav",
	"npc/super_synth/ballsack_answer4.wav",
}

ENT.SoundTbl_Alert = {
	"npc/super_synth/ballsack_alert1.wav",
	"npc/super_synth/ballsack_alert2.wav",
	"npc/super_synth/ballsack_alert3.wav",
	"npc/super_synth/ballsack_alert4.wav",
	"npc/super_synth/ballsack_alert5.wav",
}

ENT.SoundTbl_Death = {
	"npc/super_synth/ballsack_death1.wav",
	"npc/super_synth/ballsack_death2.wav",
	"npc/super_synth/ballsack_death3.wav",
}

ENT.SoundTbl_Hurt = {
	"npc/super_synth/ballsack_pain1.wav",
	"npc/super_synth/ballsack_pain2.wav",
	"npc/super_synth/ballsack_pain3.wav",
	"npc/super_synth/ballsack_pain4.wav",
}

ENT.SoundTbl_Pain = {
	"npc/super_synth/ballsack_pain1.wav",
	"npc/super_synth/ballsack_pain2.wav",
	"npc/super_synth/ballsack_pain3.wav",
	"npc/super_synth/ballsack_pain4.wav",
}

local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}

ENT.Metrocop_CanHaveManhack = false

ENT.NextDance = 0

ENT.MaxDispellDist = 420
ENT.DispellAttackDamage = 120
ENT.VortDispellCooldown = 5
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local enemy = self:GetEnemy()

	if not IsValid(enemy) then return end

	local distance = self:GetPos():Distance(enemy:GetPos())

	if distance <= self.MaxDispellDist&&not self.DispellAttacking&&not self.GrenadeAttacking&&not self.RangeAttacking&&not self.MeleeAttacking&&(self.NextDispell or 0) <= CurTime() then
		self:DispellAttack()
		return
	end

	if distance <= self.GrenadeAttackDistance&&not self.GrenadeAttacking&&not self.DispellAttacking&&not self.RangeAttacking&&not self.MeleeAttacking&&(self.NextGrenadeAttack or 0) <= CurTime() then
		self:GrenadeAttack(enemy)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrenadeAttack(target)
	if self.GrenadeAttacking then return end
	if not IsValid(target) then return end

	self.GrenadeAttacking = true

	local anim = "grenthrow"
	local sequence = self:LookupSequence(anim)

	if sequence < 0 then
		self.GrenadeAttacking = false
		return
	end

	local duration = self:SequenceDuration(sequence)

	self:VJ_ACT_PLAYACTIVITY(anim, true, duration, false)
	self:EmitSound("npc/ministrider/ministrider_preflechette.wav", 100, math.random(70, 80))

	local throwTime = 1

	timer.Simple(throwTime, function()
		if not IsValid(self) then return end
		if not IsValid(target) then return end

		local attachment = self:GetAttachment(self.GrenadeAttachment)

		if not attachment then
			self.GrenadeAttacking = false
			return
		end

		local spawnPos = attachment.Pos
		local spawnAng = attachment.Ang

		local grenade = ents.Create(self.GrenadeEntity)

		if not IsValid(grenade) then
			self.GrenadeAttacking = false
			return
		end

		grenade:SetPos(spawnPos)
		grenade:SetAngles(spawnAng)
		grenade:SetOwner(self)
		grenade.Attacker = self
		grenade.Target = target
		grenade.Damage = self.GrenadeAttackDamage
		grenade.DamageRadius = self.GrenadeAttackRadius
		grenade:Spawn()
		grenade:Activate()

		local targetPos = target:GetPos() + target:OBBCenter()
		local direction = (targetPos - spawnPos):GetNormalized()
		local phys = grenade:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(direction * self.GrenadeThrowForce + Vector(0, 0, self.GrenadeThrowUp))
			phys:AddAngleVelocity(VectorRand() * 300)
		end

		self:EmitSound("npc/assault/assault_cannon.wav", 100, math.random(90, 110))

		self:DeleteOnRemove(grenade)
	end)

	timer.Simple(duration, function()
		if not IsValid(self) then return end

		self.GrenadeAttacking = false
		self.NextGrenadeAttack = CurTime() + self.GrenadeAttackCooldown
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local reloadAnim = "reload"
	local reloadSequence = self:LookupSequence(reloadAnim)

	if reloadSequence >= 0 then
		local reloadDuration = self:SequenceDuration(reloadSequence)

		self:VJ_ACT_PLAYACTIVITY(reloadAnim, true, reloadDuration, false)
		self:EmitSound("npc/waste_scanner/security_yes.wav", 100, math.random(90, 110))
	end

	local bullet_source = self:GetAttachment(3).Pos
	local shootpos = bullet_source + self:GetForward() * 10
	local fire_dir = (shootpos - bullet_source):GetNormalized()

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "256")
	expLight:Fire("Color", "0 75 255")
	expLight:SetPos(bullet_source)
	expLight:Spawn()
	expLight:SetParent(self,3)
	expLight:Fire("TurnOn", "", 0)
	timer.Simple(0.1,function() if IsValid(expLight) then expLight:Remove() end end)
	self:DeleteOnRemove(expLight)

	ParticleEffect("ar2_muzzleflash_cets",bullet_source,self:GetAttachment(3).Ang)
	ParticleEffect("assassin_projectile_explosion_2i",bullet_source,self:GetAttachment(3).Ang)
	ParticleEffect("assassin_projectile_explosion_2b",bullet_source,self:GetAttachment(3).Ang)

	self:FireBullets({
		Src = bullet_source,
		Dir = fire_dir,
		Damage = 10,
		Force = 33,
		TracerName = "AirboatGunTracer",
		Tracer = 1,
		Spread = Vector( self.BulletSpread,self.BulletSpread,self.BulletSpread ),
		Num = 32,
		Callback = function(attacker, tracer)
			local effectdata = EffectData()
			effectdata:SetOrigin(tracer.HitPos)
			effectdata:SetNormal(tracer.HitNormal)
			effectdata:SetRadius( 10 )
			util.Effect( "cball_bounce", effectdata )

			effects.BeamRingPoint( tracer.HitPos, 0.3, 0, 70, 12, 6, Color(32,16,255,200) )
			util.VJ_SphereDamage(self,self,tracer.HitPos,26,6,DMG_DISSOLVE,true,false,false,false)
		end,
	})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if math.random(1,4) == 1 then
		VJ_EmitSound(self,"ambient/energy/weld2.wav",100,80)
		VJ_EmitSound(self,"hl1/weapons/hegrenade-1.wav",100,100)
		util.VJ_SphereDamage(self,self,self:GetPos(),100,32,DMG_BLAST,true,true)

		ParticleEffect("explosion_turret_break",self:GetPos() + self:GetUp()* 60,Angle(0,0,0),nil)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DispellAttack()
	if self.DispellAttacking then return end

	self.DispellAttacking = true

	self:EmitSound("hl1/discreturn.wav", 100, math.random(90, 110))

	local anim = "dispell"
	local sequence = self:LookupSequence(anim)

	if sequence < 0 then
		self.DispellAttacking = false
		return
	end

	local duration = self:SequenceDuration(sequence)
	local impacttime = 0.8

	self:VJ_ACT_PLAYACTIVITY(anim, true, duration, false)

	local bullet_source = self:GetAttachment(3).Pos
	local shootpos = bullet_source + self:GetForward() * 10
	local fire_dir = (shootpos - bullet_source):GetNormalized()

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "256")
	expLight:Fire("Color", "0 75 255")
	expLight:SetPos(bullet_source)
	expLight:Spawn()
	expLight:SetParent(self, 3)
	expLight:Fire("TurnOn", "", 0)

	timer.Simple(0.3, function()
		if IsValid(expLight) then
			expLight:Remove()
		end
	end)

	self:DeleteOnRemove(expLight)

	ParticleEffectAttach("electrical_arc_01_system", PATTACH_POINT_FOLLOW, self, 3)

	timer.Simple(impacttime, function()
		if not IsValid(self) then return end

		local Dispellpos = self:GetPos() + self:GetUp() * 4
		local radius = self.MaxDispellDist * 1.25

		util.VJ_SphereDamage(self, self, Dispellpos, radius, self.DispellAttackDamage, bit.bor(DMG_DISSOLVE, DMG_SHOCK, DMG_BLAST), true, true, false, false)

		util.ScreenShake(Dispellpos, 16, 400, 1, self.MaxDispellDist * 4)

		self:EmitSound("hl1/debris/beamstart5.wav", 100, math.random(90, 110))
		self:EmitSound("weapons/mortar/mortar_explode" .. math.random(1, 3) .. ".wav", 100, math.random(90, 110))

		local effectdata = EffectData()
		effectdata:SetOrigin(Dispellpos)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetRadius(self.MaxDispellDist * 0.25)
		effectdata:SetScale(300)

		util.Effect("cball_bounce", effectdata)
		util.Effect("ThumperDust", effectdata)

		local scorchTrace = util.TraceLine({
			start = Dispellpos + Vector(0, 0, 10),
			endpos = Dispellpos - Vector(0, 0, 100),
			filter = self,
			mask = MASK_SOLID
		})

		if scorchTrace.Hit then
			util.Decal("Scorch", scorchTrace.HitPos + scorchTrace.HitNormal, scorchTrace.HitPos - scorchTrace.HitNormal)
		end

		local expLight = ents.Create("light_dynamic")

		if IsValid(expLight) then
			expLight:SetKeyValue("brightness", "4")
			expLight:SetKeyValue("distance", tostring(self.MaxDispellDist * 2))
			expLight:Fire("Color", "0 75 255")
			expLight:SetPos(Dispellpos)
			expLight:Spawn()
			expLight:Fire("TurnOn", "", 0)

			timer.Simple(0.1, function()
				if IsValid(expLight) then
					expLight:Remove()
				end
			end)

			self:DeleteOnRemove(expLight)
		end

		local teslaCount = 128
		local teslaRadius = self.MaxDispellDist

		for i = 1, teslaCount do
			local angle = math.rad((i / teslaCount) * 360)
			local offset = Vector(math.cos(angle) * teslaRadius, math.sin(angle) * teslaRadius, 8)
			local teslaPos = Dispellpos + offset

			local effectdata = EffectData()
			effectdata:SetOrigin(teslaPos)
			effectdata:SetStart(Dispellpos)
			effectdata:SetMagnitude(8)
			effectdata:SetScale(12)
			effectdata:SetRadius(8)

			util.Effect("TeslaHitBoxes", effectdata, true, true)
		end

		local fent = self:GetEnemy()

		for _, fent in ipairs(player.GetAll()) do
			if IsValid(self:GetEnemy()) && fent:IsPlayer() && self:Visible(fent) && self:GetPos():Distance(fent:GetPos()) <= self.MaxDispellDist * 2 then
				fent:ScreenFade(SCREENFADE.IN, Color(138, 196, 245, 128), 1, 1)
			end
		end

		effects.BeamRingPoint(Dispellpos, 0.6, 0, self.MaxDispellDist * 2, 64, 8, Color(0, 75, 255))

		ParticleEffect("aurora_shockwave_bigg", Dispellpos, Angle(0, 0, 0))
		ParticleEffect("cguard_fire", Dispellpos, Angle(0, 0, 0))
		ParticleEffect("assassin_projectile_explosion_2i_bigg", Dispellpos, Angle(0, 0, 0))
		ParticleEffect("assassin_projectile_explosion_2b_bigg", Dispellpos, Angle(0, 0, 0))
	end)

	timer.Simple(duration, function()
		if not IsValid(self) then return end

		self.DispellAttacking = false
		self.NextDispell = CurTime() + self.VortDispellCooldown
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath()
	ParticleEffect("grenade_explosion_01",self:GetPos() + self:GetUp()* 80,Angle(0,0,0),nil)
	util.VJ_SphereDamage(self,self,self:GetPos(),250,64,DMG_BLAST,true,true)

	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 100, 100)
	effects.BeamRingPoint(self:GetPos(), 0.3, 24, 512, 16, 0, Color(255, 255, 240, 8))
end