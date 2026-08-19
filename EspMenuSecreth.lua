--// SecrethA v1 - Local ESP
--// Coloca este LocalScript en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURACIÓN
--==================================================

local RED = Color3.fromRGB(255, 25, 25)
local DARK_RED = Color3.fromRGB(45, 5, 5)
local BLACK = Color3.fromRGB(8, 8, 10)
local WHITE = Color3.fromRGB(255, 255, 255)

local espEnabled = false
local espObjects = {}

--==================================================
-- GUI PRINCIPAL
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SecrethA_v1"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

--==================================================
-- BOTÓN SA
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "SAToggle"
ToggleButton.Size = UDim2.new(0, 65, 0, 65)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -32)
ToggleButton.BackgroundColor3 = BLACK
ToggleButton.Text = "SA"
ToggleButton.TextColor3 = WHITE
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = RED
ToggleStroke.Thickness = 3
ToggleStroke.Parent = ToggleButton

-- Diana roja detrás de SA
local Target = Instance.new("Frame")
Target.Name = "RedTarget"
Target.Size = UDim2.new(0, 48, 0, 48)
Target.Position = UDim2.new(0.5, -24, 0.5, -24)
Target.BackgroundTransparency = 1
Target.ZIndex = 0
Target.Parent = ToggleButton

local TargetCircle = Instance.new("UICorner")
TargetCircle.CornerRadius = UDim.new(1, 0)
TargetCircle.Parent = Target

local TargetStroke = Instance.new("UIStroke")
TargetStroke.Color = RED
TargetStroke.Thickness = 3
TargetStroke.Transparency = 0.15
TargetStroke.Parent = Target

local TargetInner = Instance.new("Frame")
TargetInner.Size = UDim2.new(0, 27, 0, 27)
TargetInner.Position = UDim2.new(0.5, -13.5, 0.5, -13.5)
TargetInner.BackgroundTransparency = 1
TargetInner.ZIndex = 0
TargetInner.Parent = Target

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(1, 0)
InnerCorner.Parent = TargetInner

local InnerStroke = Instance.new("UIStroke")
InnerStroke.Color = RED
InnerStroke.Thickness = 2
InnerStroke.Parent = TargetInner

ToggleButton.ZIndex = 5

--==================================================
-- DRAG DEL BOTÓN
--==================================================

local dragging = false
local dragStart
local startPos

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = ToggleButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and
		(input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then

		local delta = input.Position - dragStart

		ToggleButton.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- MENÚ
--==================================================

local Menu = Instance.new("Frame")
Menu.Name = "MainMenu"
Menu.Size = UDim2.new(0, 350, 0, 390)
Menu.Position = UDim2.new(0.5, -175, 0.5, -195)
Menu.BackgroundColor3 = BLACK
Menu.Visible = false
Menu.ClipsDescendants = true
Menu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 18)
MenuCorner.Parent = Menu

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = RED
MenuStroke.Thickness = 2
MenuStroke.Transparency = 0.1
MenuStroke.Parent = Menu

--==================================================
-- FONDO DE PARTÍCULAS
--==================================================

local ParticleContainer = Instance.new("Frame")
ParticleContainer.Name = "Particles"
ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
ParticleContainer.BackgroundTransparency = 1
ParticleContainer.ClipsDescendants = true
ParticleContainer.ZIndex = 1
ParticleContainer.Parent = Menu

local function createParticle()

	local particle = Instance.new("Frame")

	local size = math.random(3, 7)

	particle.Size = UDim2.new(0, size, 0, size)

	particle.Position = UDim2.new(
		math.random(),
		0,
		-0.05,
		0
	)

	particle.BackgroundColor3 = RED
	particle.BackgroundTransparency = math.random(20, 55) / 100

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = particle

	local glow = Instance.new("UIStroke")
	glow.Color = RED
	glow.Thickness = 1
	glow.Transparency = 0.25
	glow.Parent = particle

	particle.ZIndex = 1
	particle.Parent = ParticleContainer

	local duration = math.random(3, 7)

	local tween = TweenService:Create(
		particle,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{
			Position = UDim2.new(
				particle.Position.X.Scale,
				0,
				1.1,
				0
			),
			BackgroundTransparency = 1
		}
	)

	tween:Play()

	tween.Completed:Connect(function()
		particle:Destroy()
	end)
end

task.spawn(function()
	while ScreenGui.Parent do
		if Menu.Visible then
			createParticle()
		end
		task.wait(0.12)
	end
end)

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -30, 0, 60)
Title.Position = UDim2.new(0, 15, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "SecrethA v1"
Title.TextColor3 = WHITE
Title.TextSize = 28

-- Shimalu no siempre está disponible como Enum.Font,
-- por eso usamos Gotham como sustituto seguro.
Title.Font = Enum.Font.GothamBlack

Title.ZIndex = 3
Title.Parent = Menu

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = RED
TitleStroke.Thickness = 1
TitleStroke.Transparency = 0.35
TitleStroke.Parent = Title

--==================================================
-- SUBTÍTULO
--==================================================

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -40, 0, 25)
Subtitle.Position = UDim2.new(0, 20, 0, 68)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PLAYER VISUAL SYSTEM"
Subtitle.TextColor3 = Color3.fromRGB(190, 190, 190)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.ZIndex = 3
Subtitle.Parent = Menu

--==================================================
-- FUNCIÓN PARA CREAR BOTONES
--==================================================

local function createButton(name, text, position)

	local button = Instance.new("TextButton")

	button.Name = name
	button.Size = UDim2.new(0, 290, 0, 65)
	button.Position = position

	button.BackgroundColor3 = DARK_RED
	button.BackgroundTransparency = 0.1

	button.Text = text
	button.TextColor3 = WHITE
	button.TextSize = 18
	button.Font = Enum.Font.GothamBold

	button.AutoButtonColor = false
	button.ZIndex = 4
	button.Parent = Menu

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Name = "NeonStroke"
	stroke.Color = RED
	stroke.Thickness = 2
	stroke.Transparency = 0.15
	stroke.Parent = button

	button.MouseEnter:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.15),
			{
				BackgroundColor3 = Color3.fromRGB(85, 8, 8)
			}
		):Play()

		TweenService:Create(
			stroke,
			TweenInfo.new(0.15),
			{
				Thickness = 4,
				Transparency = 0
			}
		):Play()
	end)

	button.MouseLeave:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.15),
			{
				BackgroundColor3 = DARK_RED
			}
		):Play()

		TweenService:Create(
			stroke,
			TweenInfo.new(0.15),
			{
				Thickness = 2,
				Transparency = 0.15
			}
		):Play()
	end)

	return button
end

--==================================================
-- BOTÓN ESP PLAYERS
--==================================================

local ESPPlayers = createButton(
	"ESPPlayers",
	"ESP Players",
	UDim2.new(0.5, -145, 0, 120)
)

--==================================================
-- BOTÓN ESP HITBOX
--==================================================

local ESPHitbox = createButton(
	"ESPHitbox",
	"ESP Hitbox",
	UDim2.new(0.5, -145, 0, 200)
)

-- Como se eliminó la función de modificar Hitbox,
-- este botón funciona también como ESP visual.

--==================================================
-- ESTADO
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 30)
Status.Position = UDim2.new(0, 20, 0, 285)
Status.BackgroundTransparency = 1
Status.Text = "ESP: OFF"
Status.TextColor3 = Color3.fromRGB(160, 160, 160)
Status.TextSize = 13
Status.Font = Enum.Font.GothamMedium
Status.ZIndex = 4
Status.Parent = Menu

--==================================================
-- ESP
--==================================================

local function removeESP(player)

	if espObjects[player] then

		for _, object in ipairs(espObjects[player]) do
			if object and object.Parent then
				object:Destroy()
			end
		end

		espObjects[player] = nil
	end
end

local function addESP(player)

	if player == LocalPlayer then
		return
	end

	removeESP(player)

	local character = player.Character

	if not character then
		return
	end

	local highlight = Instance.new("Highlight")

	highlight.Name = "SecrethA_ESP"
	highlight.Adornee = character

	highlight.FillColor = RED
	highlight.OutlineColor = Color3.fromRGB(255, 80, 80)

	highlight.FillTransparency = 0.78
	highlight.OutlineTransparency = 0

	-- Hace que se vea incluso detrás de paredes.
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	highlight.Parent = character

	espObjects[player] = {
		highlight
	}
end

local function enableESP()

	espEnabled = true

	Status.Text = "ESP: ON"
	Status.TextColor3 = RED

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			addESP(player)
		end
	end
end

local function disableESP()

	espEnabled = false

	Status.Text = "ESP: OFF"
	Status.TextColor3 = Color3.fromRGB(160, 160, 160)

	for player, _ in pairs(espObjects) do
		removeESP(player)
	end
end

local function toggleESP()

	if espEnabled then
		disableESP()
	else
		enableESP()
	end
end

--==================================================
-- NUEVOS JUGADORES / RESPAWN
--==================================================

Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function()

		task.wait(0.5)

		if espEnabled then
			addESP(player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

for _, player in ipairs(Players:GetPlayers()) do

	if player ~= LocalPlayer then

		player.CharacterAdded:Connect(function()

			task.wait(0.5)

			if espEnabled then
				addESP(player)
			end
		end)
	end
end

--==================================================
-- BOTONES
--==================================================

ESPPlayers.MouseButton1Click:Connect(function()
	toggleESP()
end)

ESPHitbox.MouseButton1Click:Connect(function()
	-- Sin modificar Hitboxes: simplemente activa/desactiva
	-- el sistema ESP visual.
	toggleESP()
end)

--==================================================
-- ABRIR / CERRAR MENÚ
--==================================================

local menuOpen = false

ToggleButton.MouseButton1Click:Connect(function()

	menuOpen = not menuOpen

	if menuOpen then

		Menu.Visible = true
		Menu.Size = UDim2.new(0, 0, 0, 0)

		TweenService:Create(
			Menu,
			TweenInfo.new(
				0.25,
				Enum.EasingStyle.Back,
				Enum.EasingDirection.Out
			),
			{
				Size = UDim2.new(0, 350, 0, 390)
			}
		):Play()

	else

		local closeTween = TweenService:Create(
			Menu,
			TweenInfo.new(
				0.18,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			),
			{
				Size = UDim2.new(0, 0, 0, 0)
			}
		)

		closeTween:Play()

		closeTween.Completed:Connect(function()

			if not menuOpen then
				Menu.Visible = false
			end

		end)
	end
end)

--==================================================
-- ANIMACIÓN DEL BOTÓN SA
--==================================================

task.spawn(function()

	while ScreenGui.Parent do

		TweenService:Create(
			ToggleStroke,
			TweenInfo.new(
				0.8,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				Thickness = 5,
				Transparency = 0.35
			}
		):Play()

		task.wait(0.8)

		TweenService:Create(
			ToggleStroke,
			TweenInfo.new(
				0.8,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				Thickness = 2,
				Transparency = 0
			}
		):Play()

		task.wait(0.8)
	end
end)
