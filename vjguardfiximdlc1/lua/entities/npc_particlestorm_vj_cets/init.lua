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

ENT.BreathSoundLevel = 100
ENT.IdleSoundLevel = 100
ENT.AlertSoundLevel = 100
ENT.CombatIdleSoundLevel = 100

ENT.SoundTbl_Breath = {"npc/particle_storm/hover.wav"}
ENT.SoundTbl_Idle = {"npc/particle_storm/lightning.wav"}
ENT.SoundTbl_Alert = {"npc/gargantua/gar_stomp1.wav"}
ENT.SoundTbl_Death = {"npc/particle_storm/dissipate.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize ()
	self:SetSpawnEffect(true)
	self:SetNoDraw(true)
	self:SetNotSolid(false)
	self:SetCollisionBounds(Vector(1, 1, 1), Vector(0, 0, 0))

	VJ.EmitSound(self, "npc/particle_storm/form.wav", 100)

	ParticleEffectAttach("particle_storm_fx",PATTACH_POINT_FOLLOW,self,0)

	self.DynamicLight = ents.Create("light_dynamic")
	self.DynamicLight:SetKeyValue("brightness", "3")
	self.DynamicLight:SetKeyValue("distance", "360")
	self.DynamicLight:SetLocalPos(self:GetPos())
	self.DynamicLight:SetLocalAngles(self:GetAngles())
	self.DynamicLight:Fire("Color", "0 255 0")
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Spawn()
	self.DynamicLight:Activate()
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Fire("SetParentAttachment", "0", 0)
	self.DynamicLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.DynamicLight)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:AddFlags(FL_NOTARGET)
	self:RemoveFlags(FL_AIMTARGET)
	util.VJ_SphereDamage(self,self,self:GetPos(),166,2,DMG_RADIATION,true,true)
	util.VJ_SphereDamage(self,self,self:GetPos(),32,50,DMG_SHOCK,true,true)
	util.VJ_SphereDamage(self,self,self:GetPos(),16,150,DMG_SHOCK,true,true)
	util.VJ_SphereDamage(self,self,self:GetPos(),1,2000,DMG_ENERGYBEAM,true,true)
	if self:WaterLevel() > 2 then
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.SightDistance = 1 
		self.CallForHelp = false
		self:VJ_TASK_IDLE_STAND("TASK_IDLE_STAND")
		self:SetVelocity(Vector(0,0,1))
		self.Bleeds = false
		self.DisableChasingEnemy = true
		self.HasLeapAttack = false
		self:TakeDamage(500)
		self.GodMode = false
		self:SetGravity(0)
		self:SetGravity(1)
	end

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