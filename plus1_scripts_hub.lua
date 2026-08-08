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

-- Owners can open View; others see lock icon
local OWNERS = {Eyfanboy09 = true, TheSledM = true}
local IS_OWNER = OWNERS[player.Name] == true

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
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8) -- normal corner
local os1 = Instance.new("UIStroke", OpenBtn)
os1.Color = Color3.fromRGB(87, 92, 154) -- match content stroke
os1.Thickness = 2

-- Main frame
local Main = Instance.new("Frame")
Main.Name = "Mainplus1ScriptFrame"
Main.Size = UDim2.new(0, 311, 0, 190)
Main.Position = UDim2.new(0.5, -155, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
Main.BorderSizePixel = 0
Main.Visible = false -- locked until key
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
Title.Size = UDim2.new(1, -60, 1, 0)
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
local navIcons = {}
for _, item in ipairs(NAV_ITEMS) do
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 15, 0, 15)
	icon.Position = UDim2.new(0, 5, 0, item.Y)
	icon.BackgroundTransparency = 1
	icon.Image = item.Icon
	icon.Parent = Nav
	navIcons[item.Name] = icon

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

-- Lock View for non-owners
if not IS_OWNER then
	local viewIcon = navIcons["View"]
	if viewIcon then
		viewIcon.Image = "rbxthumb://type=Asset&id=113054079163682&w=420&h=420"
		viewIcon.ImageColor3 = Color3.fromRGB(255, 200, 80) -- gold lock color
	end
	if navButtons["View"] then
		navButtons["View"].TextColor3 = Color3.fromRGB(180, 160, 100)
		navButtons["View"].Text = "View"
	end
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
	-- block View for non-owners
	if name == "View" and not IS_OWNER then
		playClick()
		-- brief lock feedback
		local b = navButtons["View"]
		if b then
			local old = b.Text
			b.Text = "Locked"
			b.TextColor3 = Color3.fromRGB(255, 180, 60)
			task.delay(0.8, function()
				if b then
					b.Text = "View"
					b.TextColor3 = Color3.fromRGB(180, 160, 100)
				end
			end)
		end
		return
	end
	playClick()
	for n, p in pairs(pages) do
		p.Visible = (n == name)
	end
	for n, b in pairs(navButtons) do
		if n == "View" and not IS_OWNER then
			b.TextColor3 = Color3.fromRGB(180, 160, 100)
		else
			b.TextColor3 = (n == name) and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(255, 255, 255)
		end
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

-- ========== HOME — WalkSpeed + Discord ==========
do
	createSection(HomePage, "Movement", 0)
	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(1, -4, 0, 16)
	speedLabel.Position = UDim2.new(0, 2, 0, 20)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "WalkSpeed: 16"
	speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedLabel.Font = Enum.Font.Gotham
	speedLabel.TextSize = 11
	speedLabel.TextXAlignment = Enum.TextXAlignment.Left
	speedLabel.Parent = HomePage

	local applyOn = false
	local currentSpeed = 16
	local MIN_SPD, MAX_SPD = 1, 200

	-- Slider track
	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -4, 0, 10)
	track.Position = UDim2.new(0, 2, 0, 40)
	track.BackgroundColor3 = Color3.fromRGB(45, 40, 90)
	track.BorderSizePixel = 0
	track.Parent = HomePage
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((16 - MIN_SPD) / (MAX_SPD - MIN_SPD), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(130, 110, 220)
	fill.BorderSizePixel = 0
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new((16 - MIN_SPD) / (MAX_SPD - MIN_SPD), -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(220, 210, 255)
	knob.Text = ""
	knob.AutoButtonColor = false
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(1, -4, 0, 24)
	speedBox.Position = UDim2.new(0, 2, 0, 56)
	speedBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	speedBox.Text = "16"
	speedBox.PlaceholderText = "Speed"
	speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedBox.Font = Enum.Font.Gotham
	speedBox.TextSize = 11
	speedBox.ClearTextOnFocus = false
	speedBox.Parent = HomePage
	Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

	local function setSpeedUI(n)
		n = math.clamp(n, MIN_SPD, MAX_SPD)
		currentSpeed = n
		speedLabel.Text = "WalkSpeed: " .. tostring(math.floor(n))
		speedBox.Text = tostring(math.floor(n))
		local t = (n - MIN_SPD) / (MAX_SPD - MIN_SPD)
		fill.Size = UDim2.new(t, 0, 1, 0)
		knob.Position = UDim2.new(t, -7, 0.5, -7)
		if applyOn then
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = n end
		end
	end

	local sliding = false
	local function updateFromInput(x)
		local abs = track.AbsolutePosition.X
		local size = track.AbsoluteSize.X
		local t = math.clamp((x - abs) / size, 0, 1)
		setSpeedUI(MIN_SPD + t * (MAX_SPD - MIN_SPD))
	end
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true
		end
	end)
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true
			updateFromInput(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input.Position.X)
		end
	end)

	createToggle(HomePage, "Apply WalkSpeed", 86, function(v)
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
		if n and n > 0 then setSpeedUI(n) end
	end)

	player.CharacterAdded:Connect(function(char)
		task.wait(0.3)
		if applyOn then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = currentSpeed end
		end
	end)

	-- Discord + copy IDs (text: Copy / Copy check)
	createSection(HomePage, "Discord / IDs", 124)

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
		lbl.Size = UDim2.new(1, -72, 1, 0)
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
		copyBtn.Size = UDim2.new(0, 66, 0, 22)
		copyBtn.Position = UDim2.new(1, -68, 0.5, -11)
		copyBtn.BackgroundColor3 = Color3.fromRGB(70, 65, 140)
		copyBtn.Text = "Copy"
		copyBtn.TextSize = 10
		copyBtn.Font = Enum.Font.GothamBold
		copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		copyBtn.AutoButtonColor = false
		copyBtn.Parent = row
		Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 5)

		copyBtn.MouseButton1Click:Connect(function()
			playClick()
			if copyText(copyValue) then
				copyBtn.Text = "Copy check"
				copyBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 90)
				task.delay(1.5, function()
					if copyBtn and copyBtn.Parent then
						copyBtn.Text = "Copy"
						copyBtn.BackgroundColor3 = Color3.fromRGB(70, 65, 140)
					end
				end)
			else
				copyBtn.Text = "Fail"
				task.delay(1, function()
					if copyBtn and copyBtn.Parent then copyBtn.Text = "Copy" end
				end)
			end
		end)
		return row
	end

	makeCopyRow(HomePage, 146, "Discord Invite", "https://discord.gg/DvhPapJNm")
	makeCopyRow(HomePage, 178, "83343449436920", "83343449436920")
	makeCopyRow(HomePage, 210, "100254529812443", "100254529812443")

	HomePage.CanvasSize = UDim2.new(0, 0, 0, 260)
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
		drop.Text = (open and "▲  " or "▼  ") .. selected
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
		drop.Text = (listF.Visible and "▲  " or "▼  ") .. selected.L
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
gameNameLabel.Text = "Game: Loading..."
gameNameLabel.TextColor3 = Color3.fromRGB(200, 190, 255)
gameNameLabel.Font = Enum.Font.GothamBold
gameNameLabel.TextSize = 10
gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
gameNameLabel.Parent = GamePage

pcall(function()
	local info = MarketplaceService:GetProductInfo(game.PlaceId)
	if info then gameNameLabel.Text = "Playing: " .. info.Name end
end)

local notAdded = Instance.new("TextLabel")
notAdded.Size = UDim2.new(1, -8, 0, 36)
notAdded.Position = UDim2.new(0, 4, 0, 22)
notAdded.BackgroundTransparency = 1
notAdded.Text = "Game Not Added Yet"
notAdded.TextColor3 = Color3.fromRGB(255, 180, 200)
notAdded.Font = Enum.Font.GothamBold
notAdded.TextSize = 12
notAdded.TextWrapped = true
notAdded.Visible = false
notAdded.Parent = GamePage

-- dark purple Request Game button (when not supported)
local reqFromGame = Instance.new("TextButton")
reqFromGame.Size = UDim2.new(1, -8, 0, 28)
reqFromGame.Position = UDim2.new(0, 4, 0, 60)
reqFromGame.BackgroundColor3 = Color3.fromRGB(45, 30, 80)
reqFromGame.Text = "Request Game"
reqFromGame.TextColor3 = Color3.fromRGB(200, 180, 255)
reqFromGame.Font = Enum.Font.GothamBold
reqFromGame.TextSize = 12
reqFromGame.Visible = false
reqFromGame.AutoButtonColor = false
reqFromGame.Parent = GamePage
Instance.new("UICorner", reqFromGame).CornerRadius = UDim.new(0, 6)

local REQUEST_FILE = "plus1_requests.txt"

local function saveRequest(msg)
	if not msg or #msg == 0 then return false end
	pcall(function()
		if writefile then
			local prev = ""
			if isfile and isfile(REQUEST_FILE) then prev = readfile(REQUEST_FILE) end
			local display = player.DisplayName or player.Name
			writefile(REQUEST_FILE, prev .. player.Name .. "|" .. display .. "|" .. msg .. "\n")
		end
	end)
	return true
end

reqFromGame.MouseButton1Click:Connect(function()
	playClick()
	local gname = gameNameLabel.Text:gsub("^Playing: ", ""):gsub("^Game: ", "")
	if saveRequest("Request for: " .. gname .. " (PlaceId " .. tostring(game.PlaceId) .. ")") then
		reqFromGame.Text = "Sent!"
		task.delay(1.2, function()
			if reqFromGame then reqFromGame.Text = "Request Game" end
		end)
	end
end)

if SUPPORTED[game.PlaceId] then
	notAdded.Visible = false
	reqFromGame.Visible = false
	pcall(SUPPORTED[game.PlaceId])
else
	notAdded.Visible = true
	reqFromGame.Visible = true
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
	info.Text = "Will be adding soon"
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
	createSection(RequestPage, "Request Game", 0)
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

	local sendBtn = Instance.new("TextButton")
	sendBtn.Size = UDim2.new(1, -4, 0, 28)
	sendBtn.Position = UDim2.new(0, 2, 0, 80)
	sendBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 80)
	sendBtn.Text = "Send"
	sendBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
	sendBtn.Font = Enum.Font.GothamBold
	sendBtn.TextSize = 12
	sendBtn.AutoButtonColor = false
	sendBtn.Parent = RequestPage
	Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 6)
	sendBtn.MouseButton1Click:Connect(function()
		playClick()
		local msg = box.Text
		if msg and #msg > 0 then
			if saveRequest(msg) then
				sendBtn.Text = "Sent!"
				box.Text = ""
				task.delay(1.2, function()
					if sendBtn then sendBtn.Text = "Send" end
				end)
			end
		end
	end)
	RequestPage.CanvasSize = UDim2.new(0, 0, 0, 130)
end

-- ========== VIEW (owners only — others blocked by lock icon) ==========
do
	createSection(ViewPage, "View Requests", 0)

	local function refreshView()
		for _, c in ipairs(ViewPage:GetChildren()) do
			if c:IsA("Frame") or (c:IsA("TextLabel") and c.Text ~= "View Requests") then
				c:Destroy()
			end
		end
		local y = 22
		local list = {}
		pcall(function()
			if isfile and isfile(REQUEST_FILE) and readfile then
				for line in readfile(REQUEST_FILE):gmatch("[^\r\n]+") do
					local user, nick, msg = line:match("([^|]+)|([^|]+)|(.+)")
					if not msg then
						user, msg = line:match("([^|]+)|(.+)")
						nick = user
					end
					if user and msg then
						table.insert(list, {user = user, nick = nick or user, msg = msg})
					end
				end
			end
		end)
		if #list == 0 then
			local empty = Instance.new("TextLabel")
			empty.Size = UDim2.new(1, -4, 0, 30)
			empty.Position = UDim2.new(0, 2, 0, y)
			empty.BackgroundTransparency = 1
			empty.Text = "No requests yet."
			empty.TextColor3 = Color3.fromRGB(180, 170, 220)
			empty.Font = Enum.Font.Gotham
			empty.TextSize = 11
			empty.Parent = ViewPage
			y = y + 34
		else
			for i = #list, 1, -1 do
				local req = list[i]
				local card = Instance.new("Frame")
				card.Size = UDim2.new(1, -4, 0, 44)
				card.Position = UDim2.new(0, 2, 0, y)
				card.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
				card.Parent = ViewPage
				Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

				local u = Instance.new("TextLabel")
				u.Size = UDim2.new(1, -8, 0, 16)
				u.Position = UDim2.new(0, 6, 0, 2)
				u.BackgroundTransparency = 1
				u.Text = "@" .. req.user .. " (" .. req.nick .. ")"
				u.TextColor3 = Color3.fromRGB(180, 220, 255)
				u.Font = Enum.Font.GothamBold
				u.TextSize = 10
				u.TextXAlignment = Enum.TextXAlignment.Left
				u.TextTruncate = Enum.TextTruncate.AtEnd
				u.Parent = card

				local m = Instance.new("TextLabel")
				m.Size = UDim2.new(1, -8, 0, 22)
				m.Position = UDim2.new(0, 6, 0, 18)
				m.BackgroundTransparency = 1
				m.Text = req.msg
				m.TextColor3 = Color3.fromRGB(255, 255, 255)
				m.Font = Enum.Font.Gotham
				m.TextSize = 10
				m.TextXAlignment = Enum.TextXAlignment.Left
				m.TextTruncate = Enum.TextTruncate.AtEnd
				m.Parent = card

				y = y + 48
			end
		end
		ViewPage.CanvasSize = UDim2.new(0, 0, 0, y + 10)
	end

	if IS_OWNER then
		refreshView()
		if navButtons["View"] then
			navButtons["View"].MouseButton1Click:Connect(function()
				task.defer(refreshView)
			end)
		end
	end
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

-- Start on Home (after unlock)
switchPage("Home")

-- ========== KEY SYSTEM ==========
local KEY_FILE = "plus1_key_data.txt"
local FREE_USE_FILE = "plus1_free_key_uses.txt"
local FREE_KEY = "f0rfàn0nl6"
local FREE_MAX_USES = 20
local SESSION_MAX = 20 * 60
local ICON_NORMAL = "rbxthumb://type=Asset&id=78901068522402&w=420&h=420"
local ICON_WARN = "rbxthumb://type=Asset&id=89042512685010&w=420&h=420"
local ICON_OFF = "rbxthumb://type=Asset&id=90057204200047&w=420&h=420"

-- 1mth3b3st = works every time, expires every 10 minutes
-- f0rfàn0nl6 = free, expires in 24 hours, max 20 uses (shows use count)
local VALID_KEYS = {
	["1mth3b3st"] = {durationSec = 10 * 60, unlimited = true},
	[FREE_KEY] = {durationSec = 24 * 60 * 60, free = true, maxUses = FREE_MAX_USES},
	["plus1owner"] = {durationSec = 24 * 60 * 60, unlimited = true},
}

local function getFreeUses()
	local n = 0
	pcall(function()
		if isfile and isfile(FREE_USE_FILE) and readfile then
			n = tonumber(readfile(FREE_USE_FILE)) or 0
		end
	end)
	return n
end

local function setFreeUses(n)
	pcall(function()
		if writefile then writefile(FREE_USE_FILE, tostring(n)) end
	end)
end

local function loadKeySaved()
	local data = nil
	pcall(function()
		if isfile and isfile(KEY_FILE) and readfile then
			local raw = readfile(KEY_FILE)
			local key, exp = raw:match("([^|]+)|(%d+)")
			if key and exp then
				data = {key = key, exp = tonumber(exp)}
			end
		end
	end)
	return data
end

local function saveKeySaved(key, exp)
	pcall(function()
		if writefile then writefile(KEY_FILE, key .. "|" .. tostring(exp)) end
	end)
end

local function clearKeySaved()
	pcall(function()
		if writefile then writefile(KEY_FILE, "") end
		if isfile and delfile and isfile(KEY_FILE) then delfile(KEY_FILE) end
	end)
end

-- Key UI (YOUR designs: Insert Key + KeyTimer only)
-- Insert Key panel
local InsertKey = Instance.new("Frame")
InsertKey.Name = "Insert Key"
InsertKey.Size = UDim2.new(0, 240, 0, 250)
InsertKey.Position = UDim2.new(0.5, -120, 0.5, -125)
InsertKey.BackgroundColor3 = Color3.fromRGB(148, 142, 108)
InsertKey.BorderSizePixel = 0
InsertKey.Visible = true
InsertKey.ZIndex = 50
InsertKey.Parent = ScreenGui
Instance.new("UICorner", InsertKey).CornerRadius = UDim.new(0, 8)
local ikGrad = Instance.new("UIGradient", InsertKey)
ikGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(148, 148, 111)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
local ikStroke = Instance.new("UIStroke", InsertKey)
ikStroke.Color = Color3.fromRGB(102, 64, 52)
ikStroke.Thickness = 3

local keyTitleBtn = Instance.new("TextLabel")
keyTitleBtn.Size = UDim2.new(0, 200, 0, 40)
keyTitleBtn.Position = UDim2.new(0, 5, 0, 1)
keyTitleBtn.BackgroundTransparency = 1
keyTitleBtn.Text = "Key System"
keyTitleBtn.TextColor3 = Color3.fromRGB(27, 42, 53)
keyTitleBtn.TextSize = 22
keyTitleBtn.Font = Enum.Font.GothamBold
keyTitleBtn.ZIndex = 51
keyTitleBtn.Parent = InsertKey

local keyExpireHint = Instance.new("TextLabel")
keyExpireHint.Size = UDim2.new(1, 0, 0, 20)
keyExpireHint.Position = UDim2.new(0, 0, 0, 42)
keyExpireHint.BackgroundTransparency = 1
keyExpireHint.Text = "Key Expire every 10 minutes!"
keyExpireHint.TextColor3 = Color3.fromRGB(27, 42, 53)
keyExpireHint.TextSize = 11
keyExpireHint.Font = Enum.Font.Gotham
keyExpireHint.ZIndex = 51
keyExpireHint.Parent = InsertKey

local freeUseLbl = Instance.new("TextLabel")
freeUseLbl.Size = UDim2.new(1, -10, 0, 16)
freeUseLbl.Position = UDim2.new(0, 5, 0, 62)
freeUseLbl.BackgroundTransparency = 1
freeUseLbl.Text = ""
freeUseLbl.TextColor3 = Color3.fromRGB(40, 60, 100)
freeUseLbl.TextSize = 11
freeUseLbl.Font = Enum.Font.GothamBold
freeUseLbl.ZIndex = 51
freeUseLbl.Parent = InsertKey

local keyCloseX = Instance.new("TextButton")
keyCloseX.Name = "Close Key button"
keyCloseX.Size = UDim2.new(0, 25, 0, 25)
keyCloseX.Position = UDim2.new(0, 215, 0, -8)
keyCloseX.BackgroundTransparency = 1
keyCloseX.Text = "X"
keyCloseX.TextColor3 = Color3.fromRGB(255, 0, 0)
keyCloseX.TextSize = 22
keyCloseX.Font = Enum.Font.GothamBold
keyCloseX.ZIndex = 52
keyCloseX.Parent = InsertKey

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Name = "GetKeyButton"
getKeyBtn.Size = UDim2.new(0, 200, 0, 28)
getKeyBtn.Position = UDim2.new(0, 20, 0, 82)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 160)
getKeyBtn.Text = "Get Key"
getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyBtn.TextSize = 14
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.ZIndex = 51
getKeyBtn.Parent = InsertKey
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 8)

local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Size = UDim2.new(0, 220, 0, 40)
keyInput.Position = UDim2.new(0, 10, 0, 120)
keyInput.BackgroundColor3 = Color3.fromRGB(230, 225, 200)
keyInput.Text = ""
keyInput.PlaceholderText = "Insert Key"
keyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
keyInput.TextColor3 = Color3.fromRGB(27, 42, 53)
keyInput.TextSize = 18
keyInput.Font = Enum.Font.GothamBold
keyInput.ClearTextOnFocus = true
keyInput.ZIndex = 51
keyInput.Parent = InsertKey
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)

local confirmBtn = Instance.new("TextButton")
confirmBtn.Name = "Confirm Button"
confirmBtn.Size = UDim2.new(0, 200, 0, 40)
confirmBtn.Position = UDim2.new(0, 20, 0, 175)
confirmBtn.BackgroundColor3 = Color3.fromRGB(117, 117, 117)
confirmBtn.Text = "Confirm"
confirmBtn.TextColor3 = Color3.fromRGB(27, 42, 53)
confirmBtn.TextSize = 20
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.ZIndex = 51
confirmBtn.Parent = InsertKey
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)
local confGrad = Instance.new("UIGradient", confirmBtn)
confGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(177, 177, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(226, 226, 169)),
})

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -10, 0, 18)
statusLbl.Position = UDim2.new(0, 5, 0, 222)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = ""
statusLbl.TextColor3 = Color3.fromRGB(120, 40, 40)
statusLbl.TextSize = 11
statusLbl.Font = Enum.Font.Gotham
statusLbl.ZIndex = 51
statusLbl.Parent = InsertKey

makeDraggable(keyTitleBtn, InsertKey)

-- KeyTimer panel (TIMER LIVES ONLY HERE)
local KeyTimer = Instance.new("Frame")
KeyTimer.Name = "KeyTimer"
KeyTimer.Size = UDim2.new(0, 311, 0, 190)
KeyTimer.Position = UDim2.new(0.5, -155, 0.5, -95)
KeyTimer.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
KeyTimer.BorderSizePixel = 0
KeyTimer.Visible = false
KeyTimer.ZIndex = 55
KeyTimer.Parent = ScreenGui
Instance.new("UICorner", KeyTimer).CornerRadius = UDim.new(0, 8)

local ktTitle = Instance.new("Frame")
ktTitle.Name = "TitleName"
ktTitle.Size = UDim2.new(0, 311, 0, 30)
ktTitle.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
ktTitle.BorderSizePixel = 0
ktTitle.ZIndex = 56
ktTitle.Parent = KeyTimer
Instance.new("UICorner", ktTitle).CornerRadius = UDim.new(0, 8)

local keyTimerIcon = Instance.new("ImageLabel")
keyTimerIcon.Size = UDim2.new(0, 25, 0, 25)
keyTimerIcon.Position = UDim2.new(0, 4, 0, 3)
keyTimerIcon.BackgroundTransparency = 1
keyTimerIcon.Image = "rbxthumb://type=Asset&id=78901068522402&w=420&h=420"
keyTimerIcon.ZIndex = 57
keyTimerIcon.Parent = ktTitle

local keyTimerLabel = Instance.new("TextLabel")
keyTimerLabel.Name = "Timer"
keyTimerLabel.Size = UDim2.new(0, 50, 0, 30)
keyTimerLabel.Position = UDim2.new(0, 32, 0, 0)
keyTimerLabel.BackgroundTransparency = 1
keyTimerLabel.Text = "00:00"
keyTimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTimerLabel.TextSize = 12
keyTimerLabel.Font = Enum.Font.GothamBold
keyTimerLabel.ZIndex = 57
keyTimerLabel.Parent = ktTitle

local keyResetBtn = Instance.new("TextButton")
keyResetBtn.Name = "ResetButton"
keyResetBtn.Size = UDim2.new(0, 50, 0, 30)
keyResetBtn.Position = UDim2.new(0, 255, 0, 0)
keyResetBtn.BackgroundTransparency = 1
keyResetBtn.Text = "Reset"
keyResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyResetBtn.TextSize = 11
keyResetBtn.Font = Enum.Font.GothamBold
keyResetBtn.ZIndex = 57
keyResetBtn.Parent = ktTitle

local secA = Instance.new("Frame")
secA.Name = "Section A"
secA.Size = UDim2.new(0, 145, 0, 148)
secA.Position = UDim2.new(0, 5, 0, 36)
secA.BackgroundColor3 = Color3.fromRGB(79, 74, 164)
secA.ZIndex = 56
secA.Parent = KeyTimer
Instance.new("UICorner", secA).CornerRadius = UDim.new(0, 8)
local saS = Instance.new("UIStroke", secA)
saS.Color = Color3.fromRGB(87, 92, 154)
saS.Thickness = 2

local secALbl = Instance.new("TextLabel")
secALbl.Size = UDim2.new(1, -10, 0, 20)
secALbl.Position = UDim2.new(0, 5, 0, 6)
secALbl.BackgroundTransparency = 1
secALbl.Text = "Session"
secALbl.TextColor3 = Color3.fromRGB(220, 210, 255)
secALbl.TextSize = 12
secALbl.Font = Enum.Font.GothamBold
secALbl.ZIndex = 57
secALbl.Parent = secA

local secABody = Instance.new("TextLabel")
secABody.Size = UDim2.new(1, -10, 1, -30)
secABody.Position = UDim2.new(0, 5, 0, 28)
secABody.BackgroundTransparency = 1
secABody.Text = "Timer runs here only.\n\n<=10:00 warning icon\n0:00 = time up\nRejoin locks you out\n(Ran Out Of Time!)"
secABody.TextColor3 = Color3.fromRGB(230, 220, 255)
secABody.TextSize = 11
secABody.Font = Enum.Font.Gotham
secABody.TextXAlignment = Enum.TextXAlignment.Left
secABody.TextYAlignment = Enum.TextYAlignment.Top
secABody.TextWrapped = true
secABody.ZIndex = 57
secABody.Parent = secA

local secB = Instance.new("Frame")
secB.Name = "Section B"
secB.Size = UDim2.new(0, 145, 0, 148)
secB.Position = UDim2.new(0, 160, 0, 36)
secB.BackgroundColor3 = Color3.fromRGB(79, 74, 164)
secB.ZIndex = 56
secB.Parent = KeyTimer
Instance.new("UICorner", secB).CornerRadius = UDim.new(0, 8)
local sbS = Instance.new("UIStroke", secB)
sbS.Color = Color3.fromRGB(87, 92, 154)
sbS.Thickness = 2

local secBLbl = Instance.new("TextLabel")
secBLbl.Size = UDim2.new(1, -10, 0, 20)
secBLbl.Position = UDim2.new(0, 5, 0, 6)
secBLbl.BackgroundTransparency = 1
secBLbl.Text = "Hub"
secBLbl.TextColor3 = Color3.fromRGB(220, 210, 255)
secBLbl.TextSize = 12
secBLbl.Font = Enum.Font.GothamBold
secBLbl.ZIndex = 57
secBLbl.Parent = secB

local openMainFromTimer = Instance.new("TextButton")
openMainFromTimer.Size = UDim2.new(1, -12, 0, 32)
openMainFromTimer.Position = UDim2.new(0, 6, 0, 40)
openMainFromTimer.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
openMainFromTimer.Text = "Open Main GUI"
openMainFromTimer.TextColor3 = Color3.fromRGB(255, 255, 255)
openMainFromTimer.TextSize = 12
openMainFromTimer.Font = Enum.Font.GothamBold
openMainFromTimer.ZIndex = 57
openMainFromTimer.Parent = secB
Instance.new("UICorner", openMainFromTimer).CornerRadius = UDim.new(0, 8)

local hideKeyTimer = Instance.new("TextButton")
hideKeyTimer.Size = UDim2.new(1, -12, 0, 32)
hideKeyTimer.Position = UDim2.new(0, 6, 0, 80)
hideKeyTimer.BackgroundColor3 = Color3.fromRGB(45, 30, 80)
hideKeyTimer.Text = "Hide Timer"
hideKeyTimer.TextColor3 = Color3.fromRGB(200, 180, 255)
hideKeyTimer.TextSize = 12
hideKeyTimer.Font = Enum.Font.GothamBold
hideKeyTimer.ZIndex = 57
hideKeyTimer.Parent = secB
Instance.new("UICorner", hideKeyTimer).CornerRadius = UDim.new(0, 8)

makeDraggable(ktTitle, KeyTimer)

-- Open Key button when Insert Key closed
local OpenKeyBtn = Instance.new("TextButton")
OpenKeyBtn.Name = "OpenKeyBtn"
OpenKeyBtn.Size = UDim2.new(0, 90, 0, 36)
OpenKeyBtn.Position = UDim2.new(0, 16, 0.5, 30)
OpenKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 65)
OpenKeyBtn.Text = "Open Key"
OpenKeyBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
OpenKeyBtn.TextSize = 13
OpenKeyBtn.Font = Enum.Font.GothamBold
OpenKeyBtn.Visible = false
OpenKeyBtn.ZIndex = 60
OpenKeyBtn.Parent = ScreenGui
Instance.new("UICorner", OpenKeyBtn).CornerRadius = UDim.new(0, 8)
local oks = Instance.new("UIStroke", OpenKeyBtn)
oks.Color = Color3.fromRGB(87, 92, 154)
oks.Thickness = 2
makeDraggable(OpenKeyBtn, OpenKeyBtn)

-- alias for old references
local KeyFrame = InsertKey

-- ========== SPOT THE DIFFERENCE (Get Key) ==========
local TOTAL_LEVELS = 30
local SpotGui = Instance.new("Frame")
SpotGui.Name = "SpotTheDifference"
SpotGui.Size = UDim2.new(0, 320, 0, 280)
SpotGui.Position = UDim2.new(0.5, -160, 0.5, -140)
SpotGui.BackgroundColor3 = Color3.fromRGB(20, 16, 35)
SpotGui.BorderSizePixel = 0
SpotGui.Visible = false
SpotGui.ZIndex = 80
SpotGui.Parent = ScreenGui
Instance.new("UICorner", SpotGui).CornerRadius = UDim.new(0, 12)
local spotStroke = Instance.new("UIStroke", SpotGui)
spotStroke.Color = Color3.fromRGB(0, 255, 80)
spotStroke.Thickness = 3

local spotTitle = Instance.new("TextLabel")
spotTitle.Size = UDim2.new(1, -70, 0, 28)
spotTitle.Position = UDim2.new(0, 10, 0, 4)
spotTitle.BackgroundTransparency = 1
spotTitle.Text = "Spot the Difference"
spotTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
spotTitle.Font = Enum.Font.GothamBold
spotTitle.TextSize = 14
spotTitle.TextXAlignment = Enum.TextXAlignment.Left
spotTitle.ZIndex = 81
spotTitle.Parent = SpotGui

local spotClose = Instance.new("TextButton")
spotClose.Size = UDim2.new(0, 50, 0, 24)
spotClose.Position = UDim2.new(1, -56, 0, 6)
spotClose.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
spotClose.Text = "Close"
spotClose.TextColor3 = Color3.fromRGB(255, 255, 255)
spotClose.TextSize = 11
spotClose.Font = Enum.Font.GothamBold
spotClose.ZIndex = 81
spotClose.Parent = SpotGui
Instance.new("UICorner", spotClose).CornerRadius = UDim.new(0, 6)

local levelLbl = Instance.new("TextLabel")
levelLbl.Size = UDim2.new(1, -16, 0, 18)
levelLbl.Position = UDim2.new(0, 8, 0, 32)
levelLbl.BackgroundTransparency = 1
levelLbl.Text = "Level 1 / " .. TOTAL_LEVELS
levelLbl.TextColor3 = Color3.fromRGB(200, 190, 255)
levelLbl.Font = Enum.Font.Gotham
levelLbl.TextSize = 12
levelLbl.ZIndex = 81
levelLbl.Parent = SpotGui

local leftPane = Instance.new("Frame")
leftPane.Size = UDim2.new(0.5, -12, 0, 160)
leftPane.Position = UDim2.new(0, 8, 0, 54)
leftPane.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
leftPane.ZIndex = 81
leftPane.Parent = SpotGui
Instance.new("UICorner", leftPane).CornerRadius = UDim.new(0, 8)

local rightPane = Instance.new("Frame")
rightPane.Size = UDim2.new(0.5, -12, 0, 160)
rightPane.Position = UDim2.new(0.5, 4, 0, 54)
rightPane.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
rightPane.ZIndex = 81
rightPane.Parent = SpotGui
Instance.new("UICorner", rightPane).CornerRadius = UDim.new(0, 8)

local spotStatus = Instance.new("TextLabel")
spotStatus.Size = UDim2.new(1, -16, 0, 18)
spotStatus.Position = UDim2.new(0, 8, 0, 220)
spotStatus.BackgroundTransparency = 1
spotStatus.Text = "Tap the difference on the right"
spotStatus.TextColor3 = Color3.fromRGB(180, 170, 220)
spotStatus.Font = Enum.Font.Gotham
spotStatus.TextSize = 11
spotStatus.ZIndex = 81
spotStatus.Parent = SpotGui

local rewardLbl = Instance.new("TextLabel")
rewardLbl.Size = UDim2.new(1, -16, 0, 28)
rewardLbl.Position = UDim2.new(0, 8, 0, 242)
rewardLbl.BackgroundTransparency = 1
rewardLbl.Text = ""
rewardLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
rewardLbl.Font = Enum.Font.GothamBold
rewardLbl.TextSize = 12
rewardLbl.ZIndex = 81
rewardLbl.Parent = SpotGui

makeDraggable(spotTitle, SpotGui)

local spotLevel = 1
local function clearPanes()
	for _, p in ipairs({leftPane, rightPane}) do
		for _, c in ipairs(p:GetChildren()) do
			if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
		end
	end
end
local function makeShape(parent, x, y, color, size)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, size or 18, 0, size or 18)
	f.Position = UDim2.new(0, x, 0, y)
	f.BackgroundColor3 = color
	f.BorderSizePixel = 0
	f.ZIndex = 82
	f.Parent = parent
	Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
	return f
end
local function startSpotLevel(lv)
	clearPanes()
	spotLevel = lv
	levelLbl.Text = "Level " .. lv .. " / " .. TOTAL_LEVELS
	spotStatus.Text = "Tap the difference on the right"
	rewardLbl.Text = ""
	local seed = lv * 17 + 3
	local colors = {
		Color3.fromRGB(255, 100, 100), Color3.fromRGB(100, 200, 255),
		Color3.fromRGB(100, 255, 140), Color3.fromRGB(255, 220, 80),
		Color3.fromRGB(200, 120, 255),
	}
	for i = 1, 5 do
		local x = 10 + ((seed * i * 7) % 100)
		local y = 10 + ((seed * i * 11) % 110)
		local col = colors[((i + lv) % #colors) + 1]
		makeShape(leftPane, x, y, col, 16)
		makeShape(rightPane, x, y, col, 16)
	end
	local dx = 20 + ((seed * 13) % 90)
	local dy = 20 + ((seed * 19) % 100)
	local dcol = colors[((lv + 2) % #colors) + 1]
	local diffBtn = Instance.new("TextButton")
	diffBtn.Size = UDim2.new(0, 20, 0, 20)
	diffBtn.Position = UDim2.new(0, dx, 0, dy)
	diffBtn.BackgroundColor3 = dcol
	diffBtn.Text = ""
	diffBtn.ZIndex = 83
	diffBtn.Parent = rightPane
	Instance.new("UICorner", diffBtn).CornerRadius = UDim.new(1, 0)
	diffBtn.MouseButton1Click:Connect(function()
		playClick()
		if spotLevel >= TOTAL_LEVELS then
			local reward = "spot" .. tostring(player.UserId % 10000) .. "win"
			VALID_KEYS[reward] = {durationSec = 10 * 60, unlimited = true}
			rewardLbl.Text = "Key: " .. reward
			spotStatus.Text = "You won! Confirm on Key System"
			keyInput.Text = reward
			pcall(function() if setclipboard then setclipboard(reward) end end)
			task.delay(1.2, function()
				SpotGui.Visible = false
				InsertKey.Visible = true
				statusLbl.Text = "Key filled — press Confirm"
				statusLbl.TextColor3 = Color3.fromRGB(40, 120, 40)
			end)
		else
			spotStatus.Text = "Correct! Next..."
			task.delay(0.35, function() startSpotLevel(spotLevel + 1) end)
		end
	end)
end

spotClose.MouseButton1Click:Connect(function()
	playClick()
	SpotGui.Visible = false
	InsertKey.Visible = true
end)

local function openKeySystem()
	InsertKey.Visible = true
	OpenKeyBtn.Visible = false
	SpotGui.Visible = false
end
local function closeKeySystem()
	InsertKey.Visible = false
	SpotGui.Visible = false
	if not ENV.plus1_unlocked then OpenKeyBtn.Visible = true end
end
keyCloseX.MouseButton1Click:Connect(function() playClick() closeKeySystem() end)
OpenKeyBtn.MouseButton1Click:Connect(function() playClick() openKeySystem() end)
getKeyBtn.MouseButton1Click:Connect(function()
	playClick()
	InsertKey.Visible = false
	SpotGui.Visible = true
	startSpotLevel(1)
end)
openMainFromTimer.MouseButton1Click:Connect(function()
	playClick()
	Main.Visible = true
	KeyTimer.Visible = false
end)
hideKeyTimer.MouseButton1Click:Connect(function()
	playClick()
	KeyTimer.Visible = false
end)

-- Session timer
local sessionLeft = SESSION_MAX
local timerRunning = false
local timerConn = nil

local function formatTime(sec)
	sec = math.max(0, math.floor(sec))
	local m = math.floor(sec / 60)
	local s = sec % 60
	return string.format("%02d:%02d", m, s)
end

local function updateTimerIcon()
	local img, col
	if sessionLeft <= 0 then
		img, col = ICON_OFF, Color3.fromRGB(255, 80, 80)
	elseif sessionLeft <= 10 * 60 then
		img, col = ICON_WARN, Color3.fromRGB(255, 200, 80)
	else
		img, col = ICON_NORMAL, Color3.fromRGB(255, 255, 255)
	end
	-- timer ONLY on key system
	keyTimerIcon.Image = img
	keyTimerLabel.TextColor3 = col
end

local function kickTimeOut()
	-- NO live kick — only lock on rejoin (saved exp already past)
	timerRunning = false
	keyTimerIcon.Image = ICON_OFF
	keyTimerLabel.Text = "00:00"
	keyTimerLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
	clearKeySaved() -- force key UI next join
	-- show message on KeyTimer Section A
	pcall(function()
		if secABody then
			secABody.Text = "Ran Out Of Time!\n\nYou can keep using\nthis session.\n\nRejoin = need key again"
			secABody.TextColor3 = Color3.fromRGB(255, 120, 120)
		end
	end)
	if secBLbl then secBLbl.Text = "EXPIRED" end
end

local function startSessionTimer(fromSeconds)
	sessionLeft = fromSeconds or SESSION_MAX
	timerRunning = true
	updateTimerIcon()
	keyTimerLabel.Text = formatTime(sessionLeft)
	if timerConn then task.cancel(timerConn) end
	timerConn = task.spawn(function()
		while timerRunning and sessionLeft > 0 do
			task.wait(1)
			if not timerRunning then break end
			sessionLeft = sessionLeft - 1
			local t = formatTime(sessionLeft)
			keyTimerLabel.Text = t
			updateTimerIcon()
			-- persist remaining roughly
			pcall(function()
				local saved = loadKeySaved()
				if saved then
					saveKeySaved(saved.key, os.time() + sessionLeft)
				end
			end)
			if sessionLeft <= 0 then
				kickTimeOut()
				break
			end
		end
	end)
end

local function unlockHub(keyStr, durationSec)
	local dur = durationSec or (10 * 60)
	ENV.plus1_unlocked = true
	InsertKey.Visible = false
	SpotGui.Visible = false
	OpenKeyBtn.Visible = false
	Main.Visible = true
	OpenBtn.Visible = false
	KeyTimer.Visible = true -- timer GUI only here
	saveKeySaved(keyStr or "session", os.time() + dur)
	startSessionTimer(dur)
	playClick()
end

confirmBtn.MouseButton1Click:Connect(function()
	playClick()
	local entered = (keyInput.Text or ""):gsub("%s+", "")
	if entered == "" then
		statusLbl.Text = "Enter a key first"
		statusLbl.TextColor3 = Color3.fromRGB(255, 180, 80)
		freeUseLbl.Text = ""
		return
	end
	local info = VALID_KEYS[entered]
	-- spot-the-difference reward keys (spotXXXX)
	if not info and entered:match("^spot%d+win$") then
		info = {durationSec = 10 * 60, unlimited = true}
		VALID_KEYS[entered] = info
	end
	if not info then
		statusLbl.Text = "Invalid key"
		statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
		freeUseLbl.Text = ""
		return
	end
	-- free key use limit
	if info.free then
		local used = getFreeUses()
		freeUseLbl.Text = "Free key uses: " .. tostring(used) .. " / " .. tostring(info.maxUses or FREE_MAX_USES)
		if used >= (info.maxUses or FREE_MAX_USES) then
			statusLbl.Text = "Free key max uses reached"
			statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
			return
		end
		used = used + 1
		setFreeUses(used)
		freeUseLbl.Text = "Free key uses: " .. tostring(used) .. " / " .. tostring(info.maxUses or FREE_MAX_USES)
		statusLbl.Text = "Free key OK (" .. used .. "/" .. (info.maxUses or FREE_MAX_USES) .. ")"
		statusLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
	else
		freeUseLbl.Text = ""
		statusLbl.Text = "Success! (" .. math.floor((info.durationSec or 600) / 60) .. " min)"
		statusLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
	end
	task.wait(0.45)
	unlockHub(entered, info.durationSec)
end)

-- show free uses when typing free key
keyInput:GetPropertyChangedSignal("Text"):Connect(function()
	local t = (keyInput.Text or ""):gsub("%s+", "")
	if t == FREE_KEY then
		local used = getFreeUses()
		freeUseLbl.Text = "Free key uses: " .. tostring(used) .. " / " .. tostring(FREE_MAX_USES)
	else
		freeUseLbl.Text = ""
	end
end)

keyResetBtn.MouseButton1Click:Connect(function()
	playClick()
	timerRunning = false
	clearKeySaved()
	ENV.plus1_unlocked = false
	Main.Visible = false
	OpenBtn.Visible = false
	OpenKeyBtn.Visible = false
	SpotGui.Visible = false
	KeyTimer.Visible = false
	InsertKey.Visible = true
	keyInput.Text = ""
	keyTimerLabel.Text = "00:00"
	statusLbl.Text = "Key reset — enter again"
	statusLbl.TextColor3 = Color3.fromRGB(120, 60, 40)
end)

-- Auto unlock if saved session still valid
task.spawn(function()
	local saved = loadKeySaved()
	if saved and saved.exp and saved.exp > os.time() then
		local left = saved.exp - os.time()
		if left > (24 * 60 * 60) then left = 24 * 60 * 60 end
		ENV.plus1_unlocked = true
		InsertKey.Visible = false
		SpotGui.Visible = false
		OpenKeyBtn.Visible = false
		Main.Visible = true
		KeyTimer.Visible = true
		startSessionTimer(left)
	else
		InsertKey.Visible = true
		KeyTimer.Visible = false
		OpenKeyBtn.Visible = false
		Main.Visible = false
	end
end)

print("[+1GamesScript] Loaded — key system + timer")
