//HORNETGUN
sound.Add( {
	name = "Cets_Weapon_HIVEH.Fire",
	channel = CHAN_WEAPON,
	volume = 1.0,
	pitch =	95,100,105,
	soundlevel = SNDLVL_GUNFIRE,
	sound = { "npc/alien_grunt/ag_fire1.wav", "npc/alien_grunt/ag_fire2.wav", "npc/alien_grunt/ag_fire3.wav" }
} )

game.AddAmmoType( {
	name = 'XenBionade_CETS',
	dmgtype = {DMG_POISON},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'Snarks_CETS',
	dmgtype = {DMG_SLASH},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'Hornet_CETS',
	dmgtype = {DMG_SLASH},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )

game.AddAmmoType( {
	name = 'ShockR_CETS',
	dmgtype = {DMG_SHOCK},
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 100,
	minsplash = 10,
	maxsplash = 5
} )