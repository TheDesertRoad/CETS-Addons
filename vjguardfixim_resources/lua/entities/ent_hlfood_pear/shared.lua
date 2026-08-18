ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Pear"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/pear.mdl")
	
end