AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
self:SetModel("models/misc/cube025x025x025.mdl")

	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	self:SetTrigger(true)
	self:SetNoDraw(true)
	self.TeleportCooldowns = {}

	self.DynamicLight = ents.Create("light_dynamic")

	if IsValid(self.DynamicLight) then
		self.DynamicLight:SetKeyValue("brightness", "0")
		self.DynamicLight:SetKeyValue("distance", "256")
		self.DynamicLight:SetLocalPos(self:GetPos())
		self.DynamicLight:SetLocalAngles(Angle(0, 0, 0))
		self.DynamicLight:Fire("Color", "8 255 0")
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Spawn()
		self.DynamicLight:Activate()
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.DynamicLight)
	end

	self.GlowSprite = ents.Create("env_sprite")

	if IsValid(self.GlowSprite) then
		self.GlowSprite:SetKeyValue("model", "sprites/hl1/exit1.vmt")
		self.GlowSprite:SetKeyValue("GlowProxySize", "1")
		self.GlowSprite:SetKeyValue("renderfx", "14")
		self.GlowSprite:SetKeyValue("scale", "0.6")
		self.GlowSprite:SetKeyValue("framerate", "30")
		self.GlowSprite:SetKeyValue("rendermode", "7")
		self.GlowSprite:SetKeyValue("disablereceiveshadows", "0")
		self.GlowSprite:SetKeyValue("spawnflags", "0")
		self.GlowSprite:SetParent(self)
		self.GlowSprite:SetLocalPos(Vector(0, 0, 0))
		self.GlowSprite:SetLocalAngles(Angle(0, 0, 0))
		self.GlowSprite:Spawn()
		self.GlowSprite:Activate()
		self:DeleteOnRemove(self.GlowSprite)
	end
end