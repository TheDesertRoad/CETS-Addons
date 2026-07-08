/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Explosive Gascan"
ENT.Author 			= "DrVrej"

ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.Active		= false

local PartEffGasLeak = "gascan_gasleak2"
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
function ENT:Initialize()
	self:SetModel("models/misc/cube025x05x025.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetNoDraw( true )
	self:DrawShadow( false )
	self.PhysgunDisabled = false
		
	local phys = self:GetPhysicsObject()	
		if (phys:IsValid()) then
			phys:Wake()
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local npc = self:GetParent()
	local DamageAttacker = dmginfo:GetAttacker()

	if !self.Active then
		if dmginfo:IsDamageType( DMG_BULLET ) or dmginfo:IsDamageType( DMG_CLUB ) or dmginfo:IsDamageType( DMG_SNIPER ) or dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_BUCKSHOT ) then
			self.Active = true

		if self:WaterLevel() > 1 then 
			ParticleEffectAttach("gascan_gasleak3",PATTACH_ABSORIGIN_FOLLOW,self,0)
		else
			ParticleEffectAttach("fire_small_02",PATTACH_ABSORIGIN_FOLLOW,self,0)
			ParticleEffectAttach(PartEffGasLeak,PATTACH_ABSORIGIN_FOLLOW,self,0)

			npc.FireLight1 = ents.Create("light_dynamic")
			npc.FireLight1:SetKeyValue("brightness", "0.5")
			npc.FireLight1:SetKeyValue("distance", "128")
			npc.FireLight1:SetLocalPos(npc:GetPos() + npc:GetUp() * 56)
			npc.FireLight1:SetLocalAngles( npc:GetAngles())
			npc.FireLight1:Fire("Color", "255 128 0")
			npc.FireLight1:SetParent(npc)
			npc.FireLight1:Spawn()
			npc.FireLight1:Activate()
			npc.FireLight1:Fire("TurnOn", "", 0)
		end

			npc:EmitSound("ambient/fire/ignite.wav")
			npc:EmitSound("npc/misc/gas_leak.wav", 90, math.random(90, 110))
				
			if npc:IsNPC() then
					VJ_EmitSound(npc,npc.SoundTbl_Hurt,80,100)
										
					npc.MovementType = VJ_MOVETYPE_STATIONARY

					npc:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
					npc:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
					npc.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))

					npc.CanTurnWhileStationary = false
					npc.HasMeleeAttack = false
					npc.HasRangeAttack = false
					npc.Behavior = VJ_BEHAVIOR_PASSIVE
					npc.Weapon_Disabled = true
					npc.HasGrenadeAttack = false
					npc.DamageResponse = false
					npc.DamageAllyResponse = false
					npc.CombatDamageResponse = false
					npc.CanDetectDangers = false
					npc.NextProcessTime = 0
					npc.EnemyDetection = false

					timer.Simple(0.1,function() if IsValid(npc) then
						npc:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
						npc:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
						npc.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))
					end end)
				end

				timer.Simple(2.9,function() if IsValid(npc) then
					self:Explode(DamageAttacker)
				end end)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Explode(attacker)
	local defAngle = Angle(0, 0, 0)
	local npc = self:GetParent()
	local own = self:GetOwner()
		
	if !IsValid(npc) then return end
		
	if npc:IsNPC() then
		npc:StopAllCommonSpeechSounds()
	end

	local myPos = self:GetPos()

	if self:WaterLevel() > 1 then 
		VJ.EmitSound(self, "weapons/underwater_explode" .. math.random(3, 4) .. ".wav", 100, 200)
		util.ScreenShake(myPos, 50, 100, 1, 512)

		ParticleEffect("water_gren_test1", self:GetPos(), Angle(0,0,0), nil)
		ParticleEffect("nigga_fire", self:GetPos(), Angle(0,0,0), nil)

		VJ.ApplyRadiusDamage(self, self, myPos, 100, 11, DMG_BURN, true, true, {DisableVisibilityCheck=true, Force=60})
	else
		npc:EmitSound("weapons/fire_explode.wav", 100, math.random(90, 110))
		util.ScreenShake(myPos, 100, 200, 1, 1024)
	
		ParticleEffect("ep2_ExplosionCore", self:GetPos(), Angle(0,0,0), nil)
		ParticleEffect("nigga_fire", self:GetPos(), Angle(0,0,0), nil)

		npc.ExplosionLight1 = ents.Create("light_dynamic")
		npc.ExplosionLight1:SetKeyValue("brightness", "2")
		npc.ExplosionLight1:SetKeyValue("distance", "200")
		npc.ExplosionLight1:SetLocalPos(npc:GetPos())
		npc.ExplosionLight1:SetLocalAngles( npc:GetAngles() )
		npc.ExplosionLight1:Fire("Color", "255 150 0")
		npc.ExplosionLight1:SetParent(npc)
		npc.ExplosionLight1:Spawn()
		npc.ExplosionLight1:Activate()
		npc.ExplosionLight1:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(npc.ExplosionLight1)

		VJ.ApplyRadiusDamage(self, self, myPos, 210, 33, DMG_BURN, true, true, {DisableVisibilityCheck=true, Force=60})
	end
	
	own:Ignite(1)

	npc:StopSound("npc/misc/tank_flame.wav")
	npc:StopSound("ambient/gas/steam2.wav")
		
	if !IsValid(attacker) then
		if IsValid(npc) then
			attacker = npc
		else
			attacker = self
		end
	end
		
	npc:TakeDamage( npc:Health() * 9999, attacker )
		
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
	end
end