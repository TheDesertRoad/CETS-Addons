ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Carrot"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/carrot.mdl")
	
end