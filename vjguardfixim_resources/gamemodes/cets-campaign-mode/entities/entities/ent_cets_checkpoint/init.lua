AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetNoDraw(true)

    self:SetSolid(SOLID_BBOX)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetTrigger(true)

    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

    self:SetCollisionBounds(
        Vector(-256, -256, 0),
        Vector(256, 256, 128)
    )
end

function ENT:StartTouch(ent)
    if not ent:IsPlayer() then return end

    -- Prevent repeatedly activating the same checkpoint
    if self.Activated then return end
    self.Activated = true

    GAMEMODE:SetCheckpoint(self:GetPos(), self:GetAngles())

    -- Play a checkpoint sound
    for _, ply in ipairs(player.GetAll()) do
        ply:EmitSound("buttons/button14.wav")
    end
end