loadstring(game:HttpGet("https://raw.githubusercontent.com/cjwstar25-pngWJNof9r29jk1oi23134/refs/heads/main/Bypass.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
local ESP_Drawings = {}

local function GetCharacterParts(player)
    local char = player.Character
    if not char then return nil end
    return {
        Root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"),
        Head = char:FindFirstChild("Head"),
        Humanoid = char:FindFirstChildOfClass("Humanoid"),
        UpperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
        LeftArm = char:FindFirstChild("LeftHand") or char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"),
        RightArm = char:FindFirstChild("RightHand") or char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"),
        LeftLeg = char:FindFirstChild("LeftFoot") or char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"),
        RightLeg = char:FindFirstChild("RightFoot") or char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
    }
end

local function CreateDrawing(drawingType, properties)
    local drawing = Drawing.new(drawingType)
    for prop, val in pairs(properties) do drawing[prop] = val end
    return drawing
end

local function InitESPForPlayer(player)
    if player == LocalPlayer then return end
    local espData = {
        Box = CreateDrawing("Square", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255), Filled = false}),
        BoxOutline = CreateDrawing("Square", {Visible = false, Thickness = 3, Color = Color3.fromRGB(0, 0, 0), Filled = false}),
        Tracer = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
        Name = CreateDrawing("Text", {Visible = false, Size = 13, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255)}),
        HealthBarOutline = CreateDrawing("Line", {Visible = false, Thickness = 3, Color = Color3.fromRGB(0, 0, 0)}),
        HealthBar = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(0, 255, 0)}),
        SkeletonLines = {}
    }
    for i = 1, 6 do table.insert(espData.SkeletonLines, CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)})) end
    ESP_Drawings[player] = espData
end

for _, p in ipairs(Players:GetPlayers()) do InitESPForPlayer(p) end
Players.PlayerAdded:Connect(InitESPForPlayer)
Players.PlayerRemoving:Connect(function(player)
    if ESP_Drawings[player] then
        for _, obj in pairs(ESP_Drawings[player]) do
            if type(obj) == "table" then for _, line in ipairs(obj) do pcall(function() line:Remove() end) end
            else pcall(function() obj:Remove() end) end
        end
        ESP_Drawings[player] = nil
    end
end)

local function HookPlayerDeath(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        local torso = char:WaitForChild("HumanoidRootPart", 5) or char:WaitForChild("Head", 5)
        if hum and torso then
            hum.Died:Connect(function()
                if Config.Death_Audio and torso then
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://" .. tostring(Config.Death_Audio_Id)
                    sound.Volume = 5
                    sound.Parent = torso
                    sound:Play()
                    task.delay(5, function() if sound then sound:Destroy() end end)
                end
            end)
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do HookPlayerDeath(p) end
Players.PlayerAdded:Connect(HookPlayerDeath)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space and Config.Infinite_Jump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

local function IsSameTeam(player)
    if not Config.Team_Filter then return false end
    if player.Team and LocalPlayer.Team then return player.Team == LocalPlayer.Team end
    if player.TeamColor and LocalPlayer.TeamColor then return player.TeamColor == LocalPlayer.TeamColor end
    return false
end

local function GetClosestTarget()
    local closestTarget = nil
    local shortestDist = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not IsSameTeam(p) then
            local parts = GetCharacterParts(p)
            if parts and parts.Humanoid and parts.Humanoid.Health > 0 and parts.Root then
                local targetPart = (Config.Hitbox == "Torso" and parts.UpperTorso) or parts.Head
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDist then shortestDist = dist closestTarget = targetPart end
                    end
                end
            end
        end
    end
    return closestTarget
end

local function IsVisible(targetPart)
    if not Config.Wall_Check then return true end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return false end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = RaycastParams.FilterType.Exclude
    raycastParams.FilterDescendantsInstances = {char, targetPart.Parent}
    raycastParams.IgnoreWater = true
    local result = Workspace:Raycast(char.Head.Position, targetPart.Position - char.Head.Position, raycastParams)
    return result == nil
end

RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if Config.Third_Person then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 25
            LocalPlayer.CameraMinZoomDistance = 10
        end

        if Config.FPS_Opt then pcall(function() if setfpscap then setfpscap(120) end end) end

        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")

            if humanoid then humanoid.WalkSpeed = Config.Speed_Hack and (tonumber(Config.Speed_Val) or 40) or 16 end

            if Config.Noclip then
                for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
            end

            if Config.Anti_Aim and upperTorso and hrp then
                local camCF = Camera.CFrame
                local flatLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
                if flatLook.Magnitude > 0 then
                    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.atan2(-flatLook.X, -flatLook.Z), 0)
                    upperTorso.CFrame = upperTorso.CFrame * CFrame.Angles(math.rad(180), 0, 0)
                end
            end

            if Config.Fly_Mode then
                if hrp and not hrp:FindFirstChild("UnifiedFlyVel") then
                    local bv = Instance.new("BodyVelocity", hrp) bv.Name = "UnifiedFlyVel" bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    local bg = Instance.new("BodyGyro", hrp) bg.Name = "UnifiedFlyGyro" bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                elseif hrp then
                    local bv, bg = hrp:FindFirstChild("UnifiedFlyVel"), hrp:FindFirstChild("UnifiedFlyGyro")
                    if bv and bg then
                        local camCF = Camera.CFrame
                        local moveDir = Vector3.new(0, 0, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                        bv.Velocity = moveDir * (tonumber(Config.Fly_Speed) or 80)
                        bg.CFrame = camCF
                    end
                    if humanoid then humanoid.PlatformStand = true end
                end
            else
                if hrp then
                    if hrp:FindFirstChild("UnifiedFlyVel") then hrp.UnifiedFlyVel:Destroy() end
                    if hrp:FindFirstChild("UnifiedFlyGyro") then hrp.UnifiedFlyGyro:Destroy() end
                end
                if humanoid then humanoid.PlatformStand = false end
            end
        end

        local target = GetClosestTarget()
        if target and (Config.Aimbot or Config.Ragebot) then
            if not Config.Wall_Check or IsVisible(target) then
                if Config.Aimbot then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 1 / math.clamp(Config.Aimbot_Smooth, 1, 10))
                elseif Config.Ragebot then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                end
            end
        end

        if Config.Triggerbot and target and IsVisible(target) then pcall(function() mouse1click() end) end

        for player, esp in pairs(ESP_Drawings) do
            local parts = GetCharacterParts(player)
            local showESP = Config.ESP_Master and parts and parts.Root and parts.Humanoid and parts.Humanoid.Health > 0
            if showESP and IsSameTeam(player) then showESP = false end

            if showESP then
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(parts.Root.Position)
                if rootOnScreen then
                    local headPos = Camera:WorldToViewportPoint(parts.Head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(parts.Root.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2

                    if Config.Box_ESP then
                        esp.BoxOutline.Size = Vector2.new(width, height) esp.BoxOutline.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2) esp.BoxOutline.Visible = true
                        esp.Box.Size = Vector2.new(width, height) esp.Box.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2) esp.Box.Visible = true
                    else
                        esp.Box.Visible = false esp.BoxOutline.Visible = false
                    end

                    if Config.Health_Bar then
                        local hpPct = parts.Humanoid.Health / parts.Humanoid.MaxHealth
                        local barH = height * hpPct
                        esp.HealthBarOutline.From = Vector2.new(rootPos.X - width / 2 - 6, rootPos.Y - height / 2)
                        esp.HealthBarOutline.To = Vector2.new(rootPos.X - width / 2 - 6, rootPos.Y + height / 2)
                        esp.HealthBarOutline.Visible = true
                        esp.HealthBar.From = Vector2.new(rootPos.X - width / 2 - 6, rootPos.Y + height / 2 - barH)
                        esp.HealthBar.To = Vector2.new(rootPos.X - width / 2 - 6, rootPos.Y + height / 2)
                        esp.HealthBar.Color = Color3.fromRGB(255 * (1 - hpPct), 255 * hpPct, 0)
                        esp.HealthBar.Visible = true
                    else
                        esp.HealthBar.Visible = false esp.HealthBarOutline.Visible = false
                    end

                    if Config.Info_Display then
                        esp.Name.Text = player.Name .. " [" .. math.floor(parts.Humanoid.Health) .. "HP]"
                        esp.Name.Position = Vector2.new(rootPos.X, rootPos.Y - height / 2 - 18)
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end

                    if Config.Tracer_Lines then
                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y + height / 2)
                        esp.Tracer.Visible = true
                    else
                        esp.Tracer.Visible = false
                    end

                    if Config.Skeleton_ESP and parts.Head and parts.UpperTorso and parts.LeftArm and parts.RightArm and parts.LeftLeg and parts.RightLeg then
                        local joints = {
                            {parts.Head.Position, parts.UpperTorso.Position}, {parts.UpperTorso.Position, parts.LeftArm.Position},
                            {parts.UpperTorso.Position, parts.RightArm.Position}, {parts.UpperTorso.Position, parts.Root.Position},
                            {parts.Root.Position, parts.LeftLeg.Position}, {parts.Root.Position, parts.RightLeg.Position}
                        }
                        for i, joint in ipairs(joints) do
                            local p1, on1 = Camera:WorldToViewportPoint(joint[1])
                            local p2, on2 = Camera:WorldToViewportPoint(joint[2])
                            if on1 and on2 then
                                esp.SkeletonLines[i].From = Vector2.new(p1.X, p1.Y)
                                esp.SkeletonLines[i].To = Vector2.new(p2.X, p2.Y)
                                esp.SkeletonLines[i].Visible = true
                            else
                                esp.SkeletonLines[i].Visible = false
                            end
                        end
                    else
                        for _, line in ipairs(esp.SkeletonLines) do line.Visible = false end
                    end

                    if Config.Chams_Enabled then
                        local hl = player.Character:FindFirstChildOfClass("Highlight")
                        if not hl then hl = Instance.new("Highlight", player.Character) hl.FillColor = Color3.fromRGB(255, 0, 0) hl.OutlineColor = Color3.fromRGB(255, 255, 255) end
                    else
                        local hl = player.Character:FindFirstChildOfClass("Highlight")
                        if hl then hl:Destroy() end
                    end
                else
                    esp.Box.Visible = false esp.BoxOutline.Visible = false esp.Tracer.Visible = false esp.Name.Visible = false esp.HealthBar.Visible = false esp.HealthBarOutline.Visible = false
                    for _, line in ipairs(esp.SkeletonLines) do line.Visible = false end
                end
            else
                esp.Box.Visible = false esp.BoxOutline.Visible = false esp.Tracer.Visible = false esp.Name.Visible = false esp.HealthBar.Visible = false esp.HealthBarOutline.Visible = false
                for _, line in ipairs(esp.SkeletonLines) do line.Visible = false end
            end
        end
    end)
end)
