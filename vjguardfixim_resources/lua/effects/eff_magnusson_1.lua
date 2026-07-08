local lifetime = 0.7
local lifetimeinv = 1.0 / lifetime

local mat = Material("models/props_combine/portalball001_sheet")
local mat2 = Material("sprites/bakuglow")

function EFFECT:Init(data)
	self.Entity = data:GetEntity()

	if(!IsValid(self.Entity)) then
		self:Remove()
		return
	end
	self.DieTime = CurTime() + lifetime

	self:SetRenderBounds(self.Entity:GetRenderBounds(), Vector(128,128,128))
	self.Entity.RenderOverride = self.RenderParent
	self.Particles = {}

	self.DoWeirdThing = bit.band(data:GetFlags(), 1) == 1

	local rand = math.random(10, 15)
	for i = 1, rand do
		self.Particles[i] = {
			offset = VectorRand() * 30,
			initsize = rand * 3
		}
	end

	if(self.DoWeirdThing) then
		self.Entity:SetupBones()
		self.BoneID = 0
		self.BoneScale = Vector(1,1,1) * 1.5

		for i = 0, self.Entity:GetBoneCount() do
			if(self.Entity:GetBoneParent(i) == 0) then
				self.BoneID = i
				break
			end
		end
	end

	self.Entity.SpawnEffect = self

	local emitter = ParticleEmitter(self.Entity:GetPos(), false)

	for i = 1, rand do
		local vectorrand = VectorRand()
		local part = emitter:Add("sprites/flamelet1", self.Entity:GetPos() + vectorrand * Vector(10,10,0.5))
		local vel = vectorrand
		part:SetVelocity(vel * 20 + Vector(0,0,50))
		part:SetAngleVelocity(AngleRand() * 0.5)
		part:SetDieTime(math.Rand(0, 1))

		part:SetStartAlpha( 128 );
		part:SetEndAlpha( 0 );
		part:SetStartSize( 4 * i );
		part:SetGravity(Vector(0, 0, 100))
		part:SetEndSize( 0 );
		part:SetCollide( true );

		part:SetRoll(0)
		part:SetRollDelta(3)

		part:SetBounce( 0 );
		part:SetAirResistance( 5 );
		part:SetMaterial(mat2)
		part:SetColor(0,180,255)
	end

	emitter:Finish()
end

function EFFECT:Render()
end

function EFFECT:RenderParent()
	local mins, maxs = self:GetRenderBounds()
	local fract = (self.SpawnEffect.DieTime - CurTime()) * lifetimeinv
	local z = Lerp(fract, mins.z, maxs.z)

	local norm = Vector(0, 0, 1)
	local pos = self:GetPos() + Vector(0, 0, z)
	local clipping = render.EnableClipping( true )

	if(self.SpawnEffect.DoWeirdThing) then
		local boneid = self.SpawnEffect.BoneID
		local delta = 0.12
		self.SpawnEffect.BoneScale = Vector(math.Approach(self.SpawnEffect.BoneScale.x, math.Rand(0, 1.5), delta),
			math.Approach(self.SpawnEffect.BoneScale.y, math.Rand(0, 1.5), delta),
			math.Approach(self.SpawnEffect.BoneScale.z, math.Rand(0, 1.5), delta))

		local matrix = self:GetBoneMatrix(boneid)
		matrix:SetScale(self.SpawnEffect.BoneScale)

		self:SetupBones()
		self:SetBoneMatrix(boneid, matrix)
	end

	render.PushCustomClipPlane( norm, pos:Dot(norm) )
	self:DrawModel()
	render.PopCustomClipPlane()

	render.PushCustomClipPlane( -norm, pos:Dot(-norm) )
	render.MaterialOverride(mat)
	self:DrawModel()
	render.MaterialOverride(nil)
	render.PopCustomClipPlane()

	render.EnableClipping(clipping)

	for k, v in ipairs(self.SpawnEffect.Particles) do
		local vel = (Vector(0,0, 2) + v.offset:Cross(Vector(0, 0, 1))):GetNormalized()
		local ppos = v.offset + vel * fract
		v.offset = ppos
		local size = fract * v.initsize
		render.SetMaterial(mat2)
		render.DrawSprite(self:GetPos() + ppos, size, size, Color(0, 200,255))
	end
end

function EFFECT:Think()
	if(!IsValid(self.Entity)) then return false end

	self:SetPos(self.Entity:GetPos())
	if self.DieTime < CurTime() then
		self.Entity.RenderOverride = nil
		self.Entity.SpawnEffect = nil
		return false
	end

	return true
end