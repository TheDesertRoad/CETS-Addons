AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_exhoundeye.mdl"
ENT.StartHealth = 80
ENT.HullType = HULL_WIDE_SHORT
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Orange"
ENT.BloodDecal = "VJ_CETS_OBlood"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Sonic = true
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK1
ENT.MeleeAttackDistance = 130
ENT.MeleeAttackDamageDistance = 400
ENT.MeleeAttackDamageAngleRadius = 180
ENT.TimeUntilMeleeAttackDamage = 2.35
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackDamageType = DMG_BLAST
ENT.MeleeAttackDSP = 34
ENT.MeleeAttackDSPLimit = false
ENT.DisableDefaultMeleeAttackDamageCode = true
ENT.Immune_Fire = true
ENT.AllowIgnition = false

ENT.CanChatMessage = false

ENT.CanEat = true
ENT.EatCooldown = 30 
ENT.AnimTbl_Eat =  {"eat"}

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {"vjseq_flinch_small"}

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "HoundEye.Head",
    FirstP_Offset = Vector(4, 0, 0),
}

ENT.SoundTbl_FootStep = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav",
}

ENT.FootStepSoundLevel = 55
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking

ENT.SoundTbl_CallForHelp = {"npc/houndeye/he_bark_group_attack.wav"}
ENT.SoundTbl_ReceiveOrder = {"npc/houndeye/he_bark_group_attack_reply.wav"}
ENT.SoundTbl_AllyDeath = {"npc/houndeye/he_bark_group_retreat.wav"}
ENT.SoundTbl_Idle = {
	"npc/houndeye/he_idle1.wav",
	"npc/houndeye/he_idle2.wav",
	"npc/houndeye/he_idle3.wav",
	"npc/houndeye/he_idle4.wav",
}
ENT.SoundTbl_Alert = {
	"npc/houndeye/he_alert1.wav",
	"npc/houndeye/he_alert2.wav",
	"npc/houndeye/he_alert3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/houndeye/he_attack1.wav",
	"npc/houndeye/he_attack2.wav",
	"npc/houndeye/he_attack3.wav",
}
ENT.SoundTbl_Pain = {
	"npc/houndeye/he_pain1.wav",
	"npc/houndeye/he_pain2.wav",
	"npc/houndeye/he_pain3.wav",
	"npc/houndeye/he_pain4.wav",
	"npc/houndeye/he_pain5.wav",
	"npc/houndeye/he_yelp1.wav"
}
ENT.SoundTbl_Death = {
	"npc/houndeye/he_die1.wav",
	"npc/houndeye/he_die2.wav",
	"npc/houndeye/he_die3.wav",
}

ENT.FootstepSoundLevel = 80
ENT.FootstepSoundPitch = VJ.SET(110, 115)
ENT.MainSoundPitch = 100

ENT.Squadrant_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("npc_cets_hounds_xenfriends"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
	else
		self.VJ_NPC_Class = {"CLASS_HOUND"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(17, 17, 40), Vector(-17, -17, 0))

	self.BlackAmount = 0

	self.Squadrant_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))

	local flags = self:GetSpawnFlags()

	if !IsValid(SquadC_Leader) && string.lower(self:GetModel()) == "models/hl2_exhoundeye.mdl" or bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
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
function ENT:OnThink()
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
		if string.lower(self:GetModel()) == "models/hl2_exhoundeye.mdl" or bit.band(flags, 32) ~= 0 or self:HasSpawnFlags(32) then
			VJ.SquadC_Leader = self
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "step" then
		self:PlayFootstepSound()
	end
	if key == "hunt" then
		VJ.EmitSound(self, "houndeye/he_hunt" .. math.random(1, 4) .. ".wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks()
	self:SetHealth(1)
	util.BlastDamage(self, self, self:GetPos(), 21, 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	ParticleEffect("hound_explosion_1",self:GetPos(),Angle(0,0,0),nil)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav")
	VJ.EmitSound(self, "npc/squeek/sqk_blast1.wav", 90, 70)
	
	self:SetHealth(1)
	
	local allies = {}
	local alliesNum = 0
	local isPassive = self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE
	local myClass = self:GetClass()
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), dist or 800)) do
		local entData = ent:GetTable()
		if ent != self && entData.IsVJBaseSNPC && entData.CanReceiveOrders && ent:Alive() && (ent:GetClass() == myClass or (ent:Disposition(self) == D_LI or entData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE)) then
			if isPassive then
				if entData.Behavior == VJ_BEHAVIOR_PASSIVE or entData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
					alliesNum = alliesNum + 1
					allies[alliesNum] = ent
				end
			else
				alliesNum = alliesNum + 1
				allies[alliesNum] = ent
			end
		end
	end


	if GetConVar("npc_cets_hounds_xenfriends"):GetInt() == 1 then
		util.VJ_SphereDamage(self,self,self:GetPos(),300,20,self.MeleeAttackDamageType,true,true,{Force60})

	elseif alliesNum == 0 && GetConVar("npc_cets_hounds_xenfriends"):GetInt() == 0 then
		util.VJ_SphereDamage(self,self,self:GetPos(),300,20,self.MeleeAttackDamageType,true,true,{Force60})

	elseif alliesNum == 1 && GetConVar("npc_cets_hounds_xenfriends"):GetInt() == 0 then
		util.VJ_SphereDamage(self,self,self:GetPos(),300,40,self.MeleeAttackDamageType,true,true,{Force80})

	elseif alliesNum == 2 && GetConVar("npc_cets_hounds_xenfriends"):GetInt() == 0 then
		util.VJ_SphereDamage(self,self,self:GetPos(),300,60,self.MeleeAttackDamageType,true,true,{Force100})

	elseif alliesNum == 3 && GetConVar("npc_cets_hounds_xenfriends"):GetInt() == 0 then
		util.VJ_SphereDamage(self,self,self:GetPos(),300,80,self.MeleeAttackDamageType,true,true,{Force120})

	elseif alliesNum > 3 && GetConVar("npc_cets_hounds_xenfriends"):GetInt() == 0 then
		util.VJ_SphereDamage(self,self,self:GetPos(),300,100,self.MeleeAttackDamageType,true,true,{Force140})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup)
	self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +5))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "Init" then
		-- Houndeye shouldn't have its sonic attack interrupted by a flinch animation!
		return self.AttackAnimTime > CurTime()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 1 then
		self:PlayAnim({"vjseq_madidle1", "vjseq_madidle2", "vjseq_madidle3"}, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ50 = Vector(0, 0, -50)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnEat(status, statusData)
	-- The following code is a ideal example based on Half-Life 1 Zombie
	//VJ.DEBUG_Print(self, "OnEat", status, statusData)
	if status == "CheckFood" then
		return true //statusData.owner.BloodData && statusData.owner.BloodData.Color == VJ.BLOOD_COLOR_RED
	elseif status == "BeginEating" then
		self.AnimationTranslations[ACT_IDLE] = ACT_GESTURE_RANGE_ATTACK1 -- Eating animation
		return select(2, self:PlayAnim(ACT_ARM, true, false))
	elseif status == "Eat" then
		VJ.EmitSound(self, "barnacle/bcl_chew" .. math.random(1, 3) .. ".wav", 55)
		-- Health changes
		local food = self.EatingData.Target
		local damage = 30 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
		self:PlayAnim("eat", true, true)
		-- Blood effects
		local bloodData = food.BloodData
		if bloodData then
			local bloodPos = food:GetPos() + food:OBBCenter()
			local bloodParticle = VJ_PICK(bloodData.Particle)
			if bloodParticle then
				ParticleEffect(bloodParticle, bloodPos, self:GetAngles())
			end
			local bloodDecal = VJ_PICK(bloodData.Decal)
			if bloodDecal then
				local tr = util.TraceLine({start = bloodPos, endpos = bloodPos + vecZ50, filter = {food, self}})
				util.Decal(bloodDecal, tr.HitPos + tr.HitNormal + Vector(math.random(-45, 45), math.random(-45, 45), 0), tr.HitPos - tr.HitNormal, food)
			end
		end
		return 2 -- Eat every this seconds
	elseif status == "StopEating" then
		if statusData != "Dead" && self.EatingData.AnimStatus != "None" then -- Do NOT play anim while dead or has NOT prepared to eat
			return select(2, self:PlayAnim("inspect", true, false))
		end
	end
	return 0
end