if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "HECU Sniper"
SWEP.Author = "VALVe"
SWEP.Category = "Half-Life 2"
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.Purpose = false
SWEP.NPC_CanBePickedUp = false

SWEP.MadeForNPCsOnly = false
SWEP.UseHands = true
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 	
SWEP.ViewModel		= "models/weapons/c_hl2_m40a1.mdl"	
SWEP.WorldModel		= "models/weapons/w_hl2_m40a1.mdl"
SWEP.ReplacementWeapon = false
SWEP.ViewModelFOV			= 80
--------------------------------------------------------------------------------|
SWEP.Primary.Sound				= "Cets_Weapon_Sniper_Rifle.Single"
SWEP.Primary.Damage		= GetConVar("sk_plr_cets_dmg_hecsnip"):GetInt()
SWEP.Primary.NumShots		= 1						
SWEP.Primary.Delay			= 1
SWEP.Primary.ClipSize		= GetConVar("sk_max_cets_hecsnip"):GetInt()		
SWEP.Primary.DefaultClip	                  = GetConVar("sk_max_cets_hecsnip_bullet"):GetInt()	
SWEP.Primary.Force			= 14
SWEP.Primary.Automatic		= 0	
SWEP.Primary.Ammo		= "Sniper_CETS"	
SWEP.Primary.Recoil			= 2
SWEP.Primary.BulletShot 		= true;
--------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--------------------------------------------------------------------------------|
SWEP.UseScope				= true	
SWEP.Zoom = 0
--------------------------------------------------------------------------------|
SWEP.NPC_NextPrimaryFire = 2
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
SWEP.NPC_TimeUntilFire = 0
SWEP.NPC_TimeUntilFireExtraTimers = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	if GetConVar("sk_cets_ar2scrotums_enable"):GetInt() == 1 then
		self.NPC_HasSecondaryFire = false
	else
		self.NPC_HasSecondaryFire = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack()
	if self.Owner:IsNPC() then
		local ef = EffectData()
			ef:SetEntity( self )
			ef:SetFlags( 1 )
			util.Effect( "MuzzleFlash", ef )
	end
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
		local fireSd = VJ.PICK("Cets_Weapon_Sniper_Rifle.Single")
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
		local spread = 0.08 or self.NPC_CustomSpread
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
				dmginfo:SetWeapon(self)
				dmginfo:SetInflictor(self)
				return self:OnPrimaryAttack_BulletCallback(attacker, tracer, tr, dmginfo)
		end
		owner:FireBullets(bullet);
		self:TakePrimaryAmmo(1) 

	elseif isPly then

	self.Owner:SetFOV( 0, .5 )
	self.Owner:DrawViewModel(true)
	self:EmitSound("Weapon_AR2.Special1")
	self.Zoom = 0
	self.Owner:ScreenFade( SCREENFADE.PURGE, Color( 0, 0, 0, 0 ), 0.1, 0.1 )
	self.Owner:GetCanZoom( 0 )
	self.Owner:SetCanZoom( 1 )

	if self:Clip1() <= 0 && self:Ammo1() > 0 then
		self:Reload()
	end

	if self:Clip1() <= 0 then
		self.Weapon:EmitSound("weapons/ar2/ar2_empty.wav")
			self:SetNextPrimaryFire(CurTime() + 0.2)
			self:SetNextSecondaryFire(CurTime() + 0.2)
		return
	end

	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
		self.Weapon:EmitSound("weapons/ar2/ar2_empty.wav")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)
		return
	end

	local tr = self.Owner:GetEyeTrace();

	if ( self.Primary.BulletShot ) then
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = self.Owner:GetAimVector() //Gets where you're aiming
		bullet.Spread = Vector( 0.1 * 0.1 , 0.1 * 0.1, 0)
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = 1
		bullet.TracerName       = "Tracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tracer) end
		
		self.Owner:FireBullets( bullet );
		end

		local PlayerPos = self.Owner:GetShootPos()
		local PlayerAim = self.Owner:GetAimVector()
 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
	
		self:TakePrimaryAmmo(1) 
		if self.Weapon:Clip1() > 1 then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		end
		if self.Weapon:Clip1() <= 1 then
			self.Weapon:SendWeaponAnim( ACT_GLOCK_SHOOTEMPTY )
		end
		self:ShootEffects()	
		self.Weapon:MuzzleFlash()	
		self:EmitSound(Sound(self.Primary.Sound)) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 

		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self:SetNextPrimaryFire( CurTime() + 2 )
	end

	local ang = self:GetOwner():EyeAngles()
	ang:RotateAroundAxis(ang:Up(), -90)
	local effect = EffectData()

	if isPly then
		effect:SetOrigin(self:GetOwner():GetShootPos() - self:GetUp() * 10 + self:GetForward() * 22 + self:GetRight() * 10)
	elseif isNPC then
		effect:SetOrigin(self:GetOwner():GetShootPos())
	end

	effect:SetAngles(ang)
	effect:SetEntity(self)
	util.Effect("RifleShellEject", effect)
end
--------------------------------------------------------------------------------|
function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if (self.Zoom == 0) && isPly then
		self.Owner:SetFOV( 24, .5 )
		self.Owner:DrawViewModel(false)
		self:EmitSound("Cets_Weapon_Sniper_Rifle.Zoom")
		self.Zoom = 1
		self.Owner:ScreenFade( SCREENFADE.STAYOUT, Color( 64, 255, 16, 2 ), 0.1, 0.1 )
		self.Owner:GetCanZoom( 1 )
		self.Owner:SetCanZoom( 0 )

	elseif (self.Zoom == 1) && isPly then
		self.Owner:SetFOV( 0, .5 )
		self.Owner:DrawViewModel(true)
		self:EmitSound("Weapon_AR2.Special1")
		self.Zoom = 0
		self.Owner:ScreenFade( SCREENFADE.PURGE, Color( 0, 0, 0, 0 ), 0.1, 0.1 )
		self.Owner:GetCanZoom( 0 )
		self.Owner:SetCanZoom( 1 )
	end
end
--------------------------------------------------------------------------------|
function SWEP:Reload()
	if !IsValid(self) then return end

	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if self:Ammo1() <= 0 && isPly then return end
	if self:Clip1() == self.Primary.ClipSize && isPly then return end

	if isNPC then
	local owner = funcGetOwner(self)
	if !IsValid(owner) or !owner:IsPlayer() or !owner:Alive() or owner:GetAmmoCount(self.Primary.Ammo) == 0 or self.Reloading or CurTime() < self.PLY_NextReloadT then return end
	if self:Clip1() < self.Primary.ClipSize then
		self.Reloading = true
		self:OnReload("Start")
		if SERVER && self.HasReloadSound then
			local reloadSD = VJ.PICK(self.ReloadSound)
			if reloadSD then
				owner:EmitSound(reloadSD, 50, math.random(90, 100))
			end
		end
		-- Handle clip
		timer.Simple(self.Reload_TimeUntilAmmoIsSet, function()
			if IsValid(self) && self:OnReload("Finish") != true then
				local ammoUsed = math.Clamp(self.Primary.ClipSize - self:Clip1(), 0, owner:GetAmmoCount(self:GetPrimaryAmmoType())) -- Amount of ammo that it will use (Take from the reserve)
				owner:RemoveAmmo(ammoUsed, self.Primary.Ammo)
				self:SetClip1(self:Clip1() + ammoUsed)
			end
		end)
		-- Handle animation
		owner:SetAnimation(PLAYER_RELOAD)
		local anim = VJ.PICK(self.AnimTbl_Reload)
		local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
		self:SendWeaponAnim(anim)
		self.PLY_NextIdleAnimT = CurTime() + animTime
		timer.Simple(animTime, function()
			if IsValid(self) then
				self.Reloading = false
			end
		end)
		return true
	end

	elseif isPly then
		if (self.Zoom == 1) && isPly then
			self.Owner:SetFOV( 0, .5 )
			self.Owner:DrawViewModel(true)
			self.Owner:GetCanZoom( 0 )
			self.Owner:SetCanZoom( 1 )
			self.Owner:ScreenFade( SCREENFADE.PURGE, Color( 0, 0, 0, 0 ), 0.1, 0.1 )
		end

		self.Owner:SetFOV( 0, .5 )
		self.Owner:DrawViewModel(true)
		self.Zoom = 0
		self.Owner:GetCanZoom( 0 )
		self.Owner:SetCanZoom( 1 )

		self:DefaultReload( ACT_VM_RELOAD )

		return true
	end
end
--------------------------------------------------------------------------------|
function SWEP:Holster()
	if self == newWep or self.Reloading then return end

	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if isPly then

	self.Owner:SetFOV( 0, .5 )
	self.Owner:DrawViewModel(true)
	self:EmitSound("Weapon_AR2.Special1")
	self.Zoom = 0
	self.Owner:ScreenFade( SCREENFADE.PURGE, Color( 0, 0, 0, 0 ), 0.1, 0.1 )
	self.Owner:GetCanZoom( 0 )
	self.Owner:SetCanZoom( 1 )

	end

	hook.Remove("Think", self) -- Otherwise "NPC_Think" will just keep running!
	self.PLY_NextIdleAnimT = CurTime() + 2
	//self:SendWeaponAnim(ACT_VM_HOLSTER)
	return self:OnHolster(newWep) != true
end
