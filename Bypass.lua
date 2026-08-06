local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiCheatNotificationGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(0, 320, 0, 80)
notificationFrame.Position = UDim2.new(1, 400, 1, -100)
notificationFrame.AnchorPoint = Vector2.new(0, 0)
notificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
notificationFrame.BorderSizePixel = 0
notificationFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = notificationFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(60, 60, 70)
uiStroke.Thickness = 1.5
uiStroke.Parent = notificationFrame

local accentBar = Instance.new("Frame")
accentBar.Name = "AccentBar"
accentBar.Size = UDim2.new(0, 4, 1, 0)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(230, 70, 70)
accentBar.BorderSizePixel = 0
accentBar.Parent = notificationFrame

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 4)
accentCorner.Parent = accentBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -30, 0, 24)
titleLabel.Position = UDim2.new(0, 16, 0, 14)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Anti Cheat Detected ⛔"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = notificationFrame

local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Size = UDim2.new(1, -30, 0, 20)
descLabel.Position = UDim2.new(0, 16, 0, 42)
descLabel.BackgroundTransparency = 1
descLabel.Font = Enum.Font.GothamMedium
descLabel.Text = "안티치트가 감지됨"
descLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
descLabel.TextSize = 13
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.Parent = notificationFrame

local function showNotification(titleText, descText, accentColor)
	titleLabel.Text = titleText
	descLabel.Text = descText
	accentBar.BackgroundColor3 = accentColor
	
	local showTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
	local showTween = TweenService:Create(notificationFrame, showTweenInfo, {
		Position = UDim2.new(1, -340, 1, -100)
	})
	showTween:Play()
end

local function updateNotification(titleText, descText, accentColor)
	local fadeOutInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeOutTitle = TweenService:Create(titleLabel, fadeOutInfo, {TextTransparency = 1})
	local fadeOutDesc = TweenService:Create(descLabel, fadeOutInfo, {TextTransparency = 1})
	
	fadeOutTitle:Play()
	fadeOutDesc:Play()
	
	fadeOutTitle.Completed:Connect(function()
		titleLabel.Text = titleText
		descLabel.Text = descText
		accentBar.BackgroundColor3 = accentColor
		
		local fadeInInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local fadeInTitle = TweenService:Create(titleLabel, fadeInInfo, {TextTransparency = 0})
		local fadeInDesc = TweenService:Create(descLabel, fadeInInfo, {TextTransparency = 0})
		
		fadeInTitle:Play()
		fadeInDesc:Play()
	end)
end

local function executeAdvancedBypass()
	local successFlag = false
	
	local function bypassMetatable()
		pcall(function()
			local mt = getrawmetatable(game)
			setreadonly(mt, false)
			local oldIndex = mt.__index
			local oldNamecall = mt.__namecall
			
			mt.__index = newcclosure(function(self, k)
				if tostring(k):lower():match("kick") or tostring(k):lower():match("ban") then
					return function() end
				end
				return oldIndex(self, k)
			end)
			
			mt.__namecall = newcclosure(function(self, ...)
				local method = getnamecallmethod():lower()
				if method == "kick" or method == "raisenerror" then
					return
				end
				return oldNamecall(self, ...)
			end)
			
			setreadonly(mt, true)
		end)
	end
	
	local function bypassGarbageCollection()
		pcall(function()
			for _, obj in ipairs(getgc(true)) do
				if typeof(obj) == "function" then
					local info = debug.getinfo(obj)
					if info and info.name then
						local name = info.name:lower()
						if name:match("anticheat") or name:match("detect") or name:match("integrity") or name:match("check") then
							pcall(function()
								hookfunction(obj, function() return true end)
							end)
						end
					end
				elseif typeof(obj) == "table" then
					pcall(function()
						if rawget(obj, "Kick") then rawset(obj, "Kick", function() end) end
						if rawget(obj, "Ban") then rawset(obj, "Ban", function() end) end
						if rawget(obj, "Report") then rawset(obj, "Report", function() end) end
					end)
				end
			end
		end)
	end
	
	local function bypassNamecallAndHooks()
		pcall(function()
			if syn and syn.protect_gui then
				local gui = Instance.new("ScreenGui")
				syn.protect_gui(gui)
			end
			
			local mt = getrawmetatable(game)
			setreadonly(mt, false)
			local oldNc = mt.__namecall
			mt.__namecall = newcclosure(function(self, ...)
				local method = getnamecallmethod()
				local args = {...}
				if method == "FireServer" and self.Name:lower():match("analytics") then
					return
				end
				return oldNc(self, unpack(args))
			end)
			setreadonly(mt, true)
		end)
	end
	
	pcall(function()
		bypassMetatable()
		bypassGarbageCollection()
		bypassNamecallAndHooks()
		successFlag = true
	end)
	
	return successFlag
end

local detectionTriggered = false

local function monitorAntiCheatTriggers()
	local lastPosition = rootPart.Position
	local heartbeatConnection
	
	heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
		if detectionTriggered then
			heartbeatConnection:Disconnect()
			return
		end
		
		local currentPosition = rootPart.Position
		local distance = (currentPosition - lastPosition).Magnitude
		local expectedMaxDistance = humanoid.WalkSpeed * dt * 2.5
		
		if distance > expectedMaxDistance and not humanoid.PlatformStand then
			detectionTriggered = true
			heartbeatConnection:Disconnect()
		end
		
		lastPosition = currentPosition
	end)
end

monitorAntiCheatTriggers()

task.spawn(function()
	while not detectionTriggered do
		task.wait(0.1)
	end
	
	showNotification("Anti Cheat Detected ⛔", "안티치트가 감지됨", Color3.fromRGB(230, 70, 70))
	
	task.wait(1.5)
	
	local bypassResult = executeAdvancedBypass()
	
	task.wait(1.5)
	
	if bypassResult then
		updateNotification("Bypass Successful! ✅", "우회 성공", Color3.fromRGB(70, 230, 130))
		
		task.wait(3)
		
		local hideTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
		local hideTween = TweenService:Create(notificationFrame, hideTweenInfo, {
			Position = UDim2.new(1, 400, 1, -100)
		})
		hideTween:Play()
		hideTween.Completed:Connect(function()
			screenGui:Destroy()
		end)
	else
		updateNotification("Bypass Failed ⛔", "우회 실패", Color3.fromRGB(230, 140, 70))
		
		task.wait(2)
		
		updateNotification("Error ⛔", "Bypass에 실패했습니다. 벤 가능성이 높아졌습니다.", Color3.fromRGB(230, 70, 70))
		
		task.wait(2)
		
		player:Kick("Bypass에 실패했습니다. 벤 가능성이 높아졌습니다.")
	end
end)
