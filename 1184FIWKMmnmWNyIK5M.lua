












































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

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

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
    Ragebot_Speed = 5,
    Wall_Check = false,
    Triggerbot = false,
    Trigger_Delay = 0.05,
    Fling = false,
    Fling_Power = 9e9,
    
    FOV_Radius = 350,
    Infinite_Jump = false,
    
    Fly_Mode = false,
    Fly_Speed = 80,
    Noclip = false,
    Noclip_Mode = "SafeRaycast",
    Speed_Hack = false,
    Speed_Val = 40,
    Fullbright = false,
    Fullbright_Brightness = 3,
    
    Menu_Key = Enum.KeyCode.RightShift
}

pcall(function()
    local oldGui = CoreGui:FindFirstChild("CubicIndependentHubAdvancedPro")
    if oldGui then oldGui:Destroy() end
    local oldGuiPlayer = LocalPlayer.PlayerGui:FindFirstChild("CubicIndependentHubAdvancedPro")
    if oldGuiPlayer then oldGuiPlayer:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CubicIndependentHubAdvancedPro"
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
local activeSubMenuOwner = nil

local SubSettingPopup = Instance.new("Frame")
SubSettingPopup.Name = "SubSettingPopup"
SubSettingPopup.Size = UDim2.new(0, 220, 0, 140)
SubSettingPopup.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
SubSettingPopup.BackgroundTransparency = 0.05
SubSettingPopup.BorderSizePixel = 0
SubSettingPopup.Visible = false
SubSettingPopup.ZIndex = 100
SubSettingPopup.Parent = ScreenGui

local popupCorner = Instance.new("UICorner")
popupCorner.CornerRadius = UDim.new(0, 10)
popupCorner.Parent = SubSettingPopup

local popupStroke = Instance.new("UIStroke")
popupStroke.Color = Color3.fromRGB(70, 140, 240)
popupStroke.Thickness = 1.5
popupStroke.Parent = SubSettingPopup

local popupTitle = Instance.new("TextLabel")
popupTitle.Name = "PopupTitle"
popupTitle.Size = UDim2.new(1, 0, 0, 36)
popupTitle.Position = UDim2.new(0, 12, 0, 0)
popupTitle.BackgroundTransparency = 1
popupTitle.Text = "Settings"
popupTitle.TextColor3 = Color3.fromRGB(240, 245, 255)
popupTitle.TextSize = 14
popupTitle.Font = Enum.Font.GothamBold
popupTitle.TextXAlignment = Enum.TextXAlignment.Left
popupTitle.ZIndex = 101
popupTitle.Parent = SubSettingPopup

local popupContentFrame = Instance.new("Frame")
popupContentFrame.Name = "PopupContent"
popupContentFrame.Size = UDim2.new(1, -20, 1, -44)
popupContentFrame.Position = UDim2.new(0, 10, 0, 40)
popupContentFrame.BackgroundTransparency = 1
popupContentFrame.ZIndex = 101
popupContentFrame.Parent = SubSettingPopup

local function HideSubPopup()
    SubSettingPopup.Visible = false
    activeSubMenuOwner = nil
    for _, child in ipairs(popupContentFrame:GetChildren()) do
        child:Destroy()
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and SubSettingPopup.Visible then
        local mousePos = UserInputService:GetMouseLocation()
        local absPos = SubSettingPopup.AbsolutePosition
        local absSize = SubSettingPopup.AbsoluteSize
        if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
            HideSubPopup()
        end
    end
end)

local function CreateIndependentWindow(titleText, defaultPos)
    local columnFrame = Instance.new("ScrollingFrame")
    columnFrame.Name = titleText .. "Window"
    columnFrame.Size = UDim2.new(0, 310, 0, 620) 
    columnFrame.Position = defaultPos
    columnFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 22)
    columnFrame.BackgroundTransparency = 0.05
    columnFrame.BorderSizePixel = 0
    columnFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    columnFrame.ScrollBarThickness = 5
    columnFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 130, 240)
    columnFrame.ZIndex = 2
    columnFrame.Parent = ScreenGui

    local colCorner = Instance.new("UICorner")
    colCorner.CornerRadius = UDim.new(0, 12)
    colCorner.Parent = columnFrame

    local colStroke = Instance.new("UIStroke")
    colStroke.Color = Color3.fromRGB(50, 100, 180)
    colStroke.Thickness = 1.8
    colStroke.Transparency = 0.15
    colStroke.Parent = columnFrame

    local colTitle = Instance.new("Frame")
    colTitle.Size = UDim2.new(1, 0, 0, 48)
    colTitle.BackgroundColor3 = Color3.fromRGB(16, 22, 35)
    colTitle.BorderSizePixel = 0
    colTitle.ZIndex = 3
    colTitle.Parent = columnFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = colTitle

    local titleCover = Instance.new("Frame")
    titleCover.Size = UDim2.new(1, 0, 0, 10)
    titleCover.Position = UDim2.new(0, 0, 1, -10)
    titleCover.BackgroundColor3 = Color3.fromRGB(16, 22, 35)
    titleCover.BorderSizePixel = 0
    titleCover.ZIndex = 3
    titleCover.Parent = colTitle

    local titleTextLabel = Instance.new("TextLabel")
    titleTextLabel.Size = UDim2.new(1, -24, 1, 0)
    titleTextLabel.Position = UDim2.new(0, 16, 0, 0)
    titleTextLabel.BackgroundTransparency = 1
    titleTextLabel.Text = titleText
    titleTextLabel.TextColor3 = Color3.fromRGB(230, 242, 255)
    titleTextLabel.TextSize = 16
    titleTextLabel.Font = Enum.Font.GothamBold
    titleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleTextLabel.ZIndex = 4
    titleTextLabel.Parent = colTitle

    local innerList = Instance.new("UIListLayout")
    innerList.SortOrder = Enum.SortOrder.LayoutOrder
    innerList.Padding = UDim.new(0, 10)
    innerList.Parent = columnFrame

    local innerPad = Instance.new("UIPadding")
    innerPad.PaddingTop = UDim.new(0, 58)
    innerPad.PaddingBottom = UDim.new(0, 16)
    innerPad.PaddingLeft = UDim.new(0, 14)
    innerPad.PaddingRight = UDim.new(0, 14)
    innerPad.Parent = columnFrame

    innerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        columnFrame.CanvasSize = UDim2.new(0, 0, 0, innerList.AbsoluteContentSize.Y + 74)
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

local CombatCol = CreateIndependentWindow("Combat", UDim2.new(0.5, -650, 0.5, -310))
local VisualCol = CreateIndependentWindow("Visuals & ESP", UDim2.new(0.5, -325, 0.5, -310))
local PlayerCol = CreateIndependentWindow("Player", UDim2.new(0.5, 0, 0.5, -310))
local MiscCol = CreateIndependentWindow("Misc", UDim2.new(0.5, 325, 0.5, -310))

local function CreateToggleInColumn(parentCol, name, default, callback, rightClickConfigFunc)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = default and Color3.fromRGB(20, 80, 170) or Color3.fromRGB(15, 20, 32)
    btn.Text = "   " .. name
    btn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 185, 215)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    btn.Parent = parentCol

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = default and Color3.fromRGB(90, 180, 255) or Color3.fromRGB(30, 45, 70)
    stroke.Transparency = 0.3
    stroke.Parent = btn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 60, 1, 0)
    statusLabel.Position = UDim2.new(1, -65, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = default and "ON" or "OFF"
    statusLabel.TextColor3 = default and Color3.fromRGB(170, 230, 255) or Color3.fromRGB(95, 115, 140)
    statusLabel.TextSize = 13
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.ZIndex = 3
    statusLabel.Parent = btn

    local state = default
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    btn.MouseButton1Click:Connect(function()
        state = not state
        statusLabel.Text = state and "ON" or "OFF"
        
        local targetColor = state and Color3.fromRGB(20, 80, 170) or Color3.fromRGB(15, 20, 32)
        local targetTextColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 185, 215)
        local targetStatusColor = state and Color3.fromRGB(170, 230, 255) or Color3.fromRGB(95, 115, 140)
        local targetStrokeColor = state and Color3.fromRGB(90, 180, 255) or Color3.fromRGB(30, 45, 70)

        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(btn, tweenInfo, {TextColor3 = targetTextColor}):Play()
        TweenService:Create(statusLabel, tweenInfo, {TextColor3 = targetStatusColor}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = targetStrokeColor}):Play()

        callback(state)
    end)

    if rightClickConfigFunc then
        btn.MouseButton2Click:Connect(function()
            if activeSubMenuOwner == name then
                HideSubPopup()
            else
                HideSubPopup()
                activeSubMenuOwner = name
                popupTitle.Text = name .. " Properties"
                rightClickConfigFunc(popupContentFrame)
                local mouseLoc = UserInputService:GetMouseLocation()
                SubSettingPopup.Position = UDim2.new(0, math.clamp(mouseLoc.X, 10, Camera.ViewportSize.X - 230), 0, math.clamp(mouseLoc.Y, 10, Camera.ViewportSize.Y - 160))
                SubSettingPopup.Visible = true
            end
        end)
    end
end

CreateToggleInColumn(CombatCol, "Aimbot", Config.Aimbot, function(v) Config.Aimbot = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Smoothness: " .. Config.Aimbot_Smooth
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 12)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 102
    sliderBg.Parent = container

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp(Config.Aimbot_Smooth / 10, 0.05, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 102
    fill.Parent = sliderBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = fill

    local draggingSlider = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local relX = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0.05, 1)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            Config.Aimbot_Smooth = math.floor(relX * 10)
            lbl.Text = "Smoothness: " .. Config.Aimbot_Smooth
        end
    end)
end)

CreateToggleInColumn(CombatCol, "Ragebot", Config.Ragebot, function(v) Config.Ragebot = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Rage Speed: " .. Config.Ragebot_Speed
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 12)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 102
    sliderBg.Parent = container

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp(Config.Ragebot_Speed / 20, 0.05, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 102
    fill.Parent = sliderBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = fill

    local draggingSlider = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local relX = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0.05, 1)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            Config.Ragebot_Speed = math.floor(relX * 20)
            lbl.Text = "Rage Speed: " .. Config.Ragebot_Speed
        end
    end)
end)

CreateToggleInColumn(CombatCol, "Wall Check", Config.Wall_Check, function(v) Config.Wall_Check = v end)

CreateToggleInColumn(CombatCol, "Triggerbot", Config.Triggerbot, function(v) Config.Triggerbot = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Hitbox Target: " .. Config.Hitbox
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container

    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(1, 0, 0, 36)
    modeBtn.Position = UDim2.new(0, 0, 0, 32)
    modeBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 80)
    modeBtn.Text = "Switch Hitbox"
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.TextSize = 12
    modeBtn.Font = Enum.Font.GothamBold
    modeBtn.ZIndex = 102
    modeBtn.Parent = container

    local mCorner = Instance.new("UICorner")
    mCorner.CornerRadius = UDim.new(0, 6)
    mCorner.Parent = modeBtn

    modeBtn.MouseButton1Click:Connect(function()
        if Config.Hitbox == "Head" then
            Config.Hitbox = "HumanoidRootPart"
        else
            Config.Hitbox = "Head"
        end
        lbl.Text = "Hitbox Target: " .. Config.Hitbox
    end)
end)

CreateToggleInColumn(CombatCol, "Fling Target", Config.Fling, function(v) Config.Fling = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Safe Anti-Recoil Fling"
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container

    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(1, 0, 0, 36)
    modeBtn.Position = UDim2.new(0, 0, 0, 32)
    modeBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 80)
    modeBtn.Text = "Status: Anti-Fly Active"
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.TextSize = 12
    modeBtn.Font = Enum.Font.GothamBold
    modeBtn.ZIndex = 102
    modeBtn.Parent = container

    local mCorner = Instance.new("UICorner")
    mCorner.CornerRadius = UDim.new(0, 6)
    mCorner.Parent = modeBtn
end)

CreateToggleInColumn(VisualCol, "ESP Master", Config.ESP_Master, function(v) Config.ESP_Master = v end)
CreateToggleInColumn(VisualCol, "Skeleton ESP", Config.Skeleton_ESP, function(v) Config.Skeleton_ESP = v end)
CreateToggleInColumn(VisualCol, "Box ESP", Config.Box_ESP, function(v) Config.Box_ESP = v end)
CreateToggleInColumn(VisualCol, "Health Bar", Config.Health_Bar, function(v) Config.Health_Bar = v end)
CreateToggleInColumn(VisualCol, "Player Info", Config.Info_Display, function(v) Config.Info_Display = v end)
CreateToggleInColumn(VisualCol, "Tracer Lines", Config.Tracer_Lines, function(v) Config.Tracer_Lines = v end)

CreateToggleInColumn(VisualCol, "Team Filter", Config.Team_Filter, function(v) Config.Team_Filter = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Filters out teammates from ESP & Aim"
    lbl.TextColor3 = Color3.fromRGB(180, 200, 230)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container
end)

CreateToggleInColumn(VisualCol, "Chams / Highlight", Config.Chams_Enabled, function(v) Config.Chams_Enabled = v end)

CreateToggleInColumn(PlayerCol, "Infinite Jump", Config.Infinite_Jump, function(v) Config.Infinite_Jump = v end)

CreateToggleInColumn(PlayerCol, "Fly Mode (Q)", Config.Fly_Mode, function(v) Config.Fly_Mode = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Fly Speed: " .. Config.Fly_Speed
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 12)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 102
    sliderBg.Parent = container

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp(Config.Fly_Speed / 200, 0.05, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 102
    fill.Parent = sliderBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = fill

    local draggingSlider = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local relX = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0.05, 1)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            Config.Fly_Speed = math.floor(relX * 200)
            lbl.Text = "Fly Speed: " .. Config.Fly_Speed
        end
    end)
end)

CreateToggleInColumn(PlayerCol, "Noclip", Config.Noclip, function(v) Config.Noclip = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Noclip Mode Selector"
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container

    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(1, 0, 0, 36)
    modeBtn.Position = UDim2.new(0, 0, 0, 32)
    modeBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 80)
    modeBtn.Text = "Mode: " .. Config.Noclip_Mode
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.TextSize = 12
    modeBtn.Font = Enum.Font.GothamBold
    modeBtn.ZIndex = 102
    modeBtn.Parent = container

    local mCorner = Instance.new("UICorner")
    mCorner.CornerRadius = UDim.new(0, 6)
    mCorner.Parent = modeBtn

    modeBtn.MouseButton1Click:Connect(function()
        if Config.Noclip_Mode == "SafeRaycast" then
            Config.Noclip_Mode = "Standard"
        else
            Config.Noclip_Mode = "SafeRaycast"
        end
        modeBtn.Text = "Mode: " .. Config.Noclip_Mode
    end)
end)

CreateToggleInColumn(PlayerCol, "Speed Hack", Config.Speed_Hack, function(v) Config.Speed_Hack = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Speed Value: " .. Config.Speed_Val
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 12)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 102
    sliderBg.Parent = container

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp(Config.Speed_Val / 150, 0.05, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 102
    fill.Parent = sliderBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = fill

    local draggingSlider = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local relX = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0.05, 1)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            Config.Speed_Val = math.floor(relX * 150)
            lbl.Text = "Speed Value: " .. Config.Speed_Val
        end
    end)
end)

CreateToggleInColumn(MiscCol, "Fullbright", Config.Fullbright, function(v) Config.Fullbright = v end, function(container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Max Lighting Brightness"
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 102
    lbl.Parent = container
end)

local function ToggleMenuVisibility()
    isMenuVisible = not isMenuVisible
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    if isMenuVisible then
        TweenService:Create(DimBackground, tweenInfo, {BackgroundTransparency = 0.55}):Play()
        for _, win in ipairs(WindowsList) do win.Visible = true end
    else
        TweenService:Create(DimBackground, tweenInfo, {BackgroundTransparency = 1}):Play()
        for _, win in ipairs(WindowsList) do win.Visible = false end
        HideSubPopup()
    end
end

TweenService:Create(DimBackground, TweenInfo.new(0.4), {BackgroundTransparency = 0.55}):Play()

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
    if ESPConnections[player] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "SecureUniqueHighlight"
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
                table.insert(skeletonLines, line)
            end
        end
    end)

    local connection = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not Config.ESP_Master or not IsPlayerValid(player) then
                highlight.Enabled = false
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
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local col = GetPlayerColor(player)

            if Config.Chams_Enabled then
                highlight.Adornee = char
                highlight.FillColor = col
                highlight.OutlineColor = col
                highlight.Enabled = true
            else
                highlight.Enabled = false
            end

            local cam = Workspace.CurrentCamera
            if not cam then return end

            local hrpPos, hrpOnScreen = cam:WorldToViewportPoint(hrp.Position)
            if hrpOnScreen then
                if Config.Tracer_Lines and tracerLine then
                    tracerLine.Visible = true
                    tracerLine.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                    tracerLine.To = Vector2.new(hrpPos.X, hrpPos.Y)
                    tracerLine.Color = col
                elseif tracerLine then
                    tracerLine.Visible = false
                end

                if Config.Info_Display and infoText then
                    infoText.Visible = true
                    infoText.Position = Vector2.new(hrpPos.X, hrpPos.Y - 40)
                    infoText.Text = player.Name .. " [" .. math.floor(humanoid.Health) .. "HP]"
                elseif infoText then
                    infoText.Visible = false
                end

                if Config.Box_ESP and boxLine then
                    local size = (cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y)
                    local boxSize = Vector2.new(math.abs(size) * 0.6, math.abs(size))
                    boxLine.Visible = true
                    boxLine.Size = boxSize
                    boxLine.Position = Vector2.new(hrpPos.X - boxSize.X / 2, hrpPos.Y - boxSize.Y / 2)
                    boxLine.Color = col
                elseif boxLine then
                    boxLine.Visible = false
                end

                if Config.Health_Bar and healthBarBg and healthBarLine then
                    local size = (cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y)
                    local boxHeight = math.abs(size)
                    local boxWidth = boxHeight * 0.6
                    local barX = hrpPos.X - boxWidth / 2 - 6
                    local barYTop = hrpPos.Y - boxHeight / 2
                    local barYBot = hrpPos.Y + boxHeight / 2

                    healthBarBg.Visible = true
                    healthBarBg.From = Vector2.new(barX, barYTop)
                    healthBarBg.To = Vector2.new(barX, barYBot)

                    local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    local currentHeight = boxHeight * healthPercent
                    healthBarLine.Visible = true
                    healthBarLine.From = Vector2.new(barX, barYBot - currentHeight)
                    healthBarLine.To = Vector2.new(barX, barYBot)
                    healthBarLine.Color = Color3.fromRGB(255 - (healthPercent * 255), healthPercent * 255, 0)
                else
                    if healthBarBg then healthBarBg.Visible = false end
                    if healthBarLine then healthBarLine.Visible = false end
                end

                if Config.Skeleton_ESP then
                    for i, joint in ipairs(SkeletonJoints) do
                        local p1 = char:FindFirstChild(joint[1])
                        local p2 = char:FindFirstChild(joint[2])
                        local line = skeletonLines[i]
                        if p1 and p2 and line then
                            local v1, s1 = cam:WorldToViewportPoint(p1.Position)
                            local v2, s2 = cam:WorldToViewportPoint(p2.Position)
                            if s1 and s2 then
                                line.Visible = true
                                line.From = Vector2.new(v1.X, v1.Y)
                                line.To = Vector2.new(v2.X, v2.Y)
                                line.Color = col
                            else
                                line.Visible = false
                            end
                        elseif line then
                            line.Visible = false
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
        Highlight = highlight, 
        Connection = connection, 
        Skeleton = skeletonLines, 
        Tracer = tracerLine, 
        Info = infoText, 
        Box = boxLine, 
        BarBg = healthBarBg, 
        BarLine = healthBarLine
    }
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

-- [수정됨] 거리 제한 없는 자동 타겟팅 및 즉시 폭발형 Fling 로직
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if not Config.Fling then return end
        pcall(function()
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHrp or not myHumanoid then return end

            local closestTarget = nil
            local shortestDist = math.huge

            for _, p in ipairs(Players:GetPlayers()) do
                if IsPlayerValid(p) and (not Config.Team_Filter or p.Team ~= LocalPlayer.Team) then
                    local tChar = p.Character
                    local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    if tHrp then
                        local dist = (myHrp.Position - tHrp.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestTarget = p
                        end
                    end
                end
            end

            if closestTarget and closestTarget.Character then
                local tChar = closestTarget.Character
                local tHrp = tChar:FindFirstChild("HumanoidRootPart")
                local tHumanoid = tChar:FindFirstChildOfClass("Humanoid")
                
                if tHrp and tHumanoid and tHumanoid.Health > 0 then
                    myHumanoid.PlatformStand = true

                    local holdVel = myHrp:FindFirstChild("AntiRecoilVel")
                    if not holdVel then
                        holdVel = Instance.new("BodyVelocity", myHrp)
                        holdVel.Name = "AntiRecoilVel"
                        holdVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        holdVel.Velocity = Vector3.new(0, 0, 0)
                    end

                    local startTime = tick()
                    while tick() - startTime < 0.4 and Config.Fling and IsPlayerValid(closestTarget) and tHumanoid.Health > 0 do
                        local angle = tick() * 120
                        local offsetX = math.cos(angle) * 1.5
                        local offsetZ = math.sin(angle) * 1.5
                        
                        myHrp.CFrame = tHrp.CFrame + Vector3.new(offsetX, 0.5, offsetZ)
                        myHrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                        myHrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
                        RunService.Heartbeat:Wait()
                    end

                    if holdVel then holdVel:Destroy() end
                    myHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    myHumanoid.PlatformStand = false
                end
            end
        end)
    end)
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local cam = Workspace.CurrentCamera
        if not cam then return end

        if FOVCircle then
            if Config.Aimbot then
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
                        myRoot.CFrame = tHrp.CFrame + Vector3.new(math.random(-1, 1), Config.Ragebot_Speed, math.random(-1, 1))
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
            Lighting.Brightness = Config.Fullbright_Brightness
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.ClockTime = OriginalLighting.ClockTime
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        end

        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if humanoid then
                if Config.Speed_Hack then humanoid.WalkSpeed = Config.Speed_Val else humanoid.WalkSpeed = 16 end
            end

            if Config.Noclip then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if Config.Noclip_Mode == "Standard" then
                            part.CanCollide = false
                        else
                            if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Position.Y > (char:GetPivot().Position.Y - 2.5) then
                                part.CanCollide = false
                            end
                        end
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
