/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("CETS: PORTAL EXPANSION", "NPC", "Base/Default")

local vCat = "Portal"
local spawnCategory = "Portal"

VJ.AddCategoryInfo(spawnCategory, {Icon = "games/16/hl2.png"})

VJ.AddNPC("ASPMA Unit","npc_aspma_vj_cets",vCat)

VJ.AddNPCWeapon("VJ-CETS Aperture MP", "weapon_vj_cets_aspgun", spawnCategory)

game.AddParticles("particles/portalgun.pcf")
game.AddParticles("particles/portal_projectile.pcf")
game.AddParticles("particles/portals.pcf")
game.AddParticles("particles/cleansers.pcf")
game.AddParticles("particles/fire_01.pcf")
game.AddParticles("particles/fire_02.pcf")
game.AddParticles("particles/tubes.pcf")
game.AddParticles("particles/environment.pcf")
game.AddParticles("particles/glados.pcf")
game.AddParticles("particles/neurotoxins.pcf")
game.AddParticles("particles/finale_fx.pcf")
game.AddParticles("particles/water_impact.pcf")
game.AddParticles("particles/burning_fx.pcf")
game.AddParticles("particles/impact_fx.pcf")	

if SERVER then
    AddCSLuaFile()
    return
end

local laserMaterial = Material("sprites/baku_burntcer_smoke")
local spriteMaterial = Material("sprites/blueglow2")

local LASERON = true
local LASERFLASHRATE = 0.2
local LASERFLASHTIMER = 0

hook.Add( "OnEntityCreated", "TurretCreated", function( ent )
    if ( ent:GetClass() == "npc_portal_sentry_vj_cets" ) then
		ent:SetCycle(0.5)
	end
    if ( ent:GetClass() == "npc_portal_rocket_sentry_vj_cets" ) then
		ent:SetCycle(0.5)
	end
end)

local function DrawLaser(attachment, color, turret)
    local startPos = attachment.Pos
    local endPos = startPos + (attachment.Ang:Forward() * 99999)
    
    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = {turret}
    })

    render.SetMaterial(laserMaterial)
    render.DrawBeam(startPos, tr.HitPos, 2, 0, 5, color)

    if tr.Hit then
        render.SetMaterial(spriteMaterial)
        render.DrawSprite(tr.HitPos, 3, 3, Color(255, 0, 0, 255))
    end
end

local function DrawLaser1(attachment, color, turret)
    local startPos = attachment.Pos
    local endPos = startPos + (attachment.Ang:Forward() * 99999)
    
    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = {turret}
    })

    render.SetMaterial(laserMaterial)
    render.DrawBeam(startPos, tr.HitPos, 2, 0, 5, color)

    if tr.Hit then
        render.SetMaterial(spriteMaterial)
        render.DrawSprite(tr.HitPos, 3, 3, Color(100, 220, 255, 255))
    end
end

local function DrawGroundTurretLaser(turret)
    if not IsValid(turret) then return end
    if turret:GetCycle() == 0 and turret:GetSequence() == 0 then return end

    local attachmentIndex = turret:LookupAttachment("light")
    if attachmentIndex == 0 then return end
    
    local attachment = turret:GetAttachment(attachmentIndex)
    if not attachment then return end

    local seq = turret:GetSequence()
    local lc = Color(0, 0, 0, 0)
        LASERON = true
        lc = Color(255, 0, 0, 64)
    
    if LASERON then
        DrawLaser(attachment, lc, turret)
    end    
end

local function DrawGroundTurretLaser1(turret)
    if not IsValid(turret) then return end

    local attachmentIndex = turret:LookupAttachment("barrel")
    if attachmentIndex == 0 then return end
    
    local attachment = turret:GetAttachment(attachmentIndex)
    if not attachment then return end

    local seq = turret:GetSequence()
    local lc = Color(0, 0, 0, 0)
        LASERON = true
        lc = Color(100, 220, 255, 64)
    
    if LASERON then
        DrawLaser1(attachment, lc, turret)
    end    
end

hook.Add("PostDrawTranslucentRenderables", "DrawTurretLaser", function()
    for _, turret in ipairs(ents.FindByClass("npc_portal_sentry_vj_cets")) do
        DrawGroundTurretLaser(turret)
    end  
end)

hook.Add("PostDrawTranslucentRenderables", "DrawTurretLaser1", function()
    for _, turret in ipairs(ents.FindByClass("npc_portal_rocket_sentry_vj_cets")) do
        DrawGroundTurretLaser1(turret)
    end  
end)

local function CreateSettingsPanel(CPanel)
    CPanel:ClearControls()
    CPanel:CheckBox("Laser Enabled", "turretlaser_enabled")
    CPanel:CheckBox("Target Only", "turretlaser_targetonly")
end