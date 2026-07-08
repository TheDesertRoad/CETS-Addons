AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_gargantua.mdl"
ENT.StartHealth = GetConVar("sk_cets_gargantua_health"):GetInt()
ENT.SightAngle = 90
ENT.SightDistance = 20000
ENT.TimeUntilEnemyLost = 50000
ENT.HullType = HULL_LARGE_CENTERED
ENT.InvestigateSoundDistance = 80000
ENT.CallForHelpDistance = 20000 -- -- How far away the SNPC's call for help goes | Counted in World Units 
ENT.VJ_ID_Boss = true
ENT.VJ_NPC_Class = {"CLASS_XVORTIGAUNT","CLASS_XEN"}
ENT.HasWorldShakeOnMove = true
ENT.ConstantlyFacingEnemy = true
ENT.CanChatMessage = false
ENT.CanTurnWhileMoving = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Physics = FALSE -- Immune to Physics
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.Immune_Toxic = true
ENT.Immune_Fire = true
ENT.Immune_Melee = true
ENT.AllowIgnition = false
ENT.ImmuneDamagesTable = {DMG_BURN}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"attack", "smash", "kickcar"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = GetConVar("sk_cets_gargantua_dmg"):GetInt()
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 500 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 800 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackDistance = 180
ENT.MeleeAttackDamageDistance = 185
ENT.MeleeAttackDamageType = DMG_CRUSH
ENT.HasExtraMeleeAttackSounds = true

ENT.HasRangeAttack = false

ENT.CanFlinch = "DamageTypes"
ENT.FlinchDamageTypes = {DMG_BLAST}
ENT.FlinchChance = 4
ENT.AnimTbl_Flinch = {"flinchheavy"}

ENT.GibOnDeathFilter = false

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {"die"}
ENT.DeathAnimationTime = 4.4

ENT.Garg_Type = 0
ENT.Garg_CanFlame = false
ENT.Garg_FlameLevel = 0 -- 0 = Not started | 1 = Preparing | 2 = Flame active
ENT.Garg_NextFlameT = 0
ENT.Garg_MeleeLargeKnockback = false

ENT.FootStepSoundLevel = 100
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking

ENT.AlertSoundLevel = 100
ENT.PainSoundLevel = 100
ENT.DeathSoundLevel = 100
ENT.FlinchSoundLevel = 100
ENT.MeleeAttackExtraSoundLevel = 80

ENT.MainSoundPitch = 100
ENT.MeleeAttackMissSoundPitch = 70

ENT.SoundTbl_FootStep = {"npc/gargantua/gar_step1.wav", "npc/gargantua/gar_step2.wav"}

ENT.SoundTbl_Breath = {
	"npc/gargantua/gar_breathe1.wav",
	"npc/gargantua/gar_breathe2.wav",
	"npc/gargantua/gar_breathe3.wav",
}

ENT.SoundTbl_Idle = {
	"npc/gargantua/gar_idle1.wav",
	"npc/gargantua/gar_idle2.wav",
	"npc/gargantua/gar_idle3.wav",
	"npc/gargantua/gar_idle4.wav",
	"npc/gargantua/gar_idle5.wav",
}

ENT.SoundTbl_Alert = {
	"npc/gargantua/gar_alert1.wav",
	"npc/gargantua/gar_alert2.wav",
	"npc/gargantua/gar_alert3.wav",
}

ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/gargantua/gar_attack1.wav",
	"npc/gargantua/gar_attack2.wav",
	"npc/gargantua/gar_attack3.wav",
}


ENT.SoundTbl_MeleeAttackMiss = "hl1/weapons/ax1.wav"

ENT.SoundTbl_Pain = {
	"npc/gargantua/gar_pain1.wav",
	"npc/gargantua/gar_pain2.wav",
	"npc/gargantua/gar_pain3.wav",
}

ENT.SoundTbl_Death = {
	"npc/gargantua/gar_die1.wav",
	"npc/gargantua/gar_die2.wav"
}

ENT.SoundTbl_Flinch = {
	"npc/gargantua/gar_alert1.wav",
	"npc/gargantua/gar_alert2.wav",
	"npc/gargantua/gar_alert3.wav"
}

ENT.SoundTbl_MeleeAttackExtra = "npc/gargantua/gar_shove1.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.TimersToRemove[#self.TimersToRemove + 1] = "garg_flame_reset"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)

	local glow1 = ents.Create("env_sprite")
	glow1:SetKeyValue("model", "sprites/gargantua/gargeye1.vmt")
	glow1:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
	glow1:SetKeyValue("renderfx", "14")
	glow1:SetKeyValue("scale", "1")
	glow1:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
	glow1:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
	glow1:SetKeyValue("spawnflags", "0")
	glow1:SetParent(self)
	glow1:Fire("SetParentAttachment", "0")
	glow1:Spawn()
	glow1:Activate()
	self:DeleteOnRemove(glow1)

	self.DynamicLight = ents.Create("light_dynamic")
	self.DynamicLight:SetKeyValue("brightness", "3")
	self.DynamicLight:SetKeyValue("distance", "128")
	self.DynamicLight:SetLocalPos(self:GetPos())
	self.DynamicLight:SetLocalAngles(self:GetAngles())
	self.DynamicLight:Fire("Color", "255 0 0")
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Spawn()
	self.DynamicLight:Activate()
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Fire("SetParentAttachment", "0")
	self.DynamicLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.DynamicLight)

	if self.Garg_Type == 0 then
		self:SetCollisionBounds(Vector(70, 70, 170),  Vector(-70, -70, 0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && self.Garg_FlameLevel >= 1 then
		return ACT_MELEE_ATTACK2
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
	end

	if self.Garg_CanFlame && self.Garg_NextFlameT < CurTime() && self.AttackType == VJ.ATTACK_TYPE_NONE then
		self.DisableChasingEnemy = true
		self:StopMoving()

		if GetConVar("npc_cets_gargantua_preparation"):GetInt() == 1 then
			if self.Garg_FlameLevel == 0 then
				self:PlayAnim("shootflames1", "LetAttacks", false)
				self.Garg_FlameLevel = 1
				self.Garg_NextFlameT = CurTime() + 0.8 -- Don't use anim duration because we want it to start playing the flame animation mid way
				timer.Simple(0.5, function() -- Play flame start sound
					if IsValid(self) && self.Garg_CanFlame then
						VJ.EmitSound(self, "npc/gargantua/gar_flameon1.wav", 80)
					end
				end)
				return
			end
		
			self.Garg_FlameLevel = 2
			self.Garg_NextFlameT = CurTime() + 0.2

		else

			if self.Garg_FlameLevel == 0 then
				VJ.EmitSound(self, "npc/gargantua/gar_flameon1.wav", 80)
			end
		
			self.Garg_FlameLevel = 2
			self:PlayAnim("shootflames2", "LetAttacks", false)
		end

		local range = (self.Garg_Type == 1 and 280) or 460
		VJ.ApplyRadiusDamage(self, self, self:GetPos() + self:OBBCenter() + self:GetForward()*15, range, GetConVar("sk_gargantua_dmg_fire"):GetInt(), DMG_BURN, true, true, {UseConeDegree = 35}, function(ent) if !ent:IsOnFire() && (ent:IsPlayer() or ent:IsNPC()) then ent:Ignite(2) end end)
		
		self.Garg_FlameSd = VJ.CreateSound(self, "npc/gargantua/gar_flamerun1.wav")
		self:StopParticles()
		ParticleEffectAttach("ta_cremator_flamethrower", PATTACH_POINT_FOLLOW, self, 2)
		ParticleEffectAttach("ta_cremator_flamethrower", PATTACH_POINT_FOLLOW, self, 3)
		local startPos1 = self:GetAttachment(2).Pos
		local startPos2 = self:GetAttachment(3).Pos
		local tr1 = util.TraceLine({start = startPos1, endpos = startPos1 + self:GetForward()*range, filter = self})
		local tr2 = util.TraceLine({start = startPos2, endpos = startPos2 + self:GetForward()*range, filter = self})
		local hitPos1 = tr1.HitPos
		local hitPos2 = tr2.HitPos
		sound.EmitHint(SOUND_DANGER, (hitPos1 + startPos1) / 2, 300, 1, self) -- Pos: Midpoint of start and hit pos, same as Vector((hitPos1.x + startPos1.x ) / 2, (hitPos1.y + startPos1.y ) / 2, (hitPos1.z + startPos1.z ) / 2)
		sound.EmitHint(SOUND_DANGER, (hitPos2 + startPos2) / 2, 300, 1, self)
		util.Decal("VJ_CETS_Garg_Burnt1", hitPos1 + tr1.HitNormal, hitPos1 - tr1.HitNormal)
		util.Decal("VJ_CETS_Garg_Burnt1", hitPos2 + tr2.HitNormal, hitPos2 - tr2.HitNormal)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(isAttacking, enemy)
	local eneData = self.EnemyData
	local eneVisible = eneData.Visible
	local range = (self.Garg_Type == 1 and 250) or 400
	if self.VJ_IsBeingControlled then
		range = 9999999
		eneVisible = true -- Skip enemy visibility check when being controlled!
		if !self.VJ_TheController:KeyDown(IN_ATTACK2) then -- Do flame attack only when player is holding down right click
			self:Garg_ResetFlame()
			return
		end
	end
	if eneVisible && self.AttackType == VJ.ATTACK_TYPE_NONE && eneData.DistanceNearest <= range && eneData.DistanceNearest > self.MeleeAttackDistance then
		self.Garg_CanFlame = true
		self:SetTurnTarget(enemy, -1)
		-- Make it constantly delay the range attack timer by 1 second (Which will also successfully play the flame-end sound)
		timer.Create("garg_flame_reset" .. self:EntIndex(), 1, 0, function()
			self:Garg_ResetFlame()
		end)
	else
		self:Garg_ResetFlame()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Garg_ResetFlame()
	if self.Garg_CanFlame then
		self:ResetTurnTarget()
	end
	if self.Garg_FlameLevel == 2 then
		VJ.EmitSound(self, "npc/gargantua/gar_flameoff1.wav", 80)
	end

	self.Garg_CanFlame = false
	self.Garg_FlameLevel = 0
	self.DisableChasingEnemy = false
	VJ.STOPSOUND(self.Garg_FlameSd)
	self:StopParticles()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.Garg_FlameLevel = 0
	self.Garg_CanFlame = false
	self.Garg_NextFlameT = 0
	self:StopParticles()

	VJ.STOPSOUND(self.Garg_FlameSd)
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 150, 100)
	VJ.EmitSound(self, "npc/gargantua/gar_die" .. math.random(1, 2) .. ".wav", 150, 100)
    	ParticleEffect("striderbuster_explode_goop", self:GetPos(), self:GetAngles() )
	for i = 0.3, 3.5, 0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
					local effectdata = EffectData()
					effectdata:SetScale( 500 )
					effectdata:SetOrigin(self:GetPos())
					util.Effect("Explosion", effectdata)
					util.ScreenShake(self:GetPos(),44,1000,2,1000)
					VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 150, 100)
			end
		end)
	end

    	return true, {AllowAnim = true, AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"phx/explode00.wav",100,100)
	VJ_EmitSound(self,"phx/explode01.wav",100,100)
	VJ_EmitSound(self,"phx/explode02.wav",100,100)
	self:StopSound("npc/gargantua/gar_flamerun1.wav")

	util.BlastDamage(self,self,self:GetPos(),800,200,DMG_BLAST,true,true)
	util.ScreenShake(self:GetPos(),44,1000,2,1000)

	effects.BeamRingPoint(self:GetPos() +Vector(0, 0, 5), 0.4, 2, 2000, 128, 8, Color(240, 240, 255, 32))

	ParticleEffect("explosion_huge_g", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("explosion_huge_h", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("cguard_fire", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("gonarch_explode_alternate1", self:GetPos(), Angle(0,0,0), nil)

	self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/canisterchunk01h.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01d.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01d.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01d.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("prop_ragdoll", "models/props_cets_aliens/gargantua_brain.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 120))})
	self:CreateGibEntity("prop_ragdoll", "models/props_cets_aliens/gargantua_brain.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 120))})
	self:CreateGibEntity("prop_ragdoll", "models/props_cets_aliens/gargantua_brain.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 120))})
	self:CreateGibEntity("prop_ragdoll", "models/props_cets_aliens/gargantua_brain.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 120))})
	self:CreateGibEntity("obj_vj_gib", "models/container_chunk02.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01e.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01e.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01e.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/props_c17/oildrumchunk01e.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/props_canal/winch02c.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib2.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib3.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib7.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_base/gibs/alien/gib1.mdl", {BloodType="Yellow", CollisionDecal="YellowBlood", Pos=self:LocalToWorld(Vector(0, 1, 5))})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:StopSound("npc/gargantua/gar_flamerun1.wav")
end