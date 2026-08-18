AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/items/classic_misc_consume.mdl")
	self:SetSkin(0)

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
function ENT:PhysicsCollide(data)
	if data.Speed > 100 then
		self:EmitSound("Grenade.ImpactSoft")
	end

	if data.Speed > 300 then
		self:EmitSound("Grenade.ImpactHard")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator:PickupObject(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function GetAdrenalineTime()
	local convar = GetConVar("sk_cets_adrenaline_time")

	if not convar then
		return 10
	end

	return math.max(convar:GetFloat(), 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function RemoveSpeedBoost(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	timer.Remove("CETS_SpeedBoost_" .. ply:EntIndex())

	if ply.CETS_OriginalWalkSpeed then
		ply:SetWalkSpeed(ply.CETS_OriginalWalkSpeed)
	end

	if ply.CETS_OriginalRunSpeed then
		ply:SetRunSpeed(ply.CETS_OriginalRunSpeed)
	end

	ply.CETS_OriginalWalkSpeed = nil
	ply.CETS_OriginalRunSpeed = nil

	ply.CETS_SpeedBoostEnd = nil
	ply:SetNWBool("HasSpeedBoost", false)

	ply:EmitSound("hl1/items/r_item1.wav", 75, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function GiveSpeedBoost(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	local duration = GetAdrenalineTime()

	if not ply:GetNWBool("HasSpeedBoost", false) then
		ply.CETS_OriginalWalkSpeed = ply:GetWalkSpeed()
		ply.CETS_OriginalRunSpeed = ply:GetRunSpeed()
	end

	ply:SetNWBool("HasSpeedBoost", true)
	ply.CETS_SpeedBoostEnd = CurTime() + duration

	ply:SetWalkSpeed(ply.CETS_OriginalWalkSpeed * 2)
	ply:SetRunSpeed(ply.CETS_OriginalRunSpeed * 1.75)

	ply:EmitSound("hl1/fvox/hiss.wav", 75, 100)

	timer.Remove("CETS_SpeedBoost_" .. ply:EntIndex())

	timer.Create("CETS_SpeedBoost_" .. ply:EntIndex(), duration, 1, function()
			if not IsValid(ply) then return end

			RemoveSpeedBoost(ply)
		end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTouch(ent)
	if not IsValid(ent) or not ent:IsPlayer() then return end

	ent:SetHealth(math.min( ent:Health() + 5, ent:GetMaxHealth()))

	GiveSpeedBoost(ent)

	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Move", "CETS_SpeedBoostMove", function(ply, mv)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end

	if not ply:GetNWBool("HasSpeedBoost", false) then
		return
	end

	if not ply.CETS_OriginalWalkSpeed or not ply.CETS_OriginalRunSpeed then
		return
	end

	if not ply.CETS_SpeedBoostEnd then
		return
	end

	if CurTime() >= ply.CETS_SpeedBoostEnd then
		RemoveSpeedBoost(ply)
		return
	end

	local boostedWalk = ply.CETS_OriginalWalkSpeed * 2
	local boostedRun = ply.CETS_OriginalRunSpeed * 1.75

	if ply:GetWalkSpeed() ~= boostedWalk then
		ply:SetWalkSpeed(boostedWalk)
	end

	if ply:GetRunSpeed() ~= boostedRun then
		ply:SetRunSpeed(boostedRun)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "CETS_SpeedBoostDamageReduction", function(target, dmginfo)
	if not IsValid(target) or not target:IsPlayer() then return end
	if not target:GetNWBool("HasSpeedBoost", false) then return end

	if target.CETS_SpeedBoostEnd and CurTime() >= target.CETS_SpeedBoostEnd then
		RemoveSpeedBoost(target)
		return
	end

	dmginfo:ScaleDamage(0.5)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath", "CETS_SpeedBoostDeath", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	if ply:GetNWBool("HasSpeedBoost", false) then
		RemoveSpeedBoost(ply)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDisconnected", "CETS_SpeedBoostDisconnect", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	timer.Remove("CETS_SpeedBoost_" .. ply:EntIndex())
end)