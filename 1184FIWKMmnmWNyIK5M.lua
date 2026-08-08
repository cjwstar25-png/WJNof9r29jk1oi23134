loadstring(game:HttpGet("https://raw.githubusercontent.com/cjwstar25-png/WJNof9r29jk1oi23134/refs/heads/main/Bypass.lua"))()

pcall(function()
    if hookmetamethod then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Kick" or method == "kick" or method == "Teleport" or method == "Ban") then
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

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
    Chams_Enabled = false,
    
    Aimbot = false,
    Aimbot_Smooth = 2,
    Hitbox = "Head",
    
    Ragebot = false,
    Wall_Check = false,
    Triggerbot = false,
    
    FOV_Radius = 350,
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
    local oldGui = CoreGui:FindFirstChild("CubicIndependentHub")
    if oldGui then oldGui:Destroy() end
    local oldGuiPlayer = LocalPlayer.PlayerGui:FindFirstChild("CubicIndependentHub")
    if oldGuiPlayer then oldGuiPlayer:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CubicIndependentHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local DimBackground = Instance.new("Frame")
DimBackground.Name = "DimBackground"
DimBackground.Size = UDim2.new(1, 0, 1, 0)
DimBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DimBackground.BackgroundTransparency = 1
DimBackground.BorderSizePixel = 0
DimBackground.ZIndex = 0
DimBackground.Parent = ScreenGui

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

local WindowsList = {}
local isMenuVisible = true

-- UI 크기를 훨씬 더 키우고, 최소화 버튼을 완전히 제거
local function CreateIndependentWindow(titleText, defaultPos, layoutOrder)
    local columnFrame = Instance.new("ScrollingFrame")
    columnFrame.Name = titleText .. "Window"
    columnFrame.Size = UDim2.new(0, 260, 0, 560) -- 창 크기 대폭 확장
    columnFrame.Position = defaultPos
    columnFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 25)
    columnFrame.BackgroundTransparency = 0.1
    columnFrame.BorderSizePixel = 0
    columnFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    columnFrame.ScrollBarThickness = 4
    columnFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 110, 200)
    columnFrame.ZIndex = 2
    columnFrame.Parent = ScreenGui

    local colCorner = Instance.new("UICorner")
    colCorner.CornerRadius = UDim.new(0, 8)
    colCorner.Parent = columnFrame

    local colStroke = Instance.new("UIStroke")
    colStroke.Color = Color3.fromRGB(40, 80, 150)
    colStroke.Thickness = 1.5
    colStroke.Transparency = 0.2
    colStroke.Parent = columnFrame

    local colTitle = Instance.new("Frame")
    colTitle.Size = UDim2.new(1, 0, 0, 42)
    colTitle.BackgroundColor3 = Color3.fromRGB(18, 24, 38)
    colTitle.BorderSizePixel = 0
    colTitle.ZIndex = 3
    colTitle.Parent = columnFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = colTitle

    local titleCover = Instance.new("Frame")
    titleCover.Size = UDim2.new(1, 0, 0, 8)
    titleCover.Position = UDim2.new(0, 0, 1, -8)
    titleCover.BackgroundColor3 = Color3.fromRGB(18, 24, 38)
    titleCover.BorderSizePixel = 0
    titleCover.ZIndex = 3
    titleCover.Parent = colTitle

    local titleTextLabel = Instance.new("TextLabel")
    titleTextLabel.Size = UDim2.new(1, -20, 1, 0)
    titleTextLabel.Position = UDim2.new(0, 12, 0, 0)
    titleTextLabel.BackgroundTransparency = 1
    titleTextLabel.Text = titleText
    titleTextLabel.TextColor3 = Color3.fromRGB(220, 235, 255)
    titleTextLabel.TextSize = 14
    titleTextLabel.Font = Enum.Font.GothamBold
    titleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleTextLabel.ZIndex = 4
    titleTextLabel.Parent = colTitle

    local innerList = Instance.new("UIListLayout")
    innerList.SortOrder = Enum.SortOrder.LayoutOrder
    innerList.Padding = UDim.new(0, 8)
    innerList.Parent = columnFrame

    local innerPad = Instance.new("UIPadding")
    innerPad.PaddingTop = UDim.new(0, 52)
    innerPad.PaddingBottom = UDim.new(0, 12)
    innerPad.PaddingLeft = UDim.new(0, 10)
    innerPad.PaddingRight = UDim.new(0, 10)
    innerPad.Parent = columnFrame

    innerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        columnFrame.CanvasSize = UDim2.new(0, 0, 0, innerList.AbsoluteContentSize.Y + 64)
    end)

    local dragging, dragInput, dragStart, startPos
    colTitle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = columnFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    colTitle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            columnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    table.insert(WindowsList, columnFrame)
    return columnFrame
end

-- 4개의 열 간격과 위치를 전체 화면 폭에 맞게 배치
local CombatCol = CreateIndependentWindow("Combat", UDim2.new(0.5, -550, 0.5, -280), 1)
local VisualCol = CreateIndependentWindow("Visuals & ESP", UDim2.new(0.5, -275, 0.5, -280), 2)
local PlayerCol = CreateIndependentWindow("Player", UDim2.new(0.5, 0, 0.5, -280), 3)
local MiscCol = CreateIndependentWindow("Misc", UDim2.new(0.5, 275, 0.5, -280), 4)

-- ON/OFF 토글 버튼 크기와 내부 텍스트 크기 확장
local function CreateToggleInColumn(parentCol, name, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42) -- 버튼 높이와 크기 대폭 키움
    btn.BackgroundColor3 = default and Color3.fromRGB(25, 75, 150) or Color3.fromRGB(18, 24, 38)
    btn.Text = "  " .. name
    btn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 175, 205)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    btn.Parent = parentCol

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = default and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(35, 50, 75)
    stroke.Transparency = 0.4
    stroke.Parent = btn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 55, 1, 0)
    statusLabel.Position = UDim2.new(1, -60, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = default and "ON" or "OFF"
    statusLabel.TextColor3 = default and Color3.fromRGB(150, 220, 255) or Color3.fromRGB(90, 110, 135)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.ZIndex = 3
    statusLabel.Parent = btn

    local state = default
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    btn.MouseButton1Click:Connect(function()
        state = not state
        statusLabel.Text = state and "ON" or "OFF"
        
        local targetColor = state and Color3.fromRGB(25, 75, 150) or Color3.fromRGB(18, 24, 38)
        local targetTextColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 175, 205)
        local targetStatusColor = state and Color3.fromRGB(150, 220, 255) or Color3.fromRGB(90, 110, 135)
        local targetStrokeColor = state and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(35, 50, 75)

        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(btn, tweenInfo, {TextColor3 = targetTextColor}):Play()
        TweenService:Create(statusLabel, tweenInfo, {TextColor3 = targetStatusColor}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = targetStrokeColor}):Play()

        callback(state)
    end)
end

-- 컴포넌트 항목 채우기 (히트박스 기능 제거됨)
CreateToggleInColumn(CombatCol, "Aimbot", Config.Aimbot, function(v) Config.Aimbot = v end)
CreateToggleInColumn(CombatCol, "Ragebot", Config.Ragebot, function(v) Config.Ragebot = v end)
CreateToggleInColumn(CombatCol, "Wall Check", Config.Wall_Check, function(v) Config.Wall_Check = v end)
CreateToggleInColumn(CombatCol, "Triggerbot", Config.Triggerbot, function(v) Config.Triggerbot = v end)

CreateToggleInColumn(VisualCol, "ESP Master", Config.ESP_Master, function(v) Config.ESP_Master = v end)
CreateToggleInColumn(VisualCol, "Skeleton ESP", Config.Skeleton_ESP, function(v) Config.Skeleton_ESP = v end)
CreateToggleInColumn(VisualCol, "Box ESP", Config.Box_ESP, function(v) Config.Box_ESP = v end)
CreateToggleInColumn(VisualCol, "Health Bar", Config.Health_Bar, function(v) Config.Health_Bar = v end)
CreateToggleInColumn(VisualCol, "Player Info", Config.Info_Display, function(v) Config.Info_Display = v end)
CreateToggleInColumn(VisualCol, "Tracer Lines", Config.Tracer_Lines, function(v) Config.Tracer_Lines = v end)
CreateToggleInColumn(VisualCol, "Team Filter", Config.Team_Filter, function(v) Config.Team_Filter = v end)
CreateToggleInColumn(VisualCol, "Chams / Highlight", Config.Chams_Enabled, function(v) Config.Chams_Enabled = v end)

CreateToggleInColumn(PlayerCol, "Infinite Jump", Config.Infinite_Jump, function(v) Config.Infinite_Jump = v end)
CreateToggleInColumn(PlayerCol, "Fly Mode (Q)", Config.Fly_Mode, function(v) Config.Fly_Mode = v end)
CreateToggleInColumn(PlayerCol, "Noclip", Config.Noclip, function(v) Config.Noclip = v end)
CreateToggleInColumn(PlayerCol, "Speed Hack", Config.Speed_Hack, function(v) Config.Speed_Hack = v end)

CreateToggleInColumn(MiscCol, "Fullbright", Config.Fullbright, function(v) Config.Fullbright = v end)
CreateToggleInColumn(MiscCol, "Bunny Hop", Config.Bunny_Hop, function(v) Config.Bunny_Hop = v end)

local function ToggleMenuVisibility()
    isMenuVisible = not isMenuVisible
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if isMenuVisible then
        TweenService:Create(DimBackground, tweenInfo, {BackgroundTransparency = 0.55}):Play()
        for _, win in ipairs(WindowsList) do win.Visible = true end
    else
        TweenService:Create(DimBackground, tweenInfo, {BackgroundTransparency = 1}):Play()
        for _, win in ipairs(WindowsList) do win.Visible = false end
    end
end

TweenService:Create(DimBackground, TweenInfo.new(0.3), {BackgroundTransparency = 0.55}):Play()

ContextActionService:BindAction("BlockShiftLock", function(_, state)
    if state == Enum.UserInputState.Begin then
        ToggleMenuVisibility()
    end
    return Enum.ContextActionResult.Sink
end, false, Config.Menu_Key)

UserInputService.JumpRequest:Connect(function()
    if Config.Infinite_Jump then
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

local ESPConnections = {}

local function GetPlayerColor(player)
    if Config.Team_Filter and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
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
    if not player or player == LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    if not hrp or not humanoid or not head or humanoid.Health <= 0 then return false end
    return true
end

local function CreateESP(player)
    if player == LocalPlayer then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "SecureHighlight"
    highlight.FillTransparency = 0.95
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
            highlight.FillTransparency = Config.Chams_Enabled and 0.5 or 0.95

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

    ESPConnections[player] = {Highlight = highlight, Connection = connection, Skeleton = skeletonLines, Tracer = tracerLine, Info = infoText, Box = boxLine, BarBg = healthBarBg, BarLine = healthBarLine}
end

local function RemoveESP(player)
    if ESPConnections[player] then
        pcall(function()
            if ESPConnections[player].Highlight then ESPConnections[player].Highlight:Destroy() end
            if ESPConnections[player].Connection then ESPConnections[player].Connection:Disconnect() end
            if ESPConnections[player].Tracer then ESPConnections[player].Tracer:Remove() end
            if ESPConnections[player].Info then ESPConnections[player].Info:Remove() end
            if ESPConnections[player].Box then ESPConnections[player].Box:Remove() end
            if ESPConnections[player].BarBg then ESPConnections[player].BarBg:Remove() end
            if ESPConnections[player].BarLine then ESPConnections[player].BarLine:Remove() end
            if ESPConnections[player].Skeleton then
                for _, line in ipairs(ESPConnections[player].Skeleton) do
                    line:Remove()
                end
            end
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
                local part = p.Character:FindFirstChild(Config.Hitbox) or p.Character:FindFirstChild("Head")
                if part then
                    if not Config.Team_Filter or p.Team ~= LocalPlayer.Team then
                        local vec, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local screenDist = (mousePos - Vector2.new(vec.X, vec.Y)).Magnitude
                            if screenDist < shortestDist and IsVisible(part, p.Character) then
                                shortestDist = screenDist
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
    if not gp and input.KeyCode == Enum.KeyCode.Q then
        Config.Fly_Mode = not Config.Fly_Mode
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local cam = Workspace.CurrentCamera
        if not cam then return end

        if FOVCircle then
            if Config.Aimbot and isMenuVisible then
                FOVCircle.Visible = true
                FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 42)
                FOVCircle.Radius = Config.FOV_Radius
            else
                FOVCircle.Visible = false
            end
        end

        if Config.Aimbot then
            local target = GetClosestTargetForAimbot()
            if target and target.Character then
                local part = target.Character:FindFirstChild(Config.Hitbox) or target.Character:FindFirstChild("Head")
                if part then
                    local targetCF = CFrame.new(cam.CFrame.Position, part.Position)
                    cam.CFrame = cam.CFrame:Lerp(targetCF, 1 / Config.Aimbot_Smooth)
                end
            end
        end

        if Config.Ragebot then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local closestPlayer = nil
                local shortestDist = math.huge

                for _, p in ipairs(Players:GetPlayers()) do
                    if IsPlayerValid(p) and (not Config.Team_Filter or p.Team ~= LocalPlayer.Team) then
                        local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if tHrp then
                            local dist = (myRoot.Position - tHrp.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestPlayer = p
                            end
                        end
                    end
                end

                if closestPlayer and closestPlayer.Character then
                    local tHrp = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if tHrp then
                        myRoot.CFrame = tHrp.CFrame + Vector3.new(math.random(-1, 1), 3, math.random(-1, 1))
                        myRoot.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end

        if Config.Triggerbot then
            local target = GetClosestTargetForAimbot()
            if target and target.Character then
                local part = target.Character:FindFirstChild(Config.Hitbox) or target.Character:FindFirstChild("Head")
                if part then
                    local vec, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen and (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(vec.X, vec.Y)).Magnitude < 30 then
                        pcall(function() mouse1click() end)
                    end
                end
            end
        end

        if Config.Fullbright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
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
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            if Config.Fly_Mode then
                if hrp and not hrp:FindFirstChild("SecureFlyVel") then
                    local bv = Instance.new("BodyVelocity", hrp)
                    bv.Name = "SecureFlyVel"
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    local bg = Instance.new("BodyGyro", hrp)
                    bg.Name = "SecureFlyGyro"
                    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
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
