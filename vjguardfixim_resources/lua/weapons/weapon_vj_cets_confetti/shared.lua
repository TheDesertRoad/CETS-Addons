if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_smg1"
SWEP.PrintName = "Confetti!"
SWEP.Author = "Me"
SWEP.Category = "Other"
SWEP.HoldType = "grenade"
SWEP.Spawnable = true
SWEP.Purpose = false
SWEP.Weight = 0.1
SWEP.Slot = 0
SWEP.SlotPos = 128

SWEP.MadeForNPCsOnly = false
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 	
SWEP.ViewModel = "models/weapons/c_hands_cets_ki.mdl"
SWEP.WorldModel = false
SWEP.ReplacementWeapon = false

SWEP.RegenerationTimer = CurTime()
--------------------------------------------------------------------------------|
SWEP.Primary.Sound = 	"friends/surprise_confetti.wav"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 4096
SWEP.Primary.MaxAmmo = 4096
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = nil
SWEP.Primary.TakeAmmo = 0
SWEP.Primary.Delay = 1
SWEP.Primary.Force = 100
--------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--------------------------------------------------------------------------------|
SWEP.NPC_NextPrimaryFire = 1.4
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.3, 0.4, 0.7, 0.8, 0.9, 1}
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack()
	if self.Owner:IsNPC() then
		local ef = EffectData()
			ef:SetEntity( self )
			ef:SetFlags( 1 )
			util.Effect( "MuzzleFlash", ef )
	end
end
--------------------------------------------------------------------------------|
function SWEP:Deploy()
		self:SetWeaponHoldType( self.HoldType )
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.5 )
		self.RegenerationTimer = CurTime() + 0.3
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		self.Recoil = 0
		self.RecoilTimer = CurTime()
	return true
end
--------------------------------------------------------------------------------|
function SWEP:Holster()
		self.RegenerationTimer = CurTime() + 0.3
		self.Idle = 0
		self.IdleTimer = CurTime()
		self.Recoil = 0
		self.RecoilTimer = CurTime()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
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
		local fireSd = VJ.PICK("Cets_Weapon_MP5K.NPC_Single")
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
		local spread = 0.15 or self.NPC_CustomSpread
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
				local dmginfo = DamageInfo()
				local effectdata = EffectData()
				local ef = EffectData()
				ef:SetEntity( self )
				ef:SetFlags( 1 ) -- Sets the Combine AR2 Muzzle flash
				util.Effect( "MuzzleFlash", ef )

				dmginfo:SetWeapon(self)
				dmginfo:SetInflictor(self)
				return self:OnPrimaryAttack_BulletCallback(attacker, tracer, tr, dmginfo)
		end
		owner:FireBullets(bullet);
		self:TakePrimaryAmmo(1) 

	elseif isPly then

	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
		self.Weapon:EmitSound("weapons/ar2/ar2_empty.wav")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)
		return
	end

	local tr = self.Owner:GetEyeTrace()
	local hitPos = tr.HitPos
	ParticleEffect("cets_achieved", hitPos, Angle(0, 0, 0), nil)
	ParticleEffect("cets_achieved", hitPos, Angle(0, 0, 0), nil)

	if ( self.Primary.BulletShot ) then
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = self.Owner:GetAimVector() //Gets where you're aiming
		bullet.Spread = Vector( 0.01, 0.01, 0.01)
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = 0
		bullet.Force = self.Primary.Force 
		bullet.Damage = 1 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tracer)
			return {effects = false}
		end
		self.Owner:FireBullets( bullet );
	end

		local PlayerPos = self.Owner:GetShootPos()
		local PlayerAim = self.Owner:GetAimVector()
 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
	
		self:TakePrimaryAmmo(1) 

		self:ShootEffects()	
		self.Weapon:MuzzleFlash()	
		self.RegenerationTimer = CurTime() + 1
		self:EmitSound(Sound(self.Primary.Sound)) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end

	if self.RegenerationTimer <= CurTime() and self.Weapon:Ammo1() < self.Primary.MaxAmmo then
		self.Owner:SetAmmo( self.Weapon:Ammo1() + 1, self.Primary.Ammo )
		self.RegenerationTimer = CurTime() + 1
	end

	if self.Idle == 0 and self.IdleTimer <= CurTime() then
		if SERVER then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end
		self.Idle = 1
	end

	if self.Weapon:Ammo1() > self.Primary.MaxAmmo then
		self.Owner:SetAmmo( self.Primary.MaxAmmo, self.Primary.Ammo )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Reload()

end