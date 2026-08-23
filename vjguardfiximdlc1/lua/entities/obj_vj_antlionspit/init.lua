/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Acid Spit"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/vj_base/projectiles/spit_acid_medium.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true
ENT.DirectDamage = 10	
ENT.DirectDamageType = DMG_ACID
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = {"BeerSplash"}

ENT.AcidDropletSpread = 2
ENT.AcidDropletSeparationSpeed = 1

ENT.IdleSoundPitch = VJ.SET(50,180)
ENT.IdleSoundLevel = 80
ENT.OnCollideSoundPitch = VJ.SET(130, 125)

ENT.SoundTbl_Idle = {"npc/antlion/antlion_poisonball1.wav", "npc/antlion/antlion_poisonball2.wav"}
ENT.SoundTbl_OnCollide = {"npc/antlion/antlion_shoot2.wav", "npc/antlion/antlion_shoot3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetModelScale(math.random(1, 2))
	ParticleEffectAttach("antlion_spit_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())

	self.AcidDroplets = {}

	if self.IsAcidDroplet then return end

	self:CreateDroplet(math.random(0.4, 0.8), Vector(math.random(-32, 32), math.random(-12, 12), math.random(-8, 8)))
	self:CreateDroplet(math.random(0.4, 0.8), Vector(math.random(-32, 32), math.random(-12, 12), math.random(-8, 8)))
	self:CreateDroplet(math.random(0.4, 0.8), Vector(math.random(-32, 32), math.random(-12, 12), math.random(-8, 8)))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDroplet(scale, offset)
	local droplet = ents.Create("base_anim")
	if not IsValid(droplet) then return end

	droplet:SetModel("models/vj_base/projectiles/spit_acid_medium.mdl")
	droplet:SetModelScale(scale, 0)
	droplet:SetPos(self:LocalToWorld(offset))
	droplet:SetAngles(self:GetAngles())
	droplet:Spawn()
	droplet:Activate()
	droplet:SetParent(self)
	droplet:SetLocalPos(offset)
	droplet:SetLocalAngles(Angle(0, 0, 0))

	ParticleEffectAttach("antlion_spit_trail", PATTACH_ABSORIGIN_FOLLOW, droplet, 0)

	if self.SoundTbl_Idle and #self.SoundTbl_Idle > 0 then
		local soundPath = table.Random(self.SoundTbl_Idle)

		droplet.IdleSound = CreateSound(droplet, soundPath)

		if droplet.IdleSound then
			local pitch = math.random(50, 180)
			droplet.IdleSound:PlayEx(1, pitch)
		end
	end

	table.insert(self.AcidDroplets, droplet)

	droplet:CallOnRemove("AcidProjectileRemoved", function(ent)
		if ent.IdleSound then
			ent.IdleSound:Stop()
			ent.IdleSound = nil
		end

		if IsValid(self) then
			for i, v in ipairs(self.AcidDroplets or {}) do
				if v == ent then
					table.remove(self.AcidDroplets, i)
					break
				end
			end
		end
	end)

	droplet:AddCallback("PhysicsCollide", function(ent, data)
		if not IsValid(ent) then return end

		if ent.IdleSound then
			ent.IdleSound:Stop()
			ent.IdleSound = nil
		end

		local hitPos = data.HitPos
		local hitNormal = data.HitNormal

		VJ_EmitSound(ent, self.SoundTbl_OnCollide, self.IdleSoundLevel, math.random(125, 130))

		ParticleEffect("antlion_spit", hitPos, hitNormal:Angle(), nil)

		if self.CollisionDecal and #self.CollisionDecal > 0 then
			util.Decal(table.Random(self.CollisionDecal), hitPos + hitNormal, hitPos - hitNormal)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("antlion_spit", data.HitPos, Angle(0,0,0), nil)
end