AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "MP5 Grenades"
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
		self.Entity:SetModel( "models/weapons/hl2_mp5_grenade.mdl" )
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

timer.Simple(0, function()
    if not IsValid(self) then return end

    local trigger = ents.Create("mp5_grenade_trigger")

    if not IsValid(trigger) then return end

    trigger:SetPos(self:GetPos())
    trigger:SetParent(self)

    trigger:SetCollisionBounds(
        Vector(-32, -32, -32),
        Vector(32, 32, 32)
    )

    trigger.Parent = self

    trigger:Spawn()

    self.TouchTrigger = trigger
end)
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
		self.User:GiveAmmo( 1, "MP5Gr_CETS" )
	end
end