ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cool Water"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/props/cs_office/Water_bottle.mdl")
	
end