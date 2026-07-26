AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local function IsTaunting(ply)
    return IsValid(ply) and ply:Alive() and ply:IsPlayingTaunt()
end

function GM:SetupMove(ply, mv, cmd)
    if not IsTaunting(ply) then return end

    -- Freeze movement input
    mv:SetForwardSpeed(0)
    mv:SetSideSpeed(0)
    mv:SetUpSpeed(0)
    mv:SetButtons(0)
    mv:SetVelocity(vector_origin)
    mv:SetMaxClientSpeed(0)
    mv:SetMaxSpeed(0)

    -- Snap to the floor
    local tr = util.TraceHull({
        start = ply:GetPos(),
        endpos = ply:GetPos() - Vector(0, 0, 10000),
        mins = ply:OBBMins(),
        maxs = ply:OBBMaxs(),
        filter = ply,
        mask = MASK_PLAYERSOLID
    })

    if tr.Hit then
        mv:SetOrigin(tr.HitPos)
    end
end

GM.RespawnTime = 5

local function EveryoneDead()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() then
            return false
        end
    end

    return #player.GetAll() > 0
end

function GM:PlayerDeath(victim)
    if EveryoneDead() then
        timer.Remove("CETS_Respawn_" .. victim:SteamID64())
for _, ply in ipairs(player.GetAll()) do
    ply:EmitSound("ambient/alarms/klaxon1.wav", 75, 100, 1)
end
        timer.Simple(2, function()
            RunConsoleCommand("changelevel", game.GetMap())
        end)

        return
    end

    timer.Create("CETS_Respawn_" .. victim:SteamID64(), GM.RespawnTime, 1, function()
        if IsValid(victim) and not victim:Alive() then
            victim:Spawn()
        end
    end)
end

function GM:PlayerDeathThink()
    return false
end

function GM:PlayerLoadout(ply)
	return true
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)
end

util.AddNetworkString("cets_playermodel_set")

local DEFAULT_MODEL = "models/player/group01/male_07.mdl"

local function BuildValidModelSet()
    local set = {}

    for _, model in pairs(player_manager.AllValidModels()) do
        set[string.lower(model)] = true
    end

    return set
end

local VALID_MODELS = BuildValidModelSet()

local function IsValidPlayerModel(model)
    return isstring(model) and VALID_MODELS[string.lower(model)] == true
end

function GM:GetDefaultPlayerModel()
    return DEFAULT_MODEL
end

function GM:PlayerInitialSpawn(ply)
    local savedModel = ply:GetPData("cets_selected_model", DEFAULT_MODEL)
    if not IsValidPlayerModel(savedModel) then
        savedModel = DEFAULT_MODEL
    end

    ply.CETS_SelectedModel = savedModel
    ply:SetNWString("cets_selected_model", savedModel)
end

function GM:PlayerSetModel(ply)
    local model = ply.CETS_SelectedModel or ply:GetNWString("cets_selected_model", "")

    if not IsValidPlayerModel(model) then
        model = DEFAULT_MODEL
    end

    ply:SetModel(model)
end

function GM:PlayerLoadout(ply)
    return true
end


local rewardWeapons = {
    "weapon_ply_comgr",
    "weapon_ply_comgr_a",
    "weapon_ply_comgr_s",
    "weapon_ply_fragnade",
    "weapon_vj_cets_glock",
    "weapon_vj_cets_egon",
    "weapon_vj_cets_hecusniper",
    "weapon_ply_hornetgun",
    "weapon_vj_cets_hmg",
    "weapon_ply_moly",
    "weapon_vj_cets_mp5k",
    "weapon_vj_cets_mp5sd",
    "weapon_vj_cets_oicw",
    "weapon_ply_shockroach",
    "weapon_ply_snark",
    "weapon_vj_cets_tau",
    "weapon_ply_xenbionade",
}

local defaultAmmo = 60

function GM:StartCommand(ply, cmd)
    if cmd:GetImpulse() ~= 101 then return end

    for _, class in ipairs(rewardWeapons) do
        local wep = ply:Give(class)
        if not IsValid(wep) then continue end

        local ammoType = wep:GetPrimaryAmmoType()
        if ammoType ~= -1 then
            ply:GiveAmmo(defaultAmmo, ammoType, true)
        end
    end
end

GM.CurrentCheckpoint = nil
GM.RespawnTime = 5

----------------------------------------------------
-- CHECKPOINT SAVE/LOAD
----------------------------------------------------

local function CheckpointFile()
    return "cets/" .. game.GetMap() .. ".json"
end

function GM:SetCheckpoint(pos, ang)

    self.CurrentCheckpoint = {
        pos = {
            x = pos.x,
            y = pos.y,
            z = pos.z
        },

        ang = {
            p = ang.p,
            y = ang.y,
            r = ang.r
        }
    }

    file.CreateDir("cets")
    file.Write(
        CheckpointFile(),
        util.TableToJSON(self.CurrentCheckpoint, true)
    )

    PrintMessage(HUD_PRINTCENTER, "Checkpoint!")
end

local function LoadCheckpoint()

    local fileName = CheckpointFile()

    if not file.Exists(fileName, "DATA") then
        return
    end

    local data = util.JSONToTable(file.Read(fileName, "DATA"))

    if not data then return end

    GAMEMODE.CurrentCheckpoint = {
        pos = Vector(
            data.pos.x,
            data.pos.y,
            data.pos.z
        ),

        ang = Angle(
            data.ang.p,
            data.ang.y,
            data.ang.r
        )
    }

end

hook.Add("Initialize", "CETS_LoadCheckpoint", LoadCheckpoint)

----------------------------------------------------
-- SPAWN
----------------------------------------------------

hook.Add("PlayerSpawn", "CETS_CheckpointSpawn", function(ply)

    local cp = GAMEMODE.CurrentCheckpoint
    if not cp then return end

    timer.Simple(0, function()

        if not IsValid(ply) then return end

        ply:SetPos(cp.pos)
        ply:SetEyeAngles(cp.ang)

    end)

end)

----------------------------------------------------
-- DEATH
----------------------------------------------------

local function EveryoneDead()

    local players = player.GetAll()

    if #players == 0 then
        return false
    end

    for _, ply in ipairs(players) do
        if ply:Alive() then
            return false
        end
    end

    return true
end

function GM:PlayerDeath(victim)

    if EveryoneDead() then

        timer.Simple(2, function()

            if GAMEMODE.CurrentCheckpoint then

                for _, ply in ipairs(player.GetAll()) do

                    if IsValid(ply) then
                        ply:Spawn()
                    end

                end

            else

                RunConsoleCommand("changelevel", game.GetMap())

            end

        end)

        return
    end

    timer.Simple(self.RespawnTime, function()

        if IsValid(victim) and not victim:Alive() then
            victim:Spawn()
        end

    end)

end

function GM:PlayerDeathThink()
    return false
end