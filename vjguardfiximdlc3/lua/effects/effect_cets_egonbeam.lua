function EFFECT:Init(data)
	self.texcoord = math.Rand(0,200) / 30
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	self.EndPos = data:GetOrigin()
	self.SmoothEndPos = self.EndPos
	self.Target = data:GetEntity()
	self.Alpha = 255
	self.FlashA = 255
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	local ft = FrameTime()

	self.Alpha = math.max(self.Alpha - 2000 * ft,0)
	self.FlashA = math.max(self.FlashA - 2000 * ft,0)

	if self.Alpha <= 0 then
		return false
	end

	if IsValid(self.Target) then
		local target = self.Target:WorldSpaceCenter()

		if self.Target.GetVelocity then
			target = target + self.Target:GetVelocity() * engine.TickInterval()
		end

		local t = 1 - math.exp(0 * ft)

		self.SmoothEndPos = LerpVector(t, self.SmoothEndPos, target)
	end

	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local matBeam = Material("effects/gluon_beamcets1")
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:GetBeamStart()
	local startPos = self.StartPos

	if IsValid(self.WeaponEnt) then
		local att = self.WeaponEnt:GetAttachment(self.Attachment)

		if att then
			startPos = att.Pos
		end

		startPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	end

	return startPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	local startPos = self:GetBeamStart()
	local endPos = self.SmoothEndPos

	if not startPos or not endPos then return end

	local dist = startPos:Distance(endPos)

	dist = math.min(dist, 2048)

	local stepSize = 16
	local texWidth = 12
	local texScroll = CurTime() * 10
	local color = Color(128, 158, 255, self.Alpha)
	local ang = (endPos - startPos):Angle()
	local Forward = ang:Forward()
	local Right = ang:Right()
	local Up = ang:Up()

	render.SetMaterial(matBeam)
	render.StartBeam(128)
	render.AddBeam(startPos, texWidth, texScroll, color)


	for i = 0, dist, stepSize do
		local sin = math.sin(CurTime() + i * 0.025)
		local cos = math.cos(CurTime() + i * 0.025)
		local prog = math.min(i * i * 0.2 / dist, 16)
		local pos = startPos + Forward * i + Up * sin * prog + Right * cos * prog

		render.AddBeam(pos, texWidth, texScroll + i / 64, color)
	end

	render.AddBeam(endPos, texWidth, texScroll, color)
	render.EndBeam()

	render.SetMaterial(matBeam)
	render.DrawBeam(startPos, endPos, texWidth, texScroll, texScroll + dist / 256, color)
end