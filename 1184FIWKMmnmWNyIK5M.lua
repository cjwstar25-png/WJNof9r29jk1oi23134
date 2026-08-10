local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().SharedConfig = getgenv().SharedConfig or {
    Language = "KO",
    MenuKey = Enum.KeyCode.RightShift,
    
    ESP_Master = true,
    Skeleton_ESP = true,
    Box_ESP = true,      
    Health_Bar = true,      
    Tracer_Lines = true,
    Info_Display = true,
    Team_Filter = false,
    Chams_Enabled = false,
    
    Aimbot = false,
    Aimbot_Smooth = 2,
    Aimbot_FOV = 150,
    Show_FOV = true,
    Hitbox = "Head",
    
    Ragebot = false,
    Ragebot_Speed = 5,
    Wall_Check = false,
    Triggerbot = false,
    
    Infinite_Jump = false,
    Fly_Mode = false,
    Fly_Speed = 80,
    Noclip = false,
    Speed_Hack = false,
    Speed_Val = 40,
    
    Skybox_Mode = "Off",
    Custom_Sky_Id = "600835154",
    
    Death_Audio = false,
    Death_Audio_Id = "84615664978587",
    
    Anti_Aim = false,
    Third_Person = false,
    Device_Spoof = false,
    Interactive_Cursor = false,
    FPS_Opt = false
}

local Config = getgenv().SharedConfig

local Translations = {
    EN = {
        Combat = "Combat Systems", Visuals = "Visuals & ESP", Player = "Player Enhancements", Misc = "Misc & World",
        Aimbot = "Aimbot", Ragebot = "Ragebot", WallCheck = "Wall Check", Triggerbot = "Triggerbot", AntiAim = "Visual Anti-Aim",
        ESPMaster = "ESP Master", SkeletonESP = "Skeleton", BoxESP = "Box ESP", HealthBar = "Health Bar", PlayerInfo = "Player Info",
        TracerLines = "Tracers", TeamFilter = "Team Filter", Chams = "Chams / Highlight", InfJump = "Infinite Jump",
        FlyMode = "Flight Mode", Noclip = "Noclip", SpeedHack = "Speed Hack", Forced3P = "Third-Person", SkyChanger = "Sky Atmosphere",
        DeathAudio = "Death Audio", Cursor = "Rainbow Cursor", FPSOpt = "FPS Unlocker", Spoof = "HWID Spoof",
        Properties = "Advanced Properties", SwitchHitbox = "Target Hitbox", ToggleSky = "Toggle Atmosphere",
        SoundID = "Audio Asset ID", SkyID = "Sky Texture ID", LangTitle = "Language Hub / 언어",
        Smoothness = "Smoothness", RageSpeed = "Rage Speed", FlySpeed = "Flight Speed", SpeedVal = "Speed Value",
        FOVRadius = "FOV Radius", ShowFOV = "Show FOV Circle"
    },
    KO = {
        Combat = "전투 시스템", Visuals = "시각 및 ESP", Player = "플레이어 강화", Misc = "기타",
        Aimbot = "에임봇", Ragebot = "레이지봇", WallCheck = "벽 관통 체크", Triggerbot = "트리거봇", AntiAim = "안티에임",
        ESPMaster = "ESP 마스터", SkeletonESP = "스켈레톤", BoxESP = "박스 ESP", HealthBar = "체력 바", PlayerInfo = "정보 표시",
        TracerLines = "트레이서 라인", TeamFilter = "팀 필터링", Chams = "하이라이트", InfJump = "무한 점프",
        FlyMode = "비행 모드", Noclip = "노클립", SpeedHack = "스피드 핵", Forced3P = "강제 3인칭", SkyChanger = "스카이 대기효과",
        DeathAudio = "데스 오디오", Cursor = "무지개 커서", FPSOpt = "프레임 최적화", Spoof = "기기 스푸핑",
        Properties = "고급 속성 설정", SwitchHitbox = "타겟 히트박스", ToggleSky = "대기 모드 전환",
        SoundID = "오디오 에셋 ID", SkyID = "스카이 텍스처 ID", LangTitle = "언어 설정 / Language",
        Smoothness = "부드러움", RageSpeed = "레이지 속도", FlySpeed = "비행 속도", SpeedVal = "이동 값",
        FOVRadius = "FOV 범위", ShowFOV = "FOV 원 표시"
    }
}

local function _T(key)
    local t = Translations[Config.Language] or Translations.EN
    return t[key] or Translations.EN[key] or key
end

pcall(function()
    local old = CoreGui:FindFirstChild("CubicUltimateHub")
    if old then old:Destroy() end
    local oldP = LocalPlayer.PlayerGui:FindFirstChild("CubicUltimateHub")
    if oldP then oldP:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CubicUltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local Dimmer = Instance.new("Frame", ScreenGui)
Dimmer.Size = UDim2.new(1, 0, 1, 0)
Dimmer.BackgroundColor3 = Color3.fromRGB(3, 5, 10)
Dimmer.BackgroundTransparency = 0.4
Dimmer.BorderSizePixel = 0
Dimmer.ZIndex = 0

local SubPopup = Instance.new("Frame", ScreenGui)
SubPopup.Size = UDim2.new(0, 270, 0, 200)
SubPopup.Position = UDim2.new(0, 0, 0, 0)
SubPopup.BackgroundColor3 = Color3.fromRGB(10, 14, 24)
SubPopup.BackgroundTransparency = 0.03
SubPopup.BorderSizePixel = 0
SubPopup.Visible = false
SubPopup.ZIndex = 3000

Instance.new("UICorner", SubPopup).CornerRadius = UDim.new(0, 14)
local spStroke = Instance.new("UIStroke", SubPopup)
spStroke.Color = Color3.fromRGB(70, 140, 255)
spStroke.Thickness = 1.8

local spTitle = Instance.new("TextLabel", SubPopup)
spTitle.Size = UDim2.new(1, 0, 0, 45)
spTitle.Position = UDim2.new(0, 16, 0, 0)
spTitle.BackgroundTransparency = 1
spTitle.TextColor3 = Color3.fromRGB(245, 250, 255)
spTitle.TextSize = 14
spTitle.Font = Enum.Font.GothamBold
spTitle.TextXAlignment = Enum.TextXAlignment.Left
spTitle.ZIndex = 3001

local spContent = Instance.new("ScrollingFrame", SubPopup)
spContent.Size = UDim2.new(1, -28, 1, -55)
spContent.Position = UDim2.new(0, 14, 0, 45)
spContent.BackgroundTransparency = 1
spContent.CanvasSize = UDim2.new(0, 0, 0, 0)
spContent.ScrollBarThickness = 2
spContent.ZIndex = 3001

local spLayout = Instance.new("UIListLayout", spContent)
spLayout.Padding = UDim.new(0, 10)
spLayout.SortOrder = Enum.SortOrder.LayoutOrder
spLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    spContent.CanvasSize = UDim2.new(0, 0, 0, spLayout.AbsoluteContentSize.Y + 20)
end)

local function ClosePopup()
    SubPopup.Visible = false
    for _, c in ipairs(spContent:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and SubPopup.Visible then
        local m = UserInputService:GetMouseLocation()
        local p, s = SubPopup.AbsolutePosition, SubPopup.AbsoluteSize
        if m.X < p.X or m.X > p.X + s.X or m.Y < p.Y or m.Y > p.Y + s.Y then
            ClosePopup()
        end
    end
end)

local Windows = {}
local UIElements = {}

local function CreateWindow(titleKey, posX)
    local frame = Instance.new("ScrollingFrame", ScreenGui)
    frame.Size = UDim2.new(0, 310, 0, 620)
    frame.Position = UDim2.new(0.5, posX, 0.5, -310)
    frame.BackgroundColor3 = Color3.fromRGB(8, 11, 18)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Color3.fromRGB(60, 130, 240)
    frame.ZIndex = 2

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fStroke = Instance.new("UIStroke", frame)
    fStroke.Color = Color3.fromRGB(45, 95, 180)
    fStroke.Transparency = 0.25
    fStroke.Thickness = 1.5

    local header = Instance.new("Frame", frame)
    header.Size = UDim2.new(1, 0, 0, 52)
    header.BackgroundColor3 = Color3.fromRGB(12, 17, 28)
    header.BorderSizePixel = 0
    header.ZIndex = 3

    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)
    local cover = Instance.new("Frame", header)
    cover.Size = UDim2.new(1, 0, 0, 12)
    cover.Position = UDim2.new(0, 0, 1, -12)
    cover.BackgroundColor3 = Color3.fromRGB(12, 17, 28)
    cover.BorderSizePixel = 0

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size = UDim2.new(1, -24, 1, 0)
    titleLbl.Position = UDim2.new(0, 16, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Name = "TitleLabel"
    titleLbl.Text = _T(titleKey)
    titleLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    titleLbl.TextSize = 15
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 4

    local list = Instance.new("UIListLayout", frame)
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", frame)
    pad.PaddingTop = UDim.new(0, 62)
    pad.PaddingBottom = UDim.new(0, 16)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 80)
    end)

    local dragging, dragInput, framePos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragInput = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragInput
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    frame:SetAttribute("TitleKey", titleKey)
    table.insert(Windows, frame)
    return frame
end

local WinCombat = CreateWindow("Combat", -640)
local WinVisuals = CreateWindow("Visuals", -320)
local WinPlayer = CreateWindow("Player", 0)
local WinMisc = CreateWindow("Misc", 320)

local function AddToggle(parent, nameKey, configKey, callback, rightClickFunc)
    local defaultState = Config[configKey] or false
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(18, 75, 175) or Color3.fromRGB(12, 17, 28)
    btn.Text = "    " .. _T(nameKey)
    btn.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 175, 210)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    btn:SetAttribute("NameKey", nameKey)

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = defaultState and Color3.fromRGB(80, 170, 255) or Color3.fromRGB(28, 42, 70)
    stroke.Transparency = 0.3
    stroke.Thickness = 1.2

    local status = Instance.new("TextLabel", btn)
    status.Size = UDim2.new(0, 60, 1, 0)
    status.Position = UDim2.new(1, -65, 0, 0)
    status.BackgroundTransparency = 1
    status.Text = defaultState and "ON" or "OFF"
    status.TextColor3 = defaultState and Color3.fromRGB(160, 225, 255) or Color3.fromRGB(90, 110, 140)
    status.TextSize = 12
    status.Font = Enum.Font.GothamBold
    status.TextXAlignment = Enum.TextXAlignment.Right
    status.ZIndex = 3

    local active = defaultState
    local info = TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    local function Toggle()
        active = not active
        Config[configKey] = active
        status.Text = active and "ON" or "OFF"
        TweenService:Create(btn, info, {BackgroundColor3 = active and Color3.fromRGB(18, 75, 175) or Color3.fromRGB(12, 17, 28)}):Play()
        TweenService:Create(btn, info, {TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 175, 210)}):Play()
        TweenService:Create(status, info, {TextColor3 = active and Color3.fromRGB(160, 225, 255) or Color3.fromRGB(90, 110, 140)}):Play()
        TweenService:Create(stroke, info, {Color = active and Color3.fromRGB(80, 170, 255) or Color3.fromRGB(28, 42, 70)}):Play()
        if callback then callback(active) end
    end

    btn.MouseButton1Click:Connect(Toggle)

    if rightClickFunc then
        btn.MouseButton2Click:Connect(function()
            ClosePopup()
            spTitle.Text = _T(nameKey) .. " " .. _T("Properties")
            rightClickFunc(spContent)
            local mouse = UserInputService:GetMouseLocation()
            SubPopup.Position = UDim2.new(0, math.clamp(mouse.X, 15, Camera.ViewportSize.X - 290), 0, math.clamp(mouse.Y, 15, Camera.ViewportSize.Y - 220))
            SubPopup.Visible = true
        end)
    end

    table.insert(UIElements, {Type = "Toggle", Button = btn, NameKey = nameKey})
end

local function AddSlider(parent, titleKey, configKey, min, max, step)
    local wrapper = Instance.new("Frame", parent)
    wrapper.Size = UDim2.new(1, 0, 0, 50)
    wrapper.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", wrapper)
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = _T(titleKey) .. ": " .. Config[configKey]
    lbl.TextColor3 = Color3.fromRGB(210, 230, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", wrapper)
    bg.Size = UDim2.new(1, 0, 0, 10)
    bg.Position = UDim2.new(0, 0, 0, 28)
    bg.BackgroundColor3 = Color3.fromRGB(20, 28, 42)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new(math.clamp((Config[configKey] - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((UserInputService:GetMouseLocation().X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor((min + (max - min) * pos) / step + 0.5) * step
            Config[configKey] = val
            lbl.Text = _T(titleKey) .. ": " .. val
        end
    end)
end

local function AddTextBox(parent, titleKey, configKey)
    local wrapper = Instance.new("Frame", parent)
    wrapper.Size = UDim2.new(1, 0, 0, 65)
    wrapper.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", wrapper)
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = _T(titleKey)
    lbl.TextColor3 = Color3.fromRGB(210, 230, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", wrapper)
    box.Size = UDim2.new(1, 0, 0, 36)
    box.Position = UDim2.new(0, 0, 0, 26)
    box.BackgroundColor3 = Color3.fromRGB(20, 28, 42)
    box.Text = tostring(Config[configKey])
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    box.FocusLost:Connect(function()
        Config[configKey] = box.Text
    end)
end

AddToggle(WinCombat, "Aimbot", "Aimbot", nil, function(c) 
    AddSlider(c, "Smoothness", "Aimbot_Smooth", 1, 10, 1)
    AddSlider(c, "FOVRadius", "Aimbot_FOV", 50, 500, 10)
    AddToggle(c, "ShowFOV", "Show_FOV")
end)
AddToggle(WinCombat, "Ragebot", "Ragebot", nil, function(c) 
    AddSlider(c, "RageSpeed", "Ragebot_Speed", 1, 20, 1) 
end)
AddToggle(WinCombat, "WallCheck", "Wall_Check")
AddToggle(WinCombat, "Triggerbot", "Triggerbot")
AddToggle(WinCombat, "AntiAim", "Anti_Aim")

AddToggle(WinVisuals, "ESPMaster", "ESP_Master")
AddToggle(WinVisuals, "BoxESP", "Box_ESP")
AddToggle(WinVisuals, "SkeletonESP", "Skeleton_ESP")
AddToggle(WinVisuals, "TracerLines", "Tracer_Lines")
AddToggle(WinVisuals, "PlayerInfo", "Info_Display")
AddToggle(WinVisuals, "HealthBar", "Health_Bar")
AddToggle(WinVisuals, "TeamFilter", "Team_Filter")
AddToggle(WinVisuals, "Chams", "Chams_Enabled")

AddToggle(WinPlayer, "InfJump", "Infinite_Jump")
AddToggle(WinPlayer, "FlyMode", "Fly_Mode", nil, function(c) 
    AddSlider(c, "FlySpeed", "Fly_Speed", 10, 200, 5) 
end)
AddToggle(WinPlayer, "Noclip", "Noclip")
AddToggle(WinPlayer, "SpeedHack", "Speed_Hack", nil, function(c) 
    AddSlider(c, "SpeedVal", "Speed_Val", 16, 150, 5) 
end)
AddToggle(WinPlayer, "Forced3P", "Third_Person")

AddToggle(WinMisc, "SkyChanger", "Skybox_Mode", function(state)
    if state then
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
        sky.SkyboxBk = "rbxassetid://" .. Config.Custom_Sky_Id
        sky.SkyboxDn = "rbxassetid://" .. Config.Custom_Sky_Id
        sky.SkyboxFt = "rbxassetid://" .. Config.Custom_Sky_Id
        sky.SkyboxLf = "rbxassetid://" .. Config.Custom_Sky_Id
        sky.SkyboxRt = "rbxassetid://" .. Config.Custom_Sky_Id
        sky.SkyboxUp = "rbxassetid://" .. Config.Custom_Sky_Id
    else
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if sky then sky:Destroy() end
    end
end, function(c) AddTextBox(c, "SkyID", "Custom_Sky_Id") end)

AddToggle(WinMisc, "DeathAudio", "Death_Audio", nil, function(c) AddTextBox(c, "SoundID", "Death_Audio_Id") end)
AddToggle(WinMisc, "Cursor", "Interactive_Cursor")
AddToggle(WinMisc, "FPSOpt", "FPS_Opt", function(state) pcall(function() if setfpscap then setfpscap(state and 120 or 60) end end) end)
AddToggle(WinMisc, "Spoof", "Device_Spoof")

local function RefreshAllUI()
    for _, win in ipairs(Windows) do
        local key = win:GetAttribute("TitleKey")
        if key then
            local lbl = win:FindFirstChild("TitleLabel", true)
            if lbl then lbl.Text = _T(key) end
        end
    end
    for _, el in ipairs(UIElements) do
        if el.Type == "Toggle" then el.Button.Text = "    " .. _T(el.NameKey) end
    end
end

local LanguageBar = Instance.new("Frame", ScreenGui)
LanguageBar.Size = UDim2.new(0, 220, 0, 50)
LanguageBar.Position = UDim2.new(0, 20, 0.5, -25)
LanguageBar.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
LanguageBar.BackgroundTransparency = 0.05
LanguageBar.ZIndex = 1500
Instance.new("UICorner", LanguageBar).CornerRadius = UDim.new(0, 12)
local lbStroke = Instance.new("UIStroke", LanguageBar)
lbStroke.Color = Color3.fromRGB(70, 150, 255)
lbStroke.Thickness = 1.5

local btnEN = Instance.new("TextButton", LanguageBar)
btnEN.Size = UDim2.new(0.44, 0, 0, 36)
btnEN.Position = UDim2.new(0.04, 0, 0, 7)
btnEN.BackgroundColor3 = Color3.fromRGB(25, 45, 80)
btnEN.Text = "EN"
btnEN.TextColor3 = Color3.fromRGB(255, 255, 255)
btnEN.Font = Enum.Font.GothamBold
btnEN.TextSize = 12
btnEN.ZIndex = 1501
Instance.new("UICorner", btnEN).CornerRadius = UDim.new(0, 8)

local btnKO = Instance.new("TextButton", LanguageBar)
btnKO.Size = UDim2.new(0.44, 0, 0, 36)
btnKO.Position = UDim2.new(0.52, 0, 0, 7)
btnKO.BackgroundColor3 = Color3.fromRGB(25, 45, 80)
btnKO.Text = "KO"
btnKO.TextColor3 = Color3.fromRGB(255, 255, 255)
btnKO.Font = Enum.Font.GothamBold
btnKO.TextSize = 12
btnKO.ZIndex = 1501
Instance.new("UICorner", btnKO).CornerRadius = UDim.new(0, 8)

btnEN.MouseButton1Click:Connect(function() Config.Language = "EN" RefreshAllUI() end)
btnKO.MouseButton1Click:Connect(function() Config.Language = "KO" RefreshAllUI() end)

local MenuVisible = true
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -85)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 2000
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local tbStroke = Instance.new("UIStroke", ToggleBtn)
tbStroke.Color = Color3.fromRGB(80, 160, 255)
tbStroke.Thickness = 2

local function ToggleHub()
    MenuVisible = not MenuVisible
    local info = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    TweenService:Create(Dimmer, info, {BackgroundTransparency = MenuVisible and 0.4 or 1}):Play()
    for _, w in ipairs(Windows) do w.Visible = MenuVisible end
    LanguageBar.Visible = MenuVisible
    if not MenuVisible then ClosePopup() end
end

ToggleBtn.MouseButton1Click:Connect(ToggleHub)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Config.MenuKey then ToggleHub() end
end)
