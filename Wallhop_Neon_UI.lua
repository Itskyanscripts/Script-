-- Nova-Style Compact Neon Wallhop
-- YouTube: ItsKyanBence
getgenv().WallhopEnabled = true
getgenv().FlickAmount = 45
getgenv().WallhopDistance = 5
getgenv().HopBoost = 26
getgenv().JumpBoost = 42

local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

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

-- Input Handlers
box.FocusLost:Connect(function()
    local num = tonumber(box.Text)
    if num then
        getgenv().FlickAmount = math.clamp(num, 10, 90)
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
    local dir = root.CFrame.LookVector * getgenv().WallhopDistance
    return workspace:Raycast(root.Position, dir, params) ~= nil
end

local function doHop(char)
    local root = getRoot(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    hum.Jump = true
    local look = root.CFrame.LookVector
    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + Vector3.new(0, getgenv().JumpBoost, 0) + (look * getgenv().HopBoost)
    
    -- Clean flick
    local orig = cam.CFrame
    cam.CFrame = orig * CFrame.Angles(0, math.rad(getgenv().FlickAmount), 0)
    task.delay(0.03, function()
        cam.CFrame = orig
    end)
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
