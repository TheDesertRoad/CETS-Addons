AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.IdleBeamColor = "255 2 8"
ENT.TouchSoundCooldown = 0.2
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
		self.DynamicLight:Fire("Color", "255 2 8")
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Spawn()
		self.DynamicLight:Activate()
		self.DynamicLight:SetParent(self)
		self.DynamicLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.DynamicLight)
	end

	self.GlowSprite = ents.Create("env_sprite")

	if IsValid(self.GlowSprite) then
		self.GlowSprite:SetKeyValue("model", "sprites/hl1/hotglow.vmt")
		self.GlowSprite:SetKeyValue("GlowProxySize", "1")
		self.GlowSprite:SetKeyValue("renderfx", "14")
		self.GlowSprite:SetKeyValue("scale", "1")
		self.GlowSprite:SetKeyValue("framerate", "15")
		self.GlowSprite:SetKeyValue("rendermode", "7")
		self.GlowSprite:Fire("Color", "255 2 8")
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
function ENT:CreateIdleBeam()
	if not IsValid(self) then
		return
	end

	local origin = self:WorldSpaceCenter() + VectorRand():GetNormalized() * 12
	local direction = VectorRand():GetNormalized()
	local endPos = origin + direction * math.Rand(128 * 0.1, 128)

	local trace = util.TraceLine({
		start = origin,
		endpos = endPos,
		filter = self,
		mask = MASK_SOLID
	})

	if trace.Hit then
		endPos = trace.HitPos
	end

	local beamName = "cets_idle_beam_" .. self:EntIndex() .. "_" .. math.random(1, 999999)
	local beam = ents.Create("env_beam")

	if not IsValid(beam) then
		return
	end

	beam:SetName(beamName)
	beam:SetPos(origin)
	beam:SetKeyValue("LightningStart", beamName)
	beam:SetKeyValue("LightningEnd", beamName)
	beam:SetKeyValue("texture", "sprites/hl1/lgtning.vmt")
	beam:SetKeyValue("BoltWidth", "2")
	beam:SetKeyValue("NoiseAmplitude", "24")
	beam:SetKeyValue("rendercolor", self.IdleBeamColor)
	beam:SetKeyValue("renderamt", "255")
	beam:SetKeyValue("spawnflags", "0")
	beam:SetKeyValue("life", "0.3")
	beam:Spawn()
	beam:Activate()
	beam:SetPos(origin)
	beam:SetKeyValue("LightningStart", beamName)
	beam:SetKeyValue("LightningEnd", beamName)

	local endPoint = ents.Create("info_target")

	if not IsValid(endPoint) then
		beam:Remove()
		return
	end

	endPoint:SetName(beamName .. "_end")
	endPoint:SetPos(endPos)
	endPoint:Spawn()
	endPoint:Activate()

	beam:SetKeyValue("LightningStart", self:GetName() ~= "" and self:GetName() or beamName)
	beam:SetKeyValue("LightningEnd", endPoint:GetName())
	beam:Fire("TurnOn", "", 0)

	timer.Simple(0.3, function()
		if IsValid(beam) then
			beam:Fire("TurnOff", "", 0)
			beam:Remove()
		end

		if IsValid(endPoint) then
			endPoint:Remove()
		end
	end)

	if trace.Hit then
		timer.Simple(0.3 * 0.5, function()
			if not IsValid(endPoint) then
				return
			end

			local effectData = EffectData()

			effectData:SetOrigin(trace.HitPos)
			effectData:SetNormal(trace.HitNormal)
			effectData:SetScale(1)

			util.Effect("Sparks", effectData)
		end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DissolveEntity(ent)
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 1)) do
		if not IsValid(ent) then continue end
		if ent == self then continue end
		if ent:IsPlayer() then continue end
		if ent:IsWorld() then continue end

		local dissolver = ents.Create("env_entity_dissolver")
		if not IsValid(dissolver) then continue end

		local target = "dissolve_" .. ent:EntIndex()
		ent:SetName(target)

		dissolver:SetKeyValue("target", target)
		dissolver:SetKeyValue("dissolvetype", "2") -- 0=Energy, 1=Heavy Electrical, 2=Light Electrical, 3=Core Effect
		dissolver:Spawn()
		dissolver:Activate()
		dissolver:Fire("Dissolve", target, 0)

		timer.Simple(0, function()
			if IsValid(dissolver) then
				dissolver:Remove()
			end
		end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPortalDamage()
	local center = self:GetPos()

	for _, ent in ipairs(ents.FindInSphere(center, 2)) do
		if ent == self or not IsValid(ent) then continue end
		if ent:Health() <= 0 then continue end

		local dist = ent:GetPos():Distance(center)
		local strength = 1 - math.Clamp(dist / 12, 0, 1)
		strength = strength * strength

		local dmg = DamageInfo()
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		dmg:SetDamageType(DMG_ENERGYBEAM)
		dmg:SetDamage(4098)
		dmg:SetDamagePosition(ent:WorldSpaceCenter() - Vector(0,0,512))
		ent:TakeDamageInfo(dmg)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTouch(ent)
	self:DissolveEntity(ent)

	if not IsValid(ent) then
		return
	end

	if ent == self then
		return
	end

	if self.NextTouchSound and self.NextTouchSound > CurTime() then
		return
	end

	self.NextTouchSound = CurTime() + self.TouchSoundCooldown

	if ent:IsPlayer() then
		ent:ScreenFade(SCREENFADE.IN, Color(255, 2, 8, 255), 1, 0)
	end

	self:EmitSound("hl1/debris/beamstart" .. math.random(14, 15) .. ".wav", 90, 100)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:DoPortalDamage()

	local randRange = math.random(1, 32)

	if randRange == 1 then 
		self:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav", 70, 100)
	end

	if not self.NextIdleBeam then
		self.NextIdleBeam = CurTime()
	end

	if CurTime() >= self.NextIdleBeam then
		self.NextIdleBeam = CurTime() + 0.1

		if math.random() <= 1 then
			self:CreateIdleBeam()
		end
	end

	self:NextThink(CurTime())

	return true
end