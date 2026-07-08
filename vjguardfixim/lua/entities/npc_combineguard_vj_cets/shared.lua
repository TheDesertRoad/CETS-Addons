ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Combine Guard"
ENT.Author 			= "VALVe"

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local laser2mat = Material("effects/blueblacklargebeam")
local laserwidth = 4

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
    function ENT:ExpandLaser(time,size)
        if self.ExpandingLaser then return end
        self.ExpandingLaser = true

        self.LaserWidth = 0
    
        local reps = 33
        timer.Create("VJ_Z_StriderLaserWidthTimer" .. self:EntIndex(), time/reps, reps, function() if IsValid(self) then
            self.LaserWidth = math.Clamp( self.LaserWidth + size/reps , 0, size)
        end end)

        -- timer.Simple(time, function() if IsValid(self) then
        --     self.ExpandingLaser = false
        -- end end)
    end

    function ENT:Draw()

        self:DrawModel()

        if self:GetNWBool("VJCombGuardZGunCharging") == true then
            if !self.LaserExpanded then
                self:ExpandLaser(1, 20)
            end

            if !self.ClientFirePosUpdated then
                self.ClientFirePos = self:GetNWVector("VJCombGuardZFirePos")
                self.ClientFirePosUpdated = true
            end
        
            render.SetMaterial(laser2mat)
            render.SetShadowsDisabled(true)
            render.DrawBeam(self:GetAttachment(1).Pos, self.ClientFirePos, self.LaserWidth, 0, 1, Color(255,255,255))

        else
            self.LaserExpanded = false
            self.ExpandingLaser = false
            self.ClientFirePosUpdated = false
        end

    end
end