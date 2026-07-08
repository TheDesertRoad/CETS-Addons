if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "HMG"
SWEP.Author = ""
SWEP.Category = ""

SWEP.HoldType = "smg"
SWEP.ReplacementWeapon = "item_ammo_ar2_large"

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/w_ihmg.mdl"

SWEP.Primary.Sound				= "Cets_Weapon_SUPPHMG.Fire"
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 40 -- Max amount of bullets per clip
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
SWEP.Primary.Cone			= 0.001			
SWEP.Primary.Tracer			= 4			
SWEP.Primary.Force			= 7
SWEP.Primary.Automatic		= 1
SWEP.Primary.Delay		= 0
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.NPC_BulletSpawnAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.PrimaryEffects_DynamicLightBrightness = 2
SWEP.PrimaryEffects_DynamicLightDistance = 32
SWEP.Primary.TracerType = "AR2Tracer"

SWEP.NPC_NextPrimaryFire = 8
SWEP.NPC_TimeUntilFire = 1
SWEP.NPC_ReloadSound = "Cets_Weapon_SUPPHMG.NPC_Reload"
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4}
SWEP.NPC_HasSecondaryFire = false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCShoot_Primary()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	local ene = owner:GetEnemy()
	if !owner.VJ_IsBeingControlled && (!IsValid(ene) or (!owner:Visible(ene))) then return end
	if owner.IsVJBaseSNPC then
		owner:UpdatePoseParamTracking()
	end

	
	-- Primary Fire
	VJ.CreateSound(self, "weapons/supphmg/supphmg_wind_up.wav", 85)
	timer.Simple(self.NPC_TimeUntilFire, function()
		if !IsValid(self) then return end
		local curTime = CurTime()
		owner = self:GetOwner()
		if IsValid(owner) && owner:IsNPC() && self:NPC_CanFire() && curTime > self.NPC_NextPrimaryFireT then
			self:PrimaryAttack()
			owner.WeaponLastShotTime = curTime
			timer.Simple(4.1, function()
				if IsValid(self) && IsValid(owner) then
					VJ.CreateSound(self, "weapons/supphmg/supphmg_wind_down.wav", 85)	
				end
			end)
			if self.NPC_NextPrimaryFire != false then -- Support for animation events
				self.NPC_NextPrimaryFireT = curTime + self.NPC_NextPrimaryFire
				for _, tv in ipairs(self.NPC_TimeUntilFireExtraTimers) do
					timer.Simple(tv, function()
						if !IsValid(self) then return end
						owner = self:GetOwner()
						if IsValid(owner) && owner:IsNPC() && self:NPC_CanFire() then
							self:PrimaryAttack()
						end
					end)
				end
			end
		end
	end)



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
	local ene = owner:GetEnemy()
	local spawnPos = self:GetBulletPos()
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
		bullet.Damage = owner:ScaleByDifficulty(self.Primary.Damage)
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tracer, tr, dmginfo)
				local dmginfo = DamageInfo()
				local effectdata = EffectData()
				effectdata:SetOrigin(tracer.HitPos)
				effectdata:SetNormal(tracer.HitNormal)
				effectdata:SetRadius( 10 )
				util.Effect( "AR2Impact", effectdata )

				local ef = EffectData()
				ef:SetEntity( self )
				ef:SetFlags( 5 ) -- Sets the Combine AR2 Muzzle flash
				util.Effect( "MuzzleFlash", ef )

				dmginfo:SetWeapon(self)
				dmginfo:SetInflictor(self)
				return self:OnPrimaryAttack_BulletCallback(attacker, tracer, tr, dmginfo)
		end
		owner:FireBullets(bullet);
		self:TakePrimaryAmmo(1) 
end