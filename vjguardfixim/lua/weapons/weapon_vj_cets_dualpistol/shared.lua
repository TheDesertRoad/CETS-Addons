SWEP.Base 								= "weapon_vj_base"
SWEP.PrintName							= "Citadel Dual Pistols"
SWEP.Author 							= ""
SWEP.Contact							= ""

SWEP.WorldModel							= ""
SWEP.HoldType 							= "duel"
SWEP.NPC_CanBePickedUp = false

SWEP.NPC_NextPrimaryFire 				= 0.6
SWEP.NPC_TimeUntilFire 					= 0.1
SWEP.NPC_TimeUntilFireExtraTimers 		= {0.1, 0.2, 0.3}
SWEP.ReplacementWeapon = "item_ammo_ar2_large"

SWEP.Primary.Sound						= {"hl1/weapons/pl_gun1.wav", "hl1/weapons/pl_gun2.wav"}
SWEP.Primary.DistantSound				= {"hl1/weapons/pl_gun1.wav", "hl1/weapons/pl_gun2.wav"}
SWEP.Primary.Damage						= 2
SWEP.Primary.ClipSize					= 120
SWEP.Primary.TracerType = ""

SWEP.PrimaryEffects_MuzzleFlash 		= false
SWEP.PrimaryEffects_SpawnShells 		= false

SWEP.Primary.Force						= 12
SWEP.Primary.Ammo						= "Pistol"

SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.PrimaryEffects_DynamicLightBrightness = 2
SWEP.PrimaryEffects_DynamicLightDistance = 64
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	self:SetDrawWorldModel(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnAnimEvent(pos, ang, event, options)
	if event == 5001 then return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnGetBulletPos()
	local att = self.CurrentMuzzle == "left" && "right" && 1 or 2
	return self:GetOwner():GetAttachment(att).Pos
end