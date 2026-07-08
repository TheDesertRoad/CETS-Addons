local mat = Material("sprites/fassassinglow01")
local mat2 = Material("sprites/bluelaser1")

local lifetime = 5
local lifeinv = 1/lifetime

local trailtime = 0.05
local trailinv = 1/trailtime

local maxpoints = 10
local maxpinv = 1/maxpoints

function EFFECT:Init(data)
	self.Attachment = data:GetAttachment()
	self.Ent = data:GetEntity()
	self.DieTime = CurTime() + lifetime
	self.TrailTime = 0

	self.Trail = {}

	if(bit.band(data:GetFlags(), 1) > 0)then
		self.DieTime = -1
	end

	self:SetRenderBounds(Vector(-256,-256,-256), Vector(256,256,256))
end

function EFFECT:Render()
	local pos = self.Ent:GetAttachment(self.Attachment).Pos
	self:SetPos(pos)

	local size = 8

	if(self.TrailTime < CurTime()) then
		table.insert(self.Trail, 1, pos)
		table.remove(self.Trail, maxpoints + 1)
		self.TrailTime = CurTime() + trailtime
	end

	if(self.DieTime > -1) then
		size = size * (self.DieTime - CurTime()) * lifeinv
	end

	render.SetMaterial(mat)
	render.DrawSprite(pos, size, size, Color(255,0,0,255))

	render.SetMaterial(mat2)
	render.StartBeam(#self.Trail + 1)
	render.AddBeam(pos, size * 2, 0.5, Color(255,0,0,255))
	for k, v in ipairs(self.Trail) do
		render.AddBeam(v, size * (maxpoints - k) * maxpinv * 2, 0.5, Color(255,0,0,255))
	end
	render.EndBeam()
end

function EFFECT:Think()
	return IsValid(self.Ent) && (self.DieTime < 0 || self.DieTime > CurTime())
end