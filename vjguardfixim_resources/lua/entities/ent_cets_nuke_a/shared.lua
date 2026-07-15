ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Spawnable = GetConVar("cets_spawnable_nuke"):GetBool()
ENT.PrintName 		= "Nuclear Bomb"
ENT.Category	= "Fun + Games"
ENT.Author 			= "VALVe"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
end
