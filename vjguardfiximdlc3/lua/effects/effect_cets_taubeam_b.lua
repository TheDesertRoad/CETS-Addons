function EFFECT:Init( data )
	self.texcoord = math.Rand( 0, 20 ) / 3
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	self.Entity:SetCollisionBounds( self.StartPos -  self.EndPos, Vector( 100, 100, 100 ) )
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos, Vector() * 1 )
	self.Alpha = 255
	self.FlashA = 255
	self.Target = data:GetEntity()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	self.FlashA = self.FlashA - 2000 * FrameTime()
	if self.FlashA < 0 then
		self.FlashA = 0 end
		self.Alpha = self.Alpha - 2000 * FrameTime()

		if self.Alpha < 0 then
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

	render.SetMaterial( Material( "sprites/yellowlaser1" ) )
	render.DrawBeam( self.StartPos, self.EndPos, 12, self.texcoord, self.texcoord + self.Length / 1024, Color( 255, 180, 0, 255) )
end