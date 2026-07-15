AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_cets_aliens/jump_pad.mdl")
	self:SetCollisionBounds(Vector(32, 32, 1), Vector(-32, -32, 2))
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

	self.Launching = false
	self.Target = nil

	self.Delay = 0.2
	self.Cooldown = 0.4

	self.CurrentAnim = nil
	self:PlayAnimation("idle1", true)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.CurrentAnim then
		self:SetSequence(self.CurrentAnim)
		self:FrameAdvance(FrameTime())

		if not self.AnimationLoop and CurTime() >= self.AnimEnd then
			self.CurrentAnim = nil
			self:PlayAnimation("idle1", true)
		end
	end

	if self.Launching then
		if CurTime() >= self.LaunchTime then
			if IsValid(self.Target) then
				self:LaunchEntity(self.Target)
			end

			self.Launching = false
			self.Target = nil
			self.NextLaunch = CurTime() + self.Cooldown
		end

		self:NextThink(CurTime() + 0.05)
		return true
	end

	if self.NextLaunch and CurTime() < self.NextLaunch then
		self:NextThink(CurTime() + 0.05)
		return true
	end

	local checkPos = self:GetPos() + Vector(0,0,40)

	for _, ent in ipairs(ents.FindInSphere(checkPos,40)) do
		if ent ~= self and self:IsLaunchable(ent) then
			self.Target = ent
			self.Launching = true
			self.LaunchTime = CurTime() + self.Delay
			break
		end
	end

	self:NextThink(CurTime() + 0.05)
	return true
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Blacklist = {
	["npc_mommapod_vj_cets"] = true,
	["npc_hydra_vj_cets"] = true,
	["npc_tentacle_vj_cets"] = true,
	["npc_gonarch_vj_cets"] = true,
	["npc_gargantua_vj_cets"] = true,
	["npc_particlestorm_vj_cets"] = true,
}

local BlacklistPrefixes = {
	"obj_",
	"sent_",
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsLaunchable(ent)
	if not IsValid(ent) then return false end

	local class = ent.GetClass and ent:GetClass() or ""

	if Blacklist[class] then
		return false
	end

	for _, prefix in ipairs(BlacklistPrefixes) do
		if string.StartWith(class, prefix) then
			return false
		end
	end

	if ent:IsPlayer() then
		return true
	end

	if ent:IsNPC() then
		if GetConVar("cets_xen_jumppad_launchnpcs"):GetBool() == false then
			return false
		end

		if ent.VJ_IsHugeMonster then
			return false
		end

		if ent.VJ_IsBoss then
			return false
		end

		if ent:GetMoveType() == MOVETYPE_NONE then
			return false
		end

		if ent:GetMoveType() == VJ_MOVETYPE_STATIONARY then
			return false
    		end

		return true
	end

	if ent:IsNextBot() then
		return true
	end

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		return true
	end

	return false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LaunchEntity(ent)
	self:EmitSound("hl1/doors/aliendoor3.wav", 100, 100)

	self:PlayJumpAnimation()

	local direction = self:GetUp()
	local power = 720

	if ent:IsPlayer() then
		ent:SetVelocity(direction * power)
		return
	end

	if ent:IsNPC() && GetConVar("cets_xen_jumppad_launchnpcs"):GetInt() == 1 then
		ent:SetVelocity(direction * power)

		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			phys:ApplyForceCenter(direction * phys:GetMass() * power)
		end

		return
	end

	if ent:IsNextBot() then
		if ent.loco then
			ent.loco:SetVelocity(direction * power)
		else
			ent:SetVelocity(direction * power)
		end

		return
	end

	local phys = ent:GetPhysicsObject()

	if IsValid(phys) then
		phys:ApplyForceCenter(direction * phys:GetMass() * power)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(name, loop)

	local seq = self:LookupSequence(name)

	if seq == -1 then return false end

	self:ResetSequence(seq)
	self:SetCycle(0)
	self:SetPlaybackRate(1)

	self.CurrentAnim = seq
	self.AnimationLoop = loop or false

	if loop then
		self.AnimEnd = 0
	else
		self.AnimEnd = CurTime() + self:SequenceDuration(seq)
	end

	return true
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayJumpAnimation()
	local anim

	if math.random(1,2) == 1 then
		anim = "jump01"
	else
		anim = "jump02"
	end

	local seq = self:LookupSequence(anim)

	if seq == -1 then
		return
	end

	self:ResetSequence(seq)
	self:SetCycle(0)
	self:SetPlaybackRate(1)

	self.CurrentAnim = seq
	self.AnimEnd = CurTime() + self:SequenceDuration(seq)
end