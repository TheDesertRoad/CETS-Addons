AddCSLuaFile()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Category = "Half-Life 2"
ENT.Author 			= "VALVe"
ENT.PrintName = "Magnusson Telespawner"
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local SPAWN_ENTITY = "weapon_striderbuster"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	ENT.SpinTime = 0
	ENT.BombSpawned = false
	ENT.LastSpawnedEntity = NULL
	ENT.NextSpark = 0
	ENT.BetaOwner = NULL
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {
	"models/gibs/metal_gib1.mdl", "models/gibs/metal_gib2.mdl",
	"models/gibs/metal_gib3.mdl", "models/gibs/metal_gib4.mdl",
	"models/gibs/manhack_gib01.mdl", "models/gibs/manhack_gib04.mdl",
	"models/gibs/manhack_gib05.mdl", "models/gibs/manhack_gib06.mdl",
	"models/combine_turrets/floor_turret_gib2.mdl",
	"models/combine_turrets/floor_turret_gib4.mdl",
	"models/combine_turrets/floor_turret_gib5.mdl"
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end
 
	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + tr.HitNormal * 4)
	ent:SetAngles(Angle(0, ply:EyeAngles().yaw + 90, 0))
	ent:Spawn()
	ent:Activate()
	ent:SetSpawnEffect(true)
	ent.BetaOwner = ply

 
	return ent
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/magnusson_teleporter.mdl")
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)
	self:SetHealth(500)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use()
	if self.SpinTime > CurTime() then return end
	if not self:IsLastBombTaken() then
		self:EmitSound("HL2Player.UseDeny")
		return
	end
 
	self.BombSpawned = false
	self:ResetSequence(1)
	self.SpinTime = CurTime() + self:SequenceDuration()
	self:SetNWFloat("spintime", self.SpinTime)
	self:EmitSound("HL2Player.Use")
	self:CleanUpEntities(self:GetAttachment(1).Pos)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.SpinTime > CurTime() then
		if (self.SpinTime - CurTime()) < 2.5 and not self.BombSpawned then
			local ent = duplicator.IsAllowed(SPAWN_ENTITY) and ents.Create(SPAWN_ENTITY) or nil
			self.LastSpawnedEntity = ent
 
			if IsValid(ent) then
				ent:SetPos(self:GetAttachment(1).Pos)
				ent:SetAngles(self:GetAttachment(1).Ang)
				ent:Spawn()
 
				if IsValid(ent:GetPhysicsObject()) then
					ent:GetPhysicsObject():Sleep()
				end
 
				if IsValid(self.BetaOwner) then
					undo.Create("magnusson_device")
						undo.AddEntity(ent)
						undo.SetPlayer(self.BetaOwner)
						undo.SetCustomUndoText("Undone a " .. string.upper(ent:GetClass()))
					undo.Finish()
				end
 
				local ef = EffectData()
				ef:SetEntity(ent)
				ef:SetFlags(0)
				util.Effect("eff_magnusson_1", ef)
			end
 
			self.BombSpawned = true
		end
 
		self:NextThink(CurTime())
		return true
	end
 
	if self:Health() < 50 and self.NextSpark < CurTime() then
		self.NextSpark = CurTime() + self:Health() * 0.2
		local sparkpos = VectorRand()
		local ef = EffectData()
		ef:SetOrigin(self:GetAttachment(1).Pos + sparkpos * 20)
		ef:SetNormal(sparkpos)
		ef:SetScale(5)
		ef:SetMagnitude(2)
		util.Effect("ElectricSpark", ef)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsLastBombTaken()
	local ent = self.LastSpawnedEntity
	return not (IsValid(ent) and IsValid(ent:GetPhysicsObject()) and ent:GetPhysicsObject():IsAsleep())
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CleanUpEntities(pos)
	local diss = ents.Create("env_entity_dissolver")
	diss:SetPos(self:GetPos())
	diss:SetKeyValue("dissolvetype", "1")
	diss:SetKeyValue("magnitude", "300")
	diss:SetKeyValue("target", "to_dissolve_enkomes_erosonkomes")
	diss:Spawn()
 
	for _, v in ipairs(ents.FindInSphere(pos, 8)) do
		if v:IsPlayer() or v:GetClass() == self:GetClass() or v == self then continue end
		v:SetName("to_dissolve_enkomes_erosonkomes")
	end
 
	diss:Fire("Dissolve", "", 0.3)
	diss:Fire("Kill", "", 10)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local atk = dmginfo:GetAttacker()
	if not (atk:IsPlayer() or atk:IsNPC()) then return end
 
	local ef = EffectData()
	ef:SetOrigin(dmginfo:GetDamagePosition())
	ef:SetScale(5)
	ef:SetMagnitude(2)
	ef:SetNormal((dmginfo:GetDamagePosition() - self:GetPos() - self:OBBCenter()):GetNormal())
	util.Effect("ElectricSpark", ef)
 
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() < 1 then self:DestroySpectacularly() end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DestroySpectacularly()
	for i = 1, math.random(3, 5) do
		local exp = ents.Create("env_explosion")
		exp:SetPos(self:GetPos() + VectorRand() * Vector(30, 30, 0))
		exp:SetKeyValue("iMagnitude", "20")
		exp:Spawn()
		exp:Fire("Explode", "", (i - 1) * 0.2)
		exp:Fire("Kill", "", 1)
	end
 
	for i = 1, math.random(10, 30) do
		local norm = VectorRand()
		local gib = ents.Create("prop_physics")
		gib:SetModel(math.random(1, 100) == 47 and "models/Gibs/HGIBS.mdl" or gibs[math.random(#gibs)])
		gib:SetPos(self:GetPos() + norm * 15 + Vector(0, 0, 30))
		gib:Spawn()
		gib:Fire("Kill", "", 5)
		gib:GetPhysicsObject():SetVelocity(norm * 1000)
		gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		if math.random(1, 3) == 2 then gib:Ignite(10, 10) end

		construct.SetPhysProp(NULL, gib, 0, gib:GetPhysicsObject(), { Material = "metal_bouncy" })
	end
 
	self:Remove()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if not self:IsLastBombTaken() then
		self.LastSpawnedEntity:Remove()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.NextSmoke = 0
ENT.Emitter = nil
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/magnusson_teleporter.mdl")
	self.Emitter = ParticleEmitter(self:GetPos(), false)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.NextSmoke < CurTime() and self:Health() < 50 then
		self.NextSmoke = CurTime() + self:Health() * 0.005
 
		local part = self.Emitter:Add("sprites/baku_burntcer_smoke", self:GetAttachment(2).Pos + VectorRand() * 13)
		part:SetVelocity(Vector(0, 0, 100) + VectorRand() * 10)
		part:SetAngleVelocity(AngleRand() * 0.5)
		part:SetDieTime(math.Rand(0, 2))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartSize(16)
		part:SetEndSize(0)
		part:SetGravity(Vector(0, 0, 100))
		part:SetCollide(true)
		part:SetRoll(0)
		part:SetRollDelta(3)
		part:SetBounce(0)
		part:SetAirResistance(5)
		part:SetColor(255, 255, 255)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Emitter:Finish()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end