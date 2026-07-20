include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self:DrawModel()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local overlayEnd = 0
local overlayMaterial = Material("effects/advisoreffect/advisorblast1")
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("AdvisorBlindOverlay", function()
	local duration = net.ReadFloat()
	overlayEnd = CurTime() + duration
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("RenderScreenspaceEffects", "AdvisorBlindOverlay", function()
	if CurTime() >= overlayEnd then return end
	render.SetMaterial(overlayMaterial)

	local intensity = 1

	overlayMaterial:SetFloat("$alpha", intensity)
	DrawMaterialOverlay("effects/advisoreffect/advisorblast1", intensity)
end)