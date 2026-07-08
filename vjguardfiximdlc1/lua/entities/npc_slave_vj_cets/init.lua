AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vortigaunt_slave.mdl"}
ENT.StartHealth = GetConVar("sk_cets_vortigaunt_health"):GetInt()
ENT.CanChatMessage = false
ENT.JumpParams = {
	Enabled = false, -- Can it do movement jumps?
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
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
ENT.RangeAttackDamage = 25
ENT.AnimTbl_RangeAttack = {"zapattack1"} -- Range Attack Animations
ENT.RangeDistance = 2500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 150 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = 0.85 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 4 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 5 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.MaxDispellDist = 200
ENT.DispellAttackDamage = GetConVar("sk_vortigaunt_zap_range"):GetInt()
ENT.VortDispellCooldown = 5

ENT.HealDistance = 60
ENT.VortHealCooldown = 1.5

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.FootStepSoundLevel = 40
ENT.IdleSoundLevel = 75
ENT.CombatIdleSoundLevel = 75
ENT.InvestigateSoundLevel = 75
ENT.AlertSoundLevel = 75
ENT.PainSoundLevel = 75
ENT.DeathSoundLevel = 80
ENT.BeforeRangeAttackSoundLevel = 80

ENT.CombatIdleSoundLevel = 90
ENT.BeforeRangeAttackPitch = VJ.SET(100,110)

ENT.MainSoundChance = 2
ENT.BeforeRangeAttackSoundChance = 1
ENT.FootStepSoundChance = 1
ENT.DeathSoundChance = 1

ENT.SoundTbl_FootStep = {
	"npc/vort/vort_foot1.wav",
	"npc/vort/vort_foot2.wav",
	"npc/vort/vort_foot3.wav",
	"npc/vort/vort_foot4.wav",
}

ENT.SoundTbl_BeforeRangeAttack = {"npc/vort/attack_charge.wav"}

ENT.SoundTbl_Idle = {
	"npc/vort/slave/slv_word1",
	"npc/vort/slave/slv_word2",
	"npc/vort/slave/slv_word3",
}

ENT.SoundTbl_CombatIdle = {
	"npc/vort/slave/slv_word4",
	"npc/vort/slave/slv_word5",
	"npc/vort/slave/slv_word6",
}

ENT.SoundTbl_Investigate = {
	"npc/vort/slave/slv_word7",
	"npc/vort/slave/slv_word8",
}

ENT.SoundTbl_Alert = {
	"npc/vort/slave/slv_alert1",
	"npc/vort/slave/slv_alert3",
	"npc/vort/slave/slv_alert4",
}

ENT.SoundTbl_Death = {
	"npc/vort/slave/slv_die1.wav",
	"npc/vort/slave/slv_die2.wav",
}

ENT.SoundTbl_Pain = {
	"npc/vort/slave/slv_pain1.wav",
	"npc/vort/slave/slv_pain2.wav",
}

ENT.SoundTbl_MeleeAttackMiss = {"NPC_Vortigaunt.Swing"}

local hurtgests = {
	"flinch_01",
	"flinch_02",
	"flinch_03",
}

local TeamNone = -1
local TeamS = 1
local TeamZ = 2

local TeamR = 2

ENT.VSquadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self.TeamS = 1
	self.VortChargeTimerName = "VJ_VortSynth_Z_ChargeTimer" .. self:EntIndex()
	self.VortHealOrbsTimerName = "VJ_VortSynth_Z_HealOrbTimer" .. self:EntIndex()
	self.NextDispell = CurTime()
	self.NextHeal = CurTime()
	self.NextFindHurtAllyT = CurTime()

	self.BlackAmount = 0

	if self.TeamS == 1 then
		self.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}	
	end

	self.VSquadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	if not IsValid(VJ.VSquadC_Leader) then
		for _, ent in ipairs(ents.GetAll()) do
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_aliengrunt_vj_cets" then
					VJ.VSquadC_Leader = ent
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("SPACE (jump key): Dispell")
	ply:ChatPrint("ALT (walk key): Heal Orbs")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 1 then
		self:PlayAnim({"toaction"}, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_yield_leader = vj_ai_schedule.New("SCHEDULE_YIELD_LEADER")
schedule_yield_leader:EngTask("TASK_MOVE_AWAY_PATH", 120)
schedule_yield_leader:EngTask("TASK_WALK_PATH", 0)
schedule_yield_leader:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schedule_yield_leader.TurnData = {Type = VJ.FACE_ENTITY_VISIBLE, Target = nil}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
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

	local leader = VJ.VSquadC_Leader

	if IsValid(leader) then
		if leader ~= self then
			self.DisableWandering = true
			if IsValid(self:GetEnemy()) or self:IsBusy() then return end

			local targetPos = leader:GetPos() + self.VSquadrant_FollowOffsetPos
			local leaderSpeed = leader:GetVelocity():Length()

			local pos = leader:GetPos() + self.VSquadrant_FollowOffsetPos
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
				self:SetLastPosition(leader:GetPos() + self.VSquadrant_FollowOffsetPos)

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
			if ent:IsNPC() and string.lower(ent:GetClass()) == "npc_aliengrunt_vj_cets" then
					VJ.VSquadC_Leader = ent
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo)
	if math.random(1, 8) == 1 then
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
	self:EmitSound("npc/vort/vort_explode" .. math.random(1, 2) .. ".wav", 100, math.random(95, 105))
	self:StopSound("npc/vort/attack_charge.wav")
	if self.RangeAttackPos then
		for i = 3,4 do
			local source = self:GetAttachment(i).Pos
			local tr = util.TraceLine({
				start = source,
 				endpos = source + (self.RangeAttackPos - (source+VectorRand(-8,8))):GetNormalized()*10000,
				mask = MASK_SHOT,
				filter = self,
		})
		util.ParticleTracerEx("vortigaunt_beam",self:GetPos()+self:OBBCenter(),tr.HitPos,false,self:EntIndex(),i)
		util.VJ_SphereDamage(self,self,tr.HitPos,200,self.RangeAttackDamage,bit.bor(DMG_SHOCK),true,true,false,false)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	self:StopSound("npc/vort/attack_charge.wav")
	if status == "Init" then
		local randRange = math.random(1, 3)
		if randRange == 1 then
			self.SoundTbl_MeleeAttack = {"NPC_FastZombie.AttackHit"}
			self.MeleeAttackDamage = GetConVar("sk_vortigaunt_dmg_claw"):GetInt()
			self.AnimTbl_MeleeAttack = {"meleehigh1", "meleehigh2"}
		elseif randRange == 2 then
			self.SoundTbl_MeleeAttack = {"npc/vort/foot_hit.wav"}
			self.MeleeAttackDamage = GetConVar("sk_vortigaunt_dmg_claw"):GetInt()
			self.AnimTbl_MeleeAttack = "meleelow"
		elseif randRange == 3 then
			self.SoundTbl_MeleeAttack = {"NPC_FastZombie.AttackHit"}
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
	self:StopSound("npc/vort/attack_charge.wav")
	if self.DoingHeal then return end
	self.DoingHeal = true
	self:VortCharge(5)

	if !agressive then
		self.VortHeal_CurrentAlly = target
	end

	local healduration = 2
	self:AddGesture(self:GetSequenceActivity(self:LookupSequence("gest_heal")))
	self:EmitSound("npc/vort/health_charge.wav",90,100)

	timer.Simple(1.25, function() if IsValid(self) then

	timer.Create(self.VortHealOrbsTimerName, 0.16, 6, function()
		local speed = 650
		local orb = ents.Create("obj_vj_vort_orb")
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
	timer.Create(self.VortChargeTimerName, 0.3, effectreps, function()
		ParticleEffectAttach("vortigaunt_hand_glow_cets", PATTACH_POINT_FOLLOW, self, 4)
		ParticleEffectAttach("vortigaunt_hand_glow_cets", PATTACH_POINT_FOLLOW, self, 3)
		ParticleEffectAttach("vortigaunt_glow_beam_cp0", PATTACH_POINT_FOLLOW, self, 4)
		ParticleEffectAttach("vortigaunt_glow_beam_cp0", PATTACH_POINT_FOLLOW, self, 3)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(ev, evTime, evCycle, evType, evOptions)
	local getEventName = util.GetAnimEventNameByID
	local event = getEventName(ev)
	if event == "AE_VORTIGAUNT_ZAP_POWERUP" or event == "AE_VORTIGAUNT_DEFEND_BEAMS" or event == "AE_VORTIGAUNT_HEAL_STARTBEAMS" then
		local short = event == "AE_VORTIGAUNT_DEFEND_BEAMS"
		local noElec = event == "AE_VORTIGAUNT_HEAL_STARTBEAMS"

		for i = 3, (noElec && 3 or 4) do
			if !noElec then
				local target = ents.Create("prop_vj_animatable")
					target:SetName("vortigaunt_charge_token" .. i .. "_" .. target:EntIndex())
					target:SetModel("models/props_junk/watermelon01.mdl")
					target:SetPos(self:GetAttachment(i).Pos +VectorRand() *math.Rand(-12, 32))
					target:Spawn()
					target:Activate()
					target:SetNoDraw(true)
					target:DrawShadow(false)
					target:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
					target:SetSolid(SOLID_NONE)

				local att = self:GetAttachment(i)
				local particle = ents.Create("info_particle_system")
					particle:SetKeyValue("effect_name", "vortigaunt_beam_charge")
					particle:SetPos(att.Pos)
					particle:SetAngles(att.Ang)
					particle:SetKeyValue("start_active", "1")
					particle:SetKeyValue("cpoint1", target:GetName())
					particle:Spawn()
					particle:Activate()
					particle:SetParent(self)
					particle:Fire("SetParentAttachment", i == 3 && "leftclaw" or "rightclaw")
					particle:DeleteOnRemove(target)
				self:DeleteOnRemove(particle)
			end

			local deleteTime = (short or noElec) && 0.25 or 1.5
			SafeRemoveEntityDelayed(target, deleteTime)
			SafeRemoveEntityDelayed(particle, deleteTime)
			SafeRemoveEntityDelayed(light, deleteTime)
			if short then
				timer.Simple(0.25, function()
					if IsValid(self) then
						self:StopParticles()
					end
				end)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Attacking()
	if self.RangeAttacking or self.MeleeAttacking or self.DispellAttacking or self.DoingHeal then return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DispellAttack()
	if self.DispellAttacking then return end
	self:StopSound("npc/vort/attack_charge.wav")
	self.DispellAttacking = true
	self:EmitSound("npc/vort/vort_dispell.wav", 100, 100)
	self:VortCharge(4)

	local duration = 1.5
	local impacttime = 2
	self:VJ_ACT_PLAYACTIVITY("Dispel",true,2,false)

	timer.Simple(impacttime, function() if IsValid(self) then
		local Dispellpos = self:GetPos()+self:GetUp()*4
			util.VJ_SphereDamage(self,self,Dispellpos,self.MaxDispellDist*1.25,self.DispellAttackDamage,bit.bor(DMG_SHOCK,DMG_BLAST),true,true,false,false)
			util.ScreenShake(Dispellpos, 16, 200, 1, self.MaxDispellDist*4)
			VJ.EmitSound(self, "npc/vort/vort_explode" .. math.random(1, 2) .. ".wav", 100)

	local effectdata = EffectData()
		effectdata:SetOrigin(Dispellpos)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetRadius( self.MaxDispellDist*0.25 )
		effectdata:SetScale( 150 )
	util.Effect( "VortDispel", effectdata )

	local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "4")
		expLight:SetKeyValue("distance", tostring(self.MaxDispellDist*2))
		expLight:Fire("Color", "120 255 120")
		expLight:SetPos(Dispellpos)
		expLight:Spawn()
		expLight:Fire("TurnOn", "", 0)
			timer.Simple(0.1,function() if IsValid(expLight) then expLight:Remove() end end)
			self:DeleteOnRemove(expLight)
		effects.BeamRingPoint( Dispellpos, 0.35, 0, self.MaxDispellDist*2, 50, 5, Color(120,255,120,16) )
	end end)

	timer.Simple(duration, function() if IsValid(self) then
		self.DispellAttacking = false
		self.NextDispell = CurTime() + self.VortDispellCooldown
	end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:StopSound("npc/vort/attack_charge.wav")
	if timer.Exists(self.VortChargeTimerName) then
		timer.Remove(self.VortChargeTimerName)
	end

	if timer.Exists(self.VortHealOrbsTimerName) then
		timer.Remove(self.VortHealOrbsTimerName)
	end
end