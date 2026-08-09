if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Tau Cannon"
SWEP.Category = "Half-Life 2"
SWEP.Author		= "VALVe"
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false
SWEP.FiresUnderwater = false

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

SWEP.GaussCharging = false
SWEP.GaussChargeStart = 0
SWEP.GaussChargeDuration = 7
SWEP.GaussNextAmmoDrain = 0
SWEP.GaussAmmoDrainRate = 0.4
--------------------------------------------------------------------------------|
SWEP.Primary.Sound = "Cets_Weapon_Tau.Fire"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 20
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "UraniumEnergy_CETS"
SWEP.Primary.TracerType       = "cets_taubeam_tracer"
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
function SWEP:CustomOnInitialize()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if isPly then
		self:SetWeaponHoldType( self.HoldType )
		self.Idle = 0
		self.IdleTimer = CurTime() + 1
	elseif isNPC then
		self.Primary.ClipSize = 999999
		self.Primary.DefaultClip = 999999
		self.Primary.MaxAmmo = 999999
	end
end
--------------------------------------------------------------------------------|
function SWEP:StopChargeSound()
	local owner = self:GetOwner()

	self:StopSound(self.Secondary.Sound)

	if IsValid(owner) then
		owner:StopSound(self.Secondary.Sound)
	end
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnDeploy()
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	self.GaussCharging = false
	self.GaussAttack2WasDown = false
	self.Spin = 0
	self.SpinTimer = 0
	self.GaussChargeStart = 0

	if owner:IsPlayer() then
		self:SetWeaponHoldType(self.HoldType)

		self:StopChargeSound()

		self.SpinTimer = CurTime()
		self.Idle = 0
		self.Recoil = 0

		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:SetNextSecondaryFire(CurTime() + 0.5)

		if SERVER then
			self:SendWeaponAnim(ACT_VM_DRAW)
		end

		if IsValid(owner:GetViewModel()) then
			self.IdleTimer = CurTime() + owner:GetViewModel():SequenceDuration()
		else
			self.IdleTimer = CurTime() + 1
		end
	end

	return true
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnHolster()
	local owner = self:GetOwner()

	self.GaussCharging = false
	self.GaussAttack2WasDown = false
	self.Spin = 0
	self.SpinTimer = 0
	self.GaussChargeStart = 0

	self:StopChargeSound()

	if IsValid(owner) and owner:IsPlayer() then
		self.Idle = 0
		self.IdleTimer = CurTime()
		self.Recoil = 0
		self.RecoilTimer = CurTime()

		if SERVER then
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end

	return true
end
--------------------------------------------------------------------------------|
function SWEP:GetWorldModelAttachment(name)
	local owner = self:GetOwner()
	if !IsValid(owner) then return end

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
function SWEP:PrimaryAttack(UseAlt)
	//if self:GetOwner():KeyDown(IN_RELOAD) then return end
	//self:GetOwner():SetFOV(45, 0.3)
	//if !IsFirstTimePredicted() then return end
	local curTime = CurTime()
	self:SetNextPrimaryFire(curTime + self.Primary.Delay)
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()
	local spawnPos = self:GetBulletPos()

	if isNPC then

	local ene = owner:GetEnemy()
	local aimPos

	if owner.GetAimPosition then
		aimPos = owner:GetAimPosition(ene, spawnPos, 0)
	else
		aimPos = ene:WorldSpaceCenter()
	end

	local spread = owner.GetAimSpread and owner:GetAimSpread(ene, aimPos, self.NPC_CustomSpread or 1) or (self.NPC_CustomSpread or 1)

	if self.Reloading or self:GetNextSecondaryFire() > curTime then return end
	if isNPC && !owner.VJ_IsBeingControlled && !IsValid(owner:GetEnemy()) then return end -- If the NPC owner isn't being controlled and doesn't have an enemy, then return end
	if !self.IsMeleeWeapon && ((isPly && !self.Primary.AllowInWater && owner:WaterLevel() == 3) or (self:Clip1() <= 0)) then
		if SERVER then
			owner:EmitSound(VJ.PICK(self.DryFireSound), self.DryFireSoundLevel, math.random(self.DryFireSoundPitch.a, self.DryFireSoundPitch.b))
		end
		return
	end
	if !self:CanPrimaryAttack() then return end
	if self:OnPrimaryAttack("Init") == true then return end
	
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
		bullet.Damage = 0
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Angles = self:GetAngles()
		bullet.Callback = function(attacker, tracer, tr, dmginfo)
				local dmginfo = DamageInfo()

				self.Spark1 = ents.Create("env_spark")
					self.Spark1:SetPos(tracer.HitPos)
					self.Spark1:Spawn()
					self.Spark1:SetKeyValue("Magnitude",8)
					self.Spark1:SetKeyValue("Spark Trail Length",3)
					self.Spark1:Fire("StartSpark", "", 0)
					self.Spark1:Fire("StopSpark", "", 0.1)
				self:DeleteOnRemove(self.Spark1)

				local radius = 8

				for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius)) do
					if not IsValid(ent) then continue end
					if ent == self.Owner then continue end
					if not SERVER then return end

					if IsValid(ent) and ent ~= self then
						local dmg = DamageInfo()
						dmg:SetAttacker(self.Owner)
						dmg:SetInflictor(self)
						dmg:SetDamage(40)
						dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM)) -- Change to any damage type you want
						dmg:SetDamagePosition(tracer.HitPos)

						if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
							ent:TakeDamageInfo(dmg)
						end
					end
				end


				local radius1 = 64

				for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius1)) do
					if not IsValid(ent) then continue end
					if ent == self.Owner then continue end
					if not SERVER then return end

					local class = ent:GetClass()

					if class == "npc_turret_floor" then
						ent:Fire("SelfDestruct")
					end

					if class == "npc_rollermine" then
						ent:Fire("RespondToExplodeChirp")
					end
	
					if class == "npc_helicopter" then
						local blast = DamageInfo()

						blast:SetAttacker(self.Owner)
						blast:SetInflictor(self)
						blast:SetDamage(self.Primary.Damage)
						blast:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT, DMG_ENERGYBEAM, DMG_SHOCK, DMG_GENERIC))
						blast:SetDamagePosition(tracer.HitPos)
						ent:TakeDamageInfo(blast)
						ent:SetHealth(ent:Health() - self.Primary.Damage)
					end
				end

				local effectdata = EffectData()
					effectdata:SetOrigin( tracer.HitPos )
					effectdata:SetNormal( tracer.HitNormal )
					effectdata:SetStart( owner:GetAimPosition(ene, spawnPos, 0) )
					effectdata:SetAttachment( 1 )
					effectdata:SetEntity( self.Weapon )
				util.Effect( "effect_cets_taubeam_b", effectdata )
				util.Decal("redglowfade", tracer.HitPos, tracer.HitPos - tracer.HitNormal)

				dmginfo:SetWeapon(self)
				dmginfo:SetInflictor(self)
				return self:OnPrimaryAttack_BulletCallback(attacker, tracer, tr, dmginfo)
		end
		owner:FireBullets(bullet);
	else

	if self.Spin == 1 then return end
		if self.Weapon:Ammo1() <= 0 then
			self.Weapon:EmitSound( "Cets_Weapon_Tau.FireNOO" )
			self:SetNextPrimaryFire( CurTime() + 0.2 )
			self:SetNextSecondaryFire( CurTime() + 0.2 )
		end

		if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
			self.Weapon:EmitSound( "Cets_Weapon_Tau.FireNOO" )
			self:SetNextPrimaryFire( CurTime() + 0.2 )
			self:SetNextSecondaryFire( CurTime() + 0.2 )
		end

		if self.Weapon:Ammo1() <= 0 then return end
		if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end
				local tr = self.Owner:GetEyeTrace()

		local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Ang = self.Owner:GetAngles()
		bullet.Spread = Vector( 1 * self.Primary.Spread, 1 * self.Primary.Spread, 0 )
		bullet.Tracer = 1
		bullet.TracerName       = "cets_taubeam_tracer"
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo
		bullet.Callback = function(attacker, tracer, tr, dmginfo)
			self:SparksSmall(attacker, tracer, tr, dmginfo)
			local tr = self.Owner:GetEyeTrace()
			local effectdata = EffectData()
				effectdata:SetOrigin( tracer.HitPos )
				effectdata:SetNormal( tr.HitNormal )
				effectdata:SetStart( self.Owner:GetShootPos() )
				effectdata:SetAttachment( 1 )
				effectdata:SetEntity( self.Weapon )
			util.Effect( "effect_cets_taubeam", effectdata )
			util.Decal("redglowfade", tracer.HitPos, tr.HitPos - tr.HitNormal)

			local radius = 8

			for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius)) do
				if not IsValid(ent) then continue end
				if ent == self.Owner then continue end
				if not SERVER then return end

				local class = ent:GetClass()

				if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then

				local dmg = DamageInfo()

				dmg:SetAttacker(self.Owner)
				dmg:SetInflictor(self)
				dmg:SetDamage(self.Primary.Damage)
				dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
				dmg:SetDamagePosition(tracer.HitPos)

				ent:TakeDamageInfo(dmg)

				end
			end

			local radius1 = 64

			for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius1)) do
				if not IsValid(ent) then continue end
				if ent == self.Owner then continue end
				if not SERVER then return end

				local class = ent:GetClass()

				if class == "npc_turret_floor" then
					ent:Fire("SelfDestruct")
				end

				if class == "npc_rollermine" then
					ent:Fire("RespondToExplodeChirp")
				end

				if class == "npc_helicopter" then
					local blast = DamageInfo()

					blast:SetAttacker(self.Owner)
					blast:SetInflictor(self)
					blast:SetDamage(self.Primary.Damage)
					blast:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT, DMG_ENERGYBEAM, DMG_SHOCK, DMG_GENERIC))
					blast:SetDamagePosition(tracer.HitPos)
					ent:TakeDamageInfo(blast)
					ent:SetHealth(ent:Health() - self.Primary.Damage)
				end
			end
		end

		self.Owner:FireBullets( bullet )

		self:EmitSound( self.Primary.Sound )
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
		if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
			self.Recoil = 1
			self.RecoilTimer = CurTime() + self.Primary.Delay
			self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -3, 0, 0 ) )
		end
	end
end
--------------------------------------------------------------------------------|
function SWEP:StartGaussCharge()
	if not SERVER then return end

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

	if self.GaussCharging then
		return
	end

	if self.FiresUnderwater == false and owner:WaterLevel() >= 3 then
		self:StopGaussCharge()
		owner:EmitSound("Cets_Weapon_Tau.FireNOO")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)
		return
	end

	local ammo = self:Ammo1()

	if ammo < 6 then
		owner:EmitSound("Cets_Weapon_Tau.FireNOO")

		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)

		return
	end

	self.GaussCharging = true
	self.GaussChargeStart = CurTime()
	self.GaussNextAmmoDrain = CurTime() + self.GaussAmmoDrainRate

	self.Spin = 1
	self.SpinTimer = CurTime() + self.GaussChargeDuration

	self:EmitSound(self.Secondary.Sound, 75, 100)

	self:SendWeaponAnim(ACT_GAUSS_SPINUP)

	self:SetNextPrimaryFire(CurTime() + 0.2)
	self:SetNextSecondaryFire(CurTime() + 0.2)

	self.Idle = 0

	if IsValid(owner:GetViewModel()) then
		self.IdleTimer =
			CurTime() + owner:GetViewModel():SequenceDuration()
	end
end
--------------------------------------------------------------------------------|
function SWEP:StopGaussCharge()
	self.GaussCharging = false

	self.Spin = 0
	self.SpinTimer = 0

	self:StopSound(self.Secondary.Sound)

	local owner = self:GetOwner()

	if IsValid(owner) then
		owner:StopSound(self.Secondary.Sound)
	end

	if SERVER and IsValid(owner) then
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
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

	if self.GaussCharging then
		return
	end

	local curTime = CurTime()

	if self:GetNextSecondaryFire() > curTime then
		return
	end

	if self:GetNextPrimaryFire() > curTime then
		return
	end

	if self.FiresUnderwater == false and owner:WaterLevel() >= 3 then
		owner:EmitSound("Cets_Weapon_Tau.FireNOO")

		self:SetNextPrimaryFire(curTime + 0.2)
		self:SetNextSecondaryFire(curTime + 0.2)

		return
	end

	if self:Ammo1() < 6 then
		owner:EmitSound("Cets_Weapon_Tau.FireNOO")

		self:SetNextPrimaryFire(curTime + 0.2)
		self:SetNextSecondaryFire(curTime + 0.2)

		return
	end

	self:StartGaussCharge()
	self:TakePrimaryAmmo( 5 )
end
--------------------------------------------------------------------------------|
function SWEP:GetGaussChargeProgress()
	if not self.GaussCharging then
		return 0
	end

	local elapsed = CurTime() - self.GaussChargeStart

	return math.Clamp(elapsed / self.GaussChargeDuration, 0, 1)
end
--------------------------------------------------------------------------------|
function SWEP:GetGaussDamage()
	local progress = self:GetGaussChargeProgress()

	if progress >= 0.95 then
		return self.Primary.Damage * 32
	elseif progress >= 0.80 then
		return self.Primary.Damage * 16
	elseif progress >= 0.43 then
		return self.Primary.Damage * 8
	elseif progress >= 0.14 then
		return self.Primary.Damage * 4
	end

	return self.Primary.Damage
end
--------------------------------------------------------------------------------|
function SWEP:GetGaussPush()
	local progress = self:GetGaussChargeProgress()

	if progress >= 0.95 then
		return 1000
	elseif progress >= 0.80 then
		return 600
	elseif progress >= 0.43 then
		return 300
	elseif progress >= 0.14 then
		return 200
	end

	return 100
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
	bullet.Force = self.Primary.Force
	bullet.Damage = 0
	bullet.AmmoType = self.Primary.Ammo
	bullet.Callback = function(attacker, tracer, tr, dmginfo)
		if not IsValid(self) then
			return
		end

		if not IsValid(owner) then
			return
		end

		local tr = self.Owner:GetEyeTrace()
		local effectdata = EffectData()
			effectdata:SetOrigin( tracer.HitPos )
			effectdata:SetNormal( tr.HitNormal )
			effectdata:SetStart( self.Owner:GetShootPos() )
			effectdata:SetAttachment( 1 )
			effectdata:SetEntity( self.Weapon )
		util.Effect( "effect_cets_taubeam_b", effectdata )
		util.Decal("redglowfade", tracer.HitPos, tr.HitPos - tr.HitNormal)
		self:SparksHuge(attacker, tracer, tr, dmginfo)

		local radius = 16

		for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius)) do
			if not IsValid(ent) then continue end
			if ent == self.Owner then continue end
			if not SERVER then return end

			local class = ent:GetClass()

			if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then

			local dmg = DamageInfo()

			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamage(damage)
			dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
			dmg:SetDamagePosition(tracer.HitPos)

			ent:TakeDamageInfo(dmg)

			end
		end

		local radius1 = 64

		for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius1)) do
			if not IsValid(ent) then continue end
			if ent == self.Owner then continue end
			if not SERVER then return end

			local class = ent:GetClass()

			if class == "npc_turret_floor" then
				ent:Fire("SelfDestruct")
			end

			if class == "npc_rollermine" then
				ent:Fire("RespondToExplodeChirp")
			end

			if class == "npc_helicopter" then
				local blast = DamageInfo()

				blast:SetAttacker(self.Owner)
				blast:SetInflictor(self)
				blast:SetDamage(self.Primary.Damage)
				blast:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT, DMG_ENERGYBEAM, DMG_SHOCK, DMG_GENERIC))
				blast:SetDamagePosition(tracer.HitPos)
				ent:TakeDamageInfo(blast)
				ent:SetHealth(ent:Health() - self.Primary.Damage)
			end
		end
	end

	owner:FireBullets(bullet)

	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

	owner:SetAnimation(PLAYER_ATTACK1)
	owner:MuzzleFlash()

	self:StopSound(self.Secondary.Sound)
	owner:StopSound(self.Secondary.Sound)

	self:EmitSound("Cets_Weapon_Tau.FireAlt")

	owner:ViewPunch(Angle(-3, 0, 0))

	local pushDirection = -aimVector

	owner:SetVelocity(pushDirection * push * 2)

	local remainingForce = push * 0.40
	local duration = 0.16
	local steps = 10

	for i = 1, steps do
		timer.Simple(i * (duration / steps), function()
			if not IsValid(owner) then
				return
			end

			local t = i / steps
			local scale = 1 - (t * t)

			owner:SetVelocity(pushDirection * ((remainingForce / steps) * scale))
		end)
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnThink()
	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	if not owner:IsPlayer() then
		return
	end

	if self.GaussCharging then
		if not owner:Alive() or owner:GetActiveWeapon() ~= self or self.Reloading then
			self:StopGaussCharge()
			return
		end

		if self.FiresUnderwater == false and owner:WaterLevel() >= 3 then
			self:StopGaussCharge()
			return
		end

		if CurTime() >= self.GaussNextAmmoDrain then
			self.GaussNextAmmoDrain = CurTime() + self.GaussAmmoDrainRate

			if self:Ammo1() > 0 then
				self:TakePrimaryAmmo(1)
			else
				self:StopGaussCharge()
				return
			end
		end

		if not owner:KeyDown(IN_ATTACK2) then
			self:FireGaussBeam()
			self.GaussCharging = false
			self.Spin = 0
			self.SpinTimer = 0

			self.Idle = 0

			if IsValid(owner:GetViewModel()) then
				self.IdleTimer = CurTime() + owner:GetViewModel():SequenceDuration()
			end

			return
		end

		if CurTime() >= self.GaussChargeStart + self.GaussChargeDuration then
			self:StopSound(self.Secondary.Sound)
			owner:StopSound(self.Secondary.Sound)

			self:EmitSound("Cets_HL2.Electric")
			self:EmitSound("Cets_Weapon_Tau.FireAlt")
			self.GaussCharging = false
			self.Spin = 0
			self.SpinTimer = 0

			self:ExplodeGauss()

			local effectPos = owner:GetShootPos()

			ParticleEffect("grenade_explosion_01", effectPos, Angle(0, 0, 0), nil)

			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

			return
		end

		if self.Idle == 1 then
			self:SendWeaponAnim(ACT_GAUSS_SPINCYCLE)

			self.Idle = 0

			if IsValid(owner:GetViewModel()) then
				self.IdleTimer =
					CurTime()
					+ owner:GetViewModel():SequenceDuration()
			end
		end
	end
end
--------------------------------------------------------------------------------|
function SWEP:SparksSmall(attacker, tracer, tr, dmginfo)
	local dmginfo = DamageInfo()
	if SERVER then
		local ent = ents.Create("env_spark")
		if IsValid(ent) then
			ent:SetPos(tracer.HitPos)
			ent:SetKeyValue("Magnitude",4)
			ent:SetKeyValue("Spark Trail Length",1.5)
			ent:Fire("StartSpark", "", 0)
			ent:Fire("StopSpark", "", 0.1)
			ent:Spawn()
			ent:Activate()
		end
	end

	dmginfo:SetWeapon(self)
	dmginfo:SetInflictor(self)
end
--------------------------------------------------------------------------------|
function SWEP:SparksHuge(attacker, tracer, tr, dmginfo)
	local dmginfo = DamageInfo()
	if SERVER then
		local ent = ents.Create("env_spark")
		if IsValid(ent) then
			ent:SetPos(tracer.HitPos)
			ent:SetKeyValue("Magnitude",8)
			ent:SetKeyValue("Spark Trail Length",3)
			ent:Fire("StartSpark", "", 0)
			ent:Fire("StopSpark", "", 0.1)
			ent:Spawn()
			ent:Activate()
		end
	end

	dmginfo:SetWeapon(self)
	dmginfo:SetInflictor(self)
end
--------------------------------------------------------------------------------|
function SWEP:ExplodeGauss()
	if not SERVER then
		return
	end

	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	if owner:HasGodMode() then
		return
	end

	local pos = owner:GetShootPos()

	util.BlastDamage(self, owner, pos, 180, 300)

	util.ScreenShake(pos, 8, 100, 0.5, 500)

	owner:EmitSound("hl1/shatter.wav")
	owner:EmitSound("hl1/discreturn.wav")

	local effectdata = EffectData()

	effectdata:SetOrigin(pos)
	effectdata:SetScale(2)

	util.Effect("cball_explode", effectdata, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
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