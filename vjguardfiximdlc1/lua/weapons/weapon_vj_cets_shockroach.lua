AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Shockroach"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = false

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = ""
SWEP.HoldType = "ar2"
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.UseHands = true
SWEP.ReplacementWeapon = "weapon_ply_shockroach"

SWEP.NPC_HasSecondaryFire = false

SWEP.Primary.ClipSize = 4096
SWEP.NPC_NextPrimaryFire = 0.3
SWEP.Primary.DisableBulletCode	= true
SWEP.Primary.TracerType = ""
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Sound = "npc/shockroach/shock_fire.wav"
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 30, 225)

SWEP.DryFireSound = "npc/shockroach/shock_discharge.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Init" then
		if CLIENT then return end
		local owner = self:GetOwner()
		local projectile = ents.Create("obj_vj_racexenergyorb_b")
		local spawnPos = self:GetBulletPos()
		projectile:SetPos(spawnPos)
		projectile:SetAngles(owner:GetAngles())
		projectile:SetOwner(owner)
		projectile:Activate()
		projectile:Spawn()
		ParticleEffectAttach("racex_arc_02_cp0", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("muzzleflash"))
		local phys = projectile:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos + Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(-15, 15)), 1, 10000))
			projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnGetBulletPos()
	-- Return a position to override the bullet spawn position
	return self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("muzzleflash")).Pos
end