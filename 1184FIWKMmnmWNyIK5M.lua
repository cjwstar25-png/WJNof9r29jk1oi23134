loadstring(game:HttpGet(""))()

--!nocheck
----------------------------------------------------------------
-- CUBIC ULTIMATE HUB - UI ONLY (최적화)
----------------------------------------------------------------
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------
getgenv().SharedConfig = getgenv().SharedConfig or {
    Language = "EN",
    MenuKey = Enum.KeyCode.RightShift,
    ESP_Master = false,
    Box_ESP = false,
    Health_Bar = false,
    Info_Display = false,
    Team_Filter = false,
    Chams_Enabled = false,
    Aimbot = false,
    Aimbot_Smooth = 2,
    Aimbot_FOV = 150,
    Show_FOV = true,
    Hitbox = "Head",
    Ragebot = false,
    Triggerbot = false,
    Infinite_Jump = false,
    Fly_Mode = false,
    Fly_Speed = 80,
    Noclip = false,
    Speed_Hack = false,
    Speed_Val = 40,
    Skybox_Mode = false,
    Custom_Sky_Id = "600835154",
    Death_Audio = false,
    Death_Audio_Id = "84615664978587",
    Anti_Aim = false,
    Third_Person = false,
    Device_Spoof = false,
    Interactive_Cursor = false,
    FPS_Opt = false,
}

local Config = getgenv().SharedConfig

----------------------------------------------------------------
-- THEME
----------------------------------------------------------------
local T = {
    Bg = Color3.fromRGB(8,7,7),
    Panel = Color3.fromRGB(18,12,12),
    Panel2 = Color3.fromRGB(25,14,14),
    Panel3 = Color3.fromRGB(36,18,18),
    Header = Color3.fromRGB(220,44,38),
    HeaderD = Color3.fromRGB(176,29,29),
    Accent = Color3.fromRGB(238,48,40),
    AccentB = Color3.fromRGB(255,86,72),
    Border = Color3.fromRGB(117,37,37),
    BorderB = Color3.fromRGB(171,47,47),
    Text = Color3.fromRGB(255,248,248),
    TextS = Color3.fromRGB(211,187,187),
    TextM = Color3.fromRGB(149,122,122),
    Off = Color3.fromRGB(28,16,16),
    OffH = Color3.fromRGB(43,21,21),
    OffB = Color3.fromRGB(72,37,37),
    Black = Color3.fromRGB(0,0,0),
}

----------------------------------------------------------------
-- TRANSLATIONS (압축)
----------------------------------------------------------------
local L = {
    EN = {
        Combat="Combat Systems", Visuals="Visuals & ESP", Player="Player Enhancements", Misc="Misc & World",
        Aimbot="Aimbot", Ragebot="Ragebot", Triggerbot="Triggerbot", AntiAim="Visual Anti-Aim",
        ESPMaster="ESP Master", BoxESP="Box ESP", HealthBar="Health Bar", PlayerInfo="Player Info",
        TeamFilter="Team Filter", Chams="Chams", InfJump="Infinite Jump", FlyMode="Flight Mode",
        Noclip="Noclip", SpeedHack="Speed Hack", Forced3P="Third-Person", SkyChanger="Sky Atmosphere",
        DeathAudio="Death Audio", Cursor="Rainbow Cursor", FPSOpt="FPS Unlocker", Spoof="HWID Spoof",
        Properties="Properties", Language="Language", Keybind="UI Toggle Key", PressToBind="Press a key...",
        MobileToggle="UI", Smoothness="Smoothness", FlySpeed="Flight Speed", SpeedVal="Speed Value",
        FOVRadius="FOV Radius", ShowFOV="Show FOV Circle",
    },
    KO = {
        Combat="전투 시스템", Visuals="시각 및 ESP", Player="플레이어 강화", Misc="기타 및 월드",
        Aimbot="에임봇", Ragebot="레이지봇", Triggerbot="트리거봇", AntiAim="안티에임",
        ESPMaster="ESP 마스터", BoxESP="박스 ESP", HealthBar="체력 바", PlayerInfo="정보 표시",
        TeamFilter="팀 필터", Chams="하이라이트", InfJump="무한 점프", FlyMode="비행 모드",
        Noclip="노클립", SpeedHack="스피드 핵", Forced3P="강제 3인칭", SkyChanger="스카이 대기효과",
        DeathAudio="데스 오디오", Cursor="무지개 커서", FPSOpt="프레임 최적화", Spoof="기기 스푸핑",
        Properties="속성 설정", Language="언어", Keybind="UI 토글 키", PressToBind="키를 누르세요...",
        MobileToggle="UI", Smoothness="부드러움", FlySpeed="비행 속도", SpeedVal="이동 값",
        FOVRadius="FOV 범위", ShowFOV="FOV 원 표시",
    }
}

local function Tr(k) local lang = Config.Language=="KO" and "KO" or "EN" return (L[lang] and L[lang][k]) or L.EN[k] or k end

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------
local function cr(p,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=p return c end
local function st(p,c,t,tr) local s=Instance.new("UIStroke") s.Color=c s.Thickness=t s.Transparency=tr or 0 s.Parent=p return s end
local function tw(i,d,p,s,dir) pcall(function() TweenService:Create(i,TweenInfo.new(d or .18,s or Enum.EasingStyle.Quart,dir or Enum.EasingDirection.Out),p):Play() end) end
local function make(cls,p) local i=Instance.new(cls) i.Parent=p return i end
local function size(i,x,y) i.Size=UDim2.fromOffset(x,y) end
local function pos(i,x,y) i.Position=UDim2.fromOffset(x,y) end
local function scale(i,x,y) i.Size=UDim2.new(x or 0,y or 0,0,0) end
local function pscale(i,x,y) i.Position=UDim2.new(x or 0,y or 0,0,0) end

----------------------------------------------------------------
-- SCREEN GUI
----------------------------------------------------------------
local SG = make("ScreenGui", CoreGui)
SG.Name = "CubicUltimateHub"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Global
SG.DisplayOrder = 1000

local Root = make("Frame", SG)
Root.Name = "Root"
Root.Size = UDim2.fromScale(1,1)
Root.BackgroundTransparency = 1
Root.BorderSizePixel = 0

make("Frame", Root).Name = "Dimmer"
local Dimmer = Root.Dimmer
Dimmer.Size = UDim2.fromScale(1,1)
Dimmer.BackgroundColor3 = T.Black
Dimmer.BackgroundTransparency = .55
Dimmer.BorderSizePixel = 0
Dimmer.ZIndex = 0

local WL = make("Frame", Root)
WL.Name = "WindowLayer"
WL.Size = UDim2.fromScale(1,1)
WL.BackgroundTransparency = 1
WL.BorderSizePixel = 0
WL.ZIndex = 10

local Scl = make("UIScale", WL)
local function updScl()
    local c = Workspace.CurrentCamera
    if not c then return end
    local v = c.ViewportSize
    local f = math.min(v.X/1400, v.Y/820)
    Scl.Scale = math.clamp(f,.72,1)
end
task.defer(updScl)
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() task.defer(updScl) end)

----------------------------------------------------------------
-- POPUP
----------------------------------------------------------------
local Popup = make("Frame", Root)
Popup.Name = "PropertiesPopup"
Popup.Size = UDim2.fromOffset(360,330)
Popup.AnchorPoint = Vector2.new(.5,.5)
Popup.Position = UDim2.new(.5,0,.5,0)
Popup.BackgroundColor3 = T.Panel2
Popup.BorderSizePixel = 0
Popup.Visible = false
Popup.ZIndex = 5000
cr(Popup,16)
st(Popup,T.BorderB,1.6,.05)

local PH = make("Frame", Popup)
PH.Size = UDim2.new(1,0,0,54)
PH.BackgroundColor3 = T.HeaderD
PH.BorderSizePixel = 0
PH.ZIndex = 5001
cr(PH,16)
make("Frame", PH).Size = UDim2.new(1,0,0,18)
PH:FindFirstChildOfClass("Frame").Position = UDim2.new(0,0,1,-18)
PH:FindFirstChildOfClass("Frame").BackgroundColor3 = T.HeaderD
PH:FindFirstChildOfClass("Frame").BorderSizePixel = 0
PH:FindFirstChildOfClass("Frame").ZIndex = 5001

local PT = make("TextLabel", PH)
PT.Position = UDim2.fromOffset(16,0)
PT.Size = UDim2.new(1,-58,1,0)
PT.BackgroundTransparency = 1
PT.Text = ""
PT.TextColor3 = T.Text
PT.TextSize = 14
PT.Font = Enum.Font.GothamBold
PT.TextXAlignment = Enum.TextXAlignment.Left
PT.ZIndex = 5002

local PC = make("TextButton", PH)
PC.AnchorPoint = Vector2.new(1,.5)
PC.Position = UDim2.new(1,-12,.5,0)
PC.Size = UDim2.fromOffset(28,28)
PC.BackgroundColor3 = T.Panel
PC.BorderSizePixel = 0
PC.Text = "×"
PC.TextColor3 = T.Text
PC.TextSize = 18
PC.Font = Enum.Font.GothamBold
PC.AutoButtonColor = false
PC.ZIndex = 5003
cr(PC,8)
st(PC,T.Border,1,.05)

local PContent = make("ScrollingFrame", Popup)
PContent.Position = UDim2.fromOffset(14,66)
PContent.Size = UDim2.new(1,-28,1,-80)
PContent.BackgroundTransparency = 1
PContent.BorderSizePixel = 0
PContent.ScrollBarThickness = 4
PContent.ScrollBarImageColor3 = T.Accent
PContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
PContent.CanvasSize = UDim2.fromOffset(0,0)
PContent.ZIndex = 5001

make("UIListLayout", PContent).Padding = UDim.new(0,10)
make("UIPadding", PContent).PaddingBottom = UDim.new(0,10)

local function ClearPopup()
    for _,c in ipairs(PContent:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
end

local function ClosePopup()
    Popup.Visible = false
    ClearPopup()
end

local function OpenPopup(title, builder, mp)
    ClearPopup()
    PT.Text = title
    builder(PContent)
    local c = Workspace.CurrentCamera
    if c and mp then
        local v = c.ViewportSize
        local w = Popup.AbsoluteSize.X
        local h = Popup.AbsoluteSize.Y
        local x = math.clamp(mp.X, w/2+12, v.X-w/2-12)
        local y = math.clamp(mp.Y, h/2+12, v.Y-h/2-12)
        Popup.Position = UDim2.fromOffset(x,y)
    end
    Popup.Size = UDim2.fromOffset(340,310)
    Popup.Visible = true
    tw(Popup,.18,{Size=UDim2.fromOffset(360,330)},Enum.EasingStyle.Back)
end
PC.MouseButton1Click:Connect(ClosePopup)

----------------------------------------------------------------
-- UI COMPONENTS
----------------------------------------------------------------
local UIE = {}
local Windows = {}

local function AddTextBox(parent, tk, ck)
    local w = make("Frame", parent)
    w.Size = UDim2.new(1,0,0,70)
    w.BackgroundTransparency = 1
    w.ZIndex = 5100

    local l = make("TextLabel", w)
    l.Size = UDim2.new(1,0,0,20)
    l.BackgroundTransparency = 1
    l.Text = Tr(tk)
    l.TextColor3 = T.TextS
    l.TextSize = 11
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 5101

    local b = make("TextBox", w)
    b.Position = UDim2.fromOffset(0,28)
    b.Size = UDim2.new(1,0,0,34)
    b.BackgroundColor3 = T.Off
    b.BorderSizePixel = 0
    b.Text = tostring(Config[ck] or "")
    b.TextColor3 = T.Text
    b.TextSize = 12
    b.Font = Enum.Font.Gotham
    b.ClearTextOnFocus = false
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ZIndex = 5101
    cr(b,9); st(b,T.OffB,1,.05)

    b.Focused:Connect(function() tw(b,.12,{BackgroundColor3=T.OffH}) end)
    b.FocusLost:Connect(function() Config[ck]=b.Text; tw(b,.12,{BackgroundColor3=T.Off}) end)
    return w
end

local function AddSlider(parent, tk, ck, mn, mx, stp)
    local w = make("Frame", parent)
    w.Size = UDim2.new(1,0,0,60)
    w.BackgroundTransparency = 1
    w.ZIndex = 5100

    local l = make("TextLabel", w)
    l.Size = UDim2.new(1,0,0,20)
    l.BackgroundTransparency = 1
    l.Text = Tr(tk)..": "..tostring(Config[ck] or mn)
    l.TextColor3 = T.Text
    l.TextSize = 11
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 5101

    local track = make("Frame", w)
    track.Position = UDim2.fromOffset(0,30)
    track.Size = UDim2.new(1,0,0,12)
    track.BackgroundColor3 = T.Off
    track.BorderSizePixel = 0
    track.ZIndex = 5101
    cr(track,8); st(track,T.OffB,1,.05)

    local fill = make("Frame", track)
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = T.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 5102
    cr(fill,8)

    local knob = make("Frame", track)
    knob.AnchorPoint = Vector2.new(.5,.5)
    knob.Position = UDim2.new(0,0,.5,0)
    knob.Size = UDim2.fromOffset(18,18)
    knob.BackgroundColor3 = T.Text
    knob.BorderSizePixel = 0
    knob.ZIndex = 5103
    cr(knob,20); st(knob,T.Accent,2,0)

    local val = tonumber(Config[ck]) or mn
    local drag = false

    local function apply(mx)
        local w2 = math.max(1, track.AbsoluteSize.X)
        local p = math.clamp((mx - track.AbsolutePosition.X)/w2, 0, 1)
        local raw = mn + (mx - mn) * p
        val = math.floor(raw/stp + .5) * stp
        val = math.clamp(val, mn, mx)
        Config[ck] = val
        local pc = (val - mn) / (mx - mn)
        fill.Size = UDim2.new(pc,0,1,0)
        knob.Position = UDim2.new(pc,0,.5,0)
        l.Text = Tr(tk)..": "..tostring(val)
    end

    local ip = math.clamp((val-mn)/(mx-mn),0,1)
    fill.Size = UDim2.new(ip,0,1,0)
    knob.Position = UDim2.new(ip,0,.5,0)

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            apply(i.Position.X)
            tw(knob,.1,{Size=UDim2.fromOffset(22,22)})
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            apply(UserInputService:GetMouseLocation().X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
            tw(knob,.1,{Size=UDim2.fromOffset(18,18)})
        end
    end)
    return w
end

local function AddToggle(parent, tk, ck, cb, rcb)
    local active = Config[ck] == true
    local btn = make("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,42)
    btn.BackgroundColor3 = active and Color3.fromRGB(105,27,27) or T.Off
    btn.BorderSizePixel = 0
    btn.Text = "  "..Tr(tk)
    btn.TextColor3 = active and T.Text or T.TextS
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 300
    cr(btn,10)
    local bs = st(btn, active and T.BorderB or T.OffB,1.15,.05)

    local status = make("TextLabel", btn)
    status.AnchorPoint = Vector2.new(1,.5)
    status.Position = UDim2.new(1,-30,.5,0)
    status.Size = UDim2.fromOffset(32,18)
    status.BackgroundTransparency = 1
    status.Text = active and "ON" or "OFF"
    status.TextColor3 = active and T.AccentB or T.TextM
    status.TextSize = 9
    status.Font = Enum.Font.GothamBold
    status.TextXAlignment = Enum.TextXAlignment.Right
    status.ZIndex = 301

    local ind = make("Frame", btn)
    ind.AnchorPoint = Vector2.new(1,.5)
    ind.Position = UDim2.new(1,-12,.5,0)
    ind.Size = UDim2.fromOffset(8,8)
    ind.BackgroundColor3 = active and T.AccentB or T.TextM
    ind.BorderSizePixel = 0
    ind.ZIndex = 302
    cr(ind,8)

    local function upd()
        btn.BackgroundColor3 = active and Color3.fromRGB(105,27,27) or T.Off
        btn.TextColor3 = active and T.Text or T.TextS
        bs.Color = active and T.BorderB or T.OffB
        status.Text = active and "ON" or "OFF"
        status.TextColor3 = active and T.AccentB or T.TextM
        ind.BackgroundColor3 = active and T.AccentB or T.TextM
    end

    local function setState(s)
        active = s == true
        Config[ck] = active
        upd()
        if cb then cb(active) end
    end

    btn.MouseButton1Click:Connect(function() setState(not active) end)
    btn.MouseEnter:Connect(function() tw(btn,.1,{BackgroundColor3=active and Color3.fromRGB(122,31,31) or T.OffH}) end)
    btn.MouseLeave:Connect(upd)

    if rcb then
        btn.MouseButton2Click:Connect(function()
            OpenPopup(Tr(tk).." "..Tr("Properties"), rcb, UserInputService:GetMouseLocation())
        end)
    end

    table.insert(UIE, {Type="Toggle", Button=btn, NameKey=tk})
    return btn
end

----------------------------------------------------------------
-- CREATE WINDOW
----------------------------------------------------------------
local function CreateWindow(tk, xo)
    local w = make("ScrollingFrame", WL)
    w.Name = tk.."Window"
    w.AnchorPoint = Vector2.new(.5,.5)
    w.Position = UDim2.new(.5,xo,.5,0)
    w.Size = UDim2.fromOffset(300,660)
    w.BackgroundColor3 = T.Panel
    w.BackgroundTransparency = 0
    w.BorderSizePixel = 0
    w.CanvasSize = UDim2.fromOffset(0,0)
    w.AutomaticCanvasSize = Enum.AutomaticSize.Y
    w.ScrollBarThickness = 5
    w.ScrollBarImageColor3 = T.Accent
    w.ScrollingDirection = Enum.ScrollingDirection.Y
    w.ZIndex = 100
    cr(w,16); st(w,T.Border,1.4,.02)

    local h = make("Frame", w)
    h.Name = "Header"
    h.Size = UDim2.new(1,0,0,60)
    h.BackgroundColor3 = T.Header
    h.BorderSizePixel = 0
    h.ZIndex = 110
    cr(h,16)

    local hc = make("Frame", h)
    hc.Size = UDim2.new(1,0,0,18)
    hc.Position = UDim2.new(0,0,1,-18)
    hc.BackgroundColor3 = T.Header
    hc.BorderSizePixel = 0
    hc.ZIndex = 110

    local hl = make("Frame", h)
    hl.Position = UDim2.fromOffset(14,14)
    hl.Size = UDim2.fromOffset(4,32)
    hl.BackgroundColor3 = T.Text
    hl.BorderSizePixel = 0
    hl.ZIndex = 111
    cr(hl,4)

    local title = make("TextLabel", h)
    title.Name = "TitleLabel"
    title.Position = UDim2.fromOffset(28,8)
    title.Size = UDim2.new(1,-40,0,24)
    title.BackgroundTransparency = 1
    title.Text = Tr(tk)
    title.TextColor3 = T.Text
    title.TextSize = 15
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 111

    local sub = make("TextLabel", h)
    sub.Position = UDim2.fromOffset(29,32)
    sub.Size = UDim2.new(1,-42,0,15)
    sub.BackgroundTransparency = 1
    sub.Text = "MODULE CONTROLS"
    sub.TextColor3 = Color3.fromRGB(255,194,187)
    sub.TextSize = 8
    sub.Font = Enum.Font.GothamBold
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 111

    local body = make("ScrollingFrame", w)
    body.Name = "Content"
    body.Position = UDim2.fromOffset(12,72)
    body.Size = UDim2.new(1,-24,1,-84)
    body.BackgroundTransparency = 1
    body.BorderSizePixel = 0
    body.ScrollBarThickness = 4
    body.ScrollBarImageColor3 = T.Accent
    body.AutomaticCanvasSize = Enum.AutomaticSize.Y
    body.CanvasSize = UDim2.fromOffset(0,0)
    body.ZIndex = 105

    local list = make("UIListLayout", body)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0,9)

    local pad = make("UIPadding", body)
    pad.PaddingTop = UDim.new(0,2)
    pad.PaddingBottom = UDim.new(0,12)
    pad.PaddingLeft = UDim.new(0,2)
    pad.PaddingRight = UDim.new(0,2)

    local drag = false
    local ds, sp
    h.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = i.Position; sp = w.Position
        end
    end)
    h.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not drag or not ds or not sp then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = i.Position - ds
        w.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end)

    w:SetAttribute("TitleKey", tk)
    table.insert(Windows, {Frame=w, Title=title, TitleKey=tk, BasePosition=w.Position})
    return w, body
end

----------------------------------------------------------------
-- BUILD UI
----------------------------------------------------------------
local WC, CB = CreateWindow("Combat", -477)
local WV, VB = CreateWindow("Visuals", -159)
local WP, PB = CreateWindow("Player", 159)
local WM, MB = CreateWindow("Misc", 477)

-- Combat
AddToggle(CB, "Aimbot", "Aimbot", nil, function(c)
    AddSlider(c, "Smoothness", "Aimbot_Smooth", 1, 10, 1)
    AddSlider(c, "FOVRadius", "Aimbot_FOV", 50, 500, 10)
    AddToggle(c, "ShowFOV", "Show_FOV")
end)
AddToggle(CB, "Ragebot", "Ragebot")
AddToggle(CB, "Triggerbot", "Triggerbot")
AddToggle(CB, "AntiAim", "Anti_Aim")

-- Visuals
AddToggle(VB, "ESPMaster", "ESP_Master")
AddToggle(VB, "BoxESP", "Box_ESP")
AddToggle(VB, "HealthBar", "Health_Bar")
AddToggle(VB, "PlayerInfo", "Info_Display")
AddToggle(VB, "TeamFilter", "Team_Filter")
AddToggle(VB, "Chams", "Chams_Enabled")

-- Player
AddToggle(PB, "InfJump", "Infinite_Jump")
AddToggle(PB, "FlyMode", "Fly_Mode", nil, function(c)
    AddSlider(c, "FlySpeed", "Fly_Speed", 10, 200, 5)
end)
AddToggle(PB, "Noclip", "Noclip")
AddToggle(PB, "SpeedHack", "Speed_Hack", nil, function(c)
    AddSlider(c, "SpeedVal", "Speed_Val", 16, 150, 5)
end)
AddToggle(PB, "Forced3P", "Third_Person")

-- Misc
AddToggle(MB, "SkyChanger", "Skybox_Mode", function(s)
    if s then
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        sky.Parent = Lighting
        local a = "rbxassetid://"..tostring(Config.Custom_Sky_Id)
        sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = a,a,a,a,a,a
    else
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if sky then sky:Destroy() end
    end
end, function(c) AddTextBox(c, "SkyID", "Custom_Sky_Id") end)
AddToggle(MB, "DeathAudio", "Death_Audio", nil, function(c)
    AddTextBox(c, "SoundID", "Death_Audio_Id")
end)
AddToggle(MB, "Cursor", "Interactive_Cursor")
AddToggle(MB, "FPSOpt", "FPS_Opt")
AddToggle(MB, "Spoof", "Device_Spoof")

----------------------------------------------------------------
-- LANGUAGE BAR
----------------------------------------------------------------
local LB = make("Frame", Root)
LB.Name = "LanguageBar"
LB.AnchorPoint = Vector2.new(.5,0)
LB.Position = UDim2.new(.5,0,0,18)
LB.Size = UDim2.fromOffset(220,48)
LB.BackgroundColor3 = T.Panel2
LB.BorderSizePixel = 0
LB.ZIndex = 1000
cr(LB,12); st(LB,T.Border,1.2,.05)

local LL = make("TextLabel", LB)
LL.Position = UDim2.fromOffset(12,0)
LL.Size = UDim2.fromOffset(60,48)
LL.BackgroundTransparency = 1
LL.Text = Tr("Language")
LL.TextColor3 = T.TextS
LL.TextSize = 10
LL.Font = Enum.Font.GothamMedium
LL.TextXAlignment = Enum.TextXAlignment.Left
LL.ZIndex = 1001

local ENB = make("TextButton", LB)
ENB.Position = UDim2.fromOffset(86,10)
ENB.Size = UDim2.fromOffset(56,28)
ENB.BackgroundColor3 = T.Accent
ENB.BorderSizePixel = 0
ENB.Text = "EN"
ENB.TextColor3 = T.Text
ENB.TextSize = 10
ENB.Font = Enum.Font.GothamBold
ENB.AutoButtonColor = false
ENB.ZIndex = 1001
cr(ENB,8)

local KOB = make("TextButton", LB)
KOB.Position = UDim2.fromOffset(150,10)
KOB.Size = UDim2.fromOffset(56,28)
KOB.BackgroundColor3 = T.Off
KOB.BorderSizePixel = 0
KOB.Text = "KO"
KOB.TextColor3 = T.TextS
KOB.TextSize = 10
KOB.Font = Enum.Font.GothamBold
KOB.AutoButtonColor = false
KOB.ZIndex = 1001
cr(KOB,8)

local function RefreshUI()
    for _,v in ipairs(UIE) do if v.Type=="Toggle" and v.Button and v.Button.Parent then v.Button.Text = "  "..Tr(v.NameKey) end end
    for _,v in ipairs(Windows) do if v.Title and v.Title.Parent then v.Title.Text = Tr(v.TitleKey) end end
    LL.Text = Tr("Language")
    if KL then KL.Text = Tr("Keybind") end
    if MBtn then MBtn.Text = Tr("MobileToggle") end
    if BM and KBtn then KBtn.Text = Tr("PressToBind") end
end

ENB.MouseButton1Click:Connect(function()
    Config.Language = "EN"
    ENB.BackgroundColor3 = T.Accent; ENB.TextColor3 = T.Text
    KOB.BackgroundColor3 = T.Off; KOB.TextColor3 = T.TextS
    RefreshUI()
end)
KOB.MouseButton1Click:Connect(function()
    Config.Language = "KO"
    KOB.BackgroundColor3 = T.Accent; KOB.TextColor3 = T.Text
    ENB.BackgroundColor3 = T.Off; ENB.TextColor3 = T.TextS
    RefreshUI()
end)

----------------------------------------------------------------
-- MENU TOGGLE
----------------------------------------------------------------
local MenuVisible = true
local function ToggleMenu()
    MenuVisible = not MenuVisible
    for _,v in ipairs(Windows) do v.Frame.Visible = MenuVisible end
    Dimmer.Visible = MenuVisible
    LB.Visible = MenuVisible
    if not MenuVisible then ClosePopup() end
end

----------------------------------------------------------------
-- MOBILE / PC
----------------------------------------------------------------
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local MBtn, KP, KL, KBtn, BM = false

if IsMobile then
    MBtn = make("TextButton", Root)
    MBtn.AnchorPoint = Vector2.new(0,.5)
    MBtn.Position = UDim2.new(0,14,.5,0)
    MBtn.Size = UDim2.fromOffset(50,50)
    MBtn.BackgroundColor3 = T.Accent
    MBtn.BorderSizePixel = 0
    MBtn.Text = Tr("MobileToggle")
    MBtn.TextColor3 = T.Text
    MBtn.TextSize = 12
    MBtn.Font = Enum.Font.GothamBold
    MBtn.AutoButtonColor = false
    MBtn.ZIndex = 3000
    cr(MBtn,14); st(MBtn,T.AccentB,1.3,0)
    MBtn.MouseButton1Click:Connect(ToggleMenu)
else
    KP = make("Frame", Root)
    KP.AnchorPoint = Vector2.new(0,1)
    KP.Position = UDim2.new(0,16,1,-16)
    KP.Size = UDim2.fromOffset(190,64)
    KP.BackgroundColor3 = T.Panel2
    KP.BorderSizePixel = 0
    KP.ZIndex = 3000
    cr(KP,12); st(KP,T.Border,1.2,.05)

    KL = make("TextLabel", KP)
    KL.Position = UDim2.fromOffset(10,7)
    KL.Size = UDim2.new(1,-20,0,14)
    KL.BackgroundTransparency = 1
    KL.Text = Tr("Keybind")
    KL.TextColor3 = T.TextS
    KL.TextSize = 9
    KL.Font = Enum.Font.Gotham
    KL.TextXAlignment = Enum.TextXAlignment.Left
    KL.ZIndex = 3001

    KBtn = make("TextButton", KP)
    KBtn.Position = UDim2.fromOffset(10,28)
    KBtn.Size = UDim2.new(1,-20,0,24)
    KBtn.BackgroundColor3 = T.Off
    KBtn.BorderSizePixel = 0
    KBtn.Text = Config.MenuKey.Name
    KBtn.TextColor3 = T.Text
    KBtn.TextSize = 10
    KBtn.Font = Enum.Font.GothamBold
    KBtn.AutoButtonColor = false
    KBtn.ZIndex = 3001
    cr(KBtn,7); st(KBtn,T.Border,1,0)

    KBtn.MouseButton1Click:Connect(function()
        BM = true
        KBtn.Text = Tr("PressToBind")
    end)
end

----------------------------------------------------------------
-- RIGHT SHIFT SINK
----------------------------------------------------------------
pcall(function() ContextActionService:UnbindAction("CubicUltimateHub_RightShift") end)
ContextActionService:BindActionAtPriority("CubicUltimateHub_RightShift", function(_, state)
    if state == Enum.UserInputState.Begin then
        if Config.MenuKey == Enum.KeyCode.RightShift and not BM then ToggleMenu() end
    end
    return Enum.ContextActionResult.Sink
end, false, 5000, Enum.KeyCode.RightShift)

----------------------------------------------------------------
-- KEYBOARD INPUT
----------------------------------------------------------------
UserInputService.InputBegan:Connect(function(i, p)
    if BM and i.UserInputType == Enum.UserInputType.Keyboard then
        if i.KeyCode ~= Enum.KeyCode.Unknown then
            Config.MenuKey = i.KeyCode; BM = false
            if KBtn then KBtn.Text = Config.MenuKey.Name end
        end
        return
    end
    if p then return end
    if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == Config.MenuKey then
        if Config.MenuKey ~= Enum.KeyCode.RightShift then ToggleMenu() end
    end
end)

----------------------------------------------------------------
-- INITIAL STATE
----------------------------------------------------------------
Config.Language = "EN"
ENB.BackgroundColor3 = T.Accent
KOB.BackgroundColor3 = T.Off
for _,v in ipairs(Windows) do v.Frame.Visible = true end
Dimmer.Visible = true
LB.Visible = true

task.spawn(function()
    while SG.Parent do
        updScl()
        if MBtn then MBtn.Position = UDim2.new(0,14,.5,0) end
        if KP then KP.Position = UDim2.new(0,16,1,-16) end
        task.wait(.35)
    end
end)

print("[Cubic UI] 최적화 버전 로드 완료!")
