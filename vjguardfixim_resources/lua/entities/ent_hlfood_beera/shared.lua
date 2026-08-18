ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Beer (Beer brand)"
ENT.Author = "VALVe"
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupModel()

	self.Entity:SetModel("models/props_junk/garbage_glassbottle001a.mdl")
	
end