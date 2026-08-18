ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Chocolate Replacement"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/hext_candy_chocolate.mdl")
	
end