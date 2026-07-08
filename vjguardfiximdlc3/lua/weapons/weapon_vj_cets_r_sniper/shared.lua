if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_357"
SWEP.PrintName = "SNIPER"
SWEP.HoldType = "ar2"
SWEP.Author = ""
SWEP.Category = ""

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/w_sniper.mdl"
SWEP.ReplacementWeapon = "item_ammo_357"

SWEP.Primary.Damage				= 40 -- Damage
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 2 -- Time until it can shoot again
SWEP.Primary.Sound				= "npc/sniper/sniper1.wav"
SWEP.Primary.SoundLevel = 100
SWEP.Primary.DistantSound				= "npc/sniper/sniper1.wav"
SWEP.Primary.Cone = 0
SWEP.Primary.Force = 2

SWEP.NPC_ReloadSound				= "weapons/sniper/sniper_reload.wav"
SWEP.NPC_NextPrimaryFire = 1
SWEP.NPC_TimeUntilFire = 1
SWEP.NPC_CustomSpread = 0
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?