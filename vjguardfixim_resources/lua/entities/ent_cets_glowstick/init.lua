AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_cets/stick.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	local flags = self:GetSpawnFlags()

	if bit.band(flags,2) ~= 0 or self:HasSpawnFlags(2) then
		self.GlowColor = Vector(1,0,0)
	elseif bit.band(flags,4) ~= 0 or self:HasSpawnFlags(4) then
		self.GlowColor = Vector(0,1,0)
	elseif bit.band(flags,8) ~= 0 or self:HasSpawnFlags(8) then
		self.GlowColor = Vector(0,0,1)
	elseif bit.band(flags,16) ~= 0 or self:HasSpawnFlags(16) then
		self.GlowColor = Vector(1,1,0)
	elseif bit.band(flags,32) ~= 0 or self:HasSpawnFlags(32) then
		self.GlowColor = Vector(0,1,1)
	elseif bit.band(flags,64) ~= 0 or self:HasSpawnFlags(64) then
		self.GlowColor = Vector(1,0,1)
	elseif bit.band(flags,128) ~= 0 or self:HasSpawnFlags(128) then
		self.GlowColor = Vector(1,1,1)
	end

	local randNumb = math.random(1,7)

	if randNumb == 1 then
	 	self.GlowColor = Vector(1,0,0)
	elseif randNumb == 2 then
		self.GlowColor = Vector(0,1,0)
	elseif randNumb == 3 then
		self.GlowColor = Vector(0,0,1)
	elseif randNumb == 4 then
	 	self.GlowColor = Vector(1,1,0)
	elseif randNumb == 5 then
		self.GlowColor = Vector(0,1,1)
	elseif randNumb == 6 then
		self.GlowColor = Vector(1,0,1)
	elseif randNumb == 7 then
		self.GlowColor = Vector(1,1,1)
	end

	self:SetNWVector("GlowColor", Vector(0,0,0))

	self.Light = ents.Create("light_dynamic")

	if IsValid(self.Light) then
		self.Light:SetPos(self:GetPos()+Vector(0,0,8))
		self.Light:SetParent(self)
		self.Light:SetKeyValue("distance","420")
		self.Light:SetKeyValue("brightness","4")
		self.Light:SetKeyValue("_light", self.GlowColor.x * 255 .. " " .. self.GlowColor.y * 255 .. " " .. self.GlowColor.z * 255)
		self.Light:Spawn()
		self.Light:Fire("TurnOff")
	end

	self.LightActive = false
		self.Used = false
	end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Plastic_Box.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Plastic_Box.ImpactHard" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end
	activator:PickupObject(self)

	if self.Used then return end

	self.Used = true
	self:SetNWVector("GlowColor", self.GlowColor)


	if IsValid(self.Light) then
		self.Light:Fire("TurnOn")
		self.LightActive = true
		VJ_EmitSound(self, "items/glowstick_crack.wav", 90, math.random(90, 110))
	end

	timer.Simple(30,function()
		if not IsValid(self) then return end
		self:SetNWVector("GlowColor",Vector(0,0,0))

		if IsValid(self.Light) then
			self.Light:Fire("TurnOff")
			self.LightActive = false
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if IsValid(self.Light) then
		self.Light:Remove()
	end
end