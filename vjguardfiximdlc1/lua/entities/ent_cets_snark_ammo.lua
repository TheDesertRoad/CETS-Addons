AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "prop_vj_animatable"
ENT.PrintName = "Snark Entrails"
ENT.Author = false
ENT.Category = "Half-Life 2"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( "models/hl2_organest.mdl" )
		self:ResetSequence( "walk" )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
		self.Entity:DrawShadow( true )
		self.Entity:SetPos( self:GetPos() + Vector( 0, 0, 10 ) )
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Body.ImpactSoft" )
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
		self.User:Give("weapon_ply_snark")
		self.User:GiveAmmo( 9, "Snarks_CETS" )
	end
end