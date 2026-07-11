if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_cets_357"
SWEP.PrintName = "SNIPER COMB"
SWEP.HoldType = "smg"
SWEP.Author = ""
SWEP.Category = ""

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/weapons/w_combinesniper.mdl"
SWEP.ReplacementWeapon = "item_ammo_ar2_large"

SWEP.Primary.Damage				= 40 -- Damage
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 3 -- Time until it can shoot again
SWEP.Primary.Sound				= "npc/sniper/sniper1.wav"
SWEP.Primary.SoundLevel = 100
SWEP.Primary.DistantSound				= "npc/sniper/echo1.wav"
SWEP.Primary.Cone = 0
SWEP.Primary.Force = 2
SWEP.Primary.TracerType = "AirboatGunTracer"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
SWEP.PrimaryEffects_DynamicLightBrightness = 2
SWEP.PrimaryEffects_DynamicLightDistance = 32

SWEP.NPC_ReloadSound				= "Cets_Weapon_Sniper.Reload"
SWEP.NPC_NextPrimaryFire = 1
SWEP.NPC_TimeUntilFire = 1
SWEP.NPC_CustomSpread = 0
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
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
				local effectdata = EffectData()
				effectdata:SetOrigin(tracer.HitPos)
				effectdata:SetNormal(tracer.HitNormal)
				effectdata:SetRadius( 10 )
				util.Effect( "AR2Impact", effectdata )

				local ef = EffectData()
				ef:SetEntity( self )
				ef:SetFlags( 5 ) -- Sets the Combine AR2 Muzzle flash
				util.Effect( "MuzzleFlash", ef )
		end
		owner:FireBullets(bullet);
		self:TakePrimaryAmmo(1) 
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local aimPos = Vector(-9, 0, -32)
	local aimAng = Angle(0, 0, 0)
	local matLaser = Material("sprites/baku_burntcer_smoke")
	local matSprite = Material("sprites/blueglow2")
	local laserColor = Color(100, 220, 255, 64)
	local spriteColor = Color(0, 64, 255, 255)

function SWEP:OnDrawWorldModel()
	local owner = self:GetOwner()
		if IsValid(owner) then
			local attach = self:GetAttachment(self:LookupAttachment("laser"))
			local attachPos = attach.Pos
			local attachAng = attach.Ang
			local endPos = attachPos + attachAng:Forward()*10000 + attachAng:Up()*820 + attachAng:Right()*680
			local tr = util.TraceLine({
				start = attachPos,
				endpos = endPos,
				filter = self,
			})
			render.SetMaterial(matLaser)
			render.DrawBeam(attachPos, tr.HitPos, 2, 0, 5, laserColor)
			render.SetMaterial(matSprite)
			render.DrawSprite(attachPos, 3, 3, spriteColor)
			if tr.Hit == true then
				render.SetMaterial(matSprite)
				render.DrawSprite(tr.HitPos, math.random(4, 6), math.random(4, 6), spriteColor)
			end
		end
		return true
	end
end