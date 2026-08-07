-- +1 Games Script Hub (New Purple GUI)
-- Games + Game List features kept | WalkSpeed on Home | Owners page

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end
local playerGui = player:WaitForChild("PlayerGui")

local ENV = _G
pcall(function()
	if getgenv then
		local g = getgenv()
		if type(g) == "table" then ENV = g end
	end
end)

-- Cleanup
pcall(function()
	for _, name in ipairs({"+1Scripts", "plus1ScriptsGui"}) do
		local a = playerGui:FindFirstChild(name)
		if a then a:Destroy() end
		pcall(function()
			local c = game:GetService("CoreGui"):FindFirstChild(name)
			if c then c:Destroy() end
		end)
		pcall(function()
			if gethui then
				local h = gethui():FindFirstChild(name)
				if h then h:Destroy() end
			end
		end)
	end
end)

local function playSfx(id, vol)
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = id
		s.Volume = vol or 0.4
		s.Parent = SoundService
		s:Play()
		game:GetService("Debris"):AddItem(s, 3)
	end)
end
local function playClick() playSfx("rbxassetid://6895079853", 0.35) end

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "plus1ScriptsGui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
pcall(function()
	if gethui then ScreenGui.Parent = gethui()
	else ScreenGui.Parent = game:GetService("CoreGui") end
end)
if not ScreenGui.Parent then ScreenGui.Parent = playerGui end

-- Open button
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "Openbutton"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 16, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(78, 74, 145)
OpenBtn.Image = "rbxthumb://type=Asset&id=73957617656173&w=420&h=420"
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 20)
local os1 = Instance.new("UIStroke", OpenBtn)
os1.Color = Color3.fromRGB(74, 59, 104)
os1.Thickness = 2

-- Main frame
local Main = Instance.new("Frame")
Main.Name = "Mainplus1ScriptFrame"
Main.Size = UDim2.new(0, 311, 0, 190)
Main.Position = UDim2.new(0.5, -155, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleName"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 160, 1, 0)
Title.Position = UDim2.new(0, 6, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "+1GamesScript"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local HideBtn = Instance.new("TextButton")
HideBtn.Name = "HideButton"
HideBtn.Size = UDim2.new(0, 55, 1, 0)
HideBtn.Position = UDim2.new(1, -58, 0, 0)
HideBtn.BackgroundTransparency = 1
HideBtn.Text = "Hide UI"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 11
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Parent = TitleBar

-- Left nav
local Nav = Instance.new("Frame")
Nav.Name = "ButtonsFrame"
Nav.Size = UDim2.new(0, 85, 0, 148)
Nav.Position = UDim2.new(0, 5, 0, 36)
Nav.BackgroundColor3 = Color3.fromRGB(79, 74, 164)
Nav.BorderSizePixel = 0
Nav.Parent = Main
Instance.new("UICorner", Nav).CornerRadius = UDim.new(0, 8)
local navStroke = Instance.new("UIStroke", Nav)
navStroke.Color = Color3.fromRGB(87, 92, 154)
navStroke.Thickness = 2

-- Content area
local Content = Instance.new("Frame")
Content.Name = "ButtonsFrame2"
Content.Size = UDim2.new(0, 206, 0, 148)
Content.Position = UDim2.new(0, 98, 0, 36)
Content.BackgroundColor3 = Color3.fromRGB(79, 74, 164)
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)
local contentStroke = Instance.new("UIStroke", Content)
contentStroke.Color = Color3.fromRGB(87, 92, 154)
contentStroke.Thickness = 2

-- Nav items
local NAV_ITEMS = {
	{Name = "Home", Icon = "rbxthumb://type=Asset&id=133664183496663&w=420&h=420", Y = 5},
	{Name = "Game", Icon = "rbxthumb://type=Asset&id=81689537841279&w=420&h=420", Y = 25},
	{Name = "Game List", Icon = "rbxthumb://type=Asset&id=94982886788563&w=420&h=420", Y = 45},
	{Name = "Settings", Icon = "rbxthumb://type=Asset&id=129581117627874&w=420&h=420", Y = 65},
	{Name = "Request", Icon = "rbxthumb://type=Asset&id=117881087490999&w=420&h=420", Y = 85},
	{Name = "View", Icon = "rbxthumb://type=Asset&id=131537678100350&w=420&h=420", Y = 105},
	{Name = "Owner", Icon = "rbxthumb://type=Asset&id=127421988740220&w=420&h=420", Y = 125},
}

local navButtons = {}
for _, item in ipairs(NAV_ITEMS) do
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 15, 0, 15)
	icon.Position = UDim2.new(0, 5, 0, item.Y)
	icon.BackgroundTransparency = 1
	icon.Image = item.Icon
	icon.Parent = Nav

	local btn = Instance.new("TextButton")
	btn.Name = item.Name .. "Btn"
	btn.Size = UDim2.new(0, 58, 0, 18)
	btn.Position = UDim2.new(0, 22, 0, item.Y - 2)
	btn.BackgroundTransparency = 1
	btn.Text = item.Name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = Nav
	navButtons[item.Name] = btn
end

-- Pages
local pages = {}
local function makePage(name)
	local p = Instance.new("ScrollingFrame")
	p.Name = name .. "Page"
	p.Size = UDim2.new(1, -8, 1, -8)
	p.Position = UDim2.new(0, 4, 0, 4)
	p.BackgroundTransparency = 1
	p.BorderSizePixel = 0
	p.ScrollBarThickness = 3
	p.ScrollBarImageColor3 = Color3.fromRGB(180, 170, 255)
	p.CanvasSize = UDim2.new(0, 0, 0, 0)
	p.Visible = false
	p.Parent = Content
	pages[name] = p
	return p
end

local HomePage = makePage("Home")
local GamePage = makePage("Game")
local GameListPage = makePage("Game List")
local SettingsPage = makePage("Settings")
local RequestPage = makePage("Request")
local ViewPage = makePage("View")
local OwnerPage = makePage("Owner")

local function switchPage(name)
	playClick()
	for n, p in pairs(pages) do
		p.Visible = (n == name)
	end
	for n, b in pairs(navButtons) do
		b.TextColor3 = (n == name) and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(255, 255, 255)
	end
end

for name, btn in pairs(navButtons) do
	btn.MouseButton1Click:Connect(function()
		switchPage(name)
	end)
end

-- Drag
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
makeDraggable(Main, Main) -- whole main UI draggable
makeDraggable(OpenBtn, OpenBtn)

HideBtn.MouseButton1Click:Connect(function()
	playClick()
	Main.Visible = false
	OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
	playClick()
	Main.Visible = true
	OpenBtn.Visible = false
end)

-- ========== UI HELPERS ==========
local function createSection(parent, text, y)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -4, 0, 18)
	l.Position = UDim2.new(0, 2, 0, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.fromRGB(200, 190, 255)
	l.Font = Enum.Font.GothamBold
	l.TextSize = 11
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

local function createToggle(parent, name, y, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -4, 0, 28)
	frame.Position = UDim2.new(0, 2, 0, y)
	frame.BackgroundColor3 = Color3.fromRGB(60, 55, 120)
	frame.Parent = parent
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -48, 1, 0)
	label.Position = UDim2.new(0, 6, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = frame

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 34, 0, 18)
	toggle.Position = UDim2.new(1, -40, 0.5, -9)
	toggle.BackgroundColor3 = Color3.fromRGB(50, 45, 90)
	toggle.Text = ""
	toggle.AutoButtonColor = false
	toggle.Parent = frame
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 14, 0, 14)
	circle.Position = UDim2.new(0, 2, 0.5, -7)
	circle.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
	circle.Parent = toggle
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local enabled = false
	toggle.MouseButton1Click:Connect(function()
		enabled = not enabled
		playClick()
		if enabled then
			toggle.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
			circle.Position = UDim2.new(1, -16, 0.5, -7)
			circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(50, 45, 90)
			circle.Position = UDim2.new(0, 2, 0.5, -7)
			circle.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
		end
		callback(enabled)
	end)
	return frame
end

local function createButton(parent, name, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -4, 0, 28)
	btn.Position = UDim2.new(0, 2, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(90, 80, 180)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	end)
	btn.MouseButton1Click:Connect(function()
		playClick()
		callback()
	end)
	return btn
end

local function clearChildren(parent)
	for _, c in ipairs(parent:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
end

-- ========== HOME — WalkSpeed ==========
do
	createSection(HomePage, "Movement", 0)
	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(1, -4, 0, 18)
	speedLabel.Position = UDim2.new(0, 2, 0, 22)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "WalkSpeed: 16"
	speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedLabel.Font = Enum.Font.Gotham
	speedLabel.TextSize = 12
	speedLabel.TextXAlignment = Enum.TextXAlignment.Left
	speedLabel.Parent = HomePage

	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(1, -4, 0, 26)
	speedBox.Position = UDim2.new(0, 2, 0, 44)
	speedBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	speedBox.Text = "16"
	speedBox.PlaceholderText = "Speed"
	speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedBox.Font = Enum.Font.Gotham
	speedBox.TextSize = 12
	speedBox.ClearTextOnFocus = false
	speedBox.Parent = HomePage
	Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

	local applyOn = false
	local currentSpeed = 16

	createToggle(HomePage, "Apply WalkSpeed", 76, function(v)
		applyOn = v
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not v then
			if hum then hum.WalkSpeed = 16 end
		else
			if hum then hum.WalkSpeed = currentSpeed end
		end
	end)

	speedBox.FocusLost:Connect(function()
		local n = tonumber(speedBox.Text)
		if n and n > 0 then
			currentSpeed = n
			speedLabel.Text = "WalkSpeed: " .. tostring(n)
			if applyOn then
				local char = player.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then hum.WalkSpeed = n end
			end
		end
	end)

	player.CharacterAdded:Connect(function(char)
		task.wait(0.3)
		if applyOn then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = currentSpeed end
		end
	end)

	-- Discord + copy IDs
	createSection(HomePage, "Discord / IDs", 118)

	local function copyText(text)
		local ok = false
		pcall(function()
			if setclipboard then setclipboard(text) ok = true
			elseif toclipboard then toclipboard(text) ok = true end
		end)
		return ok
	end

	local function makeCopyRow(parent, y, labelText, copyValue)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -4, 0, 28)
		row.Position = UDim2.new(0, 2, 0, y)
		row.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -36, 1, 0)
		lbl.Position = UDim2.new(0, 6, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = labelText
		lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 10
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextTruncate = Enum.TextTruncate.AtEnd
		lbl.Parent = row

		local copyBtn = Instance.new("TextButton")
		copyBtn.Size = UDim2.new(0, 28, 0, 22)
		copyBtn.Position = UDim2.new(1, -30, 0.5, -11)
		copyBtn.BackgroundColor3 = Color3.fromRGB(70, 65, 140)
		copyBtn.Text = "📋"
		copyBtn.TextSize = 12
		copyBtn.Font = Enum.Font.GothamBold
		copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		copyBtn.AutoButtonColor = false
		copyBtn.Parent = row
		Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 5)

		copyBtn.MouseButton1Click:Connect(function()
			playClick()
			if copyText(copyValue) then
				copyBtn.Text = "✓"
				copyBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 90)
				copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				task.delay(1.5, function()
					if copyBtn and copyBtn.Parent then
						copyBtn.Text = "📋"
						copyBtn.BackgroundColor3 = Color3.fromRGB(70, 65, 140)
					end
				end)
			else
				copyBtn.Text = "!"
				task.delay(1, function()
					if copyBtn and copyBtn.Parent then copyBtn.Text = "📋" end
				end)
			end
		end)
		return row
	end

	-- Discord invite
	makeCopyRow(HomePage, 140, "Discord Invite", "https://discord.gg/DvhPapJNm")
	-- IDs
	makeCopyRow(HomePage, 172, "83343449436920", "83343449436920")
	makeCopyRow(HomePage, 204, "100254529812443", "100254529812443")

	HomePage.CanvasSize = UDim2.new(0, 0, 0, 250)
end

-- ========== GAME FEATURES ==========
local FeaturesFrame = GamePage -- features go directly in Game page

local function clearFeatures()
	clearChildren(FeaturesFrame)
end

local function createSectionF(text, y)
	return createSection(FeaturesFrame, text, y)
end
local function createToggleF(name, y, cb)
	return createToggle(FeaturesFrame, name, y, cb)
end
local function createButtonF(name, y, cb)
	return createButton(FeaturesFrame, name, y, cb)
end

-- GAME 1 (75626443136851) Bottle Flip
local function buildGame1Features()
	clearFeatures()
	createSectionF("World 1", 0)
	createToggleF("Auto Farm Wins", 22, function(v)
		ENV.farm1 = v
		while ENV.farm1 do
			task.wait()
			pcall(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
				end
			end)
		end
	end)
	createButtonF("TP To World 2", 54, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 50)
		end
	end)
	createSectionF("World 2", 90)
	createToggleF("Auto Farm Wins", 112, function(v)
		ENV.farm2 = v
		while ENV.farm2 do
			task.wait()
			pcall(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 50)
				end
			end)
		end
	end)
	createButtonF("TP To World 1", 144, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
		end
	end)
	createSectionF("Rebirth", 180)
	createToggleF("Auto Rebirth", 202, function(v)
		ENV.g1_rebirth = v
		while ENV.g1_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").BottleRebirthEvent:FireServer("TryRebirth")
			end)
		end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
end

-- GAME 2 (108775830475023) Moon Walk
local function buildGame2Features()
	clearFeatures()
	createSectionF("Worlds", 0)
	createToggleF("Auto Farm W1", 22, function(v)
		ENV.g2_f1 = v
		while ENV.g2_f1 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
				end
			end)
		end
	end)
	createToggleF("Auto Farm W2", 54, function(v)
		ENV.g2_f2 = v
		while ENV.g2_f2 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(50, 5, 0)
				end
			end)
		end
	end)
	createToggleF("Auto Farm W3", 86, function(v)
		ENV.g2_f3 = v
		while ENV.g2_f3 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(100, 5, 0)
				end
			end)
		end
	end)
	createSectionF("Teleport", 120)
	createButtonF("World 1", 142, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0) end
	end)
	createButtonF("World 2", 174, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(50, 5, 0) end
	end)
	createButtonF("World 3", 206, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(100, 5, 0) end
	end)
	createSectionF("Shop / Rebirth", 242)
	createToggleF("Auto Rebirth", 264, function(v)
		ENV.g2_rebirth = v
		while ENV.g2_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Events.Rebirth.Rebirth:FireServer()
			end)
		end
	end)
	createButtonF("Buy (NorthStar) 1m", 296, function()
		pcall(function()
			game:GetService("ReplicatedStorage").Events.Aura.Buy:FireServer("NorthStar")
		end)
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 340)
end

-- GAME 3 (84757653274750)
local function buildGame3Features()
	clearFeatures()
	createSectionF("Farm", 0)
	createToggleF("Auto Farm Wins", 22, function(v)
		ENV.g3_farm = v
		while ENV.g3_farm do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
				end
			end)
		end
	end)
	createToggleF("Auto Swing", 54, function(v)
		ENV.g3_swing = v
		while ENV.g3_swing do task.wait(0.2) end
	end)
	createToggleF("Auto Rebirth", 86, function(v)
		ENV.g3_rebirth = v
		while ENV.g3_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Events.Rebirth:FireServer()
			end)
		end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 130)
end

-- GAME 4 (78579721506911)
local function buildGame4Features()
	clearFeatures()
	createSectionF("World 1", 0)
	createToggleF("Auto Farm", 22, function(v)
		ENV.g4_f1 = v
		while ENV.g4_f1 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(887.62, 3234.99, 108.66)
				end
			end)
		end
	end)
	createSectionF("World 2", 56)
	createToggleF("Auto Farm", 78, function(v)
		ENV.g4_f2 = v
		while ENV.g4_f2 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(1198.14, 4714.88, 1764.46)
				end
			end)
		end
	end)
	createSectionF("Rebirth", 114)
	createToggleF("Auto Rebirth", 136, function(v)
		ENV.g4_rebirth = v
		while ENV.g4_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Events.Rebirth:FireServer()
			end)
		end
	end)
	createSectionF("Teleport", 172)
	createButtonF("TP To World 1", 194, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then
			c.HumanoidRootPart.CFrame = CFrame.new(-761, 5, 106)
		end
	end)
	createButtonF("TP To World 2", 226, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then
			c.HumanoidRootPart.CFrame = CFrame.new(-805, 222, 1767)
		end
	end)
	-- Trails
	createSectionF("Trails", 262)
	local trailOpts = {"Purple Trail", "Green Trail", "Blue Trail", "Yellow Trail", "Fire Trail"}
	local selected = trailOpts[1]
	local drop = Instance.new("TextButton")
	drop.Size = UDim2.new(1, -4, 0, 26)
	drop.Position = UDim2.new(0, 2, 0, 284)
	drop.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	drop.Text = "▼  " .. selected
	drop.TextColor3 = Color3.fromRGB(255, 255, 255)
	drop.Font = Enum.Font.Gotham
	drop.TextSize = 11
	drop.Parent = FeaturesFrame
	Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)
	local open = false
	local listF = Instance.new("Frame")
	listF.Size = UDim2.new(1, -4, 0, #trailOpts * 24)
	listF.Position = UDim2.new(0, 2, 0, 312)
	listF.BackgroundColor3 = Color3.fromRGB(45, 40, 95)
	listF.Visible = false
	listF.ZIndex = 10
	listF.Parent = FeaturesFrame
	Instance.new("UICorner", listF).CornerRadius = UDim.new(0, 6)
	Instance.new("UIListLayout", listF)
	local buyBtn = createButtonF("Buy and Equip", 318, function()
		pcall(function()
			game:GetService("ReplicatedStorage").Events.BuyTrail:FireServer(selected)
		end)
		task.wait(0.15)
		pcall(function()
			game:GetService("ReplicatedStorage").Events.EquipTrail:FireServer(selected)
		end)
	end)
	for _, opt in ipairs(trailOpts) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 24)
		b.BackgroundTransparency = 0.3
		b.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		b.Text = opt
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.Font = Enum.Font.Gotham
		b.TextSize = 11
		b.ZIndex = 11
		b.Parent = listF
		b.MouseButton1Click:Connect(function()
			playClick()
			selected = opt
			drop.Text = "▼  " .. opt
			listF.Visible = false
			open = false
			buyBtn.Position = UDim2.new(0, 2, 0, 318)
		end)
	end
	drop.MouseButton1Click:Connect(function()
		playClick()
		open = not open
		listF.Visible = open
		buyBtn.Position = UDim2.new(0, 2, 0, open and (318 + #trailOpts * 24) or 318)
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 420)
end

-- GAME 5 (82554996468034)
local function buildGame5Features()
	clearFeatures()
	createSectionF("World 1", 0)
	createToggleF("Auto Farm Wins (World1)", 22, function(v)
		ENV.g5_f1 = v
		while ENV.g5_f1 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(1207.54, 5.5, 162.35)
				end
			end)
		end
	end)
	createSectionF("World 2", 56)
	createToggleF("Auto Farm Wins (World2)", 78, function(v)
		ENV.g5_f2 = v
		while ENV.g5_f2 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(1471.89, 5.47, 489.51)
				end
			end)
		end
	end)
	createSectionF("World 3", 112)
	createToggleF("Auto Farm Wins (World3)", 134, function(v)
		ENV.g5_f3 = v
		while ENV.g5_f3 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(1769.2, 5.47, 847.51)
				end
			end)
		end
	end)
	createSectionF("Rebirth / Spin", 170)
	createToggleF("Auto Rebirth", 192, function(v)
		ENV.g5_rebirth = v
		while ENV.g5_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.ConfirmAura:FireServer()
			end)
		end
	end)
	createToggleF("Auto Spin", 224, function(v)
		ENV.g5_spin = v
		while ENV.g5_spin do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.SpinAura:InvokeServer(false)
			end)
		end
	end)
	createSectionF("Trails", 260)
	local trailOpts = {
		{L = "Orange Trail", V = "Orange"},
		{L = "Green Trail", V = "Green"},
		{L = "Blue Trail", V = "Blue"},
		{L = "Rainbow Trail", V = "Rainbow"},
		{L = "Lava Trail", V = "Lava"},
		{L = "Inferno Trail", V = "Inferno"},
	}
	local selected = trailOpts[1]
	local drop = Instance.new("TextButton")
	drop.Size = UDim2.new(1, -4, 0, 26)
	drop.Position = UDim2.new(0, 2, 0, 282)
	drop.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	drop.Text = "▼  " .. selected.L
	drop.TextColor3 = Color3.fromRGB(255, 255, 255)
	drop.Font = Enum.Font.Gotham
	drop.TextSize = 11
	drop.Parent = FeaturesFrame
	Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)
	local listF = Instance.new("Frame")
	listF.Size = UDim2.new(1, -4, 0, #trailOpts * 24)
	listF.Position = UDim2.new(0, 2, 0, 310)
	listF.BackgroundColor3 = Color3.fromRGB(45, 40, 95)
	listF.Visible = false
	listF.ZIndex = 10
	listF.Parent = FeaturesFrame
	Instance.new("UICorner", listF).CornerRadius = UDim.new(0, 6)
	Instance.new("UIListLayout", listF)
	local buyBtn = createButtonF("Buy and Equip", 316, function()
		pcall(function()
			game:GetService("ReplicatedStorage").Remotes.BuyTrail:InvokeServer(selected.V)
		end)
		task.wait(0.15)
		pcall(function()
			game:GetService("ReplicatedStorage").Remotes.EquipTrail:FireServer(selected.V)
		end)
	end)
	for _, opt in ipairs(trailOpts) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 24)
		b.BackgroundTransparency = 0.3
		b.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		b.Text = opt.L
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.Font = Enum.Font.Gotham
		b.TextSize = 11
		b.ZIndex = 11
		b.Parent = listF
		b.MouseButton1Click:Connect(function()
			playClick()
			selected = opt
			drop.Text = "▼  " .. opt.L
			listF.Visible = false
			buyBtn.Position = UDim2.new(0, 2, 0, 316)
		end)
	end
	drop.MouseButton1Click:Connect(function()
		playClick()
		listF.Visible = not listF.Visible
		buyBtn.Position = UDim2.new(0, 2, 0, listF.Visible and (316 + #trailOpts * 24) or 316)
	end)
	createSectionF("Teleport", 360)
	createButtonF("TP To World 1", 382, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then
			c.HumanoidRootPart.CFrame = CFrame.new(-5, 5, 177)
		end
	end)
	createButtonF("TP To World 2", 414, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then
			c.HumanoidRootPart.CFrame = CFrame.new(-5, 5, 510)
		end
	end)
	createButtonF("TP To World 3", 446, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then
			c.HumanoidRootPart.CFrame = CFrame.new(-5, 5, 868)
		end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
end

-- EASY GAMES
local EASY_GAMES = {
	-- add games here, example:
	-- {
	-- 	PlaceId = "00000000000000",
	-- 	Features = {
	-- 		{type="section", name="World 1"},
	-- 		{type="farm", name="Auto Farm", pos={0,10,0}},
	-- 		{type="tp", name="TP World 1", pos={-5,5,177}},
	-- 		{type="remote", name="Auto Rebirth", path="ReplicatedStorage.Remotes.X", method="FireServer", args={}, loop=true, wait=0.5},
	-- 	},
	-- },
}

local function resolvePath(path)
	local cur = game
	for part in string.gmatch(path, "[^%.]+") do
		if not cur then return nil end
		cur = cur:FindFirstChild(part)
	end
	return cur
end

local function buildEasyGameFeatures(cfg)
	return function()
		clearFeatures()
		local y, id = 0, 0
		for _, f in ipairs(cfg.Features or {}) do
			if f.type == "section" then
				createSectionF(f.name or "Section", y)
				y = y + 22
			elseif f.type == "farm" then
				id = id + 1
				local key = "easy_f_" .. tostring(cfg.PlaceId) .. "_" .. id
				local pos = f.pos or {0, 10, 0}
				createToggleF(f.name or "Auto Farm", y, function(v)
					ENV[key] = v
					while ENV[key] do task.wait()
						pcall(function()
							local c = player.Character
							if c and c:FindFirstChild("HumanoidRootPart") then
								c.HumanoidRootPart.CFrame = CFrame.new(pos[1], pos[2], pos[3])
							end
						end)
					end
				end)
				y = y + 32
			elseif f.type == "tp" then
				local pos = f.pos or {0, 10, 0}
				createButtonF(f.name or "Teleport", y, function()
					local c = player.Character
					if c and c:FindFirstChild("HumanoidRootPart") then
						c.HumanoidRootPart.CFrame = CFrame.new(pos[1], pos[2], pos[3])
					end
				end)
				y = y + 32
			elseif f.type == "remote" then
				local path, method = f.path or "", f.method or "FireServer"
				local args, loop, waitT = f.args or {}, f.loop, f.wait or 0.5
				if loop then
					id = id + 1
					local key = "easy_r_" .. tostring(cfg.PlaceId) .. "_" .. id
					createToggleF(f.name or "Auto Remote", y, function(v)
						ENV[key] = v
						while ENV[key] do
							task.wait(waitT)
							pcall(function()
								local rem = resolvePath(path)
								if rem then
									if method == "InvokeServer" then rem:InvokeServer(unpack(args))
									else rem:FireServer(unpack(args)) end
								end
							end)
						end
					end)
				else
					createButtonF(f.name or "Run Remote", y, function()
						pcall(function()
							local rem = resolvePath(path)
							if rem then
								if method == "InvokeServer" then rem:InvokeServer(unpack(args))
								else rem:FireServer(unpack(args)) end
							end
						end)
					end)
				end
				y = y + 32
			end
		end
		FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(y + 20, 80))
	end
end

local SupportedPlaceIds = {
	tonumber("75626443136851"),
	tonumber("108775830475023"),
	tonumber("84757653274750"),
	tonumber("78579721506911"),
	tonumber("82554996468034"),
}
for _, g in ipairs(EASY_GAMES) do
	local pid = tonumber(tostring(g.PlaceId))
	if pid then table.insert(SupportedPlaceIds, pid) end
end

local SUPPORTED = {
	[tonumber("75626443136851")] = buildGame1Features,
	[tonumber("108775830475023")] = buildGame2Features,
	[tonumber("84757653274750")] = buildGame3Features,
	[tonumber("78579721506911")] = buildGame4Features,
	[tonumber("82554996468034")] = buildGame5Features,
}
for _, g in ipairs(EASY_GAMES) do
	local pid = tonumber(tostring(g.PlaceId))
	if pid then SUPPORTED[pid] = buildEasyGameFeatures(g) end
end

-- Detect current game
local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Size = UDim2.new(1, -4, 0, 16)
gameNameLabel.Position = UDim2.new(0, 2, 0, 0)
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.Text = "Loading..."
gameNameLabel.TextColor3 = Color3.fromRGB(200, 190, 255)
gameNameLabel.Font = Enum.Font.GothamBold
gameNameLabel.TextSize = 10
gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
gameNameLabel.Parent = GamePage

pcall(function()
	local info = MarketplaceService:GetProductInfo(game.PlaceId)
	if info then gameNameLabel.Text = info.Name end
end)

local notAdded = Instance.new("TextLabel")
notAdded.Size = UDim2.new(1, -8, 0, 40)
notAdded.Position = UDim2.new(0, 4, 0, 40)
notAdded.BackgroundTransparency = 1
notAdded.Text = "This game is not supported yet.\nCheck Game List."
notAdded.TextColor3 = Color3.fromRGB(200, 180, 220)
notAdded.Font = Enum.Font.Gotham
notAdded.TextSize = 11
notAdded.TextWrapped = true
notAdded.Visible = false
notAdded.Parent = GamePage

if SUPPORTED[game.PlaceId] then
	notAdded.Visible = false
	-- shift features down a bit so name fits
	pcall(SUPPORTED[game.PlaceId])
else
	notAdded.Visible = true
end

-- ========== GAME LIST ==========
do
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -4, 0, 18)
	title.Position = UDim2.new(0, 2, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Games (tap to join)"
	title.TextColor3 = Color3.fromRGB(200, 190, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = GameListPage

	local y = 22
	for i, placeId in ipairs(SupportedPlaceIds) do
		local entry = Instance.new("TextButton")
		entry.Size = UDim2.new(1, -4, 0, 32)
		entry.Position = UDim2.new(0, 2, 0, y)
		entry.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		entry.Text = ""
		entry.AutoButtonColor = false
		entry.Parent = GameListPage
		Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 6)

		local nameL = Instance.new("TextLabel")
		nameL.Size = UDim2.new(1, -8, 1, 0)
		nameL.Position = UDim2.new(0, 6, 0, 0)
		nameL.BackgroundTransparency = 1
		nameL.Text = "Place " .. tostring(placeId)
		nameL.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameL.Font = Enum.Font.Gotham
		nameL.TextSize = 10
		nameL.TextXAlignment = Enum.TextXAlignment.Left
		nameL.TextTruncate = Enum.TextTruncate.AtEnd
		nameL.Parent = entry

		task.spawn(function()
			pcall(function()
				local info = MarketplaceService:GetProductInfo(placeId)
				if info and nameL and nameL.Parent then
					nameL.Text = info.Name
				end
			end)
		end)

		entry.MouseButton1Click:Connect(function()
			playClick()
			pcall(function()
				TeleportService:Teleport(placeId, player)
			end)
		end)
		y = y + 36
	end
	GameListPage.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- ========== SETTINGS ==========
do
	createSection(SettingsPage, "Settings", 0)
	local info = Instance.new("TextLabel")
	info.Size = UDim2.new(1, -4, 0, 40)
	info.Position = UDim2.new(0, 2, 0, 24)
	info.BackgroundTransparency = 1
	info.Text = "WalkSpeed is on the Home tab.\nMore settings coming soon."
	info.TextColor3 = Color3.fromRGB(220, 210, 255)
	info.Font = Enum.Font.Gotham
	info.TextSize = 11
	info.TextWrapped = true
	info.TextXAlignment = Enum.TextXAlignment.Left
	info.Parent = SettingsPage
	SettingsPage.CanvasSize = UDim2.new(0, 0, 0, 80)
end

-- ========== REQUEST ==========
do
	createSection(RequestPage, "Request a Game", 0)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -4, 0, 50)
	box.Position = UDim2.new(0, 2, 0, 24)
	box.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	box.Text = ""
	box.PlaceholderText = "Place ID or game name..."
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderColor3 = Color3.fromRGB(160, 150, 200)
	box.Font = Enum.Font.Gotham
	box.TextSize = 11
	box.TextWrapped = true
	box.ClearTextOnFocus = false
	box.Parent = RequestPage
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

	createButton(RequestPage, "Submit Request", 80, function()
		local msg = box.Text
		if msg and #msg > 0 then
			pcall(function()
				if writefile then
					local prev = ""
					if isfile and isfile("plus1_requests.txt") then
						prev = readfile("plus1_requests.txt")
					end
					writefile("plus1_requests.txt", prev .. player.Name .. "|" .. msg .. "\n")
				end
			end)
			box.Text = "Sent!"
			task.wait(1)
			box.Text = ""
		end
	end)
	RequestPage.CanvasSize = UDim2.new(0, 0, 0, 130)
end

-- ========== VIEW ==========
do
	createSection(ViewPage, "View Requests", 0)
	local empty = Instance.new("TextLabel")
	empty.Size = UDim2.new(1, -4, 0, 40)
	empty.Position = UDim2.new(0, 2, 0, 24)
	empty.BackgroundTransparency = 1
	empty.Text = "No requests yet."
	empty.TextColor3 = Color3.fromRGB(180, 170, 220)
	empty.Font = Enum.Font.Gotham
	empty.TextSize = 11
	empty.Parent = ViewPage
	pcall(function()
		if isfile and isfile("plus1_requests.txt") and readfile then
			local data = readfile("plus1_requests.txt")
			if data and #data > 0 then
				empty.Text = data
				empty.TextXAlignment = Enum.TextXAlignment.Left
				empty.TextYAlignment = Enum.TextYAlignment.Top
				empty.Size = UDim2.new(1, -4, 0, 100)
			end
		end
	end)
	ViewPage.CanvasSize = UDim2.new(0, 0, 0, 140)
end

-- ========== OWNER ==========
do
	createSection(OwnerPage, "Owners", 0)
	local owners = {"Eyfanboy09", "TheSledM"}
	local y = 24
	for _, userName in ipairs(owners) do
		local card = Instance.new("Frame")
		card.Size = UDim2.new(1, -4, 0, 48)
		card.Position = UDim2.new(0, 2, 0, y)
		card.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		card.Parent = OwnerPage
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 36, 0, 36)
		avatar.Position = UDim2.new(0, 6, 0.5, -18)
		avatar.BackgroundColor3 = Color3.fromRGB(40, 35, 80)
		avatar.Image = ""
		avatar.Parent = card
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

		local nameL = Instance.new("TextLabel")
		nameL.Size = UDim2.new(1, -50, 1, 0)
		nameL.Position = UDim2.new(0, 48, 0, 0)
		nameL.BackgroundTransparency = 1
		nameL.Text = userName
		nameL.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameL.Font = Enum.Font.GothamBold
		nameL.TextSize = 12
		nameL.TextXAlignment = Enum.TextXAlignment.Left
		nameL.Parent = card

		task.spawn(function()
			local uid
			pcall(function()
				uid = Players:GetUserIdFromNameAsync(userName)
			end)
			if uid then
				avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=150&h=150"
			end
		end)
		y = y + 54
	end
	OwnerPage.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- Start on Home
switchPage("Home")
print("[+1GamesScript] Loaded — purple GUI")
