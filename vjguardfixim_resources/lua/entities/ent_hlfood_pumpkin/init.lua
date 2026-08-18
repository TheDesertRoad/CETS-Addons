AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnFunction( ply, tr )
	
	if !tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 1

	local ent = ents.Create( "ent_hlfood_pumpkin" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()

	self.Entity:SetModel("models/props_outland/pumpkin01.mdl")
 
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	
	self.Index = self.Entity:EntIndex()
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator)

	local health = activator:Health()
	activator:SetHealth( math.Clamp( ( health or 100 ) + pumpkin,0,100 ) )
	
	self.Entity:Remove()
	activator:EmitSound("food/normal_eat.wav", 80, 100)
	activator:EmitSound("food/crunch_eat.wav", 70, 100)
end
