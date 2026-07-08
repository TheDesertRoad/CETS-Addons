AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/hl2_outfassassin.mdl"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.MainSoundLevel = 20
	self:SetSpawnEffect(true)
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))

	util.SpriteTrail(self, 5, Color(0, 128, 255), true, 3, 0, 0.3, 1 /(25 +1) *0.5, "sprites/laserbeam")

	local spriteGlow = ents.Create("env_sprite")
		spriteGlow:SetKeyValue("rendercolor", "0 128 255")
		spriteGlow:SetKeyValue("GlowProxySize", "1.0")
		spriteGlow:SetKeyValue("HDRColorScale", "1.0")
		spriteGlow:SetKeyValue("renderfx", "14")
		spriteGlow:SetKeyValue("rendermode", "3")
		spriteGlow:SetKeyValue("renderamt", "255")
		spriteGlow:SetKeyValue("disablereceiveshadows", "0")
		spriteGlow:SetKeyValue("mindxlevel", "0")
		spriteGlow:SetKeyValue("maxdxlevel", "0")
		spriteGlow:SetKeyValue("framerate", "10.0")
		spriteGlow:SetKeyValue("model", "VJ_Base/sprites/glow.vmt")
		spriteGlow:SetKeyValue("spawnflags", "0")
		spriteGlow:SetKeyValue("scale", "0.07")
		spriteGlow:SetParent(self)
		spriteGlow:Fire("SetParentAttachment", "eye")
		spriteGlow:Spawn()

	self:DeleteOnRemove(spriteGlow)
	self:Give("weapon_vj_cets_dualpistol")

	timer.Simple(10, function() if IsValid(self) then self:SetRenderMode(RENDERMODE_TRANSALPHA) end end)
end