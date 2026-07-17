SWEP.PrintName = "Shockrifle"
SWEP.Category = "Half-Life 2"
SWEP.Author		= "VALVe, Gearbox"
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 90
SWEP.ViewModel = "models/weapons/v_hl2_shock.mdl"
SWEP.WorldModel = "models/weapons/w_shock_rifle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 3
SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.UseHands = false
SWEP.HoldType = "AR2"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"
--------------------------------------------------------------------------------|
SWEP.RegenerationTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.Recoil = 0
SWEP.RecoilTimer = CurTime()
--------------------------------------------------------------------------------|
SWEP.Primary.Sound = "npc/shockroach/shock_fire.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 12
SWEP.Primary.MaxAmmo = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ShockR_CETS"
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.4
SWEP.Primary.Force = 100
--------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo				= "none"

SWEP.DryFireSound = "npc/shockroach/shock_discharge.wav"
SWEP.HasReloadSound = false
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 0.8
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
		local entity = ents.Create( "obj_vj_racexenergyorb_b" )
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
		self.RecoilTimer = CurTime() + 0.12

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
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function SWEP:CreateWeaponSelectionFonts(height)
		local scale = (height*0.8)/64 --ScrH()/480
		
		surface.CreateFont("CETS_SHRfont_Glow", {
			font = "CETS",
			size = math.min(48*scale, 150), --165
			weight = 500,
			antialias = true,
			additive = true,
			blursize = 5*scale,
			scanlines = 2*scale
		})

		surface.CreateFont("CETS_SHRfont", {
			font = "CETS",
			size = math.min(48*scale, 150), --150
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
		self.PrintName = "SHOCKROACH"
		if h != prevScrH then
			self:CreateWeaponSelectionFonts(h)
			prevScrH = h
		end
			local hudColor = GetHUDColor()
		
			r = hudColor.r
			g = hudColor.g
			b = hudColor.b

		local glowAlpha = 255

		local icon = "i"
		local cx = x + w / 2
		local cy = y + h / 2

		draw.SimpleText(icon, "CETS_SHRfont_Glow", cx, cy, Color(r, g, b, glowAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(icon, "CETS_SHRfont", cx, cy, Color(r, g, b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end