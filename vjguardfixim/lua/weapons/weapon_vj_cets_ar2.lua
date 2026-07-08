AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "AR2"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = false
SWEP.NPC_CanBePickedUp = false

if CLIENT then
	VJ.AddKillIcon("weapon_vj_ar2", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_ar2")
end

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.UseHands = true
SWEP.ReplacementWeapon = "weapon_ar2"


SWEP.NPC_SecondaryFireEnt = "obj_vj_cets_combineball"
SWEP.NPC_SecondaryFireDistance = 3000
SWEP.NPC_SecondaryFireChance = 2
SWEP.NPC_SecondaryFireNext = VJ.SET(10, 15)
SWEP.NPC_SecondaryFireSound = "VJ.Weapon_AR2.Secondary"
SWEP.NPC_NextPrimaryFire = 1.9
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.3, 0.4, 0.6, 0.7, 0.9, 1, 1.1, 1.2}
SWEP.NPC_ReloadSound = "weapons/ar2/npc_ar2_reload.wav"

SWEP.Primary.Damage = 5
SWEP.Primary.Force = 10
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.TracerType       = "AR2Tracer"
SWEP.Primary.Sound = "VJ.Weapon_AR2.Single"
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.PrimaryEffects_DynamicLightBrightness = 2
SWEP.PrimaryEffects_DynamicLightDistance = 32

SWEP.Secondary.Ammo = "AR2AltFire"

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"
SWEP.HasReloadSound = false
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 0.8
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	if GetConVar("sk_cets_ar2scrotums_enable"):GetInt() == 1 then
		self.NPC_HasSecondaryFire = true
	else
		self.NPC_HasSecondaryFire = false
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
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_SecondaryFire_BeforeTimer(eneEnt, fireTime)
	VJ.EmitSound(self, "weapons/cguard/charging.wav", 70)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnSecondaryAttack()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	local fidgetTime = VJ.AnimDuration(vm, ACT_VM_FIDGET)
	local fireTime = VJ.AnimDuration(vm, ACT_VM_SECONDARYATTACK)
	local totalTime = fidgetTime + fireTime
	local curTime = CurTime()
	self:SetNextSecondaryFire(curTime + totalTime)
	self.PLY_NextIdleAnimT = curTime + totalTime
	self.PLY_NextReloadT = curTime + totalTime
	self:SendWeaponAnim(ACT_VM_FIDGET)
	VJ.CreateSound(self, "weapons/cguard/charging.wav", 85)
	
	timer.Simple(fidgetTime, function()
		if IsValid(self) && IsValid(owner) && owner:GetActiveWeapon() == self then
			VJ.CreateSound(self, "weapons/ar2/npc_ar2_altfire.wav", 90)

			if SERVER then
				local projectile = ents.Create(self.NPC_SecondaryFireEnt)
				projectile:SetPos(owner:GetShootPos())
				projectile:SetAngles(owner:GetAimVector():Angle())
				projectile:SetOwner(owner)
				projectile:Spawn()
				projectile:Activate()
				local phys = projectile:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					phys:SetVelocity(owner:GetAimVector() * 2000)
				end
			end
			
			owner:ViewPunch(Angle(-self.Primary.Recoil * 3, 0, 0))
			owner:SetAnimation(PLAYER_ATTACK1)
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self:TakeSecondaryAmmo(1)
		end
	end)
	return true
end