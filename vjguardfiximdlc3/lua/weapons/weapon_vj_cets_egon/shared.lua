if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Gluon Gun"
SWEP.Category = "Half-Life 2"
SWEP.Author		= "VALVe"
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false
SWEP.NPC_CanBePickedUp = false

SWEP.ViewModelFOV = 86
SWEP.ViewModel = "models/weapons/c_hl2_egon.mdl"
SWEP.WorldModel = "models/weapons/w_hl2_egon.mdl"
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
SWEP.SpinTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.Recoil = 0
SWEP.RecoilTimer = CurTime()

SWEP.Temp = 0
SWEP.HasFiredGauss = false
SWEP.SpinAmmoDrainTime = 0
SWEP.SpinAmmoDrainRate = 0.2
SWEP.SpinAmmoDrainRateS = 0.4

SWEP.Firing = false
SWEP.LoopStartTime = 0

SWEP.Mode = 0
SWEP.ModeC = 0

SWEP.StopS = 0

SWEP.DroppedW = 1
--------------------------------------------------------------------------------|
SWEP.Primary.Sound = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 20
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "UraniumEnergy_CETS"
SWEP.Primary.TracerType       = "cets_taubeam_tracer"
SWEP.Primary.Damage = 26
SWEP.Primary.Spread = 0
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.Force = false
SWEP.Primary.TakeAmmo = 1
--------------------------------------------------------------------------------|
SWEP.Secondary.Sound = "Cets_Weapon_Tau.Charge"
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Delay = 2
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Damage = 16
SWEP.Secondary.TakeAmmo = 1
--------------------------------------------------------------------------------|
SWEP.NPC_NextPrimaryFire = 4
SWEP.NPC_TimeUntilFireExtraTimers = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5}
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
		self:SetWeaponHoldType( "physgun" )
		self.Idle = 0
		self.IdleTimer = CurTime() + 1
	elseif isNPC then
		self:SetWeaponHoldType( "ar2" )
		self.Primary.ClipSize = 999999
		self.Primary.DefaultClip = 999999
		self.Primary.MaxAmmo = 999999
	end

	self.Firing = false
	self.LoopStartTime = 0

	self.FireLoop = CreateSound(self, "hl1/weapons/egon_run3.wav")
	self.FireLoop:SetSoundLevel(80)
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnDeploy()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if self.FireLoop then
		self.FireLoop:Stop()
	end

	self:StopSound("hl1/weapons/egon_off1.wav")

	if IsValid(owner) then
		self.Owner:StopSound("hl1/weapons/egon_off1.wav")
		self:StopSound("hl1/weapons/egon_off1.wav")
	end

	if isPly then
		self:StopSound("hl1/weapons/egon_off1.wav")
		self:SetWeaponHoldType( "physgun" )
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.5 )

		self.Spin = 0
		self.SpinTimer = CurTime()

		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

		self.Recoil = 0
		self.RecoilTimer = CurTime()

		return true
	else
		self:SetWeaponHoldType( "ar2" )
		self.Primary.ClipSize = 999999
		self.Primary.DefaultClip = 999999
		self.Primary.MaxAmmo = 999999
	end
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnHolster()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if isPly then
		self:SetWeaponHoldType( "physgun" )
		self:StopSound("hl1/weapons/egon_off1.wav")
		self.Spin = 0
		self.SpinTimer = CurTime()

		self.Idle = 0
		self.IdleTimer = CurTime()

		self.Recoil = 0
		self.RecoilTimer = CurTime()

		return true
	else
		self:SetWeaponHoldType( "ar2" )
		self:StopSound("hl1/weapons/egon_off1.wav")
		self.Primary.ClipSize = 999999
		self.Primary.DefaultClip = 999999
		self.Primary.MaxAmmo = 999999
	end

	if self.FireLoop then
		self.FireLoop:Stop()
	end

	return true
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

	if not self.Firing then
		self.Firing = true
		self:EmitSound("hl1/weapons/egon_windup2.wav")
		self.LoopStartTime = CurTime() + SoundDuration("hl1/weapons/egon_windup2.wav") - 0.2
	end

	local ene = owner:GetEnemy()
	local aimPos = owner:GetAimPosition(ene, spawnPos, 0)
	local spread = owner:GetAimSpread(ene, aimPos, self.NPC_CustomSpread or 1)

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
		bullet.Spread = Vector(spread, spread, 0)
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = self.Primary.Tracer
		bullet.TracerName       = self.Primary.TracerType
		bullet.Force = self.Primary.Force 
		bullet.Damage = 0
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Angles = self:GetAngles()
		bullet.Callback = function(attacker, tracer, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart(self.Owner:GetShootPos())
					effectdata:SetOrigin(tracer.HitPos)
					effectdata:SetNormal(tracer.HitNormal)
					effectdata:SetAttachment( 1 )
					effectdata:SetEntity( self.Weapon )
					effectdata:SetRadius( 10 )
				util.Effect("effect_cets_egonbeam", effectdata )

				local radius = 64

				for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius)) do
					if not IsValid(ent) then continue end
					if ent == self.Owner then continue end
					if not SERVER then return end

					if IsValid(ent) and ent ~= self then
						local dmg = DamageInfo()
						dmg:SetAttacker(self.Owner)
						dmg:SetInflictor(self)
						dmg:SetDamage(self.Primary.Damage / 2)
						dmg:SetDamageType(bit.bor(DMG_ALWAYSGIB, DMG_ENERGYBEAM)) -- Change to any damage type you want
						dmg:SetDamagePosition(tracer.HitPos)

						if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
							ent:TakeDamageInfo(dmg)
						end
					end
				end

			ParticleEffect("egon_beam_cloud1", tracer.HitPos, Angle(0, 0, 0), nil)
			return {effects = false}
		end

		owner:FireBullets(bullet);
	
		local targetPos = ene:GetPos() + ene:OBBCenter()
		local randPos = targetPos

		util.ParticleTracerEx("egon_beam_wave_B", self:GetAttachment(1).Pos, randPos, false, self:EntIndex(), 1)

		self.NextStopFireLoop = CurTime() + 0.2

		if self.Firing and CurTime() >= self.LoopStartTime then
			if self.FireLoop and not self.FireLoop:IsPlaying() then
				self.FireLoop:PlayEx(1, 100)
			end
		end

	elseif isPly then

		if not self.Firing then
			if self.Weapon:Ammo1() <= 0 then return end
			self.Firing = true
			self:EmitSound("hl1/weapons/egon_windup2.wav")
			self.LoopStartTime = CurTime() + SoundDuration("hl1/weapons/egon_windup2.wav") - 0.2
		end

		if self.Weapon:Ammo1() <= 0 then return end
		if not IsValid(owner) then return end
		if not owner:Alive() then return end
		if owner:GetActiveWeapon() ~= self then return end

		if self.Spin == 1 then return end

		if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
			self.Weapon:EmitSound( "Cets_Weapon_Tau.FireNOO" )
			self:SetNextPrimaryFire( CurTime() + 0.2 )
			self:SetNextSecondaryFire( CurTime() + 0.2 )
		end
		local tr = self.Owner:GetEyeTrace()
			if IsValid(self) then
				local effectdata = EffectData()
					effectdata:SetStart(self.Owner:GetShootPos())
					effectdata:SetOrigin(tr.HitPos)
					effectdata:SetNormal(tr.HitNormal)
					effectdata:SetAttachment( 1 )
					effectdata:SetEntity( self.Weapon )
					effectdata:SetRadius( 10 )

				if self.Mode == 0 then
					ParticleEffect("egon_beam_cloud1", tr.HitPos, Angle(0, 0, 0), nil)
					util.Effect("effect_cets_egonbeam", effectdata )
					local radius = 24

					for _, ent in ipairs(ents.FindInSphere(tr.HitPos, radius)) do
						if not IsValid(ent) then continue end
						if not SERVER then return end

						if IsValid(ent) and ent ~= self then
							local dmg = DamageInfo()
							dmg:SetAttacker(self.Owner)
							dmg:SetInflictor(self)
							dmg:SetDamage(self.Primary.Damage)
							dmg:SetDamageType(bit.bor(DMG_ALWAYSGIB, DMG_ENERGYBEAM, DMG_SONIC)) -- Change to any damage type you want
							dmg:SetDamagePosition(tr.HitPos)

							if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
								ent:TakeDamageInfo(dmg)
							end
						end
					end
				else
					ParticleEffect("egon_beam_cloud1_weak", tr.HitPos, Angle(0, 0, 0), nil)
					util.Effect("effect_cets_egonbeam_weak", effectdata )
					local radius = 12

					for _, ent in ipairs(ents.FindInSphere(tr.HitPos, radius)) do
						if not IsValid(ent) then continue end
						if not SERVER then return end

						if IsValid(ent) and ent ~= self then
							local dmg = DamageInfo()
							dmg:SetAttacker(self.Owner)
							dmg:SetInflictor(self)
							if not ent == self.Owner then
								dmg:SetDamage(self.Secondary.Damage)
							else
								dmg:SetDamage(3)
							end
							dmg:SetDamageType(bit.bor(DMG_ALWAYSGIB, DMG_ENERGYBEAM, DMG_SONIC)) -- Change to any damage type you want
							dmg:SetDamagePosition(tr.HitPos)

							if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
								ent:TakeDamageInfo(dmg)
							end
						end

					end
				end
			end

		local radius = 24

		for _, ent in ipairs(ents.FindInSphere(tr.HitPos, radius * 2)) do
			if not IsValid(ent) then continue end
			if not SERVER then return end

			if IsValid(ent) and ent ~= self then
				if SERVER and ent:IsPlayer() then
					ent:SetDSP(30, false)
					timer.Simple(0.1, function()
						if IsValid(ent) then
							ent:SetDSP(0, false)
						end
					end)
				end
			end
		end

		local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Ang = self.Owner:GetAngles()
		bullet.Spread = Vector( 1 * self.Primary.Spread, 1 * self.Primary.Spread, 0 )
		bullet.Tracer = 0
		bullet.TracerName       = self.Primary.TracerType
		bullet.Force = self.Primary.Force
		bullet.Damage = 0
		bullet.AmmoType = self.Primary.Ammo
		bullet.Callback = function(attacker, tracer, tr, dmginfo)
			return {effects = false}
		end
		self.Owner:FireBullets( bullet )
		self.NextStopFireLoop = CurTime() + 0.2

		if self.Firing and CurTime() >= self.LoopStartTime then
			if self.FireLoop and not self.FireLoop:IsPlaying() then
				self.FireLoop:PlayEx(1, 100)
			end
		end

		if self.Mode == 0 then
			if CurTime() >= self.SpinAmmoDrainRate then
				self:TakePrimaryAmmo(1)
				self.SpinAmmoDrainRate = CurTime() + 0.1
			end
		else
			if CurTime() >= self.SpinAmmoDrainRate then
				self:TakePrimaryAmmo(1)
				self.SpinAmmoDrainRate = CurTime() + 0.24
			end
		end

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

		if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end

		local tr = self.Owner:GetEyeTrace()
		local hitPos = tr.HitPos

		if self.Mode == 0 then
			util.ParticleTracerEx("egon_beam_wave_B", self.Owner:GetShootPos(), hitPos, false, self:EntIndex(), 1)
		else
			util.ParticleTracerEx("egon_beam_wave_B_weak", self.Owner:GetShootPos(), hitPos, false, self:EntIndex(), 1)
		end

		self.Owner:ViewPunch( Angle( math.random(-.4, .4), .1, .3 ) ) 
		if CurTime() >= (self.NextVMAnim or 0) then
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self.NextVMAnim = CurTime() + vm:SequenceDuration()
			end
		end

		self.Owner:SetAnimation(PLAYER_ATTACK1)

		if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	end
end
--------------------------------------------------------------------------------|
function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextPrimaryFire(CurTime() + 1)

	self:StopSound("hl1/weapons/egon_run3.wav")

	if IsValid(owner) then
		self.Owner:StopSound("hl1/weapons/egon_run3.wav")
	end

	timer.Simple(0.1, function()
		if not IsValid(self) or self.ModeC == 1 then return end

		local vm = self:GetOwner():GetViewModel()
		local seq = vm:LookupSequence("fidget1")

		if seq >= 0 then
			vm:SendViewModelMatchingSequence(seq)
		end

		self.ModeC = 1

		self:EmitSound("hl1/weapons/ump45_clipin.wav")

		timer.Simple(0.1, function()
			if not IsValid(self) then return end

			if self.Mode == 0 then
				self.Mode = 1
			else
				self.Mode = 0
			end

			timer.Simple(0.1, function() if not IsValid(self) then return end self.ModeC = 0 end)
		end)
	end)
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnThink()
	local owner = self:GetOwner()

	if self.Firing then

		local stop = false

		if owner:IsPlayer() then
			stop = not owner:KeyDown(IN_ATTACK) or self:Ammo1() == 0

		elseif owner:IsNPC() then
			stop = CurTime() > (self.NextStopFireLoop or 0)
		end

		if stop then
			self.Firing = false

			self:SendWeaponAnim(ACT_VM_IDLE)

			if self.FireLoop and self.FireLoop:IsPlaying() then
				self.FireLoop:Stop()
			end

			self:StopSound("hl1/weapons/egon_windup2.wav")
			owner:StopSound("hl1/weapons/egon_windup2.wav")
			self:StopSound("hl1/weapons/egon_run3.wav")
			owner:StopSound("hl1/weapons/egon_run3.wav")

			self:EmitSound("hl1/weapons/egon_off1.wav")
		end
	end

	if owner:IsPlayer() and self:Ammo1() > self.Primary.MaxAmmo then
		owner:SetAmmo(self.Primary.MaxAmmo, self.Primary.Ammo)
	end
end
--------------------------------------------------------------------------------|
function SWEP:OwnerDeath()
	if self.FireLoop then
		self.FireLoop:Stop()
	end

	self:StopSound("hl1/weapons/egon_run3.wav")
	self:StopSound("hl1/weapons/egon_windup2.wav")

	if IsValid(self:GetOwner()) then
		self:GetOwner():StopSound("hl1/weapons/egon_run3.wav")
		self:GetOwner():StopSound("hl1/weapons/egon_windup2.wav")
	end

	self.Firing = false
end
--------------------------------------------------------------------------------|
function SWEP:Reload()

end
--------------------------------------------------------------------------------|
function SWEP:OnRemove()
	self:OwnerDeath()
end