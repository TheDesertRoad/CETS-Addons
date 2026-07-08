AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_flamercomb_soldier.mdl"}
ENT.StartHealth = 150
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 4
ENT.Weapon_MinDistance = 20 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 250 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 30
ENT.Weapon_CanCrouchAttack = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Immune_Toxic = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.HasMeleeAttack = true -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity
ENT.AnimTbl_MeleeAttack = "flinchsmall"
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 200 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 300 -- How far it will push you forward | Second in math.random
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.NextMeleeAttackTime = 1 -- How much time until it can use a melee attack?
ENT.MeleeAttackDamage = -1
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 40 -- How far does the damage go?

ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?

ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
}

ENT.Comb_CanFlame = false
ENT.Comb_FlameLevel = 0 -- 0 = Not started | 1 = Preparing | 2 = Flame active
ENT.Comb_NextFlameT = 0

ENT.SoundTbl_MeleeAttackExtra = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.TimersToRemove[#self.TimersToRemove + 1] = "Comb_flame_reset"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_flamethrower")
	self:SetBodygroup( 2, math.random( 0, 3 ) )
	if game.GetGlobalState("gordon_precriminal") == 1 then 
		self.Behavior = VJ_BEHAVIOR_NEUTRAL
		self.IdleAlwaysWander = true
		self.EnemyTouchDetection = true
		self.BecomeEnemyToPlayer = true
		self.AlliedWithPlayerAllies = true
		self.CanReceiveOrders = false
		self.FollowPlayer = false
		self.YieldToAlliedPlayers = false
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
	end

	self.gascan = ents.Create("obj_vj_cets_gascan_x2_flamer")
	self.gascan:SetPos( self:GetPos() + self:GetForward() * -6 + self:GetUp() * 60 )
	self.gascan:SetAngles( self:GetAngles() + Angle(0,0,0) )
	self.gascan:SetOwner(self)
	self.gascan:SetParent(self, self:LookupAttachment( "zipline" ))
	self.gascan:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.gascan:Spawn()
	self.gascan:Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute()
	local rangegas = 120
	local muzz = self:GetActiveWeapon("weapon_vj_cets_flamethrower")

	self:StopSound("weapons/flamethrow/flame_thrower_start.wav")
	self:StopSound("weapons/flamethrow/flame_thrower_loop.wav")
	VJ_EmitSound(self, "weapons/flamethrow/flame_thrower_end.wav", 80)

	self.MovementType = VJ_MOVETYPE_STATIONARY
	self.Behavior = VJ_BEHAVIOR_PASSIVE
	self:Comb_ResetFlame()
	self.Comb_CanFlame = false
	self.Comb_FlameLevel = 0

	VJ.ApplyRadiusDamage(self, self, self:GetPos(), rangegas, 22, DMG_PLASMA, true, true, {UseConeDegree = 46, Force = 128, DisableVisibilityCheck = true}, function(ent) if !ent:IsOnFire() && (ent:IsPlayer() or ent:IsNPC()) then ent:Extinguish() end end)
	VJ.EmitSound(self, "weapons/flamethrow/flame_thrower_airblast.wav", 80)
	self:StopParticles()
	ParticleEffectAttach("flamer_at2", PATTACH_POINT_FOLLOW, muzz, 1)

	timer.Simple(0.3,function() if IsValid(self) then
			self.MovementType = VJ_MOVETYPE_GROUND
			self.Behavior = VJ_BEHAVIOR_AGRESSIVE

		end 
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local muzz = self:GetActiveWeapon("weapon_vj_cets_flamethrower")

	if self:IsOnFire() && CurTime() > self.NextDance then
		self.Bleeds = false
		timer.Simple(self:SequenceDuration(self:LookupSequence( "bugbait_hit" )), function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
		self:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
		self.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))
		self:Comb_ResetFlame()
		self.Comb_CanFlame = false
		self.Comb_FlameLevel = 0
		self:StopSound("weapons/flamethrow/flame_thrower_start.wav")
		self:StopSound("weapons/flamethrow/flame_thrower_loop.wav")
	end

	if self.Comb_CanFlame && self.Comb_NextFlameT < CurTime() && self.AttackType == VJ.ATTACK_TYPE_NONE then
		if self.Comb_FlameLevel == 0 then
			VJ.EmitSound(self, "weapons/flamethrow/flame_thrower_start.wav", 80)
		end
		
		self.Comb_FlameLevel = 2

		local range = 280
		VJ.ApplyRadiusDamage(self, self, self:GetPos(), range, 2, DMG_BURN, true, true, {UseConeDegree = 46}, function(ent) if !ent:IsOnFire() && (ent:IsPlayer() or ent:IsNPC()) then ent:Ignite(5) end end)

		self.Comb_FlameSd = VJ.CreateSound(self, "weapons/flamethrow/flame_thrower_loop.wav", 80)
		self:StopParticles()
		ParticleEffectAttach("flamer_at1", PATTACH_POINT_FOLLOW, muzz, 1) 

		local startPos1 = muzz:GetAttachment(1).Pos
		local tr1 = util.TraceLine({start = startPos1, endpos = startPos1 + self:GetForward()*range, filter = self})
		local hitPos1 = tr1.HitPos
		sound.EmitHint(SOUND_DANGER, (hitPos1 + startPos1) / 2, 300, 1, self) -- Pos: Midpoint of start and hit pos, same as Vector((hitPos1.x + startPos1.x ) / 2, (hitPos1.y + startPos1.y ) / 2, (hitPos1.z + startPos1.z ) / 2)

		//local glowFX = ents.Create("light_dynamic")
		//glowFX:SetKeyValue("brightness", "4")
		//glowFX:SetKeyValue("distance", "125")
		//glowFX:SetLocalPos(self:GetPos() + self:GetUp()*50 + self:GetRight()*10 + self:GetForward()*40)
		//glowFX:SetLocalAngles(self:GetAngles())
		//glowFX:Fire("Color", "255 128 32")
		//glowFX:SetParent(self, muzz)
		//glowFX:Spawn()
		//glowFX:Activate(timer.Simple(0.1, function() if IsValid(glowFX) then glowFX:Remove() end end))
		//glowFX:Fire("TurnOn", "", 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_BeforeMeleeAttack, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Pain, sdFile) then return end
	if VJ.HasValue("weapons/flamethrow/flame_thrower_loop.wav", sdFile) then return end
	VJ.EmitSound(self, "npc/combine_soldier/vo/on" .. math.random(1, 2) .. ".wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self, "npc/combine_soldier/vo/off" .. math.random(1, 3) .. ".wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(isAttacking, enemy)
	local eneData = self.EnemyData
	local eneVisible = eneData.Visible
	local range = 250
	if self.VJ_IsBeingControlled then
		range = 250
		eneVisible = true -- Skip enemy visibility check when being controlled!
		if !self.VJ_TheController:KeyDown(IN_ATTACK2) then -- Do flame attack only when player is holding down right click
			self:Comb_ResetFlame()
			return
		end
	end

	if eneVisible && self.AttackType == VJ.ATTACK_TYPE_NONE && eneData.DistanceNearest <= range && eneData.DistanceNearest > self.MeleeAttackDistance then
		self.Comb_CanFlame = true
		self:SetTurnTarget(enemy, -1)
		-- Make it constantly delay the range attack timer by 1 second (Which will also successfully play the flame-end sound)
		timer.Create("Comb_flame_reset" .. self:EntIndex(), 1, 0, function()
			self:Comb_ResetFlame()
		end)
	else
		self:Comb_ResetFlame()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Comb_ResetFlame()
	if self.Comb_CanFlame then
		self:ResetTurnTarget()
	end
	if self.Comb_FlameLevel == 2 then
		VJ.EmitSound(self, "weapons/flamethrow/flame_thrower_end.wav", 80)
	end

	self.Comb_CanFlame = false
	self.Comb_FlameLevel = 0
	self.DisableChasingEnemy = false
	self:StopSound("weapons/flamethrow/flame_thrower_start.wav")
	self:StopSound("weapons/flamethrow/flame_thrower_loop.wav")
	self:StopParticles()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	self:CreateGibEntity("physics_prop", "models/weapons/w_flamethrower.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ammo = ents.Create("item_ammo_ar2")
		ammo:SetPos(att.Pos)
		ammo:SetAngles(att.Ang)
		ammo:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:StopSound("weapons/flamethrow/flame_thrower_start.wav")
	self:StopSound("weapons/flamethrow/flame_thrower_loop.wav")
end