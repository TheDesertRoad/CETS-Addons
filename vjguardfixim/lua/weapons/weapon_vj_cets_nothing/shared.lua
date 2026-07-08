if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_9mmpistol"
SWEP.PrintName = "NOTHING"
SWEP.Author = ""
SWEP.Category = ""
SWEP.HoldType = "normal"
SWEP.ReplacementWeapon = ""

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/vehicles/vehicle_blackout_e1_dogintro.mdl"

SWEP.Primary.Damage				= 0 -- Damage
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Sound				= "Cets_Weapon_HMG1.NPC_Fire"
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
SWEP.Primary.Cone			= 0				
SWEP.Primary.Tracer			= 0			
SWEP.Primary.Force			= 0
SWEP.Primary.Automatic		= 0
SWEP.PrimaryEffects_MuzzleFlash = false

SWEP.NPC_NextPrimaryFire = 0
SWEP.NPC_TimeUntilFire = 0
SWEP.NPC_HasReloadSound = false
SWEP.NPC_TimeUntilFireExtraTimers = {0}
SWEP.NPC_HasSecondaryFire = false 
