-- +1 Scripts Hub | Ringta-style dark theme
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local IS_OWNER = (player.Name == "Eyfanboy09")

if playerGui:FindFirstChild("+1Scripts") then playerGui["+1Scripts"]:Destroy() end

-- Ringta-inspired theme
local Theme = {
	Bg = Color3.fromRGB(15, 15, 15),
	Bg2 = Color3.fromRGB(22, 22, 22),
	Button = Color3.fromRGB(30, 30, 30),
	ButtonHover = Color3.fromRGB(42, 42, 42),
	Accent = Color3.fromRGB(0, 220, 90),
	AccentDim = Color3.fromRGB(0, 160, 65),
	Text = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(170, 170, 170),
	Stroke = Color3.fromRGB(45, 45, 45),
	Danger = Color3.fromRGB(180, 50, 50),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "+1Scripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = playerGui

local clickIds = {"rbxassetid://103866342467024","rbxassetid://14133663945","rbxassetid://876939830","rbxassetid://166084059"}
local function playClick(vol)
	local s = Instance.new("Sound")
	s.SoundId = clickIds[math.random(1,#clickIds)]
	s.Volume = vol or 0.4
	s.PlaybackSpeed = 0.9 + math.random()*0.25
	s.Parent = SoundService
	s:Play()
	s.Ended:Connect(function() s:Destroy() end)
	task.delay(2, function() if s then s:Destroy() end end)
end

local function makeSatisfying(btn, normal, hover, press)
	normal = normal or btn.BackgroundColor3
	hover = hover or Theme.ButtonHover
	press = press or Color3.fromRGB(20,20,20)
	local orig = btn.Size
	local ti = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tb = TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	btn.AutoButtonColor = false
	btn.MouseEnter:Connect(function() TweenService:Create(btn, ti, {BackgroundColor3=hover}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, ti, {BackgroundColor3=normal, Size=orig}):Play() end)
	btn.MouseButton1Down:Connect(function()
		local sm = UDim2.new(orig.X.Scale, orig.X.Offset-2, orig.Y.Scale, orig.Y.Offset-2)
		TweenService:Create(btn, ti, {BackgroundColor3=press, Size=sm}):Play()
		playClick()
	end)
	btn.MouseButton1Up:Connect(function() TweenService:Create(btn, tb, {BackgroundColor3=hover, Size=orig}):Play() end)
end

-- MAIN (same size as original ~340x310)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 340, 0, 310)
Main.Position = UDim2.new(0.5, -170, 0.5, -155)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color = Theme.Stroke
UIStroke.Thickness = 1.5

local GlowLine = Instance.new("Frame")
GlowLine.Size = UDim2.new(1,0,0,1)
GlowLine.Position = UDim2.new(0,0,0,38)
GlowLine.BackgroundColor3 = Theme.Accent
GlowLine.BackgroundTransparency = 0.4
GlowLine.BorderSizePixel = 0
GlowLine.ZIndex = 3
GlowLine.Parent = Main

local RainBg = Instance.new("Frame")
RainBg.Size = UDim2.new(1,0,1,0)
RainBg.BackgroundTransparency = 1
RainBg.ZIndex = 0
RainBg.ClipsDescendants = true
RainBg.Parent = Main
local activeNoobs, MAX_NOOBS = 0, 2

local function spawnDigit(parent, digits)
	digits = digits or {"0","1"}
	local digit = Instance.new("TextLabel")
	digit.Size = UDim2.new(0,12,0,14)
	digit.BackgroundTransparency = 1
	digit.Text = digits[math.random(1,#digits)]
	digit.TextColor3 = Color3.fromRGB(0, math.random(140,220), math.random(40,90))
	digit.Font = Enum.Font.Code
	digit.TextSize = math.random(9,13)
	digit.TextTransparency = math.random(30,70)/100
	digit.ZIndex = 0
	digit.Parent = parent
	local pw = math.max(20, parent.AbsoluteSize.X)
	local ph = math.max(20, parent.AbsoluteSize.Y)
	local x, y = math.random(0, math.max(1,pw-12)), math.random(-30,-8)
	digit.Position = UDim2.new(0,x,0,y)
	local speed, drift = math.random(25,65)/100, (math.random()-0.5)*0.3
	task.spawn(function()
		while digit and digit.Parent and y < ph+25 do
			y = y + speed*2.2; x = x + drift
			digit.Position = UDim2.new(0,x,0,y)
			if math.random()<0.05 then digit.Text = digits[math.random(1,#digits)] end
			task.wait(0.03)
		end
		if digit then digit:Destroy() end
	end)
end

local function spawnFallingNoob(parent)
	if activeNoobs >= MAX_NOOBS then return end
	activeNoobs = activeNoobs + 1
	local root = Instance.new("Frame")
	root.Size = UDim2.new(0,32,0,46)
	root.BackgroundTransparency = 1
	root.ZIndex = 0
	root.Parent = parent
	local pw = math.max(40, parent.AbsoluteSize.X)
	local ph = math.max(40, parent.AbsoluteSize.Y)
	local startX, y = math.random(0, pw-36), math.random(-60,-40)
	root.Position = UDim2.new(0,startX,0,y)
	root.Rotation = math.random(-10,10)
	local head = Instance.new("Frame")
	head.Size = UDim2.new(0,20,0,20)
	head.Position = UDim2.new(0.5,-10,0,0)
	head.BackgroundColor3 = Color3.fromRGB(245,205,48)
	head.BorderSizePixel = 0
	head.ZIndex = 0
	head.Parent = root
	Instance.new("UICorner", head).CornerRadius = UDim.new(0,3)
	local smile = Instance.new("TextLabel")
	smile.Size = UDim2.new(1,0,1,0)
	smile.BackgroundTransparency = 1
	smile.Text = "☺"
	smile.TextColor3 = Color3.fromRGB(40,40,40)
	smile.TextSize = 12
	smile.Font = Enum.Font.GothamBold
	smile.ZIndex = 1
	smile.Parent = head
	local torso = Instance.new("Frame")
	torso.Size = UDim2.new(0,18,0,14)
	torso.Position = UDim2.new(0.5,-9,0,20)
	torso.BackgroundColor3 = Color3.fromRGB(13,105,172)
	torso.BorderSizePixel = 0
	torso.ZIndex = 0
	torso.Parent = root
	local legL = Instance.new("Frame")
	legL.Size = UDim2.new(0,7,0,10)
	legL.Position = UDim2.new(0.5,-9,0,34)
	legL.BackgroundColor3 = Color3.fromRGB(75,151,75)
	legL.BorderSizePixel = 0
	legL.ZIndex = 0
	legL.Parent = root
	local legR = Instance.new("Frame")
	legR.Size = UDim2.new(0,7,0,10)
	legR.Position = UDim2.new(0.5,2,0,34)
	legR.BackgroundColor3 = Color3.fromRGB(75,151,75)
	legR.BorderSizePixel = 0
	legR.ZIndex = 0
	legR.Parent = root
	local speed, drift, spin = math.random(28,50)/100, (math.random()-0.5)*0.45, (math.random()-0.5)*1
	task.spawn(function()
		local rot = root.Rotation
		while root and root.Parent and y < ph+50 do
			y = y + speed*2.4; startX = startX + drift; rot = rot + spin
			root.Position = UDim2.new(0,startX,0,y)
			root.Rotation = rot
			legL.Rotation = math.sin(y/12)*16
			legR.Rotation = -math.sin(y/12)*16
			task.wait(0.03)
		end
		if root then root:Destroy() end
		activeNoobs = math.max(0, activeNoobs-1)
	end)
end

task.spawn(function()
	while RainBg and RainBg.Parent do spawnDigit(RainBg) task.wait(math.random(10,20)/100) end
end)
task.spawn(function()
	while RainBg and RainBg.Parent do
		if activeNoobs < MAX_NOOBS then spawnFallingNoob(RainBg) end
		task.wait(2)
	end
end)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,38)
TitleBar.BackgroundColor3 = Theme.Bg2
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,10)
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1,0,0,12)
TitleFix.Position = UDim2.new(0,0,1,-12)
TitleFix.BackgroundColor3 = Theme.Bg2
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 2
TitleFix.Parent = TitleBar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-45,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Text = "+1 Scripts"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = TitleBar
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,26,0,26)
Close.Position = UDim2.new(1,-32,0.5,-13)
Close.BackgroundColor3 = Theme.Button
Close.Text = "×"
Close.TextColor3 = Theme.Text
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.ZIndex = 3
Close.Parent = TitleBar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,6)
makeSatisfying(Close, Theme.Button, Theme.ButtonHover, Color3.fromRGB(18,18,18))

-- OPEN BUTTON: "Open" with falling digits 1,0,0,1,2,3,0 — draggable
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 56, 0, 40)
OpenBtn.Position = UDim2.new(0, 16, 0.5, -20)
OpenBtn.BackgroundColor3 = Theme.Bg
OpenBtn.Text = ""
OpenBtn.AutoButtonColor = false
OpenBtn.ClipsDescendants = true
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local openStroke = Instance.new("UIStroke", OpenBtn)
openStroke.Color = Theme.Accent
openStroke.Thickness = 1.5
openStroke.Transparency = 0.3

local OpenLabel = Instance.new("TextLabel")
OpenLabel.Size = UDim2.new(1,0,1,0)
OpenLabel.BackgroundTransparency = 1
OpenLabel.Text = "Open"
OpenLabel.TextColor3 = Theme.Accent
OpenLabel.Font = Enum.Font.GothamBold
OpenLabel.TextSize = 13
OpenLabel.ZIndex = 2
OpenLabel.Parent = OpenBtn

local OpenRain = Instance.new("Frame")
OpenRain.Size = UDim2.new(1,0,1,0)
OpenRain.BackgroundTransparency = 1
OpenRain.ZIndex = 1
OpenRain.ClipsDescendants = true
OpenRain.Parent = OpenBtn

local OPEN_DIGITS = {"1","0","0","1","2","3","0"}
task.spawn(function()
	while OpenRain and OpenRain.Parent do
		if OpenBtn.Visible then
			spawnDigit(OpenRain, OPEN_DIGITS)
		end
		task.wait(math.random(12,28)/100)
	end
end)

makeSatisfying(OpenBtn, Theme.Bg, Theme.Bg2, Color3.fromRGB(10,10,10))
Close.MouseButton1Click:Connect(function() Main.Visible=false OpenBtn.Visible=true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible=true OpenBtn.Visible=false end)

local openDragging, openDragStart, openStartPos
OpenBtn.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		openDragging=true; openDragStart=input.Position; openStartPos=OpenBtn.Position
	end
end)
OpenBtn.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then openDragging=false end
end)
UserInputService.InputChanged:Connect(function(input)
	if openDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
		local d=input.Position-openDragStart
		OpenBtn.Position=UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset+d.X, openStartPos.Y.Scale, openStartPos.Y.Offset+d.Y)
	end
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,-16,0,30)
TabBar.Position = UDim2.new(0,8,0,44)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 2
TabBar.Parent = Main

local function createTab(name, position, width)
	local tab = Instance.new("TextButton")
	tab.Name = name
	tab.Size = UDim2.new(0, width or 90, 1, 0)
	tab.Position = position
	tab.BackgroundColor3 = Theme.Button
	tab.Text = name
	tab.TextColor3 = Theme.TextDim
	tab.Font = Enum.Font.GothamMedium
	tab.TextSize = 12
	tab.ZIndex = 3
	tab.Parent = TabBar
	Instance.new("UICorner", tab).CornerRadius = UDim.new(0,6)
	makeSatisfying(tab, Theme.Button, Theme.ButtonHover, Color3.fromRGB(18,18,18))
	return tab
end

local GameTab, GameListTab, MiscTab, AccountsTab
if IS_OWNER then
	GameTab = createTab("Game", UDim2.new(0,0,0,0), 72)
	GameListTab = createTab("Game List", UDim2.new(0,76,0,0), 82)
	MiscTab = createTab("Misc", UDim2.new(0,162,0,0), 64)
	AccountsTab = createTab("Accounts", UDim2.new(0,230,0,0), 82)
else
	GameTab = createTab("Game", UDim2.new(0,0,0,0), 100)
	GameListTab = createTab("Game List", UDim2.new(0,108,0,0), 100)
	MiscTab = createTab("Misc", UDim2.new(0,216,0,0), 100)
end

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-16,1,-108)
Content.Position = UDim2.new(0,8,0,80)
Content.BackgroundTransparency = 1
Content.ZIndex = 2
Content.Parent = Main

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1,-16,0,14)
Credit.Position = UDim2.new(0,8,1,-18)
Credit.BackgroundTransparency = 1
Credit.Text = "Made By ItsKyanBence"
Credit.TextColor3 = Color3.fromRGB(90,90,90)
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 10
Credit.TextXAlignment = Enum.TextXAlignment.Center
Credit.ZIndex = 3
Credit.Parent = Main

local function createSection(parent, text, y)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,18)
	label.Position = UDim2.new(0,0,0,y)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.Accent
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

local function createToggle(parent, name, y, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,30)
	frame.Position = UDim2.new(0,0,0,y)
	frame.BackgroundColor3 = Theme.Button
	frame.Parent = parent
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-52,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Theme.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0,38,0,20)
	toggle.Position = UDim2.new(1,-46,0.5,-10)
	toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
	toggle.Text = ""
	toggle.AutoButtonColor = false
	toggle.Parent = frame
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0,14,0,14)
	circle.Position = UDim2.new(0,3,0.5,-7)
	circle.BackgroundColor3 = Color3.fromRGB(160,160,160)
	circle.Parent = toggle
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)
	local enabled = false
	local tf = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tb = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	toggle.MouseButton1Click:Connect(function()
		enabled = not enabled
		playClick()
		if enabled then
			TweenService:Create(toggle, tf, {BackgroundColor3=Theme.AccentDim}):Play()
			TweenService:Create(circle, tb, {Position=UDim2.new(1,-17,0.5,-7), BackgroundColor3=Theme.Accent}):Play()
		else
			TweenService:Create(toggle, tf, {BackgroundColor3=Color3.fromRGB(45,45,45)}):Play()
			TweenService:Create(circle, tb, {Position=UDim2.new(0,3,0.5,-7), BackgroundColor3=Color3.fromRGB(160,160,160)}):Play()
		end
		callback(enabled)
	end)
	return frame
end

local function createButton(parent, name, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,30)
	btn.Position = UDim2.new(0,0,0,y)
	btn.BackgroundColor3 = Theme.Button
	btn.Text = name
	btn.TextColor3 = Theme.Text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 12
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	makeSatisfying(btn, Theme.Button, Theme.ButtonHover, Color3.fromRGB(18,18,18))
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function fireTouch(part)
	if not part then return end
	if part:IsA("TouchTransmitter") or part.Name=="TouchInterest" then part = part.Parent end
	if not part or not part:IsA("BasePart") then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function() firetouchinterest(part,hrp,0) task.wait() firetouchinterest(part,hrp,1) end)
end

-- GAME PAGE
local GamePage = Instance.new("Frame")
GamePage.Size = UDim2.new(1,0,1,0)
GamePage.BackgroundTransparency = 1
GamePage.Visible = true
GamePage.Parent = Content
local GameStatus = Instance.new("TextLabel")
GameStatus.Size = UDim2.new(1,0,0,16)
GameStatus.BackgroundTransparency = 1
GameStatus.Text = "Current Game"
GameStatus.TextColor3 = Theme.TextDim
GameStatus.Font = Enum.Font.Gotham
GameStatus.TextSize = 11
GameStatus.TextXAlignment = Enum.TextXAlignment.Left
GameStatus.Parent = GamePage
local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Size = UDim2.new(1,0,0,22)
GameNameLabel.Position = UDim2.new(0,0,0,16)
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Text = "Loading..."
GameNameLabel.TextColor3 = Theme.Text
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.TextSize = 13
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
GameNameLabel.Parent = GamePage
local NotAddedLabel = Instance.new("TextLabel")
NotAddedLabel.Size = UDim2.new(1,0,0,34)
NotAddedLabel.Position = UDim2.new(0,0,0,46)
NotAddedLabel.BackgroundColor3 = Theme.Button
NotAddedLabel.Text = "Game Not Added Yet!"
NotAddedLabel.TextColor3 = Theme.TextDim
NotAddedLabel.Font = Enum.Font.GothamMedium
NotAddedLabel.TextSize = 12
NotAddedLabel.Visible = true
NotAddedLabel.Parent = GamePage
Instance.new("UICorner", NotAddedLabel).CornerRadius = UDim.new(0,6)
local FeaturesFrame = Instance.new("ScrollingFrame")
FeaturesFrame.Size = UDim2.new(1,0,1,-48)
FeaturesFrame.Position = UDim2.new(0,0,0,46)
FeaturesFrame.BackgroundTransparency = 1
FeaturesFrame.BorderSizePixel = 0
FeaturesFrame.ScrollBarThickness = 3
FeaturesFrame.ScrollBarImageColor3 = Theme.AccentDim
FeaturesFrame.CanvasSize = UDim2.new(0,0,0,0)
FeaturesFrame.Visible = false
FeaturesFrame.Parent = GamePage
local function clearFeatures()
	for _,c in ipairs(FeaturesFrame:GetChildren()) do c:Destroy() end
end

local function buildGame1Features()
	clearFeatures()
	createSection(FeaturesFrame,"World 1",0)
	createToggle(FeaturesFrame,"Auto Farm Wins",22,function(V)
		getgenv().farm1=V
		while getgenv().farm1 do task.wait()
			local c=player.Character
			if c and c:FindFirstChild("HumanoidRootPart") then c:MoveTo(Vector3.new(114.85,12.78,9503.41)) end
		end
	end)
	createButton(FeaturesFrame,"TP To World 2",58,function()
		local c=player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c:MoveTo(Vector3.new(-5377,-88,-5)) end
	end)
	createSection(FeaturesFrame,"World 2",98)
	createToggle(FeaturesFrame,"Auto Farm Wins",120,function(V)
		getgenv().farm2=V
		while getgenv().farm2 do task.wait()
			local c=player.Character
			if c and c:FindFirstChild("HumanoidRootPart") then c:MoveTo(Vector3.new(-5380.61,261.45,13183.42)) end
		end
	end)
	createButton(FeaturesFrame,"TP To World 1",156,function()
		local c=player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c:MoveTo(Vector3.new(118,14,-8)) end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0,0,0,200)
end

local function buildGame2Features()
	clearFeatures()
	createSection(FeaturesFrame,"World 1",0)
	createToggle(FeaturesFrame,"Auto Farm",22,function(V)
		getgenv().g2_w1=V
		while getgenv().g2_w1 do task.wait(0.15)
			local ok,p=pcall(function() return workspace.SectionAwardParts:GetChildren()[11] end)
			if ok and p then fireTouch(p) end
		end
	end)
	createSection(FeaturesFrame,"World 2",60)
	createToggle(FeaturesFrame,"Auto Farm",82,function(V)
		getgenv().g2_w2=V
		while getgenv().g2_w2 do task.wait(0.15)
			local ok,p=pcall(function() return workspace.SectionAwardParts.World2:GetChildren()[10] end)
			if ok and p then fireTouch(p) end
		end
	end)
	createSection(FeaturesFrame,"World 3",120)
	createToggle(FeaturesFrame,"Auto Farm",142,function(V)
		getgenv().g2_w3=V
		while getgenv().g2_w3 do task.wait(0.15)
			pcall(function()
				local w3=workspace:FindFirstChild("World3")
				if not w3 then return end
				for _,c in ipairs(w3:GetChildren()) do
					if c:FindFirstChildOfClass("TouchTransmitter") or c:FindFirstChild("TouchInterest") then fireTouch(c) end
				end
			end)
		end
	end)
	createSection(FeaturesFrame,"TP World Area",180)
	createButton(FeaturesFrame,"World 1",202,function()
		local c=player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c:MoveTo(Vector3.new(1109,670,-401)) end
	end)
	createButton(FeaturesFrame,"World 2",238,function()
		local c=player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c:MoveTo(Vector3.new(-1755,670,-413)) end
	end)
	createButton(FeaturesFrame,"World 3",274,function()
		local c=player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c:MoveTo(Vector3.new(-3026,670,-413)) end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0,0,0,320)
end

local function buildGame3Features()
	clearFeatures()
	createSection(FeaturesFrame,"Farming",0)
	createToggle(FeaturesFrame,"Auto Farm Wins",22,function(V)
		getgenv().g3_farm=V
		while getgenv().g3_farm do task.wait(0.1)
			pcall(function()
				local b=workspace.WinCollectors.Stage25.Button:GetChildren()[8]
				if b then fireTouch(b) end
			end)
		end
	end)
	createToggle(FeaturesFrame,"Auto Swing",58,function(V)
		getgenv().g3_swing=V
		while getgenv().g3_swing do task.wait(0.1)
			pcall(function() game:GetService("ReplicatedStorage").Remotes.SwingRequest:FireServer() end)
		end
	end)
	createSection(FeaturesFrame,"Rebirth",98)
	createToggle(FeaturesFrame,"Auto Rebirth",120,function(V)
		getgenv().g3_rebirth=V
		while getgenv().g3_rebirth do task.wait(0.5)
			pcall(function() game:GetService("ReplicatedStorage").Remotes.RebirthRequest:FireServer() end)
		end
	end)
	createSection(FeaturesFrame,"Eggs",160)
	local buyBtn=Instance.new("TextButton")
	buyBtn.Size=UDim2.new(1,0,0,30)
	buyBtn.Position=UDim2.new(0,0,0,182)
	buyBtn.BackgroundColor3=Theme.AccentDim
	buyBtn.Text="Buy Egg"
	buyBtn.TextColor3=Theme.Text
	buyBtn.Font=Enum.Font.GothamMedium
	buyBtn.TextSize=12
	buyBtn.Parent=FeaturesFrame
	Instance.new("UICorner",buyBtn).CornerRadius=UDim.new(0,6)
	makeSatisfying(buyBtn,Theme.AccentDim,Theme.Accent,Color3.fromRGB(0,100,40))
	local openEggBtn=Instance.new("TextButton")
	openEggBtn.Size=UDim2.new(1,0,0,30)
	openEggBtn.Position=UDim2.new(0,0,0,218)
	openEggBtn.BackgroundColor3=Theme.Button
	openEggBtn.Text="Open Egg"
	openEggBtn.TextColor3=Theme.Text
	openEggBtn.Font=Enum.Font.GothamMedium
	openEggBtn.TextSize=12
	openEggBtn.Parent=FeaturesFrame
	Instance.new("UICorner",openEggBtn).CornerRadius=UDim.new(0,6)
	makeSatisfying(openEggBtn,Theme.Button,Theme.ButtonHover,Color3.fromRGB(18,18,18))
	buyBtn.MouseButton1Click:Connect(function()
		pcall(function() game:GetService("ReplicatedStorage").Remotes.EggEvents:FireServer("PurchaseEgg","BasicEgg",1) end)
	end)
	openEggBtn.MouseButton1Click:Connect(function()
		pcall(function() game:GetService("ReplicatedStorage").Remotes.EggEvents:FireServer("OpenEgg","BasicEgg",1) end)
	end)
	FeaturesFrame.CanvasSize=UDim2.new(0,0,0,260)
end

local GameListPage = Instance.new("Frame")
GameListPage.Size = UDim2.new(1,0,1,0)
GameListPage.BackgroundTransparency = 1
GameListPage.Visible = false
GameListPage.Parent = Content
local GameListTitle = Instance.new("TextLabel")
GameListTitle.Size = UDim2.new(1,0,0,16)
GameListTitle.BackgroundTransparency = 1
GameListTitle.Text = "Games (click to join)"
GameListTitle.TextColor3 = Theme.TextDim
GameListTitle.Font = Enum.Font.Gotham
GameListTitle.TextSize = 11
GameListTitle.TextXAlignment = Enum.TextXAlignment.Left
GameListTitle.Parent = GameListPage
local GameListScroll = Instance.new("ScrollingFrame")
GameListScroll.Size = UDim2.new(1,0,1,-22)
GameListScroll.Position = UDim2.new(0,0,0,20)
GameListScroll.BackgroundTransparency = 1
GameListScroll.BorderSizePixel = 0
GameListScroll.ScrollBarThickness = 3
GameListScroll.ScrollBarImageColor3 = Theme.AccentDim
GameListScroll.CanvasSize = UDim2.new(0,0,0,0)
GameListScroll.Parent = GameListPage
local listLayout = Instance.new("UIListLayout", GameListScroll)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,6)
local SupportedPlaceIds = {75626443136851,108775830475023,84757653274750}
local function createGameEntry(placeId, gameName)
	local entry = Instance.new("TextButton")
	entry.Size = UDim2.new(1,-2,0,36)
	entry.BackgroundColor3 = Theme.Button
	entry.Text = ""
	entry.AutoButtonColor = false
	entry.Parent = GameListScroll
	Instance.new("UICorner", entry).CornerRadius = UDim.new(0,6)
	local nl = Instance.new("TextLabel")
	nl.Size = UDim2.new(1,-12,1,0)
	nl.Position = UDim2.new(0,10,0,0)
	nl.BackgroundTransparency = 1
	nl.Text = gameName
	nl.TextColor3 = Theme.Text
	nl.Font = Enum.Font.GothamMedium
	nl.TextSize = 12
	nl.TextXAlignment = Enum.TextXAlignment.Left
	nl.TextTruncate = Enum.TextTruncate.AtEnd
	nl.Parent = entry
	makeSatisfying(entry, Theme.Button, Theme.ButtonHover, Color3.fromRGB(18,18,18))
	entry.MouseButton1Click:Connect(function()
		nl.Text = "Teleporting..."
		pcall(function() TeleportService:Teleport(placeId, player) end)
	end)
end
task.spawn(function()
	for _,pid in ipairs(SupportedPlaceIds) do
		local name = "Place "..tostring(pid)
		local ok,info = pcall(function() return MarketplaceService:GetProductInfo(pid) end)
		if ok and info and info.Name then name = info.Name end
		createGameEntry(pid, name)
	end
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		GameListScroll.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+8)
	end)
	GameListScroll.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+8)
end)

local MiscPage = Instance.new("Frame")
MiscPage.Size = UDim2.new(1,0,1,0)
MiscPage.BackgroundTransparency = 1
MiscPage.Visible = false
MiscPage.Parent = Content
local MiscTitle = Instance.new("TextLabel")
MiscTitle.Size = UDim2.new(1,0,0,16)
MiscTitle.BackgroundTransparency = 1
MiscTitle.Text = "WalkSpeed"
MiscTitle.TextColor3 = Theme.TextDim
MiscTitle.Font = Enum.Font.Gotham
MiscTitle.TextSize = 11
MiscTitle.TextXAlignment = Enum.TextXAlignment.Left
MiscTitle.Parent = MiscPage
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1,0,0,22)
SpeedLabel.Position = UDim2.new(0,0,0,18)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Current: 16"
SpeedLabel.TextColor3 = Theme.Accent
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MiscPage
local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(1,0,0,32)
SpeedInput.Position = UDim2.new(0,0,0,44)
SpeedInput.BackgroundColor3 = Theme.Button
SpeedInput.Text = "16"
SpeedInput.PlaceholderText = "1 - 500"
SpeedInput.TextColor3 = Theme.Text
SpeedInput.PlaceholderColor3 = Theme.TextDim
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.TextSize = 13
SpeedInput.ClearTextOnFocus = false
SpeedInput.Parent = MiscPage
Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0,6)
local function setWalkSpeed(speed)
	speed = math.clamp(tonumber(speed) or 16, 1, 500)
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = speed end
	end
	SpeedLabel.Text = "Current: "..tostring(speed)
	SpeedInput.Text = tostring(speed)
end
createToggle(MiscPage, "Apply WalkSpeed", 84, function(V)
	getgenv().wsLoop = V
	while getgenv().wsLoop do setWalkSpeed(SpeedInput.Text) task.wait(0.1) end
end)
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(1,0,0,28)
ResetBtn.Position = UDim2.new(0,0,0,122)
ResetBtn.BackgroundColor3 = Theme.Button
ResetBtn.Text = "Reset to 16"
ResetBtn.TextColor3 = Theme.TextDim
ResetBtn.Font = Enum.Font.Gotham
ResetBtn.TextSize = 12
ResetBtn.Parent = MiscPage
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0,6)
makeSatisfying(ResetBtn, Theme.Button, Theme.ButtonHover, Color3.fromRGB(18,18,18))
ResetBtn.MouseButton1Click:Connect(function() getgenv().wsLoop=false setWalkSpeed(16) end)
SpeedInput.FocusLost:Connect(function(e) if e then setWalkSpeed(SpeedInput.Text) end end)
createSection(MiscPage, "Movement", 160)
createToggle(MiscPage, "Inf Jump", 182, function(V) getgenv().infJump = V end)
UserInputService.JumpRequest:Connect(function()
	if getgenv().infJump then
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end
end)

-- ACCOUNTS only Eyfanboy09
local AccountsPage = nil
if IS_OWNER then
	AccountsPage = Instance.new("Frame")
	AccountsPage.Size = UDim2.new(1,0,1,0)
	AccountsPage.BackgroundTransparency = 1
	AccountsPage.Visible = false
	AccountsPage.Parent = Content

	local AccTitle = Instance.new("TextLabel")
	AccTitle.Size = UDim2.new(1,0,0,16)
	AccTitle.BackgroundTransparency = 1
	AccTitle.Text = "Accounts (owner only)"
	AccTitle.TextColor3 = Theme.TextDim
	AccTitle.Font = Enum.Font.Gotham
	AccTitle.TextSize = 11
	AccTitle.TextXAlignment = Enum.TextXAlignment.Left
	AccTitle.Parent = AccountsPage

	local AccNameLabel = Instance.new("TextLabel")
	AccNameLabel.Size = UDim2.new(1,0,0,14)
	AccNameLabel.Position = UDim2.new(0,0,0,20)
	AccNameLabel.BackgroundTransparency = 1
	AccNameLabel.Text = "Account Name"
	AccNameLabel.TextColor3 = Theme.TextDim
	AccNameLabel.Font = Enum.Font.GothamMedium
	AccNameLabel.TextSize = 11
	AccNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	AccNameLabel.Parent = AccountsPage

	local AccNameBox = Instance.new("TextBox")
	AccNameBox.Size = UDim2.new(1,0,0,30)
	AccNameBox.Position = UDim2.new(0,0,0,36)
	AccNameBox.BackgroundColor3 = Theme.Button
	AccNameBox.Text = player.Name
	AccNameBox.PlaceholderText = "Account name..."
	AccNameBox.TextColor3 = Theme.Text
	AccNameBox.PlaceholderColor3 = Theme.TextDim
	AccNameBox.Font = Enum.Font.Gotham
	AccNameBox.TextSize = 12
	AccNameBox.ClearTextOnFocus = false
	AccNameBox.Parent = AccountsPage
	Instance.new("UICorner", AccNameBox).CornerRadius = UDim.new(0,6)

	local AccPassLabel = Instance.new("TextLabel")
	AccPassLabel.Size = UDim2.new(1,0,0,14)
	AccPassLabel.Position = UDim2.new(0,0,0,72)
	AccPassLabel.BackgroundTransparency = 1
	AccPassLabel.Text = "Password"
	AccPassLabel.TextColor3 = Theme.TextDim
	AccPassLabel.Font = Enum.Font.GothamMedium
	AccPassLabel.TextSize = 11
	AccPassLabel.TextXAlignment = Enum.TextXAlignment.Left
	AccPassLabel.Parent = AccountsPage

	local AccPassBox = Instance.new("TextBox")
	AccPassBox.Size = UDim2.new(1, -68, 0, 30)
	AccPassBox.Position = UDim2.new(0,0,0,88)
	AccPassBox.BackgroundColor3 = Theme.Button
	AccPassBox.Text = ""
	AccPassBox.PlaceholderText = "Password..."
	AccPassBox.TextColor3 = Theme.Text
	AccPassBox.PlaceholderColor3 = Theme.TextDim
	AccPassBox.Font = Enum.Font.Gotham
	AccPassBox.TextSize = 12
	AccPassBox.ClearTextOnFocus = false
	AccPassBox.Parent = AccountsPage
	Instance.new("UICorner", AccPassBox).CornerRadius = UDim.new(0,6)

	local CopyPassBtn = Instance.new("TextButton")
	CopyPassBtn.Size = UDim2.new(0, 62, 0, 30)
	CopyPassBtn.Position = UDim2.new(1, -62, 0, 88)
	CopyPassBtn.BackgroundColor3 = Color3.fromRGB(35, 55, 90)
	CopyPassBtn.Text = "Copy"
	CopyPassBtn.TextColor3 = Color3.fromRGB(180, 210, 255)
	CopyPassBtn.Font = Enum.Font.GothamMedium
	CopyPassBtn.TextSize = 12
	CopyPassBtn.Parent = AccountsPage
	Instance.new("UICorner", CopyPassBtn).CornerRadius = UDim.new(0,6)
	makeSatisfying(CopyPassBtn, Color3.fromRGB(35,55,90), Color3.fromRGB(50,75,120), Color3.fromRGB(25,40,70))
	CopyPassBtn.MouseButton1Click:Connect(function()
		local pass = AccPassBox.Text
		if pass == "" then
			CopyPassBtn.Text = "Empty"
			task.wait(0.6)
			CopyPassBtn.Text = "Copy"
			return
		end
		pcall(function() if setclipboard then setclipboard(pass) end end)
		CopyPassBtn.Text = "Copied!"
		playClick(0.45)
		task.wait(0.7)
		CopyPassBtn.Text = "Copy"
	end)

	local AccSaveBtn = Instance.new("TextButton")
	AccSaveBtn.Size = UDim2.new(1,0,0,28)
	AccSaveBtn.Position = UDim2.new(0,0,0,128)
	AccSaveBtn.BackgroundColor3 = Theme.AccentDim
	AccSaveBtn.Text = "Save Account"
	AccSaveBtn.TextColor3 = Theme.Text
	AccSaveBtn.Font = Enum.Font.GothamMedium
	AccSaveBtn.TextSize = 12
	AccSaveBtn.Parent = AccountsPage
	Instance.new("UICorner", AccSaveBtn).CornerRadius = UDim.new(0,6)
	makeSatisfying(AccSaveBtn, Theme.AccentDim, Theme.Accent, Color3.fromRGB(0,100,40))

	local AccStatus = Instance.new("TextLabel")
	AccStatus.Size = UDim2.new(1,0,0,14)
	AccStatus.Position = UDim2.new(0,0,0,160)
	AccStatus.BackgroundTransparency = 1
	AccStatus.Text = "Logged in as " .. player.Name
	AccStatus.TextColor3 = Theme.Accent
	AccStatus.Font = Enum.Font.Gotham
	AccStatus.TextSize = 11
	AccStatus.Parent = AccountsPage

	local AccListTitle = Instance.new("TextLabel")
	AccListTitle.Size = UDim2.new(1,0,0,14)
	AccListTitle.Position = UDim2.new(0,0,0,178)
	AccListTitle.BackgroundTransparency = 1
	AccListTitle.Text = "Saved / Executed Accounts"
	AccListTitle.TextColor3 = Theme.TextDim
	AccListTitle.Font = Enum.Font.Gotham
	AccListTitle.TextSize = 11
	AccListTitle.TextXAlignment = Enum.TextXAlignment.Left
	AccListTitle.Parent = AccountsPage

	local AccListScroll = Instance.new("ScrollingFrame")
	AccListScroll.Size = UDim2.new(1,0,0,66)
	AccListScroll.Position = UDim2.new(0,0,0,194)
	AccListScroll.BackgroundColor3 = Theme.Button
	AccListScroll.BorderSizePixel = 0
	AccListScroll.ScrollBarThickness = 3
	AccListScroll.ScrollBarImageColor3 = Theme.AccentDim
	AccListScroll.CanvasSize = UDim2.new(0,0,0,0)
	AccListScroll.Parent = AccountsPage
	Instance.new("UICorner", AccListScroll).CornerRadius = UDim.new(0,6)
	local accListLayout = Instance.new("UIListLayout", AccListScroll)
	accListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	accListLayout.Padding = UDim.new(0,2)

	local ACCOUNT_FILE = "plus1_accounts_list.txt"
	local function loadAccountList()
		local list = {}
		pcall(function()
			if isfile and isfile(ACCOUNT_FILE) and readfile then
				for line in readfile(ACCOUNT_FILE):gmatch("[^\r\n]+") do
					local name = line:match("^%s*(.-)%s*$")
					if name and name ~= "" then table.insert(list, name) end
				end
			end
		end)
		return list
	end
	local function saveAccountList(list)
		pcall(function()
			if writefile then writefile(ACCOUNT_FILE, table.concat(list, "\n")) end
		end)
	end
	local function refreshAccountListUI()
		for _,c in ipairs(AccListScroll:GetChildren()) do
			if c:IsA("TextLabel") then c:Destroy() end
		end
		local list = loadAccountList()
		for _, name in ipairs(list) do
			local row = Instance.new("TextLabel")
			row.Size = UDim2.new(1, -6, 0, 18)
			row.BackgroundTransparency = 1
			row.Text = "  " .. name
			row.TextColor3 = Theme.Text
			row.Font = Enum.Font.Gotham
			row.TextSize = 11
			row.TextXAlignment = Enum.TextXAlignment.Left
			row.Parent = AccListScroll
		end
		AccListScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 20)
	end
	local function addAccountToList(username)
		if not username or username == "" then return end
		local list = loadAccountList()
		for _,n in ipairs(list) do
			if n:lower() == username:lower() then refreshAccountListUI() return end
		end
		table.insert(list, username)
		saveAccountList(list)
		refreshAccountListUI()
	end
	addAccountToList(player.Name)
	AccSaveBtn.MouseButton1Click:Connect(function()
		local user = AccNameBox.Text
		local pass = AccPassBox.Text
		if user == "" then
			AccStatus.Text = "Enter an account name"
			AccStatus.TextColor3 = Color3.fromRGB(255,120,100)
			return
		end
		addAccountToList(user)
		getgenv().plus1_account = {user=user, pass=pass}
		pcall(function()
			if writefile then writefile("plus1_account.txt", user.."|"..(pass or "")) end
		end)
		AccStatus.Text = "Saved: " .. user
		AccStatus.TextColor3 = Theme.Accent
		playClick(0.45)
	end)
end

local function switchTab(selected)
	GamePage.Visible = (selected=="Game")
	GameListPage.Visible = (selected=="Game List")
	MiscPage.Visible = (selected=="Misc")
	if AccountsPage then AccountsPage.Visible = (selected=="Accounts") end
	local tabs = {["Game"]=GameTab,["Game List"]=GameListTab,["Misc"]=MiscTab}
	if AccountsTab then tabs["Accounts"] = AccountsTab end
	for name,tab in pairs(tabs) do
		if name==selected then
			tab.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
			tab.TextColor3 = Theme.Accent
		else
			tab.BackgroundColor3 = Theme.Button
			tab.TextColor3 = Theme.TextDim
		end
	end
end
GameTab.MouseButton1Click:Connect(function() switchTab("Game") end)
GameListTab.MouseButton1Click:Connect(function() switchTab("Game List") end)
MiscTab.MouseButton1Click:Connect(function() switchTab("Misc") end)
if AccountsTab then
	AccountsTab.MouseButton1Click:Connect(function() switchTab("Accounts") end)
end

local SUPPORTED = {
	[75626443136851]=buildGame1Features,
	[108775830475023]=buildGame2Features,
	[84757653274750]=buildGame3Features,
}
local ok,info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
if ok and info then GameNameLabel.Text=info.Name else GameNameLabel.Text="Unknown Game" end
if SUPPORTED[game.PlaceId] then
	NotAddedLabel.Visible=false; FeaturesFrame.Visible=true; SUPPORTED[game.PlaceId]()
else
	NotAddedLabel.Visible=true; FeaturesFrame.Visible=false
end

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true; dragStart=input.Position; startPos=Main.Position
	end
end)
TitleBar.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
		local d=input.Position-dragStart
		Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)
switchTab("Game")

-- KEY + SPOT THE DIFFERENCE
local MASTER_KEY = "1mth3b3st"
local KEY_DURATION = 24*60*60
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
			if k and e then key,expire = k, tonumber(e) end
		end
	end)
	return key, expire
end
local function isSessionUnlocked()
	if getgenv().plus1_unlocked then return true end
	local key, expire = loadKeyData()
	if key == MASTER_KEY then return true end
	if key and expire and os.time() <= expire then return true end
	return false
end
local function genKey()
	local chars="ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local out=""
	for i=1,9 do local idx=math.random(1,#chars); out=out..chars:sub(idx,idx) end
	return out
end
local savedWS, savedJP = 16, 50
local function freezePlayer(on)
	local char=player.Character
	if not char then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	if on then
		savedWS,savedJP=hum.WalkSpeed,hum.JumpPower
		hum.WalkSpeed,hum.JumpPower,hum.JumpHeight=0,0,0
	else
		hum.WalkSpeed=savedWS or 16
		hum.JumpPower=savedJP or 50
	end
end

local Auth = Instance.new("Frame")
Auth.Size = UDim2.new(1,0,1,0)
Auth.BackgroundColor3 = Color3.fromRGB(8,8,8)
Auth.BackgroundTransparency = 0.15
Auth.ZIndex = 50
Auth.Parent = ScreenGui
local AuthRain = Instance.new("Frame")
AuthRain.Size = UDim2.new(1,0,1,0)
AuthRain.BackgroundTransparency = 1
AuthRain.ZIndex = 50
AuthRain.ClipsDescendants = true
AuthRain.Parent = Auth
task.spawn(function()
	while AuthRain and AuthRain.Parent do spawnDigit(AuthRain) task.wait(math.random(12,24)/100) end
end)

local AuthCard = Instance.new("Frame")
AuthCard.Size = UDim2.new(0,300,0,280)
AuthCard.Position = UDim2.new(0.5,-150,0.5,-140)
AuthCard.BackgroundColor3 = Theme.Bg
AuthCard.BorderSizePixel = 0
AuthCard.ZIndex = 55
AuthCard.ClipsDescendants = true
AuthCard.Parent = Auth
Instance.new("UICorner", AuthCard).CornerRadius = UDim.new(0,12)
local acs = Instance.new("UIStroke", AuthCard)
acs.Color = Theme.Accent
acs.Thickness = 1.5
acs.Transparency = 0.4

local LoadPage = Instance.new("Frame")
LoadPage.Size = UDim2.new(1,0,1,0)
LoadPage.BackgroundTransparency = 1
LoadPage.ZIndex = 56
LoadPage.Parent = AuthCard
local function mkL(parent,text,y,size,color,bold)
	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,-20,0,size+6)
	l.Position=UDim2.new(0,10,0,y)
	l.BackgroundTransparency=1
	l.Text=text
	l.TextColor3=color
	l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
	l.TextSize=size
	l.ZIndex=57
	l.Parent=parent
	return l
end
mkL(LoadPage,"+1 Scripts",36,20,Theme.Accent,true)
local LoadSub=mkL(LoadPage,"Initializing...",66,12,Theme.TextDim,false)
local BarBg=Instance.new("Frame")
BarBg.Size=UDim2.new(1,-40,0,8)
BarBg.Position=UDim2.new(0,20,0,140)
BarBg.BackgroundColor3=Theme.Button
BarBg.BorderSizePixel=0
BarBg.ZIndex=57
BarBg.Parent=LoadPage
Instance.new("UICorner",BarBg).CornerRadius=UDim.new(1,0)
local BarFill=Instance.new("Frame")
BarFill.Size=UDim2.new(0,0,1,0)
BarFill.BackgroundColor3=Theme.Accent
BarFill.BorderSizePixel=0
BarFill.ZIndex=58
BarFill.Parent=BarBg
Instance.new("UICorner",BarFill).CornerRadius=UDim.new(1,0)
local LoadPct=mkL(LoadPage,"0%",158,11,Theme.TextDim,false)

local KeyPage=Instance.new("Frame")
KeyPage.Size=UDim2.new(1,0,1,0)
KeyPage.BackgroundTransparency=1
KeyPage.Visible=false
KeyPage.ZIndex=56
KeyPage.Parent=AuthCard
mkL(KeyPage,"Key System",16,16,Theme.Accent,true)
mkL(KeyPage,"Enter key. Earned keys expire in 24h.\nSpecial key always works.",42,11,Theme.TextDim,false)
local KeyBox=Instance.new("TextBox")
KeyBox.Size=UDim2.new(1,-28,0,34)
KeyBox.Position=UDim2.new(0,14,0,95)
KeyBox.BackgroundColor3=Theme.Button
KeyBox.Text=""
KeyBox.PlaceholderText="Enter key..."
KeyBox.TextColor3=Theme.Text
KeyBox.PlaceholderColor3=Theme.TextDim
KeyBox.Font=Enum.Font.Gotham
KeyBox.TextSize=13
KeyBox.ClearTextOnFocus=false
KeyBox.ZIndex=57
KeyBox.Parent=KeyPage
Instance.new("UICorner",KeyBox).CornerRadius=UDim.new(0,8)
local StatusLbl=mkL(KeyPage,"",136,11,Color3.fromRGB(255,120,100),false)
local SubmitBtn=Instance.new("TextButton")
SubmitBtn.Size=UDim2.new(1,-28,0,34)
SubmitBtn.Position=UDim2.new(0,14,0,160)
SubmitBtn.BackgroundColor3=Theme.AccentDim
SubmitBtn.Text="Unlock"
SubmitBtn.TextColor3=Theme.Text
SubmitBtn.Font=Enum.Font.GothamMedium
SubmitBtn.TextSize=13
SubmitBtn.ZIndex=57
SubmitBtn.Parent=KeyPage
Instance.new("UICorner",SubmitBtn).CornerRadius=UDim.new(0,8)
makeSatisfying(SubmitBtn,Theme.AccentDim,Theme.Accent,Color3.fromRGB(0,100,40))
local GetKeyBtn=Instance.new("TextButton")
GetKeyBtn.Size=UDim2.new(1,-28,0,32)
GetKeyBtn.Position=UDim2.new(0,14,0,202)
GetKeyBtn.BackgroundColor3=Theme.Button
GetKeyBtn.Text="Get Key"
GetKeyBtn.TextColor3=Theme.TextDim
GetKeyBtn.Font=Enum.Font.Gotham
GetKeyBtn.TextSize=12
GetKeyBtn.ZIndex=57
GetKeyBtn.Parent=KeyPage
Instance.new("UICorner",GetKeyBtn).CornerRadius=UDim.new(0,8)
makeSatisfying(GetKeyBtn,Theme.Button,Theme.ButtonHover,Color3.fromRGB(18,18,18))

local RewardPage=Instance.new("Frame")
RewardPage.Size=UDim2.new(1,0,1,0)
RewardPage.BackgroundTransparency=1
RewardPage.Visible=false
RewardPage.ZIndex=56
RewardPage.Parent=AuthCard
mkL(RewardPage,"Key Earned!",22,16,Theme.Accent,true)
local RewKey=Instance.new("TextLabel")
RewKey.Size=UDim2.new(1,-28,0,38)
RewKey.Position=UDim2.new(0,14,0,64)
RewKey.BackgroundColor3=Theme.Button
RewKey.Text="XXXXXXXXX"
RewKey.TextColor3=Theme.Accent
RewKey.Font=Enum.Font.Code
RewKey.TextSize=18
RewKey.ZIndex=57
RewKey.Parent=RewardPage
Instance.new("UICorner",RewKey).CornerRadius=UDim.new(0,8)
local CopyBtn=Instance.new("TextButton")
CopyBtn.Size=UDim2.new(1,-28,0,34)
CopyBtn.Position=UDim2.new(0,14,0,118)
CopyBtn.BackgroundColor3=Theme.AccentDim
CopyBtn.Text="Copy Key"
CopyBtn.TextColor3=Theme.Text
CopyBtn.Font=Enum.Font.GothamMedium
CopyBtn.TextSize=13
CopyBtn.ZIndex=57
CopyBtn.Parent=RewardPage
Instance.new("UICorner",CopyBtn).CornerRadius=UDim.new(0,8)
makeSatisfying(CopyBtn,Theme.AccentDim,Theme.Accent,Color3.fromRGB(0,100,40))
local BackBtn=Instance.new("TextButton")
BackBtn.Size=UDim2.new(1,-28,0,32)
BackBtn.Position=UDim2.new(0,14,0,160)
BackBtn.BackgroundColor3=Theme.Button
BackBtn.Text="Back"
BackBtn.TextColor3=Theme.TextDim
BackBtn.Font=Enum.Font.Gotham
BackBtn.TextSize=12
BackBtn.ZIndex=57
BackBtn.Parent=RewardPage
Instance.new("UICorner",BackBtn).CornerRadius=UDim.new(0,8)
makeSatisfying(BackBtn,Theme.Button,Theme.ButtonHover,Color3.fromRGB(18,18,18))
local earnedKey=nil
CopyBtn.MouseButton1Click:Connect(function()
	if earnedKey then
		pcall(function() if setclipboard then setclipboard(earnedKey) end end)
		CopyBtn.Text="Copied!"; playClick(0.5); task.wait(0.8); CopyBtn.Text="Copy Key"
	end
end)
BackBtn.MouseButton1Click:Connect(function()
	RewardPage.Visible=false; KeyPage.Visible=true
	if earnedKey then KeyBox.Text=earnedKey end
end)

local TOTAL_LEVELS = 25
local SHAPES = {"●","■","▲","◆","★","✦","⬡","♥"}
local COLORS = {
	Color3.fromRGB(255,80,80), Color3.fromRGB(80,200,255), Color3.fromRGB(255,200,60),
	Color3.fromRGB(120,255,120), Color3.fromRGB(255,120,220), Color3.fromRGB(180,140,255),
	Color3.fromRGB(255,160,80), Color3.fromRGB(100,255,200),
}

local Mini = Instance.new("Frame")
Mini.Size = UDim2.new(1,0,1,0)
Mini.BackgroundColor3 = Color3.fromRGB(10,10,10)
Mini.Visible = false
Mini.ZIndex = 60
Mini.Parent = ScreenGui

local MiniTop = Instance.new("Frame")
MiniTop.Size = UDim2.new(1,0,0,46)
MiniTop.BackgroundColor3 = Theme.Bg2
MiniTop.BorderSizePixel = 0
MiniTop.ZIndex = 61
MiniTop.Parent = Mini

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(1,-170,0,20)
MiniTitle.Position = UDim2.new(0,12,0,4)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "Spot the Difference"
MiniTitle.TextColor3 = Theme.Accent
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
LevelLbl.TextColor3 = Theme.TextDim
LevelLbl.Font = Enum.Font.Gotham
LevelLbl.TextSize = 11
LevelLbl.TextXAlignment = Enum.TextXAlignment.Left
LevelLbl.ZIndex = 62
LevelLbl.Parent = MiniTop

local FoundBox = Instance.new("Frame")
FoundBox.Size = UDim2.new(0, 86, 0, 32)
FoundBox.Position = UDim2.new(1, -160, 0.5, -16)
FoundBox.BackgroundColor3 = Theme.Button
FoundBox.BorderSizePixel = 0
FoundBox.ZIndex = 62
FoundBox.Parent = MiniTop
Instance.new("UICorner", FoundBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", FoundBox).Color = Theme.AccentDim

local FoundLbl = Instance.new("TextLabel")
FoundLbl.Size = UDim2.new(1, -4, 1, 0)
FoundLbl.Position = UDim2.new(0, 2, 0, 0)
FoundLbl.BackgroundTransparency = 1
FoundLbl.Text = "Found 0 / 1"
FoundLbl.TextColor3 = Theme.Accent
FoundLbl.Font = Enum.Font.GothamBold
FoundLbl.TextSize = 12
FoundLbl.ZIndex = 63
FoundLbl.Parent = FoundBox

local ExitMini = Instance.new("TextButton")
ExitMini.Size = UDim2.new(0, 58, 0, 26)
ExitMini.Position = UDim2.new(1, -68, 0.5, -13)
ExitMini.BackgroundColor3 = Theme.Danger
ExitMini.Text = "Exit"
ExitMini.TextColor3 = Theme.Text
ExitMini.Font = Enum.Font.GothamMedium
ExitMini.TextSize = 12
ExitMini.ZIndex = 62
ExitMini.Parent = MiniTop
Instance.new("UICorner", ExitMini).CornerRadius = UDim.new(0,6)
makeSatisfying(ExitMini, Theme.Danger, Color3.fromRGB(220,70,70), Color3.fromRGB(120,30,30))

local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0.48,-8,0,270)
LeftPanel.Position = UDim2.new(0,10,0,56)
LeftPanel.BackgroundColor3 = Theme.Button
LeftPanel.BorderSizePixel = 0
LeftPanel.ClipsDescendants = true
LeftPanel.ZIndex = 61
LeftPanel.Parent = Mini
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0,8)

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0.48,-8,0,270)
RightPanel.Position = UDim2.new(0.52,0,0,56)
RightPanel.BackgroundColor3 = Theme.Button
RightPanel.BorderSizePixel = 0
RightPanel.ClipsDescendants = true
RightPanel.ZIndex = 61
RightPanel.Parent = Mini
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0,8)

local LeftTag = Instance.new("TextLabel")
LeftTag.Size = UDim2.new(1,0,0,16)
LeftTag.BackgroundTransparency = 1
LeftTag.Text = "A"
LeftTag.TextColor3 = Theme.TextDim
LeftTag.Font = Enum.Font.GothamBold
LeftTag.TextSize = 11
LeftTag.ZIndex = 62
LeftTag.Parent = LeftPanel

local RightTag = Instance.new("TextLabel")
RightTag.Size = UDim2.new(1,0,0,16)
RightTag.BackgroundTransparency = 1
RightTag.Text = "B"
RightTag.TextColor3 = Theme.TextDim
RightTag.Font = Enum.Font.GothamBold
RightTag.TextSize = 11
RightTag.ZIndex = 62
RightTag.Parent = RightPanel

local HintLbl = Instance.new("TextLabel")
HintLbl.Size = UDim2.new(1,-20,0,18)
HintLbl.Position = UDim2.new(0,10,1,-26)
HintLbl.BackgroundTransparency = 1
HintLbl.Text = "Tap the difference on panel B"
HintLbl.TextColor3 = Theme.TextDim
HintLbl.Font = Enum.Font.Gotham
HintLbl.TextSize = 11
HintLbl.ZIndex = 62
HintLbl.Parent = Mini

local stdActive, currentLevel, foundCount, neededDiffs, diffButtons = false, 1, 0, 1, {}

local function updateFoundLabel()
	FoundLbl.Text = string.format("Found %d / %d", foundCount, neededDiffs)
	FoundLbl.TextColor3 = foundCount >= neededDiffs and Color3.fromRGB(255,220,80) or Theme.Accent
end

local function clearDiffs()
	for _,b in ipairs(diffButtons) do if b then b:Destroy() end end
	diffButtons = {}
	for _,c in ipairs(LeftPanel:GetChildren()) do
		if c:IsA("TextLabel") and c ~= LeftTag then c:Destroy() end
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _,c in ipairs(RightPanel:GetChildren()) do
		if c:IsA("TextLabel") and c ~= RightTag then c:Destroy() end
		if c:IsA("TextButton") then c:Destroy() end
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

local function endSTD(success)
	stdActive = false
	clearDiffs()
	freezePlayer(false)
	Mini.Visible = false
	if success then
		earnedKey = genKey()
		saveKeyData(earnedKey, os.time()+KEY_DURATION)
		RewKey.Text = earnedKey
		KeyPage.Visible = false
		RewardPage.Visible = true
		Auth.Visible = true
		playClick(0.55)
	else
		Auth.Visible = true
		KeyPage.Visible = true
	end
end

local function loadLevel(level)
	clearDiffs()
	currentLevel = level
	foundCount = 0
	local baseShapes = math.min(4 + math.floor((level-1)/3), 12)
	neededDiffs = math.min(1 + math.floor((level-1)/5), 4)
	local sizeMin = math.max(14, 28 - math.floor(level/3))
	local sizeMax = math.max(18, 36 - math.floor(level/4))
	LevelLbl.Text = string.format("Level %d / %d", level, TOTAL_LEVELS)
	updateFoundLabel()
	local shapes = {}
	for i = 1, baseShapes do
		shapes[i] = {
			shape = SHAPES[math.random(1,#SHAPES)],
			color = COLORS[math.random(1,#COLORS)],
			x = 0.12 + math.random()*0.76,
			y = 0.18 + math.random()*0.70,
			size = math.random(sizeMin, sizeMax),
		}
	end
	for _,s in ipairs(shapes) do
		placeShape(LeftPanel, s.shape, s.color, s.x, s.y, s.size)
		placeShape(RightPanel, s.shape, s.color, s.x, s.y, s.size)
	end
	for d = 1, neededDiffs do
		local sx = 0.15 + math.random()*0.7
		local sy = 0.2 + math.random()*0.65
		local sz = math.random(sizeMin, sizeMax)
		local sh = SHAPES[math.random(1,#SHAPES)]
		local col = COLORS[math.random(1,#COLORS)]
		placeShape(RightPanel, sh, col, sx, sy, sz)
		local hit = Instance.new("TextButton")
		hit.Size = UDim2.new(0, sz+12, 0, sz+12)
		hit.Position = UDim2.new(sx, -(sz+12)/2, sy, -(sz+12)/2)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = 63
		hit.Parent = RightPanel
		table.insert(diffButtons, hit)
	end
	for _,hit in ipairs(diffButtons) do
		hit.MouseButton1Click:Connect(function()
			if not stdActive or not hit.Parent or not hit.Active then return end
			foundCount = foundCount + 1
			updateFoundLabel()
			playClick(0.5)
			local mark = Instance.new("Frame")
			mark.Size = UDim2.new(1,0,1,0)
			mark.BackgroundColor3 = Theme.Accent
			mark.BackgroundTransparency = 0.5
			mark.BorderSizePixel = 0
			mark.ZIndex = 64
			mark.Parent = hit
			Instance.new("UICorner", mark).CornerRadius = UDim.new(1,0)
			hit.Active = false
			if foundCount >= neededDiffs then
				if currentLevel >= TOTAL_LEVELS then
					task.wait(0.4)
					endSTD(true)
				else
					task.wait(0.35)
					loadLevel(currentLevel + 1)
				end
			end
		end)
	end
end

local function startSTD()
	Auth.Visible = false
	Mini.Visible = true
	stdActive = true
	freezePlayer(true)
	loadLevel(1)
end

ExitMini.MouseButton1Click:Connect(function() endSTD(false) end)
GetKeyBtn.MouseButton1Click:Connect(function() startSTD() end)

local function unlockHub()
	getgenv().plus1_unlocked = true
	Auth.Visible = false
	Mini.Visible = false
	Main.Visible = true
	playClick(0.5)
end

SubmitBtn.MouseButton1Click:Connect(function()
	local entered = KeyBox.Text:gsub("%s+","")
	if entered == "" then
		StatusLbl.Text = "Please enter a key"
		StatusLbl.TextColor3 = Color3.fromRGB(255,140,100)
		return
	end
	if entered == MASTER_KEY then
		saveKeyData(MASTER_KEY, os.time()+KEY_DURATION)
		StatusLbl.Text = "Welcome! Special key accepted"
		StatusLbl.TextColor3 = Theme.Accent
		task.wait(0.35)
		unlockHub()
		return
	end
	local saved, expire = loadKeyData()
	if saved and entered == saved and expire and os.time() <= expire then
		StatusLbl.Text = "Key accepted"
		StatusLbl.TextColor3 = Theme.Accent
		task.wait(0.35)
		unlockHub()
		return
	end
	StatusLbl.Text = "Invalid or expired key"
	StatusLbl.TextColor3 = Color3.fromRGB(255,100,100)
	playClick(0.3)
end)

task.spawn(function()
	if isSessionUnlocked() then
		Auth.Visible = false
		Main.Visible = true
		return
	end
	local steps = {"Connecting...","Loading modules...","Checking environment...","Preparing UI...","Almost ready..."}
	for i=1,100 do
		BarFill.Size = UDim2.new(i/100,0,1,0)
		LoadPct.Text = i.."%"
		if i%20==0 then
			LoadSub.Text = steps[math.clamp(math.floor(i/20),1,#steps)]
			playClick(0.12)
		end
		task.wait(0.022)
	end
	LoadSub.Text = "Ready"
	task.wait(0.25)
	LoadPage.Visible = false
	KeyPage.Visible = true
	playClick(0.35)
end)
