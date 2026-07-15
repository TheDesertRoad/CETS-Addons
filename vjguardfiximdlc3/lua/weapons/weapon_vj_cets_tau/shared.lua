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
SWEP.NPC_CanBePickedUp = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_hl2_taucannon.mdl"
SWEP.WorldModel = "models/weapons/w_hl2_taucannon.mdl"
SWEP.ViewModelFlip = false

SWEP.Purpose = false
 
SWEP.AutoSwitchTo = true
SWEP.UseHands = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 2
SWEP.Slot = 4
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
SWEP.SpinAmmoDrainRate = 0.4
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
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()
	self:StopSound(self.Secondary.Sound)

	if IsValid(owner) then
		self.Owner:StopSound(self.Secondary.Sound)
	end
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnDeploy()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if isPly then
		self:SetWeaponHoldType( self.HoldType )
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.5 )
	
		self:StopChargeSound()

		self.Spin = 0
		self.SpinTimer = CurTime()

		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

		self.Recoil = 0
		self.RecoilTimer = CurTime()

		return true
	else
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
		self:StopChargeSound()

		self.Spin = 0
		self.SpinTimer = CurTime()

		self.Idle = 0
		self.IdleTimer = CurTime()

		self.Recoil = 0
		self.RecoilTimer = CurTime()

		return true
	else
		self.Primary.ClipSize = 999999
		self.Primary.DefaultClip = 999999
		self.Primary.MaxAmmo = 999999
	end
end

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

				if IsValid(ent) and ent ~= self then
					local dmg = DamageInfo()
					dmg:SetAttacker(self.Owner)
					dmg:SetInflictor(self)
					dmg:SetDamage(self.Primary.Damage)
					dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK)) -- Change to any damage type you want
					dmg:SetDamagePosition(tracer.HitPos)

					if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
						ent:TakeDamageInfo(dmg)
					end
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
function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()
	local spawnPos = self:GetBulletPos()

	if isPly then

	if self.Weapon:Ammo1() <= 0 then return end
	if not IsValid(owner) then return end
	if not owner:Alive() then return end
	if owner:GetActiveWeapon() ~= self then return end

	if self.Spin == 1 then return end
		if self.Weapon:Ammo1() <= 5 then
			self.Weapon:EmitSound( "Cets_Weapon_Tau.FireNOO" )
			self:SetNextPrimaryFire( CurTime() + 0.2 )
			self:SetNextSecondaryFire( CurTime() + 0.2 )
			self:StopChargeSound()
			self.Spin = 0
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end

		if self.Weapon:Ammo1() >= 6 then
			self:EmitSound( self.Secondary.Sound )
			self:TakePrimaryAmmo( 5 )
			self.Weapon:SendWeaponAnim( ACT_GAUSS_SPINUP )
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		end

	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
		self.Weapon:EmitSound( "Cets_Weapon_Tau.FireNOO" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
	end

	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end

	self.Spin = 1
	self.SpinTimer = CurTime() + 7

	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

	end
end
--------------------------------------------------------------------------------|
function SWEP:CustomOnThink()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()
	local spawnPos = self:GetBulletPos()

	if isPly then
		for _, v in ipairs(player.GetAll()) do
		
			if not IsValid(v) or not owner:Alive() then
				self:StopChargeSound()
				self.Spin = 0
				return
			end

			if owner:GetActiveWeapon() ~= self then
				self:StopChargeSound()
				self.Spin = 0
				return
			end

			if self.Spin == 1 and not self.Owner:KeyDown(IN_ATTACK2) then
				local bullet = {}
				bullet.Num = self.Primary.NumberofShots
				bullet.Src = self.Owner:GetShootPos()
				bullet.Ang = self.Owner:GetAngles()
				bullet.Dir = self.Owner:GetAimVector()
				bullet.Spread = Vector( 1 * self.Primary.Spread, 1 * self.Primary.Spread, 0 )
				bullet.Tracer = 1
				bullet.TracerName       = "cets_taubeam_tracer_b"
				bullet.Force = self.Primary.Force
				bullet.Damage = 0
				bullet.AmmoType = self.Primary.Ammo
				bullet.Callback = function(attacker, tracer, tr, dmginfo)
					self:SparksHuge(attacker, tracer, tr, dmginfo)
					local tr = self.Owner:GetEyeTrace()
					local effectdata = EffectData()
						effectdata:SetOrigin( tracer.HitPos )
						effectdata:SetNormal( tr.HitNormal )
						effectdata:SetStart( self.Owner:GetShootPos() )
						effectdata:SetAttachment( 1 )
						effectdata:SetEntity( self.Weapon )
					util.Effect( "effect_cets_taubeam_b", effectdata )
					util.Decal("redglowfade", tracer.HitPos, tr.HitPos - tr.HitNormal)
					local radius = 8

					for _, ent in ipairs(ents.FindInSphere(tracer.HitPos, radius)) do
						if not IsValid(ent) then continue end
						if ent == self.Owner then continue end
						if not SERVER then return end

						if IsValid(ent) and ent ~= self then
							local dmg = DamageInfo()
							dmg:SetAttacker(self.Owner)
							dmg:SetInflictor(self)
							dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
	
							if self.SpinTimer > CurTime() + 6.5 and self.SpinTimer <= CurTime() + 7 then
								dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
								dmg:SetDamage(self.Primary.Damage)
							end

							if self.SpinTimer > CurTime() + 6 and self.SpinTimer <= CurTime() + 6.5 then
								dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
								dmg:SetDamage(self.Primary.Damage * 2)
							end

							if self.SpinTimer <= CurTime() + 6 then
								dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
								dmg:SetDamage(self.Primary.Damage * 4)
							end

							if self.SpinTimer <= CurTime() + 3 then
								dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
								dmg:SetDamage(self.Primary.Damage * 8)
							end

							if self.SpinTimer <= CurTime() + 1 then
								dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
								dmg:SetDamage(self.Primary.Damage * 16)
							end

							dmg:SetDamagePosition(tracer.HitPos)
							dmg:SetDamageType(bit.bor(DMG_ENERGYBEAM, DMG_SHOCK))
							if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
								ent:TakeDamageInfo(dmg)
							end
						end
					end
				end

				self.Owner:FireBullets( bullet )

				self:EmitSound( self.Primary.Sound )
				self:StopSound( self.Secondary.Sound )

				if SERVER then
					self.Owner:StopSound( self.Secondary.Sound )
					self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
					self.Owner:StopSound( "Cets_Weapon_Tau.Charge" )
					self.Owner:EmitSound( "Cets_Weapon_Tau.FireAlt" )
				end		

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()

				self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
				self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
				self.Spin = 0

				self.Idle = 0
				self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

				self.Recoil = 1
				self.RecoilTimer = CurTime() + self.Primary.Delay
				self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -3, 0, 0 ) )

				if self.SpinTimer > CurTime() + 6.5 and self.SpinTimer <= CurTime() + 7 then
					self.Owner:SetVelocity( self.Owner:GetForward() * -100 )
				end

				if self.SpinTimer > CurTime() + 6 and self.SpinTimer <= CurTime() + 6.5 then
					self.Owner:SetVelocity( self.Owner:GetForward() * -200 )
				end

				if self.SpinTimer <= CurTime() + 6 then
					self.Owner:SetVelocity( self.Owner:GetForward() * -300 )
				end

				if self.SpinTimer <= CurTime() + 3 then
					self.Owner:SetVelocity( self.Owner:GetForward() * -600 )
				end

				if self.SpinTimer <= CurTime() + 1 then
					self.Owner:SetVelocity( self.Owner:GetForward() * -1000 )
				end
			end

			if self.Idle == 0 and self.IdleTimer <= CurTime() then
				if SERVER then
					if self.Spin == 0 then
						self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
					end

					if self.Spin == 1 then
						self.Weapon:SendWeaponAnim( ACT_GAUSS_SPINCYCLE )
					end
				end

				self.Idle = 1
			end

			if self.Weapon:Ammo1() > self.Primary.MaxAmmo then
				self.Owner:SetAmmo( self.Primary.MaxAmmo, self.Primary.Ammo )
			end

			if self.Spin == 1 then
				if CurTime() >= self.SpinAmmoDrainTime then
					self.SpinAmmoDrainTime = CurTime() + self.SpinAmmoDrainRate
					if SERVER then
						self:TakePrimaryAmmo(1)
						if self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
							self.Spin = 0
							self:StopChargeSound()
							return
						end
					end
				end
			end

			if self.Spin == 1 and self.SpinTimer <= CurTime() and self.Weapon:Ammo1() >= 6 then
				if SERVER then
					self.Owner:StopSound( "Cets_Weapon_Tau.Charge" )
					self.Owner:EmitSound( "Cets_HL2.Electric" )
					self.Owner:EmitSound( "Cets_Weapon_Tau.FireAlt" )

					self.Spin = 0
					self.Idle = 0
					self.Recoil = 0

					if not self.Owner:HasGodMode() then
						self:ExplodeGauss()
						ParticleEffect("grenade_explosion_01",self:GetPos(),Angle(0, 0, 0),nil)
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------|
function SWEP:Reload() 

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
	if not self.Owner:HasGodMode() then
		util.BlastDamage( self, self, self:GetPos(), 180, 300 )
		self.Owner:EmitSound( "hl1/shatter.wav" )
		self.Owner:EmitSound( "hl1/discreturn.wav" )
	end
end