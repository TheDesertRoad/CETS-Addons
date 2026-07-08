AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Ammo Box APC"
ENT.Category = "Half-Life 2"
ENT.Author = "VALVe"
ENT.Editable = true
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
		self.Entity:DrawShadow( false )
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "SolidMetal.ImpactSoft" )
	end
end

function ENT:Use( entity )
	if entity:IsPlayer() then
		self.User = entity
	end

	if SERVER and IsValid( self.User ) then
		self.User:GiveAmmo( 11, "SMG1" )
	end
end