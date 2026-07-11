/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Hornet"

ENT.VJ_ID_Danger = true
ENT.PhysicsSolidMask = MASK_SHOT
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		self:SetAngles((LocalPlayer():EyePos() - self:GetPos()):Angle())
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/hl2_hornet.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 6
ENT.DirectDamageType = DMG_SLASH
ENT.CollisionBehavior = VJ.PROJ_COLLISION_PERSIST
ENT.SoundTbl_OnCollide = {"npc/alien_grunt/ag_hornethit1.wav", "npc/alien_grunt/ag_hornethit2.wav", "npc/alien_grunt/ag_hornethit3.wav"}
ENT.CollisionDecal = "YellowBlood"

ENT.IdleSoundPitch = VJ.SET(100, 100)

local sdIdle = {"npc/alien_grunt/ag_buzz1.wav", "npc/alien_grunt/ag_buzz2.wav", "npc/alien_grunt/ag_buzz3.wav"}

local defVec = Vector(0, 0, 0)

local HORNET_TYPE_RED = 0
local HORNET_TYPE_ORANGE = 1

-- Custom
ENT.Track_Ent = NULL
ENT.Track_Position = defVec
local defAng = Angle(0, 0, 0)

ENT.Hor_Exp = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSkin(math.random(0, 1))
	self.Hor_Lifetime = CurTime() + math.Rand(4, 12)
self.Hor_NoiseSeed = math.Rand(0, 100)
self.Hor_NoiseTime = CurTime()
	util.SpriteTrail(self, 1, Color(255, math.random(2, 160), 0, 64), true, 12, 0, 0.5, 0.1, "sprites/smoke.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if !self.Hor_Exp && CurTime() > self.Hor_Lifetime then
		self.Hor_Exp = true
		self.HasDeathSounds = false
		self:Destroy(data, phys)
		self:SetGroundEntity(NULL)
		ParticleEffect("blood_impact_yellow_01", self:GetPos(), defAng)
		VJ.EmitSound(self, self.SoundTbl_OnCollide)
	end

	ParticleEffectAttach("jeff_trails",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("jeff_trails", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	local trackedEnt = self.Track_Ent
	if IsValid(trackedEnt) then -- Homing Behavior
		local pos = trackedEnt:GetPos() + trackedEnt:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			local targetVel = VJ.CalculateTrajectory(self, trackedEnt, "Line", self:GetPos(), self.Track_Position + VectorRand(-75, 75), 600)
			local currentVel = phys:GetVelocity()
			local smoothVel = LerpVector(FrameTime() * 30, currentVel, targetVel)

			phys:SetVelocity(smoothVel)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	ParticleEffect("jeff_gas_small",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("jeff_slime_small",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	local lastVel = math.max(data.OurOldVelocity:Length(), data.Speed) -- Get the last velocity and speed
	local newVel = phys:GetVelocity():GetNormal()
	lastVel = math.max(newVel:Length(), lastVel)
	phys:SetVelocity(newVel * lastVel * 0.3)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
	
	self:Remove()
end