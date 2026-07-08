AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "9mm Pistol"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = false
SWEP.NPC_CanBePickedUp = false

if CLIENT then
	VJ.AddKillIcon("weapon_vj_9mmpistol", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_pistol")
end

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.SwayScale = 4
SWEP.UseHands = true
SWEP.ReplacementWeapon = "weapon_pistol"

SWEP.NPC_CustomSpread = 0.9

SWEP.Primary.Damage = 8
SWEP.Primary.ClipSize = 18
SWEP.Primary.Delay = 0.25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = "Cets_Weapon_Pistol.Single"
SWEP.Primary.AllowInWater = true
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShellEject"
SWEP.PrimaryEffects_MuzzleFlash = false

SWEP.NPC_NextPrimaryFire = 3
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.6, 1.2, 2.1, 2.9}

SWEP.HasReloadSound = true
SWEP.ReloadSound = "weapons/pistol/pistol_reload1.wav"
SWEP.Reload_TimeUntilAmmoIsSet	= 1
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack()
local ef = EffectData()
      ef:SetEntity( self )
      ef:SetFlags( 1 )

util.Effect( "MuzzleFlash", ef )
end