--!nocheck

loadstring(game:HttpGet("https://raw.githubusercontent.com/cjwstar25-pngWJNof9r29jk1oi23134/refs/heads/main/Bypass.lua"))()

-- ============================================================
-- CONFIG 자체 초기화 (UI 코드와 독립적으로 실행 가능)
-- ============================================================
if not getgenv().SharedConfig then
    getgenv().SharedConfig = {
        Language = "EN",
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
end

local Config = getgenv().SharedConfig

-- ============================================================
-- 여기서부터 본격적인 기능 코드 시작
-- ============================================================

-- ============================================================
-- 디버그: Config 상태 확인
-- ============================================================
print("[Cubic] Config 초기화 시작")
print("[Cubic] getgenv() 존재:", getgenv() ~= nil)
print("[Cubic] SharedConfig 존재:", getgenv().SharedConfig ~= nil)

if getgenv().SharedConfig then
    print("[Cubic] Config.ESP_Master:", getgenv().SharedConfig.ESP_Master)
    print("[Cubic] Config.Aimbot:", getgenv().SharedConfig.Aimbot)
    print("[Cubic] Config.Ragebot:", getgenv().SharedConfig.Ragebot)
    print("[Cubic] Config.Fly_Mode:", getgenv().SharedConfig.Fly_Mode)
else
    print("[Cubic] SharedConfig가 nil입니다! UI 코드가 먼저 실행되었는지 확인하세요.")
end

print("[Cubic] LocalPlayer 존재:", Players.LocalPlayer ~= nil)
print("[Cubic] Character 존재:", Players.LocalPlayer.Character ~= nil)
print("[Cubic] Humanoid 존재:", Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

-- Config 안전 초기화 (getgenv()가 nil일 경우 대비)
local function safeGetConfig()
    local env = getgenv()
    if not env then
        env = {}
        setgenv(env)
    end
    if not env.SharedConfig then
        env.SharedConfig = {
            Language = "EN",
            MenuKey = Enum.KeyCode.RightShift,
            ESP_Master = false,
            Skeleton_ESP = false,
            Box_ESP = false,
            Health_Bar = false,
            Tracer_Lines = false,
            Info_Display = false,
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
    end
    return env.SharedConfig
end

local Config = safeGetConfig()
if type(Config) ~= "table" then
    error("Config is not a table! Check getgenv().")
end

local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChild("Humanoid")

local function GetCharacter(player)
    return player and player.Character or nil
end

local function GetHumanoid(player)
    local char = GetCharacter(player)
    return char and char:FindFirstChild("Humanoid")
end

local function IsAlive(player)
    local humanoid = GetHumanoid(player)
    return humanoid and humanoid.Health > 0
end

local function GetMyRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function GetClosestPlayer()
    local closestDist = math.huge
    local closestPlayer = nil
    local myRoot = GetMyRoot()
    if not myRoot then return nil end
    local myPos = myRoot.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not IsAlive(player) then continue end
        if Config.Team_Filter and player.Team == LocalPlayer.Team then continue end

        local char = GetCharacter(player)
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local dist = (root.Position - myPos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closestPlayer = player
        end
    end
    return closestPlayer
end

local Aimbot = {Enabled = false, Target = nil, CurrentTarget = nil}

local function GetClosestPlayerToMouse()
    if not Config.Aimbot then return nil end
    local mouse = LocalPlayer:GetMouse()
    if not mouse then return nil end

    local fovRadius = Config.Aimbot_FOV or 150
    local bestDistance = fovRadius
    local bestTarget = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not IsAlive(player) then continue end
        if Config.Team_Filter and player.Team == LocalPlayer.Team then continue end

        local char = GetCharacter(player)
        if not char then continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end

        local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

        local targetPart
        if Config.Hitbox == "Head" then
            targetPart = head
        elseif Config.Hitbox == "Torso" then
            targetPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
        else
            local parts = {head, char:FindFirstChild("UpperTorso"), char:FindFirstChild("HumanoidRootPart")}
            targetPart = parts[math.random(1, #parts)]
        end

        if targetPart and distance < bestDistance then
            bestDistance = distance
            bestTarget = {Player = player, Part = targetPart, ScreenPos = screenPos}
        end
    end
    return bestTarget
end

local function PerformAimbot()
    if not Config.Aimbot then return end
    local targetData = GetClosestPlayerToMouse()
    if not targetData then return end

    local mouse = LocalPlayer:GetMouse()
    if not mouse then return end

    local smoothness = Config.Aimbot_Smooth or 2
    local smoothFactor = 1 / (smoothness + 1)

    local targetScreenPos = targetData.ScreenPos
    local currentPos = Vector2.new(mouse.X, mouse.Y)
    local targetPos = Vector2.new(targetScreenPos.X, targetScreenPos.Y)

    if smoothness > 1 then
        local newPos = currentPos:Lerp(targetPos, smoothFactor)
        mousemoverel(newPos.X - currentPos.X, newPos.Y - currentPos.Y)
    else
        mousemoverel(targetPos.X - currentPos.X, targetPos.Y - currentPos.Y)
    end
    Aimbot.CurrentTarget = targetData.Player
end

local FOVCircle = nil
local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Destroy(); FOVCircle = nil end
    if not Config.Show_FOV or not Config.Aimbot then return end

    local screenGui = CoreGui:FindFirstChild("CubicUltimateHub") or CoreGui
    FOVCircle = Instance.new("Frame")
    FOVCircle.Name = "FOVCircle"
    FOVCircle.Size = UDim2.fromOffset(Config.Aimbot_FOV * 2, Config.Aimbot_FOV * 2)
    FOVCircle.Position = UDim2.new(0.5, -Config.Aimbot_FOV, 0.5, -Config.Aimbot_FOV)
    FOVCircle.BackgroundTransparency = 1
    FOVCircle.BorderSizePixel = 0
    FOVCircle.ZIndex = 9999
    FOVCircle.Parent = screenGui

    local circle = Instance.new("ImageLabel")
    circle.Size = UDim2.fromScale(1, 1)
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://15314665975"
    circle.ImageColor3 = Color3.fromRGB(255, 80, 80)
    circle.ImageTransparency = 0.7
    circle.ZIndex = 10000
    circle.Parent = FOVCircle
end

local function UpdateFOVCircle()
    if FOVCircle then FOVCircle:Destroy(); FOVCircle = nil end
    if Config.Show_FOV and Config.Aimbot then CreateFOVCircle() end
end

local Ragebot = {
    Enabled = false,
    Target = nil,
    Offset = Vector3.new(0, 10, 0),
    JitterAmount = 0.3,
    Connection = nil,
}

local function PerformRagebot()
    if not Config.Ragebot then return end
    local target = GetClosestPlayer()
    if not target then return end

    local targetChar = GetCharacter(target)
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local basePos = targetRoot.Position + Ragebot.Offset
    local jitter = Vector3.new(
        math.random(-100, 100) / 100 * Ragebot.JitterAmount,
        math.random(-100, 100) / 100 * Ragebot.JitterAmount,
        math.random(-100, 100) / 100 * Ragebot.JitterAmount
    )
    local targetPos = basePos + jitter

    myRoot.CFrame = CFrame.new(targetPos)
    local humanoid = myChar:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
end

local function ToggleRagebot(state)
    Config.Ragebot = state
    if state then
        if Ragebot.Connection then Ragebot.Connection:Disconnect() end
        Ragebot.Connection = RunService.Heartbeat:Connect(function()
            if Config.Ragebot then PerformRagebot() end
        end)
    else
        if Ragebot.Connection then
            Ragebot.Connection:Disconnect()
            Ragebot.Connection = nil
        end
        local myChar = LocalPlayer.Character
        if myChar then
            local humanoid = myChar:FindFirstChild("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end

local Triggerbot = {Enabled = false}
local function PerformTriggerbot()
    if not Config.Triggerbot then return end
    local mouse = LocalPlayer:GetMouse()
    if not mouse then return end
    local target = GetClosestPlayerToMouse()
    if not target then return end

    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local fireEvent = tool:FindFirstChild("FireEvent") or tool:FindFirstChild("RemoteEvent")
        if fireEvent and fireEvent:IsA("RemoteEvent") then
            fireEvent:FireServer()
        end
    end
end

local ESP = {Enabled = false, Objects = {}}

local function CreateESP(player)
    if not Config.ESP_Master then return end
    local char = GetCharacter(player)
    if not char then return end
    if ESP.Objects[player] then
        ESP.Objects[player]:Destroy()
        ESP.Objects[player] = nil
    end

    local espGroup = Instance.new("Folder")
    espGroup.Name = "ESP_" .. player.Name
    espGroup.Parent = char

    if Config.Box_ESP then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(2.5, 5, 1)
        box.Color3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.6
        box.ZIndex = 10
        box.AlwaysOnTop = true
        box.Adornee = char:FindFirstChild("HumanoidRootPart") or char
        box.Parent = espGroup
    end

    if Config.Skeleton_ESP then
        local function AddLine(part1, part2, color)
            local line = Instance.new("LineHandleAdornment")
            line.Width = 1
            line.Color3 = color
            line.Transparency = 0.5
            line.ZIndex = 10
            line.AlwaysOnTop = true
            line.Points = {part1.Position, part2.Position}
            line.Parent = espGroup
            RunService.Heartbeat:Connect(function()
                if part1 and part2 and part1.Parent and part2.Parent then
                    line.Points = {part1.Position, part2.Position}
                end
            end)
            return line
        end

        local head = char:FindFirstChild("Head")
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
        local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("LeftArm")
        local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("RightArm")
        local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("LeftLeg")
        local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("RightLeg")

        if head and torso then AddLine(head, torso, Color3.fromRGB(255,255,255)) end
        if torso and leftArm then AddLine(torso, leftArm, Color3.fromRGB(255,255,255)) end
        if torso and rightArm then AddLine(torso, rightArm, Color3.fromRGB(255,255,255)) end
        if torso and leftLeg then AddLine(torso, leftLeg, Color3.fromRGB(255,255,255)) end
        if torso and rightLeg then AddLine(torso, rightLeg, Color3.fromRGB(255,255,255)) end
    end

    if Config.Health_Bar then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 50, 0, 8)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.Parent = espGroup

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.5
        bg.Parent = billboard

        local healthFrame = Instance.new("Frame")
        healthFrame.Size = UDim2.new(1, 0, 1, 0)
        healthFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFrame.Parent = bg

        local humanoid = GetHumanoid(player)
        if humanoid then
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                local percent = humanoid.Health / humanoid.MaxHealth
                healthFrame.Size = UDim2.new(percent, 0, 1, 0)
                healthFrame.BackgroundColor3 = Color3.fromRGB(255 * (1 - percent), 255 * percent, 0)
            end)
        end
    end

    if Config.Tracer_Lines then
        local tracer = Instance.new("LineHandleAdornment")
        tracer.Width = 1
        tracer.Color3 = Color3.fromRGB(255, 0, 0)
        tracer.Transparency = 0.5
        tracer.ZIndex = 5
        tracer.AlwaysOnTop = true
        tracer.Parent = espGroup

        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            RunService.Heartbeat:Connect(function()
                if rootPart and rootPart.Parent then
                    local camPos = Workspace.CurrentCamera.CFrame.Position
                    tracer.Points = {camPos, rootPart.Position}
                end
            end)
        end
    end

    if Config.Info_Display then
        local infoGui = Instance.new("BillboardGui")
        infoGui.Size = UDim2.new(0, 100, 0, 30)
        infoGui.StudsOffset = Vector3.new(0, 3.8, 0)
        infoGui.Parent = espGroup

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = infoGui

        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 1, 0)
        distLabel.Position = UDim2.new(0, 0, 1, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = ""
        distLabel.TextColor3 = Color3.fromRGB(200,200,200)
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.Gotham
        distLabel.Parent = infoGui

        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            RunService.Heartbeat:Connect(function()
                if rootPart and rootPart.Parent then
                    local myRoot = GetMyRoot()
                    local myPos = myRoot and myRoot.Position or Vector3.new(0,0,0)
                    local dist = (rootPart.Position - myPos).Magnitude
                    distLabel.Text = string.format("%.1f m", dist)
                end
            end)
        end
    end

    ESP.Objects[player] = espGroup
end

local function UpdateESP()
    for player, obj in pairs(ESP.Objects) do
        pcall(function() obj:Destroy() end)
    end
    ESP.Objects = {}
    if not Config.ESP_Master then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            if not Config.Team_Filter or player.Team ~= LocalPlayer.Team then
                CreateESP(player)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        UpdateESP()
    end)
    UpdateESP()
end)
Players.PlayerRemoving:Connect(function(player)
    if ESP.Objects[player] then
        pcall(function() ESP.Objects[player]:Destroy() end)
        ESP.Objects[player] = nil
    end
end)
task.spawn(function()
    while task.wait(1) do
        if Config.ESP_Master then UpdateESP() end
    end
end)

local Chams = {Enabled = false, Objects = {}}
local function UpdateChams()
    for player, obj in pairs(Chams.Objects) do
        pcall(function() obj:Destroy() end)
    end
    Chams.Objects = {}
    if not Config.Chams_Enabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local char = GetCharacter(player)
            if char then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255,255,255)
                highlight.OutlineTransparency = 0.3
                highlight.Adornee = char
                highlight.Parent = char
                Chams.Objects[player] = highlight
            end
        end
    end
end

local InfiniteJump = {Enabled = false, OriginalJumpPower = 50}
local function SetupInfiniteJump()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    if Config.Infinite_Jump then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid.JumpPower = 50
        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
                if Config.Infinite_Jump and humanoid and humanoid.Parent then
                    humanoid.Jump = true
                end
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:FindFirstChild("Humanoid")
    SetupInfiniteJump()
end)

local Fly = {Enabled = false, Flying = false, BodyVelocity = nil, BodyGyro = nil}
local function ToggleFly(state)
    Config.Fly_Mode = state
    if state then
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = true end

        Fly.BodyVelocity = Instance.new("BodyVelocity")
        Fly.BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        Fly.BodyVelocity.Parent = root

        Fly.BodyGyro = Instance.new("BodyGyro")
        Fly.BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        Fly.BodyGyro.CFrame = root.CFrame
        Fly.BodyGyro.Parent = root

        Fly.Flying = true
        task.spawn(function()
            while Fly.Flying and Config.Fly_Mode do
                local speed = Config.Fly_Speed or 80
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end

                if moveDir.Magnitude > 0 then
                    moveDir = moveDir.Unit * speed
                    if Fly.BodyVelocity then Fly.BodyVelocity.Velocity = moveDir end
                else
                    if Fly.BodyVelocity then Fly.BodyVelocity.Velocity = Vector3.new(0,0,0) end
                end
                task.wait()
            end
        end)
    else
        Fly.Flying = false
        if Fly.BodyVelocity then Fly.BodyVelocity:Destroy(); Fly.BodyVelocity = nil end
        if Fly.BodyGyro then Fly.BodyGyro:Destroy(); Fly.BodyGyro = nil end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end

local Noclip = {Enabled = false}
local function ToggleNoclip(state)
    Config.Noclip = state
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if Config.Noclip then ToggleNoclip(true) end
end)

local SpeedHack = {Enabled = false, OriginalSpeed = 16}
local function SetupSpeedHack()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    if Config.Speed_Hack then
        SpeedHack.OriginalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = Config.Speed_Val or 40
    else
        if SpeedHack.OriginalSpeed > 0 then
            humanoid.WalkSpeed = SpeedHack.OriginalSpeed
        end
    end
end

local function OnSpeedChange()
    if Config.Speed_Hack then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = Config.Speed_Val or 40 end
        end
    end
end

local function ToggleSkybox(state)
    Config.Skybox_Mode = state
    if state then
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then sky = Instance.new("Sky"); sky.Parent = Lighting end
        local id = Config.Custom_Sky_Id or "600835154"
        local asset = "rbxassetid://" .. tostring(id)
        sky.SkyboxBk = asset; sky.SkyboxDn = asset; sky.SkyboxFt = asset
        sky.SkyboxLf = asset; sky.SkyboxRt = asset; sky.SkyboxUp = asset

        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atmosphere then atmosphere = Instance.new("Atmosphere"); atmosphere.Parent = Lighting end
        atmosphere.Density = 0.3; atmosphere.Offset = 0.1
        atmosphere.Color = Color3.fromRGB(255,200,150)
        atmosphere.Decay = Color3.fromRGB(100,80,150)
    else
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if sky then sky:Destroy() end
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then atmosphere:Destroy() end
    end
end

local DeathAudio = {Enabled = false}
local function PlayDeathAudio()
    if not Config.Death_Audio then return end
    local id = Config.Death_Audio_Id or "84615664978587"
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = 1
    sound.Parent = Workspace
    sound:Play()
    task.wait(sound.TimeLength)
    sound:Destroy()
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char.Humanoid.Died:Connect(function()
        PlayDeathAudio()
    end)
end)

local RainbowCursor = {Enabled = false, Connection = nil, Crosshair = nil, Hue = 0}
local function CreateCrosshair()
    if RainbowCursor.Crosshair then RainbowCursor.Crosshair:Destroy(); RainbowCursor.Crosshair = nil end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RainbowCrosshair"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = CoreGui

    local center = Instance.new("Frame")
    center.Size = UDim2.new(0, 40, 0, 40)
    center.Position = UDim2.new(0.5, -20, 0.5, -20)
    center.BackgroundTransparency = 1
    center.ZIndex = 9999
    center.Parent = screenGui

    local thickness = 2
    local length = 12
    local gap = 4

    local function makeLine(anchor, pos, size)
        local line = Instance.new("Frame")
        line.Size = size
        line.Position = pos
        line.AnchorPoint = anchor
        line.BackgroundColor3 = Color3.fromRGB(255,255,255)
        line.BackgroundTransparency = 0.2
        line.ZIndex = 10000
        line.Parent = center
        return line
    end

    makeLine(Vector2.new(0.5,1), UDim2.new(0.5,0,0.5,-gap), UDim2.new(0,thickness,0,length))
    makeLine(Vector2.new(0.5,0), UDim2.new(0.5,0,0.5,gap), UDim2.new(0,thickness,0,length))
    makeLine(Vector2.new(1,0.5), UDim2.new(0.5,-gap,0.5,0), UDim2.new(0,length,0,thickness))
    makeLine(Vector2.new(0,0.5), UDim2.new(0.5,gap,0.5,0), UDim2.new(0,length,0,thickness))

    RainbowCursor.Crosshair = screenGui
    return center
end

local function SetupRainbowCursor()
    if Config.Interactive_Cursor then
        RainbowCursor.Enabled = true
        local center = CreateCrosshair()
        if not center then return end
        if RainbowCursor.Connection then RainbowCursor.Connection:Disconnect() end

        RainbowCursor.Connection = RunService.Heartbeat:Connect(function()
            if not RainbowCursor.Enabled or not center.Parent then
                if RainbowCursor.Connection then
                    RainbowCursor.Connection:Disconnect()
                    RainbowCursor.Connection = nil
                end
                return
            end
            RainbowCursor.Hue = (RainbowCursor.Hue + 0.01) % 1
            local color = Color3.fromHSV(RainbowCursor.Hue, 1, 1)
            for _, child in ipairs(center:GetChildren()) do
                if child:IsA("Frame") then
                    child.BackgroundColor3 = color
                    child.BackgroundTransparency = 0.1
                end
            end
            center.Rotation = (center.Rotation + 1.5) % 360
        end)
    else
        RainbowCursor.Enabled = false
        if RainbowCursor.Connection then
            RainbowCursor.Connection:Disconnect()
            RainbowCursor.Connection = nil
        end
        if RainbowCursor.Crosshair then
            RainbowCursor.Crosshair:Destroy()
            RainbowCursor.Crosshair = nil
        end
    end
end

local function SetupFPSUnlocker(state)
    Config.FPS_Opt = state
    pcall(function()
        if setfpscap then setfpscap(state and 120 or 60) end
    end)
end

local function ToggleThirdPerson(state)
    Config.Third_Person = state
    local camera = Workspace.CurrentCamera
    if not camera then return end
    camera.CameraType = state and Enum.CameraType.Custom or Enum.CameraType.Default
end

local function ToggleSpoof(state)
    Config.Device_Spoof = state
    GuiService:SetEmotesVisible(state)
end

local AntiAim = {Enabled = false, Connection = nil}
local function SetupAntiAim(state)
    Config.Anti_Aim = state
    if state then
        if AntiAim.Connection then AntiAim.Connection:Disconnect() end
        AntiAim.Connection = RunService.Heartbeat:Connect(function()
            if not Config.Anti_Aim then return end
            local char = LocalPlayer.Character
            if not char then return end
            local head = char:FindFirstChild("Head")
            if head then
                head.CFrame = head.CFrame * CFrame.Angles(0, math.rad(180), 0)
            end
        end)
    else
        if AntiAim.Connection then
            AntiAim.Connection:Disconnect()
            AntiAim.Connection = nil
        end
    end
end

-- 모든 주요 함수를 pcall로 감싸서 실행
local function UpdateAllFeatures()
    pcall(function()
        if Config.Aimbot then PerformAimbot() end
        if Config.Ragebot then PerformRagebot() end
        if Config.Triggerbot then PerformTriggerbot() end
        if Config.Speed_Hack then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then humanoid.WalkSpeed = Config.Speed_Val or 40 end
            end
        end
    end)
end

RunService.Heartbeat:Connect(UpdateAllFeatures)

-- Config 변경 감지 (setmetatable은 Config가 테이블일 때만)
if type(Config) == "table" then
    local configMetatable = {
        __index = Config,
        __newindex = function(t, key, value)
            rawset(t, key, value)
            pcall(function()
                if key == "Ragebot" then
                    ToggleRagebot(value)
                elseif key == "Fly_Mode" then
                    ToggleFly(value)
                elseif key == "Noclip" then
                    ToggleNoclip(value)
                elseif key == "Speed_Hack" then
                    SetupSpeedHack()
                elseif key == "Skybox_Mode" then
                    ToggleSkybox(value)
                elseif key == "Third_Person" then
                    ToggleThirdPerson(value)
                elseif key == "Device_Spoof" then
                    ToggleSpoof(value)
                elseif key == "Interactive_Cursor" then
                    SetupRainbowCursor()
                elseif key == "FPS_Opt" then
                    SetupFPSUnlocker(value)
                elseif key == "Anti_Aim" then
                    SetupAntiAim(value)
                elseif key == "ESP_Master" or key == "Box_ESP" or key == "Skeleton_ESP" or
                       key == "Health_Bar" or key == "Tracer_Lines" or key == "Info_Display" or
                       key == "Team_Filter" then
                    UpdateESP()
                elseif key == "Chams_Enabled" then
                    UpdateChams()
                elseif key == "Speed_Val" then
                    OnSpeedChange()
                elseif key == "Show_FOV" or key == "Aimbot_FOV" then
                    UpdateFOVCircle()
                end
            end)
        end
    }
    setmetatable(Config, configMetatable)
else
    warn("Config is not a table, skipping metatable setup.")
end

task.spawn(function()
    wait(0.5)
    pcall(function()
        if Config.Ragebot then ToggleRagebot(true) end
        if Config.Interactive_Cursor then SetupRainbowCursor() end
        if Config.Aimbot then UpdateFOVCircle() end
        if Config.Fly_Mode then ToggleFly(true) end
        if Config.Noclip then ToggleNoclip(true) end
        if Config.Speed_Hack then SetupSpeedHack() end
        if Config.Skybox_Mode then ToggleSkybox(true) end
        if Config.Third_Person then ToggleThirdPerson(true) end
        if Config.Device_Spoof then ToggleSpoof(true) end
        if Config.FPS_Opt then SetupFPSUnlocker(true) end
        if Config.Anti_Aim then SetupAntiAim(true) end
        if Config.ESP_Master then UpdateESP() end
        if Config.Chams_Enabled then UpdateChams() end
        if Config.Infinite_Jump then SetupInfiniteJump() end
    end)
end)

local function Cleanup()
    pcall(function()
        if RainbowCursor.Connection then RainbowCursor.Connection:Disconnect() end
        if RainbowCursor.Crosshair then RainbowCursor.Crosshair:Destroy() end
        if Ragebot.Connection then Ragebot.Connection:Disconnect() end
        if FOVCircle then FOVCircle:Destroy() end
        for _, obj in pairs(ESP.Objects) do pcall(function() obj:Destroy() end) end
        for _, obj in pairs(Chams.Objects) do pcall(function() obj:Destroy() end) end
    end)
end

task.spawn(function()
    while true do
        task.wait(1)
        if not getgenv().SharedConfig then
            Cleanup()
            break
        end
    end
end)
