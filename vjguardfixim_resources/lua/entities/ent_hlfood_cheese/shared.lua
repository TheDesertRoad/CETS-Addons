ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cheese Replacement"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/pound_cheese.mdl")
	
end