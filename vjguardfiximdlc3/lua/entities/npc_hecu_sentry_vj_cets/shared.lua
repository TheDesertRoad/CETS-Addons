ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "HECU Sentry"
ENT.Author 			= "VALVe"

ENT.VJ_ID_Turret = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsUpdate(physobj) end
---------------------------------------------------------------------------------------------------------------------------------------------
local laserMaterial = Material("sprites/baku_burntcer_smoke")
local spriteMaterial = Material("sprites/blueglow2")

local LASERON = true
local LASERFLASHRATE = 0.2
local LASERFLASHTIMER = 0
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( "OnEntityCreated", "TurretCreated", function( ent )
	if ( ent:GetClass() == "npc_hecu_sentry_vj_cets" ) then
		ent:SetCycle(0.5)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local function DrawLaser(attachment, color, turret)
	local startPos = attachment.Pos
	local endPos = startPos + (attachment.Ang:Forward() * 99999)
	
	local tr = util.TraceLine({
		start = startPos,
		endpos = endPos,
		filter = {turret}
	})

	render.SetMaterial(laserMaterial)
	render.DrawBeam(startPos, tr.HitPos, 1, 0, 5, color)

	if tr.Hit then
		render.SetMaterial(spriteMaterial)
		render.DrawSprite(tr.HitPos, 16, 16, Color(255, 0, 0, 255))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function DrawGroundTurretLaser(turret)
	if not IsValid(turret) then return end
	if turret:GetCycle() == 0 and turret:GetSequence() == 0 then return end

	local attachmentIndex = turret:LookupAttachment("laser")
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
---------------------------------------------------------------------------------------------------------------------------------------------
local function DrawGroundTurretLaser1(turret)
	if not IsValid(turret) then return end

	local attachmentIndex = turret:LookupAttachment("laser")
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
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PostDrawTranslucentRenderables", "DrawTurretLaser", function()
	for _, turret in ipairs(ents.FindByClass("npc_hecu_sentry_vj_cets")) do
		DrawGroundTurretLaser(turret)
	end  
end)