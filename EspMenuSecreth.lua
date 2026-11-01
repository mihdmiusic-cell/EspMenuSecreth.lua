--[[
    SecrethA V3.1 ULTRA
    Roblox Studio - LocalScript
    Ubicacion: StarterPlayer > StarterPlayerScripts

    Herramientas visuales para tu propia experiencia.
    No utiliza Drawing API ni requiere modulos externos.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local VERSION = "3.1 ULTRA"

-- Evitar duplicados al volver a ejecutar el LocalScript.
local Previous = PlayerGui:FindFirstChild("SecrethA_V31")
if Previous then
    Previous:Destroy()
end

local Config = {
    Names = true,
    Boxes = true,
    Corners = false,
    Health = true,
    Distance = true,
    Skeleton = false,
    Highlights = false,
    TeamCheck = false,

    Crosshair = false,
    FOV = false,
    FPS = true,
    Debug = false,

    Rainbow = false,

    MaxDistance = 1000,
    FOVRadius = 100,
    CrosshairSize = 8,
    TextSize = 13,

    -- Color independiente de los colores de la interfaz.
    ESPColor = Color3.fromRGB(255, 55, 65),
    UIAccent = Color3.fromRGB(255, 45, 60),

    CustomR = 255,
    CustomG = 55,
    CustomB = 65,

    Theme = "ROJO",
}

local ThemeColors = {
    ROJO = Color3.fromRGB(255, 45, 60),
    AZUL = Color3.fromRGB(35, 145, 255),
    VERDE = Color3.fromRGB(30, 235, 135),
    MORADO = Color3.fromRGB(180, 75, 255),
    BLANCO = Color3.fromRGB(240, 240, 255),
}

local ESPPresets = {
    {"ROJO", Color3.fromRGB(255, 45, 60)},
    {"AZUL", Color3.fromRGB(35, 145, 255)},
    {"VERDE", Color3.fromRGB(30, 235, 135)},
    {"MORADO", Color3.fromRGB(180, 75, 255)},
    {"BLANCO", Color3.fromRGB(245, 245, 245)},
    {"AMARILLO", Color3.fromRGB(255, 220, 35)},
    {"NARANJA", Color3.fromRGB(255, 130, 30)},
    {"CIAN", Color3.fromRGB(0, 235, 255)},
}

local PaletteIndex = 1

local function getCamera()
    return Workspace.CurrentCamera
end

-- =========================================================
-- INTERFAZ
-- =========================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "SecrethA_V31"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 100
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = PlayerGui

local Panel = Instance.new("Frame")
Panel.Name = "MainPanel"
Panel.Size = UDim2.fromOffset(350, 500)
Panel.Position = UDim2.new(0, 25, 0.5, -250)
Panel.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
Panel.BorderSizePixel = 0
Panel.Parent = GUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = Panel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Config.UIAccent
PanelStroke.Thickness = 1.5
PanelStroke.Parent = Panel

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(27, 22, 29)
Header.BorderSizePixel = 0
Header.Parent = Panel

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -65, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "SecrethA  |  " .. VERSION
Title.TextColor3 = Config.UIAccent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(35, 32)
MinButton.Position = UDim2.new(1, -43, 0, 10)
MinButton.Text = "—"
MinButton.TextColor3 = Color3.new(1, 1, 1)
MinButton.BackgroundColor3 = Color3.fromRGB(45, 40, 48)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 17
MinButton.Parent = Header

Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 6)

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(10, 62)
Content.Size = UDim2.new(1, -20, 1, -72)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Config.UIAccent
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new()
Content.Parent = Panel

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

local Padding = Instance.new("UIPadding")
Padding.PaddingBottom = UDim.new(0, 12)
Padding.PaddingTop = UDim.new(0, 3)
Padding.Parent = Content

local order = 0

local function nextOrder()
    order += 1
    return order
end

local function makeSection(text)
    local Label = Instance.new("TextLabel")
    Label.Name = "Section"
    Label.Size = UDim2.new(1, -4, 0, 27)
    Label.BackgroundColor3 = Color3.fromRGB(31, 27, 35)
    Label.BorderSizePixel = 0
    Label.Text = "  " .. text
    Label.TextColor3 = Config.UIAccent
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.LayoutOrder = nextOrder()
    Label.Parent = Content

    Instance.new("UICorner", Label).CornerRadius = UDim.new(0, 5)

    return Label
end

local function makeButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Control"
    Button.Size = UDim2.new(1, -4, 0, 34)
    Button.BackgroundColor3 = Color3.fromRGB(38, 36, 43)
    Button.BorderSizePixel = 0
    Button.TextColor3 = Color3.fromRGB(230, 230, 235)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 12
    Button.Text = text
    Button.LayoutOrder = nextOrder()
    Button.Parent = Content

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    Button.MouseEnter:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = Color3.fromRGB(53, 43, 53)}
        ):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = Color3.fromRGB(38, 36, 43)}
        ):Play()
    end)

    Button.Activated:Connect(function()
        callback(Button)
    end)

    return Button
end

local function makeStatusButton(label, key)
    local Button

    local function refresh()
        Button.Text = label .. ": " .. (Config[key] and "ACTIVADO" or "DESACTIVADO")
        Button.TextColor3 = Config[key]
            and Color3.fromRGB(110, 255, 160)
            or Color3.fromRGB(230, 230, 235)
    end

    Button = makeButton(label, function()
        Config[key] = not Config[key]
        refresh()
    end)

    refresh()
    return Button, refresh
end

local function makeValueButton(label, key, minValue, maxValue, step)
    local Button

    local function refresh()
        Button.Text = label .. ": " .. tostring(Config[key])
    end

    Button = makeButton("", function()
        Config[key] += step
        if Config[key] > maxValue then
            Config[key] = minValue
        end
        refresh()
    end)

    refresh()
    return Button
end

-- =========================================================
-- ARRASTRAR Y MINIMIZAR
-- =========================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local minimized = false

MinButton.Activated:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    Panel.Size = minimized
        and UDim2.fromOffset(350, 52)
        or UDim2.fromOffset(350, 500)

    MinButton.Text = minimized and "+" or "—"
end)

-- =========================================================
-- CONFIGURACIÓN VISUAL
-- =========================================================

makeSection("ESP | VISUALES")

makeStatusButton("Nombres", "Names")
makeStatusButton("Cajas 2D", "Boxes")
makeStatusButton("Corner ESP", "Corners")
makeStatusButton("Barras de salud", "Health")
makeStatusButton("Distancia", "Distance")
makeStatusButton("Esqueleto R6/R15", "Skeleton")
makeStatusButton("Resaltado Highlight", "Highlights")
makeStatusButton("Filtro de equipo", "TeamCheck")

makeButton("Distancia máxima: cambiar valor", function()
    Config.MaxDistance = Config.MaxDistance + 250
    if Config.MaxDistance > 2000 then
        Config.MaxDistance = 250
    end
end)

makeSection("ESP | COLOR")

local ColorStatus = makeButton("Color ESP: ROJO", function()
    PaletteIndex += 1

    if PaletteIndex > #ESPPresets then
        PaletteIndex = 1
    end

    local preset = ESPPresets[PaletteIndex]
    Config.ESPColor = preset[2]
    Config.Rainbow = false

    ColorStatus.Text = "Color ESP: " .. preset[1]
    ColorStatus.TextColor3 = Config.ESPColor
end)

ColorStatus.TextColor3 = Config.ESPColor

makeStatusButton("RGB / Rainbow ESP", "Rainbow")

makeButton("R +32 (color personalizado)", function()
    Config.Rainbow = false
    Config.CustomR = (Config.CustomR + 32) % 256
    Config.ESPColor = Color3.fromRGB(
        Config.CustomR, Config.CustomG, Config.CustomB
    )
    ColorStatus.Text = "Color ESP: PERSONALIZADO"
    ColorStatus.TextColor3 = Config.ESPColor
end)

makeButton("G +32 (color personalizado)", function()
    Config.Rainbow = false
    Config.CustomG = (Config.CustomG + 32) % 256
    Config.ESPColor = Color3.fromRGB(
        Config.CustomR, Config.CustomG, Config.CustomB
    )
    ColorStatus.Text = "Color ESP: PERSONALIZADO"
    ColorStatus.TextColor3 = Config.ESPColor
end)

makeButton("B +32 (color personalizado)", function()
    Config.Rainbow = false
    Config.CustomB = (Config.CustomB + 32) % 256
    Config.ESPColor = Color3.fromRGB(
        Config.CustomR, Config.CustomG, Config.CustomB
    )
    ColorStatus.Text = "Color ESP: PERSONALIZADO"
    ColorStatus.TextColor3 = Config.ESPColor
end)

makeSection("HUD")

makeStatusButton("Punto de mira", "Crosshair")
makeStatusButton("Círculo FOV visual", "FOV")
makeStatusButton("Contador FPS", "FPS")
makeStatusButton("Información de diagnóstico", "Debug")

makeValueButton("Tamaño del punto de mira", "CrosshairSize", 4, 24, 2)
makeValueButton("Radio del círculo FOV", "FOVRadius", 40, 300, 20)
makeValueButton("Tamaño del texto", "TextSize", 10, 22, 1)

makeSection("INTERFAZ")

makeButton("Cambiar tema de interfaz", function()
    local names = {"ROJO", "AZUL", "VERDE", "MORADO", "BLANCO"}

    local current = 1
    for i, name in ipairs(names) do
        if name == Config.Theme then
            current = i
            break
        end
    end

    current += 1
    if current > #names then
        current = 1
    end

    Config.Theme = names[current]
    Config.UIAccent = ThemeColors[Config.Theme]

    Title.TextColor3 = Config.UIAccent
    PanelStroke.Color = Config.UIAccent
    Content.ScrollBarImageColor3 = Config.UIAccent
end)

-- =========================================================
-- HUD EN PANTALLA
-- =========================================================

local HUD = Instance.new("Frame")
HUD.Name = "HUD"
HUD.Size = UDim2.fromScale(1, 1)
HUD.BackgroundTransparency = 1
HUD.Parent = GUI

local Crosshair = Instance.new("TextLabel")
Crosshair.Name = "Crosshair"
Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
Crosshair.Position = UDim2.fromScale(0.5, 0.5)
Crosshair.Size = UDim2.fromOffset(30, 30)
Crosshair.BackgroundTransparency = 1
Crosshair.Text = "+"
Crosshair.TextSize = Config.CrosshairSize * 2
Crosshair.Font = Enum.Font.GothamBold
Crosshair.TextColor3 = Config.ESPColor
Crosshair.Visible = false
Crosshair.Parent = HUD

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(Config.FOVRadius * 2, Config.FOVRadius * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = HUD

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1
FOVStroke.Color = Config.ESPColor
FOVStroke.Parent = FOVCircle

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Position = UDim2.fromOffset(12, 12)
FPSLabel.Size = UDim2.fromOffset(180, 24)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Color3.new(1, 1, 1)
FPSLabel.TextSize = 14
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = HUD

local DebugLabel = Instance.new("TextLabel")
DebugLabel.Position = UDim2.fromOffset(12, 38)
DebugLabel.Size = UDim2.fromOffset(300, 60)
DebugLabel.BackgroundTransparency = 1
DebugLabel.TextColor3 = Color3.new(1, 1, 1)
DebugLabel.TextSize = 12
DebugLabel.Font = Enum.Font.Code
DebugLabel.TextXAlignment = Enum.TextXAlignment.Left
DebugLabel.TextYAlignment = Enum.TextYAlignment.Top
DebugLabel.Parent = HUD

-- =========================================================
-- SISTEMA ESP POR JUGADOR
-- =========================================================

local ESP = {}

local function createLine(parent)
    local line = Instance.new("Frame")
    line.Name = "ESPLine"
    line.AnchorPoint = Vector2.new(0, 0.5)
    line.BorderSizePixel = 0
    line.BackgroundColor3 = Config.ESPColor
    line.Visible = false
    line.Parent = parent
    return line
end

local function updateLine(line, p1, p2, color, thickness)
    local delta = p2 - p1
    local length = delta.Magnitude

    line.Position = UDim2.fromOffset(p1.X, p1.Y)
    line.Size = UDim2.fromOffset(length, thickness or 2)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.BackgroundColor3 = color
    line.Visible = true
end

local function hideLine(line)
    line.Visible = false
end

local function makePlayerESP(player)
    if ESP[player] then
        return ESP[player]
    end

    local folder = Instance.new("Folder")
    folder.Name = "ESP_" .. player.UserId
    folder.Parent = HUD

    local data = {
        Folder = folder,
        Lines = {},
        Corners = {},
        Highlight = nil,
    }

    local Box = Instance.new("Frame")
    Box.Name = "Box"
    Box.BackgroundTransparency = 1
    Box.BorderSizePixel = 0
    Box.Visible = false
    Box.Parent = folder

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Thickness = 1.5
    BoxStroke.Color = Config.ESPColor
    BoxStroke.Parent = Box

    local Name = Instance.new("TextLabel")
    Name.Name = "Name"
    Name.AnchorPoint = Vector2.new(0.5, 1)
    Name.BackgroundTransparency = 1
    Name.Size = UDim2.fromOffset(220, 20)
    Name.TextColor3 = Config.ESPColor
    Name.TextStrokeTransparency = 0.35
    Name.Font = Enum.Font.GothamBold
    Name.TextSize = Config.TextSize
    Name.Visible = false
    Name.Parent = folder

    local Distance = Instance.new("TextLabel")
    Distance.Name = "Distance"
    Distance.AnchorPoint = Vector2.new(0.5, 0)
    Distance.BackgroundTransparency = 1
    Distance.Size = UDim2.fromOffset(160, 18)
    Distance.TextColor3 = Config.ESPColor
    Distance.TextStrokeTransparency = 0.35
    Distance.Font = Enum.Font.Gotham
    Distance.TextSize = Config.TextSize
    Distance.Visible = false
    Distance.Parent = folder

    local HealthBack = Instance.new("Frame")
    HealthBack.Name = "HealthBack"
    HealthBack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    HealthBack.BorderSizePixel = 0
    HealthBack.Visible = false
    HealthBack.Parent = folder

    local HealthFill = Instance.new("Frame")
    HealthFill.Name = "HealthFill"
    HealthFill.BorderSizePixel = 0
    HealthFill.BackgroundColor3 = Color3.fromRGB(70, 255, 110)
    HealthFill.AnchorPoint = Vector2.new(0, 1)
    HealthFill.Position = UDim2.new(0, 0, 1, 0)
    HealthFill.Size = UDim2.new(1, 0, 1, 0)
    HealthFill.Parent = HealthBack

    data.Box = Box
    data.BoxStroke = BoxStroke
    data.Name = Name
    data.Distance = Distance
    data.HealthBack = HealthBack
    data.HealthFill = HealthFill

    for i = 1, 8 do
        data.Corners[i] = createLine(folder)
    end

    for i = 1, 15 do
        data.Lines[i] = createLine(folder)
    end

    ESP[player] = data
    return data
end

local function cleanupPlayer(player)
    local data = ESP[player]
    if data then
        if data.Highlight then
            data.Highlight:Destroy()
        end
        data.Folder:Destroy()
        ESP[player] = nil
    end
end

local function getSkeletonPairs(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then
        return {}
    end

    if hum.RigType == Enum.HumanoidRigType.R6 then
        return {
            {"Head", "Torso"},
            {"Torso", "Left Arm"},
            {"Torso", "Right Arm"},
            {"Torso", "Left Leg"},
            {"Torso", "Right Leg"},
        }
    end

    return {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
    }
end

local function getBoxBounds(character, camera)
    local ok, cf, size = pcall(function()
        return character:GetBoundingBox()
    end)

    if not ok then
        return nil
    end

    local half = size / 2

    local corners = {
        Vector3.new(-half.X, -half.Y, -half.Z),
        Vector3.new(-half.X, -half.Y, half.Z),
        Vector3.new(-half.X, half.Y, -half.Z),
        Vector3.new(-half.X, half.Y, half.Z),
        Vector3.new(half.X, -half.Y, -half.Z),
        Vector3.new(half.X, -half.Y, half.Z),
        Vector3.new(half.X, half.Y, -half.Z),
        Vector3.new(half.X, half.Y, half.Z),
    }

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge

    for _, corner in ipairs(corners) do
        local screen = camera:WorldToViewportPoint(cf:PointToWorldSpace(corner))

        if screen.Z <= 0 then
            return nil
        end

        minX = math.min(minX, screen.X)
        minY = math.min(minY, screen.Y)
        maxX = math.max(maxX, screen.X)
        maxY = math.max(maxY, screen.Y)
    end

    if maxX <= minX or maxY <= minY then
        return nil
    end

    return minX, minY, maxX, maxY
end

local function updateESP(player, data, camera)
    local character = player.Character
    local localCharacter = LocalPlayer.Character

    if not character or not localCharacter then
        data.Folder.Parent = nil
        return
    end

    data.Folder.Parent = HUD

    local hum = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")

    if not hum or not root or not localRoot or hum.Health <= 0 then
        data.Box.Visible = false
        data.Name.Visible = false
        data.Distance.Visible = false
        data.HealthBack.Visible = false

        for _, line in ipairs(data.Lines) do
            hideLine(line)
        end
        for _, line in ipairs(data.Corners) do
            hideLine(line)
        end

        if data.Highlight then
            data.Highlight.Enabled = false
        end
        return
    end

    if Config.TeamCheck and LocalPlayer.Team ~= nil
        and player.Team == LocalPlayer.Team then

        data.Box.Visible = false
        data.Name.Visible = false
        data.Distance.Visible = false
        data.HealthBack.Visible = false

        for _, line in ipairs(data.Lines) do
            hideLine(line)
        end
        for _, line in ipairs(data.Corners) do
            hideLine(line)
        end
        if data.Highlight then
            data.Highlight.Enabled = false
        end
        return
    end

    local distance = (root.Position - localRoot.Position).Magnitude

    if distance > Config.MaxDistance then
        data.Box.Visible = false
        data.Name.Visible = false
        data.Distance.Visible = false
        data.HealthBack.Visible = false

        for _, line in ipairs(data.Lines) do
            hideLine(line)
        end
        for _, line in ipairs(data.Corners) do
            hideLine(line)
        end
        if data.Highlight then
            data.Highlight.Enabled = false
        end
        return
    end

    local minX, minY, maxX, maxY = getBoxBounds(character, camera)

    if not minX then
        data.Box.Visible = false
        data.Name.Visible = false
        data.Distance.Visible = false
        data.HealthBack.Visible = false

        for _, line in ipairs(data.Lines) do
            hideLine(line)
        end
        for _, line in ipairs(data.Corners) do
            hideLine(line)
        end
        if data.Highlight then
            data.Highlight.Enabled = false
        end
        return
    end

    local width = maxX - minX
    local height = maxY - minY

    local color = Config.ESPColor

    data.Box.Visible = Config.Boxes and not Config.Corners
    data.Box.Position = UDim2.fromOffset(minX, minY)
    data.Box.Size = UDim2.fromOffset(width, height)
    data.BoxStroke.Color = color

    -- Corner ESP: cuatro esquinas, dos segmentos por esquina.
    if Config.Corners then
        local horizontal = math.max(8, width * 0.25)
        local vertical = math.max(8, height * 0.18)

        local segments = {
            {Vector2.new(minX, minY), Vector2.new(minX + horizontal, minY)},
            {Vector2.new(minX, minY), Vector2.new(minX, minY + vertical)},
            {Vector2.new(maxX - horizontal, minY), Vector2.new(maxX, minY)},
            {Vector2.new(maxX, minY), Vector2.new(maxX, minY + vertical)},
            {Vector2.new(minX, maxY - vertical), Vector2.new(minX, maxY)},
            {Vector2.new(minX, maxY), Vector2.new(minX + horizontal, maxY)},
            {Vector2.new(maxX, maxY - vertical), Vector2.new(maxX, maxY)},
            {Vector2.new(maxX - horizontal, maxY), Vector2.new(maxX, maxY)},
        }

        for i, segment in ipairs(segments) do
            updateLine(data.Corners[i], segment[1], segment[2], color, 2)
        end
    else
        for _, line in ipairs(data.Corners) do
            hideLine(line)
        end
    end

    data.Name.Visible = Config.Names
    data.Name.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    data.Name.TextColor3 = color
    data.Name.TextSize = Config.TextSize
    data.Name.Position = UDim2.fromOffset((minX + maxX) / 2, minY - 3)

    data.Distance.Visible = Config.Distance
    data.Distance.Text = string.format("%d studs", math.floor(distance))
    data.Distance.TextColor3 = color
    data.Distance.TextSize = Config.TextSize
    data.Distance.Position = UDim2.fromOffset((minX + maxX) / 2, maxY + 2)

    data.HealthBack.Visible = Config.Health
    data.HealthBack.Position = UDim2.fromOffset(minX - 7, minY)
    data.HealthBack.Size = UDim2.fromOffset(4, height)

    local healthPercent = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
    data.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
    data.HealthFill.BackgroundColor3 = Color3.fromRGB(
        255 * (1 - healthPercent),
        255 * healthPercent,
        50
    )

    -- Highlight ESP.
    if Config.Highlights then
        if not data.Highlight or data.Highlight.Parent ~= character then
            if data.Highlight then
                data.Highlight:Destroy()
            end

            local highlight = Instance.new("Highlight")
            highlight.Name = "SecrethA_Highlight"
            highlight.Adornee = character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character
            data.Highlight = highlight
        end

        data.Highlight.Enabled = true
        data.Highlight.FillColor = color
        data.Highlight.OutlineColor = color
        data.Highlight.FillTransparency = 0.75
        data.Highlight.OutlineTransparency = 0
    elseif data.Highlight then
        data.Highlight.Enabled = false
    end

    -- Esqueleto compatible con los nombres de articulaciones R6/R15.
    if Config.Skeleton then
        local pairsList = getSkeletonPairs(character)
        local lineIndex = 0

        for _, pair in ipairs(pairsList) do
            lineIndex += 1

            local partA = character:FindFirstChild(pair[1])
            local partB = character:FindFirstChild(pair[2])
            local line = data.Lines[lineIndex]

            if partA and partB and line then
                local p1, visibleA = camera:WorldToViewportPoint(partA.Position)
                local p2, visibleB = camera:WorldToViewportPoint(partB.Position)

                if visibleA and visibleB and p1.Z > 0 and p2.Z > 0 then
                    updateLine(
                        line,
                        Vector2.new(p1.X, p1.Y),
                        Vector2.new(p2.X, p2.Y),
                        color,
                        2
                    )
                else
                    hideLine(line)
                end
            elseif line then
                hideLine(line)
            end
        end

        for i = lineIndex + 1, #data.Lines do
            hideLine(data.Lines[i])
        end
    else
        for _, line in ipairs(data.Lines) do
            hideLine(line)
        end
    end
end

-- =========================================================
-- ACTUALIZACIÓN
-- =========================================================

local frames = 0
local elapsed = 0
local currentFPS = 0
local rainbowHue = 0

local connection
connection = RunService.RenderStepped:Connect(function(dt)
    if not GUI.Parent then
        connection:Disconnect()
        return
    end

    frames += 1
    elapsed += dt

    if elapsed >= 0.5 then
        currentFPS = math.floor(frames / elapsed)
        frames = 0
        elapsed = 0
    end

    if Config.Rainbow then
        rainbowHue = (rainbowHue + dt * 0.35) % 1
        Config.ESPColor = Color3.fromHSV(rainbowHue, 1, 1)
    end

    Crosshair.Visible = Config.Crosshair
    Crosshair.TextSize = Config.CrosshairSize * 2
    Crosshair.TextColor3 = Config.ESPColor

    FOVCircle.Visible = Config.FOV
    FOVCircle.Size = UDim2.fromOffset(
        Config.FOVRadius * 2,
        Config.FOVRadius * 2
    )
    FOVStroke.Color = Config.ESPColor

    FPSLabel.Visible = Config.FPS
    FPSLabel.Text = "SecrethA | FPS: " .. tostring(currentFPS)

    DebugLabel.Visible = Config.Debug
    DebugLabel.Text = string.format(
        "Jugadores: %d\nDistancia máxima: %d\nModo RGB: %s",
        #Players:GetPlayers(),
        Config.MaxDistance,
        tostring(Config.Rainbow)
    )

    local camera = getCamera()
    if not camera then
        return
    end

    -- Actualizar jugadores existentes.
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local data = makePlayerESP(player)

            local ok, err = pcall(function()
                updateESP(player, data, camera)
            end)

            if not ok then
                warn("[SecrethA] Error de ESP para " .. player.Name .. ": " .. tostring(err))
            end
        end
    end

    -- Cambiar el color de los elementos visuales sin recrearlos.
    for _, data in pairs(ESP) do
        data.BoxStroke.Color = Config.ESPColor
        data.Name.TextColor3 = Config.ESPColor
        data.Distance.TextColor3 = Config.ESPColor
    end
end)

Players.PlayerRemoving:Connect(cleanupPlayer)

-- Limpiar conexiones y elementos al destruir la GUI.
GUI.Destroying:Connect(function()
    if connection then
        connection:Disconnect()
    end

    for player in pairs(ESP) do
        cleanupPlayer(player)
    end
end)

print("[SecrethA " .. VERSION .. "] Cargado. Comprueba la ventana Output para detectar errores.")
