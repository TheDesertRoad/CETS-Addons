AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/racex/hl2_pit_drone.mdl"
ENT.VJ_NPC_Class = {"CLASS_NONE"}
ENT.StartHealth = 1000
ENT.SightDistance = 10000
ENT.Sightangle = 360
ENT.TurningSpeed = 9999
ENT.HullType = HULL_LARGE
ENT.TimeUntilEnemyLost = 500000 
ENT.LastSeenEnemyTimeUntilReset = 100000 -- Time until it resets its enemy if its current enemy is not visible
ENT.InvestigateSoundDistance = 100000 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
ENT.CanChatMessage = false
ENT.EnemyXRayDetection = true
ENT.ConstantlyFaceEnemy = true
ENT.IdleAlwaysWander = true
ENT.VJ_ID_Boss = true
ENT.JumpParams = {
	Enabled = true, -- Can it do movement jumps?
	MaxRise = 12, -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = 64, -- How low it can jump down (E -> S)
	MaxDistance = 25, -- Maximum distance between Start and End
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = true
ENT.AllowIgnition = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bleeds = false
ENT.BloodColor = "Green"
ENT.BloodParticle = "blood_impact_antlion_worker_01"
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false
ENT.HasBloodPool = false

ENT.HasDeathCorpse = false

ENT.HasWorldShakeOnMove = true
ENT.CanGib = false

ENT.CanEat = true
ENT.EatCooldown = 5

ENT.CallForHelp = false
ENT.HasMeleeAttack = false

ENT.BreathSoundLevel = 3000
ENT.IdleSoundLevel = 2000
ENT.AlertSoundLevel = 100
ENT.CombatIdleSoundLevel = 100

ENT.BreathSoundPitch = 100

ENT.SoundTbl_Breath = {"ambient/atmosphere/super_storm.wav"}
ENT.SoundTbl_Idle = {"ambient/atmosphere/super_thunder.wav"}
ENT.SoundTbl_Alert = {"npc/gargantua/gar_stomp1.wav"}
ENT.SoundTbl_Death = {"npc/particle_storm/dissipate.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize ()
	self:SetSpawnEffect(true)
	self:SetNoDraw(true)
	self:SetNotSolid(false)
	self:SetCollisionBounds(Vector(1, 1, 1), Vector(0, 0, 0))

	VJ.EmitSound(self, "npc/particle_storm/form.wav", 2000, 70)

	ParticleEffectAttach("particle_storm_fx_super",PATTACH_POINT_FOLLOW,self,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoTornado(radius)
	local center = self:GetPos()
	local maxHeight = 500

	for _, ent in ipairs(ents.FindInSphere(center, radius)) do
		if ent == self or not IsValid(ent) then continue end

		local phys = ent:GetPhysicsObject()
		local isPhys = IsValid(phys)
		local isChar = ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()

		if not (isChar or isPhys) then continue end

		local pos = ent:WorldSpaceCenter()
		local flat = Vector(pos.x - center.x, pos.y - center.y, 0)
		local dist = flat:Length()

		if dist < 8 or dist > radius then continue end

		local strength = 1 - (dist / radius)
		strength = strength * strength

		local relZ = math.max(0, pos.z - center.z)
		local heightFactor = 1 - math.Clamp(relZ / maxHeight, 0, 1)
		local inward = -flat:GetNormalized()
		local tangent = Vector(-inward.y, inward.x, 0)
		local orbitSpeed = 500 + strength * 2048
		local pullSpeed  = 40 + strength * 256
		local liftSpeed  = (30 + strength * 256) * heightFactor
		local vel = ent:GetVelocity()
		local desiredXY = tangent * orbitSpeed + inward * pullSpeed
		local currentXY = Vector(vel.x, vel.y, 0)
		local steer = (desiredXY - currentXY) * 2
		local steer1 = (desiredXY - currentXY) * 20
		local lift = Vector(0, 0, liftSpeed)
		local lift1 = Vector(0, 0, liftSpeed * 20)

		if isChar then
			if ent:IsPlayer() and ent:IsOnGround() then
				ent:SetGroundEntity(NULL)
			end
			ent:SetVelocity(steer)
			ent:SetVelocity(lift)
		else
			phys:Wake()
			phys:ApplyForceCenter((steer + lift) * phys:GetMass())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoTornadoDamage(radius)
	local center = self:GetPos()

	for _, ent in ipairs(ents.FindInSphere(center, radius)) do
		if ent == self or not IsValid(ent) then continue end
		if ent:Health() <= 0 then continue end

		local dist = ent:GetPos():Distance(center)
		local strength = 1 - math.Clamp(dist / radius, 0, 1)
		strength = strength * strength

		local dmg = DamageInfo()
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		dmg:SetDamageType(DMG_BLAST, DMG_ENERGYBEAM)
		dmg:SetDamage(1 + strength * 16)
		dmg:SetDamagePosition(ent:WorldSpaceCenter() - Vector(0,0,512))
		dmg:SetDamageForce(Vector(0,0,100000))

		ent:TakeDamageInfo(dmg)

		if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
			ent:SetVelocity(Vector(0, 0, 150 * strength))
		else
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:ApplyForceCenter(Vector(0, 0, phys:GetMass() * 400 * strength))
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:DoTornado(4096)
	self:DoTornadoDamage(2048)

	if self:IsMoving() then
		self:SetLocalVelocity(self:GetMoveVelocity() * 2)
	end

	self:AddFlags(FL_NOTARGET)
	self:RemoveFlags(FL_AIMTARGET)
	util.VJ_SphereDamage(self,self,self:GetPos(),2048,0.1,DMG_RADIATION,true,true)

	if self:IsOnFire() then
		self.Bleeds = false
		self:TakeDamage(1)
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
	elseif status == "Eat" then
		VJ.EmitSound(self, "ambient/energy/weld" .. math.random(1, 2) .. ".wav", 55)
		-- Health changes
		local food = self.EatingData.Target
		local damage = 100000 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
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
		return 1 -- Eat every this seconds
		end

	return 0
end