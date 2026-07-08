game.AddAmmoType( {
	name = 'ComGren_CETS',
	dmgtype = {DMG_BLAST},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'ComGren_S_CETS',
	dmgtype = {DMG_SONIC},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'ComGren_A_CETS',
	dmgtype = {DMG_ACID},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

sound.Add( {
    name = "Cets_HL2.Electric",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "hl1/weapons/electro4.wav", "hl1/weapons/electro5.wav", "hl1/weapons/electro6.wav" }
} )

//OICW
sound.Add( {
    name = "Cets_Weapon_OICW.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/oicw/ar2_1.wav", "weapons/oicw/ar2_2.wav", "weapons/oicw/ar2_3.wav" }
} )

sound.Add( {
    name = "Cets_Weapon_OICW.Reload",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/oicw/oicw_reload.wav" }
} )

sound.Add( {
    name = "Cets_Weapon_OICW.NPC_Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/oicw/npc_ar2_fire1.wav", "weapons/oicw/npc_ar2_fire2.wav", "weapons/oicw/npc_ar2_fire3.wav" }
} )
//HMG
sound.Add( {
    name = "Cets_Weapon_HMG1.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/hmg1/hmg1_1.wav" }
} )

sound.Add( {
    name = "Cets_Weapon_HMG1.Reload1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/hmg1/magout.wav" }
} )

sound.Add( {
    name = "Cets_Weapon_HMG1.Reload2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/hmg1/magin.wav" }
} )

sound.Add( {
    name = "Cets_Weapon_HMG1.NPC_Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/hmg1/npc_hmg1_fire1.wav" }
} )
//SUPPHMG
sound.Add( {
    name = "Cets_Weapon_SUPPHMG.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/supphmg/supphmg_fire1.wav", "weapons/supphmg/supphmg_fire2.wav", "weapons/supphmg/supphmg_fire3.wav", "weapons/supphmg/supphmg_fire4.wav", }
} )

sound.Add( {
    name = "Cets_Weapon_SUPPHMG.NPC_Reload",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/supphmg/supphmg_npc_reload.wav", }
} )
//HEVSHOT
sound.Add( {
    name = "Cets_Weapon_HEVSHOT.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/hevsg/hevsg_fire.wav" }
} )
sound.Add( {
    name = "Cets_Weapon_HEVSHOT.Reload",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/supphmg/hevsg_reload.wav" }
} )
//PULSESMG
sound.Add( {
    name = "Cets_Weapon_PULSESMG.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/pulsesmg/psmg_fire.wav" }
} )
sound.Add( {
    name = "Cets_Weapon_PULSESMG.Reload",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "weapons/pulsesmg/psmg_reload.wav" }
} )
//COMBSNIPER
sound.Add( {
    name = "Cets_Weapon_Sniper.Reload",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "npc/sniper/reload1.wav" }
} )
sound.Add( {
    name = "Cets_Weapon_Sniper.FireDist",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "npc/sniper/echo1.wav" }
} )
sound.Add( {
    name = "Cets_Weapon_Sniper.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch =	95,100,105,
    soundlevel = SNDLVL_GUNFIRE,
    sound = { "npc/sniper/sniper1.wav" }
} )
//MP5K
sound.Add( {
	name = "Cets_Weapon_MP5K.NPC_Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = {"weapons/misc/npc_cets_smg1_1.wav", "weapons/misc/npc_cets_smg1_2.wav", "weapons/misc/npc_cets_smg1_3.wav"}
})

///DEF WEP
-- 9mm Pistol
sound.Add({
	name = "Cets_Weapon_Pistol.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "weapons/fixed_sounds/pistol_fire3.wav"
})

-- .357 Magnum
sound.Add({
	name = "Cets_Weapon_Magnum.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "weapons/357/357_fire3.wav"
})

-- RPG
sound.Add({
	name = "Cets_Weapon_RPG.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/rpg/single.wav"
})

-- SMG1
sound.Add({
	name = "Cets_Weapon_SMG1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "weapons/fixed_sounds/npc_smg1_fire1.wav"
})
sound.Add({
	name = "Cets_Weapon_SMG1.Secondary",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100, -- Since it's a grenade launcher, make it less than a gun shot!
	pitch = PITCH_RANDOM,
	sound = "weapons/grenade_launcher1.wav"
})

-- SPAS-12
sound.Add({
	name = "Cets_Weapon_SPAS12.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "weapons/shotgun/shotgun_fire6.wav"
})