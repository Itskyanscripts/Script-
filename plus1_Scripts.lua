-- +1 Scripts Hub
-- Game | Game List | Misc
-- Mobile + PC friendly • Default: +1 Hacker theme

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("+1Scripts") then
	playerGui["+1Scripts"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "+1Scripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- ========== MAIN FRAME ==========
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 340, 0, 310)
Main.Position = UDim2.new(0.5, -170, 0.5, -155)
Main.BackgroundColor3 = Color3.fromRGB(8, 18, 12)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(30, 70, 40)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(12, 26, 16)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(12, 26, 16)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "+1 Scripts"
Title.TextColor3 = Color3.fromRGB(80, 255, 120)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0.5, -14)
Close.BackgroundColor3 = Color3.fromRGB(20, 40, 25)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(180, 220, 180)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

-- Open Button (√)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 16, 0.5, -20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(12, 26, 16)
OpenBtn.Text = "√"
OpenBtn.TextColor3 = Color3.fromRGB(80, 255, 120)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 20
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(30, 70, 40)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

Close.MouseButton1Click:Connect(function()
	Main.Visible = false
	OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
	Main.Visible = true
	OpenBtn.Visible = false
end)

local openDragging, openDragStart, openStartPos
OpenBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		openDragging = true
		openDragStart = input.Position
		openStartPos = OpenBtn.Position
	end
end)
OpenBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		openDragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if openDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - openDragStart
		OpenBtn.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
	end
end)

-- Tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 32)
TabBar.Position = UDim2.new(0, 8, 0, 44)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local function createTab(name, position)
	local tab = Instance.new("TextButton")
	tab.Name = name
	tab.Size = UDim2.new(0, 100, 1, 0)
	tab.Position = position
	tab.BackgroundColor3 = Color3.fromRGB(14, 30, 18)
	tab.Text = name
	tab.TextColor3 = Color3.fromRGB(140, 180, 150)
	tab.Font = Enum.Font.GothamMedium
	tab.TextSize = 13
	tab.Parent = TabBar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = tab
	return tab
end

local GameTab = createTab("Game", UDim2.new(0, 0, 0, 0))
local GameListTab = createTab("Game List", UDim2.new(0, 108, 0, 0))
local MiscTab = createTab("Misc", UDim2.new(0, 216, 0, 0))

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -84)
Content.Position = UDim2.new(0, 8, 0, 82)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ========== GAME PAGE ==========
local GamePage = Instance.new("Frame")
GamePage.Name = "GamePage"
GamePage.Size = UDim2.new(1, 0, 1, 0)
GamePage.BackgroundTransparency = 1
GamePage.Visible = true
GamePage.Parent = Content

local GameStatus = Instance.new("TextLabel")
GameStatus.Size = UDim2.new(1, 0, 0, 18)
GameStatus.BackgroundTransparency = 1
GameStatus.Text = "Current Game"
GameStatus.TextColor3 = Color3.fromRGB(120, 160, 130)
GameStatus.Font = Enum.Font.Gotham
GameStatus.TextSize = 11
GameStatus.TextXAlignment = Enum.TextXAlignment.Left
GameStatus.Parent = GamePage

local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Size = UDim2.new(1, 0, 0, 24)
GameNameLabel.Position = UDim2.new(0, 0, 0, 18)
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Text = "Loading..."
GameNameLabel.TextColor3 = Color3.fromRGB(200, 255, 210)
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

local NotAddedCorner = Instance.new("UICorner")
NotAddedCorner.CornerRadius = UDim.new(0, 6)
NotAddedCorner.Parent = NotAddedLabel

local FeaturesFrame = Instance.new("ScrollingFrame")
FeaturesFrame.Name = "FeaturesFrame"
FeaturesFrame.Size = UDim2.new(1, 0, 1, -50)
FeaturesFrame.Position = UDim2.new(0, 0, 0, 48)
FeaturesFrame.BackgroundTransparency = 1
FeaturesFrame.BorderSizePixel = 0
FeaturesFrame.ScrollBarThickness = 3
FeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(40, 90, 50)
FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
FeaturesFrame.Visible = false
FeaturesFrame.Parent = GamePage

local function clearFeatures()
	for _, child in ipairs(FeaturesFrame:GetChildren()) do
		child:Destroy()
	end
end

local function createSection(parent, text, y)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, 0, y)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(100, 180, 120)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

local function createToggle(parent, name, y, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 32)
	frame.Position = UDim2.new(0, 0, 0, y)
	frame.BackgroundColor3 = Color3.fromRGB(14, 28, 18)
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -55, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(200, 240, 210)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 40, 0, 22)
	toggle.Position = UDim2.new(1, -48, 0.5, -11)
	toggle.BackgroundColor3 = Color3.fromRGB(30, 50, 35)
	toggle.Text = ""
	toggle.Parent = frame

	local tCorner = Instance.new("UICorner")
	tCorner.CornerRadius = UDim.new(1, 0)
	tCorner.Parent = toggle

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(160, 200, 170)
	circle.Parent = toggle

	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(1, 0)
	cCorner.Parent = circle

	local enabled = false
	toggle.MouseButton1Click:Connect(function()
		enabled = not enabled
		if enabled then
			toggle.BackgroundColor3 = Color3.fromRGB(30, 120, 50)
			circle.Position = UDim2.new(1, -19, 0.5, -8)
			circle.BackgroundColor3 = Color3.fromRGB(180, 255, 190)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(30, 50, 35)
			circle.Position = UDim2.new(0, 3, 0.5, -8)
			circle.BackgroundColor3 = Color3.fromRGB(160, 200, 170)
		end
		callback(enabled)
	end)
	return frame
end

local function createButton(parent, name, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.Position = UDim2.new(0, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(18, 36, 22)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(200, 240, 210)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Helper: fire touch interest safely
local function fireTouch(part)
	if not part then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function()
		firetouchinterest(part, hrp, 0)
		task.wait()
		firetouchinterest(part, hrp, 1)
	end)
end

-- Helper: fire all proximity prompts near player or in workspace
local function firePrompts()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			pcall(function()
				fireproximityprompt(obj)
			end)
		end
	end
end

-- ========== BUILD FEATURES PER GAME ==========
local function buildGame1Features() -- PlaceId 75626443136851
	clearFeatures()
	createSection(FeaturesFrame, "World 1", 0)
	createToggle(FeaturesFrame, "Auto Farm Wins", 24, function(Value)
		getgenv().farm1 = Value
		while getgenv().farm1 do
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
	createToggle(FeaturesFrame, "Auto Farm Wins", 129, function(Value)
		getgenv().farm2 = Value
		while getgenv().farm2 do
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

local function buildGame2Features() -- PlaceId 108775830475023
	clearFeatures()

	-- World 1
	createSection(FeaturesFrame, "World 1", 0)
	createToggle(FeaturesFrame, "Auto Farm (Touch)", 24, function(Value)
		getgenv().g2_w1 = Value
		while getgenv().g2_w1 do
			task.wait(0.15)
			local ok, part = pcall(function()
				return workspace.SectionAwardParts:GetChildren()[11]
			end)
			if ok and part then
				fireTouch(part)
			end
		end
	end)

	-- World 2
	createSection(FeaturesFrame, "World 2", 65)
	createToggle(FeaturesFrame, "Auto Farm (Touch)", 89, function(Value)
		getgenv().g2_w2 = Value
		while getgenv().g2_w2 do
			task.wait(0.15)
			local ok, part = pcall(function()
				return workspace.SectionAwardParts.World2:GetChildren()[10]
			end)
			if ok and part then
				fireTouch(part)
			end
		end
	end)

	-- World 3
	createSection(FeaturesFrame, "World 3", 130)
	createToggle(FeaturesFrame, "Auto Farm (Touch)", 154, function(Value)
		getgenv().g2_w3 = Value
		while getgenv().g2_w3 do
			task.wait(0.15)
			local ok, part = pcall(function()
				return workspace.World3:GetChildren()[115]
			end)
			if ok and part then
				fireTouch(part)
			end
		end
	end)

	-- Proximity Prompt
	createSection(FeaturesFrame, "Proximity", 195)
	createToggle(FeaturesFrame, "Auto Fire Prompts", 219, function(Value)
		getgenv().g2_prompt = Value
		while getgenv().g2_prompt do
			task.wait(0.3)
			firePrompts()
		end
	end)

	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 270)
end

-- ========== GAME LIST PAGE ==========
local GameListPage = Instance.new("Frame")
GameListPage.Name = "GameListPage"
GameListPage.Size = UDim2.new(1, 0, 1, 0)
GameListPage.BackgroundTransparency = 1
GameListPage.Visible = false
GameListPage.Parent = Content

local GameListTitle = Instance.new("TextLabel")
GameListTitle.Size = UDim2.new(1, 0, 0, 18)
GameListTitle.BackgroundTransparency = 1
GameListTitle.Text = "Games (click to join)"
GameListTitle.TextColor3 = Color3.fromRGB(120, 160, 130)
GameListTitle.Font = Enum.Font.Gotham
GameListTitle.TextSize = 11
GameListTitle.TextXAlignment = Enum.TextXAlignment.Left
GameListTitle.Parent = GameListPage

local GameListScroll = Instance.new("ScrollingFrame")
GameListScroll.Name = "GameListScroll"
GameListScroll.Size = UDim2.new(1, 0, 1, -24)
GameListScroll.Position = UDim2.new(0, 0, 0, 22)
GameListScroll.BackgroundTransparency = 1
GameListScroll.BorderSizePixel = 0
GameListScroll.ScrollBarThickness = 3
GameListScroll.ScrollBarImageColor3 = Color3.fromRGB(40, 90, 50)
GameListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
GameListScroll.Parent = GameListPage

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = GameListScroll

local SupportedGames = {
	{ PlaceId = 75626443136851, Name = "World 1 & World 2 Game" },
	{ PlaceId = 108775830475023, Name = "World 1 / 2 / 3 Game" },
}

local function createGameEntry(data)
	local entry = Instance.new("TextButton")
	entry.Size = UDim2.new(1, -2, 0, 40)
	entry.BackgroundColor3 = Color3.fromRGB(14, 28, 18)
	entry.Text = ""
	entry.AutoButtonColor = false
	entry.Parent = GameListScroll

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = entry

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -12, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = Color3.fromRGB(200, 240, 210)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 13
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = entry

	entry.MouseEnter:Connect(function()
		entry.BackgroundColor3 = Color3.fromRGB(22, 42, 28)
	end)
	entry.MouseLeave:Connect(function()
		entry.BackgroundColor3 = Color3.fromRGB(14, 28, 18)
	end)

	entry.MouseButton1Click:Connect(function()
		nameLabel.Text = "Teleporting..."
		pcall(function()
			TeleportService:Teleport(data.PlaceId, player)
		end)
	end)
	return entry
end

for _, gameData in ipairs(SupportedGames) do
	createGameEntry(gameData)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	GameListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end)
GameListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)

-- ========== MISC PAGE ==========
local MiscPage = Instance.new("Frame")
MiscPage.Name = "MiscPage"
MiscPage.Size = UDim2.new(1, 0, 1, 0)
MiscPage.BackgroundTransparency = 1
MiscPage.Visible = false
MiscPage.Parent = Content

local MiscTitle = Instance.new("TextLabel")
MiscTitle.Size = UDim2.new(1, 0, 0, 18)
MiscTitle.BackgroundTransparency = 1
MiscTitle.Text = "WalkSpeed"
MiscTitle.TextColor3 = Color3.fromRGB(120, 160, 130)
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
SpeedInput.BackgroundColor3 = Color3.fromRGB(14, 28, 18)
SpeedInput.Text = "16"
SpeedInput.PlaceholderText = "1 - 500"
SpeedInput.TextColor3 = Color3.fromRGB(200, 240, 210)
SpeedInput.PlaceholderColor3 = Color3.fromRGB(80, 120, 90)
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.TextSize = 14
SpeedInput.ClearTextOnFocus = false
SpeedInput.Parent = MiscPage

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = SpeedInput

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, 0, 0, 32)
ApplyBtn.Position = UDim2.new(0, 0, 0, 90)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(25, 80, 40)
ApplyBtn.Text = "Apply WalkSpeed"
ApplyBtn.TextColor3 = Color3.fromRGB(200, 255, 210)
ApplyBtn.Font = Enum.Font.GothamMedium
ApplyBtn.TextSize = 13
ApplyBtn.Parent = MiscPage

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 6)
applyCorner.Parent = ApplyBtn

local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(1, 0, 0, 30)
ResetBtn.Position = UDim2.new(0, 0, 0, 128)
ResetBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 30)
ResetBtn.Text = "Reset to 16"
ResetBtn.TextColor3 = Color3.fromRGB(160, 200, 170)
ResetBtn.Font = Enum.Font.Gotham
ResetBtn.TextSize = 12
ResetBtn.Parent = MiscPage

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = ResetBtn

local ThemeTitle = Instance.new("TextLabel")
ThemeTitle.Size = UDim2.new(1, 0, 0, 18)
ThemeTitle.Position = UDim2.new(0, 0, 0, 170)
ThemeTitle.BackgroundTransparency = 1
ThemeTitle.Text = "Theme"
ThemeTitle.TextColor3 = Color3.fromRGB(120, 160, 130)
ThemeTitle.Font = Enum.Font.Gotham
ThemeTitle.TextSize = 11
ThemeTitle.TextXAlignment = Enum.TextXAlignment.Left
ThemeTitle.Parent = MiscPage

local themes = {
	{Name = "+1 for hacker", Color = Color3.fromRGB(8, 18, 12)},
	{Name = "Dark", Color = Color3.fromRGB(18, 18, 22)},
	{Name = "Midnight", Color = Color3.fromRGB(12, 14, 24)},
	{Name = "Purple", Color = Color3.fromRGB(22, 16, 28)},
}

local function applyTheme(bgColor)
	Main.BackgroundColor3 = bgColor
	local titleCol = Color3.new(
		math.clamp(bgColor.R + 0.03, 0, 1),
		math.clamp(bgColor.G + 0.04, 0, 1),
		math.clamp(bgColor.B + 0.03, 0, 1)
	)
	TitleBar.BackgroundColor3 = titleCol
	TitleFix.BackgroundColor3 = titleCol
	OpenBtn.BackgroundColor3 = titleCol
end

for i, theme in ipairs(themes) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.Position = UDim2.new(0, 0, 0, 192 + (i - 1) * 34)
	btn.BackgroundColor3 = Color3.fromRGB(14, 28, 18)
	btn.Text = theme.Name
	btn.TextColor3 = Color3.fromRGB(180, 230, 190)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 12
	btn.Parent = MiscPage

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		applyTheme(theme.Color)
	end)
end

local function setWalkSpeed(speed)
	speed = math.clamp(tonumber(speed) or 16, 1, 500)
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = speed
		end
	end
	SpeedLabel.Text = "Current: " .. tostring(speed)
	SpeedInput.Text = tostring(speed)
end

ApplyBtn.MouseButton1Click:Connect(function()
	setWalkSpeed(SpeedInput.Text)
end)
ResetBtn.MouseButton1Click:Connect(function()
	setWalkSpeed(16)
end)
SpeedInput.FocusLost:Connect(function(enter)
	if enter then setWalkSpeed(SpeedInput.Text) end
end)

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	local speed = tonumber(SpeedInput.Text) or 16
	if speed ~= 16 then
		local hum = char:WaitForChild("Humanoid", 5)
		if hum then hum.WalkSpeed = math.clamp(speed, 1, 500) end
	end
end)

-- Tab switching
local function switchTab(selected)
	GamePage.Visible = (selected == "Game")
	GameListPage.Visible = (selected == "Game List")
	MiscPage.Visible = (selected == "Misc")

	local tabs = { ["Game"] = GameTab, ["Game List"] = GameListTab, ["Misc"] = MiscTab }
	for name, tab in pairs(tabs) do
		if name == selected then
			tab.BackgroundColor3 = Color3.fromRGB(25, 55, 32)
			tab.TextColor3 = Color3.fromRGB(180, 255, 190)
		else
			tab.BackgroundColor3 = Color3.fromRGB(14, 30, 18)
			tab.TextColor3 = Color3.fromRGB(140, 180, 150)
		end
	end
end

GameTab.MouseButton1Click:Connect(function() switchTab("Game") end)
GameListTab.MouseButton1Click:Connect(function() switchTab("Game List") end)
MiscTab.MouseButton1Click:Connect(function() switchTab("Misc") end)

-- Detect + load features
local SUPPORTED = {
	[75626443136851] = buildGame1Features,
	[108775830475023] = buildGame2Features,
}

local success, info = pcall(function()
	return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success and info then
	GameNameLabel.Text = info.Name
else
	GameNameLabel.Text = "Unknown Game"
end

if SUPPORTED[game.PlaceId] then
	NotAddedLabel.Visible = false
	FeaturesFrame.Visible = true
	SUPPORTED[game.PlaceId]()
else
	NotAddedLabel.Visible = true
	FeaturesFrame.Visible = false
end

-- Main draggable
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)
TitleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

switchTab("Game")
