/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_cets_gascan"
ENT.PrintName		= "Explosive Gascan"
ENT.Author 			= "DrVrej"

ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.Active		= false

local PartEffGasLeak = "gascan_gasleak2"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local npc = self:GetParent()
	local DamageAttacker = dmginfo:GetAttacker()

	if !self.Active then
		if dmginfo:IsDamageType( DMG_BULLET ) or dmginfo:IsDamageType( DMG_CLUB ) or dmginfo:IsDamageType( DMG_SNIPER ) or dmginfo:IsDamageType( DMG_PHYSGUN ) or dmginfo:IsDamageType( DMG_BUCKSHOT ) then
			self.Active = true

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
			end
				
			timer.Simple(2.9,function() if IsValid(npc) then
				self:Explode(DamageAttacker)
			end end)
		end
	end
end