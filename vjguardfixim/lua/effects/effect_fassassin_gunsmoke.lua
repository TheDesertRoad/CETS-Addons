local mat = Material("sprites/baku_burntcer_smoke")

local lifetime = 5
local lifeinv = 1/lifetime

local trailtime = 0.03
local trailinv = 1/trailtime

local maxpoints = 20
local maxpinv = 1/maxpoints

function EFFECT:Init(data)
	self.Attachment = data:GetAttachment()
	self.Ent = data:GetEntity()
	self.DieTime = CurTime() + lifetime
	self.TrailTime = 0

	self.Trail = {}

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
	
	local x = (self.DieTime - CurTime()) * lifeinv

	render.SetMaterial(mat)
	render.StartBeam(#self.Trail + 1)
	render.AddBeam(pos, 0.05, 0, Color(255,255,255,128))
	for k, v in ipairs(self.Trail) do
		local y = (maxpoints - k) * maxpinv
		render.AddBeam(v, size * y, k * maxpinv, Color(255,255,255,y * 128 * x))

		self.Trail[k] = v + Vector(0, 0, 100) * FrameTime()
	end
	render.EndBeam()
end

function EFFECT:Think()
	return IsValid(self.Ent) && self.DieTime > CurTime()
end