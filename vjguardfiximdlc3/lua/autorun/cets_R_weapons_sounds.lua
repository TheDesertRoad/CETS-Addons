game.AddAmmoType( {
	name = 'MP5Gr_CETS',
	dmgtype = {DMG_BLAST},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'UraniumEnergy_CETS',
	dmgtype = {DMG_ENERGYBEAM, DMG_SHOCK, DMG_PLASMA},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'Molotov_CETS',
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'HECGren_CETS',
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'MP5Gr_CETS',
	dmgtype = {DMG_BLAST},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'Sniper_CETS',
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

//TAU
sound.Add( {
    name = "Cets_Weapon_Tau.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch = math.random(100, 105),
    soundlevel = SNDLVL_GUNFIRE,
    sound = {"weapons/gauss/fire1.wav"}
} )

sound.Add( {
    name = "Cets_Weapon_Tau.Charge",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = {"weapons/gauss/pulsemachine.wav"}
} )

sound.Add( {
    name = "Cets_Weapon_Tau.ChargeMightFix",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = {"items/ammo_pickup.wav"}
} )

sound.Add( {
    name = "Cets_Weapon_Tau.FireAlt",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = {"weapons/gauss/overcharged01.wav", "weapons/gauss/overcharged02.wav"}
} )

sound.Add( {
    name = "Cets_Weapon_Tau.FireNOO",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = {"weapons/gauss/empty.wav"}
} )

sound.Add( {
    name = "Cets_Weapon_Tau.Over",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = {"weapons/gauss/gauss_overcharging.wav"}
} )

sound.Add( {
    name = "Cets_Weapon_Tau.NPC_Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = {"weapons/gauss/npc_fire.wav"}
} )

//MP5SD

//MP5SD
sound.Add( {
    name = "Cets_Weapon_MP5SD.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "hl1/weapons/hks1.wav", "hl1/weapons/hks2.wav", "hl1/weapons/hks3.wav" }
} )

sound.Add( {
    name = "Cets_Weapon_MP5SD.S_Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	100,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "hl1/weapons/glauncher.wav", "hl1/weapons/glauncher2.wav" }
} )

//MISC
sound.Add( {
	name = "Cets_Weapon_Pipe.Hit",
	channel = CHAN_AUTO,
	volume = 0.6,
	level = 75,
	pitch = {95, 105},
	sound = {
       		"physics/metal/metal_canister_impact_hard1.wav",
		"physics/metal/metal_canister_impact_hard2.wav",
		"physics/metal/metal_canister_impact_hard3.wav",
    }
} )

// Sniper Rifle

sound.Add( {
	name = "Cets_Weapon_Sniper_Rifle.Single",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "hl1/weapons/sniper_fire.wav"
} )

sound.Add( {
	name = "Cets_Weapon_Sniper_Rifle.Bolt1",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "hl1/weapons/sniper_bolt1.wav"
} )

sound.Add( {
	name = "Cets_Weapon_Sniper_Rifle.Bolt2",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "hl1/weapons/sniper_bolt2.wav"
} )

sound.Add( {
	name = "Cets_Weapon_Sniper_Rifle.Reload_First_Seq",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "hl1/weapons/sniper_reload_first_seq.wav"
} )

sound.Add( {
	name = "Cets_Weapon_Sniper_Rifle.Reload_Second_Seq",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "hl1/weapons/sniper_reload_second_seq.wav"
} )

sound.Add( {
	name = "Cets_Weapon_Sniper_Rifle.Zoom",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "hl1/weapons/sniper_zoom.wav"
} )

local EMETA = FindMetaTable("Entity")
-----------------------------------------------------------------------------------------------
function EMETA:TakeHealth(health)
    if !self.Health then return 0 end

    local iMax = self:GetMaxHealth()

    if self:Health() >= iMax then
        return 0
    end

    local oldHealth = self:Health()

    self:SetHealth(self:Health() + health)

    if self:Health() > iMax then
        self:SetHealth(iMax)
    end

    return self:Health() - oldHealth
end