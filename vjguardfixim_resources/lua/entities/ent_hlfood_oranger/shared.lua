ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Tangerine"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/props/de_inferno/crate_fruit_break_gib2.mdl")
	
end