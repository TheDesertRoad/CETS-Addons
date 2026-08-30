AddCSLuaFile()
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_grenade"
ENT.PrintName		= "Extractor"
ENT.Author 			= ""
ENT.Spawnable = false

ENT.Model = {"models/healthvial.mdl"}

ENT.SoundTbl_OnCollide = {"physics/metal/metal_grenade_impact_hard1.wav", "physics/metal/metal_grenade_impact_hard2.wav", "physics/metal/metal_grenade_impact_hard3.wav"}

ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 65
ENT.CollisionDecal = "BeerSplash"

ENT.RadiusDamageRadius = 320 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 75 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageType = DMG_ACID

ENT.VJ_ID_Grabbable = true
ENT.AcidCount = 8

ENT.HealRadius = 320
ENT.HealAmount = 75
ENT.HealMaxHealth = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.StartTime = CurTime()
	self.NextBlip = CurTime()

	local pos = self:GetPos()
	local pitch = math.random(60, 70)
	local function beepSound(time, snd)
		timer.Simple(time, function()
			sound.Play(snd, pos, 80, pitch)
		end)
	end

	beepSound(0, "weapons/grenade/timebomb1.wav")
	beepSound(1.0, "weapons/grenade/timebomb1.wav")
	beepSound(1.9, "weapons/grenade/timebomb2.wav")

	hook.Add("GravGunOnPickedUp", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	hook.Add("OnPlayerPhysicsPickup", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	hook.Add("OnPhysgunPickup", self, function(_, ply, ent)
		if ent == self then
			self:SetOwner(ply, ent)
		end
	end)

	util.SpriteTrail(self, 1, Color(166, 250, 137, 255), true, 32, 2, 1.0, 0.1, "effects/laser1")

	timer.Simple(2, function()
		if IsValid(self) then
			self:Destroy()
			self:HealCombineDamageOthers()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(plyUse)
	plyUse:PickupObject( self )
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HealCombineDamageOthers()
	local origin = self:GetPos()
	effects.BeamRingPoint(origin, 1, 30, 1024, 75, 0, Color(166, 250, 137, 32))

	for _, ent in ipairs(ents.FindInSphere(origin, self.HealRadius)) do
		if !IsValid(ent) or ent == self then continue end
		if ent:Health() <= 0 then continue end

		local distance = origin:Distance(ent:GetPos())

		if distance > self.HealRadius then continue end

		local fraction = 1 - (distance / self.HealRadius)
		local amount = math.max(1, self.HealAmount * fraction)

		if ent:IsNPC() && ent.VJ_NPC_Class && VJ.HasValue(ent.VJ_NPC_Class, "CLASS_COMBINE") then
			if self.HealMaxHealth then
				local newHealth = math.min(ent:Health() + amount, ent:GetMaxHealth())
				ent:SetHealth(newHealth)
			else
				ent:SetHealth(ent:Health() + amount)
			end

			-- Green healing effect
			local effect = EffectData()
			effect:SetOrigin(ent:WorldSpaceCenter())
			effect:SetScale(1)
			util.Effect("VJ_HealEffect", effect, true, true)

		else
			local dmg = DamageInfo()

			dmg:SetAttacker(self)
			dmg:SetInflictor(self)
			dmg:SetDamage(amount)
			dmg:SetDamageType(self.RadiusDamageType)
			dmg:SetDamagePosition(ent:WorldSpaceCenter())
			dmg:SetDamageForce((ent:GetPos() - origin):GetNormalized() * 160)

			ent:TakeDamageInfo(dmg)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy()
	local myPos = self:GetPos()

	self:SetLocalPos(myPos + vecZ4) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos - vezZ100,
		filter = self
	})

	if self:WaterLevel() > 1 then 
		local surface = myPos
		local ed = EffectData()
		ed:SetOrigin(myPos)
		util.Effect("WaterSurfaceExplosion", ed, true, true)

		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos + Vector(0,0,32768),
			mask = MASK_WATER
		})

		if tr.Hit then
			local effect = EffectData()
			effect:SetOrigin(tr.HitPos - tr.HitNormal)
			effect:SetNormal(tr.HitNormal)
			util.Effect("WaterSurfaceExplosion", effect)
		end

		VJ.EmitSound(self, "weapons/underwater_explode" .. math.random(3, 4) .. ".wav", 80, 100)
		VJ.EmitSound(self, "weapons/grenade/grenade_acid_fadein.wav", 80, math.random(95, 105))
		ParticleEffect("assassin_projectile_explosion_1", self:GetPos(), Angle(0,0,0))
	else
		VJ.EmitSound(self, "hl1/items/health1.wav", 100, math.random(95, 105))
		VJ.EmitSound(self, "hl1/weapons/sg_explode.wav", 100, math.random(95, 105))
		VJ.EmitSound(self, "hl1/items/medshot4.wav", 50, math.random(70, 80))
		util.ScreenShake(myPos, 60, 70, 1, 4096)
	
		ParticleEffect("antlion_gib_02", self:GetPos(), Angle(0,0,0))

		local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "2")
		expLight:SetKeyValue("distance", "256")
		expLight:SetLocalPos(myPos)
		expLight:SetLocalAngles(self:GetAngles())
		expLight:Fire("Color", "32 100 255")
		expLight:SetParent(self)
		expLight:Spawn()
		expLight:Activate()
		expLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(expLight)

		util.Decal(VJ.PICK(self.CollisionDecal), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
end