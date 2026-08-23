SWEP.Base 								= "weapon_vj_base"
SWEP.PrintName							= "Black-Ops Dual Pistols"
SWEP.Author 							= ""
SWEP.Contact							= ""

SWEP.WorldModel							= ""
SWEP.HoldType 							= "duel"
SWEP.NPC_CanBePickedUp = false

SWEP.NPC_NextPrimaryFire 				= 1
SWEP.NPC_TimeUntilFire 					= 0.1
SWEP.NPC_TimeUntilFireExtraTimers 		= {0.2, 0.3, 0.4, 0.5}
SWEP.ReplacementWeapon = "item_ammo_ar2_large"

SWEP.Primary.Sound						= {"hl1/weapons/pl_gun1.wav", "hl1/weapons/pl_gun2.wav"}
SWEP.Primary.DistantSound				= {"hl1/weapons/pl_gun1.wav", "hl1/weapons/pl_gun2.wav"}
SWEP.Primary.Damage						= 2
SWEP.Primary.ClipSize					= 120

SWEP.PrimaryEffects_MuzzleFlash 		= false
SWEP.PrimaryEffects_SpawnShells 		= false

SWEP.Primary.Force						= 6
SWEP.Primary.Ammo						= "Pistol"

SWEP.PrimaryEffects_DynamicLightColor = Color(225, 128, 0)
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
	local owner = self:GetOwner()
	if !IsValid(owner) then return end

	self.MuzzleIndex = self.MuzzleIndex or 3

	local att = owner:GetAttachment(self.MuzzleIndex)

	-- Switch to the other muzzle for the next shot
	if self.MuzzleIndex == 3 then
		self.MuzzleIndex = 4
	else
		self.MuzzleIndex = 3
	end

	if att then
		return att.Pos
	end

	return owner:GetPos()
end