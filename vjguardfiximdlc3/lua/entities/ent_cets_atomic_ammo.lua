AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Uranium Ammo"
ENT.Category = "Half-Life 2"
ENT.Author = "VALVe"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( "models/weapons/w_hl2_gaussammo.mdl" )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
		self.Entity:DrawShadow( false )
		self.Entity:SetPos( self:GetPos() + Vector( 0, 0, 10 ) )
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

function ENT:Touch( entity )
	if entity:IsPlayer() then
		self.User = entity
		self.Entity:Remove()
	end
end

function ENT:Use( entity )
	if entity:IsPlayer() then
		self.User = entity
		self.Entity:Remove()
	end
end

function ENT:OnRemove()
	if SERVER and IsValid( self.User ) then
		self.User:GiveAmmo( 15, "UraniumEnergy_CETS" )
	end
end