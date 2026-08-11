if not file.Exists("autorun/vj_base_autorun.lua", "LUA") then return end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("CETS_TauPrimaryBeam")
	util.AddNetworkString("CETS_TauExplosion")
end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Tau Cannon"
SWEP.Category = "Half-Life 2"
SWEP.Author = "VALVe"
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false
SWEP.FiresUnderwater = false

SWEP.HoldType = "ar2"

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_hl2_taucannon.mdl"
SWEP.WorldModel = "models/weapons/w_hl2_taucannon.mdl"
SWEP.ViewModelFlip = false

SWEP.Purpose = false

SWEP.AutoSwitchTo = true
SWEP.UseHands = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 2
SWEP.Slot = 3
SWEP.SlotPos = 4
--------------------------------------------------------------------------------|
SWEP.Spin = 0
SWEP.SpinTimer = 0
SWEP.SpinAmmoDrainTime = 0
SWEP.SpinAmmoDrainRate = 0.4

SWEP.GaussChargeDuration = 7
SWEP.GaussAmmoDrainRate = 0.4
SWEP.GaussNextAmmoDrain = 0
SWEP.GaussRecoilStart = 0
SWEP.GaussRecoilDuration = 0
SWEP.GaussRecoilForce = 0
SWEP.GaussRecoilDirection = vector_origin
--------------------------------------------------------------------------------|
SWEP.Primary.Sound = "Cets_Weapon_Tau.Fire"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 24
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "UraniumEnergy_CETS"
SWEP.Primary.TracerType = "cets_taubeam_tracer"
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.025
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Delay = 0.2
SWEP.Primary.Force = 1
SWEP.Primary.TakeAmmo = 1
--------------------------------------------------------------------------------|
SWEP.Secondary.Sound = "Cets_Weapon_Tau.Charge"
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.TakeAmmo = 5
--------------------------------------------------------------------------------|
SWEP.NPC_NextPrimaryFire = 0.8
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_CustomSpread = 0.4
SWEP.NPC_ReloadSound = "hl1/weapons/aug_boltslap.wav"
SWEP.NPC_HasSecondaryFire = false
--------------------------------------------------------------------------------|
function SWEP:SetupDataTables()
	if self.BaseClass && self.BaseClass.SetupDataTables then
		self.BaseClass.SetupDataTables(self)
	end

	self:NetworkVar("Bool", 0, "GaussCharging")
	self:NetworkVar("Float", 0, "GaussChargeStart")
end
--------------------------------------------------------------------------------|
function SWEP:DrawWorldModel()
	if not IsValid(self) then
		return
	end

	self:DrawModel()
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnInitialize()
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	if owner:IsPlayer() then
		self:SetWeaponHoldType(self.HoldType)
		self.Idle = 0
		self.IdleTimer = CurTime() + 1

	elseif owner:IsNPC() then
		self.Primary.ClipSize = 999999999
		self.Primary.DefaultClip = 999999999
		self.Primary.MaxAmmo = 999999999
		self:SetClip1(999999999)

		self.Reloading = false

		self:SetNextPrimaryFire(0)
		self:SetNextSecondaryFire(0)
	end
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnDeploy()
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	self:SetGaussCharging(false)
	self:SetGaussChargeStart(0)

	self.Spin = 0
	self.SpinTimer = 0
	self.GaussNextAmmoDrain = 0
	self.GaussRecoilStart = 0
	self.GaussRecoilDuration = 0
	self.GaussRecoilForce = 0
	self.GaussRecoilDirection = vector_origin

	self:StopChargeSound()

	if owner:IsPlayer() then
		self:SetWeaponHoldType(self.HoldType)

		self.Idle = 0
		self.Recoil = 0
		self.IdleTimer = CurTime() + 1

		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:SetNextSecondaryFire(CurTime() + 0.5)

		self:SendWeaponAnim(ACT_VM_DRAW)

		if IsValid(owner:GetViewModel()) then
			self.IdleTimer = CurTime() + owner:GetViewModel():SequenceDuration()
		end
	end

	return true
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnHolster()
	local owner = self:GetOwner()

	self:SetGaussCharging(false)
	self:SetGaussChargeStart(0)

	self.Spin = 0
	self.SpinTimer = 0
	self.GaussNextAmmoDrain = 0
	self.GaussRecoilStart = 0
	self.GaussRecoilDuration = 0
	self.GaussRecoilForce = 0
	self.GaussRecoilDirection = vector_origin

	self:StopChargeSound()

	if IsValid(owner) && owner:IsPlayer() then
		self.Idle = 0
		self.IdleTimer = CurTime()
		self.Recoil = 0
		self.RecoilTimer = CurTime()

		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	return true
end
--------------------------------------------------------------------------------|
function SWEP:GetWorldModelAttachment(name)
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	for _, ent in ipairs(owner:GetChildren()) do
		if ent:GetModel() == self.WorldModel then
			local id = ent:LookupAttachment(name)

			if id > 0 then
				return ent:GetAttachment(id)
			end
		end
	end
end
--------------------------------------------------------------------------------|
function SWEP:StopChargeSound()
	self:StopSound(self.Secondary.Sound)

	local owner = self:GetOwner()

	if IsValid(owner) then
		owner:StopSound(self.Secondary.Sound)
	end
end
--------------------------------------------------------------------------------|
function SWEP:PrimaryAttack(UseAlt)
	local curTime = CurTime()
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	if owner:IsNPC() then
		local curTime = CurTime()

		self.Reloading = false

		if self:GetNextPrimaryFire() > curTime then
			return
		end

		local enemy = owner:GetEnemy()


		if not IsValid(enemy) then
			return
		end

		local shootPos = owner:GetShootPos()
		local aimPos

		if owner.GetAimPosition then
			aimPos = owner:GetAimPosition(enemy, shootPos, 0)
		else
			aimPos = enemy:WorldSpaceCenter()
		end

		if not aimPos then
			aimPos = enemy:WorldSpaceCenter()
		end

		local shootDir = (aimPos - shootPos):GetNormalized()
		local bullet = {}

		bullet.Num = 1
		bullet.Src = shootPos
		bullet.Dir = shootDir
		bullet.Spread = Vector(0.01, 0.01, 0)
		bullet.Tracer = 1
		bullet.TracerName = self.Primary.TracerType
		bullet.Force = self.Primary.Force or 1
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo
		bullet.Callback = function(attacker, tracer, tr, dmginfo)
			if not SERVER then
				return
			end

			local hitPos = tracer.HitPos
			local hitNormal = tracer.HitNormal

			self:SparksHuge(attacker, tracer, tr, dmginfo)
			self:CreateGaussBeam(hitPos, hitNormal, shootPos)
			util.Decal("redglowfade", hitPos, hitPos - hitNormal)

			local Beffectdata = EffectData()

			Beffectdata:SetOrigin(hitPos)
			Beffectdata:SetNormal(hitNormal)
			Beffectdata:SetStart(shootPos)
			Beffectdata:SetSurfaceProp(tr.SurfaceProps or 0)
			Beffectdata:SetDamageType(DMG_BULLET)

			util.Effect("Impact", Beffectdata, true, true)

			for _, ent in ipairs(ents.FindInSphere(hitPos, 8)) do
				if not IsValid(ent) then
					continue
				end

				if ent == owner then
					continue
				end

				if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
					local info = DamageInfo()

					info:SetAttacker(owner)
					info:SetInflictor(self)
					info:SetDamage(self.Primary.Damage)
					info:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
					info:SetDamagePosition(hitPos)

					ent:TakeDamageInfo(info)
				end
			end

			for _, ent in ipairs(ents.FindInSphere(hitPos, 64)) do
				if not IsValid(ent) then
					continue
				end

				if ent == owner then
					continue
				end

				local class = ent:GetClass()

				if class == "npc_turret_floor" then
					ent:Fire("SelfDestruct")
				elseif class == "npc_rollermine" then
					ent:Fire("RespondToExplodeChirp")
				elseif class == "npc_helicopter" then
					local blast = DamageInfo()

					blast:SetAttacker(owner)
					blast:SetInflictor(self)
					blast:SetDamage(self.Primary.Damage)
					blast:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT, DMG_ENERGYBEAM, DMG_SHOCK, DMG_GENERIC))
					blast:SetDamagePosition(hitPos)

					ent:TakeDamageInfo(blast)
				end
			end
		end

		owner:FireBullets(bullet)

		if SERVER then
			local sound = VJ.PICK(self.Primary.Sound)

			if sound ~= false then
				owner:EmitSound("Cets_Weapon_Tau.FireAlt", self.Primary.SoundLevel or 75, math.random(self.Primary.SoundPitch.a, self.Primary.SoundPitch.b), self.Primary.SoundVolume or 1, CHAN_WEAPON)
			end
		end

		if owner.IsVJBaseSNPC_Human && owner.AnimTbl_WeaponAttackGesture then
			owner:PlayAnim(owner.AnimTbl_WeaponAttackGesture, false, false, false, 0, {AlwaysUseGesture = true})
		end

		self:SetClip1(999999)
		self:SetNextPrimaryFire(curTime + self.Primary.Delay)

		return
	end

	if self:GetGaussCharging() then
		return
	end

	if self.Spin == 1 then
		return
	end

	if self:Ammo1() <= 0 then
		if SERVER then
			owner:EmitSound("Cets_Weapon_Tau.FireNOO")
		end

		self:SetNextPrimaryFire(curTime + 0.2)
		self:SetNextSecondaryFire(curTime + 0.2)

		return
	end

	if self.FiresUnderwater == false && owner:WaterLevel() == 3 then
		if SERVER then
			owner:EmitSound("Cets_Weapon_Tau.FireNOO")
		end

		self:SetNextPrimaryFire(curTime + 0.2)
		self:SetNextSecondaryFire(curTime + 0.2)

		return
	end

	local shootPos = owner:GetShootPos()
	local aimVector = owner:GetAimVector()
	local bullet = {}

	bullet.Num = self.Primary.NumberofShots
	bullet.Src = owner:GetShootPos()
	bullet.Dir = owner:GetAimVector()
	bullet.Ang = owner:GetAngles()
	bullet.Spread = Vector(self.Primary.Spread, self.Primary.Spread,0)
	bullet.Tracer = 0
	bullet.Force = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = self.Primary.Ammo
	bullet.Callback = function(attacker, tracer, tr, dmginfo)
		local hitPos = tracer.HitPos
		local hitNormal = tracer.HitNormal

		self:SparksSmall(attacker, tracer, tr, dmginfo)
		self:CreatePrimaryBeam(hitPos, hitNormal, shootPos)

		util.Decal("redglowfade", hitPos, hitPos - hitNormal)

		for _, ent in ipairs(ents.FindInSphere(hitPos, 8)) do
			if not IsValid(ent) then
				continue
			end

			if ent == owner then
				continue
			end

			if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
				local damageInfo = DamageInfo()

				damageInfo:SetAttacker(owner)
				damageInfo:SetInflictor(self)
				damageInfo:SetDamage(self.Primary.Damage)
				damageInfo:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
				damageInfo:SetDamagePosition(hitPos)

				ent:TakeDamageInfo(damageInfo)
			end
		end

		for _, ent in ipairs(ents.FindInSphere(hitPos, 64)) do
			if not IsValid(ent) then
				continue
			end

			if ent == owner then
				continue
			end

			local class = ent:GetClass()

			if class == "npc_turret_floor" then
				ent:Fire("SelfDestruct")
			elseif class == "npc_rollermine" then
				ent:Fire("RespondToExplodeChirp")
			elseif class == "npc_helicopter" then
				local blast = DamageInfo()

				blast:SetAttacker(owner)
				blast:SetInflictor(self)
				blast:SetDamage(self.Primary.Damage)
				blast:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT, DMG_ENERGYBEAM, DMG_SHOCK, DMG_GENERIC))
				blast:SetDamagePosition(hitPos)

				ent:TakeDamageInfo(blast)
				ent:SetHealth(ent:Health() - self.Primary.Damage)
			end
		end
	end

	owner:FireBullets(bullet)

	if SERVER then
		owner:EmitSound(self.Primary.Sound, 75, 100, 1, CHAN_WEAPON)
		self:TakePrimaryAmmo(1)
	end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	owner:SetAnimation(PLAYER_ATTACK1)
	owner:MuzzleFlash()

	self:SetNextPrimaryFire(curTime + self.Primary.Delay)
	self:SetNextSecondaryFire(curTime + self.Primary.Delay)

	self.Idle = 0

	if IsValid(owner:GetViewModel()) then
		self.IdleTimer = CurTime() + owner:GetViewModel():SequenceDuration()
	end

	if IsFirstTimePredicted() then
		self.Recoil = 1
		self.RecoilTimer = CurTime() + self.Primary.Delay
		owner:ViewPunch(Angle(-2, 0, 0))
	end 
end
--------------------------------------------------------------------------------|
function SWEP:StartGaussCharge()
	local owner = self:GetOwner()

	if not IsValid(owner) or not owner:IsPlayer() then
		return
	end

	if not owner:Alive() then
		return
	end

	if owner:GetActiveWeapon() ~= self then
		return
	end

	if self:GetGaussCharging() then
		return
	end

	if self.FiresUnderwater == false && owner:WaterLevel() >= 3 then
		if SERVER then
			owner:EmitSound("Cets_Weapon_Tau.FireNOO", 75, 100, 1, CHAN_WEAPON)
		end

		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)

		return
	end

	if self:Ammo1() < 6 then
		if SERVER then
			owner:EmitSound("Cets_Weapon_Tau.FireNOO", 75, 100, 1, CHAN_WEAPON)
		end

		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)

		return
	end

	local chargeStart = CurTime()

	self:SetGaussCharging(true)
	self:SetGaussChargeStart(chargeStart)

	self.Spin = 1
	self.SpinTimer = chargeStart + self.GaussChargeDuration
	self.GaussNextAmmoDrain = chargeStart + self.GaussAmmoDrainRate

	self:SetNextPrimaryFire(chargeStart + 0.2)
	self:SetNextSecondaryFire(chargeStart + 0.2)

	self.Idle = 0

	self:SendWeaponAnim(ACT_GAUSS_SPINUP)

	if IsValid(owner:GetViewModel()) then
		self.IdleTimer = CurTime() + owner:GetViewModel():SequenceDuration()
	end

	if SERVER then
		owner:EmitSound(self.Secondary.Sound, 75, 100, 1, CHAN_WEAPON)
		self:TakePrimaryAmmo(5)
	end
end
--------------------------------------------------------------------------------|
function SWEP:StopGaussCharge()
	self.Spin = 0
	self.SpinTimer = 0
	self.GaussNextAmmoDrain = 0

	self:StopChargeSound()

	self:SendWeaponAnim(ACT_VM_IDLE)

	self.Idle = 0
	self.IdleTimer = CurTime()
end
--------------------------------------------------------------------------------|
function SWEP:SecondaryAttack()
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	if not owner:IsPlayer() then
		return
	end

	if not owner:Alive() then
		return
	end

	if owner:GetActiveWeapon() ~= self then
		return
	end

	if self.Reloading then
		return
	end

	if self:GetGaussCharging() then
		return
	end

	local curTime = CurTime()

	if self:GetNextSecondaryFire() > curTime then
		return
	end

	if self:GetNextPrimaryFire() > curTime then
		return
	end

	if self.FiresUnderwater == false && owner:WaterLevel() >= 3 then
		if SERVER then
			owner:EmitSound("Cets_Weapon_Tau.FireNOO")
		end

		self:SetNextPrimaryFire(curTime + 0.2)
		self:SetNextSecondaryFire(curTime + 0.2)

		return
	end

	if self:Ammo1() < 6 then
		if SERVER then
			owner:EmitSound("Cets_Weapon_Tau.FireNOO")
		end

		self:SetNextPrimaryFire(curTime + 0.2)
		self:SetNextSecondaryFire(curTime + 0.2)

		return
	end

	self:StartGaussCharge()
end
--------------------------------------------------------------------------------|
function SWEP:GetGaussChargeProgress()
	if not self:GetGaussCharging() then
		return 0
	end

	local elapsed = CurTime() - self:GetGaussChargeStart()

	return math.Clamp(elapsed / self.GaussChargeDuration, 0, 1)
end
--------------------------------------------------------------------------------|
function SWEP:GetGaussDamage()
	local progress = self:GetGaussChargeProgress()
	local minDamage = self.Primary.Damage * 3
	local maxDamage = self.Primary.Damage * 28
	local charge = progress * progress

	return minDamage + (maxDamage - minDamage) * charge
end
--------------------------------------------------------------------------------|
function SWEP:GetGaussPush()
	local progress = math.Clamp(self:GetGaussChargeProgress(), 0, 1)
	local minPush = 256
	local maxPush = 1536

	return minPush + (maxPush - minPush) * progress
end
--------------------------------------------------------------------------------|
function SWEP:CreateGaussBeam(pos, normal, startPos)
	local effectdata = EffectData()

	effectdata:SetOrigin(pos)
	effectdata:SetNormal(normal)
	effectdata:SetStart(startPos)
	effectdata:SetAttachment(1)
	effectdata:SetEntity(self)

	util.Effect("effect_cets_taubeam_b", effectdata, true, true)
end
--------------------------------------------------------------------------------|
function SWEP:CreatePrimaryBeam(pos, normal, startPos)
	local effectdata = EffectData()

	effectdata:SetOrigin(pos)
	effectdata:SetNormal(normal)
	effectdata:SetStart(startPos)
	effectdata:SetAttachment(1)
	effectdata:SetEntity(self)

	util.Effect("effect_cets_taubeam", effectdata, true, true)
end
--------------------------------------------------------------------------------|
function SWEP:FireGaussBeam()
	if not SERVER then
		return
	end

	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	if not owner:Alive() then
		return
	end

	local damage = self:GetGaussDamage()
	local push = self:GetGaussPush()
	local shootPos = owner:GetShootPos()
	local aimVector = owner:GetAimVector()

	local bullet = {}

	bullet.Num = 1
	bullet.Src = shootPos
	bullet.Dir = aimVector
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 1
	bullet.TracerName = "cets_taubeam_tracer_b"
	bullet.Damage = 0
	bullet.Force = push
	bullet.AmmoType = self.Primary.Ammo
	bullet.Callback = function(attacker, tracer, tr, dmginfo)
		local hitPos = tracer.HitPos
		local hitNormal = tracer.HitNormal

		self:SparksHuge(attacker, tracer, tr, dmginfo)
		self:CreateGaussBeam(hitPos, hitNormal, shootPos)

		util.Decal("redglowfade", hitPos, hitPos - hitNormal)

		for _, ent in ipairs(ents.FindInSphere(hitPos, 12)) do
			if not IsValid(ent) then
				continue
			end

			if ent == owner then
				continue
			end

			if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
				local damageInfo = DamageInfo()

				damageInfo:SetAttacker(owner)
				damageInfo:SetInflictor(self)
				damageInfo:SetDamage(damage)
				damageInfo:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
				damageInfo:SetDamagePosition(hitPos)

				ent:TakeDamageInfo(damageInfo)
			end
		end

		for _, ent in ipairs(ents.FindInSphere(hitPos, 64)) do
			if not IsValid(ent) then
				continue
			end

			if ent == owner then
				continue
			end

			local class = ent:GetClass()

			if class == "npc_turret_floor" then
				ent:Fire("SelfDestruct")
			elseif class == "npc_rollermine" then
				ent:Fire("RespondToExplodeChirp")
			elseif class == "npc_helicopter" then
				local blast = DamageInfo()

				blast:SetAttacker(owner)
				blast:SetInflictor(self)
				blast:SetDamage(damage)
				blast:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT, DMG_ENERGYBEAM,DMG_SHOCK))
				blast:SetDamagePosition(hitPos)

				ent:TakeDamageInfo(blast)
			end
		end
		return dmginfo
	end

	owner:FireBullets(bullet)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	owner:SetAnimation(PLAYER_ATTACK1)
	owner:MuzzleFlash()

	self:StopChargeSound()

	owner:EmitSound("Cets_Weapon_Tau.FireAlt", 75, 100, 1, CHAN_WEAPON)
	owner:ViewPunch(Angle(-3, 0, 0))
	owner:SetVelocity(-aimVector * push)

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = 0

	if IsValid(owner:GetViewModel()) then
		self.IdleTimer = CurTime() + owner:GetViewModel():SequenceDuration()
	end
end
--------------------------------------------------------------------------------|
function SWEP:ExplodeGauss()
	if not SERVER then
		return
	end

	local owner = self:GetOwner()

	if not IsValid(owner) or owner:HasGodMode() then
		return
	end

	local pos = owner:GetShootPos()

	util.BlastDamage(self, owner, pos, 180, 300)
	util.ScreenShake(pos, 8, 100, 0.5, 500)

	owner:EmitSound("hl1/shatter.wav")
	owner:EmitSound("hl1/discreturn.wav")
	owner:EmitSound("Cets_HL2.Electric", 75, 100, 1, CHAN_WEAPON)
	owner:EmitSound("Cets_Weapon_Tau.FireAlt", 75, 100, 1, CHAN_WEAPON)

	local effectdata = EffectData()

	effectdata:SetOrigin(pos)
	effectdata:SetScale(2)

	util.Effect("cball_explode", effectdata, true, true)

	net.Start("CETS_TauExplosion")
	net.WriteVector(pos)
	net.Broadcast()
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnThink()
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	if owner:IsPlayer() then
		if self.GaussRecoilStart > 0 then
			local elapsed = CurTime() - self.GaussRecoilStart

			if elapsed >= self.GaussRecoilDuration then
				self.GaussRecoilStart = 0
				self.GaussRecoilDuration = 0
				self.GaussRecoilForce = 0
			elseif SERVER then
				local progress = elapsed / self.GaussRecoilDuration
				local scale = 1 - (progress * progress)

				owner:SetVelocity(self.GaussRecoilDirection * self.GaussRecoilForce * FrameTime() * 60 * scale)
			end
		end

		if not self:GetGaussCharging() then
			return
		end

		if not owner:Alive() or owner:GetActiveWeapon() ~= self or self.Reloading then
			if SERVER then
				self:SetGaussCharging(false)
			end

			self:StopGaussCharge()

			return
		end

		if self.FiresUnderwater == false && owner:WaterLevel() >= 3 then
			if SERVER then
				self:SetGaussCharging(false)
			end

			self:StopGaussCharge()

			return
		end

		if self.Idle == 1 then
			self:SendWeaponAnim(ACT_GAUSS_SPINCYCLE)

			self.Idle = 0

			if IsValid(owner:GetViewModel()) then
				self.IdleTimer = CurTime() + owner:GetViewModel():SequenceDuration()
			end
		end

		if not SERVER then
			return
		end

		if CurTime() >= self.GaussNextAmmoDrain then
			self.GaussNextAmmoDrain = CurTime() + self.GaussAmmoDrainRate

			if self:Ammo1() > 0 then
				self:TakePrimaryAmmo(1)
			else
				self:SetGaussCharging(false)
				self:StopGaussCharge()

				return
			end
		end

		if not owner:KeyDown(IN_ATTACK2) then
			self:FireGaussBeam()
			self:SetGaussCharging(false)
			self:StopGaussCharge()

			return
		end

		if CurTime() >= self:GetGaussChargeStart() + self.GaussChargeDuration then
			self:SetGaussCharging(false)
			self:StopGaussCharge()
			self:ExplodeGauss()

			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

			return
		end
	end
end
--------------------------------------------------------------------------------|
function SWEP:SparksSmall(attacker, tracer, tr, dmginfo)
	if not SERVER then
		return
	end

	local ent = ents.Create("env_spark")

	if not IsValid(ent) then
		return
	end

	ent:SetPos(tracer.HitPos)
	ent:SetKeyValue("Magnitude", 4)
	ent:SetKeyValue("Spark Trail Length", 1.5)

	ent:Spawn()
	ent:Activate()

	ent:Fire("StartSpark", "", 0)
	ent:Fire("StopSpark", "", 0.1)

	SafeRemoveEntityDelayed(ent, 0.2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SparksHuge(attacker, tracer, tr, dmginfo)
	if not SERVER then
		return
	end

	local ent = ents.Create("env_spark")

	if not IsValid(ent) then
		return
	end

	ent:SetPos(tracer.HitPos)
	ent:SetKeyValue("Magnitude", 8)
	ent:SetKeyValue("Spark Trail Length", 3)

	ent:Spawn()
	ent:Activate()

	ent:Fire("StartSpark", "", 0)
	ent:Fire("StopSpark", "", 0.1)

	SafeRemoveEntityDelayed(ent, 0.2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	net.Receive("CETS_TauExplosion", function()
		local pos = net.ReadVector()

		ParticleEffect("grenade_explosion_01", pos, Angle(0, 0, 0), nil)
	end)

	function SWEP:CreateWeaponSelectionFonts(height)
		local scale = (height*0.8)/64 --ScrH()/480
		
		surface.CreateFont("CETS_TAUfont_Glow", {
			font = "CETS",
			size = math.min(36*scale, 150), --165
			weight = 500,
			antialias = true,
			additive = true,
			blursize = 5*scale,
			scanlines = 2*scale
		})

		surface.CreateFont("CETS_TAUfont", {
			font = "CETS",
			size = math.min(36*scale, 150), --150
			weight = 500,
			antialias = true,
			additive = true
		})
		
	end

	local function GetHUDColor()
		local path = "resource/ClientScheme.res"

		if not file.Exists(path, "GAME") then
			return Color(255, 220, 0, 220)
		end

		local contents = file.Read(path, "GAME")
		if not contents then
			return Color(255, 220, 0, 220)
		end

		local r, g, b, a = contents:match([["FgColorHud"%s*"(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"]])

		if not r then
			return Color(255, 220, 0, 220)
		end

		return Color(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
	end

	local prevScrH = nil

	SWEP.DrawWeaponSelection = function(self, x, y, w, h, alpha)
		self.PrintName = "TAU CANNON"
		if h != prevScrH then
			self:CreateWeaponSelectionFonts(h)
			prevScrH = h
		end
			local hudColor = GetHUDColor()
		
			r = hudColor.r
			g = hudColor.g
			b = hudColor.b

		local glowAlpha = 255

		local icon = "o"
		local cx = x + w / 2
		local cy = y + h / 2

		draw.SimpleText(icon, "CETS_TAUfont_Glow", cx, cy, Color(r, g, b, glowAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(icon, "CETS_TAUfont", cx, cy, Color(r, g, b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end