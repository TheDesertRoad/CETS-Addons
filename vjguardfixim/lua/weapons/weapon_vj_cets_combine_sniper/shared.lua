if (!file.Exists("autorun/vj_base_autorun.lua", "LUA")) then return end

SWEP.Base = "weapon_vj_cets_357"
SWEP.PrintName = "SNIPER COMB"
SWEP.HoldType = "smg"
SWEP.Author = ""
SWEP.Category = ""

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/w_combinesniper.mdl"
SWEP.ReplacementWeapon = "item_ammo_ar2_large"

SWEP.Primary.Damage				= 20 -- Damage
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 3 -- Time until it can shoot again
SWEP.Primary.Sound				= "npc/sniper/sniper1.wav"
SWEP.Primary.SoundLevel = 100
SWEP.Primary.DistantSound				= "npc/sniper/echo1.wav"
SWEP.Primary.Cone = 0
SWEP.Primary.Force = 2
SWEP.Primary.TracerType = "AirboatGunTracer"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.PrimaryEffects_DynamicLightBrightness = 2
SWEP.PrimaryEffects_DynamicLightDistance = 32

SWEP.NPC_ReloadSound				= "Cets_Weapon_Sniper.Reload"
SWEP.NPC_NextPrimaryFire = 1
SWEP.NPC_TimeUntilFire = 1
SWEP.NPC_CustomSpread = 0
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
---------------------------------------------------------------------------------------------------------------------------------------------
local ExplosiveSearchDistance = 24576
local ExplosiveTargetDistance = 256
local ExplosiveLineRadius = 128
local ExplosiveModels = {
	["models/props_junk/propane_tank001a.mdl"] = true,
	["models/props_junk/gascan001a.mdl"] = true,
	["models/props_c17/oildrum001_explosive.mdl"] = true,
	["models/props_cets/oildrum001_explosive.mdl"] = true,
	["models/props_explosive/explosive_butane_can02.mdl"] = true,
	["models/props_explosive/explosive_butane_can.mdl"] = true,
	["models/props_phx/oildrum001_explosive.mdl"] = true,
	["models/props_cets_aliens/boomerplant_01.mdl"] = true,
	["models/props_cets/roller_spikes.mdl"] = true,
}
---------------------------------------------------------------------------------------------------------------------------------------------
local function IsExplosiveProp(ent)
	if !IsValid(ent) then
		return false
	end

	local class = ent:GetClass()

	if class != "prop_physics" && class != "npc_boomplant_vj_cets" && class != "ent_cets_navalmine" then
		return false
	end

	if class == "npc_boomplant_vj_cets" then
		return true
	end

	if class == "ent_cets_navalmine" then
		return true
	end

	local model = string.lower(ent:GetModel() or "")

	return ExplosiveModels[model] == true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function IsValidExplosiveVictim(ent, owner)
	if !IsValid(ent) then
		return false
	end

	if ent == owner then
		return false
	end

	if ent:IsPlayer() then
		return ent:Alive()
	end

	if ent:IsNPC() then
		if ent:Health() <= 0 then
			return false
		end

		if !ent.IsVJBaseSNPC_Human then
			return false
		end

		return true
	end

	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function FindVictimNearExplosive(explosive, owner)
	if !IsValid(explosive) then
		return nil
	end

	local explosivePos = explosive:WorldSpaceCenter()
	local closestTarget = nil
	local closestDistance = math.huge

	for _, ent in ipairs(ents.FindInSphere(explosivePos, ExplosiveTargetDistance)) do
		if IsValidExplosiveVictim(ent, owner) then
			local distance = explosivePos:DistToSqr(ent:WorldSpaceCenter())

			if distance < closestDistance then
				closestDistance = distance
				closestTarget = ent
			end
		end
	end

	return closestTarget
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function IsExplosiveBetween(sniper, explosive, target)
	if !IsValid(sniper) then return false end
	if !IsValid(explosive) then return false end
	if !IsValid(target) then return false end

	local sniperPos = sniper:WorldSpaceCenter()
	local explosivePos = explosive:WorldSpaceCenter()
	local targetPos = target:WorldSpaceCenter()

	local direction = (targetPos - sniperPos):GetNormalized()
	local sniperToExplosive = explosivePos - sniperPos

	local distanceAlongLine = sniperToExplosive:Dot(direction)

	if distanceAlongLine <= 0 then
		return false
	end

	local targetDistance = sniperPos:Distance(targetPos)

	if distanceAlongLine >= targetDistance then
		return false
	end

	local closestPoint = sniperPos + direction * distanceAlongLine
	local distanceFromLine = closestPoint:Distance(explosivePos)

	return distanceFromLine <= ExplosiveLineRadius
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function FindExplosiveTarget(owner)
	if !IsValid(owner) then
		return nil, nil
	end

	local sniperPos = owner:WorldSpaceCenter()

	local bestExplosive = nil
	local bestVictim = nil
	local bestDistance = math.huge

	for _, explosive in ipairs(ents.FindInSphere(sniperPos, ExplosiveSearchDistance)) do
		if !IsExplosiveProp(explosive) then
			continue
		end

		local victim = FindVictimNearExplosive(explosive, owner)

		if !IsValid(victim) then
			continue
		end

		if !IsExplosiveBetween(owner, explosive, victim) then
			continue
		end

		local distance = sniperPos:DistToSqr(explosive:WorldSpaceCenter())

		if distance < bestDistance then
			bestDistance = distance
			bestExplosive = explosive
			bestVictim = victim
		end
	end

	return bestExplosive, bestVictim
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack(UseAlt)
	local curTime = CurTime()

	if self.Reloading then
		return
	end

	if self:GetNextSecondaryFire() > curTime then
		return
	end

	if !self:CanPrimaryAttack() then
		return
	end

	local owner = self:GetOwner()

	if !IsValid(owner) then
		return
	end

	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()
	local normalEnemy = nil

	if isNPC && owner.GetEnemy then
		normalEnemy = owner:GetEnemy()
	end

	local explosiveTarget = nil
	local explosiveVictim = nil

	if isNPC then
		explosiveTarget, explosiveVictim = FindExplosiveTarget(owner)
	end

	local spawnPos

	if self.GetBulletPos then
		spawnPos = self:GetBulletPos()
	else
		spawnPos = owner:GetShootPos()
	end

	if !spawnPos then
		spawnPos = owner:GetShootPos()
	end

	local aimPos = nil

	if IsValid(explosiveTarget) && IsValid(explosiveVictim) then
		aimPos = explosiveTarget:WorldSpaceCenter()

	elseif IsValid(normalEnemy) then
		if owner.GetAimPosition then
			aimPos = owner:GetAimPosition(normalEnemy, spawnPos, 0)
		else
			aimPos = normalEnemy:WorldSpaceCenter()
		end

	elseif isPly then
		aimPos = owner:GetEyeTrace().HitPos
	else
		return
	end

	if !aimPos then
		return
	end

	self:SetNextPrimaryFire(curTime + self.Primary.Delay)
	if isNPC && owner.IsVJBaseSNPC then
		timer.Simple(self.NPC_ExtraFireSoundTime, function()
			if IsValid(self) && IsValid(owner) then
				VJ.EmitSound(owner, self.NPC_ExtraFireSound, self.NPC_ExtraFireSoundLevel, math.Rand(self.NPC_ExtraFireSoundPitch.a, self.NPC_ExtraFireSoundPitch.b))
			end
		end)
	end
	
	-- Firing Sounds
	if SERVER then
		local fireSd = VJ.PICK(self.Primary.Sound)
		if fireSd != false then
			self:EmitSound(fireSd, self.Primary.SoundLevel, math.random(self.Primary.SoundPitch.a, self.Primary.SoundPitch.b), self.Primary.SoundVolume, CHAN_WEAPON, 0, 0, VJ_RecipientFilter)
			//EmitSound(fireSd, owner:GetPos(), owner:EntIndex(), CHAN_WEAPON, 1, 140, 0, 100, 0, filter)
			//sound.Play(fireSd, owner:GetPos(), self.Primary.SoundLevel, math.random(self.Primary.SoundPitch.a, self.Primary.SoundPitch.b), self.Primary.SoundVolume)
		end
		if self.Primary.HasDistantSound then
			local fireFarSd = VJ.PICK(self.Primary.DistantSound)
			if fireFarSd != false then
				-- Use "CHAN_AUTO" instead of "CHAN_WEAPON" otherwise it will override primary firing sound because it's also "CHAN_WEAPON"
				self:EmitSound(fireFarSd, self.Primary.DistantSoundLevel, math.random(self.Primary.DistantSoundPitch.a, self.Primary.DistantSoundPitch.b), self.Primary.DistantSoundVolume, CHAN_AUTO, 0, 0, VJ_RecipientFilter)
			end
		end
	end
	
	-- Firing Gesture
	if owner.IsVJBaseSNPC_Human && owner.AnimTbl_WeaponAttackGesture then
		owner:PlayAnim(owner.AnimTbl_WeaponAttackGesture, false, false, false, 0, {AlwaysUseGesture = true})
	end

	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = (aimPos - spawnPos):GetNormal() //Gets where you're aiming
		local spread = 0.01 or self.NPC_CustomSpread
		bullet.Spread = Vector(spread, spread, 0)
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = self.Primary.Tracer
		bullet.TracerName       = self.Primary.TracerType
		bullet.Force = self.Primary.Force 
		local damage = self.Primary.Damage

		if owner.ScaleByDifficulty then
			damage = owner:ScaleByDifficulty(damage)
		end

		bullet.Damage = damage
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tracer, tr, dmginfo)
				local effectdata = EffectData()
				effectdata:SetOrigin(tracer.HitPos)
				effectdata:SetNormal(tracer.HitNormal)
				effectdata:SetRadius( 10 )
				util.Effect( "AR2Impact", effectdata )

				local ef = EffectData()
				ef:SetEntity( self )
				ef:SetFlags( 5 ) -- Sets the Combine AR2 Muzzle flash
				util.Effect( "MuzzleFlash", ef )
		end
		owner:FireBullets(bullet);
		self:TakePrimaryAmmo(1) 
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local aimPos = Vector(-9, 0, -32)
	local aimAng = Angle(0, 0, 0)
	local matLaser = Material("sprites/baku_burntcer_smoke")
	local matSprite = Material("sprites/blueglow2")
	local laserColor = Color(100, 220, 255, 64)
	local spriteColor = Color(0, 64, 255, 255)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnDrawWorldModel()
	local owner = self:GetOwner()
		if IsValid(owner) then
			local attach = self:GetAttachment(self:LookupAttachment("laser"))
			local attachPos = attach.Pos
			local attachAng = attach.Ang
			local endPos = attachPos + attachAng:Forward()*10000 + attachAng:Up()*820 + attachAng:Right()*680
			local tr = util.TraceLine({
				start = attachPos,
				endpos = endPos,
				filter = self,
			})
			render.SetMaterial(matLaser)
			render.DrawBeam(attachPos, tr.HitPos, 2, 0, 5, laserColor)
			render.SetMaterial(matSprite)
			render.DrawSprite(attachPos, 3, 3, spriteColor)
			if tr.Hit == true then
				render.SetMaterial(matSprite)
				render.DrawSprite(tr.HitPos, math.random(4, 6), math.random(4, 6), spriteColor)
			end
		end
		return true
	end
end