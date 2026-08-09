AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.TeleportSounds = {
	"hl1/debris/beamstart8.wav"
}

ENT.TeleportSoundCooldown = 0.1

ENT.TeleportCooldown = 1
ENT.TeleportPositionOffset = Vector(0, 0, 12)
ENT.TeleportOffset = Vector(24, 0, 0)
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
		self.DynamicLight:Fire("Color", "255 128 0")
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Spawn()
		self.DynamicLight:Activate()
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.DynamicLight)
	end

	self.GlowSprite = ents.Create("env_sprite")

	if IsValid(self.GlowSprite) then
		self.GlowSprite:SetKeyValue("model", "sprites/hl1/enter1.vmt")
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetPortalName()
	local name = self:GetName()

	if not isstring(name) then
		return ""
	end

	return string.Trim(name)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetPortalClasses()
	return {
		"ent_cets_xen_portal1",
		"ent_cets_xen_portal2",
	}
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindNamedPortals()
	local portalName = self:GetPortalName()

	if portalName == "" then
		return {}
	end

	local matches = {}

	for _, className in ipairs(self:GetPortalClasses()) do
		for _, portal in ipairs(ents.FindByClass(className)) do
			if IsValid(portal) and portal ~= self then
				local otherName = portal:GetName()

				if isstring(otherName) then
					otherName = string.Trim(otherName)
				else
					otherName = ""
				end

				if otherName == portalName then
					table.insert(matches, portal)
				end
			end
		end
	end

	return matches
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindNamedDestination()
	local matches = self:FindNamedPortals()

	if #matches == 0 then
		return nil
	end

	return matches[math.random(1, #matches)]
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindRandomDestination()
	local destinations = {}

	for _, className in ipairs(self:GetPortalClasses()) do
		for _, portal in ipairs(ents.FindByClass(className)) do
			if IsValid(portal) and portal ~= self then
				local portalName = portal:GetName()

				if not isstring(portalName) then
					portalName = ""
				end

				portalName = string.Trim(portalName)

				if portalName == "" then
					table.insert(destinations, portal)
				end
			end
		end
	end

	if #destinations == 0 then
		return nil
	end

	return destinations[math.random(1, #destinations)]
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindDestination()
	local portalName = self:GetPortalName()

	if portalName ~= "" then
		return self:FindNamedDestination()
	end

	return self:FindRandomDestination()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TeleportEntity(ent, destination)
	if not IsValid(ent) then
		return false
	end

	if not IsValid(destination) then
		return false
	end

	if ent == self then
		return false
	end

	if ent:IsWorld() then
		return false
	end

	local velocity = ent:GetVelocity()

	local phys = ent:GetPhysicsObject()

	if IsValid(phys) then
		velocity = phys:GetVelocity()
	end

	local entAngles = ent:GetAngles()

	if ent:IsPlayer() then
		entAngles = ent:EyeAngles()
	end

	local directionOffset = entAngles:Forward() * self.TeleportOffset.x + entAngles:Right() * self.TeleportOffset.y + entAngles:Up() * self.TeleportOffset.z
	local positionOffset = destination:LocalToWorld( self.TeleportPositionOffset) - destination:GetPos()
	local destinationPos = destination:GetPos() + positionOffset + directionOffset

	ent:SetPos(destinationPos)

	local now = CurTime()

	if not ent.TeleportSoundCooldown or ent.TeleportSoundCooldown <= now then
		ent.TeleportSoundCooldown = now + self.TeleportSoundCooldown

		if #self.TeleportSounds > 0 then
			ent:EmitSound(self.TeleportSounds[math.random(1, #self.TeleportSounds)], 90, 100)
		end
	end

	if self.TeleportParticle ~= "" then
		timer.Simple(1, function()
			if not IsValid(ent) then
				return
			end

			ent:StopParticles()
		end)
	end

	if ent:IsPlayer() then
		local eyeAngles = ent:EyeAngles()

		ent:SetEyeAngles(Angle(eyeAngles.p, destination:GetAngles().y, eyeAngles.r))

		local fadeColor

		if self:GetName() ~= "" then
			fadeColor = Color(0, 255, 0, 255)
		else
			fadeColor = Color(255, 128, 0, 255)
		end

		ent:ScreenFade(SCREENFADE.IN, fadeColor, 0.5, 0)
	end

	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(velocity)
	else
		ent:SetVelocity(velocity)
	end

	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTouch(ent)
	if not IsValid(ent) then
		return
	end

	if ent == self then
		return
	end

	if ent:IsWorld() then
		return
	end

	if self.TeleportCooldowns[ent] then
		if self.TeleportCooldowns[ent] > CurTime() then
			return
		end

		self.TeleportCooldowns[ent] = nil
	end

	local destination = self:FindDestination()

	if not IsValid(destination) then
		return
	end

	self.TeleportCooldowns[ent] = CurTime() + self.TeleportCooldown

	destination.TeleportCooldowns = destination.TeleportCooldowns or {}
	destination.TeleportCooldowns[ent] = CurTime() + self.TeleportCooldown

	self:TeleportEntity(ent, destination)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(ent)
	self:StartTouch(ent)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	for ent, time in pairs(self.TeleportCooldowns) do
		if not IsValid(ent) or time <= CurTime() then
			self.TeleportCooldowns[ent] = nil
		end
	end

	self:NextThink(CurTime())

	return true
end