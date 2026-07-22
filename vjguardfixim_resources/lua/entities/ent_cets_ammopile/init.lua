AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSpawnEffect(true)

	local flags = self:GetSpawnFlags()

	if bit.band(flags, 64) ~= 0 or self:HasSpawnFlags(64) then
		self:SetModel("models/props_cets/coffeeammo.mdl")
	elseif bit.band(flags, 128) ~= 0 or self:HasSpawnFlags(128) then
		self:SetModel("models/props_cets/ammo_stack.mdl")
	else
		if math.random(1,2) == 1 then
			self:SetModel("models/props_cets/coffeeammo.mdl")
		else
			self:SetModel("models/props_cets/ammo_stack.mdl")
		end
	end

	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	for _, wep in ipairs(activator:GetWeapons()) do
		if not IsValid(wep) then continue end

		local primary = wep:GetPrimaryAmmoType()
		if primary >= 0 then
			local amount = math.max(wep:GetMaxClip1() * 2, 15)
			activator:GiveAmmo(amount, primary, true)
		end

		local secondary = wep:GetSecondaryAmmoType()
		if secondary >= 0 then
			local amount = math.max(wep:GetMaxClip2() * 1, 1)
			activator:GiveAmmo(amount, secondary, true)
		end
	end

	activator:EmitSound("items/ammo_pickup.wav")
end