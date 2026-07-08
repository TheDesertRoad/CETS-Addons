if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
EFFECT.MainMat = Material("particle/bendibeam")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Ent = data:GetEntity()
	self.Att = data:GetAttachment()
	if IsValid(self.Ent) then
		self.StartPos = self.Ent:GetAttachment(self.Att).Pos
		self.EndPos = self.Ent:GetAttachment(4).Pos
	end
	
	self.HitPos = self.EndPos - self.StartPos
	self.DieTime = CurTime() + data:GetScale()
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if !IsValid(self.Ent) then return false end
	self.StartPos = self.Ent:GetAttachment(self.Att).Pos
	self.EndPos = self.Ent:GetAttachment(4).Pos
	if (CurTime() > self.DieTime) then -- If it's dead then...
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	render.SetMaterial(self.MainMat)
	render.DrawBeam(self.StartPos, self.EndPos, math.Rand(18, 24), math.Rand(0, 1), math.Rand(0, 1) + ((self.StartPos - self.EndPos):Length() / 128), Color(255, 86, 255, 255 / ((self.DieTime - 0.1) - CurTime())))
end