AddCSLuaFile()
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_rocket_apc"
ENT.PrintName		= "Missile"
ENT.Spawnable = false
ENT.Model = "models/props_marines/tow_missile_projectile.mdl"
ENT.RadiusDamage = GetConVar("sk_apc_missile_damage"):GetInt()
ENT.RadiusDamageRadius = 130