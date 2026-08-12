--!nocheck
-- ============================================================
-- CONFIG 자체 초기화 (UI 코드와 독립적)
-- ============================================================
if not getgenv().SharedConfig then
    getgenv().SharedConfig = {
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

local Config = getgenv().SharedConfig

-- ============================================================
-- 서비스 가져오기
-- ============================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local RenderStepped = game:GetService("RunService").RenderStepped
local Stepped = game:GetService("RunService").Stepped
local Heartbeat = game:GetService("RunService").Heartbeat
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer or Players:WaitForChild("LocalPlayer")

-- ============================================================
-- 범용 헬퍼 함수
-- ============================================================
local function GetMyCharacter()
    if not LocalPlayer then return nil end
    local char = LocalPlayer.Character
    if char and char.Parent then return char end
    return nil
end

local function GetMyHumanoid()
    local char = GetMyCharacter()
    if not char then return nil end
    return char:FindFirstChild("Humanoid")
end

local function GetMyRoot()
    local char = GetMyCharacter()
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function GetCharacter(player)
    if not player then return nil end
    return player.Character
end

local function GetHumanoid(player)
    local char = GetCharacter(player)
    if not char then return nil end
    return char:FindFirstChild("Humanoid")
end

local function IsAlive(player)
    local humanoid = GetHumanoid(player)
    if not humanoid then return false end
    return humanoid.Health > 0
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

local function GetClosestPlayerToMouse()
    if not Config.Aimbot then return nil end
    if not LocalPlayer then return nil end
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

        local camera = Workspace.CurrentCamera
        if not camera then continue end

        local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
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

-- ============================================================
-- 1. AIMBOT (범용)
-- ============================================================
local function PerformAimbot()
    if not Config.Aimbot then return end
    if type(mousemoverel) ~= "function" then return end

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
        pcall(function() mousemoverel(newPos.X - currentPos.X, newPos.Y - currentPos.Y) end)
    else
        pcall(function() mousemoverel(targetPos.X - currentPos.X, targetPos.Y - currentPos.Y) end)
    end
end

-- ============================================================
-- 2. RAGEBOT (범용)
-- ============================================================
local Ragebot = {Connection = nil, Offset = Vector3.new(0, 10, 0), JitterAmount = 0.3}

local function PerformRagebot()
    if not Config.Ragebot then return end
    local target = GetClosestPlayer()
    if not target then return end

    local targetChar = GetCharacter(target)
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    local myRoot = GetMyRoot()
    if not myRoot then return end

    local basePos = targetRoot.Position + Ragebot.Offset
    local jitter = Vector3.new(
        math.random(-100, 100) / 100 * Ragebot.JitterAmount,
        math.random(-100, 100) / 100 * Ragebot.JitterAmount,
        math.random(-100, 100) / 100 * Ragebot.JitterAmount
    )
    myRoot.CFrame = CFrame.new(basePos + jitter)
end

local function ToggleRagebot(state)
    Config.Ragebot = state
    if state then
        if Ragebot.Connection then Ragebot.Connection:Disconnect() end
        Ragebot.Connection = Heartbeat:Connect(PerformRagebot)
    else
        if Ragebot.Connection then
            Ragebot.Connection:Disconnect()
            Ragebot.Connection = nil
        end
    end
end

-- ============================================================
-- 3. TRIGGERBOT (범용 - RemoteEvent 자동 스캔)
-- ============================================================
local function PerformTriggerbot()
    if not Config.Triggerbot then return end
    local target = GetClosestPlayerToMouse()
    if not target then return end
    
    local char = GetMyCharacter()
    if not char then return end
    
    -- Character 내 모든 RemoteEvent/RemoteFunction 검색
    for _, child in pairs(char:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            pcall(function() child:FireServer() end)
        elseif child:IsA("RemoteFunction") then
            pcall(function() child:InvokeServer() end)
        end
    end
    
    -- Tool 내 모든 RemoteEvent/RemoteFunction 검색
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("RemoteEvent") then
                    pcall(function() child:FireServer() end)
                elseif child:IsA("RemoteFunction") then
                    pcall(function() child:InvokeServer() end)
                end
            end
        end
    end
end

-- ============================================================
-- 4. ESP (BillboardGui 방식 - 모든 게임에서 작동)
-- ============================================================
local ESP = {Objects = {}}

local function CreateESP(player)
    if not Config.ESP_Master then return end
    local char = GetCharacter(player)
    if not char then return end
    
    if ESP.Objects[player] then
        pcall(function() ESP.Objects[player]:Destroy() end)
        ESP.Objects[player] = nil
    end

    local espGroup = Instance.new("Folder")
    espGroup.Name = "ESP_" .. player.Name
    espGroup.Parent = char

    -- Box ESP (BillboardGui 방식 - 모든 게임에서 렌더링 보장)
    if Config.Box_ESP then
        local boxGui = Instance.new("BillboardGui")
        boxGui.Size = UDim2.new(0, 60, 0, 90)
        boxGui.StudsOffset = Vector3.new(0, 0.5, 0)
        boxGui.AlwaysOnTop = true
        boxGui.Parent = espGroup

        local boxFrame = Instance.new("Frame")
        boxFrame.Size = UDim2.new(1, 0, 1, 0)
        boxFrame.BackgroundTransparency = 0.6
        boxFrame.BackgroundColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        boxFrame.BorderSizePixel = 2
        boxFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
        boxFrame.Parent = boxGui
    end

    -- Health Bar
    if Config.Health_Bar then
        local healthGui = Instance.new("BillboardGui")
        healthGui.Size = UDim2.new(0, 50, 0, 6)
        healthGui.StudsOffset = Vector3.new(0, 3.2, 0)
        healthGui.AlwaysOnTop = true
        healthGui.Parent = espGroup

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.5
        bg.Parent = healthGui

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

    -- Tracer Lines (선 대신 BillboardGui로 표시)
    if Config.Tracer_Lines then
        local tracerGui = Instance.new("BillboardGui")
        tracerGui.Size = UDim2.new(0, 4, 0, 200)
        tracerGui.StudsOffset = Vector3.new(0, 0, 0)
        tracerGui.AlwaysOnTop = true
        tracerGui.Parent = espGroup

        local tracerFrame = Instance.new("Frame")
        tracerFrame.Size = UDim2.new(1, 0, 1, 0)
        tracerFrame.Position = UDim2.new(0, 0, 1, 0)
        tracerFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        tracerFrame.BackgroundTransparency = 0.3
        tracerFrame.Parent = tracerGui
    end

    -- Player Info
    if Config.Info_Display then
        local infoGui = Instance.new("BillboardGui")
        infoGui.Size = UDim2.new(0, 120, 0, 20)
        infoGui.StudsOffset = Vector3.new(0, 3.8, 0)
        infoGui.AlwaysOnTop = true
        infoGui.Parent = espGroup

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 11
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = infoGui
        
        -- 거리 표시 (선택)
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 1, 0)
        distLabel.Position = UDim2.new(0, 0, 1, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = ""
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 9
        distLabel.Font = Enum.Font.Gotham
        distLabel.Parent = infoGui
        
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            Heartbeat:Connect(function()
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
                pcall(function() CreateESP(player) end)
            end
        end
    end
end

-- ESP 플레이어 이벤트
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

-- ============================================================
-- 5. CHAMS (Color/Transparency 직접 변경)
-- ============================================================
local Chams = {Objects = {}, Connections = {}}

local function UpdateChams()
    -- 기존 Chams 정리
    for player, data in pairs(Chams.Objects) do
        pcall(function()
            for _, part in pairs(data.Parts) do
                if part and part.Parent then
                    part.Color = data.OriginalColors[part] or part.Color
                    part.Transparency = data.OriginalTransparency[part] or part.Transparency
                end
            end
        end)
    end
    for _, conn in pairs(Chams.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Chams.Objects = {}
    Chams.Connections = {}
    
    if not Config.Chams_Enabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local char = GetCharacter(player)
            if char then
                local data = {Parts = {}, OriginalColors = {}, OriginalTransparency = {}}
                
                -- Character의 모든 BasePart 색상 변경
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        data.OriginalColors[part] = part.Color
                        data.OriginalTransparency[part] = part.Transparency
                        part.Color = Color3.fromRGB(255, 0, 0)
                        part.Transparency = 0.3
                        table.insert(data.Parts, part)
                    end
                end
                
                Chams.Objects[player] = data
            end
        end
    end
end

-- ============================================================
-- 6. INFINITE JUMP (강제 점프)
-- ============================================================
local InfiniteJumpConnection = nil

local function SetupInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end

    if not Config.Infinite_Jump then return end

    InfiniteJumpConnection = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            local humanoid = GetMyHumanoid()
            local root = GetMyRoot()
            if humanoid and humanoid.Parent then
                humanoid.Jump = true
                pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end)
                if root then
                    root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
                end
            end
        end
    end)
end

-- ============================================================
-- 7. FLY MODE (Velocity 직접 조작 - 범용)
-- ============================================================
local Fly = {Flying = false, Connection = nil}

local function ToggleFly(state)
    Config.Fly_Mode = state
    
    if state then
        Fly.Flying = true
        local humanoid = GetMyHumanoid()
        if humanoid then 
            humanoid.PlatformStand = true
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end)
        end

        if Fly.Connection then Fly.Connection:Disconnect() end
        
        Fly.Connection = Heartbeat:Connect(function()
            if not Fly.Flying or not Config.Fly_Mode then return end

            local root = GetMyRoot()
            if not root then return end

            local speed = Config.Fly_Speed or 80
            local moveDir = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then 
                moveDir = moveDir + Workspace.CurrentCamera.CFrame.LookVector 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then 
                moveDir = moveDir - Workspace.CurrentCamera.CFrame.LookVector 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then 
                moveDir = moveDir - Workspace.CurrentCamera.CFrame.RightVector 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then 
                moveDir = moveDir + Workspace.CurrentCamera.CFrame.RightVector 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then 
                moveDir = moveDir + Vector3.new(0, 1, 0) 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
                moveDir = moveDir - Vector3.new(0, 1, 0) 
            end

            if moveDir.Magnitude > 0 then
                root.Velocity = moveDir.Unit * speed
            else
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        Fly.Flying = false
        if Fly.Connection then
            Fly.Connection:Disconnect()
            Fly.Connection = nil
        end
        local humanoid = GetMyHumanoid()
        if humanoid then 
            humanoid.PlatformStand = false
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            end)
        end
    end
end

-- ============================================================
-- 8. NOCLIP (Stepped로 강제 적용 - 범용)
-- ============================================================
local NoclipConnection = nil

local function ToggleNoclip(state)
    Config.Noclip = state

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if not state then return end

    NoclipConnection = Stepped:Connect(function()
        if not Config.Noclip then return end
        local char = GetMyCharacter()
        if not char then return end
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

-- ============================================================
-- 9. SPEED HACK
-- ============================================================
local SpeedHack = {OriginalSpeed = 16}

local function SetupSpeedHack()
    local humanoid = GetMyHumanoid()
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

-- ============================================================
-- 10. SKYBOX
-- ============================================================
local function ToggleSkybox(state)
    Config.Skybox_Mode = state
    if state then
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then sky = Instance.new("Sky"); sky.Parent = Lighting end
        local id = Config.Custom_Sky_Id or "600835154"
        local asset = "rbxassetid://" .. tostring(id)
        sky.SkyboxBk = asset; sky.SkyboxDn = asset; sky.SkyboxFt = asset
        sky.SkyboxLf = asset; sky.SkyboxRt = asset; sky.SkyboxUp = asset
        
        -- Atmosphere 추가 (선택)
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atmosphere then atmosphere = Instance.new("Atmosphere"); atmosphere.Parent = Lighting end
        atmosphere.Density = 0.3
        atmosphere.Offset = 0.1
        atmosphere.Color = Color3.fromRGB(255, 200, 150)
        atmosphere.Decay = Color3.fromRGB(100, 80, 150)
    else
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if sky then sky:Destroy() end
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then atmosphere:Destroy() end
    end
end

-- ============================================================
-- 11. DEATH AUDIO (Health 변화 감지)
-- ============================================================
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

-- Health 변화 감지로 사망 감지
local DeathAudioConnection = nil
local function SetupDeathAudio()
    if DeathAudioConnection then
        DeathAudioConnection:Disconnect()
        DeathAudioConnection = nil
    end
    
    if not Config.Death_Audio then return end
    
    local humanoid = GetMyHumanoid()
    if not humanoid then return end
    
    local lastHealth = humanoid.Health
    DeathAudioConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health <= 0 and lastHealth > 0 then
            PlayDeathAudio()
        end
        lastHealth = humanoid.Health
    end)
end

-- ============================================================
-- 12. RAINBOW CURSOR (gethui() 우회 - 범용)
-- ============================================================
local RainbowCursor = {Connection = nil, Crosshair = nil, Hue = 0}

local function CreateCrosshair()
    if RainbowCursor.Crosshair then
        pcall(function() RainbowCursor.Crosshair:Destroy() end)
        RainbowCursor.Crosshair = nil
    end

    -- gethui()가 있으면 사용, 없으면 CoreGui 또는 PlayerGui
    local parent = nil
    pcall(function()
        parent = gethui and gethui()
    end)
    if not parent then
        parent = CoreGui
    end
    if not parent or not parent.Parent then
        parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RainbowCrosshair"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = parent

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
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = 0.2
        line.ZIndex = 10000
        line.Parent = center
        return line
    end

    makeLine(Vector2.new(0.5, 1), UDim2.new(0.5, 0, 0.5, -gap), UDim2.new(0, thickness, 0, length))
    makeLine(Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0.5, gap), UDim2.new(0, thickness, 0, length))
    makeLine(Vector2.new(1, 0.5), UDim2.new(0.5, -gap, 0.5, 0), UDim2.new(0, length, 0, thickness))
    makeLine(Vector2.new(0, 0.5), UDim2.new(0.5, gap, 0.5, 0), UDim2.new(0, length, 0, thickness))

    RainbowCursor.Crosshair = screenGui
    return center
end

local function SetupRainbowCursor()
    if Config.Interactive_Cursor then
        local center = CreateCrosshair()
        if not center then return end
        
        if RainbowCursor.Connection then RainbowCursor.Connection:Disconnect() end
        
        RainbowCursor.Connection = Heartbeat:Connect(function()
            if not Config.Interactive_Cursor then return end
            if not RainbowCursor.Crosshair or not RainbowCursor.Crosshair.Parent then
                if RainbowCursor.Connection then
                    RainbowCursor.Connection:Disconnect()
                    RainbowCursor.Connection = nil
                end
                return
            end
            
            RainbowCursor.Hue = (RainbowCursor.Hue + 0.01) % 1
            local color = Color3.fromHSV(RainbowCursor.Hue, 1, 1)
            
            if center and center.Parent then
                for _, child in ipairs(center:GetChildren()) do
                    if child:IsA("Frame") then
                        child.BackgroundColor3 = color
                        child.BackgroundTransparency = 0.1
                    end
                end
                center.Rotation = (center.Rotation + 1.5) % 360
            end
        end)
    else
        if RainbowCursor.Connection then
            RainbowCursor.Connection:Disconnect()
            RainbowCursor.Connection = nil
        end
        if RainbowCursor.Crosshair then
            pcall(function() RainbowCursor.Crosshair:Destroy() end)
            RainbowCursor.Crosshair = nil
        end
    end
end

-- ============================================================
-- 13. FPS UNLOCKER
-- ============================================================
local function SetupFPSUnlocker(state)
    Config.FPS_Opt = state
    pcall(function()
        if setfpscap then setfpscap(state and 120 or 60) end
    end)
end

-- ============================================================
-- 14. THIRD PERSON (CFrame 직접 조작 - 범용)
-- ============================================================
local ThirdPerson = {Connection = nil}

local function ToggleThirdPerson(state)
    Config.Third_Person = state
    
    if ThirdPerson.Connection then
        ThirdPerson.Connection:Disconnect()
        ThirdPerson.Connection = nil
    end
    
    if not state then return end
    
    ThirdPerson.Connection = RenderStepped:Connect(function()
        if not Config.Third_Person then return end
        
        local root = GetMyRoot()
        if not root then return end
        
        local camera = Workspace.CurrentCamera
        if not camera then return end
        
        local offset = Vector3.new(0, 5, 15)
        local targetPos = root.Position + offset
        camera.CFrame = CFrame.new(targetPos, root.Position)
    end)
end

-- ============================================================
-- 15. DEVICE SPOOF
-- ============================================================
local function ToggleSpoof(state)
    Config.Device_Spoof = state
    pcall(function()
        GuiService:SetEmotesVisible(state)
    end)
end

-- ============================================================
-- 16. ANTI-AIM (매 프레임 강제 적용 - 범용)
-- ============================================================
local AntiAim = {Connection = nil}

local function SetupAntiAim(state)
    Config.Anti_Aim = state
    
    if AntiAim.Connection then
        AntiAim.Connection:Disconnect()
        AntiAim.Connection = nil
    end
    
    if not state then return end
    
    AntiAim.Connection = Heartbeat:Connect(function()
        if not Config.Anti_Aim then return end
        local char = GetMyCharacter()
        if not char then return end
        local head = char:FindFirstChild("Head")
        if head then
            head.CFrame = head.CFrame * CFrame.Angles(0, math.rad(180), 0)
        end
    end)
end

-- ============================================================
-- 17. FOV CIRCLE
-- ============================================================
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

-- ============================================================
-- MAIN UPDATE
-- ============================================================
local function UpdateAllFeatures()
    pcall(function()
        if Config.Aimbot then PerformAimbot() end
        if Config.Ragebot then PerformRagebot() end
        if Config.Triggerbot then PerformTriggerbot() end
    end)
end

Heartbeat:Connect(UpdateAllFeatures)

-- ============================================================
-- CONFIG METATABLE (안전하게)
-- ============================================================
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
                    SetupSpeedHack()
                elseif key == "Infinite_Jump" then
                    SetupInfiniteJump()
                elseif key == "Death_Audio" then
                    SetupDeathAudio()
                elseif key == "Show_FOV" or key == "Aimbot_FOV" then
                    UpdateFOVCircle()
                end
            end)
        end
    }
    setmetatable(Config, configMetatable)
end

-- ============================================================
-- CHARACTER ADDED / RESPAWN 이벤트
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    pcall(function()
        if Config.Noclip then ToggleNoclip(true) end
        if Config.Speed_Hack then SetupSpeedHack() end
        if Config.Fly_Mode then ToggleFly(true) end
        if Config.Infinite_Jump then SetupInfiniteJump() end
        if Config.Anti_Aim then SetupAntiAim(true) end
        if Config.ESP_Master then UpdateESP() end
        if Config.Chams_Enabled then UpdateChams() end
        if Config.Death_Audio then SetupDeathAudio() end
    end)
end)

-- ============================================================
-- INITIALIZATION
-- ============================================================
task.spawn(function()
    wait(1)
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
        if Config.Death_Audio then SetupDeathAudio() end
    end)
end)

-- ============================================================
-- CLEANUP
-- ============================================================
local function Cleanup()
    pcall(function()
        if RainbowCursor.Connection then RainbowCursor.Connection:Disconnect() end
        if RainbowCursor.Crosshair then RainbowCursor.Crosshair:Destroy() end
        if Ragebot.Connection then Ragebot.Connection:Disconnect() end
        if FOVCircle then FOVCircle:Destroy() end
        if NoclipConnection then NoclipConnection:Disconnect() end
        if Fly.Connection then Fly.Connection:Disconnect() end
        if AntiAim.Connection then AntiAim.Connection:Disconnect() end
        if ThirdPerson.Connection then ThirdPerson.Connection:Disconnect() end
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        if DeathAudioConnection then DeathAudioConnection:Disconnect() end
        
        for player, obj in pairs(ESP.Objects) do
            pcall(function() obj:Destroy() end)
        end
        for player, data in pairs(Chams.Objects) do
            pcall(function()
                for _, part in pairs(data.Parts) do
                    if part and part.Parent then
                        part.Color = data.OriginalColors[part] or part.Color
                        part.Transparency = data.OriginalTransparency[part] or part.Transparency
                    end
                end
            end)
        end
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
