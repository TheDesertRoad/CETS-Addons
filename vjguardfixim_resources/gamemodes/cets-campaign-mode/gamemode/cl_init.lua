include("shared.lua")

local FRAME_W, FRAME_H = 1100, 720
local DEFAULT_MODEL = "models/player/group01/male_07.mdl"

local function BuildModelList(filterText)
	local models = player_manager.AllValidModels()
	local list = {}
	local filter = string.Trim(string.lower(filterText or ""))

	for name, model in pairs(models) do
		local nameLower = string.lower(name)
		local modelLower = string.lower(model)

		if filter == ""
			or string.find(nameLower, filter, 1, true)
			or string.find(modelLower, filter, 1, true) then
			list[#list + 1] = {
				name = name,
				model = model
			}
		end
	end

	table.sort(list, function(a, b)
		return string.lower(a.name) < string.lower(b.name)
	end)

	return list
end

local function GetCurrentModel()
	local mdl = LocalPlayer():GetNWString("cets_selected_model", "")
	if mdl == "" then
		mdl = cookie.GetString("cets_selected_model", "")
	end

	if mdl == "" then
		mdl = DEFAULT_MODEL
	end

	return mdl
end

local function OpenPlayermodelMenu()
	if IsValid(CETS_PlayermodelFrame) then
		CETS_PlayermodelFrame:Remove()
	end

	local currentModel = GetCurrentModel()
	local selectedModel = currentModel

	CETS_PlayermodelFrame = vgui.Create("DFrame")
	CETS_PlayermodelFrame:SetSize(FRAME_W, FRAME_H)
	CETS_PlayermodelFrame:Center()
	CETS_PlayermodelFrame:SetTitle("CETS: Playermodel Selector")
	CETS_PlayermodelFrame:MakePopup()

	local preview = vgui.Create("DModelPanel", CETS_PlayermodelFrame)
	preview:SetPos(-130, 25)
	preview:SetSize(670, 600)
	preview:SetModel(currentModel)
	preview:SetFOV(42)
	preview:SetCamPos(Vector(68, 0, 60))
	preview:SetLookAt(Vector(0, 0, 60))
	preview:SetAnimated(true)
	function preview:LayoutEntity(ent)
		ent:SetAngles(Angle(0, RealTime() * 18 % 360, 0))
	end

	local search = vgui.Create("DTextEntry", CETS_PlayermodelFrame)
	search:SetPos(400, 45)
	search:SetSize(680, 28)
	search:SetPlaceholderText("Search models by name or path...")

	local scroll = vgui.Create("DScrollPanel", CETS_PlayermodelFrame)
	scroll:SetPos(400, 83)
	scroll:SetSize(680, 562)

	local layout = vgui.Create("DIconLayout", scroll)
	layout:Dock(FILL)
	layout:SetSpaceX(8)
	layout:SetSpaceY(8)

	local function RebuildList()
		layout:Clear()

		local filter = search:GetValue()
		local entries = BuildModelList(filter)

		for _, entry in ipairs(entries) do
			local icon = layout:Add("SpawnIcon")
			icon:SetSize(96, 96)
			icon:SetModel(entry.model)
			icon:SetTooltip(entry.name .. "\n" .. entry.model)

			function icon:DoClick()
				selectedModel = entry.model
				preview:SetModel(entry.model)
				cookie.Set("cets_selected_model", entry.model)
			end
		end
	end

	search.OnChange = function()
		RebuildList()
	end

	local bottom = vgui.Create("DPanel", CETS_PlayermodelFrame)
	bottom:SetPos(20, 655)
	bottom:SetSize(1060, 50)
	bottom.Paint = function() end

	local selectBtn = vgui.Create("DButton", bottom)
	selectBtn:SetPos(0, 5)
	selectBtn:SetSize(180, 40)
	selectBtn:SetText("Use Selected Model")
	function selectBtn:DoClick()
		if not selectedModel or selectedModel == "" then return end

		net.Start("cets_playermodel_set")
			net.WriteString(selectedModel)
		net.SendToServer()

		cookie.Set("cets_selected_model", selectedModel)
		CETS_PlayermodelFrame:Close()
	end

	local randomBtn = vgui.Create("DButton", bottom)
	randomBtn:SetPos(190, 5)
	randomBtn:SetSize(180, 40)
	randomBtn:SetText("Random Model")
	function randomBtn:DoClick()
		local entries = BuildModelList("")
		if #entries == 0 then return end

		local entry = entries[math.random(#entries)]
		selectedModel = entry.model
		preview:SetModel(entry.model)
		cookie.Set("cets_selected_model", entry.model)
	end

	local closeBtn = vgui.Create("DButton", bottom)
	closeBtn:SetPos(380, 5)
	closeBtn:SetSize(90, 40)
	closeBtn:SetText("Close")
	function closeBtn:DoClick()
		CETS_PlayermodelFrame:Close()
	end

	RebuildList()
end

concommand.Add("cets_playermodel_menu", OpenPlayermodelMenu)

hook.Add("OnPlayerChat", "CETS_OpenPlayermodelMenuChat", function(ply, text)
	if ply ~= LocalPlayer() then return end

	local msg = string.lower(string.Trim(text))
	if msg == "!playermodel" or msg == "/playermodel" then
		OpenPlayermodelMenu()
		return true
	end
end)


local function IsTaunting(ply)
    return IsValid(ply) and ply:Alive() and ply:IsPlayingTaunt()
end

hook.Add("CalcView", "CETS_TauntThirdPerson", function(ply, pos, ang, fov, znear, zfar)
    if not IsTaunting(ply) then return end

    local eyePos = ply:EyePos()
    local viewAng = ply:EyeAngles()

    local desired = eyePos
        - viewAng:Forward() * 120
        + viewAng:Right() * 20
        + viewAng:Up() * 8

    local tr = util.TraceHull({
        start = eyePos,
        endpos = desired,
        filter = ply,
        mins = Vector(-4, -4, -4),
        maxs = Vector(4, 4, 4),
        mask = MASK_SOLID
    })

    return {
        origin = tr.HitPos,
        angles = viewAng,
        fov = fov,
        drawviewer = true
    }
end)