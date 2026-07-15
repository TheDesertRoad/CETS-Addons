AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/items/classic_misc_consume.mdl")
	self:SetSkin(1)

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
function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Grenade.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Grenade.ImpactHard" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ANTITOXIN_TIME = GetConVar("sk_cets_antidote_time"):GetInt()

local SND_GAIN = "hl1/fvox/hiss.wav"
local SND_EXPIRE = "hl1/items/r_item1.wav"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GiveAntitoxin(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	ply.AntitoxinEnd = CurTime() + ANTITOXIN_TIME
	ply:EmitSound(SND_GAIN, 75, 100)

	timer.Create("CETS_Antitoxin_" .. ply:EntIndex(), ANTITOXIN_TIME, 1, function()
		if not IsValid(ply) then return end

		if CurTime() >= (ply.AntitoxinEnd or 0) then
			ply.AntitoxinEnd = nil
			ply:EmitSound(SND_EXPIRE, 75, 100)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTouch(ent)
	if not IsValid(ent) or not ent:IsPlayer() then return end

	GiveAntitoxin(ent)

	self:Remove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath", "CETS_AntitoxinCleanup", function(ply)
	timer.Remove("CETS_Antitoxin_" .. ply:EntIndex())
	ply.AntitoxinEnd = nil
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDisconnected", "CETS_AntitoxinCleanup", function(ply)
	timer.Remove("CETS_Antitoxin_" .. ply:EntIndex())
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "CETS_AntitoxinImmunity", function(ent, dmginfo)
	if not ent:IsPlayer() then return end

	if not ent.AntitoxinEnd or CurTime() >= ent.AntitoxinEnd then
		return
	end

	if dmginfo:IsDamageType(DMG_POISON) or dmginfo:IsDamageType(DMG_NERVEGAS) or dmginfo:IsDamageType(DMG_ACID) or dmginfo:IsDamageType(DMG_RADIATION) then
		dmginfo:SetDamage(0)
		return true
	end
end)