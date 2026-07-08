/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_cets_gascan_x2"
ENT.PrintName		= "Explosive Gascan"
ENT.Author 			= "DrVrej"

ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.Active		= false

local PartEffGasLeak = "gascan_gasleak1"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local npc = self:GetParent()
	local DamageAttacker = dmginfo:GetAttacker()
	
	if !self.Active then
		if dmginfo:IsDamageType( DMG_BULLET ) or dmginfo:IsDamageType( DMG_CLUB ) or dmginfo:IsDamageType( DMG_SNIPER ) or dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_BUCKSHOT ) then
			self.Active = true
			npc:Comb_ResetFlame()
			npc.Comb_CanFlame = false
			npc.Comb_FlameLevel = 0

			npc:EmitSound("ambient/fire/ignite.wav")

		if self:WaterLevel() > 1 then 
			ParticleEffectAttach("gascan_gasleak3",PATTACH_ABSORIGIN_FOLLOW,self,0)
		else
			ParticleEffectAttach("fire_small_02",PATTACH_ABSORIGIN_FOLLOW,self,0)
			ParticleEffectAttach(PartEffGasLeak,PATTACH_ABSORIGIN_FOLLOW,self,0)

			npc.FireLight1 = ents.Create("light_dynamic")
			npc.FireLight1:SetKeyValue("brightness", "0.5")
			npc.FireLight1:SetKeyValue("distance", "128")
			npc.FireLight1:SetLocalPos(npc:GetPos() + npc:GetUp() * 56)
			npc.FireLight1:SetLocalAngles( npc:GetAngles())
			npc.FireLight1:Fire("Color", "255 128 0")
			npc.FireLight1:SetParent(npc)
			npc.FireLight1:Spawn()
			npc.FireLight1:Activate()
			npc.FireLight1:Fire("TurnOn", "", 0)
		end

			npc:EmitSound("npc/misc/gas_leak.wav", 90, math.random(90, 110))
				
			if npc:IsNPC() then
					VJ_EmitSound(npc,npc.SoundTbl_Hurt,80,100)
										
					npc.MovementType = VJ_MOVETYPE_STATIONARY
					npc.AttackType = VJ.ATTACK_TYPE_CUSTOM	

					npc:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
					npc:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
					npc.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))

					npc.CanTurnWhileStationary = false
					npc.HasMeleeAttack = false
					npc.HasRangeAttack = false
					npc.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
					npc.Weapon_Disabled = true
					npc.HasGrenadeAttack = false
					npc.DamageResponse = false
					npc.DamageAllyResponse = false
					npc.CombatDamageResponse = false
					npc.CanDetectDangers = false
					npc.NextProcessTime = 0
					npc.EnemyDetection = false
					npc:StopSound("weapons/flamethrow/flame_thrower_start.wav")
					npc:StopSound("weapons/flamethrow/flame_thrower_loop.wav")

					npc:Comb_ResetFlame()
					npc.Comb_CanFlame = false
					npc.Comb_FlameLevel = 0

					timer.Simple(0.1,function() if IsValid(npc) then
						npc:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
						npc:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
						npc.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))
					end end)
				end

				timer.Simple(2.9,function() if IsValid(npc) then
					self:Explode(DamageAttacker)
				end end)
			end
		end
	end
