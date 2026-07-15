AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local Enabled = false
local IsWorking = true 
local CurrentSong

ENT.Music = NULL 
ENT.SongNr = 1
ENT.Nxtdelay = CurTime()

function ENT:Initialize()
    self:SetModel("models/props_lab/citizenradio.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
    end

    self.LastUsed = 0
    Enabled = false
    IsWorking = true
    CurrentSong = nil

end

function RandomizeSong()
	local Songs = {
	"hl1/ambience/signalgear2.wav",
	"hl1/ambience/signalgear1.wav",
	"hl1/ambience/littlemachine.wav",
	"music/radio/radio_rebel1.wav",
	"music/radio/radio_rebel2.wav",
	"music/radio/radio_rebel3.wav",
	"music/radio/radio_rebel4.wav",
	"music/radio/radio_rebel5.wav",
	"music/radio/radio_rebel6.wav",
	"music/radio/radio_rebel7.wav",
	"music/radio/radio_rebel8.wav",
	"music/radio/radio_rebel9.wav",
	"music/radio/radio_rebel10.wav",
	"music/radio/radio_rebel11.wav",
	"music/radio/radio_strange1.wav",
	"music/radio/radio_strange2.wav",
	"music/radio/radio_strange3.wav",
	"music/radio/radio_strange4.wav",
	"music/radio/radio_comb1.wav",
	"hl1/ambience/alien_frantic.wav",
	"weapons/misc/music.wav",
	"weapons/misc/signal.wav",
	"weapons/misc/signal1.wav",
	"weapons/misc/signal2.wav",
	"weapons/misc/talking.wav",
	"vo/consul/con_cast0.wav",
	"vo/consul/con_cast1.wav",
	"vo/consul/con_cast2.wav",
	"vo/consul/con_cast3.wav",
	"vo/consul/con_cast4.wav",
	"music/radio1.mp3",
	"npc/turret_wall/turret_loop1.wav",
	"hl1/ambience/alienvoices1.wav",
	"hl1/ambience/arabmusic.wav",
	"hl1/ambience/zipmachine.wav",
	"hl1/ambience/crtnoise.wav",
	"hl1/ambience/Opera.wav",
	"hl1/ambience/guit1.wav",
	"ambient/music/mirame_radio_thru_wall.wav",
	"ambient/music/latin.wav",
	"ambient/music/flamenco.wav",
	"ambient/office/officenews.wav",
	"music/soundscape_test/tv_music.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"music/radio/radio_static.wav",
	"ambient/levels/prison/radio_random1.wav",
	"ambient/levels/prison/radio_random2.wav",
	"ambient/levels/prison/radio_random3.wav",
	"ambient/levels/prison/radio_random4.wav",
	"ambient/levels/prison/radio_random5.wav",
	"ambient/levels/prison/radio_random6.wav",
	"ambient/levels/prison/radio_random7.wav",
	"ambient/levels/prison/radio_random8.wav",
	"ambient/levels/prison/radio_random9.wav",
	"ambient/levels/prison/radio_random10.wav",
	"ambient/levels/prison/radio_random11.wav",
	"ambient/levels/prison/radio_random12.wav",
	"ambient/levels/prison/radio_random13.wav",
	"ambient/levels/prison/radio_random14.wav",
	"ambient/levels/prison/radio_random15.wav",
	}

	local RandomSong = Songs[math.random(1,100)]
	CurrentSong = RandomSong
end

function ENT:Use()
	if CurTime() - self.LastUsed < 0.3 then
		return 
	end

	self.LastUsed = CurTime()

	if IsWorking == true then
		self:EmitSound("hl1/buttons/lightswitch2.wav",50,100,0.7)
		self:EmitSound("hl1/buttons/lever2.wav",40,150,0.7)

	if Enabled == false then
		Enabled = true
		RandomizeSong()
		self.Music = CreateSound(self,CurrentSong)
		self.Music:SetSoundLevel(GetConVar("radiobroad_volume"):GetInt())
	else
		Enabled = false 
		self.Music:Stop()
		end
	end
end

function ENT:Think()

    if CurrentSong ~= nil then
        if self.SongNr == 0 then			
		    self.Music:Stop()
	    end

	    if self.SongNr == 1 and Enabled == true  then
		    self.Music:Play()
		    self.Music:ChangeVolume(0.5, 0)
	    end
    end

end

function ENT:PhysicsCollide( data )
	if data.Speed > 100 then
		self.Entity:EmitSound( "Computer.ImpactSoft" )
	end

	if data.Speed > 300 then
		self.Entity:EmitSound( "Computer.ImpactHard" )
	end
end

function ENT:OnRemove()

    if CurrentSong ~= nil then
        self.Music:Stop()
    end

end