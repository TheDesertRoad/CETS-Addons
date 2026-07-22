include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	local matName = "cets_glowstick_" .. self:EntIndex()

	self.GlowMaterial = CreateMaterial(matName, "VertexLitGeneric", {
		["$basetexture"] = "models/glowstick/glow",
		["$selfillum"] = 1,
		["$model"] = 1,
		["$color2"] = "[0 0 0]"
	})

	self.GlowIndex = nil

	for k, mat in ipairs(self:GetMaterials()) do
		if string.find(string.lower(mat), "glow") then
			self.GlowIndex = k - 1
			break
		end
	end

	if self.GlowIndex then
		self:SetSubMaterial(self.GlowIndex, "!" .. self.GlowMaterial:GetName())
	end

	self.GlowMaterial:SetVector("$color2", Vector(0,0,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if not self.GlowMaterial then return end

	local color = self:GetNWVector("GlowColor", Vector(0,0,0))

	self.GlowMaterial:SetVector("$color2", color)
	self:SetNextClientThink(CurTime() + 0.05)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self:DrawModel()
end