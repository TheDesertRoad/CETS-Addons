if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_ar2"
SWEP.PrintName = "Pulse SMG"
SWEP.Author = ""
SWEP.Category = ""

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/w_hl2psmg.mdl"
SWEP.ReplacementWeapon = "item_ammo_ar2"

SWEP.Primary.Damage				= 4 -- Damage
SWEP.Primary.ClipSize			= 25 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.12 -- Time until it can shoot again
SWEP.Primary.Sound				= "Cets_Weapon_PULSESMG.Fire"
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.Primary.TracerType = "AR2Tracer"

SWEP.NPC_NextPrimaryFire = 1.3
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1}
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.PrimaryEffects_DynamicLightBrightness = 2
SWEP.PrimaryEffects_DynamicLightDistance = 32

SWEP.HasReloadSound = true
SWEP.ReloadSound = "Cets_Weapon_PULSESMG.Reload"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	if GetConVar("sk_cets_ar2scrotums_enable"):GetInt() == 1 then
		self.NPC_HasSecondaryFire = false
	else
		self.NPC_HasSecondaryFire = false
	end
end