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

local PartEffGasLeak = "blood_spurt_synth_01"
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/misc/cube2x6x1.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetNoDraw( true )
		self:DrawShadow( false )
		self.PhysgunDisabled = false
		
		local phys = self:GetPhysicsObject()	
			if (phys:IsValid()) then
				phys:Wake()
				phys:SetMaterial("gmod_silent")
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	if dmginfo:IsDamageType(DMG_BLAST) then
		if not IsValid(self) then return end
		self:Explode()
	end

	if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SNIPER) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
			local hitPos = dmginfo:GetDamagePosition()

			if hitPos == vector_origin then
				hitPos = self:GetPos()
			end

			if self:WaterLevel() > 1 then
				ParticleEffect("gascan_gasleak3", hitPos, Angle(0,0,0), self)
			else
				ParticleEffect("fire_small_02", hitPos, Angle(0,0,0), self)
				ParticleEffect(PartEffGasLeak, hitPos, Angle(0,0,0), self)
			end

			if not  self.Active then 
				self.Active = true

				self:EmitSound("ambient/fire/ignite.wav")
				self:EmitSound("npc/misc/gas_leak.wav", 90, math.random(90, 110))

				timer.Simple(4, function()
					if not IsValid(self) then return end
					self:Explode()
				end)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function CleanupGib(ent)
	if not IsValid(ent) then return end

	local lifetime = math.Rand(10, 30)

	timer.Simple(lifetime - 1, function()
		if IsValid(ent) then
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetRenderFX(kRenderFxFadeFast) -- or kRenderFxFadeSlow
		end
	end)

	timer.Simple(lifetime, function()
		if IsValid(ent) then
			ent:Remove()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Explode()
	local myPos = self:GetPos()
	local parent = self:GetParent()

	util.Decal("BigScorch", myPos + Vector(0,0,10), myPos - Vector(0,0,100))

	if IsValid(parent) then
		parent:EmitSound("ambient/explosions/explode_2.wav", 100, math.random(90,110))
	end

	util.ScreenShake(myPos, 100, 200, 1, 1024)

	ParticleEffect("building_explosion", myPos, Angle(0,0,0), nil)
	ParticleEffect("cets_explosion_huge_b", myPos, Angle(0,0,0), nil)
	ParticleEffect("explosion_huge_d", myPos, Angle(0,0,0), nil)
	ParticleEffect("explosion_huge_c", myPos, Angle(0,0,0), nil)
	ParticleEffect("explosion_huge_f", myPos, Angle(0,0,0), nil)
	ParticleEffect("explosion_huge_g", myPos, Angle(0,0,0), nil)
	ParticleEffect("explosion_huge_h", myPos, Angle(0,0,0), nil)

	if IsValid(self.LinkedVehicle) then
		self.LinkedVehicle:Remove()
	elseif IsValid(parent) and parent:GetClass() == "prop_vehicle_jeep" then
		parent:Remove()
	end

	timer.Simple(0.1, function()
		for _, ent in ipairs(ents.FindInSphere(myPos, 720)) do
			if not IsValid(ent) then continue end
			if not SERVER then return end

			if IsValid(ent) and ent ~= self then
				local dmg = DamageInfo()
				dmg:SetAttacker(ent)
				dmg:SetInflictor(ent)
				dmg:SetDamage(800)
				dmg:SetDamageType(bit.bor(DMG_BLAST, DMG_BURN)) -- Change to any damage type you want
				dmg:SetDamagePosition(myPos)
				ent:TakeDamageInfo(dmg)
			end
		end
	end)

	for i = 1, 2 do
		self.APCGib1 = ents.Create("prop_physics")
		self.APCGib1:SetModel("models/props_wasteland/gear01.mdl")
		self.APCGib1:SetPos(myPos + self:GetUp() * 128)
		self.APCGib1:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.APCGib1:Ignite(math.random(4, 16))
		self.APCGib1:Spawn()
		CleanupGib(self.APCGib1)

		local phys = self.APCGib1:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib1:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * math.random(-64, 64)


			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	for i = 1, 2 do
		self.APCGib2 = ents.Create("prop_physics")
		self.APCGib2:SetModel("models/props_vehicles/tire001b_truck.mdl")
		self.APCGib2:SetPos(myPos + self:GetUp() * 128)
		self.APCGib2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.APCGib2:Ignite(math.random(4, 16))
		self.APCGib2:Spawn()
		CleanupGib(self.APCGib2)

		local phys = self.APCGib2:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib2:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * math.random(-64, 64)

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	for i = 1, 8 do
		self.APCGib2b = ents.Create("prop_physics")
		self.APCGib2b:SetModel("models/props_c17/oildrumchunk01" .. string.char(math.random(string.byte("a"), string.byte("e"))) .. ".mdl")
		self.APCGib2b:SetPos(myPos + self:GetUp() * 128)
		self.APCGib2b:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.APCGib2b:Ignite(math.random(4, 16))
		self.APCGib2b:Spawn()
		CleanupGib(self.APCGib2b)

		local phys = self.APCGib2b:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib2b:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * math.random(-64, 64)

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	for i = 0, 1 do
		self.APCGib3 = ents.Create("prop_physics")
		self.APCGib3:SetModel("models/props_c17/trappropeller_engine.mdl")
		self.APCGib3:SetPos(myPos + self:GetUp() * 128)
		self.APCGib3:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.APCGib3:Ignite(math.random(8, 16))
		self.APCGib3:Spawn()
		CleanupGib(self.APCGib3)

		local phys = self.APCGib3:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib3:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * math.random(-64, 64)

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
	end
end