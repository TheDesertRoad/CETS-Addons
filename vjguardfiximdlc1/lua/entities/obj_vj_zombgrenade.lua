/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Grenade"
ENT.Category		= "Combified Zombie"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.VJ_IsDetectableGrenade = true
ENT.VJ_IsPickupableDanger = true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/weapons/w_npcnade.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = nil -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.CollisionGroupType = nil -- Collision type, recommended to keep it as it is
ENT.SolidType = SOLID_VPHYSICS -- Solid type, recommended to keep it as it is
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 150 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 55 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 60 -- Put the force amount it should apply | false = Don't apply any force
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.BlastDamage = 150
ENT.BlastRadius = 300
-- Custom
ENT.FussTime = 1201002103
ENT.TimeSinceSpawn = 0
ENT.Team = 1 -- 1 = Combine, 2 = Rebel
ENT.CanChange = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
self.redGlow = ents.Create("env_sprite")
	self.redGlow:SetKeyValue("model", "vj_base/sprites/vj_glow1.vmt")
	self.redGlow:SetKeyValue("scale", "0.07")
	self.redGlow:SetKeyValue("rendermode", "5")
	self.redGlow:SetKeyValue("rendercolor", "150 0 0")
	self.redGlow:SetKeyValue("spawnflags", "1") -- If animated
	self.redGlow:SetParent(self)
	self.redGlow:Fire("SetParentAttachment", "fuse", 0)
	self.redGlow:Spawn()
	self.redGlow:Activate()
	self:DeleteOnRemove(self.redGlow)
	self.Trail = util.SpriteTrail(self, 1, Color(200,0,0), true, 15, 15, 0.35, 1/(6+6)*0.5, "VJ_Base/sprites/vj_trial1.vmt")
	//if self:GetOwner():IsValid() && (self:GetOwner().GrenadeAttackFussTime) then
	//timer.Simple(self:GetOwner().GrenadeAttackFussTime,function() if IsValid(self) then self:DeathEffects() end end) else
	timer.Simple(self.FussTime,function() if IsValid(self) then self:DoDeath() end end)
	//end
	VJ_EmitSound(self,"weapons/grenade/tick1.wav",350,400)
	timer.Simple( 1, function()
	if IsValid(self) then
	VJ_EmitSound(self,"weapons/grenade/tick1.wav",350,400)
	timer.Simple( 1, function()
	if IsValid(self) then
	VJ_EmitSound(self,"weapons/grenade/tick1.wav",350,400)
	timer.Simple( 1, function()
	if IsValid(self) then
	VJ_EmitSound(self,"weapons/grenade/tick1.wav",350,400)
	timer.Simple( 0.3, function()
	if IsValid(self) then
	VJ_EmitSound(self,"weapons/grenade/tick1.wav",350,400)
	timer.Simple( 0.3, function()
	if IsValid(self) then
	VJ_EmitSound(self,"weapons/grenade/tick1.wav",350,400)
	timer.Simple( 0.3, function()
	if IsValid(self) then
	VJ_EmitSound(self,"weapons/grenade/tick1.wav",350,400)
	timer.Simple( 0.1, function()
	if IsValid(self) then
	self:DeathEffects()
end end)
end end)
end end)
end end)
end end)
end end)
end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.TimeSinceSpawn = self.TimeSinceSpawn + 0.2
	if self.Team == 2 && self.CanChange == true then
	self.Trail:Remove()
	self.Trail = util.SpriteTrail(self, 1, Color(150, 100, 0), true, 15, 15, 0.35, 1/(6+6)*0.5, "VJ_Base/sprites/vj_trial1.vmt")
	self.CanChange = false
	self.redGlow:SetKeyValue("rendercolor", "150 100 0")
	end
	if !IsValid(self:GetOwner()) then
		self:SetOwner(game:GetWorld())
		end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage(dmginfo)
	if IsValid(self:GetPhysicsObject()) then
		self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data, phys)
	local getVel = phys:GetVelocity()
	local curVelSpeed = getVel:Length()
	//print(curVelSpeed)
	if curVelSpeed > 500 then -- Or else it will go flying!
		phys:SetVelocity(getVel * 0.9)
	end
	
	if curVelSpeed > 100 then -- If the grenade is going faster than 100, then play the touch sound
		self:OnCollideSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
--
function ENT:DeathEffects()
local explosion = {"weapons/explode3.wav","weapons/explode4.wav","weapons/explode5.wav"}
	local selfPos = self:GetPos()	
	ParticleEffect("explo_grenade", self:GetPos(), defAngle, nil)
	ParticleEffect("explo_rpg", self:GetPos(), defAngle, nil)
	VJ_EmitSound(self,explosion, 150)
local bloodeffect = ents.Create("env_explosion")
		bloodeffect:AddFlags(64)-- 4 256 8
		bloodeffect:AddFlags(4)
		bloodeffect:AddFlags(256)
		bloodeffect:AddFlags(8)
		bloodeffect:Fire( "Explode", 0, 0 )
		bloodeffect:SetPos(self:GetPos(1))
		bloodeffect:Spawn()
		bloodeffect:Activate()
		bloodeffect:SetOwner(game:GetWorld())
		util.BlastDamage(self:GetOwner(), self:GetOwner(), self:GetPos(), self.BlastRadius, self.BlastDamage)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(plyUse)
		plyUse:PickupObject( self )
		self.FussTime = CurTime() + math.Rand(0.5, 1)
end