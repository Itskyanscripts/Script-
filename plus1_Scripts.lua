-- +1 Scripts Hub
-- Game | Game List | Misc
-- Mobile + PC friendly • Default: +1 Hacker theme

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

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
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 45, 45)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
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
OpenBtn.Size = UDim2.new(0, 56, 0, 40)
OpenBtn.Position = UDim2.new(0, 16, 0.5, -20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
OpenBtn.Text = "Open"
OpenBtn.TextColor3 = Color3.fromRGB(0, 220, 90)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(45, 45, 45)
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
FeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 160, 65)
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
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = frame

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
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function fireTouch(part)
	if not part then return end
	-- If they passed TouchInterest, use its parent
	if part:IsA("TouchTransmitter") or part.Name == "TouchInterest" then
		part = part.Parent
	end
	if not part or not part:IsA("BasePart") then return end
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

-- ========== GAME 1 FEATURES ==========
local function buildGame1Features()
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

-- ========== GAME 2 FEATURES ==========
local function buildGame2Features()
	clearFeatures()

	-- World 1
	createSection(FeaturesFrame, "World 1", 0)
	createToggle(FeaturesFrame, "Auto Farm", 24, function(Value)
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
	createToggle(FeaturesFrame, "Auto Farm", 89, function(Value)
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

	-- World 3 (dynamic - finds TouchInterest each time, works across servers)
	createSection(FeaturesFrame, "World 3", 130)
	createToggle(FeaturesFrame, "Auto Farm", 154, function(Value)
		getgenv().g2_w3 = Value
		while getgenv().g2_w3 do
			task.wait(0.15)
			pcall(function()
				local world3 = workspace:FindFirstChild("World3")
				if not world3 then return end
				-- Find any part under World3 that has TouchInterest
				for _, child in ipairs(world3:GetChildren()) do
					if child:FindFirstChildOfClass("TouchTransmitter") or child:FindFirstChild("TouchInterest") then
						fireTouch(child)
					end
				end
				-- Also check deeper descendants just in case
				for _, desc in ipairs(world3:GetDescendants()) do
					if desc:IsA("TouchTransmitter") or desc.Name == "TouchInterest" then
						fireTouch(desc.Parent)
					end
				end
			end)
		end
	end)

	-- TP World Area
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


-- ========== GAME 3 FEATURES (84757653274750) ==========
local function buildGame3Features()
	clearFeatures()

	createSection(FeaturesFrame, "Farming", 0)
	createToggle(FeaturesFrame, "Auto Farm Wins", 24, function(Value)
		getgenv().g3_farm = Value
		while getgenv().g3_farm do
			task.wait(0.1)
			pcall(function()
				local btn = workspace.WinCollectors.Stage25.Button:GetChildren()[8]
				if btn then
					fireTouch(btn)
				end
			end)
		end
	end)

	createToggle(FeaturesFrame, "Auto Swing", 62, function(Value)
		getgenv().g3_swing = Value
		while getgenv().g3_swing do
			task.wait(0.1)
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.SwingRequest:FireServer()
			end)
		end
	end)

	createSection(FeaturesFrame, "Rebirth", 105)
	createToggle(FeaturesFrame, "Auto Rebirth", 129, function(Value)
		getgenv().g3_rebirth = Value
		while getgenv().g3_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.RebirthRequest:FireServer()
			end)
		end
	end)

	-- Eggs dropdown + Buy
	createSection(FeaturesFrame, "Eggs", 170)

	local eggOptions = {
		{Label = "Basic Egg (500)", Egg = "BasicEgg"},
		{Label = "Advance Egg (35k)", Egg = "AdvancedEgg"},
		{Label = "Pro Egg (2m)", Egg = "ProEgg"},
		{Label = "Elite Egg (360m)", Egg = "EliteEgg"},
	}
	local selectedEgg = eggOptions[1]

	-- Dropdown button
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

	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 6)
	dropCorner.Parent = dropBtn

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 10)
	pad.Parent = dropBtn

	-- Dropdown list (hidden by default)
	local dropList = Instance.new("Frame")
	dropList.Size = UDim2.new(1, 0, 0, #eggOptions * 30)
	dropList.Position = UDim2.new(0, 0, 0, 228)
	dropList.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	dropList.Visible = false
	dropList.ZIndex = 10
	dropList.Parent = FeaturesFrame

	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 6)
	listCorner.Parent = dropList

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = dropList

	for i, opt in ipairs(eggOptions) do
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
			selectedEgg = opt
			dropBtn.Text = "▼  " .. opt.Label
			dropList.Visible = false
		end)
	end

	dropBtn.MouseButton1Click:Connect(function()
		dropList.Visible = not dropList.Visible
	end)

	-- Buy button
	local buyBtn = Instance.new("TextButton")
	buyBtn.Size = UDim2.new(1, 0, 0, 32)
	buyBtn.Position = UDim2.new(0, 0, 0, 234)
	buyBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 65)
	buyBtn.Text = "Buy"
	buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyBtn.Font = Enum.Font.GothamMedium
	buyBtn.TextSize = 13
	buyBtn.Parent = FeaturesFrame

	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 6)
	buyCorner.Parent = buyBtn

	-- Keep buy button below dropdown when open
	local function updateBuyPos()
		if dropList.Visible then
			buyBtn.Position = UDim2.new(0, 0, 0, 234 + #eggOptions * 30)
		else
			buyBtn.Position = UDim2.new(0, 0, 0, 234)
		end
	end

	dropBtn.MouseButton1Click:Connect(function()
		task.wait()
		updateBuyPos()
	end)

	buyBtn.MouseButton1Click:Connect(function()
		pcall(function()
			local args = {
				[1] = "PurchaseEgg",
				[2] = selectedEgg.Egg,
				[3] = 1
			}
			game:GetService("ReplicatedStorage").Remotes.EggEvents:FireServer(unpack(args))
		end)
		buyBtn.Text = "Bought!"
		task.wait(0.6)
		buyBtn.Text = "Buy"
	end)

	
	local openEggBtn = Instance.new("TextButton")
	openEggBtn.Size = UDim2.new(1, 0, 0, 32)
	openEggBtn.Position = UDim2.new(0, 0, 0, 272)
	openEggBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	openEggBtn.Text = "Open"
	openEggBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	openEggBtn.Font = Enum.Font.GothamMedium
	openEggBtn.TextSize = 13
	openEggBtn.Parent = FeaturesFrame
	Instance.new("UICorner", openEggBtn).CornerRadius = UDim.new(0, 6)
	openEggBtn.MouseButton1Click:Connect(function()
		pcall(function()
			game:GetService("ReplicatedStorage").Remotes.EggEvents:FireServer("OpenEgg", selectedEgg.Egg, 1)
		end)
		openEggBtn.Text = "Opened!"
		task.wait(0.6)
		openEggBtn.Text = "Open"
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 320)

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
GameListTitle.TextColor3 = Color3.fromRGB(170, 170, 170)
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
GameListScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 160, 65)
GameListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
GameListScroll.Parent = GameListPage

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = GameListScroll

-- PlaceIds only - real names fetched from Marketplace
local SupportedPlaceIds = {
	75626443136851,
	108775830475023,
	84757653274750,
}

local function createGameEntry(placeId, gameName)
	local entry = Instance.new("TextButton")
	entry.Size = UDim2.new(1, -2, 0, 40)
	entry.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
	nameLabel.Text = gameName
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 13
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = entry

	entry.MouseEnter:Connect(function()
		entry.BackgroundColor3 = Color3.fromRGB(22, 42, 28)
	end)
	entry.MouseLeave:Connect(function()
		entry.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end)

	entry.MouseButton1Click:Connect(function()
		nameLabel.Text = "Teleporting..."
		pcall(function()
			TeleportService:Teleport(placeId, player)
		end)
	end)
	return entry
end

-- Fetch real game names
task.spawn(function()
	for _, placeId in ipairs(SupportedPlaceIds) do
		local name = "Place " .. tostring(placeId)
		local ok, info = pcall(function()
			return MarketplaceService:GetProductInfo(placeId)
		end)
		if ok and info and info.Name then
			name = info.Name
		end
		createGameEntry(placeId, name)
	end
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		GameListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
	end)
	GameListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end)

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
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 65)
ApplyBtn.Text = "Apply WalkSpeed"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
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

getgenv().infJump = false
local InfF = Instance.new("Frame")
InfF.Size = UDim2.new(1,0,0,32)
InfF.Position = UDim2.new(0,0,0,200)
InfF.BackgroundColor3 = Color3.fromRGB(30,30,30)
InfF.Parent = MiscPage
Instance.new("UICorner", InfF).CornerRadius = UDim.new(0,6)
local InfL = Instance.new("TextLabel")
InfL.Size = UDim2.new(1,-50,1,0)
InfL.Position = UDim2.new(0,10,0,0)
InfL.BackgroundTransparency = 1
InfL.Text = "Inf Jump"
InfL.TextColor3 = Color3.fromRGB(255,255,255)
InfL.Font = Enum.Font.Gotham
InfL.TextSize = 13
InfL.TextXAlignment = Enum.TextXAlignment.Left
InfL.Parent = InfF
local InfB = Instance.new("TextButton")
InfB.Size = UDim2.new(0,40,0,22)
InfB.Position = UDim2.new(1,-48,0.5,-11)
InfB.BackgroundColor3 = Color3.fromRGB(45,45,45)
InfB.Text = ""
InfB.Parent = InfF
Instance.new("UICorner", InfB).CornerRadius = UDim.new(1,0)
local InfC = Instance.new("Frame")
InfC.Size = UDim2.new(0,16,0,16)
InfC.Position = UDim2.new(0,3,0.5,-8)
InfC.BackgroundColor3 = Color3.fromRGB(160,160,160)
InfC.Parent = InfB
Instance.new("UICorner", InfC).CornerRadius = UDim.new(1,0)
InfB.MouseButton1Click:Connect(function()
	getgenv().infJump = not getgenv().infJump
	if getgenv().infJump then
		InfB.BackgroundColor3 = Color3.fromRGB(0,160,65)
		InfC.Position = UDim2.new(1,-19,0.5,-8)
		InfC.BackgroundColor3 = Color3.fromRGB(0,220,90)
	else
		InfB.BackgroundColor3 = Color3.fromRGB(45,45,45)
		InfC.Position = UDim2.new(0,3,0.5,-8)
		InfC.BackgroundColor3 = Color3.fromRGB(160,160,160)
	end
end)
UserInputService.JumpRequest:Connect(function()
	if getgenv().infJump then
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end
end)
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

GameTab.MouseButton1Click:Connect(function() 
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
switchTab("Game") end)
GameListTab.MouseButton1Click:Connect(function() switchTab("Game List") end)
MiscTab.MouseButton1Click:Connect(function() switchTab("Misc") end)

-- Detect + load features
local SUPPORTED = {
	[75626443136851] = buildGame1Features,
	[108775830475023] = buildGame2Features,
	[84757653274750] = buildGame3Features,
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


-- Open digits
do
	OpenBtn.ClipsDescendants = true
	local OpenRain = Instance.new("Frame")
	OpenRain.Size = UDim2.new(1,0,1,0)
	OpenRain.BackgroundTransparency = 1
	OpenRain.ZIndex = 0
	OpenRain.ClipsDescendants = true
	OpenRain.Parent = OpenBtn
	local OD = {"1","0","0","1","2","3","0"}
	task.spawn(function()
		while OpenRain and OpenRain.Parent do
			if OpenBtn.Visible then
				local d = Instance.new("TextLabel")
				d.Size = UDim2.new(0,10,0,12)
				d.BackgroundTransparency = 1
				d.Text = OD[math.random(1,#OD)]
				d.TextColor3 = Color3.fromRGB(0, math.random(140,220), math.random(40,90))
				d.Font = Enum.Font.Code
				d.TextSize = 10
				d.TextTransparency = 0.4
				d.ZIndex = 0
				d.Parent = OpenRain
				local x, y = math.random(0,46), -12
				d.Position = UDim2.new(0,x,0,y)
				local speed = math.random(20,50)/100
				task.spawn(function()
					while d and d.Parent and y < 50 do
						y = y + speed * 2
						d.Position = UDim2.new(0,x,0,y)
						task.wait(0.03)
					end
					if d then d:Destroy() end
				end)
			end
			task.wait(0.15)
		end
	end)
end

-- Sounds (click, wrong, find, level, unlock, WIN)
local clicks = {"rbxassetid://103866342467024","rbxassetid://14133663945","rbxassetid://876939830","rbxassetid://166084059"}
local wrongs = {"rbxassetid://12222124","rbxassetid://178077629","rbxassetid://138081500"}
local finds = {"rbxassetid://515373460","rbxassetid://4612375201","rbxassetid://911382214"}
local levels = {"rbxassetid://3398620867","rbxassetid://6026984224"}
local unlocks = {"rbxassetid://4612375201","rbxassetid://3398620867"}
local wins = {"rbxassetid://183990826","rbxassetid://12222225","rbxassetid://3398620867","rbxassetid://6026984224"}

local function playSfx(ids, vol, speed)
	local s = Instance.new("Sound")
	s.SoundId = ids[math.random(1,#ids)]
	s.Volume = vol or 0.45
	s.PlaybackSpeed = speed or (0.9 + math.random()*0.2)
	s.Parent = SoundService
	s:Play()
	s.Ended:Connect(function() s:Destroy() end)
	task.delay(4, function() if s and s.Parent then s:Destroy() end end)
end
local function playClick() playSfx(clicks, 0.4) end
local function playWrong() playSfx(wrongs, 0.55, 0.85) end
local function playFind() playSfx(finds, 0.5, 1.1) end
local function playLevelUp() playSfx(levels, 0.5, 1.0) end
local function playUnlock() playSfx(unlocks, 0.55, 1.05) end
local function playWin() playSfx(wins, 0.7, 1.0) end

-- Accounts owner-only
local AccountsPage, AccountsTab = nil, nil
if player.Name == "Eyfanboy09" then
	AccountsTab = Instance.new("TextButton")
	AccountsTab.Name = "Accounts"
	AccountsTab.Size = UDim2.new(0, 80, 1, 0)
	AccountsTab.Position = UDim2.new(0, 222, 0, 0)
	AccountsTab.BackgroundColor3 = Color3.fromRGB(30,30,30)
	AccountsTab.Text = "Accounts"
	AccountsTab.TextColor3 = Color3.fromRGB(170,170,170)
	AccountsTab.Font = Enum.Font.GothamMedium
	AccountsTab.TextSize = 12
	AccountsTab.Parent = TabBar
	Instance.new("UICorner", AccountsTab).CornerRadius = UDim.new(0, 6)
	GameTab.Size = UDim2.new(0, 70, 1, 0)
	GameTab.Position = UDim2.new(0, 0, 0, 0)
	GameListTab.Size = UDim2.new(0, 80, 1, 0)
	GameListTab.Position = UDim2.new(0, 74, 0, 0)
	MiscTab.Size = UDim2.new(0, 60, 1, 0)
	MiscTab.Position = UDim2.new(0, 158, 0, 0)

	AccountsPage = Instance.new("Frame")
	AccountsPage.Size = UDim2.new(1,0,1,0)
	AccountsPage.BackgroundTransparency = 1
	AccountsPage.Visible = false
	AccountsPage.Parent = Content

	local ownerLbl = Instance.new("TextLabel")
	ownerLbl.Size = UDim2.new(1,0,0,16)
	ownerLbl.BackgroundTransparency = 1
	ownerLbl.Text = "Owner: Eyfanboy09"
	ownerLbl.TextColor3 = Color3.fromRGB(0,220,90)
	ownerLbl.Font = Enum.Font.GothamBold
	ownerLbl.TextSize = 12
	ownerLbl.TextXAlignment = Enum.TextXAlignment.Left
	ownerLbl.Parent = AccountsPage

	local youLbl = Instance.new("TextLabel")
	youLbl.Size = UDim2.new(1,0,0,14)
	youLbl.Position = UDim2.new(0,0,0,18)
	youLbl.BackgroundTransparency = 1
	youLbl.Text = "Logged in as: " .. player.Name
	youLbl.TextColor3 = Color3.fromRGB(170,170,170)
	youLbl.Font = Enum.Font.Gotham
	youLbl.TextSize = 11
	youLbl.TextXAlignment = Enum.TextXAlignment.Left
	youLbl.Parent = AccountsPage

	local AccScroll = Instance.new("ScrollingFrame")
	AccScroll.Size = UDim2.new(1,0,1,-40)
	AccScroll.Position = UDim2.new(0,0,0,38)
	AccScroll.BackgroundColor3 = Color3.fromRGB(22,22,22)
	AccScroll.BorderSizePixel = 0
	AccScroll.ScrollBarThickness = 3
	AccScroll.Parent = AccountsPage
	Instance.new("UICorner", AccScroll).CornerRadius = UDim.new(0,6)
	local accLayout = Instance.new("UIListLayout", AccScroll)
	accLayout.SortOrder = Enum.SortOrder.LayoutOrder
	accLayout.Padding = UDim.new(0,6)

	local ACCOUNT_FILE = "plus1_accounts_list.txt"
	local function loadAccounts()
		local list = {}
		pcall(function()
			if isfile and isfile(ACCOUNT_FILE) and readfile then
				for line in readfile(ACCOUNT_FILE):gmatch("[^\r\n]+") do
					local u, p = line:match("([^|]+)|?(.*)")
					if u and u ~= "" then table.insert(list, {user=u, pass=p or ""}) end
				end
			end
		end)
		return list
	end
	local function saveAccounts(list)
		pcall(function()
			if writefile then
				local lines = {}
				for _,a in ipairs(list) do table.insert(lines, a.user.."|"..(a.pass or "")) end
				writefile(ACCOUNT_FILE, table.concat(lines, "\n"))
			end
		end)
	end
	local function refreshAccounts()
		for _,c in ipairs(AccScroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		local list = loadAccounts()
		local has = false
		for _,a in ipairs(list) do if a.user:lower()==player.Name:lower() then has=true break end end
		if not has then table.insert(list, 1, {user=player.Name, pass=""}) saveAccounts(list) end
		for _,acc in ipairs(list) do
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, -8, 0, 56)
			row.BackgroundColor3 = Color3.fromRGB(30,30,30)
			row.Parent = AccScroll
			Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
			local nL = Instance.new("TextLabel")
			nL.Size = UDim2.new(1, -70, 0, 18)
			nL.Position = UDim2.new(0, 8, 0, 4)
			nL.BackgroundTransparency = 1
			nL.Text = "Account: " .. acc.user
			nL.TextColor3 = Color3.fromRGB(255,255,255)
			nL.Font = Enum.Font.GothamMedium
			nL.TextSize = 12
			nL.TextXAlignment = Enum.TextXAlignment.Left
			nL.Parent = row
			local pL = Instance.new("TextLabel")
			pL.Size = UDim2.new(1, -70, 0, 16)
			pL.Position = UDim2.new(0, 8, 0, 24)
			pL.BackgroundTransparency = 1
			pL.Text = "Password: " .. (acc.pass ~= "" and acc.pass or "(none)")
			pL.TextColor3 = Color3.fromRGB(170,170,170)
			pL.Font = Enum.Font.Gotham
			pL.TextSize = 11
			pL.TextXAlignment = Enum.TextXAlignment.Left
			pL.Parent = row
			local copyB = Instance.new("TextButton")
			copyB.Size = UDim2.new(0, 56, 0, 24)
			copyB.Position = UDim2.new(1, -64, 0.5, -12)
			copyB.BackgroundColor3 = Color3.fromRGB(35, 55, 90)
			copyB.Text = "Copy"
			copyB.TextColor3 = Color3.fromRGB(180, 210, 255)
			copyB.Font = Enum.Font.GothamMedium
			copyB.TextSize = 11
			copyB.Parent = row
			Instance.new("UICorner", copyB).CornerRadius = UDim.new(0,6)
			local passCopy, userCopy = acc.pass, acc.user
			copyB.MouseButton1Click:Connect(function()
				local toCopy = (passCopy ~= "" and passCopy) or userCopy
				pcall(function() if setclipboard then setclipboard(toCopy) end end)
				playClick()
				copyB.Text = "Copied!"
				task.wait(0.7)
				copyB.Text = "Copy"
			end)
		end
		AccScroll.CanvasSize = UDim2.new(0,0,0, #list * 62)
	end
	refreshAccounts()

	switchTab = function(selected)
		GamePage.Visible = (selected == "Game")
		GameListPage.Visible = (selected == "Game List")
		MiscPage.Visible = (selected == "Misc")
		AccountsPage.Visible = (selected == "Accounts")
		local tabs = {["Game"]=GameTab, ["Game List"]=GameListTab, ["Misc"]=MiscTab, ["Accounts"]=AccountsTab}
		for name, tab in pairs(tabs) do
			if tab then
				if name == selected then
					tab.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
					tab.TextColor3 = Color3.fromRGB(0, 220, 90)
				else
					tab.BackgroundColor3 = Color3.fromRGB(30,30,30)
					tab.TextColor3 = Color3.fromRGB(170,170,170)
				end
			end
		end
	end
	AccountsTab.MouseButton1Click:Connect(function() switchTab("Accounts") end)
end

-- ========== KEY SYSTEM (responsive mobile + PC) ==========
local MASTER_KEY = "1mth3b3st"
local KEY_DURATION = 24 * 60 * 60
local KEY_FILE = "plus1_key_data.txt"

local function saveKeyData(key, expireAt)
	pcall(function() if writefile then writefile(KEY_FILE, key.."|"..tostring(expireAt)) end end)
	getgenv().plus1_key, getgenv().plus1_expire = key, expireAt
end
local function loadKeyData()
	local key, expire = getgenv().plus1_key, getgenv().plus1_expire
	pcall(function()
		if isfile and isfile(KEY_FILE) and readfile then
			local k,e = readfile(KEY_FILE):match("([^|]+)|(.+)")
			if k and e then key, expire = k, tonumber(e) end
		end
	end)
	return key, expire
end
local function isUnlocked()
	if getgenv().plus1_unlocked then return true end
	local key, expire = loadKeyData()
	if key == MASTER_KEY then return true end
	if key and expire and os.time() <= expire then return true end
	return false
end
local function genKey()
	local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local out = ""
	for i=1,9 do local idx=math.random(1,#chars); out=out..chars:sub(idx,idx) end
	return out
end
local savedWS, savedJP = 16, 50
local function freezePlayer(on)
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	if on then
		savedWS, savedJP = hum.WalkSpeed, hum.JumpPower
		hum.WalkSpeed, hum.JumpPower, hum.JumpHeight = 0, 0, 0
	else
		hum.WalkSpeed = savedWS or 16
		hum.JumpPower = savedJP or 50
	end
end

local Auth = Instance.new("Frame")
Auth.Size = UDim2.new(1,0,1,0)
Auth.BackgroundColor3 = Color3.fromRGB(5,5,5)
Auth.BackgroundTransparency = 0.2
Auth.ZIndex = 50
Auth.Parent = ScreenGui

-- Responsive card: scale-based for mobile + PC
local AuthCard = Instance.new("Frame")
AuthCard.Name = "AuthCard"
AuthCard.AnchorPoint = Vector2.new(0.5, 0.5)
AuthCard.Position = UDim2.new(0.5, 0, 0.5, 0)
AuthCard.Size = UDim2.new(0.9, 0, 0, 320) -- width 90% of screen, fixed height then clamp
AuthCard.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
AuthCard.BorderSizePixel = 0
AuthCard.ZIndex = 55
AuthCard.Parent = Auth
Instance.new("UICorner", AuthCard).CornerRadius = UDim.new(0, 14)

local cardConstraint = Instance.new("UISizeConstraint", AuthCard)
cardConstraint.MinSize = Vector2.new(260, 280)
cardConstraint.MaxSize = Vector2.new(380, 360)

local acs = Instance.new("UIStroke", AuthCard)
acs.Color = Color3.fromRGB(0, 220, 90)
acs.Thickness = 2
acs.Transparency = 0.35

-- Top accent bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 4)
topBar.BackgroundColor3 = Color3.fromRGB(0, 220, 90)
topBar.BorderSizePixel = 0
topBar.ZIndex = 56
topBar.Parent = AuthCard

-- Soft glow line
local glow = Instance.new("Frame")
glow.Size = UDim2.new(0.6, 0, 0, 2)
glow.Position = UDim2.new(0.2, 0, 0, 4)
glow.BackgroundColor3 = Color3.fromRGB(120, 255, 180)
glow.BackgroundTransparency = 0.5
glow.BorderSizePixel = 0
glow.ZIndex = 57
glow.Parent = AuthCard

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

-- LOAD PAGE
local LoadPage = Instance.new("Frame")
LoadPage.Size = UDim2.new(1,0,1,0)
LoadPage.BackgroundTransparency = 1
LoadPage.ZIndex = 56
LoadPage.Parent = AuthCard
mkL(LoadPage, "+1 Scripts", 40, 22, Color3.fromRGB(0,220,90), true)
local LoadSub = mkL(LoadPage, "Initializing...", 72, 13, Color3.fromRGB(170,170,170), false)
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -40, 0, 10)
BarBg.Position = UDim2.new(0, 20, 0, 150)
BarBg.BackgroundColor3 = Color3.fromRGB(28,28,28)
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 57
BarBg.Parent = LoadPage
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1,0)
local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0,0,1,0)
BarFill.BackgroundColor3 = Color3.fromRGB(0,220,90)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 58
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1,0)
local LoadPct = mkL(LoadPage, "0%", 170, 12, Color3.fromRGB(170,170,170), false)

-- KEY PAGE
local KeyPage = Instance.new("Frame")
KeyPage.Size = UDim2.new(1,0,1,0)
KeyPage.BackgroundTransparency = 1
KeyPage.Visible = false
KeyPage.ZIndex = 56
KeyPage.Parent = AuthCard
mkL(KeyPage, "Key System", 18, 18, Color3.fromRGB(0,220,90), true)
mkL(KeyPage, "Enter your key below.\nEarned keys expire in 24h • Special key always works", 46, 11, Color3.fromRGB(150,150,150), false)

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -32, 0, 40)
KeyBox.Position = UDim2.new(0, 16, 0, 100)
KeyBox.BackgroundColor3 = Color3.fromRGB(22,22,22)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Paste or type key..."
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(100,100,100)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false
KeyBox.ZIndex = 57
KeyBox.Parent = KeyPage
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)
local kbStroke = Instance.new("UIStroke", KeyBox)
kbStroke.Color = Color3.fromRGB(50,50,50)
kbStroke.Thickness = 1

local StatusLbl = mkL(KeyPage, "", 148, 12, Color3.fromRGB(255,120,100), false)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -32, 0, 40)
SubmitBtn.Position = UDim2.new(0, 16, 0, 175)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 70)
SubmitBtn.Text = "Unlock"
SubmitBtn.TextColor3 = Color3.fromRGB(255,255,255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 15
SubmitBtn.ZIndex = 57
SubmitBtn.Parent = KeyPage
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 10)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(1, -32, 0, 36)
GetKeyBtn.Position = UDim2.new(0, 16, 0, 224)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
GetKeyBtn.Text = "Get Key  ›"
GetKeyBtn.TextColor3 = Color3.fromRGB(0, 220, 90)
GetKeyBtn.Font = Enum.Font.GothamMedium
GetKeyBtn.TextSize = 13
GetKeyBtn.ZIndex = 57
GetKeyBtn.Parent = KeyPage
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 10)
local gkStroke = Instance.new("UIStroke", GetKeyBtn)
gkStroke.Color = Color3.fromRGB(0, 120, 50)
gkStroke.Thickness = 1
gkStroke.Transparency = 0.4

-- REWARD PAGE
local RewardPage = Instance.new("Frame")
RewardPage.Size = UDim2.new(1,0,1,0)
RewardPage.BackgroundTransparency = 1
RewardPage.Visible = false
RewardPage.ZIndex = 56
RewardPage.Parent = AuthCard
mkL(RewardPage, "Key Earned!", 24, 18, Color3.fromRGB(0,220,90), true)
mkL(RewardPage, "Copy your key and use it to unlock", 52, 12, Color3.fromRGB(150,150,150), false)

local RewKey = Instance.new("TextLabel")
RewKey.Size = UDim2.new(1, -32, 0, 44)
RewKey.Position = UDim2.new(0, 16, 0, 88)
RewKey.BackgroundColor3 = Color3.fromRGB(22,22,22)
RewKey.Text = "XXXXXXXXX"
RewKey.TextColor3 = Color3.fromRGB(0,220,90)
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
CopyBtn.TextColor3 = Color3.fromRGB(255,255,255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.ZIndex = 57
CopyBtn.Parent = RewardPage
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 10)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(1, -32, 0, 36)
BackBtn.Position = UDim2.new(0, 16, 0, 198)
BackBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
BackBtn.Text = "Back"
BackBtn.TextColor3 = Color3.fromRGB(170,170,170)
BackBtn.Font = Enum.Font.Gotham
BackBtn.TextSize = 13
BackBtn.ZIndex = 57
BackBtn.Parent = RewardPage
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 10)

local earnedKey = nil
CopyBtn.MouseButton1Click:Connect(function()
	if earnedKey then
		pcall(function() if setclipboard then setclipboard(earnedKey) end end)
		playClick()
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

-- Resize AuthCard when viewport changes (mobile rotate etc)
local function fitAuthCard()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local vs = cam.ViewportSize
	local w = math.clamp(vs.X * 0.9, 260, 380)
	local h = math.clamp(vs.Y * 0.55, 300, 360)
	AuthCard.Size = UDim2.new(0, w, 0, h)
end
fitAuthCard()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitAuthCard)
end

-- SPOT THE DIFFERENCE (harder)
local TOTAL_LEVELS = 25
local SHAPES = {"●","■","▲","◆","★","✦","⬡","♥","◆","●"}
local COLORS = {
	Color3.fromRGB(255,80,80), Color3.fromRGB(80,200,255), Color3.fromRGB(255,200,60),
	Color3.fromRGB(120,255,120), Color3.fromRGB(255,120,220), Color3.fromRGB(180,140,255),
	Color3.fromRGB(255,160,80), Color3.fromRGB(100,255,200), Color3.fromRGB(255,100,150),
	Color3.fromRGB(100,180,255),
}

local Mini = Instance.new("Frame")
Mini.Size = UDim2.new(1,0,1,0)
Mini.BackgroundColor3 = Color3.fromRGB(10,10,10)
Mini.Visible = false
Mini.ZIndex = 60
Mini.Parent = ScreenGui

local MiniTop = Instance.new("Frame")
MiniTop.Size = UDim2.new(1,0,0,48)
MiniTop.BackgroundColor3 = Color3.fromRGB(18,18,18)
MiniTop.BorderSizePixel = 0
MiniTop.ZIndex = 61
MiniTop.Parent = Mini

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(1,-170,0,20)
MiniTitle.Position = UDim2.new(0,12,0,4)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "Spot the Difference"
MiniTitle.TextColor3 = Color3.fromRGB(0,220,90)
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 14
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.ZIndex = 62
MiniTitle.Parent = MiniTop

local LevelLbl = Instance.new("TextLabel")
LevelLbl.Size = UDim2.new(1,-170,0,14)
LevelLbl.Position = UDim2.new(0,12,0,26)
LevelLbl.BackgroundTransparency = 1
LevelLbl.Text = "Level 1 / 25"
LevelLbl.TextColor3 = Color3.fromRGB(170,170,170)
LevelLbl.Font = Enum.Font.Gotham
LevelLbl.TextSize = 11
LevelLbl.TextXAlignment = Enum.TextXAlignment.Left
LevelLbl.ZIndex = 62
LevelLbl.Parent = MiniTop

local FoundBox = Instance.new("Frame")
FoundBox.Size = UDim2.new(0,90,0,32)
FoundBox.Position = UDim2.new(1,-164,0.5,-16)
FoundBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
FoundBox.ZIndex = 62
FoundBox.Parent = MiniTop
Instance.new("UICorner", FoundBox).CornerRadius = UDim.new(0,8)

local FoundLbl = Instance.new("TextLabel")
FoundLbl.Size = UDim2.new(1,-4,1,0)
FoundLbl.Position = UDim2.new(0,2,0,0)
FoundLbl.BackgroundTransparency = 1
FoundLbl.Text = "Found 0 / 2"
FoundLbl.TextColor3 = Color3.fromRGB(0,220,90)
FoundLbl.Font = Enum.Font.GothamBold
FoundLbl.TextSize = 12
FoundLbl.ZIndex = 63
FoundLbl.Parent = FoundBox

local ExitMini = Instance.new("TextButton")
ExitMini.Size = UDim2.new(0,58,0,28)
ExitMini.Position = UDim2.new(1,-70,0.5,-14)
ExitMini.BackgroundColor3 = Color3.fromRGB(200,55,55)
ExitMini.Text = "Exit"
ExitMini.TextColor3 = Color3.fromRGB(255,255,255)
ExitMini.Font = Enum.Font.GothamMedium
ExitMini.TextSize = 12
ExitMini.ZIndex = 62
ExitMini.Parent = MiniTop
Instance.new("UICorner", ExitMini).CornerRadius = UDim.new(0,8)

local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0.48,-8,1,-90)
LeftPanel.Position = UDim2.new(0,10,0,56)
LeftPanel.BackgroundColor3 = Color3.fromRGB(28,28,28)
LeftPanel.ClipsDescendants = true
LeftPanel.ZIndex = 61
LeftPanel.Parent = Mini
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0,10)

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0.48,-8,1,-90)
RightPanel.Position = UDim2.new(0.52,0,0,56)
RightPanel.BackgroundColor3 = Color3.fromRGB(28,28,28)
RightPanel.ClipsDescendants = true
RightPanel.ZIndex = 61
RightPanel.Parent = Mini
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0,10)

local LeftTag = Instance.new("TextLabel")
LeftTag.Size = UDim2.new(1,0,0,16)
LeftTag.BackgroundTransparency = 1
LeftTag.Text = "A"
LeftTag.TextColor3 = Color3.fromRGB(170,170,170)
LeftTag.Font = Enum.Font.GothamBold
LeftTag.TextSize = 11
LeftTag.ZIndex = 62
LeftTag.Parent = LeftPanel

local RightTag = Instance.new("TextLabel")
RightTag.Size = UDim2.new(1,0,0,16)
RightTag.BackgroundTransparency = 1
RightTag.Text = "B"
RightTag.TextColor3 = Color3.fromRGB(170,170,170)
RightTag.Font = Enum.Font.GothamBold
RightTag.TextSize = 11
RightTag.ZIndex = 62
RightTag.Parent = RightPanel

local HintLbl = Instance.new("TextLabel")
HintLbl.Size = UDim2.new(1,-20,0,18)
HintLbl.Position = UDim2.new(0,10,1,-24)
HintLbl.BackgroundTransparency = 1
HintLbl.Text = "Tap the difference on panel B"
HintLbl.TextColor3 = Color3.fromRGB(170,170,170)
HintLbl.Font = Enum.Font.Gotham
HintLbl.TextSize = 11
HintLbl.ZIndex = 62
HintLbl.Parent = Mini

local LevelDone = Instance.new("Frame")
LevelDone.AnchorPoint = Vector2.new(0.5, 0.5)
LevelDone.Position = UDim2.new(0.5, 0, 0.5, 0)
LevelDone.Size = UDim2.new(0, 240, 0, 140)
LevelDone.BackgroundColor3 = Color3.fromRGB(12,12,12)
LevelDone.Visible = false
LevelDone.ZIndex = 70
LevelDone.Parent = Mini
Instance.new("UICorner", LevelDone).CornerRadius = UDim.new(0,14)
local ldStroke = Instance.new("UIStroke", LevelDone)
ldStroke.Color = Color3.fromRGB(0,220,90)
ldStroke.Thickness = 2
local ldTitle = Instance.new("TextLabel")
ldTitle.Size = UDim2.new(1,0,0,28)
ldTitle.Position = UDim2.new(0,0,0,14)
ldTitle.BackgroundTransparency = 1
ldTitle.Text = "Level Complete!"
ldTitle.TextColor3 = Color3.fromRGB(0,220,90)
ldTitle.Font = Enum.Font.GothamBold
ldTitle.TextSize = 16
ldTitle.ZIndex = 71
ldTitle.Parent = LevelDone
local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(1,-36,0,36)
NextBtn.Position = UDim2.new(0,18,0,52)
NextBtn.BackgroundColor3 = Color3.fromRGB(0,170,70)
NextBtn.Text = "Next Level"
NextBtn.TextColor3 = Color3.fromRGB(255,255,255)
NextBtn.Font = Enum.Font.GothamBold
NextBtn.TextSize = 14
NextBtn.ZIndex = 71
NextBtn.Parent = LevelDone
Instance.new("UICorner", NextBtn).CornerRadius = UDim.new(0,10)
local ReplayBtn = Instance.new("TextButton")
ReplayBtn.Size = UDim2.new(1,-36,0,32)
ReplayBtn.Position = UDim2.new(0,18,0,96)
ReplayBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
ReplayBtn.Text = "Replay"
ReplayBtn.TextColor3 = Color3.fromRGB(170,170,170)
ReplayBtn.Font = Enum.Font.Gotham
ReplayBtn.TextSize = 13
ReplayBtn.ZIndex = 71
ReplayBtn.Parent = LevelDone
Instance.new("UICorner", ReplayBtn).CornerRadius = UDim.new(0,10)

local stdActive, currentLevel, foundCount, neededDiffs = false, 1, 0, 2
local diffButtons, baseShapesData = {}, {}

local function updateFoundLabel()
	FoundLbl.Text = string.format("Found %d / %d", foundCount, neededDiffs)
	FoundLbl.TextColor3 = foundCount >= neededDiffs and Color3.fromRGB(255,220,80) or Color3.fromRGB(0,220,90)
end

local function clearDiffs()
	for _,b in ipairs(diffButtons) do if b then b:Destroy() end end
	diffButtons = {}
	for _,c in ipairs(LeftPanel:GetChildren()) do
		if (c:IsA("TextLabel") and c ~= LeftTag) or c:IsA("TextButton") then c:Destroy() end
	end
	for _,c in ipairs(RightPanel:GetChildren()) do
		if (c:IsA("TextLabel") and c ~= RightTag) or c:IsA("TextButton") then c:Destroy() end
	end
end

local function placeShape(parent, shape, color, xScale, yScale, size)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0, size, 0, size)
	l.Position = UDim2.new(xScale, -size/2, yScale, -size/2)
	l.BackgroundTransparency = 1
	l.Text = shape
	l.TextColor3 = color
	l.TextSize = size * 0.85
	l.Font = Enum.Font.GothamBold
	l.ZIndex = 62
	l.Parent = parent
	return l
end

local function showWrongX(relX, relY)
	local xMark = Instance.new("TextLabel")
	xMark.Size = UDim2.new(0, 36, 0, 36)
	xMark.Position = UDim2.new(0, relX - 18, 0, relY - 18)
	xMark.BackgroundTransparency = 1
	xMark.Text = "X"
	xMark.TextColor3 = Color3.fromRGB(255, 60, 60)
	xMark.Font = Enum.Font.GothamBold
	xMark.TextSize = 28
	xMark.ZIndex = 65
	xMark.Parent = RightPanel
	task.delay(0.6, function() if xMark then xMark:Destroy() end end)
end

local function endSTD(success)
	stdActive = false
	clearDiffs()
	LevelDone.Visible = false
	freezePlayer(false)
	Mini.Visible = false
	if success then
		playWin()
		earnedKey = genKey()
		saveKeyData(earnedKey, os.time() + KEY_DURATION)
		RewKey.Text = earnedKey
		KeyPage.Visible = false
		RewardPage.Visible = true
		Auth.Visible = true
	else
		Auth.Visible = true
		KeyPage.Visible = true
	end
end

local function spawnDiffsOnly()
	for _,b in ipairs(diffButtons) do if b then b:Destroy() end end
	diffButtons = {}
	for _,c in ipairs(RightPanel:GetChildren()) do
		if (c:IsA("TextLabel") and c ~= RightTag) or c:IsA("TextButton") then c:Destroy() end
	end
	for _,s in ipairs(baseShapesData) do
		placeShape(RightPanel, s.shape, s.color, s.x, s.y, s.size)
	end
	local sizeMin = math.max(12, 26 - math.floor(currentLevel/2))
	local sizeMax = math.max(16, 32 - math.floor(currentLevel/3))
	for d = 1, neededDiffs do
		local sx = 0.12 + math.random()*0.76
		local sy = 0.18 + math.random()*0.70
		local sz = math.random(sizeMin, sizeMax)
		local sh = SHAPES[math.random(1,#SHAPES)]
		local col = COLORS[math.random(1,#COLORS)]
		placeShape(RightPanel, sh, col, sx, sy, sz)
		local hit = Instance.new("TextButton")
		hit.Size = UDim2.new(0, math.max(sz+8, 18), 0, math.max(sz+8, 18))
		hit.Position = UDim2.new(sx, -hit.Size.X.Offset/2, sy, -hit.Size.Y.Offset/2)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = 63
		hit.Parent = RightPanel
		table.insert(diffButtons, hit)
		hit.MouseButton1Click:Connect(function()
			if not stdActive or not hit.Parent or not hit.Active then return end
			foundCount = foundCount + 1
			updateFoundLabel()
			playFind()
			local mark = Instance.new("Frame")
			mark.Size = UDim2.new(1,0,1,0)
			mark.BackgroundColor3 = Color3.fromRGB(0,220,90)
			mark.BackgroundTransparency = 0.5
			mark.ZIndex = 64
			mark.Parent = hit
			Instance.new("UICorner", mark).CornerRadius = UDim.new(1,0)
			hit.Active = false
			if foundCount >= neededDiffs then
				playLevelUp()
				LevelDone.Visible = true
			end
		end)
	end
end

local function loadLevel(level)
	clearDiffs()
	LevelDone.Visible = false
	currentLevel = level
	foundCount = 0
	local baseShapes = math.min(6 + math.floor((level-1)*0.8), 18)
	neededDiffs = math.min(2 + math.floor((level-1)/3), 7)
	local sizeMin = math.max(12, 26 - math.floor(level/2))
	local sizeMax = math.max(16, 32 - math.floor(level/3))
	LevelLbl.Text = string.format("Level %d / %d", level, TOTAL_LEVELS)
	updateFoundLabel()
	baseShapesData = {}
	for i = 1, baseShapes do
		baseShapesData[i] = {
			shape = SHAPES[math.random(1,#SHAPES)],
			color = COLORS[math.random(1,#COLORS)],
			x = 0.10 + math.random()*0.80,
			y = 0.16 + math.random()*0.72,
			size = math.random(sizeMin, sizeMax),
		}
	end
	for _,s in ipairs(baseShapesData) do
		placeShape(LeftPanel, s.shape, s.color, s.x, s.y, s.size)
		placeShape(RightPanel, s.shape, s.color, s.x, s.y, s.size)
	end
	spawnDiffsOnly()
end

RightPanel.InputBegan:Connect(function(input)
	if not stdActive or LevelDone.Visible then return end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
	task.defer(function()
		local abs = RightPanel.AbsolutePosition
		local pos = input.Position
		local relX = pos.X - abs.X
		local relY = pos.Y - abs.Y
		local overDiff = false
		for _,hit in ipairs(diffButtons) do
			if hit and hit.Parent and hit.Active then
				local hp, hs = hit.AbsolutePosition, hit.AbsoluteSize
				if pos.X >= hp.X and pos.X <= hp.X+hs.X and pos.Y >= hp.Y and pos.Y <= hp.Y+hs.Y then
					overDiff = true
					break
				end
			end
		end
		if not overDiff then
			showWrongX(relX, relY)
			playWrong()
			foundCount = 0
			updateFoundLabel()
			spawnDiffsOnly()
		end
	end)
end)

NextBtn.MouseButton1Click:Connect(function()
	playClick()
	LevelDone.Visible = false
	if currentLevel >= TOTAL_LEVELS then
		endSTD(true)
	else
		loadLevel(currentLevel + 1)
	end
end)
ReplayBtn.MouseButton1Click:Connect(function()
	playClick()
	LevelDone.Visible = false
	loadLevel(currentLevel)
end)

local function startSTD()
	playClick()
	Auth.Visible = false
	Mini.Visible = true
	stdActive = true
	freezePlayer(true)
	loadLevel(1)
end

ExitMini.MouseButton1Click:Connect(function() playClick() endSTD(false) end)
GetKeyBtn.MouseButton1Click:Connect(function() startSTD() end)

local function unlockHub()
	getgenv().plus1_unlocked = true
	Auth.Visible = false
	Mini.Visible = false
	Main.Visible = true
	playUnlock()
end

SubmitBtn.MouseButton1Click:Connect(function()
	playClick()
	local entered = KeyBox.Text:gsub("%s+","")
	if entered == "" then
		StatusLbl.Text = "Please enter a key"
		StatusLbl.TextColor3 = Color3.fromRGB(255,140,100)
		return
	end
	if entered == MASTER_KEY then
		saveKeyData(MASTER_KEY, os.time()+KEY_DURATION)
		StatusLbl.Text = "Welcome! Special key accepted"
		StatusLbl.TextColor3 = Color3.fromRGB(0,220,90)
		task.wait(0.3)
		unlockHub()
		return
	end
	local saved, expire = loadKeyData()
	if saved and entered == saved and expire and os.time() <= expire then
		StatusLbl.Text = "Key accepted"
		StatusLbl.TextColor3 = Color3.fromRGB(0,220,90)
		task.wait(0.3)
		unlockHub()
		return
	end
	StatusLbl.Text = "Invalid or expired key"
	StatusLbl.TextColor3 = Color3.fromRGB(255,100,100)
	playWrong()
end)

task.spawn(function()
	if isUnlocked() then
		Auth.Visible = false
		Main.Visible = true
		return
	end
	local steps = {"Connecting...","Loading modules...","Checking environment...","Preparing UI...","Almost ready..."}
	for i=1,100 do
		BarFill.Size = UDim2.new(i/100,0,1,0)
		LoadPct.Text = i.."%"
		if i%20==0 then LoadSub.Text = steps[math.clamp(math.floor(i/20),1,#steps)] end
		task.wait(0.02)
	end
	LoadSub.Text = "Ready"
	playClick()
	task.wait(0.25)
	LoadPage.Visible = false
	KeyPage.Visible = true
end)
