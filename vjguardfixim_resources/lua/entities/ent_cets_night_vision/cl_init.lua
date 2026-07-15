include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self:DrawModel()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local keyWasDown = false
local oldNVState = false
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "NV_Think", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not ply:GetNWBool("HasNV", false) then return end

	local down = input.IsKeyDown(KEY_N)
	if down and not keyWasDown then
		net.Start("NV_ToggleActive")
		net.SendToServer()
	end

	keyWasDown = down
	local nvActive = ply:GetNWBool("NVActive", false)


	if nvActive ~= oldNVState then
		if nvActive then
			ply:EmitSound("hl1/player/hud_nightvision.wav")
		else
			ply:EmitSound("hl1/items/nvg_off.wav")
		end
	end

	oldNVState = nvActive

	if not ply:GetNWBool("NVActive", false) then return end

	local dlight = DynamicLight(ply:EntIndex())
	if dlight then
		dlight.pos = EyePos()
		dlight.r = 0
		dlight.g = 255
		dlight.b = 0
		dlight.brightness = 0
		dlight.Size = 2048
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 0.1
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PreDrawViewModel", "NV_ViewmodelDim", function(vm, ply, weapon)
	if not IsValid(ply) or ply ~= LocalPlayer() then return end
	if not ply:GetNWBool("NVActive", false) then return end
 
	render.SetColorModulation(0.3, 0.3, 0.3)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PostDrawViewModel", "NV_ViewmodelDimReset", function(vm, ply, weapon)
	if not IsValid(ply) or ply ~= LocalPlayer() then return end
 
	render.SetColorModulation(1, 1, 1)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PreDrawPlayerHands", "NV_HandsDim", function(hands, vm, ply, weapon)
	if not IsValid(ply) or ply ~= LocalPlayer() then return end
	if not ply:GetNWBool("NVActive", false) then return end
 
	render.SetColorModulation(0.2, 0.2, 0.2)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PostDrawPlayerHands", "NV_HandsDimReset", function(hands, vm, ply, weapon)
	if not IsValid(ply) or ply ~= LocalPlayer() then return end
 
	render.SetColorModulation(1, 1, 1)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("RenderScreenspaceEffects", "NV_Brighten", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not ply:GetNWBool("NVActive", false) then return end
 
	DrawColorModify({
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0.2,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0.1,
		["$pp_colour_contrast"] = 1.1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0,
	})
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("HUDPaint", "NV_Overlay", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not ply:GetNWBool("NVActive", false) then return end
 
	surface.SetDrawColor(0, 255, 0, 24)
	surface.DrawRect(0, 0, ScrW(), ScrH())
end)
