loadstring(game:HttpGet("https://raw.githubusercontent.com/cjwstar25-png/WJNof9r29jk1oi23134/refs/heads/main/Cubic.lua"))()

--!nocheck

----------------------------------------------------------------
-- CubicUltimateHub
-- Original UI structure preserved
--
-- IMPORTANT:
-- This is a UI-focused rewrite.
-- The original four-panel structure is preserved:
-- Combat / Visuals / Player / Misc
--
-- UI improvements:
-- • Strong black + red palette
-- • Larger panels
-- • Centered four-column layout
-- • Rounded but not overly soft
-- • Real draggable windows
-- • Better spacing / typography
-- • Better ON/OFF states
-- • Better sliders
-- • Better Properties popup
-- • English default
-- • RightShift toggles UI
-- • RightShift is consumed to avoid Shift Lock
-- • Mobile gets UI button
-- • PC gets keybind panel
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
-- THEME
----------------------------------------------------------------

local THEME = {
	Background = Color3.fromRGB(8, 7, 7),

	Panel = Color3.fromRGB(18, 12, 12),
	Panel2 = Color3.fromRGB(25, 14, 14),
	Panel3 = Color3.fromRGB(36, 18, 18),

	Header = Color3.fromRGB(220, 44, 38),
	HeaderDark = Color3.fromRGB(176, 29, 29),

	Accent = Color3.fromRGB(238, 48, 40),
	AccentBright = Color3.fromRGB(255, 86, 72),

	Border = Color3.fromRGB(117, 37, 37),
	BorderBright = Color3.fromRGB(171, 47, 47),

	Text = Color3.fromRGB(255, 248, 248),
	TextSecondary = Color3.fromRGB(211, 187, 187),
	TextMuted = Color3.fromRGB(149, 122, 122),

	Off = Color3.fromRGB(28, 16, 16),
	OffHover = Color3.fromRGB(43, 21, 21),
	OffBorder = Color3.fromRGB(72, 37, 37),

	Black = Color3.fromRGB(0, 0, 0),
}

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------

getgenv().SharedConfig = getgenv().SharedConfig or {
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

local Config = getgenv().SharedConfig

----------------------------------------------------------------
-- TRANSLATIONS
----------------------------------------------------------------

local Translations = {
	EN = {
		Combat = "Combat Systems",
		Visuals = "Visuals & ESP",
		Player = "Player Enhancements",
		Misc = "Misc & World",

		Aimbot = "Aimbot",
		Ragebot = "Ragebot",
		WallCheck = "Wall Check",
		Triggerbot = "Triggerbot",
		AntiAim = "Visual Anti-Aim",

		ESPMaster = "ESP Master",
		SkeletonESP = "Skeleton",
		BoxESP = "Box ESP",
		HealthBar = "Health Bar",
		PlayerInfo = "Player Info",
		TracerLines = "Tracers",
		TeamFilter = "Team Filter",
		Chams = "Chams / Highlight",

		InfJump = "Infinite Jump",
		FlyMode = "Flight Mode",
		Noclip = "Noclip",
		SpeedHack = "Speed Hack",
		Forced3P = "Third-Person",

		SkyChanger = "Sky Atmosphere",
		DeathAudio = "Death Audio",
		Cursor = "Rainbow Cursor",
		FPSOpt = "FPS Unlocker",
		Spoof = "HWID Spoof",

		Properties = "Advanced Properties",
		SwitchHitbox = "Target Hitbox",
		ToggleSky = "Toggle Atmosphere",
		SoundID = "Audio Asset ID",
		SkyID = "Sky Texture ID",

		Language = "Language",
		Keybind = "UI Toggle Key",
		PressToBind = "Press a key...",
		MobileToggle = "UI",

		Smoothness = "Smoothness",
		RageSpeed = "Rage Speed",
		FlySpeed = "Flight Speed",
		SpeedVal = "Speed Value",
		FOVRadius = "FOV Radius",
		ShowFOV = "Show FOV Circle",
	},

	KO = {
		Combat = "전투 시스템",
		Visuals = "시각 및 ESP",
		Player = "플레이어 강화",
		Misc = "기타 및 월드",

		Aimbot = "에임봇",
		Ragebot = "레이지봇",
		WallCheck = "벽 관통 체크",
		Triggerbot = "트리거봇",
		AntiAim = "안티에임",

		ESPMaster = "ESP 마스터",
		SkeletonESP = "스켈레톤",
		BoxESP = "박스 ESP",
		HealthBar = "체력 바",
		PlayerInfo = "정보 표시",
		TracerLines = "트레이서",
		TeamFilter = "팀 필터",
		Chams = "하이라이트",

		InfJump = "무한 점프",
		FlyMode = "비행 모드",
		Noclip = "노클립",
		SpeedHack = "스피드 핵",
		Forced3P = "강제 3인칭",

		SkyChanger = "스카이 대기효과",
		DeathAudio = "데스 오디오",
		Cursor = "무지개 커서",
		FPSOpt = "프레임 최적화",
		Spoof = "기기 스푸핑",

		Properties = "고급 속성 설정",
		SwitchHitbox = "타겟 히트박스",
		ToggleSky = "대기 모드 전환",
		SoundID = "오디오 에셋 ID",
		SkyID = "스카이 텍스처 ID",

		Language = "언어",
		Keybind = "UI 토글 키",
		PressToBind = "키를 누르세요...",
		MobileToggle = "UI",

		Smoothness = "부드러움",
		RageSpeed = "레이지 속도",
		FlySpeed = "비행 속도",
		SpeedVal = "이동 값",
		FOVRadius = "FOV 범위",
		ShowFOV = "FOV 원 표시",
	},
}

local function T(key)
	local language =
		Config.Language == "KO"
		and "KO"
		or "EN"

	return
		(Translations[language] and Translations[language][key])
		or Translations.EN[key]
		or key
end

----------------------------------------------------------------
-- CLEANUP
----------------------------------------------------------------

pcall(function()
	local old = CoreGui:FindFirstChild("CubicUltimateHub")

	if old then
		old:Destroy()
	end
end)

pcall(function()
	local playerGui =
		LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if playerGui then
		local old =
			playerGui:FindFirstChild("CubicUltimateHub")

		if old then
			old:Destroy()
		end
	end
end)

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(
	parent,
	color,
	thickness,
	transparency
)
	local s = Instance.new("UIStroke")

	s.Color = color
	s.Thickness = thickness
	s.Transparency =
		transparency or 0

	s.Parent = parent

	return s
end

local function tween(
	instance,
	duration,
	properties,
	style,
	direction
)
	pcall(function()
		TweenService:Create(
			instance,
			TweenInfo.new(
				duration or 0.18,
				style
					or Enum.EasingStyle.Quart,
				direction
					or Enum.EasingDirection.Out
			),
			properties
		):Play()
	end)
end

----------------------------------------------------------------
-- SCREEN GUI
----------------------------------------------------------------

local ScreenGui =
	Instance.new("ScreenGui")

ScreenGui.Name =
	"CubicUltimateHub"

ScreenGui.ResetOnSpawn =
	false

ScreenGui.IgnoreGuiInset =
	true

ScreenGui.ZIndexBehavior =
	Enum.ZIndexBehavior.Global

ScreenGui.DisplayOrder =
	1000

ScreenGui.Parent =
	CoreGui

----------------------------------------------------------------
-- ROOT
----------------------------------------------------------------

local Root =
	Instance.new("Frame")

Root.Name =
	"Root"

Root.Size =
	UDim2.fromScale(
		1,
		1
	)

Root.BackgroundTransparency =
	1

Root.BorderSizePixel =
	0

Root.Parent =
	ScreenGui

----------------------------------------------------------------
-- DIMMER
----------------------------------------------------------------

local Dimmer =
	Instance.new("Frame")

Dimmer.Name =
	"Dimmer"

Dimmer.Size =
	UDim2.fromScale(
		1,
		1
	)

Dimmer.BackgroundColor3 =
	THEME.Black

Dimmer.BackgroundTransparency =
	0.55

Dimmer.BorderSizePixel =
	0

Dimmer.ZIndex =
	0

Dimmer.Parent =
	Root

----------------------------------------------------------------
-- WINDOW CONTAINER
----------------------------------------------------------------

local WindowLayer =
	Instance.new("Frame")

WindowLayer.Name =
	"WindowLayer"

WindowLayer.Size =
	UDim2.fromScale(
		1,
		1
	)

WindowLayer.BackgroundTransparency =
	1

WindowLayer.BorderSizePixel =
	0

WindowLayer.ZIndex =
	10

WindowLayer.Parent =
	Root

----------------------------------------------------------------
-- SCALE
----------------------------------------------------------------

local Scale =
	Instance.new("UIScale")

Scale.Parent =
	WindowLayer

local function updateScale()
	local camera =
		Workspace.CurrentCamera

	if not camera then
		return
	end

	local viewport =
		camera.ViewportSize

	local widthScale =
		viewport.X / 1400

	local heightScale =
		viewport.Y / 820

	local finalScale =
		math.min(
			widthScale,
			heightScale
		)

	Scale.Scale =
		math.clamp(
			finalScale,
			0.72,
			1
		)
end

task.defer(updateScale)

Workspace:GetPropertyChangedSignal(
	"CurrentCamera"
):Connect(function()
	task.defer(updateScale)
end)

----------------------------------------------------------------
-- DATA
----------------------------------------------------------------

local Windows = {}
local UIElements = {}

----------------------------------------------------------------
-- PROPERTY POPUP
----------------------------------------------------------------

local Popup =
	Instance.new("Frame")

Popup.Name =
	"PropertiesPopup"

Popup.Size =
	UDim2.fromOffset(
		360,
		330
	)

Popup.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

Popup.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

Popup.BackgroundColor3 =
	THEME.Panel2

Popup.BorderSizePixel =
	0

Popup.Visible =
	false

Popup.ZIndex =
	5000

Popup.Parent =
	Root

corner(
	Popup,
	16
)

stroke(
	Popup,
	THEME.BorderBright,
	1.6,
	0.05
)

----------------------------------------------------------------
-- POPUP HEADER
----------------------------------------------------------------

local PopupHeader =
	Instance.new("Frame")

PopupHeader.Size =
	UDim2.new(
		1,
		0,
		0,
		54
	)

PopupHeader.BackgroundColor3 =
	THEME.HeaderDark

PopupHeader.BorderSizePixel =
	0

PopupHeader.ZIndex =
	5001

PopupHeader.Parent =
	Popup

corner(
	PopupHeader,
	16
)

local PopupCover =
	Instance.new("Frame")

PopupCover.Size =
	UDim2.new(
		1,
		0,
		0,
		18
	)

PopupCover.Position =
	UDim2.new(
		0,
		0,
		1,
		-18
	)

PopupCover.BackgroundColor3 =
	THEME.HeaderDark

PopupCover.BorderSizePixel =
	0

PopupCover.ZIndex =
	5001

PopupCover.Parent =
	PopupHeader

local PopupTitle =
	Instance.new("TextLabel")

PopupTitle.Position =
	UDim2.fromOffset(
		16,
		0
	)

PopupTitle.Size =
	UDim2.new(
		1,
		-58,
		1,
		0
	)

PopupTitle.BackgroundTransparency =
	1

PopupTitle.Text =
	""

PopupTitle.TextColor3 =
	THEME.Text

PopupTitle.TextSize =
	14

PopupTitle.Font =
	Enum.Font.GothamBold

PopupTitle.TextXAlignment =
	Enum.TextXAlignment.Left

PopupTitle.ZIndex =
	5002

PopupTitle.Parent =
	PopupHeader

local PopupClose =
	Instance.new("TextButton")

PopupClose.AnchorPoint =
	Vector2.new(
		1,
		0.5
	)

PopupClose.Position =
	UDim2.new(
		1,
		-12,
		0.5,
		0
	)

PopupClose.Size =
	UDim2.fromOffset(
		28,
		28
	)

PopupClose.BackgroundColor3 =
	THEME.Panel

PopupClose.BorderSizePixel =
	0

PopupClose.Text =
	"×"

PopupClose.TextColor3 =
	THEME.Text

PopupClose.TextSize =
	18

PopupClose.Font =
	Enum.Font.GothamBold

PopupClose.AutoButtonColor =
	false

PopupClose.ZIndex =
	5003

PopupClose.Parent =
	PopupHeader

corner(
	PopupClose,
	8
)

stroke(
	PopupClose,
	THEME.Border,
	1,
	0.05
)

----------------------------------------------------------------
-- POPUP CONTENT
----------------------------------------------------------------

local PopupContent =
	Instance.new("ScrollingFrame")

PopupContent.Position =
	UDim2.fromOffset(
		14,
		66
	)

PopupContent.Size =
	UDim2.new(
		1,
		-28,
		1,
		-80
	)

PopupContent.BackgroundTransparency =
	1

PopupContent.BorderSizePixel =
	0

PopupContent.ScrollBarThickness =
	4

PopupContent.ScrollBarImageColor3 =
	THEME.Accent

PopupContent.AutomaticCanvasSize =
	Enum.AutomaticSize.Y

PopupContent.CanvasSize =
	UDim2.fromOffset(
		0,
		0
	)

PopupContent.ZIndex =
	5001

PopupContent.Parent =
	Popup

local PopupLayout =
	Instance.new("UIListLayout")

PopupLayout.Padding =
	UDim.new(
		0,
		10
	)

PopupLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

PopupLayout.Parent =
	PopupContent

local PopupPadding =
	Instance.new("UIPadding")

PopupPadding.PaddingBottom =
	UDim.new(
		0,
		10
	)

PopupPadding.Parent =
	PopupContent

----------------------------------------------------------------
-- POPUP FUNCTIONS
----------------------------------------------------------------

local function clearPopup()
	for _, child in ipairs(
		PopupContent:GetChildren()
	) do
		if not child:IsA("UIListLayout")
			and not child:IsA("UIPadding") then

			child:Destroy()
		end
	end
end

local function ClosePopup()
	Popup.Visible =
		false

	clearPopup()
end

local function OpenPopup(
	title,
	builder,
	mousePosition
)
	clearPopup()

	PopupTitle.Text =
		title

	builder(
		PopupContent
	)

	local camera =
		Workspace.CurrentCamera

	if camera
		and mousePosition then

		local viewport =
			camera.ViewportSize

		local width =
			Popup.AbsoluteSize.X

		local height =
			Popup.AbsoluteSize.Y

		local x =
			math.clamp(
				mousePosition.X,
				width / 2 + 12,
				viewport.X -
					width / 2 -
					12
			)

		local y =
			math.clamp(
				mousePosition.Y,
				height / 2 + 12,
				viewport.Y -
					height / 2 -
					12
			)

		Popup.Position =
			UDim2.fromOffset(
				x,
				y
			)
	end

	Popup.Size =
		UDim2.fromOffset(
			340,
			310
		)

	Popup.Visible =
		true

	tween(
		Popup,
		0.18,
		{
			Size =
				UDim2.fromOffset(
					360,
					330
				)
		},
		Enum.EasingStyle.Back
	)
end

PopupClose.MouseButton1Click:Connect(
	ClosePopup
)

----------------------------------------------------------------
-- TEXTBOX
----------------------------------------------------------------

local function AddTextBox(
	parent,
	titleKey,
	configKey
)
	local wrapper =
		Instance.new("Frame")

	wrapper.Size =
		UDim2.new(
			1,
			0,
			0,
			70
		)

	wrapper.BackgroundTransparency =
		1

	wrapper.ZIndex =
		5100

	wrapper.Parent =
		parent

	local label =
		Instance.new("TextLabel")

	label.Size =
		UDim2.new(
			1,
			0,
			0,
			20
		)

	label.BackgroundTransparency =
		1

	label.Text =
		T(titleKey)

	label.TextColor3 =
		THEME.TextSecondary

	label.TextSize =
		11

	label.Font =
		Enum.Font.GothamMedium

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	label.ZIndex =
		5101

	label.Parent =
		wrapper

	local box =
		Instance.new("TextBox")

	box.Position =
		UDim2.fromOffset(
			0,
			28
		)

	box.Size =
		UDim2.new(
			1,
			0,
			0,
			34
		)

	box.BackgroundColor3 =
		THEME.Off

	box.BorderSizePixel =
		0

	box.Text =
		tostring(
			Config[configKey]
			or ""
		)

	box.TextColor3 =
		THEME.Text

	box.TextSize =
		12

	box.Font =
		Enum.Font.Gotham

	box.ClearTextOnFocus =
		false

	box.TextXAlignment =
		Enum.TextXAlignment.Left

	box.ZIndex =
		5101

	box.Parent =
		wrapper

	corner(
		box,
		9
	)

	stroke(
		box,
		THEME.OffBorder,
		1,
		0.05
	)

	box.Focused:Connect(
		function()
			tween(
				box,
				0.12,
				{
					BackgroundColor3 =
						THEME.OffHover
				}
			)
		end
	)

	box.FocusLost:Connect(
		function()
			Config[configKey] =
				box.Text

			tween(
				box,
				0.12,
				{
					BackgroundColor3 =
						THEME.Off
				}
			)
		end
	)

	return wrapper
end

----------------------------------------------------------------
-- SLIDER
----------------------------------------------------------------

local function AddSlider(
	parent,
	titleKey,
	configKey,
	minimum,
	maximum,
	step
)
	local wrapper =
		Instance.new("Frame")

	wrapper.Size =
		UDim2.new(
			1,
			0,
			0,
			60
		)

	wrapper.BackgroundTransparency =
		1

	wrapper.ZIndex =
		5100

	wrapper.Parent =
		parent

	local label =
		Instance.new("TextLabel")

	label.Size =
		UDim2.new(
			1,
			0,
			0,
			20
		)

	label.BackgroundTransparency =
		1

	label.Text =
		T(titleKey) ..
		": " ..
		tostring(
			Config[configKey]
			or minimum
		)

	label.TextColor3 =
		THEME.Text

	label.TextSize =
		11

	label.Font =
		Enum.Font.GothamMedium

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	label.ZIndex =
		5101

	label.Parent =
		wrapper

	local track =
		Instance.new("Frame")

	track.Position =
		UDim2.fromOffset(
			0,
			30
		)

	track.Size =
		UDim2.new(
			1,
			0,
			0,
			12
		)

	track.BackgroundColor3 =
		THEME.Off

	track.BorderSizePixel =
		0

	track.ZIndex =
		5101

	track.Parent =
		wrapper

	corner(
		track,
		8
	)

	stroke(
		track,
		THEME.OffBorder,
		1,
		0.05
	)

	local fill =
		Instance.new("Frame")

	fill.Size =
		UDim2.new(
			0,
			0,
			1,
			0
		)

	fill.BackgroundColor3 =
		THEME.Accent

	fill.BorderSizePixel =
		0

	fill.ZIndex =
		5102

	fill.Parent =
		track

	corner(
		fill,
		8
	)

	local knob =
		Instance.new("Frame")

	knob.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

	knob.Position =
		UDim2.new(
			0,
			0,
			0.5,
			0
		)

	knob.Size =
		UDim2.fromOffset(
			18,
			18
		)

	knob.BackgroundColor3 =
		THEME.Text

	knob.BorderSizePixel =
		0

	knob.ZIndex =
		5103

	knob.Parent =
		track

	corner(
		knob,
		20
	)

	stroke(
		knob,
		THEME.Accent,
		2,
		0
	)

	local value =
		tonumber(
			Config[configKey]
		)
		or minimum

	local dragging =
		false

	local function applyValue(
		mouseX
	)
		local width =
			math.max(
				1,
				track.AbsoluteSize.X
			)

		local pos =
			math.clamp(
				(
					mouseX
					-
					track.AbsolutePosition.X
				)
				/ width,
				0,
				1
			)

		local raw =
			minimum
			+
			(
				maximum
				-
				minimum
			)
			*
			pos

		value =
			math.floor(
				raw / step
				+
				0.5
			)
			*
			step

		value =
			math.clamp(
				value,
				minimum,
				maximum
			)

		Config[configKey] =
			value

		local percentage =
			(
				value
				-
				minimum
			)
			/
			(
				maximum
				-
				minimum
			)

		fill.Size =
			UDim2.new(
				percentage,
				0,
				1,
				0
			)

		knob.Position =
			UDim2.new(
				percentage,
				0,
				0.5,
				0
			)

		label.Text =
			T(titleKey) ..
			": " ..
			tostring(value)
	end

	local initialPercent =
		math.clamp(
			(
				value
				-
				minimum
			)
			/
			(
				maximum
				-
				minimum
			),
			0,
			1
		)

	fill.Size =
		UDim2.new(
			initialPercent,
			0,
			1,
			0
		)

	knob.Position =
		UDim2.new(
			initialPercent,
			0,
			0.5,
			0
		)

	track.InputBegan:Connect(
		function(input)
			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
				or
				input.UserInputType ==
					Enum.UserInputType.Touch then

				dragging =
					true

				applyValue(
					input.Position.X
				)

				tween(
					knob,
					0.10,
					{
						Size =
							UDim2.fromOffset(
								22,
								22
							)
					}
				)
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)
			if not dragging then
				return
			end

			if input.UserInputType ==
				Enum.UserInputType.MouseMovement
				or
				input.UserInputType ==
					Enum.UserInputType.Touch then

				applyValue(
					UserInputService:
						GetMouseLocation()
						.X
				)
			end
		end
	)

	UserInputService.InputEnded:Connect(
		function(input)
			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
				or
				input.UserInputType ==
					Enum.UserInputType.Touch then

				dragging =
					false

				tween(
					knob,
					0.10,
					{
						Size =
							UDim2.fromOffset(
								18,
								18
							)
					}
				)
			end
		end
	)

	return wrapper
end

----------------------------------------------------------------
-- TOGGLE
----------------------------------------------------------------

local function AddToggle(
	parent,
	nameKey,
	configKey,
	callback,
	rightClickFunc
)
	local active =
		Config[configKey]
		== true

	local button =
		Instance.new(
			"TextButton"
		)

	button.Size =
		UDim2.new(
			1,
			0,
			0,
			42
		)

	button.BackgroundColor3 =
		active
		and Color3.fromRGB(
			105,
			27,
			27
		)
		or THEME.Off

	button.BorderSizePixel =
		0

	button.Text =
		"  " ..
		T(nameKey)

	button.TextColor3 =
		active
		and THEME.Text
		or THEME.TextSecondary

	button.TextSize =
		12

	button.Font =
		Enum.Font.GothamMedium

	button.TextXAlignment =
		Enum.TextXAlignment.Left

	button.AutoButtonColor =
		false

	button.ZIndex =
		300

	button.Parent =
		parent

	corner(
		button,
		10
	)

	local buttonStroke =
		stroke(
			button,
			active
			and THEME.BorderBright
			or THEME.OffBorder,
			1.15,
			0.05
		)

	local status =
		Instance.new(
			"TextLabel"
		)

	status.AnchorPoint =
		Vector2.new(
			1,
			0.5
		)

	status.Position =
		UDim2.new(
			1,
			-30,
			0.5,
			0
		)

	status.Size =
		UDim2.fromOffset(
			32,
			18
		)

	status.BackgroundTransparency =
		1

	status.Text =
		active
		and "ON"
		or "OFF"

	status.TextColor3 =
		active
		and THEME.AccentBright
		or THEME.TextMuted

	status.TextSize =
		9

	status.Font =
		Enum.Font.GothamBold

	status.TextXAlignment =
		Enum.TextXAlignment.Right

	status.ZIndex =
		301

	status.Parent =
		button

	local indicator =
		Instance.new(
			"Frame"
		)

	indicator.AnchorPoint =
		Vector2.new(
			1,
			0.5
		)

	indicator.Position =
		UDim2.new(
			1,
			-12,
			0.5,
			0
		)

	indicator.Size =
		UDim2.fromOffset(
			8,
			8
		)

	indicator.BackgroundColor3 =
		active
		and THEME.AccentBright
		or THEME.TextMuted

	indicator.BorderSizePixel =
		0

	indicator.ZIndex =
		302

	indicator.Parent =
		button

	corner(
		indicator,
		8
	)

	local function updateVisual()
		button.BackgroundColor3 =
			active
			and Color3.fromRGB(
				105,
				27,
				27
			)
			or THEME.Off

		button.TextColor3 =
			active
			and THEME.Text
			or THEME.TextSecondary

		buttonStroke.Color =
			active
			and THEME.BorderBright
			or THEME.OffBorder

		status.Text =
			active
			and "ON"
			or "OFF"

		status.TextColor3 =
			active
			and THEME.AccentBright
			or THEME.TextMuted

		indicator.BackgroundColor3 =
			active
			and THEME.AccentBright
			or THEME.TextMuted
	end

	local function setState(
		state
	)
		active =
			state == true

		Config[configKey] =
			active

		updateVisual()

		if callback then
			callback(active)
		end
	end

	button.MouseButton1Click:Connect(
		function()
			setState(
				not active
			)
		end
	)

	button.MouseEnter:Connect(
		function()
			tween(
				button,
				0.10,
				{
					BackgroundColor3 =
						active
						and Color3.fromRGB(
							122,
							31,
							31
						)
						or THEME.OffHover
				}
			)
		end
	)

	button.MouseLeave:Connect(
		function()
			updateVisual()
		end
	)

	if rightClickFunc then
		button.MouseButton2Click:Connect(
			function()
				OpenPopup(
					T(nameKey)
					..
					" "
					..
					T("Properties"),
					rightClickFunc,
					UserInputService:
						GetMouseLocation()
				)
			end
		)
	end

	table.insert(
		UIElements,
		{
			Type = "Toggle",
			Button = button,
			NameKey = nameKey
		}
	)

	return button
end

----------------------------------------------------------------
-- CREATE WINDOW
----------------------------------------------------------------

local function CreateWindow(
	titleKey,
	xOffset
)
	local window =
		Instance.new(
			"ScrollingFrame"
		)

	window.Name =
		titleKey ..
		"Window"

	window.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

	window.Position =
		UDim2.new(
			0.5,
			xOffset,
			0.5,
			0
		)

	window.Size =
		UDim2.fromOffset(
			300,
			660
		)

	window.BackgroundColor3 =
		THEME.Panel

	window.BackgroundTransparency =
		0

	window.BorderSizePixel =
		0

	window.CanvasSize =
		UDim2.fromOffset(
			0,
			0
		)

	window.AutomaticCanvasSize =
		Enum.AutomaticSize.Y

	window.ScrollBarThickness =
		5

	window.ScrollBarImageColor3 =
		THEME.Accent

	window.ScrollingDirection =
		Enum.ScrollingDirection.Y

	window.ZIndex =
		100

	window.Parent =
		WindowLayer

	corner(
		window,
		16
	)

	local windowStroke =
		stroke(
			window,
			THEME.Border,
			1.4,
			0.02
		)

	----------------------------------------------------------------
	-- HEADER
	----------------------------------------------------------------

	local header =
		Instance.new("Frame")

	header.Name =
		"Header"

	header.Size =
		UDim2.new(
			1,
			0,
			0,
			60
		)

	header.BackgroundColor3 =
		THEME.Header

	header.BorderSizePixel =
		0

	header.ZIndex =
		110

	header.Parent =
		window

	corner(
		header,
		16
	)

	local headerCover =
		Instance.new("Frame")

	headerCover.Size =
		UDim2.new(
			1,
			0,
			0,
			18
		)

	headerCover.Position =
		UDim2.new(
			0,
			0,
			1,
			-18
		)

	headerCover.BackgroundColor3 =
		THEME.Header

	headerCover.BorderSizePixel =
		0

	headerCover.ZIndex =
		110

	headerCover.Parent =
		header

	local headerLine =
		Instance.new("Frame")

	headerLine.Position =
		UDim2.fromOffset(
			14,
			14
		)

	headerLine.Size =
		UDim2.fromOffset(
			4,
			32
		)

	headerLine.BackgroundColor3 =
		THEME.Text

	headerLine.BorderSizePixel =
		0

	headerLine.ZIndex =
		111

	headerLine.Parent =
		header

	corner(
		headerLine,
		4
	)

	local title =
		Instance.new("TextLabel")

	title.Name =
		"TitleLabel"

	title.Position =
		UDim2.fromOffset(
			28,
			8
		)

	title.Size =
		UDim2.new(
			1,
			-40,
			0,
			24
		)

	title.BackgroundTransparency =
		1

	title.Text =
		T(titleKey)

	title.TextColor3 =
		THEME.Text

	title.TextSize =
		15

	title.Font =
		Enum.Font.GothamBold

	title.TextXAlignment =
		Enum.TextXAlignment.Left

	title.ZIndex =
		111

	title.Parent =
		header

	local sub =
		Instance.new(
			"TextLabel"
		)

	sub.Position =
		UDim2.fromOffset(
			29,
			32
		)

	sub.Size =
		UDim2.new(
			1,
			-42,
			0,
			15
		)

	sub.BackgroundTransparency =
		1

	sub.Text =
		"MODULE CONTROLS"

	sub.TextColor3 =
		Color3.fromRGB(
			255,
			194,
			187
		)

	sub.TextSize =
		8

	sub.Font =
		Enum.Font.GothamBold

	sub.TextXAlignment =
		Enum.TextXAlignment.Left

	sub.ZIndex =
		111

	sub.Parent =
		header

	----------------------------------------------------------------
	-- CONTENT
	----------------------------------------------------------------

	local body =
		Instance.new(
			"ScrollingFrame"
		)

	body.Name =
		"Content"

	body.Position =
		UDim2.fromOffset(
			12,
			72
		)

	body.Size =
		UDim2.new(
			1,
			-24,
			1,
			-84
		)

	body.BackgroundTransparency =
		1

	body.BorderSizePixel =
		0

	body.ScrollBarThickness =
		4

	body.ScrollBarImageColor3 =
		THEME.Accent

	body.AutomaticCanvasSize =
		Enum.AutomaticSize.Y

	body.CanvasSize =
		UDim2.fromOffset(
			0,
			0
		)

	body.ZIndex =
		105

	body.Parent =
		window

	local list =
		Instance.new(
			"UIListLayout"
		)

	list.SortOrder =
		Enum.SortOrder.LayoutOrder

	list.Padding =
		UDim.new(
			0,
			9
		)

	list.Parent =
		body

	local padding =
		Instance.new(
			"UIPadding"
		)

	padding.PaddingTop =
		UDim.new(
			0,
			2
		)

	padding.PaddingBottom =
		UDim.new(
			0,
			12
		)

	padding.PaddingLeft =
		UDim.new(
			0,
			2
		)

	padding.PaddingRight =
		UDim.new(
			0,
			2
		)

	padding.Parent =
		body

	----------------------------------------------------------------
	-- DRAG
	----------------------------------------------------------------

	local dragging =
		false

	local dragStart =
		nil

	local startPosition =
		nil

	header.InputBegan:Connect(
		function(input)
			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
				or
				input.UserInputType ==
					Enum.UserInputType.Touch then

				dragging =
					true

				dragStart =
					input.Position

				startPosition =
					window.Position
			end
		end
	)

	header.InputEnded:Connect(
		function(input)
			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
				or
				input.UserInputType ==
					Enum.UserInputType.Touch then

				dragging =
					false
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)
			if not dragging then
				return
			end

			if not dragStart
				or not startPosition then

				return
			end

			if input.UserInputType ~=
				Enum.UserInputType.MouseMovement
				and
				input.UserInputType ~=
					Enum.UserInputType.Touch then

				return
			end

			local delta =
				input.Position
				-
				dragStart

			window.Position =
				UDim2.new(
					startPosition.X.Scale,
					startPosition.X.Offset
						+
						delta.X,

					startPosition.Y.Scale,
					startPosition.Y.Offset
						+
						delta.Y
				)
		end
	)

	----------------------------------------------------------------
	-- SAVE
	----------------------------------------------------------------

	window:SetAttribute(
		"TitleKey",
		titleKey
	)

	table.insert(
		Windows,
		{
			Frame = window,
			Title = title,
			TitleKey = titleKey,
			BasePosition = window.Position
		}
	)

	return window, body
end

----------------------------------------------------------------
-- FOUR ORIGINAL WINDOWS
--
-- Same four-panel concept as the original,
-- but genuinely larger and centered.
----------------------------------------------------------------

local WinCombat, CombatBody =
	CreateWindow(
		"Combat",
		-477
	)

local WinVisuals, VisualsBody =
	CreateWindow(
		"Visuals",
		-159
	)

local WinPlayer, PlayerBody =
	CreateWindow(
		"Player",
		159
	)

local WinMisc, MiscBody =
	CreateWindow(
		"Misc",
		477
	)

----------------------------------------------------------------
-- COMBAT
----------------------------------------------------------------

AddToggle(
	CombatBody,
	"Aimbot",
	"Aimbot",
	nil,
	function(content)

		AddSlider(
			content,
			"Smoothness",
			"Aimbot_Smooth",
			1,
			10,
			1
		)

		AddSlider(
			content,
			"FOVRadius",
			"Aimbot_FOV",
			50,
			500,
			10
		)

		AddToggle(
			content,
			"ShowFOV",
			"Show_FOV"
		)
	end
)

AddToggle(
	CombatBody,
	"Ragebot",
	"Ragebot",
	nil,
	function(content)

		AddSlider(
			content,
			"RageSpeed",
			"Ragebot_Speed",
			1,
			20,
			1
		)
	end
)

AddToggle(
	CombatBody,
	"WallCheck",
	"Wall_Check"
)

AddToggle(
	CombatBody,
	"Triggerbot",
	"Triggerbot"
)

AddToggle(
	CombatBody,
	"AntiAim",
	"Anti_Aim"
)

----------------------------------------------------------------
-- VISUALS
----------------------------------------------------------------

AddToggle(
	VisualsBody,
	"ESPMaster",
	"ESP_Master"
)

AddToggle(
	VisualsBody,
	"SkeletonESP",
	"Skeleton_ESP"
)

AddToggle(
	VisualsBody,
	"BoxESP",
	"Box_ESP"
)

AddToggle(
	VisualsBody,
	"HealthBar",
	"Health_Bar"
)

AddToggle(
	VisualsBody,
	"TracerLines",
	"Tracer_Lines"
)

AddToggle(
	VisualsBody,
	"PlayerInfo",
	"Info_Display"
)

AddToggle(
	VisualsBody,
	"TeamFilter",
	"Team_Filter"
)

AddToggle(
	VisualsBody,
	"Chams",
	"Chams_Enabled"
)

----------------------------------------------------------------
-- PLAYER
----------------------------------------------------------------

AddToggle(
	PlayerBody,
	"InfJump",
	"Infinite_Jump"
)

AddToggle(
	PlayerBody,
	"FlyMode",
	"Fly_Mode",
	nil,
	function(content)

		AddSlider(
			content,
			"FlySpeed",
			"Fly_Speed",
			10,
			200,
			5
		)
	end
)

AddToggle(
	PlayerBody,
	"Noclip",
	"Noclip"
)

AddToggle(
	PlayerBody,
	"SpeedHack",
	"Speed_Hack",
	nil,
	function(content)

		AddSlider(
			content,
			"SpeedVal",
			"Speed_Val",
			16,
			150,
			5
		)
	end
)

AddToggle(
	PlayerBody,
	"Forced3P",
	"Third_Person"
)

----------------------------------------------------------------
-- MISC
----------------------------------------------------------------

AddToggle(
	MiscBody,
	"SkyChanger",
	"Skybox_Mode",
	function(state)
		if state then

			local sky =
				Lighting:
					FindFirstChildOfClass(
						"Sky"
					)

			if not sky then
				sky =
					Instance.new(
						"Sky"
					)

				sky.Parent =
					Lighting
			end

			local asset =
				"rbxassetid://" ..
				tostring(
					Config.Custom_Sky_Id
				)

			sky.SkyboxBk =
				asset

			sky.SkyboxDn =
				asset

			sky.SkyboxFt =
				asset

			sky.SkyboxLf =
				asset

			sky.SkyboxRt =
				asset

			sky.SkyboxUp =
				asset

		else

			local sky =
				Lighting:
					FindFirstChildOfClass(
						"Sky"
					)

			if sky then
				sky:Destroy()
			end
		end
	end,
	function(content)

		AddTextBox(
			content,
			"SkyID",
			"Custom_Sky_Id"
		)
	end
)

AddToggle(
	MiscBody,
	"DeathAudio",
	"Death_Audio",
	nil,
	function(content)

		AddTextBox(
			content,
			"SoundID",
			"Death_Audio_Id"
		)
	end
)

AddToggle(
	MiscBody,
	"Cursor",
	"Interactive_Cursor"
)

AddToggle(
	MiscBody,
	"FPSOpt",
	"FPS_Opt",
	function(state)

		pcall(
			function()

				if setfpscap then
					setfpscap(
						state
							and 120
							or 60
					)
				end

			end
		)

	end
)

AddToggle(
	MiscBody,
	"Spoof",
	"Device_Spoof"
)

----------------------------------------------------------------
-- LANGUAGE BAR
----------------------------------------------------------------

local LanguageBar =
	Instance.new("Frame")

LanguageBar.Name =
	"LanguageBar"

LanguageBar.AnchorPoint =
	Vector2.new(
		0.5,
		0
	)

LanguageBar.Position =
	UDim2.new(
		0.5,
		0,
		0,
		18
	)

LanguageBar.Size =
	UDim2.fromOffset(
		220,
		48
	)

LanguageBar.BackgroundColor3 =
	THEME.Panel2

LanguageBar.BorderSizePixel =
	0

LanguageBar.ZIndex =
	1000

LanguageBar.Parent =
	Root

corner(
	LanguageBar,
	12
)

stroke(
	LanguageBar,
	THEME.Border,
	1.2,
	0.05
)

local LanguageLabel =
	Instance.new(
		"TextLabel"
	)

LanguageLabel.Position =
	UDim2.fromOffset(
		12,
		0
	)

LanguageLabel.Size =
	UDim2.fromOffset(
		60,
		48
	)

LanguageLabel.BackgroundTransparency =
	1

LanguageLabel.Text =
	T("Language")

LanguageLabel.TextColor3 =
	THEME.TextSecondary

LanguageLabel.TextSize =
	10

LanguageLabel.Font =
	Enum.Font.GothamMedium

LanguageLabel.TextXAlignment =
	Enum.TextXAlignment.Left

LanguageLabel.ZIndex =
	1001

LanguageLabel.Parent =
	LanguageBar

local ENButton =
	Instance.new(
		"TextButton"
	)

ENButton.Position =
	UDim2.fromOffset(
		86,
		10
	)

ENButton.Size =
	UDim2.fromOffset(
		56,
		28
	)

ENButton.BackgroundColor3 =
	THEME.Accent

ENButton.BorderSizePixel =
	0

ENButton.Text =
	"EN"

ENButton.TextColor3 =
	THEME.Text

ENButton.TextSize =
	10

ENButton.Font =
	Enum.Font.GothamBold

ENButton.AutoButtonColor =
	false

ENButton.ZIndex =
	1001

ENButton.Parent =
	LanguageBar

corner(
	ENButton,
	8
)

local KOButton =
	Instance.new(
		"TextButton"
	)

KOButton.Position =
	UDim2.fromOffset(
		150,
		10
	)

KOButton.Size =
	UDim2.fromOffset(
		56,
		28
	)

KOButton.BackgroundColor3 =
	THEME.Off

KOButton.BorderSizePixel =
	0

KOButton.Text =
	"KO"

KOButton.TextColor3 =
	THEME.TextSecondary

KOButton.TextSize =
	10

KOButton.Font =
	Enum.Font.GothamBold

KOButton.AutoButtonColor =
	false

KOButton.ZIndex =
	1001

KOButton.Parent =
	LanguageBar

corner(
	KOButton,
	8
)

local function RefreshAllUI()
	for _, item in ipairs(
		UIElements
	) do
		if item.Type ==
			"Toggle"
			and item.Button
			and item.Button.Parent then

			item.Button.Text =
				"  " ..
				T(item.NameKey)
		end
	end

	for _, window in ipairs(
		Windows
	) do
		if window.Title
			and window.Title.Parent then

			window.Title.Text =
				T(
					window.TitleKey
				)
		end
	end

	LanguageLabel.Text =
		T("Language")

	if KeybindLabel then
		KeybindLabel.Text =
			T("Keybind")
	end

	if MobileButton then
		MobileButton.Text =
			T("MobileToggle")
	end

	if BindingMode
		and KeybindButton then

		KeybindButton.Text =
			T("PressToBind")
	end
end

ENButton.MouseButton1Click:Connect(
	function()

		Config.Language =
			"EN"

		ENButton.BackgroundColor3 =
			THEME.Accent

		ENButton.TextColor3 =
			THEME.Text

		KOButton.BackgroundColor3 =
			THEME.Off

		KOButton.TextColor3 =
			THEME.TextSecondary

		RefreshAllUI()
	end
)

KOButton.MouseButton1Click:Connect(
	function()

		Config.Language =
			"KO"

		KOButton.BackgroundColor3 =
			THEME.Accent

		KOButton.TextColor3 =
			THEME.Text

		ENButton.BackgroundColor3 =
			THEME.Off

		ENButton.TextColor3 =
			THEME.TextSecondary

		RefreshAllUI()
	end
)

----------------------------------------------------------------
-- MENU TOGGLE
----------------------------------------------------------------

local MenuVisible =
	true

local function ToggleMenu()
	MenuVisible =
		not MenuVisible

	for _, window in ipairs(
		Windows
	) do
		window.Frame.Visible =
			MenuVisible
	end

	Dimmer.Visible =
		MenuVisible

	LanguageBar.Visible =
		MenuVisible

	if not MenuVisible then
		ClosePopup()
	end
end

----------------------------------------------------------------
-- MOBILE / PC CONTROL
----------------------------------------------------------------

local IsMobile =
	UserInputService.TouchEnabled
	and not UserInputService.KeyboardEnabled

local MobileButton
local KeybindPanel
local KeybindLabel
local KeybindButton

local BindingMode =
	false

if IsMobile then

	MobileButton =
		Instance.new(
			"TextButton"
		)

	MobileButton.AnchorPoint =
		Vector2.new(
			0,
			0.5
		)

	MobileButton.Position =
		UDim2.new(
			0,
			14,
			0.5,
			0
		)

	MobileButton.Size =
		UDim2.fromOffset(
			50,
			50
		)

	MobileButton.BackgroundColor3 =
		THEME.Accent

	MobileButton.BorderSizePixel =
		0

	MobileButton.Text =
		T("MobileToggle")

	MobileButton.TextColor3 =
		THEME.Text

	MobileButton.TextSize =
		12

	MobileButton.Font =
		Enum.Font.GothamBold

	MobileButton.AutoButtonColor =
		false

	MobileButton.ZIndex =
		3000

	MobileButton.Parent =
		Root

	corner(
		MobileButton,
		14
	)

	stroke(
		MobileButton,
		THEME.AccentBright,
		1.3,
		0
	)

	MobileButton.MouseButton1Click:Connect(
		ToggleMenu
	)

else

	KeybindPanel =
		Instance.new(
			"Frame"
		)

	KeybindPanel.AnchorPoint =
		Vector2.new(
			0,
			1
		)

	KeybindPanel.Position =
		UDim2.new(
			0,
			16,
			1,
			-16
		)

	KeybindPanel.Size =
		UDim2.fromOffset(
			190,
			64
		)

	KeybindPanel.BackgroundColor3 =
		THEME.Panel2

	KeybindPanel.BorderSizePixel =
		0

	KeybindPanel.ZIndex =
		3000

	KeybindPanel.Parent =
		Root

	corner(
		KeybindPanel,
		12
	)

	stroke(
		KeybindPanel,
		THEME.Border,
		1.2,
		0.05
	)

	KeybindLabel =
		Instance.new(
			"TextLabel"
		)

	KeybindLabel.Position =
		UDim2.fromOffset(
			10,
			7
		)

	KeybindLabel.Size =
		UDim2.new(
			1,
			-20,
			0,
			14
		)

	KeybindLabel.BackgroundTransparency =
		1

	KeybindLabel.Text =
		T("Keybind")

	KeybindLabel.TextColor3 =
		THEME.TextSecondary

	KeybindLabel.TextSize =
		9

	KeybindLabel.Font =
		Enum.Font.Gotham

	KeybindLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	KeybindLabel.ZIndex =
		3001

	KeybindLabel.Parent =
		KeybindPanel

	KeybindButton =
		Instance.new(
			"TextButton"
		)

	KeybindButton.Position =
		UDim2.fromOffset(
			10,
			28
		)

	KeybindButton.Size =
		UDim2.new(
			1,
			-20,
			0,
			24
		)

	KeybindButton.BackgroundColor3 =
		THEME.Off

	KeybindButton.BorderSizePixel =
		0

	KeybindButton.Text =
		Config.MenuKey.Name

	KeybindButton.TextColor3 =
		THEME.Text

	KeybindButton.TextSize =
		10

	KeybindButton.Font =
		Enum.Font.GothamBold

	KeybindButton.AutoButtonColor =
		false

	KeybindButton.ZIndex =
		3001

	KeybindButton.Parent =
		KeybindPanel

	corner(
		KeybindButton,
		7
	)

	stroke(
		KeybindButton,
		THEME.Border,
		1,
		0
	)

	KeybindButton.MouseButton1Click:Connect(
		function()

			BindingMode =
				true

			KeybindButton.Text =
				T("PressToBind")
		end
	)
end

----------------------------------------------------------------
-- RIGHT SHIFT SINK
--
-- RightShift is consumed before Roblox's normal
-- Shift Lock action so using it for the UI does not
-- turn Shift Lock on/off.
----------------------------------------------------------------

pcall(function()
	ContextActionService:
		UnbindAction(
			"CubicUltimateHub_RightShift"
		)
end)

ContextActionService:
	BindActionAtPriority(
		"CubicUltimateHub_RightShift",

		function(
			actionName,
			inputState,
			inputObject
		)
			if inputState ==
				Enum.UserInputState.Begin then

				if Config.MenuKey ==
					Enum.KeyCode.RightShift
					and
					not BindingMode then

					ToggleMenu()
				end
			end

			return Enum.ContextActionResult.Sink
		end,

		false,

		5000,

		Enum.KeyCode.RightShift
	)

----------------------------------------------------------------
-- KEYBOARD INPUT
----------------------------------------------------------------

UserInputService.InputBegan:Connect(
	function(
		input,
		processed
	)

		if BindingMode
			and input.UserInputType ==
				Enum.UserInputType.Keyboard then

			if input.KeyCode ~=
				Enum.KeyCode.Unknown then

				Config.MenuKey =
					input.KeyCode

				BindingMode =
					false

				if KeybindButton then
					KeybindButton.Text =
						Config.MenuKey.Name
				end
			end

			return
		end

		if processed then
			return
		end

		if input.UserInputType ==
			Enum.UserInputType.Keyboard
			and
			input.KeyCode ==
				Config.MenuKey then

			if Config.MenuKey ~=
				Enum.KeyCode.RightShift then

				ToggleMenu()
			end

			return
		end
	end
)

----------------------------------------------------------------
-- INITIAL STATE
----------------------------------------------------------------

Config.Language =
	"EN"

ENButton.BackgroundColor3 =
	THEME.Accent

KOButton.BackgroundColor3 =
	THEME.Off

for _, window in ipairs(
	Windows
) do
	window.Frame.Visible =
		true
end

Dimmer.Visible =
	true

LanguageBar.Visible =
	true

----------------------------------------------------------------
-- KEEP CONTROLLERS IN PLACE
----------------------------------------------------------------

task.spawn(
	function()
		while ScreenGui.Parent do

			updateScale()

			if MobileButton then
				MobileButton.Position =
					UDim2.new(
						0,
						14,
						0.5,
						0
					)
			end

			if KeybindPanel then
				KeybindPanel.Position =
					UDim2.new(
						0,
						16,
						1,
						-16
					)
			end

			task.wait(
				0.35
			)
		end
	end
)
