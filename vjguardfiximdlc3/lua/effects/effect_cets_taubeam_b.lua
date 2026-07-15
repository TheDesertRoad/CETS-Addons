function EFFECT:Init( data )
	self.texcoord = math.Rand(0, 20) / 3
	self.NextZap = 0
	self.ZapLife = 0
	self.ZapPoints = {}
	self.PrevZapPoints = {}
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
	-- Keep the outgoing shape around so we can morph out of it instead of snapping
	self.PrevZapPoints = self.ZapPoints
	self.ZapBlendStart = CurTime()
	self.ZapBlendTime = 0.01

	self.ZapPoints = {}
	local segments = 8
	local hitOffset = VectorRand() * math.Rand(-12, 12)
	local zapEnd = self.EndPos + hitOffset
	local dir = (zapEnd - self.StartPos):GetNormalized()
	local right = dir:Cross(Vector(0,0,1)):GetNormalized()
	local up = right:Cross(dir):GetNormalized()

	local curR, curU = 0, 0
	for i = 0, segments do
		local frac = i / segments
		local pos = LerpVector(frac, self.StartPos, zapEnd)

		curR = Lerp(0.08, curR, math.Rand(-32, 32))
		curU = Lerp(0.08, curU, math.Rand(-32, 32))

		local envelope = math.sin(frac * math.pi) -- taper to 0 at both ends
		local offset = (right * curR + up * curU) * envelope

		table.insert(self.ZapPoints, pos + offset)
	end
	self.ZapLife = math.Rand(0.06, 0.15)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if CurTime() > self.NextZap then
		self:CreateZap()
		self.NextZap = CurTime() + math.Rand(0.05, 0.1)
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
	if IsValid(self.Owner) then
		self.EndPos = self.Owner:WorldSpaceCenter()
	end

	if IsValid(self.WeaponEnt) then
		local att = self.WeaponEnt:GetAttachment(self.Attachment)
	end

	if att then
		self.StartPos = att.Pos
	end

	if IsValid(self.WeaponEnt) then
		self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	end

	self.Length = (self.StartPos - self.EndPos):Length()
	render.SetMaterial( Material( "effects/gluon_beamcets1" ) )
	render.DrawBeam( self.StartPos, self.EndPos, 8, self.texcoord, self.texcoord + self.Length / 1024, Color( 255, 180, 13, 255) )

	if self.ZapLife > 0 and #self.ZapPoints > 1 then
		render.SetMaterial(Material("effects/gluon_beamcets1"))

		for b = 1, 2 do
			local points = {}
			local segments = 48
			local hitOffset = VectorRand() * math.Rand(-12, 12)
			local zapEnd = self.EndPos + hitOffset
			local dir = (zapEnd - self.StartPos):GetNormalized()
			local right = dir:Cross(Vector(0,0,1)):GetNormalized()
			local up = right:Cross(dir):GetNormalized()
			local curR, curU = 0, 0

			for i = 0, segments do
				local frac = i / segments
				local pos = LerpVector(frac, self.StartPos, zapEnd)

				curR = Lerp(0.08, curR, math.Rand(-36,36))
				curU = Lerp(0.08, curU, math.Rand(-36,36))

				local offset = (right * curR + up * curU) * math.sin(frac * math.pi)

				points[#points + 1] = pos + offset
			end

			render.StartBeam(#points)
			local dist = 0
			local last = points[1]

			for i, pos in ipairs(points) do
				if i > 1 then
					dist = dist + last:Distance(pos)
				end

				render.AddBeam(pos, 4, dist / 8, Color(255, 255, math.random(150, 255), 64))
				last = pos
			end

		render.EndBeam()

		end
	end
end