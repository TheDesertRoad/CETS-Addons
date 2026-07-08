SWEP.PrintName = "Hivehand"
SWEP.Category = "Half-Life 2"
SWEP.Author		= "VALVe"
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_hl2_hgun.mdl"
SWEP.WorldModel = "models/weapons/w_hl2_hgun.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 3
SWEP.Slot = 5
SWEP.SlotPos = 4

SWEP.UseHands = false
SWEP.HoldType = "pistol"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

SWEP.RegenerationTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.Recoil = 0
SWEP.RecoilTimer = CurTime()

SWEP.Primary.Sound = 	"Cets_Weapon_HIVEH.Fire"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 8
SWEP.Primary.MaxAmmo = 16
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Hornet_CETS"
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.3
SWEP.Primary.Force = 100

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.1
--------------------------------------------------------------------------------|
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.Idle = 0
	self.IdleTimer = CurTime() + 1
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
--------------------------------------------------------------------------------|
function SWEP:PrimaryAttack()
	if self.Weapon:Ammo1() <= 0 then return end
	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end

	if SERVER then
		local entity = ents.Create( "obj_vj_alienhornet_ply" )
		entity:SetOwner( self.Owner )

		if IsValid( entity ) then
		local Forward = self.Owner:EyeAngles():Forward()
		local Right = self.Owner:EyeAngles():Right()
		local Up = self.Owner:EyeAngles():Up()
		entity:SetPos( self.Owner:GetShootPos() + Forward * 12 + Right * 4 + Up * -6 )
		entity:SetAngles( self.Owner:EyeAngles() )
		entity:Spawn()

		local phys = entity:GetPhysicsObject()
		phys:SetMass( 1 )
		phys:EnableGravity( false )
		timer.Create( "Flight"..entity:EntIndex(), 0, 0, function()

		if !IsValid( phys ) then
			timer.Stop( "Flight" )
		end

		if IsValid( entity ) and IsValid( phys ) then
			phys:ApplyForceCenter( entity:GetForward() * 100 )
				end
			end )
		end
	end

	self:EmitSound( self.Primary.Sound )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.RegenerationTimer = CurTime() + 1
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

	if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
		self.Recoil = math.random( 1, 2 )
		self.RecoilTimer = CurTime() + self.Secondary.Delay

		if self.Recoil == 1 then
			self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -2.5, 0, 0 ) )
		end

		if self.Recoil == 2 then
			self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( 2.5, 0, 0 ) )
		end
	end
end
--------------------------------------------------------------------------------|
function SWEP:SecondaryAttack()
	if self.Weapon:Ammo1() <= 0 then return end
	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end

	if SERVER then
	local entity = ents.Create( "obj_vj_alienhornet_ng" )
	entity:SetOwner( self.Owner )

	if IsValid( entity ) then
	local Forward = self.Owner:EyeAngles():Forward()
	local Right = self.Owner:EyeAngles():Right()
	local Up = self.Owner:EyeAngles():Up()
	entity:SetPos( self.Owner:GetShootPos() + Forward * 12 + Right * 4 + Up * -6 )
	entity:SetAngles( self.Owner:EyeAngles() )
	entity:Spawn()

	local phys = entity:GetPhysicsObject()
	phys:SetMass( 1 )
	phys:EnableGravity( false )

	timer.Create( "Flight"..entity:EntIndex(), 0, 0, function()
		if !IsValid( phys ) then
			timer.Stop( "Flight" )
		end

		if IsValid( entity ) and IsValid( phys ) then
			phys:ApplyForceCenter( entity:GetForward() * 100 )
				end
			end )
		end
	end

	self:EmitSound( self.Primary.Sound )
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self.RegenerationTimer = CurTime() + 2
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

	if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
		self.Recoil = math.random( 1, 2 )
		self.RecoilTimer = CurTime() + self.Secondary.Delay
			if self.Recoil == 1 then
				self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -2.5, 0, 0 ) )
			end

			if self.Recoil == 2 then
				self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( 2.5, 0, 0 ) )
		end
	end
end
--------------------------------------------------------------------------------|
function SWEP:Reload()
end
--------------------------------------------------------------------------------|
function SWEP:Think()
	if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
		if self.Recoil == 1 and self.RecoilTimer <= CurTime() then
			self.Recoil = 0
		end

		if self.Recoil == 2 and self.RecoilTimer <= CurTime() then
			self.Recoil = 0
		end

		if self.Recoil == 1 then
			self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( 0.415, 0, 0 ) )
		end

		if self.Recoil == 2 then
			self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -0.415, 0, 0 ) )
		end
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