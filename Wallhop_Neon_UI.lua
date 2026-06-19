-- Nova-Style Compact Neon Wallhop
-- YouTube: ItsKyanBence
-- Updated by Grok - Settings Panel + Feedback Added

getgenv().WallhopEnabled = true
getgenv().FlickAmount = 45
getgenv().WallhopDistance = 4.2
getgenv().HopBoost = 26
getgenv().JumpBoost = 42

-- New Settings
getgenv().Mode1_Cooldown = 0.12
getgenv().Mode2_Cooldown = 0.3
getgenv().MaxChain = 5
getgenv().SnapDuration = 0.04
getgenv().SoundFeedback = true
getgenv().VisualFeedback = true
getgenv().HopCount = 0

local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

-- Sound Service
local SoundService = game:GetService("SoundService")

local function playOpenSound()
    if not getgenv().SoundFeedback then return end
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://7147420522"  -- Laptop/keyboard open sound
    sound.Volume = 0.6
    sound.Parent = SoundService
    sound:Play()
    task.delay(1.5, function() sound:Destroy() end)
end

local function playHopSound()
    if not getgenv().SoundFeedback then return end
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://131057517"  -- Soft hop/click feedback
    sound.Volume = 0.4
    sound.Parent = SoundService
    sound:Play()
    task.delay(0.8, function() sound:Destroy() end)
end

-- Small Neon UI
local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 165, 0, 108)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
frame.BorderSizePixel = 0
frame.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160, 0, 255)
stroke.Thickness = 2.2
stroke.Transparency = 0.15
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 24)
title.BackgroundTransparency = 1
title.Text = "Neon Wallhop"
title.TextColor3 = Color3.fromRGB(255, 70, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- Settings Button (Top Right)
local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 24, 0, 24)
settingsBtn.Position = UDim2.new(1, -30, 0, 4)
settingsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = Color3.fromRGB(200, 100, 255)
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 16
settingsBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = settingsBtn

-- Flick Input (small)
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.88, 0, 0, 26)
box.Position = UDim2.new(0.06, 0, 0, 28)
box.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
box.Text = tostring(getgenv().FlickAmount)
box.PlaceholderText = "Flick°"
box.TextColor3 = Color3.new(1,1,1)
box.ClearTextOnFocus = false
box.Font = Enum.Font.Gotham
box.TextSize = 13
box.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = box

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.88, 0, 0, 18)
status.Position = UDim2.new(0.06, 0, 0.58, 0)
status.BackgroundTransparency = 1
status.Text = "ENABLED"
status.TextColor3 = Color3.fromRGB(0, 255, 120)
status.TextSize = 12
status.Font = Enum.Font.GothamBold
status.Parent = frame

-- Toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.88, 0, 0, 20)
toggle.Position = UDim2.new(0.06, 0, 0.78, 0)
toggle.BackgroundColor3 = Color3.fromRGB(50, 20, 70)
toggle.Text = "ON"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 12
toggle.Parent = frame

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 8)
tCorner.Parent = toggle

-- YouTube Credit
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 14)
credit.Position = UDim2.new(0, 0, 1, -15)
credit.BackgroundTransparency = 1
credit.Text = "YouTube: ItsKyanBence"
credit.TextColor3 = Color3.fromRGB(180, 100, 255)
credit.TextSize = 10.5
credit.Font = Enum.Font.Gotham
credit.TextTransparency = 0.3
credit.Parent = frame

-- ==================== SETTINGS PANEL ====================

local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0, 280, 0, 340)
settingsFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
settingsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
settingsFrame.Parent = sg

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 14)
sCorner.Parent = settingsFrame

local sStroke = Instance.new("UIStroke")
sStroke.Color = Color3.fromRGB(160, 0, 255)
sStroke.Thickness = 2.5
sStroke.Parent = settingsFrame

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1, 0, 0, 36)
sTitle.BackgroundTransparency = 1
sTitle.Text = "Wallhop Settings"
sTitle.TextColor3 = Color3.fromRGB(255, 100, 255)
sTitle.Font = Enum.Font.GothamBold
sTitle.TextSize = 16
sTitle.Parent = settingsFrame

-- Scrolling Frame for settings
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = settingsFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

local function createSetting(labelText, defaultValue, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = scroll
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.35, 0, 0, 26)
    input.Position = UDim2.new(0.62, 0, 0.1, 0)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    input.Text = tostring(defaultValue)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.Parent = row
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(0, 6)
    iCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text)
        if val then
            callback(val)
            input.Text = tostring(val)
        end
    end)
end

-- Create toggles
local function createToggle(labelText, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = scroll
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local togBtn = Instance.new("TextButton")
    togBtn.Size = UDim2.new(0, 50, 0, 24)
    togBtn.Position = UDim2.new(0.7, 0, 0.1, 0)
    togBtn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(120, 30, 30)
    togBtn.Text = default and "ON" or "OFF"
    togBtn.TextColor3 = Color3.new(1,1,1)
    togBtn.Font = Enum.Font.GothamBold
    togBtn.TextSize = 12
    togBtn.Parent = row
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 12)
    tc.Parent = togBtn
    
    togBtn.MouseButton1Click:Connect(function()
        default = not default
        togBtn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(120, 30, 30)
        togBtn.Text = default and "ON" or "OFF"
        callback(default)
    end)
end

-- Add Settings
createSetting("Mode1 Cooldown", getgenv().Mode1_Cooldown, function(v) getgenv().Mode1_Cooldown = math.clamp(v, 0.05, 2) end)
createSetting("Mode2 Cooldown", getgenv().Mode2_Cooldown, function(v) getgenv().Mode2_Cooldown = math.clamp(v, 0.1, 3) end)
createSetting("Flick Angle", getgenv().FlickAmount, function(v) 
    getgenv().FlickAmount = math.clamp(v, 5, 360) 
    box.Text = tostring(getgenv().FlickAmount)
end)
createSetting("Max Chain", getgenv().MaxChain, function(v) getgenv().MaxChain = math.clamp(v, 1, 20) end)
createSetting("Snap Duration", getgenv().SnapDuration, function(v) getgenv().SnapDuration = math.clamp(v, 0.01, 0.2) end)
createSetting("Jump Power", getgenv().JumpBoost, function(v) getgenv().JumpBoost = math.clamp(v, 10, 120) end)
createSetting("Wall Distance", getgenv().WallhopDistance, function(v) getgenv().WallhopDistance = math.clamp(v, 1, 12) end)

createToggle("Sound Feedback", getgenv().SoundFeedback, function(v) getgenv().SoundFeedback = v end)
createToggle("Visual Feedback", getgenv().VisualFeedback, function(v) getgenv().VisualFeedback = v end)

-- Close button for settings
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 6)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = settingsFrame

closeBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
end)

-- Settings Button Handler
settingsBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
    if settingsFrame.Visible then
        playOpenSound()
        scroll.CanvasPosition = Vector2.new(0,0)
    end
end)

-- Input Handlers (main)
box.FocusLost:Connect(function()
    local num = tonumber(box.Text)
    if num then
        getgenv().FlickAmount = math.clamp(num, 5, 360)
        box.Text = tostring(getgenv().FlickAmount)
    end
end)

toggle.MouseButton1Click:Connect(function()
    getgenv().WallhopEnabled = not getgenv().WallhopEnabled
    status.Text = getgenv().WallhopEnabled and "ENABLED" or "DISABLED"
    status.TextColor3 = getgenv().WallhopEnabled and Color3.fromRGB(0,255,120) or Color3.fromRGB(255,60,60)
    toggle.Text = getgenv().WallhopEnabled and "ON" or "OFF"
end)

-- Universal Helpers
local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or char:FindFirstChildWhichIsA("BasePart"))
end

local function detectWall(char)
    local root = getRoot(char)
    if not root then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    
    local result = workspace:Raycast(root.Position + Vector3.new(0, 1, 0), root.CFrame.LookVector * getgenv().WallhopDistance, params)
    if result then
        local normal = result.Normal
        if normal.Y > -0.3 and normal.Y < 0.3 then
            return true
        end
    end
    return false
end

local lastHop = 0
local hopChain = 0
local HOP_COOLDOWN = 0.4

local function doHop(char)
    local now = tick()
    if now - lastHop < HOP_COOLDOWN then return end
    lastHop = now
    
    hopChain = hopChain + 1
    if hopChain > getgenv().MaxChain then
        hopChain = 1
    end
    
    local root = getRoot(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    hum.Jump = true
    local look = root.CFrame.LookVector
    
    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * Vector3.new(0.5, 0.8, 0.5) 
        + Vector3.new(0, getgenv().JumpBoost, 0) 
        + (look * getgenv().HopBoost)
    
    -- Flick with configurable duration
    local orig = cam.CFrame
    cam.CFrame = orig * CFrame.Angles(0, math.rad(getgenv().FlickAmount), 0)
    task.delay(getgenv().SnapDuration, function()
        cam.CFrame = orig
    end)
    
    playHopSound()
    
    -- Visual Feedback
    if getgenv().VisualFeedback then
        status.Text = "HOP #" .. hopChain
        status.TextColor3 = Color3.fromRGB(100, 255, 255)
        task.delay(0.6, function()
            if getgenv().WallhopEnabled then
                status.Text = "ENABLED"
                status.TextColor3 = Color3.fromRGB(0, 255, 120)
            end
        end)
    end
end

-- Setup
local function setup(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    hum.StateChanged:Connect(function(_, new)
        if not getgenv().WallhopEnabled then return end
        if new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall then
            task.delay(0.02, function()
                if detectWall(char) then
                    doHop(char)
                end
            end)
        end
    end)
end

player.CharacterAdded:Connect(setup)
if player.Character then setup(player.Character) end

-- Keyboard Toggle
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        getgenv().WallhopEnabled = not getgenv().WallhopEnabled
        status.Text = getgenv().WallhopEnabled and "ENABLED" or "DISABLED"
        status.TextColor3 = getgenv().WallhopEnabled and Color3.fromRGB(0,255,120) or Color3.fromRGB(255,60,60)
        toggle.Text = getgenv().WallhopEnabled and "ON" or "OFF"
    end
end)

-- Script loaded silently
print("Neon Wallhop loaded with Settings Panel!")