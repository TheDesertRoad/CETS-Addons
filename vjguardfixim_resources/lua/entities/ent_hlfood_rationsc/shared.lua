ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Loyalist Rations"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/weapons/w_packatl.mdl")
	
end