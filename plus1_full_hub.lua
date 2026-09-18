--[[
  HyperZscript FULL HUB
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

-- owner ids (decoded at runtime)
local function _d(t)
	local o = ""
	for i = 1, #t do o = o .. string.char(t[i]) end
	return o
end
local OWNERS = {
	[_d({69,121,102,97,110,98,111,121,48,57})] = true, -- owner A
	[_d({84,104,101,83,108,101,100,77})] = true, -- owner B
}
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
		s.SoundId = "rbxassetid://127105730240202"
		s.Volume = 0.8
		s.PlaybackSpeed = 1
		s.Parent = SoundService
		s:Play()
		game:GetService("Debris"):AddItem(s, 3)
	end)
end

local function clickPunch(gui)
	pcall(function()
		if not gui or not gui.Parent then return end
		local scale = gui:FindFirstChildOfClass("UIScale")
		if not scale then
			scale = Instance.new("UIScale")
			scale.Scale = 1
			scale.Parent = gui
		end
		scale.Scale = 1
		local t1 = TweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.88})
		t1:Play()
		t1.Completed:Connect(function()
			if not scale or not scale.Parent then return end
			local t2 = TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.05})
			t2:Play()
			t2.Completed:Connect(function()
				if scale and scale.Parent then
					TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 1}):Play()
				end
			end)
		end)
	end)
end

local function hoverJump(gui)
	pcall(function()
		if not gui or not gui.Parent then return end
		local scale = gui:FindFirstChildOfClass("UIScale")
		if not scale then
			scale = Instance.new("UIScale")
			scale.Parent = gui
		end
		TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.08}):Play()
	end)
end

local function hoverReset(gui)
	pcall(function()
		if not gui or not gui.Parent then return end
		local scale = gui:FindFirstChildOfClass("UIScale")
		if scale then
			TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {Scale = 1}):Play()
		end
	end)
end

local function playHover()
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = "rbxassetid://10066931761"
		s.Volume = 0.2
		s.PlaybackSpeed = 1.2
		s.Parent = SoundService
		s:Play()
		game:GetService("Debris"):AddItem(s, 1)
	end)
end

local function addHover(btn, baseColor, hoverColor)
	if not btn or not btn:IsA("GuiButton") then return end
	baseColor = baseColor or btn.BackgroundColor3
	hoverColor = hoverColor or Color3.fromRGB(
		math.min(255, baseColor.R * 255 + 25) / 255,
		math.min(255, baseColor.G * 255 + 25) / 255,
		math.min(255, baseColor.B * 255 + 35) / 255
	)
	btn.AutoButtonColor = false
	btn.MouseEnter:Connect(function()
		playHover()
		hoverJump(btn)
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = hoverColor}):Play()
	end)
	btn.MouseLeave:Connect(function()
		hoverReset(btn)
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = baseColor}):Play()
	end)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.06), {BackgroundColor3 = Color3.fromRGB(
			math.max(0, baseColor.R * 255 - 20) / 255,
			math.max(0, baseColor.G * 255 - 20) / 255,
			math.max(0, baseColor.B * 255 - 20) / 255
		)}):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = hoverColor}):Play()
	end)
end

local function notify(msg)
	-- notifications removed
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
Main.Size = UDim2.new(0, 311, 0, 230)
Main.Position = UDim2.new(0.5, -155, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(74, 68, 145)
Main.BorderSizePixel = 0
Main.Visible = false -- shown after loading screen
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
Title.Text = "HyperZscript"
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
HideBtn.Font = Enum.Font.Arcade
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 11
HideBtn.Parent = TitleBar

local Nav = Instance.new("Frame")
Nav.Name = "ButtonsFrame"
Nav.Size = UDim2.new(0, 85, 0, 188)
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
Content.Size = UDim2.new(0, 206, 0, 188)
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
	{Name = "Universal", Icon = "rbxthumb://type=Asset&id=108014123759487&w=420&h=420", Y = 145},
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
	-- tab hover (text highlight)
	btn.MouseEnter:Connect(function()
		playHover()
		if btn.TextColor3 ~= Color3.fromRGB(200, 255, 200) then
			btn.TextColor3 = Color3.fromRGB(220, 210, 255)
		end
	end)
	btn.MouseLeave:Connect(function()
		-- restore via switchPage colors roughly
		local active = false
		for n, p in pairs(pages) do
			if p.Visible and n == item.Name then active = true break end
		end
		if item.Name == "View" and not IS_OWNER then
			btn.TextColor3 = Color3.fromRGB(180, 160, 100)
		elseif active then
			btn.TextColor3 = Color3.fromRGB(200, 255, 200)
		else
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end)
end
if not IS_OWNER then
	if navIcons["View"] then
		navIcons["View"].Image = "rbxthumb://type=Asset&id=113054079163682&w=420&h=420"
		navIcons["View"].ImageColor3 = Color3.fromRGB(255, 200, 80)
	end
	if navButtons["View"] then navButtons["View"].TextColor3 = Color3.fromRGB(180, 160, 100) end
	-- hide Owner tab completely (no admin hint)
	if navButtons["Owner"] then navButtons["Owner"]:Destroy() end
	if navIcons["Owner"] then navIcons["Owner"]:Destroy() end
	navButtons["Owner"] = nil
	navIcons["Owner"] = nil
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
pages.Universal = makePage("Universal")

local function switchPage(name)
	if name == "Owner" and not IS_OWNER then
		return
	end
	if name == "View" and not IS_OWNER then
		playClick()
		local b = navButtons["View"]
		if b then b.Text = "Locked" task.delay(0.8, function() if b then b.Text = "View" end end) end
		return
	end
	playClick()
	local activeBtn = navButtons[name]
	if activeBtn then clickPunch(activeBtn) end
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

local mainScale = Main:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
mainScale.Name = "MainScale"
mainScale.Scale = 1
mainScale.Parent = Main

local function animateClose()
	playClick()
	clickPunch(HideBtn)
	local t = TweenService:Create(mainScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.75})
	local t2 = TweenService:Create(Main, TweenInfo.new(0.18), {BackgroundTransparency = 0.4})
	t:Play(); t2:Play()
	t.Completed:Connect(function()
		Main.Visible = false
		Main.BackgroundTransparency = 0
		mainScale.Scale = 1
		OpenBtn.Visible = true
		OpenBtn.Size = UDim2.new(0, 10, 0, 10)
		OpenBtn.BackgroundTransparency = 0.5
		TweenService:Create(OpenBtn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 50, 0, 50),
			BackgroundTransparency = 0
		}):Play()
	end)
end

local function animateOpen()
	playClick()
	clickPunch(OpenBtn)
	OpenBtn.Visible = false
	Main.Visible = true
	Main.BackgroundTransparency = 0.35
	mainScale.Scale = 0.7
	TweenService:Create(mainScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	TweenService:Create(Main, TweenInfo.new(0.22), {BackgroundTransparency = 0}):Play()
end

HideBtn.MouseButton1Click:Connect(animateClose)
OpenBtn.MouseButton1Click:Connect(animateOpen)

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
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, -4, 0, 26)
	row.Position = UDim2.new(0, 2, 0, y)
	row.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	row.Text = ""
	row.AutoButtonColor = false
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
	lbl.ZIndex = 2
	lbl.Parent = row
	local on = false
	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 28, 0, 16)
	switch.Position = UDim2.new(1, -34, 0.5, -8)
	switch.BackgroundColor3 = Color3.fromRGB(80, 70, 120)
	switch.ZIndex = 2
	switch.Parent = row
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 12, 0, 12)
	circle.Position = UDim2.new(0, 2, 0.5, -6)
	circle.BackgroundColor3 = Color3.fromRGB(220, 220, 240)
	circle.ZIndex = 3
	circle.Parent = switch
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local function setVisual(state)
		switch.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(80, 70, 120)
		TweenService:Create(circle, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
			Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
		}):Play()
	end

	row.MouseEnter:Connect(function()
		playHover()
		if not on then
			TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 65, 135)}):Play()
		end
	end)
	row.MouseLeave:Connect(function()
		TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 50, 115)}):Play()
	end)

	row.MouseButton1Click:Connect(function()
		playClick()
		on = not on
		setVisual(on)
		-- small instant punch without blocking
		local sc = row:FindFirstChildOfClass("UIScale")
		if not sc then sc = Instance.new("UIScale") sc.Parent = row end
		sc.Scale = 0.94
		TweenService:Create(sc, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
		if callback then
			task.spawn(callback, on)
		end
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
	addHover(btn, Color3.fromRGB(55, 50, 115), Color3.fromRGB(85, 75, 160))
	btn.MouseButton1Click:Connect(function()
		playClick()
		clickPunch(btn)
		if callback then callback() end
	end)
	return btn
end

print("[HyperZ] GUI base loaded")

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
	ENV.scriptUsers = ENV.scriptUsers or {}
	-- always track self
	ENV.scriptUsers[player.Name] = {
		userId = player.UserId,
		placeId = game.PlaceId,
		gameName = game.Name,
	}

	local function isScriptUser(plr)
		if not plr then return false end
		if ENV.scriptUsers[plr.Name] then return true end
		local head = plr.Character and plr.Character:FindFirstChild("Head")
		if head and head:FindFirstChild("HZUserTag") then return true end
		return false
	end
	ENV.isScriptUser = isScriptUser

	local function applyESP()
		clearESP()
		if not ENV.espUsers then return end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and isScriptUser(plr) then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local hl = Instance.new("Highlight")
					hl.Adornee = plr.Character
					hl.FillColor = Color3.fromRGB(140, 60, 255)
					hl.OutlineColor = Color3.fromRGB(220, 160, 255)
					hl.FillTransparency = 0.45
					hl.Parent = espFolder
					local bb = Instance.new("BillboardGui")
					bb.Size = UDim2.new(0, 130, 0, 36)
					bb.StudsOffset = Vector3.new(0, 3.8, 0)
					bb.AlwaysOnTop = true
					bb.Adornee = hrp
					bb.Parent = espFolder
					local t = Instance.new("TextLabel")
					t.Size = UDim2.new(1, 0, 1, 0)
					t.BackgroundTransparency = 1
					local info = ENV.scriptUsers[plr.Name]
					local gname = (info and info.gameName) or "HZ User"
					t.Text = plr.Name .. "\n⚡ " .. tostring(gname)
					t.TextColor3 = Color3.fromRGB(210, 170, 255)
					t.TextSize = 10
					t.Font = Enum.Font.GothamBold
					t.Parent = bb
				end
			end
		end
	end
	ENV.applyESP = applyESP
	createToggle(HomePage, "ESP HZ Users", 118, function(v)
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

	-- Admin GUI opener (owners) — not on Home content list beyond one owner path
	-- (button lives on Owner tab; function defined here for shared use)
	if IS_OWNER then
		ENV.openTrollGui = function()
			local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
			local old = pg:FindFirstChild("HZTrollAdmin")
			if old then
				old.Enabled = true
				local m = old:FindFirstChild("Main")
				if m then m.Visible = true end
				return
			end

			local g = Instance.new("ScreenGui")
			g.Name = "HZTrollAdmin"
			g.ResetOnSpawn = false
			g.IgnoreGuiInset = true
			g.DisplayOrder = 120
			g.ZIndexBehavior = Enum.ZIndexBehavior.Global
			g.Parent = pg

			-- Purple + black AdminTroll style
			local main = Instance.new("Frame")
			main.Name = "Main"
			main.Size = UDim2.new(0, 320, 0, 420)
			main.Position = UDim2.new(0.5, -160, 0.5, -210)
			main.BackgroundColor3 = Color3.fromRGB(162, 162, 162)
			main.BorderSizePixel = 0
			main.Parent = g
			Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
			local stroke = Instance.new("UIStroke", main)
			stroke.Color = Color3.fromRGB(0, 0, 0)
			stroke.Thickness = 3
			local grad = Instance.new("UIGradient", main)
			grad.Rotation = 100
			grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 0, 84)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
			})

			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, -48, 0, 28)
			title.Position = UDim2.new(0, 10, 0, 6)
			title.BackgroundTransparency = 1
			title.Text = "Admin Commands"
			title.TextColor3 = Color3.fromRGB(255, 255, 255)
			title.Font = Enum.Font.GothamBold
			title.TextSize = 16
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = main

			local close = Instance.new("TextButton")
			close.Size = UDim2.new(0, 28, 0, 28)
			close.Position = UDim2.new(1, -34, 0, 6)
			close.BackgroundTransparency = 1
			close.Text = "X"
			close.TextColor3 = Color3.fromRGB(255, 180, 180)
			close.Font = Enum.Font.GothamBold
			close.TextSize = 16
			close.Parent = main
			close.MouseButton1Click:Connect(function()
				playClick()
				main.Visible = false
			end)

			local sc = Instance.new("ScrollingFrame")
			sc.Size = UDim2.new(1, -12, 1, -42)
			sc.Position = UDim2.new(0, 6, 0, 38)
			sc.BackgroundTransparency = 1
			sc.BorderSizePixel = 0
			sc.ScrollBarThickness = 4
			sc.CanvasSize = UDim2.new(0, 0, 0, 1100)
			sc.Parent = main

			local function lbl(text, y)
				local t = Instance.new("TextLabel")
				t.Size = UDim2.new(1, -8, 0, 18)
				t.Position = UDim2.new(0, 4, 0, y)
				t.BackgroundTransparency = 1
				t.Text = text
				t.TextColor3 = Color3.fromRGB(255, 220, 255)
				t.Font = Enum.Font.GothamBold
				t.TextSize = 12
				t.TextXAlignment = Enum.TextXAlignment.Left
				t.Parent = sc
				return y + 20
			end

			local function box(placeholder, y)
				local b = Instance.new("TextBox")
				b.Size = UDim2.new(1, -8, 0, 28)
				b.Position = UDim2.new(0, 4, 0, y)
				b.BackgroundColor3 = Color3.fromRGB(40, 0, 50)
				b.PlaceholderText = placeholder
				b.Text = ""
				b.TextColor3 = Color3.fromRGB(255, 255, 255)
				b.Font = Enum.Font.GothamBold
				b.TextSize = 12
				b.ClearTextOnFocus = false
				b.Parent = sc
				Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
				local st = Instance.new("UIStroke", b)
				st.Color = Color3.fromRGB(0, 0, 0)
				st.Thickness = 2
				return b, y + 34
			end

			local function btn(text, y, fn)
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1, -8, 0, 30)
				b.Position = UDim2.new(0, 4, 0, y)
				b.BackgroundColor3 = Color3.fromRGB(60, 0, 70)
				b.Text = text
				b.TextColor3 = Color3.fromRGB(255, 255, 255)
				b.Font = Enum.Font.GothamBold
				b.TextSize = 12
				b.AutoButtonColor = false
				b.Parent = sc
				Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
				local st = Instance.new("UIStroke", b)
				st.Color = Color3.fromRGB(0, 0, 0)
				st.Thickness = 2
				b.MouseButton1Click:Connect(function()
					playClick()
					clickPunch(b)
					if fn then fn() end
				end)
				return y + 36
			end

			local y = 4
			y = lbl("Selected player", y)
			local selBox
			selBox, y = box("Username", y)
			selBox.Text = ENV.adminSelected or ""

			local dropBtn = Instance.new("TextButton")
			dropBtn.Size = UDim2.new(1, -8, 0, 28)
			dropBtn.Position = UDim2.new(0, 4, 0, y)
			dropBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 70)
			dropBtn.Text = "HZ Players list  ∇"
			dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			dropBtn.Font = Enum.Font.GothamBold
			dropBtn.TextSize = 12
			dropBtn.Parent = sc
			Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
			local dst = Instance.new("UIStroke", dropBtn)
			dst.Color = Color3.fromRGB(0, 0, 0)
			dst.Thickness = 2
			y = y + 32

			local list = Instance.new("ScrollingFrame")
			list.Size = UDim2.new(1, -8, 0, 90)
			list.Position = UDim2.new(0, 4, 0, y)
			list.BackgroundColor3 = Color3.fromRGB(30, 0, 40)
			list.Visible = false
			list.ScrollBarThickness = 4
			list.Parent = sc
			Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

			local function refresh()
				for _, ch in ipairs(list:GetChildren()) do
					if ch:IsA("TextButton") then ch:Destroy() end
				end
				ENV.scriptUsers = ENV.scriptUsers or {}
				ENV.scriptUsers[player.Name] = {
					userId = player.UserId, placeId = game.PlaceId, gameName = game.Name
				}
				local names = {}
				for n in pairs(ENV.scriptUsers) do table.insert(names, n) end
				table.sort(names)
				local ly = 2
				for _, name in ipairs(names) do
					local info = ENV.scriptUsers[name] or {}
					local b = Instance.new("TextButton")
					b.Size = UDim2.new(1, -8, 0, 28)
					b.Position = UDim2.new(0, 4, 0, ly)
					b.BackgroundColor3 = Color3.fromRGB(50, 0, 60)
					b.Text = "  " .. name .. "  ·  " .. tostring(info.gameName or "?")
					b.TextColor3 = Color3.fromRGB(255, 255, 255)
					b.Font = Enum.Font.GothamBold
					b.TextSize = 11
					b.TextXAlignment = Enum.TextXAlignment.Left
					b.Parent = list
					Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
					b.MouseButton1Click:Connect(function()
						playClick()
						ENV.adminSelected = name
						selBox.Text = name
						list.Visible = false
					end)
					ly = ly + 30
				end
				list.CanvasSize = UDim2.new(0, 0, 0, ly + 4)
			end
			ENV.refreshHZPlayers = refresh
			dropBtn.MouseButton1Click:Connect(function()
				playClick()
				refresh()
				list.Visible = not list.Visible
			end)
			y = y + 96

			local function target()
				local t = selBox.Text
				if t == "" then t = ENV.adminSelected or "all" end
				ENV.adminSelected = t
				return t
			end

			local function adminSend(cmd, extra)
				local t = target()
				local payload = {cmd = cmd, target = t, from = player.Name}
				if extra then for k, v in pairs(extra) do payload[k] = v end end
				pcall(function()
					if ENV.wsSocket and ENV.wsConnected then
						local s = game:GetService("HttpService"):JSONEncode(payload)
						local sock = ENV.wsSocket
						if sock.Send then sock:Send(s) elseif sock.send then sock:send(s) end
					end
				end)
				if cmd == "goto" or cmd == "spectate" then
					local plr = Players:FindFirstChild(t)
					local hum = plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
					local me = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if cmd == "goto" and plr and plr.Character then
						local r = plr.Character:FindFirstChild("HumanoidRootPart")
						if r and me then me.CFrame = r.CFrame * CFrame.new(0, 0, 3) end
					elseif cmd == "spectate" and hum then
						pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
					end
				elseif cmd == "bring" then
					local me = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if me then
						payload.cmd = "tp"
						payload.x, payload.y, payload.z = me.Position.X, me.Position.Y, me.Position.Z
						pcall(function()
							if ENV.wsSocket and ENV.wsConnected then
								local s = game:GetService("HttpService"):JSONEncode(payload)
								local sock = ENV.wsSocket
								if sock.Send then sock:Send(s) elseif sock.send then sock:send(s) end
							end
						end)
					end
				end
			end

			y = y + 8
			y = lbl("Kick", y)
			local kickBox
			kickBox, y = box("Reason...", y)
			y = btn("Kick", y, function()
				adminSend("kick", {reason = kickBox.Text ~= "" and kickBox.Text or "Kicked"})
			end)

			y = y + 10
			y = lbl("Kick V2", y)
			y = btn("Kick V2", y, function()
				adminSend("kick", {hard = true})
			end)

			y = y + 10
			y = lbl("Fling", y)
			y = btn("Fling", y, function() adminSend("fling") end)

			y = y + 10
			y = lbl("How many times / seconds", y)
			local timesBox
			timesBox, y = box("e.g. 5", y)

			y = y + 6
			y = lbl("Freeze", y)
			y = btn("Freeze", y, function()
				adminSend("freeze", {time = tonumber(timesBox.Text) or 5})
			end)

			y = y + 10
			y = lbl("Message", y)
			local msgBox
			msgBox, y = box("Message only (no name)...", y)
			y = btn("Send Message", y, function()
				adminSend("message", {text = msgBox.Text ~= "" and msgBox.Text or "..."})
			end)

			y = y + 10
			y = lbl("Spectate", y)
			y = btn("Spectate Player", y, function() adminSend("spectate") end)
			y = btn("Stop Spectate", y, function()
				pcall(function()
					local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
					if h then workspace.CurrentCamera.CameraSubject = h end
				end)
			end)

			y = y + 12
			y = lbl("Move / Combat", y)
			y = btn("Bring Player Here", y, function() adminSend("bring") end)
			y = btn("Goto Player", y, function() adminSend("goto") end)
			y = btn("Kill", y, function() adminSend("kill") end)
			y = btn("Sky TP", y, function() adminSend("tp", {x = 0, y = 500, z = 0}) end)
			y = btn("Refresh Players", y, refresh)

			sc.CanvasSize = UDim2.new(0, 0, 0, y + 24)

			local dragging, startP, startPos
			title.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					startP = input.Position
					startPos = main.Position
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then dragging = false end
					end)
				end
			end)
			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local d = input.Position - startP
					main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				end
			end)
		end
	end

	-- Cool / Better Respawn + custom death animations dropdown
	createSection(HomePage, "Death / Respawn", 210)
	local DEATH_ANIMS = {
		"Falling Knife",
		"Lightning",
	}
	ENV.deathAnim = ENV.deathAnim or DEATH_ANIMS[1]

	local animDrop = Instance.new("TextButton")
	animDrop.Size = UDim2.new(1, -4, 0, 24)
	animDrop.Position = UDim2.new(0, 2, 0, 232)
	animDrop.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	animDrop.Text = "  " .. ENV.deathAnim .. "  ∇"
	animDrop.TextColor3 = Color3.fromRGB(255, 255, 255)
	animDrop.Font = Enum.Font.GothamBold
	animDrop.TextSize = 10
	animDrop.TextXAlignment = Enum.TextXAlignment.Left
	animDrop.AutoButtonColor = false
	animDrop.Parent = HomePage
	Instance.new("UICorner", animDrop).CornerRadius = UDim.new(0, 6)

	local animList = Instance.new("ScrollingFrame")
	animList.Size = UDim2.new(1, -4, 0, 140)
	animList.Position = UDim2.new(0, 2, 0, 258)
	animList.BackgroundColor3 = Color3.fromRGB(40, 35, 90)
	animList.Visible = false
	animList.ZIndex = 25
	animList.ClipsDescendants = true
	animList.BorderSizePixel = 0
	animList.ScrollBarThickness = 5
	animList.ScrollBarImageColor3 = Color3.fromRGB(180, 160, 255)
	animList.CanvasSize = UDim2.new(0, 0, 0, 0)
	animList.Parent = HomePage
	Instance.new("UICorner", animList).CornerRadius = UDim.new(0, 6)

	local function rebuildAnimList()
		for _, ch in ipairs(animList:GetChildren()) do
			if ch:IsA("TextButton") then ch:Destroy() end
		end
		local y = 2
		for _, name in ipairs(DEATH_ANIMS) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -10, 0, 22)
			b.Position = UDim2.new(0, 2, 0, y)
			b.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
			b.Text = "  " .. name
			b.TextColor3 = Color3.fromRGB(230, 220, 255)
			b.Font = Enum.Font.Gotham
			b.TextSize = 10
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.ZIndex = 26
			b.Parent = animList
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
			b.MouseButton1Click:Connect(function()
				playClick()
				ENV.deathAnim = name
				animDrop.Text = "  " .. name .. "  ∇"
				animList.Visible = false
			end)
			y = y + 24
		end
		animList.CanvasSize = UDim2.new(0, 0, 0, y + 4)
	end
	rebuildAnimList()
	animDrop.MouseButton1Click:Connect(function()
		playClick()
		animList.Visible = not animList.Visible
		animDrop.Text = "  " .. ENV.deathAnim .. (animList.Visible and "  ∆" or "  ∇")
	end)

	local function freezeLocal(hum, root)
		hum.WalkSpeed = 0
		pcall(function() hum.JumpPower = 0 end)
		pcall(function() hum.JumpHeight = 0 end)
		root.Anchored = true
	end

	local function finishDeathCam(oldType)
		task.delay(1.8, function()
			pcall(function()
				local cam = workspace.CurrentCamera
				if cam then
					cam.CameraType = oldType or Enum.CameraType.Custom
					local nc = player.Character
					local nh = nc and nc:FindFirstChildOfClass("Humanoid")
					if nh then cam.CameraSubject = nh end
				end
			end)
			ENV.coolRespawnBusy = false
		end)
	end

	local function animFallingKnife(char, root, hum, cam)
		local parts = {}
		local function clear()
			for _, p in ipairs(parts) do if p and p.Parent then p:Destroy() end end
			table.clear(parts)
		end
		local diedConn = hum.Died:Connect(clear)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local lookPos = root.Position
		cam.CFrame = CFrame.new(lookPos + Vector3.new(0, 2, 6), lookPos + Vector3.new(0, 8, 0))
		TweenService:Create(cam, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
			CFrame = CFrame.new(lookPos + Vector3.new(0, 1.5, 3), lookPos + Vector3.new(0, 40, 0))
		}):Play()
		task.wait(0.75)

		local function makePart(size, color, mat, cf)
			local p = Instance.new("Part")
			p.Size = size
			p.Color = color
			p.Material = mat
			p.Anchored = true
			p.CanCollide = false
			p.CFrame = cf
			p.Parent = workspace
			table.insert(parts, p)
			return p
		end
		local knifeCF = CFrame.new(root.Position + Vector3.new(0, 45, 0)) * CFrame.Angles(math.rad(180), 0, 0)
		local knife = makePart(Vector3.new(0.35, 0.8, 0.35), Color3.fromRGB(90, 50, 20), Enum.Material.Wood, knifeCF * CFrame.new(0, 1.5, 0))
		local blade = makePart(Vector3.new(0.12, 2.4, 0.45), Color3.fromRGB(210, 210, 220), Enum.Material.Metal, knifeCF * CFrame.new(0, -0.6, 0))
		local tip = Instance.new("WedgePart")
		tip.Size = Vector3.new(0.12, 0.5, 0.45)
		tip.Color = Color3.fromRGB(200, 200, 210)
		tip.Material = Enum.Material.Metal
		tip.Anchored = true
		tip.CanCollide = false
		tip.CFrame = knifeCF * CFrame.new(0, -2.0, 0) * CFrame.Angles(0, 0, math.rad(180))
		tip.Parent = workspace
		table.insert(parts, tip)

		local fallTime = 1.1
		local goal = CFrame.new(root.Position + Vector3.new(0, 2.2, 0)) * CFrame.Angles(math.rad(180), 0, 0)
		local ti = TweenInfo.new(fallTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		-- Preload + play FALL sound the moment the knife starts dropping (before death)
		local sFall
		pcall(function()
			sFall = Instance.new("Sound")
			sFall.Name = "HZKnifeFall"
			sFall.SoundId = "rbxassetid://116150406781332"
			sFall.Volume = 1.3
			sFall.PlaybackSpeed = 1
			sFall.Parent = workspace
			sFall.TimePosition = 0
			local tLoad = tick()
			while not sFall.IsLoaded and tick() - tLoad < 0.8 do
				task.wait()
			end
			sFall:Play()
		end)

		TweenService:Create(knife, ti, {CFrame = goal * CFrame.new(0, 1.5, 0)}):Play()
		TweenService:Create(blade, ti, {CFrame = goal * CFrame.new(0, -0.6, 0)}):Play()
		TweenService:Create(tip, ti, {CFrame = goal * CFrame.new(0, -2.0, 0) * CFrame.Angles(0, 0, math.rad(180))}):Play()
		local t0 = tick()
		while tick() - t0 < fallTime do
			if blade.Parent and root.Parent then
				cam.CFrame = CFrame.new(root.Position + Vector3.new(3, 4, 7), blade.Position)
			end
			RunService.RenderStepped:Wait()
		end

		-- Stop fall sound, play HIT on impact (still alive here)
		pcall(function()
			if sFall then sFall:Stop(); sFall:Destroy() end
		end)
		local sHit
		pcall(function()
			sHit = Instance.new("Sound")
			sHit.Name = "HZKnifeHit"
			sHit.SoundId = "rbxassetid://133096341705333"
			sHit.Volume = 1.5
			sHit.Parent = workspace
			sHit.TimePosition = 0
			sHit:Play()
			game:GetService("Debris"):AddItem(sHit, 5)
		end)

		-- impact cam shake while still alive
		for i = 1, 8 do
			if root.Parent then
				cam.CFrame = CFrame.new(root.Position + Vector3.new(2 + math.random(), 3, 5 + math.random()), root.Position)
			end
			task.wait(0.03)
		end
		-- die AFTER hit sound started
		task.wait(0.05)
		pcall(function() if hum then hum.Health = 0 end end)
		clear()
		if diedConn then diedConn:Disconnect() end
		finishDeathCam(oldType)
	end

	local SHOOT_NAMES = {_d({69,121,102,97,110,98,111,121,48,57}), _d({84,104,101,83,108,101,100,77})}

	local function sfx(id, vol)
		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = "rbxassetid://" .. tostring(id)
			s.Volume = vol or 1
			s.Parent = workspace
			s:Play()
			game:GetService("Debris"):AddItem(s, 5)
		end)
	end

	local function animOwnerShoot(char, root, hum, cam)
		local ownerName = SHOOT_NAMES[math.random(1, #SHOOT_NAMES)]
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local uid = 1
		pcall(function()
			uid = Players:GetUserIdFromNameAsync(ownerName) or 1
		end)

		local model = Instance.new("Model")
		model.Name = "DeathAnimOwner"
		model.Parent = workspace
		local okAvatar = false
		pcall(function()
			local desc = Players:GetHumanoidDescriptionFromUserId(uid)
			local dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
			dummy.Name = ownerName
			for _, d in ipairs(dummy:GetDescendants()) do
				if d:IsA("BasePart") then
					d.Anchored = true
					d.CanCollide = false
				end
			end
			local hrp = dummy:FindFirstChild("HumanoidRootPart") or dummy.PrimaryPart
			if hrp then
				dummy:PivotTo(root.CFrame * CFrame.new(0, 0, -10) * CFrame.Angles(0, math.rad(180), 0))
			end
			dummy.Parent = model
			okAvatar = true
		end)
		if not okAvatar then
			local torso = Instance.new("Part")
			torso.Size = Vector3.new(2, 2, 1)
			torso.Anchored = true
			torso.CanCollide = false
			torso.Color = Color3.fromRGB(60, 100, 180)
			torso.CFrame = root.CFrame * CFrame.new(0, 0, -10)
			torso.Parent = model
			local head = Instance.new("Part")
			head.Size = Vector3.new(1.2, 1.2, 1.2)
			head.Anchored = true
			head.CanCollide = false
			head.Color = Color3.fromRGB(243, 190, 150)
			head.CFrame = torso.CFrame * CFrame.new(0, 1.6, 0)
			head.Parent = model
			pcall(function()
				local dec = Instance.new("Decal")
				dec.Face = Enum.NormalId.Front
				dec.Texture = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=420&h=420"
				dec.Parent = head
			end)
		end

		local focus = model:FindFirstChildWhichIsA("BasePart", true) or root
		local ownerPos = focus.Position
		local playerPos = root.Position + Vector3.new(0, 1.5, 0)

		-- slow cinematic orbit then aim
		local t0 = tick()
		while tick() - t0 < 2.2 do
			local a = (tick() - t0) / 2.2
			local ang = a * math.rad(140)
			local dist = 9 - a * 3
			local orbit = ownerPos + Vector3.new(math.sin(ang) * dist, 2.5 + a, math.cos(ang) * dist)
			cam.CFrame = CFrame.new(orbit, ownerPos + Vector3.new(0, 1, 0))
			RunService.RenderStepped:Wait()
		end
		-- slow push in to gun view
		TweenService:Create(cam, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
			CFrame = CFrame.new(ownerPos + Vector3.new(1.2, 1.4, 2.5), playerPos)
		}):Play()
		task.wait(0.9)

		local muzzlePos = ownerPos + Vector3.new(0, 1.2, 0)
		local hitPos = playerPos
		local flash = Instance.new("Part")
		flash.Size = Vector3.new(0.55, 0.55, 0.55)
		flash.Shape = Enum.PartType.Ball
		flash.Anchored = true
		flash.CanCollide = false
		flash.Material = Enum.Material.Neon
		flash.Color = Color3.fromRGB(255, 220, 80)
		flash.CFrame = CFrame.new(muzzlePos)
		flash.Parent = workspace
		local beam = Instance.new("Part")
		beam.Anchored = true
		beam.CanCollide = false
		beam.Material = Enum.Material.Neon
		beam.Color = Color3.fromRGB(255, 230, 100)
		local mid = (muzzlePos + hitPos) / 2
		beam.Size = Vector3.new(0.12, 0.12, (muzzlePos - hitPos).Magnitude)
		beam.CFrame = CFrame.new(mid, hitPos)
		beam.Parent = workspace

		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = "rbxassetid://130113322"
			s.Volume = 1.6
			s.Parent = workspace
			s:Play()
			game:GetService("Debris"):AddItem(s, 2)
		end)

		-- impact cam
		cam.CFrame = CFrame.new(playerPos + Vector3.new(0.5, 0.8, 2), hitPos)
		task.wait(0.15)
		flash:Destroy()
		beam:Destroy()
		pcall(function() hum.Health = 0 end)
		task.wait(0.25)
		model:Destroy()
		finishDeathCam(oldType)
	end

	local function animMonster(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local startPos = root.Position

		-- sink underground
		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = "rbxassetid://9120662915"
			s.Volume = 1
			s.Parent = workspace
			s:Play()
			game:GetService("Debris"):AddItem(s, 3)
		end)
		local sinkGoal = root.CFrame * CFrame.new(0, -12, 0)
		cam.CFrame = CFrame.new(startPos + Vector3.new(4, 6, 8), startPos)
		TweenService:Create(root, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			CFrame = sinkGoal
		}):Play()
		local t0 = tick()
		while tick() - t0 < 1.4 do
			cam.CFrame = CFrame.new(root.Position + Vector3.new(3, 5, 6), root.Position)
			RunService.RenderStepped:Wait()
		end

		-- TP to backrooms space
		local brOrigin = startPos + Vector3.new(0, -80, 0)
		root.CFrame = CFrame.new(brOrigin + Vector3.new(0, 3, 0))
		local room = Instance.new("Model")
		room.Name = "BackroomsDeath"
		room.Parent = workspace
		local function wall(size, cf, color)
			local p = Instance.new("Part")
			p.Size = size
			p.Anchored = true
			p.CanCollide = false
			p.Material = Enum.Material.SmoothPlastic
			p.Color = color or Color3.fromRGB(200, 180, 60)
			p.CFrame = cf
			p.Parent = room
			return p
		end
		wall(Vector3.new(50, 1, 50), CFrame.new(brOrigin), Color3.fromRGB(180, 160, 50))
		wall(Vector3.new(50, 14, 1), CFrame.new(brOrigin + Vector3.new(0, 7, -25)))
		wall(Vector3.new(50, 14, 1), CFrame.new(brOrigin + Vector3.new(0, 7, 25)))
		wall(Vector3.new(1, 14, 50), CFrame.new(brOrigin + Vector3.new(-25, 7, 0)))
		wall(Vector3.new(1, 14, 50), CFrame.new(brOrigin + Vector3.new(25, 7, 0)))
		wall(Vector3.new(50, 1, 50), CFrame.new(brOrigin + Vector3.new(0, 14, 0)), Color3.fromRGB(170, 150, 40))
		-- pillars so it feels like backrooms
		for i = -2, 2 do
			for j = -2, 2 do
				if not (i == 0 and j == 0) then
					wall(Vector3.new(1.5, 14, 1.5), CFrame.new(brOrigin + Vector3.new(i * 8, 7, j * 8)), Color3.fromRGB(190, 170, 55))
				end
			end
		end

		pcall(function()
			local amb = Instance.new("Sound")
			amb.SoundId = "rbxassetid://9113826548"
			amb.Volume = 0.6
			amb.Looped = true
			amb.Parent = workspace
			amb:Play()
			game:GetService("Debris"):AddItem(amb, 12)
		end)

		-- player POV start
		cam.CFrame = CFrame.new(brOrigin + Vector3.new(0, 5, 0), brOrigin + Vector3.new(0, 5, -20))
		task.wait(0.5)

		-- monster far down hallway (visible)
		local mon = Instance.new("Model")
		mon.Name = "Monster"
		mon.Parent = workspace
		local body = Instance.new("Part")
		body.Size = Vector3.new(3.2, 9, 2.2)
		body.Anchored = true
		body.CanCollide = false
		body.Material = Enum.Material.SmoothPlastic
		body.Color = Color3.fromRGB(12, 12, 12)
		body.CFrame = CFrame.new(brOrigin + Vector3.new(0, 5, -28))
		body.Parent = mon
		local mhead = Instance.new("Part")
		mhead.Size = Vector3.new(2.8, 2.8, 2.8)
		mhead.Anchored = true
		mhead.CanCollide = false
		mhead.Color = Color3.fromRGB(8, 8, 8)
		mhead.CFrame = body.CFrame * CFrame.new(0, 5.5, 0)
		mhead.Parent = mon
		for _, off in ipairs({Vector3.new(-0.55, 0.25, -1.3), Vector3.new(0.55, 0.25, -1.3)}) do
			local eye = Instance.new("Part")
			eye.Size = Vector3.new(0.4, 0.4, 0.2)
			eye.Anchored = true
			eye.CanCollide = false
			eye.Material = Enum.Material.Neon
			eye.Color = Color3.fromRGB(255, 25, 25)
			eye.CFrame = mhead.CFrame * CFrame.new(off)
			eye.Parent = mon
		end
		-- arms / hands that will hold the cam
		local function arm(side)
			local a = Instance.new("Part")
			a.Size = Vector3.new(0.7, 0.7, 4)
			a.Anchored = true
			a.CanCollide = false
			a.Color = Color3.fromRGB(10, 10, 10)
			a.CFrame = body.CFrame * CFrame.new(side * 2.2, 2, -2)
			a.Parent = mon
			local hand = Instance.new("Part")
			hand.Size = Vector3.new(1.2, 1.2, 1.2)
			hand.Anchored = true
			hand.CanCollide = false
			hand.Color = Color3.fromRGB(5, 5, 5)
			hand.CFrame = a.CFrame * CFrame.new(0, 0, -2.2)
			hand.Parent = mon
			return a, hand
		end
		local armL, handL = arm(-1)
		local armR, handR = arm(1)

		-- first person walk toward monster
		local walkT = 2.0
		local wt0 = tick()
		while tick() - wt0 < walkT do
			local a = (tick() - wt0) / walkT
			local pos = brOrigin + Vector3.new(0, 5, -a * 18)
			cam.CFrame = CFrame.new(pos, body.Position + Vector3.new(0, 2, 0))
			RunService.RenderStepped:Wait()
		end

		-- monster lunges; hands grab camera
		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = "rbxassetid://5801257793"
			s.Volume = 2
			s.Parent = workspace
			s:Play()
			game:GetService("Debris"):AddItem(s, 4)
		end)
		local grabPos = brOrigin + Vector3.new(0, 5, -8)
		TweenService:Create(body, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			CFrame = CFrame.new(grabPos)
		}):Play()
		TweenService:Create(mhead, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			CFrame = CFrame.new(grabPos + Vector3.new(0, 5.5, 0))
		}):Play()
		task.wait(0.45)

		-- hands hold cam (first person locked in claws)
		local holdT = 1.1
		local ht0 = tick()
		while tick() - ht0 < holdT do
			local shake = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 0.15
			local eyePos = mhead.Position + Vector3.new(0, 0, 1.5) + shake
			cam.CFrame = CFrame.new(eyePos, mhead.Position + Vector3.new(0, 0, -1))
			handL.CFrame = CFrame.new(eyePos + Vector3.new(-0.8, 0.2, 0.3))
			handR.CFrame = CFrame.new(eyePos + Vector3.new(0.8, 0.2, 0.3))
			RunService.RenderStepped:Wait()
		end

		-- head snap
		pcall(function()
			local snap = Instance.new("Sound")
			snap.SoundId = "rbxassetid://9114227552"
			snap.Volume = 2
			snap.Parent = workspace
			snap:Play()
			game:GetService("Debris"):AddItem(snap, 3)
		end)
		pcall(function()
			local s2 = Instance.new("Sound")
			s2.SoundId = "rbxassetid://138081560"
			s2.Volume = 1.4
			s2.Parent = workspace
			s2:Play()
			game:GetService("Debris"):AddItem(s2, 2)
		end)
		for i = 1, 10 do
			cam.CFrame = cam.CFrame * CFrame.Angles(math.rad(math.random(-8, 8)), math.rad(math.random(-12, 12)), 0)
			task.wait(0.03)
		end

		local black = Instance.new("Part")
		black.Size = Vector3.new(30, 30, 1)
		black.Anchored = true
		black.CanCollide = false
		black.Color = Color3.fromRGB(0, 0, 0)
		black.CFrame = cam.CFrame * CFrame.new(0, 0, -2)
		black.Parent = workspace
		task.wait(0.25)

		pcall(function() hum.Health = 0 end)
		task.wait(0.1)
		mon:Destroy()
		room:Destroy()
		black:Destroy()
		finishDeathCam(oldType)
	end

	local function animFade(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local pos = root.Position
		cam.CFrame = CFrame.new(pos + Vector3.new(4, 3, 7), pos + Vector3.new(0, 1, 0))

		pcall(function()
			for _, id in ipairs({9113848995, 9113826548, 9114221331}) do
				local s = Instance.new("Sound")
				s.SoundId = "rbxassetid://" .. id
				s.Volume = 0.9
				s.Parent = workspace
				s:Play()
				game:GetService("Debris"):AddItem(s, 5)
			end
		end)

		-- fade all character parts (Thanos / Spidey dust vibe)
		local parts = {}
		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
				table.insert(parts, d)
				d.Anchored = true
			end
		end
		-- slow orbit while fading
		local t0 = tick()
		local dur = 2.4
		while tick() - t0 < dur do
			local a = (tick() - t0) / dur
			local ang = a * math.rad(90)
			cam.CFrame = CFrame.new(pos + Vector3.new(math.sin(ang) * 6, 2.5 + a, math.cos(ang) * 6), pos + Vector3.new(0, 1, 0))
			for _, p in ipairs(parts) do
				if p and p.Parent then
					p.Transparency = a
					p.Color = p.Color:Lerp(Color3.fromRGB(40, 20, 60), a * 0.5)
				end
			end
			-- spark particles lite
			if math.random() < 0.35 then
				local spark = Instance.new("Part")
				spark.Size = Vector3.new(0.15, 0.15, 0.15)
				spark.Anchored = true
				spark.CanCollide = false
				spark.Material = Enum.Material.Neon
				spark.Color = Color3.fromRGB(180, 120, 255)
				spark.CFrame = CFrame.new(pos + Vector3.new(math.random(-2,2), math.random(0,3), math.random(-2,2)))
				spark.Parent = workspace
				TweenService:Create(spark, TweenInfo.new(0.4), {
					Transparency = 1,
					CFrame = spark.CFrame + Vector3.new(0, 1.5, 0)
				}):Play()
				game:GetService("Debris"):AddItem(spark, 0.5)
			end
			RunService.RenderStepped:Wait()
		end
		for _, p in ipairs(parts) do
			if p and p.Parent then p.Transparency = 1 end
		end
		pcall(function()
			local s2 = Instance.new("Sound")
			s2.SoundId = "rbxassetid://9114221331"
			s2.Volume = 1
			s2.Parent = workspace
			s2:Play()
			game:GetService("Debris"):AddItem(s2, 3)
		end)
		task.wait(0.2)
		pcall(function() hum.Health = 0 end)
		finishDeathCam(oldType)
	end


	local function playSFX(id, vol)
		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = "rbxassetid://" .. tostring(id)
			s.Volume = vol or 1
			s.Parent = workspace
			s:Play()
			game:GetService("Debris"):AddItem(s, 4)
		end)
	end

	local function animLego(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local pos = root.Position
		cam.CFrame = CFrame.new(pos + Vector3.new(5, 4, 8), pos)
		playSFX(9113848995, 1)
		playSFX(9120662915, 0.7)
		local parts = {}
		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
				d.Anchored = true
				table.insert(parts, d)
			end
		end
		for i, p in ipairs(parts) do
			local off = Vector3.new(math.random(-8, 8), math.random(2, 10), math.random(-8, 8))
			local rot = CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
			TweenService:Create(p, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				CFrame = CFrame.new(p.Position + off) * rot
			}):Play()
			playSFX(9114221331, 0.5)
			-- orbit each piece
			local ang = i * 0.7
			cam.CFrame = CFrame.new(p.Position + Vector3.new(math.sin(ang) * 4, 2.5, math.cos(ang) * 4), p.Position)
			task.wait(0.32)
		end
		playSFX(138081560, 1.2)
		task.wait(0.35)
		pcall(function() hum.Health = 0 end)
		finishDeathCam(oldType)
	end

	local function animLightning(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local pos = root.Position
		cam.CFrame = CFrame.new(pos + Vector3.new(6, 8, 6), pos)
		playSFX(821439273, 1.3)
		-- lightning bolt parts
		local bolts = {}
		for i = 1, 6 do
			local b = Instance.new("Part")
			b.Size = Vector3.new(0.25, math.random(4, 10), 0.25)
			b.Material = Enum.Material.Neon
			b.Color = Color3.fromRGB(180, 220, 255)
			b.Anchored = true
			b.CanCollide = false
			b.CFrame = CFrame.new(pos + Vector3.new(math.random(-3, 3), 15, math.random(-3, 3)))
			b.Parent = workspace
			table.insert(bolts, b)
			TweenService:Create(b, TweenInfo.new(0.25), {CFrame = CFrame.new(pos + Vector3.new(math.random(-1,1), 2, math.random(-1,1)))}):Play()
		end
		task.wait(0.3)
		-- flash
		local flash = Instance.new("Part")
		flash.Size = Vector3.new(40, 40, 1)
		flash.Anchored = true
		flash.CanCollide = false
		flash.Material = Enum.Material.Neon
		flash.Color = Color3.fromRGB(255, 255, 255)
		flash.Transparency = 0.2
		flash.CFrame = cam.CFrame * CFrame.new(0, 0, -5)
		flash.Parent = workspace
		playSFX(138081560, 1.5)
		task.wait(0.15)
		flash:Destroy()
		for _, b in ipairs(bolts) do b:Destroy() end
		pcall(function() hum.Health = 0 end)
		finishDeathCam(oldType)
	end

	local function animBlackHole(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local pos = root.Position
		local hole = Instance.new("Part")
		hole.Shape = Enum.PartType.Ball
		hole.Size = Vector3.new(1, 1, 1)
		hole.Material = Enum.Material.Neon
		hole.Color = Color3.fromRGB(20, 0, 40)
		hole.Anchored = true
		hole.CanCollide = false
		hole.CFrame = CFrame.new(pos + Vector3.new(0, 2, -6))
		hole.Parent = workspace
		playSFX(9113826548, 1)
		TweenService:Create(hole, TweenInfo.new(1.2), {Size = Vector3.new(8, 8, 8)}):Play()
		local t0 = tick()
		while tick() - t0 < 1.3 do
			local a = (tick() - t0) / 1.3
			cam.CFrame = CFrame.new(pos + Vector3.new(4 - a * 2, 3, 8 - a * 4), hole.Position)
			root.CFrame = root.CFrame:Lerp(CFrame.new(hole.Position), 0.08)
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BasePart") then
					d.Size = d.Size:Lerp(Vector3.new(0.1, 0.1, 0.1), 0.05)
				end
			end
			RunService.RenderStepped:Wait()
		end
		playSFX(9114227552, 1.4)
		hole:Destroy()
		pcall(function() hum.Health = 0 end)
		finishDeathCam(oldType)
	end

	local function animFreezeShatter(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local pos = root.Position
		cam.CFrame = CFrame.new(pos + Vector3.new(4, 3, 7), pos)
		playSFX(9113848995, 0.9)
		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("BasePart") then
				d.Anchored = true
				d.Material = Enum.Material.Ice
				d.Color = Color3.fromRGB(170, 220, 255)
			end
		end
		task.wait(0.7)
		playSFX(9114221331, 1.3)
		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
				local off = Vector3.new(math.random(-6, 6), math.random(0, 5), math.random(-6, 6))
				TweenService:Create(d, TweenInfo.new(0.5), {
					CFrame = CFrame.new(d.Position + off) * CFrame.Angles(math.random(), math.random(), math.random()),
					Transparency = 0.5
				}):Play()
			end
		end
		for i = 1, 12 do
			cam.CFrame = CFrame.new(pos + Vector3.new(math.sin(i) * 5, 3, math.cos(i) * 5), pos)
			task.wait(0.04)
		end
		pcall(function() hum.Health = 0 end)
		finishDeathCam(oldType)
	end

	local function animSkyLaunch(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local pos = root.Position
		playSFX(9113848995, 1)
		cam.CFrame = CFrame.new(pos + Vector3.new(3, 2, 6), pos)
		local goal = pos + Vector3.new(0, 120, 0)
		TweenService:Create(root, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			CFrame = CFrame.new(goal)
		}):Play()
		local t0 = tick()
		while tick() - t0 < 1.6 do
			cam.CFrame = CFrame.new(root.Position + Vector3.new(4, -2, 8), root.Position)
			RunService.RenderStepped:Wait()
		end
		playSFX(138081560, 1.2)
		pcall(function() hum.Health = 0 end)
		finishDeathCam(oldType)
	end

	local function animGlitch(char, root, hum, cam)
		local oldType = cam.CameraType
		cam.CameraType = Enum.CameraType.Scriptable
		local pos = root.Position
		playSFX(9114227552, 1)
		for i = 1, 18 do
			local jitter = Vector3.new(math.random(-4, 4), math.random(-2, 4), math.random(-4, 4))
			cam.CFrame = CFrame.new(pos + Vector3.new(3, 2, 5) + jitter * 0.15, pos + jitter * 0.05)
			root.CFrame = CFrame.new(pos + jitter * 0.4) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BasePart") and math.random() < 0.3 then
					d.Transparency = math.random()
					d.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
				end
			end
			task.wait(0.05)
		end
		playSFX(9114221331, 1.2)
		pcall(function() hum.Health = 0 end)
		finishDeathCam(oldType)
	end

	local function playCoolRespawn()
		if ENV.coolRespawnBusy then return end
		ENV.coolRespawnBusy = true
		task.spawn(function()
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local cam = workspace.CurrentCamera
			if not root or not hum or not cam then
				ENV.coolRespawnBusy = false
				return
			end
			freezeLocal(hum, root)
			local anim = ENV.deathAnim or DEATH_ANIMS[1]
			if anim == "Random Owner Shoot the player" then
				animOwnerShoot(char, root, hum, cam)
			elseif anim == "Monster" then
				animMonster(char, root, hum, cam)
			elseif anim == "Fade" then
				animFade(char, root, hum, cam)
			elseif anim == "Lego" then
				animLego(char, root, hum, cam)
			elseif anim == "Lightning" then
				animLightning(char, root, hum, cam)
			elseif anim == "Black Hole" then
				animBlackHole(char, root, hum, cam)
			elseif anim == "Freeze Shatter" then
				animFreezeShatter(char, root, hum, cam)
			elseif anim == "Sky Launch" then
				animSkyLaunch(char, root, hum, cam)
			elseif anim == "Glitch" then
				animGlitch(char, root, hum, cam)
			else
				animFallingKnife(char, root, hum, cam)
			end
		end)
	end
	ENV.playCoolRespawn = playCoolRespawn

	createButton(HomePage, "Cool Respawn", 320, function()
		playClick()
		playCoolRespawn()
	end)

	local resetBindable = Instance.new("BindableEvent")
	resetBindable.Event:Connect(function()
		if ENV.betterRespawnMenu then
			playCoolRespawn()
		else
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
		end
	end)

	local function applyResetCallback(on)
		pcall(function()
			local StarterGui = game:GetService("StarterGui")
			if on then
				StarterGui:SetCore("ResetButtonCallback", resetBindable)
			else
				StarterGui:SetCore("ResetButtonCallback", true)
			end
		end)
	end

	createToggle(HomePage, "Better Respawn Menu", 280, function(v)
		ENV.betterRespawnMenu = v
		applyResetCallback(v)
	end)
	-- default ON for current death anim on Respawn Menu
	ENV.betterRespawnMenu = true
	task.defer(function()
		applyResetCallback(true)
	end)

	HomePage.CanvasSize = UDim2.new(0, 0, 0, 980)
end

-- ========== VERITY HELPER (rainbow UI) ==========

-- ========== SETTINGS ==========
do
	local S = pages.Settings
	createSection(S, "Performance", 0)

	-- White overlay when 3D rendering is off
	local whiteScreen = Instance.new("Frame")
	whiteScreen.Name = "HZWhiteScreen"
	whiteScreen.Size = UDim2.new(1, 0, 1, 0)
	whiteScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	whiteScreen.BorderSizePixel = 0
	whiteScreen.Visible = false
	whiteScreen.ZIndex = 500
	whiteScreen.Parent = ScreenGui

	createToggle(S, "3D Rendering (OFF = white)", 22, function(v)
		-- toggle ON = rendering enabled (normal)
		-- toggle OFF = disable 3D + full white screen
		-- User asked: when on screen white — interpret as when "disable" style.
		-- Label: when this toggle is ON, white screen (disable 3D)
		ENV.disable3D = v
		pcall(function()
			game:GetService("RunService"):Set3dRenderingEnabled(not v)
		end)
		whiteScreen.Visible = v and true or false
	end)

	createToggle(S, "FPS Booster", 54, function(v)
		ENV.fpsBoost = v
		task.spawn(function()
			while ENV.fpsBoost do
				pcall(function()
					settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
					UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
				end)
				pcall(function()
					local lighting = game:GetService("Lighting")
					lighting.GlobalShadows = false
					lighting.FogEnd = 9e9
					lighting.Brightness = 1
				end)
				pcall(function()
					workspace.DescendantAdded:Connect(function() end) -- noop keep
					for _, d in ipairs(workspace:GetDescendants()) do
						if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
							d.Enabled = false
						elseif d:IsA("Explosion") then
							d:Destroy()
						elseif d:IsA("PostEffect") then
							d.Enabled = false
						end
					end
				end)
				pcall(function()
					local cam = workspace.CurrentCamera
					if cam then cam.FieldOfView = 70 end
				end)
				task.wait(2)
			end
		end)
	end)

	createButton(S, "Boost FPS Once", 86, function()
		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)
		pcall(function()
			local lighting = game:GetService("Lighting")
			lighting.GlobalShadows = false
			lighting.FogEnd = 9e9
			for _, e in ipairs(lighting:GetChildren()) do
				if e:IsA("PostEffect") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") then
					e.Enabled = false
				end
			end
		end)
		pcall(function()
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") then
					d.Enabled = false
				end
			end
		end)
	end)

	createSection(S, "General", 130)
	createToggle(S, "Auto Rejoin (when kicked)", 152, function(v)
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

	createToggle(S, "Low Graphics Mode", 184, function(v)
		ENV.lowGfx = v
		pcall(function()
			local lighting = game:GetService("Lighting")
			if v then
				ENV._oldBrightness = lighting.Brightness
				lighting.GlobalShadows = false
				lighting.Brightness = 2
				lighting.FogEnd = 1e6
			else
				lighting.GlobalShadows = true
				if ENV._oldBrightness then lighting.Brightness = ENV._oldBrightness end
			end
		end)
	end)

	createToggle(S, "Hide Other Players", 216, function(v)
		ENV.hideOthers = v
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				for _, p in ipairs(plr.Character:GetDescendants()) do
					if p:IsA("BasePart") then
						p.LocalTransparencyModifier = v and 1 or 0
					end
				end
			end
		end
	end)

	createToggle(S, "Mute All Sounds", 248, function(v)
		ENV.muteAll = v
		pcall(function()
			for _, s in ipairs(game:GetService("SoundService"):GetDescendants()) do
				if s:IsA("Sound") then s.Volume = v and 0 or s.Volume end
			end
			UserSettings():GetService("UserGameSettings").MasterVolume = v and 0 or 1
		end)
	end)

	createButton(S, "Clear Workspace Effects", 280, function()
		pcall(function()
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") then
					d.Enabled = false
				end
			end
		end)
	end)

	createButton(S, "Reset Graphics Defaults", 312, function()
		ENV.fpsBoost = false
		ENV.disable3D = false
		pcall(function()
			game:GetService("RunService"):Set3dRenderingEnabled(true)
			whiteScreen.Visible = false
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		end)
	end)

	createSection(S, "Repair", 350)
	createButton(S, "Clear / Repair Game View", 372, function()
		-- Undo FPS boosters / white screen / hide players / mute
		ENV.fpsBoost = false
		ENV.disable3D = false
		ENV.lowGfx = false
		ENV.hideOthers = false
		ENV.muteAll = false
		pcall(function()
			game:GetService("RunService"):Set3dRenderingEnabled(true)
			whiteScreen.Visible = false
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
			UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.Automatic
			UserSettings():GetService("UserGameSettings").MasterVolume = 1
		end)
		pcall(function()
			local lighting = game:GetService("Lighting")
			lighting.GlobalShadows = true
			lighting.FogEnd = 100000
			lighting.Brightness = 1
			for _, e in ipairs(lighting:GetChildren()) do
				if e:IsA("PostEffect") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") then
					e.Enabled = true
				end
			end
		end)
		pcall(function()
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					for _, p in ipairs(plr.Character:GetDescendants()) do
						if p:IsA("BasePart") then
							p.LocalTransparencyModifier = 0
						end
					end
				end
			end
		end)
		pcall(function()
			local cam = workspace.CurrentCamera
			if cam then
				cam.FieldOfView = 70
				local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if h then cam.CameraSubject = h end
				cam.CameraType = Enum.CameraType.Custom
			end
		end)
	end)

	S.CanvasSize = UDim2.new(0, 0, 0, 420)
end

-- ========== REQUEST ==========
do
	local RequestPage = pages.Request
	createSection(RequestPage, "Request Game", 0)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -4, 0, 40)
	box.Position = UDim2.new(0, 2, 0, 22)
	box.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	box.PlaceholderText = "Request Game..."
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
		if msg == "" or msg == "Request +1 Game name..." then
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
	for _, userName in ipairs({_d({69,121,102,97,110,98,111,121,48,57}), _d({84,104,101,83,108,101,100,77})}) do
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

	-- ========== WEBSOCKET TROLL CMDS ==========
	createSection(OwnerPage, "Troll (WebSocket)", y + 8)
	local ty = y + 30

	-- Default public relay-style URL — change to your own WS server
	ENV.wsUrl = ENV.wsUrl or (getgenv().HyperZ_WS_URL or "wss://echo.websocket.events")
	ENV.wsConnected = false
	ENV.wsSocket = nil
	ENV.wsUsers = ENV.wsUsers or {}

	local function showTrollMsg(text, secs)
		-- Anonymous on-screen message only (no chat, no sender name)
		text = tostring(text or "")
		-- strip accidental sender prefixes if any
		text = text:gsub("^[Ff]rom%s*:%s*", "")
		text = text:gsub("^%[[^%]]+%]%s*", "")
		if text == "" then text = "..." end
		secs = secs or math.clamp(#text * 0.09, 2.5, 10)

		local parent = nil
		pcall(function() parent = game:GetService("CoreGui") end)
		if not parent then
			parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
		end
		if not parent then return end

		local oldGui = parent:FindFirstChild("HZTrollMsg")
		if oldGui then oldGui:Destroy() end
		-- also clear from PlayerGui if we used CoreGui path before
		pcall(function()
			local pg = player:FindFirstChild("PlayerGui")
			if pg then
				local o = pg:FindFirstChild("HZTrollMsg")
				if o then o:Destroy() end
			end
		end)

		local g = Instance.new("ScreenGui")
		g.Name = "HZTrollMsg"
		g.ResetOnSpawn = false
		g.IgnoreGuiInset = true
		g.DisplayOrder = 9999
		g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		pcall(function() g.Parent = parent end)
		if not g.Parent then
			g.Parent = player:WaitForChild("PlayerGui")
		end

		local f = Instance.new("Frame")
		f.Size = UDim2.new(0, 340, 0, 78)
		f.Position = UDim2.new(0.5, -170, 0.08, 0)
		f.BackgroundColor3 = Color3.fromRGB(25, 15, 50)
		f.BorderSizePixel = 0
		f.Parent = g
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
		local st = Instance.new("UIStroke", f)
		st.Color = Color3.fromRGB(190, 100, 255)
		st.Thickness = 3
		local grad = Instance.new("UIGradient", f)
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 25, 90)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 12, 45)),
		})
		grad.Rotation = 90

		-- message only — no username, no "from"
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(1, -20, 1, -16)
		t.Position = UDim2.new(0, 10, 0, 8)
		t.BackgroundTransparency = 1
		t.Text = text
		t.TextColor3 = Color3.fromRGB(245, 235, 255)
		t.Font = Enum.Font.GothamBold
		t.TextSize = 15
		t.TextWrapped = true
		t.TextXAlignment = Enum.TextXAlignment.Center
		t.TextYAlignment = Enum.TextYAlignment.Center
		t.Parent = f

		-- fade in
		f.BackgroundTransparency = 0.4
		t.TextTransparency = 0.5
		pcall(function()
			game:GetService("TweenService"):Create(f, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
			game:GetService("TweenService"):Create(t, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
		end)

		task.delay(secs, function()
			pcall(function()
				game:GetService("TweenService"):Create(f, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
				game:GetService("TweenService"):Create(t, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
			end)
			task.delay(0.3, function()
				if g then g:Destroy() end
			end)
		end)
	end
	ENV.showTrollMsg = showTrollMsg

	local function doFlingLocal()
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not root then return end
		pcall(function()
			if hum then hum.PlatformStand = true end
			local bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
			bv.Velocity = Vector3.new(math.random(-120, 120), 140, math.random(-120, 120))
			bv.Parent = root
			local bg = Instance.new("BodyAngularVelocity")
			bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
			bg.AngularVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
			bg.Parent = root
			task.delay(1.2, function()
				pcall(function() bv:Destroy() end)
				pcall(function() bg:Destroy() end)
				if hum then hum.PlatformStand = false end
			end)
		end)
	end

	local function handleWsCommand(data)
		local cmd = data.cmd or data.command
		local target = data.target
		local me = player.Name
		if target and target ~= me and target ~= "all" and target ~= "*" then
			return
		end
		if cmd == "message" or cmd == "msg" then
			-- only the message body — never data.from / username
			local body = data.text or data.msg or data.message or ""
			showTrollMsg(body)
		elseif cmd == "fling" then
			doFlingLocal()
			showTrollMsg("You got flung 😈", 3)
		elseif cmd == "kick" or cmd == "leave" then
			if data.hard then
				-- Kick V2: looks like an official experience-owner kick (no custom popup)
				task.delay(0.1, function()
					pcall(function()
						player:Kick("You have been kicked by the experience owner.")
					end)
				end)
			else
				local reason = tostring(data.reason or data.text or "No reason")
				local msg = "Kick Reason: " .. reason
				showTrollMsg(msg, 2)
				task.delay(0.5, function()
					pcall(function() player:Kick(msg) end)
				end)
			end
		elseif cmd == "freeze" then
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = 0
				hum.JumpPower = 0
				task.delay(tonumber(data.time) or 5, function()
					if hum then
						hum.WalkSpeed = 16
						hum.JumpPower = 50
					end
				end)
			end
		elseif cmd == "tp" and data.x then
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = CFrame.new(tonumber(data.x) or 0, tonumber(data.y) or 50, tonumber(data.z) or 0)
			end
		elseif cmd == "kill" then
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
		elseif cmd == "bring" then
			-- handled as tp with coords from admin
		elseif cmd == "users" then
		end
	end

	local function wsSend(tbl)
		local sock = ENV.wsSocket
		if not sock then return false end
		local ok = pcall(function()
			local payload = game:GetService("HttpService"):JSONEncode(tbl)
			if sock.Send then sock:Send(payload)
			elseif sock.send then sock:send(payload)
			end
		end)
		return ok
	end

	local function wsConnect()
		if ENV.wsConnected then return end
		local url = ENV.wsUrl
		local connectFn = nil
		pcall(function()
			if syn and syn.websocket and syn.websocket.connect then
				connectFn = function(u) return syn.websocket.connect(u) end
			elseif WebSocket and WebSocket.connect then
				connectFn = function(u) return WebSocket.connect(u) end
			elseif websocket and websocket.connect then
				connectFn = function(u) return websocket.connect(u) end
			end
		end)
		if not connectFn then
			statusWs.Text = "WS: executor has no WebSocket"
			return
		end
		local ok, sock = pcall(connectFn, url)
		if not ok or not sock then
			statusWs.Text = "WS: connect failed"
			return
		end
		ENV.wsSocket = sock
		ENV.wsConnected = true
		statusWs.Text = "WS: connected"
		statusWs.TextColor3 = Color3.fromRGB(120, 255, 160)

		-- register
		wsSend({
			cmd = "join",
			user = player.Name,
			userId = player.UserId,
			placeId = game.PlaceId,
			gameName = game.Name,
			owner = OWNERS[player.Name] == true,
		})
		ENV.scriptUsers = ENV.scriptUsers or {}
		ENV.scriptUsers[player.Name] = {
			userId = player.UserId,
			placeId = game.PlaceId,
			gameName = game.Name,
		}

		local function onMsg(msg)
			pcall(function()
				local data = game:GetService("HttpService"):JSONDecode(msg)
				if typeof(data) == "table" then
					if data.cmd == "join" and data.user then
						ENV.scriptUsers = ENV.scriptUsers or {}
						ENV.scriptUsers[data.user] = {
							userId = data.userId,
							placeId = data.placeId,
							gameName = data.gameName or "Unknown",
						}
						local plr = Players:FindFirstChild(data.user)
						if plr and plr.Character and ENV.makeCoolTag then
							pcall(function() plr.Character:SetAttribute("HZOwnerName", data.user) end)
							ENV.makeCoolTag(plr.Character, data.gameName or game.Name)
						end
						if ENV.refreshHZPlayers then ENV.refreshHZPlayers() end
						if ENV.espUsers and ENV.applyESP then ENV.applyESP() end
					elseif data.cmd == "leave" and data.user then
						if ENV.scriptUsers then ENV.scriptUsers[data.user] = nil end
						local plr = Players:FindFirstChild(data.user)
						if plr and plr.Character then
							local head = plr.Character:FindFirstChild("Head")
							if head then
								local t = head:FindFirstChild("HZUserTag")
								if t then t:Destroy() end
							end
						end
						if ENV.refreshHZPlayers then ENV.refreshHZPlayers() end
						if ENV.espUsers and ENV.applyESP then ENV.applyESP() end
					end
					handleWsCommand(data)
					if data.cmd == "userlist" and data.users then
						ENV.wsUsers = data.users
						ENV.scriptUsers = ENV.scriptUsers or {}
						for _, u in pairs(data.users) do
							if typeof(u) == "table" and u.user then
								ENV.scriptUsers[u.user] = u
							elseif typeof(u) == "string" then
								ENV.scriptUsers[u] = ENV.scriptUsers[u] or {gameName = "?"}
							end
						end
						if ENV.refreshHZPlayers then ENV.refreshHZPlayers() end
					end
				end
			end)
		end

		pcall(function()
			if sock.OnMessage then
				sock.OnMessage:Connect(onMsg)
			elseif typeof(sock) == "table" and sock.onmessage then
				sock.onmessage = onMsg
			end
		end)
		pcall(function()
			if sock.OnClose then
				sock.OnClose:Connect(function()
					ENV.wsConnected = false
					statusWs.Text = "WS: closed"
					statusWs.TextColor3 = Color3.fromRGB(255, 140, 140)
				end)
			end
		end)
	end

	local statusWs = Instance.new("TextLabel")
	statusWs.Size = UDim2.new(1, -4, 0, 16)
	statusWs.Position = UDim2.new(0, 2, 0, ty)
	statusWs.BackgroundTransparency = 1
	statusWs.Text = "WS: offline"
	statusWs.TextColor3 = Color3.fromRGB(255, 180, 120)
	statusWs.Font = Enum.Font.GothamBold
	statusWs.TextSize = 10
	statusWs.TextXAlignment = Enum.TextXAlignment.Left
	statusWs.Parent = OwnerPage
	ty = ty + 20

	local urlBox = Instance.new("TextBox")
	urlBox.Size = UDim2.new(1, -4, 0, 26)
	urlBox.Position = UDim2.new(0, 2, 0, ty)
	urlBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	urlBox.PlaceholderText = "wss://your-server.com/ws"
	urlBox.Text = ENV.wsUrl
	urlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	urlBox.Font = Enum.Font.Gotham
	urlBox.TextSize = 11
	urlBox.ClearTextOnFocus = false
	urlBox.Parent = OwnerPage
	Instance.new("UICorner", urlBox).CornerRadius = UDim.new(0, 6)
	urlBox.FocusLost:Connect(function()
		ENV.wsUrl = urlBox.Text
		getgenv().HyperZ_WS_URL = urlBox.Text
	end)
	ty = ty + 32

	local connectBtn = Instance.new("TextButton")
	connectBtn.Size = UDim2.new(1, -4, 0, 26)
	connectBtn.Position = UDim2.new(0, 2, 0, ty)
	connectBtn.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	connectBtn.Text = "Connect WebSocket"
	connectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	connectBtn.Font = Enum.Font.GothamBold
	connectBtn.TextSize = 11
	connectBtn.Parent = OwnerPage
	Instance.new("UICorner", connectBtn).CornerRadius = UDim.new(0, 6)
	connectBtn.MouseButton1Click:Connect(function()
		playClick()
		ENV.wsUrl = urlBox.Text
		wsConnect()
	end)
	ty = ty + 32

	-- Auto connect for everyone so owners can reach them
	task.defer(function()
		task.wait(1)
		pcall(wsConnect)
	end)

	-- Cool HZ Billboard tag
	pcall(function()
		local function makeCoolTag(char, displayName)
			if not char then return end
			local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
			if not head then return end
			local old = head:FindFirstChild("HZUserTag")
			if old then old:Destroy() end
			local bb = Instance.new("BillboardGui")
			bb.Name = "HZUserTag"
			bb.Size = UDim2.new(0, 140, 0, 48)
			bb.StudsOffset = Vector3.new(0, 3.2, 0)
			bb.AlwaysOnTop = true
			bb.MaxDistance = 200
			bb.Parent = head
			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Color3.fromRGB(30, 18, 55)
			bg.BackgroundTransparency = 0.15
			bg.Parent = bb
			Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)
			local st = Instance.new("UIStroke", bg)
			st.Color = Color3.fromRGB(160, 80, 255)
			st.Thickness = 2
			local grad = Instance.new("UIGradient", bg)
			grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 40, 180)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 90)),
			})
			grad.Rotation = 90
			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, -8, 0, 22)
			title.Position = UDim2.new(0, 4, 0, 4)
			title.BackgroundTransparency = 1
			local isOwn = OWNERS[player.Name] == true and char == player.Character
			local tagOwner = char:GetAttribute("HZOwnerName")
			if tagOwner and OWNERS[tagOwner] then isOwn = true end
			-- same-server owner without attribute
			if not isOwn then
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr.Character == char and OWNERS[plr.Name] then
						isOwn = true
						break
					end
				end
			end
			if isOwn then
				title.Text = "👑 Owner👑"
				title.TextColor3 = Color3.fromRGB(255, 215, 80)
				st.Color = Color3.fromRGB(255, 200, 60)
				grad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 120, 20)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 40, 10)),
				})
			else
				title.Text = "⚡ HYPERZ"
				title.TextColor3 = Color3.fromRGB(230, 200, 255)
			end
			title.Font = Enum.Font.GothamBold
			title.TextSize = 13
			title.Parent = bg
			local sub = Instance.new("TextLabel")
			sub.Name = "GameLabel"
			sub.Size = UDim2.new(1, -8, 0, 16)
			sub.Position = UDim2.new(0, 4, 0, 26)
			sub.BackgroundTransparency = 1
			sub.Text = displayName or (game.Name or "Playing...")
			sub.TextColor3 = isOwn and Color3.fromRGB(255, 230, 150) or Color3.fromRGB(180, 160, 220)
			sub.Font = Enum.Font.Gotham
			sub.TextSize = 9
			sub.TextTruncate = Enum.TextTruncate.AtEnd
			sub.Parent = bg
			-- soft pulse on stroke
			task.spawn(function()
				while bb.Parent do
					for i = 1, 10 do
						st.Thickness = 1.5 + i * 0.15
						task.wait(0.05)
					end
					for i = 10, 1, -1 do
						st.Thickness = 1.5 + i * 0.15
						task.wait(0.05)
					end
				end
			end)
		end
		ENV.makeCoolTag = makeCoolTag
		local function tagSelf(ch)
			if ch then
				pcall(function() ch:SetAttribute("HZOwnerName", player.Name) end)
				makeCoolTag(ch, game.Name)
			end
		end
		if player.Character then tagSelf(player.Character) end
		player.CharacterAdded:Connect(function(ch)
			task.wait(0.3)
			tagSelf(ch)
		end)
	end)

	if IS_OWNER then
		local targetBox = Instance.new("TextBox")
		targetBox.Size = UDim2.new(1, -4, 0, 26)
		targetBox.Position = UDim2.new(0, 2, 0, ty)
		targetBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
		targetBox.PlaceholderText = "Target name (or all)"
		targetBox.Text = "all"
		targetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		targetBox.Font = Enum.Font.Gotham
		targetBox.TextSize = 11
		targetBox.ClearTextOnFocus = false
		targetBox.Parent = OwnerPage
		Instance.new("UICorner", targetBox).CornerRadius = UDim.new(0, 6)
		ty = ty + 32

		local msgBox = Instance.new("TextBox")
		msgBox.Size = UDim2.new(1, -4, 0, 26)
		msgBox.Position = UDim2.new(0, 2, 0, ty)
		msgBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
		msgBox.PlaceholderText = "Message text"
		msgBox.Text = ""
		msgBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		msgBox.Font = Enum.Font.Gotham
		msgBox.TextSize = 11
		msgBox.ClearTextOnFocus = false
		msgBox.Parent = OwnerPage
		Instance.new("UICorner", msgBox).CornerRadius = UDim.new(0, 6)
		ty = ty + 32

		local function ownerSend(cmd, extra)
			local t = targetBox.Text
			if t == "" then t = "all" end
			local payload = {
				cmd = cmd,
				target = t,
				from = player.Name,
			}
			if extra then
				for k, v in pairs(extra) do payload[k] = v end
			end
			if not wsSend(payload) then
				-- local fallback if WS down: only affects you when target is you/all
				handleWsCommand(payload)
			end
		end

		local cmds = {
			{"Send Message", function()
				ownerSend("message", {text = msgBox.Text ~= "" and msgBox.Text or "..."})
			end},
			{"Fling Target", function() ownerSend("fling") end},
			{"Freeze 5s", function() ownerSend("freeze", {time = 5}) end},
			{"Kick / Leave", function()
				ownerSend("kick", {reason = "Kicked by HyperZ owner"})
			end},
		}
		for _, pair in ipairs(cmds) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -4, 0, 26)
			b.Position = UDim2.new(0, 2, 0, ty)
			b.BackgroundColor3 = Color3.fromRGB(90, 40, 120)
			b.Text = pair[1]
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
			b.Font = Enum.Font.GothamBold
			b.TextSize = 11
			b.Parent = OwnerPage
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
			b.MouseButton1Click:Connect(function()
				playClick()
				pair[2]()
			end)
			ty = ty + 30
		end

		local note = Instance.new("TextLabel")
		note.Size = UDim2.new(1, -4, 0, 48)
		note.Position = UDim2.new(0, 2, 0, ty)
		note.BackgroundTransparency = 1
		note.Text = "Need a real WS server that broadcasts JSON. echo.websocket.events only echoes to you. Set your wss:// URL above."
		note.TextColor3 = Color3.fromRGB(180, 170, 220)
		note.Font = Enum.Font.Gotham
		note.TextSize = 10
		note.TextWrapped = true
		note.TextXAlignment = Enum.TextXAlignment.Left
		note.Parent = OwnerPage
		ty = ty + 52
	else
		local tip = Instance.new("TextLabel")
		tip.Size = UDim2.new(1, -4, 0, 40)
		tip.Position = UDim2.new(0, 2, 0, ty)
		tip.BackgroundTransparency = 1
		tip.Text = "Troll panel is owners only. You still auto-connect so owners can reach you."
		tip.TextColor3 = Color3.fromRGB(200, 180, 255)
		tip.Font = Enum.Font.Gotham
		tip.TextSize = 10
		tip.TextWrapped = true
		tip.Parent = OwnerPage
		ty = ty + 44
	end

		if IS_OWNER then
		local openAd = Instance.new("TextButton")
		openAd.Size = UDim2.new(1, -4, 0, 32)
		openAd.Position = UDim2.new(0, 2, 0, (ty or 200) + 8)
		openAd.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		openAd.Text = "Open Admin Commands"
		openAd.TextColor3 = Color3.fromRGB(255, 255, 255)
		openAd.Font = Enum.Font.GothamBold
		openAd.TextSize = 13
		openAd.Parent = OwnerPage
		Instance.new("UICorner", openAd).CornerRadius = UDim.new(0, 8)
		local st = Instance.new("UIStroke", openAd)
		st.Color = Color3.fromRGB(140, 110, 255)
		st.Thickness = 1.5
		openAd.MouseButton1Click:Connect(function()
			playClick()
			if ENV.openTrollGui then ENV.openTrollGui() end
		end)
		OwnerPage.CanvasSize = UDim2.new(0, 0, 0, (ty or 200) + 52)
	else
		OwnerPage.CanvasSize = UDim2.new(0, 0, 0, ty + 20)
	end
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

-- GAME 1 Bottle Flip / Escape
local function buildGame1Features()
	clearFeatures()
	-- auto farm pivot CFrame (0,0,0 with identity rotation)
	local FARM_CF = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	local W1 = Vector3.new(119, 14, -7)
	local W2 = Vector3.new(-5377, -88, -5)

	createSectionF("World 1", 0)
	createToggleF("Auto Farm Wins", 22, function(v)
		ENV.farm1 = v
		while ENV.farm1 do task.wait()
			pcall(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.CFrame = FARM_CF
				end
			end)
		end
	end)
	createButtonF("TP To World 1", 54, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(W1)
		end
	end)
	createSectionF("World 2", 90)
	createToggleF("Auto Farm Wins", 112, function(v)
		ENV.farm2 = v
		while ENV.farm2 do task.wait()
			pcall(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.CFrame = FARM_CF
				end
			end)
		end
	end)
	createButtonF("TP To World 2", 144, function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(W2)
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

-- Monkey Math / quiz helper (place 84718070904253)
local function buildGame6Features()
	clearFeatures()
	createSectionF("Monkey Math", 0)

	local qBox = Instance.new("TextBox")
	qBox.Size = UDim2.new(1, -4, 0, 40)
	qBox.Position = UDim2.new(0, 2, 0, 22)
	qBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	qBox.PlaceholderText = "Current question appears here..."
	qBox.Text = ""
	qBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	qBox.Font = Enum.Font.Gotham
	qBox.TextSize = 11
	qBox.TextWrapped = true
	qBox.ClearTextOnFocus = false
	qBox.Parent = FeaturesFrame
	Instance.new("UICorner", qBox).CornerRadius = UDim.new(0, 6)

	-- auto-update question text box from Line1
	task.spawn(function()
		while qBox.Parent do
			task.wait(0.25)
			local q = nil
			pcall(function()
				local line = workspace:FindFirstChild("Screen")
					and workspace.Screen:FindFirstChild("SurfaceGui")
					and workspace.Screen.SurfaceGui:FindFirstChild("Frame")
					and workspace.Screen.SurfaceGui.Frame:FindFirstChild("Line1")
				if line and line.Text and line.Text ~= "" then
					q = line.Text
				end
			end)
			if q and qBox.Text ~= q then
				qBox.Text = q
			end
		end
	end)

	local ansLbl = Instance.new("TextLabel")
	ansLbl.Size = UDim2.new(1, -4, 0, 22)
	ansLbl.Position = UDim2.new(0, 2, 0, 66)
	ansLbl.BackgroundTransparency = 1
	ansLbl.Text = "Answer: —"
	ansLbl.TextColor3 = Color3.fromRGB(180, 255, 180)
	ansLbl.Font = Enum.Font.GothamBold
	ansLbl.TextSize = 12
	ansLbl.TextXAlignment = Enum.TextXAlignment.Left
	ansLbl.Parent = FeaturesFrame

	-- Solves ALL math questions dynamically (covers every + - * / expression)
	local function solveMath(text)
		if not text or text == "" then return nil end
		local t = tostring(text)
		t = t:gsub(",", "")
		t = t:gsub("[Ww]hat is", "")
		t = t:gsub("[Ss]olve", "")
		t = t:gsub("[Ee]quals%??", "")
		t = t:gsub("%?", "")
		t = t:gsub("=", " ")
		t = t:gsub("[Pp]lus", "+")
		t = t:gsub("[Mm]inus", "-")
		t = t:gsub("[Tt]imes", "*")
		t = t:gsub("[Mm]ultiplied by", "*")
		t = t:gsub("[Dd]ivided by", "/")
		t = t:gsub("×", "*")
		t = t:gsub("x", "*")
		t = t:gsub("X", "*")
		t = t:gsub("÷", "/")
		t = t:gsub("%s+", "")
		if not t:match("^[0-9%+%-%*/%.%(%)]+$") then
			local expr = tostring(text):match("(%-?%d[%d%.%s%+%-%*/x×÷X]*)")
			if expr then
				t = expr:gsub("×", "*"):gsub("[xX]", "*"):gsub("÷", "/"):gsub("%s+", "")
			else
				return nil
			end
			if not t:match("^[0-9%+%-%*/%.%(%)]+$") then return nil end
		end
		if t == "" then return nil end
		local fn = loadstring("return (" .. t .. ")")
		if not fn then return nil end
		local ok, result = pcall(fn)
		if not ok or type(result) ~= "number" then return nil end
		if result ~= result then return nil end
		if math.abs(result - math.floor(result + 0.5)) < 1e-9 then
			return math.floor(result + 0.5)
		end
		return math.floor(result * 10000 + 0.5) / 10000
	end

	local function findQuestionFromGame()
		local q = nil
		pcall(function()
			local screen = workspace:FindFirstChild("Screen")
			if not screen then return end
			local sg = screen:FindFirstChild("SurfaceGui")
			if not sg then return end
			local frame = sg:FindFirstChild("Frame")
			if not frame then return end
			local line = frame:FindFirstChild("Line1")
			if line and line.Text and line.Text ~= "" then
				q = line.Text
			end
		end)
		if q and q ~= "" then return q end
		-- fallback scan
		pcall(function()
			local screen = workspace:FindFirstChild("Screen")
			if not screen then return end
			for _, d in ipairs(screen:GetDescendants()) do
				if (d:IsA("TextLabel") or d:IsA("TextBox")) and d.Text and #d.Text > 0 then
					if d.Text:match("%d") and d.Text:find("[%+%-%*/x×÷=]") then
						q = d.Text
						break
					end
				end
			end
		end)
		return q
	end

	local function currentAnswer()
		local q = findQuestionFromGame() or qBox.Text
		if q and q ~= "" then qBox.Text = q end
		return solveMath(q or ""), q
	end

	local function trySubmitAnswer(ans)
		if ans == nil then return false end
		local s = tostring(ans)
		-- integer answers without .0
		if type(ans) == "number" and math.floor(ans) == ans then
			s = tostring(math.floor(ans))
		end
		local ok = false
		pcall(function()
			local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
			if not remotes then
				remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 3)
			end
			if not remotes then return end
			local typing = remotes:FindFirstChild("TypingUpdate")
			local submit = remotes:FindFirstChild("SubmitAnswer")
			if typing then
				-- send full answer as typed text
				typing:FireServer(s)
				ok = true
			end
			task.wait(0.08)
			if submit then
				submit:FireServer(s)
				ok = true
			end
		end)
		return ok
	end

	ENV.autoAnsDelay = ENV.autoAnsDelay or 1

	createButtonF("Refresh Question", 92, function()
		local q = findQuestionFromGame()
		if q then
			qBox.Text = q
			local a = solveMath(q)
			ansLbl.Text = a ~= nil and ("Answer: " .. tostring(a)) or "Answer: ?"
		end
	end)

	createButtonF("Show Answer", 124, function()
		local q = findQuestionFromGame()
		if q and q ~= "" then qBox.Text = q end
		local a = solveMath(qBox.Text)
		if a ~= nil then
			ansLbl.Text = "Answer: " .. tostring(a)
		else
			ansLbl.Text = "Answer: ?"
		end
	end)

	createButtonF("Submit Answer Once", 156, function()
		local a = currentAnswer()
		if a == nil then return end
		ansLbl.Text = "Answer: " .. tostring(a)
		trySubmitAnswer(a)
	end)

	-- Auto Ans Delay (1-5) slider + number input
	local delayLabel = Instance.new("TextLabel")
	delayLabel.Size = UDim2.new(1, -4, 0, 16)
	delayLabel.Position = UDim2.new(0, 2, 0, 188)
	delayLabel.BackgroundTransparency = 1
	delayLabel.Text = "Auto Ans Delay"
	delayLabel.TextColor3 = Color3.fromRGB(220, 210, 255)
	delayLabel.Font = Enum.Font.GothamBold
	delayLabel.TextSize = 11
	delayLabel.TextXAlignment = Enum.TextXAlignment.Left
	delayLabel.Parent = FeaturesFrame

	local delayInput = Instance.new("TextBox")
	delayInput.Size = UDim2.new(0, 40, 0, 22)
	delayInput.Position = UDim2.new(1, -44, 0, 186)
	delayInput.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	delayInput.Text = tostring(ENV.autoAnsDelay)
	delayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	delayInput.Font = Enum.Font.Gotham
	delayInput.TextSize = 12
	delayInput.ClearTextOnFocus = false
	delayInput.Parent = FeaturesFrame
	Instance.new("UICorner", delayInput).CornerRadius = UDim.new(0, 4)

	local delayBar = Instance.new("Frame")
	delayBar.Size = UDim2.new(1, -50, 0, 10)
	delayBar.Position = UDim2.new(0, 2, 0, 210)
	delayBar.BackgroundColor3 = Color3.fromRGB(40, 35, 80)
	delayBar.BorderSizePixel = 0
	delayBar.Parent = FeaturesFrame
	Instance.new("UICorner", delayBar).CornerRadius = UDim.new(0, 4)

	local delayFill = Instance.new("Frame")
	delayFill.Size = UDim2.new((ENV.autoAnsDelay - 1) / 4, 0, 1, 0)
	delayFill.BackgroundColor3 = Color3.fromRGB(140, 100, 255)
	delayFill.BorderSizePixel = 0
	delayFill.Parent = delayBar
	Instance.new("UICorner", delayFill).CornerRadius = UDim.new(0, 4)

	local function setDelay(n)
		n = math.clamp(math.floor(tonumber(n) or 1), 1, 5)
		ENV.autoAnsDelay = n
		delayInput.Text = tostring(n)
		delayFill.Size = UDim2.new((n - 1) / 4, 0, 1, 0)
	end

	delayInput:GetPropertyChangedSignal("Text"):Connect(function()
		local t = delayInput.Text:gsub("[^0-9]", "")
		if t ~= delayInput.Text then delayInput.Text = t end
	end)
	delayInput.FocusLost:Connect(function()
		setDelay(delayInput.Text)
	end)

	delayBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local function update(pos)
				local rel = math.clamp((pos.X - delayBar.AbsolutePosition.X) / delayBar.AbsoluteSize.X, 0, 1)
				setDelay(1 + math.floor(rel * 4 + 0.5))
			end
			update(input.Position)
			local move, endc
			move = UserInputService.InputChanged:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
					update(inp.Position)
				end
			end)
			endc = UserInputService.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
					move:Disconnect()
					endc:Disconnect()
				end
			end)
		end
	end)

	createToggleF("Auto Ans", 228, function(v)
		ENV.monkeyAutoAns = v
		local lastQ = ""
		while ENV.monkeyAutoAns do
			task.wait(ENV.autoAnsDelay or 1)
			local q = findQuestionFromGame()
			if q and q ~= "" then
				qBox.Text = q
				local a = solveMath(q)
				if a ~= nil then
					ansLbl.Text = "Answer: " .. tostring(a)
					if q ~= lastQ then
						lastQ = q
						trySubmitAnswer(a)
					end
				end
			end
		end
	end)

	createButtonF("Reset to Normal", 260, function()
		setDelay(1)
		ENV.monkeyAutoAns = false
		ansLbl.Text = "Answer: —"
		qBox.Text = ""
	end)

	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 310)
end


-- BABFT / Build place 537413528
local function buildGame7Features()
	clearFeatures()
	createSectionF("Preset Builds", 0)

	-- Named from your YouTube links + common BABFT tutorials
	local PRESETS = {
		{Name = "RC Cybertruck", Mats = {WoodBlock = 80, MetalBlock = 40, PlasticBlock = 30}, Sec = 18},
		{Name = "Missile Launcher", Mats = {WoodBlock = 25, MetalBlock = 50, TitaniumBlock = 10}, Sec = 12},
		{Name = "Speed Boat", Mats = {WoodBlock = 40, PlasticBlock = 20}, Sec = 10},
		{Name = "Tank Build", Mats = {MetalBlock = 60, WoodBlock = 20, ConcreteBlock = 15}, Sec = 16},
		{Name = "Plane Build", Mats = {WoodBlock = 35, FabricBlock = 25, MetalBlock = 15}, Sec = 14},
		{Name = "Simple Raft", Mats = {WoodBlock = 20}, Sec = 6},
	}
	ENV.babftPreset = ENV.babftPreset or PRESETS[1].Name
	ENV.babftBuild = ENV.babftBuild or "WoodBlock"

	local MATERIALS = {
		"WoodBlock", "PlasticBlock", "MetalBlock", "ConcreteBlock",
		"GlassBlock", "TitaniumBlock", "MarbleBlock", "BrickBlock",
		"FabricBlock", "GrassBlock", "SandBlock", "IceBlock",
	}

	local ZONE_NAMES = {
		"WhiteZone",
		"Really redZone",
		"Really blueZone",
		"BlackZone",
		"CamoZone",
		"MagentaZone",
		"New YellerZone",
	}

	local function findZone()
		local names = {}
		pcall(function()
			table.insert(names, player.TeamColor.Name .. "Zone")
		end)
		for _, n in ipairs(ZONE_NAMES) do table.insert(names, n) end
		for _, name in ipairs(names) do
			local ok, z = pcall(function() return workspace[name] end)
			if ok and z then return z end
			z = workspace:FindFirstChild(name)
			if z then return z end
		end
		-- last resort: any child with Zone in name
		for _, ch in ipairs(workspace:GetChildren()) do
			if string.find(ch.Name, "Zone") then return ch end
		end
		return nil
	end

	local function getZoneBuildCFrame(zone, root)
		local base = nil
		if zone:IsA("BasePart") then
			base = zone
		else
			-- largest BasePart under zone (the pad)
			local best, bestVol = nil, 0
			for _, d in ipairs(zone:GetDescendants()) do
				if d:IsA("BasePart") then
					local vol = d.Size.X * d.Size.Y * d.Size.Z
					if vol > bestVol then bestVol, best = vol, d end
				end
			end
			base = best or zone:FindFirstChildWhichIsA("BasePart", true)
		end
		if base then
			-- on top of pad center, slight grid offset
			local gx = math.floor(math.random() * 5) - 2
			local gz = math.floor(math.random() * 5) - 2
			return base.CFrame * CFrame.new(gx * 2, base.Size.Y / 2 + 1, gz * 2)
		end
		if root then
			return CFrame.new(root.Position + Vector3.new(0, -2, -5))
		end
		return CFrame.new(0, 6, 0)
	end

	local function getPreset(name)
		for _, p in ipairs(PRESETS) do
			if p.Name == name then return p end
		end
		return PRESETS[1]
	end

	local function getBuildingTool()
		local char = player.Character
		if not char then return nil end
		local tool = char:FindFirstChild("BuildingTool")
		if tool then return tool end
		tool = player.Backpack:FindFirstChild("BuildingTool")
		if tool then return tool end
		for _, parent in ipairs({char, player.Backpack}) do
			for _, t in ipairs(parent:GetChildren()) do
				if t:IsA("Tool") and t:FindFirstChild("RF") then return t end
			end
		end
		return nil
	end

	local function materialsComplete(preset)
		local tool = getBuildingTool()
		if not tool then return false, "Need BuildingTool" end
		local zone = findZone()
		if not zone then return false, "Zone not found" end
		return true, "Ready | " .. zone.Name
	end

	local function placeBlock(blockName, doTp)
		local char = player.Character
		if not char then return false, "No character" end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return false, "No HRP" end

		local tool = getBuildingTool()
		if not tool then return false, "No BuildingTool" end

		-- equip until RF is on Character.BuildingTool
		if tool.Parent ~= char and hum then
			pcall(function() hum:UnequipTools() end)
			task.wait(0.05)
			pcall(function() hum:EquipTool(tool) end)
			for i = 1, 10 do
				task.wait(0.05)
				if char:FindFirstChild("BuildingTool") or char:FindFirstChild(tool.Name) then break end
			end
			tool = char:FindFirstChild("BuildingTool") or char:FindFirstChild(tool.Name) or tool
		end

		local rf = tool:FindFirstChild("RF")
		if not rf then
			rf = tool:FindFirstChild("RF", true)
		end
		-- exact path user used
		pcall(function()
			local t2 = char:FindFirstChild("BuildingTool")
			if t2 and t2:FindFirstChild("RF") then
				tool = t2
				rf = t2.RF
			end
		end)
		if not rf then return false, "RF missing (equip BuildingTool)" end

		local zone = findZone()
		if not zone then return false, "No zone" end

		local placeCf = getZoneBuildCFrame(zone, root)
		-- also try right under player if they're already in zone
		local nearPlayer = CFrame.new(root.Position.X, placeCf.Position.Y, root.Position.Z - 4)

		if doTp then
			pcall(function()
				root.CFrame = CFrame.new(placeCf.Position + Vector3.new(0, 5, 12), placeCf.Position)
			end)
			task.wait(0.05)
		end

		local function tryInvoke(a1, a2, a3, a4, a5, a6, a7, a8)
			local args = {a1, a2, a3, a4, a5, a6, a7, a8}
			local ok, res = pcall(function()
				return rf:InvokeServer(unpack(args))
			end)
			return ok, res
		end

		-- pattern matching your remote dump
		local attempts = {
			function()
				return tryInvoke(
					blockName, 1108, zone,
					placeCf, true,
					placeCf * CFrame.Angles(0, -1.5707963705062866, 0),
					false, true
				)
			end,
			function()
				return tryInvoke(
					blockName, 1108, zone,
					nearPlayer, true,
					nearPlayer * CFrame.Angles(0, -1.5707963705062866, 0),
					false, true
				)
			end,
			function()
				return tryInvoke(
					blockName, 1, zone,
					placeCf, true,
					placeCf * CFrame.Angles(0, -math.pi / 2, 0),
					false, true
				)
			end,
			function()
				return tryInvoke(
					blockName, 1108, zone,
					CFrame.new(placeCf.Position), true,
					CFrame.new(root.Position) * CFrame.Angles(0, -1.5707963705062866, 0),
					false, true
				)
			end,
		}

		local lastErr = "unknown"
		for _, fn in ipairs(attempts) do
			local ok, res = fn()
			if ok then
				return true, "Placed " .. tostring(blockName)
			end
			lastErr = tostring(res)
		end

		-- FireServer fallback
		local ok2 = pcall(function()
			rf:FireServer(
				blockName, 1108, zone,
				placeCf, true,
				placeCf * CFrame.Angles(0, -1.5707963705062866, 0),
				false, true
			)
		end)
		if ok2 then return true, "Fired " .. tostring(blockName) end

		return false, lastErr
	end

	-- preset dropdown
	local pDrop = Instance.new("TextButton")
	pDrop.Size = UDim2.new(1, -4, 0, 26)
	pDrop.Position = UDim2.new(0, 2, 0, 22)
	pDrop.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	pDrop.Text = "  " .. ENV.babftPreset .. "  ∇"
	pDrop.TextColor3 = Color3.fromRGB(255, 255, 255)
	pDrop.Font = Enum.Font.GothamBold
	pDrop.TextSize = 11
	pDrop.TextXAlignment = Enum.TextXAlignment.Left
	pDrop.Parent = FeaturesFrame
	Instance.new("UICorner", pDrop).CornerRadius = UDim.new(0, 6)

	local pList = Instance.new("ScrollingFrame")
	pList.Size = UDim2.new(1, -4, 0, 120)
	pList.Position = UDim2.new(0, 2, 0, 50)
	pList.BackgroundColor3 = Color3.fromRGB(40, 35, 90)
	pList.Visible = false
	pList.ZIndex = 80
	pList.ScrollBarThickness = 5
	pList.BorderSizePixel = 0
	pList.Parent = FeaturesFrame
	Instance.new("UICorner", pList).CornerRadius = UDim.new(0, 6)

	local matLbl = Instance.new("TextLabel")
	matLbl.Size = UDim2.new(1, -4, 0, 36)
	matLbl.Position = UDim2.new(0, 2, 0, 50)
	matLbl.BackgroundTransparency = 1
	matLbl.Text = "Materials: select a build first"
	matLbl.TextColor3 = Color3.fromRGB(200, 190, 255)
	matLbl.Font = Enum.Font.Gotham
	matLbl.TextSize = 10
	matLbl.TextWrapped = true
	matLbl.TextXAlignment = Enum.TextXAlignment.Left
	matLbl.Parent = FeaturesFrame

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(1, -4, 0, 16)
	statusLbl.Position = UDim2.new(0, 2, 0, 88)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = "Status: —"
	statusLbl.TextColor3 = Color3.fromRGB(180, 255, 180)
	statusLbl.Font = Enum.Font.GothamBold
	statusLbl.TextSize = 10
	statusLbl.TextXAlignment = Enum.TextXAlignment.Left
	statusLbl.Parent = FeaturesFrame

	local function refreshMats()
		local pr = getPreset(ENV.babftPreset)
		local parts = {}
		for k, v in pairs(pr.Mats) do
			table.insert(parts, k .. " x" .. tostring(v))
		end
		table.sort(parts)
		matLbl.Text = "Need (" .. pr.Name .. "): " .. (#parts > 0 and table.concat(parts, " | ") or "—")
		local ok, msg = materialsComplete(pr)
		statusLbl.Text = "Status: " .. tostring(msg)
		statusLbl.TextColor3 = ok and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(255, 140, 140)
		-- rebuild material dropdown from preset amounts + full list
		if rebuildMatList then rebuildMatList() end
	end

	local y = 2
	for _, pr in ipairs(PRESETS) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -8, 0, 22)
		b.Position = UDim2.new(0, 4, 0, y)
		b.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		b.Text = "  " .. pr.Name
		b.TextColor3 = Color3.fromRGB(230, 220, 255)
		b.Font = Enum.Font.Gotham
		b.TextSize = 11
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.ZIndex = 31
		b.Parent = pList
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
		b.MouseButton1Click:Connect(function()
			playClick()
			clickPunch(b)
			ENV.babftPreset = pr.Name
			ENV.babftSelected = true
			for k, _ in pairs(pr.Mats) do
				ENV.babftBuild = k
				break
			end
			pDrop.Text = "  " .. pr.Name .. "  ∇"
			pList.Visible = false
			matLbl.Visible = true
			refreshMats()
			rebuildMatList()
			local amt = pr.Mats[ENV.babftBuild]
			mDrop.Text = "  " .. tostring(ENV.babftBuild) .. (amt and (" x" .. amt) or "") .. "  ∇"
			statusLbl.Text = "Status: Selected " .. pr.Name
			statusLbl.TextColor3 = Color3.fromRGB(180, 220, 255)
		end)
		y = y + 24
	end
	pList.CanvasSize = UDim2.new(0, 0, 0, y + 4)

	pDrop.MouseButton1Click:Connect(function()
		playClick()
		clickPunch(pDrop)
		mList.Visible = false
		local open = not pList.Visible
		pList.Visible = open
		matLbl.Visible = not open
		pDrop.Text = "  " .. tostring(ENV.babftPreset) .. (open and "  ∆" or "  ∇")
	end)

	-- Material dropdown
	createSectionF("Material", 110)
	local mDrop = Instance.new("TextButton")
	mDrop.Size = UDim2.new(1, -4, 0, 26)
	mDrop.Position = UDim2.new(0, 2, 0, 132)
	mDrop.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	mDrop.Text = "  Materials (select build)  ∇"
	mDrop.TextColor3 = Color3.fromRGB(255, 255, 255)
	mDrop.Font = Enum.Font.GothamBold
	mDrop.TextSize = 11
	mDrop.TextXAlignment = Enum.TextXAlignment.Left
	mDrop.Parent = FeaturesFrame
	Instance.new("UICorner", mDrop).CornerRadius = UDim.new(0, 6)

	local mList = Instance.new("ScrollingFrame")
	mList.Size = UDim2.new(1, -4, 0, 100)
	mList.Position = UDim2.new(0, 2, 0, 160)
	mList.BackgroundColor3 = Color3.fromRGB(40, 35, 90)
	mList.Visible = false
	mList.ZIndex = 80
	mList.ScrollBarThickness = 5
	mList.BorderSizePixel = 0
	mList.Parent = FeaturesFrame
	Instance.new("UICorner", mList).CornerRadius = UDim.new(0, 6)

	ENV.babftSelected = ENV.babftSelected or false

	function rebuildMatList()
		for _, ch in ipairs(mList:GetChildren()) do
			if ch:IsA("TextButton") or ch:IsA("TextLabel") then ch:Destroy() end
		end
		local my = 2
		if not ENV.babftSelected then
			local empty = Instance.new("TextLabel")
			empty.Size = UDim2.new(1, -8, 0, 40)
			empty.Position = UDim2.new(0, 4, 0, 4)
			empty.BackgroundTransparency = 1
			empty.Text = "Select a Preset Build first"
			empty.TextColor3 = Color3.fromRGB(255, 180, 140)
			empty.Font = Enum.Font.GothamBold
			empty.TextSize = 11
			empty.ZIndex = 31
			empty.Parent = mList
			mList.CanvasSize = UDim2.new(0, 0, 0, 50)
			mDrop.Text = "  Materials (select build)  ∇"
			return
		end
		local pr = getPreset(ENV.babftPreset)
		local ordered = {}
		for k, v in pairs(pr.Mats) do table.insert(ordered, {k, v}) end
		table.sort(ordered, function(a, b) return a[1] < b[1] end)
		for _, pair in ipairs(ordered) do
			local name, amt = pair[1], pair[2]
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -8, 0, 24)
			b.Position = UDim2.new(0, 4, 0, my)
			b.BackgroundColor3 = Color3.fromRGB(70, 60, 130)
			b.Text = "  " .. name .. "   x" .. tostring(amt)
			b.TextColor3 = Color3.fromRGB(255, 230, 150)
			b.Font = Enum.Font.GothamBold
			b.TextSize = 11
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.ZIndex = 31
			b.Parent = mList
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
			b.MouseButton1Click:Connect(function()
				playClick()
				clickPunch(b)
				ENV.babftBuild = name
				mDrop.Text = "  " .. name .. " x" .. tostring(amt) .. "  ∇"
				mList.Visible = false
			end)
			my = my + 26
		end
		mList.CanvasSize = UDim2.new(0, 0, 0, my + 4)
	end
	rebuildMatList()

	mDrop.MouseButton1Click:Connect(function()
		playClick()
		clickPunch(mDrop)
		pList.Visible = false
		rebuildMatList()
		local open = not mList.Visible
		mList.Visible = open
		local label = ENV.babftBuild or "Material"
		mDrop.Text = "  " .. label .. (open and "  ∆" or "  ∇")
	end)

	createButtonF("Select Build", 268, function()
		local pr = getPreset(ENV.babftPreset)
		ENV.babftSelected = true
		for k, _ in pairs(pr.Mats) do
			ENV.babftBuild = k
			break
		end
		refreshMats()
		rebuildMatList()
		local amt = pr.Mats[ENV.babftBuild]
		pDrop.Text = "  " .. pr.Name .. "  ∇"
		mDrop.Text = "  " .. tostring(ENV.babftBuild) .. (amt and (" x" .. amt) or "") .. "  ∇"
		statusLbl.Text = "Status: Build selected — " .. pr.Name
		statusLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
	end)

	local function tryBuyMaterial(blockName, amount)
		amount = tonumber(amount) or 1
		local ok, err = pcall(function()
			local remote = workspace:FindFirstChild("ItemBoughtFromShop")
			if not remote then
				remote = workspace:FindFirstChild("ItemBoughtFromShop", true)
			end
			if not remote then error("ItemBoughtFromShop missing") end
			local args = {
				[1] = blockName,
				[2] = amount,
			}
			remote:InvokeServer(unpack(args))
		end)
		return ok, err
	end

	createToggleF("Auto Buy Materials", 300, function(v)
		ENV.babftAutoBuy = v
		task.spawn(function()
			while ENV.babftAutoBuy do
				if ENV.babftSelected then
					local pr = getPreset(ENV.babftPreset)
					for mat, amt in pairs(pr.Mats) do
						local ok, err = tryBuyMaterial(mat, amt)
						if ok then
							statusLbl.Text = "Status: Bought " .. tostring(mat) .. " x" .. tostring(amt)
							statusLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
						else
							statusLbl.Text = "Status: Buy fail " .. tostring(err)
							statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
						end
						task.wait(0.25)
					end
				end
				task.wait(1.5)
			end
		end)
	end)

	createToggleF("Auto Build", 332, function(v)
		ENV.babftAuto = v
		if not v then
			statusLbl.Text = "Status: Auto Build OFF"
			return
		end
		if not ENV.babftSelected then
			statusLbl.Text = "Status: Select a Preset Build first"
			statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
			ENV.babftAuto = false
			return
		end
		local n = 0
		task.spawn(function()
			while ENV.babftAuto do
				local pr = getPreset(ENV.babftPreset)
				local ok, msg = materialsComplete(pr)
				if not ok then
					statusLbl.Text = "Status: " .. tostring(msg)
					statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
					task.wait(0.6)
				else
					n = n + 1
					local keys = {}
					for k, _ in pairs(pr.Mats) do table.insert(keys, k) end
					table.sort(keys)
					local block = ENV.babftBuild or "WoodBlock"
					if #keys > 0 then block = keys[((n - 1) % #keys) + 1] end
					local placed, pmsg = placeBlock(block, n == 1 or n % 20 == 0)
					if placed then
						statusLbl.Text = "Status: Placing #" .. n .. " " .. tostring(block)
						statusLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
					else
						statusLbl.Text = "Status: " .. tostring(pmsg)
						statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
					end
					task.wait(0.2)
				end
			end
		end)
	end)

	createSectionF("Manual Buy", 364)

	ENV.babftBuyAmount = ENV.babftBuyAmount or 10
	ENV.babftManualBlock = ENV.babftManualBlock or "WoodBlock"

	local ALL_BLOCKS = {
		"WoodBlock", "PlasticBlock", "MetalBlock", "ConcreteBlock",
		"GlassBlock", "TitaniumBlock", "MarbleBlock", "BrickBlock",
		"FabricBlock", "GrassBlock", "SandBlock", "IceBlock",
		"ObsidianBlock", "RustedBlock", "BouncyBlock", "Candle",
		"Seat", "Button", "Switch", "Motor", "Servo", "Thruster",
		"Balloon", "Rope", "Spring", "Piston", "Hinge", "BoatMotor",
		"FrontWheel", "BackWheel", "Trowel", "Harpoon",
	}

	local amtLbl = Instance.new("TextLabel")
	amtLbl.Size = UDim2.new(0.35, 0, 0, 18)
	amtLbl.Position = UDim2.new(0, 2, 0, 386)
	amtLbl.BackgroundTransparency = 1
	amtLbl.Text = "Amount"
	amtLbl.TextColor3 = Color3.fromRGB(200, 190, 255)
	amtLbl.Font = Enum.Font.GothamBold
	amtLbl.TextSize = 11
	amtLbl.TextXAlignment = Enum.TextXAlignment.Left
	amtLbl.Parent = FeaturesFrame

	local amtBox = Instance.new("TextBox")
	amtBox.Name = "Amount"
	amtBox.Size = UDim2.new(0.6, -6, 0, 26)
	amtBox.Position = UDim2.new(0.4, 0, 0, 382)
	amtBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	amtBox.PlaceholderText = "Amount"
	amtBox.Text = tostring(ENV.babftBuyAmount)
	amtBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	amtBox.Font = Enum.Font.GothamBold
	amtBox.TextSize = 12
	amtBox.ClearTextOnFocus = false
	amtBox.Parent = FeaturesFrame
	Instance.new("UICorner", amtBox).CornerRadius = UDim.new(0, 6)
	amtBox.FocusLost:Connect(function()
		local n = tonumber(amtBox.Text)
		if n then
			ENV.babftBuyAmount = math.clamp(math.floor(n), 1, 9999)
			amtBox.Text = tostring(ENV.babftBuyAmount)
		else
			amtBox.Text = tostring(ENV.babftBuyAmount)
		end
	end)

	local blockDrop = Instance.new("TextButton")
	blockDrop.Size = UDim2.new(1, -4, 0, 26)
	blockDrop.Position = UDim2.new(0, 2, 0, 414)
	blockDrop.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	blockDrop.Text = "  " .. ENV.babftManualBlock .. "  ∇"
	blockDrop.TextColor3 = Color3.fromRGB(255, 255, 255)
	blockDrop.Font = Enum.Font.GothamBold
	blockDrop.TextSize = 11
	blockDrop.TextXAlignment = Enum.TextXAlignment.Left
	blockDrop.Parent = FeaturesFrame
	Instance.new("UICorner", blockDrop).CornerRadius = UDim.new(0, 6)
	addHover(blockDrop, Color3.fromRGB(55, 50, 115), Color3.fromRGB(85, 75, 160))

	local blockList = Instance.new("ScrollingFrame")
	blockList.Size = UDim2.new(1, -4, 0, 120)
	blockList.Position = UDim2.new(0, 2, 0, 442)
	blockList.BackgroundColor3 = Color3.fromRGB(40, 35, 90)
	blockList.Visible = false
	blockList.ZIndex = 90
	blockList.ScrollBarThickness = 5
	blockList.BorderSizePixel = 0
	blockList.Parent = FeaturesFrame
	Instance.new("UICorner", blockList).CornerRadius = UDim.new(0, 6)

	local by = 2
	for _, name in ipairs(ALL_BLOCKS) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -8, 0, 22)
		b.Position = UDim2.new(0, 4, 0, by)
		b.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
		b.Text = "  " .. name
		b.TextColor3 = Color3.fromRGB(230, 220, 255)
		b.Font = Enum.Font.Gotham
		b.TextSize = 11
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.ZIndex = 91
		b.Parent = blockList
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
		b.MouseButton1Click:Connect(function()
			playClick()
			clickPunch(b)
			ENV.babftManualBlock = name
			blockDrop.Text = "  " .. name .. "  ∇"
			blockList.Visible = false
		end)
		by = by + 24
	end
	blockList.CanvasSize = UDim2.new(0, 0, 0, by + 4)

	blockDrop.MouseButton1Click:Connect(function()
		playClick()
		clickPunch(blockDrop)
		local open = not blockList.Visible
		blockList.Visible = open
		blockDrop.Text = "  " .. ENV.babftManualBlock .. (open and "  ∆" or "  ∇")
	end)

	createButtonF("Buy Current Block (Manual)", 450, function()
		local n = tonumber(amtBox.Text) or ENV.babftBuyAmount or 1
		n = math.clamp(math.floor(n), 1, 9999)
		ENV.babftBuyAmount = n
		local block = ENV.babftManualBlock or "WoodBlock"
		local ok, err = tryBuyMaterial(block, n)
		if ok then
			statusLbl.Text = "Status: Bought " .. block .. " x" .. tostring(n)
			statusLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
		else
			statusLbl.Text = "Status: Buy fail " .. tostring(err)
			statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
		end
	end)

	-- spacer before load preset
	createButtonF("Load Preset Build", 486, function()
		local pr = getPreset(ENV.babftPreset)
		local ok, msg = materialsComplete(pr)
		refreshMats()
		if not ok then
			statusLbl.Text = "Status: " .. tostring(msg)
			statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
			return
		end
		statusLbl.Text = "Status: Building " .. pr.Name .. "..."
		statusLbl.TextColor3 = Color3.fromRGB(180, 220, 255)
		task.spawn(function()
			local t0 = tick()
			local n = 0
			local keys = {}
			for k, _ in pairs(pr.Mats) do table.insert(keys, k) end
			if #keys == 0 then keys = {ENV.babftBuild or "WoodBlock"} end
			local placedAny = false
			while tick() - t0 < pr.Sec do
				n = n + 1
				local block = keys[((n - 1) % #keys) + 1]
				local placed, pmsg = placeBlock(block, n == 1)
				if placed then placedAny = true end
				statusLbl.Text = string.format("Status: %s %s %s %.1fs", pr.Name, placed and "OK" or "FAIL", block, pr.Sec - (tick() - t0))
				statusLbl.TextColor3 = placed and Color3.fromRGB(180, 220, 255) or Color3.fromRGB(255, 140, 140)
				task.wait(0.15)
			end
			if placedAny then
				statusLbl.Text = "Status: Preset done (placed)"
				statusLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
			else
				statusLbl.Text = "Status: Preset finished but no blocks placed"
				statusLbl.TextColor3 = Color3.fromRGB(255, 180, 100)
			end
		end)
	end)

	-- Custom build
	createSectionF("Custom Build", 520)
	local customBox = Instance.new("TextBox")
	customBox.Size = UDim2.new(1, -4, 0, 26)
	customBox.Position = UDim2.new(0, 2, 0, 542)
	customBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	customBox.PlaceholderText = "Block name e.g. WoodBlock"
	customBox.Text = ""
	customBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	customBox.Font = Enum.Font.Gotham
	customBox.TextSize = 11
	customBox.ClearTextOnFocus = false
	customBox.Parent = FeaturesFrame
	Instance.new("UICorner", customBox).CornerRadius = UDim.new(0, 6)

	local timeBox = Instance.new("TextBox")
	timeBox.Size = UDim2.new(0.45, 0, 0, 26)
	timeBox.Position = UDim2.new(0, 2, 0, 572)
	timeBox.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
	timeBox.PlaceholderText = "Seconds"
	timeBox.Text = "10"
	timeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	timeBox.Font = Enum.Font.Gotham
	timeBox.TextSize = 11
	timeBox.ClearTextOnFocus = false
	timeBox.Parent = FeaturesFrame
	Instance.new("UICorner", timeBox).CornerRadius = UDim.new(0, 6)

	createButtonF("Add Custom Build", 604, function()
		local block = customBox.Text
		if block == "" then
			statusLbl.Text = "Status: Enter block name"
			statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
			return
		end
		local sec = tonumber(timeBox.Text) or 10
		sec = math.clamp(sec, 1, 120)
		local pr = {Name = "Custom", Mats = {[block] = 1}, Sec = sec}
		local ok, msg = materialsComplete(pr)
		if not ok then
			statusLbl.Text = "Status: " .. msg .. " (custom blocked)"
			statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
			return
		end
		ENV.babftBuild = block
		mDrop.Text = "  " .. block .. "  ▼"
		statusLbl.Text = "Status: Custom building " .. sec .. "s..."
		statusLbl.TextColor3 = Color3.fromRGB(180, 220, 255)
		task.spawn(function()
			local t0 = tick()
			while tick() - t0 < sec do
				if not materialsComplete(pr) then
					statusLbl.Text = "Status: Materials incomplete — stopped"
					statusLbl.TextColor3 = Color3.fromRGB(255, 140, 140)
					return
				end
				placeBlock(block)
				statusLbl.Text = string.format("Status: Custom %.1fs left", sec - (tick() - t0))
				task.wait(0.12)
			end
			statusLbl.Text = "Status: Custom done"
			statusLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
		end)
	end)

	refreshMats()
	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 660)
end


-- Studio Lite / HypeAI (place 10959918411)
local function buildGame8Features()
	clearFeatures()
	createSectionF("HypeAI / CoAI Loader", 0)

	ENV.hypeAI = ENV.hypeAI or {
		name = "HypeAI",
		mode = "Fast",
		loading = false,
		progress = 0,
		ultraReady = false,
		loaded = false,
	}

	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(1, -4, 0, 280)
	panel.Position = UDim2.new(0, 2, 0, 22)
	panel.BackgroundColor3 = Color3.fromRGB(162, 162, 162)
	panel.BorderSizePixel = 0
	panel.Parent = FeaturesFrame
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
	local pStroke = Instance.new("UIStroke", panel)
	pStroke.Thickness = 3
	pStroke.Color = Color3.fromRGB(0, 0, 0)
	local pGrad = Instance.new("UIGradient", panel)
	pGrad.Rotation = 100
	pGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 0, 84)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
	})

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -12, 0, 22)
	title.Position = UDim2.new(0, 8, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = "Load AI"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = panel

	local status = Instance.new("TextLabel")
	status.Size = UDim2.new(1, -12, 0, 18)
	status.Position = UDim2.new(0, 8, 0, 28)
	status.BackgroundTransparency = 1
	status.Text = "Pick AI + mode"
	status.TextColor3 = Color3.fromRGB(220, 200, 255)
	status.Font = Enum.Font.Gotham
	status.TextSize = 11
	status.TextXAlignment = Enum.TextXAlignment.Left
	status.Parent = panel

	local function makeBtn(text, x, y, w, h, fn)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, w, 0, h)
		b.Position = UDim2.new(0, x, 0, y)
		b.BackgroundColor3 = Color3.fromRGB(60, 0, 70)
		b.Text = text
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 11
		b.AutoButtonColor = false
		b.Parent = panel
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		local st = Instance.new("UIStroke", b)
		st.Color = Color3.fromRGB(0, 0, 0)
		st.Thickness = 2
		b.MouseButton1Click:Connect(function()
			playClick()
			clickPunch(b)
			if fn then fn() end
		end)
		return b
	end

	local hypeLbl = Instance.new("TextLabel")
	hypeLbl.Size = UDim2.new(1, -12, 0, 16)
	hypeLbl.Position = UDim2.new(0, 8, 0, 52)
	hypeLbl.BackgroundTransparency = 1
	hypeLbl.Text = "HypeAI (Fast / Advanced)"
	hypeLbl.TextColor3 = Color3.fromRGB(255, 200, 255)
	hypeLbl.Font = Enum.Font.GothamBold
	hypeLbl.TextSize = 11
	hypeLbl.TextXAlignment = Enum.TextXAlignment.Left
	hypeLbl.Parent = panel

	makeBtn("Load HypeAI · Fast", 8, 72, 140, 28, function()
		ENV.hypeAI.name = "HypeAI"
		ENV.hypeAI.mode = "Fast"
		ENV.hypeAI.loaded = true
		ENV.hypeAI.ultraReady = false
		status.Text = "HypeAI Fast: sends scripts + where to put + Copy"
	end)
	makeBtn("Load HypeAI · Advanced", 156, 72, 140, 28, function()
		ENV.hypeAI.name = "HypeAI"
		ENV.hypeAI.mode = "Advanced"
		ENV.hypeAI.loaded = true
		ENV.hypeAI.ultraReady = false
		status.Text = "HypeAI Advanced: better toolbox + cool build scripts + Copy"
	end)

	local coLbl = Instance.new("TextLabel")
	coLbl.Size = UDim2.new(1, -12, 0, 16)
	coLbl.Position = UDim2.new(0, 8, 0, 110)
	coLbl.BackgroundTransparency = 1
	coLbl.Text = "CoAI (Fast / Advanced / Ultra)"
	coLbl.TextColor3 = Color3.fromRGB(200, 220, 255)
	coLbl.Font = Enum.Font.GothamBold
	coLbl.TextSize = 11
	coLbl.TextXAlignment = Enum.TextXAlignment.Left
	coLbl.Parent = panel

	makeBtn("CoAI · Fast", 8, 130, 90, 28, function()
		ENV.hypeAI.name = "CoAI"
		ENV.hypeAI.mode = "Fast"
		ENV.hypeAI.loaded = true
		ENV.hypeAI.ultraReady = false
		status.Text = "CoAI Fast: scripts + where to put + Copy"
	end)
	makeBtn("CoAI · Advanced", 104, 130, 100, 28, function()
		ENV.hypeAI.name = "CoAI"
		ENV.hypeAI.mode = "Advanced"
		ENV.hypeAI.loaded = true
		ENV.hypeAI.ultraReady = false
		status.Text = "CoAI Advanced: toolbox + build scripts + Copy"
	end)
	makeBtn("CoAI · Ultra", 210, 130, 90, 28, function()
		ENV.hypeAI.name = "CoAI"
		ENV.hypeAI.mode = "Ultra"
		ENV.hypeAI.loaded = true
		status.Text = "CoAI Ultra: path + explain what you want (strong)"
		ENV.hypeAI.ultraReady = true
	end)

	if IS_OWNER then
		makeBtn("Owner Instant Load (Ultra)", 8, 168, 288, 28, function()
			ENV.hypeAI.name = "CoAI"
			ENV.hypeAI.mode = "Ultra"
			ENV.hypeAI.loading = false
			ENV.hypeAI.loaded = true
			ENV.hypeAI.ultraReady = true
			status.Text = "Owner Instant — CoAI Ultra ready"
		end)
	end

	local tip = Instance.new("TextLabel")
	tip.Size = UDim2.new(1, -12, 0, 50)
	tip.Position = UDim2.new(0, 8, 0, IS_OWNER and 204 or 168)
	tip.BackgroundTransparency = 1
	tip.Text = "Fast = script + where to put\nAdvanced = toolbox + cool builds + script\nUltra = path + describe → strong auto script"
	tip.TextColor3 = Color3.fromRGB(200, 180, 220)
	tip.Font = Enum.Font.Gotham
	tip.TextSize = 10
	tip.TextWrapped = true
	tip.TextXAlignment = Enum.TextXAlignment.Left
	tip.TextYAlignment = Enum.TextYAlignment.Top
	tip.Parent = panel

	local baseY = 310
	createSectionF("Chat", baseY)

	local typingLbl = Instance.new("TextLabel")
	typingLbl.Size = UDim2.new(1, -4, 0, 16)
	typingLbl.Position = UDim2.new(0, 2, 0, baseY + 20)
	typingLbl.BackgroundTransparency = 1
	typingLbl.Text = ""
	typingLbl.TextColor3 = Color3.fromRGB(180, 255, 200)
	typingLbl.Font = Enum.Font.GothamBold
	typingLbl.TextSize = 11
	typingLbl.TextXAlignment = Enum.TextXAlignment.Left
	typingLbl.Visible = false
	typingLbl.Parent = FeaturesFrame

	local reply = Instance.new("TextLabel")
	reply.Size = UDim2.new(1, -4, 0, 70)
	reply.Position = UDim2.new(0, 2, 0, baseY + 38)
	reply.BackgroundColor3 = Color3.fromRGB(40, 20, 50)
	reply.Text = "Load an AI, then ask. Scripts include where to put them."
	reply.TextColor3 = Color3.fromRGB(230, 220, 255)
	reply.Font = Enum.Font.Gotham
	reply.TextSize = 10
	reply.TextWrapped = true
	reply.TextXAlignment = Enum.TextXAlignment.Left
	reply.TextYAlignment = Enum.TextYAlignment.Top
	reply.Parent = FeaturesFrame
	Instance.new("UICorner", reply).CornerRadius = UDim.new(0, 6)

	local scriptBox = Instance.new("TextBox")
	scriptBox.Size = UDim2.new(1, -4, 0, 80)
	scriptBox.Position = UDim2.new(0, 2, 0, baseY + 114)
	scriptBox.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
	scriptBox.PlaceholderText = "Script output appears here..."
	scriptBox.Text = ""
	scriptBox.TextColor3 = Color3.fromRGB(180, 255, 180)
	scriptBox.Font = Enum.Font.Code
	scriptBox.TextSize = 10
	scriptBox.TextWrapped = true
	scriptBox.TextXAlignment = Enum.TextXAlignment.Left
	scriptBox.TextYAlignment = Enum.TextYAlignment.Top
	scriptBox.ClearTextOnFocus = false
	scriptBox.MultiLine = true
	scriptBox.Parent = FeaturesFrame
	Instance.new("UICorner", scriptBox).CornerRadius = UDim.new(0, 6)

	local whereLbl = Instance.new("TextLabel")
	whereLbl.Size = UDim2.new(1, -4, 0, 28)
	whereLbl.Position = UDim2.new(0, 2, 0, baseY + 198)
	whereLbl.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
	whereLbl.Text = "Where to put: —"
	whereLbl.TextColor3 = Color3.fromRGB(255, 220, 180)
	whereLbl.Font = Enum.Font.GothamBold
	whereLbl.TextSize = 10
	whereLbl.TextWrapped = true
	whereLbl.TextXAlignment = Enum.TextXAlignment.Left
	whereLbl.Parent = FeaturesFrame
	Instance.new("UICorner", whereLbl).CornerRadius = UDim.new(0, 6)

	createButtonF("Copy Script", baseY + 232, function()
		local t = scriptBox.Text
		if t == "" then return end
		pcall(function()
			if setclipboard then setclipboard(t)
			elseif toclipboard then toclipboard(t) end
		end)
		whereLbl.Text = (whereLbl.Text:gsub(" %[Copied!%]$", "")) .. " [Copied!]"
	end)

	local ask = Instance.new("TextBox")
	ask.Size = UDim2.new(1, -70, 0, 28)
	ask.Position = UDim2.new(0, 2, 0, baseY + 266)
	ask.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
	ask.PlaceholderText = "Describe what you want (Ultra: path + explain)..."
	ask.Text = ""
	ask.TextColor3 = Color3.fromRGB(255, 255, 255)
	ask.Font = Enum.Font.Gotham
	ask.TextSize = 11
	ask.ClearTextOnFocus = false
	ask.Parent = FeaturesFrame
	Instance.new("UICorner", ask).CornerRadius = UDim.new(0, 6)

	local function setTyping(on)
		typingLbl.Visible = on
		typingLbl.Text = on and "Typing..." or ""
	end

	local function genScript(q)
		local n = ENV.hypeAI.name
		local m = ENV.hypeAI.mode
		local low = string.lower(q or "")
		local script, where, note = "", "StarterPlayer > StarterPlayerScripts (LocalScript)", ""

		-- keyword templates
		if low:find("kill") or low:find("damage") then
			script = [[-- Damage touch
local part = script.Parent
part.Touched:Connect(function(hit)
	local hum = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
	if hum then hum:TakeDamage(25) end
end)]]
			where = "Put inside a Part (Script)"
		elseif low:find("teleport") or low:find("tp") then
			script = [[-- Teleport pad
local part = script.Parent
local dest = Vector3.new(0, 10, 0) -- change
part.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = CFrame.new(dest) end
end)]]
			where = "Put inside a Part (Script)"
		elseif low:find("gui") or low:find("button") then
			script = [[-- Simple ScreenGui button
local sg = Instance.new("ScreenGui")
sg.Name = "MyGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0.5, -60, 0.8, 0)
btn.Text = "Click"
btn.Parent = sg
btn.MouseButton1Click:Connect(function()
	print("clicked")
end)]]
			where = "StarterPlayer > StarterPlayerScripts (LocalScript)"
		elseif low:find("leaderstat") or low:find("coin") or low:find("money") then
			script = [[-- Leaderstats
game.Players.PlayerAdded:Connect(function(plr)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = ls
end)]]
			where = "ServerScriptService (Script)"
		elseif low:find("part") or low:find("spawn") or low:find("build") then
			script = [[-- Create a part in front of player
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local p = Instance.new("Part")
p.Size = Vector3.new(4, 1, 4)
p.Anchored = true
p.CFrame = root.CFrame * CFrame.new(0, 0, -8)
p.Parent = workspace]]
			where = "StarterPlayer > StarterPlayerScripts (LocalScript) or Command Bar"
		elseif low:find("loop") or low:find("auto") then
			script = [[-- Simple loop
while task.wait(1) do
	print("tick", os.clock())
end]]
			where = "LocalScript or Script depending on use"
		else
			-- generic from request
			if m == "Ultra" then
				script = string.format([[-- CoAI Ultra generated from your request
-- Request: %s
-- Edit the path / targets below to match your game

local target = workspace -- change path if needed
local function apply()
	-- customize this section
	print("Ultra apply:", %q)
end
apply()]], q, q)
				where = "Paste path you named in chat · usually ServerScriptService or LocalScript"
				note = "Ultra: describe path + what to change for better scripts."
			elseif m == "Advanced" then
				script = string.format([[-- Advanced build helper
-- Request: %s
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
-- toolbox-style: create a simple platform
local m = Instance.new("Model")
m.Name = "Build"
local base = Instance.new("Part")
base.Size = Vector3.new(12, 1, 12)
base.Anchored = true
base.Parent = m
m.PrimaryPart = base
m.Parent = workspace
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
	m:PivotTo(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10))
end]], q)
				where = "StarterPlayerScripts (LocalScript) or run once in command bar"
			else
				script = string.format([[-- Fast script
-- You asked: %s
print(%q)
-- Expand this with your game logic]], q, q)
				where = "StarterPlayer > StarterPlayerScripts (LocalScript)"
			end
		end

		if n == "HypeAI" and m == "Advanced" and script ~= "" then
			note = "HypeAI Advanced: cool build / toolbox-oriented script."
		elseif n == "HypeAI" and m == "Fast" then
			note = "HypeAI Fast: script only + where to put."
		end
		return script, where, note
	end

	local sendBtn = Instance.new("TextButton")
	sendBtn.Size = UDim2.new(0, 60, 0, 28)
	sendBtn.Position = UDim2.new(1, -62, 0, baseY + 266)
	sendBtn.BackgroundColor3 = Color3.fromRGB(84, 0, 84)
	sendBtn.Text = "Send"
	sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	sendBtn.Font = Enum.Font.GothamBold
	sendBtn.TextSize = 12
	sendBtn.Parent = FeaturesFrame
	Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 6)
	local sst = Instance.new("UIStroke", sendBtn)
	sst.Color = Color3.fromRGB(0, 0, 0)
	sst.Thickness = 2

	sendBtn.MouseButton1Click:Connect(function()
		playClick()
		if not ENV.hypeAI.loaded then
			reply.Text = "Load HypeAI or CoAI first."
			return
		end
		local q = ask.Text
		if q == "" then return end
		setTyping(true)
		reply.Text = ENV.hypeAI.name .. " is thinking..."
		scriptBox.Text = ""
		task.spawn(function()
			task.wait(0.6 + math.random() * 0.8) -- typing feel
			local script, where, note = genScript(q)
			setTyping(false)
			reply.Text = (note ~= "" and note or (ENV.hypeAI.name .. " [" .. ENV.hypeAI.mode .. "]"))
				.. "\nCopy the script below."
			scriptBox.Text = script
			whereLbl.Text = "Where to put: " .. where
			ask.Text = ""
		end)
	end)

	createSectionF("Toolbox / Models", baseY + 310)
	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1, -4, 0, 28)
	searchBox.Position = UDim2.new(0, 2, 0, baseY + 332)
	searchBox.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
	searchBox.PlaceholderText = "Search toolbox models..."
	searchBox.Text = ""
	searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextSize = 11
	searchBox.ClearTextOnFocus = false
	searchBox.Parent = FeaturesFrame
	Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

	local resultsLbl = Instance.new("TextLabel")
	resultsLbl.Size = UDim2.new(1, -4, 0, 36)
	resultsLbl.Position = UDim2.new(0, 2, 0, baseY + 364)
	resultsLbl.BackgroundTransparency = 1
	resultsLbl.Text = "Search or paste a model ID."
	resultsLbl.TextColor3 = Color3.fromRGB(180, 170, 220)
	resultsLbl.Font = Enum.Font.Gotham
	resultsLbl.TextSize = 10
	resultsLbl.TextWrapped = true
	resultsLbl.TextXAlignment = Enum.TextXAlignment.Left
	resultsLbl.Parent = FeaturesFrame

	createButtonF("Search Models", baseY + 404, function()
		local q = searchBox.Text
		if q == "" then resultsLbl.Text = "Type a search first." return end
		resultsLbl.Text = "Searching..."
		task.spawn(function()
			local found = {}
			pcall(function()
				local url = "https://catalog.roblox.com/v1/search/items?category=Models&keyword="
					.. game:GetService("HttpService"):UrlEncode(q) .. "&limit=10"
				local body = game:HttpGet(url)
				local data = game:GetService("HttpService"):JSONDecode(body)
				if data and data.data then
					for _, item in ipairs(data.data) do
						table.insert(found, tostring(item.id or "?"))
					end
				end
			end)
			if #found > 0 then
				resultsLbl.Text = "Found IDs: " .. table.concat(found, ", ")
				ENV.hypeAI.lastIds = found
			else
				resultsLbl.Text = "No results / HttpGet blocked. Paste an ID."
			end
		end)
	end)

	local idBox = Instance.new("TextBox")
	idBox.Size = UDim2.new(1, -4, 0, 28)
	idBox.Position = UDim2.new(0, 2, 0, baseY + 436)
	idBox.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
	idBox.PlaceholderText = "Model ID..."
	idBox.Text = ""
	idBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	idBox.Font = Enum.Font.Gotham
	idBox.TextSize = 11
	idBox.ClearTextOnFocus = false
	idBox.Parent = FeaturesFrame
	Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 6)

	createButtonF("Insert Model", baseY + 470, function()
		local id = tonumber(idBox.Text:match("%d+"))
			or (ENV.hypeAI.lastIds and tonumber(ENV.hypeAI.lastIds[1]))
		if not id then return end
		task.spawn(function()
			local ok, model = pcall(function()
				return game:GetService("InsertService"):LoadAsset(id)
			end)
			if ok and model then
				local m = model:GetChildren()[1] or model
				pcall(function()
					m.Parent = workspace
					local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if root and m:IsA("Model") then
						m:PivotTo(root.CFrame * CFrame.new(0, 0, -10))
					end
				end)
				resultsLbl.Text = "Inserted " .. tostring(id)
			else
				resultsLbl.Text = "Insert failed."
			end
		end)
	end)

	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, baseY + 520)
end

-- How to add a game: put PlaceId + builder in SUPPORTED
local SUPPORTED = {
	[tonumber("75626443136851")] = buildGame1Features,
	[tonumber("108775830475023")] = buildGame2Features,
	[tonumber("84757653274750")] = buildGame3Features,
	[tonumber("78579721506911")] = buildGame4Features,
	[tonumber("82554996468034")] = buildGame5Features,
	[tonumber("84718070904253")] = buildGame6Features, -- Monkey Math
	[tonumber("537413528")] = buildGame7Features, -- BABFT Builds
	[tonumber("10959918411")] = buildGame8Features, -- Studio Lite / HypeAI
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
	createButton(GamePage, "Request Game", 60, function()
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
		if placeId == tonumber("84718070904253") then
			nameL.Text = "Monkey Math"
		elseif placeId == tonumber("537413528") then
			nameL.Text = "BABFT Builds"
		elseif placeId == tonumber("10959918411") then
			nameL.Text = "Studio Lite • HypeAI"
		else
			task.spawn(function()
				pcall(function()
					local info = MarketplaceService:GetProductInfo(placeId)
					if info and nameL.Parent then nameL.Text = info.Name end
				end)
			end)
		end
		entry.MouseButton1Click:Connect(function()
			playClick()
			pcall(function() TeleportService:Teleport(placeId, player) end)
		end)
		y = y + 36
	end
	GameListPage.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- (Settings / Request / View already built above — no stub overwrite)

do
	local OwnerPage = pages.Owner
	-- skip if already filled
	if OwnerPage:FindFirstChildWhichIsA("Frame") then
		-- already has owner cards
	else
	createSection(OwnerPage, "Owners", 0)
	local y = 24
	for _, userName in ipairs({_d({69,121,102,97,110,98,111,121,48,57}), _d({84,104,101,83,108,101,100,77})}) do
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
end


-- ========== KEY SYSTEM REMOVED — always unlocked ==========
ENV.plus1_unlocked = true


-- ========== UNIVERSAL (dropdown features) ==========
do
	local UniPage = pages.Universal
	createSection(UniPage, "Universal", 0)

	-- Feature list: add more names here later
	local UNI_FEATURES = { "Wallhop" }
	local currentFeature = "Wallhop"

	local dropBtn = Instance.new("TextButton")
	dropBtn.Size = UDim2.new(1, -4, 0, 26)
	dropBtn.Position = UDim2.new(0, 2, 0, 22)
	dropBtn.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
	dropBtn.Text = "  Wallhop  ∇"
	dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	dropBtn.Font = Enum.Font.GothamBold
	dropBtn.TextSize = 12
	dropBtn.TextXAlignment = Enum.TextXAlignment.Left
	dropBtn.AutoButtonColor = false
	dropBtn.Parent = UniPage
	Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
	local ds = Instance.new("UIStroke", dropBtn)
	ds.Color = Color3.fromRGB(120, 100, 200)
	ds.Thickness = 1

	local dropList = Instance.new("Frame")
	dropList.Size = UDim2.new(1, -4, 0, 0)
	dropList.Position = UDim2.new(0, 2, 0, 50)
	dropList.BackgroundColor3 = Color3.fromRGB(40, 35, 90)
	dropList.BorderSizePixel = 0
	dropList.Visible = false
	dropList.ZIndex = 20
	dropList.ClipsDescendants = true
	dropList.Parent = UniPage
	Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 6)

	local featureHolders = {}

	local function setHoldersVisible(vis)
		for n, holder in pairs(featureHolders) do
			if vis then
				holder.Visible = (n == currentFeature)
			else
				holder.Visible = false
			end
		end
	end

	local function showFeature(name)
		currentFeature = name
		dropList.Visible = false
		dropBtn.Text = "  " .. name .. "  ∇"
		setHoldersVisible(true)
	end

	local function rebuildDropList()
		for _, ch in ipairs(dropList:GetChildren()) do
			if ch:IsA("TextButton") then ch:Destroy() end
		end
		local y = 2
		for _, name in ipairs(UNI_FEATURES) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -4, 0, 24)
			b.Position = UDim2.new(0, 2, 0, y)
			b.BackgroundColor3 = Color3.fromRGB(55, 50, 115)
			b.Text = "  " .. name
			b.TextColor3 = Color3.fromRGB(230, 220, 255)
			b.Font = Enum.Font.Gotham
			b.TextSize = 11
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.ZIndex = 21
			b.Parent = dropList
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
			b.MouseButton1Click:Connect(function()
				playClick()
				showFeature(name)
			end)
			y = y + 26
		end
		dropList.Size = UDim2.new(1, -4, 0, math.min(y + 2, 120))
	end
	rebuildDropList()

	dropBtn.MouseButton1Click:Connect(function()
		playClick()
		local open = not dropList.Visible
		dropList.Visible = open
		dropBtn.Text = "  " .. currentFeature .. (open and "  ∆" or "  ∇")
		-- settings hide while dropdown open; show when closed
		setHoldersVisible(not open)
	end)

	-- Wallhop content holder
	local wallHolder = Instance.new("Frame")
	wallHolder.Name = "WallhopHolder"
	wallHolder.Size = UDim2.new(1, 0, 0, 360)
	wallHolder.Position = UDim2.new(0, 0, 0, 56)
	wallHolder.BackgroundTransparency = 1
	wallHolder.Parent = UniPage
	featureHolders["Wallhop"] = wallHolder

	local function createToggleH(parent, name, y, callback)
		return createToggle(parent, name, y, callback)
	end
	local function createButtonH(parent, name, y, callback)
		return createButton(parent, name, y, callback)
	end
	local function createSectionH(parent, text, y)
		return createSection(parent, text, y)
	end

	local WH = {
		Mode1_Cooldown = 0.12,
		Mode2_Cooldown = 0.3,
		FlickAngle = 45,
		MaxChain = 999,
		SnapDuration = 0.04,
		JumpPower = 61,
		WallDistance = 4.2,
		enabled = false,
		mode = 1,
	}
	ENV.wallhop = WH

	local mode1_lastJump = 0
	local mode2_lastJumpTime = 0
	local mode2_jumpChain = 0

	-- (feature content; name is in dropdown only)

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(1, -4, 0, 16)
	statusLbl.Position = UDim2.new(0, 2, 0, 20)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = "Status: OFF | Mode: Inf Jump"
	statusLbl.TextColor3 = Color3.fromRGB(255, 120, 120)
	statusLbl.Font = Enum.Font.GothamBold
	statusLbl.TextSize = 11
	statusLbl.TextXAlignment = Enum.TextXAlignment.Left
	statusLbl.Parent = wallHolder

	local function refreshStatus()
		local m = WH.mode == 1 and "Inf Jump" or "Cam Flick"
		statusLbl.Text = "Status: " .. (WH.enabled and "ON" or "OFF") .. " | Mode: " .. m
		statusLbl.TextColor3 = WH.enabled and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(255, 120, 120)
	end

	createToggleH(wallHolder, "Enable", 40, function(v)
		WH.enabled = v
		if not v then mode2_jumpChain = 0 end
		refreshStatus()
	end)

	createButtonH(wallHolder, "Mode: Inf Jump", 72, function()
		WH.mode = 1
		mode2_jumpChain = 0
		refreshStatus()
	end)
	createButtonH(wallHolder, "Mode: Cam Flick", 104, function()
		WH.mode = 2
		refreshStatus()
	end)

	local function numSetting(label, y, key, minV, maxV, step)
		local lab = Instance.new("TextLabel")
		lab.Size = UDim2.new(0.55, 0, 0, 18)
		lab.Position = UDim2.new(0, 2, 0, y)
		lab.BackgroundTransparency = 1
		lab.Text = label
		lab.TextColor3 = Color3.fromRGB(210, 200, 255)
		lab.Font = Enum.Font.Gotham
		lab.TextSize = 10
		lab.TextXAlignment = Enum.TextXAlignment.Left
		lab.Parent = wallHolder
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(0, 52, 0, 20)
		box.Position = UDim2.new(1, -56, 0, y - 1)
		box.BackgroundColor3 = Color3.fromRGB(50, 45, 100)
		box.Text = tostring(WH[key])
		box.TextColor3 = Color3.fromRGB(255, 255, 255)
		box.Font = Enum.Font.Gotham
		box.TextSize = 11
		box.ClearTextOnFocus = false
		box.Parent = wallHolder
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
		box.FocusLost:Connect(function()
			local n = tonumber(box.Text)
			if not n then box.Text = tostring(WH[key]) return end
			if maxV and maxV > 0 then
				n = math.clamp(n, minV, maxV)
			else
				n = math.max(minV, n)
			end
			if step and step >= 1 then n = math.floor(n + 0.5) end
			WH[key] = n
			box.Text = tostring(n)
		end)
		return box
	end

	createSectionH(wallHolder, "Settings", 140)
	numSetting("Inf Jump CD", 162, "Mode1_Cooldown", 0.01, 2, 0)
	numSetting("Cam Flick CD", 186, "Mode2_Cooldown", 0.01, 2, 0)
	numSetting("Flick Angle", 210, "FlickAngle", 1, 180, 1)
	numSetting("Max Chain (any)", 234, "MaxChain", 1, 0, 1)
	numSetting("Snap Duration", 258, "SnapDuration", 0.01, 1, 0)
	numSetting("Jump Power", 282, "JumpPower", 10, 500, 1)
	numSetting("Wall Distance", 306, "WallDistance", 1, 20, 0)

	createButtonH(wallHolder, "Reset to Normal", 332, function()
		WH.Mode1_Cooldown = 0.12
		WH.Mode2_Cooldown = 0.3
		WH.FlickAngle = 45
		WH.MaxChain = 999
		WH.SnapDuration = 0.04
		WH.JumpPower = 61
		WH.WallDistance = 4.2
		refreshStatus()
	end)

	UniPage.CanvasSize = UDim2.new(0, 0, 0, 430)
	showFeature("Wallhop")

	-- How to add more: table.insert(UNI_FEATURES, "Name") + featureHolders["Name"] = holderFrame

	local function hasWallNearby(root)
		if not root then return false end
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {player.Character or {}}
		local pos = root.Position + Vector3.new(0, -1.5, 0)
		local dist = WH.WallDistance
		local dirs = {
			root.CFrame.RightVector * dist,
			-root.CFrame.RightVector * dist,
			root.CFrame.LookVector * dist,
			-root.CFrame.LookVector * dist,
		}
		for _, dir in ipairs(dirs) do
			local result = workspace:Raycast(pos, dir, params)
			if result and result.Instance and result.Instance.CanCollide then
				return true
			end
		end
		return false
	end

	local function getContactCount(char, root)
		if not root then return 0 end
		local params = OverlapParams.new()
		params.FilterDescendantsInstances = {char}
		local parts = workspace:GetPartBoundsInBox(root.CFrame * CFrame.new(0, -1.8, 0), Vector3.new(4, 3.5, 4), params)
		local count = 0
		for _, p in ipairs(parts) do
			if p:IsA("BasePart") and p.CanCollide then count = count + 1 end
		end
		return count
	end

	local function getHorizontalMoveDir()
		local right = UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right)
		local left = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)
		if right and not left then return 1
		elseif left and not right then return -1
		else return 0 end
	end

	UserInputService.JumpRequest:Connect(function()
		if not WH.enabled or WH.mode ~= 1 then return end
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not hum or not root then return end
		if tick() - mode1_lastJump < WH.Mode1_Cooldown then return end
		if not hasWallNearby(root) then return end
		mode1_lastJump = tick()
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
		local vel = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(vel.X, WH.JumpPower + math.random(-3, 5), vel.Z)
	end)

	RunService.Heartbeat:Connect(function()
		if not WH.enabled or WH.mode ~= 2 then return end
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not hum or not root then return end
		if hum:GetState() ~= Enum.HumanoidStateType.Freefall and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
			mode2_jumpChain = 0
			return
		end
		local isJumping = UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump
		if not isJumping then return end
		if mode2_jumpChain >= WH.MaxChain then return end
		if tick() - mode2_lastJumpTime < WH.Mode2_Cooldown then return end
		if getContactCount(char, root) < 2 then return end
		mode2_lastJumpTime = tick()
		mode2_jumpChain = mode2_jumpChain + 1
		local dir = getHorizontalMoveDir()
		local sign = dir == 0 and 1 or dir
		local flickRad = math.rad(WH.FlickAngle * sign + math.random(-3, 3))
		local camera = workspace.CurrentCamera
		root.CFrame = root.CFrame * CFrame.Angles(0, flickRad, 0)
		if camera then camera.CFrame = camera.CFrame * CFrame.Angles(0, flickRad, 0) end
		local vel = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(vel.X, WH.JumpPower + math.random(-2, 4), vel.Z)
		task.delay(WH.SnapDuration, function()
			if root and root.Parent then
				pcall(function()
					root.CFrame = root.CFrame * CFrame.Angles(0, -flickRad, 0)
					if camera then camera.CFrame = camera.CFrame * CFrame.Angles(0, -flickRad, 0) end
				end)
			end
		end)
	end)

	-- keybind (-) toggle like original
	UserInputService.InputBegan:Connect(function(input, gp)
		if input.KeyCode == Enum.KeyCode.Minus then
			WH.enabled = not WH.enabled
			if not WH.enabled then mode2_jumpChain = 0 end
			refreshStatus()
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			WH.mode = 1
			mode2_jumpChain = 0
			refreshStatus()
		elseif input.KeyCode == Enum.KeyCode.RightAlt then
			WH.mode = 2
			refreshStatus()
		end
	end)
end


-- FE Emotes removed (did not work)

switchPage("Home")

-- ========== LOADING SCREEN ==========
do
	local LoadGui = Instance.new("Frame")
	LoadGui.Name = "HyperZLoad"
	LoadGui.Size = UDim2.new(1, 0, 1, 0)
	LoadGui.BackgroundTransparency = 1
	LoadGui.BorderSizePixel = 0
	LoadGui.ZIndex = 200
	LoadGui.Parent = ScreenGui

	local card = Instance.new("Frame")
	card.Size = UDim2.new(0, 280, 0, 220)
	card.Position = UDim2.new(0.5, -140, 0.5, -110)
	card.BackgroundColor3 = Color3.fromRGB(40, 35, 90)
	card.BorderSizePixel = 0
	card.ZIndex = 201
	card.Parent = LoadGui
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
	local cs = Instance.new("UIStroke", card)
	cs.Color = Color3.fromRGB(140, 100, 255)
	cs.Thickness = 2

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 28)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "HyperZscript"
	title.TextColor3 = Color3.fromRGB(220, 200, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.ZIndex = 202
	title.Parent = card

	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.new(1, -20, 0, 18)
	sub.Position = UDim2.new(0, 10, 0, 38)
	sub.BackgroundTransparency = 1
	sub.Text = "Select load mode"
	sub.TextColor3 = Color3.fromRGB(160, 150, 200)
	sub.Font = Enum.Font.Gotham
	sub.TextSize = 12
	sub.ZIndex = 202
	sub.Parent = card

	local loadMode = "Game Only" -- or "All"
	local modeBtn = Instance.new("TextButton")
	modeBtn.Size = UDim2.new(1, -24, 0, 28)
	modeBtn.Position = UDim2.new(0, 12, 0, 64)
	modeBtn.BackgroundColor3 = Color3.fromRGB(55, 50, 120)
	modeBtn.Text = "  Load Only Game / Game List  ▼"
	modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	modeBtn.Font = Enum.Font.GothamBold
	modeBtn.TextSize = 11
	modeBtn.TextXAlignment = Enum.TextXAlignment.Left
	modeBtn.ZIndex = 202
	modeBtn.Parent = card
	Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)

	local modeList = Instance.new("Frame")
	modeList.Size = UDim2.new(1, -24, 0, 56)
	modeList.Position = UDim2.new(0, 12, 0, 94)
	modeList.BackgroundColor3 = Color3.fromRGB(30, 25, 70)
	modeList.Visible = false
	modeList.ZIndex = 210
	modeList.Parent = card
	Instance.new("UICorner", modeList).CornerRadius = UDim.new(0, 6)

	local function addModeOption(text, mode, y)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -6, 0, 24)
		b.Position = UDim2.new(0, 3, 0, y)
		b.BackgroundColor3 = Color3.fromRGB(55, 50, 120)
		b.Text = "  " .. text
		b.TextColor3 = Color3.fromRGB(230, 220, 255)
		b.Font = Enum.Font.Gotham
		b.TextSize = 11
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.ZIndex = 211
		b.Parent = modeList
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
		b.MouseButton1Click:Connect(function()
			playClick()
			loadMode = mode
			modeBtn.Text = "  " .. text .. "  ▼"
			modeList.Visible = false
		end)
	end
	addModeOption("Load Only Game / Game List", "Game Only", 2)
	addModeOption("Load All", "All", 28)

	modeBtn.MouseButton1Click:Connect(function()
		playClick()
		modeList.Visible = not modeList.Visible
	end)

	local timerLbl = Instance.new("TextLabel")
	timerLbl.Size = UDim2.new(1, -20, 0, 32)
	timerLbl.Position = UDim2.new(0, 10, 0, 100)
	timerLbl.BackgroundTransparency = 1
	timerLbl.Text = "00.00"
	timerLbl.TextColor3 = Color3.fromRGB(180, 255, 200)
	timerLbl.Font = Enum.Font.Code
	timerLbl.TextSize = 28
	timerLbl.ZIndex = 202
	timerLbl.Parent = card

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(1, -20, 0, 18)
	statusLbl.Position = UDim2.new(0, 10, 0, 134)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = "Ready"
	statusLbl.TextColor3 = Color3.fromRGB(160, 150, 200)
	statusLbl.Font = Enum.Font.Gotham
	statusLbl.TextSize = 11
	statusLbl.ZIndex = 202
	statusLbl.Parent = card

	local barBG = Instance.new("Frame")
	barBG.Size = UDim2.new(1, -24, 0, 10)
	barBG.Position = UDim2.new(0, 12, 0, 158)
	barBG.BackgroundColor3 = Color3.fromRGB(25, 20, 55)
	barBG.BorderSizePixel = 0
	barBG.ZIndex = 202
	barBG.Parent = card
	Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 4)
	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = Color3.fromRGB(120, 90, 255)
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 203
	barFill.Parent = barBG
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 4)

	local launchBtn = Instance.new("TextButton")
	launchBtn.Size = UDim2.new(1, -24, 0, 32)
	launchBtn.Position = UDim2.new(0, 12, 0, 176)
	launchBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 220)
	launchBtn.Text = "Launch"
	launchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	launchBtn.Font = Enum.Font.GothamBold
	launchBtn.TextSize = 14
	launchBtn.ZIndex = 202
	launchBtn.Parent = card
	Instance.new("UICorner", launchBtn).CornerRadius = UDim.new(0, 8)

	local loading = false
	local function setTabLock(mode)
		-- Game Only: Home + Game + Game List + Request (+ View/Owner if needed minimal)
		-- All: everything
		ENV.loadMode = mode
		local allow
		if mode == "Game Only" then
			allow = {Home = true, Game = true, ["Game List"] = true, Request = true}
		else
			allow = nil -- all
		end
		ENV.tabAllow = allow
	end

	-- gate switchPage
	local _switchPage = switchPage
	switchPage = function(name)
		if ENV.tabAllow and not ENV.tabAllow[name] then
			playClick()
			return
		end
		_switchPage(name)
	end

	launchBtn.MouseButton1Click:Connect(function()
		if loading then return end
		loading = true
		modeList.Visible = false
		modeBtn.Active = false
		launchBtn.Text = "Loading..."
		launchBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 100)

		local t0 = tick()
		statusLbl.Text = (loadMode == "All") and "Loading everything..." or "Loading Game / Game List..."

		if loadMode == "All" then
			-- 0 -> 80 in 10s, then 80 -> 100 in 30s
			while tick() - t0 < 10 do
				local a = math.clamp((tick() - t0) / 10, 0, 1)
				local pct = a * 80
				timerLbl.Text = string.format("%05.2f", pct)
				barFill.Size = UDim2.new(pct / 100, 0, 1, 0)
				RunService.RenderStepped:Wait()
			end
			timerLbl.Text = "80.00"
			barFill.Size = UDim2.new(0.8, 0, 1, 0)
			statusLbl.Text = "Finishing load..."
			local t1 = tick()
			while tick() - t1 < 30 do
				local a = math.clamp((tick() - t1) / 30, 0, 1)
				local pct = 80 + a * 20
				timerLbl.Text = string.format("%05.2f", pct)
				barFill.Size = UDim2.new(pct / 100, 0, 1, 0)
				RunService.RenderStepped:Wait()
			end
		else
			-- Game only: same as before (10 sec full)
			while tick() - t0 < 10 do
				local a = math.clamp((tick() - t0) / 10, 0, 1)
				local pct = a * 100
				timerLbl.Text = string.format("%05.2f", pct)
				barFill.Size = UDim2.new(a, 0, 1, 0)
				RunService.RenderStepped:Wait()
			end
		end
		timerLbl.Text = "100.00"
		barFill.Size = UDim2.new(1, 0, 1, 0)
		statusLbl.Text = "Done!"
		task.wait(0.35)

		setTabLock(loadMode)
		LoadGui:Destroy()
		OpenBtn.Visible = false
		Main.Visible = true
		Main.BackgroundTransparency = 0.35
		local ms = Main:FindFirstChild("MainScale") or mainScale
		if ms then ms.Scale = 0.75 end
		TweenService:Create(ms or Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), ms and {Scale = 1} or {}):Play()
		TweenService:Create(Main, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
		switchPage("Home")
		print("[HyperZscript] Loaded mode:", loadMode)
	end)
end

print("[HyperZscript] HyperZscript ready")
