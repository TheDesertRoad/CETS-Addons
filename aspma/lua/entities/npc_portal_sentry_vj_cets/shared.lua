ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Sentry"
ENT.Author 			= "VALVe"

ENT.VJ_ID_Turret = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsUpdate(physobj) end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
function ENT:DrawLaser(attachment, color, turret)
local laserMaterial = Material("effects/laser1")
local spriteMaterial = Material("effects/blueflare1")
local attachment = self:GetAttachment(self:LookupAttachment("eyes"))
local LASERON = true
local LASERFLASHRATE = 0.2
local LASERFLASHTIMER = 0

    local startPos = attachment.Pos
    local endPos = startPos + (attachment.Ang:Forward() * 99999)
    
    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = {turret}
    })

    render.SetMaterial(spriteMaterial)
    render.DrawSprite(startPos, 8, 8, color)
    render.SetMaterial(laserMaterial)
    render.DrawBeam(startPos, tr.HitPos, 1, 0, 1, Color(255, 0, 0))

    if tr.Hit then
        render.SetMaterial(spriteMaterial)
        render.DrawSprite(tr.HitPos, 8, 8, color)

        local dlight = DynamicLight(turret:EntIndex())
        if dlight then
            dlight.pos = tr.HitPos
            dlight.r = 255
            dlight.g = 0
            dlight.b = 0
            dlight.brightness = 1
            dlight.Decay = 500
            dlight.Size = 50
            dlight.DieTime = CurTime() + 0.1
        end
    end
end
end