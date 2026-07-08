if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_base"
SWEP.PrintName = "Flamethrow"
SWEP.Author = ""
SWEP.Category = ""
SWEP.HoldType = "smg"
SWEP.ReplacementWeapon = ""
SWEP.NPC_CanBePickedUp = false

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/w_flamethrower.mdl"
SWEP.NPC_CustomSpread = 0.9

SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = false
SWEP.Primary.AllowInWater = false
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShellEject"
SWEP.PrimaryEffects_MuzzleFlash = false

SWEP.NPC_NextPrimaryFire = 0
SWEP.NPC_TimeUntilFire = 0
SWEP.NPC_TimeUntilFireExtraTimers = {0}

SWEP.HasReloadSound = false
SWEP.ReloadSound = "weapons/pistol/pistol_reload1.wav"
SWEP.Reload_TimeUntilAmmoIsSet	= 10000000000000
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack()

end