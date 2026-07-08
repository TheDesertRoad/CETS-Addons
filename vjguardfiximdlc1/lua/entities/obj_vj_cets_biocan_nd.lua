/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Bloater"
ENT.Author 			= "DrVrej"

ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.Active		= false
ENT.Exploded 		= 0

local PartEffGasLeak = "zomboom1_a"
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
function ENT:Initialize()
	self:SetModel("models/props_cets_aliens/zombie_bloater.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetNoDraw( false )
	self.PhysgunDisabled = false
		
	self:SetCollisionBounds(Vector(60, 24, 24), Vector(-60, -24, 2))
	local phys = self:GetPhysicsObject()	
		if (phys:IsValid()) then
			phys:Wake()
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local npc = self:GetParent()
	local DamageAttacker = dmginfo:GetAttacker()
	
	if self.Exploded == 0 then

	npc:EmitSound("npc/antlion_grub/squashed.wav", 90, 150)

	self:SetSkin(1)
	self.Exploded = 1

	ParticleEffect("zomboom1_c", self:GetPos(), Angle(0,0,0), nil)

	if !self.Active then
		if dmginfo:IsDamageType( DMG_BULLET ) or dmginfo:IsDamageType( DMG_CLUB ) or dmginfo:IsDamageType( DMG_SNIPER ) or dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_BUCKSHOT ) then
			self.Active = true

			npc:EmitSound("npc/stinger/stinger_spray01.wav")

		if self:WaterLevel() > 1 then 
			ParticleEffectAttach("zomboom1_b",PATTACH_ABSORIGIN_FOLLOW,self,0)
		else
			ParticleEffectAttach(PartEffGasLeak,PATTACH_ABSORIGIN_FOLLOW,self,0)
		end

			npc:EmitSound("npc/stinger/stinger_spray01.wav", 90, math.random(90, 110))
				
			if npc:IsNPC() then
				VJ_EmitSound(npc,npc.SoundTbl_Hurt,80,100)					
			end
				
			timer.Simple(1.4,function() if IsValid(npc) then
				self:Explode(DamageAttacker)
			end end)
		end
	end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)

local color1 = Color(255, 255, 225, 16)
local color2 = Color(255, 0, 84, 128)
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
	effects.BeamRingPoint(myPos, 0.6, 12, 128, 12, 0, color2)

	if self:WaterLevel() > 1 then 
		VJ.EmitSound(self, "weapons/underwater_explode" .. math.random(3, 4) .. ".wav", 100, 200)
		util.ScreenShake(myPos, 50, 100, 1, 512)

		ParticleEffect("water_gren_test1", self:GetPos(), Angle(0,0,0), nil)

		VJ.ApplyRadiusDamage(self, self, myPos, 50, 5, DMG_POISON, true, true, {DisableVisibilityCheck=true, Force=60})
	else
		VJ.EmitSound(self, "weapons/explode" .. math.random(3, 5) .. ".wav", 80, math.random(90, 100))
		VJ.EmitSound(self, "hl1/weapons/splauncher_fire.wav", 100, 100)
		VJ.EmitSound(self, "npc/ministrider/flechette_explode" .. math.random(1, 3) .. ".wav", 100, math.random(90, 100))
		util.ScreenShake(myPos, 100, 200, 1, 1024)
	
		ParticleEffect("jeff_blood_b", self:GetPos(), Angle(0,0,0), nil)

		npc.ExplosionLight1 = ents.Create("light_dynamic")
		npc.ExplosionLight1:SetKeyValue("brightness", "2")
		npc.ExplosionLight1:SetKeyValue("distance", "200")
		npc.ExplosionLight1:SetLocalPos(npc:GetPos())
		npc.ExplosionLight1:SetLocalAngles( npc:GetAngles() )
		npc.ExplosionLight1:Fire("Color", "128 0 128")
		npc.ExplosionLight1:SetParent(npc)
		npc.ExplosionLight1:Spawn()
		npc.ExplosionLight1:Activate()
		npc.ExplosionLight1:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(npc.ExplosionLight1)

		VJ.ApplyRadiusDamage(self, self, myPos, 105, 11, DMG_POISON, true, true, {DisableVisibilityCheck=true, Force=60})
	end
		
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
end