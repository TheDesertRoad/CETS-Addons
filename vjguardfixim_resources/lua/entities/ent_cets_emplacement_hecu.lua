AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_cets_emplacement"

ENT.PrintName = "Military Emplacement"
ENT.Category = "Half-Life 2"
ENT.SubCategory = "Emplacements"
ENT.Spawnable = false 
ENT.AdminOnly = false
ENT.Author 			= "VALVe"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

ENT.Model = "models/weapons/w_mach_m60.mdl"
ENT.InvModel = "models/props_combine/bunker_gun01_nogun.mdl"

ENT.ShootDelay = 0.08
ENT.Ammo = -1
ENT.Automatic = true
ENT.DoNetworking = true
ENT.HideGunModel = true

ENT.Damage = 28
ENT.NPCDamage = 16

ENT.NPCFire = true

ENT.NPC_NextPrimaryFire = 0.1
ENT.NPC_TimeUntilFire = 0
ENT.NPC_TimeUntilFireExtraTimers = {0.07, 0.4}

ENT.Spread = Vector(1, 1, 0) * 0.02
ENT.NPCSpread = Vector(1, 1, 0) * 0.08

ENT.EnableZoom = false
ENT.ZoomFOV = 20
ENT.ZoomTransition = 0.5

ENT.EnableScope = false
ENT.ScopeMaterial = "effects/cets/hmg_scope1_s"
ENT.ZoomInSound = "weapons/sniper/sniper_zoomin.wav"
ENT.ZoomOutSound = "weapons/sniper/sniper_zoomout.wav"
ENT.ZoomSoundLevel = 100
ENT.ZoomSoundPitch = 100

ENT.PitchOffset = 10

ENT.UseDistance = 64
ENT.YawLimit = 60
ENT.PitchMin = -35
ENT.PitchMax = 60

ENT.ActivateSequence = 1
ENT.RetractSequence = 3
ENT.ShootSequence = 2
ENT.IdleSequence = 0

ENT.ShootMode = "hitscan"

ENT.ProjectileClass = "obj_vj_rocket_apc"
ENT.ProjectileSpeed = 2500
ENT.ProjectileDamage = 50
ENT.ProjectileRadius = 8
ENT.ProjectileOwner = true

ENT.EnableNPC = true
ENT.NPCAimDistance = 65535
ENT.NPCUseEnemy = true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoShoot(destination)
	if not destination then
		return
	end

	local damage = self.Damage or 15

	if IsValid(self.User) and self.User:IsNPC() then
		damage = self.NPCDamage or damage
	end

	if self.ShootMode == "projectile" then
		local projectile = self:DoShootProjectile(destination)

		if not IsValid(projectile) then
			return
		end

		if IsValid(self.User) and self.User:IsNPC() then
			projectile.CETS_Damage = self.NPCProjectileDamage or self.ProjectileDamage or 50

		else
			projectile.CETS_Damage = self.ProjectileDamage or 50

		end

		self:EmitSound("Weapon_RPG.Single")

		local effect = EffectData()

		effect:SetEntity(self)
		effect:SetAttachment(1)
		effect:SetFlags(7)

		util.Effect("MuzzleFlash", effect)

		return projectile
	end

	local attachment = self:GetAttachment(1)

	if not attachment then
		return
	end

	local spread = self.Spread or Vector(1, 1, 0) * 0.02

	if IsValid(self.User) and self.User:IsNPC() then
		spread = self.NPCSpread or spread
	end


	local bullet = {
		TracerName = "Tracer",
		Damage = damage,
		Force = 16,
		Spread = spread,
		Src = attachment.Pos,
		Dir = destination,
		Attacker = IsValid(self.User) and self.User or self,
		Inflictor = self,
		Callback = function(att, tr, dmg)
			dmg:SetDamage(damage)
			if IsValid(tr.Entity) then
				if tr.Entity:IsPlayer() or tr.Entity:IsVehicle() then
					dmg:SetDamage(damage)
				end
			end

			dmg:SetDamageType(DMG_BULLET)
		end
	}


	self:FireBullets(bullet)
	self:EmitSound("hl1/ambience/mgun1.wav")

	local effect = EffectData()

	effect:SetEntity(self)
	effect:SetAttachment(1)
	effect:SetFlags(7)

	util.Effect("MuzzleFlash", effect)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
else
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoInit()
	local mdl = self:SetupCustomModel("models/weapons/emplacement_mach_m249para.mdl", 1)

	mdl:ManipulateBoneScale(1, Vector(0, 0, 0))

	local mat = Matrix()
	mat:Rotate(Angle(0, 90, 100))
	mat:Translate(Vector(0, 4, 1))
	self._GunModelMatrix = mat
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end