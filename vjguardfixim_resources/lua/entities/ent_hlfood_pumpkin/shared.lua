ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Pumpkin"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/props_outland/pumpkin01.mdl")
	
end