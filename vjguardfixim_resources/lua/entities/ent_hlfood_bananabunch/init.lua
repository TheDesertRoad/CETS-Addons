AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnFunction( ply, tr )
	
	if !tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 1

	local ent = ents.Create( "ent_hlfood_bananabunch" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()

	self.Entity:SetModel("models/props/cs_italy/bananna_bunch.mdl")
 
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
	local ent = ents.Create("ent_hlfood_banana")
	ent:SetPos(self:GetPos() + Vector(0,20,0))
	ent:Spawn()
	ent:Activate()

	local enta = ents.Create("ent_hlfood_banana")
	enta:SetPos(self:GetPos() + Vector(0,20,0))
	enta:Spawn()
	enta:Activate()

	local entb = ents.Create("ent_hlfood_banana")
	entb:SetPos(self:GetPos() + Vector(0,20,0))
	entb:Spawn()
	entb:Activate()

	local entc = ents.Create("ent_hlfood_banana")
	entc:SetPos(self:GetPos() + Vector(0,20,0))
	entc:Spawn()
	entc:Activate()

	local entd = ents.Create("ent_hlfood_banana")
	entd:SetPos(self:GetPos() + self:GetForward()*25 + Vector(0,0,20))
	entd:Spawn()
	entd:Activate()

	self.Entity:Remove()
	activator:EmitSound("physics/wood/wood_strain2.wav", 80, 100)
end
