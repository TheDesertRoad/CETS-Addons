ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Watermelon"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/props_junk/watermelon01.mdl")
	
end