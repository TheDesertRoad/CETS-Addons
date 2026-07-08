AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/humans/blackops/hassassin.mdl"
ENT.StartHealth = 60
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_MinDistance = 20 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 4000 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 0 -- Minimum distance an enemy has to be for it to retreat back | 0 = Never retreat
ENT.Weapon_Accuracy = 0.05 -- Its accuracy with weapons, affects bullet spread! | x < 1 = Better accuracy | x > 1 = Worse accuracy
ENT.Weapon_CanMoveFire = false -- Can it fire its weapon while it's moving?
ENT.Weapon_CanReload = true -- Can it reload weapons?
ENT.Weapon_IgnoreSpawnMenu = true
ENT.Weapon_Strafe = false

ENT.DisableWeaponReloadAnimation = true

ENT.CanChatMessage = false
ENT.CanTurnWhileMoving = false
ENT.JumpParams = {
	Enabled = true, -- Can it do movement jumps?
	MaxRise = 620,
	MaxDrop = 620,
	MaxDistance = 620
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanDetectDangers = true -- Can it detect dangers? | Ex: Grenades, fire, bombs, explosives, etc.
ENT.DangerDetectionDistance = 400 -- Max danger detection distance | WARNING: Most of the non-grenade dangers ignore this max value

ENT.ConstantlyFaceEnemy = true--false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?

ENT.DamageResponse = true -- Should it respond to damages while it has no enemy?
ENT.AnimTbl_DamageAllyResponse = ACT_SIGNAL_GROUP -- Animations to play when it calls allies to respond | false = Don't play an animation
ENT.DamageAllyResponse_Cooldown = VJ.SET(9, 12) -- How long until it can call allies again?
ENT.DamageAllyResponse = true -- Should allies respond when it's damaged while it has no enemy?

ENT.AnimTbl_CallForHelp = false
ENT.DisableFootStepSoundTimer = true

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 15
ENT.AnimTbl_MeleeAttack = {"melee1", "melee2"}
ENT.MeleeAttackDistance = 55
ENT.MeleeAttackDamageDistance = 100

ENT.Assassin_NextJumpT = 0
ENT.Assassin_OffGround = false
ENT.Assassin_NextCloakT = GetConVar("sk_fassassin_cloak_time"):GetInt()
ENT.Assassin_Cloaking = false
ENT.Assassin_ControllerCloakLevel = 0
ENT.Assassin_NextDodgeT = CurTime()
ENT.Assassin_NextDodge2T = CurTime()

ENT.MainSoundPitch = VJ.SET(120,130)

ENT.SoundTbl_Idle = {
	"npc/fempolice/vo/dispupdatingapb.wav",
	"npc/fempolice/vo/pickingupnoncorplexindy.wav",
	"npc/fempolice/vo/ten97suspectisgoa.wav",
	"npc/fempolice/vo/stillgetting647e.wav",
	"npc/fempolice/vo/404zone.wav",
	"npc/fempolice/vo/standardloyaltycheck.wav",
	"npc/fempolice/vo/anyonepickup647e.wav",
	"npc/fempolice/vo/blockisholdingcohesive.wav",
	"npc/fempolice/vo/checkformiscount.wav",
	"npc/fempolice/vo/catchthatbliponstabilization.wav",
	"npc/fempolice/vo/clearandcode100.wav",
	"npc/fempolice/vo/clearno647no10-107.wav",
	"npc/fempolice/vo/classifyasdbthisblockready.wav",
	"npc/fempolice/vo/control100percent.wav",
	"npc/fempolice/vo/cprequestsallunitsreportin.wav",
	"npc/fempolice/vo/dispreportssuspectincursion.wav",
	"npc/fempolice/vo/wegotadbherecancel10-102.wav",
	"npc/fempolice/vo/localcptreportstatus.wav",
	"npc/fempolice/vo/novisualonupi.wav",
	"npc/fempolice/vo/loyaltycheckfailure.wav",
}

ENT.SoundTbl_IdleDialogue = ENT.SoundTbl_Idle

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/fempolice/vo/rodgerthat.wav",
}

ENT.SoundTbl_Investigate = {
	"npc/fempolice/vo/requestsecondaryviscerator.wav",
	"npc/fempolice/vo/goingtotakealook.wav",
	"npc/fempolice/vo/movetoarrestpositions.wav",
	"npc/fempolice/vo/investigating10-103.wav",
	"npc/fempolice/vo/readytoamputate.wav",
	"npc/fempolice/vo/readytojudge.wav",
	"npc/fempolice/vo/preparingtojudge10-107.wav",
	"npc/fempolice/vo/prepareforjudgement.wav",
	"npc/fempolice/vo/possible10-103alerttagunits.wav",
	"npc/fempolice/vo/possible404here.wav",
	"npc/fempolice/vo/possiblelevel3civilprivacyviolator.wav",
	"npc/fempolice/vo/possible647erequestairwatch.wav",
	"npc/fempolice/vo/positiontocontain.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/fempolice/vo/airwatchsubjectis505.wav",
	"npc/fempolice/vo/assaultpointsecureadvance.wav",
	"npc/fempolice/vo/breakhiscover.wav",
	"npc/fempolice/vo/covermegoingin.wav",
	"npc/fempolice/vo/destroythatcover.wav",
	"npc/fempolice/vo/firingtoexposetarget.wav",
	"npc/fempolice/vo/lockyourposition.wav",
	"npc/fempolice/vo/holdthisposition.wav",
	"npc/fempolice/vo/teaminpositionadvance.wav",
}

ENT.SoundTbl_Alert = {
	"npc/fempolice/vo/allunitscloseonsuspect.wav",
	"npc/fempolice/vo/allunitsmovein.wav",
	"npc/fempolice/vo/contactwith243suspect.wav",
	"npc/fempolice/vo/criminaltrespass63.wav",
	"npc/fempolice/vo/get11-44inboundcleaningup.wav",
	"npc/fempolice/vo/unlawfulentry603.wav",
	"npc/fempolice/vo/malcompliant10107my1020.wav",
	"npc/fempolice/vo/level3civilprivacyviolator.wav",
	"npc/fempolice/vo/ivegot408hereatlocation.wav",
	"npc/fempolice/vo/ihave10-30my10-20responding.wav",
	"npc/fempolice/vo/readytoprosecute.wav",
	"npc/fempolice/vo/priority2anticitizenhere.wav",
	"npc/fempolice/vo/gota10-107sendairwatch.wav",
}

ENT.SoundTbl_WeaponReload = {
	"npc/fempolice/vo/runninglowonverdicts.wav",
	"npc/fempolice/vo/backmeupimout.wav",
	"npc/fempolice/vo/movingtocover.wav",
	"npc/fempolice/vo/finalverdictadministered.wav",
}

ENT.SoundTbl_OnDangerSight = {
	"npc/fempolice/vo/lookout.wav",
	"npc/fempolice/vo/shit.wav",
	"npc/fempolice/vo/takecover.wav",
	"npc/fempolice/vo/getdown.wav",
}

ENT.SoundTbl_OnGrenadeSight = {
	"npc/fempolice/vo/thatsagrenade.wav",
	"npc/fempolice/vo/grenade.wav"
}

ENT.SoundTbl_OnKilledEnemy = {
	"npc/fempolice/vo/chuckle.wav",
	"npc/fempolice/vo/suspectisbleeding.wav",
	"npc/fempolice/vo/sentencedelivered.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/fempolice/vo/11-99officerneedsassistance.wav",
	"npc/fempolice/vo/wehavea10-108.wav",
	"npc/fempolice/vo/reinforcementteamscode3.wav",
	"npc/fempolice/vo/officerneedshelp.wav",
	"npc/fempolice/vo/officerunderfiretakingcover.wav",
	"npc/fempolice/vo/officerneedsassistance.wav",
	"npc/fempolice/vo/officerdowniam10-99.wav",
	"npc/fempolice/vo/officerdowncode3tomy10-20.wav",
	"npc/fempolice/vo/cpiscompromised.wav",
	"npc/fempolice/vo/cpisoverrunwehavenocontainment.wav",
	"npc/fempolice/vo/minorhitscontinuing.wav",
}

ENT.SoundTbl_LostEnemy = {
	"npc/fempolice/vo/hidinglastseenatrange.wav",
	"npc/fempolice/vo/hesgone148.wav",
	"npc/fempolice/vo/searchingforsuspect.wav",
	"npc/fempolice/vo/suspectlocationunknown.wav",
}

ENT.SoundTbl_Death = {
	"npc/fempolice/die1.wav",
	"npc/fempolice/die2.wav",
	"npc/fempolice/die3.wav",
	"npc/fempolice/die4.wav",
}

ENT.SoundTbl_Hurt = {"npc/fempolice/vo/help.wav"}

ENT.SoundTbl_Pain = {
	"npc/fempolice/pain1.wav",
	"npc/fempolice/pain2.wav",
	"npc/fempolice/pain3.wav",
	"npc/fempolice/pain4.wav",
	"npc/fempolice/vo/help.wav",
}

ENT.SoundTbl_RadioOn = {
 	"npc/fempolice/vo/on1.wav",
	"npc/fempolice/vo/on2.wav",
}

ENT.SoundTbl_RadioOff = {
	"npc/fempolice/vo/off1.wav",
	"npc/fempolice/vo/off2.wav",
	"npc/fempolice/vo/off3.wav",
	"npc/fempolice/vo/off4.wav",
}

ENT.SoundTbl_CombatIdle = "npc/fempolice/takedown.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.MainSoundLevel = 20
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(8, 8, 60), Vector(-8, -8, 0))

	util.SpriteTrail(self, 5, Color(255, 0, 0), true, 3, 0, 0.3, 1 /(25 +1) *0.5, "sprites/laserbeam")

	local spriteGlow = ents.Create("env_sprite")
		spriteGlow:SetKeyValue("rendercolor", "255 0 0")
		spriteGlow:SetKeyValue("GlowProxySize", "1.0")
		spriteGlow:SetKeyValue("HDRColorScale", "1.0")
		spriteGlow:SetKeyValue("renderfx", "14")
		spriteGlow:SetKeyValue("rendermode", "3")
		spriteGlow:SetKeyValue("renderamt", "255")
		spriteGlow:SetKeyValue("disablereceiveshadows", "0")
		spriteGlow:SetKeyValue("mindxlevel", "0")
		spriteGlow:SetKeyValue("maxdxlevel", "0")
		spriteGlow:SetKeyValue("framerate", "10.0")
		spriteGlow:SetKeyValue("model", "VJ_Base/sprites/glow.vmt")
		spriteGlow:SetKeyValue("spawnflags", "0")
		spriteGlow:SetKeyValue("scale", "0.07")
		spriteGlow:SetParent(self)
		spriteGlow:Fire("SetParentAttachment", "eye")
		spriteGlow:Spawn()

	self:DeleteOnRemove(spriteGlow)
	self:Give("weapon_vj_cets_dualpistol")

	timer.Simple(10, function() if IsValid(self) then self:SetRenderMode(RENDERMODE_TRANSALPHA) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:IsOnFire() then
		self.Bleeds = false
		timer.Simple(6, function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end

	if self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_RELOAD) then
		self.VJ_TheController:PrintMessage(HUD_PRINTCENTER, "Changing Camouflage!")
		if self.Assassin_ControllerCloakLevel == 0 then
			self.Assassin_ControllerCloakLevel = 1
			self:ASSASSIN_DOCLOAK()
		elseif self.Assassin_ControllerCloakLevel == 1 then
			self.Assassin_ControllerCloakLevel = 0
			self:ASSASSIN_RESETCLOAK()
		end
	end

	if !self.VJ_IsBeingControlled then
			if IsValid(self:GetEnemy()) then
				if CurTime() > self.Assassin_NextCloakT then
					self:ASSASSIN_DOCLOAK()
				end

			elseif self:GetNPCState() != NPC_STATE_ALERT && self:GetNPCState() != NPC_STATE_COMBAT then
				if self.Assassin_Cloaking == true then self:ASSASSIN_RESETCLOAK() end
		end
	end

	if self.Assassin_OffGround == true then
		if self:GetVelocity().z == 0 then
			self.Assassin_OffGround = false
			self:ClearSchedule()
			self:StopMoving()
			self:PlayAnim("jumpland", true, false, false)
			self.AnimTbl_IdleStand = {ACT_IDLE}
		else
			if self:GetActivity() != ACT_GLIDE then
				self:PlayAnim(ACT_GLIDE, true, false, false)
			end
		end
	end

	if (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP) or IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled && CurTime() > self.Assassin_NextDodgeT && !self:IsMoving() && !self:Dodge() && !self:Dodge2() && self:GetPos():Distance(self:GetEnemy():GetPos()) < 750) && self:IsOnGround() then--if (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP) or validEnt && !self.VJ_IsBeingControlled && CurTime() > self.Assassin_NextDodgeT && !self:IsMoving() && self:GetPos():Distance(self:GetEnemy():GetPos()) < 1100) && self:IsOnGround() then
		self:Dodge()
	end

	if validEnt && self.WeaponAttackState == self.VJ_IsBeingControlled == false && CurTime() > self.Assassin_NextJumpT && !self:IsMoving() && self:GetPos():Distance(self:GetEnemy():GetPos()) < 1400 then
		self:StopMoving()
		self:SetGroundEntity(NULL)

		if math.random(1, 2) == 1 then
			self:SetLocalVelocity(((self:GetPos() + self:GetRight()*100) - (self:GetPos() + self:OBBCenter())):GetNormal()*200 +self:GetForward()*1 +self:GetUp()*500 + self:GetRight()*1)--self:GetUp()*600
		else
			self:SetLocalVelocity(((self:GetPos() + self:GetRight()*-100) - (self:GetPos() + self:OBBCenter())):GetNormal()*200 +self:GetForward()*1 +self:GetUp()*500 + self:GetRight()*1)--self:GetUp()*600
		end

		self.AnimTbl_IdleStand = {ACT_GLIDE}
		self:PlayAnim(ACT_JUMP, true, false, true, 0, {}, function(sched)
			self.Assassin_OffGround = true
			self:PlayAnim(ACT_GLIDE, true, false, false)
		end)

		self.Assassin_NextJumpT = CurTime() + 8
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "Foot" then
		VJ.EmitSound(self, "npc/footsteps/hardboot_generic2.wav", 72, 100)
		VJ.EmitSound(self, {"npc/stalker/stalker_footstep_left1.wav", "npc/stalker/stalker_footstep_left2.wav", "npc/stalker/stalker_footstep_right1.wav", "npc/stalker/stalker_footstep_right2.wav"}, 75)
	end
	if key == "left" or key == "right" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep.CurrentMuzzle = key
		end
	end
	if string.StartWith(key, "melee") then
		self:ExecuteMeleeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_BeforeMeleeAttack, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Pain, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Death, sdFile) then return end
	VJ.EmitSound(self, "npc/fempolice/vo/on" .. math.random(1, 2) .. ".wav", 90, 100)
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self, "npc/fempolice/vo/off" .. math.random(1, 3) .. ".wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ASSASSIN_RESETCLOAK()
	self.Assassin_Cloaking = false
	self:SetColor(Color(255, 255, 255, 255))
	self:DrawShadow(true)
	self:RemoveFlags(FL_NOTARGET)
	VJ.EmitSound(self, "buttons/combine_button5.wav", 72, 100)
	local curWep = self:GetActiveWeapon()
	if IsValid(curWep) then
		if IsValid(self.SecondGun) then
			self.SecondGun:SetColor(colorVis)
			self.SecondGun:DrawShadow(true)
		end
		curWep:SetDrawWorldModel(true)
	end
	if self.VJ_IsBeingControlled == false then
		timer.Simple(math.random(5, 10), function() if IsValid(self) then self:ASSASSIN_DOCLOAK() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ASSASSIN_DOCLOAK()
	self.Assassin_Cloaking = true
	self:AddFlags(FL_NOTARGET)
	self:SetColor(Color(255, 255, 255, 16))
	self:DrawShadow(true)
	local curWep = self:GetActiveWeapon()
	if IsValid(curWep) then
		if IsValid(self.SecondGun) then
			self.SecondGun:SetColor(colorInv)
			self.SecondGun:DrawShadow(false)
		end
		curWep:SetDrawWorldModel(false)
	end
	if self.VJ_IsBeingControlled == false then
		timer.Simple(math.random(10, 30), function() if IsValid(self) then self:ASSASSIN_RESETCLOAK() end end)
	end
	self.Assassin_NextCloakT = CurTime() + math.random(5, 10)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponCanFire()
	if self.Assassin_OffGround == true then return false end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFireBullet(data)
	self.Assassin_CloakLevel = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dodge()
	if !self:IsBusy() then
		if self.VJ_IsBeingControlled then
			local ply = self.VJ_TheController
			self:PlayAnim((ply:KeyDown(IN_MOVELEFT) && "flip_l") or (ply:KeyDown(IN_MOVERIGHT) && "flip_r") or (ply:KeyDown(IN_FORWARD) && "flip_front") or "flip_front", true, false, true)
			self.Assassin_NextDodgeT = CurTime() +math.Rand(2, 6)--math.Rand(2, 6)
		else
			local checkdist = self:VJ_CheckAllFourSides(400)
			local randmove = {}
			if checkdist.Backward == true then randmove[#randmove+1] = "Backward" end
			if checkdist.Right == true then randmove[#randmove+1] = "Right" end
			if checkdist.Left == true then randmove[#randmove+1] = "Left" end
			if checkdist.Forward == true then randmove[#randmove+1] = "Forward" end
			local pickmove = VJ.PICK(randmove)
			local anim = "flipback"
			if pickmove == "Right" then anim = "FlipRight" end
			if pickmove == "Left" then anim = "FlipLeft" end
			if pickmove == "Forward" then anim = "FlipForwardB" end
			if type(pickmove) == "table" && #pickmove == 4 then
				anim = VJ.PICK({"flip_front", "flip_r", "flip_l", "flip_front"})
			end
			if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
				self:PlayAnim(anim, true, false, true)
				self.Assassin_NextDodgeT = CurTime() +math.Rand(2, 2)--math.Rand(2, 6)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dodge2()
	if !self:IsBusy() then
		if self.VJ_IsBeingControlled then
			local ply = self.VJ_TheController
			self:PlayAnim((ply:KeyDown(IN_MOVELEFT) && "flip_l") or (ply:KeyDown(IN_MOVERIGHT) && "flip_r") or (ply:KeyDown(IN_FORWARD) && "flip_front") or "flip_front", true, false, true)
			self.Assassin_NextDodge2T = CurTime() +math.Rand(2, 6)--math.Rand(2, 6)
		else
			local checkdist = self:VJ_CheckAllFourSides(400)
			local randmove = {}
			if checkdist.Backward == true then randmove[#randmove+1] = "Backward" end
			if checkdist.Right == true then randmove[#randmove+1] = "Right" end
			if checkdist.Left == true then randmove[#randmove+1] = "Left" end
			if checkdist.Forward == true then randmove[#randmove+1] = "Forward" end
			local pickmove = VJ.PICK(randmove)
			local anim = "flipback"
			if pickmove == "Right" then anim = "FlipRight" end
			if pickmove == "Left" then anim = "FlipLeft" end
			if pickmove == "Forward" then anim = "FlipForwardB" end
			if type(pickmove) == "table" && #pickmove == 4 then
				anim = VJ.PICK({"flip_front", "flip_r", "flip_l", "flip_front"})
			end

			if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
				self:PlayAnim(anim, true, false, true)
				self.Assassin_NextDodge2T = CurTime() +math.Rand(1, 1)--math.Rand(2, 6)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnBleed(dmginfo, hitgroup)
	if !self.VJ_IsBeingControlled && CurTime() > self.Assassin_NextDodge2T && !self:IsMoving() && !self:Dodge() && !self:Dodge2() && self:IsOnGround() then--if !self.VJ_IsBeingControlled && CurTime() > self.Assassin_NextDodge2T && !self:IsMoving() && self:IsOnGround() then
		self:Dodge()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		self.Assassin_Cloaking = false
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathCorpse(dmginfo, hitgroup)
	local vj_npc_corpse_undo = GetConVar("vj_npc_corpse_undo")
	local vj_npc_corpse_fade = GetConVar("vj_npc_corpse_fade")
	local vj_npc_corpse_fadetime = GetConVar("vj_npc_corpse_fadetime")
	local ai_serverragdolls = GetConVar("ai_serverragdolls")
	local math_min = math.min
	local math_max = math.max
	local math_rad = math.rad
	local math_cos = math.cos
	local math_angApproach = math.ApproachAngle
	local colorGrey = Color(255, 255, 255)
		-- NOTE: dmginfo at this point can be incorrect/corrupted, but its better than leaving the self.SavedDmgInfo empty!
	if !self.SavedDmgInfo then
		self.SavedDmgInfo = {
			dmginfo = dmginfo, -- The actual CTakeDamageInfo object | WARNING: Can be corrupted after a tick, recommended not to use this!
			attacker = dmginfo:GetAttacker(),
			inflictor = dmginfo:GetInflictor(),
			amount = dmginfo:GetDamage(),
			pos = dmginfo:GetDamagePosition(),
			type = dmginfo:GetDamageType(),
			force = dmginfo:GetDamageForce(),
			ammoType = dmginfo:GetAmmoType(),
			hitgroup = hitgroup,
		}
	end
	
	if self.HasDeathCorpse && self.HasDeathRagdoll != false then
		local corpseMdl = self:GetModel()
		if corpseMdlCustom then corpseMdl = corpseMdlCustom end
		local corpseClass = "prop_physics"
		if self.DeathCorpseEntityClass then
			corpseClass = self.DeathCorpseEntityClass
		else
			if util.IsValidRagdoll(corpseMdl) then
				corpseClass = "prop_ragdoll"
			elseif !util.IsValidProp(corpseMdl) or !util.IsValidModel(corpseMdl) then
				if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end
				return false
			end
		end
		self.Corpse = ents.Create(corpseClass)
		local corpse = self.Corpse
		corpse:SetModel(corpseMdl)
		corpse:SetPos(self:GetPos())
		corpse:SetAngles(self:GetAngles())
		corpse:Spawn()
		corpse:Activate()
		corpse:SetSkin(self:GetSkin())
		for i = 0, self:GetNumBodyGroups() do
			corpse:SetBodygroup(i, self:GetBodygroup(i))
		end
		corpse:SetColor(self:GetColor())
		corpse:SetMaterial(self:GetMaterial())
		if !corpseMdlCustom && self.DeathCorpseSubMaterials then -- Take care of sub materials
			for _, x in ipairs(self.DeathCorpseSubMaterials) do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end
			 -- This causes lag, not a very good way to do it.
			/*for x = 0, #self:GetMaterials() do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end*/
		end
		//corpse:SetName("corpse" .. self:EntIndex())
		//corpse:SetModelScale(self:GetModelScale())
		corpse.FadeCorpseType = (corpse:GetClass() == "prop_ragdoll" and "FadeAndRemove") or "kill"
		corpse.IsVJBaseCorpse = true
		corpse.DamageInfo = dmginfo
		corpse.ChildEnts = self.DeathCorpse_ChildEnts or {}
		corpse.BloodData = {Color = self.BloodColor, Particle = self.BloodParticle, Decal = self.BloodDecal}

		if self.Bleeds && self.HasBloodPool && vj_npc_blood_pool:GetInt() == 1 then
			self:SpawnBloodPool(dmginfo, hitgroup, corpse)
		end
		
		-- Collision
		corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if ai_serverragdolls:GetInt() == 1 then
			undo.ReplaceEntity(self, corpse)
		else -- Keep corpses is not enabled...
			VJ.Corpse_Add(corpse)
			if vj_npc_corpse_undo:GetInt() == 1 then undo.ReplaceEntity(self, corpse) end -- Undoable
		end
		cleanup.ReplaceEntity(self, corpse) -- Delete on cleanup
		
		-- On fire
		if self:IsOnFire() then
			if !self.Immune_Fire then -- Don't darken the corpse if we are immune to fire!
				corpse:SetColor(colorGrey)
				//corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
			end
		end
		
		-- Dissolve
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			corpse:Dissolve(0, 1)
		end
		
		-- Bone and Angle
		-- If it's a bullet, it will use localized velocity on each bone depending on how far away the bone is from the dmg position
		local useLocalVel = (bit.band(self.SavedDmgInfo.type, DMG_BULLET) != 0 and self.SavedDmgInfo.pos != defPos) or false
		local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if self.DeathAnimationCodeRan then
			useLocalVel = false
			dmgForce = self:GetGroundSpeedVelocity()
		end
		local totalSurface = 0
		local physCount = corpse:GetPhysicsObjectCount()
		for childNum = 0, physCount - 1 do -- 128 = Bone Limit
			local childPhysObj = corpse:GetPhysicsObjectNum(childNum)
			if IsValid(childPhysObj) then
				totalSurface = totalSurface + childPhysObj:GetSurfaceArea()
				local childPhysObj_BonePos, childPhysObj_BoneAng = self:GetBonePosition(corpse:TranslatePhysBoneToBone(childNum))
				if childPhysObj_BonePos then
					if self.DeathCorpseSetBoneAngles then childPhysObj:SetAngles(childPhysObj_BoneAng) end
					childPhysObj:SetPos(childPhysObj_BonePos)
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and childPhysObj_BonePos:Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				-- If it's 1, then it's likely a regular physics model with no bones
				elseif physCount == 1 then
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and corpse:GetPos():Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				end
			end
		end
		
		-- Health & stink system
		if corpse:Health() <= 0 then
			local hpCalc = totalSurface / 60
			corpse:SetMaxHealth(hpCalc)
			corpse:SetHealth(hpCalc)
		end
		VJ.Corpse_AddStinky(corpse, true)
		
		if IsValid(self.WeaponEntity) then corpse.ChildEnts[#corpse.ChildEnts + 1] = self.WeaponEntity end
		if self.DeathCorpseFade then corpse:Fire(corpse.FadeCorpseType, nil, self.DeathCorpseFade) end
		if vj_npc_corpse_fade:GetInt() == 1 then corpse:Fire(corpse.FadeCorpseType, nil, vj_npc_corpse_fadetime:GetInt()) end
		self:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
		if corpse:IsFlagSet(FL_DISSOLVING) then
			if IsValid(self.WeaponEntity) then
				self.WeaponEntity:Dissolve(0, 1)
			end
			if corpse.ChildEnts then
				for _, child in ipairs(corpse.ChildEnts) do
					child:Dissolve(0, 1)
				end
			end
		end
		corpse:CallOnRemove("vj_" .. corpse:EntIndex(), function(ent, childPieces)
			for _, child in ipairs(childPieces) do
				if IsValid(child) then
					if child:GetClass() == "prop_ragdoll" then -- Make ragdolls fade
						child:Fire("FadeAndRemove")
					else
						child:Fire("kill")
					end
				end
			end
		end, corpse.ChildEnts)
		hook.Call("CreateEntityRagdoll", nil, self, corpse)
		return corpse
	else
		if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end -- Remove dropped weapon
		-- Remove child entities | No fade effects as it will look weird, remove it instantly!
		if self.DeathCorpse_ChildEnts then
			for _, child in ipairs(self.DeathCorpse_ChildEnts) do
				child:Remove()
			end
		end
	end
end