AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/zombie_hl2_combine_grunt.mdl"}
ENT.StartHealth = 50
ENT.HullType = HULL_WIDE_HUMAN 
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.CanChatMessage = false
ENT.Passive_RunOnTouch = true
ENT.Passive_RunOnDamage = true
ENT.WaitForEnemyToComeOut = true
ENT.Medic_CanBeHealed = false 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01" -- Particles to spawn when it's damaged
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 9

ENT.NoWeapon_UseScaredBehavior = false
ENT.HasWeaponBackAway = true
ENT.WeaponReload_FindCover = false

ENT.CanCrouchOnWeaponAttack = false -- Can it crouch while shooting?

ENT.AnimTbl_WeaponReload = {"reload_ar2"}
ENT.AnimTbl_WeaponReloadBehindCover = {"reload_ar2_low"}
ENT.AnimTbl_WeaponAttackGesture = "gesture_shoot_annabelle"   -- Animation played when the SNPC does weapon attack
ENT.DisableWeaponFiringGesture = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"melee_swing"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 16 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.2 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 30
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 150
ENT.MeleeAttackKnockBack_Forward2 = 200

ENT.HasGrenadeAttack = false

ENT.SoundTbl_FootStep = {"npc/zombine/gear1.wav", "npc/zombine/gear2.wav", "npc/zombine/gear3.wav"}

ENT.SoundTbl_Idle = {
	"npc/zombine/zombine_idle1.wav",
	"npc/zombine/zombine_idle2.wav",
	"npc/zombine/zombine_idle3.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/zombine/zombine_idle1.wav",
	"npc/zombine/zombine_idle2.wav",
	"npc/zombine/zombine_idle3.wav",
}

ENT.SoundTbl_OnPlayerSight = {
	"npc/zombine/zombine_alert1.wav",
	"npc/zombine/zombine_alert2.wav",
	"npc/zombine/zombine_alert3.wav",
	"npc/zombine/zombine_alert4.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert7.wav",
}

ENT.SoundTbl_Alert = {
	"npc/zombine/zombine_alert1.wav",
	"npc/zombine/zombine_alert2.wav",
	"npc/zombine/zombine_alert3.wav",
	"npc/zombine/zombine_alert4.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert7.wav",
}

ENT.SoundTbl_Suppressing = {
	"npc/zombine/zombine_alert1.wav",
	"npc/zombine/zombine_alert2.wav",
	"npc/zombine/zombine_alert3.wav",
	"npc/zombine/zombine_alert4.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert7.wav",
}

ENT.SoundTbl_WeaponReload = {
	"npc/zombine/zombine_alert1.wav",
	"npc/zombine/zombine_alert2.wav",
	"npc/zombine/zombine_alert3.wav",
	"npc/zombine/zombine_alert4.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert7.wav",
}

ENT.SoundTbl_GrenadeAttack = {
	"npc/zombine/zombine_readygrenade1.wav",
	"npc/zombine/zombine_readygrenade2.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/zombine/zombine_pain1.wav",
	"npc/zombine/zombine_pain2.wav",
	"npc/zombine/zombine_pain3.wav",
	"npc/zombine/zombine_pain4.wav",
}

ENT.SoundTbl_Pain = {
	"npc/zombine/zombine_pain1.wav",
	"npc/zombine/zombine_pain2.wav",
	"npc/zombine/zombine_pain3.wav",
	"npc/zombine/zombine_pain4.wav",
}

ENT.SoundTbl_Death = {
	"npc/zombine/zombine_die1.wav",
	"npc/zombine/zombine_die2.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSpawnEffect(true)
	self:SetBodygroup(1,1)
	self:Give("weapon_vj_cets_psmg")

	self.gascan = ents.Create("obj_vj_cets_gascan_nd")
	self.gascan:SetPos( self:GetPos() + self:GetForward() * -8 + self:GetUp() * 68 + self:GetRight() * 0 )
	self.gascan:SetAngles( self:GetAngles() + Angle(0,0,0) )
	self.gascan:SetOwner(self)
	self.gascan:SetParent(self, self:LookupAttachment( "zipline" ))
	self.gascan:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.gascan:Spawn()
	self.gascan:Activate()

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.6, 1)
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	local Crabdrop = math.random(1,3)

	if Crabdrop == 1 or 2 then
		self:SetBodygroup(1,1)
	end 

	if Crabdrop == 3 then
		if dmginfo:IsDamageType(DMG_BLAST) or self:IsOnFire() then return false end
			self:SetBodygroup(1,0)
			self.Headcrab = ents.Create("npc_headcrab")
			self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
			self.Headcrab:SetAngles(self:GetAngles())
			self.Headcrab:Spawn()
			self.Headcrab:Activate() 
			self.Headcrab:SetOwner(self)
			self:SetGroundEntity(NULL)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	self:CreateGibEntity("physics_prop", "models/weapons/w_hl2psmg.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local psmg = ents.Create("item_ammo_ar2")
		psmg:SetPos(att.Pos)
		psmg:SetAngles(att.Ang)
		psmg:Spawn()
	end
end