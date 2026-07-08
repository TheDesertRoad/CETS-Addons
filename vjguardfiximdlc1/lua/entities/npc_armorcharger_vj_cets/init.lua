AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/armored_zombie_charger.mdl"}
ENT.StartHealth = GetConVar("sk_cets_armchz_health"):GetInt()
ENT.HullType = HULL_WIDE_HUMAN 
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.CanChatMessage = false
ENT.Passive_RunOnTouch = true
ENT.Passive_RunOnDamage = true
ENT.WaitForEnemyToComeOut = true
ENT.Medic_CanBeHealed = false 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow"
ENT.BloodParticle = "blood_impact_zombie_01"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 7

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
ENT.MeleeAttackDamage = 60
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 200
ENT.MeleeAttackKnockBack_Forward2 = 400

ENT.HasGrenadeAttack = false

ENT.MainSoundPitch = 70
ENT.FootStepSoundPitch = 100

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
	self:Give("weapon_vj_cets_hev_shot")

	self.wall = ents.Create("obj_vj_cets_generic_shit")
	self.wall:SetModel("models/misc/cube025x075x025.mdl")
	self.wall:SetPos( self:GetPos() + self:GetForward() * 18 + self:GetUp() * 62  + self:GetRight() * -18 )
	self.wall:SetAngles( self:GetAngles())
	self.wall:SetOwner(self)
	self.wall:SetNoDraw( true )
	self.wall:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall:Spawn()
	self.wall:Activate()

	self.wall2 = ents.Create("obj_vj_cets_generic_shit")
	self.wall2:SetModel("models/misc/cube025x075x025.mdl")
	self.wall2:SetPos( self:GetPos() + self:GetForward() * 2 + self:GetUp() * 60  + self:GetRight() * -18 )
	self.wall2:SetAngles( self:GetAngles())
	self.wall2:SetOwner(self)
	self.wall2:SetNoDraw( true )
	self.wall2:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall2:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall2:Spawn()
	self.wall2:Activate()

	self.wall3 = ents.Create("obj_vj_cets_generic_shit")
	self.wall3:SetModel("models/misc/cube025x075x025.mdl")
	self.wall3:SetPos( self:GetPos() + self:GetForward() * 10 + self:GetUp() * 62  + self:GetRight() * -18 )
	self.wall3:SetAngles( self:GetAngles())
	self.wall3:SetOwner(self)
	self.wall3:SetNoDraw( true )
	self.wall3:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall3:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall3:Spawn()
	self.wall3:Activate()

	self.wall4 = ents.Create("obj_vj_cets_generic_shit")
	self.wall4:SetModel("models/misc/cube025x075x025.mdl")
	self.wall4:SetPos( self:GetPos() + self:GetForward() * 10 + self:GetUp() * 52  + self:GetRight() * -18 )
	self.wall4:SetAngles( self:GetAngles())
	self.wall4:SetOwner(self)
	self.wall4:SetNoDraw( true )
	self.wall4:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall4:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall4:Spawn()
	self.wall4:Activate()

	self.wall5 = ents.Create("obj_vj_cets_generic_shit")
	self.wall5:SetModel("models/misc/cube025x075x025.mdl")
	self.wall5:SetPos( self:GetPos() + self:GetForward() * 18 + self:GetUp() * 52  + self:GetRight() * -18 )
	self.wall5:SetAngles( self:GetAngles())
	self.wall5:SetOwner(self)
	self.wall5:SetNoDraw( true )
	self.wall5:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall5:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall5:Spawn()
	self.wall5:Activate()

	self.wall6 = ents.Create("obj_vj_cets_generic_shit")
	self.wall6:SetModel("models/misc/cube025x075x025.mdl")
	self.wall6:SetPos( self:GetPos() + self:GetForward() * 10 + self:GetUp() * 66  + self:GetRight() * -18 )
	self.wall6:SetAngles( self:GetAngles())
	self.wall6:SetOwner(self)
	self.wall6:SetNoDraw( true )
	self.wall6:SetParent(self, self:LookupAttachment( "zipline" ))
	self.wall6:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.wall6:Spawn()
	self.wall6:Activate()

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
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	self:CreateGibEntity("physics_prop", "models/weapons/w_ishotgun.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ammo = ents.Create("item_ammo_ar2")
		ammo:SetPos(att.Pos)
		ammo:SetAngles(att.Ang)
		ammo:Spawn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	local Crabdrop = math.random(1, 3)

	if Crabdrop == 1 then
		self:SetBodygroup(1,1)
	end 

	if Crabdrop == 3 then
	if dmginfo:IsDamageType(DMG_BLAST) or self:IsOnFire() then return false end
		self:SetBodygroup(1,0)
		self.Headcrab = ents.Create("npc_armorhead_vj_cets")
		self.Headcrab:SetPos(self:GetPos()+ self:GetRight()*0  + self:GetForward()*-5 + self:GetUp()*50)
		self.Headcrab:SetAngles(self:GetAngles())
		self.Headcrab:Spawn()
		self.Headcrab:Activate() 
		self.Headcrab:SetOwner(self)
		self:SetGroundEntity(NULL)
	end
end