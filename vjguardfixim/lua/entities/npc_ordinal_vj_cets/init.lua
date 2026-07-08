AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_ordinal.mdl"}
ENT.StartHealth = 75
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.CanRedirectGrenades = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.BloodDecalUseGMod = true
ENT.HasBloodParticle = true
ENT.HasBloodPool = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Accuracy = 2
ENT.Weapon_CanCrouchAttack = true -- Can it crouch while firing a weapon?
ENT.Weapon_CrouchAttackChance = 1
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 2000 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 150
ENT.Weapon_FindCoverOnReload = false

ENT.CanChatMessage = false

ENT.JumpParams = {
	Enabled = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CallForHelpDistance = 10000
ENT.InvestigateSoundDistance = 18

ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 4 -- Chance of it flinching from 1 to x | 1 will make it always flinch

ENT.AnimTbl_MeleeAttack = {"melee_gunhit"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.3 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 10
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.GrenadeAttackEntity = "obj_vj_cets_extractor" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.ThrowGrenadeChance = 2 -- Chance that it will throw the grenade | Set to 1 to throw all the time

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
ENT.ItemDropsOnDeath_EntityList = {
	"weapon_ply_comgr",
	"item_battery",
	"item_health_pen",
}

ENT.CanBeMedic = false

ENT.FootStepSoundLevel = 80
ENT.IdleSoundLevel = 85
ENT.IdleDialogueSoundLevel = 85
ENT.IdleDialogueAnswerSoundLevel = 85
ENT.CombatIdleSoundLevel = 90
ENT.InvestigateSoundLevel = 90
ENT.LostEnemySoundLevel = 85
ENT.AlertSoundLevel = 90
ENT.WeaponReloadSoundLevel = 90
ENT.GrenadeAttackSoundLevel = 90
ENT.OnGrenadeSightSoundLevel = 90
ENT.OnDangerSightSoundLevel = 90
ENT.OnKilledEnemySoundLevel = 90
ENT.AllyDeathSoundLevel = 90
ENT.PainSoundLevel = 90
ENT.DeathSoundLevel = 90

ENT.SoundTbl_FootStep = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav",
}

ENT.SoundTbl_Idle = {
	"npc/combine_soldier/vo/gridsundown46.wav",
	"npc/combine_soldier/vo/noviscon.wav",
	"npc/combine_soldier/vo/ovewatchorders3ccstimboost.wav",
	"npc/combine_soldier/vo/reportallpositionsclear.wav",
	"npc/combine_soldier/vo/reportallradialsfree.wav",
	"npc/combine_soldier/vo/reportingclear.wav",
	"npc/combine_soldier/vo/sectorissecurenovison.wav",
	"npc/combine_soldier/vo/sightlineisclear.wav",
	"npc/combine_soldier/vo/stabilizationteamhassector.wav",
	"npc/combine_soldier/vo/stabilizationteamholding.wav",
	"npc/combine_soldier/vo/teamdeployedandscanning.wav",
	"npc/combine_soldier/vo/unitisclosing.wav",
	"npc/combine_soldier/vo/wehavenontaggedviromes.wav",
}

ENT.SoundTbl_IdleDialogue = ENT.SoundTbl_Idle

ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/combine_soldier/vo/copy.wav",
	"npc/combine_soldier/vo/copythat.wav",
}

ENT.SoundTbl_Investigate = {
	"npc/combine_soldier/vo/motioncheckallradials.wav",
	"npc/combine_soldier/vo/overwatchreportspossiblehostiles.wav",
	"npc/combine_soldier/vo/prepforcontact.wav",
	"npc/combine_soldier/vo/readycharges.wav",
	"npc/combine_soldier/vo/readyextractors.wav",
	"npc/combine_soldier/vo/readyweapons.wav",
	"npc/combine_soldier/vo/readyweaponshostilesinbound.wav",
	"npc/combine_soldier/vo/stayalert.wav",
	"npc/combine_soldier/vo/stayalertreportsightlines.wav",
	"npc/combine_soldier/vo/weaponsoffsafeprepforcontact.wav",
}

ENT.SoundTbl_CombatIdle = {
	"npc/combine_soldier/vo/thatsitwrapitup.wav",
	"npc/combine_soldier/vo/gosharp.wav",
	"npc/combine_soldier/vo/hardenthatposition.wav",
	"npc/combine_soldier/vo/gosharpgosharp.wav",
	"npc/combine_soldier/vo/targetmyradial.wav",
	"npc/combine_soldier/vo/goactiveintercept.wav",
	"npc/combine_soldier/vo/unitisinbound.wav",
	"npc/combine_soldier/vo/unitismovingin.wav",
	"npc/combine_soldier/vo/sweepingin.wav",
	"npc/combine_soldier/vo/executingfullresponse.wav",
	"npc/combine_soldier/vo/containmentproceeding.wav",
	"npc/combine_soldier/vo/callhotpoint.wav",
	"npc/combine_soldier/vo/callcontacttarget1.wav",
	"npc/combine_soldier/vo/prosecuting.wav",
}

ENT.SoundTbl_Alert = {
	"npc/combine_soldier/vo/contact.wav",
	"npc/combine_soldier/vo/viscon.wav",
	"npc/combine_soldier/vo/alert1.wav",
	"npc/combine_soldier/vo/contactconfirmprosecuting.wav",
	"npc/combine_soldier/vo/contactconfim.wav",
	"npc/combine_soldier/vo/outbreak.wav",
	"npc/combine_soldier/vo/fixsightlinesmovein.wav",
}

ENT.SoundTbl_WeaponReload = {
	"npc/combine_soldier/vo/cover.wav",
	"npc/combine_soldier/vo/coverme.wav",
}

ENT.SoundTbl_GrenadeAttack = {
	"npc/combine_soldier/vo/extractoraway.wav",
	"npc/combine_soldier/vo/extractorislive.wav",
}

ENT.SoundTbl_OnDangerSight = {
	"npc/combine_soldier/vo/ripcordripcord.wav",
	"npc/combine_soldier/vo/displace.wav",
	"npc/combine_soldier/vo/displace2.wav",
}

ENT.SoundTbl_OnGrenadeSight = {
	"npc/combine_soldier/vo/flaredown.wav",
	"npc/combine_soldier/vo/bouncerbouncer.wav",
}

ENT.SoundTbl_OnKilledEnemy = {
	"npc/combine_soldier/vo/targetcompromisedmovein.wav",
	"npc/combine_soldier/vo/targetblackout.wav",
	"npc/combine_soldier/vo/affirmativewegothimnow.wav",
	"npc/combine_soldier/vo/overwatchconfirmhvtcontained.wav",
	"npc/combine_soldier/vo/overwatchtargetcontained.wav",
	"npc/combine_soldier/vo/overwatchtarget1sterilized.wav",
	"npc/combine_soldier/vo/onecontained.wav",
	"npc/combine_soldier/vo/payback.wav",
}

ENT.SoundTbl_AllyDeath = {
	"npc/combine_soldier/vo/heavyresistance.wav",
	"npc/combine_soldier/vo/overwatchrequestreinforcement.wav",
	"npc/combine_soldier/vo/overwatchrequestreserveactivation.wav",
	"npc/combine_soldier/vo/overwatchrequestskyshield.wav",
	"npc/combine_soldier/vo/overwatchrequestwinder.wav",
	"npc/combine_soldier/vo/overwatchsectoroverrun.wav",
	"npc/combine_soldier/vo/onedutyvacated.wav",
	"npc/combine_soldier/vo/sectorisnotsecure.wav",
	"npc/combine_soldier/vo/onedown.wav",
}

ENT.SoundTbl_LostEnemy = {
	"npc/combine_soldier/vo/skyshieldreportslostcontact.wav",
	"npc/combine_soldier/vo/lostcontact.wav",
}

ENT.SoundTbl_Death = {
	"npc/combine_soldier/die1.wav",
	"npc/combine_soldier/die2.wav",
	"npc/combine_soldier/die3.wav",
}

ENT.SoundTbl_Hurt = {
	"npc/combine_soldier/vo/requestmedical.wav",
	"npc/combine_soldier/vo/requeststimdose.wav",
	"npc/combine_soldier/vo/coverhurt.wav",
}

ENT.SoundTbl_Pain = {
	"npc/combine_soldier/pain1.wav",
	"npc/combine_soldier/pain2.wav",
	"npc/combine_soldier/pain3.wav",
	"npc/combine_soldier/vo/requestmedical.wav",
	"npc/combine_soldier/vo/requeststimdose.wav",
	"npc/combine_soldier/vo/coverhurt.wav",
}

ENT.SoundTbl_RadioOn = {
	"npc/combine_soldier/vo/on1.wav",
	"npc/combine_soldier/vo/on2.wav",
}

ENT.SoundTbl_RadioOff = {
	"npc/combine_soldier/vo/off1.wav",
	"npc/combine_soldier/vo/off2.wav",
	"npc/combine_soldier/vo/off3.wav",
	"npc/combine_soldier/vo/off4.wav",
}

local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}

local sdAlertFreeman = {
	"npc/combine_soldier/vo/priority1objective.wav",
	"npc/combine_soldier/vo/freeman3.wav",
	"npc/combine_soldier/vo/anticitizenone.wav",
	"npc/combine_soldier/vo/priority1objective.wav",
	"npc/combine_soldier/vo/targetone.wav",
}

local sdAlertZombies = {
	"npc/combine_soldier/vo/infected.wav",
	"npc/combine_soldier/vo/necrotics.wav",
	"npc/combine_soldier/vo/necroticsinbound.wav",
	"npc/combine_soldier/vo/wehavefreeparasites.wav",
	"npc/combine_soldier/vo/callcontactparasitics.wav",
	"npc/combine_soldier/vo/wehavenontaggedviromes.wav",
	"npc/combine_soldier/vo/weareinaninfestationzone.wav",
}

local sdAlertAliens = {
	"npc/combine_soldier/vo/outbreak.wav",
	"npc/combine_soldier/vo/swarmoutbreakinsector.wav",
	"npc/combine_soldier/vo/visualonexogens.wav",
}

local sdAlertAC2 = {
	"npc/combine_soldier/vo/prioritytwoescapee.wav",
	"npc/combine_soldier/vo/overwatchreportspossiblehostiles.wav",
}

local sdAlertStinger = "npc/combine_soldier/vo/stinger.wav"

local sdAlertFungal = {
	"npc/combine_soldier/vo/wehavefreeparasites.wav",
	"npc/combine_soldier/vo/callcontactparasitics.wav",
	"npc/combine_soldier/vo/wehavenontaggedviromes.wav",
	"npc/combine_soldier/vo/weareinaninfestationzone.wav",
}

ENT.NextDance = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_ar2")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.BlackAmount = 0
	self.ColValue = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink(dmginfo)
	if self:IsOnFire() && CurTime() > self.NextDance then
		self.Bleeds = false
		self:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
		self.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))
		timer.Simple(self:SequenceDuration(self:LookupSequence( "bugbait_hit" )), function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 && dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", SoundTbl_Pain)
	end

	if self:Health() > 0 && dmginfo:IsDamageType(DMG_NERVEGAS) then
		self.Bleeds = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)

	if !( (VJ_HasValue(self.SoundTbl_Pain, sdFile) && !VJ_HasValue(self.SoundTbl_Hurt, sdFile)) or VJ_HasValue(DefaultSoundTbl_MedicAfterHeal, sdFile) or VJ_HasValue(self.DefaultSoundTbl_MeleeAttack, sdFile) or VJ_HasValue(self.SoundTbl_NovaProspektIdle, sdFile)  ) then

		self:EmitSound(table.Random(self.SoundTbl_RadioOn),90,math.random(85, 115))
		timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then self:EmitSound(table.Random(self.SoundTbl_RadioOff),70,math.random(85, 115)) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_BeforeMeleeAttack, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Pain, sdFile) then return end
	if VJ.HasValue(self.SoundTbl_Death, sdFile) then return end
	VJ.EmitSound(self, "npc/combine_soldier/vo/on" .. math.random(1, 2) .. ".wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self, "npc/combine_soldier/vo/off" .. math.random(1, 3) .. ".wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 2 then
		if ent:IsPlayer() then
			self:PlaySoundSystem("Alert", sdAlertFreeman)
		return

		elseif ent.VJ_ID_Headcrab or ent:GetClass() == "CLASS_ZOMBIE" then
			self:PlaySoundSystem("Alert", sdAlertZombies)
		return

		elseif ent:GetClass() == "CLASS_FUNGUS" then
			self:PlaySoundSystem("Alert", sdAlertFungal)
		return

		elseif ent:GetClass() == "npc_stinger_vj_cets" or ent:GetClass() == "npc_stinger_r_vj_cets" then
			self:PlaySoundSystem("Alert", sdAlertStinger)
		return

		elseif ent:GetClass() == "npc_alyx" or ent.IsVJBaseSNPC_Human then
			self:PlaySoundSystem("Alert", sdAlertAC2)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath( dmginfo, hit_gr, rag )
	self:SetBodygroup(1, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt:Remove()
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local ar2 = ents.Create("weapon_ar2")
		ar2:SetPos(att.Pos)
		ar2:SetAngles(att.Ang)
		ar2:Spawn()
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