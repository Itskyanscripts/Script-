-- =============================================
-- WALLHOP V3.0 - IMPROVED
-- Made By Nova
-- =============================================
-- Controls:
-- (-) Minus = ON/OFF
-- LCtrl = Infinite Jump Mode
-- RAlt = Cam Flick Mode
-- Mouse drag = Move GUI
-- =============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local enabled = false
local currentMode = 1  -- 1 = Inf Jump, 2 = Cam Flick

-- Default Settings
local Settings = {
    Mode1_Cooldown = 0.12,
    Mode2_Cooldown = 0.3,
    FlickAngle = 45,
    MaxChain = math.huge,
    SnapDuration = 0.04,
    JumpPower = 61,
    WallDistance = 4.2,
    SoundFeedback = true,
    VisualFeedback = true,
}

-- Persistent settings (save between sessions)
local settingsKey = "WallhopV3_Settings"
local function loadSettings()
    local success, data = pcall(function() return getgenv().WallhopSettings end)
    if success and data then
        for k, v in pairs(data) do
            if Settings[k] ~= nil then Settings[k] = v end
        end
    end
end

local function saveSettings()
    getgenv().WallhopSettings = Settings
end
loadSettings()

-- Color Palette
local C = {
    BG = Color3.fromRGB(8, 8, 12),
    Panel = Color3.fromRGB(14, 14, 20),
    Surface = Color3.fromRGB(20, 20, 28),
    Border = Color3.fromRGB(40, 40, 55),
    Accent = Color3.fromRGB(85, 170, 255),
    Green = Color3.fromRGB(60, 230, 130),
    Red = Color3.fromRGB(240, 70, 70),
    Yellow = Color3.fromRGB(255, 200, 50),
    TextMain = Color3.fromRGB(220, 220, 235),
    TextSub = Color3.fromRGB(120, 120, 145),
    TextDim = Color3.fromRGB(55, 55, 80),
    Mode1 = Color3.fromRGB(60, 230, 130),
    Mode2 = Color3.fromRGB(130, 100, 255),
}

local mode1_lastJump = 0
local mode2_lastJumpTime = 0
local mode2_jumpChain = 0
local lastWallCheck = 0
local wallhopCount = 0
local currentVelocity = Vector3.new(0, 0, 0)

-- Cleanup old GUI
for _, gui in ipairs({player.PlayerGui, game:GetService("CoreGui")}) do
    local old = gui:FindFirstChild("WallhopGUI")
    if old then old:Destroy() end
end

-- Create ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "WallhopGUI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not sg.Parent then sg.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 200, 0, 85)
frame.Position = UDim2.new(0.5, -100, 0, 18)
frame.BackgroundColor3 = C.BG
frame.BackgroundTransparency = 0.08
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local outerStroke = Instance.new("UIStroke", frame)
outerStroke.Thickness = 1.4
outerStroke.Color = C.Border

local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0.5, 0, 0, 2)
accentBar.Position = UDim2.new(0.25, 0, 0, 0)
accentBar.BackgroundColor3 = C.Accent
accentBar.ZIndex = 4
accentBar.Parent = frame
Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundTransparency = 1
header.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -40, 1, 0)
toggleBtn.Position = UDim2.new(0, 32, 0, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = ""
toggleBtn.Parent = header

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0.52, 0, 1, 0)
titleLbl.Position = UDim2.new(0, 46, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Wallhop V4.0"
titleLbl.TextColor3 = C.TextMain
titleLbl.TextSize = 14
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = header

-- Made By Nova
local madeByLbl = Instance.new("TextLabel")
madeByLbl.Size = UDim2.new(0, 80, 1, 0)
madeByLbl.Position = UDim2.new(1, -85, 0, 0)
madeByLbl.BackgroundTransparency = 1
madeByLbl.Text = "Nova"
madeByLbl.TextColor3 = C.TextDim
madeByLbl.TextSize = 9
madeByLbl.Font = Enum.Font.Gotham
madeByLbl.TextXAlignment = Enum.TextXAlignment.Right
madeByLbl.Parent = header

-- Counter display
local counterLbl = Instance.new("TextLabel")
counterLbl.Size = UDim2.new(0, 40, 1, 0)
counterLbl.Position = UDim2.new(1, -40, 0, 0)
counterLbl.BackgroundTransparency = 1
counterLbl.Text = ""
counterLbl.TextColor3 = C.Yellow
counterLbl.TextSize = 10
counterLbl.Font = Enum.Font.GothamBold
counterLbl.TextXAlignment = Enum.TextXAlignment.Right
counterLbl.Visible = false
counterLbl.Parent = header

-- Gear Button (Settings)
local gearBtn = Instance.new("TextButton")
gearBtn.Size = UDim2.new(0, 26, 0, 26)
gearBtn.Position = UDim2.new(0, 6, 0.5, -13)
gearBtn.BackgroundTransparency = 1
gearBtn.Text = "⚙"
gearBtn.TextColor3 = C.TextSub
gearBtn.TextSize = 16
gearBtn.Font = Enum.Font.GothamBold
gearBtn.Parent = header

-- Status Pill
local pillBG = Instance.new("Frame")
pillBG.Size = UDim2.new(0, 52, 0, 22)
pillBG.Position = UDim2.new(1, -58, 0.5, -11)
pillBG.BackgroundColor3 = C.Surface
pillBG.ZIndex = 3
pillBG.Parent = header
Instance.new("UICorner", pillBG).CornerRadius = UDim.new(1, 0)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 7, 0, 7)
statusDot.Position = UDim2.new(0, 7, 0.5, -3.5)
statusDot.BackgroundColor3 = C.Red
statusDot.ZIndex = 4
statusDot.Parent = pillBG
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -18, 1, 0)
statusLbl.Position = UDim2.new(0, 18, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = C.Red
statusLbl.TextSize = 11
statusLbl.Font = Enum.Font.GothamBold
statusLbl.ZIndex = 4
statusLbl.Parent = pillBG

-- Mode Tabs
local tabRow = Instance.new("Frame")
tabRow.Size = UDim2.new(1, -16, 0, 28)
tabRow.Position = UDim2.new(0.5, 0, 0, 38)
tabRow.AnchorPoint = Vector2.new(0.5, 0)
tabRow.BackgroundColor3 = C.Surface
tabRow.BorderSizePixel = 0
tabRow.Parent = frame
Instance.new("UICorner", tabRow).CornerRadius = UDim.new(0, 8)

local tabSlider = Instance.new("Frame")
tabSlider.Size = UDim2.new(0.5, -4, 1, -4)
tabSlider.Position = UDim2.new(0, 2, 0, 2)
tabSlider.BackgroundColor3 = C.Mode1
tabSlider.BackgroundTransparency = 0.75
tabSlider.ZIndex = 1
tabSlider.Parent = tabRow
Instance.new("UICorner", tabSlider).CornerRadius = UDim.new(0, 6)

local tab1 = Instance.new("TextButton")
tab1.Size = UDim2.new(0.5, -4, 1, -4)
tab1.Position = UDim2.new(0, 2, 0, 2)
tab1.BackgroundTransparency = 1
tab1.Text = "Inf Jump"
tab1.TextColor3 = C.Mode1
tab1.TextSize = 11
tab1.Font = Enum.Font.GothamBold
tab1.ZIndex = 2
tab1.Parent = tabRow

local tab2 = Instance.new("TextButton")
tab2.Size = UDim2.new(0.5, -4, 1, -4)
tab2.Position = UDim2.new(0.5, 2, 0, 2)
tab2.BackgroundTransparency = 1
tab2.Text = "Cam Flick"
tab2.TextColor3 = C.TextDim
tab2.TextSize = 11
tab2.Font = Enum.Font.GothamBold
tab2.ZIndex = 2
tab2.Parent = tabRow

local keyHint = Instance.new("TextLabel")
keyHint.Size = UDim2.new(1, -12, 0, 14)
keyHint.Position = UDim2.new(0, 6, 1, -18)
keyHint.BackgroundTransparency = 1
keyHint.Text = "(-) ON/OFF  •  LCtrl = Inf Jump  •  RAlt = Cam Flick"
keyHint.TextColor3 = C.TextDim
keyHint.TextSize = 9
keyHint.Font = Enum.Font.Gotham
keyHint.Parent = frame

-- =============================================
-- SETTINGS PANEL
-- =============================================
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0, 220, 0, 310)
settingsFrame.Position = UDim2.new(0.5, -110, 0.5, -155)
settingsFrame.BackgroundColor3 = C.BG
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
settingsFrame.ZIndex = 10
settingsFrame.Parent = sg
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 12)

local settingsStroke = Instance.new("UIStroke", settingsFrame)
settingsStroke.Color = C.Border
settingsStroke.Thickness = 1.4

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 32)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Settings"
settingsTitle.TextColor3 = C.TextMain
settingsTitle.TextSize = 14
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.Parent = settingsFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = C.Red
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = settingsFrame

local function createSetting(name, default, yPos, minVal, maxVal, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 22)
    label.Position = UDim2.new(0, 12, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = C.TextSub
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = settingsFrame

    local valueBox = Instance.new("TextBox")
    valueBox.Size = UDim2.new(0.3, 0, 0, 22)
    valueBox.Position = UDim2.new(0.68, 0, 0, yPos)
    valueBox.BackgroundColor3 = C.Surface
    valueBox.Text = tostring(default)
    valueBox.TextColor3 = C.TextMain
    valueBox.TextSize = 11
    valueBox.Font = Enum.Font.Gotham
    valueBox.Parent = settingsFrame
    Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0, 4)

    local decBtn = Instance.new("TextButton")
    decBtn.Size = UDim2.new(0, 20, 0, 20)
    decBtn.Position = UDim2.new(0.62, -25, 0, yPos + 1)
    decBtn.BackgroundColor3 = C.Surface
    decBtn.Text = "-"
    decBtn.TextColor3 = C.TextMain
    decBtn.TextSize = 14
    decBtn.Font = Enum.Font.GothamBold
    decBtn.Parent = settingsFrame
    Instance.new("UICorner", decBtn).CornerRadius = UDim.new(0, 4)

    local incBtn = Instance.new("TextButton")
    incBtn.Size = UDim2.new(0, 20, 0, 20)
    incBtn.Position = UDim2.new(0.98, -20, 0, yPos + 1)
    incBtn.BackgroundColor3 = C.Surface
    incBtn.Text = "+"
    incBtn.TextColor3 = C.TextMain
    incBtn.TextSize = 14
    incBtn.Font = Enum.Font.GothamBold
    incBtn.Parent = settingsFrame
    Instance.new("UICorner", incBtn).CornerRadius = UDim.new(0, 4)

    local currentVal = default
    local function updateValue(newVal)
        if minVal and newVal < minVal then newVal = minVal end
        if maxVal and newVal > maxVal then newVal = maxVal end
        currentVal = newVal
        valueBox.Text = tostring(math.floor(newVal * 100) / 100)
        callback(currentVal)
        saveSettings()
    end

    decBtn.MouseButton1Click:Connect(function()
        if type(currentVal) == "number" then
            updateValue(currentVal - 1)
        end
    end)
    incBtn.MouseButton1Click:Connect(function()
        if type(currentVal) == "number" then
            updateValue(currentVal + 1)
        end
    end)

    valueBox.FocusLost:Connect(function()
        local num = tonumber(valueBox.Text)
        if num then updateValue(num) end
    end)
end

createSetting("Flick Angle", Settings.FlickAngle, 42, 15, 90, function(v) Settings.FlickAngle = v end)
createSetting("Mode 2 Cooldown", Settings.Mode2_Cooldown, 68, 0.1, 1, function(v) Settings.Mode2_Cooldown = v end)
createSetting("Max Chain", Settings.MaxChain, 94, 1, 999999, function(v) Settings.MaxChain = v end)
createSetting("Snap Duration", Settings.SnapDuration, 120, 0.01, 0.15, function(v) Settings.SnapDuration = v end)
createSetting("Inf Jump Cooldown", Settings.Mode1_Cooldown, 146, 0.05, 0.5, function(v) Settings.Mode1_Cooldown = v end)
createSetting("Jump Power", Settings.JumpPower, 172, 45, 85, function(v) Settings.JumpPower = v end)

local soundFeedbackBtn = Instance.new("TextButton")
soundFeedbackBtn.Size = UDim2.new(0.3, 0, 0, 24)
soundFeedbackBtn.Position = UDim2.new(0.12, 0, 0, 200)
soundFeedbackBtn.BackgroundColor3 = Settings.SoundFeedback and C.Green or C.Red
soundFeedbackBtn.Text = Settings.SoundFeedback and "SOUND ON" or "SOUND OFF"
soundFeedbackBtn.TextColor3 = C.TextMain
soundFeedbackBtn.TextSize = 10
soundFeedbackBtn.Font = Enum.Font.GothamBold
soundFeedbackBtn.Parent = settingsFrame
Instance.new("UICorner", soundFeedbackBtn).CornerRadius = UDim.new(0, 4)

soundFeedbackBtn.MouseButton1Click:Connect(function()
    Settings.SoundFeedback = not Settings.SoundFeedback
    soundFeedbackBtn.BackgroundColor3 = Settings.SoundFeedback and C.Green or C.Red
    soundFeedbackBtn.Text = Settings.SoundFeedback and "SOUND ON" or "SOUND OFF"
    saveSettings()
end)

local visualFeedbackBtn = Instance.new("TextButton")
visualFeedbackBtn.Size = UDim2.new(0.3, 0, 0, 24)
visualFeedbackBtn.Position = UDim2.new(0.58, 0, 0, 200)
visualFeedbackBtn.BackgroundColor3 = Settings.VisualFeedback and C.Green or C.Red
visualFeedbackBtn.Text = Settings.VisualFeedback and "VISUAL ON" or "VISUAL OFF"
visualFeedbackBtn.TextColor3 = C.TextMain
visualFeedbackBtn.TextSize = 10
visualFeedbackBtn.Font = Enum.Font.GothamBold
visualFeedbackBtn.Parent = settingsFrame
Instance.new("UICorner", visualFeedbackBtn).CornerRadius = UDim.new(0, 4)

visualFeedbackBtn.MouseButton1Click:Connect(function()
    Settings.VisualFeedback = not Settings.VisualFeedback
    visualFeedbackBtn.BackgroundColor3 = Settings.VisualFeedback and C.Green or C.Red
    visualFeedbackBtn.Text = Settings.VisualFeedback and "VISUAL ON" or "VISUAL OFF"
    saveSettings()
end)

-- Reset button
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.8, 0, 0, 28)
resetBtn.Position = UDim2.new(0.1, 0, 1, -36)
resetBtn.BackgroundColor3 = C.Surface
resetBtn.Text = "Reset to Default"
resetBtn.TextColor3 = C.Yellow
resetBtn.TextSize = 11
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Parent = settingsFrame
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 4)

resetBtn.MouseButton1Click:Connect(function()
    Settings.FlickAngle = 45
    Settings.Mode2_Cooldown = 0.3
    Settings.MaxChain = math.huge
    Settings.SnapDuration = 0.04
    Settings.Mode1_Cooldown = 0.12
    Settings.JumpPower = 61
    saveSettings()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Settings Reset",
        Text = "All settings restored to default",
        Duration = 2
    })
end)

-- =============================================
-- GUI FUNCTIONS
-- =============================================
local modeColors = {C.Mode1, C.Mode2}

local function updateTabs()
    local color = modeColors[currentMode]
    TweenService:Create(tabSlider, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
        Position = UDim2.new(currentMode == 1 and 0 or 0.5, 2, 0, 2),
        BackgroundColor3 = color,
    }):Play()
    tab1.TextColor3 = currentMode == 1 and C.Mode1 or C.TextDim
    tab2.TextColor3 = currentMode == 2 and C.Mode2 or C.TextDim
end

local function playFeedback()
    if Settings.SoundFeedback then
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://9120376435"
            sound.Volume = 0.3
            sound.Parent = player.Character or Workspace
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 1)
        end)
    end
    
    if Settings.VisualFeedback then
        counterLbl.Visible = true
        counterLbl.Text = "x" .. mode2_jumpChain
        TweenService:Create(counterLbl, TweenInfo.new(0.2), {TextColor3 = C.Yellow}):Play()
        task.delay(0.5, function()
            if not enabled then
                counterLbl.Visible = false
            end
        end)
    end
end

local function setEnabled(val)
    enabled = val
    local color = val and C.Green or C.Red
    local txt = val and "ON" or "OFF"

    TweenService:Create(statusLbl, TweenInfo.new(0.15), {TextColor3 = color}):Play()
    TweenService:Create(statusDot, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
    TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundColor3 = val and modeColors[currentMode] or C.Accent}):Play()
    TweenService:Create(outerStroke, TweenInfo.new(0.2), {Color = val and modeColors[currentMode] or C.Border}):Play()
    statusLbl.Text = txt
    
    if not val then
        counterLbl.Visible = false
        mode2_jumpChain = 0
    end
end

local function toggleEnabled()
    setEnabled(not enabled)
end

-- =============================================
-- KEYBIND LOGIC
-- =============================================
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Minus then
        toggleEnabled()
        return
    end

    if input.KeyCode == Enum.KeyCode.LeftControl then
        currentMode = 1
        updateTabs()
        TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundColor3 = enabled and C.Mode1 or C.Accent}):Play()
        TweenService:Create(outerStroke, TweenInfo.new(0.2), {Color = enabled and C.Mode1 or C.Border}):Play()
        mode2_jumpChain = 0
        counterLbl.Visible = false
        return
    end

    if input.KeyCode == Enum.KeyCode.RightAlt then
        currentMode = 2
        updateTabs()
        TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundColor3 = enabled and C.Mode2 or C.Accent}):Play()
        TweenService:Create(outerStroke, TweenInfo.new(0.2), {Color = enabled and C.Mode2 or C.Border}):Play()
        return
    end

    if gp then return end
end)

gearBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
end)

toggleBtn.MouseButton1Click:Connect(toggleEnabled)
tab1.MouseButton1Click:Connect(function()
    currentMode = 1
    updateTabs()
    TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundColor3 = enabled and C.Mode1 or C.Accent}):Play()
    TweenService:Create(outerStroke, TweenInfo.new(0.2), {Color = enabled and C.Mode1 or C.Border}):Play()
    mode2_jumpChain = 0
    counterLbl.Visible = false
end)
tab2.MouseButton1Click:Connect(function()
    currentMode = 2
    updateTabs()
    TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundColor3 = enabled and C.Mode2 or C.Accent}):Play()
    TweenService:Create(outerStroke, TweenInfo.new(0.2), {Color = enabled and C.Mode2 or C.Border}):Play()
end)

-- =============================================
-- DRAG SYSTEM (Fixed)
-- =============================================
local DRAG_THRESHOLD = 5
local isDragging = false
local dragStartPos = nil
local frameStartPos = nil

local dragSurfaces = {frame, header, toggleBtn, gearBtn, tabRow, tab1, tab2, tabSlider, pillBG, statusLbl, keyHint, settingsFrame, titleLbl, madeByLbl}

for _, surface in ipairs(dragSurfaces) do
    surface.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            dragStartPos = input.Position
            frameStartPos = frame.Position
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if not dragStartPos then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        if not isDragging and (delta.Magnitude > DRAG_THRESHOLD) then
            isDragging = true
        end
        if isDragging then
            frame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStartPos = nil
        isDragging = false
    end
end)

-- =============================================
-- MAIN WALLHOP LOGIC
-- =============================================
local function isNearWall()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    local root = player.Character.HumanoidRootPart
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {player.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    local directions = {
        root.CFrame.LookVector,
        -root.CFrame.LookVector,
        root.CFrame.RightVector,
        -root.CFrame.RightVector,
    }

    for _, dir in ipairs(directions) do
        local result = Workspace:Raycast(root.Position, dir * Settings.WallDistance, rayParams)
        if result then return true, result.Normal end
    end
    return false
end

local function performWallhop()
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    local hum = player.Character.Humanoid
    local root = player.Character.HumanoidRootPart

    local nearWall, normal = isNearWall()
    if not nearWall then return false end

    local jumpDir = normal
    local currentTime = tick()

    if currentMode == 1 then
        -- Inf Jump Mode
        if currentTime - mode1_lastJump < Settings.Mode1_Cooldown then return false end
        mode1_lastJump = currentTime

        hum.JumpPower = Settings.JumpPower
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        task.delay(0.05, function()
            if hum then hum.JumpPower = 50 end
        end)
        wallhopCount = wallhopCount + 1
    else
        -- Cam Flick Mode
        if currentTime - mode2_lastJumpTime < Settings.Mode2_Cooldown then return false end
        mode2_lastJumpTime = currentTime
        mode2_jumpChain = mode2_jumpChain + 1
        if mode2_jumpChain > Settings.MaxChain then mode2_jumpChain = 1 end

        playFeedback()

        local flickAngleRad = math.rad(Settings.FlickAngle)
        local camFlick = CFrame.Angles(0, flickAngleRad, 0)
        local newLook = (root.CFrame.LookVector * camFlick):Unit()

        TweenService:Create(root, TweenInfo.new(Settings.SnapDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CFrame = CFrame.new(root.Position, root.Position + newLook)
        }):Play()

        hum.JumpPower = Settings.JumpPower
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        task.delay(0.05, function()
            if hum then hum.JumpPower = 50 end
        end)
    end

    return true
end

RunService.Heartbeat:Connect(function()
    if not enabled then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local hum = player.Character.Humanoid
    if hum:GetState() == Enum.HumanoidStateType.Freefall or hum:GetState() == Enum.HumanoidStateType.Jumping then
        if tick() - lastWallCheck > 0.05 then
            lastWallCheck = tick()
            performWallhop()
        end
    end
end)

print("Wallhop V3.0 loaded | Made By Nova | (-) = ON/OFF • LCtrl = Inf Jump • RAlt = Cam Flick")
