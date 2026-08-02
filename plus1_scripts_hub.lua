-- +1 Scripts Hub
-- Clean rebuild • All features kept

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
while not player do
	task.wait()
	player = Players.LocalPlayer
end
local playerGui = player:WaitForChild("PlayerGui")

-- ENV table (safe getgenv)
local ENV = _G
pcall(function()
	if getgenv then
		local g = getgenv()
		if type(g) == "table" then ENV = g end
	end
end)

-- Cleanup old UI
pcall(function()
	local old = playerGui:FindFirstChild("+1Scripts")
	if old then old:Destroy() end
	local core = game:GetService("CoreGui")
	local o2 = core:FindFirstChild("+1Scripts")
	if o2 then o2:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "+1Scripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function()
	if gethui then
		ScreenGui.Parent = gethui()
	else
		ScreenGui.Parent = game:GetService("CoreGui")
	end
end)
if not ScreenGui.Parent then
	ScreenGui.Parent = playerGui
end

-- Sounds
local function playSfx(id, vol)
	task.spawn(function()
		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = id
			s.Volume = vol or 0.4
			s.Parent = ScreenGui
			s:Play()
			s.Ended:Connect(function() s:Destroy() end)
			task.delay(3, function() if s and s.Parent then s:Destroy() end end)
		end)
	end)
end
local function playClick() playSfx("rbxassetid://421058925", 0.35) end
local function playWrong() playSfx("rbxassetid://138081500", 0.5) end
local function playFind() playSfx("rbxassetid://515373460", 0.45) end
local function playLevelUp() playSfx("rbxassetid://3398620867", 0.5) end
local function playUnlock() playSfx("rbxassetid://4612375201", 0.5) end
local function playExpire() playSfx("rbxassetid://178077629", 0.55) end
local function playWin() playSfx("rbxassetid://183990826", 0.6) end

-- ========== MAIN FRAME ==========
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 340, 0, 310)
Main.Position = UDim2.new(0.5, -170, 0.5, -155)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(0, 255, 70)
mainStroke.Thickness = 2

-- Title
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "+1 Scripts"
Title.TextColor3 = Color3.fromRGB(0, 220, 90)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0.5, -14)
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(200, 200, 200)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Parent = TitleBar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)

-- Open button
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 56, 0, 40)
OpenBtn.Position = UDim2.new(0, 16, 0.5, -20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
OpenBtn.Text = "Open"
OpenBtn.TextColor3 = Color3.fromRGB(0, 220, 90)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.Visible = false
OpenBtn.ClipsDescendants = true
OpenBtn.ZIndex = 5
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local os2 = Instance.new("UIStroke", OpenBtn)
os2.Color = Color3.fromRGB(0, 255, 70)
os2.Thickness = 1.5

-- Matrix rain on Open button
do
	local rain = Instance.new("Frame")
	rain.Size = UDim2.new(1, 0, 1, 0)
	rain.BackgroundTransparency = 1
	rain.ZIndex = 0
	rain.ClipsDescendants = true
	rain.Parent = OpenBtn
	local digits = {"1", "0", "0", "1"}
	task.spawn(function()
		while rain and rain.Parent do
			if OpenBtn.Visible then
				local d = Instance.new("TextLabel")
				d.Size = UDim2.new(0, 10, 0, 12)
				d.BackgroundTransparency = 1
				d.Text = digits[math.random(1, #digits)]
				d.TextColor3 = Color3.fromRGB(0, math.random(100, 200), math.random(40, 90))
				d.Font = Enum.Font.Code
				d.TextSize = 9
				d.TextTransparency = 0.5
				d.ZIndex = 0
				d.Parent = rain
				local x, y = math.random(0, 48), -12
				d.Position = UDim2.new(0, x, 0, y)
				local sp = math.random(20, 45) / 100
				task.spawn(function()
					while d and d.Parent and y < 48 do
						y = y + sp * 2.0
						d.Position = UDim2.new(0, x, 0, y)
						task.wait(0.03)
					end
					if d then d:Destroy() end
				end)
			end
			task.wait(0.18)
		end
	end)
end

Close.MouseButton1Click:Connect(function()
	playClick()
	Main.Visible = false
	OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
	playClick()
	Main.Visible = true
	OpenBtn.Visible = false
end)

-- Drag helpers
local function makeDraggable(handle, target)
	local dragging, startPos, startInput
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = target.Position
			startInput = input.Position
		end
	end)
	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - startInput
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end
makeDraggable(TitleBar, Main)
makeDraggable(OpenBtn, OpenBtn)

-- Matrix rain on Main
do
	local rain = Instance.new("Frame")
	rain.Size = UDim2.new(1, 0, 1, 0)
	rain.BackgroundTransparency = 1
	rain.ZIndex = 0
	rain.ClipsDescendants = true
	rain.Parent = Main
	local digits = {"1", "0", "0", "1"}
	task.spawn(function()
		while rain and rain.Parent do
			if Main.Visible then
				local d = Instance.new("TextLabel")
				d.Size = UDim2.new(0, 12, 0, 14)
				d.BackgroundTransparency = 1
				d.Text = digits[math.random(1, #digits)]
				d.TextColor3 = Color3.fromRGB(0, math.random(100, 200), math.random(40, 90))
				d.Font = Enum.Font.Code
				d.TextSize = 11
				d.TextTransparency = 0.55
				d.ZIndex = 0
				d.Parent = rain
				local x, y = math.random(0, 328), -16
				d.Position = UDim2.new(0, x, 0, y)
				local sp = math.random(25, 55) / 100
				task.spawn(function()
					while d and d.Parent and y < 320 do
						y = y + sp * 2.2
						d.Position = UDim2.new(0, x, 0, y)
						task.wait(0.03)
					end
					if d then d:Destroy() end
				end)
			end
			task.wait(0.12)
		end
	end)
end

-- Tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 32)
TabBar.Position = UDim2.new(0, 8, 0, 44)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local function makeTab(name, x, w)
	local t = Instance.new("TextButton")
	t.Name = name
	t.Size = UDim2.new(0, w or 70, 1, 0)
	t.Position = UDim2.new(0, x, 0, 0)
	t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	t.Text = name
	t.TextColor3 = Color3.fromRGB(170, 170, 170)
	t.Font = Enum.Font.GothamMedium
	t.TextSize = 12
	t.Parent = TabBar
	Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
	return t
end

local GameTab = makeTab("Game", 0, 68)
local GameListTab = makeTab("Game List", 72, 72)
local MiscTab = makeTab("Misc", 148, 58)
local FeedbackTab = makeTab("Feedback", 210, 80)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -100)
Content.Position = UDim2.new(0, 8, 0, 82)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Credit
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, -16, 0, 14)
Credit.Position = UDim2.new(0, 8, 1, -16)
Credit.BackgroundTransparency = 1
Credit.Text = "Made By ItsKyanBence"
Credit.TextColor3 = Color3.fromRGB(90, 90, 90)
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 10
Credit.TextXAlignment = Enum.TextXAlignment.Center
Credit.ZIndex = 5
Credit.Parent = Main

-- ========== GAME PAGE ==========
local GamePage = Instance.new("Frame")
GamePage.Size = UDim2.new(1, 0, 1, 0)
GamePage.BackgroundTransparency = 1
GamePage.Visible = true
GamePage.Parent = Content

local GameStatus = Instance.new("TextLabel")
GameStatus.Size = UDim2.new(1, 0, 0, 18)
GameStatus.BackgroundTransparency = 1
GameStatus.Text = "Current Game"
GameStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
GameStatus.Font = Enum.Font.Gotham
GameStatus.TextSize = 11
GameStatus.TextXAlignment = Enum.TextXAlignment.Left
GameStatus.Parent = GamePage

local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Size = UDim2.new(1, 0, 0, 24)
GameNameLabel.Position = UDim2.new(0, 0, 0, 18)
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Text = "Loading..."
GameNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.TextSize = 14
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
GameNameLabel.Parent = GamePage

local NotAddedLabel = Instance.new("TextLabel")
NotAddedLabel.Size = UDim2.new(1, 0, 0, 36)
NotAddedLabel.Position = UDim2.new(0, 0, 0, 50)
NotAddedLabel.BackgroundColor3 = Color3.fromRGB(25, 40, 28)
NotAddedLabel.Text = "Game Not Added Yet!"
NotAddedLabel.TextColor3 = Color3.fromRGB(180, 220, 180)
NotAddedLabel.Font = Enum.Font.GothamMedium
NotAddedLabel.TextSize = 13
NotAddedLabel.Visible = true
NotAddedLabel.Parent = GamePage
Instance.new("UICorner", NotAddedLabel).CornerRadius = UDim.new(0, 6)

local FeaturesFrame = Instance.new("ScrollingFrame")
FeaturesFrame.Size = UDim2.new(1, 0, 1, -50)
FeaturesFrame.Position = UDim2.new(0, 0, 0, 48)
FeaturesFrame.BackgroundTransparency = 1
FeaturesFrame.BorderSizePixel = 0
FeaturesFrame.ScrollBarThickness = 3
FeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 160, 65)
FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
FeaturesFrame.Visible = false
FeaturesFrame.Parent = GamePage

local function clearFeatures()
	for _, c in ipairs(FeaturesFrame:GetChildren()) do c:Destroy() end
end

local function createSection(parent, text, y)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 20)
	l.Position = UDim2.new(0, 0, 0, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.fromRGB(100, 180, 120)
	l.Font = Enum.Font.GothamMedium
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

local function createToggle(parent, name, y, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 32)
	frame.Position = UDim2.new(0, 0, 0, y)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.Parent = parent
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -55, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 40, 0, 22)
	toggle.Position = UDim2.new(1, -48, 0.5, -11)
	toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	toggle.Text = ""
	toggle.Parent = frame
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
	circle.Parent = toggle
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local enabled = false
	toggle.MouseButton1Click:Connect(function()
		enabled = not enabled
		playClick()
		if enabled then
			toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 70)
			circle.Position = UDim2.new(1, -19, 0.5, -8)
			circle.BackgroundColor3 = Color3.fromRGB(200, 255, 210)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			circle.Position = UDim2.new(0, 3, 0.5, -8)
			circle.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
		end
		callback(enabled)
	end)
	return frame
end

local function createButton(parent, name, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.Position = UDim2.new(0, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(0, 140, 55)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	end)
	btn.MouseButton1Click:Connect(function()
		playClick()
		callback()
	end)
	return btn
end

local function fireTouch(part)
	if not part then return end
	if part:IsA("TouchTransmitter") or part.Name == "TouchInterest" then
		part = part.Parent
	end
	if not part or not part:IsA("BasePart") then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function()
		if firetouchinterest then
			firetouchinterest(part, hrp, 0)
			task.wait()
			firetouchinterest(part, hrp, 1)
		end
	end)
end

-- GAME 1
local function buildGame1Features()
	clearFeatures()
	createSection(FeaturesFrame, "World 1", 0)
	createToggle(FeaturesFrame, "Auto Farm Wins", 24, function(v)
		ENV.farm1 = v
		while ENV.farm1 do
			task.wait()
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char:MoveTo(Vector3.new(114.85, 12.78, 9503.41))
			end
		end
	end)
	createButton(FeaturesFrame, "TP To World 2", 62, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(Vector3.new(-5377, -88, -5))
		end
	end)
	createSection(FeaturesFrame, "World 2", 105)
	createToggle(FeaturesFrame, "Auto Farm Wins", 129, function(v)
		ENV.farm2 = v
		while ENV.farm2 do
			task.wait()
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char:MoveTo(Vector3.new(-5380.61, 261.45, 13183.42))
			end
		end
	end)
	createButton(FeaturesFrame, "TP To World 1", 167, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(Vector3.new(118, 14, -8))
		end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 210)
end

-- GAME 2
local function buildGame2Features()
	clearFeatures()
	createSection(FeaturesFrame, "World 1", 0)
	createToggle(FeaturesFrame, "Auto Farm", 24, function(v)
		ENV.g2_w1 = v
		while ENV.g2_w1 do
			task.wait(0.15)
			pcall(function()
				local part = workspace.SectionAwardParts:GetChildren()[11]
				if part then fireTouch(part) end
			end)
		end
	end)
	createSection(FeaturesFrame, "World 2", 65)
	createToggle(FeaturesFrame, "Auto Farm", 89, function(v)
		ENV.g2_w2 = v
		while ENV.g2_w2 do
			task.wait(0.15)
			pcall(function()
				local part = workspace.SectionAwardParts.World2:GetChildren()[10]
				if part then fireTouch(part) end
			end)
		end
	end)
	createSection(FeaturesFrame, "World 3", 130)
	createToggle(FeaturesFrame, "Auto Farm", 154, function(v)
		ENV.g2_w3 = v
		while ENV.g2_w3 do
			task.wait(0.15)
			pcall(function()
				local world3 = workspace:FindFirstChild("World3")
				if not world3 then return end
				for _, child in ipairs(world3:GetChildren()) do
					if child:FindFirstChildOfClass("TouchTransmitter") or child:FindFirstChild("TouchInterest") then
						fireTouch(child)
					end
				end
				for _, desc in ipairs(world3:GetDescendants()) do
					if desc:IsA("TouchTransmitter") or desc.Name == "TouchInterest" then
						fireTouch(desc.Parent)
					end
				end
			end)
		end
	end)
	createSection(FeaturesFrame, "TP World Area", 195)
	createButton(FeaturesFrame, "World 1", 219, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(Vector3.new(1109, 670, -401))
		end
	end)
	createButton(FeaturesFrame, "World 2", 257, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(Vector3.new(-1755, 670, -413))
		end
	end)
	createButton(FeaturesFrame, "World 3", 295, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(Vector3.new(-3026, 670, -413))
		end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 345)
end

-- GAME 3
local function buildGame3Features()
	clearFeatures()
	createSection(FeaturesFrame, "Farming", 0)
	createToggle(FeaturesFrame, "Auto Farm Wins", 24, function(v)
		ENV.g3_farm = v
		while ENV.g3_farm do
			task.wait(0.1)
			pcall(function()
				local btn = workspace.WinCollectors.Stage25.Button:GetChildren()[8]
				if btn then fireTouch(btn) end
			end)
		end
	end)
	createToggle(FeaturesFrame, "Auto Swing", 62, function(v)
		ENV.g3_swing = v
		while ENV.g3_swing do
			task.wait(0.1)
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.SwingRequest:FireServer()
			end)
		end
	end)
	createSection(FeaturesFrame, "Rebirth", 105)
	createToggle(FeaturesFrame, "Auto Rebirth", 129, function(v)
		ENV.g3_rebirth = v
		while ENV.g3_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.RebirthRequest:FireServer()
			end)
		end
	end)
	createSection(FeaturesFrame, "Eggs", 170)

	local eggOptions = {
		{Label = "Basic Egg (500)", Egg = "BasicEgg"},
		{Label = "Advance Egg (35k)", Egg = "AdvancedEgg"},
		{Label = "Pro Egg (2m)", Egg = "ProEgg"},
		{Label = "Elite Egg (360m)", Egg = "EliteEgg"},
	}
	local selectedEgg = eggOptions[1]

	local dropBtn = Instance.new("TextButton")
	dropBtn.Size = UDim2.new(1, 0, 0, 32)
	dropBtn.Position = UDim2.new(0, 0, 0, 194)
	dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	dropBtn.Text = "▼  " .. selectedEgg.Label
	dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	dropBtn.Font = Enum.Font.Gotham
	dropBtn.TextSize = 13
	dropBtn.TextXAlignment = Enum.TextXAlignment.Left
	dropBtn.Parent = FeaturesFrame
	Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
	local pad = Instance.new("UIPadding", dropBtn)
	pad.PaddingLeft = UDim.new(0, 10)

	local dropList = Instance.new("Frame")
	dropList.Size = UDim2.new(1, 0, 0, #eggOptions * 30)
	dropList.Position = UDim2.new(0, 0, 0, 228)
	dropList.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	dropList.Visible = false
	dropList.ZIndex = 10
	dropList.Parent = FeaturesFrame
	Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 6)
	Instance.new("UIListLayout", dropList).SortOrder = Enum.SortOrder.LayoutOrder

	for _, opt in ipairs(eggOptions) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, 0, 0, 30)
		optBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		optBtn.BackgroundTransparency = 0.3
		optBtn.Text = opt.Label
		optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		optBtn.Font = Enum.Font.Gotham
		optBtn.TextSize = 12
		optBtn.ZIndex = 11
		optBtn.Parent = dropList
		optBtn.MouseButton1Click:Connect(function()
			playClick()
			selectedEgg = opt
			dropBtn.Text = "▼  " .. opt.Label
			dropList.Visible = false
		end)
	end

	local buyBtn = Instance.new("TextButton")
	buyBtn.Size = UDim2.new(1, 0, 0, 32)
	buyBtn.Position = UDim2.new(0, 0, 0, 234)
	buyBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 65)
	buyBtn.Text = "Buy"
	buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyBtn.Font = Enum.Font.GothamMedium
	buyBtn.TextSize = 13
	buyBtn.Parent = FeaturesFrame
	Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 6)

	dropBtn.MouseButton1Click:Connect(function()
		playClick()
		dropList.Visible = not dropList.Visible
		buyBtn.Position = UDim2.new(0, 0, 0, dropList.Visible and (234 + #eggOptions * 30) or 234)
	end)

	buyBtn.MouseButton1Click:Connect(function()
		playClick()
		pcall(function()
			game:GetService("ReplicatedStorage").Remotes.EggEvents:FireServer("PurchaseEgg", selectedEgg.Egg, 1)
		end)
		buyBtn.Text = "Bought!"
		task.wait(0.6)
		buyBtn.Text = "Buy"
	end)

	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 290)
end

-- ========== GAME LIST ==========
local GameListPage = Instance.new("Frame")
GameListPage.Size = UDim2.new(1, 0, 1, 0)
GameListPage.BackgroundTransparency = 1
GameListPage.Visible = false
GameListPage.Parent = Content

local GameListTitle = Instance.new("TextLabel")
GameListTitle.Size = UDim2.new(1, 0, 0, 18)
GameListTitle.BackgroundTransparency = 1
GameListTitle.Text = "Games (click to join)"
GameListTitle.TextColor3 = Color3.fromRGB(170, 170, 170)
GameListTitle.Font = Enum.Font.Gotham
GameListTitle.TextSize = 11
GameListTitle.TextXAlignment = Enum.TextXAlignment.Left
GameListTitle.Parent = GameListPage

local GameListScroll = Instance.new("ScrollingFrame")
GameListScroll.Size = UDim2.new(1, 0, 1, -24)
GameListScroll.Position = UDim2.new(0, 0, 0, 22)
GameListScroll.BackgroundTransparency = 1
GameListScroll.BorderSizePixel = 0
GameListScroll.ScrollBarThickness = 3
GameListScroll.Parent = GameListPage
local listLayout = Instance.new("UIListLayout", GameListScroll)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)

local SupportedPlaceIds = {75626443136851, 108775830475023, 84757653274750}

local function createGameEntry(placeId, gameName)
	local entry = Instance.new("TextButton")
	entry.Size = UDim2.new(1, -2, 0, 40)
	entry.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	entry.Text = ""
	entry.AutoButtonColor = false
	entry.Parent = GameListScroll
	Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 6)
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -12, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = gameName
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 13
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = entry
	entry.MouseEnter:Connect(function() entry.BackgroundColor3 = Color3.fromRGB(0, 100, 45) end)
	entry.MouseLeave:Connect(function() entry.BackgroundColor3 = Color3.fromRGB(28, 28, 28) end)
	entry.MouseButton1Click:Connect(function()
		playClick()
		nameLabel.Text = "Teleporting..."
		pcall(function() TeleportService:Teleport(placeId, player) end)
	end)
end

task.spawn(function()
	for _, placeId in ipairs(SupportedPlaceIds) do
		local name = "Place " .. tostring(placeId)
		local ok, info = pcall(function() return MarketplaceService:GetProductInfo(placeId) end)
		if ok and info and info.Name then name = info.Name end
		createGameEntry(placeId, name)
	end
	GameListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end)

-- ========== MISC ==========
local MiscPage = Instance.new("Frame")
MiscPage.Size = UDim2.new(1, 0, 1, 0)
MiscPage.BackgroundTransparency = 1
MiscPage.Visible = false
MiscPage.Parent = Content

local MiscTitle = Instance.new("TextLabel")
MiscTitle.Size = UDim2.new(1, 0, 0, 18)
MiscTitle.BackgroundTransparency = 1
MiscTitle.Text = "WalkSpeed"
MiscTitle.TextColor3 = Color3.fromRGB(170, 170, 170)
MiscTitle.Font = Enum.Font.Gotham
MiscTitle.TextSize = 11
MiscTitle.TextXAlignment = Enum.TextXAlignment.Left
MiscTitle.Parent = MiscPage

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 24)
SpeedLabel.Position = UDim2.new(0, 0, 0, 20)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Current: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 15
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MiscPage

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(1, 0, 0, 34)
SpeedInput.Position = UDim2.new(0, 0, 0, 48)
SpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedInput.Text = "16"
SpeedInput.PlaceholderText = "1 - 500"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.TextSize = 14
SpeedInput.ClearTextOnFocus = false
SpeedInput.Parent = MiscPage
Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 6)

local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(1, 0, 0, 10)
SliderBG.Position = UDim2.new(0, 0, 0, 90)
SliderBG.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SliderBG.Parent = MiscPage
Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(16/500, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
SliderFill.Parent = SliderBG
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 16, 0, 16)
SliderKnob.Position = UDim2.new(16/500, -8, 0.5, -8)
SliderKnob.BackgroundColor3 = Color3.fromRGB(200, 255, 210)
SliderKnob.ZIndex = 2
SliderKnob.Parent = SliderBG
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

local speedOn = false
local function setWalkSpeed(speed)
	speed = math.clamp(tonumber(speed) or 16, 1, 500)
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = speed end
	end
	SpeedLabel.Text = "Current: " .. tostring(math.floor(speed))
	SpeedInput.Text = tostring(math.floor(speed))
	local pct = (speed - 1) / 499
	SliderFill.Size = UDim2.new(pct, 0, 1, 0)
	SliderKnob.Position = UDim2.new(pct, -8, 0.5, -8)
end

local sliding = false
local function valueFromMouse(x)
	local abs = SliderBG.AbsolutePosition.X
	local size = math.max(SliderBG.AbsoluteSize.X, 1)
	return 1 + math.clamp((x - abs) / size, 0, 1) * 499
end

SliderBG.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliding = true
		playClick()
		local val = valueFromMouse(input.Position.X)
		setWalkSpeed(val)
		if not speedOn then speedOn = true end
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliding = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		setWalkSpeed(valueFromMouse(input.Position.X))
	end
end)

local SpeedToggleFrame = Instance.new("Frame")
SpeedToggleFrame.Size = UDim2.new(1, 0, 0, 32)
SpeedToggleFrame.Position = UDim2.new(0, 0, 0, 112)
SpeedToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedToggleFrame.Parent = MiscPage
Instance.new("UICorner", SpeedToggleFrame).CornerRadius = UDim.new(0, 6)

local SpeedToggleLabel = Instance.new("TextLabel")
SpeedToggleLabel.Size = UDim2.new(1, -55, 1, 0)
SpeedToggleLabel.Position = UDim2.new(0, 10, 0, 0)
SpeedToggleLabel.BackgroundTransparency = 1
SpeedToggleLabel.Text = "Use Custom Speed"
SpeedToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggleLabel.Font = Enum.Font.Gotham
SpeedToggleLabel.TextSize = 13
SpeedToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedToggleLabel.Parent = SpeedToggleFrame

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0, 40, 0, 22)
SpeedToggle.Position = UDim2.new(1, -48, 0.5, -11)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedToggle.Text = ""
SpeedToggle.Parent = SpeedToggleFrame
Instance.new("UICorner", SpeedToggle).CornerRadius = UDim.new(1, 0)

local SpeedCircle = Instance.new("Frame")
SpeedCircle.Size = UDim2.new(0, 16, 0, 16)
SpeedCircle.Position = UDim2.new(0, 3, 0.5, -8)
SpeedCircle.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
SpeedCircle.Parent = SpeedToggle
Instance.new("UICorner", SpeedCircle).CornerRadius = UDim.new(1, 0)

SpeedToggle.MouseButton1Click:Connect(function()
	playClick()
	speedOn = not speedOn
	if speedOn then
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 160, 65)
		SpeedCircle.Position = UDim2.new(1, -19, 0.5, -8)
		SpeedCircle.BackgroundColor3 = Color3.fromRGB(180, 255, 190)
		setWalkSpeed(SpeedInput.Text)
	else
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		SpeedCircle.Position = UDim2.new(0, 3, 0.5, -8)
		SpeedCircle.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
		setWalkSpeed(16)
	end
end)

SpeedInput.FocusLost:Connect(function()
	setWalkSpeed(SpeedInput.Text)
end)

-- Inf Jump
local InfF = Instance.new("Frame")
InfF.Size = UDim2.new(1, 0, 0, 32)
InfF.Position = UDim2.new(0, 0, 0, 156)
InfF.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InfF.Parent = MiscPage
Instance.new("UICorner", InfF).CornerRadius = UDim.new(0, 6)
local InfL = Instance.new("TextLabel")
InfL.Size = UDim2.new(1, -55, 1, 0)
InfL.Position = UDim2.new(0, 10, 0, 0)
InfL.BackgroundTransparency = 1
InfL.Text = "Inf Jump"
InfL.TextColor3 = Color3.fromRGB(255, 255, 255)
InfL.Font = Enum.Font.Gotham
InfL.TextSize = 13
InfL.TextXAlignment = Enum.TextXAlignment.Left
InfL.Parent = InfF
local InfB = Instance.new("TextButton")
InfB.Size = UDim2.new(0, 40, 0, 22)
InfB.Position = UDim2.new(1, -48, 0.5, -11)
InfB.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InfB.Text = ""
InfB.Parent = InfF
Instance.new("UICorner", InfB).CornerRadius = UDim.new(1, 0)
local InfC = Instance.new("Frame")
InfC.Size = UDim2.new(0, 16, 0, 16)
InfC.Position = UDim2.new(0, 3, 0.5, -8)
InfC.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
InfC.Parent = InfB
Instance.new("UICorner", InfC).CornerRadius = UDim.new(1, 0)
ENV.infJump = false
InfB.MouseButton1Click:Connect(function()
	playClick()
	ENV.infJump = not ENV.infJump
	if ENV.infJump then
		InfB.BackgroundColor3 = Color3.fromRGB(0, 160, 65)
		InfC.Position = UDim2.new(1, -19, 0.5, -8)
		InfC.BackgroundColor3 = Color3.fromRGB(0, 220, 90)
	else
		InfB.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		InfC.Position = UDim2.new(0, 3, 0.5, -8)
		InfC.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
	end
end)
UserInputService.JumpRequest:Connect(function()
	if ENV.infJump then
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end
end)

-- ========== FEEDBACK ==========
local FeedbackPage = Instance.new("Frame")
FeedbackPage.Size = UDim2.new(1, 0, 1, 0)
FeedbackPage.BackgroundTransparency = 1
FeedbackPage.Visible = false
FeedbackPage.Parent = Content

local FbTitle = Instance.new("TextLabel")
FbTitle.Size = UDim2.new(1, 0, 0, 18)
FbTitle.BackgroundTransparency = 1
FbTitle.Text = "Request a Game"
FbTitle.TextColor3 = Color3.fromRGB(0, 220, 90)
FbTitle.Font = Enum.Font.GothamBold
FbTitle.TextSize = 13
FbTitle.TextXAlignment = Enum.TextXAlignment.Left
FbTitle.Parent = FeedbackPage

local RequestBox = Instance.new("TextBox")
RequestBox.Size = UDim2.new(1, 0, 0, 36)
RequestBox.Position = UDim2.new(0, 0, 0, 28)
RequestBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
RequestBox.Text = ""
RequestBox.PlaceholderText = "Request Game"
RequestBox.TextColor3 = Color3.fromRGB(255, 255, 255)
RequestBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
RequestBox.Font = Enum.Font.Gotham
RequestBox.TextSize = 13
RequestBox.ClearTextOnFocus = false
RequestBox.Parent = FeedbackPage
Instance.new("UICorner", RequestBox).CornerRadius = UDim.new(0, 6)

local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(1, 0, 0, 34)
SendBtn.Position = UDim2.new(0, 0, 0, 74)
SendBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 60)
SendBtn.Text = "Send"
SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendBtn.Font = Enum.Font.GothamBold
SendBtn.TextSize = 14
SendBtn.Parent = FeedbackPage
Instance.new("UICorner", SendBtn).CornerRadius = UDim.new(0, 6)

local SendStatus = Instance.new("TextLabel")
SendStatus.Size = UDim2.new(1, 0, 0, 18)
SendStatus.Position = UDim2.new(0, 0, 0, 114)
SendStatus.BackgroundTransparency = 1
SendStatus.Text = ""
SendStatus.TextColor3 = Color3.fromRGB(0, 220, 90)
SendStatus.Font = Enum.Font.Gotham
SendStatus.TextSize = 12
SendStatus.TextXAlignment = Enum.TextXAlignment.Left
SendStatus.Parent = FeedbackPage

local REQUEST_FILE = "plus1_game_requests.txt"
local function saveRequest(user, msg)
	pcall(function()
		if not writefile then return end
		local existing = ""
		if isfile and isfile(REQUEST_FILE) and readfile then
			existing = readfile(REQUEST_FILE)
			if existing ~= "" and not existing:match("\n$") then existing = existing .. "\n" end
		end
		writefile(REQUEST_FILE, existing .. user .. "|" .. msg:gsub("|", "/") .. "|" .. tostring(os.time()) .. "\n")
	end)
end

SendBtn.MouseButton1Click:Connect(function()
	playClick()
	local msg = RequestBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if msg == "" then
		SendStatus.Text = "Please type a game name"
		SendStatus.TextColor3 = Color3.fromRGB(255, 140, 100)
		return
	end
	saveRequest(player.Name, msg)
	SendStatus.Text = "Sent! Thanks for the request."
	SendStatus.TextColor3 = Color3.fromRGB(0, 220, 90)
	RequestBox.Text = ""
end)

-- ========== VIEW (owner only) ==========
local ViewPage, ViewTab = nil, nil
local IS_OWNER = (player.Name == "Eyfanboy09")
if IS_OWNER then
	ViewTab = makeTab("View", 294, 52)
	GameTab.Size = UDim2.new(0, 58, 1, 0)
	GameListTab.Size = UDim2.new(0, 64, 1, 0)
	GameListTab.Position = UDim2.new(0, 60, 0, 0)
	MiscTab.Size = UDim2.new(0, 50, 1, 0)
	MiscTab.Position = UDim2.new(0, 126, 0, 0)
	FeedbackTab.Size = UDim2.new(0, 68, 1, 0)
	FeedbackTab.Position = UDim2.new(0, 180, 0, 0)
	ViewTab.Position = UDim2.new(0, 252, 0, 0)

	ViewPage = Instance.new("Frame")
	ViewPage.Size = UDim2.new(1, 0, 1, 0)
	ViewPage.BackgroundTransparency = 1
	ViewPage.Visible = false
	ViewPage.ClipsDescendants = true
	ViewPage.Parent = Content

	local ViewTitle = Instance.new("TextLabel")
	ViewTitle.Size = UDim2.new(1, 0, 0, 18)
	ViewTitle.BackgroundTransparency = 1
	ViewTitle.Text = "Requested Games"
	ViewTitle.TextColor3 = Color3.fromRGB(0, 220, 90)
	ViewTitle.Font = Enum.Font.GothamBold
	ViewTitle.TextSize = 13
	ViewTitle.TextXAlignment = Enum.TextXAlignment.Left
	ViewTitle.ZIndex = 2
	ViewTitle.Parent = ViewPage

	local ViewScroll = Instance.new("ScrollingFrame")
	ViewScroll.Size = UDim2.new(1, 0, 1, -28)
	ViewScroll.Position = UDim2.new(0, 0, 0, 24)
	ViewScroll.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	ViewScroll.BackgroundTransparency = 0.3
	ViewScroll.BorderSizePixel = 0
	ViewScroll.ScrollBarThickness = 3
	ViewScroll.ZIndex = 2
	ViewScroll.Parent = ViewPage
	Instance.new("UICorner", ViewScroll).CornerRadius = UDim.new(0, 6)
	local viewLayout = Instance.new("UIListLayout", ViewScroll)
	viewLayout.SortOrder = Enum.SortOrder.LayoutOrder
	viewLayout.Padding = UDim.new(0, 6)

	local function refreshViews()
		for _, c in ipairs(ViewScroll:GetChildren()) do
			if c:IsA("TextButton") or (c:IsA("TextLabel") and c.Text == "No requests yet") then c:Destroy() end
		end
		local list = {}
		pcall(function()
			if isfile and isfile(REQUEST_FILE) and readfile then
				for line in readfile(REQUEST_FILE):gmatch("[^\r\n]+") do
					local user, msg = line:match("([^|]+)|([^|]+)")
					if user and msg then table.insert(list, {user = user, msg = msg}) end
				end
			end
		end)
		if #list == 0 then
			local empty = Instance.new("TextLabel")
			empty.Size = UDim2.new(1, -8, 0, 36)
			empty.BackgroundTransparency = 1
			empty.Text = "No requests yet"
			empty.TextColor3 = Color3.fromRGB(120, 120, 120)
			empty.Font = Enum.Font.Gotham
			empty.TextSize = 12
			empty.ZIndex = 3
			empty.Parent = ViewScroll
		else
			for i, req in ipairs(list) do
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -8, 0, 44)
				btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
				btn.Text = ""
				btn.AutoButtonColor = false
				btn.ZIndex = 3
				btn.LayoutOrder = i
				btn.Parent = ViewScroll
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
				local t1 = Instance.new("TextLabel")
				t1.Size = UDim2.new(1, -12, 0, 18)
				t1.Position = UDim2.new(0, 8, 0, 4)
				t1.BackgroundTransparency = 1
				t1.Text = req.msg
				t1.TextColor3 = Color3.fromRGB(255, 255, 255)
				t1.Font = Enum.Font.GothamMedium
				t1.TextSize = 12
				t1.TextXAlignment = Enum.TextXAlignment.Left
				t1.TextTruncate = Enum.TextTruncate.AtEnd
				t1.ZIndex = 4
				t1.Parent = btn
				local t2 = Instance.new("TextLabel")
				t2.Size = UDim2.new(1, -12, 0, 14)
				t2.Position = UDim2.new(0, 8, 0, 24)
				t2.BackgroundTransparency = 1
				t2.Text = "from " .. req.user
				t2.TextColor3 = Color3.fromRGB(120, 160, 130)
				t2.Font = Enum.Font.Gotham
				t2.TextSize = 10
				t2.TextXAlignment = Enum.TextXAlignment.Left
				t2.ZIndex = 4
				t2.Parent = btn
				btn.MouseButton1Click:Connect(function()
					playClick()
					pcall(function() if setclipboard then setclipboard(req.msg) end end)
				end)
			end
		end
		ViewScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(viewLayout.AbsoluteContentSize.Y + 10, 40))
	end

	ViewTab.MouseButton1Click:Connect(function()
		playClick()
		switchTab("View")
		refreshViews()
	end)
end

-- Tab switch
function switchTab(selected)
	GamePage.Visible = (selected == "Game")
	GameListPage.Visible = (selected == "Game List")
	MiscPage.Visible = (selected == "Misc")
	FeedbackPage.Visible = (selected == "Feedback")
	if ViewPage then ViewPage.Visible = (selected == "View") end
	local tabs = {["Game"] = GameTab, ["Game List"] = GameListTab, ["Misc"] = MiscTab, ["Feedback"] = FeedbackTab}
	if ViewTab then tabs["View"] = ViewTab end
	for name, tab in pairs(tabs) do
		if tab then
			if name == selected then
				tab.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
				tab.TextColor3 = Color3.fromRGB(0, 220, 90)
			else
				tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				tab.TextColor3 = Color3.fromRGB(170, 170, 170)
			end
		end
	end
end

GameTab.MouseButton1Click:Connect(function() playClick() switchTab("Game") end)
GameListTab.MouseButton1Click:Connect(function() playClick() switchTab("Game List") end)
MiscTab.MouseButton1Click:Connect(function() playClick() switchTab("Misc") end)
FeedbackTab.MouseButton1Click:Connect(function() playClick() switchTab("Feedback") end)

-- Detect game
local SUPPORTED = {
	[75626443136851] = buildGame1Features,
	[108775830475023] = buildGame2Features,
	[84757653274750] = buildGame3Features,
}
pcall(function()
	local info = MarketplaceService:GetProductInfo(game.PlaceId)
	if info then GameNameLabel.Text = info.Name end
end)
if not GameNameLabel.Text or GameNameLabel.Text == "Loading..." then
	GameNameLabel.Text = "Unknown Game"
end
if SUPPORTED[game.PlaceId] then
	NotAddedLabel.Visible = false
	FeaturesFrame.Visible = true
	pcall(SUPPORTED[game.PlaceId])
else
	NotAddedLabel.Visible = true
	FeaturesFrame.Visible = false
end
switchTab("Game")

-- ========== KEY SYSTEM ==========
local MASTER_KEY = "1mth3b3st"
local KEY_DURATION = 10 * 60
local KEY_FILE = "plus1_key_data.txt"
local PENDING_FILE = "plus1_pending_key.txt"

local function saveKeyData(key, expireAt)
	pcall(function() if writefile then writefile(KEY_FILE, key .. "|" .. tostring(expireAt)) end end)
	ENV.plus1_key = key
	ENV.plus1_expire = expireAt
end
local function loadKeyData()
	local key, expire = ENV.plus1_key, ENV.plus1_expire
	pcall(function()
		if isfile and isfile(KEY_FILE) and readfile then
			local k, e = readfile(KEY_FILE):match("([^|]+)|(.+)")
			if k and e then key, expire = k, tonumber(e) end
		end
	end)
	return key, expire
end
local function savePendingKey(key, expireAt)
	pcall(function() if writefile then writefile(PENDING_FILE, key .. "|" .. tostring(expireAt)) end end)
	ENV.plus1_pending_key = key
	ENV.plus1_pending_expire = expireAt
end
local function loadPendingKey()
	local key, expire = ENV.plus1_pending_key, ENV.plus1_pending_expire
	pcall(function()
		if isfile and isfile(PENDING_FILE) and readfile then
			local k, e = readfile(PENDING_FILE):match("([^|]+)|(.+)")
			if k and e then key, expire = k, tonumber(e) end
		end
	end)
	return key, expire
end
local function isUnlocked()
	local key, expire = loadKeyData()
	if key == MASTER_KEY then return true end
	if key and key ~= MASTER_KEY and expire and os.time() <= expire then return true end
	return false
end
local function genKey()
	local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local out
	repeat
		out = ""
		for i = 1, 9 do
			local idx = math.random(1, #chars)
			out = out .. chars:sub(idx, idx)
		end
	until out ~= MASTER_KEY
	savePendingKey(out, os.time() + KEY_DURATION)
	return out
end

local Auth = Instance.new("Frame")
Auth.Size = UDim2.new(1, 0, 1, 0)
Auth.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Auth.BackgroundTransparency = 0.2
Auth.ZIndex = 50
Auth.Parent = ScreenGui

local AuthCard = Instance.new("Frame")
AuthCard.AnchorPoint = Vector2.new(0.5, 0.5)
AuthCard.Position = UDim2.new(0.5, 0, 0.5, 0)
AuthCard.Size = UDim2.new(0, 320, 0, 340)
AuthCard.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
AuthCard.BorderSizePixel = 0
AuthCard.ZIndex = 55
AuthCard.Parent = Auth
Instance.new("UICorner", AuthCard).CornerRadius = UDim.new(0, 14)
local acs = Instance.new("UIStroke", AuthCard)
acs.Color = Color3.fromRGB(0, 220, 90)
acs.Thickness = 2

local function mkL(parent, text, y, size, color, bold)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -24, 0, size + 8)
	l.Position = UDim2.new(0, 12, 0, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = color
	l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
	l.TextSize = size
	l.TextWrapped = true
	l.ZIndex = 57
	l.Parent = parent
	return l
end

local LoadPage = Instance.new("Frame")
LoadPage.Size = UDim2.new(1, 0, 1, 0)
LoadPage.BackgroundTransparency = 1
LoadPage.ZIndex = 56
LoadPage.Parent = AuthCard
mkL(LoadPage, "+1 Scripts", 40, 22, Color3.fromRGB(0, 220, 90), true)
local LoadSub = mkL(LoadPage, "Initializing...", 72, 13, Color3.fromRGB(170, 170, 170), false)
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -40, 0, 10)
BarBg.Position = UDim2.new(0, 20, 0, 150)
BarBg.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
BarBg.ZIndex = 57
BarBg.Parent = LoadPage
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)
local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 220, 90)
BarFill.ZIndex = 58
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)
local LoadPct = mkL(LoadPage, "0%", 170, 14, Color3.fromRGB(0, 220, 90), true)

local KeyPage = Instance.new("Frame")
KeyPage.Size = UDim2.new(1, 0, 1, 0)
KeyPage.BackgroundTransparency = 1
KeyPage.Visible = false
KeyPage.ZIndex = 56
KeyPage.Parent = AuthCard
mkL(KeyPage, "Key System", 18, 18, Color3.fromRGB(0, 220, 90), true)
mkL(KeyPage, "Get key in-game • expires in 10 min\nSpecial key always works", 46, 11, Color3.fromRGB(150, 150, 150), false)

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -32, 0, 40)
KeyBox.Position = UDim2.new(0, 16, 0, 100)
KeyBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Paste or type key..."
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.ZIndex = 57
KeyBox.Parent = KeyPage
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

local StatusLbl = mkL(KeyPage, "", 148, 12, Color3.fromRGB(255, 120, 100), false)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -32, 0, 40)
SubmitBtn.Position = UDim2.new(0, 16, 0, 175)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 70)
SubmitBtn.Text = "Unlock"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 15
SubmitBtn.ZIndex = 57
SubmitBtn.Parent = KeyPage
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 10)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(1, -32, 0, 40)
GetKeyBtn.Position = UDim2.new(0, 16, 0, 224)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
GetKeyBtn.Text = "Get Key (Spot the Difference)"
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
GetKeyBtn.Font = Enum.Font.GothamMedium
GetKeyBtn.TextSize = 13
GetKeyBtn.ZIndex = 57
GetKeyBtn.Parent = KeyPage
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 10)

local RewardPage = Instance.new("Frame")
RewardPage.Size = UDim2.new(1, 0, 1, 0)
RewardPage.BackgroundTransparency = 1
RewardPage.Visible = false
RewardPage.ZIndex = 56
RewardPage.Parent = AuthCard
mkL(RewardPage, "Key Earned!", 24, 18, Color3.fromRGB(0, 220, 90), true)
mkL(RewardPage, "Copy your key and use it to unlock", 52, 12, Color3.fromRGB(150, 150, 150), false)
local RewKey = Instance.new("TextLabel")
RewKey.Size = UDim2.new(1, -32, 0, 44)
RewKey.Position = UDim2.new(0, 16, 0, 88)
RewKey.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
RewKey.Text = "XXXXXXXXX"
RewKey.TextColor3 = Color3.fromRGB(0, 220, 90)
RewKey.Font = Enum.Font.Code
RewKey.TextSize = 20
RewKey.ZIndex = 57
RewKey.Parent = RewardPage
Instance.new("UICorner", RewKey).CornerRadius = UDim.new(0, 10)
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(1, -32, 0, 40)
CopyBtn.Position = UDim2.new(0, 16, 0, 148)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 70)
CopyBtn.Text = "Copy Key"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.ZIndex = 57
CopyBtn.Parent = RewardPage
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 10)
local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(1, -32, 0, 36)
BackBtn.Position = UDim2.new(0, 16, 0, 198)
BackBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
BackBtn.Text = "Back"
BackBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
BackBtn.Font = Enum.Font.Gotham
BackBtn.TextSize = 13
BackBtn.ZIndex = 57
BackBtn.Parent = RewardPage
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 10)

local earnedKey = nil
CopyBtn.MouseButton1Click:Connect(function()
	playClick()
	if earnedKey then
		pcall(function() if setclipboard then setclipboard(earnedKey) end end)
		CopyBtn.Text = "Copied!"
		task.wait(0.8)
		CopyBtn.Text = "Copy Key"
	end
end)
BackBtn.MouseButton1Click:Connect(function()
	playClick()
	RewardPage.Visible = false
	KeyPage.Visible = true
	if earnedKey then KeyBox.Text = earnedKey end
end)

local function unlockHub()
	ENV.plus1_unlocked = true
	Auth.Visible = false
	Main.Visible = true
	playUnlock()
end

SubmitBtn.MouseButton1Click:Connect(function()
	playClick()
	local entered = KeyBox.Text:gsub("%s+", "")
	if entered == "" then
		StatusLbl.Text = "Please enter a key"
		StatusLbl.TextColor3 = Color3.fromRGB(255, 140, 100)
		return
	end
	if entered == MASTER_KEY then
		saveKeyData(MASTER_KEY, os.time() + KEY_DURATION)
		StatusLbl.Text = "Welcome! Special key accepted"
		StatusLbl.TextColor3 = Color3.fromRGB(0, 220, 90)
		task.wait(0.3)
		unlockHub()
		return
	end
	local pending, pendExp = loadPendingKey()
	if pending and entered == pending then
		if pendExp and os.time() > pendExp then
			StatusLbl.Text = "Key expired — play again for a new key"
			StatusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
			playExpire()
			return
		end
		saveKeyData(entered, os.time() + KEY_DURATION)
		pcall(function() if writefile then writefile(PENDING_FILE, "") end end)
		ENV.plus1_pending_key = nil
		StatusLbl.Text = "Key accepted!"
		StatusLbl.TextColor3 = Color3.fromRGB(0, 220, 90)
		task.wait(0.3)
		unlockHub()
		return
	end
	local saved, expire = loadKeyData()
	if saved and entered == saved and saved ~= MASTER_KEY and expire and os.time() <= expire then
		StatusLbl.Text = "Key accepted"
		StatusLbl.TextColor3 = Color3.fromRGB(0, 220, 90)
		task.wait(0.3)
		unlockHub()
		return
	end
	StatusLbl.Text = "Get a key from the game first"
	StatusLbl.TextColor3 = Color3.fromRGB(255, 140, 100)
	playExpire()
end)

-- Simple Spot the Difference (25 levels) — PC + mobile friendly card
local TOTAL_LEVELS = 25
local Mini = Instance.new("Frame")
Mini.Size = UDim2.new(1, 0, 1, 0)
Mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Mini.BackgroundTransparency = 0.35
Mini.Visible = false
Mini.ZIndex = 60
Mini.Parent = ScreenGui

local MiniCard = Instance.new("Frame")
MiniCard.Name = "MiniCard"
MiniCard.AnchorPoint = Vector2.new(0.5, 0.5)
MiniCard.Position = UDim2.new(0.5, 0, 0.5, 0)
MiniCard.Size = UDim2.new(0.92, 0, 0.8, 0) -- scales with screen (mobile + PC)
MiniCard.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MiniCard.BorderSizePixel = 0
MiniCard.ClipsDescendants = true
MiniCard.ZIndex = 61
MiniCard.Parent = Mini
Instance.new("UICorner", MiniCard).CornerRadius = UDim.new(0, 12)
local miniStroke = Instance.new("UIStroke", MiniCard)
miniStroke.Color = Color3.fromRGB(0, 255, 70)
miniStroke.Thickness = 2
-- Cap size on large PC screens so it doesn't stretch too wide
local miniConstraint = Instance.new("UISizeConstraint", MiniCard)
miniConstraint.MaxSize = Vector2.new(480, 420)
miniConstraint.MinSize = Vector2.new(280, 260)

local MiniTop = Instance.new("Frame")
MiniTop.Size = UDim2.new(1, 0, 0, 44)
MiniTop.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MiniTop.ZIndex = 62
MiniTop.Parent = MiniCard
Instance.new("UICorner", MiniTop).CornerRadius = UDim.new(0, 12)
local MiniTopFix = Instance.new("Frame")
MiniTopFix.Size = UDim2.new(1, 0, 0, 12)
MiniTopFix.Position = UDim2.new(0, 0, 1, -12)
MiniTopFix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MiniTopFix.BorderSizePixel = 0
MiniTopFix.ZIndex = 62
MiniTopFix.Parent = MiniTop

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(1, -80, 0, 18)
MiniTitle.Position = UDim2.new(0, 12, 0, 4)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "Spot the Difference"
MiniTitle.TextColor3 = Color3.fromRGB(0, 220, 90)
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 14
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.ZIndex = 63
MiniTitle.Parent = MiniTop
local LevelLbl = Instance.new("TextLabel")
LevelLbl.Size = UDim2.new(1, -80, 0, 14)
LevelLbl.Position = UDim2.new(0, 12, 0, 24)
LevelLbl.BackgroundTransparency = 1
LevelLbl.Text = "Level 1 / 25"
LevelLbl.TextColor3 = Color3.fromRGB(170, 170, 170)
LevelLbl.Font = Enum.Font.Gotham
LevelLbl.TextSize = 11
LevelLbl.TextXAlignment = Enum.TextXAlignment.Left
LevelLbl.ZIndex = 63
LevelLbl.Parent = MiniTop
local ExitMini = Instance.new("TextButton")
ExitMini.Size = UDim2.new(0, 56, 0, 28)
ExitMini.Position = UDim2.new(1, -66, 0.5, -14)
ExitMini.BackgroundColor3 = Color3.fromRGB(200, 55, 55)
ExitMini.Text = "Exit"
ExitMini.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitMini.Font = Enum.Font.GothamMedium
ExitMini.TextSize = 12
ExitMini.ZIndex = 63
ExitMini.Parent = MiniTop
Instance.new("UICorner", ExitMini).CornerRadius = UDim.new(0, 8)

local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0.48, -8, 1, -78)
LeftPanel.Position = UDim2.new(0, 8, 0, 50)
LeftPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
LeftPanel.ClipsDescendants = true
LeftPanel.ZIndex = 62
LeftPanel.Parent = MiniCard
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 10)
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0.48, -8, 1, -78)
RightPanel.Position = UDim2.new(0.52, 0, 0, 50)
RightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
RightPanel.ClipsDescendants = true
RightPanel.ZIndex = 62
RightPanel.Parent = MiniCard
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 10)

local FoundLbl = Instance.new("TextLabel")
FoundLbl.Size = UDim2.new(1, -16, 0, 18)
FoundLbl.Position = UDim2.new(0, 8, 1, -22)
FoundLbl.BackgroundTransparency = 1
FoundLbl.Text = "Found 0 / 2 — Tap differences on panel B"
FoundLbl.TextColor3 = Color3.fromRGB(170, 170, 170)
FoundLbl.Font = Enum.Font.Gotham
FoundLbl.TextSize = 11
FoundLbl.ZIndex = 63
FoundLbl.Parent = MiniCard

local LevelDone = Instance.new("Frame")
LevelDone.AnchorPoint = Vector2.new(0.5, 0.5)
LevelDone.Position = UDim2.new(0.5, 0, 0.5, 0)
LevelDone.Size = UDim2.new(0, 240, 0, 100)
LevelDone.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
LevelDone.Visible = false
LevelDone.ZIndex = 70
LevelDone.Parent = MiniCard
Instance.new("UICorner", LevelDone).CornerRadius = UDim.new(0, 14)
local ldTitle = Instance.new("TextLabel")
ldTitle.Size = UDim2.new(1, 0, 0, 28)
ldTitle.Position = UDim2.new(0, 0, 0, 12)
ldTitle.BackgroundTransparency = 1
ldTitle.Text = "Level Complete!"
ldTitle.TextColor3 = Color3.fromRGB(0, 220, 90)
ldTitle.Font = Enum.Font.GothamBold
ldTitle.TextSize = 16
ldTitle.ZIndex = 71
ldTitle.Parent = LevelDone
local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(1, -36, 0, 36)
NextBtn.Position = UDim2.new(0, 18, 0, 50)
NextBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 70)
NextBtn.Text = "Next Level"
NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NextBtn.Font = Enum.Font.GothamBold
NextBtn.TextSize = 14
NextBtn.ZIndex = 71
NextBtn.Parent = LevelDone
Instance.new("UICorner", NextBtn).CornerRadius = UDim.new(0, 10)

local SHAPES = {"●", "■", "▲", "◆", "★"}
local COLORS = {
	Color3.fromRGB(255, 80, 80), Color3.fromRGB(80, 200, 255), Color3.fromRGB(255, 200, 60),
	Color3.fromRGB(120, 255, 120), Color3.fromRGB(255, 120, 220),
}
local stdActive, currentLevel, foundCount, neededDiffs = false, 1, 0, 2
local diffButtons = {}

local function clearDiffs()
	for _, b in ipairs(diffButtons) do if b then b:Destroy() end end
	diffButtons = {}
	for _, c in ipairs(LeftPanel:GetChildren()) do if c:IsA("TextLabel") or c:IsA("TextButton") then c:Destroy() end end
	for _, c in ipairs(RightPanel:GetChildren()) do if c:IsA("TextLabel") or c:IsA("TextButton") then c:Destroy() end end
end

local function placeShape(parent, shape, color, xScale, yScale, size)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0, size, 0, size)
	l.Position = UDim2.new(xScale, -size / 2, yScale, -size / 2)
	l.BackgroundTransparency = 1
	l.Text = shape
	l.TextColor3 = color
	l.TextSize = size * 0.85
	l.Font = Enum.Font.GothamBold
	l.ZIndex = 62
	l.Parent = parent
	return l
end

local function loadLevel(level)
	clearDiffs()
	LevelDone.Visible = false
	currentLevel = level
	foundCount = 0
	neededDiffs = math.min(2 + math.floor((level - 1) / 3), 5)
	LevelLbl.Text = string.format("Level %d / %d", level, TOTAL_LEVELS)
	FoundLbl.Text = string.format("Found 0 / %d — Tap differences on panel B", neededDiffs)
	local base = {}
	for i = 1, math.min(5 + level, 12) do
		base[i] = {
			shape = SHAPES[math.random(1, #SHAPES)],
			color = COLORS[math.random(1, #COLORS)],
			x = 0.12 + math.random() * 0.76,
			y = 0.15 + math.random() * 0.7,
			size = math.random(16, 28),
		}
	end
	for _, s in ipairs(base) do
		placeShape(LeftPanel, s.shape, s.color, s.x, s.y, s.size)
		placeShape(RightPanel, s.shape, s.color, s.x, s.y, s.size)
	end
	for d = 1, neededDiffs do
		local sx = 0.12 + math.random() * 0.76
		local sy = 0.15 + math.random() * 0.7
		local sz = math.random(16, 28)
		local sh = SHAPES[math.random(1, #SHAPES)]
		local col = COLORS[math.random(1, #COLORS)]
		placeShape(RightPanel, sh, col, sx, sy, sz)
		local hit = Instance.new("TextButton")
		hit.Size = UDim2.new(0, sz + 10, 0, sz + 10)
		hit.Position = UDim2.new(sx, -(sz + 10) / 2, sy, -(sz + 10) / 2)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = 63
		hit.Parent = RightPanel
		table.insert(diffButtons, hit)
		hit.MouseButton1Click:Connect(function()
			if not stdActive or not hit.Active then return end
			foundCount = foundCount + 1
			FoundLbl.Text = string.format("Found %d / %d — Tap differences on panel B", foundCount, neededDiffs)
			playFind()
			hit.Active = false
			local mark = Instance.new("Frame")
			mark.Size = UDim2.new(1, 0, 1, 0)
			mark.BackgroundColor3 = Color3.fromRGB(0, 220, 90)
			mark.BackgroundTransparency = 0.5
			mark.ZIndex = 64
			mark.Parent = hit
			Instance.new("UICorner", mark).CornerRadius = UDim.new(1, 0)
			if foundCount >= neededDiffs then
				playLevelUp()
				LevelDone.Visible = true
			end
		end)
	end
end

local function endSTD(success)
	stdActive = false
	clearDiffs()
	LevelDone.Visible = false
	Mini.Visible = false
	if success then
		playWin()
		earnedKey = genKey()
		RewKey.Text = earnedKey
		KeyPage.Visible = false
		RewardPage.Visible = true
		Auth.Visible = true
	else
		Auth.Visible = true
		KeyPage.Visible = true
	end
end

NextBtn.MouseButton1Click:Connect(function()
	playClick()
	if currentLevel >= TOTAL_LEVELS then
		endSTD(true)
	else
		loadLevel(currentLevel + 1)
	end
end)
ExitMini.MouseButton1Click:Connect(function() playClick() endSTD(false) end)
GetKeyBtn.MouseButton1Click:Connect(function()
	playClick()
	Auth.Visible = false
	Mini.Visible = true
	stdActive = true
	loadLevel(1)
end)

-- Expiry watcher
task.spawn(function()
	while true do
		task.wait(5)
		if not Main or not Main.Parent then break end
		local key, expire = loadKeyData()
		if key and key ~= MASTER_KEY and expire and os.time() > expire and Main.Visible then
			ENV.plus1_key = nil
			ENV.plus1_expire = nil
			pcall(function() if writefile then writefile(KEY_FILE, "") end end)
			Main.Visible = false
			OpenBtn.Visible = false
			Auth.Visible = true
			LoadPage.Visible = false
			KeyPage.Visible = true
			StatusLbl.Text = "Key expired — get a new key"
			StatusLbl.TextColor3 = Color3.fromRGB(255, 140, 100)
			playExpire()
		end
	end
end)

-- Boot
task.spawn(function()
	if isUnlocked() then
		Auth.Visible = false
		Main.Visible = true
		return
	end
	for i = 1, 100 do
		BarFill.Size = UDim2.new(i / 100, 0, 1, 0)
		LoadPct.Text = i .. "%"
		task.wait(0.015)
	end
	LoadSub.Text = "Ready"
	playClick()
	task.wait(0.2)
	LoadPage.Visible = false
	KeyPage.Visible = true
end)
