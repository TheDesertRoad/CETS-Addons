AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/VJ_Combine_guard_Z.mdl"}
ENT.StartHealth = GetConVar("sk_cguard_health"):GetInt()
ENT.TurningSpeed = 15 -- How fast it can turn
ENT.PoseParameterLooking_TurningSpeed = 20 -- How fast does the parameter turn?
ENT.CanChatMessage = false
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.VJ_ID_Boss = true
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.Immune_Bullet = true
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
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 32

ENT.AnimTbl_MeleeAttack = {"punch01","punch02"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = GetConVar("sk_cguard_dmg_shove"):GetInt()
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 200 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 300 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 1
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
	"weapon_frag",
	"item_ammo_ar2_altfire",
}

ENT.FireGunDist = {
	min = ENT.MeleeAttackDamageDistance,
	max = 3000,
}

ENT.GuardAttackDelay = {
	min = 2,
	max = 5,
}
ENT.GrenadeAttackDelay = {
	min = 2,
	max = 5,
}

ENT.FootStepSoundLevel = 80
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.6 -- Next foot step sound when it is walking

ENT.BeforeMeleeAttackSoundPitch = 75

ENT.IdleSoundLevel = 85
ENT.IdleDialogueSoundLevel = 85
ENT.IdleDialogueAnswerSoundLevel = 85
ENT.CombatIdleSoundLevel = 90
ENT.InvestigateSoundLevel = 90
ENT.LostEnemySoundLevel = 85
ENT.AlertSoundLevel = 90
ENT.WeaponReloadSoundLevel = 90
ENT.GrenadeAttackSoundLevel = 90
ENT.OnGrenadeSightSoundLevel = 90
ENT.OnDangerSightSoundLevel = 90
ENT.OnKilledEnemySoundLevel = 90
ENT.AllyDeathSoundLevel = 90
ENT.PainSoundLevel = 90
ENT.DeathSoundLevel = 100
ENT.BeforeMeleeAttackSoundLevel = 75

ENT.SoundTbl_FootStep = {"npc/vj_combine_guard_z/cguard_footstep_walk01.wav", "npc/vj_combine_guard_z/cguard_footstep_walk02.wav", "npc/vj_combine_guard_z/cguard_footstep_walk03.wav", "npc/vj_combine_guard_z/cguard_footstep_walk04.wav", "npc/vj_combine_guard_z/cguard_footstep_walk05.wav", "npc/vj_combine_guard_z/cguard_footstep_walk06.wav", "npc/vj_combine_guard_z/cguard_footstep_walk07.wav", "npc/vj_combine_guard_z/cguard_footstep_walk08.wav", "npc/vj_combine_guard_z/cguard_footstep_walk09.wav"}

ENT.SoundTbl_MeleeAttack = {"npc/vj_combine_guard_z/shove.wav"}

ENT.SoundTbl_BeforeMeleeAttack = {"npc/zombie/claw_miss1.wav", "npc/zombie/claw_miss2.wav"}

ENT.SoundTbl_Idle = {
	"npc/vj_combine_guard_z/cguard_noise1.wav",
	"npc/vj_combine_guard_z/cguard_noise2.wav",
	"npc/vj_combine_guard_z/cguard_noise3.wav",
	"npc/vj_combine_guard_z/cguard_noise4.wav",
	"npc/vj_combine_guard_z/cguard_noise5.wav",
	"npc/vj_combine_guard_z/cguard_noise6.wav",
}

ENT.SoundTbl_IdleDialogue = ENT.SoundTbl_Idle

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/vj_combine_guard_z/cguard_noise1.wav",
	"npc/vj_combine_guard_z/cguard_noise2.wav",
	"npc/vj_combine_guard_z/cguard_noise3.wav",
	"npc/vj_combine_guard_z/cguard_noise4.wav",
	"npc/vj_combine_guard_z/cguard_noise5.wav",
	"npc/vj_combine_guard_z/cguard_noise6.wav",
}

ENT.SoundTbl_Investigate = {"npc/combine_gunship/ping_search.wav"}

ENT.SoundTbl_CombatIdle = {
	"npc/vj_combine_guard_z/cguard_noise1.wav",
	"npc/vj_combine_guard_z/cguard_noise2.wav",
	"npc/vj_combine_guard_z/cguard_noise3.wav",
	"npc/vj_combine_guard_z/cguard_noise4.wav",
	"npc/vj_combine_guard_z/cguard_noise5.wav",
	"npc/vj_combine_guard_z/cguard_noise6.wav",
}

ENT.SoundTbl_Alert = {"npc/vj_combine_guard_z/alert1.wav"}

ENT.SoundTbl_GrenadeAttack = {"ambient/levels/canals/headcrab_canister_ambient3.wav"}

ENT.SoundTbl_OnKilledEnemy = {"ambient/levels/canals/headcrab_canister_ambient2.wav"}

ENT.SoundTbl_AllyDeath = {
	"npc/vj_combine_guard_z/cguard_servo1.wav",
	"npc/vj_combine_guard_z/cguard_servo2.wav",
	"npc/vj_combine_guard_z/cguard_servo3.wav",
}

ENT.SoundTbl_Hurt = {
	"npc/vj_combine_guard_z/cguard_servo1.wav",
	"npc/vj_combine_guard_z/cguard_servo2.wav",
	"npc/vj_combine_guard_z/cguard_servo3.wav",
}

ENT.SoundTbl_Pain = table.Add({"npc/dog/dogphrase11.wav"},ENT.SoundTbl_Hurt)

ENT.SoundTbl_LostEnemy = {
	"npc/vj_combine_guard_z/cguard_servo1.wav",
	"npc/vj_combine_guard_z/cguard_servo2.wav",
	"npc/vj_combine_guard_z/cguard_servo3.wav",
}

ENT.SoundTbl_Death = {"npc/vj_combine_guard_z/death.wav"}

ENT.SoundTbl_RadioOn = {"npc/dog/dogphrase01.wav"}

ENT.SoundTbl_RadioOff = {"npc/dog/dogphrase14.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetBodygroup(1, 1)
	self:SetCollisionBounds(Vector(-22,-22,0), Vector(22,22,80))
	self.NextGuardAttackTime = CurTime()
	self.NextGrenadeAttack = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	if game.GetGlobalState("gordon_precriminal") == 1 then 
		self.Behavior = VJ_BEHAVIOR_NEUTRAL
		self.IsGuard = true
		self.EnemyTouchDetection = true
		self.BecomeEnemyToPlayer = true
		self.AlliedWithPlayerAllies = true
		self.CanReceiveOrders = false
		self.FollowPlayer = false
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("MOUSE2 (secondary attack key): Fire Gun")
	ply:ChatPrint("SPACE (jump key): Fire Grenade")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.GunCharging then
	if self.FirePos then
		sound.EmitHint( SOUND_DANGER, self.FirePos, 300, 0.5, self )
        end

	self:BlackHole(self.FirePos)
		ParticleEffectAttach("hunter_shield_impactglow", PATTACH_POINT_FOLLOW, self, 1)
	else

		if self.BlackHoleLight && IsValid(self.BlackHoleLight) then
			self.BlackHoleLight:Remove()
			self.BlackHoleLight = nil
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local enemy = self:GetEnemy()
	if self.VJ_IsBeingControlled then

		if IsValid(enemy) then self.PotentialGrenadePos = enemy:GetPos() end

		local controller = self.VJ_TheController

		if self.NextGrenadeAttack < CurTime() && controller:KeyDown(IN_JUMP) && !self.GuardGunFiring then
			self:GrenadeAttack()
		end

		if controller:KeyDown(IN_ATTACK2) && !self.GrenadeAttacking then
			self:StartFiringGuardGun()
		end

	elseif IsValid(enemy) then 

		if self.NextGuardAttackTime < CurTime() && self:EnemyIsInFireDist() then

		if self.NextGrenadeAttack < CurTime() && (math.random(1, 3) == 1 or !self:Visible(enemy)) && enemy:IsOnGround() then
			self:GrenadeAttack()
		end

		if self:Visible(enemy) then
			self.PotentialGrenadePos = enemy:GetPos()

		if !self.GrenadeAttacking then
			self:StartFiringGuardGun()
			end
		end
			self.NextGuardAttackTime = CurTime() + math.Rand(self.GuardAttackDelay.min, self.GuardAttackDelay.max)
			end
		end

		if self.FirePos then
			local fireang = (self.FirePos - self:GetPos()):Angle()
				self:SetIdealYawAndUpdate(fireang.y)
				self:SetPoseParameter("aim_pitch",self:WorldToLocalAngles(fireang).x + 15 )
				self:SetPoseParameter("aim_yaw",self:WorldToLocalAngles(fireang).y )
		end

		if self.GrenadeAttacking or self.GuardGunFiring then
			self.HasMeleeAttack = false
		else
			self.HasMeleeAttack = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
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

	if comballdamage then
		dmginfo:SetDamage(150)
	elseif !dmginfo:IsExplosionDamage() then
		dmginfo:ScaleDamage(0.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	if ev == 13 then
		self:ChargeGun()
	elseif ev == 12 then
		self:FireGun()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSpark(pos,intensity)
	intensity = intensity or 1
	local spark = ents.Create("env_spark")
		spark:SetKeyValue("Magnitude",tostring(intensity))
		spark:SetKeyValue("Spark Trail Length",tostring(intensity))
		spark:SetPos(pos)
		spark:Spawn()
		spark:Fire("StartSpark", "", 0)
		timer.Simple(0.1, function() if IsValid(spark) then spark:Remove() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateFirePos()
	local tr_EndPos = self:GetPos() + self:GetForward() * 200
	if IsValid(self:GetEnemy()) then
		tr_EndPos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()
	end

	if self.FirePos then
		tr_EndPos = self.FirePos
	end

	local tr = util.TraceLine({
		start = self:GetAttachment(1).Pos,
		endpos = tr_EndPos,
		mask = MASK_SHOT,
		filter = self,
	})

	self.FirePos = tr.HitPos
	self:SetNWVector("VJCombGuardZFirePos", self.FirePos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EnemyIsInFireDist()
	local enemydist = self:GetPos():Distance(self:GetEnemy():GetPos())
	if enemydist > self.FireGunDist.min && enemydist < self.FireGunDist.max then
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChargeGun()
	self.GunCharging = true
	self:SetNWBool("VJCombGuardZGunCharging", true)
	self.HasPoseParameterLooking = false -- Start using manual poseparameters instead.

	self:UpdateFirePos()
	local assumed_time_until_fire = 0.92
		timer.Simple(assumed_time_until_fire, function() if IsValid(self) then self.GunCharging = false self:SetNWBool("VJCombGuardZGunCharging", false) end end)

	util.ScreenShake(self:GetAttachment(1).Pos, 4, 200, assumed_time_until_fire*3, 2000)

	self:EmitSound("weapons/cguard/charging.wav", 100, math.random(90, 100) , 1)

	local light = ents.Create("light_dynamic")
		light:SetKeyValue("brightness", "3")
		light:SetKeyValue("distance", "250")
		light:Fire("Color", "0 75 255")
		light:SetPos(self:GetAttachment(1).Pos)
		light:Spawn()
		light:SetParent(self,1)
		light:Fire("TurnOn", "", 0)
	timer.Simple(assumed_time_until_fire,function() if IsValid(light) then light:Remove() end end)
	self:DeleteOnRemove(light)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartFiringGuardGun()
	if self.GuardGunFiring then return end
		self.GuardGunFiring = true

	local firetime = 2.5
		self:VJ_ACT_PLAYACTIVITY("fire", true, firetime, false)

	timer.Simple(firetime, function() if IsValid(self) then
		self.GuardGunFiring = false
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FireGun()
	self:EmitSound("npc/vj_combine_guard_z/cguard_fire.wav", 140, math.random(80, 100))

	local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "5")
		expLight:SetKeyValue("distance", "400")
		expLight:Fire("Color", "0 75 255")
		expLight:SetPos(self:GetAttachment(1).Pos)
		expLight:Spawn()
		expLight:SetParent(self,1)
		expLight:Fire("TurnOn", "", 0)
	timer.Simple(0.2,function() if IsValid(expLight) then expLight:Remove() end end)
	self:DeleteOnRemove(expLight)

	ParticleEffect( "wasteland_scanner_beam_wave",self:GetAttachment(1).Pos, self:GetAttachment(1).Ang, self )
	util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",self:GetAttachment(1).Pos,self.FirePos,false,self:EntIndex(),1)
	self:DoGuardExplosion(self.FirePos)

	self.FirePos = nil
	self.HasPoseParameterLooking = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackHole()
	local suckradius = GetConVar("sk_cguard_suck_radius"):GetInt()
	if !self.BlackHoleLight then
		self.BlackHoleLight = ents.Create("light_dynamic")
		self.BlackHoleLight:SetKeyValue("brightness", "3")
		self.BlackHoleLight:SetKeyValue("distance", "250")
		self.BlackHoleLight:Fire("Color", "0 75 255")
		self.BlackHoleLight:SetPos(self.FirePos)
		self.BlackHoleLight:Spawn()
		self.BlackHoleLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.BlackHoleLight)

		local effectdata = EffectData()
			effectdata:SetStart(self.FirePos)
			effectdata:SetMagnitude(1)
			effectdata:SetEntity(self)
			effectdata:SetAttachment(0)
			effectdata:SetScale(1.5)
		util.Effect("cguard_warp", effectdata)
	end

	local effectdata = EffectData()
	effectdata:SetStart(self.FirePos)
	util.Effect("cguard_suck", effectdata)

	for _,ent in pairs(ents.FindInSphere(self.FirePos, suckradius)) do

	if ent != self && ent:IsSolid() then
		local dir = (self.FirePos - ent:GetPos()):GetNormalized()

	if (ent:IsNPC() or ent:IsPlayer()) && !self:IsAlly(ent) && !ent.VJ_IsHugeMonster then
		ent:SetVelocity(Vector(dir.x,dir.y,0) * 138)
	end

		if ent:GetMoveType() == MOVETYPE_VPHYSICS then
			local physobj = ent:GetPhysicsObject()
				if IsValid(physobj) then
					physobj:ApplyForceCenter(dir * 3000)
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoGuardExplosion(pos)
	ParticleEffect("cguard_fire", pos, Angle(0,0,0), nil)
	ParticleEffect("barrel_explosion", pos, Angle(0,0,0), nil)

	sound.Play("hl1/debris/beamstart" .. math.random(4, 6) .. ".wav", pos, 100, math.random(90, 110))
	sound.Play("ambient/energy/newspark0" .. math.random(1, 9) .. ".wav", pos, 110, math.random(80, 110))

	local realisticRadius = true
	local ExplodeDist = 200
	local ExplodeDamage = GetConVar("sk_cguard_dmg_exp"):GetInt()

	util.VJ_SphereDamage(self, self,  pos, ExplodeDist, ExplodeDamage, bit.bor(DMG_BLAST, DMG_DISSOLVE, DMG_SHOCK), true, realisticRadius)
	effects.BeamRingPoint(pos, 0.6, 2, 700, 32, 2, Color(100, 100, 255))

	local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "8")
		expLight:SetKeyValue("distance", "650")
		expLight:Fire("Color", "0 75 255")
		expLight:SetPos(pos)
		expLight:Spawn()
		expLight:Fire("TurnOn", "", 0)
	timer.Simple(0.2,function() if IsValid(expLight) then expLight:Remove() end end)
	self:DeleteOnRemove(expLight)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrenadeAttack()
	if self.GrenadeAttacking then return end
		self.GrenadeAttacking = true
	local total_time = 1.5
	local fire_time = 0.9

	self:EmitSound(table.Random(self.SoundTbl_GrenadeAttack), 80, 100, 1, CHAN_VOICE )
	self:VJ_ACT_PLAYACTIVITY("grenade", true, total_time, true)

	timer.Simple(fire_time, function() if IsValid(self) then

		local targetpos = self:GetPos() + self:GetForward() * 300

	if IsValid(self:GetEnemy()) then

		if self:Visible(self:GetEnemy()) then
			targetpos = self:GetEnemy():GetPos()
		elseif self.PotentialGrenadePos then
			targetpos = self.PotentialGrenadePos
		end
	end

	self:EmitSound("weapons/mortar/mortar_fire1.wav",100,math.random(90, 110))

        local grenade = ents.Create("obj_vj_cguard_extractor")
		grenade:SetPos(self:GetAttachment(2).Pos)
		grenade:Spawn()
		grenade:GetPhysicsObject():SetVelocity(targetpos - self:GetPos() + Vector(0,0,200))
		grenade:SetOwner(self)
	end end)

	timer.Simple(total_time, function() if IsValid(self) then
		self.GrenadeAttacking = false
		self.NextGrenadeAttack = CurTime() + math.Rand(self.GrenadeAttackDelay.min, self.GrenadeAttackDelay.max)
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsAlly(ent)
	if !ent.VJ_NPC_Class then return end
		for _,npcclass in pairs(ent.VJ_NPC_Class) do
			for _,mynpcclass in pairs(self.VJ_NPC_Class) do
				if npcclass == mynpcclass then
			return true
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetScale( 100 )
		util.Effect("Explosion", effectdata )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.HasGibDeathParticles == true then -- Taken from black mesa SNPCs I think Xdddddd
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
  		bloodeffect:SetColor(VJ_Color2Byte(Color(0,0,0)))
		bloodeffect:SetScale(200)
		util.Effect("VJ_Blood1",bloodeffect)
	end
		self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 60)), Ang=self:GetAngles()+Angle(0, -90, 0)})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/manhack_gib03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 55)), Ang=self:GetAngles()+Angle(0, -90, 0), Vel=self:GetRight()*math.Rand(150, 250)+self:GetForward()*math.Rand(-200, 200)})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/manhack_gib03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 3, 55)), Ang=self:GetAngles()+Angle(0, -90, 0), Vel=self:GetRight()*math.Rand(-150, -250)+self:GetForward()*math.Rand(-200, 200)})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/manhack_gib03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 55)), Ang=self:GetAngles()+Angle(0, -90, 0), Vel=self:GetRight()*math.Rand(150, 250)+self:GetForward()*math.Rand(-200, 200)})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/manhack_gib03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 3, 55)), Ang=self:GetAngles()+Angle(0, -90, 0), Vel=self:GetRight()*math.Rand(-150, -250)+self:GetForward()*math.Rand(-200, 200)})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/manhack_gib03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 55)), Ang=self:GetAngles()+Angle(0, -90, 0), Vel=self:GetRight()*math.Rand(150, 250)+self:GetForward()*math.Rand(-200, 200)})
		self:CreateGibEntity("obj_vj_gib", "models/gibs/manhack_gib03.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 3, 55)), Ang=self:GetAngles()+Angle(0, -90, 0), Vel=self:GetRight()*math.Rand(-150, -250)+self:GetForward()*math.Rand(-200, 200)})
		self:CreateGibEntity("obj_vj_gib", "models/props_c17/canisterchunk01h.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 40))})
		self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01d.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 41))})
		self:CreateGibEntity("obj_vj_gib", "models/container_chunk02.mdl", {CollisionDecal=false, CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 42))})
		self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01e.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 35))})
		self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01e.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 35))})
		self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 0))})
		self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 0))})
		self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 0))})
		self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 0))})
	for i = 1, 2 do
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetBodygroup(1,0)
	self:CreateGibEntity("physics_prop", "models/cguard_gun.mdl", {CollisionDecal=false,  CollisionSound={"physics/metal/metal_solid_impact_soft1.wav", "physics/metal/metal_solid_impact_soft2.wav", "physics/metal/metal_solid_impact_soft3.wav"}, Pos=self:LocalToWorld(Vector(0, 0, 60)), Ang=self:GetAngles()+Angle(0, -90, 0)})
end