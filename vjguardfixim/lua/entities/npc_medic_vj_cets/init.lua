AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hl2_combine_medic.mdl"}
ENT.StartHealth = 128
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
ENT.MeleeAttackDamage = 8
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 30 -- How far does the damage go?

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"grenthrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"
ENT.GrenadeAttackEntity = "npc_grenade_frag" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.ThrowGrenadeChance = 2 -- Chance that it will throw the grenade | Set to 1 to throw all the time

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 2
ENT.ItemDropsOnDeath_EntityList = {
	"item_battery",
	"item_healthvial",
}

ENT.IsMedic = true -- Should it heal allied entities?
ENT.Medic_CheckDistance = 2000 -- Max distance to check for injured allies
ENT.Medic_HealDistance = 80 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_TimeUntilHeal = false -- Time until the ally receives health | false = Base auto calculates the duration
ENT.AnimTbl_Medic_GiveHealth = ACT_SPECIAL_ATTACK1 -- Animations to play when it heals an ally | false = Don't play an animation
ENT.Medic_HealAmount = 128 -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(2, 4) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on

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

local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}

local sdAlertFreeman = {
	"npc/fempolice/vo/priority2anticitizenhere.wav",
	"npc/fempolice/vo/freeman.wav",
	"npc/fempolice/vo/anticitizen.wav",
}

local sdAlertZombies = {
	"npc/fempolice/vo/infection.wav",
	"npc/fempolice/vo/necrotics.wav",
	"npc/fempolice/vo/freenecrotics.wav",
	"npc/fempolice/vo/infestedzone.wav",
	"npc/fempolice/vo/wehavea10-108.wav",
}

local sdAlertAliens = {
	"npc/fempolice/vo/outbreak.wav",
	"npc/fempolice/vo/outlandbioticinhere.wav",
}

local sdAlertAC2 = {
	"npc/fempolice/vo/priority2anticitizenhere.wav",
}

local sdAlertStinger = "npc/fempolice/vo/sterilize.wav"

local sdAlertFungal = {
	"npc/fempolice/vo/sterilize.wav",
	"npc/fempolice/vo/infection.wav",
	"npc/fempolice/vo/necrotics.wav",
	"npc/fempolice/vo/freenecrotics.wav",
	"npc/fempolice/vo/infestedzone.wav",
	"npc/fempolice/vo/wehavea10-108.wav",
	"npc/fempolice/vo/outbreak.wav",
	"npc/fempolice/vo/outlandbioticinhere.wav",
}

ENT.NextDance = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSpawnEffect(true)
	self:Give("weapon_vj_cets_psmg")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("ALT (walk key)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink(dmginfo)
	if self:IsMoving() then
		self:SetLocalVelocity(self:GetMoveVelocity() * 0.2)
	end

	if self:IsOnFire() && CurTime() > self.NextDance then
		self.Bleeds = false
		timer.Simple(self:SequenceDuration(self:LookupSequence( "bugbait_hit" )), function() if self:IsValid() && self:IsOnFire() then self:TakeDamage(self:GetMaxHealth(), self, self) end end)
		self:VJ_ACT_PLAYACTIVITY("bugbait_hit", true, true, true)
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(self:LookupSequence( "bugbait_hit" )))
		self.NextDance = CurTime() + self:SequenceDuration(self:LookupSequence( "bugbait_hit" ))
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
	VJ.EmitSound(self, "npc/fempolice/vo/on" .. math.random(1, 2) .. ".wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self, "npc/fempolice/vo/off" .. math.random(1, 4) .. ".wav") end end)
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
	self:CreateGibEntity("physics_prop", "models/weapons/w_hl2psmg.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20))})
	for i = 1, 1 do
		local att = self:GetAttachment(1 +i)
		local psmg = ents.Create("item_ammo_ar2")
		psmg:SetPos(att.Pos)
		psmg:SetAngles(att.Ang)
		psmg:Spawn()
	end
end