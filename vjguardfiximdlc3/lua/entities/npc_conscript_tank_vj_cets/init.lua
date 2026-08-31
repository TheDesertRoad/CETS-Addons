AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl_tank_chasis.mdl"
ENT.StartHealth = GetConVar("sk_apc_conscript_health"):GetInt()
ENT.CanChatMessage = false
ENT.VJ_ID_Boss = true
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "APC.Frame", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 50), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self:SetSkin(2)
	self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
	self.AlliedWithPlayerAllies = true
	local flags = self:GetSpawnFlags()

	if bit.band(flags, 64) ~= 0 or self:HasSpawnFlags(64) then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.APC_RunOverDist = 0
		self.APC_MinDriveDist = 0
		self.APC_AccelSpeed = 0
		self.APC_DrivingSpeed = 0
		self.APC_BackPedalSpeed = 0
		self.APC_TurnSpeedMax = 0
	end

	local gunner = ents.Create("npc_hecu_tank_head_vj_cets")
	if IsValid(gunner) then
		gunner:SetPos(self:Tank_GunnerSpawnPosition())
		gunner:SetAngles(self:GetAngles())
		gunner:SetOwner(self)
		gunner:SetParent(self)
		gunner.DoNotDuplicate = true
		gunner.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
		gunner.AlliedWithPlayerAllies = true
		gunner:Spawn()
		gunner:Activate()
		self.Gunner = gunner
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
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt:Remove()
	local myPos = self:GetPos()
	VJ.EmitSound(self, "weapons/explode" .. math.random(3, 4) .. ".wav", 100, 100)

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale( 800 )

	self:SetSkin(5)

	util.Effect( "Explosion", effectdata )
	util.Effect( "Explosion", effectdata )

	local gibphys1 = ents.Create("prop_physics")
		gibphys1:SetPos(self:GetPos() + self:GetUp()*120)
		gibphys1:SetModel("models/hl_tank_chasis.mdl")
		gibphys1:SetAngles(self:GetAngles())
		gibphys1:Ignite(16)
		gibphys1:SetSkin(self:GetSkin())

		CETS.RegisterTankDeathDebris(gibphys1)

		gibphys1:Spawn()
		gibphys1:Activate()

		local phys = gibphys1:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (gibphys1:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * 12

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end

	for i = 1, 6 do
		self.APCGib1 = ents.Create("prop_physics")
		self.APCGib1:SetModel("models/gibs/metal_gib" .. math.random(1, 5) .. ".mdl")
		self.APCGib1:SetPos(myPos)

		CETS.RegisterTankDeathDebris(self.APCGib1)

		self.APCGib1:Ignite(math.random(4, 16))
		self.APCGib1:Spawn()
		CleanupGib(self.APCGib1)

		local phys = self.APCGib1:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib1:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 150, 500) * 12

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	for i = 1, 3 do
		self.APCGib2 = ents.Create("prop_physics")
		self.APCGib2:SetModel("models/props_wasteland/gear01.mdl")
		self.APCGib2:SetPos(myPos)
		self.APCGib2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		CETS.RegisterTankDeathDebris(self.APCGib2)

		self.APCGib2:Ignite(math.random(4, 16))
		self.APCGib2:Spawn()
		CleanupGib(self.APCGib2)

		local phys = self.APCGib2:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib2:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * 12

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	for i = 1, 2 do
		self.APCGib2b = ents.Create("prop_physics")
		self.APCGib2b:SetModel("models/props_c17/oildrumchunk01" .. string.char(math.random(string.byte("a"), string.byte("e"))) .. ".mdl")
		self.APCGib2b:SetPos(myPos)
		self.APCGib2b:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		CETS.RegisterTankDeathDebris(self.APCGib2b)

		self.APCGib2b:Ignite(math.random(4, 16))
		self.APCGib2b:Spawn()
		CleanupGib(self.APCGib2b)


		local phys = self.APCGib2b:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib2b:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * 12

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	for i = 1, 1 do
		self.APCGib3 = ents.Create("prop_physics")
		self.APCGib3:SetModel("models/props_c17/trappropeller_engine.mdl")
		self.APCGib3:SetPos(myPos)
		self.APCGib3:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		CETS.RegisterTankDeathDebris(self.APCGib3)

		self.APCGib3:Ignite(math.random(8, 16))
		self.APCGib3:Spawn()
		CleanupGib(self.APCGib3)

		local phys = self.APCGib3:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib3:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * 12

			phys:SetVelocity(dir * force)
			phys:AddAngleVelocity(VectorRand() * 2000)
		end
	end

	for i = 1, 3 do
		self.APCGib4 = ents.Create("prop_ragdoll")
		self.APCGib4:SetModel("models/humans/conscripts/male_masked.mdl")
		self.APCGib4:SetPos(myPos)
		self.APCGib4:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.APCGib4:Spawn()
		self.APCGib4:Ignite(math.random(8, 16))
		self.APCGib4:SetColor(Color(90, 90, 90, 90))

		CETS.RegisterTankDeathDebris(self.APCGib4)

		local phys = self.APCGib4:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()

			local explosionPos = myPos
			local dir = (self.APCGib4:WorldSpaceCenter() - explosionPos):GetNormalized()
			local force = math.Clamp(DMG_BLAST, 50, 500) * math.random(-256, 256)

			phys:SetVelocity(dir * force * 30)
			phys:AddAngleVelocity(VectorRand() * 8000)
		end
	end
end