AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Resin"
ENT.Author = "VALVe"
ENT.Spawnable = true
ENT.Category = "Half-Life 2"
ENT.SubCategory = "Ammo and Items"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Models = {
	"models/items/crafting_metal/resin_puck01.mdl",
	"models/items/crafting_metal/resin_puck02.mdl",
	"models/items/crafting_metal/resin_puck03.mdl",
	"models/items/crafting_metal/resin_puck_stack.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if SERVER then
		local model = table.Random(self.Models)

		self:SetModel(model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Plastic_Box.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Plastic_Box.ImpactHard" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end