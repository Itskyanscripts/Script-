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
    MaxChain = 5,
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
settingsFrame.ZIndex = math.huge
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
createSetting("Max Chain", Settings.MaxChain, 94, 1, 10, function(v) Settings.MaxChain = v end)
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

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.8, 0, 0, 28)
resetBtn.Position = UDim2.new(0.1, 0, 0, 260)
resetBtn.BackgroundColor3 = C.Red
resetBtn.Text = "Reset to Defaults"
resetBtn.TextColor3 = C.TextMain
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Parent = settingsFrame
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

resetBtn.MouseButton1Click:Connect(function()
    -- Reset logic would go here
    print("Reset settings")
end)

closeBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
end)

gearBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

-- Dragging
local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Toggle
local function updateUI()
    if enabled then
        statusDot.BackgroundColor3 = C.Green
        statusLbl.Text = "ON"
        statusLbl.TextColor3 = C.Green
    else
        statusDot.BackgroundColor3 = C.Red
        statusLbl.Text = "OFF"
        statusLbl.TextColor3 = C.Red
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    updateUI()
    if enabled then
        print("Wallhop Enabled")
    else
        print("Wallhop Disabled")
    end
end)

-- Mode switching
tab1.MouseButton1Click:Connect(function()
    currentMode = 1
    tabSlider.Position = UDim2.new(0, 2, 0, 2)
    tabSlider.BackgroundColor3 = C.Mode1
    tab1.TextColor3 = C.Mode1
    tab2.TextColor3 = C.TextDim
end)

tab2.MouseButton1Click:Connect(function()
    currentMode = 2
    tabSlider.Position = UDim2.new(0.5, 2, 0, 2)
    tabSlider.BackgroundColor3 = C.Mode2
    tab2.TextColor3 = C.Mode2
    tab1.TextColor3 = C.TextDim
end)

-- Keyboard controls
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Minus then
        enabled = not enabled
        updateUI()
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        currentMode = 1
        tabSlider.Position = UDim2.new(0, 2, 0, 2)
        tabSlider.BackgroundColor3 = C.Mode1
        tab1.TextColor3 = C.Mode1
        tab2.TextColor3 = C.TextDim
    elseif input.KeyCode == Enum.KeyCode.RightAlt then
        currentMode = 2
        tabSlider.Position = UDim2.new(0.5, 2, 0, 2)
        tabSlider.BackgroundColor3 = C.Mode2
        tab2.TextColor3 = C.Mode2
        tab1.TextColor3 = C.TextDim
    end
end)

-- Main Wallhop Logic (simplified placeholder - full script continues)
print("Wallhop V3.0 loaded | Made By Nova | (-) = ON/OFF • LCtrl = Inf Jump • RAlt = Cam Flick")