--[[
    SecrethA V2
    Visual ESP para experiencias propias de Roblox Studio.
    Compatible con personajes R6 y R15.

    Coloca este código en un LocalScript dentro de:
    StarterPlayer > StarterPlayerScripts
]]

--==================================================
-- SERVICIOS
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURACIÓN
--==================================================

local CONFIG = {
    PlayerESP = true,
    NameESP = true,
    BoxESP = true,
    TrackerESP = false,
    HealthESP = true,
    DistanceESP = true,
    SkeletonESP = true,
    ChamsESP = false,
    FOVCircle = false,
    HitboxESP = false,
    DamageIndicator = true,
    CustomCrosshair = true,
    RecoilVisualizer = false,

    MaxDistance = 1500,
    FOVRadius = 120,

    MainColor = Color3.fromRGB(255, 45, 65),
    TextColor = Color3.fromRGB(255, 255, 255),
    BackgroundColor = Color3.fromRGB(16, 16, 21),
    PanelColor = Color3.fromRGB(25, 25, 32),
    AccentColor = Color3.fromRGB(210, 30, 50),
    HealthColor = Color3.fromRGB(50, 220, 100),
}

local VISUAL_FOLDER_NAME = "SecrethA_Visuals"

--==================================================
-- LIMPIEZA DE UNA EJECUCIÓN ANTERIOR
--==================================================

local previousGui = PlayerGui:FindFirstChild("SecrethA_V2_GUI")
if previousGui then
    previousGui:Destroy()
end

local previousFolder = Workspace:FindFirstChild(VISUAL_FOLDER_NAME)
if previousFolder then
    previousFolder:Destroy()
end

--==================================================
-- CARPETA DE EFECTOS VISUALES
--==================================================

local VisualFolder = Instance.new("Folder")
VisualFolder.Name = VISUAL_FOLDER_NAME
VisualFolder.Parent = Workspace

--==================================================
-- INTERFAZ
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SecrethA_V2_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 50
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(340, 440)
Main.Position = UDim2.new(0, 25, 0.5, -220)
Main.BackgroundColor3 = CONFIG.BackgroundColor
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CONFIG.AccentColor
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundColor3 = Color3.fromRGB(31, 20, 26)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 0, 27)
Title.Position = UDim2.fromOffset(14, 5)
Title.BackgroundTransparency = 1
Title.Text = "SECRETHA V2"
Title.TextColor3 = CONFIG.TextColor
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -70, 0, 16)
Subtitle.Position = UDim2.fromOffset(15, 30)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "VISUAL CONTROL PANEL  |  R6 + R15"
Subtitle.TextColor3 = Color3.fromRGB(190, 155, 165)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.fromOffset(32, 30)
MinimizeButton.Position = UDim2.new(1, -42, 0, 11)
MinimizeButton.BackgroundColor3 = CONFIG.AccentColor
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -112)
Content.Position = UDim2.fromOffset(10, 62)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = CONFIG.AccentColor
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 7)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = Content

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingBottom = UDim.new(0, 8)
ContentPadding.PaddingTop = UDim.new(0, 4)
ContentPadding.PaddingLeft = UDim.new(0, 3)
ContentPadding.PaddingRight = UDim.new(0, 3)
ContentPadding.Parent = Content

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -20, 0, 27)
Footer.Position = UDim2.new(0, 10, 1, -35)
Footer.BackgroundTransparency = 1
Footer.Text = "SECRETHA  •  VISUALS ONLY"
Footer.TextColor3 = Color3.fromRGB(155, 155, 165)
Footer.TextSize = 10
Footer.Font = Enum.Font.GothamMedium
Footer.Parent = Main

local function createSection(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = string.upper(text)
    label.TextColor3 = CONFIG.MainColor
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Content
    return label
end

local function createToggle(labelText, configKey)
    local button = Instance.new("TextButton")
    button.Name = configKey .. "Toggle"
    button.Size = UDim2.new(1, -4, 0, 34)
    button.BackgroundColor3 = CONFIG.PanelColor
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Text = ""
    button.Parent = Content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = CONFIG.TextColor
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromOffset(36, 18)
    indicator.Position = UDim2.new(1, -46, 0.5, -9)
    indicator.BorderSizePixel = 0
    indicator.Parent = button

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator

    local function update()
        local enabled = CONFIG[configKey]
        indicator.BackgroundColor3 = enabled
            and CONFIG.AccentColor
            or Color3.fromRGB(65, 65, 75)

        label.TextColor3 = enabled
            and Color3.new(1, 1, 1)
            or Color3.fromRGB(175, 175, 185)
    end

    button.Activated:Connect(function()
        CONFIG[configKey] = not CONFIG[configKey]
        update()
    end)

    update()
    return button
end

createSection("Player visuals")
createToggle("Player ESP", "PlayerESP")
createToggle("Names", "NameESP")
createToggle("Bounding boxes", "BoxESP")
createToggle("Tracker lines", "TrackerESP")
createToggle("Health bars", "HealthESP")
createToggle("Distance", "DistanceESP")
createToggle("Skeleton", "SkeletonESP")
createToggle("Character highlight", "ChamsESP")
createToggle("Hitbox display", "HitboxESP")

createSection("Screen visuals")
createToggle("FOV circle", "FOVCircle")
createToggle("Custom crosshair", "CustomCrosshair")
createToggle("Damage indicator", "DamageIndicator")
createToggle("Recoil visualizer (demo)", "RecoilVisualizer")

--==================================================
-- ARRASTRAR LA INTERFAZ
--==================================================

local dragging = false
local dragStart
local startPosition
local dragInput

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

local minimized = false

MinimizeButton.Activated:Connect(function()
    minimized = not minimized

    Content.Visible = not minimized
    Footer.Visible = not minimized

    Main.Size = minimized
        and UDim2.fromOffset(340, 52)
        or UDim2.fromOffset(340, 440)

    MinimizeButton.Text = minimized and "+" or "—"
end)

--==================================================
-- DIBUJOS EN PANTALLA
--==================================================

local function createDrawing(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = ScreenGui
    return object
end

local FOVCircle = createDrawing("Frame", {
    Name = "FOVCircle",
    Size = UDim2.fromOffset(CONFIG.FOVRadius * 2, CONFIG.FOVRadius * 2),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Visible = false,
})

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = CONFIG.MainColor
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.1
FOVStroke.Parent = FOVCircle

local Crosshair = Instance.new("Frame")
Crosshair.Name = "Crosshair"
Crosshair.Size = UDim2.fromOffset(4, 4)
Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
Crosshair.BackgroundColor3 = CONFIG.MainColor
Crosshair.BorderSizePixel = 0
Crosshair.Visible = false
Crosshair.Parent = ScreenGui

local CrosshairCorner = Instance.new("UICorner")
CrosshairCorner.CornerRadius = UDim.new(1, 0)
CrosshairCorner.Parent = Crosshair

local RecoilDemo = Instance.new("Frame")
RecoilDemo.Name = "RecoilDemo"
RecoilDemo.Size = UDim2.fromOffset(100, 32)
RecoilDemo.BackgroundTransparency = 1
RecoilDemo.AnchorPoint = Vector2.new(0.5, 0.5)
RecoilDemo.Visible = false
RecoilDemo.Parent = ScreenGui

local RecoilText = Instance.new("TextLabel")
RecoilText.Size = UDim2.fromScale(1, 1)
RecoilText.BackgroundTransparency = 1
RecoilText.Text = "RECOIL DEMO"
RecoilText.TextColor3 = CONFIG.MainColor
RecoilText.TextSize = 12
RecoilText.Font = Enum.Font.GothamBold
RecoilText.Parent = RecoilDemo

--==================================================
-- FUNCIONES AUXILIARES
--==================================================

local function getCharacterParts(player)
    local character = player.Character
    if not character then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")

    if not humanoid or not root or not head then
        return nil
    end

    if humanoid.Health <= 0 then
        return nil
    end

    return character, humanoid, root, head
end

local function getDistance(character)
    local myCharacter = LocalPlayer.Character
    if not myCharacter then
        return math.huge
    end

    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local targetRoot = character:FindFirstChild("HumanoidRootPart")

    if not myRoot or not targetRoot then
        return math.huge
    end

    return (myRoot.Position - targetRoot.Position).Magnitude
end

local function getScreenPosition(worldPosition)
    local point, visible = Camera:WorldToViewportPoint(worldPosition)

    return Vector2.new(point.X, point.Y), visible and point.Z > 0
end

local function createLine(parent, color, thickness)
    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BorderSizePixel = 0
    line.BackgroundColor3 = color
    line.Size = UDim2.fromOffset(1, thickness or 2)
    line.Visible = false
    line.Parent = parent
    return line
end

local function setLine(line, pointA, pointB, color, thickness)
    local delta = pointB - pointA
    local length = delta.Magnitude

    line.Position = UDim2.fromOffset(
        (pointA.X + pointB.X) / 2,
        (pointA.Y + pointB.Y) / 2
    )

    line.Size = UDim2.fromOffset(length, thickness or 2)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.BackgroundColor3 = color
    line.Visible = true
end

--==================================================
-- PARES DEL ESQUELETO: R6 Y R15
--==================================================

local R6_PAIRS = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

local R15_PAIRS = {
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

local function getSkeletonPairs(humanoid)
    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        return R6_PAIRS
    end

    return R15_PAIRS
end

--==================================================
-- DATOS VISUALES DE CADA JUGADOR
--==================================================

local PlayerData = {}

local function makePlayerData(player)
    if player == LocalPlayer or PlayerData[player] then
        return
    end

    local folder = Instance.new("Folder")
    folder.Name = "Player_" .. player.UserId
    folder.Parent = VisualFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.fromOffset(200, 20)
    nameLabel.AnchorPoint = Vector2.new(0.5, 1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = CONFIG.TextColor
    nameLabel.TextStrokeTransparency = 0.35
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Visible = false
    nameLabel.Parent = ScreenGui

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.fromOffset(150, 18)
    distanceLabel.AnchorPoint = Vector2.new(0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
    distanceLabel.TextStrokeTransparency = 0.35
    distanceLabel.TextSize = 11
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Visible = false
    distanceLabel.Parent = ScreenGui

    local healthBackground = Instance.new("Frame")
    healthBackground.Name = "HealthBackground"
    healthBackground.Size = UDim2.fromOffset(5, 70)
    healthBackground.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    healthBackground.BorderSizePixel = 0
    healthBackground.Visible = false
    healthBackground.Parent = ScreenGui

    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.AnchorPoint = Vector2.new(0, 1)
    healthFill.Position = UDim2.new(0, 0, 1, 0)
    healthFill.Size = UDim2.fromScale(1, 1)
    healthFill.BackgroundColor3 = CONFIG.HealthColor
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBackground

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = ScreenGui

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = CONFIG.MainColor
    boxStroke.Thickness = 1.5
    boxStroke.Parent = box

    local tracker = createLine(ScreenGui, CONFIG.MainColor, 1.5)

    local skeletonLines = {}
    for i = 1, #R15_PAIRS do
        skeletonLines[i] = createLine(ScreenGui, CONFIG.MainColor, 1.5)
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.FillColor = CONFIG.MainColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0.1
    highlight.Enabled = false
    highlight.Parent = folder

    local hitboxes = {}

    local damageLabel = Instance.new("TextLabel")
    damageLabel.Name = "DamageIndicator"
    damageLabel.Size = UDim2.fromOffset(100, 22)
    damageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    damageLabel.BackgroundTransparency = 1
    damageLabel.TextColor3 = CONFIG.MainColor
    damageLabel.TextStrokeTransparency = 0.3
    damageLabel.TextSize = 15
    damageLabel.Font = Enum.Font.GothamBold
    damageLabel.Visible = false
    damageLabel.Parent = ScreenGui

    PlayerData[player] = {
        Folder = folder,
        Name = nameLabel,
        Distance = distanceLabel,
        HealthBackground = healthBackground,
        HealthFill = healthFill,
        Box = box,
        Tracker = tracker,
        Skeleton = skeletonLines,
        Highlight = highlight,
        Hitboxes = hitboxes,
        DamageLabel = damageLabel,
        LastHealth = nil,
        DamageUntil = 0,
        LastCharacter = nil,
    }
end

local function hidePlayerData(data)
    data.Name.Visible = false
    data.Distance.Visible = false
    data.HealthBackground.Visible = false
    data.Box.Visible = false
    data.Tracker.Visible = false
    data.Highlight.Enabled = false
    data.DamageLabel.Visible = false

    for _, line in ipairs(data.Skeleton) do
        line.Visible = false
    end

    for _, selectionBox in pairs(data.Hitboxes) do
        selectionBox.Visible = false
    end
end

local function clearHitboxes(data)
    for _, selectionBox in pairs(data.Hitboxes) do
        selectionBox:Destroy()
    end

    table.clear(data.Hitboxes)
end

local function removePlayerData(player)
    local data = PlayerData[player]
    if not data then
        return
    end

    data.Name:Destroy()
    data.Distance:Destroy()
    data.HealthBackground:Destroy()
    data.Box:Destroy()
    data.Tracker:Destroy()
    data.DamageLabel:Destroy()

    for _, line in ipairs(data.Skeleton) do
        line:Destroy()
    end

    data.Folder:Destroy()
    PlayerData[player] = nil
end

local function setupPlayer(player)
    makePlayerData(player)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removePlayerData)

--==================================================
-- ACTTUALIZACIÓN VISUAL
--==================================================

local function updatePlayer(player, data)
    local character, humanoid, root, head = getCharacterParts(player)

    if not character then
        hidePlayerData(data)
        return
    end

    if player.Team ~= nil
        and LocalPlayer.Team ~= nil
        and player.Team == LocalPlayer.Team then
        hidePlayerData(data)
        return
    end

    local distance = getDistance(character)

    if distance > CONFIG.MaxDistance then
        hidePlayerData(data)
        return
    end

    local rootPosition, rootVisible = getScreenPosition(root.Position)
    local headPosition, headVisible = getScreenPosition(
        head.Position + Vector3.new(0, 0.5, 0)
    )

    if not rootVisible then
        hidePlayerData(data)
        return
    end

    -- Si cambia el personaje, reiniciar datos de salud y hitboxes.
    if data.LastCharacter ~= character then
        data.LastCharacter = character
        data.LastHealth = humanoid.Health
        data.DamageUntil = 0
        clearHitboxes(data)
    end

    -- ESP general.
    local espEnabled = CONFIG.PlayerESP

    -- Nombre.
    data.Name.Visible = espEnabled and CONFIG.NameESP and headVisible
    data.Name.Position = UDim2.fromOffset(
        headPosition.X,
        headPosition.Y - 6
    )
    data.Name.Text = player.DisplayName

    -- Distancia.
    data.Distance.Visible = espEnabled and CONFIG.DistanceESP
    data.Distance.Position = UDim2.fromOffset(
        rootPosition.X,
        rootPosition.Y + 20
    )
    data.Distance.Text = string.format("%d studs", math.floor(distance))

    -- Caja calculada usando el tamaño real del personaje.
    if espEnabled and CONFIG.BoxESP then
        local success, boundingCFrame, boundingSize = pcall(function()
            return character:GetBoundingBox()
        end)

        if success then
            local half = boundingSize / 2

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
            local valid = true

            for _, cornerPosition in ipairs(corners) do
                local worldPoint = boundingCFrame:PointToWorldSpace(cornerPosition)
                local screenPoint, visible = getScreenPosition(worldPoint)

                if not visible then
                    valid = false
                    break
                end

                minX = math.min(minX, screenPoint.X)
                minY = math.min(minY, screenPoint.Y)
                maxX = math.max(maxX, screenPoint.X)
                maxY = math.max(maxY, screenPoint.Y)
            end

            if valid then
                data.Box.Position = UDim2.fromOffset(minX, minY)
                data.Box.Size = UDim2.fromOffset(
                    math.max(2, maxX - minX),
                    math.max(2, maxY - minY)
                )
                data.Box.Visible = true
            else
                data.Box.Visible = false
            end
        else
            data.Box.Visible = false
        end
    else
        data.Box.Visible = false
    end

    -- Barra de vida.
    data.HealthBackground.Visible = espEnabled and CONFIG.HealthESP
    data.HealthBackground.Position = UDim2.fromOffset(
        rootPosition.X - 38,
        rootPosition.Y - 35
    )

    local healthRatio = math.clamp(
        humanoid.Health / math.max(humanoid.MaxHealth, 1),
        0,
        1
    )

    data.HealthFill.Size = UDim2.new(1, 0, healthRatio, 0)

    if healthRatio > 0.6 then
        data.HealthFill.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
    elseif healthRatio > 0.3 then
        data.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 190, 50)
    else
        data.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 55, 65)
    end

    -- Línea hacia el personaje.
    if espEnabled and CONFIG.TrackerESP then
        local viewport = Camera.ViewportSize
        setLine(
            data.Tracker,
            Vector2.new(viewport.X / 2, viewport.Y - 5),
            rootPosition,
            CONFIG.MainColor,
            1.5
        )
    else
        data.Tracker.Visible = false
    end

    -- Chams.
    data.Highlight.Adornee = character
    data.Highlight.Enabled = espEnabled and CONFIG.ChamsESP

    -- Skeleton compatible con R6 y R15.
    local skeletonEnabled = espEnabled and CONFIG.SkeletonESP
    local pairsForRig = getSkeletonPairs(humanoid)

    for index, pair in ipairs(R15_PAIRS) do
        local line = data.Skeleton[index]
        local rigPair = pairsForRig[index]

        if skeletonEnabled and rigPair then
            local partA = character:FindFirstChild(rigPair[1])
            local partB = character:FindFirstChild(rigPair[2])

            if partA and partB
                and partA:IsA("BasePart")
                and partB:IsA("BasePart") then

                local pointA, visibleA = getScreenPosition(partA.Position)
                local pointB, visibleB = getScreenPosition(partB.Position)

                if visibleA and visibleB then
                    setLine(
                        line,
                        pointA,
                        pointB,
                        CONFIG.MainColor,
                        2
                    )
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end

    -- Hitboxes visuales.
    if espEnabled and CONFIG.HitboxESP then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart")
                and part.Name ~= "HumanoidRootPart" then

                if not data.Hitboxes[part] then
                    local selectionBox = Instance.new("SelectionBox")
                    selectionBox.Name = "VisualHitbox"
                    selectionBox.Adornee = part
                    selectionBox.Color3 = CONFIG.MainColor
                    selectionBox.LineThickness = 0.025
                    selectionBox.SurfaceTransparency = 0.9
                    selectionBox.Parent = data.Folder

                    data.Hitboxes[part] = selectionBox
                end

                data.Hitboxes[part].Visible = true
            end
        end

        for part, selectionBox in pairs(data.Hitboxes) do
            if not part.Parent or not part:IsDescendantOf(character) then
                selectionBox:Destroy()
                data.Hitboxes[part] = nil
            end
        end
    else
        for _, selectionBox in pairs(data.Hitboxes) do
            selectionBox.Visible = false
        end
    end

    -- Indicador demostrativo cuando cambia la vida observada.
    if data.LastHealth ~= nil
        and humanoid.Health < data.LastHealth
        and CONFIG.DamageIndicator then

        local amount = math.floor(data.LastHealth - humanoid.Health)

        data.DamageLabel.Text = "-" .. tostring(amount)
        data.DamageLabel.Position = UDim2.fromOffset(
            rootPosition.X,
            rootPosition.Y - 45
        )
        data.DamageLabel.Visible = true
        data.DamageUntil = os.clock() + 0.8
    end

    data.LastHealth = humanoid.Health

    if os.clock() > data.DamageUntil then
        data.DamageLabel.Visible = false
    end
end

--==================================================
-- BUCLE PRINCIPAL
--==================================================

local renderConnection

renderConnection = RunService.RenderStepped:Connect(function()
    if not Camera or not Camera.Parent then
        Camera = Workspace.CurrentCamera
        if not Camera then
            return
        end
    end

    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    -- Círculo FOV puramente visual.
    FOVCircle.Visible = CONFIG.FOVCircle
    FOVCircle.Position = UDim2.fromOffset(center.X, center.Y)
    FOVCircle.Size = UDim2.fromOffset(
        CONFIG.FOVRadius * 2,
        CONFIG.FOVRadius * 2
    )

    -- Mira personalizada.
    Crosshair.Visible = CONFIG.CustomCrosshair
    Crosshair.Position = UDim2.fromOffset(center.X, center.Y)

    -- Indicador ilustrativo de retroceso.
    RecoilDemo.Visible = CONFIG.RecoilVisualizer
    RecoilDemo.Position = UDim2.fromOffset(
        center.X,
        center.Y + 45
    )

    for player, data in pairs(PlayerData) do
        if player.Parent == Players then
            updatePlayer(player, data)
        else
            removePlayerData(player)
        end
    end
end)

--==================================================
-- LIMPIEZA AL CERRAR
--==================================================

ScreenGui.Destroying:Connect(function()
    if renderConnection then
        renderConnection:Disconnect()
    end

    if VisualFolder and VisualFolder.Parent then
        VisualFolder:Destroy()
    end
end)

print("SecrethA V2 iniciado. Compatibilidad visual R6/R15.")
