ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Big Slam"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/props/cs_office/trash_can_p8.mdl")
	
end