ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Biotic Rations"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/weapons/w_packatb.mdl")
	
end