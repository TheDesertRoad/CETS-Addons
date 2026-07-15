ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Tentacle"
ENT.Author 			= "VALVe"
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	hook.Add("EntityEmitSound", "CETS_Tentacle_ExplosionSounds", function(data)
		local ent = data.Entity
		if not IsValid(ent) then return end

		local snd = string.lower(data.SoundName)
		local pos = ent:GetPos()
		local isFootstep = ent:IsPlayer() && (string.find(snd, "footstep") or string.find(snd, "step"))

		if isFootstep then
			if ent:Crouching() then return end
			if ent:GetVelocity():Length2D() < 20 then return end
		else
			local isExplosion = string.find(snd, "explode") or string.find(snd, "grenade") or string.find(snd, "weapon") or string.find(snd, "shoot") or string.find(snd, "impact") or string.find(snd, "rpg")
			if not isExplosion then return end
		end

		local tr = util.TraceLine({
			start = pos + Vector(0,0,100),
			endpos = pos - Vector(0,0,1000),
			filter = ent
		})

		if tr.Hit then
			pos = tr.HitPos
		end

		timer.Simple(1, function()
			if not IsValid(ent) then return end

			for _, npc in ipairs(ents.FindByClass("npc_tentacle_vj_cets")) do
				if IsValid(npc) && npc:GetPos():DistToSqr(pos) <= npc.ExplosionSoundRange^2 then
					npc.LastExplosionSoundPos = pos
					npc.LastExplosionSoundTime = CurTime() + npc.ExplosionSoundMemory
				end
			end
		end)
	end)
end