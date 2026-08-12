loadstring(game:HttpGet("https://raw.githubusercontent.com/cjwstar25-png/WJNof9r29jk1oi23134/refs/heads/main/Bypass.lua"))()

--!nocheck

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().SharedConfig = getgenv().SharedConfig or {
    -- Combat
    Aimbot = false,
    Aimbot_Smooth = 2,
    Aimbot_FOV = 150,
    Show_FOV = true,
    Hitbox = "Head",
    Silent_Aim = false,   -- 사일런트 에임 (좌클릭 시 즉시 스냅)
    Ragebot = false,      -- 자동 조준 + 자동 발사
    Triggerbot = false,
    Anti_Aim = false,
    -- Visuals
    ESP_Master = false,
    Box_ESP = false,
    Health_Bar = false,
    Info_Display = false,
    Team_Filter = false,
    Chams_Enabled = false,
    Tracert = false,
    -- Player
    Infinite_Jump = false,
    Fly_Mode = false,
    Fly_Speed = 80,
    Noclip = false,
    Speed_Hack = false,
    Speed_Val = 40,
    Third_Person = false,
    -- Misc
    Skybox_Mode = false,
    Custom_Sky_Id = "600835154",
    Death_Audio = false,
    Death_Audio_Id = "84615664978587",
    Interactive_Cursor = false,
    FPS_Opt = false,
    Device_Spoof = false,
}
local Config = getgenv().SharedConfig

-- ===== 타겟 획득 함수 =====
local function GetClosestPlayer()
    local target = nil
    local shortestDist = Config.Aimbot_FOV or 150
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if Config.Team_Filter and player.Team == LocalPlayer.Team then
                    continue
                end

                local hitPart = player.Character:FindFirstChild(Config.Hitbox or "Head") or player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = hitPart
                    end
                end
            end
        end
    end
    return target
end

-- ===== FOV 서클 (시각 표시용) =====
local FOVCircle = Drawing and Drawing.new("Circle")
if FOVCircle then
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Config.Aimbot_FOV or 150
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 86, 72)
    FOVCircle.Transparency = 0.8
end

-- ===== 메인 루프 (에임, 사일런트, 레이지, 트리거, 안티에임) =====
RunService.RenderStepped:Connect(function()
    -- FOV 서클 표시
    if FOVCircle and (Config.Aimbot or Config.Silent_Aim or Config.Ragebot) and Config.Show_FOV then
        FOVCircle.Visible = true
        FOVCircle.Radius = Config.Aimbot_FOV or 150
        FOVCircle.Position = UserInputService:GetMouseLocation()
    elseif FOVCircle then
        FOVCircle.Visible = false
    end

    local target = GetClosestPlayer()
    if not target then return end

    -- 1. 에임봇 (우클릭 시 부드럽게 조준)
    if Config.Aimbot and type(mousemoverel) == "function" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local smooth = math.clamp(Config.Aimbot_Smooth or 2, 1, 10)
            mousemoverel((targetPos.X - mousePos.X) / smooth, (targetPos.Y - mousePos.Y) / smooth)
        end
    end

    -- 2. 사일런트 에임 (좌클릭 시 즉시 타겟으로 스냅, 부드러움 없음)
    if Config.Silent_Aim and type(mousemoverel) == "function" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            mousemoverel(targetPos.X - mousePos.X, targetPos.Y - mousePos.Y)
        end
    end

    -- 3. 레이지봇 (자동 조준 + 자동 발사)
    if Config.Ragebot and type(mousemoverel) == "function" then
        local targetPos = Camera:WorldToViewportPoint(target.Position)
        local mousePos = UserInputService:GetMouseLocation()
        mousemoverel(targetPos.X - mousePos.X, targetPos.Y - mousePos.Y)
        if type(mouse1click) == "function" then
            mouse1click()
            task.wait(0.05)
        end
    end

    -- 4. 트리거봇 (조준선에 적이 있으면 자동 발사)
    if Config.Triggerbot then
        local mouse = LocalPlayer:GetMouse()
        local targetObj = mouse.Target
        if targetObj and targetObj.Parent then
            local char = targetObj.Parent
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and Players:GetPlayerFromCharacter(char) then
                local targetPlayer = Players:GetPlayerFromCharacter(char)
                if not (Config.Team_Filter and targetPlayer.Team == LocalPlayer.Team) then
                    if type(mouse1click) == "function" then
                        mouse1click()
                        task.wait(0.08)
                    end
                end
            end
        end
    end

    -- 5. 안티에임
    if Config.Anti_Aim then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end
    end
end)

-- ===== ESP (박스, 체력바, 정보) =====
local ESPCache = {}
local function RemoveESP(player)
    if ESPCache[player] then
        for _, drawing in pairs(ESPCache[player]) do
            pcall(function() drawing:Remove() end)
        end
        ESPCache[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if not Config.ESP_Master then
        for player, _ in pairs(ESPCache) do RemoveESP(player) end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            if char and hrp and humanoid and humanoid.Health > 0 then
                if Config.Team_Filter and player.Team == LocalPlayer.Team then
                    RemoveESP(player)
                    continue
                end

                if not ESPCache[player] then
                    ESPCache[player] = {
                        Box = Drawing and Drawing.new("Square"),
                        HealthBarBg = Drawing and Drawing.new("Line"),
                        HealthBar = Drawing and Drawing.new("Line"),
                        Info = Drawing and Drawing.new("Text")
                    }
                    if ESPCache[player].Box then
                        ESPCache[player].Box.Filled = false
                        ESPCache[player].Box.Thickness = 1.5
                    end
                    if ESPCache[player].Info then
                        ESPCache[player].Info.Size = 12
                        ESPCache[player].Info.Center = true
                        ESPCache[player].Info.Outline = true
                        ESPCache[player].Info.Color = Color3.fromRGB(255, 255, 255)
                    end
                end

                local esp = ESPCache[player]
                if not esp or not esp.Box then
                    RemoveESP(player)
                    continue
                end

                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local size = Vector3.new(2, 4, 0) * (Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y) / 2
                    local boxSize = Vector2.new(math.abs(size.X), math.abs(size.Y))
                    local boxPos = Vector2.new(pos.X - boxSize.X / 2, pos.Y - boxSize.Y / 2)

                    if Config.Box_ESP then
                        esp.Box.Visible = true
                        esp.Box.Size = boxSize
                        esp.Box.Position = boxPos
                        esp.Box.Color = (player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(220, 44, 38)
                    else
                        esp.Box.Visible = false
                    end

                    if Config.Health_Bar and esp.HealthBar and esp.HealthBarBg then
                        local hpRatio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local barX = boxPos.X - 6
                        local barY = boxPos.Y
                        local barHeight = boxSize.Y

                        esp.HealthBarBg.Visible = true
                        esp.HealthBarBg.From = Vector2.new(barX, barY)
                        esp.HealthBarBg.To = Vector2.new(barX, barY + barHeight)
                        esp.HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
                        esp.HealthBarBg.Thickness = 3

                        esp.HealthBar.Visible = true
                        esp.HealthBar.From = Vector2.new(barX, barY + barHeight)
                        esp.HealthBar.To = Vector2.new(barX, barY + (barHeight * (1 - hpRatio)))
                        esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                        esp.HealthBar.Thickness = 1.5
                    elseif esp.HealthBar and esp.HealthBarBg then
                        esp.HealthBar.Visible = false
                        esp.HealthBarBg.Visible = false
                    end

                    if Config.Info_Display and esp.Info then
                        esp.Info.Visible = true
                        esp.Info.Position = Vector2.new(pos.X, boxPos.Y - 18)
                        esp.Info.Text = string.format("%s [%dHP]", player.Name, math.floor(humanoid.Health))
                    elseif esp.Info then
                        esp.Info.Visible = false
                    end
                else
                    if esp.Box then esp.Box.Visible = false end
                    if esp.HealthBar then esp.HealthBar.Visible = false end
                    if esp.HealthBarBg then esp.HealthBarBg.Visible = false end
                    if esp.Info then esp.Info.Visible = false end
                end
            else
                RemoveESP(player)
            end
        end
    end
end)

-- ===== 챔스 (하이라이트) =====
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("CubicHighlight")
            if Config.Chams_Enabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "CubicHighlight"
                    highlight.Adornee = player.Character
                    highlight.FillColor = Color3.fromRGB(220, 44, 38)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.Parent = player.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- ===== 무한 점프 =====
UserInputService.JumpRequest:Connect(function()
    if Config.Infinite_Jump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ===== 비행, 노클립, 스피드핵, 3인칭 =====
local BodyVelocity, BodyGyro
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if not hrp or not humanoid then return end

    -- 노클립
    if Config.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 스피드핵
    if Config.Speed_Hack then
        humanoid.WalkSpeed = Config.Speed_Val or 40
    end

    -- 비행 모드
    if Config.Fly_Mode then
        if not BodyVelocity then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.Parent = hrp
        end
        if not BodyGyro then
            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.CFrame = Camera.CFrame
            BodyGyro.Parent = hrp
        end

        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end

        BodyVelocity.Velocity = moveDir * (Config.Fly_Speed or 80)
        BodyGyro.CFrame = Camera.CFrame
        humanoid.PlatformStand = true
    else
        if BodyVelocity then BodyVelocity:Destroy(); BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy(); BodyGyro = nil end
        if humanoid then humanoid.PlatformStand = false end
    end

    -- 3인칭 강제
    if Config.Third_Person then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 15
        LocalPlayer.CameraMinZoomDistance = 15
    end
end)

-- ===== 사망 오디오 =====
LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if Config.Death_Audio then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(Config.Death_Audio_Id)
            sound.Volume = 2
            sound.Parent = Workspace
            sound:Play()
            task.delay(5, function() sound:Destroy() end)
        end
    end)
end)

-- ===== 무지개 커서 =====
local CursorDrawing = Drawing and Drawing.new("Triangle")
if CursorDrawing then
    CursorDrawing.Visible = false
    CursorDrawing.Thickness = 1
    CursorDrawing.Filled = true
end

RunService.RenderStepped:Connect(function()
    if Config.Interactive_Cursor and CursorDrawing then
        CursorDrawing.Visible = true
        local mPos = UserInputService:GetMouseLocation()
        CursorDrawing.PointA = mPos
        CursorDrawing.PointB = mPos + Vector2.new(12, 18)
        CursorDrawing.PointC = mPos + Vector2.new(18, 12)
        CursorDrawing.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    elseif CursorDrawing then
        CursorDrawing.Visible = false
    end
end)

-- ===== FPS 최적화 =====
RunService.Heartbeat:Connect(function()
    if Config.FPS_Opt then
        if type(setfpscap) == "function" then setfpscap(999) end
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("Sky") then
                pcall(function() obj.Enabled = false end)
            end
        end
    end
end)

-- ===== 기기 스푸핑 =====
RunService.RenderStepped:Connect(function()
    if Config.Device_Spoof then
        pcall(function()
            if UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then end
        end)
    end
end)
