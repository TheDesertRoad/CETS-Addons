AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("NV_ToggleActive")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/items/cets_nvg.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self:SetTrigger(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Weapon.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Weapon.ImpactHard" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	if not IsValid(activator) or not activator:IsPlayer() then return end
	if activator:GetNWBool("HasNV", false) then return end
 
	self:EmitSound("hl1/items/nvg_on.wav", 75, 100)

	activator:SetNWBool("HasNV", true)
	activator:SetNWBool("NVActive", false)
 
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("NV_ToggleActive", function(len, ply)
	if not ply:GetNWBool("HasNV", false) then return end
	ply:SetNWBool("NVActive", not ply:GetNWBool("NVActive", false))
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath", "NV_DisableOnDeath", function(victim, inflictor, attacker)
	victim:SetNWBool("NVActive", false)
	victim:SetNWBool("HasNV", false)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("cets_remove_nightvision", function(ply, cmd, args)
	if not IsValid(ply) then return end
	if not ply:GetNWBool("HasNV", false) then return end

	ply:SetNWBool("NVActive", false)
	ply:SetNWBool("HasNV", false)
end)