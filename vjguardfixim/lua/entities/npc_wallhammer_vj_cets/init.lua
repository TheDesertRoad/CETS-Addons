AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_wallhammer.mdl"}
ENT.StartHealth = 175
ENT.Weapon_Accuracy = 1.5
ENT.Weapon_MinDistance = 8 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 1500 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 80
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.TimeUntilGrenadeIsReleased = 0.82 -- Time until the grenade is released

ENT.AnimTbl_Medic_GiveHealth = {"harassfront1"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.5 -- Time until the ally receives health | Set to false to let the base decide the time

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations

ENT.MeleeAttackDamage = 10
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 200 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 400 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 12
ENT.MeleeAttackKnockBack_Up2 = 12
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.CanUseSecondaryOnWeaponAttack = false -- Can the NPC use a secondary fire if it's available?
ENT.ManhackChance = 1

ENT.ItemDropsOnDeath_EntityList = {
	"weapon_ply_comgr",
	"item_battery",
	"item_health_pen",
}

ENT.FootStepSoundPitch = 100
ENT.IdleSoundPitch = 80
ENT.IdleDialogueSoundPitch = 80
ENT.IdleDialogueAnswerSoundPitch = 80
ENT.CombatIdleSoundPitch = 80
ENT.InvestigateSoundPitch = 80
ENT.LostEnemySoundPitch = 80
ENT.AlertSoundPitch = 80
ENT.WeaponReloadSoundPitch = 80
ENT.GrenadeAttackSoundPitch = 80
ENT.OnGrenadeSightSoundPitch = 80
ENT.OnDangerSightSoundPitch = 80
ENT.OnKilledEnemySoundPitch = 80
ENT.AllyDeathSoundPitch = 80
ENT.PainSoundPitch = 80
ENT.DeathSoundPitch = 80

ENT.Metrocop_CanHaveManhack = FALSE
ENT.FlashDistance = 2000
ENT.NextRandomFlash = math.random(40, 400)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key): Deploy Manhack (if available)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.VJ_IsBeingControlled then return end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:IsOnFire() && CurTime() > self.NextDance then
		self.Bleeds = false
		timer.Simple(self:SequenceDuration(self:LookupSequence( "bugbait_hit" )), function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
		self:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
		self.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))
	end

	if IsValid(self:GetEnemy()) && self:GetPos():Distance(self:GetEnemy():GetPos()) < 1000 && self:GetPos():Distance(self:GetEnemy():GetPos()) > 100 && self:Visible(self:GetEnemy()) then
		--self.CallForHelp = true
		if self.NextRandomFlash != 0 then
			self.NextRandomFlash = self.NextRandomFlash - 1
		end
		if self.NextRandomFlash == 0 then
			self:CustomOnCallForHelp()
		end
	else
		---self.CallForHelp = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally)
	local fent = self:GetEnemy()

	self:VJ_ACT_PLAYACTIVITY("flash",true,1.8,false)
	self.NextRandomFlash = math.random(40, 400)
	VJ.EmitSound(self, "npc/wallhammer/flashbang_ready.wav", 100, 100)

	timer.Simple(1,function() if IsValid(self) && !self.IsDoingFlash then
		local glow1 = ents.Create("env_sprite")
		glow1:SetKeyValue("model", "sprites/blueflare1.spr")
		glow1:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
		glow1:SetKeyValue("renderfx", "14")
		glow1:SetKeyValue("scale", "1")
		glow1:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
		glow1:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
		glow1:Fire("Color", "255 255 255 255")
		glow1:SetKeyValue("spawnflags", "0")
		glow1:SetParent(self)
		glow1:Fire("SetParentAttachment", "shield_glow")
		glow1:Spawn()
		glow1:Activate()
		self:DeleteOnRemove(glow1)

		local FlashDynamicLight = ents.Create("light_dynamic")
		FlashDynamicLight:SetKeyValue("brightness", "4")
		FlashDynamicLight:SetKeyValue("distance", "128")
		FlashDynamicLight:SetLocalPos(self:GetPos())
		FlashDynamicLight:SetLocalAngles(self:GetAngles())
		FlashDynamicLight:Fire("Color", "255 255 255 255")
		FlashDynamicLight:SetParent(self)
		FlashDynamicLight:Spawn()
		FlashDynamicLight:Activate()
		FlashDynamicLight:SetParent(self)
		FlashDynamicLight:Fire("SetParentAttachment", "shield_glow")
		FlashDynamicLight:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(FlashDynamicLight)

		timer.Simple(1.2,function() if IsValid(self) then FlashDynamicLight:Remove() end end)
		timer.Simple(1.4,function() if IsValid(self) then glow1:Remove() end end)

		timer.Simple(1,function() if IsValid(self) then self.IsDoingFlash = false end end)
			VJ.EmitSound(self, "npc/wallhammer/flashbang.wav", 100, 100)
				if IsValid(self:GetEnemy()) && fent:IsPlayer() && self:Visible(self:GetEnemy()) && self:GetPos():Distance(fent:GetPos()) <= 800 then
					fent:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 255 ), 2, 2 )
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	local fent = self:GetEnemy()
	if status == "Init" then
		local randRange = math.random(1, 3)
		if randRange == 1 then
			self.TimeUntilMeleeAttackDamage = 0.2
			self.MeleeAttackDamage = 10
			self.NextAnyAttackTime_Melee = 0.5
			self.SoundTbl_MeleeAttackMiss = "Zombie.AttackMiss"
			self.AnimTbl_MeleeAttack = {"melee_gunhit"}
			self.SoundTbl_MeleeAttackExtra = "Flesh.ImpactHard"

		elseif randRange == 2 && GetConVar("sk_charger_stunbaton_chance"):GetInt() == 1 then
			self.TimeUntilMeleeAttackDamage = 0.6
			self.MeleeAttackDamage = 30
			self:SetBodygroup(1,1)
			self.NextAnyAttackTime_Melee = 1.6
			self.AnimTbl_MeleeAttack = {"melee_stunstick2"}
			self.SoundTbl_MeleeAttackExtra = {"weapons/stunstick/stunstick_fleshhit1.wav", "weapons/stunstick/stunstick_fleshhit2.wav"}
			self.SoundTbl_MeleeAttackMiss = {"weapons/stunstick/stunstick_swing1.wav", "weapons/stunstick/stunstick_swing2.wav"}
			timer.Simple(0.6,function() if IsValid(self) && fent:IsPlayer() then 
					local effectData = EffectData()
					effectData:SetOrigin(self:GetAttachment(1).Pos)
					util.Effect("StunstickImpact", effectData)
					util.Effect("TeslaHitBoxes", effectData)
				end
			end)

			timer.Simple(1.3,function() if IsValid(self) then 
					self:SetBodygroup(1,0) 
				end
			end)
		end

		elseif randRange == 3 && GetConVar("sk_charger_stunbaton_chance"):GetInt() == 1 then
			self.TimeUntilMeleeAttackDamage = 0.6
			self.MeleeAttackDamage = 20
			self:SetBodygroup(1,1)
			self.NextAnyAttackTime_Melee = 1.6
			self.AnimTbl_MeleeAttack = {"melee_stunstick"}
			self.SoundTbl_MeleeAttackExtra = {"weapons/stunstick/stunstick_fleshhit1.wav", "weapons/stunstick/stunstick_fleshhit2.wav"}
			self.SoundTbl_MeleeAttackMiss = {"weapons/stunstick/stunstick_swing1.wav", "weapons/stunstick/stunstick_swing2.wav"}
			timer.Simple(0.6,function() if IsValid(self) && fent:IsPlayer() then 
					local effectData = EffectData()
					effectData:SetOrigin(self:GetAttachment(1).Pos)
					util.Effect("StunstickImpact", effectData)
					util.Effect("TeslaHitBoxes", effectData)
				end
			end)

			timer.Simple(1.3,function() if IsValid(self) then 
					self:SetBodygroup(1,0) 
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath( dmginfo, hit_gr, rag )
	self:SetBodygroup(1, 0)
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
function ENT:CustomOnRemove()
	self:StopSound("npc/wallhammer/flashbang_ready.wav")
	self:StopSound("npc/wallhammer/flashbang.wav")
end