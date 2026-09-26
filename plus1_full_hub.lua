local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- ========== WeAreDevs / JJSploit / limited executor compat ==========
local function safeHttpGet(url)
	local ok, res = pcall(function()
		return game:HttpGet(url)
	end)
	if ok and type(res) == "string" then return res end
	ok, res = pcall(function()
		return game:HttpGetAsync(url)
	end)
	if ok and type(res) == "string" then return res end
	return nil
end

local function safeClipboard(text)
	text = tostring(text or "")
	pcall(function() if setclipboard then setclipboard(text) end end)
	pcall(function() if toclipboard then toclipboard(text) end end)
	pcall(function() if set_clipboard then set_clipboard(text) end end)
	pcall(function() if Clipboard and Clipboard.set then Clipboard.set(text) end end)
end

local function safeWrite(file, data)
	pcall(function() if writefile then writefile(file, data) end end)
end
local function safeRead(file)
	local out
	pcall(function()
		if isfile and isfile(file) and readfile then out = readfile(file) end
	end)
	return out
end
local function safeIsFile(file)
	local ok = false
	pcall(function() if isfile then ok = isfile(file) == true end end)
	return ok
end

local function protectGui(gui)
	pcall(function()
		if syn and syn.protect_gui then syn.protect_gui(gui) end
	end)
	pcall(function()
		if protect_gui then protect_gui(gui) end
	end)
end

local function parentGui(gui)
	protectGui(gui)
	local ok = false
	pcall(function()
		if gethui then
			gui.Parent = gethui()
			ok = gui.Parent ~= nil
		end
	end)
	if not ok then
		pcall(function()
			gui.Parent = game:GetService("CoreGui")
			ok = gui.Parent ~= nil
		end)
	end
	if not ok then
		pcall(function()
			local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
			if pg then gui.Parent = pg end
		end)
	end
	return gui.Parent ~= nil
end

-- queue_on_teleport optional
pcall(function()
	if queue_on_teleport then
		-- keep available
	end
end)


local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end
local playerGui = player:WaitForChild("PlayerGui")

local OWNERS = {
	Eyfanboy09 = true,
	TheSledM = true,
}
local IS_OWNER = OWNERS[player.Name] == true

local ENV = _G
pcall(function()
	if getgenv then
		local g = getgenv()
		if type(g) == "table" then ENV = g end
	end
end)
if type(ENV) ~= "table" then ENV = {} end
-- shared store that works without getgenv
if not ENV.__HyperZ then ENV.__HyperZ = {} end

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
	local raw = safeRead(FREE_USE_FILE)
	if raw then n = tonumber(raw) or 0 end
	return n
end
local function setFreeUses(n)
	safeWrite(FREE_USE_FILE, tostring(n))
end
local function hasUsedFreeKey()
	local raw = safeRead(FREE_USED_BY_FILE)
	if raw and raw:find(tostring(player.UserId), 1, true) then return true end
	return false
end
local function markUsedFreeKey()
	local prev = safeRead(FREE_USED_BY_FILE) or ""
	safeWrite(FREE_USED_BY_FILE, prev .. tostring(player.UserId) .. "\n")
end
local function loadKeySaved()
	local data = nil
	local raw = safeRead(KEY_FILE)
	if raw then
		local key, exp = raw:match("([^|]+)|(%d+)")
		if key and exp then data = {key = key, exp = tonumber(exp)} end
	end
	return data
end
local function saveKeySaved(key, exp)
	safeWrite(KEY_FILE, key .. "|" .. tostring(exp))
end
local function clearKeySaved()
	safeWrite(KEY_FILE, "")
	pcall(function()
		if delfile and safeIsFile(KEY_FILE) then delfile(KEY_FILE) end
	end)
end
local function loadRequests()
	local list = {}
	local raw = safeRead(REQ_FILE)
	if raw then
		for line in raw:gmatch("[^\r\n]+") do
			local user, uid, msg = line:match("([^|]+)|([^|]+)|(.+)")
			if user and msg then
				table.insert(list, {user = user, uid = tonumber(uid) or 0, msg = msg})
			end
		end
	end
	return list
end
local function saveRequest(user, uid, msg)
	local prev = safeRead(REQ_FILE) or ""
	safeWrite(REQ_FILE, prev .. user .. "|" .. tostring(uid) .. "|" .. msg:gsub("[\r\n]", " ") .. "\n")
end

-- ========== SCREEN GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Main1Gui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
if not parentGui(ScreenGui) then
	pcall(function() ScreenGui.Parent = playerGui end)
end

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
		if pages then
			for n, p in pairs(pages) do
				if p.Visible and n == item.Name then active = true break end
			end
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
		if not IS_OWNER then return end -- only owners see ESP tags
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
			if not IS_OWNER then return end
			local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
			local old = pg:FindFirstChild("AdminTroll")
			if old then
				old.Enabled = true
				local m = old:FindFirstChild("MainFrame") or old:FindFirstChild("Main")
				if m then m.Visible = true end
				return
			end
			-- also hide old name if any
			pcall(function()
				local o = pg:FindFirstChild("HZTrollAdmin")
				if o then o:Destroy() end
			end)

			local g = Instance.new("ScreenGui")
			g.Name = "AdminTroll"
			g.ResetOnSpawn = false
			g.IgnoreGuiInset = true
			g.DisplayOrder = 120
			g.ZIndexBehavior = Enum.ZIndexBehavior.Global
			pcall(function()
				if parentGui then parentGui(g) else g.Parent = pg end
			end)
			if not g.Parent then g.Parent = pg end

			-- Same size / style as AdminTroll (purple + black)
			local main = Instance.new("Frame")
			main.Name = "MainFrame"
			main.Size = UDim2.new(0, 320, 0, 250)
			main.Position = UDim2.new(0, 275, 0, 50)
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
			title.Size = UDim2.new(1, -48, 0, 26)
			title.Position = UDim2.new(0, 10, 0, 4)
			title.BackgroundTransparency = 1
			title.Text = "Admin Commands"
			title.TextColor3 = Color3.fromRGB(255, 255, 255)
			title.Font = Enum.Font.GothamBold
			title.TextSize = 15
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = main

			local close = Instance.new("TextButton")
			close.Size = UDim2.new(0, 28, 0, 26)
			close.Position = UDim2.new(1, -32, 0, 4)
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
			sc.Size = UDim2.new(1, -10, 1, -34)
			sc.Position = UDim2.new(0, 5, 0, 32)
			sc.BackgroundTransparency = 1
			sc.BorderSizePixel = 0
			sc.ScrollBarThickness = 4
			sc.CanvasSize = UDim2.new(0, 0, 0, 900)
			sc.Parent = main

			local function lbl(text, y)
				local t = Instance.new("TextLabel")
				t.Size = UDim2.new(1, -8, 0, 16)
				t.Position = UDim2.new(0, 4, 0, y)
				t.BackgroundTransparency = 1
				t.Text = text
				t.TextColor3 = Color3.fromRGB(255, 220, 255)
				t.Font = Enum.Font.GothamBold
				t.TextSize = 11
				t.TextXAlignment = Enum.TextXAlignment.Left
				t.Parent = sc
				return y + 18
			end
			local function box(ph, y, h)
				h = h or 26
				local b = Instance.new("TextBox")
				b.Size = UDim2.new(1, -8, 0, h)
				b.Position = UDim2.new(0, 4, 0, y)
				b.BackgroundColor3 = Color3.fromRGB(40, 0, 50)
				b.PlaceholderText = ph
				b.Text = ""
				b.TextColor3 = Color3.fromRGB(255, 255, 255)
				b.Font = Enum.Font.GothamBold
				b.TextSize = 11
				b.ClearTextOnFocus = false
				b.Parent = sc
				Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
				local st = Instance.new("UIStroke", b)
				st.Color = Color3.fromRGB(0, 0, 0)
				st.Thickness = 2
				return b, y + h + 6
			end
			local function btn(text, y, fn)
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1, -8, 0, 28)
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
					if clickPunch then clickPunch(b) end
					if fn then fn() end
				end)
				return y + 32
			end

			local y = 4
			y = lbl("Player", y)
			local selBox
			selBox, y = box("Username", y)

			-- HZ users dropdown
			local dropBtn = Instance.new("TextButton")
			dropBtn.Size = UDim2.new(1, -8, 0, 26)
			dropBtn.Position = UDim2.new(0, 4, 0, y)
			dropBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 70)
			dropBtn.Text = "HZ Players  ∇"
			dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			dropBtn.Font = Enum.Font.GothamBold
			dropBtn.TextSize = 11
			dropBtn.Parent = sc
			Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
			y = y + 30

			local list = Instance.new("ScrollingFrame")
			list.Size = UDim2.new(1, -8, 0, 72)
			list.Position = UDim2.new(0, 4, 0, y)
			list.BackgroundColor3 = Color3.fromRGB(30, 0, 40)
			list.Visible = false
			list.ScrollBarThickness = 3
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
					b.Size = UDim2.new(1, -6, 0, 22)
					b.Position = UDim2.new(0, 3, 0, ly)
					b.BackgroundColor3 = Color3.fromRGB(50, 0, 60)
					b.Text = "  " .. name .. " · " .. tostring(info.gameName or "?")
					b.TextColor3 = Color3.fromRGB(255, 255, 255)
					b.Font = Enum.Font.GothamBold
					b.TextSize = 10
					b.TextXAlignment = Enum.TextXAlignment.Left
					b.Parent = list
					Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
					b.MouseButton1Click:Connect(function()
						playClick()
						ENV.adminSelected = name
						selBox.Text = name
						list.Visible = false
					end)
					ly = ly + 24
				end
				list.CanvasSize = UDim2.new(0, 0, 0, ly + 4)
			end
			dropBtn.MouseButton1Click:Connect(function()
				playClick()
				refresh()
				list.Visible = not list.Visible
			end)
			y = y + 78

			local function target()
				local t = selBox.Text
				if t == "" then t = ENV.adminSelected or "" end
				ENV.adminSelected = t
				return t
			end

			local function adminSend(cmd, extra)
				local t = target()
				if t == "" then return end
				local payload = {cmd = cmd, target = t, from = player.Name}
				if extra then for k, v in pairs(extra) do payload[k] = v end end
				pcall(function()
					if ENV.wsSocket and ENV.wsConnected then
						local s = HttpService:JSONEncode(payload)
						local sock = ENV.wsSocket
						if sock.Send then sock:Send(s) elseif sock.send then sock:send(s) end
					end
				end)
				-- local helpers for goto / spectate
				if cmd == "goto" then
					local plr = Players:FindFirstChild(t)
					local me = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					local r = plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if r and me then me.CFrame = r.CFrame * CFrame.new(0, 0, 3) end
				elseif cmd == "spectate" then
					local plr = Players:FindFirstChild(t)
					local hum = plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
					if hum then pcall(function() workspace.CurrentCamera.CameraSubject = hum end) end
				elseif cmd == "unspectate" then
					local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
					if h then pcall(function() workspace.CurrentCamera.CameraSubject = h end) end
				elseif cmd == "bring" then
					local me = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if me then
						payload.cmd = "tp"
						payload.x, payload.y, payload.z = me.Position.X, me.Position.Y, me.Position.Z
						pcall(function()
							if ENV.wsSocket and ENV.wsConnected then
								local s = HttpService:JSONEncode(payload)
								local sock = ENV.wsSocket
								if sock.Send then sock:Send(s) elseif sock.send then sock:send(s) end
							end
						end)
					end
				end
			end

			-- (Reason then Kick)
			y = lbl("(Reason then Kick)", y)
			local kickReason
			kickReason, y = box("Kick Reason...", y)
			y = btn("Kick", y, function()
				local reason = kickReason.Text
				if reason == "" then reason = "Kicked" end
				adminSend("kick", {reason = reason})
			end)

			y = y + 4
			y = lbl("Kick V2 (owner-style message)", y)
			y = btn("Kick V2", y, function()
				adminSend("kick", {hard = true})
			end)

			y = y + 4
			y = lbl("Message", y)
			local msgBox
			msgBox, y = box("Message (no username)...", y)
			y = btn("Send", y, function()
				adminSend("message", {text = msgBox.Text ~= "" and msgBox.Text or "..."})
			end)

			y = y + 4
			y = lbl("Time", y)
			local timeBox
			timeBox, y = box("Seconds (e.g. 5)", y)
			y = btn("Freeze", y, function()
				adminSend("freeze", {time = tonumber(timeBox.Text) or 5})
			end)

			y = y + 4
			y = btn("Tp Player To Sky", y, function()
				adminSend("tp", {x = 0, y = 500, z = 0})
			end)

			y = y + 4
			y = lbl("Speed", y)
			local speedBox
			speedBox, y = box("Fling speed (default 1000)", y)
			y = btn("Fling", y, function()
				adminSend("fling", {speed = tonumber(speedBox.Text) or 1000})
			end)

			y = y + 6
			y = btn("Goto (player)", y, function() adminSend("goto") end)
			y = btn("Spectate (player)", y, function() adminSend("spectate") end)
			y = btn("Unspectate (player)", y, function() adminSend("unspectate") end)

			y = y + 6
			y = btn("Refresh Players", y, refresh)

			sc.CanvasSize = UDim2.new(0, 0, 0, y + 16)

			-- drag by title
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
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local d = input.Position - startP
					main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				end
			end)
		end

	-- Owner: OPEN ADMINCMMD on Home
	local deathY = 210
	if IS_OWNER then
		createSection(HomePage, "Admin", 210)
		createButton(HomePage, "OPEN ADMINCMMD", 232, function()
			playClick()
			if ENV.openTrollGui then ENV.openTrollGui() end
		end)
		deathY = 270
	end
	createSection(HomePage, "Death / Respawn", deathY)

	local DEATH_ANIMS = {
		"Falling Knife",
		"Lightning",
	}
	ENV.deathAnim = ENV.deathAnim or DEATH_ANIMS[1]

	local animDrop = Instance.new("TextButton")
	animDrop.Size = UDim2.new(1, -4, 0, 24)
	animDrop.Position = UDim2.new(0, 2, 0, deathY + 22)
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
	animList.Position = UDim2.new(0, 2, 0, deathY + 48)
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

	local SHOOT_NAMES = {"Eyfanboy09", "TheSledM"}

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
			if not IS_OWNER then return end -- only owners see tags
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
		openAd.Text = "OPEN ADMINCMMD"
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


-- BABFT removed
local function buildGame7Features() end

-- Studio Lite removed
local function buildGame8Features() end



-- Embedded Build Anything data (no Vaehz)
pcall(function()
	local src = [==[
-- Auto-generated Build Anything builds (no Sub to Vaehz)
local M = {}
local castle = {
  --[1] t=1781715956.50
  {"Mossy Stone Blocks", CFrame.new(212, 2, -60, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[2] t=1781715957.27
  {"Mossy Stone Blocks", CFrame.new(212, 2, -64, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[3] t=1781715957.62
  {"Mossy Stone Blocks", CFrame.new(212, 2, -68, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[4] t=1781715957.96
  {"Mossy Stone Blocks", CFrame.new(212, 2, -72, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[5] t=1781715958.29
  {"Mossy Stone Blocks", CFrame.new(212, 2, -76, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[6] t=1781715958.65
  {"Mossy Stone Blocks", CFrame.new(212, 2, -80, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[7] t=1781715959.85
  {"Mossy Stone Blocks", CFrame.new(212, 2, -84, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[8] t=1781715960.20
  {"Mossy Stone Blocks", CFrame.new(212, 2, -88, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[9] t=1781715960.57
  {"Mossy Stone Blocks", CFrame.new(212, 2, -92, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[10] t=1781715960.92
  {"Mossy Stone Blocks", CFrame.new(212, 2, -96, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[11] t=1781715961.27
  {"Mossy Stone Blocks", CFrame.new(212, 2, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[12] t=1781715961.65
  {"Mossy Stone Blocks", CFrame.new(212, 2, -104, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[13] t=1781715966.02
  {"Mossy Stone Blocks", CFrame.new(212, 2, -116, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[14] t=1781715966.99
  {"Mossy Stone Blocks", CFrame.new(212, 2, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[15] t=1781715967.32
  {"Mossy Stone Blocks", CFrame.new(212, 2, -124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[16] t=1781715967.62
  {"Mossy Stone Blocks", CFrame.new(212, 2, -128, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[17] t=1781715967.97
  {"Mossy Stone Blocks", CFrame.new(212, 2, -132, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[18] t=1781715977.86
  {"Mossy Stone Blocks", CFrame.new(212, 2, -136, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[19] t=1781715978.57
  {"Mossy Stone Blocks", CFrame.new(212, 2, -140, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[20] t=1781715979.19
  {"Mossy Stone Blocks", CFrame.new(212, 2, -144, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[21] t=1781715979.55
  {"Mossy Stone Blocks", CFrame.new(212, 2, -148, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[22] t=1781715979.89
  {"Mossy Stone Blocks", CFrame.new(212, 2, -152, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[23] t=1781715980.27
  {"Mossy Stone Blocks", CFrame.new(212, 2, -156, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[24] t=1781715980.61
  {"Mossy Stone Blocks", CFrame.new(212, 2, -160, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[25] t=1781715985.46
  {"Mossy Stone Blocks", CFrame.new(212, 6, -116, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[26] t=1781715985.88
  {"Mossy Stone Blocks", CFrame.new(212, 10, -116, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[27] t=1781715986.63
  {"Mossy Stone Blocks", CFrame.new(212, 10, -112, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[28] t=1781715986.94
  {"Mossy Stone Blocks", CFrame.new(212, 10, -108, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[29] t=1781715987.32
  {"Mossy Stone Blocks", CFrame.new(212, 10, -104, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[30] t=1781715987.84
  {"Mossy Stone Blocks", CFrame.new(212, 6, -104, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[31] t=1781715993.74
  {"Mossy Stone Blocks", CFrame.new(208, 2, -160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[32] t=1781715994.05
  {"Mossy Stone Blocks", CFrame.new(204, 2, -160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[33] t=1781715995.22
  {"Mossy Stone Blocks", CFrame.new(200, 2, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[34] t=1781715996.01
  {"Mossy Stone Blocks", CFrame.new(200, 2, -168, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[35] t=1781715996.42
  {"Mossy Stone Blocks", CFrame.new(200, 2, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[36] t=1781715997.39
  {"Mossy Stone Blocks", CFrame.new(200, 2, -176, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[37] t=1781715997.70
  {"Mossy Stone Blocks", CFrame.new(200, 2, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[38] t=1781715998.44
  {"Mossy Stone Blocks", CFrame.new(204, 2, -184, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[39] t=1781716000.35
  {"Mossy Stone Blocks", CFrame.new(208, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[40] t=1781716000.89
  {"Mossy Stone Blocks", CFrame.new(212, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[41] t=1781716002.08
  {"Mossy Stone Blocks", CFrame.new(216, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[42] t=1781716002.76
  {"Mossy Stone Blocks", CFrame.new(220, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[43] t=1781716003.38
  {"Mossy Stone Blocks", CFrame.new(224, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[44] t=1781716004.96
  {"Mossy Stone Blocks", CFrame.new(228, 2, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[45] t=1781716006.59
  {"Mossy Stone Blocks", CFrame.new(228, 2, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[46] t=1781716006.95
  {"Mossy Stone Blocks", CFrame.new(228, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[47] t=1781716007.34
  {"Mossy Stone Blocks", CFrame.new(228, 2, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[48] t=1781716007.78
  {"Mossy Stone Blocks", CFrame.new(228, 2, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[49] t=1781716008.58
  {"Mossy Stone Blocks", CFrame.new(216, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[50] t=1781716008.86
  {"Mossy Stone Blocks", CFrame.new(220, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[51] t=1781716009.38
  {"Mossy Stone Blocks", CFrame.new(224, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[52] t=1781716014.91
  {"Mossy Stone Blocks", CFrame.new(208, 2, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[53] t=1781716016.42
  {"Mossy Stone Blocks", CFrame.new(204, 2, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[54] t=1781716016.82
  {"Mossy Stone Blocks", CFrame.new(200, 2, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[55] t=1781716020.87
  {"Mossy Stone Blocks", CFrame.new(200, 2, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[56] t=1781716021.24
  {"Mossy Stone Blocks", CFrame.new(200, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[57] t=1781716021.59
  {"Mossy Stone Blocks", CFrame.new(200, 2, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[58] t=1781716021.97
  {"Mossy Stone Blocks", CFrame.new(200, 2, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[59] t=1781716023.19
  {"Mossy Stone Blocks", CFrame.new(204, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[60] t=1781716023.58
  {"Mossy Stone Blocks", CFrame.new(208, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[61] t=1781716023.95
  {"Mossy Stone Blocks", CFrame.new(212, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[62] t=1781716024.32
  {"Mossy Stone Blocks", CFrame.new(216, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[63] t=1781716028.31
  {"Mossy Stone Blocks", CFrame.new(216, 2, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[64] t=1781716028.70
  {"Mossy Stone Blocks", CFrame.new(220, 2, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[65] t=1781716029.06
  {"Mossy Stone Blocks", CFrame.new(224, 2, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[66] t=1781716029.52
  {"Mossy Stone Blocks", CFrame.new(228, 2, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[67] t=1781716029.84
  {"Mossy Stone Blocks", CFrame.new(228, 2, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[68] t=1781716030.17
  {"Mossy Stone Blocks", CFrame.new(228, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[69] t=1781716030.54
  {"Mossy Stone Blocks", CFrame.new(228, 2, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[70] t=1781716030.94
  {"Mossy Stone Blocks", CFrame.new(228, 2, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[71] t=1781716031.34
  {"Mossy Stone Blocks", CFrame.new(224, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[72] t=1781716031.66
  {"Mossy Stone Blocks", CFrame.new(220, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[73] t=1781716036.56
  {"Mossy Stone Blocks", CFrame.new(212, 6, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[74] t=1781716036.85
  {"Mossy Stone Blocks", CFrame.new(212, 6, -96, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[75] t=1781716037.17
  {"Mossy Stone Blocks", CFrame.new(212, 6, -92, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[76] t=1781716037.50
  {"Mossy Stone Blocks", CFrame.new(212, 6, -88, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[77] t=1781716037.78
  {"Mossy Stone Blocks", CFrame.new(212, 6, -84, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[78] t=1781716038.15
  {"Mossy Stone Blocks", CFrame.new(212, 6, -80, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[79] t=1781716038.48
  {"Mossy Stone Blocks", CFrame.new(212, 6, -76, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[80] t=1781716038.82
  {"Mossy Stone Blocks", CFrame.new(212, 6, -72, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[81] t=1781716039.81
  {"Mossy Stone Blocks", CFrame.new(212, 6, -68, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[82] t=1781716040.05
  {"Mossy Stone Blocks", CFrame.new(212, 6, -64, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[83] t=1781716041.02
  {"Mossy Stone Blocks", CFrame.new(212, 10, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[84] t=1781716041.26
  {"Mossy Stone Blocks", CFrame.new(212, 10, -96, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[85] t=1781716041.54
  {"Mossy Stone Blocks", CFrame.new(212, 10, -92, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[86] t=1781716041.83
  {"Mossy Stone Blocks", CFrame.new(212, 10, -88, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[87] t=1781716042.92
  {"Mossy Stone Blocks", CFrame.new(212, 10, -84, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[88] t=1781716043.20
  {"Mossy Stone Blocks", CFrame.new(212, 10, -80, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[89] t=1781716043.47
  {"Mossy Stone Blocks", CFrame.new(212, 10, -76, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[90] t=1781716043.83
  {"Mossy Stone Blocks", CFrame.new(212, 10, -72, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[91] t=1781716044.14
  {"Mossy Stone Blocks", CFrame.new(212, 10, -68, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[92] t=1781716044.63
  {"Mossy Stone Blocks", CFrame.new(212, 10, -64, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[93] t=1781716046.77
  {"Mossy Stone Blocks", CFrame.new(224, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[94] t=1781716047.01
  {"Mossy Stone Blocks", CFrame.new(220, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[95] t=1781716047.33
  {"Mossy Stone Blocks", CFrame.new(216, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[96] t=1781716047.65
  {"Mossy Stone Blocks", CFrame.new(212, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[97] t=1781716047.97
  {"Mossy Stone Blocks", CFrame.new(208, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[98] t=1781716048.36
  {"Mossy Stone Blocks", CFrame.new(204, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[99] t=1781716048.97
  {"Mossy Stone Blocks", CFrame.new(224, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[100] t=1781716049.22
  {"Mossy Stone Blocks", CFrame.new(220, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[101] t=1781716049.55
  {"Mossy Stone Blocks", CFrame.new(216, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[102] t=1781716049.97
  {"Mossy Stone Blocks", CFrame.new(212, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[103] t=1781716050.30
  {"Mossy Stone Blocks", CFrame.new(208, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[104] t=1781716050.67
  {"Mossy Stone Blocks", CFrame.new(204, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[105] t=1781716051.20
  {"Mossy Stone Blocks", CFrame.new(200, 6, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[106] t=1781716051.45
  {"Mossy Stone Blocks", CFrame.new(200, 6, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[107] t=1781716052.50
  {"Mossy Stone Blocks", CFrame.new(200, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[108] t=1781716052.72
  {"Mossy Stone Blocks", CFrame.new(200, 6, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[109] t=1781716053.00
  {"Mossy Stone Blocks", CFrame.new(200, 6, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[110] t=1781716053.46
  {"Mossy Stone Blocks", CFrame.new(200, 10, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[111] t=1781716053.69
  {"Mossy Stone Blocks", CFrame.new(200, 10, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[112] t=1781716053.96
  {"Mossy Stone Blocks", CFrame.new(200, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[113] t=1781716054.36
  {"Mossy Stone Blocks", CFrame.new(200, 10, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[114] t=1781716054.72
  {"Mossy Stone Blocks", CFrame.new(200, 10, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[115] t=1781716055.69
  {"Mossy Stone Blocks", CFrame.new(224, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[116] t=1781716055.96
  {"Mossy Stone Blocks", CFrame.new(220, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[117] t=1781716056.26
  {"Mossy Stone Blocks", CFrame.new(216, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[118] t=1781716056.64
  {"Mossy Stone Blocks", CFrame.new(212, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[119] t=1781716056.96
  {"Mossy Stone Blocks", CFrame.new(208, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[120] t=1781716057.34
  {"Mossy Stone Blocks", CFrame.new(204, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[121] t=1781716062.75
  {"Mossy Stone Blocks", CFrame.new(224, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[122] t=1781716063.09
  {"Mossy Stone Blocks", CFrame.new(220, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[123] t=1781716063.34
  {"Mossy Stone Blocks", CFrame.new(216, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[124] t=1781716063.63
  {"Mossy Stone Blocks", CFrame.new(212, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[125] t=1781716063.94
  {"Mossy Stone Blocks", CFrame.new(208, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[126] t=1781716064.26
  {"Mossy Stone Blocks", CFrame.new(204, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[127] t=1781716065.33
  {"Mossy Stone Blocks", CFrame.new(228, 6, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[128] t=1781716065.58
  {"Mossy Stone Blocks", CFrame.new(228, 6, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[129] t=1781716065.85
  {"Mossy Stone Blocks", CFrame.new(228, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[130] t=1781716066.17
  {"Mossy Stone Blocks", CFrame.new(228, 6, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[131] t=1781716066.50
  {"Mossy Stone Blocks", CFrame.new(228, 6, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[132] t=1781716067.00
  {"Mossy Stone Blocks", CFrame.new(228, 10, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[133] t=1781716067.27
  {"Mossy Stone Blocks", CFrame.new(228, 10, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[134] t=1781716067.54
  {"Mossy Stone Blocks", CFrame.new(228, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[135] t=1781716068.01
  {"Mossy Stone Blocks", CFrame.new(228, 10, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[136] t=1781716068.34
  {"Mossy Stone Blocks", CFrame.new(228, 10, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[137] t=1781716072.02
  {"Mossy Stone Blocks", CFrame.new(212, 6, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[138] t=1781716072.43
  {"Mossy Stone Blocks", CFrame.new(212, 10, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[139] t=1781716073.33
  {"Mossy Stone Blocks", CFrame.new(212, 6, -124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[140] t=1781716073.59
  {"Mossy Stone Blocks", CFrame.new(212, 6, -128, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[141] t=1781716073.87
  {"Mossy Stone Blocks", CFrame.new(212, 6, -132, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[142] t=1781716074.21
  {"Mossy Stone Blocks", CFrame.new(212, 6, -136, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[143] t=1781716074.50
  {"Mossy Stone Blocks", CFrame.new(212, 6, -140, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[144] t=1781716074.83
  {"Mossy Stone Blocks", CFrame.new(212, 6, -144, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[145] t=1781716075.21
  {"Mossy Stone Blocks", CFrame.new(212, 6, -148, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[146] t=1781716075.55
  {"Mossy Stone Blocks", CFrame.new(212, 6, -152, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[147] t=1781716076.06
  {"Mossy Stone Blocks", CFrame.new(212, 6, -156, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[148] t=1781716076.81
  {"Mossy Stone Blocks", CFrame.new(212, 10, -124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[149] t=1781716077.18
  {"Mossy Stone Blocks", CFrame.new(212, 10, -128, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[150] t=1781716077.50
  {"Mossy Stone Blocks", CFrame.new(212, 10, -132, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[151] t=1781716077.83
  {"Mossy Stone Blocks", CFrame.new(212, 10, -136, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[152] t=1781716078.17
  {"Mossy Stone Blocks", CFrame.new(212, 10, -140, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[153] t=1781716078.54
  {"Mossy Stone Blocks", CFrame.new(212, 10, -148, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[154] t=1781716079.38
  {"Mossy Stone Blocks", CFrame.new(212, 10, -144, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[155] t=1781716079.80
  {"Mossy Stone Blocks", CFrame.new(212, 10, -152, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[156] t=1781716080.18
  {"Mossy Stone Blocks", CFrame.new(212, 10, -156, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[157] t=1781716081.86
  {"Mossy Stone Blocks", CFrame.new(224, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[158] t=1781716082.10
  {"Mossy Stone Blocks", CFrame.new(220, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[159] t=1781716082.33
  {"Mossy Stone Blocks", CFrame.new(216, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[160] t=1781716082.55
  {"Mossy Stone Blocks", CFrame.new(212, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[161] t=1781716082.76
  {"Mossy Stone Blocks", CFrame.new(208, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[162] t=1781716082.99
  {"Mossy Stone Blocks", CFrame.new(204, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[163] t=1781716084.01
  {"Mossy Stone Blocks", CFrame.new(224, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[164] t=1781716084.23
  {"Mossy Stone Blocks", CFrame.new(220, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[165] t=1781716084.40
  {"Mossy Stone Blocks", CFrame.new(216, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[166] t=1781716084.59
  {"Mossy Stone Blocks", CFrame.new(212, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[167] t=1781716084.79
  {"Mossy Stone Blocks", CFrame.new(208, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[168] t=1781716085.36
  {"Mossy Stone Blocks", CFrame.new(204, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[169] t=1781716085.91
  {"Mossy Stone Blocks", CFrame.new(224, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[170] t=1781716086.12
  {"Mossy Stone Blocks", CFrame.new(220, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[171] t=1781716086.30
  {"Mossy Stone Blocks", CFrame.new(216, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[172] t=1781716086.49
  {"Mossy Stone Blocks", CFrame.new(212, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[173] t=1781716086.68
  {"Mossy Stone Blocks", CFrame.new(208, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[174] t=1781716087.08
  {"Mossy Stone Blocks", CFrame.new(204, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[175] t=1781716088.01
  {"Mossy Stone Blocks", CFrame.new(224, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[176] t=1781716088.21
  {"Mossy Stone Blocks", CFrame.new(220, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[177] t=1781716088.40
  {"Mossy Stone Blocks", CFrame.new(216, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[178] t=1781716088.58
  {"Mossy Stone Blocks", CFrame.new(212, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[179] t=1781716088.78
  {"Mossy Stone Blocks", CFrame.new(208, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[180] t=1781716088.98
  {"Mossy Stone Blocks", CFrame.new(204, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[181] t=1781716089.90
  {"Mossy Stone Blocks", CFrame.new(200, 6, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[182] t=1781716090.11
  {"Mossy Stone Blocks", CFrame.new(200, 6, -176, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[183] t=1781716090.33
  {"Mossy Stone Blocks", CFrame.new(200, 6, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[184] t=1781716090.62
  {"Mossy Stone Blocks", CFrame.new(200, 6, -168, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[185] t=1781716090.87
  {"Mossy Stone Blocks", CFrame.new(200, 6, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[186] t=1781716091.39
  {"Mossy Stone Blocks", CFrame.new(200, 10, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[187] t=1781716091.62
  {"Mossy Stone Blocks", CFrame.new(200, 10, -176, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[188] t=1781716091.88
  {"Mossy Stone Blocks", CFrame.new(200, 10, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[189] t=1781716092.18
  {"Mossy Stone Blocks", CFrame.new(200, 10, -168, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[190] t=1781716092.46
  {"Mossy Stone Blocks", CFrame.new(200, 10, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[191] t=1781716095.40
  {"Mossy Stone Blocks", CFrame.new(228, 6, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[192] t=1781716095.62
  {"Mossy Stone Blocks", CFrame.new(228, 6, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[193] t=1781716095.84
  {"Mossy Stone Blocks", CFrame.new(228, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[194] t=1781716096.05
  {"Mossy Stone Blocks", CFrame.new(228, 6, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[195] t=1781716096.35
  {"Mossy Stone Blocks", CFrame.new(228, 6, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[196] t=1781716096.89
  {"Mossy Stone Blocks", CFrame.new(228, 10, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[197] t=1781716097.07
  {"Mossy Stone Blocks", CFrame.new(228, 10, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[198] t=1781716097.28
  {"Mossy Stone Blocks", CFrame.new(228, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[199] t=1781716097.47
  {"Mossy Stone Blocks", CFrame.new(228, 10, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[200] t=1781716097.87
  {"Mossy Stone Blocks", CFrame.new(228, 10, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[201] t=1781716104.80
  {"Mossy Stone Blocks", CFrame.new(212, 14, -156, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[202] t=1781716105.03
  {"Mossy Stone Blocks", CFrame.new(212, 14, -152, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[203] t=1781716105.31
  {"Mossy Stone Blocks", CFrame.new(212, 14, -148, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[204] t=1781716105.57
  {"Mossy Stone Blocks", CFrame.new(212, 14, -144, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[205] t=1781716106.21
  {"Mossy Stone Blocks", CFrame.new(212, 14, -140, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[206] t=1781716106.51
  {"Mossy Stone Blocks", CFrame.new(212, 14, -136, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[207] t=1781716106.77
  {"Mossy Stone Blocks", CFrame.new(212, 14, -132, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[208] t=1781716107.57
  {"Mossy Stone Blocks", CFrame.new(212, 14, -128, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[209] t=1781716107.81
  {"Mossy Stone Blocks", CFrame.new(212, 14, -124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[210] t=1781716108.09
  {"Mossy Stone Blocks", CFrame.new(212, 14, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[211] t=1781716108.80
  {"Mossy Stone Blocks", CFrame.new(212, 14, -116, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[212] t=1781716109.07
  {"Mossy Stone Blocks", CFrame.new(212, 14, -112, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[213] t=1781716109.39
  {"Mossy Stone Blocks", CFrame.new(208, 14, -112, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[214] t=1781716110.03
  {"Mossy Stone Blocks", CFrame.new(212, 14, -108, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[215] t=1781716110.80
  {"Mossy Stone Blocks", CFrame.new(212, 14, -104, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[216] t=1781716111.10
  {"Mossy Stone Blocks", CFrame.new(212, 14, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[217] t=1781716111.86
  {"Mossy Stone Blocks", CFrame.new(212, 14, -96, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[218] t=1781716112.11
  {"Mossy Stone Blocks", CFrame.new(212, 14, -92, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[219] t=1781716112.68
  {"Mossy Stone Blocks", CFrame.new(212, 14, -88, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[220] t=1781716112.96
  {"Mossy Stone Blocks", CFrame.new(212, 14, -84, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[221] t=1781716113.59
  {"Mossy Stone Blocks", CFrame.new(212, 14, -80, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[222] t=1781716113.92
  {"Mossy Stone Blocks", CFrame.new(212, 14, -76, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[223] t=1781716114.57
  {"Mossy Stone Blocks", CFrame.new(212, 14, -72, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[224] t=1781716114.82
  {"Mossy Stone Blocks", CFrame.new(212, 14, -68, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[225] t=1781716115.20
  {"Mossy Stone Blocks", CFrame.new(212, 14, -64, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[226] t=1781716121.01
  {"Mossy Stone Blocks", CFrame.new(208, 14, -116, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[227] t=1781716121.93
  {"Mossy Stone Blocks", CFrame.new(208, 10, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[228] t=1781716122.42
  {"Mossy Stone Blocks", CFrame.new(208, 6, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[229] t=1781716122.90
  {"Mossy Stone Blocks", CFrame.new(208, 2, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[230] t=1781716123.84
  {"Mossy Stone Blocks", CFrame.new(208, 14, -108, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[231] t=1781716124.87
  {"Mossy Stone Blocks", CFrame.new(208, 14, -104, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[232] t=1781716125.76
  {"Mossy Stone Blocks", CFrame.new(208, 10, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[233] t=1781716126.29
  {"Mossy Stone Blocks", CFrame.new(208, 6, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[234] t=1781716126.68
  {"Mossy Stone Blocks", CFrame.new(208, 2, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[235] t=1781716136.93
  {"Mossy Stone Blocks", CFrame.new(212, 18, -156, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[236] t=1781716137.20
  {"Mossy Stone Blocks", CFrame.new(212, 18, -152, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[237] t=1781716137.46
  {"Mossy Stone Blocks", CFrame.new(212, 18, -148, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[238] t=1781716137.71
  {"Mossy Stone Blocks", CFrame.new(212, 18, -144, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[239] t=1781716137.97
  {"Mossy Stone Blocks", CFrame.new(212, 18, -140, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[240] t=1781716139.27
  {"Mossy Stone Blocks", CFrame.new(212, 18, -136, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[241] t=1781716140.10
  {"Mossy Stone Blocks", CFrame.new(212, 18, -132, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[242] t=1781716140.47
  {"Mossy Stone Blocks", CFrame.new(212, 18, -128, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[243] t=1781716140.89
  {"Mossy Stone Blocks", CFrame.new(212, 18, -124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[244] t=1781716141.21
  {"Mossy Stone Blocks", CFrame.new(212, 18, -120, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[245] t=1781716141.41
  {"Mossy Stone Blocks", CFrame.new(212, 18, -116, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[246] t=1781716141.63
  {"Mossy Stone Blocks", CFrame.new(212, 18, -112, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[247] t=1781716141.90
  {"Mossy Stone Blocks", CFrame.new(212, 18, -108, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[248] t=1781716142.36
  {"Mossy Stone Blocks", CFrame.new(212, 18, -104, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[249] t=1781716143.46
  {"Mossy Stone Blocks", CFrame.new(212, 18, -100, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[250] t=1781716143.69
  {"Mossy Stone Blocks", CFrame.new(212, 18, -96, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[251] t=1781716143.91
  {"Mossy Stone Blocks", CFrame.new(212, 18, -92, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[252] t=1781716144.12
  {"Mossy Stone Blocks", CFrame.new(212, 18, -88, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[253] t=1781716144.33
  {"Mossy Stone Blocks", CFrame.new(212, 18, -84, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[254] t=1781716144.56
  {"Mossy Stone Blocks", CFrame.new(212, 18, -80, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[255] t=1781716145.27
  {"Mossy Stone Blocks", CFrame.new(212, 18, -76, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[256] t=1781716145.79
  {"Mossy Stone Blocks", CFrame.new(212, 18, -72, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[257] t=1781716146.73
  {"Mossy Stone Blocks", CFrame.new(212, 18, -68, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[258] t=1781716147.29
  {"Mossy Stone Blocks", CFrame.new(212, 18, -64, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[259] t=1781716149.19
  {"Mossy Stone Blocks", CFrame.new(224, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[260] t=1781716149.40
  {"Mossy Stone Blocks", CFrame.new(220, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[261] t=1781716149.60
  {"Mossy Stone Blocks", CFrame.new(216, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[262] t=1781716149.85
  {"Mossy Stone Blocks", CFrame.new(212, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[263] t=1781716150.19
  {"Mossy Stone Blocks", CFrame.new(208, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[264] t=1781716150.75
  {"Mossy Stone Blocks", CFrame.new(204, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[265] t=1781716152.06
  {"Mossy Stone Blocks", CFrame.new(200, 14, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[266] t=1781716152.29
  {"Mossy Stone Blocks", CFrame.new(200, 14, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[267] t=1781716152.57
  {"Mossy Stone Blocks", CFrame.new(200, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[268] t=1781716152.98
  {"Mossy Stone Blocks", CFrame.new(200, 14, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[269] t=1781716153.41
  {"Mossy Stone Blocks", CFrame.new(200, 14, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[270] t=1781716154.17
  {"Mossy Stone Blocks", CFrame.new(224, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[271] t=1781716154.42
  {"Mossy Stone Blocks", CFrame.new(220, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[272] t=1781716154.65
  {"Mossy Stone Blocks", CFrame.new(216, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[273] t=1781716154.89
  {"Mossy Stone Blocks", CFrame.new(212, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[274] t=1781716155.39
  {"Mossy Stone Blocks", CFrame.new(208, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[275] t=1781716156.05
  {"Mossy Stone Blocks", CFrame.new(204, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[276] t=1781716156.94
  {"Mossy Stone Blocks", CFrame.new(200, 18, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[277] t=1781716157.17
  {"Mossy Stone Blocks", CFrame.new(200, 18, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[278] t=1781716157.44
  {"Mossy Stone Blocks", CFrame.new(200, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[279] t=1781716157.78
  {"Mossy Stone Blocks", CFrame.new(200, 18, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[280] t=1781716158.26
  {"Mossy Stone Blocks", CFrame.new(200, 18, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[281] t=1781716158.89
  {"Mossy Stone Blocks", CFrame.new(224, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[282] t=1781716159.11
  {"Mossy Stone Blocks", CFrame.new(220, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[283] t=1781716159.32
  {"Mossy Stone Blocks", CFrame.new(216, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[284] t=1781716159.54
  {"Mossy Stone Blocks", CFrame.new(212, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[285] t=1781716159.87
  {"Mossy Stone Blocks", CFrame.new(208, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[286] t=1781716160.49
  {"Mossy Stone Blocks", CFrame.new(204, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[287] t=1781716161.22
  {"Mossy Stone Blocks", CFrame.new(200, 22, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[288] t=1781716161.51
  {"Mossy Stone Blocks", CFrame.new(200, 22, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[289] t=1781716161.79
  {"Mossy Stone Blocks", CFrame.new(200, 22, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[290] t=1781716162.10
  {"Mossy Stone Blocks", CFrame.new(200, 22, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[291] t=1781716162.44
  {"Mossy Stone Blocks", CFrame.new(200, 22, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[292] t=1781716163.12
  {"Mossy Stone Blocks", CFrame.new(224, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[293] t=1781716163.36
  {"Mossy Stone Blocks", CFrame.new(220, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[294] t=1781716163.62
  {"Mossy Stone Blocks", CFrame.new(216, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[295] t=1781716163.87
  {"Mossy Stone Blocks", CFrame.new(212, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[296] t=1781716164.29
  {"Mossy Stone Blocks", CFrame.new(208, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[297] t=1781716164.96
  {"Mossy Stone Blocks", CFrame.new(204, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[298] t=1781716165.63
  {"Mossy Stone Blocks", CFrame.new(200, 26, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[299] t=1781716165.88
  {"Mossy Stone Blocks", CFrame.new(200, 26, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[300] t=1781716166.15
  {"Mossy Stone Blocks", CFrame.new(200, 26, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[301] t=1781716166.45
  {"Mossy Stone Blocks", CFrame.new(200, 26, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[302] t=1781716166.98
  {"Mossy Stone Blocks", CFrame.new(200, 26, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[303] t=1781716171.75
  {"Mossy Stone Blocks", CFrame.new(228, 14, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[304] t=1781716172.01
  {"Mossy Stone Blocks", CFrame.new(228, 14, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[305] t=1781716172.26
  {"Mossy Stone Blocks", CFrame.new(228, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[306] t=1781716172.53
  {"Mossy Stone Blocks", CFrame.new(228, 14, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[307] t=1781716172.91
  {"Mossy Stone Blocks", CFrame.new(228, 14, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[308] t=1781716173.76
  {"Mossy Stone Blocks", CFrame.new(228, 18, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[309] t=1781716174.00
  {"Mossy Stone Blocks", CFrame.new(228, 18, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[310] t=1781716174.36
  {"Mossy Stone Blocks", CFrame.new(228, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[311] t=1781716174.68
  {"Mossy Stone Blocks", CFrame.new(228, 18, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[312] t=1781716174.94
  {"Mossy Stone Blocks", CFrame.new(228, 18, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[313] t=1781716175.58
  {"Mossy Stone Blocks", CFrame.new(228, 22, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[314] t=1781716175.77
  {"Mossy Stone Blocks", CFrame.new(228, 22, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[315] t=1781716176.02
  {"Mossy Stone Blocks", CFrame.new(228, 22, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[316] t=1781716176.32
  {"Mossy Stone Blocks", CFrame.new(228, 22, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[317] t=1781716176.61
  {"Mossy Stone Blocks", CFrame.new(228, 22, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[318] t=1781716177.18
  {"Mossy Stone Blocks", CFrame.new(228, 26, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[319] t=1781716177.43
  {"Mossy Stone Blocks", CFrame.new(228, 26, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[320] t=1781716177.71
  {"Mossy Stone Blocks", CFrame.new(228, 26, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[321] t=1781716178.02
  {"Mossy Stone Blocks", CFrame.new(228, 26, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[322] t=1781716178.35
  {"Mossy Stone Blocks", CFrame.new(228, 26, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[323] t=1781716182.42
  {"Mossy Stone Blocks", CFrame.new(224, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[324] t=1781716182.70
  {"Mossy Stone Blocks", CFrame.new(220, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[325] t=1781716182.98
  {"Mossy Stone Blocks", CFrame.new(216, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[326] t=1781716183.30
  {"Mossy Stone Blocks", CFrame.new(212, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[327] t=1781716189.09
  {"Mossy Stone Blocks", CFrame.new(208, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[328] t=1781716189.41
  {"Mossy Stone Blocks", CFrame.new(204, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[329] t=1781716190.14
  {"Mossy Stone Blocks", CFrame.new(224, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[330] t=1781716190.43
  {"Mossy Stone Blocks", CFrame.new(220, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[331] t=1781716190.72
  {"Mossy Stone Blocks", CFrame.new(216, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[332] t=1781716191.05
  {"Mossy Stone Blocks", CFrame.new(212, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[333] t=1781716191.48
  {"Mossy Stone Blocks", CFrame.new(208, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[334] t=1781716191.87
  {"Mossy Stone Blocks", CFrame.new(204, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[335] t=1781716192.48
  {"Mossy Stone Blocks", CFrame.new(224, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[336] t=1781716192.72
  {"Mossy Stone Blocks", CFrame.new(220, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[337] t=1781716193.07
  {"Mossy Stone Blocks", CFrame.new(216, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[338] t=1781716193.39
  {"Mossy Stone Blocks", CFrame.new(212, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[339] t=1781716193.80
  {"Mossy Stone Blocks", CFrame.new(208, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[340] t=1781716194.18
  {"Mossy Stone Blocks", CFrame.new(204, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[341] t=1781716195.22
  {"Mossy Stone Blocks", CFrame.new(224, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[342] t=1781716195.56
  {"Mossy Stone Blocks", CFrame.new(220, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[343] t=1781716195.83
  {"Mossy Stone Blocks", CFrame.new(216, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[344] t=1781716196.19
  {"Mossy Stone Blocks", CFrame.new(212, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[345] t=1781716196.50
  {"Mossy Stone Blocks", CFrame.new(208, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[346] t=1781716196.90
  {"Mossy Stone Blocks", CFrame.new(204, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[347] t=1781716201.90
  {"Mossy Stone Blocks", CFrame.new(200, 30, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[348] t=1781716202.41
  {"Mossy Stone Blocks", CFrame.new(200, 30, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[349] t=1781716202.90
  {"Mossy Stone Blocks", CFrame.new(200, 30, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[350] t=1781716204.13
  {"Mossy Stone Blocks", CFrame.new(204, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[351] t=1781716205.27
  {"Mossy Stone Blocks", CFrame.new(212, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[352] t=1781716205.87
  {"Mossy Stone Blocks", CFrame.new(220, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[353] t=1781716206.59
  {"Mossy Stone Blocks", CFrame.new(228, 30, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[354] t=1781716207.60
  {"Mossy Stone Blocks", CFrame.new(228, 30, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[355] t=1781716211.22
  {"Mossy Stone Blocks", CFrame.new(204, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[356] t=1781716211.92
  {"Mossy Stone Blocks", CFrame.new(212, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[357] t=1781716212.53
  {"Mossy Stone Blocks", CFrame.new(220, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[358] t=1781716216.91
  {"Mossy Stone Blocks", CFrame.new(228, 30, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[359] t=1781716224.34
  {"Mossy Stone Blocks", CFrame.new(224, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[360] t=1781716224.60
  {"Mossy Stone Blocks", CFrame.new(220, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[361] t=1781716224.85
  {"Mossy Stone Blocks", CFrame.new(216, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[362] t=1781716225.13
  {"Mossy Stone Blocks", CFrame.new(212, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[363] t=1781716225.48
  {"Mossy Stone Blocks", CFrame.new(208, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[364] t=1781716225.87
  {"Mossy Stone Blocks", CFrame.new(204, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[365] t=1781716226.53
  {"Mossy Stone Blocks", CFrame.new(224, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[366] t=1781716226.75
  {"Mossy Stone Blocks", CFrame.new(220, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[367] t=1781716226.97
  {"Mossy Stone Blocks", CFrame.new(216, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[368] t=1781716227.22
  {"Mossy Stone Blocks", CFrame.new(212, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[369] t=1781716227.63
  {"Mossy Stone Blocks", CFrame.new(208, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[370] t=1781716227.97
  {"Mossy Stone Blocks", CFrame.new(204, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[371] t=1781716228.85
  {"Mossy Stone Blocks", CFrame.new(224, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[372] t=1781716229.06
  {"Mossy Stone Blocks", CFrame.new(220, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[373] t=1781716229.30
  {"Mossy Stone Blocks", CFrame.new(216, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[374] t=1781716229.63
  {"Mossy Stone Blocks", CFrame.new(212, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[375] t=1781716230.00
  {"Mossy Stone Blocks", CFrame.new(208, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[376] t=1781716230.33
  {"Mossy Stone Blocks", CFrame.new(204, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[377] t=1781716230.89
  {"Mossy Stone Blocks", CFrame.new(224, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[378] t=1781716231.14
  {"Mossy Stone Blocks", CFrame.new(220, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[379] t=1781716231.35
  {"Mossy Stone Blocks", CFrame.new(216, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[380] t=1781716231.61
  {"Mossy Stone Blocks", CFrame.new(212, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[381] t=1781716231.98
  {"Mossy Stone Blocks", CFrame.new(208, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[382] t=1781716232.34
  {"Mossy Stone Blocks", CFrame.new(204, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[383] t=1781716236.75
  {"Mossy Stone Blocks", CFrame.new(200, 14, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[384] t=1781716237.03
  {"Mossy Stone Blocks", CFrame.new(200, 14, -176, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[385] t=1781716237.34
  {"Mossy Stone Blocks", CFrame.new(200, 14, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[386] t=1781716237.59
  {"Mossy Stone Blocks", CFrame.new(200, 14, -168, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[387] t=1781716237.87
  {"Mossy Stone Blocks", CFrame.new(200, 14, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[388] t=1781716238.97
  {"Mossy Stone Blocks", CFrame.new(200, 18, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[389] t=1781716239.23
  {"Mossy Stone Blocks", CFrame.new(200, 18, -176, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[390] t=1781716239.49
  {"Mossy Stone Blocks", CFrame.new(200, 18, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[391] t=1781716239.88
  {"Mossy Stone Blocks", CFrame.new(200, 18, -168, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[392] t=1781716240.16
  {"Mossy Stone Blocks", CFrame.new(200, 18, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[393] t=1781716241.35
  {"Mossy Stone Blocks", CFrame.new(200, 22, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[394] t=1781716241.56
  {"Mossy Stone Blocks", CFrame.new(200, 22, -176, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[395] t=1781716241.80
  {"Mossy Stone Blocks", CFrame.new(200, 22, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[396] t=1781716242.06
  {"Mossy Stone Blocks", CFrame.new(200, 22, -168, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[397] t=1781716242.44
  {"Mossy Stone Blocks", CFrame.new(200, 22, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[398] t=1781716243.80
  {"Mossy Stone Blocks", CFrame.new(200, 26, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[399] t=1781716244.04
  {"Mossy Stone Blocks", CFrame.new(200, 26, -176, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[400] t=1781716244.30
  {"Mossy Stone Blocks", CFrame.new(200, 26, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[401] t=1781716244.53
  {"Mossy Stone Blocks", CFrame.new(200, 26, -168, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[402] t=1781716244.85
  {"Mossy Stone Blocks", CFrame.new(200, 26, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[403] t=1781716246.07
  {"Mossy Stone Blocks", CFrame.new(228, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[404] t=1781716248.39
  {"Mossy Stone Blocks", CFrame.new(228, 14, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[405] t=1781716248.58
  {"Mossy Stone Blocks", CFrame.new(228, 14, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[406] t=1781716249.16
  {"Mossy Stone Blocks", CFrame.new(228, 14, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[407] t=1781716249.36
  {"Mossy Stone Blocks", CFrame.new(228, 14, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[408] t=1781716249.65
  {"Mossy Stone Blocks", CFrame.new(228, 18, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[409] t=1781716249.85
  {"Mossy Stone Blocks", CFrame.new(228, 18, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[410] t=1781716250.07
  {"Mossy Stone Blocks", CFrame.new(228, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[411] t=1781716250.31
  {"Mossy Stone Blocks", CFrame.new(228, 18, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[412] t=1781716250.70
  {"Mossy Stone Blocks", CFrame.new(228, 18, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[413] t=1781716251.27
  {"Mossy Stone Blocks", CFrame.new(228, 22, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[414] t=1781716251.49
  {"Mossy Stone Blocks", CFrame.new(228, 22, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[415] t=1781716251.70
  {"Mossy Stone Blocks", CFrame.new(228, 22, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[416] t=1781716251.94
  {"Mossy Stone Blocks", CFrame.new(228, 22, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[417] t=1781716252.45
  {"Mossy Stone Blocks", CFrame.new(228, 22, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[418] t=1781716252.91
  {"Mossy Stone Blocks", CFrame.new(228, 26, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[419] t=1781716253.13
  {"Mossy Stone Blocks", CFrame.new(228, 26, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[420] t=1781716253.40
  {"Mossy Stone Blocks", CFrame.new(228, 26, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[421] t=1781716253.76
  {"Mossy Stone Blocks", CFrame.new(228, 26, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[422] t=1781716254.12
  {"Mossy Stone Blocks", CFrame.new(228, 26, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[423] t=1781716260.66
  {"Mossy Stone Blocks", CFrame.new(204, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[424] t=1781716260.95
  {"Mossy Stone Blocks", CFrame.new(208, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[425] t=1781716261.25
  {"Mossy Stone Blocks", CFrame.new(212, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[426] t=1781716261.54
  {"Mossy Stone Blocks", CFrame.new(216, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[427] t=1781716261.92
  {"Mossy Stone Blocks", CFrame.new(220, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[428] t=1781716262.45
  {"Mossy Stone Blocks", CFrame.new(224, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[429] t=1781716262.99
  {"Mossy Stone Blocks", CFrame.new(204, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[430] t=1781716263.22
  {"Mossy Stone Blocks", CFrame.new(208, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[431] t=1781716263.43
  {"Mossy Stone Blocks", CFrame.new(212, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[432] t=1781716263.68
  {"Mossy Stone Blocks", CFrame.new(216, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[433] t=1781716264.04
  {"Mossy Stone Blocks", CFrame.new(220, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[434] t=1781716264.50
  {"Mossy Stone Blocks", CFrame.new(224, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[435] t=1781716265.13
  {"Mossy Stone Blocks", CFrame.new(204, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[436] t=1781716265.41
  {"Mossy Stone Blocks", CFrame.new(208, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[437] t=1781716265.64
  {"Mossy Stone Blocks", CFrame.new(212, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[438] t=1781716266.00
  {"Mossy Stone Blocks", CFrame.new(216, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[439] t=1781716266.38
  {"Mossy Stone Blocks", CFrame.new(220, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[440] t=1781716266.86
  {"Mossy Stone Blocks", CFrame.new(224, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[441] t=1781716267.65
  {"Mossy Stone Blocks", CFrame.new(204, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[442] t=1781716267.94
  {"Mossy Stone Blocks", CFrame.new(208, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[443] t=1781716268.25
  {"Mossy Stone Blocks", CFrame.new(212, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[444] t=1781716268.78
  {"Mossy Stone Blocks", CFrame.new(220, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[445] t=1781716269.24
  {"Mossy Stone Blocks", CFrame.new(224, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[446] t=1781716269.70
  {"Mossy Stone Blocks", CFrame.new(216, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[447] t=1781716277.76
  {"Mossy Stone Blocks", CFrame.new(200, 30, -164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[448] t=1781716278.15
  {"Mossy Stone Blocks", CFrame.new(200, 30, -172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[449] t=1781716278.57
  {"Mossy Stone Blocks", CFrame.new(200, 30, -180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[450] t=1781716281.59
  {"Mossy Stone Blocks", CFrame.new(204, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[451] t=1781716287.15
  {"Mossy Stone Blocks", CFrame.new(204, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[452] t=1781716287.67
  {"Mossy Stone Blocks", CFrame.new(212, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[453] t=1781716288.55
  {"Mossy Stone Blocks", CFrame.new(212, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[454] t=1781716289.04
  {"Mossy Stone Blocks", CFrame.new(220, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[455] t=1781716289.73
  {"Mossy Stone Blocks", CFrame.new(220, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[456] t=1781716291.17
  {"Mossy Stone Blocks", CFrame.new(228, 30, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[457] t=1781716291.67
  {"Mossy Stone Blocks", CFrame.new(228, 30, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[458] t=1781716292.14
  {"Mossy Stone Blocks", CFrame.new(228, 30, -180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[459] t=1781716300.12
  {"Mossy Stone Blocks", CFrame.new(232, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[460] t=1781716300.85
  {"Mossy Stone Blocks", CFrame.new(236, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[461] t=1781716301.55
  {"Mossy Stone Blocks", CFrame.new(240, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[462] t=1781716302.15
  {"Mossy Stone Blocks", CFrame.new(244, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[463] t=1781716305.33
  {"Mossy Stone Blocks", CFrame.new(248, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[464] t=1781716305.55
  {"Mossy Stone Blocks", CFrame.new(252, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[465] t=1781716305.75
  {"Mossy Stone Blocks", CFrame.new(256, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[466] t=1781716305.94
  {"Mossy Stone Blocks", CFrame.new(260, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[467] t=1781716306.12
  {"Mossy Stone Blocks", CFrame.new(264, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[468] t=1781716306.30
  {"Mossy Stone Blocks", CFrame.new(268, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[469] t=1781716306.48
  {"Mossy Stone Blocks", CFrame.new(272, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[470] t=1781716306.64
  {"Mossy Stone Blocks", CFrame.new(276, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[471] t=1781716306.80
  {"Mossy Stone Blocks", CFrame.new(280, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[472] t=1781716306.97
  {"Mossy Stone Blocks", CFrame.new(284, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[473] t=1781716307.14
  {"Mossy Stone Blocks", CFrame.new(288, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[474] t=1781716307.31
  {"Mossy Stone Blocks", CFrame.new(292, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[475] t=1781716307.50
  {"Mossy Stone Blocks", CFrame.new(296, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[476] t=1781716307.87
  {"Mossy Stone Blocks", CFrame.new(300, 2, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[477] t=1781716313.61
  {"Mossy Stone Blocks", CFrame.new(232, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[478] t=1781716314.08
  {"Mossy Stone Blocks", CFrame.new(236, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[479] t=1781716314.28
  {"Mossy Stone Blocks", CFrame.new(240, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[480] t=1781716314.46
  {"Mossy Stone Blocks", CFrame.new(244, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[481] t=1781716314.64
  {"Mossy Stone Blocks", CFrame.new(248, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[482] t=1781716314.82
  {"Mossy Stone Blocks", CFrame.new(252, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[483] t=1781716315.06
  {"Mossy Stone Blocks", CFrame.new(256, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[484] t=1781716315.25
  {"Mossy Stone Blocks", CFrame.new(260, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[485] t=1781716315.45
  {"Mossy Stone Blocks", CFrame.new(264, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[486] t=1781716315.64
  {"Mossy Stone Blocks", CFrame.new(268, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[487] t=1781716315.84
  {"Mossy Stone Blocks", CFrame.new(272, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[488] t=1781716316.04
  {"Mossy Stone Blocks", CFrame.new(276, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[489] t=1781716316.22
  {"Mossy Stone Blocks", CFrame.new(280, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[490] t=1781716316.76
  {"Mossy Stone Blocks", CFrame.new(284, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[491] t=1781716316.98
  {"Mossy Stone Blocks", CFrame.new(288, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[492] t=1781716320.25
  {"Mossy Stone Blocks", CFrame.new(232, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[493] t=1781716320.60
  {"Mossy Stone Blocks", CFrame.new(236, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[494] t=1781716320.76
  {"Mossy Stone Blocks", CFrame.new(240, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[495] t=1781716320.94
  {"Mossy Stone Blocks", CFrame.new(244, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[496] t=1781716321.12
  {"Mossy Stone Blocks", CFrame.new(248, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[497] t=1781716321.30
  {"Mossy Stone Blocks", CFrame.new(252, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[498] t=1781716321.49
  {"Mossy Stone Blocks", CFrame.new(256, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[499] t=1781716321.67
  {"Mossy Stone Blocks", CFrame.new(260, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[500] t=1781716321.86
  {"Mossy Stone Blocks", CFrame.new(264, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[501] t=1781716322.05
  {"Mossy Stone Blocks", CFrame.new(268, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[502] t=1781716322.23
  {"Mossy Stone Blocks", CFrame.new(272, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[503] t=1781716322.42
  {"Mossy Stone Blocks", CFrame.new(276, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[504] t=1781716322.60
  {"Mossy Stone Blocks", CFrame.new(280, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[505] t=1781716322.81
  {"Mossy Stone Blocks", CFrame.new(284, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[506] t=1781716327.36
  {"Mossy Stone Blocks", CFrame.new(232, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[507] t=1781716327.54
  {"Mossy Stone Blocks", CFrame.new(236, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[508] t=1781716327.73
  {"Mossy Stone Blocks", CFrame.new(240, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[509] t=1781716327.93
  {"Mossy Stone Blocks", CFrame.new(244, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[510] t=1781716328.12
  {"Mossy Stone Blocks", CFrame.new(248, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[511] t=1781716328.31
  {"Mossy Stone Blocks", CFrame.new(252, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[512] t=1781716328.53
  {"Mossy Stone Blocks", CFrame.new(256, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[513] t=1781716328.73
  {"Mossy Stone Blocks", CFrame.new(260, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[514] t=1781716328.97
  {"Mossy Stone Blocks", CFrame.new(264, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[515] t=1781716329.20
  {"Mossy Stone Blocks", CFrame.new(268, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[516] t=1781716329.55
  {"Mossy Stone Blocks", CFrame.new(272, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[517] t=1781716329.89
  {"Mossy Stone Blocks", CFrame.new(276, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[518] t=1781716330.25
  {"Mossy Stone Blocks", CFrame.new(280, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[519] t=1781716333.22
  {"Mossy Stone Blocks", CFrame.new(232, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[520] t=1781716333.40
  {"Mossy Stone Blocks", CFrame.new(236, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[521] t=1781716333.60
  {"Mossy Stone Blocks", CFrame.new(240, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[522] t=1781716333.78
  {"Mossy Stone Blocks", CFrame.new(244, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[523] t=1781716333.97
  {"Mossy Stone Blocks", CFrame.new(248, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[524] t=1781716334.16
  {"Mossy Stone Blocks", CFrame.new(252, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[525] t=1781716334.36
  {"Mossy Stone Blocks", CFrame.new(256, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[526] t=1781716334.59
  {"Mossy Stone Blocks", CFrame.new(260, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[527] t=1781716334.79
  {"Mossy Stone Blocks", CFrame.new(264, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[528] t=1781716335.00
  {"Mossy Stone Blocks", CFrame.new(268, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[529] t=1781716335.21
  {"Mossy Stone Blocks", CFrame.new(272, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[530] t=1781716337.22
  {"Mossy Stone Blocks", CFrame.new(276, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[531] t=1781716337.61
  {"Mossy Stone Blocks", CFrame.new(280, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[532] t=1781716338.65
  {"Mossy Stone Blocks", CFrame.new(284, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[533] t=1781716338.91
  {"Mossy Stone Blocks", CFrame.new(284, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[534] t=1781716339.37
  {"Mossy Stone Blocks", CFrame.new(288, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[535] t=1781716339.62
  {"Mossy Stone Blocks", CFrame.new(288, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[536] t=1781716339.90
  {"Mossy Stone Blocks", CFrame.new(288, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[537] t=1781716340.72
  {"Mossy Stone Blocks", CFrame.new(292, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[538] t=1781716340.97
  {"Mossy Stone Blocks", CFrame.new(296, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[539] t=1781716341.33
  {"Mossy Stone Blocks", CFrame.new(300, 6, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[540] t=1781716341.66
  {"Mossy Stone Blocks", CFrame.new(292, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[541] t=1781716341.89
  {"Mossy Stone Blocks", CFrame.new(296, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[542] t=1781716342.14
  {"Mossy Stone Blocks", CFrame.new(300, 10, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[543] t=1781716342.56
  {"Mossy Stone Blocks", CFrame.new(292, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[544] t=1781716342.78
  {"Mossy Stone Blocks", CFrame.new(296, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[545] t=1781716343.03
  {"Mossy Stone Blocks", CFrame.new(300, 14, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[546] t=1781716343.47
  {"Mossy Stone Blocks", CFrame.new(292, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[547] t=1781716343.69
  {"Mossy Stone Blocks", CFrame.new(296, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[548] t=1781716343.96
  {"Mossy Stone Blocks", CFrame.new(300, 18, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[549] t=1781716348.48
  {"Mossy Stone Blocks", CFrame.new(300, 2, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[550] t=1781716348.71
  {"Mossy Stone Blocks", CFrame.new(300, 2, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[551] t=1781716350.07
  {"Mossy Stone Blocks", CFrame.new(304, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[552] t=1781716351.23
  {"Mossy Stone Blocks", CFrame.new(300, 2, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[553] t=1781716351.95
  {"Mossy Stone Blocks", CFrame.new(300, 2, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[554] t=1781716352.83
  {"Mossy Stone Blocks", CFrame.new(304, 2, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[555] t=1781716358.64
  {"Mossy Stone Blocks", CFrame.new(308, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[556] t=1781716359.12
  {"Mossy Stone Blocks", CFrame.new(312, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[557] t=1781716359.58
  {"Mossy Stone Blocks", CFrame.new(316, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[558] t=1781716360.07
  {"Mossy Stone Blocks", CFrame.new(320, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[559] t=1781716360.68
  {"Mossy Stone Blocks", CFrame.new(324, 2, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[560] t=1781716362.42
  {"Mossy Stone Blocks", CFrame.new(312, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[561] t=1781716362.89
  {"Mossy Stone Blocks", CFrame.new(316, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[562] t=1781716363.23
  {"Mossy Stone Blocks", CFrame.new(320, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[563] t=1781716363.61
  {"Mossy Stone Blocks", CFrame.new(324, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[564] t=1781716364.43
  {"Mossy Stone Blocks", CFrame.new(308, 2, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[565] t=1781716366.90
  {"Mossy Stone Blocks", CFrame.new(328, 2, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[566] t=1781716367.23
  {"Mossy Stone Blocks", CFrame.new(328, 2, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[567] t=1781716367.45
  {"Mossy Stone Blocks", CFrame.new(328, 2, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[568] t=1781716367.76
  {"Mossy Stone Blocks", CFrame.new(328, 2, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[569] t=1781716368.22
  {"Mossy Stone Blocks", CFrame.new(328, 2, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[570] t=1781716379.34
  {"Mossy Stone Blocks", CFrame.new(316, 2, -156, 1, 0, 0, 0), workspace.Baseplate},
  --[571] t=1781716379.79
  {"Mossy Stone Blocks", CFrame.new(316, 2, -152, 1, 0, 0, 0), workspace.Baseplate},
  --[572] t=1781716380.02
  {"Mossy Stone Blocks", CFrame.new(316, 2, -148, 1, 0, 0, 0), workspace.Baseplate},
  --[573] t=1781716380.29
  {"Mossy Stone Blocks", CFrame.new(316, 2, -144, 1, 0, 0, 0), workspace.Baseplate},
  --[574] t=1781716380.51
  {"Mossy Stone Blocks", CFrame.new(316, 2, -140, 1, 0, 0, 0), workspace.Baseplate},
  --[575] t=1781716380.73
  {"Mossy Stone Blocks", CFrame.new(316, 2, -136, 1, 0, 0, 0), workspace.Baseplate},
  --[576] t=1781716381.66
  {"Mossy Stone Blocks", CFrame.new(316, 2, -132, 1, 0, 0, 0), workspace.Baseplate},
  --[577] t=1781716381.88
  {"Mossy Stone Blocks", CFrame.new(316, 2, -128, 1, 0, 0, 0), workspace.Baseplate},
  --[578] t=1781716382.07
  {"Mossy Stone Blocks", CFrame.new(316, 2, -124, 1, 0, 0, 0), workspace.Baseplate},
  --[579] t=1781716382.29
  {"Mossy Stone Blocks", CFrame.new(316, 2, -120, 1, 0, 0, 0), workspace.Baseplate},
  --[580] t=1781716382.48
  {"Mossy Stone Blocks", CFrame.new(316, 2, -116, 1, 0, 0, 0), workspace.Baseplate},
  --[581] t=1781716382.66
  {"Mossy Stone Blocks", CFrame.new(316, 2, -112, 1, 0, 0, 0), workspace.Baseplate},
  --[582] t=1781716383.61
  {"Mossy Stone Blocks", CFrame.new(316, 2, -108, 1, 0, 0, 0), workspace.Baseplate},
  --[583] t=1781716383.85
  {"Mossy Stone Blocks", CFrame.new(316, 2, -104, 1, 0, 0, 0), workspace.Baseplate},
  --[584] t=1781716384.05
  {"Mossy Stone Blocks", CFrame.new(316, 2, -100, 1, 0, 0, 0), workspace.Baseplate},
  --[585] t=1781716384.24
  {"Mossy Stone Blocks", CFrame.new(316, 2, -96, 1, 0, 0, 0), workspace.Baseplate},
  --[586] t=1781716389.34
  {"Mossy Stone Blocks", CFrame.new(232, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[587] t=1781716389.62
  {"Mossy Stone Blocks", CFrame.new(236, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[588] t=1781716389.86
  {"Mossy Stone Blocks", CFrame.new(240, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[589] t=1781716390.07
  {"Mossy Stone Blocks", CFrame.new(244, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[590] t=1781716390.25
  {"Mossy Stone Blocks", CFrame.new(248, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[591] t=1781716391.26
  {"Mossy Stone Blocks", CFrame.new(252, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[592] t=1781716391.45
  {"Mossy Stone Blocks", CFrame.new(256, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[593] t=1781716391.66
  {"Mossy Stone Blocks", CFrame.new(260, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[594] t=1781716391.85
  {"Mossy Stone Blocks", CFrame.new(264, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[595] t=1781716392.08
  {"Mossy Stone Blocks", CFrame.new(268, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[596] t=1781716392.29
  {"Mossy Stone Blocks", CFrame.new(272, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[597] t=1781716392.46
  {"Mossy Stone Blocks", CFrame.new(276, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[598] t=1781716392.64
  {"Mossy Stone Blocks", CFrame.new(280, 2, -48, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[599] t=1781716394.24
  {"Mossy Stone Blocks", CFrame.new(284, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[600] t=1781716394.49
  {"Mossy Stone Blocks", CFrame.new(288, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[601] t=1781716426.69
  {"Mossy Stone Blocks", CFrame.new(292, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[602] t=1781716427.16
  {"Mossy Stone Blocks", CFrame.new(296, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[603] t=1781716427.68
  {"Mossy Stone Blocks", CFrame.new(300, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[604] t=1781716434.88
  {"Mossy Stone Blocks", CFrame.new(300, 2, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[605] t=1781716435.13
  {"Mossy Stone Blocks", CFrame.new(300, 2, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[606] t=1781716438.57
  {"Mossy Stone Blocks", CFrame.new(304, 2, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[607] t=1781716439.00
  {"Mossy Stone Blocks", CFrame.new(308, 2, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[608] t=1781716439.39
  {"Mossy Stone Blocks", CFrame.new(312, 2, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[609] t=1781716439.93
  {"Mossy Stone Blocks", CFrame.new(316, 2, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[610] t=1781716440.38
  {"Mossy Stone Blocks", CFrame.new(320, 2, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[611] t=1781716445.04
  {"Mossy Stone Blocks", CFrame.new(324, 2, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[612] t=1781716449.63
  {"Mossy Stone Blocks", CFrame.new(316, 2, -64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[613] t=1781716449.87
  {"Mossy Stone Blocks", CFrame.new(316, 2, -68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[614] t=1781716450.17
  {"Mossy Stone Blocks", CFrame.new(316, 2, -72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[615] t=1781716450.47
  {"Mossy Stone Blocks", CFrame.new(316, 2, -76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[616] t=1781716450.73
  {"Mossy Stone Blocks", CFrame.new(316, 2, -80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[617] t=1781716450.98
  {"Mossy Stone Blocks", CFrame.new(316, 2, -84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[618] t=1781716451.34
  {"Mossy Stone Blocks", CFrame.new(316, 2, -88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[619] t=1781716451.70
  {"Mossy Stone Blocks", CFrame.new(316, 2, -92, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[620] t=1781716453.84
  {"Mossy Stone Blocks", CFrame.new(328, 2, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[621] t=1781716454.13
  {"Mossy Stone Blocks", CFrame.new(328, 2, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[622] t=1781716454.35
  {"Mossy Stone Blocks", CFrame.new(328, 2, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[623] t=1781716454.64
  {"Mossy Stone Blocks", CFrame.new(328, 2, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[624] t=1781716467.75
  {"Mossy Stone Blocks", CFrame.new(328, 2, -40, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[625] t=1781716469.19
  {"Mossy Stone Blocks", CFrame.new(324, 2, -36, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[626] t=1781716471.74
  {"Mossy Stone Blocks", CFrame.new(320, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[627] t=1781716472.12
  {"Mossy Stone Blocks", CFrame.new(316, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[628] t=1781716472.49
  {"Mossy Stone Blocks", CFrame.new(312, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[629] t=1781716472.92
  {"Mossy Stone Blocks", CFrame.new(308, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[630] t=1781716474.98
  {"Mossy Stone Blocks", CFrame.new(304, 2, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[631] t=1781716475.59
  {"Mossy Stone Blocks", CFrame.new(300, 2, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[632] t=1781716475.97
  {"Mossy Stone Blocks", CFrame.new(300, 2, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[633] t=1781716481.69
  {"Mossy Stone Blocks", CFrame.new(232, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[634] t=1781716482.15
  {"Mossy Stone Blocks", CFrame.new(232, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[635] t=1781716482.66
  {"Mossy Stone Blocks", CFrame.new(236, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[636] t=1781716482.91
  {"Mossy Stone Blocks", CFrame.new(240, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[637] t=1781716483.14
  {"Mossy Stone Blocks", CFrame.new(244, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[638] t=1781716484.08
  {"Mossy Stone Blocks", CFrame.new(248, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[639] t=1781716484.31
  {"Mossy Stone Blocks", CFrame.new(252, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[640] t=1781716484.58
  {"Mossy Stone Blocks", CFrame.new(256, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[641] t=1781716484.78
  {"Mossy Stone Blocks", CFrame.new(260, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[642] t=1781716484.97
  {"Mossy Stone Blocks", CFrame.new(264, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[643] t=1781716485.20
  {"Mossy Stone Blocks", CFrame.new(268, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[644] t=1781716485.40
  {"Mossy Stone Blocks", CFrame.new(272, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[645] t=1781716485.62
  {"Mossy Stone Blocks", CFrame.new(276, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[646] t=1781716486.01
  {"Mossy Stone Blocks", CFrame.new(280, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[647] t=1781716486.44
  {"Mossy Stone Blocks", CFrame.new(284, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[648] t=1781716487.93
  {"Mossy Stone Blocks", CFrame.new(232, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[649] t=1781716488.15
  {"Mossy Stone Blocks", CFrame.new(236, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[650] t=1781716488.37
  {"Mossy Stone Blocks", CFrame.new(240, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[651] t=1781716488.58
  {"Mossy Stone Blocks", CFrame.new(244, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[652] t=1781716488.79
  {"Mossy Stone Blocks", CFrame.new(248, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[653] t=1781716488.97
  {"Mossy Stone Blocks", CFrame.new(252, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[654] t=1781716489.20
  {"Mossy Stone Blocks", CFrame.new(256, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[655] t=1781716489.40
  {"Mossy Stone Blocks", CFrame.new(260, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[656] t=1781716489.58
  {"Mossy Stone Blocks", CFrame.new(264, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[657] t=1781716489.77
  {"Mossy Stone Blocks", CFrame.new(268, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[658] t=1781716489.95
  {"Mossy Stone Blocks", CFrame.new(272, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[659] t=1781716490.14
  {"Mossy Stone Blocks", CFrame.new(276, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[660] t=1781716490.33
  {"Mossy Stone Blocks", CFrame.new(280, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[661] t=1781716490.52
  {"Mossy Stone Blocks", CFrame.new(284, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[662] t=1781716492.44
  {"Mossy Stone Blocks", CFrame.new(232, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[663] t=1781716492.67
  {"Mossy Stone Blocks", CFrame.new(236, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[664] t=1781716492.87
  {"Mossy Stone Blocks", CFrame.new(240, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[665] t=1781716493.07
  {"Mossy Stone Blocks", CFrame.new(244, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[666] t=1781716493.27
  {"Mossy Stone Blocks", CFrame.new(248, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[667] t=1781716493.45
  {"Mossy Stone Blocks", CFrame.new(252, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[668] t=1781716493.63
  {"Mossy Stone Blocks", CFrame.new(256, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[669] t=1781716493.81
  {"Mossy Stone Blocks", CFrame.new(260, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[670] t=1781716494.00
  {"Mossy Stone Blocks", CFrame.new(264, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[671] t=1781716494.20
  {"Mossy Stone Blocks", CFrame.new(268, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[672] t=1781716494.39
  {"Mossy Stone Blocks", CFrame.new(272, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[673] t=1781716494.59
  {"Mossy Stone Blocks", CFrame.new(276, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[674] t=1781716494.82
  {"Mossy Stone Blocks", CFrame.new(280, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[675] t=1781716498.67
  {"Mossy Stone Blocks", CFrame.new(232, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[676] t=1781716498.99
  {"Mossy Stone Blocks", CFrame.new(236, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[677] t=1781716499.17
  {"Mossy Stone Blocks", CFrame.new(240, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[678] t=1781716499.35
  {"Mossy Stone Blocks", CFrame.new(244, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[679] t=1781716499.52
  {"Mossy Stone Blocks", CFrame.new(248, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[680] t=1781716499.75
  {"Mossy Stone Blocks", CFrame.new(252, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[681] t=1781716499.94
  {"Mossy Stone Blocks", CFrame.new(256, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[682] t=1781716500.12
  {"Mossy Stone Blocks", CFrame.new(260, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[683] t=1781716500.30
  {"Mossy Stone Blocks", CFrame.new(264, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[684] t=1781716500.50
  {"Mossy Stone Blocks", CFrame.new(268, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[685] t=1781716500.70
  {"Mossy Stone Blocks", CFrame.new(272, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[686] t=1781716500.89
  {"Mossy Stone Blocks", CFrame.new(276, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[687] t=1781716501.08
  {"Mossy Stone Blocks", CFrame.new(280, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[688] t=1781716504.43
  {"Mossy Stone Blocks", CFrame.new(284, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[689] t=1781716504.69
  {"Mossy Stone Blocks", CFrame.new(284, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[690] t=1781716506.27
  {"Mossy Stone Blocks", CFrame.new(288, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[691] t=1781716506.50
  {"Mossy Stone Blocks", CFrame.new(292, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[692] t=1781716506.82
  {"Mossy Stone Blocks", CFrame.new(296, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[693] t=1781716507.26
  {"Mossy Stone Blocks", CFrame.new(288, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[694] t=1781716507.50
  {"Mossy Stone Blocks", CFrame.new(292, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[695] t=1781716507.75
  {"Mossy Stone Blocks", CFrame.new(296, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[696] t=1781716508.20
  {"Mossy Stone Blocks", CFrame.new(288, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[697] t=1781716508.44
  {"Mossy Stone Blocks", CFrame.new(292, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[698] t=1781716508.73
  {"Mossy Stone Blocks", CFrame.new(296, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[699] t=1781716509.29
  {"Mossy Stone Blocks", CFrame.new(288, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[700] t=1781716509.51
  {"Mossy Stone Blocks", CFrame.new(292, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[701] t=1781716509.88
  {"Mossy Stone Blocks", CFrame.new(296, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[702] t=1781716512.24
  {"Mossy Stone Blocks", CFrame.new(300, 6, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[703] t=1781716512.45
  {"Mossy Stone Blocks", CFrame.new(300, 6, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[704] t=1781716512.82
  {"Mossy Stone Blocks", CFrame.new(300, 10, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[705] t=1781716513.02
  {"Mossy Stone Blocks", CFrame.new(300, 10, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[706] t=1781716513.47
  {"Mossy Stone Blocks", CFrame.new(300, 14, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[707] t=1781716513.67
  {"Mossy Stone Blocks", CFrame.new(300, 14, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[708] t=1781716514.12
  {"Mossy Stone Blocks", CFrame.new(300, 18, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[709] t=1781716514.33
  {"Mossy Stone Blocks", CFrame.new(300, 18, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[710] t=1781716515.00
  {"Mossy Stone Blocks", CFrame.new(304, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[711] t=1781716515.22
  {"Mossy Stone Blocks", CFrame.new(308, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[712] t=1781716515.61
  {"Mossy Stone Blocks", CFrame.new(304, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[713] t=1781716515.83
  {"Mossy Stone Blocks", CFrame.new(308, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[714] t=1781716516.12
  {"Mossy Stone Blocks", CFrame.new(304, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[715] t=1781716516.35
  {"Mossy Stone Blocks", CFrame.new(308, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[716] t=1781716516.81
  {"Mossy Stone Blocks", CFrame.new(304, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[717] t=1781716517.01
  {"Mossy Stone Blocks", CFrame.new(308, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[718] t=1781716517.54
  {"Mossy Stone Blocks", CFrame.new(312, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[719] t=1781716517.77
  {"Mossy Stone Blocks", CFrame.new(316, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[720] t=1781716518.14
  {"Mossy Stone Blocks", CFrame.new(312, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[721] t=1781716518.36
  {"Mossy Stone Blocks", CFrame.new(316, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[722] t=1781716518.62
  {"Mossy Stone Blocks", CFrame.new(312, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[723] t=1781716518.85
  {"Mossy Stone Blocks", CFrame.new(316, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[724] t=1781716519.20
  {"Mossy Stone Blocks", CFrame.new(312, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[725] t=1781716519.43
  {"Mossy Stone Blocks", CFrame.new(316, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[726] t=1781716519.96
  {"Mossy Stone Blocks", CFrame.new(320, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[727] t=1781716520.37
  {"Mossy Stone Blocks", CFrame.new(324, 6, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[728] t=1781716520.63
  {"Mossy Stone Blocks", CFrame.new(320, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[729] t=1781716520.90
  {"Mossy Stone Blocks", CFrame.new(324, 10, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[730] t=1781716521.26
  {"Mossy Stone Blocks", CFrame.new(320, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[731] t=1781716521.49
  {"Mossy Stone Blocks", CFrame.new(324, 14, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[732] t=1781716522.18
  {"Mossy Stone Blocks", CFrame.new(320, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[733] t=1781716522.56
  {"Mossy Stone Blocks", CFrame.new(324, 18, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[734] t=1781716525.69
  {"Mossy Stone Blocks", CFrame.new(300, 6, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[735] t=1781716525.87
  {"Mossy Stone Blocks", CFrame.new(300, 6, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[736] t=1781716526.17
  {"Mossy Stone Blocks", CFrame.new(300, 10, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[737] t=1781716526.37
  {"Mossy Stone Blocks", CFrame.new(300, 10, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[738] t=1781716526.68
  {"Mossy Stone Blocks", CFrame.new(300, 14, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[739] t=1781716526.90
  {"Mossy Stone Blocks", CFrame.new(300, 14, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[740] t=1781716527.31
  {"Mossy Stone Blocks", CFrame.new(300, 18, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[741] t=1781716527.51
  {"Mossy Stone Blocks", CFrame.new(300, 18, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[742] t=1781716528.68
  {"Mossy Stone Blocks", CFrame.new(304, 6, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[743] t=1781716528.88
  {"Mossy Stone Blocks", CFrame.new(312, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[744] t=1781716529.39
  {"Mossy Stone Blocks", CFrame.new(312, 6, -188, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[745] t=1781716529.93
  {"Mossy Stone Blocks", CFrame.new(308, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[746] t=1781716530.35
  {"Mossy Stone Blocks", CFrame.new(304, 10, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[747] t=1781716530.55
  {"Mossy Stone Blocks", CFrame.new(308, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[748] t=1781716530.86
  {"Mossy Stone Blocks", CFrame.new(312, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[749] t=1781716531.36
  {"Mossy Stone Blocks", CFrame.new(304, 14, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[750] t=1781716531.59
  {"Mossy Stone Blocks", CFrame.new(308, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[751] t=1781716531.82
  {"Mossy Stone Blocks", CFrame.new(312, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[752] t=1781716532.48
  {"Mossy Stone Blocks", CFrame.new(304, 18, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[753] t=1781716532.69
  {"Mossy Stone Blocks", CFrame.new(308, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[754] t=1781716532.99
  {"Mossy Stone Blocks", CFrame.new(312, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[755] t=1781716533.84
  {"Mossy Stone Blocks", CFrame.new(316, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[756] t=1781716534.05
  {"Mossy Stone Blocks", CFrame.new(320, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[757] t=1781716534.29
  {"Mossy Stone Blocks", CFrame.new(324, 6, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[758] t=1781716534.74
  {"Mossy Stone Blocks", CFrame.new(316, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[759] t=1781716534.94
  {"Mossy Stone Blocks", CFrame.new(320, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[760] t=1781716535.19
  {"Mossy Stone Blocks", CFrame.new(324, 10, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[761] t=1781716535.65
  {"Mossy Stone Blocks", CFrame.new(316, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[762] t=1781716535.85
  {"Mossy Stone Blocks", CFrame.new(320, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[763] t=1781716536.11
  {"Mossy Stone Blocks", CFrame.new(324, 14, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[764] t=1781716536.56
  {"Mossy Stone Blocks", CFrame.new(316, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[765] t=1781716536.77
  {"Mossy Stone Blocks", CFrame.new(320, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[766] t=1781716537.01
  {"Mossy Stone Blocks", CFrame.new(324, 18, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[767] t=1781716538.02
  {"Mossy Stone Blocks", CFrame.new(328, 6, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[768] t=1781716538.23
  {"Mossy Stone Blocks", CFrame.new(328, 6, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[769] t=1781716538.48
  {"Mossy Stone Blocks", CFrame.new(328, 6, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[770] t=1781716538.84
  {"Mossy Stone Blocks", CFrame.new(328, 6, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[771] t=1781716539.11
  {"Mossy Stone Blocks", CFrame.new(328, 6, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[772] t=1781716539.80
  {"Mossy Stone Blocks", CFrame.new(328, 10, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[773] t=1781716540.03
  {"Mossy Stone Blocks", CFrame.new(328, 10, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[774] t=1781716540.25
  {"Mossy Stone Blocks", CFrame.new(328, 10, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[775] t=1781716540.45
  {"Mossy Stone Blocks", CFrame.new(328, 10, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[776] t=1781716540.86
  {"Mossy Stone Blocks", CFrame.new(328, 10, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[777] t=1781716541.50
  {"Mossy Stone Blocks", CFrame.new(328, 14, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[778] t=1781716541.73
  {"Mossy Stone Blocks", CFrame.new(328, 14, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[779] t=1781716541.98
  {"Mossy Stone Blocks", CFrame.new(328, 14, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[780] t=1781716542.28
  {"Mossy Stone Blocks", CFrame.new(328, 14, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[781] t=1781716542.69
  {"Mossy Stone Blocks", CFrame.new(328, 14, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[782] t=1781716543.52
  {"Mossy Stone Blocks", CFrame.new(328, 18, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[783] t=1781716543.75
  {"Mossy Stone Blocks", CFrame.new(328, 18, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[784] t=1781716544.00
  {"Mossy Stone Blocks", CFrame.new(328, 18, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[785] t=1781716544.35
  {"Mossy Stone Blocks", CFrame.new(328, 18, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[786] t=1781716544.74
  {"Mossy Stone Blocks", CFrame.new(328, 18, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[787] t=1781716547.32
  {"Mossy Stone Blocks", CFrame.new(316, 6, -156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[788] t=1781716547.54
  {"Mossy Stone Blocks", CFrame.new(316, 6, -152, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[789] t=1781716547.77
  {"Mossy Stone Blocks", CFrame.new(316, 6, -148, 1, 0, 0, 0), workspace.Baseplate},
  --[790] t=1781716549.17
  {"Mossy Stone Blocks", CFrame.new(316, 6, -144, 1, 0, 0, 0), workspace.Baseplate},
  --[791] t=1781716549.37
  {"Mossy Stone Blocks", CFrame.new(316, 6, -140, 1, 0, 0, 0), workspace.Baseplate},
  --[792] t=1781716549.55
  {"Mossy Stone Blocks", CFrame.new(316, 6, -136, 1, 0, 0, 0), workspace.Baseplate},
  --[793] t=1781716549.74
  {"Mossy Stone Blocks", CFrame.new(316, 6, -132, 1, 0, 0, 0), workspace.Baseplate},
  --[794] t=1781716549.92
  {"Mossy Stone Blocks", CFrame.new(316, 6, -128, 1, 0, 0, 0), workspace.Baseplate},
  --[795] t=1781716550.11
  {"Mossy Stone Blocks", CFrame.new(316, 6, -124, 1, 0, 0, 0), workspace.Baseplate},
  --[796] t=1781716550.29
  {"Mossy Stone Blocks", CFrame.new(316, 6, -120, 1, 0, 0, 0), workspace.Baseplate},
  --[797] t=1781716550.49
  {"Mossy Stone Blocks", CFrame.new(316, 6, -116, 1, 0, 0, 0), workspace.Baseplate},
  --[798] t=1781716550.70
  {"Mossy Stone Blocks", CFrame.new(316, 6, -112, 1, 0, 0, 0), workspace.Baseplate},
  --[799] t=1781716550.89
  {"Mossy Stone Blocks", CFrame.new(316, 6, -108, 1, 0, 0, 0), workspace.Baseplate},
  --[800] t=1781716552.35
  {"Mossy Stone Blocks", CFrame.new(316, 6, -104, 1, 0, 0, 0), workspace.Baseplate},
  --[801] t=1781716552.53
  {"Mossy Stone Blocks", CFrame.new(316, 6, -100, 1, 0, 0, 0), workspace.Baseplate},
  --[802] t=1781716552.72
  {"Mossy Stone Blocks", CFrame.new(316, 6, -96, 1, 0, 0, 0), workspace.Baseplate},
  --[803] t=1781716552.91
  {"Mossy Stone Blocks", CFrame.new(316, 6, -92, 1, 0, 0, 0), workspace.Baseplate},
  --[804] t=1781716553.10
  {"Mossy Stone Blocks", CFrame.new(316, 6, -88, 1, 0, 0, 0), workspace.Baseplate},
  --[805] t=1781716553.29
  {"Mossy Stone Blocks", CFrame.new(316, 6, -84, 1, 0, 0, 0), workspace.Baseplate},
  --[806] t=1781716553.50
  {"Mossy Stone Blocks", CFrame.new(316, 6, -80, 1, 0, 0, 0), workspace.Baseplate},
  --[807] t=1781716553.70
  {"Mossy Stone Blocks", CFrame.new(316, 6, -76, 1, 0, 0, 0), workspace.Baseplate},
  --[808] t=1781716554.73
  {"Mossy Stone Blocks", CFrame.new(316, 6, -72, 1, 0, 0, 0), workspace.Baseplate},
  --[809] t=1781716555.91
  {"Mossy Stone Blocks", CFrame.new(316, 6, -68, 1, 0, 0, 0), workspace.Baseplate},
  --[810] t=1781716556.17
  {"Mossy Stone Blocks", CFrame.new(316, 6, -64, 1, 0, 0, 0), workspace.Baseplate},
  --[811] t=1781716556.54
  {"Mossy Stone Blocks", CFrame.new(316, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[812] t=1781716557.78
  {"Mossy Stone Blocks", CFrame.new(316, 10, -156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[813] t=1781716557.96
  {"Mossy Stone Blocks", CFrame.new(316, 10, -152, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[814] t=1781716558.13
  {"Mossy Stone Blocks", CFrame.new(316, 10, -148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[815] t=1781716558.31
  {"Mossy Stone Blocks", CFrame.new(316, 10, -144, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[816] t=1781716558.52
  {"Mossy Stone Blocks", CFrame.new(316, 10, -140, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[817] t=1781716558.70
  {"Mossy Stone Blocks", CFrame.new(316, 10, -136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[818] t=1781716558.87
  {"Mossy Stone Blocks", CFrame.new(316, 10, -132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[819] t=1781716559.06
  {"Mossy Stone Blocks", CFrame.new(316, 10, -128, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[820] t=1781716559.24
  {"Mossy Stone Blocks", CFrame.new(316, 10, -124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[821] t=1781716559.46
  {"Mossy Stone Blocks", CFrame.new(316, 10, -120, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[822] t=1781716559.65
  {"Mossy Stone Blocks", CFrame.new(316, 10, -116, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[823] t=1781716559.82
  {"Mossy Stone Blocks", CFrame.new(316, 10, -112, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[824] t=1781716560.01
  {"Mossy Stone Blocks", CFrame.new(316, 10, -108, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[825] t=1781716560.20
  {"Mossy Stone Blocks", CFrame.new(316, 10, -104, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[826] t=1781716560.39
  {"Mossy Stone Blocks", CFrame.new(316, 10, -100, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[827] t=1781716560.56
  {"Mossy Stone Blocks", CFrame.new(316, 10, -96, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[828] t=1781716560.73
  {"Mossy Stone Blocks", CFrame.new(316, 10, -92, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[829] t=1781716560.91
  {"Mossy Stone Blocks", CFrame.new(316, 10, -88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[830] t=1781716561.08
  {"Mossy Stone Blocks", CFrame.new(316, 10, -84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[831] t=1781716561.26
  {"Mossy Stone Blocks", CFrame.new(316, 10, -80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[832] t=1781716561.45
  {"Mossy Stone Blocks", CFrame.new(316, 10, -76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[833] t=1781716563.40
  {"Mossy Stone Blocks", CFrame.new(316, 14, -156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[834] t=1781716563.57
  {"Mossy Stone Blocks", CFrame.new(316, 14, -152, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[835] t=1781716563.74
  {"Mossy Stone Blocks", CFrame.new(316, 14, -148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[836] t=1781716564.01
  {"Mossy Stone Blocks", CFrame.new(316, 14, -144, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[837] t=1781716564.22
  {"Mossy Stone Blocks", CFrame.new(316, 14, -140, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[838] t=1781716564.41
  {"Mossy Stone Blocks", CFrame.new(316, 14, -136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[839] t=1781716564.63
  {"Mossy Stone Blocks", CFrame.new(316, 14, -132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[840] t=1781716564.85
  {"Mossy Stone Blocks", CFrame.new(316, 14, -128, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[841] t=1781716565.08
  {"Mossy Stone Blocks", CFrame.new(316, 14, -124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[842] t=1781716565.30
  {"Mossy Stone Blocks", CFrame.new(316, 14, -120, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[843] t=1781716565.52
  {"Mossy Stone Blocks", CFrame.new(316, 14, -116, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[844] t=1781716565.71
  {"Mossy Stone Blocks", CFrame.new(316, 14, -112, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[845] t=1781716567.49
  {"Mossy Stone Blocks", CFrame.new(316, 18, -156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[846] t=1781716567.69
  {"Mossy Stone Blocks", CFrame.new(316, 18, -152, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[847] t=1781716567.87
  {"Mossy Stone Blocks", CFrame.new(316, 18, -148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[848] t=1781716568.07
  {"Mossy Stone Blocks", CFrame.new(316, 18, -144, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[849] t=1781716568.25
  {"Mossy Stone Blocks", CFrame.new(316, 18, -140, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[850] t=1781716568.44
  {"Mossy Stone Blocks", CFrame.new(316, 18, -136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[851] t=1781716568.67
  {"Mossy Stone Blocks", CFrame.new(316, 18, -132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[852] t=1781716568.90
  {"Mossy Stone Blocks", CFrame.new(316, 18, -128, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[853] t=1781716569.12
  {"Mossy Stone Blocks", CFrame.new(316, 18, -124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[854] t=1781716569.32
  {"Mossy Stone Blocks", CFrame.new(316, 18, -120, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[855] t=1781716569.53
  {"Mossy Stone Blocks", CFrame.new(316, 18, -116, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[856] t=1781716571.36
  {"Mossy Stone Blocks", CFrame.new(316, 14, -108, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[857] t=1781716571.55
  {"Mossy Stone Blocks", CFrame.new(316, 14, -104, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[858] t=1781716571.74
  {"Mossy Stone Blocks", CFrame.new(316, 14, -100, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[859] t=1781716571.94
  {"Mossy Stone Blocks", CFrame.new(316, 14, -96, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[860] t=1781716572.13
  {"Mossy Stone Blocks", CFrame.new(316, 14, -92, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[861] t=1781716572.34
  {"Mossy Stone Blocks", CFrame.new(316, 14, -88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[862] t=1781716572.56
  {"Mossy Stone Blocks", CFrame.new(316, 14, -84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[863] t=1781716572.81
  {"Mossy Stone Blocks", CFrame.new(316, 14, -80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[864] t=1781716573.72
  {"Mossy Stone Blocks", CFrame.new(316, 18, -112, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[865] t=1781716573.91
  {"Mossy Stone Blocks", CFrame.new(316, 18, -108, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[866] t=1781716574.08
  {"Mossy Stone Blocks", CFrame.new(316, 18, -104, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[867] t=1781716574.27
  {"Mossy Stone Blocks", CFrame.new(316, 18, -100, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[868] t=1781716574.47
  {"Mossy Stone Blocks", CFrame.new(316, 18, -96, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[869] t=1781716574.68
  {"Mossy Stone Blocks", CFrame.new(316, 18, -92, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[870] t=1781716574.89
  {"Mossy Stone Blocks", CFrame.new(316, 18, -88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[871] t=1781716575.09
  {"Mossy Stone Blocks", CFrame.new(316, 18, -84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[872] t=1781716575.56
  {"Mossy Stone Blocks", CFrame.new(316, 18, -80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[873] t=1781716576.24
  {"Mossy Stone Blocks", CFrame.new(316, 14, -76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[874] t=1781716576.44
  {"Mossy Stone Blocks", CFrame.new(316, 18, -76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[875] t=1781716577.14
  {"Mossy Stone Blocks", CFrame.new(316, 10, -72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[876] t=1781716577.36
  {"Mossy Stone Blocks", CFrame.new(316, 10, -68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[877] t=1781716577.62
  {"Mossy Stone Blocks", CFrame.new(316, 10, -64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[878] t=1781716578.26
  {"Mossy Stone Blocks", CFrame.new(316, 14, -72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[879] t=1781716578.47
  {"Mossy Stone Blocks", CFrame.new(316, 14, -68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[880] t=1781716578.69
  {"Mossy Stone Blocks", CFrame.new(316, 14, -64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[881] t=1781716579.07
  {"Mossy Stone Blocks", CFrame.new(316, 18, -72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[882] t=1781716579.26
  {"Mossy Stone Blocks", CFrame.new(316, 18, -68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[883] t=1781716579.44
  {"Mossy Stone Blocks", CFrame.new(316, 18, -64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[884] t=1781716580.06
  {"Mossy Stone Blocks", CFrame.new(316, 10, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[885] t=1781716580.29
  {"Mossy Stone Blocks", CFrame.new(316, 14, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[886] t=1781716581.86
  {"Mossy Stone Blocks", CFrame.new(316, 18, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[887] t=1781716585.31
  {"Mossy Stone Blocks", CFrame.new(300, 6, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[888] t=1781716585.53
  {"Mossy Stone Blocks", CFrame.new(300, 6, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[889] t=1781716585.73
  {"Mossy Stone Blocks", CFrame.new(300, 6, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[890] t=1781716585.94
  {"Mossy Stone Blocks", CFrame.new(300, 6, -44, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[891] t=1781716586.16
  {"Mossy Stone Blocks", CFrame.new(300, 6, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[892] t=1781716586.86
  {"Mossy Stone Blocks", CFrame.new(300, 10, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[893] t=1781716587.07
  {"Mossy Stone Blocks", CFrame.new(300, 10, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[894] t=1781716587.26
  {"Mossy Stone Blocks", CFrame.new(300, 10, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[895] t=1781716587.48
  {"Mossy Stone Blocks", CFrame.new(300, 10, -44, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[896] t=1781716587.75
  {"Mossy Stone Blocks", CFrame.new(300, 10, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[897] t=1781716588.52
  {"Mossy Stone Blocks", CFrame.new(300, 14, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[898] t=1781716588.74
  {"Mossy Stone Blocks", CFrame.new(300, 14, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[899] t=1781716588.96
  {"Mossy Stone Blocks", CFrame.new(300, 14, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[900] t=1781716589.22
  {"Mossy Stone Blocks", CFrame.new(300, 14, -44, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[901] t=1781716589.47
  {"Mossy Stone Blocks", CFrame.new(300, 14, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[902] t=1781716590.23
  {"Mossy Stone Blocks", CFrame.new(300, 18, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[903] t=1781716590.43
  {"Mossy Stone Blocks", CFrame.new(300, 18, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[904] t=1781716590.63
  {"Mossy Stone Blocks", CFrame.new(300, 18, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[905] t=1781716590.84
  {"Mossy Stone Blocks", CFrame.new(300, 18, -44, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[906] t=1781716591.07
  {"Mossy Stone Blocks", CFrame.new(300, 18, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[907] t=1781716592.40
  {"Mossy Stone Blocks", CFrame.new(304, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[908] t=1781716592.61
  {"Mossy Stone Blocks", CFrame.new(308, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[909] t=1781716592.80
  {"Mossy Stone Blocks", CFrame.new(312, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[910] t=1781716593.00
  {"Mossy Stone Blocks", CFrame.new(316, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[911] t=1781716593.22
  {"Mossy Stone Blocks", CFrame.new(320, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[912] t=1781716593.61
  {"Mossy Stone Blocks", CFrame.new(324, 6, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[913] t=1781716594.27
  {"Mossy Stone Blocks", CFrame.new(304, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[914] t=1781716594.47
  {"Mossy Stone Blocks", CFrame.new(308, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[915] t=1781716594.68
  {"Mossy Stone Blocks", CFrame.new(312, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[916] t=1781716594.90
  {"Mossy Stone Blocks", CFrame.new(316, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[917] t=1781716595.11
  {"Mossy Stone Blocks", CFrame.new(320, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[918] t=1781716595.54
  {"Mossy Stone Blocks", CFrame.new(324, 10, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[919] t=1781716596.28
  {"Mossy Stone Blocks", CFrame.new(304, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[920] t=1781716596.49
  {"Mossy Stone Blocks", CFrame.new(308, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[921] t=1781716596.70
  {"Mossy Stone Blocks", CFrame.new(312, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[922] t=1781716596.90
  {"Mossy Stone Blocks", CFrame.new(316, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[923] t=1781716597.20
  {"Mossy Stone Blocks", CFrame.new(320, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[924] t=1781716597.56
  {"Mossy Stone Blocks", CFrame.new(324, 14, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[925] t=1781716598.30
  {"Mossy Stone Blocks", CFrame.new(304, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[926] t=1781716598.51
  {"Mossy Stone Blocks", CFrame.new(308, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[927] t=1781716598.72
  {"Mossy Stone Blocks", CFrame.new(312, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[928] t=1781716598.92
  {"Mossy Stone Blocks", CFrame.new(316, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[929] t=1781716599.16
  {"Mossy Stone Blocks", CFrame.new(320, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[930] t=1781716599.51
  {"Mossy Stone Blocks", CFrame.new(324, 18, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[931] t=1781716600.78
  {"Mossy Stone Blocks", CFrame.new(328, 6, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[932] t=1781716600.98
  {"Mossy Stone Blocks", CFrame.new(328, 6, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[933] t=1781716601.22
  {"Mossy Stone Blocks", CFrame.new(328, 6, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[934] t=1781716601.46
  {"Mossy Stone Blocks", CFrame.new(328, 6, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[935] t=1781716601.75
  {"Mossy Stone Blocks", CFrame.new(328, 6, -40, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[936] t=1781716602.32
  {"Mossy Stone Blocks", CFrame.new(328, 10, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[937] t=1781716602.53
  {"Mossy Stone Blocks", CFrame.new(328, 10, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[938] t=1781716602.77
  {"Mossy Stone Blocks", CFrame.new(328, 10, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[939] t=1781716603.07
  {"Mossy Stone Blocks", CFrame.new(328, 10, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[940] t=1781716603.33
  {"Mossy Stone Blocks", CFrame.new(328, 10, -40, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[941] t=1781716604.05
  {"Mossy Stone Blocks", CFrame.new(328, 14, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[942] t=1781716604.43
  {"Mossy Stone Blocks", CFrame.new(328, 14, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[943] t=1781716604.70
  {"Mossy Stone Blocks", CFrame.new(328, 14, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[944] t=1781716604.96
  {"Mossy Stone Blocks", CFrame.new(328, 14, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[945] t=1781716605.29
  {"Mossy Stone Blocks", CFrame.new(328, 14, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[946] t=1781716606.69
  {"Mossy Stone Blocks", CFrame.new(328, 18, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[947] t=1781716606.93
  {"Mossy Stone Blocks", CFrame.new(328, 18, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[948] t=1781716607.19
  {"Mossy Stone Blocks", CFrame.new(328, 18, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[949] t=1781716607.46
  {"Mossy Stone Blocks", CFrame.new(328, 18, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[950] t=1781716607.76
  {"Mossy Stone Blocks", CFrame.new(328, 18, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[951] t=1781716608.42
  {"Mossy Stone Blocks", CFrame.new(320, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[952] t=1781716608.64
  {"Mossy Stone Blocks", CFrame.new(324, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[953] t=1781716608.92
  {"Mossy Stone Blocks", CFrame.new(320, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[954] t=1781716609.13
  {"Mossy Stone Blocks", CFrame.new(324, 10, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[955] t=1781716609.40
  {"Mossy Stone Blocks", CFrame.new(320, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[956] t=1781716609.60
  {"Mossy Stone Blocks", CFrame.new(324, 14, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[957] t=1781716609.91
  {"Mossy Stone Blocks", CFrame.new(320, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[958] t=1781716610.11
  {"Mossy Stone Blocks", CFrame.new(324, 18, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[959] t=1781716613.28
  {"Mossy Stone Blocks", CFrame.new(312, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[960] t=1781716613.48
  {"Mossy Stone Blocks", CFrame.new(308, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[961] t=1781716613.96
  {"Mossy Stone Blocks", CFrame.new(312, 10, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[962] t=1781716614.13
  {"Mossy Stone Blocks", CFrame.new(308, 10, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[963] t=1781716614.39
  {"Mossy Stone Blocks", CFrame.new(312, 14, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[964] t=1781716614.59
  {"Mossy Stone Blocks", CFrame.new(308, 14, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[965] t=1781716614.94
  {"Mossy Stone Blocks", CFrame.new(312, 18, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[966] t=1781716615.12
  {"Mossy Stone Blocks", CFrame.new(308, 18, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[967] t=1781716615.85
  {"Mossy Stone Blocks", CFrame.new(304, 6, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[968] t=1781716616.07
  {"Mossy Stone Blocks", CFrame.new(304, 10, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[969] t=1781716616.30
  {"Mossy Stone Blocks", CFrame.new(304, 14, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[970] t=1781716616.55
  {"Mossy Stone Blocks", CFrame.new(304, 18, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[971] t=1781716620.57
  {"Mossy Stone Blocks", CFrame.new(300, 22, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[972] t=1781716620.80
  {"Mossy Stone Blocks", CFrame.new(300, 22, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[973] t=1781716621.04
  {"Mossy Stone Blocks", CFrame.new(300, 22, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[974] t=1781716621.29
  {"Mossy Stone Blocks", CFrame.new(300, 22, -44, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[975] t=1781716621.57
  {"Mossy Stone Blocks", CFrame.new(300, 22, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[976] t=1781716621.88
  {"Mossy Stone Blocks", CFrame.new(300, 26, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[977] t=1781716622.11
  {"Mossy Stone Blocks", CFrame.new(300, 26, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[978] t=1781716622.56
  {"Mossy Stone Blocks", CFrame.new(300, 26, -44, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[979] t=1781716623.07
  {"Mossy Stone Blocks", CFrame.new(300, 26, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[980] t=1781716623.28
  {"Mossy Stone Blocks", CFrame.new(300, 26, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[981] t=1781716627.22
  {"Mossy Stone Blocks", CFrame.new(324, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[982] t=1781716627.41
  {"Mossy Stone Blocks", CFrame.new(320, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[983] t=1781716627.62
  {"Mossy Stone Blocks", CFrame.new(316, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[984] t=1781716627.81
  {"Mossy Stone Blocks", CFrame.new(312, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[985] t=1781716628.04
  {"Mossy Stone Blocks", CFrame.new(308, 22, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[986] t=1781716628.20
  {"Mossy Stone Blocks", CFrame.new(308, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[987] t=1781716628.56
  {"Mossy Stone Blocks", CFrame.new(304, 22, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[988] t=1781716629.41
  {"Mossy Stone Blocks", CFrame.new(324, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[989] t=1781716629.60
  {"Mossy Stone Blocks", CFrame.new(320, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[990] t=1781716629.87
  {"Mossy Stone Blocks", CFrame.new(316, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[991] t=1781716630.28
  {"Mossy Stone Blocks", CFrame.new(312, 26, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[992] t=1781716631.13
  {"Mossy Stone Blocks", CFrame.new(304, 26, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[993] t=1781716633.08
  {"Mossy Stone Blocks", CFrame.new(328, 22, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[994] t=1781716633.56
  {"Mossy Stone Blocks", CFrame.new(328, 22, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[995] t=1781716634.07
  {"Mossy Stone Blocks", CFrame.new(328, 22, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[996] t=1781716634.43
  {"Mossy Stone Blocks", CFrame.new(328, 22, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[997] t=1781716634.85
  {"Mossy Stone Blocks", CFrame.new(328, 26, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[998] t=1781716635.23
  {"Mossy Stone Blocks", CFrame.new(328, 26, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[999] t=1781716635.53
  {"Mossy Stone Blocks", CFrame.new(328, 26, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[1000] t=1781716635.91
  {"Mossy Stone Blocks", CFrame.new(328, 26, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[1001] t=1781716641.85
  {"Mossy Stone Blocks", CFrame.new(324, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1002] t=1781716642.21
  {"Mossy Stone Blocks", CFrame.new(320, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1003] t=1781716642.48
  {"Mossy Stone Blocks", CFrame.new(316, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1004] t=1781716642.77
  {"Mossy Stone Blocks", CFrame.new(312, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1005] t=1781716643.14
  {"Mossy Stone Blocks", CFrame.new(308, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1006] t=1781716643.49
  {"Mossy Stone Blocks", CFrame.new(304, 22, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1007] t=1781716644.38
  {"Mossy Stone Blocks", CFrame.new(324, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1008] t=1781716644.68
  {"Mossy Stone Blocks", CFrame.new(320, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1009] t=1781716644.95
  {"Mossy Stone Blocks", CFrame.new(316, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1010] t=1781716645.21
  {"Mossy Stone Blocks", CFrame.new(312, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1011] t=1781716645.55
  {"Mossy Stone Blocks", CFrame.new(308, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1012] t=1781716645.92
  {"Mossy Stone Blocks", CFrame.new(304, 26, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1013] t=1781716650.82
  {"Mossy Stone Blocks", CFrame.new(328, 22, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[1014] t=1781716653.85
  {"Mossy Stone Blocks", CFrame.new(328, 26, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[1015] t=1781716657.71
  {"Mossy Stone Blocks", CFrame.new(324, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1016] t=1781716657.92
  {"Mossy Stone Blocks", CFrame.new(320, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1017] t=1781716658.33
  {"Mossy Stone Blocks", CFrame.new(324, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1018] t=1781716658.53
  {"Mossy Stone Blocks", CFrame.new(320, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1019] t=1781716660.25
  {"Mossy Stone Blocks", CFrame.new(316, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1020] t=1781716660.49
  {"Mossy Stone Blocks", CFrame.new(316, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1021] t=1781716660.78
  {"Mossy Stone Blocks", CFrame.new(312, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1022] t=1781716660.99
  {"Mossy Stone Blocks", CFrame.new(312, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1023] t=1781716661.53
  {"Mossy Stone Blocks", CFrame.new(308, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1024] t=1781716661.73
  {"Mossy Stone Blocks", CFrame.new(308, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1025] t=1781716662.23
  {"Mossy Stone Blocks", CFrame.new(304, 22, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1026] t=1781716663.71
  {"Mossy Stone Blocks", CFrame.new(304, 26, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1027] t=1781716665.17
  {"Mossy Stone Blocks", CFrame.new(300, 22, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1028] t=1781716665.39
  {"Mossy Stone Blocks", CFrame.new(300, 26, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1029] t=1781716665.89
  {"Mossy Stone Blocks", CFrame.new(300, 22, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1030] t=1781716666.23
  {"Mossy Stone Blocks", CFrame.new(300, 26, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1031] t=1781716666.96
  {"Mossy Stone Blocks", CFrame.new(300, 22, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1032] t=1781716667.19
  {"Mossy Stone Blocks", CFrame.new(300, 22, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1033] t=1781716667.51
  {"Mossy Stone Blocks", CFrame.new(300, 22, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1034] t=1781716667.93
  {"Mossy Stone Blocks", CFrame.new(300, 26, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1035] t=1781716668.17
  {"Mossy Stone Blocks", CFrame.new(300, 26, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1036] t=1781716668.48
  {"Mossy Stone Blocks", CFrame.new(300, 26, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1037] t=1781716671.92
  {"Mossy Stone Blocks", CFrame.new(324, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1038] t=1781716672.18
  {"Mossy Stone Blocks", CFrame.new(320, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1039] t=1781716672.45
  {"Mossy Stone Blocks", CFrame.new(316, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1040] t=1781716672.74
  {"Mossy Stone Blocks", CFrame.new(312, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1041] t=1781716673.06
  {"Mossy Stone Blocks", CFrame.new(308, 22, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1042] t=1781716673.48
  {"Mossy Stone Blocks", CFrame.new(304, 22, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1043] t=1781716674.04
  {"Mossy Stone Blocks", CFrame.new(324, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1044] t=1781716674.27
  {"Mossy Stone Blocks", CFrame.new(320, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1045] t=1781716674.57
  {"Mossy Stone Blocks", CFrame.new(316, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1046] t=1781716674.84
  {"Mossy Stone Blocks", CFrame.new(312, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1047] t=1781716675.12
  {"Mossy Stone Blocks", CFrame.new(308, 26, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1048] t=1781716675.62
  {"Mossy Stone Blocks", CFrame.new(304, 26, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1049] t=1781716677.52
  {"Mossy Stone Blocks", CFrame.new(328, 22, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[1050] t=1781716677.75
  {"Mossy Stone Blocks", CFrame.new(328, 22, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[1051] t=1781716677.97
  {"Mossy Stone Blocks", CFrame.new(328, 22, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[1052] t=1781716678.23
  {"Mossy Stone Blocks", CFrame.new(328, 22, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[1053] t=1781716678.59
  {"Mossy Stone Blocks", CFrame.new(328, 22, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[1054] t=1781716679.11
  {"Mossy Stone Blocks", CFrame.new(328, 26, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[1055] t=1781716679.34
  {"Mossy Stone Blocks", CFrame.new(328, 26, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[1056] t=1781716679.56
  {"Mossy Stone Blocks", CFrame.new(328, 26, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[1057] t=1781716679.83
  {"Mossy Stone Blocks", CFrame.new(328, 26, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[1058] t=1781716680.19
  {"Mossy Stone Blocks", CFrame.new(328, 26, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[1059] t=1781716685.10
  {"Mossy Stone Blocks", CFrame.new(300, 30, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1060] t=1781716685.36
  {"Mossy Stone Blocks", CFrame.new(300, 30, -168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1061] t=1781716685.66
  {"Mossy Stone Blocks", CFrame.new(300, 30, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1062] t=1781716686.06
  {"Mossy Stone Blocks", CFrame.new(300, 30, -176, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1063] t=1781716688.27
  {"Mossy Stone Blocks", CFrame.new(300, 30, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1064] t=1781716690.53
  {"Mossy Stone Blocks", CFrame.new(328, 30, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[1065] t=1781716690.78
  {"Mossy Stone Blocks", CFrame.new(328, 30, -168, 1, 0, 0, 0), workspace.Baseplate},
  --[1066] t=1781716691.11
  {"Mossy Stone Blocks", CFrame.new(328, 30, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[1067] t=1781716691.45
  {"Mossy Stone Blocks", CFrame.new(328, 30, -176, 1, 0, 0, 0), workspace.Baseplate},
  --[1068] t=1781716691.84
  {"Mossy Stone Blocks", CFrame.new(328, 30, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[1069] t=1781716695.22
  {"Mossy Stone Blocks", CFrame.new(324, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1070] t=1781716695.46
  {"Mossy Stone Blocks", CFrame.new(320, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1071] t=1781716695.76
  {"Mossy Stone Blocks", CFrame.new(316, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1072] t=1781716696.04
  {"Mossy Stone Blocks", CFrame.new(312, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1073] t=1781716696.33
  {"Mossy Stone Blocks", CFrame.new(308, 30, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1074] t=1781716699.78
  {"Mossy Stone Blocks", CFrame.new(308, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1075] t=1781716700.11
  {"Mossy Stone Blocks", CFrame.new(312, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1076] t=1781716700.37
  {"Mossy Stone Blocks", CFrame.new(316, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1077] t=1781716700.68
  {"Mossy Stone Blocks", CFrame.new(320, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1078] t=1781716701.02
  {"Mossy Stone Blocks", CFrame.new(324, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1079] t=1781716705.66
  {"Mossy Stone Blocks", CFrame.new(304, 30, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1080] t=1781716706.28
  {"Mossy Stone Blocks", CFrame.new(304, 30, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1081] t=1781716706.84
  {"Mossy Stone Blocks", CFrame.new(300, 34, -180, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1082] t=1781716707.39
  {"Mossy Stone Blocks", CFrame.new(300, 34, -172, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1083] t=1781716707.84
  {"Mossy Stone Blocks", CFrame.new(300, 34, -164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1084] t=1781716708.58
  {"Mossy Stone Blocks", CFrame.new(304, 34, -184, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1085] t=1781716709.27
  {"Mossy Stone Blocks", CFrame.new(304, 34, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1086] t=1781716710.72
  {"Mossy Stone Blocks", CFrame.new(312, 34, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1087] t=1781716711.25
  {"Mossy Stone Blocks", CFrame.new(320, 34, -184, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[1088] t=1781716711.73
  {"Mossy Stone Blocks", CFrame.new(328, 34, -180, 1, 0, 0, 0), workspace.Baseplate},
  --[1089] t=1781716712.21
  {"Mossy Stone Blocks", CFrame.new(328, 34, -172, 1, 0, 0, 0), workspace.Baseplate},
  --[1090] t=1781716712.66
  {"Mossy Stone Blocks", CFrame.new(328, 34, -164, 1, 0, 0, 0), workspace.Baseplate},
  --[1091] t=1781716713.30
  {"Mossy Stone Blocks", CFrame.new(324, 34, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1092] t=1781716715.24
  {"Mossy Stone Blocks", CFrame.new(316, 34, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1093] t=1781716726.33
  {"Mossy Stone Blocks", CFrame.new(312, 34, -160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1094] t=1781716731.18
  {"Mossy Stone Blocks", CFrame.new(316, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1095] t=1781716731.42
  {"Mossy Stone Blocks", CFrame.new(312, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1096] t=1781716731.84
  {"Mossy Stone Blocks", CFrame.new(304, 30, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1097] t=1781716732.09
  {"Mossy Stone Blocks", CFrame.new(308, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1098] t=1781716732.69
  {"Mossy Stone Blocks", CFrame.new(324, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1099] t=1781716732.90
  {"Mossy Stone Blocks", CFrame.new(320, 30, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1100] t=1781716734.25
  {"Mossy Stone Blocks", CFrame.new(328, 30, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[1101] t=1781716734.78
  {"Mossy Stone Blocks", CFrame.new(328, 30, -44, 1, 0, 0, 0), workspace.Baseplate},
  --[1102] t=1781716735.01
  {"Mossy Stone Blocks", CFrame.new(328, 30, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[1103] t=1781716735.25
  {"Mossy Stone Blocks", CFrame.new(328, 30, -52, 1, 0, 0, 0), workspace.Baseplate},
  --[1104] t=1781716735.68
  {"Mossy Stone Blocks", CFrame.new(328, 30, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[1105] t=1781716736.68
  {"Mossy Stone Blocks", CFrame.new(324, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1106] t=1781716737.08
  {"Mossy Stone Blocks", CFrame.new(320, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1107] t=1781716737.38
  {"Mossy Stone Blocks", CFrame.new(316, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1108] t=1781716737.75
  {"Mossy Stone Blocks", CFrame.new(312, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1109] t=1781716738.08
  {"Mossy Stone Blocks", CFrame.new(308, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1110] t=1781716739.13
  {"Mossy Stone Blocks", CFrame.new(300, 30, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1111] t=1781716739.47
  {"Mossy Stone Blocks", CFrame.new(300, 30, -44, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1112] t=1781716739.80
  {"Mossy Stone Blocks", CFrame.new(300, 30, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1113] t=1781716740.13
  {"Mossy Stone Blocks", CFrame.new(300, 30, -52, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1114] t=1781716740.54
  {"Mossy Stone Blocks", CFrame.new(300, 30, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1115] t=1781716742.04
  {"Mossy Stone Blocks", CFrame.new(300, 34, -40, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1116] t=1781716742.63
  {"Mossy Stone Blocks", CFrame.new(300, 34, -48, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1117] t=1781716743.16
  {"Mossy Stone Blocks", CFrame.new(300, 34, -56, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[1118] t=1781716743.72
  {"Mossy Stone Blocks", CFrame.new(304, 34, -60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[1119] t=1781716744.40
  {"Mossy Stone Blocks", CFrame.new(312, 34, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1120] t=1781716744.65
  {"Mossy Stone Blocks", CFrame.new(316, 34, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1121] t=1781716745.18
  {"Mossy Stone Blocks", CFrame.new(324, 34, -60, 1, 0, 0, 0), workspace.Baseplate},
  --[1122] t=1781716745.80
  {"Mossy Stone Blocks", CFrame.new(328, 34, -40, 1, 0, 0, 0), workspace.Baseplate},
  --[1123] t=1781716746.46
  {"Mossy Stone Blocks", CFrame.new(328, 34, -48, 1, 0, 0, 0), workspace.Baseplate},
  --[1124] t=1781716747.20
  {"Mossy Stone Blocks", CFrame.new(328, 34, -56, 1, 0, 0, 0), workspace.Baseplate},
  --[1125] t=1781716749.35
  {"Mossy Stone Blocks", CFrame.new(316, 34, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1126] t=1781716754.94
  {"Mossy Stone Blocks", CFrame.new(304, 30, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1127] t=1781716755.27
  {"Mossy Stone Blocks", CFrame.new(304, 34, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1128] t=1781716755.81
  {"Mossy Stone Blocks", CFrame.new(312, 34, -36, 1, 0, 0, 0), workspace.Baseplate},
  --[1129] t=1781716756.41
  {"Mossy Stone Blocks", CFrame.new(324, 34, -36, 1, 0, 0, 0), workspace.Baseplate},
}
local coolpattern = {
  --[1] t=1781716976.47
  {"Bricks", CFrame.new(152, 2, 136, 0, 0, 1, 0), workspace.Baseplate},
  --[2] t=1781716976.80
  {"Bricks", CFrame.new(152, 2, 140, 0, 0, 1, 0), workspace.Baseplate},
  --[3] t=1781716977.11
  {"Bricks", CFrame.new(152, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[4] t=1781716977.62
  {"Bricks", CFrame.new(152, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[5] t=1781716978.37
  {"Bricks", CFrame.new(156, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[6] t=1781716979.01
  {"Bricks", CFrame.new(164, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[7] t=1781716979.55
  {"Bricks", CFrame.new(160, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[8] t=1781716981.55
  {"Bricks", CFrame.new(168, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[9] t=1781716982.14
  {"Bricks", CFrame.new(172, 2, 148, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[10] t=1781716982.50
  {"Bricks", CFrame.new(172, 2, 144, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[11] t=1781716983.47
  {"Bricks", CFrame.new(172, 2, 140, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[12] t=1781716983.70
  {"Bricks", CFrame.new(172, 2, 136, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[13] t=1781716984.35
  {"Bricks", CFrame.new(156, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[14] t=1781716984.63
  {"Bricks", CFrame.new(160, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[15] t=1781716984.93
  {"Bricks", CFrame.new(164, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[16] t=1781716985.29
  {"Bricks", CFrame.new(168, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[17] t=1781716988.75
  {"Bricks", CFrame.new(172, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[18] t=1781716989.41
  {"Bricks", CFrame.new(152, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[19] t=1781716990.55
  {"Bricks", CFrame.new(152, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[20] t=1781716990.82
  {"Bricks", CFrame.new(152, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[21] t=1781716991.25
  {"Bricks", CFrame.new(152, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[22] t=1781716992.03
  {"Bricks", CFrame.new(172, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[23] t=1781716992.31
  {"Bricks", CFrame.new(172, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[24] t=1781716992.62
  {"Bricks", CFrame.new(172, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[25] t=1781716993.25
  {"Bricks", CFrame.new(156, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[26] t=1781716993.52
  {"Bricks", CFrame.new(160, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[27] t=1781716993.82
  {"Bricks", CFrame.new(164, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[28] t=1781716994.12
  {"Bricks", CFrame.new(168, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[29] t=1781716994.95
  {"Bricks", CFrame.new(172, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[30] t=1781716995.62
  {"Bricks", CFrame.new(172, 2, 180, 0, 0, 1, 0), workspace.Baseplate},
  --[31] t=1781716995.88
  {"Bricks", CFrame.new(172, 2, 184, 0, 0, 1, 0), workspace.Baseplate},
  --[32] t=1781716996.22
  {"Bricks", CFrame.new(172, 2, 188, 0, 0, 1, 0), workspace.Baseplate},
  --[33] t=1781716996.83
  {"Bricks", CFrame.new(152, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[34] t=1781716997.06
  {"Bricks", CFrame.new(152, 2, 180, 0, 0, 1, 0), workspace.Baseplate},
  --[35] t=1781716997.31
  {"Bricks", CFrame.new(152, 2, 184, 0, 0, 1, 0), workspace.Baseplate},
  --[36] t=1781716997.67
  {"Bricks", CFrame.new(152, 2, 188, 0, 0, 1, 0), workspace.Baseplate},
  --[37] t=1781716998.40
  {"Bricks", CFrame.new(156, 2, 192, 0, 0, 1, 0), workspace.Baseplate},
  --[38] t=1781716998.67
  {"Bricks", CFrame.new(160, 2, 192, 0, 0, 1, 0), workspace.Baseplate},
  --[39] t=1781716999.03
  {"Bricks", CFrame.new(164, 2, 192, 0, 0, 1, 0), workspace.Baseplate},
  --[40] t=1781716999.39
  {"Bricks", CFrame.new(168, 2, 192, 0, 0, 1, 0), workspace.Baseplate},
  --[41] t=1781717001.44
  {"Bricks", CFrame.new(176, 2, 172, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[42] t=1781717001.87
  {"Bricks", CFrame.new(180, 2, 172, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[43] t=1781717002.21
  {"Bricks", CFrame.new(184, 2, 172, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[44] t=1781717002.59
  {"Bricks", CFrame.new(188, 2, 172, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[45] t=1781717003.66
  {"Bricks", CFrame.new(176, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[46] t=1781717003.90
  {"Bricks", CFrame.new(180, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[47] t=1781717004.20
  {"Bricks", CFrame.new(184, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[48] t=1781717004.58
  {"Bricks", CFrame.new(188, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[49] t=1781717005.54
  {"Bricks", CFrame.new(176, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[50] t=1781717005.76
  {"Bricks", CFrame.new(180, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[51] t=1781717005.99
  {"Bricks", CFrame.new(184, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[52] t=1781717006.46
  {"Bricks", CFrame.new(188, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[53] t=1781717009.11
  {"Bricks", CFrame.new(176, 2, 192, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[54] t=1781717009.35
  {"Bricks", CFrame.new(180, 2, 192, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[55] t=1781717009.60
  {"Bricks", CFrame.new(184, 2, 192, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[56] t=1781717009.96
  {"Bricks", CFrame.new(188, 2, 192, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[57] t=1781717010.73
  {"Bricks", CFrame.new(192, 2, 188, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[58] t=1781717011.02
  {"Bricks", CFrame.new(192, 2, 184, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[59] t=1781717011.37
  {"Bricks", CFrame.new(192, 2, 180, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[60] t=1781717011.70
  {"Bricks", CFrame.new(192, 2, 176, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[61] t=1781717012.41
  {"Bricks", CFrame.new(192, 2, 168, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[62] t=1781717012.69
  {"Bricks", CFrame.new(192, 2, 164, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[63] t=1781717013.41
  {"Bricks", CFrame.new(192, 2, 160, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[64] t=1781717013.73
  {"Bricks", CFrame.new(192, 2, 156, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[65] t=1781717014.52
  {"Bricks", CFrame.new(192, 2, 148, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[66] t=1781717014.74
  {"Bricks", CFrame.new(192, 2, 144, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[67] t=1781717015.09
  {"Bricks", CFrame.new(192, 2, 140, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[68] t=1781717015.42
  {"Bricks", CFrame.new(192, 2, 136, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[69] t=1781717017.07
  {"Bricks", CFrame.new(196, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[70] t=1781717017.32
  {"Bricks", CFrame.new(200, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[71] t=1781717017.61
  {"Bricks", CFrame.new(204, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[72] t=1781717018.00
  {"Bricks", CFrame.new(208, 2, 152, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[73] t=1781717018.85
  {"Bricks", CFrame.new(196, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[74] t=1781717019.08
  {"Bricks", CFrame.new(200, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[75] t=1781717019.29
  {"Bricks", CFrame.new(204, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[76] t=1781717019.55
  {"Bricks", CFrame.new(208, 2, 132, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[77] t=1781717020.69
  {"Bricks", CFrame.new(196, 2, 172, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[78] t=1781717020.89
  {"Bricks", CFrame.new(200, 2, 172, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[79] t=1781717021.10
  {"Bricks", CFrame.new(204, 2, 172, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[80] t=1781717021.32
  {"Bricks", CFrame.new(208, 2, 172, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[81] t=1781717022.36
  {"Bricks", CFrame.new(196, 2, 192, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[82] t=1781717022.57
  {"Bricks", CFrame.new(204, 2, 192, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[83] t=1781717022.80
  {"Bricks", CFrame.new(208, 2, 192, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[84] t=1781717023.63
  {"Bricks", CFrame.new(200, 2, 192, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[85] t=1781717024.57
  {"Bricks", CFrame.new(212, 2, 188, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[86] t=1781717024.82
  {"Bricks", CFrame.new(212, 2, 184, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[87] t=1781717025.12
  {"Bricks", CFrame.new(212, 2, 180, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[88] t=1781717025.45
  {"Bricks", CFrame.new(216, 2, 180, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[89] t=1781717026.05
  {"Bricks", CFrame.new(212, 2, 176, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[90] t=1781717026.83
  {"Bricks", CFrame.new(212, 2, 168, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[91] t=1781717027.46
  {"Bricks", CFrame.new(212, 2, 164, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[92] t=1781717027.95
  {"Bricks", CFrame.new(212, 2, 160, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[93] t=1781717028.51
  {"Bricks", CFrame.new(212, 2, 156, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[94] t=1781717029.11
  {"Bricks", CFrame.new(212, 2, 148, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[95] t=1781717029.81
  {"Bricks", CFrame.new(212, 2, 144, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[96] t=1781717030.12
  {"Bricks", CFrame.new(212, 2, 140, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[97] t=1781717030.51
  {"Bricks", CFrame.new(212, 2, 136, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[98] t=1781717037.22
  {"Bricks", CFrame.new(216, 2, 184, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[99] t=1781717037.57
  {"Bricks", CFrame.new(216, 2, 188, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[100] t=1781717039.10
  {"Bricks", CFrame.new(216, 2, 176, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[101] t=1781717040.08
  {"Bricks", CFrame.new(196, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[102] t=1781717040.34
  {"Bricks", CFrame.new(200, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[103] t=1781717040.66
  {"Bricks", CFrame.new(204, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[104] t=1781717041.18
  {"Bricks", CFrame.new(208, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[105] t=1781717042.15
  {"Bricks", CFrame.new(176, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[106] t=1781717042.41
  {"Bricks", CFrame.new(180, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[107] t=1781717042.71
  {"Bricks", CFrame.new(184, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[108] t=1781717043.08
  {"Bricks", CFrame.new(188, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[109] t=1781717044.04
  {"Bricks", CFrame.new(156, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[110] t=1781717044.29
  {"Bricks", CFrame.new(160, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[111] t=1781717044.57
  {"Bricks", CFrame.new(164, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[112] t=1781717044.92
  {"Bricks", CFrame.new(168, 2, 196, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[113] t=1781717046.59
  {"Bricks", CFrame.new(148, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[114] t=1781717046.87
  {"Bricks", CFrame.new(148, 2, 180, 0, 0, 1, 0), workspace.Baseplate},
  --[115] t=1781717047.31
  {"Bricks", CFrame.new(148, 2, 184, 0, 0, 1, 0), workspace.Baseplate},
  --[116] t=1781717047.68
  {"Bricks", CFrame.new(148, 2, 188, 0, 0, 1, 0), workspace.Baseplate},
  --[117] t=1781717048.68
  {"Bricks", CFrame.new(148, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[118] t=1781717048.99
  {"Bricks", CFrame.new(148, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[119] t=1781717049.25
  {"Bricks", CFrame.new(148, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[120] t=1781717049.64
  {"Bricks", CFrame.new(148, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[121] t=1781717050.48
  {"Bricks", CFrame.new(148, 2, 136, 0, 0, 1, 0), workspace.Baseplate},
  --[122] t=1781717050.72
  {"Bricks", CFrame.new(148, 2, 140, 0, 0, 1, 0), workspace.Baseplate},
  --[123] t=1781717051.00
  {"Bricks", CFrame.new(148, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[124] t=1781717051.34
  {"Bricks", CFrame.new(148, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[125] t=1781717053.31
  {"Bricks", CFrame.new(168, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[126] t=1781717053.56
  {"Bricks", CFrame.new(164, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[127] t=1781717053.81
  {"Bricks", CFrame.new(160, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[128] t=1781717054.17
  {"Bricks", CFrame.new(156, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[129] t=1781717054.94
  {"Bricks", CFrame.new(188, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[130] t=1781717055.19
  {"Bricks", CFrame.new(184, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[131] t=1781717055.49
  {"Bricks", CFrame.new(180, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[132] t=1781717055.78
  {"Bricks", CFrame.new(176, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[133] t=1781717056.65
  {"Bricks", CFrame.new(208, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[134] t=1781717056.86
  {"Bricks", CFrame.new(204, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[135] t=1781717057.10
  {"Bricks", CFrame.new(200, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[136] t=1781717057.43
  {"Bricks", CFrame.new(196, 2, 128, 1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[137] t=1781717060.30
  {"Bricks", CFrame.new(216, 2, 148, -8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[138] t=1781717061.68
  {"Bricks", CFrame.new(216, 2, 144, -8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[139] t=1781717062.02
  {"Bricks", CFrame.new(216, 2, 140, -8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[140] t=1781717062.58
  {"Bricks", CFrame.new(216, 2, 136, -8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[141] t=1781717067.13
  {"Bricks", CFrame.new(216, 2, 168, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[142] t=1781717067.46
  {"Bricks", CFrame.new(216, 2, 164, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[143] t=1781717067.75
  {"Bricks", CFrame.new(216, 2, 160, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[144] t=1781717068.23
  {"Bricks", CFrame.new(216, 2, 156, 8.742277657347586e-08, 0, -1, 0), workspace.Baseplate},
  --[145] t=1781717076.37
  {"Magenta Wool", CFrame.new(196, 2, 148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[146] t=1781717076.79
  {"Magenta Wool", CFrame.new(196, 2, 144, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[147] t=1781717077.19
  {"Magenta Wool", CFrame.new(196, 2, 140, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[148] t=1781717077.56
  {"Magenta Wool", CFrame.new(196, 2, 136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[149] t=1781717077.89
  {"Magenta Wool", CFrame.new(200, 2, 136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[150] t=1781717078.23
  {"Magenta Wool", CFrame.new(204, 2, 136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[151] t=1781717078.61
  {"Magenta Wool", CFrame.new(208, 2, 136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[152] t=1781717079.03
  {"Magenta Wool", CFrame.new(208, 2, 140, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[153] t=1781717079.29
  {"Magenta Wool", CFrame.new(208, 2, 144, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[154] t=1781717079.64
  {"Magenta Wool", CFrame.new(208, 2, 148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[155] t=1781717080.41
  {"Magenta Wool", CFrame.new(200, 2, 148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[156] t=1781717080.83
  {"Magenta Wool", CFrame.new(204, 2, 148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[157] t=1781717082.24
  {"Magenta Wool", CFrame.new(196, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[158] t=1781717082.53
  {"Magenta Wool", CFrame.new(196, 2, 164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[159] t=1781717082.82
  {"Magenta Wool", CFrame.new(196, 2, 160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[160] t=1781717083.11
  {"Magenta Wool", CFrame.new(196, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[161] t=1781717083.91
  {"Magenta Wool", CFrame.new(200, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[162] t=1781717084.32
  {"Magenta Wool", CFrame.new(204, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[163] t=1781717084.60
  {"Magenta Wool", CFrame.new(208, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[164] t=1781717085.07
  {"Magenta Wool", CFrame.new(208, 2, 164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[165] t=1781717085.42
  {"Magenta Wool", CFrame.new(208, 2, 160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[166] t=1781717085.68
  {"Magenta Wool", CFrame.new(208, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[167] t=1781717086.20
  {"Magenta Wool", CFrame.new(200, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[168] t=1781717086.45
  {"Magenta Wool", CFrame.new(204, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[169] t=1781717088.27
  {"Magenta Wool", CFrame.new(196, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[170] t=1781717088.48
  {"Magenta Wool", CFrame.new(196, 2, 184, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[171] t=1781717088.72
  {"Magenta Wool", CFrame.new(196, 2, 180, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[172] t=1781717089.01
  {"Magenta Wool", CFrame.new(196, 2, 176, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[173] t=1781717089.70
  {"Magenta Wool", CFrame.new(208, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[174] t=1781717089.95
  {"Magenta Wool", CFrame.new(204, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[175] t=1781717090.30
  {"Magenta Wool", CFrame.new(200, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[176] t=1781717090.76
  {"Magenta Wool", CFrame.new(208, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[177] t=1781717090.98
  {"Magenta Wool", CFrame.new(208, 2, 184, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[178] t=1781717091.24
  {"Magenta Wool", CFrame.new(208, 2, 180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[179] t=1781717091.75
  {"Magenta Wool", CFrame.new(204, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[180] t=1781717091.97
  {"Magenta Wool", CFrame.new(200, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[181] t=1781717092.69
  {"Magenta Wool", CFrame.new(184, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[182] t=1781717093.07
  {"Magenta Wool", CFrame.new(188, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[183] t=1781717093.48
  {"Magenta Wool", CFrame.new(176, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[184] t=1781717093.67
  {"Magenta Wool", CFrame.new(180, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[185] t=1781717094.13
  {"Magenta Wool", CFrame.new(176, 2, 184, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[186] t=1781717094.40
  {"Magenta Wool", CFrame.new(176, 2, 180, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[187] t=1781717094.70
  {"Magenta Wool", CFrame.new(176, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[188] t=1781717095.37
  {"Magenta Wool", CFrame.new(188, 2, 184, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[189] t=1781717095.79
  {"Magenta Wool", CFrame.new(188, 2, 180, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[190] t=1781717096.06
  {"Magenta Wool", CFrame.new(188, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[191] t=1781717096.53
  {"Magenta Wool", CFrame.new(184, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[192] t=1781717096.79
  {"Magenta Wool", CFrame.new(180, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[193] t=1781717097.70
  {"Magenta Wool", CFrame.new(168, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[194] t=1781717097.95
  {"Magenta Wool", CFrame.new(168, 2, 184, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[195] t=1781717098.18
  {"Magenta Wool", CFrame.new(168, 2, 180, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[196] t=1781717098.52
  {"Magenta Wool", CFrame.new(168, 2, 176, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[197] t=1781717098.91
  {"Magenta Wool", CFrame.new(164, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[198] t=1781717099.20
  {"Magenta Wool", CFrame.new(160, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[199] t=1781717099.50
  {"Magenta Wool", CFrame.new(156, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[200] t=1781717100.01
  {"Magenta Wool", CFrame.new(156, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[201] t=1781717100.23
  {"Magenta Wool", CFrame.new(156, 2, 184, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[202] t=1781717100.51
  {"Magenta Wool", CFrame.new(156, 2, 180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[203] t=1781717101.11
  {"Magenta Wool", CFrame.new(160, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[204] t=1781717101.35
  {"Magenta Wool", CFrame.new(164, 2, 188, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[205] t=1781717102.66
  {"Magenta Wool", CFrame.new(156, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[206] t=1781717102.88
  {"Magenta Wool", CFrame.new(160, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[207] t=1781717103.16
  {"Magenta Wool", CFrame.new(164, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[208] t=1781717103.45
  {"Magenta Wool", CFrame.new(168, 2, 168, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[209] t=1781717104.38
  {"Magenta Wool", CFrame.new(156, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[210] t=1781717104.62
  {"Magenta Wool", CFrame.new(156, 2, 160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[211] t=1781717104.87
  {"Magenta Wool", CFrame.new(156, 2, 164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[212] t=1781717105.32
  {"Magenta Wool", CFrame.new(160, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[213] t=1781717105.55
  {"Magenta Wool", CFrame.new(164, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[214] t=1781717105.80
  {"Magenta Wool", CFrame.new(168, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[215] t=1781717106.25
  {"Magenta Wool", CFrame.new(168, 2, 160, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[216] t=1781717106.57
  {"Magenta Wool", CFrame.new(168, 2, 164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[217] t=1781717107.81
  {"Magenta Wool", CFrame.new(176, 2, 156, 1, 0, 0, 0), workspace.Baseplate},
  --[218] t=1781717108.08
  {"Magenta Wool", CFrame.new(176, 2, 160, 1, 0, 0, 0), workspace.Baseplate},
  --[219] t=1781717108.34
  {"Magenta Wool", CFrame.new(176, 2, 164, 1, 0, 0, 0), workspace.Baseplate},
  --[220] t=1781717108.68
  {"Magenta Wool", CFrame.new(176, 2, 168, 1, 0, 0, 0), workspace.Baseplate},
  --[221] t=1781717109.71
  {"Magenta Wool", CFrame.new(188, 2, 156, 1, 0, 0, 0), workspace.Baseplate},
  --[222] t=1781717109.92
  {"Magenta Wool", CFrame.new(184, 2, 156, 1, 0, 0, 0), workspace.Baseplate},
  --[223] t=1781717110.19
  {"Magenta Wool", CFrame.new(180, 2, 156, 1, 0, 0, 0), workspace.Baseplate},
  --[224] t=1781717110.78
  {"Magenta Wool", CFrame.new(188, 2, 160, 1, 0, 0, 0), workspace.Baseplate},
  --[225] t=1781717111.10
  {"Magenta Wool", CFrame.new(188, 2, 164, 1, 0, 0, 0), workspace.Baseplate},
  --[226] t=1781717111.47
  {"Magenta Wool", CFrame.new(188, 2, 168, 1, 0, 0, 0), workspace.Baseplate},
  --[227] t=1781717111.84
  {"Magenta Wool", CFrame.new(184, 2, 168, 1, 0, 0, 0), workspace.Baseplate},
  --[228] t=1781717112.13
  {"Magenta Wool", CFrame.new(180, 2, 168, 1, 0, 0, 0), workspace.Baseplate},
  --[229] t=1781717113.13
  {"Magenta Wool", CFrame.new(176, 2, 136, 1, 0, 0, 0), workspace.Baseplate},
  --[230] t=1781717113.35
  {"Magenta Wool", CFrame.new(176, 2, 140, 1, 0, 0, 0), workspace.Baseplate},
  --[231] t=1781717113.58
  {"Magenta Wool", CFrame.new(176, 2, 144, 1, 0, 0, 0), workspace.Baseplate},
  --[232] t=1781717113.93
  {"Magenta Wool", CFrame.new(176, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[233] t=1781717114.51
  {"Magenta Wool", CFrame.new(188, 2, 136, 1, 0, 0, 0), workspace.Baseplate},
  --[234] t=1781717114.71
  {"Magenta Wool", CFrame.new(188, 2, 140, 1, 0, 0, 0), workspace.Baseplate},
  --[235] t=1781717114.97
  {"Magenta Wool", CFrame.new(188, 2, 144, 1, 0, 0, 0), workspace.Baseplate},
  --[236] t=1781717115.26
  {"Magenta Wool", CFrame.new(188, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[237] t=1781717115.73
  {"Magenta Wool", CFrame.new(184, 2, 136, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[238] t=1781717115.94
  {"Magenta Wool", CFrame.new(180, 2, 136, 1, 0, 0, 0), workspace.Baseplate},
  --[239] t=1781717116.52
  {"Magenta Wool", CFrame.new(184, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[240] t=1781717116.79
  {"Magenta Wool", CFrame.new(180, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[241] t=1781717117.70
  {"Magenta Wool", CFrame.new(168, 2, 136, 1, 0, 0, 0), workspace.Baseplate},
  --[242] t=1781717117.91
  {"Magenta Wool", CFrame.new(168, 2, 140, 1, 0, 0, 0), workspace.Baseplate},
  --[243] t=1781717118.14
  {"Magenta Wool", CFrame.new(168, 2, 144, 1, 0, 0, 0), workspace.Baseplate},
  --[244] t=1781717118.40
  {"Magenta Wool", CFrame.new(168, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[245] t=1781717119.04
  {"Magenta Wool", CFrame.new(156, 2, 136, 1, 0, 0, 0), workspace.Baseplate},
  --[246] t=1781717119.28
  {"Magenta Wool", CFrame.new(156, 2, 144, 1, 0, 0, 0), workspace.Baseplate},
  --[247] t=1781717119.80
  {"Magenta Wool", CFrame.new(156, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[248] t=1781717120.20
  {"Magenta Wool", CFrame.new(156, 2, 140, 1, 0, 0, 0), workspace.Baseplate},
  --[249] t=1781717120.48
  {"Magenta Wool", CFrame.new(160, 2, 136, 1, 0, 0, 0), workspace.Baseplate},
  --[250] t=1781717120.73
  {"Magenta Wool", CFrame.new(164, 2, 136, 1, 0, 0, 0), workspace.Baseplate},
  --[251] t=1781717121.42
  {"Magenta Wool", CFrame.new(160, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[252] t=1781717121.80
  {"Magenta Wool", CFrame.new(164, 2, 148, 1, 0, 0, 0), workspace.Baseplate},
  --[253] t=1781717126.05
  {"Yellow Wool", CFrame.new(164, 2, 160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[254] t=1781717126.22
  {"Yellow Wool", CFrame.new(160, 2, 160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[255] t=1781717126.86
  {"Yellow Wool", CFrame.new(164, 2, 164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[256] t=1781717127.08
  {"Yellow Wool", CFrame.new(160, 2, 164, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[257] t=1781717127.90
  {"Yellow Wool", CFrame.new(164, 2, 180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[258] t=1781717128.11
  {"Yellow Wool", CFrame.new(160, 2, 180, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[259] t=1781717128.45
  {"Yellow Wool", CFrame.new(164, 2, 184, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[260] t=1781717128.65
  {"Yellow Wool", CFrame.new(160, 2, 184, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[261] t=1781717129.48
  {"Yellow Wool", CFrame.new(184, 2, 180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[262] t=1781717129.68
  {"Yellow Wool", CFrame.new(180, 2, 180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[263] t=1781717129.97
  {"Yellow Wool", CFrame.new(184, 2, 184, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[264] t=1781717130.11
  {"Yellow Wool", CFrame.new(180, 2, 184, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[265] t=1781717131.05
  {"Yellow Wool", CFrame.new(204, 2, 180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[266] t=1781717131.24
  {"Yellow Wool", CFrame.new(200, 2, 180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[267] t=1781717131.51
  {"Yellow Wool", CFrame.new(204, 2, 184, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[268] t=1781717131.72
  {"Yellow Wool", CFrame.new(200, 2, 184, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[269] t=1781717132.50
  {"Yellow Wool", CFrame.new(204, 2, 164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[270] t=1781717132.70
  {"Yellow Wool", CFrame.new(200, 2, 164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[271] t=1781717133.16
  {"Yellow Wool", CFrame.new(204, 2, 160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[272] t=1781717133.35
  {"Yellow Wool", CFrame.new(200, 2, 160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[273] t=1781717134.24
  {"Yellow Wool", CFrame.new(204, 2, 144, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[274] t=1781717134.43
  {"Yellow Wool", CFrame.new(200, 2, 144, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[275] t=1781717134.78
  {"Yellow Wool", CFrame.new(204, 2, 140, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[276] t=1781717134.96
  {"Yellow Wool", CFrame.new(200, 2, 140, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[277] t=1781717135.97
  {"Yellow Wool", CFrame.new(184, 2, 140, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[278] t=1781717136.16
  {"Yellow Wool", CFrame.new(180, 2, 140, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[279] t=1781717136.44
  {"Yellow Wool", CFrame.new(184, 2, 144, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[280] t=1781717136.64
  {"Yellow Wool", CFrame.new(180, 2, 144, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[281] t=1781717137.20
  {"Yellow Wool", CFrame.new(184, 2, 160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[282] t=1781717137.41
  {"Yellow Wool", CFrame.new(180, 2, 160, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[283] t=1781717137.79
  {"Yellow Wool", CFrame.new(184, 2, 164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[284] t=1781717138.03
  {"Yellow Wool", CFrame.new(180, 2, 164, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[285] t=1781717138.86
  {"Yellow Wool", CFrame.new(164, 2, 140, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[286] t=1781717139.06
  {"Yellow Wool", CFrame.new(160, 2, 140, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[287] t=1781717139.29
  {"Yellow Wool", CFrame.new(164, 2, 144, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[288] t=1781717139.50
  {"Yellow Wool", CFrame.new(160, 2, 144, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[289] t=1781717147.80
  {"Cyan Wool", CFrame.new(152, 2, 152, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[290] t=1781717148.08
  {"Cyan Wool", CFrame.new(148, 2, 152, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[291] t=1781717149.43
  {"Cyan Wool", CFrame.new(172, 2, 152, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[292] t=1781717150.35
  {"Cyan Wool", CFrame.new(192, 2, 152, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[293] t=1781717151.20
  {"Cyan Wool", CFrame.new(216, 2, 152, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[294] t=1781717151.52
  {"Cyan Wool", CFrame.new(212, 2, 152, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[295] t=1781717152.38
  {"Cyan Wool", CFrame.new(216, 2, 172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[296] t=1781717152.63
  {"Cyan Wool", CFrame.new(212, 2, 172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[297] t=1781717153.46
  {"Cyan Wool", CFrame.new(192, 2, 172, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[298] t=1781717154.27
  {"Cyan Wool", CFrame.new(172, 2, 172, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[299] t=1781717155.36
  {"Cyan Wool", CFrame.new(152, 2, 172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[300] t=1781717155.61
  {"Cyan Wool", CFrame.new(148, 2, 172, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[301] t=1781717156.94
  {"Cyan Wool", CFrame.new(152, 2, 192, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[302] t=1781717157.23
  {"Cyan Wool", CFrame.new(148, 2, 192, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[303] t=1781717157.77
  {"Cyan Wool", CFrame.new(152, 2, 196, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[304] t=1781717158.76
  {"Cyan Wool", CFrame.new(172, 2, 192, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[305] t=1781717159.31
  {"Cyan Wool", CFrame.new(172, 2, 196, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[306] t=1781717160.15
  {"Cyan Wool", CFrame.new(192, 2, 196, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[307] t=1781717160.36
  {"Cyan Wool", CFrame.new(192, 2, 192, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[308] t=1781717161.49
  {"Cyan Wool", CFrame.new(216, 2, 192, 1, 0, 0, 0), workspace.Baseplate},
  --[309] t=1781717161.72
  {"Cyan Wool", CFrame.new(212, 2, 192, 1, 0, 0, 0), workspace.Baseplate},
  --[310] t=1781717162.15
  {"Cyan Wool", CFrame.new(212, 2, 196, 1, 0, 0, 0), workspace.Baseplate},
  --[311] t=1781717164.30
  {"Cyan Wool", CFrame.new(212, 2, 128, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[312] t=1781717164.49
  {"Cyan Wool", CFrame.new(212, 2, 132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[313] t=1781717164.81
  {"Cyan Wool", CFrame.new(216, 2, 132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[314] t=1781717165.65
  {"Cyan Wool", CFrame.new(192, 2, 128, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[315] t=1781717165.85
  {"Cyan Wool", CFrame.new(192, 2, 132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[316] t=1781717166.61
  {"Cyan Wool", CFrame.new(172, 2, 128, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[317] t=1781717166.81
  {"Cyan Wool", CFrame.new(172, 2, 132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[318] t=1781717168.64
  {"Cyan Wool", CFrame.new(148, 2, 132, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[319] t=1781717168.87
  {"Cyan Wool", CFrame.new(152, 2, 132, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[320] t=1781717169.11
  {"Cyan Wool", CFrame.new(152, 2, 128, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[321] t=1781717175.00
  {"Blue Wool", CFrame.new(148, 2, 128, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[322] t=1781717177.81
  {"Blue Wool", CFrame.new(216, 2, 128, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[323] t=1781717179.23
  {"Blue Wool", CFrame.new(216, 2, 196, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[324] t=1781717181.03
  {"Blue Wool", CFrame.new(148, 2, 196, 1, 0, 0, 0), workspace.Baseplate},
  --[325] t=1781717184.40
  {"Blue Wool", CFrame.new(144, 2, 200, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[326] t=1781717184.65
  {"Blue Wool", CFrame.new(144, 2, 196, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[327] t=1781717184.93
  {"Blue Wool", CFrame.new(144, 2, 192, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[328] t=1781717185.18
  {"Blue Wool", CFrame.new(144, 2, 184, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[329] t=1781717186.41
  {"Blue Wool", CFrame.new(144, 2, 188, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[330] t=1781717186.88
  {"Blue Wool", CFrame.new(144, 2, 180, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[331] t=1781717187.16
  {"Blue Wool", CFrame.new(144, 2, 176, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[332] t=1781717187.47
  {"Blue Wool", CFrame.new(144, 2, 172, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[333] t=1781717187.79
  {"Blue Wool", CFrame.new(144, 2, 168, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[334] t=1781717188.12
  {"Blue Wool", CFrame.new(144, 2, 164, -1, 0, 8.742277657347586e-08, 0), workspace.Baseplate},
  --[335] t=1781717188.98
  {"Blue Wool", CFrame.new(144, 2, 160, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[336] t=1781717189.21
  {"Blue Wool", CFrame.new(144, 2, 152, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[337] t=1781717189.42
  {"Blue Wool", CFrame.new(144, 2, 148, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[338] t=1781717189.74
  {"Blue Wool", CFrame.new(144, 2, 144, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[339] t=1781717190.65
  {"Blue Wool", CFrame.new(144, 2, 156, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[340] t=1781717191.44
  {"Blue Wool", CFrame.new(144, 2, 140, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[341] t=1781717191.69
  {"Blue Wool", CFrame.new(144, 2, 136, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[342] t=1781717191.98
  {"Blue Wool", CFrame.new(144, 2, 132, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[343] t=1781717192.28
  {"Blue Wool", CFrame.new(144, 2, 128, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[344] t=1781717192.62
  {"Blue Wool", CFrame.new(144, 2, 124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[345] t=1781717194.02
  {"Blue Wool", CFrame.new(148, 2, 124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[346] t=1781717194.27
  {"Blue Wool", CFrame.new(156, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[347] t=1781717194.52
  {"Blue Wool", CFrame.new(160, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[348] t=1781717194.88
  {"Blue Wool", CFrame.new(164, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[349] t=1781717195.72
  {"Blue Wool", CFrame.new(152, 2, 124, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[350] t=1781717196.38
  {"Blue Wool", CFrame.new(168, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[351] t=1781717196.60
  {"Blue Wool", CFrame.new(172, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[352] t=1781717196.82
  {"Blue Wool", CFrame.new(176, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[353] t=1781717197.03
  {"Blue Wool", CFrame.new(180, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[354] t=1781717197.27
  {"Blue Wool", CFrame.new(184, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[355] t=1781717197.90
  {"Blue Wool", CFrame.new(192, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[356] t=1781717198.39
  {"Blue Wool", CFrame.new(196, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[357] t=1781717198.59
  {"Blue Wool", CFrame.new(200, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[358] t=1781717199.35
  {"Blue Wool", CFrame.new(188, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[359] t=1781717200.21
  {"Blue Wool", CFrame.new(204, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[360] t=1781717200.45
  {"Blue Wool", CFrame.new(208, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[361] t=1781717200.68
  {"Blue Wool", CFrame.new(212, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[362] t=1781717200.88
  {"Blue Wool", CFrame.new(216, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[363] t=1781717201.16
  {"Blue Wool", CFrame.new(220, 2, 124, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[364] t=1781717202.10
  {"Blue Wool", CFrame.new(220, 2, 128, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[365] t=1781717204.15
  {"Blue Wool", CFrame.new(220, 2, 132, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[366] t=1781717204.37
  {"Blue Wool", CFrame.new(220, 2, 136, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[367] t=1781717204.55
  {"Blue Wool", CFrame.new(220, 2, 140, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[368] t=1781717204.76
  {"Blue Wool", CFrame.new(220, 2, 144, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[369] t=1781717204.97
  {"Blue Wool", CFrame.new(220, 2, 148, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[370] t=1781717205.17
  {"Blue Wool", CFrame.new(220, 2, 152, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[371] t=1781717206.73
  {"Blue Wool", CFrame.new(220, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[372] t=1781717206.93
  {"Blue Wool", CFrame.new(220, 2, 160, 1, 0, 0, 0), workspace.Baseplate},
  --[373] t=1781717207.14
  {"Blue Wool", CFrame.new(220, 2, 164, 1, 0, 0, 0), workspace.Baseplate},
  --[374] t=1781717207.33
  {"Blue Wool", CFrame.new(220, 2, 168, 1, 0, 0, 0), workspace.Baseplate},
  --[375] t=1781717207.52
  {"Blue Wool", CFrame.new(220, 2, 172, 1, 0, 0, 0), workspace.Baseplate},
  --[376] t=1781717210.91
  {"Blue Wool", CFrame.new(220, 2, 156, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[377] t=1781717211.71
  {"Blue Wool", CFrame.new(220, 2, 176, 1, 0, 0, 0), workspace.Baseplate},
  --[378] t=1781717211.92
  {"Blue Wool", CFrame.new(220, 2, 180, 1, 0, 0, 0), workspace.Baseplate},
  --[379] t=1781717212.11
  {"Blue Wool", CFrame.new(220, 2, 184, 1, 0, 0, 0), workspace.Baseplate},
  --[380] t=1781717212.35
  {"Blue Wool", CFrame.new(220, 2, 188, 1, 0, 0, 0), workspace.Baseplate},
  --[381] t=1781717212.59
  {"Blue Wool", CFrame.new(220, 2, 192, 1, 0, 0, 0), workspace.Baseplate},
  --[382] t=1781717212.86
  {"Blue Wool", CFrame.new(220, 2, 196, 1, 0, 0, 0), workspace.Baseplate},
  --[383] t=1781717213.23
  {"Blue Wool", CFrame.new(220, 2, 200, 1, 0, 0, 0), workspace.Baseplate},
  --[384] t=1781717214.58
  {"Blue Wool", CFrame.new(216, 2, 200, 1, 0, 0, 0), workspace.Baseplate},
  --[385] t=1781717214.79
  {"Blue Wool", CFrame.new(212, 2, 200, 1, 0, 0, 0), workspace.Baseplate},
  --[386] t=1781717215.00
  {"Blue Wool", CFrame.new(208, 2, 200, 1, 0, 0, 0), workspace.Baseplate},
  --[387] t=1781717215.21
  {"Blue Wool", CFrame.new(204, 2, 200, 1, 0, 0, 0), workspace.Baseplate},
  --[388] t=1781717215.40
  {"Blue Wool", CFrame.new(200, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[389] t=1781717215.61
  {"Blue Wool", CFrame.new(196, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[390] t=1781717215.80
  {"Blue Wool", CFrame.new(192, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[391] t=1781717216.06
  {"Blue Wool", CFrame.new(188, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[392] t=1781717216.31
  {"Blue Wool", CFrame.new(184, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[393] t=1781717216.51
  {"Blue Wool", CFrame.new(180, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[394] t=1781717216.75
  {"Blue Wool", CFrame.new(176, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[395] t=1781717216.96
  {"Blue Wool", CFrame.new(168, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[396] t=1781717219.75
  {"Blue Wool", CFrame.new(172, 2, 200, 1, 0, 0, 0), workspace.Baseplate},
  --[397] t=1781717220.49
  {"Blue Wool", CFrame.new(148, 2, 200, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[398] t=1781717220.73
  {"Blue Wool", CFrame.new(152, 2, 200, -4.371138828673793e-08, 0, -1, 0), workspace.Baseplate},
  --[399] t=1781717221.18
  {"Blue Wool", CFrame.new(156, 2, 200, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[400] t=1781717221.58
  {"Blue Wool", CFrame.new(160, 2, 200, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
  --[401] t=1781717221.98
  {"Blue Wool", CFrame.new(164, 2, 200, -1, 0, -8.742277657347586e-08, 0), workspace.Baseplate},
}
local claudeshouse = {
  --[1] t=1781824750.76
  {"Oak Planks", CFrame.new(580, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[2] t=1781824752.16
  {"Oak Planks", CFrame.new(580, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[3] t=1781824753.56
  {"Oak Planks", CFrame.new(580, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[4] t=1781824754.96
  {"Oak Planks", CFrame.new(580, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[5] t=1781824756.36
  {"Oak Planks", CFrame.new(580, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[6] t=1781824757.76
  {"Oak Planks", CFrame.new(580, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[7] t=1781824759.16
  {"Oak Planks", CFrame.new(580, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[8] t=1781824760.56
  {"Oak Planks", CFrame.new(580, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[9] t=1781824761.96
  {"Oak Planks", CFrame.new(580, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[10] t=1781824763.36
  {"Oak Planks", CFrame.new(584, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[11] t=1781824764.76
  {"Oak Planks", CFrame.new(584, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[12] t=1781824766.16
  {"Oak Planks", CFrame.new(584, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[13] t=1781824767.56
  {"Oak Planks", CFrame.new(584, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[14] t=1781824768.96
  {"Oak Planks", CFrame.new(584, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[15] t=1781824770.36
  {"Oak Planks", CFrame.new(584, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[16] t=1781824771.76
  {"Oak Planks", CFrame.new(584, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[17] t=1781824773.16
  {"Oak Planks", CFrame.new(584, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[18] t=1781824774.56
  {"Oak Planks", CFrame.new(584, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[19] t=1781824775.96
  {"Oak Planks", CFrame.new(588, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[20] t=1781824777.36
  {"Oak Planks", CFrame.new(588, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[21] t=1781824778.76
  {"Oak Planks", CFrame.new(588, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[22] t=1781824780.16
  {"Oak Planks", CFrame.new(588, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[23] t=1781824781.56
  {"Oak Planks", CFrame.new(588, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[24] t=1781824782.96
  {"Oak Planks", CFrame.new(588, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[25] t=1781824784.36
  {"Oak Planks", CFrame.new(588, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[26] t=1781824785.76
  {"Oak Planks", CFrame.new(588, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[27] t=1781824787.16
  {"Oak Planks", CFrame.new(588, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[28] t=1781824788.56
  {"Oak Planks", CFrame.new(592, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[29] t=1781824789.96
  {"Oak Planks", CFrame.new(592, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[30] t=1781824791.36
  {"Oak Planks", CFrame.new(592, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[31] t=1781824792.76
  {"Oak Planks", CFrame.new(592, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[32] t=1781824794.16
  {"Oak Planks", CFrame.new(592, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[33] t=1781824795.56
  {"Oak Planks", CFrame.new(592, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[34] t=1781824796.96
  {"Oak Planks", CFrame.new(592, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[35] t=1781824798.36
  {"Oak Planks", CFrame.new(592, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[36] t=1781824799.76
  {"Oak Planks", CFrame.new(592, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[37] t=1781824801.16
  {"Oak Planks", CFrame.new(596, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[38] t=1781824802.56
  {"Oak Planks", CFrame.new(596, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[39] t=1781824803.96
  {"Oak Planks", CFrame.new(596, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[40] t=1781824805.36
  {"Oak Planks", CFrame.new(596, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[41] t=1781824806.76
  {"Oak Planks", CFrame.new(596, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[42] t=1781824808.16
  {"Oak Planks", CFrame.new(596, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[43] t=1781824809.56
  {"Oak Planks", CFrame.new(596, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[44] t=1781824810.96
  {"Oak Planks", CFrame.new(596, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[45] t=1781824812.36
  {"Oak Planks", CFrame.new(596, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[46] t=1781824813.76
  {"Oak Planks", CFrame.new(600, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[47] t=1781824815.16
  {"Oak Planks", CFrame.new(600, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[48] t=1781824816.56
  {"Oak Planks", CFrame.new(600, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[49] t=1781824817.96
  {"Oak Planks", CFrame.new(600, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[50] t=1781824819.36
  {"Oak Planks", CFrame.new(600, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[51] t=1781824820.76
  {"Oak Planks", CFrame.new(600, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[52] t=1781824822.16
  {"Oak Planks", CFrame.new(600, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[53] t=1781824823.56
  {"Oak Planks", CFrame.new(600, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[54] t=1781824824.96
  {"Oak Planks", CFrame.new(600, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[55] t=1781824826.36
  {"Oak Planks", CFrame.new(604, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[56] t=1781824827.76
  {"Oak Planks", CFrame.new(604, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[57] t=1781824829.16
  {"Oak Planks", CFrame.new(604, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[58] t=1781824830.56
  {"Oak Planks", CFrame.new(604, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[59] t=1781824831.96
  {"Oak Planks", CFrame.new(604, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[60] t=1781824833.36
  {"Oak Planks", CFrame.new(604, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[61] t=1781824834.76
  {"Oak Planks", CFrame.new(604, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[62] t=1781824836.16
  {"Oak Planks", CFrame.new(604, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[63] t=1781824837.56
  {"Oak Planks", CFrame.new(604, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[64] t=1781824838.96
  {"Oak Planks", CFrame.new(608, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[65] t=1781824840.36
  {"Oak Planks", CFrame.new(608, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[66] t=1781824841.76
  {"Oak Planks", CFrame.new(608, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[67] t=1781824843.16
  {"Oak Planks", CFrame.new(608, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[68] t=1781824844.56
  {"Oak Planks", CFrame.new(608, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[69] t=1781824845.96
  {"Oak Planks", CFrame.new(608, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[70] t=1781824847.36
  {"Oak Planks", CFrame.new(608, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[71] t=1781824848.76
  {"Oak Planks", CFrame.new(608, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[72] t=1781824850.16
  {"Oak Planks", CFrame.new(608, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[73] t=1781824851.56
  {"Oak Planks", CFrame.new(612, 2, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[74] t=1781824852.96
  {"Oak Planks", CFrame.new(612, 2, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[75] t=1781824854.36
  {"Oak Planks", CFrame.new(612, 2, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[76] t=1781824855.76
  {"Oak Planks", CFrame.new(612, 2, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[77] t=1781824857.16
  {"Oak Planks", CFrame.new(612, 2, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[78] t=1781824858.56
  {"Oak Planks", CFrame.new(612, 2, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[79] t=1781824859.96
  {"Oak Planks", CFrame.new(612, 2, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[80] t=1781824861.36
  {"Oak Planks", CFrame.new(612, 2, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[81] t=1781824862.76
  {"Oak Planks", CFrame.new(612, 2, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[82] t=1781824864.16
  {"Oak Planks", CFrame.new(580, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[83] t=1781824865.56
  {"Oak Planks", CFrame.new(580, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[84] t=1781824866.96
  {"Oak Planks", CFrame.new(584, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[85] t=1781824868.36
  {"Oak Planks", CFrame.new(584, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[86] t=1781824869.76
  {"Oak Planks", CFrame.new(588, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[87] t=1781824871.16
  {"Oak Planks", CFrame.new(588, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[88] t=1781824872.56
  {"Oak Planks", CFrame.new(592, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[89] t=1781824873.96
  {"Oak Planks", CFrame.new(592, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[90] t=1781824875.36
  {"Oak Planks", CFrame.new(596, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[91] t=1781824876.76
  {"Oak Planks", CFrame.new(596, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[92] t=1781824878.16
  {"Oak Planks", CFrame.new(600, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[93] t=1781824879.56
  {"Oak Planks", CFrame.new(600, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[94] t=1781824880.96
  {"Oak Planks", CFrame.new(604, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[95] t=1781824882.36
  {"Oak Planks", CFrame.new(604, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[96] t=1781824883.76
  {"Oak Planks", CFrame.new(608, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[97] t=1781824885.16
  {"Oak Planks", CFrame.new(608, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[98] t=1781824886.56
  {"Oak Planks", CFrame.new(612, 6, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[99] t=1781824887.96
  {"Oak Planks", CFrame.new(612, 6, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[100] t=1781824889.36
  {"Oak Planks", CFrame.new(580, 6, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[101] t=1781824890.76
  {"Oak Planks", CFrame.new(612, 6, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[102] t=1781824892.16
  {"Oak Planks", CFrame.new(580, 6, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[103] t=1781824893.56
  {"Oak Planks", CFrame.new(612, 6, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[104] t=1781824894.96
  {"Oak Planks", CFrame.new(580, 6, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[105] t=1781824896.36
  {"Oak Planks", CFrame.new(612, 6, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[106] t=1781824897.76
  {"Oak Planks", CFrame.new(580, 6, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[107] t=1781824899.16
  {"Oak Planks", CFrame.new(612, 6, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[108] t=1781824900.56
  {"Oak Planks", CFrame.new(580, 6, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[109] t=1781824901.96
  {"Oak Planks", CFrame.new(612, 6, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[110] t=1781824903.36
  {"Oak Planks", CFrame.new(580, 6, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[111] t=1781824904.76
  {"Oak Planks", CFrame.new(612, 6, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[112] t=1781824906.16
  {"Oak Planks", CFrame.new(580, 6, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[113] t=1781824907.56
  {"Oak Planks", CFrame.new(612, 6, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[114] t=1781824908.96
  {"Oak Planks", CFrame.new(580, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[115] t=1781824910.36
  {"Oak Planks", CFrame.new(580, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[116] t=1781824911.76
  {"Oak Planks", CFrame.new(584, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[117] t=1781824913.16
  {"Oak Planks", CFrame.new(584, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[118] t=1781824914.56
  {"Oak Planks", CFrame.new(588, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[119] t=1781824915.96
  {"Oak Planks", CFrame.new(588, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[120] t=1781824917.36
  {"Oak Planks", CFrame.new(592, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[121] t=1781824918.76
  {"Oak Planks", CFrame.new(592, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[122] t=1781824920.16
  {"Oak Planks", CFrame.new(596, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[123] t=1781824921.56
  {"Oak Planks", CFrame.new(596, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[124] t=1781824922.96
  {"Oak Planks", CFrame.new(600, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[125] t=1781824924.36
  {"Oak Planks", CFrame.new(600, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[126] t=1781824925.76
  {"Oak Planks", CFrame.new(604, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[127] t=1781824927.16
  {"Oak Planks", CFrame.new(604, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[128] t=1781824928.56
  {"Oak Planks", CFrame.new(608, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[129] t=1781824929.96
  {"Oak Planks", CFrame.new(608, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[130] t=1781824931.36
  {"Oak Planks", CFrame.new(612, 10, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[131] t=1781824932.76
  {"Oak Planks", CFrame.new(612, 10, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[132] t=1781824934.16
  {"Oak Planks", CFrame.new(580, 10, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[133] t=1781824935.56
  {"Oak Planks", CFrame.new(612, 10, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[134] t=1781824936.96
  {"Oak Planks", CFrame.new(580, 10, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[135] t=1781824938.36
  {"Oak Planks", CFrame.new(612, 10, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[136] t=1781824939.76
  {"Oak Planks", CFrame.new(580, 10, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[137] t=1781824941.16
  {"Oak Planks", CFrame.new(612, 10, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[138] t=1781824942.56
  {"Oak Planks", CFrame.new(580, 10, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[139] t=1781824943.96
  {"Oak Planks", CFrame.new(612, 10, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[140] t=1781824945.36
  {"Oak Planks", CFrame.new(580, 10, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[141] t=1781824946.76
  {"Oak Planks", CFrame.new(612, 10, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[142] t=1781824948.16
  {"Oak Planks", CFrame.new(580, 10, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[143] t=1781824949.56
  {"Oak Planks", CFrame.new(612, 10, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[144] t=1781824950.96
  {"Oak Planks", CFrame.new(580, 10, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[145] t=1781824952.36
  {"Oak Planks", CFrame.new(612, 10, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[146] t=1781824953.76
  {"Oak Planks", CFrame.new(580, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[147] t=1781824955.16
  {"Oak Planks", CFrame.new(580, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[148] t=1781824956.56
  {"Oak Planks", CFrame.new(584, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[149] t=1781824957.96
  {"Oak Planks", CFrame.new(584, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[150] t=1781824959.36
  {"Oak Planks", CFrame.new(588, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[151] t=1781824960.76
  {"Oak Planks", CFrame.new(588, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[152] t=1781824962.16
  {"Oak Planks", CFrame.new(592, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[153] t=1781824963.56
  {"Oak Planks", CFrame.new(592, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[154] t=1781824964.96
  {"Oak Planks", CFrame.new(596, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[155] t=1781824966.36
  {"Oak Planks", CFrame.new(596, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[156] t=1781824967.76
  {"Oak Planks", CFrame.new(600, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[157] t=1781824969.16
  {"Oak Planks", CFrame.new(600, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[158] t=1781824970.56
  {"Oak Planks", CFrame.new(604, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[159] t=1781824971.96
  {"Oak Planks", CFrame.new(604, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[160] t=1781824973.36
  {"Oak Planks", CFrame.new(608, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[161] t=1781824974.76
  {"Oak Planks", CFrame.new(608, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[162] t=1781824976.16
  {"Oak Planks", CFrame.new(612, 14, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[163] t=1781824977.56
  {"Oak Planks", CFrame.new(612, 14, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[164] t=1781824978.96
  {"Oak Planks", CFrame.new(580, 14, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[165] t=1781824980.36
  {"Oak Planks", CFrame.new(612, 14, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[166] t=1781824981.76
  {"Oak Planks", CFrame.new(580, 14, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[167] t=1781824983.16
  {"Oak Planks", CFrame.new(612, 14, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[168] t=1781824984.56
  {"Oak Planks", CFrame.new(580, 14, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[169] t=1781824985.96
  {"Oak Planks", CFrame.new(612, 14, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[170] t=1781824987.36
  {"Oak Planks", CFrame.new(580, 14, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[171] t=1781824988.76
  {"Oak Planks", CFrame.new(612, 14, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[172] t=1781824990.16
  {"Oak Planks", CFrame.new(580, 14, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[173] t=1781824991.56
  {"Oak Planks", CFrame.new(612, 14, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[174] t=1781824992.96
  {"Oak Planks", CFrame.new(580, 14, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[175] t=1781824994.36
  {"Oak Planks", CFrame.new(612, 14, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[176] t=1781824995.76
  {"Oak Planks", CFrame.new(580, 14, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[177] t=1781824997.16
  {"Oak Planks", CFrame.new(612, 14, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[178] t=1781824998.56
  {"Oak Planks", CFrame.new(580, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[179] t=1781824999.96
  {"Oak Planks", CFrame.new(580, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[180] t=1781825001.36
  {"Oak Planks", CFrame.new(580, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[181] t=1781825002.76
  {"Oak Planks", CFrame.new(580, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[182] t=1781825004.16
  {"Oak Planks", CFrame.new(580, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[183] t=1781825005.56
  {"Oak Planks", CFrame.new(580, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[184] t=1781825006.96
  {"Oak Planks", CFrame.new(580, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[185] t=1781825008.36
  {"Oak Planks", CFrame.new(580, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[186] t=1781825009.76
  {"Oak Planks", CFrame.new(580, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[187] t=1781825011.16
  {"Oak Planks", CFrame.new(584, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[188] t=1781825012.56
  {"Oak Planks", CFrame.new(584, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[189] t=1781825013.96
  {"Oak Planks", CFrame.new(584, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[190] t=1781825015.36
  {"Oak Planks", CFrame.new(584, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[191] t=1781825016.76
  {"Oak Planks", CFrame.new(584, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[192] t=1781825018.16
  {"Oak Planks", CFrame.new(584, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[193] t=1781825019.56
  {"Oak Planks", CFrame.new(584, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[194] t=1781825020.96
  {"Oak Planks", CFrame.new(584, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[195] t=1781825022.36
  {"Oak Planks", CFrame.new(584, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[196] t=1781825023.76
  {"Oak Planks", CFrame.new(588, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[197] t=1781825025.16
  {"Oak Planks", CFrame.new(588, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[198] t=1781825026.56
  {"Oak Planks", CFrame.new(588, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[199] t=1781825027.96
  {"Oak Planks", CFrame.new(588, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[200] t=1781825029.36
  {"Oak Planks", CFrame.new(588, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[201] t=1781825030.76
  {"Oak Planks", CFrame.new(588, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[202] t=1781825032.16
  {"Oak Planks", CFrame.new(588, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[203] t=1781825033.56
  {"Oak Planks", CFrame.new(588, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[204] t=1781825034.96
  {"Oak Planks", CFrame.new(588, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[205] t=1781825036.36
  {"Oak Planks", CFrame.new(592, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[206] t=1781825037.76
  {"Oak Planks", CFrame.new(592, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[207] t=1781825039.16
  {"Oak Planks", CFrame.new(592, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[208] t=1781825040.56
  {"Oak Planks", CFrame.new(592, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[209] t=1781825041.96
  {"Oak Planks", CFrame.new(592, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[210] t=1781825043.36
  {"Oak Planks", CFrame.new(592, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[211] t=1781825044.76
  {"Oak Planks", CFrame.new(592, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[212] t=1781825046.16
  {"Oak Planks", CFrame.new(592, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[213] t=1781825047.56
  {"Oak Planks", CFrame.new(592, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[214] t=1781825048.96
  {"Oak Planks", CFrame.new(596, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[215] t=1781825050.36
  {"Oak Planks", CFrame.new(596, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[216] t=1781825051.76
  {"Oak Planks", CFrame.new(596, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[217] t=1781825053.16
  {"Oak Planks", CFrame.new(596, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[218] t=1781825054.56
  {"Oak Planks", CFrame.new(596, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[219] t=1781825055.96
  {"Oak Planks", CFrame.new(596, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[220] t=1781825057.36
  {"Oak Planks", CFrame.new(596, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[221] t=1781825058.76
  {"Oak Planks", CFrame.new(596, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[222] t=1781825060.16
  {"Oak Planks", CFrame.new(596, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[223] t=1781825061.56
  {"Oak Planks", CFrame.new(600, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[224] t=1781825062.96
  {"Oak Planks", CFrame.new(600, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[225] t=1781825064.36
  {"Oak Planks", CFrame.new(600, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[226] t=1781825065.76
  {"Oak Planks", CFrame.new(600, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[227] t=1781825067.16
  {"Oak Planks", CFrame.new(600, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[228] t=1781825068.56
  {"Oak Planks", CFrame.new(600, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[229] t=1781825069.96
  {"Oak Planks", CFrame.new(600, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[230] t=1781825071.36
  {"Oak Planks", CFrame.new(600, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[231] t=1781825072.76
  {"Oak Planks", CFrame.new(600, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[232] t=1781825074.16
  {"Oak Planks", CFrame.new(604, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[233] t=1781825075.56
  {"Oak Planks", CFrame.new(604, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[234] t=1781825076.96
  {"Oak Planks", CFrame.new(604, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[235] t=1781825078.36
  {"Oak Planks", CFrame.new(604, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[236] t=1781825079.76
  {"Oak Planks", CFrame.new(604, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[237] t=1781825081.16
  {"Oak Planks", CFrame.new(604, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[238] t=1781825082.56
  {"Oak Planks", CFrame.new(604, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[239] t=1781825083.96
  {"Oak Planks", CFrame.new(604, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[240] t=1781825085.36
  {"Oak Planks", CFrame.new(604, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[241] t=1781825086.76
  {"Oak Planks", CFrame.new(608, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[242] t=1781825088.16
  {"Oak Planks", CFrame.new(608, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[243] t=1781825089.56
  {"Oak Planks", CFrame.new(608, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[244] t=1781825090.96
  {"Oak Planks", CFrame.new(608, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[245] t=1781825092.36
  {"Oak Planks", CFrame.new(608, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[246] t=1781825093.76
  {"Oak Planks", CFrame.new(608, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[247] t=1781825095.16
  {"Oak Planks", CFrame.new(608, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[248] t=1781825096.56
  {"Oak Planks", CFrame.new(608, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[249] t=1781825097.96
  {"Oak Planks", CFrame.new(608, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
  --[250] t=1781825099.36
  {"Oak Planks", CFrame.new(612, 18, 144, 0, 0, 1, 0), workspace.Baseplate},
  --[251] t=1781825100.76
  {"Oak Planks", CFrame.new(612, 18, 148, 0, 0, 1, 0), workspace.Baseplate},
  --[252] t=1781825102.16
  {"Oak Planks", CFrame.new(612, 18, 152, 0, 0, 1, 0), workspace.Baseplate},
  --[253] t=1781825103.56
  {"Oak Planks", CFrame.new(612, 18, 156, 0, 0, 1, 0), workspace.Baseplate},
  --[254] t=1781825104.96
  {"Oak Planks", CFrame.new(612, 18, 160, 0, 0, 1, 0), workspace.Baseplate},
  --[255] t=1781825106.36
  {"Oak Planks", CFrame.new(612, 18, 164, 0, 0, 1, 0), workspace.Baseplate},
  --[256] t=1781825107.76
  {"Oak Planks", CFrame.new(612, 18, 168, 0, 0, 1, 0), workspace.Baseplate},
  --[257] t=1781825109.16
  {"Oak Planks", CFrame.new(612, 18, 172, 0, 0, 1, 0), workspace.Baseplate},
  --[258] t=1781825110.56
  {"Oak Planks", CFrame.new(612, 18, 176, 0, 0, 1, 0), workspace.Baseplate},
}
local claudehousev2 = {
  --[1] t=1781825415.31
  {"Cobblestone", CFrame.new(628, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[2] t=1781825416.71
  {"Cobblestone", CFrame.new(628, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[3] t=1781825418.11
  {"Cobblestone", CFrame.new(628, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[4] t=1781825419.51
  {"Cobblestone", CFrame.new(628, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[5] t=1781825420.91
  {"Cobblestone", CFrame.new(628, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[6] t=1781825422.31
  {"Cobblestone", CFrame.new(628, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[7] t=1781825423.71
  {"Cobblestone", CFrame.new(628, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[8] t=1781825425.11
  {"Cobblestone", CFrame.new(628, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[9] t=1781825426.51
  {"Cobblestone", CFrame.new(628, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[10] t=1781825427.91
  {"Cobblestone", CFrame.new(632, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[11] t=1781825429.31
  {"Cobblestone", CFrame.new(632, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[12] t=1781825430.71
  {"Cobblestone", CFrame.new(632, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[13] t=1781825432.11
  {"Cobblestone", CFrame.new(632, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[14] t=1781825433.51
  {"Cobblestone", CFrame.new(632, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[15] t=1781825434.91
  {"Cobblestone", CFrame.new(632, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[16] t=1781825436.31
  {"Cobblestone", CFrame.new(632, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[17] t=1781825437.71
  {"Cobblestone", CFrame.new(632, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[18] t=1781825439.11
  {"Cobblestone", CFrame.new(632, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[19] t=1781825440.51
  {"Cobblestone", CFrame.new(636, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[20] t=1781825441.91
  {"Cobblestone", CFrame.new(636, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[21] t=1781825443.31
  {"Cobblestone", CFrame.new(636, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[22] t=1781825444.71
  {"Cobblestone", CFrame.new(636, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[23] t=1781825446.11
  {"Cobblestone", CFrame.new(636, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[24] t=1781825447.51
  {"Cobblestone", CFrame.new(636, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[25] t=1781825448.91
  {"Cobblestone", CFrame.new(636, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[26] t=1781825450.31
  {"Cobblestone", CFrame.new(636, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[27] t=1781825451.71
  {"Cobblestone", CFrame.new(636, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[28] t=1781825453.11
  {"Cobblestone", CFrame.new(640, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[29] t=1781825454.51
  {"Cobblestone", CFrame.new(640, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[30] t=1781825455.91
  {"Cobblestone", CFrame.new(640, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[31] t=1781825457.31
  {"Cobblestone", CFrame.new(640, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[32] t=1781825458.71
  {"Cobblestone", CFrame.new(640, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[33] t=1781825460.11
  {"Cobblestone", CFrame.new(640, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[34] t=1781825461.51
  {"Cobblestone", CFrame.new(640, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[35] t=1781825462.91
  {"Cobblestone", CFrame.new(640, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[36] t=1781825464.31
  {"Cobblestone", CFrame.new(640, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[37] t=1781825465.71
  {"Cobblestone", CFrame.new(644, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[38] t=1781825467.11
  {"Cobblestone", CFrame.new(644, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[39] t=1781825468.51
  {"Cobblestone", CFrame.new(644, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[40] t=1781825469.91
  {"Cobblestone", CFrame.new(644, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[41] t=1781825471.31
  {"Cobblestone", CFrame.new(644, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[42] t=1781825472.71
  {"Cobblestone", CFrame.new(644, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[43] t=1781825474.11
  {"Cobblestone", CFrame.new(644, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[44] t=1781825475.51
  {"Cobblestone", CFrame.new(644, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[45] t=1781825476.91
  {"Cobblestone", CFrame.new(644, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[46] t=1781825478.31
  {"Cobblestone", CFrame.new(648, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[47] t=1781825479.71
  {"Cobblestone", CFrame.new(648, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[48] t=1781825481.11
  {"Cobblestone", CFrame.new(648, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[49] t=1781825482.51
  {"Cobblestone", CFrame.new(648, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[50] t=1781825483.91
  {"Cobblestone", CFrame.new(648, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[51] t=1781825485.31
  {"Cobblestone", CFrame.new(648, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[52] t=1781825486.71
  {"Cobblestone", CFrame.new(648, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[53] t=1781825488.11
  {"Cobblestone", CFrame.new(648, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[54] t=1781825489.51
  {"Cobblestone", CFrame.new(648, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[55] t=1781825490.91
  {"Cobblestone", CFrame.new(652, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[56] t=1781825492.31
  {"Cobblestone", CFrame.new(652, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[57] t=1781825493.71
  {"Cobblestone", CFrame.new(652, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[58] t=1781825495.11
  {"Cobblestone", CFrame.new(652, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[59] t=1781825496.51
  {"Cobblestone", CFrame.new(652, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[60] t=1781825497.91
  {"Cobblestone", CFrame.new(652, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[61] t=1781825499.31
  {"Cobblestone", CFrame.new(652, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[62] t=1781825500.71
  {"Cobblestone", CFrame.new(652, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[63] t=1781825502.11
  {"Cobblestone", CFrame.new(652, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[64] t=1781825503.51
  {"Cobblestone", CFrame.new(656, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[65] t=1781825504.91
  {"Cobblestone", CFrame.new(656, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[66] t=1781825506.31
  {"Cobblestone", CFrame.new(656, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[67] t=1781825507.71
  {"Cobblestone", CFrame.new(656, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[68] t=1781825509.11
  {"Cobblestone", CFrame.new(656, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[69] t=1781825510.51
  {"Cobblestone", CFrame.new(656, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[70] t=1781825511.91
  {"Cobblestone", CFrame.new(656, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[71] t=1781825513.31
  {"Cobblestone", CFrame.new(656, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[72] t=1781825514.71
  {"Cobblestone", CFrame.new(656, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[73] t=1781825516.11
  {"Cobblestone", CFrame.new(660, 2, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[74] t=1781825517.51
  {"Cobblestone", CFrame.new(660, 2, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[75] t=1781825518.91
  {"Cobblestone", CFrame.new(660, 2, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[76] t=1781825520.31
  {"Cobblestone", CFrame.new(660, 2, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[77] t=1781825521.71
  {"Cobblestone", CFrame.new(660, 2, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[78] t=1781825523.11
  {"Cobblestone", CFrame.new(660, 2, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[79] t=1781825524.51
  {"Cobblestone", CFrame.new(660, 2, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[80] t=1781825525.91
  {"Cobblestone", CFrame.new(660, 2, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[81] t=1781825527.31
  {"Cobblestone", CFrame.new(660, 2, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[82] t=1781825528.71
  {"Oak Log", CFrame.new(628, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[83] t=1781825530.11
  {"Oak Log", CFrame.new(628, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[84] t=1781825531.51
  {"Bricks", CFrame.new(632, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[85] t=1781825532.91
  {"Bricks", CFrame.new(632, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[86] t=1781825534.31
  {"Bricks", CFrame.new(636, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[87] t=1781825535.71
  {"Bricks", CFrame.new(636, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[88] t=1781825537.11
  {"Bricks", CFrame.new(640, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[89] t=1781825538.51
  {"Bricks", CFrame.new(640, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[90] t=1781825539.91
  {"Bricks", CFrame.new(644, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[91] t=1781825541.31
  {"Bricks", CFrame.new(648, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[92] t=1781825542.71
  {"Bricks", CFrame.new(648, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[93] t=1781825544.11
  {"Bricks", CFrame.new(652, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[94] t=1781825545.51
  {"Bricks", CFrame.new(652, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[95] t=1781825546.91
  {"Bricks", CFrame.new(656, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[96] t=1781825548.31
  {"Bricks", CFrame.new(656, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[97] t=1781825549.71
  {"Oak Log", CFrame.new(660, 6, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[98] t=1781825551.11
  {"Oak Log", CFrame.new(660, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[99] t=1781825552.51
  {"Bricks", CFrame.new(628, 6, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[100] t=1781825553.91
  {"Bricks", CFrame.new(660, 6, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[101] t=1781825555.31
  {"Bricks", CFrame.new(628, 6, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[102] t=1781825556.71
  {"Bricks", CFrame.new(660, 6, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[103] t=1781825558.11
  {"Bricks", CFrame.new(628, 6, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[104] t=1781825559.51
  {"Bricks", CFrame.new(660, 6, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[105] t=1781825560.91
  {"Bricks", CFrame.new(628, 6, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[106] t=1781825562.31
  {"Bricks", CFrame.new(660, 6, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[107] t=1781825563.71
  {"Bricks", CFrame.new(628, 6, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[108] t=1781825565.11
  {"Bricks", CFrame.new(660, 6, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[109] t=1781825566.51
  {"Bricks", CFrame.new(628, 6, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[110] t=1781825567.91
  {"Bricks", CFrame.new(660, 6, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[111] t=1781825569.31
  {"Bricks", CFrame.new(628, 6, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[112] t=1781825570.71
  {"Bricks", CFrame.new(660, 6, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[113] t=1781825572.11
  {"Oak Log", CFrame.new(628, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[114] t=1781825573.51
  {"Oak Log", CFrame.new(628, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[115] t=1781825574.91
  {"Bricks", CFrame.new(632, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[116] t=1781825576.31
  {"Bricks", CFrame.new(632, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[117] t=1781825577.71
  {"Glass", CFrame.new(636, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[118] t=1781825579.11
  {"Glass", CFrame.new(636, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[119] t=1781825580.51
  {"Bricks", CFrame.new(640, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[120] t=1781825581.91
  {"Bricks", CFrame.new(640, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[121] t=1781825583.31
  {"Glass", CFrame.new(644, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[122] t=1781825584.71
  {"Bricks", CFrame.new(648, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[123] t=1781825586.11
  {"Bricks", CFrame.new(648, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[124] t=1781825587.51
  {"Glass", CFrame.new(652, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[125] t=1781825588.91
  {"Glass", CFrame.new(652, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[126] t=1781825590.31
  {"Bricks", CFrame.new(656, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[127] t=1781825591.71
  {"Bricks", CFrame.new(656, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[128] t=1781825593.11
  {"Oak Log", CFrame.new(660, 10, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[129] t=1781825594.51
  {"Oak Log", CFrame.new(660, 10, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[130] t=1781825595.91
  {"Bricks", CFrame.new(628, 10, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[131] t=1781825597.31
  {"Bricks", CFrame.new(660, 10, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[132] t=1781825598.71
  {"Glass", CFrame.new(628, 10, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[133] t=1781825600.11
  {"Glass", CFrame.new(660, 10, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[134] t=1781825601.51
  {"Bricks", CFrame.new(628, 10, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[135] t=1781825602.91
  {"Bricks", CFrame.new(660, 10, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[136] t=1781825604.31
  {"Glass", CFrame.new(628, 10, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[137] t=1781825605.71
  {"Glass", CFrame.new(660, 10, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[138] t=1781825607.11
  {"Bricks", CFrame.new(628, 10, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[139] t=1781825608.51
  {"Bricks", CFrame.new(660, 10, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[140] t=1781825609.91
  {"Glass", CFrame.new(628, 10, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[141] t=1781825611.31
  {"Glass", CFrame.new(660, 10, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[142] t=1781825612.71
  {"Bricks", CFrame.new(628, 10, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[143] t=1781825614.11
  {"Bricks", CFrame.new(660, 10, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[144] t=1781825615.51
  {"Oak Log", CFrame.new(628, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[145] t=1781825616.91
  {"Oak Log", CFrame.new(628, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[146] t=1781825618.31
  {"Bricks", CFrame.new(632, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[147] t=1781825619.71
  {"Bricks", CFrame.new(632, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[148] t=1781825621.11
  {"Bricks", CFrame.new(636, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[149] t=1781825622.51
  {"Bricks", CFrame.new(636, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[150] t=1781825623.91
  {"Bricks", CFrame.new(640, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[151] t=1781825625.31
  {"Bricks", CFrame.new(640, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[152] t=1781825626.71
  {"Bricks", CFrame.new(644, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[153] t=1781825628.11
  {"Bricks", CFrame.new(644, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[154] t=1781825629.51
  {"Bricks", CFrame.new(648, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[155] t=1781825630.91
  {"Bricks", CFrame.new(648, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[156] t=1781825632.31
  {"Bricks", CFrame.new(652, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[157] t=1781825633.71
  {"Bricks", CFrame.new(652, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[158] t=1781825635.11
  {"Bricks", CFrame.new(656, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[159] t=1781825636.51
  {"Bricks", CFrame.new(656, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[160] t=1781825637.91
  {"Oak Log", CFrame.new(660, 14, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[161] t=1781825639.31
  {"Oak Log", CFrame.new(660, 14, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[162] t=1781825640.71
  {"Bricks", CFrame.new(628, 14, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[163] t=1781825642.11
  {"Bricks", CFrame.new(660, 14, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[164] t=1781825643.51
  {"Bricks", CFrame.new(628, 14, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[165] t=1781825644.91
  {"Bricks", CFrame.new(660, 14, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[166] t=1781825646.31
  {"Bricks", CFrame.new(628, 14, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[167] t=1781825647.71
  {"Bricks", CFrame.new(660, 14, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[168] t=1781825649.11
  {"Bricks", CFrame.new(628, 14, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[169] t=1781825650.51
  {"Bricks", CFrame.new(660, 14, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[170] t=1781825651.91
  {"Bricks", CFrame.new(628, 14, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[171] t=1781825653.31
  {"Bricks", CFrame.new(660, 14, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[172] t=1781825654.71
  {"Bricks", CFrame.new(628, 14, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[173] t=1781825656.11
  {"Bricks", CFrame.new(660, 14, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[174] t=1781825657.51
  {"Bricks", CFrame.new(628, 14, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[175] t=1781825658.91
  {"Bricks", CFrame.new(660, 14, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[176] t=1781825660.31
  {"Pink Wool", CFrame.new(628, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[177] t=1781825661.71
  {"Pink Wool", CFrame.new(628, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[178] t=1781825663.11
  {"Pink Wool", CFrame.new(632, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[179] t=1781825664.51
  {"Pink Wool", CFrame.new(632, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[180] t=1781825665.91
  {"Pink Wool", CFrame.new(636, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[181] t=1781825667.31
  {"Pink Wool", CFrame.new(636, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[182] t=1781825668.71
  {"Pink Wool", CFrame.new(640, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[183] t=1781825670.11
  {"Pink Wool", CFrame.new(640, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[184] t=1781825671.51
  {"Pink Wool", CFrame.new(644, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[185] t=1781825672.91
  {"Pink Wool", CFrame.new(644, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[186] t=1781825674.31
  {"Pink Wool", CFrame.new(648, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[187] t=1781825675.71
  {"Pink Wool", CFrame.new(648, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[188] t=1781825677.11
  {"Pink Wool", CFrame.new(652, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[189] t=1781825678.51
  {"Pink Wool", CFrame.new(652, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[190] t=1781825679.91
  {"Pink Wool", CFrame.new(656, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[191] t=1781825681.31
  {"Pink Wool", CFrame.new(656, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[192] t=1781825682.71
  {"Pink Wool", CFrame.new(660, 18, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[193] t=1781825684.11
  {"Pink Wool", CFrame.new(660, 18, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[194] t=1781825685.51
  {"Pink Wool", CFrame.new(628, 18, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[195] t=1781825686.91
  {"Pink Wool", CFrame.new(660, 18, 64, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[196] t=1781825688.31
  {"Pink Wool", CFrame.new(628, 18, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[197] t=1781825689.71
  {"Pink Wool", CFrame.new(660, 18, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[198] t=1781825691.11
  {"Pink Wool", CFrame.new(628, 18, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[199] t=1781825692.51
  {"Pink Wool", CFrame.new(660, 18, 72, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[200] t=1781825693.91
  {"Pink Wool", CFrame.new(628, 18, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[201] t=1781825695.31
  {"Pink Wool", CFrame.new(660, 18, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[202] t=1781825696.71
  {"Pink Wool", CFrame.new(628, 18, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[203] t=1781825698.11
  {"Pink Wool", CFrame.new(660, 18, 80, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[204] t=1781825699.51
  {"Pink Wool", CFrame.new(628, 18, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[205] t=1781825700.91
  {"Pink Wool", CFrame.new(660, 18, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[206] t=1781825702.31
  {"Pink Wool", CFrame.new(628, 18, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[207] t=1781825703.71
  {"Pink Wool", CFrame.new(660, 18, 88, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[208] t=1781825705.11
  {"Oak Planks", CFrame.new(628, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[209] t=1781825706.51
  {"Oak Planks", CFrame.new(628, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[210] t=1781825707.91
  {"Oak Planks", CFrame.new(628, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[211] t=1781825709.31
  {"Oak Planks", CFrame.new(628, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[212] t=1781825710.71
  {"Oak Planks", CFrame.new(628, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[213] t=1781825712.11
  {"Oak Planks", CFrame.new(628, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[214] t=1781825713.51
  {"Oak Planks", CFrame.new(628, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[215] t=1781825714.91
  {"Oak Planks", CFrame.new(628, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[216] t=1781825716.31
  {"Oak Planks", CFrame.new(628, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[217] t=1781825717.71
  {"Oak Planks", CFrame.new(632, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[218] t=1781825719.11
  {"Oak Planks", CFrame.new(632, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[219] t=1781825720.51
  {"Oak Planks", CFrame.new(632, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[220] t=1781825721.91
  {"Oak Planks", CFrame.new(632, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[221] t=1781825723.31
  {"Oak Planks", CFrame.new(632, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[222] t=1781825724.71
  {"Oak Planks", CFrame.new(632, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[223] t=1781825726.11
  {"Oak Planks", CFrame.new(632, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[224] t=1781825727.51
  {"Oak Planks", CFrame.new(632, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[225] t=1781825728.91
  {"Oak Planks", CFrame.new(632, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[226] t=1781825730.31
  {"Oak Planks", CFrame.new(636, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[227] t=1781825731.71
  {"Oak Planks", CFrame.new(636, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[228] t=1781825733.11
  {"Oak Planks", CFrame.new(636, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[229] t=1781825734.51
  {"Oak Planks", CFrame.new(636, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[230] t=1781825735.91
  {"Oak Planks", CFrame.new(636, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[231] t=1781825737.31
  {"Oak Planks", CFrame.new(636, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[232] t=1781825738.71
  {"Oak Planks", CFrame.new(636, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[233] t=1781825740.11
  {"Oak Planks", CFrame.new(636, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[234] t=1781825741.51
  {"Oak Planks", CFrame.new(636, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[235] t=1781825742.91
  {"Oak Planks", CFrame.new(640, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[236] t=1781825744.31
  {"Oak Planks", CFrame.new(640, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[237] t=1781825745.71
  {"Oak Planks", CFrame.new(640, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[238] t=1781825747.11
  {"Oak Planks", CFrame.new(640, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[239] t=1781825748.51
  {"Oak Planks", CFrame.new(640, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[240] t=1781825749.91
  {"Oak Planks", CFrame.new(640, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[241] t=1781825751.31
  {"Oak Planks", CFrame.new(640, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[242] t=1781825752.71
  {"Oak Planks", CFrame.new(640, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[243] t=1781825754.11
  {"Oak Planks", CFrame.new(640, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[244] t=1781825755.51
  {"Oak Planks", CFrame.new(644, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[245] t=1781825756.91
  {"Oak Planks", CFrame.new(644, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[246] t=1781825758.31
  {"Oak Planks", CFrame.new(644, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[247] t=1781825759.71
  {"Oak Planks", CFrame.new(644, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[248] t=1781825761.11
  {"Oak Planks", CFrame.new(644, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[249] t=1781825762.51
  {"Oak Planks", CFrame.new(644, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[250] t=1781825763.91
  {"Oak Planks", CFrame.new(644, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[251] t=1781825765.31
  {"Oak Planks", CFrame.new(644, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[252] t=1781825766.71
  {"Oak Planks", CFrame.new(644, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[253] t=1781825768.11
  {"Oak Planks", CFrame.new(648, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[254] t=1781825769.51
  {"Oak Planks", CFrame.new(648, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[255] t=1781825770.91
  {"Oak Planks", CFrame.new(648, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[256] t=1781825772.31
  {"Oak Planks", CFrame.new(648, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[257] t=1781825773.71
  {"Oak Planks", CFrame.new(648, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[258] t=1781825775.11
  {"Oak Planks", CFrame.new(648, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[259] t=1781825776.51
  {"Oak Planks", CFrame.new(648, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[260] t=1781825777.91
  {"Oak Planks", CFrame.new(648, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[261] t=1781825779.31
  {"Oak Planks", CFrame.new(648, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[262] t=1781825780.71
  {"Oak Planks", CFrame.new(652, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[263] t=1781825782.11
  {"Oak Planks", CFrame.new(652, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[264] t=1781825783.51
  {"Oak Planks", CFrame.new(652, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[265] t=1781825784.91
  {"Oak Planks", CFrame.new(652, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[266] t=1781825786.31
  {"Oak Planks", CFrame.new(652, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[267] t=1781825787.71
  {"Oak Planks", CFrame.new(652, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[268] t=1781825789.11
  {"Oak Planks", CFrame.new(652, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[269] t=1781825790.51
  {"Oak Planks", CFrame.new(652, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[270] t=1781825791.91
  {"Oak Planks", CFrame.new(652, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[271] t=1781825793.31
  {"Oak Planks", CFrame.new(656, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[272] t=1781825794.71
  {"Oak Planks", CFrame.new(656, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[273] t=1781825796.11
  {"Oak Planks", CFrame.new(656, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[274] t=1781825797.51
  {"Oak Planks", CFrame.new(656, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[275] t=1781825798.91
  {"Oak Planks", CFrame.new(656, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[276] t=1781825800.31
  {"Oak Planks", CFrame.new(656, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[277] t=1781825801.71
  {"Oak Planks", CFrame.new(656, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[278] t=1781825803.11
  {"Oak Planks", CFrame.new(656, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[279] t=1781825804.51
  {"Oak Planks", CFrame.new(656, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[280] t=1781825805.91
  {"Oak Planks", CFrame.new(660, 22, 60, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[281] t=1781825807.31
  {"Oak Planks", CFrame.new(660, 22, 64, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[282] t=1781825808.71
  {"Oak Planks", CFrame.new(660, 22, 68, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[283] t=1781825810.11
  {"Oak Planks", CFrame.new(660, 22, 72, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[284] t=1781825811.51
  {"Oak Planks", CFrame.new(660, 22, 76, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[285] t=1781825812.91
  {"Oak Planks", CFrame.new(660, 22, 80, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[286] t=1781825814.31
  {"Oak Planks", CFrame.new(660, 22, 84, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[287] t=1781825815.71
  {"Oak Planks", CFrame.new(660, 22, 88, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[288] t=1781825817.11
  {"Oak Planks", CFrame.new(660, 22, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[289] t=1781825818.51
  {"Lamp", CFrame.new(640, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[290] t=1781825819.91
  {"Lamp", CFrame.new(648, 6, 92, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[291] t=1781825821.31
  {"Oak Leaves", CFrame.new(628, 2, 56, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[292] t=1781825822.71
  {"Oak Leaves", CFrame.new(628, 2, 96, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[293] t=1781825824.11
  {"Oak Leaves", CFrame.new(636, 2, 56, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[294] t=1781825825.51
  {"Oak Leaves", CFrame.new(636, 2, 96, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[295] t=1781825826.91
  {"Oak Leaves", CFrame.new(644, 2, 56, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[296] t=1781825828.31
  {"Oak Leaves", CFrame.new(644, 2, 96, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[297] t=1781825829.71
  {"Oak Leaves", CFrame.new(652, 2, 56, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[298] t=1781825831.11
  {"Oak Leaves", CFrame.new(652, 2, 96, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[299] t=1781825832.51
  {"Oak Leaves", CFrame.new(660, 2, 56, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[300] t=1781825833.91
  {"Oak Leaves", CFrame.new(660, 2, 96, -1, 0, -4.371138828673793e-08, 0), workspace.Baseplate},
  --[301] t=1781825835.31
  {"Oak Leaves", CFrame.new(624, 2, 60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[302] t=1781825836.71
  {"Oak Leaves", CFrame.new(664, 2, 60, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[303] t=1781825838.11
  {"Oak Leaves", CFrame.new(624, 2, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[304] t=1781825839.51
  {"Oak Leaves", CFrame.new(664, 2, 68, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[305] t=1781825840.91
  {"Oak Leaves", CFrame.new(624, 2, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[306] t=1781825842.31
  {"Oak Leaves", CFrame.new(664, 2, 76, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[307] t=1781825843.71
  {"Oak Leaves", CFrame.new(624, 2, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[308] t=1781825845.11
  {"Oak Leaves", CFrame.new(664, 2, 84, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[309] t=1781825846.51
  {"Oak Leaves", CFrame.new(624, 2, 92, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
  --[310] t=1781825847.91
  {"Oak Leaves", CFrame.new(664, 2, 92, -4.371138828673793e-08, 0, 1, 0), workspace.Baseplate},
}
M.castle = castle
M.coolpattern = coolpattern
M.claudeshouse = claudeshouse
M.claudehousev2 = claudehousev2
return M

]==]
	local fn = loadstring(src)
	if fn then
		local M = fn()
		if type(M) == "table" then
			if not ENV then ENV = _G end
			ENV._baBuildsEmbedded = M
		end
	end
end)

-- Build Anything (125488740127641)
local function buildGame9Features()
	clearFeatures()
	createSectionF("Delete Builds", 0)

	ENV.baVictim = ENV.baVictim or nil

	local userBox = Instance.new("TextBox")
	userBox.Size = UDim2.new(1, -4, 0, 28)
	userBox.Position = UDim2.new(0, 2, 0, 22)
	userBox.BackgroundColor3 = Color3.fromRGB(45, 40, 95)
	userBox.PlaceholderText = "Enter Username.."
	userBox.Text = ""
	userBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	userBox.Font = Enum.Font.Gotham
	userBox.TextSize = 12
	userBox.ClearTextOnFocus = false
	userBox.Parent = FeaturesFrame
	Instance.new("UICorner", userBox).CornerRadius = UDim.new(0, 6)
	userBox.FocusLost:Connect(function()
		local v = userBox.Text
		ENV.baVictim = nil
		if v == "" then return end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Name:lower():find(v:lower(), 1, true) then
				ENV.baVictim = plr
				userBox.Text = plr.Name
				break
			end
		end
	end)

	createButtonF("Delete All", 56, function()
		playClick()
		local built = workspace:FindFirstChild("Built")
		if not built then return end
		local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
		Event = Event and Event:FindFirstChild("DestroyBlock")
		if not Event then return end
		for _, plot in pairs(built:GetChildren()) do
			for _, block in pairs(plot:GetChildren()) do
				task.spawn(function()
					pcall(function() Event:InvokeServer(block) end)
				end)
			end
		end
	end)

	createButtonF("Delete Victim", 88, function()
		playClick()
		local victim = ENV.baVictim
		if not victim then return end
		local built = workspace:FindFirstChild("Built")
		local plot = built and built:FindFirstChild(victim.Name)
		if not plot then return end
		local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
		Event = Event and Event:FindFirstChild("DestroyBlock")
		if not Event then return end
		for _, block in pairs(plot:GetChildren()) do
			task.spawn(function()
				pcall(function() Event:InvokeServer(block) end)
			end)
		end
	end)

	createSectionF("Auto Build", 124)

	local function getBABuilds()
		if ENV._baBuilds then return ENV._baBuilds end
		local ok, res = pcall(function()
			local src = (safeHttpGet and safeHttpGet("https://raw.githubusercontent.com/Itskyanscripts/HyperZScript/refs/heads/main/build_anything_builds.lua"))
				or game:HttpGet("https://raw.githubusercontent.com/Itskyanscripts/HyperZScript/refs/heads/main/build_anything_builds.lua")
			return loadstring(src)()
		end)
		if ok and type(res) == "table" then
			ENV._baBuilds = res
			return res
		end
		-- fallback: embedded loader flag
		if ENV._baBuildsEmbedded then
			ENV._baBuilds = ENV._baBuildsEmbedded
			return ENV._baBuilds
		end
		return nil
	end

	local function runBuild(list, mode)
		local builds = getBABuilds()
		if not builds or not builds[list] then
			warn("[HyperZ] Build data missing — upload build_anything_builds.lua to GitHub")
			return
		end
		local Eventb = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
		Eventb = Eventb and Eventb:FindFirstChild("Place")
		if not Eventb then return end
		local plr = player
		local data = builds[list]
		if mode == "pivot" then
			for _, v in ipairs(data) do
				pcall(function()
					if plr.Character then plr.Character:PivotTo(v[2]) end
				end)
				task.wait()
				pcall(function() Eventb:InvokeServer(table.unpack(v)) end)
			end
			pcall(function()
				local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp then hrp.Anchored = false end
			end)
		elseif mode == "moveto" then
			pcall(function()
				if plr.Character then plr.Character:MoveTo(Vector3.new(596, 6, 160)) end
			end)
			for _, v in ipairs(data) do
				pcall(function() Eventb:InvokeServer(table.unpack(v)) end)
			end
		elseif mode == "spawn" then
			pcall(function()
				if plr.Character then plr.Character:MoveTo(Vector3.new(644, 6, 76)) end
			end)
			for _, v in ipairs(data) do
				task.spawn(function()
					pcall(function() Eventb:InvokeServer(table.unpack(v)) end)
				end)
			end
		end
	end

	createButtonF("Castle", 146, function()
		playClick()
		task.spawn(function() runBuild("castle", "pivot") end)
	end)
	createButtonF("Cool pattern", 178, function()
		playClick()
		task.spawn(function() runBuild("coolpattern", "pivot") end)
	end)
	createButtonF("Claude's House", 210, function()
		playClick()
		task.spawn(function() runBuild("claudeshouse", "moveto") end)
	end)
	createButtonF("Claude's House V2", 242, function()
		playClick()
		task.spawn(function() runBuild("claudehousev2", "spawn") end)
	end)

	FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 290)
end


-- How to add a game: put PlaceId + builder in SUPPORTED
local SUPPORTED = {
	[tonumber("75626443136851")] = buildGame1Features,
	[tonumber("108775830475023")] = buildGame2Features,
	[tonumber("84757653274750")] = buildGame3Features,
	[tonumber("78579721506911")] = buildGame4Features,
	[tonumber("82554996468034")] = buildGame5Features,
	[tonumber("84718070904253")] = buildGame6Features, -- Monkey Math
	[tonumber("125488740127641")] = buildGame9Features, -- Build Anything
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
