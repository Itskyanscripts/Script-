--[[
  +1GamesScript FULL HUB
  Same GUI — Key system, minigames, home, request/view, game features
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end
local playerGui = player:WaitForChild("PlayerGui")

local OWNERS = {Eyfanboy09 = true, TheSledM = true}
local IS_OWNER = OWNERS[player.Name] == true

local ENV = _G
pcall(function()
	if getgenv then
		local g = getgenv()
		if type(g) == "table" then ENV = g end
	end
end)

pcall(function()
	if gethui then
		for _, g in ipairs(gethui():GetChildren()) do
			if g.Name == "Main1Gui" or g.Name == "plus1ScriptsGui" or g.Name == "Key system" then g:Destroy() end
		end
	end
end)
pcall(function()
	local cg = game:GetService("CoreGui")
	for _, g in ipairs(cg:GetChildren()) do
		if g.Name == "Main1Gui" or g.Name == "plus1ScriptsGui" or g.Name == "Key system" then g:Destroy() end
	end
end)

local function playClick()
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = "rbxassetid://6895079853"
		s.Volume = 0.35
		s.Parent = SoundService
		s:Play()
		game:GetService("Debris"):AddItem(s, 3)
	end)
end

local function notify(msg)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "+1GamesScript",
			Text = tostring(msg),
			Duration = 3,
		})
	end)
	print("[+1]", msg)
end

-- ========== KEY DATA ==========
local KEY_FILE = "plus1_key.txt"
local FREE_USE_FILE = "plus1_free_uses.txt"
local FREE_USED_BY_FILE = "plus1_free_used_by.txt"
local REQ_FILE = "plus1_requests.txt"
local FREE_KEY = "f0rfàn0nl6"
local FREE_MAX_USES = 20
local SESSION_MAX = 20 * 60

local VALID_KEYS = {
	["imth3b3st"] = {durationSec = 10 * 60, unlimited = true},
	["1mth3b3st"] = {durationSec = 10 * 60, unlimited = true},
	[FREE_KEY] = {durationSec = 24 * 60 * 60, free = true, maxUses = FREE_MAX_USES},
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
local function hasUsedFreeKey()
	local used = false
	pcall(function()
		if isfile and isfile(FREE_USED_BY_FILE) and readfile then
			local raw = readfile(FREE_USED_BY_FILE)
			if raw:find(tostring(player.UserId), 1, true) then used = true end
		end
	end)
	return used
end
local function markUsedFreeKey()
	pcall(function()
		local prev = ""
		if isfile and isfile(FREE_USED_BY_FILE) and readfile then prev = readfile(FREE_USED_BY_FILE) end
		if writefile then writefile(FREE_USED_BY_FILE, prev .. tostring(player.UserId) .. "\n") end
	end)
end
local function loadKeySaved()
	local data = nil
	pcall(function()
		if isfile and isfile(KEY_FILE) and readfile then
			local raw = readfile(KEY_FILE)
			local key, exp = raw:match("([^|]+)|(%d+)")
			if key and exp then data = {key = key, exp = tonumber(exp)} end
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
local function loadRequests()
	local list = {}
	pcall(function()
		if isfile and isfile(REQ_FILE) and readfile then
			for line in readfile(REQ_FILE):gmatch("[^\r\n]+") do
				local user, uid, msg = line:match("([^|]+)|([^|]+)|(.+)")
				if user and msg then
					table.insert(list, {user = user, uid = tonumber(uid) or 0, msg = msg})
				end
			end
		end
	end)
	return list
end
local function saveRequest(user, uid, msg)
	pcall(function()
		local prev = ""
		if isfile and isfile(REQ_FILE) and readfile then prev = readfile(REQ_FILE) end
		if writefile then
			writefile(REQ_FILE, prev .. user .. "|" .. tostring(uid) .. "|" .. msg:gsub("[\r\n]", " ") .. "\n")
		end
	end)
end

-- ========== SCREEN GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Main1Gui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
pcall(function()
	if gethui then ScreenGui.Parent = gethui()
	else ScreenGui.Parent = game:GetService("CoreGui") end
end)
if not ScreenGui.Parent then ScreenGui.Parent = playerGui end

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

-- ========== MAIN GUI (unchanged design) ==========
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "Openbutton"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 16, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(78, 74, 145)
OpenBtn.Image = "rbxthumb://type=Asset&id=73957617656173&w=420&h=420"
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local os1 = Instance.new("UIStroke", OpenBtn)
os1.Color = Color3.fromRGB(87, 92, 154)
os1.Thickness = 2

local Main = Instance.new("Frame")
Main.Name = "Mainplus1ScriptFrame"
Main.Size = UDim2.new(0, 311, 0, 190)
Main.Position = UDim2.new(0.5, -155, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
Main.BorderSizePixel = 0
Main.Visible = false -- gated by key
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

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

local Content = Instance.new("Frame")
Content.Name = "ButtonsFrame2"
Content.Size = UDim2.new(0, 206, 0, 148)
Content.Position = UDim2.new(0, 98, 0, 36)
Content.BackgroundColor3 = Color3.fromRGB(79, 74, 164)
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)
local cStroke = Instance.new("UIStroke", Content)
cStroke.Color = Color3.fromRGB(87, 92, 154)
cStroke.Thickness = 2

local NAV_ITEMS = {
	{Name = "Home", Icon = "rbxthumb://type=Asset&id=133664183496663&w=420&h=420", Y = 5},
	{Name = "Game", Icon = "rbxthumb://type=Asset&id=81689537841279&w=420&h=420", Y = 25},
	{Name = "Game List", Icon = "rbxthumb://type=Asset&id=94982886788563&w=420&h=420", Y = 45},
	{Name = "Settings", Icon = "rbxthumb://type=Asset&id=129581117627874&w=420&h=420", Y = 65},
	{Name = "Request", Icon = "rbxthumb://type=Asset&id=117881087490999&w=420&h=420", Y = 85},
	{Name = "View", Icon = "rbxthumb://type=Asset&id=131537678100350&w=420&h=420", Y = 105},
	{Name = "Owner", Icon = "rbxthumb://type=Asset&id=127421988740220&w=420&h=420", Y = 125},
}

local navButtons, navIcons = {}, {}
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
if not IS_OWNER then
	if navIcons["View"] then
		navIcons["View"].Image = "rbxthumb://type=Asset&id=113054079163682&w=420&h=420"
		navIcons["View"].ImageColor3 = Color3.fromRGB(255, 200, 80)
	end
	if navButtons["View"] then navButtons["View"].TextColor3 = Color3.fromRGB(180, 160, 100) end
end

local function makePage(name)
	local sc = Instance.new("ScrollingFrame")
	sc.Name = name .. "Page"
	sc.Size = UDim2.new(1, -8, 1, -8)
	sc.Position = UDim2.new(0, 4, 0, 4)
	sc.BackgroundTransparency = 1
	sc.BorderSizePixel = 0
	sc.ScrollBarThickness = 4
	sc.ScrollBarImageColor3 = Color3.fromRGB(150, 140, 220)
	sc.CanvasSize = UDim2.new(0, 0, 0, 0)
	sc.Visible = false
	sc.Parent = Content
	return sc
end

local pages = {}
pages.Home = makePage("Home")
pages.Game = makePage("Game")
pages["Game List"] = makePage("Game List")
pages.Settings = makePage("Settings")
pages.Request = makePage("Request")
pages.View = makePage("View")
pages.Owner = makePage("Owner")

local function switchPage(name)
	if name == "View" and not IS_OWNER then
		playClick()
		local b = navButtons["View"]
		if b then b.Text = "Locked" task.delay(0.8, function() if b then b.Text = "View" end end) end
		return
	end
	playClick()
	for n, p in pairs(pages) do p.Visible = (n == name) end
	for n, b in pairs(navButtons) do
		if n == "View" and not IS_OWNER then
			b.TextColor3 = Color3.fromRGB(180, 160, 100)
		else
			b.TextColor3 = (n == name) and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(255, 255, 255)
		end
	end
end
for name, btn in pairs(navButtons) do
	btn.MouseButton1Click:Connect(function() switchPage(name) end)
end

makeDraggable(TitleBar, Main)
makeDraggable(Main, Main)
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

local function createSection(parent, text, y)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -4, 0, 18)
	l.Position = UDim2.new(0, 2, 0, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.fromRGB(180, 220, 255)
	l.Font = Enum.Font.GothamBold
	l.TextSize = 11
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

local function createToggle(parent, name, y, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -4, 0, 26)
	row.Position = UDim2.new(0, 2, 0, y)
	row.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -40, 1, 0)
	lbl.Position = UDim2.new(0, 6, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = name
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	local on = false
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 28, 0, 16)
	toggle.Position = UDim2.new(1, -34, 0.5, -8)
	toggle.BackgroundColor3 = Color3.fromRGB(80, 70, 120)
	toggle.Text = ""
	toggle.Parent = row
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 12, 0, 12)
	circle.Position = UDim2.new(0, 2, 0.5, -6)
	circle.BackgroundColor3 = Color3.fromRGB(220, 220, 240)
	circle.Parent = toggle
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
	toggle.MouseButton1Click:Connect(function()
		playClick()
		on = not on
		toggle.BackgroundColor3 = on and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(80, 70, 120)
		circle.Position = on and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
		if callback then callback(on) end
	end)
	return row
end

local function createButton(parent, name, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -4, 0, 26)
	btn.Position = UDim2.new(0, 2, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function()
		playClick()
		if callback then callback() end
	end)
	return btn
end

print("[+1] GUI base loaded")

-- ========== HOME ==========
do
	local HomePage = pages.Home
	createSection(HomePage, "Movement", 0)
	local applyOn, currentSpeed = false, 16

	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(1, -4, 0, 14)
	speedLabel.Position = UDim2.new(0, 2, 0, 18)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "Speed Change Amount"
	speedLabel.TextColor3 = Color3.fromRGB(220, 210, 255)
	speedLabel.Font = Enum.Font.Gotham
	speedLabel.TextSize = 10
	speedLabel.TextXAlignment = Enum.TextXAlignment.Left
	speedLabel.Parent = HomePage

	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(0, 50, 0, 22)
	speedBox.Position = UDim2.new(1, -54, 0, 16)
	speedBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	speedBox.Text = "16"
	speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedBox.Font = Enum.Font.Gotham
	speedBox.TextSize = 11
	speedBox.ClearTextOnFocus = false
	speedBox.Parent = HomePage
	Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -4, 0, 8)
	track.Position = UDim2.new(0, 2, 0, 44)
	track.BackgroundColor3 = Color3.fromRGB(40, 35, 80)
	track.Parent = HomePage
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(16/100, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(120, 100, 220)
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(16/100, -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Text = ""
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local function setSpeedUI(n)
		n = math.clamp(math.floor(n), 1, 100)
		currentSpeed = n
		speedBox.Text = tostring(n)
		fill.Size = UDim2.new(n/100, 0, 1, 0)
		knob.Position = UDim2.new(n/100, -7, 0.5, -7)
		if applyOn then
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = n end
		end
	end
	speedBox.FocusLost:Connect(function()
		local n = tonumber(speedBox.Text)
		if n then setSpeedUI(n) end
	end)
	local sliding = false
	knob.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local rel = (i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
			setSpeedUI(rel * 100)
		end
	end)

	createToggle(HomePage, "Apply", 58, function(v)
		applyOn = v
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = v and currentSpeed or 16 end
	end)
	createToggle(HomePage, "Inf Jump", 88, function(v) ENV.infJump = v end)
	UserInputService.JumpRequest:Connect(function()
		if not ENV.infJump then return end
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end)

	-- ESP Users
	local espFolder = Instance.new("Folder")
	espFolder.Name = "Plus1ESP"
	espFolder.Parent = ScreenGui
	local function clearESP()
		for _, c in ipairs(espFolder:GetChildren()) do c:Destroy() end
	end
	local function applyESP()
		clearESP()
		if not ENV.espUsers then return end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local hl = Instance.new("Highlight")
					hl.Adornee = plr.Character
					hl.FillColor = Color3.fromRGB(255, 40, 40)
					hl.OutlineColor = Color3.fromRGB(255, 100, 100)
					hl.FillTransparency = 0.5
					hl.Parent = espFolder
					local bb = Instance.new("BillboardGui")
					bb.Size = UDim2.new(0, 120, 0, 30)
					bb.StudsOffset = Vector3.new(0, 3, 0)
					bb.AlwaysOnTop = true
					bb.Adornee = hrp
					bb.Parent = espFolder
					local t = Instance.new("TextLabel")
					t.Size = UDim2.new(1, 0, 1, 0)
					t.BackgroundTransparency = 1
					t.Text = plr.Name .. "\n[Client]"
					t.TextColor3 = Color3.fromRGB(255, 80, 80)
					t.TextSize = 10
					t.Font = Enum.Font.GothamBold
					t.Parent = bb
				end
			end
		end
	end
	createToggle(HomePage, "ESP Users", 118, function(v)
		ENV.espUsers = v
		if v then applyESP() else clearESP() end
	end)
	Players.PlayerAdded:Connect(function() if ENV.espUsers then task.wait(1) applyESP() end end)
	Players.PlayerRemoving:Connect(function() if ENV.espUsers then task.wait(0.2) applyESP() end end)

	-- Discord
	createSection(HomePage, "Discord", 150)
	local function copyText(text)
		local ok = false
		pcall(function()
			if setclipboard then setclipboard(text) ok = true
			elseif toclipboard then toclipboard(text) ok = true end
		end)
		return ok
	end
	local ICON_COPY = "rbxthumb://type=Asset&id=100254529812443&w=420&h=420"
	local ICON_CHECK = "rbxthumb://type=Asset&id=83343449436920&w=420&h=420"
	local discRow = Instance.new("Frame")
	discRow.Size = UDim2.new(1, -4, 0, 32)
	discRow.Position = UDim2.new(0, 2, 0, 170)
	discRow.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	discRow.Parent = HomePage
	Instance.new("UICorner", discRow).CornerRadius = UDim.new(0, 6)
	local discLbl = Instance.new("TextLabel")
	discLbl.Size = UDim2.new(1, -40, 1, 0)
	discLbl.Position = UDim2.new(0, 6, 0, 0)
	discLbl.BackgroundTransparency = 1
	discLbl.Text = "Discord Invite"
	discLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	discLbl.Font = Enum.Font.Gotham
	discLbl.TextSize = 11
	discLbl.TextXAlignment = Enum.TextXAlignment.Left
	discLbl.Parent = discRow
	local copyImg = Instance.new("ImageButton")
	copyImg.Size = UDim2.new(0, 26, 0, 26)
	copyImg.Position = UDim2.new(1, -30, 0.5, -13)
	copyImg.BackgroundColor3 = Color3.fromRGB(70, 65, 140)
	copyImg.Image = ICON_COPY
	copyImg.Parent = discRow
	Instance.new("UICorner", copyImg).CornerRadius = UDim.new(0, 6)
	copyImg.MouseButton1Click:Connect(function()
		playClick()
		if copyText("https://discord.gg/DvhPapJNm") then
			copyImg.Image = ICON_CHECK
			task.delay(1.5, function() if copyImg then copyImg.Image = ICON_COPY end end)
		end
	end)

	-- Verity Helper
	createSection(HomePage, "Helper", 210)
	createButton(HomePage, "Verity Helper", 232, function()
		playClick()
		if ENV.openVerity then ENV.openVerity() end
	end)
	HomePage.CanvasSize = UDim2.new(0, 0, 0, 280)
end

-- ========== VERITY HELPER (rainbow UI) ==========
do
	local VerityFrame = Instance.new("Frame")
	VerityFrame.Name = "VerityHelper"
	VerityFrame.Size = UDim2.new(0, 311, 0, 190)
	VerityFrame.Position = UDim2.new(0.5, -155, 0.5, -95)
	VerityFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
	VerityFrame.BorderSizePixel = 0
	VerityFrame.Visible = false
	VerityFrame.ZIndex = 90
	VerityFrame.Parent = ScreenGui
	Instance.new("UICorner", VerityFrame).CornerRadius = UDim.new(0, 8)
	local vGrad = Instance.new("UIGradient", VerityFrame)
	vGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
		ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 200, 60)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 140)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 160, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255)),
	})
	task.spawn(function()
		while VerityFrame.Parent do
			for i = 0, 360, 2 do
				if not VerityFrame.Parent then break end
				vGrad.Rotation = i
				task.wait(0.03)
			end
		end
	end)

	local vTitle = Instance.new("TextLabel")
	vTitle.Size = UDim2.new(1, -60, 0, 28)
	vTitle.Position = UDim2.new(0, 8, 0, 4)
	vTitle.BackgroundTransparency = 1
	vTitle.Text = "✦ Verity Helper"
	vTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	vTitle.Font = Enum.Font.GothamBold
	vTitle.TextSize = 14
	vTitle.TextXAlignment = Enum.TextXAlignment.Left
	vTitle.ZIndex = 91
	vTitle.Parent = VerityFrame

	local vClose = Instance.new("TextButton")
	vClose.Size = UDim2.new(0, 50, 0, 24)
	vClose.Position = UDim2.new(1, -56, 0, 6)
	vClose.BackgroundColor3 = Color3.fromRGB(40, 20, 50)
	vClose.Text = "Close"
	vClose.TextColor3 = Color3.fromRGB(255, 255, 255)
	vClose.TextSize = 11
	vClose.Font = Enum.Font.GothamBold
	vClose.ZIndex = 92
	vClose.Parent = VerityFrame
	Instance.new("UICorner", vClose).CornerRadius = UDim.new(0, 6)

	-- talking face
	local face = Instance.new("TextLabel")
	face.Size = UDim2.new(0, 50, 0, 40)
	face.Position = UDim2.new(0, 10, 0, 36)
	face.BackgroundTransparency = 1
	face.Text = "😊"
	face.TextSize = 32
	face.ZIndex = 91
	face.Parent = VerityFrame

	local reply = Instance.new("TextLabel")
	reply.Size = UDim2.new(1, -70, 0, 50)
	reply.Position = UDim2.new(0, 60, 0, 34)
	reply.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
	reply.BackgroundTransparency = 0.3
	reply.Text = "Hi! I'm Verity. Ask me anything (not about keys)."
	reply.TextColor3 = Color3.fromRGB(255, 255, 255)
	reply.Font = Enum.Font.Gotham
	reply.TextSize = 11
	reply.TextWrapped = true
	reply.TextXAlignment = Enum.TextXAlignment.Left
	reply.TextYAlignment = Enum.TextYAlignment.Top
	reply.ZIndex = 91
	reply.Parent = VerityFrame
	Instance.new("UICorner", reply).CornerRadius = UDim.new(0, 6)

	local askBox = Instance.new("TextBox")
	askBox.Size = UDim2.new(1, -70, 0, 28)
	askBox.Position = UDim2.new(0, 10, 0, 100)
	askBox.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
	askBox.PlaceholderText = "Ask Verity..."
	askBox.Text = ""
	askBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	askBox.Font = Enum.Font.Gotham
	askBox.TextSize = 11
	askBox.ClearTextOnFocus = false
	askBox.ZIndex = 91
	askBox.Parent = VerityFrame
	Instance.new("UICorner", askBox).CornerRadius = UDim.new(0, 6)

	local askBtn = Instance.new("TextButton")
	askBtn.Size = UDim2.new(0, 50, 0, 28)
	askBtn.Position = UDim2.new(1, -58, 0, 100)
	askBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
	askBtn.Text = "Ask"
	askBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	askBtn.TextSize = 12
	askBtn.Font = Enum.Font.GothamBold
	askBtn.ZIndex = 91
	askBtn.Parent = VerityFrame
	Instance.new("UICorner", askBtn).CornerRadius = UDim.new(0, 6)

	local talking = false
	local function verityTalk(text)
		reply.Text = text
		talking = true
		-- talking sound
		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = "rbxassetid://552272995" -- soft talk-ish
			s.Volume = 0.4
			s.Parent = SoundService
			s:Play()
			game:GetService("Debris"):AddItem(s, 3)
		end)
		-- face animation
		task.spawn(function()
			local faces = {"😊", "😃", "😄", "😁", "😊"}
			for i = 1, 8 do
				if not talking then break end
				face.Text = faces[((i - 1) % #faces) + 1]
				face.Rotation = (i % 2 == 0) and 6 or -6
				task.wait(0.12)
			end
			face.Text = "😊"
			face.Rotation = 0
			talking = false
		end)
	end

	local function answer(q)
		local low = string.lower(q or "")
		if low:find("key") or low:find("1mth") or low:find("imth") or low:find("f0rf") or low:find("password") or low:find("code") then
			return "I can't talk about keys or codes. Ask me something else!"
		end
		if low:find("hello") or low:find("hi") or low:find("hey") then
			return "Hello! I'm Verity, your helper. How can I help?"
		end
		if low:find("farm") or low:find("auto") then
			return "Open the Game tab for auto farm and TP buttons for this place."
		end
		if low:find("speed") or low:find("walk") then
			return "On Home, set Speed Change Amount and turn on Apply."
		end
		if low:find("discord") then
			return "Use the Discord Invite copy button on Home!"
		end
		if low:find("help") then
			return "I can help with the hub, games, and settings — just not keys."
		end
		if low:find("who") or low:find("verity") then
			return "I'm Verity Helper — a friendly guide for +1GamesScript!"
		end
		return "Hmm… try asking about farm, speed, discord, or the hub. (Not keys!)"
	end

	askBtn.MouseButton1Click:Connect(function()
		playClick()
		local q = askBox.Text
		if q == "" then return end
		verityTalk(answer(q))
		askBox.Text = ""
	end)

	local function openVerity()
		Main.Visible = false
		OpenBtn.Visible = false
		for _, n in ipairs({"KeyTimer", "Insert Key", "SpotTheDifference", "SliceAnimals"}) do
			local f = ScreenGui:FindFirstChild(n)
			if f then f.Visible = false end
		end
		-- also hide unnamed minigame frames by ZIndex search
		for _, c in ipairs(ScreenGui:GetChildren()) do
			if c:IsA("Frame") and c ~= Main and c ~= VerityFrame and c ~= OpenBtn then
				if c.ZIndex and c.ZIndex >= 50 and c.ZIndex < 90 then
					c.Visible = false
				end
			end
		end
		VerityFrame.Visible = true
		verityTalk("Hi! I'm Verity. Ask me anything (not about keys).")
	end
	local function closeVerity()
		playClick()
		VerityFrame.Visible = false
		if ENV.plus1_unlocked then
			Main.Visible = true
		else
			local ik = ScreenGui:FindFirstChild("Insert Key")
			if ik then ik.Visible = true end
		end
	end
	vClose.MouseButton1Click:Connect(closeVerity)
	ENV.openVerity = openVerity
	makeDraggable(vTitle, VerityFrame)
end

-- ========== SETTINGS ==========
do
	createSection(pages.Settings, "Settings", 0)
	createToggle(pages.Settings, "Auto Rejoin (when kicked)", 22, function(v)
		ENV.plus1_autorejoin = v
	end)
	pcall(function()
		local GuiService = game:GetService("GuiService")
		GuiService.ErrorMessageChanged:Connect(function()
			if ENV.plus1_autorejoin then
				task.wait(1)
				pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
			end
		end)
	end)
	pages.Settings.CanvasSize = UDim2.new(0, 0, 0, 60)
end

-- ========== REQUEST ==========
do
	local RequestPage = pages.Request
	createSection(RequestPage, "Request +1 Game", 0)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -4, 0, 40)
	box.Position = UDim2.new(0, 2, 0, 22)
	box.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	box.PlaceholderText = "Request +1 Game"
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.Gotham
	box.TextSize = 11
	box.TextWrapped = true
	box.ClearTextOnFocus = false
	box.Parent = RequestPage
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	createButton(RequestPage, "Send", 68, function()
		local msg = box.Text
		if msg == "" or msg == "Request +1 Game" then
			notify("Enter a game name")
			return
		end
		saveRequest(player.Name, player.UserId, msg)
		notify("Send")
		box.Text = ""
	end)
	RequestPage.CanvasSize = UDim2.new(0, 0, 0, 110)
end

-- ========== VIEW (owners) ==========
do
	local ViewPage = pages.View
	createSection(ViewPage, "Requests", 0)
	local function refreshView()
		for _, c in ipairs(ViewPage:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		local y = 22
		for _, r in ipairs(loadRequests()) do
			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, -4, 0, 44)
			card.Position = UDim2.new(0, 2, 0, y)
			card.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
			card.Parent = ViewPage
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
			local av = Instance.new("ImageLabel")
			av.Size = UDim2.new(0, 32, 0, 32)
			av.Position = UDim2.new(0, 4, 0.5, -16)
			av.BackgroundTransparency = 1
			av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(r.uid) .. "&w=48&h=48"
			av.Parent = card
			Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
			local nm = Instance.new("TextLabel")
			nm.Size = UDim2.new(1, -44, 0, 16)
			nm.Position = UDim2.new(0, 40, 0, 4)
			nm.BackgroundTransparency = 1
			nm.Text = r.user
			nm.TextColor3 = Color3.fromRGB(200, 255, 200)
			nm.Font = Enum.Font.GothamBold
			nm.TextSize = 10
			nm.TextXAlignment = Enum.TextXAlignment.Left
			nm.Parent = card
			local ms = Instance.new("TextLabel")
			ms.Size = UDim2.new(1, -44, 0, 18)
			ms.Position = UDim2.new(0, 40, 0, 20)
			ms.BackgroundTransparency = 1
			ms.Text = r.msg
			ms.TextColor3 = Color3.fromRGB(255, 255, 255)
			ms.Font = Enum.Font.Gotham
			ms.TextSize = 10
			ms.TextXAlignment = Enum.TextXAlignment.Left
			ms.TextTruncate = Enum.TextTruncate.AtEnd
			ms.Parent = card
			y = y + 48
		end
		ViewPage.CanvasSize = UDim2.new(0, 0, 0, math.max(y, 40))
	end
	if IS_OWNER then
		refreshView()
		task.spawn(function()
			while task.wait(5) do
				if pages.View.Visible then refreshView() end
			end
		end)
	else
		local tip = Instance.new("TextLabel")
		tip.Size = UDim2.new(1, -4, 0, 30)
		tip.Position = UDim2.new(0, 2, 0, 22)
		tip.BackgroundTransparency = 1
		tip.Text = "Owners only"
		tip.TextColor3 = Color3.fromRGB(255, 200, 100)
		tip.Font = Enum.Font.Gotham
		tip.TextSize = 11
		tip.Parent = ViewPage
	end
end

-- ========== OWNER ==========
do
	local OwnerPage = pages.Owner
	createSection(OwnerPage, "Owners", 0)
	local y = 22
	for _, userName in ipairs({"Eyfanboy09", "TheSledM"}) do
		local card = Instance.new("Frame")
		card.Size = UDim2.new(1, -4, 0, 44)
		card.Position = UDim2.new(0, 2, 0, y)
		card.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		card.Parent = OwnerPage
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 32, 0, 32)
		avatar.Position = UDim2.new(0, 6, 0.5, -16)
		avatar.BackgroundTransparency = 1
		avatar.Parent = card
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
		pcall(function()
			local id = Players:GetUserIdFromNameAsync(userName)
			avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. id .. "&w=48&h=48"
		end)
		local nm = Instance.new("TextLabel")
		nm.Size = UDim2.new(1, -48, 1, 0)
		nm.Position = UDim2.new(0, 44, 0, 0)
		nm.BackgroundTransparency = 1
		nm.Text = userName
		nm.TextColor3 = Color3.fromRGB(255, 255, 255)
		nm.Font = Enum.Font.GothamBold
		nm.TextSize = 12
		nm.TextXAlignment = Enum.TextXAlignment.Left
		nm.Parent = card
		y = y + 50
	end
	OwnerPage.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- ========== GAME FEATURES ==========
local GamePage = pages.Game
local FeaturesFrame = GamePage

local function clearChildren(f)
	for _, c in ipairs(f:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
end
local function clearFeatures() clearChildren(FeaturesFrame) end
local function createSectionF(text, y) return createSection(FeaturesFrame, text, y) end
local function createToggleF(name, y, cb) return createToggle(FeaturesFrame, name, y, cb) end
local function createButtonF(name, y, cb) return createButton(FeaturesFrame, name, y, cb) end

-- GAME 1 Bottle Flip
local function buildGame1Features()
	clearFeatures()
	createSectionF("World 1", 0)
	createToggleF("Auto Farm Wins", 22, function(v)
		ENV.farm1 = v
		while ENV.farm1 do task.wait()
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
		while ENV.farm2 do task.wait()
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

-- GAME 2 Moon Walk
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

-- GAME 3
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
	createToggleF("Auto Rebirth", 54, function(v)
		ENV.g3_rebirth = v
		while ENV.g3_rebirth do
			task.wait(0.5)
			pcall(function()
				game:GetService("ReplicatedStorage").Events.Rebirth:FireServer()
			end)
		end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
end

-- GAME 4
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
		pcall(function() game:GetService("ReplicatedStorage").Events.BuyTrail:FireServer(selected) end)
		task.wait(0.15)
		pcall(function() game:GetService("ReplicatedStorage").Events.EquipTrail:FireServer(selected) end)
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
			buyBtn.Position = UDim2.new(0, 2, 0, 318)
		end)
	end
	drop.MouseButton1Click:Connect(function()
		playClick()
		listF.Visible = not listF.Visible
		drop.Text = (listF.Visible and "▲  " or "▼  ") .. selected
		buyBtn.Position = UDim2.new(0, 2, 0, listF.Visible and (318 + #trailOpts * 24) or 318)
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 420)
end

-- GAME 5
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
	createSectionF("World 4", 168)
	createToggleF("Auto Farm Wins (World4)", 190, function(v)
		ENV.g5_f4 = v
		while ENV.g5_f4 do task.wait()
			pcall(function()
				local c = player.Character
				if c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = CFrame.new(1769.2, 5.47, 1221.01)
				end
			end)
		end
	end)
	createSectionF("Rebirth / Spin", 226)
	createToggleF("Auto Rebirth", 248, function(v)
		ENV.g5_rebirth = v
		while ENV.g5_rebirth do
			task.wait(0.5)
			pcall(function() game:GetService("ReplicatedStorage").Remotes.ConfirmAura:FireServer() end)
		end
	end)
	createToggleF("Auto Spin", 280, function(v)
		ENV.g5_spin = v
		while ENV.g5_spin do
			task.wait(0.5)
			pcall(function() game:GetService("ReplicatedStorage").Remotes.SpinAura:InvokeServer(false) end)
		end
	end)
	createSectionF("Trails", 316)
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
	drop.Position = UDim2.new(0, 2, 0, 338)
	drop.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	drop.Text = "▼  " .. selected.L
	drop.TextColor3 = Color3.fromRGB(255, 255, 255)
	drop.Font = Enum.Font.Gotham
	drop.TextSize = 11
	drop.Parent = FeaturesFrame
	Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)
	local listF = Instance.new("Frame")
	listF.Size = UDim2.new(1, -4, 0, #trailOpts * 24)
	listF.Position = UDim2.new(0, 2, 0, 366)
	listF.BackgroundColor3 = Color3.fromRGB(45, 40, 95)
	listF.Visible = false
	listF.ZIndex = 10
	listF.Parent = FeaturesFrame
	Instance.new("UICorner", listF).CornerRadius = UDim.new(0, 6)
	Instance.new("UIListLayout", listF)
	local buyBtn = createButtonF("Buy and Equip", 372, function()
		pcall(function() game:GetService("ReplicatedStorage").Remotes.BuyTrail:InvokeServer(selected.V) end)
		task.wait(0.15)
		pcall(function() game:GetService("ReplicatedStorage").Remotes.EquipTrail:FireServer(selected.V) end)
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
			buyBtn.Position = UDim2.new(0, 2, 0, 372)
		end)
	end
	drop.MouseButton1Click:Connect(function()
		playClick()
		listF.Visible = not listF.Visible
		drop.Text = (listF.Visible and "▲  " or "▼  ") .. selected.L
		buyBtn.Position = UDim2.new(0, 2, 0, listF.Visible and (372 + #trailOpts * 24) or 372)
	end)
	createSectionF("Teleport", 416)
	createButtonF("TP To World 1", 438, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(-5, 5, 177) end
	end)
	createButtonF("TP To World 2", 470, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(-5, 5, 510) end
	end)
	createButtonF("TP To World 3", 502, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(-5, 5, 868) end
	end)
	createButtonF("TP To World 4", 534, function()
		local c = player.Character
		if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(-5, 5, 1244) end
	end)
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 580)
end

-- How to add a game: put PlaceId + builder in SUPPORTED
local SUPPORTED = {
	[tonumber("75626443136851")] = buildGame1Features,
	[tonumber("108775830475023")] = buildGame2Features,
	[tonumber("84757653274750")] = buildGame3Features,
	[tonumber("78579721506911")] = buildGame4Features,
	[tonumber("82554996468034")] = buildGame5Features,
}

local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Size = UDim2.new(1, -4, 0, 16)
gameNameLabel.Position = UDim2.new(0, 2, 0, 0)
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.Text = "Game: ..."
gameNameLabel.TextColor3 = Color3.fromRGB(200, 190, 255)
gameNameLabel.Font = Enum.Font.GothamBold
gameNameLabel.TextSize = 10
gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
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
notAdded.Visible = false
notAdded.Parent = GamePage

if SUPPORTED[game.PlaceId] then
	notAdded.Visible = false
	pcall(SUPPORTED[game.PlaceId])
else
	notAdded.Visible = true
	createButton(GamePage, "Request Game!", 60, function()
		switchPage("Request")
	end)
	GamePage.CanvasSize = UDim2.new(0, 0, 0, 100)
end

-- ========== GAME LIST ==========
do
	local GameListPage = pages["Game List"]
	createSection(GameListPage, "Supported Games", 0)
	local y = 22
	for placeId, _ in pairs(SUPPORTED) do
		local entry = Instance.new("TextButton")
		entry.Size = UDim2.new(1, -4, 0, 32)
		entry.Position = UDim2.new(0, 2, 0, y)
		entry.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		entry.Text = ""
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
		nameL.Parent = entry
		task.spawn(function()
			pcall(function()
				local info = MarketplaceService:GetProductInfo(placeId)
				if info and nameL.Parent then nameL.Text = info.Name end
			end)
		end)
		entry.MouseButton1Click:Connect(function()
			playClick()
			pcall(function() TeleportService:Teleport(placeId, player) end)
		end)
		y = y + 36
	end
	GameListPage.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- ========== SETTINGS ==========
do
	createSection(pages.Settings, "Settings", 0)
	local tip = Instance.new("TextLabel")
	tip.Size = UDim2.new(1, -4, 0, 40)
	tip.Position = UDim2.new(0, 2, 0, 24)
	tip.BackgroundTransparency = 1
	tip.Text = "Add your own toggles here."
	tip.TextColor3 = Color3.fromRGB(220, 210, 255)
	tip.Font = Enum.Font.Gotham
	tip.TextSize = 11
	tip.TextXAlignment = Enum.TextXAlignment.Left
	tip.Parent = pages.Settings
	pages.Settings.CanvasSize = UDim2.new(0, 0, 0, 80)
end

-- ========== REQUEST / VIEW / OWNER (simple stubs for your buttons) ==========
do
	createSection(pages.Request, "Request Game", 0)
	pages.Request.CanvasSize = UDim2.new(0, 0, 0, 40)
end
do
	createSection(pages.View, "View", 0)
	pages.View.CanvasSize = UDim2.new(0, 0, 0, 40)
end
do
	local OwnerPage = pages.Owner
	createSection(OwnerPage, "Owners", 0)
	local y = 24
	for _, userName in ipairs({"Eyfanboy09", "TheSledM"}) do
		local card = Instance.new("Frame")
		card.Size = UDim2.new(1, -4, 0, 48)
		card.Position = UDim2.new(0, 2, 0, y)
		card.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		card.Parent = OwnerPage
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 36, 0, 36)
		avatar.Position = UDim2.new(0, 6, 0.5, -18)
		avatar.BackgroundTransparency = 1
		avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=1&width=48&height=48&format=png"
		avatar.Parent = card
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
		pcall(function()
			local id = Players:GetUserIdFromNameAsync(userName)
			avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. id .. "&w=48&h=48"
		end)
		local nm = Instance.new("TextLabel")
		nm.Size = UDim2.new(1, -50, 1, 0)
		nm.Position = UDim2.new(0, 48, 0, 0)
		nm.BackgroundTransparency = 1
		nm.Text = userName
		nm.TextColor3 = Color3.fromRGB(255, 255, 255)
		nm.Font = Enum.Font.GothamBold
		nm.TextSize = 12
		nm.TextXAlignment = Enum.TextXAlignment.Left
		nm.Parent = card
		y = y + 54
	end
	OwnerPage.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end



-- ========== KEY SYSTEM + MINIGAMES ==========
local InsertKey = Instance.new("Frame")
InsertKey.Name = "Insert Key"
InsertKey.Size = UDim2.new(0, 240, 0, 270)
InsertKey.Position = UDim2.new(0.5, -120, 0.5, -135)
InsertKey.BackgroundColor3 = Color3.fromRGB(148, 142, 108)
InsertKey.BorderSizePixel = 0
InsertKey.Visible = true
InsertKey.ZIndex = 50
InsertKey.Parent = ScreenGui
Instance.new("UICorner", InsertKey).CornerRadius = UDim.new(0, 8)
local ikStroke = Instance.new("UIStroke", InsertKey)
ikStroke.Color = Color3.fromRGB(102, 64, 52)
ikStroke.Thickness = 3

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, -30, 0, 36)
keyTitle.Position = UDim2.new(0, 5, 0, 4)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "Key System"
keyTitle.TextColor3 = Color3.fromRGB(27, 42, 53)
keyTitle.TextSize = 22
keyTitle.Font = Enum.Font.GothamBold
keyTitle.ZIndex = 51
keyTitle.Parent = InsertKey

local keyCloseX = Instance.new("TextButton")
keyCloseX.Size = UDim2.new(0, 28, 0, 28)
keyCloseX.Position = UDim2.new(1, -30, 0, -6)
keyCloseX.BackgroundTransparency = 1
keyCloseX.Text = "X"
keyCloseX.TextColor3 = Color3.fromRGB(255, 0, 0)
keyCloseX.TextSize = 20
keyCloseX.Font = Enum.Font.GothamBold
keyCloseX.ZIndex = 52
keyCloseX.Parent = InsertKey

local keyHint = Instance.new("TextLabel")
keyHint.Size = UDim2.new(1, 0, 0, 16)
keyHint.Position = UDim2.new(0, 0, 0, 40)
keyHint.BackgroundTransparency = 1
keyHint.Text = "Key Expire every 10 minutes!"
keyHint.TextColor3 = Color3.fromRGB(40, 40, 40)
keyHint.TextSize = 11
keyHint.Font = Enum.Font.Gotham
keyHint.ZIndex = 51
keyHint.Parent = InsertKey

local freeUseLbl = Instance.new("TextLabel")
freeUseLbl.Size = UDim2.new(1, -10, 0, 16)
freeUseLbl.Position = UDim2.new(0, 5, 0, 56)
freeUseLbl.BackgroundTransparency = 1
freeUseLbl.Text = ""
freeUseLbl.TextColor3 = Color3.fromRGB(40, 60, 100)
freeUseLbl.TextSize = 11
freeUseLbl.Font = Enum.Font.GothamBold
freeUseLbl.ZIndex = 51
freeUseLbl.Parent = InsertKey

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0, 200, 0, 28)
getKeyBtn.Position = UDim2.new(0, 20, 0, 78)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 160)
getKeyBtn.Text = "Get Key"
getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyBtn.TextSize = 14
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.ZIndex = 51
getKeyBtn.Parent = InsertKey
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 8)

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 220, 0, 36)
keyInput.Position = UDim2.new(0, 10, 0, 116)
keyInput.BackgroundColor3 = Color3.fromRGB(230, 225, 200)
keyInput.PlaceholderText = "Insert Key"
keyInput.Text = ""
keyInput.TextColor3 = Color3.fromRGB(27, 42, 53)
keyInput.TextSize = 16
keyInput.Font = Enum.Font.GothamBold
keyInput.ClearTextOnFocus = true
keyInput.ZIndex = 51
keyInput.Parent = InsertKey
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0, 200, 0, 40)
confirmBtn.Position = UDim2.new(0, 20, 0, 165)
confirmBtn.BackgroundColor3 = Color3.fromRGB(177, 177, 0)
confirmBtn.Text = "Confirm"
confirmBtn.TextColor3 = Color3.fromRGB(27, 42, 53)
confirmBtn.TextSize = 18
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.ZIndex = 51
confirmBtn.Parent = InsertKey
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -10, 0, 36)
statusLbl.Position = UDim2.new(0, 5, 0, 215)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = ""
statusLbl.TextColor3 = Color3.fromRGB(120, 40, 40)
statusLbl.TextSize = 11
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextWrapped = true
statusLbl.ZIndex = 51
statusLbl.Parent = InsertKey

makeDraggable(keyTitle, InsertKey)

-- KeyTimer (second frame)
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
ktTitle.Size = UDim2.new(1, 0, 0, 30)
ktTitle.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
ktTitle.BorderSizePixel = 0
ktTitle.ZIndex = 56
ktTitle.Parent = KeyTimer
Instance.new("UICorner", ktTitle).CornerRadius = UDim.new(0, 8)

local keyTimerIcon = Instance.new("ImageLabel")
keyTimerIcon.Size = UDim2.new(0, 24, 0, 24)
keyTimerIcon.Position = UDim2.new(0, 4, 0, 3)
keyTimerIcon.BackgroundTransparency = 1
keyTimerIcon.Image = "rbxthumb://type=Asset&id=78901068522402&w=420&h=420"
keyTimerIcon.ZIndex = 57
keyTimerIcon.Parent = ktTitle

local keyTimerLabel = Instance.new("TextLabel")
keyTimerLabel.Size = UDim2.new(0, 50, 0, 30)
keyTimerLabel.Position = UDim2.new(0, 30, 0, 0)
keyTimerLabel.BackgroundTransparency = 1
keyTimerLabel.Text = "20:00"
keyTimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTimerLabel.TextSize = 12
keyTimerLabel.Font = Enum.Font.GothamBold
keyTimerLabel.ZIndex = 57
keyTimerLabel.Parent = ktTitle

local keyResetBtn = Instance.new("TextButton")
keyResetBtn.Size = UDim2.new(0, 50, 0, 30)
keyResetBtn.Position = UDim2.new(1, -55, 0, 0)
keyResetBtn.BackgroundTransparency = 1
keyResetBtn.Text = "Reset"
keyResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyResetBtn.TextSize = 11
keyResetBtn.Font = Enum.Font.GothamBold
keyResetBtn.ZIndex = 57
keyResetBtn.Parent = ktTitle

local secA = Instance.new("Frame")
secA.Size = UDim2.new(0, 145, 0, 148)
secA.Position = UDim2.new(0, 5, 0, 36)
secA.BackgroundColor3 = Color3.fromRGB(79, 74, 164)
secA.ZIndex = 56
secA.Parent = KeyTimer
Instance.new("UICorner", secA).CornerRadius = UDim.new(0, 8)
local secABody = Instance.new("TextLabel")
secABody.Size = UDim2.new(1, -10, 1, -10)
secABody.Position = UDim2.new(0, 5, 0, 5)
secABody.BackgroundTransparency = 1
secABody.Text = "Session timer\nMax 20:00\n0:00 = kicked\nRan Out Of Time!"
secABody.TextColor3 = Color3.fromRGB(230, 220, 255)
secABody.TextSize = 11
secABody.Font = Enum.Font.Gotham
secABody.TextXAlignment = Enum.TextXAlignment.Left
secABody.TextYAlignment = Enum.TextYAlignment.Top
secABody.TextWrapped = true
secABody.ZIndex = 57
secABody.Parent = secA

local secB = Instance.new("Frame")
secB.Size = UDim2.new(0, 145, 0, 148)
secB.Position = UDim2.new(0, 160, 0, 36)
secB.BackgroundColor3 = Color3.fromRGB(79, 74, 164)
secB.ZIndex = 56
secB.Parent = KeyTimer
Instance.new("UICorner", secB).CornerRadius = UDim.new(0, 8)
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

-- Spot the Difference
local TOTAL_LEVELS = 15
-- One pic per level (both sides). Google links don't work in Roblox — only asset IDs.
-- Put your own find-the-difference image IDs here (upload on Roblox → copy asset id).
local SPOT_IMAGES = {
	"rbxthumb://type=Asset&id=6034681437&w=420&h=420",
	"rbxthumb://type=Asset&id=6034681850&w=420&h=420",
	"rbxthumb://type=Asset&id=6034682299&w=420&h=420",
	"rbxthumb://type=Asset&id=6034682693&w=420&h=420",
	"rbxthumb://type=Asset&id=6034683112&w=420&h=420",
	"rbxthumb://type=Asset&id=6034683538&w=420&h=420",
	"rbxthumb://type=Asset&id=6034684004&w=420&h=420",
	"rbxthumb://type=Asset&id=6034684491&w=420&h=420",
	"rbxthumb://type=Asset&id=6034684926&w=420&h=420",
	"rbxthumb://type=Asset&id=6034685375&w=420&h=420",
	"rbxthumb://type=Asset&id=6034685812&w=420&h=420",
	"rbxthumb://type=Asset&id=6034686249&w=420&h=420",
	"rbxthumb://type=Asset&id=6034686701&w=420&h=420",
	"rbxthumb://type=Asset&id=6034687155&w=420&h=420",
	"rbxthumb://type=Asset&id=6034687602&w=420&h=420",
}
local SPOT_EMOJIS = {"💚","❤️","🛑","🟥","🟧","🟨","🟩","🟦","🟪","🟫","🔶"}
local ANIMAL_EMOJIS = {"🐬","🐋","🐳","🐟","🐓","🐅","🦘","🦓","🐒","🐘","🦍","🦣"}
local HUMAN_EMOJI = "🧑"

local SpotGui = Instance.new("Frame")
SpotGui.Name = "SpotTheDifference"
SpotGui.Size = UDim2.new(0, 320, 0, 280)
SpotGui.Position = UDim2.new(0.5, -160, 0.5, -140)
SpotGui.BackgroundColor3 = Color3.fromRGB(20, 16, 35)
SpotGui.Visible = false
SpotGui.ZIndex = 80
SpotGui.Parent = ScreenGui
Instance.new("UICorner", SpotGui).CornerRadius = UDim.new(0, 12)
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
levelLbl.Size = UDim2.new(0.5, -12, 0, 18)
levelLbl.Position = UDim2.new(0, 8, 0, 32)
levelLbl.BackgroundTransparency = 1
levelLbl.Text = "Level 1 / 15"
levelLbl.TextColor3 = Color3.fromRGB(200, 190, 255)
levelLbl.Font = Enum.Font.Gotham
levelLbl.TextSize = 12
levelLbl.TextXAlignment = Enum.TextXAlignment.Left
levelLbl.ZIndex = 81
levelLbl.Parent = SpotGui
local spotTimerLbl = Instance.new("TextLabel")
spotTimerLbl.Size = UDim2.new(0.5, -12, 0, 18)
spotTimerLbl.Position = UDim2.new(0.5, 4, 0, 32)
spotTimerLbl.BackgroundTransparency = 1
spotTimerLbl.Text = "⏱ 01:30"
spotTimerLbl.TextColor3 = Color3.fromRGB(255, 220, 100)
spotTimerLbl.Font = Enum.Font.GothamBold
spotTimerLbl.TextSize = 12
spotTimerLbl.TextXAlignment = Enum.TextXAlignment.Right
spotTimerLbl.ZIndex = 81
spotTimerLbl.Parent = SpotGui
local leftPane = Instance.new("Frame")
leftPane.Size = UDim2.new(0.5, -12, 0, 150)
leftPane.Position = UDim2.new(0, 8, 0, 54)
leftPane.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
leftPane.ZIndex = 81
leftPane.Parent = SpotGui
Instance.new("UICorner", leftPane).CornerRadius = UDim.new(0, 8)
local rightPane = Instance.new("Frame")
rightPane.Size = UDim2.new(0.5, -12, 0, 150)
rightPane.Position = UDim2.new(0.5, 4, 0, 54)
rightPane.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
rightPane.ZIndex = 81
rightPane.Parent = SpotGui
Instance.new("UICorner", rightPane).CornerRadius = UDim.new(0, 8)
local spotStatus = Instance.new("TextLabel")
spotStatus.Size = UDim2.new(1, -16, 0, 22)
spotStatus.Position = UDim2.new(0, 8, 0, 212)
spotStatus.BackgroundTransparency = 1
spotStatus.Text = "Tap the difference on the right"
spotStatus.TextColor3 = Color3.fromRGB(180, 170, 220)
spotStatus.Font = Enum.Font.Gotham
spotStatus.TextSize = 11
spotStatus.TextWrapped = true
spotStatus.ZIndex = 81
spotStatus.Parent = SpotGui

-- Slice
local SliceGui = Instance.new("Frame")
SliceGui.Name = "SliceAnimals"
SliceGui.Size = UDim2.new(0, 320, 0, 280)
SliceGui.Position = UDim2.new(0.5, -160, 0.5, -140)
SliceGui.BackgroundColor3 = Color3.fromRGB(18, 20, 40)
SliceGui.Visible = false
SliceGui.ZIndex = 85
SliceGui.Parent = ScreenGui
Instance.new("UICorner", SliceGui).CornerRadius = UDim.new(0, 12)
local sliceTitle = Instance.new("TextLabel")
sliceTitle.Size = UDim2.new(1, -70, 0, 24)
sliceTitle.Position = UDim2.new(0, 10, 0, 4)
sliceTitle.BackgroundTransparency = 1
sliceTitle.Text = "Slice the Animals"
sliceTitle.TextColor3 = Color3.fromRGB(255, 120, 120)
sliceTitle.Font = Enum.Font.GothamBold
sliceTitle.TextSize = 14
sliceTitle.TextXAlignment = Enum.TextXAlignment.Left
sliceTitle.ZIndex = 86
sliceTitle.Parent = SliceGui
local sliceClose = Instance.new("TextButton")
sliceClose.Size = UDim2.new(0, 50, 0, 22)
sliceClose.Position = UDim2.new(1, -56, 0, 6)
sliceClose.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
sliceClose.Text = "Close"
sliceClose.TextColor3 = Color3.fromRGB(255, 255, 255)
sliceClose.TextSize = 11
sliceClose.Font = Enum.Font.GothamBold
sliceClose.ZIndex = 86
sliceClose.Parent = SliceGui
Instance.new("UICorner", sliceClose).CornerRadius = UDim.new(0, 6)
local heartsLbl = Instance.new("TextLabel")
heartsLbl.Size = UDim2.new(0.55, -8, 0, 26)
heartsLbl.Position = UDim2.new(0, 8, 0, 28)
heartsLbl.BackgroundTransparency = 1
heartsLbl.Text = "❤️ ❤️ ❤️"
heartsLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
heartsLbl.Font = Enum.Font.Arcade
heartsLbl.TextSize = 20
heartsLbl.TextXAlignment = Enum.TextXAlignment.Left
heartsLbl.ZIndex = 86
heartsLbl.Parent = SliceGui
local sliceTimerLbl = Instance.new("TextLabel")
sliceTimerLbl.Size = UDim2.new(0.4, -8, 0, 26)
sliceTimerLbl.Position = UDim2.new(0.55, 0, 0, 28)
sliceTimerLbl.BackgroundTransparency = 1
sliceTimerLbl.Text = "⏱ 02:00"
sliceTimerLbl.TextColor3 = Color3.fromRGB(255, 220, 100)
sliceTimerLbl.Font = Enum.Font.GothamBold
sliceTimerLbl.TextSize = 12
sliceTimerLbl.TextXAlignment = Enum.TextXAlignment.Right
sliceTimerLbl.ZIndex = 86
sliceTimerLbl.Parent = SliceGui
local sliceArea = Instance.new("Frame")
sliceArea.Size = UDim2.new(1, -16, 0, 170)
sliceArea.Position = UDim2.new(0, 8, 0, 56)
sliceArea.BackgroundColor3 = Color3.fromRGB(30, 28, 55)
sliceArea.ClipsDescendants = true
sliceArea.ZIndex = 86
sliceArea.Parent = SliceGui
Instance.new("UICorner", sliceArea).CornerRadius = UDim.new(0, 8)
local sliceStatus = Instance.new("TextLabel")
sliceStatus.Size = UDim2.new(1, -16, 0, 22)
sliceStatus.Position = UDim2.new(0, 8, 0, 232)
sliceStatus.BackgroundTransparency = 1
sliceStatus.Text = "Slice 50 animals! Avoid humans!"
sliceStatus.TextColor3 = Color3.fromRGB(200, 190, 255)
sliceStatus.Font = Enum.Font.Gotham
sliceStatus.TextSize = 11
sliceStatus.TextWrapped = true
sliceStatus.ZIndex = 86
sliceStatus.Parent = SliceGui

local spotLevel, sliceHearts, sliceRunning, sliceCount = 1, 3, false, 0
local sliceNeed = 50

local function finishGetKeyWin()
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local len = math.random(6, 10)
	local reward = ""
	for i = 1, len do
		local idx = math.random(1, #chars)
		reward = reward .. chars:sub(idx, idx)
	end
	VALID_KEYS[reward] = {durationSec = 10 * 60, unlimited = true}
	keyInput.Text = reward
	pcall(function() if setclipboard then setclipboard(reward) end end)
	SpotGui.Visible = false
	SliceGui.Visible = false
	InsertKey.Visible = true
	statusLbl.Text = "Key ready — press Confirm"
	statusLbl.TextColor3 = Color3.fromRGB(40, 120, 40)
end

local function updateHearts()
	local t = ""
	for i = 1, 3 do t = t .. ((i <= sliceHearts) and "❤️ " or "🖤 ") end
	heartsLbl.Text = t
end

local function loseHeart()
	sliceHearts = sliceHearts - 1
	updateHearts()
	if sliceHearts <= 0 then
		sliceRunning = false
		sliceStatus.Text = "No hearts!"
		task.wait(0.4)
		pcall(function() player:Kick("Ran Out Of Time!") end)
	end
end

local function spawnAnimal()
	if not sliceRunning or not SliceGui.Visible then return end
	local isHuman = math.random() < 0.15
	local emoji = isHuman and HUMAN_EMOJI or ANIMAL_EMOJIS[math.random(1, #ANIMAL_EMOJIS)]
	-- bigger hitbox so easier to click
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 56, 0, 56)
	btn.Position = UDim2.new(0, math.random(4, 230), 1, -10)
	btn.BackgroundColor3 = Color3.fromRGB(50, 45, 90)
	btn.BackgroundTransparency = 0.45
	btn.Text = emoji
	btn.TextSize = 34
	btn.AutoButtonColor = true
	btn.ZIndex = 87
	btn.Parent = sliceArea
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	local sliced = false
	btn.MouseButton1Click:Connect(function()
		if sliced or not sliceRunning then return end
		sliced = true
		playClick()
		if isHuman then
			btn.Text = "✕"
			btn.TextColor3 = Color3.fromRGB(255, 40, 40)
			task.delay(0.2, function() if btn then btn:Destroy() end end)
			loseHeart()
		else
			btn.Text = "✓"
			btn.TextColor3 = Color3.fromRGB(255, 40, 40)
			sliceCount = sliceCount + 1
			sliceStatus.Text = "Sliced " .. sliceCount .. " / " .. sliceNeed
			task.delay(0.2, function() if btn then btn:Destroy() end end)
			if sliceCount >= sliceNeed then
				sliceRunning = false
				task.delay(0.4, finishGetKeyWin)
			end
		end
	end)
	-- slower throw so easier to hit
	task.spawn(function()
		local peak = math.random(15, 70)
		local x = btn.Position.X.Offset
		for y = 160, peak, -3 do
			if not btn.Parent then return end
			btn.Position = UDim2.new(0, x, 0, y)
			task.wait(0.035)
		end
		for y = peak, 190, 2 do
			if not btn.Parent then return end
			btn.Position = UDim2.new(0, x + math.sin(y/25)*6, 0, y)
			task.wait(0.04)
		end
		if btn.Parent and not sliced then btn:Destroy() end
	end)
end

local miniTimerConn = nil
local function stopMiniTimer()
	if miniTimerConn then task.cancel(miniTimerConn) miniTimerConn = nil end
end
local function startMiniTimer(label, seconds, onExpire)
	stopMiniTimer()
	local left = seconds
	local function fmt(s)
		s = math.max(0, math.floor(s))
		return string.format("⏱ %02d:%02d", math.floor(s/60), s % 60)
	end
	label.Text = fmt(left)
	miniTimerConn = task.spawn(function()
		while left > 0 do
			task.wait(1)
			left = left - 1
			if label and label.Parent then label.Text = fmt(left) end
			if left <= 0 then
				if onExpire then onExpire() end
				break
			end
		end
	end)
end

local function startSliceGame()
	SpotGui.Visible = false
	SliceGui.Visible = true
	sliceHearts, sliceCount, sliceRunning = 3, 0, true
	updateHearts()
	sliceStatus.Text = "Slice 50 animals! Avoid humans!"
	for _, c in ipairs(sliceArea:GetChildren()) do c:Destroy() end
	startMiniTimer(sliceTimerLbl, 120, function()
		if sliceRunning then
			sliceRunning = false
			sliceStatus.Text = "Time up!"
			task.wait(0.5)
			pcall(function() player:Kick("Ran Out Of Time!") end)
		end
	end)
	task.spawn(function()
		while sliceRunning and SliceGui.Visible do
			spawnAnimal()
			task.wait(0.85)
		end
	end)
end

local function clearPanes()
	for _, p in ipairs({leftPane, rightPane}) do
		for _, c in ipairs(p:GetChildren()) do
			if c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("Frame") then c:Destroy() end
		end
	end
end

local function startSpotLevel(lv)
	clearPanes()
	spotLevel = lv
	levelLbl.Text = "Level " .. lv .. " / " .. TOTAL_LEVELS
	spotStatus.Text = "Find the difference on the RIGHT picture"
	if lv == 1 then
		startMiniTimer(spotTimerLbl, 90, function()
			if SpotGui.Visible then
				spotStatus.Text = "Time up!"
				task.wait(0.5)
				pcall(function() player:Kick("Ran Out Of Time!") end)
			end
		end)
	end
	-- one picture per level (same on both sides)
	local imgId = SPOT_IMAGES[((lv - 1) % #SPOT_IMAGES) + 1]
	local function addPic(parent)
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(1, -6, 1, -6)
		img.Position = UDim2.new(0, 3, 0, 3)
		img.BackgroundTransparency = 1
		img.Image = imgId
		img.ScaleType = Enum.ScaleType.Crop
		img.ZIndex = 82
		img.Parent = parent
		Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
		return img
	end
	addPic(leftPane)
	addPic(rightPane)
	-- small extra difference only on RIGHT (the "key" spot)
	local seed = lv * 17 + 3
	local dx = 12 + ((seed * 13) % 90)
	local dy = 12 + ((seed * 19) % 90)
	local dem = SPOT_EMOJIS[((lv + 3) % #SPOT_EMOJIS) + 1]
	local diffBtn = Instance.new("TextButton")
	diffBtn.Size = UDim2.new(0, 36, 0, 36)
	diffBtn.Position = UDim2.new(0, dx, 0, dy)
	diffBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	diffBtn.BackgroundTransparency = 0.35
	diffBtn.Text = dem
	diffBtn.TextSize = 22
	diffBtn.ZIndex = 84
	diffBtn.Parent = rightPane
	Instance.new("UICorner", diffBtn).CornerRadius = UDim.new(1, 0)
	diffBtn.MouseButton1Click:Connect(function()
		playClick()
		if spotLevel >= TOTAL_LEVELS then
			stopMiniTimer()
			spotStatus.Text = "Next: Slice the Animals!"
			task.delay(0.45, startSliceGame)
		else
			task.delay(0.25, function() startSpotLevel(spotLevel + 1) end)
		end
	end)
end

local sessionLeft, timerRunning = SESSION_MAX, false
local function formatTime(sec)
	sec = math.max(0, math.floor(sec))
	return string.format("%02d:%02d", math.floor(sec/60), sec % 60)
end
local function updateTimerIcon()
	if sessionLeft <= 0 then
		keyTimerIcon.Image = "rbxthumb://type=Asset&id=90057204200047&w=420&h=420"
	elseif sessionLeft <= 600 then
		keyTimerIcon.Image = "rbxthumb://type=Asset&id=89042512685010&w=420&h=420"
	else
		keyTimerIcon.Image = "rbxthumb://type=Asset&id=78901068522402&w=420&h=420"
	end
end
local function startSessionTimer(fromSeconds)
	sessionLeft = fromSeconds or SESSION_MAX
	timerRunning = true
	updateTimerIcon()
	keyTimerLabel.Text = formatTime(sessionLeft)
	task.spawn(function()
		while timerRunning and sessionLeft > 0 do
			task.wait(1)
			sessionLeft = sessionLeft - 1
			keyTimerLabel.Text = formatTime(sessionLeft)
			updateTimerIcon()
			if sessionLeft <= 0 then
				timerRunning = false
				keyTimerLabel.Text = "00:00"
				pcall(function() player:Kick("Ran Out Of Time!") end)
				break
			end
		end
	end)
end

local function unlockHub(keyStr, durationSec)
	local dur = durationSec or (10 * 60)
	if dur > SESSION_MAX then dur = SESSION_MAX end -- session timer max 20
	ENV.plus1_unlocked = true
	InsertKey.Visible = false
	SpotGui.Visible = false
	SliceGui.Visible = false
	Main.Visible = true
	OpenBtn.Visible = false
	KeyTimer.Visible = true
	saveKeySaved(keyStr or "session", os.time() + dur)
	startSessionTimer(math.min(dur, SESSION_MAX))
	playClick()
end

confirmBtn.MouseButton1Click:Connect(function()
	playClick()
	local entered = (keyInput.Text or ""):gsub("%s+", "")
	if entered == "" then statusLbl.Text = "Enter a key first" return end
	local info = VALID_KEYS[entered]
	if not info then statusLbl.Text = "Invalid key" statusLbl.TextColor3 = Color3.fromRGB(200, 40, 40) return end
	if info.free then
		if hasUsedFreeKey() then
			statusLbl.Text = "You already used the free key once"
			statusLbl.TextColor3 = Color3.fromRGB(200, 40, 40)
			return
		end
		local used = getFreeUses()
		freeUseLbl.Text = "Free key uses: " .. used .. " / " .. FREE_MAX_USES
		notify("Free key uses: " .. used .. " / " .. FREE_MAX_USES)
		if used >= FREE_MAX_USES then
			statusLbl.Text = "Free key max uses reached"
			return
		end
		used = used + 1
		setFreeUses(used)
		markUsedFreeKey()
		freeUseLbl.Text = "Free key uses: " .. used .. " / " .. FREE_MAX_USES
		notify("Free key uses: " .. used .. " / " .. FREE_MAX_USES)
	else
		freeUseLbl.Text = ""
	end
	statusLbl.Text = "Success!"
	statusLbl.TextColor3 = Color3.fromRGB(40, 120, 40)
	task.wait(0.35)
	unlockHub(entered, info.durationSec)
end)

keyInput:GetPropertyChangedSignal("Text"):Connect(function()
	local t = (keyInput.Text or ""):gsub("%s+", "")
	if t == FREE_KEY then
		freeUseLbl.Text = "Free key uses: " .. getFreeUses() .. " / " .. FREE_MAX_USES
	else
		freeUseLbl.Text = ""
	end
end)

getKeyBtn.MouseButton1Click:Connect(function()
	playClick()
	InsertKey.Visible = false
	SpotGui.Visible = true
	startSpotLevel(1)
end)
spotClose.MouseButton1Click:Connect(function() playClick() SpotGui.Visible = false InsertKey.Visible = true end)
sliceClose.MouseButton1Click:Connect(function() playClick() sliceRunning = false SliceGui.Visible = false InsertKey.Visible = true end)
openMainFromTimer.MouseButton1Click:Connect(function() playClick() Main.Visible = true KeyTimer.Visible = false end)
hideKeyTimer.MouseButton1Click:Connect(function() playClick() KeyTimer.Visible = false end)
keyCloseX.MouseButton1Click:Connect(function() playClick() InsertKey.Visible = false end)

keyResetBtn.MouseButton1Click:Connect(function()
	playClick()
	timerRunning = false
	clearKeySaved()
	ENV.plus1_unlocked = false
	Main.Visible = false
	OpenBtn.Visible = false
	KeyTimer.Visible = false
	SpotGui.Visible = false
	SliceGui.Visible = false
	sliceRunning = false
	InsertKey.Visible = true
	keyInput.Text = ""
	keyTimerLabel.Text = "20:00"
	statusLbl.Text = "Reset — enter key again"
end)

-- Auto unlock if saved still valid (key expiry only blocks on rejoin)
task.spawn(function()
	local saved = loadKeySaved()
	if saved and saved.exp and saved.exp > os.time() then
		local left = math.min(saved.exp - os.time(), SESSION_MAX)
		ENV.plus1_unlocked = true
		InsertKey.Visible = false
		Main.Visible = true
		KeyTimer.Visible = true
		startSessionTimer(left)
	else
		InsertKey.Visible = true
		Main.Visible = false
		KeyTimer.Visible = false
	end
end)

switchPage("Home")
print("[+1GamesScript] Full hub ready")
