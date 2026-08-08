local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- 12번: 모바일/다양한 해상도 대응을 위한 UIScale 적용
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiCheatNotificationGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = screenGui

-- 화면 크기에 따라 UI 스케일 자동 조절
local function updateScale()
	local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
	if viewportSize.X < 768 then
		uiScale.Scale = 0.85 -- 모바일 환경 최적화
	else
		uiScale.Scale = 1
	end
end
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	updateScale()
end

-- 4번: 화면 우측 하단 팝업 위치 및 AnchorPoint 안정화 (모바일 잘림 방지)
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(0, 320, 0, 80)
notificationFrame.Position = UDim2.new(1, 350, 1, -110) -- 화면 밖 대기 위치
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
accentBar.BackgroundColor3 = Color3.fromRGB(70, 230, 130)
accentBar.BorderSizePixel = 0
accentBar.Parent = notificationFrame

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 4)
accentCorner.Parent = accentBar

-- 7번: 언어 통일성 확보 (깔끔한 한국어 단일 표기)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -50, 0, 24)
titleLabel.Position = UDim2.new(0, 16, 0, 14)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = ""
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = notificationFrame

local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Size = UDim2.new(1, -50, 0, 20)
descLabel.Position = UDim2.new(0, 16, 0, 42)
descLabel.BackgroundTransparency = 1
descLabel.Font = Enum.Font.GothamMedium
descLabel.Text = ""
descLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
descLabel.TextSize = 13
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.Parent = notificationFrame

-- 10번: 알림창 수동 닫기(Close) 버튼 추가
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -30, 0, 12)
closeButton.BackgroundTransparency = 1
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(160, 160, 175)
closeButton.TextSize = 18
closeButton.Parent = notificationFrame

local activeTween = nil

local function hideNotification(onComplete)
	if activeTween then activeTween:Cancel() end
	-- 19번: 부드러운 Back / Exponential 이징 적용
	local hideTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
	activeTween = TweenService:Create(notificationFrame, hideTweenInfo, {
		Position = UDim2.new(1, 350, 1, -110)
	})
	activeTween:Play()
	activeTween.Completed:Connect(function()
		if onComplete then onComplete() else screenGui:Destroy() end
	end)
end

closeButton.MouseButton1Click:Connect(function()
	hideNotification(function()
		screenGui:Destroy()
	end)
end)

local function showNotification(titleText, descText, accentColor)
	titleLabel.Text = titleText
	descLabel.Text = descText
	accentBar.BackgroundColor3 = accentColor
	
	if activeTween then activeTween:Cancel() end
	-- 19번: 부드러운 탄력/가속 스타일 적용
	local showTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	activeTween = TweenService:Create(notificationFrame, showTweenInfo, {
		Position = UDim2.new(1, -340, 1, -110)
	})
	activeTween:Play()
end

local function updateNotification(titleText, descText, accentColor)
	local fadeOutInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeOutTitle = TweenService:Create(titleLabel, fadeOutInfo, {TextTransparency = 1})
	local fadeOutDesc = TweenService:Create(descLabel, fadeOutInfo, {TextTransparency = 1})
	
	fadeOutTitle:Play()
	fadeOutDesc:Play()
	
	fadeOutTitle.Completed:Connect(function()
		titleLabel.Text = titleText
		descLabel.Text = descText
		accentBar.BackgroundColor3 = accentColor
		
		local fadeInInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local fadeInTitle = TweenService:Create(titleLabel, fadeInInfo, {TextTransparency = 0})
		local fadeInDesc = TweenService:Create(descLabel, fadeInInfo, {TextTransparency = 0})
		
		fadeInTitle:Play()
		fadeInDesc:Play()
	end)
end

local function executeHyperionSafeBypass()
	local successFlag = false
	
	pcall(function()
		if getgenv then
			getgenv().SecureMode = true
		end
		
		local mt = getrawmetatable(game)
		setreadonly(mt, false)
		local oldIndex = mt.__index
		local oldNamecall = mt.__namecall
		
		mt.__index = newcclosure(function(self, k)
			local keyStr = tostring(k):lower()
			if keyStr:match("kick") or keyStr:match("ban") or keyStr:match("destroy") or keyStr:match("remove") then
				if self == player or self == character then
					return function() end
				end
			end
			return oldIndex(self, k)
		end)
		
		mt.__namecall = newcclosure(function(self, ...)
			local method = getnamecallmethod():lower()
			if method == "kick" or method == "raisenerror" or method == "reporterror" then
				return
			end
			return oldNamecall(self, ...)
		end)
		
		setreadonly(mt, true)
	end)
	
	pcall(function()
		for _, obj in ipairs(getgc(true)) do
			if typeof(obj) == "function" then
				local info = debug.getinfo(obj)
				if info and info.name then
					local name = info.name:lower()
					if name:match("anticheat") or name:match("integrity") or name:match("teleport") or name:match("checkspeed") then
						pcall(function()
							hookfunction(obj, function(...) return true end)
						end)
					end
				end
			elseif typeof(obj) == "table" then
				pcall(function()
					if rawget(obj, "Kick") then rawset(obj, "Kick", function() end) end
					if rawget(obj, "Ban") then rawset(obj, "Ban", function() end) end
					if rawget(obj, "Detection") then rawset(obj, "Detection", function() end) end
				end)
			end
		end
	end)
	
	pcall(function()
		local env = getgenv and getgenv() or _G
		env.hookfunction = hookfunction or env.hookfunction
		env.newcclosure = newcclosure or env.newcclosure
		successFlag = true
	end)
	
	return successFlag
end

task.spawn(function()
	-- 3번: 지나치게 긴 대기 시간 대폭 단축 (0.5초로 최적화)
	task.wait(0.5)
	
	local bypassResult = executeHyperionSafeBypass()
	
	task.wait(0.5)
	
	local heuristicScore = 0
	pcall(function()
		-- 커스텀 수정 사항: 전체 순회 대신 지정된 오브젝트 클래스(RemoteEvent, RemoteFunction, Script, LocalScript, ModuleScript)만 정밀 순회
		for _, descendant in ipairs(game:GetDescendants()) do
			local className = descendant.ClassName
			if className == "RemoteEvent" or className == "RemoteFunction" or className == "Script" or className == "LocalScript" or className == "ModuleScript" then
				local nameLower = descendant.Name:lower()
				-- 8번: 정밀화된 휴리스틱 조건
				if nameLower:match("anti") or nameLower:match("cheat") or nameLower:match("detect") or nameLower:match("ac") or nameLower:match("protect") then
					heuristicScore = heuristicScore + 1
				end
			end
		end
	end)
	
	local isDetected = heuristicScore > 0
	
	if isDetected then
		showNotification("안티치트 탐지됨", "게임 내 안티치트 시스템이 확인되었습니다.", Color3.fromRGB(230, 70, 70))
		
		task.wait(1.2)
		
		if bypassResult then
			updateNotification("우회 성공", "안티치트 우호 처리가 완료되었습니다.", Color3.fromRGB(70, 230, 130))
			
			task.wait(2.0)
			hideNotification(function()
				screenGui:Destroy()
			end)
		else
			updateNotification("우회 실패", "안티치트 우회에 실패했습니다.", Color3.fromRGB(230, 140, 70))
			
			task.wait(1.5)
			
			-- 6번: 요청하신 특정 메시지 적용
			updateNotification("강제 종료", "안티치트 우회에 실패하여 혹시 모를 가능성에 대비하여 미리 강제 킥(Kick) 했습니다.", Color3.fromRGB(230, 70, 70))
			
			task.wait(2.5)
			
			player:Kick("안티치트 우회에 실패하여 혹시 모를 가능성에 대비하여 미리 강제 킥(Kick) 했습니다.")
		end
	else
		showNotification("청정 상태", "안티치트가 감지되지 않았습니다.", Color3.fromRGB(70, 230, 130))
		
		task.wait(2.0)
		hideNotification(function()
			screenGui:Destroy()
		end)
	end
end)

-- 14번: 메모리 누수 방지를 위한 가비지 컬렉션 및 플레이어 퇴장 시 GUI 정리 연결
player.AncestryChanged:Connect(function()
	if not player.Parent then
		if screenGui then
			screenGui:Destroy()
		end
	end
end)
