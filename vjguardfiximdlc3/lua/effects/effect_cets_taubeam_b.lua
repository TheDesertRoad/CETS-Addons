function EFFECT:Init( data )
	self.texcoord = math.Rand(0, 20) / 3
	self.NextZap = 0
	self.ZapLife = 0
	self.ZapPoints = {}
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	self.EndPos = data:GetOrigin()
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos, Vector(128,128,128))
	self.Alpha = 255
	self.FlashA = 255
	self.BeamNoise = {}
	self.Branches = {}

	local segments = 24
	local dir = (self.EndPos - self.StartPos):GetNormalized()
	local length = self.StartPos:Distance(self.EndPos)

	local right = dir:Cross(Vector(0,0,1)):GetNormalized()
	local up = right:Cross(dir):GetNormalized()

	for i = 1, segments do
		local frac = i / segments
		local pos = LerpVector(frac, self.StartPos, self.EndPos)

		local offset = right * math.Rand(-6,6) + up * math.Rand(-6,6)
		offset = offset * math.sin(frac * math.pi)

		table.insert(self.BeamNoise, pos + offset)
	end

	for i = 1, 4 do
		local branchStart = self.EndPos + VectorRand() * 10
		local branchEnd = branchStart + VectorRand() * math.Rand(20,50)

		table.insert(self.Branches, {branchStart, branchEnd})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:CreateZap()
	self.ZapPoints = {}

	local segments = 16
	local hitOffset = VectorRand() * math.Rand(-12, 12)
	local zapEnd = self.EndPos + hitOffset
	local dir = (zapEnd - self.StartPos):GetNormalized()
	local right = dir:Cross(Vector(0,0,1)):GetNormalized()
	local up = right:Cross(dir):GetNormalized()

	for i = 0, segments do
		local frac = i / segments
		local pos = LerpVector(frac, self.StartPos, zapEnd)
		local wave = math.sin(frac * math.pi * 2)

		local offset = right * wave * math.Rand(0, 8) + up * wave * math.Rand(0, 8)
		offset = offset * math.sin(frac * math.pi)

		table.insert(self.ZapPoints, pos + offset)
	end

	self.ZapLife = math.Rand(0.04, 0.12)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if CurTime() > self.NextZap then
		self:CreateZap()
		self.NextZap = CurTime() + math.Rand(0.05, 0.25)
	end

	self.ZapLife = self.ZapLife - FrameTime()
	self.Alpha = self.Alpha - 800 * FrameTime()

	if self.Alpha <= 0 then
		return false
	end

	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	self.Length = (self.StartPos - self.EndPos):Length()

	render.SetMaterial( Material( "sprites/yellowlaser1" ) )
	render.DrawBeam( self.StartPos, self.EndPos, 8, self.texcoord, self.texcoord + self.Length / 1024, Color( 255, 200, 0, 255) )

	if self.ZapLife > 0 and #self.ZapPoints > 1 then
		render.SetMaterial(Material("effects/gluon_beamcets1"))

		last = self.StartPos

		for _, pos in ipairs(self.ZapPoints) do
			render.DrawBeam(last, pos, 3, 0, 1, Color(255,255,140, 64))
			render.DrawBeam(last, pos, 3, 0, 1, Color(255,255,140, 64))
			last = pos
		end
	end
end