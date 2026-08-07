loadstring(game:HttpGet("https://raw.githubusercontent.com/cjwstar25-png/WJNof9r29jk1oi23134/refs/heads/main/Bypass.lua"))()

pcall(function()
    if hookmetamethod then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Kick" or method == "kick" or method == "Teleport" or method == "TeleportToService" or method == "SaveInstance") then
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

pcall(function()
    if hookmetamethod then
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, k)
            if not checkcaller() and (k == "WalkSpeed" or k == "JumpPower" or k == "Health") then
                return 16 
            end
            return oldIndex(self, k)
        end)
    end
end)

pcall(function()
    for _, v in ipairs({"DevConsoleSecurity", "RobloxReplicatedStorage", "ClientAnticheat", "BanService", "AntiExploit"}) do
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            if coreGui:FindFirstChild(v) then
                coreGui[v]:Destroy()
            end
        end)
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
    ESP_Master = true,
    Skeleton_ESP = true,
    Box_ESP = true,       
    Health_Bar = true,    
    Tracer_Lines = true,
    Info_Display = true,
    Team_Filter = false,
    
    Aimbot = false,
    Aimbot_Smooth = 2,
    Silent_Aim = false,
    Hitbox = "Head",
    
    Ragebot = false,
    Wall_Check = false,
    Triggerbot = false,
    
    FOV_Radius = 300,
    Infinite_Jump = false,
    
    Fly_Mode = false,
    Fly_Speed = 80,
    Noclip = false,
    Speed_Hack = false,
    Speed_Val = 40,
    Fullbright = false,
    Bunny_Hop = false,
    
    Menu_Key = Enum.KeyCode.RightShift
}

pcall(function()
    local oldGui = game:GetService("CoreGui"):FindFirstChild("UltimateTabbedHubV10")
    if oldGui then oldGui:Destroy() end
    local oldGuiPlayer = LocalPlayer.PlayerGui:FindFirstChild("UltimateTabbedHubV10")
    if oldGuiPlayer then oldGuiPlayer:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateTabbedHubV10"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
end)

if not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end

local FOVCircle = nil
pcall(function()
    if Drawing then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Visible = false
        FOVCircle.Thickness = 1.5
        FOVCircle.NumSides = 64
        FOVCircle.Radius = Config.FOV_Radius
        FOVCircle.Color = Color3.fromRGB(80, 160, 255)
        FOVCircle.Transparency = 0.7
        FOVCircle.Filled = false
    end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 480)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BackgroundTransparency = 0.04
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 140, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleCover = Instance.new("Frame")
TitleCover.Size = UDim2.new(1, 0, 0, 12)
TitleCover.Position = UDim2.new(0, 0, 1, -12)
TitleCover.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TitleCover.BorderSizePixel = 0
TitleCover.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Position = UDim2.new(0, 16, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Ultimate Tabbed Hub v10.2 [Safe Hook]"
TitleText.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -42, 0.5, -16)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, 36)
TabBar.Position = UDim2.new(0, 12, 0, 56)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.Parent = TabBar

local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -24, 1, -108)
ContainerFrame.Position = UDim2.new(0, 12, 0, 100)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

local Tabs = {}
local CurrentActiveTab = nil

local function CreateTab(name, layoutOrder)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 110, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.AutoButtonColor = false
    tabBtn.LayoutOrder = layoutOrder
    tabBtn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabBtn

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 1000)
    tabContent.ScrollBarThickness = 5
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 140, 255)
    tabContent.Visible = false
    tabContent.Parent = ContainerFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 30), TextColor3 = Color3.fromRGB(150, 150, 170)}):Play()
        end
        tabContent.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 100, 200), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        CurrentActiveTab = tabContent
    end)

    Tabs[name] = {Button = tabBtn, Content = tabContent}
    return tabContent
end

local CombatTab = CreateTab("Combat", 1)
local VisualTab = CreateTab("Visuals", 2)
local PlayerTab = CreateTab("Player", 3)
local MiscTab = CreateTab("Misc", 4)

Tabs["Combat"].Button.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
Tabs["Combat"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs["Combat"].Content.Visible = true
CurrentActiveTab = Tabs["Combat"].Content

local function CreateToggleInTab(parentTab, name, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = default and Color3.fromRGB(24, 80, 160) or Color3.fromRGB(20, 20, 28)
    btn.Text = "    " .. name
    btn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = parentTab

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = default and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(40, 40, 55)
    stroke.Transparency = 0.4
    stroke.Parent = btn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 100, 1, 0)
    statusLabel.Position = UDim2.new(1, -110, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = default and "ACTIVE" or "DISABLED"
    statusLabel.TextColor3 = default and Color3.fromRGB(150, 220, 255) or Color3.fromRGB(100, 100, 120)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.Parent = btn

    local state = default
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    btn.MouseButton1Click:Connect(function()
        state = not state
        statusLabel.Text = state and "ACTIVE" or "DISABLED"
        
        local targetColor = state and Color3.fromRGB(24, 80, 160) or Color3.fromRGB(20, 20, 28)
        local targetTextColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
        local targetStatusColor = state and Color3.fromRGB(150, 220, 255) or Color3.fromRGB(100, 100, 120)
        local targetStrokeColor = state and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(40, 40, 55)

        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(btn, tweenInfo, {TextColor3 = targetTextColor}):Play()
        TweenService:Create(statusLabel, tweenInfo, {TextColor3 = targetStatusColor}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = targetStrokeColor}):Play()

        callback(state)
    end)
end

CreateToggleInTab(CombatTab, "Aimbot (Auto Lock & FOV)", Config.Aimbot, function(v) Config.Aimbot = v end)
CreateToggleInTab(CombatTab, "Silent Aim (Bullet Curve)", Config.Silent_Aim, function(v) Config.Silent_Aim = v end)
CreateToggleInTab(CombatTab, "Ragebot (Teleport + Glitch Jitter)", Config.Ragebot, function(v) Config.Ragebot = v end)
CreateToggleInTab(CombatTab, "Wall Check", Config.Wall_Check, function(v) Config.Wall_Check = v end)
CreateToggleInTab(CombatTab, "Triggerbot", Config.Triggerbot, function(v) Config.Triggerbot = v end)

CreateToggleInTab(VisualTab, "ESP Master", Config.ESP_Master, function(v) Config.ESP_Master = v end)
CreateToggleInTab(VisualTab, "Skeleton ESP", Config.Skeleton_ESP, function(v) Config.Skeleton_ESP = v end)
CreateToggleInTab(VisualTab, "Box ESP (2D)", Config.Box_ESP, function(v) Config.Box_ESP = v end)
CreateToggleInTab(VisualTab, "Health Bar ESP", Config.Health_Bar, function(v) Config.Health_Bar = v end)
CreateToggleInTab(VisualTab, "Player Info & Distance", Config.Info_Display, function(v) Config.Info_Display = v end)
CreateToggleInTab(VisualTab, "Tracer Lines", Config.Tracer_Lines, function(v) Config.Tracer_Lines = v end)
CreateToggleInTab(VisualTab, "Team Filter", Config.Team_Filter, function(v) Config.Team_Filter = v end)

CreateToggleInTab(PlayerTab, "Infinite Jump", Config.Infinite_Jump, function(v) Config.Infinite_Jump = v end)
CreateToggleInTab(PlayerTab, "Fly Mode (Toggle Q)", Config.Fly_Mode, function(v) Config.Fly_Mode = v end)
CreateToggleInTab(PlayerTab, "Noclip", Config.Noclip, function(v) Config.Noclip = v end)
CreateToggleInTab(PlayerTab, "Speed Hack", Config.Speed_Hack, function(v) Config.Speed_Hack = v end)

CreateToggleInTab(MiscTab, "Fullbright", Config.Fullbright, function(v) Config.Fullbright = v end)
CreateToggleInTab(MiscTab, "Bunny Hop", Config.Bunny_Hop, function(v) Config.Bunny_Hop = v end)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContainerFrame.Visible = not isMinimized
    TabBar.Visible = not isMinimized
    MinimizeBtn.Text = isMinimized and "+" or "-"
    local targetSize = isMinimized and UDim2.new(0, 620, 0, 48) or UDim2.new(0, 620, 0, 480)
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)

local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X, 
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Config.Menu_Key then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Infinite_Jump then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)

local ESPConnections = {}

local function GetPlayerColor(player)
    if Config.Team_Filter and player.Team == LocalPlayer.Team then
        return Color3.fromRGB(40, 240, 100)
    else
        return Color3.fromRGB(255, 60, 60)
    end
end

local function IsVisible(targetPart, character)
    if not Config.Wall_Check then return true end
    local cam = Workspace.CurrentCamera
    if not cam then return true end
    local origin = cam.CFrame.Position
    local direction = targetPart.Position - origin
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
    rayParams.IgnoreWater = true
    local result = Workspace:Raycast(origin, direction, rayParams)
    return result == nil
end

local SkeletonJoints = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local function IsPlayerValid(player)
    if player == LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid or humanoid.Health <= 0 then return false end
    return true
end

local function CreateESP(player)
    if player == LocalPlayer then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "SecureHighlight"
    highlight.FillTransparency = 0.90
    highlight.OutlineTransparency = 0.1
    highlight.Parent = ScreenGui

    local tracerLine, infoText, boxLine, healthBarLine, healthBarBg = nil, nil, nil, nil, nil
    pcall(function()
        if Drawing then
            tracerLine = Drawing.new("Line")
            tracerLine.Visible = false
            tracerLine.Thickness = 1.2
            tracerLine.Transparency = 0.8

            infoText = Drawing.new("Text")
            infoText.Visible = false
            infoText.Size = 12
            infoText.Center = true
            infoText.Outline = true
            infoText.Color = Color3.fromRGB(255, 255, 255)

            boxLine = Drawing.new("Square")
            boxLine.Visible = false
            boxLine.Thickness = 1.2
            boxLine.Transparency = 0.8
            boxLine.Filled = false

            healthBarBg = Drawing.new("Line")
            healthBarBg.Visible = false
            healthBarBg.Thickness = 3
            healthBarBg.Transparency = 0.7
            healthBarBg.Color = Color3.fromRGB(20, 20, 20)

            healthBarLine = Drawing.new("Line")
            healthBarLine.Visible = false
            healthBarLine.Thickness = 1.5
            healthBarLine.Transparency = 0.9
            healthBarLine.Color = Color3.fromRGB(0, 255, 100)
        end
    end)

    local skeletonLines = {}
    pcall(function()
        if Drawing then
            for _, _ in ipairs(SkeletonJoints) do
                local line = Drawing.new("Line")
                line.Visible = false
                line.Thickness = 1
                line.Transparency = 0.8
                table.insert(skeletonLines, line)
            end
        end
    end)

    local connection
    connection = RunService.RenderStepped:Connect(function()
        pcall(function()
            local cam = Workspace.CurrentCamera
            if not cam or not Config.ESP_Master or not IsPlayerValid(player) then
                highlight.Adornee = nil
                if tracerLine then tracerLine.Visible = false end
                if infoText then infoText.Visible = false end
                if boxLine then boxLine.Visible = false end
                if healthBarBg then healthBarBg.Visible = false end
                if healthBarLine then healthBarLine.Visible = false end
                for _, l in ipairs(skeletonLines) do l.Visible = false end
                return
            end

            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            local color = GetPlayerColor(player)
            highlight.Adornee = char
            highlight.OutlineColor = color

            local vector, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                if tracerLine and Config.Tracer_Lines then
                    tracerLine.Visible = true
                    tracerLine.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                    tracerLine.To = Vector2.new(vector.X, vector.Y)
                    tracerLine.Color = color
                elseif tracerLine then
                    tracerLine.Visible = false
                end

                if Config.Box_ESP and boxLine then
                    local size = char:GetExtentsSize()
                    local topVec = cam:WorldToViewportPoint((hrp.CFrame + Vector3.new(0, size.Y/2, 0)).Position)
                    local botVec = cam:WorldToViewportPoint((hrp.CFrame - Vector3.new(0, size.Y/2, 0)).Position)
                    local boxHeight = math.abs(topVec.Y - botVec.Y)
                    local boxWidth = boxHeight / 2
                    
                    boxLine.Visible = true
                    boxLine.Size = Vector2.new(boxWidth, boxHeight)
                    boxLine.Position = Vector2.new(topVec.X - boxWidth/2, topVec.Y)
                    boxLine.Color = color

                    if Config.Health_Bar and healthBarLine and healthBarBg then
                        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local barHeight = boxHeight * healthPercent
                        
                        healthBarBg.Visible = true
                        healthBarBg.From = Vector2.new(topVec.X - boxWidth/2 - 6, topVec.Y + boxHeight)
                        healthBarBg.To = Vector2.new(topVec.X - boxWidth/2 - 6, topVec.Y)

                        healthBarLine.Visible = true
                        healthBarLine.From = Vector2.new(topVec.X - boxWidth/2 - 6, topVec.Y + boxHeight)
                        healthBarLine.To = Vector2.new(topVec.X - boxWidth/2 - 6, (topVec.Y + boxHeight) - barHeight)
                        healthBarLine.Color = Color3.fromRGB(0, 255, 100)
                    else
                        if healthBarBg then healthBarBg.Visible = false end
                        if healthBarLine then healthBarLine.Visible = false end
                    end
                else
                    if boxLine then boxLine.Visible = false end
                    if healthBarBg then healthBarBg.Visible = false end
                    if healthBarLine then healthBarLine.Visible = false end
                end

                if Config.Info_Display and char:FindFirstChild("Head") and infoText then
                    local headVec = cam:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 1.2, 0))
                    local dist = math.floor((hrp.Position - cam.CFrame.Position).Magnitude)
                    infoText.Visible = true
                    infoText.Text = string.format("%s [%dHP] (%dm)", player.Name, math.floor(humanoid.Health), dist)
                    infoText.Position = Vector2.new(headVec.X, headVec.Y)
                    infoText.Color = color
                elseif infoText then
                    infoText.Visible = false
                end

                if Config.Skeleton_ESP and char:FindFirstChild("UpperTorso") then
                    for i, pair in ipairs(SkeletonJoints) do
                        local p1 = char:FindFirstChild(pair[1])
                        local p2 = char:FindFirstChild(pair[2])
                        local line = skeletonLines[i]
                        
                        if p1 and p2 and line then
                            local v1, s1 = cam:WorldToViewportPoint(p1.Position)
                            local v2, s2 = cam:WorldToViewportPoint(p2.Position)
                            if s1 and s2 then
                                line.Visible = true
                                line.From = Vector2.new(v1.X, v1.Y)
                                line.To = Vector2.new(v2.X, v2.Y)
                                line.Color = color
                            else
                                line.Visible = false
                            end
                        else
                            if line then line.Visible = false end
                        end
                    end
                else
                    for _, l in ipairs(skeletonLines) do l.Visible = false end
                end
            else
                if tracerLine then tracerLine.Visible = false end
                if infoText then infoText.Visible = false end
                if boxLine then boxLine.Visible = false end
                if healthBarBg then healthBarBg.Visible = false end
                if healthBarLine then healthBarLine.Visible = false end
                for _, l in ipairs(skeletonLines) do l.Visible = false end
            end
        end)
    end)

    ESPConnections[player] = {
        Highlight = highlight, Tracer = tracerLine, InfoText = infoText, Box = boxLine, BarBg = healthBarBg, BarLine = healthBarLine, Skeleton = skeletonLines, Connection = connection
    }
end

local function RemoveESP(player)
    if ESPConnections[player] then
        pcall(function()
            if ESPConnections[player].Highlight then ESPConnections[player].Highlight:Destroy() end
            if ESPConnections[player].Tracer then ESPConnections[player].Tracer:Remove() end
            if ESPConnections[player].InfoText then ESPConnections[player].InfoText:Remove() end
            if ESPConnections[player].Box then ESPConnections[player].Box:Remove() end
            if ESPConnections[player].BarBg then ESPConnections[player].BarBg:Remove() end
            if ESPConnections[player].BarLine then ESPConnections[player].BarLine:Remove() end
            if ESPConnections[player].Skeleton then
                for _, l in ipairs(ESPConnections[player].Skeleton) do l:Remove() end
            end
            if ESPConnections[player].Connection then ESPConnections[player].Connection:Disconnect() end
        end)
        ESPConnections[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

local function GetClosestTargetForAimbot()
    local target = nil
    local shortestDist = Config.FOV_Radius
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local cam = Workspace.CurrentCamera
    if not cam then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        pcall(function()
            if IsPlayerValid(p) then
                local part = p.Character:FindFirstChild(Config.Hitbox) or p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    if not Config.Team_Filter or p.Team ~= LocalPlayer.Team then
                        local vec, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local screenDist = (mousePos - Vector2.new(vec.X, vec.Y)).Magnitude
                            if screenDist < shortestDist then
                                if IsVisible(part, p.Character) then
                                    shortestDist = screenDist
                                    target = p
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    return target
end

local function GetClosestTargetForSilentAim()
    local target = nil
    local shortestDist = Config.FOV_Radius
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local cam = Workspace.CurrentCamera
    if not cam then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        pcall(function()
            if IsPlayerValid(p) then
                local part = p.Character:FindFirstChild(Config.Hitbox) or p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    if not Config.Team_Filter or p.Team ~= LocalPlayer.Team then
                        local vec, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local screenDist = (mousePos - Vector2.new(vec.X, vec.Y)).Magnitude
                            if screenDist < shortestDist then
                                if IsVisible(part, p.Character) then
                                    shortestDist = screenDist
                                    target = part
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    return target
end

local function GetClosestTargetForRagebot()
    local target = nil
    local shortestDist = math.huge
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        pcall(function()
            if IsPlayerValid(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not Config.Team_Filter or p.Team ~= LocalPlayer.Team then
                        if not Config.Wall_Check or IsVisible(hrp, p.Character) then
                            local dist = (myRoot.Position - hrp.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                target = p
                            end
                        end
                    end
                end
            end
        end)
    end
    return target
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then
        Config.Fly_Mode = not Config.Fly_Mode
    end
end)

pcall(function()
    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if Config.Silent_Aim and not checkcaller() then
                if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast" then
                    local targetPart = GetClosestTargetForSilentAim()
                    if targetPart and Workspace.CurrentCamera then
                        local origin = args[1]
                        if typeof(origin) == "Ray" then
                            origin = origin.Origin
                        end
                        if typeof(origin) == "Vector3" then
                            local newDir = (targetPart.Position - origin).Unit * 1000
                            if method == "Raycast" then
                                args[2] = newDir
                            else
                                args[1] = Ray.new(origin, newDir)
                            end
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local cam = Workspace.CurrentCamera
        if not cam then return end

        if FOVCircle then
            if Config.Aimbot or Config.Silent_Aim then
                FOVCircle.Visible = true
                FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
                FOVCircle.Radius = Config.FOV_Radius
            else
                FOVCircle.Visible = false
            end
        end

        if Config.Aimbot then
            local target = GetClosestTargetForAimbot()
            if target and target.Character then
                local part = target.Character:FindFirstChild(Config.Hitbox) or target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local targetCF = CFrame.new(cam.CFrame.Position, part.Position)
                    cam.CFrame = cam.CFrame:Lerp(targetCF, 1 / Config.Aimbot_Smooth)
                end
            end
        end

        if Config.Triggerbot and not Config.Ragebot then
            local target = GetClosestTargetForAimbot()
            if target and target.Character then
                local part = target.Character:FindFirstChild(Config.Hitbox) or target.Character:FindFirstChild("Head")
                if part then
                    local vec, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                        if (mousePos - Vector2.new(vec.X, vec.Y)).Magnitude < 35 then
                            pcall(function() mouse1click() end)
                        end
                    end
                end
            end
        end

        if Config.Ragebot then
            local target = GetClosestTargetForRagebot()
            local char = LocalPlayer.Character
            if target and target.Character and char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetHrp then
                    local jitterX = math.random(-30, 30) / 10
                    local jitterY = math.random(-20, 20) / 10
                    local jitterZ = math.random(-30, 30) / 10
                    
                    hrp.CFrame = targetHrp.CFrame + Vector3.new(jitterX, 10 + jitterY, jitterZ)
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    if Config.Triggerbot then
                        pcall(function() mouse1click() end)
                    end
                end
            end
        end

        if Config.Fullbright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 12
            Lighting.FogEnd = 999999
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end

        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid then
                if Config.Speed_Hack then humanoid.WalkSpeed = Config.Speed_Val else humanoid.WalkSpeed = 16 end
                
                if Config.Bunny_Hop and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end

            if Config.Noclip then
                pcall(function()
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
            end

            if Config.Fly_Mode then
                if hrp and not hrp:FindFirstChild("SecureFlyVel") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "SecureFlyVel"
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = hrp
                    local bg = Instance.new("BodyGyro")
                    bg.Name = "SecureFlyGyro"
                    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    bg.CFrame = hrp.CFrame
                    bg.Parent = hrp
                elseif hrp then
                    local bv = hrp:FindFirstChild("SecureFlyVel")
                    local bg = hrp:FindFirstChild("SecureFlyGyro")
                    if bv and bg then
                        local camCF = cam.CFrame
                        local moveDir = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                        bv.Velocity = moveDir * Config.Fly_Speed
                        bg.CFrame = camCF
                    end
                    if humanoid then humanoid.PlatformStand = true end
                end
            else
                if hrp then
                    if hrp:FindFirstChild("SecureFlyVel") then hrp.SecureFlyVel:Destroy() end
                    if hrp:FindFirstChild("SecureFlyGyro") then hrp.SecureFlyGyro:Destroy() end
                end
                if humanoid then humanoid.PlatformStand = false end
            end
        end
    end)
end)
