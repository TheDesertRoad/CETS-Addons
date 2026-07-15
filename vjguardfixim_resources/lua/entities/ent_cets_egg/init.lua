AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_phx/misc/egg.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	if self.Broken then return end
	self.Broken = true

	local gibModels = {
		"models/props_phx/misc/gibs/egg_piece1.mdl",
		"models/props_phx/misc/gibs/egg_piece2.mdl",
		"models/props_phx/misc/gibs/egg_piece3.mdl",
		"models/props_phx/misc/gibs/egg_piece4.mdl",
		"models/props_phx/misc/gibs/egg_piece5.mdl",
		"models/props_phx/misc/gibs/egg_piece6.mdl",
	}

	local pos = self:GetPos()

	for _, model in ipairs(gibModels) do
		local gib = ents.Create("prop_physics")
		if IsValid(gib) then
			gib:SetModel(model)
			gib:SetPos(pos + VectorRand() * 5)
			gib:SetAngles(AngleRand())
			gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			gib:Spawn()

			local phys = gib:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(VectorRand() * math.random(150, 300) + Vector(0, 0, 100))
				phys:AddAngleVelocity(VectorRand() * 300)
			end

			timer.Simple(5, function()
				if IsValid(gib) then
					gib:Remove()
				end
			end)
		end
	end

	self:Remove()

	util.Decal("VJ_CETS_EggYolk", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
	sound.Play("phx/eggcrack.wav", pos)
end