AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "SMG1"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = false
SWEP.NPC_CanBePickedUp = false

if CLIENT then
	VJ.AddKillIcon("weapon_vj_smg1", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_smg1")
end

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.UseHands = true
SWEP.ReplacementWeapon = "weapon_smg1"

SWEP.NPC_NextPrimaryFire = 1.5
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1}
SWEP.NPC_HasSecondaryFire = false
SWEP.NPC_ReloadSound = "weapons/smg1/smg1_reload.wav"

SWEP.Primary.Damage = 2
SWEP.Primary.ClipSize = 45
SWEP.Primary.Delay = 0.09
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Sound = "Cets_Weapon_SMG1.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShellEject"
SWEP.PrimaryEffects_MuzzleFlash = false

SWEP.HasReloadSound = true
SWEP.ReloadSound = "weapons/smg1/smg1_reload.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack()
local ef = EffectData()
      ef:SetEntity( self )
      ef:SetFlags( 1 )

util.Effect( "MuzzleFlash", ef )
end