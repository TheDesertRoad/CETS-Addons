if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_smg1"
SWEP.PrintName = "ASPMA WEAPON"
SWEP.Author = ""
SWEP.Category = ""
SWEP.HoldType = "pistol"

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/aspgun_w.mdl"

SWEP.Primary.Damage				= 2 -- Damage
SWEP.Primary.ClipSize			= 10240 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.12 -- Time until it can shoot again
SWEP.Primary.Sound				= {"weapons/alyx_gun/alyx_gun_fire5.wav", "weapons/alyx_gun/alyx_gun_fire6.wav"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.Primary.TracerType = "AR2Tracer"
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.Primary.Spread 			= 0

SWEP.NPC_NextPrimaryFire = 2.3
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.3, 0.5, 0.7, 1.1, 1.3, 1.5, 1.7}
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack()
local ef = EffectData()
      ef:SetEntity( self )
      ef:SetFlags( 5 ) -- Sets the Combine AR2 Muzzle flash

util.Effect( "MuzzleFlash", ef )
end