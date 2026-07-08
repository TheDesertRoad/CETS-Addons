AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_snarknest.mdl"
ENT.StartHealth = 10
ENT.HullType = HULL_SMALL
ENT.TurningUseAllAxis = true

ENT.CanChatMessage = false
ENT.ConstantlyFacingEnemy = true
ENT.TurningSpeed = 0

ENT.MovementType = VJ_MOVETYPE_STATIC
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_SNARK"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Green"
ENT.BloodDecal = "VJ_CETS_GBlood"
ENT.BloodParticle = "blood_impact_antlion_worker_01"
ENT.HasBloodParticle = true
ENT.HasBloodPool = false

ENT.HasDeathCorpse = false
ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS
ENT.DeathCorpseApplyForce = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = false

ENT.CanFlinch = false

ENT.SoundTbl_Idle = {"npc/squeek/sqk_hunt1.wav", "npc/squeek/sqk_hunt2.wav", "npc/squeek/sqk_hunt3.wav"}
ENT.SoundTbl_Death = {"npc/squeek/sqk_deploy1.wav"}

ENT.MainSoundLevel = 20
ENT.MainSoundPitch = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(5, 5, 8), Vector(-5, -5, 0))
	self:SetSpawnEffect(true)

	self.BlackAmount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		self.HasIdleSounds = false
		self.BlackAmount = math.min(self.BlackAmount + FrameTime() * 0.9, 1)
		timer.Simple(3, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	else
		self.HasIdleSounds = true
	end

	local value = math.Round(Lerp(self.BlackAmount, 255, 90))
	self:SetColor(Color(value, value, value, 255))

	self:AddFlags(FL_NOTARGET)
	self:RemoveFlags(FL_AIMTARGET)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTouch(ent)
	if (ent:IsPlayer() or ent:IsNPC()) then
		self:TakeDamage(self:Health() + 1, ent, ent)
		VJ.EmitSound(self, "npc/antlion_grub/explode.wav", 60, 70)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self, "npc/squeek/sqk_blast1.wav", 50, 80)
	VJ_EmitSound(self, "phx/eggcrack.wav", 100, 70)
	util.VJ_SphereDamage(self,self,self:GetPos(),80,23,DMG_ACID,true,true)
	ParticleEffect("gas_misc_cets2",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("gas_misc_cets2",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_slime",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsA",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)
	ParticleEffect("antlion_gib_02_trailsB",self:GetPos() + self:GetUp()* 10,Angle(0,0,0),nil)

	self.Sq = ents.Create("npc_snark_vj_cets")
	self.Sq:SetPos(self:GetPos()+ self:GetRight()*-15  + self:GetForward()*15 + self:GetUp()*35)
	self.Sq:Spawn()
	self.Sq:SetAngles(self:GetAngles())
	self.Sq:SetVelocity(self:GetUp()*math.Rand(250, 350) + self:GetRight()*math.Rand(-100, 100) + self:GetForward()*math.Rand(-100, 100))
	self.Sq:Activate() 
	self.Sq:SetOwner(self)
	self:SetGroundEntity(NULL)

	self.Sq1 = ents.Create("npc_snark_vj_cets")
	self.Sq1:SetPos(self:GetPos()+ self:GetRight()*-15  + self:GetForward()*-15 + self:GetUp()*35)
	self.Sq1:Spawn()
	self.Sq1:SetAngles(self:GetAngles())
	self.Sq1:SetVelocity(self:GetUp()*math.Rand(250, 350) + self:GetRight()*math.Rand(-100, 100) + self:GetForward()*math.Rand(-100, 100))
	self.Sq1:Activate() 
	self.Sq1:SetOwner(self)
	self:SetGroundEntity(NULL)

	self.Sq2 = ents.Create("npc_snark_vj_cets")
	self.Sq2:SetPos(self:GetPos()+ self:GetRight()*15  + self:GetForward()*-15 + self:GetUp()*35)
	self.Sq2:Spawn()
	self.Sq2:SetAngles(self:GetAngles())
	self.Sq2:Activate() 
	self.Sq2:SetVelocity(self:GetUp()*math.Rand(250, 350) + self:GetRight()*math.Rand(-100, 100) + self:GetForward()*math.Rand(-100, 100))
	self.Sq2:SetOwner(self)
	self:SetGroundEntity(NULL)

	self.Sq3 = ents.Create("npc_snark_vj_cets")
	self.Sq3:SetPos(self:GetPos()+ self:GetRight()*15  + self:GetForward()*15 + self:GetUp()*35)
	self.Sq3:Spawn()
	self.Sq3:SetAngles(self:GetAngles())
	self.Sq3:SetVelocity(self:GetUp()*math.Rand(250, 350) + self:GetRight()*math.Rand(-100, 100) + self:GetForward()*math.Rand(-100, 100))
	self.Sq3:Activate() 
	self.Sq3:SetOwner(self)
	self:SetGroundEntity(NULL)
end