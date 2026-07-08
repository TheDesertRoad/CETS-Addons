AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_jeff.mdl" 
ENT.StartHealth = GetConVar("sk_jeff_health"):GetInt()
ENT.HullType = HULL_HUMAN
ENT.VJ_ID_Boss = true
ENT.VJ_NPC_Class = {"CLASS_FUNGUS"}
ENT.TimeUntilEnemyLost = 10 
ENT.CanInvestigate = true
ENT.InvestigateSoundMultiplier = 320 -- Max sound hearing distance multiplier | This multiplies the calculated volume of the sound
ENT.IdleAlwaysWander = true
ENT.CanChatMessage = false
ENT.HasSounds = true 
ENT.SightDistance = 600
ENT.TurningSpeed = 20
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.TimeUntilMeleeAttackDamage = 0.7
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.NextMeleeAttackTime = 0.5 -- How much time until it can use a melee attack?
ENT.HasMeleeAttack = true 
ENT.MeleeAttackDamage = GetConVar("sk_jeff_dmg_melee"):GetInt()
ENT.MeleeAttackDamageType = DMG_SLASH

ENT.AnimTbl_MeleeAttack = {"AttackA", "AttackB", "AttackC", "AttackD", "AttackE", "AttackF", "Swatleftlow", "Swatleftmid", "Swatrightlow", "Swatrightmid", "breakthrough"}
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 8 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 8 -- How many repetitions?

ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 80 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 90 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 10 -- How much time until player's Speed resets

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {"releasecrab"}
ENT.RangeAttackProjectiles = {"obj_vj_jeffvomit"}
ENT.RangeAttackExtraTimers = {1.01, 1.01}
ENT.TimeUntilRangeAttackProjectileRelease = 1
ENT.NextRangeAttackTime = 5
ENT.RangeAttackExtraTimers = {1.1, 1.2}
ENT.NextRangeAttackTime_DoRand = 9.5
ENT.RangeAttackMaxDistance = 300
ENT.RangeAttackMinDistance = 1
ENT.RangeUseAttachmentForPos = true
ENT.RangeUseAttachmentForPosID = "eyes"

ENT.CanFlinch = 1 -- 1 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"Physflinch1","Physflinch2","Physflinch3"} -- If it uses normal based animation, use this

ENT.HitGroupFlinching_DefaultWhenNotHit = true
ENT.HitGroupFlinching_Values = {
{HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_flinch_head","Physflinch1","Physflinch2","Physflinch3"}},
{HitGroup = {HITGROUP_CHEST}, Animation = {"vjges_flinch_chest","Physflinch1","Physflinch2","Physflinch3"}},
{HitGroup = {HITGROUP_LEFTARM}, Animation = {"vjges_flinch_leftArm"}},
{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjges_flinch_rightArm"}},
{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},
{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.GibOnDeathDamagesTable = {"UseDefault"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.CallForHelpDistance = 200 -- -- How far away the SNPC's call for help goes | Counted in World Units
ENT.HasCallForHelpAnimation = true -- if true, it will play the call for help animation
ENT.AnimTbl_CallForHelp = {"Tantrum"} -- Call For Help Animations

ENT.AlertSoundLevel = 100
ENT.DeathSoundLevel = 100

ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking

ENT.SoundTbl_Breath = {"npc/epstein/wander_breath_hiss_01.wav", "npc/epstein/wander_breath_hiss_02.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"npc/barnacle/barnacle_digesting1.wav", "npc/barnacle/barnacle_digesting2.wav"}
ENT.SoundTbl_RangeAttack = {"npc/epstein/final_spew.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/epstein/attack_player.wav"}
ENT.SoundTbl_FootStep = {"npc/zombie/foot_slide1.wav", "npc/zombie/foot_slide2.wav", "npc/zombie/foot_slide3.wav"}
ENT.SoundTbl_Alert = {"npc/epstein/aware_growl_01.wav", "npc/epstein/aware_growl_02.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/epstein/yawn_01.wav", "npc/epstein/yawn_02.wav", "npc/epstein/yawn_03.wav"}
ENT.SoundTbl_Pain = {"npc/epstein/yawn_01.wav", "npc/epstein/yawn_02.wav", "npc/epstein/yawn_03.wav"}
ENT.SoundTbl_Death = {"npc/epstein/yawn_01.wav", "npc/epstein/yawn_02.wav", "npc/epstein/yawn_03.wav"}
ENT.SoundTbl_Idle = {"npc/epstein/relax_grunt_01.wav", "npc/epstein/relax_grunt_02.wav", "npc/epstein/relax_grunt_03.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	dmginfo:ScaleDamage(0.05)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(v, isProp)
	if v:IsPlayer() then
		local pitch = math.random(-100, 100)
		local yaw = math.random(-100, 100)
		v:ViewPunch(Angle(pitch, yaw, 5))
		v:ScreenFade(SCREENFADE.IN,Color(64,0,0),6,0)
	return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	ParticleEffectAttach("vomit_jeff", PATTACH_POINT_FOLLOW, self, 9)
	VJ_EmitSound(self,"ambient/water/water_spray" .. math.random(1, 3) .. ".wav",75,50)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self.AnimTbl_Walk = {ACT_WALK_ON_FIRE}
	self.AnimTbl_Run = {ACT_WALK_ON_FIRE}
	self.AnimTbl_IdleStand = {ACT_IDLE_ON_FIRE}
	util.VJ_SphereDamage(self,self,self:GetPos(),50,1,DMG_NERVEGAS,true,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.2, 1)
		timer.Simple(24, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))

	local randRange = math.random(1, 200)

	if randRange == 1 then 
		ParticleEffectAttach("stinger_spray_gas3", PATTACH_POINT_FOLLOW, self, 8)
	elseif randRange == 2 then 
		ParticleEffectAttach("stinger_spray_gas3", PATTACH_POINT_FOLLOW, self, 9)
	end

	ParticleEffect("jeff_gas",self:GetPos() + self:GetUp()* 25,Angle(0,0,0),nil)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 4) == 1 then
		self:PlayAnim({"breakthrough"}, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanSee(ent)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 50 + self:GetForward() * -10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Curve", projectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 600)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if math.random(1,16) == 1 then
		VJ_EmitSound(self,"npc/antlion/antlion_shoot1.wav",30,100)
		VJ_EmitSound(self,"npc/antlion/antlion_shoot2.wav",30,100)
		VJ_EmitSound(self,"npc/antlion/antlion_shoot3.wav",30,100)
		util.VJ_SphereDamage(self,self,self:GetPos(),200,25,DMG_NERVEGAS,true,true)
		ParticleEffect("blood_impact_zombie_01",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("jeff_juice",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("jeff_slime",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("jeff_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
		ParticleEffect("jeff_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"npc/epstein/final_spew.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),150,43,DMG_NERVEGAS,true,true)
	util.ScreenShake(self:GetPos(),44,1000,2,1000)
	ParticleEffect("jeff_gibs",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
end