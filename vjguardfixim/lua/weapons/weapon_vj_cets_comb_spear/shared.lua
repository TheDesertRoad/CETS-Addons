if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_ar2"
SWEP.PrintName = "SPEAR"
SWEP.Author = ""
SWEP.Category = ""

SWEP.MadeForNPCsOnly = true	
SWEP.WorldModel = "models/weapons/w_spear.mdl"
SWEP.ReplacementWeapon = "item_ammo_ar2_large"

SWEP.Primary.Damage				= 7 -- Damage
SWEP.Primary.ClipSize			= 4096 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.12 -- Time until it can shoot again
SWEP.Primary.Sound				= "Cets_Weapon_OICW.NPC_Fire"
SWEP.Primary.Recoil			= 1			
SWEP.Primary.Cone			= 2		
SWEP.Primary.Delay			= 0.15		
SWEP.Primary.DefaultClip	                  = 85	
SWEP.Primary.Tracer			= 4			
SWEP.Primary.Force			= 7
SWEP.Primary.Automatic		= 1
SWEP.Primary.TracerType = "AR2Tracer"
SWEP.Primary.Sound = "npc/ministrider/ministrider_fire1.wav"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.PrimaryEffects_DynamicLightBrightness = 2
SWEP.PrimaryEffects_DynamicLightDistance = 32

SWEP.NPC_NextPrimaryFire = 2.3
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.3, 0.4, 0.5, 0.6, 0.7}
SWEP.NPC_ReloadSound = "hl1/weapons/shock_recharge.wav"
SWEP.NPC_HasSecondaryFire = true -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireEnt = "obj_vj_xrang_extractor"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	if GetConVar("sk_cets_kiscrotums_enable"):GetInt() == 1 then
		self.NPC_HasSecondaryFire = true
	else
		self.NPC_HasSecondaryFire = false
	end
end