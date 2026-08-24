if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("VJ_CETS_CreateBubbles")
	util.AddNetworkString("VJ_CETS_BubbleTrail")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
---------------------------------------------------------------------------------------------------------------------------------------------
VJ_CETS_BubbleFunctions = VJ_CETS_BubbleFunctions or {}
---------------------------------------------------------------------------------------------------------------------------------------------
VJ_CETS_BubbleFunctions.Alpha = function(particle, settings)
	particle:SetStartAlpha(settings.AlphaMin)
	particle:SetEndAlpha(settings.AlphaMax)
end
---------------------------------------------------------------------------------------------------------------------------------------------
VJ_CETS_BubbleFunctions.Color = function(particle, settings)
	particle:SetColor(settings.Color.r, settings.Color.g, settings.Color.b)
end
---------------------------------------------------------------------------------------------------------------------------------------------
VJ_CETS_BubbleFunctions.Texture = function(emitter, pos, settings)
	return emitter:Add(settings.Texture, pos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function GetWaterSurfaceZ(pos, ent)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos + Vector(0, 0, 4096),
		mask = MASK_WATER,
		filter = ent
	})

	if not tr.Hit then
		return nil
	end

	return tr.HitPos.z
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function CreateBubble(data)
	local ent = data.Entity

	if IsValid(ent) == false then
		return
	end

	local pos = ent:LocalToWorld(data.Offset)
	local surfaceZ = GetWaterSurfaceZ(pos, ent)

	if not surfaceZ then
		return
	end

	local bubbleSurfaceZ = surfaceZ - data.SurfaceOffset
	local spawnPos = pos + Vector(math.Rand(-data.BoxSize.x, data.BoxSize.x), math.Rand(-data.BoxSize.y, data.BoxSize.y), math.Rand(-data.BoxSize.z, data.BoxSize.z))

	if spawnPos.z >= bubbleSurfaceZ then
		return
	end

	if bit.band(util.PointContents(spawnPos), CONTENTS_WATER) == 0 then
		return
	end

	local emitter = ParticleEmitter(spawnPos)

	if not emitter then
		return
	end

	local particle

	local textureFunction = VJ_CETS_BubbleFunctions.Texture

	if textureFunction then
		particle = textureFunction(emitter, spawnPos, data)
	end

	if not particle then
		particle = emitter:Add(data.Texture, spawnPos)
	end

	if not particle then
		particle = emitter:Add("sprites/light_glow02_add", spawnPos)
	end

	if not particle then
		emitter:Finish()
		return
	end

	local spawnSize = math.Rand(data.SizeMin, data.SizeMax)
	local growSize = spawnSize * math.Rand(1.1, 2)
	local lifeTime = math.Rand(data.LifeMin, data.LifeMax)
	local pulseSpeed = math.Rand(2, 8)
	local pulseOffset = math.Rand(0, math.pi * 2)

	if VJ_CETS_BubbleFunctions.Alpha then
		VJ_CETS_BubbleFunctions.Alpha(particle, data)
	else
		particle:SetStartAlpha(data.AlphaMin)
		particle:SetEndAlpha(data.AlphaMax)
	end

	if VJ_CETS_BubbleFunctions.Color then
		VJ_CETS_BubbleFunctions.Color(particle, data)
	else
		particle:SetColor(data.Color.r, data.Color.g, data.Color.b)
	end

	particle:SetStartSize(spawnSize)
	particle:SetEndSize(spawnSize)
	particle:SetDieTime(lifeTime)
	particle:SetGravity(Vector(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(10, 25)))
	particle:SetVelocity(Vector(math.Rand(-8, 8), math.Rand(-8, 8), math.Rand(data.SpeedMin, data.SpeedMax)))

	local spawnTime = CurTime()

	particle:SetThinkFunction(function(p)

	if not p then
		return
	end

	local ppos = p:GetPos()
	local currentSurfaceZ = GetWaterSurfaceZ(ppos, ent)

	if currentSurfaceZ then
		local currentBubbleSurface = currentSurfaceZ - data.SurfaceOffset

		if ppos.z >= currentBubbleSurface then
			p:SetDieTime(0)
			return
		end
	end

	if bit.band(util.PointContents(ppos), CONTENTS_WATER) == 0 then
		p:SetDieTime(0)
		return
	end

	local life = CurTime() - spawnTime
	local pulse =(math.sin(life * pulseSpeed + pulseOffset) + 1) * 0.5

	pulse = pulse * pulse * (3 - 2 * pulse)

	local currentSize = Lerp(pulse, spawnSize, growSize)
		particle:SetStartSize(currentSize)
		particle:SetEndSize(currentSize)
		particle:SetNextThink(CurTime())
	end)

	particle:SetNextThink(CurTime())

	emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("VJ_CETS_CreateBubbles", function()
	local ent = net.ReadEntity()

	if not IsValid(ent) then
		return
	end

	local data = {Entity = ent, Offset = net.ReadVector(), BoxSize = net.ReadVector(), Amount = net.ReadUInt(8), Interval = net.ReadFloat(), SurfaceOffset = net.ReadFloat(), SpeedMin = net.ReadFloat(), SpeedMax = net.ReadFloat(), SizeMin = net.ReadFloat(), SizeMax = net.ReadFloat(), LifeMin = net.ReadFloat(), LifeMax = net.ReadFloat(), AlphaMin = net.ReadUInt(8), AlphaMax = net.ReadUInt(8), Color = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)), Texture = net.ReadString()}

	for i = 1, data.Amount do
		CreateBubble(data)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local trails = {}
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("VJ_CETS_BubbleTrail", function()
	local ent = net.ReadEntity()

	if not IsValid(ent) then
		return
	end

	local data = {Entity = ent, Offset = net.ReadVector(), BoxSize = net.ReadVector(), Amount = net.ReadUInt(8), Interval = net.ReadFloat(), SurfaceOffset = net.ReadFloat(), SpeedMin = net.ReadFloat(), SpeedMax = net.ReadFloat(), SizeMin = net.ReadFloat(), SizeMax = net.ReadFloat(), LifeMin = net.ReadFloat(), LifeMax = net.ReadFloat(), AlphaMin = net.ReadUInt(8), AlphaMax = net.ReadUInt(8), Color = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)), Texture = net.ReadString(), NextSpawn = CurTime()}

	trails[ent] = data
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Think", "VJ_CETS_BubbleTrail_Think", function()
	local curTime = CurTime()

	for ent, data in pairs(trails) do
		if not IsValid(ent) then
			trails[ent] = nil
			continue
		end

		if curTime < data.NextSpawn then
			continue
		end

		data.NextSpawn = curTime + data.Interval

		for i = 1, data.Amount do
			CreateBubble(data)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityRemoved", "VJ_CETS_BubbleTrail_Remove",
	function(ent) trails[ent] = nil
end)
---------------------------------------------------------------------------------------------------------------------------------------------
else
---------------------------------------------------------------------------------------------------------------------------------------------
local function ApplyBubbleDefaults(settings)
	settings = settings or {}

	if not isvector(settings.Offset) then
		settings.Offset = Vector(0, 0, 0)
	end

	if isnumber(settings.BoxSize) then
		settings.BoxSize = Vector(settings.BoxSize, settings.BoxSize, settings.BoxSize)
	end

	if not isvector(settings.BoxSize) then
		settings.BoxSize = Vector(12, 12, 8)
	end

	settings.Amount = math.Clamp(math.floor(tonumber(settings.Amount) or 1), 1, 255)
	settings.Interval = tonumber(settings.Interval) or 0.08
	settings.SurfaceOffset = tonumber(settings.SurfaceOffset) or 10
	settings.SpeedMin = tonumber(settings.SpeedMin) or 35
	settings.SpeedMax = tonumber(settings.SpeedMax) or 65
	settings.SizeMin = tonumber(settings.SizeMin) or 1
	settings.SizeMax = tonumber(settings.SizeMax) or 3
	settings.LifeMin = tonumber(settings.LifeMin) or 2
	settings.LifeMax = tonumber(settings.LifeMax) or 4
	settings.AlphaMin = math.Clamp(math.floor(tonumber(settings.AlphaMin) or 4), 0, 255)
	settings.AlphaMax = math.Clamp(math.floor(tonumber(settings.AlphaMax) or 64), 0,255)

	if not IsColor(settings.Color) then
		settings.Color = Color(255, 255, 255)
	end

	settings.Texture = settings.Texture or "effects/bubble"

	return settings
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function WriteBubbleSettings(settings)
	net.WriteVector(settings.Offset)
	net.WriteVector(settings.BoxSize)
	net.WriteUInt(settings.Amount,8)
	net.WriteFloat(settings.Interval)
	net.WriteFloat(settings.SurfaceOffset)
	net.WriteFloat(settings.SpeedMin)
	net.WriteFloat(settings.SpeedMax)
	net.WriteFloat(settings.SizeMin)
	net.WriteFloat(settings.SizeMax)
	net.WriteFloat(settings.LifeMin)
	net.WriteFloat(settings.LifeMax)
	net.WriteUInt(settings.AlphaMin, 8)
	net.WriteUInt(settings.AlphaMax, 8)
	net.WriteUInt(settings.Color.r, 8)
	net.WriteUInt(settings.Color.g, 8)
	net.WriteUInt(settings.Color.b, 8)
	net.WriteString(settings.Texture)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CETS_CreateBubbles(ent, settings, boxSize, offset)
	if not IsValid(ent) then
		return
	end

	if isnumber(settings) then
		settings = {Amount = settings, BoxSize = boxSize, Offset = offset}
	end

	settings = ApplyBubbleDefaults(settings)

	net.Start("VJ_CETS_CreateBubbles")
	net.WriteEntity(ent)
	WriteBubbleSettings(settings)
	net.SendPVS(ent:GetPos())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CETS_StartBubbleTrail(ent, settings)
	if not IsValid(ent) then
		return
	end

	settings = ApplyBubbleDefaults(settings)

	net.Start("VJ_CETS_BubbleTrail")
	net.WriteEntity(ent)
	WriteBubbleSettings(settings)
	net.SendPVS(ent:GetPos())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CETS_StopBubbleTrail(ent)
	if not IsValid(ent) then
		return
	end

	net.Start("VJ_CETS_BubbleTrail")
	net.WriteEntity(NULL)
	net.SendPVS(ent:GetPos())
end
---------------------------------------------------------------------------------------------------------------------------------------------
end