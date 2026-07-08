SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Stunstick"
SWEP.Author = ""

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.HoldType = "melee"
SWEP.Primary.Damage = 10
SWEP.NPC_NextPrimaryFire = 1 -- Next time it can use primary fire
SWEP.IsMeleeWeapon = true
SWEP.MeleeWeaponSound_Hit = {"Weapon_StunStick.Melee_Hit"}
SWEP.MeleeWeaponSound_Miss = {"Weapon_StunStick.Swing"}
SWEP.ReplacementWeapon = "weapon_stunstick"

function SWEP:CustomOnPrimaryAttack_MeleeHit(ent)
	local effectData = EffectData()
	effectData:SetOrigin(self:GetAttachment(1).Pos)
	util.Effect("StunstickImpact", effectData)
	util.Effect("TeslaHitBoxes", effectData)
end