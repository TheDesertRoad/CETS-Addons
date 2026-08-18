ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Rebel Sentry"
ENT.Author 			= "VALVe"

ENT.VJ_ID_Turret = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsUpdate(physobj) end
---------------------------------------------------------------------------------------------------------------------------------------------
local laserMaterial = Material("sprites/bluelaser1")

local LASER_WIDTH = 4
local LASER_SEGMENTS = 12
---------------------------------------------------------------------------------------------------------------------------------------------
local function DrawLaser(turret)
	if not IsValid(turret) then return end

	local startIndex = turret:LookupAttachment("laser_start")
	local endIndex = turret:LookupAttachment("laser_end")

	if startIndex == 0 or endIndex == 0 then return end

	local startAttachment = turret:GetAttachment(startIndex)
	local endAttachment = turret:GetAttachment(endIndex)

	if not startAttachment or not endAttachment then return end

	local startPos = startAttachment.Pos
	local endPos = endAttachment.Pos

	render.SetMaterial(laserMaterial)

	for i = 0, LASER_SEGMENTS - 1 do
		local frac1 = i / LASER_SEGMENTS
		local frac2 = (i + 1) / LASER_SEGMENTS
		local pos1 = LerpVector(frac1, startPos, endPos)
		local pos2 = LerpVector(frac2, startPos, endPos)
		local alpha = 128 * (1 - frac1)

		render.DrawBeam(pos1, pos2, LASER_WIDTH, frac1, frac2, Color(255, 0, 0, alpha))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PostDrawTranslucentRenderables", "DrawCETSTurretLaser", function()
	for _, turret in ipairs(ents.FindByClass("npc_rengi_sentry_vj_cets")) do
		DrawLaser(turret)
	end
end)