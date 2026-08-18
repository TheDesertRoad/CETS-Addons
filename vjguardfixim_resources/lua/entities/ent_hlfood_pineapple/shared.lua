ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Pineapple"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/pineapple.mdl")
	
end