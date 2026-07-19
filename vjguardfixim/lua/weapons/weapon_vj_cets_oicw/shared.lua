if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_ar2"
SWEP.PrintName = "OICW"
SWEP.Author = "VALVe"
SWEP.Category = "Half-Life 2"
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.Purpose = false

SWEP.MadeForNPCsOnly = false
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 	
SWEP.ViewModel		= "models/weapons/c_ar2_nope.mdl"	
SWEP.WorldModel		= "models/weapons/w_oicw.mdl"
SWEP.ReplacementWeapon = false
SWEP.ViewModelFOV			= 40
SWEP.DrawCrosshair = true
--------------------------------------------------------------------------------|
SWEP.Primary.Sound				= "Cets_Weapon_OICW.Fire"
SWEP.Primary.Damage		= GetConVar("sk_plr_cets_dmg_oicw"):GetInt()
SWEP.Primary.NumShots		= 1						
SWEP.Primary.Delay			= 0.09
SWEP.Primary.ClipSize		= GetConVar("sk_max_cets_oicw"):GetInt()		
SWEP.Primary.DefaultClip	                  = GetConVar("sk_max_cets_oicw_bullet"):GetInt()	
SWEP.Primary.Force			= 7
SWEP.Primary.Automatic		= 1	
SWEP.Primary.Ammo		= "AR2"	
SWEP.Primary.Recoil			= 1
SWEP.Primary.BulletShot 		= true;
--------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--------------------------------------------------------------------------------|
SWEP.UseScope				= true	
SWEP.Zoom = 0
local ScopeMat1 = Material("effects/cets/oicw_scope1")
local ScopeMat = Material("effects/cets/oicw_scope1_s")
--------------------------------------------------------------------------------|
SWEP.NPC_NextPrimaryFire = 1.6
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.2, 0.3, 0.4, 0.5, 0.6, 0.7}
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
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
			ef:SetFlags( 5 )
			util.Effect( "MuzzleFlash", ef )
	end
end
--------------------------------------------------------------------------------|
function SWEP:DrawHUD()
	if not self:GetNWBool("Scoped", false) then return end

	local w = ScrW()
	local h = ScrH()
	local size = math.min(w, h)
	local x = (w - size) / 2
	local y = (h - size) / 2

	local mat = ScopeMat1
	local mat1 = ScopeMat
	local matW, matH = mat:Width(), mat:Height()
	local aspect = matW / matH

	local w = ScrW()
	local h = ScrH()
	local size = math.min(w, h)

	local drawW, drawH = size, size

	if aspect > 1 then
		drawH = size / aspect
	else
		drawW = size * aspect
	end

	local x = (w - drawW) / 2
	local y = (h - drawH) / 2
	local matW1, matH1 = mat1:Width(), mat1:Height()
	local aspect1 = matW1 / matH1
	local w1 = ScrW()
	local h1 = ScrH()
	local size1 = math.min(w1, h1)

	local drawW1, drawH1 = size1, size1

	if aspect1 > 1 then
		drawH1 = size1 / aspect1
	else
		drawW1 = size1 * aspect1
	end

	local x1 = (w1 - drawW1) / 2
	local y1 = (h1 - drawH1) / 2

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.SetMaterial(mat1)
	surface.DrawTexturedRect(x, y, drawW, drawH)

	if x > 0 then
		surface.DrawRect(0, 0, x, h)
		surface.DrawRect(w - x, 0, x, h)
	end

	if y > 0 then
		surface.DrawRect(0, 0, w, y)
		surface.DrawRect(0, h - y, w, y)
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
		local fireSd = VJ.PICK("Cets_Weapon_OICW.NPC_Fire")
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

	elseif isPly then

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

	if ( self.Primary.BulletShot ) && (self.Zoom == 0) then
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = self.Owner:GetAimVector() //Gets where you're aiming
		bullet.Spread = Vector( 0.6 * 0.1 , 0.2 * 0.1, 0)
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = 1
		bullet.TracerName       = "AR2Tracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tracer)
				local effectdata = EffectData()
				effectdata:SetOrigin(tracer.HitPos)
				effectdata:SetNormal(tracer.HitNormal)
				effectdata:SetRadius( 10 )
			util.Effect( "AR2Impact", effectdata )
		end
		self.Owner:FireBullets( bullet );

	elseif ( self.Primary.BulletShot ) && (self.Zoom == 1) then

	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = self.Owner:GetAimVector() //Gets where you're aiming
		bullet.Spread = Vector( 0.2 * 0.1 , 0.1 * 0.1, 0)
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = 1
		bullet.TracerName       = "AR2Tracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tracer)
					local effectdata = EffectData()
					effectdata:SetOrigin(tracer.HitPos)
					effectdata:SetNormal(tracer.HitNormal)
					effectdata:SetRadius( 10 )
				util.Effect( "AR2Impact", effectdata )
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
		self:EmitSound(Sound(self.Primary.Sound)) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
end
--------------------------------------------------------------------------------|
function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()

	if not IsValid(owner) or not owner:IsPlayer() then return end

	if self.Zoom == 0 then
		owner:SetFOV(20, 0.5)
		owner:DrawViewModel(false)
		self:EmitSound("Weapon_AR2.Special1")

		self.Zoom = 1
		self:SetNWBool("Scoped", true)

		self.Primary.Damage = self.Primary.Damage * 2
		self.Primary.Delay = self.Primary.Delay * 3
		self.Primary.Recoil = self.Primary.Recoil / 2

		owner:SetCanZoom(false)
	else
		owner:SetFOV(0, 0.5)
		owner:DrawViewModel(true)
		self:EmitSound("Weapon_AR2.Special1")

		self.Zoom = 0
		self:SetNWBool("Scoped", false)

		self.Primary.Damage = self.Primary.Damage / 2
		self.Primary.Delay = self.Primary.Delay / 3
		self.Primary.Recoil = self.Primary.Recoil * 2

		owner:SetCanZoom(true)
	end

	self:SetNextSecondaryFire(CurTime() + 0.3)
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
			self:SetNWBool("Scoped", false)
			self.Primary.Damage = self.Primary.Damage / 2 -- Damage
			self.Primary.Delay = self.Primary.Delay / 3
			self.Primary.Recoil = self.Primary.Recoil * 2
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
	self:SetNWBool("Scoped", false)
	self.Owner:GetCanZoom( 0 )
	self.Owner:SetCanZoom( 1 )

	end

	hook.Remove("Think", self) -- Otherwise "NPC_Think" will just keep running!
	self.PLY_NextIdleAnimT = CurTime() + 2
	//self:SendWeaponAnim(ACT_VM_HOLSTER)
	return self:OnHolster(newWep) != true
end
--------------------------------------------------------------------------------|
if CLIENT then
	function SWEP:Think()
		if self.Owner ~= LocalPlayer() then return end
		if not self:GetNWBool("Scoped", false) then return end

		local dlight = DynamicLight(self:EntIndex())

		if dlight then
			dlight.pos = EyePos()
			dlight.r = 100
			dlight.g = 255
			dlight.b = 200
			dlight.brightness = 0
			dlight.Size = 2048
			dlight.Decay = 0
			dlight.DieTime = CurTime() + 0.1
		end
	end

	function SWEP:CreateWeaponSelectionFonts(height)
		local scale = (height*0.8)/64 --ScrH()/480
		
		surface.CreateFont("CETS_OICWfont_Glow", {
			font = "CETS",
			size = math.min(45*scale, 150), --165
			weight = 500,
			antialias = true,
			additive = true,
			blursize = 5*scale,
			scanlines = 2*scale
		})

		surface.CreateFont("CETS_OICWfont", {
			font = "CETS",
			size = math.min(45*scale, 150), --150
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
		if h != prevScrH then
			self:CreateWeaponSelectionFonts(h)
			prevScrH = h
		end
			local hudColor = GetHUDColor()
		
			r = hudColor.r
			g = hudColor.g
			b = hudColor.b

		local glowAlpha = 255

		local icon = "b"
		local cx = x + w / 2
		local cy = y + h / 2

		draw.SimpleText(icon, "CETS_OICWfont_Glow", cx, cy, Color(r, g, b, glowAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(icon, "CETS_OICWfont", cx, cy, Color(r, g, b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end
