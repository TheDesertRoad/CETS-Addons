AddCSLuaFile("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Acid Spit"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/vj_base/projectiles/spit_acid_large.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true
ENT.DirectDamage = 12	
ENT.DirectDamageType = DMG_SHOCK
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.CollisionDecal = "VJ_CETS_Burnt1_Small"

ENT.IdleSoundPitch = VJ.SET(90,110)
ENT.OnCollideSoundPitch = VJ.SET(95,105)

ENT.SoundTbl_Idle = {"ambient/energy/electric_loop.wav"}
ENT.SoundTbl_OnCollide = {"npc/alien_controller/energyorb_exp.wav", "npc/alien_controller/energyorb_exp2.wav", "npc/alien_controller/energyorb_exp3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	ParticleEffect("racex_arc_03_gas",self:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("electric_trails_reviver_b",self:GetPos(),Angle(0,0,0),nil)

	if self:WaterLevel() > 0 then 
		self:Remove()
	else
		self:SetNoDraw(false)
		ParticleEffectAttach("electric_trails_reviver",PATTACH_ABSORIGIN_FOLLOW,self,0)
		util.SpriteTrail(self, 1, Color(32, 128, 255, 64), true, 40, 0, 0.6, 1 / 12 * 0.5, "particle/bendibeam.vmt")
		self:SetAngles(self:GetVelocity():GetNormal():Angle())
		self:SetColor(Color(0, 0, 255, 72))
		self:SetRenderMode(RENDERMODE_GLOW)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:WaterLevel() > 0 then 
		local pos = self:GetPos() +self:GetAngles():Forward()
		effects.BubbleTrail(pos +Vector(-1, -1, -1), pos +Vector(1, 1, 1), math.random(0.3, 0.8), 0, 6, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("racex_arc_03_gas",data.HitPos,Angle(0,0,0),nil)
end