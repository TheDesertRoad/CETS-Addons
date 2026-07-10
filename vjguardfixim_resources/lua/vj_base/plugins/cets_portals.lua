/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("CETS", "NPC", "Spawn Portals")

game.AddParticles("particles/vjguardporpar.pcf")

local vCat = "Other"

VJ.AddNPC("Warpball (Xen)", "sent_vj_cets_portal_a",vCat)
VJ.AddNPC("Warpball (Xenian Boss)", "sent_vj_cets_portal_ab",vCat)
VJ.AddNPC("Warpball (Race X)", "sent_vj_cets_portal_b",vCat)
VJ.AddNPC("Warpball (Antlions)", "sent_vj_cets_portal_c",vCat)
VJ.AddNPC("Warpball (Combine)", "sent_vj_cets_portal_d",vCat)
//VJ.AddNPC("Vehicle 1", "npc_vehiclealive_1_vj_cets",vCat)

VJ.AddConVar("vehicle_weapon_strip", 1, FCVAR_ARCHIVE)
VJ.AddConVar("sv_cets_kill_announcer", 0, FCVAR_ARCHIVE)
VJ.AddConVar("sv_cets_kill_announcer_text", 0, FCVAR_ARCHIVE)
VJ.AddConVar("sv_cets_kill_announce_npc", 0, FCVAR_ARCHIVE)
VJ.AddConVar("sv_cets_friends_join_sound", 0, FCVAR_ARCHIVE)
VJ.AddConVar("sv_cets_friends_chat_sound", 0, FCVAR_ARCHIVE)
VJ.AddConVar("sv_cets_friends_chat_sound_hl1", 0, FCVAR_ARCHIVE)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	local enable = CreateConVar("cets_use_sound", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

	hook.Add("FindUseEntity", "PlayerUseNoises", function(ply, ent)
		if !enable:GetBool() or !ply:KeyPressed(IN_USE) or ply:KeyDown(IN_ATTACK2) then return end
		if IsValid(ent) and !ent:IsEffectActive(EF_NODRAW) then
			ply:EmitSound("HL2Player.Use")
		else
		timer.Simple(0, function()
			local tent = ply:GetEntityInUse()
				if IsValid(tent) and !tent:IsEffectActive(EF_NODRAW) then
					ply:EmitSound("HL2Player.Use")
				else
					ply:EmitSound("HL2Player.UseDeny")
				end
			end)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VJ.CETS_Effect_SpwPrtl(pos, size, color, onSpawn)
	-- Helpful page: https://developer.valvesoftware.com/wiki/Alien_Teleport_Effect_(HL1)
	size = size or 1.5
	
	ParticleEffect("xenpor_arc_01_system", pos, Angle(0,0,0))	

	-- Dynamic light
	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "1")
	dynLight:SetKeyValue("distance", "200")
	dynLight:SetKeyValue("rendercolor", color or "0 255 0 200")
	dynLight:SetKeyValue("style", "1") -- 1 = Flicker A (mmnmmommommnonmmonqnmmo)
	dynLight:SetPos(pos)
	dynLight:SetParent(self)
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:Fire("Kill", "", 0.6)
	
	sound.Play("hl1/debris/beamstart2.wav", pos, 85)
	timer.Simple(0.5, function()
		sound.Play("hl1/debris/beamstart7.wav", pos, 85) -- Play the spawn sound
		if onSpawn then onSpawn() end
	end)
	return spr
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VJ.CETS_Effect_SpwPrtl_RX(pos, size, color, onSpawn)
	-- Helpful page: https://developer.valvesoftware.com/wiki/Alien_Teleport_Effect_(HL1)
	size = size or 1.5
	
	ParticleEffect("xenpor_arc_01_system_racex", pos, Angle(0,0,0))	

	-- Dynamic light
	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "1")
	dynLight:SetKeyValue("distance", "200")
	dynLight:SetKeyValue("rendercolor", color or "255 86 255 200")
	dynLight:SetKeyValue("style", "1") -- 1 = Flicker A (mmnmmommommnonmmonqnmmo)
	dynLight:SetPos(pos)
	dynLight:SetParent(self)
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:Fire("Kill", "", 0.6)
	
	sound.Play("hl1/debris/beamstart2.wav", pos, 85)
	timer.Simple(0.5, function()
		sound.Play("hl1/debris/beamstart7.wav", pos, 85) -- Play the spawn sound
		if onSpawn then onSpawn() end
	end)
	return spr
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VJ.CETS_Effect_SpwPrtl_ANT(pos, size, color, onSpawn)
	-- Helpful page: https://developer.valvesoftware.com/wiki/Alien_Teleport_Effect_(HL1)
	size = size or 1.5
	
	ParticleEffect("xenpor_arc_01_system_yellow", pos, Angle(0,0,0))	

	-- Dynamic light
	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "1")
	dynLight:SetKeyValue("distance", "200")
	dynLight:SetKeyValue("rendercolor", color or "255 86 255 200")
	dynLight:SetKeyValue("style", "1") -- 1 = Flicker A (mmnmmommommnonmmonqnmmo)
	dynLight:SetPos(pos)
	dynLight:SetParent(self)
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:Fire("Kill", "", 0.6)
	
	sound.Play("hl1/debris/beamstart2.wav", pos, 85)
	timer.Simple(0.5, function()
		sound.Play("hl1/debris/beamstart7.wav", pos, 85) -- Play the spawn sound
		if onSpawn then onSpawn() end
	end)
	return spr
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VJ.CETS_Effect_SpwPrtlBOSS(pos, size, color, onSpawn)
	-- Helpful page: https://developer.valvesoftware.com/wiki/Alien_Teleport_Effect_(HL1)
	size = size or 1.5
	
	ParticleEffect("xenpor_arc_01_system_boss", pos, Angle(0,0,0))	

	-- Dynamic light
	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "2")
	dynLight:SetKeyValue("distance", "400")
	dynLight:SetKeyValue("rendercolor", color or "0 255 0 200")
	dynLight:SetKeyValue("style", "1") -- 1 = Flicker A (mmnmmommommnonmmonqnmmo)
	dynLight:SetPos(pos)
	dynLight:SetParent(self)
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:Fire("Kill", "", 0.6)
	
	sound.Play("hl1/debris/beamstart8.wav", pos, 100)
	timer.Simple(0.5, function()
		sound.Play("hl1/debris/beamstart7.wav", pos, 100) -- Play the spawn sound
		if onSpawn then onSpawn() end
	end)
	return spr
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VJ.CETS_Effect_SpwPrtl_Blu(pos, size, color, onSpawn)
	-- Helpful page: https://developer.valvesoftware.com/wiki/Alien_Teleport_Effect_(HL1)
	size = size or 1.5
	
	ParticleEffect("xenpor_arc_01_system_blu", pos, Angle(0,0,0))	

	-- Dynamic light
	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "1")
	dynLight:SetKeyValue("distance", "200")
	dynLight:SetKeyValue("rendercolor", color or "150 200 255 200")
	dynLight:SetKeyValue("style", "1") -- 1 = Flicker A (mmnmmommommnonmmonqnmmo)
	dynLight:SetPos(pos)
	dynLight:SetParent(self)
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:Fire("Kill", "", 0.6)
	
	sound.Play("ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 2) .. ".wav", pos, 100)
	timer.Simple(0.5, function()
		sound.Play("hl1/debris/beamstart7.wav", pos, 100, 70) -- Play the spawn sound
		if onSpawn then onSpawn() end
	end)
	return spr
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Cets_ClearInventory(ply, cmd, args)
	if ply ~= NULL then
		ply:RemoveAllItems()
		ply:SendLua("notification.AddLegacy('Cleared Your Inventory', NOTIFY_GENERIC, 2)")
	MsgN("Cleared Your Inventory")
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Cets_ClearCurrentWeapon(ply, cmd, args)
	if ply ~= NULL then
		plyWeapon = ply:GetActiveWeapon()
		if plyWeapon ~= NULL then
			className = plyWeapon:GetClass(plyWeapon)
			ply:StripWeapon(className)
		end
	ply:SendLua("notification.AddLegacy('Cleared Current Weapon', NOTIFY_GENERIC, 2)")
		MsgN("Cleared Current Weapon")
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Cets_ClearInventory_NOMSG(ply, cmd, args)
	if ply ~= NULL then
		ply:RemoveAllItems()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Cets_ClearCurrentWeapon_NOMSG(ply, cmd, args)
	if ply ~= NULL then
		plyWeapon = ply:GetActiveWeapon()
		if plyWeapon ~= NULL then
			className = plyWeapon:GetClass(plyWeapon)
			ply:StripWeapon(className)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Cets_giveSuit(ply)
	if ply ~= NULL then
		ply:EquipSuit()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Cets_takeOffSuit(ply)
	if ply ~= NULL then
		ply:RemoveSuit()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Cets_NudePlayer(ply)
	if ply ~= NULL then
		ply:RemoveSuit()
		ply:RemoveAllItems()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("cets_clear_inv", Cets_ClearInventory)
concommand.Add("cets_clear_inv_clear_current_weapon", Cets_ClearCurrentWeapon)
concommand.Add("cets_clear_inv_nomsg", Cets_ClearInventory_NOMSG)
concommand.Add("cets_clear_inv_clear_current_weapon_nomsg", Cets_ClearCurrentWeapon_NOMSG)
concommand.Add("cets_give_hev", Cets_giveSuit)
concommand.Add("cets_remove_hev", Cets_takeOffSuit)
concommand.Add("cets_remove_everything", Cets_NudePlayer)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MsgN("Added 'cets_clear_inv', 'cets_clear_inv_clear_current_weapon', 'cets_clear_inv_nomsg', 'cets_clear_inv_clear_current_weapon_nomsg', 'cets_give_hev', 'cets_remove_hev', 'cets_remove_everything' commands")