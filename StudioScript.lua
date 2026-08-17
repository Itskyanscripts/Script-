--[[
    Studio Script - Full Version
    Owners : Eyfanboy09
    Tester : TheSledM
    Channel: ItsKyanBence
]]

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- FOLDER + SAVED ASSETS
-- ============================================================
if isfolder and not isfolder("StudioScript") then
    pcall(makefolder, "StudioScript")
end

local SavedAssets = {}

local function LoadSaved()
    if isfile and isfile("StudioScript/SavedAssets.json") then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile("StudioScript/SavedAssets.json"))
        end)
        if ok and type(data) == "table" then
            SavedAssets = data
        end
    end
end

local function SaveSaved()
    if writefile then
        pcall(function()
            writefile("StudioScript/SavedAssets.json", HttpService:JSONEncode(SavedAssets))
        end)
    end
end

LoadSaved()

-- ============================================================
-- INSERT FUNCTION
-- ============================================================
local function InsertAsset(assetId)
    assetId = tonumber(assetId)
    if not assetId then
        Rayfield:Notify({Title = "Error", Content = "Invalid Asset ID", Duration = 4})
        return
    end

    local success, result = pcall(function()
        return InsertService:LoadAsset(assetId)
    end)

    if success and result then
        local model = result
        -- Place near player
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            model:PivotTo(root.CFrame * CFrame.new(0, 0, -8))
        end
        model.Parent = workspace
        Rayfield:Notify({
            Title = "Inserted!",
            Content = "Asset " .. assetId .. " placed in Workspace",
            Duration = 4
        })
        print("[StudioScript] Inserted Asset ID:", assetId)
    else
        Rayfield:Notify({
            Title = "Insert Failed",
            Content = "Could not load asset (private / restricted / invalid)",
            Duration = 5
        })
        print("[StudioScript] Failed to insert:", assetId, result)
    end
end

-- ============================================================
-- SAMPLE ASSETS (popular free ones for demo)
-- ============================================================
local AssetDatabase = {
    Models = {
        {Id = 257489726, Name = "Doge"},
        {Id = 16619585, Name = "Classic Sword"},
        {Id = 11999247, Name = "Linked Sword"},
        {Id = 28276472, Name = "Rocket Launcher"},
        {Id = 47620, Name = "Slingshot"},
        {Id = 168126597, Name = "Noob"},
        {Id = 101084539, Name = "Guest"},
        {Id = 210349398, Name = "Builderman"},
        {Id = 1081413, Name = "Classic House"},
        {Id = 18474459, Name = "Tree"},
        {Id = 142275399, Name = "Car"},
        {Id = 162502414, Name = "Jeep"},
        {Id = 2259346496, Name = "Modern House"},
        {Id = 2864541985, Name = "Office Building"},
        {Id = 4516534084, Name = "Simple Table"},
        {Id = 4516535282, Name = "Simple Chair"},
        {Id = 2864540898, Name = "Road"},
        {Id = 2864542591, Name = "Street Light"},
    },
    Decals = {
        {Id = 60658290, Name = "Roblox Logo"},
        {Id = 148928825, Name = "Sky"},
        {Id = 241528920, Name = "Grass"},
        {Id = 241528877, Name = "Wood"},
        {Id = 241528995, Name = "Brick"},
        {Id = 60658188, Name = "Checker"},
        {Id = 7072719, Name = "Sparkles"},
        {Id = 1081221, Name = "Face"},
    },
    Audio = {
        {Id = 142376088, Name = "Sword Slash"},
        {Id = 12222216, Name = "Laser"},
        {Id = 131447978, Name = "Explosion"},
        {Id = 12222161, Name = "Click"},
        {Id = 131447905, Name = "Jump"},
        {Id = 1837829401, Name = "Happy Music"},
        {Id = 1842619509, Name = "Epic Theme"},
    },
    Meshes = {
        {Id = 430066276, Name = "Sphere Mesh"},
        {Id = 430066401, Name = "Cube Mesh"},
        {Id = 430066490, Name = "Cylinder Mesh"},
    },
    Plugins = {
        {Id = 142274963, Name = "Building Tools"},
        {Id = 166280158, Name = "F3X Building Tools"},
    },
    Videos = {
        {Id = 5608319593, Name = "Sample Video"},
    },
    Everything = {} -- will be filled with all
}

-- Fill "Everything"
for cat, list in pairs(AssetDatabase) do
    if cat ~= "Everything" then
        for _, asset in ipairs(list) do
            table.insert(AssetDatabase.Everything, asset)
        end
    end
end

-- ============================================================
-- CUSTOM TOOLBOX GUI
-- ============================================================
local ToolboxGui = nil
local currentCategory = "Models"
local selectedAsset = nil

local function CreateToolbox()
    if ToolboxGui and ToolboxGui.Parent then
        ToolboxGui.Enabled = true
        return
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StudioToolbox"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    ToolboxGui = ScreenGui

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 780, 0, 520)
    Main.Position = UDim2.new(0.5, -390, 0.5, -260)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 80)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = Main

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 42)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 15)
    TitleFix.Position = UDim2.new(0, 0, 1, -15)
    TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 16, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Studio Toolbox"
    Title.TextColor3 = Color3.fromRGB(240, 240, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    -- Category Bar
    local CatBar = Instance.new("Frame")
    CatBar.Size = UDim2.new(1, -24, 0, 36)
    CatBar.Position = UDim2.new(0, 12, 0, 52)
    CatBar.BackgroundTransparency = 1
    CatBar.Parent = Main

    local categories = {"Models", "Decals", "Audio", "Meshes", "Plugins", "Videos", "Everything", "Saved"}
    local catButtons = {}

    local function setCategory(cat)
        currentCategory = cat
        for name, btn in pairs(catButtons) do
            if name == cat then
                btn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            end
        end
        RefreshAssetList()
    end

    for i, cat in ipairs(categories) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 88, 1, 0)
        btn.Position = UDim2.new(0, (i - 1) * 94, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.Text = cat
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.Parent = CatBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        catButtons[cat] = btn
        btn.MouseButton1Click:Connect(function()
            setCategory(cat)
        end)
    end

    -- Content Area (two frames)
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -24, 1, -110)
    Content.Position = UDim2.new(0, 12, 0, 98)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    -- Left: Asset Grid
    local GridFrame = Instance.new("ScrollingFrame")
    GridFrame.Name = "Grid"
    GridFrame.Size = UDim2.new(0.62, -6, 1, 0)
    GridFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    GridFrame.BorderSizePixel = 0
    GridFrame.ScrollBarThickness = 6
    GridFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 140)
    GridFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    GridFrame.Parent = Content
    Instance.new("UICorner", GridFrame).CornerRadius = UDim.new(0, 10)

    local GridLayout = Instance.new("UIGridLayout")
    GridLayout.CellSize = UDim2.new(0, 130, 0, 150)
    GridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GridLayout.Parent = GridFrame

    local GridPadding = Instance.new("UIPadding")
    GridPadding.PaddingTop = UDim.new(0, 10)
    GridPadding.PaddingLeft = UDim.new(0, 10)
    GridPadding.PaddingRight = UDim.new(0, 10)
    GridPadding.PaddingBottom = UDim.new(0, 10)
    GridPadding.Parent = GridFrame

    -- Right: Info Panel
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Name = "Info"
    InfoFrame.Size = UDim2.new(0.38, -6, 1, 0)
    InfoFrame.Position = UDim2.new(0.62, 6, 0, 0)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    InfoFrame.BorderSizePixel = 0
    InfoFrame.Parent = Content
    Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 10)

    local InfoImage = Instance.new("ImageLabel")
    InfoImage.Name = "Preview"
    InfoImage.Size = UDim2.new(1, -30, 0, 180)
    InfoImage.Position = UDim2.new(0, 15, 0, 15)
    InfoImage.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    InfoImage.Image = ""
    InfoImage.ScaleType = Enum.ScaleType.Fit
    InfoImage.Parent = InfoFrame
    Instance.new("UICorner", InfoImage).CornerRadius = UDim.new(0, 8)

    local InfoName = Instance.new("TextLabel")
    InfoName.Name = "AssetName"
    InfoName.Size = UDim2.new(1, -30, 0, 30)
    InfoName.Position = UDim2.new(0, 15, 0, 205)
    InfoName.BackgroundTransparency = 1
    InfoName.Text = "Select an asset"
    InfoName.TextColor3 = Color3.fromRGB(240, 240, 255)
    InfoName.Font = Enum.Font.GothamBold
    InfoName.TextSize = 16
    InfoName.TextWrapped = true
    InfoName.Parent = InfoFrame

    local InfoId = Instance.new("TextLabel")
    InfoId.Name = "AssetId"
    InfoId.Size = UDim2.new(1, -30, 0, 22)
    InfoId.Position = UDim2.new(0, 15, 0, 238)
    InfoId.BackgroundTransparency = 1
    InfoId.Text = "ID: -"
    InfoId.TextColor3 = Color3.fromRGB(160, 160, 180)
    InfoId.Font = Enum.Font.Gotham
    InfoId.TextSize = 13
    InfoId.Parent = InfoFrame

    local InsertBtn = Instance.new("TextButton")
    InsertBtn.Size = UDim2.new(1, -30, 0, 38)
    InsertBtn.Position = UDim2.new(0, 15, 0, 280)
    InsertBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    InsertBtn.Text = "Insert Asset"
    InsertBtn.TextColor3 = Color3.new(1, 1, 1)
    InsertBtn.Font = Enum.Font.GothamBold
    InsertBtn.TextSize = 15
    InsertBtn.Parent = InfoFrame
    Instance.new("UICorner", InsertBtn).CornerRadius = UDim.new(0, 8)

    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Size = UDim2.new(1, -30, 0, 38)
    SaveBtn.Position = UDim2.new(0, 15, 0, 328)
    SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
    SaveBtn.Text = "Save to Saved"
    SaveBtn.TextColor3 = Color3.new(1, 1, 1)
    SaveBtn.Font = Enum.Font.GothamBold
    SaveBtn.TextSize = 15
    SaveBtn.Parent = InfoFrame
    Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 8)

    InsertBtn.MouseButton1Click:Connect(function()
        if selectedAsset then
            InsertAsset(selectedAsset.Id)
        end
    end)

    SaveBtn.MouseButton1Click:Connect(function()
        if selectedAsset then
            local already = false
            for _, a in ipairs(SavedAssets) do
                if a.Id == selectedAsset.Id then
                    already = true
                    break
                end
            end
            if not already then
                table.insert(SavedAssets, {Id = selectedAsset.Id, Name = selectedAsset.Name})
                SaveSaved()
                Rayfield:Notify({Title = "Saved", Content = selectedAsset.Name .. " added to Saved", Duration = 3})
            else
                Rayfield:Notify({Title = "Already Saved", Content = "This asset is already in your list", Duration = 3})
            end
        end
    end)

    -- Refresh function
    function RefreshAssetList()
        for _, child in ipairs(GridFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local list = {}
        if currentCategory == "Saved" then
            list = SavedAssets
        else
            list = AssetDatabase[currentCategory] or {}
        end

        for i, asset in ipairs(list) do
            local card = Instance.new("TextButton")
            card.Size = UDim2.new(0, 130, 0, 150)
            card.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            card.Text = ""
            card.AutoButtonColor = false
            card.LayoutOrder = i
            card.Parent = GridFrame
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

            local thumb = Instance.new("ImageLabel")
            thumb.Size = UDim2.new(1, -12, 0, 100)
            thumb.Position = UDim2.new(0, 6, 0, 6)
            thumb.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            thumb.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. asset.Id .. "&width=150&height=150&format=png"
            thumb.ScaleType = Enum.ScaleType.Fit
            thumb.Parent = card
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 6)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -8, 0, 32)
            nameLbl.Position = UDim2.new(0, 4, 1, -38)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = asset.Name
            nameLbl.TextColor3 = Color3.fromRGB(220, 220, 240)
            nameLbl.Font = Enum.Font.Gotham
            nameLbl.TextSize = 12
            nameLbl.TextWrapped = true
            nameLbl.Parent = card

            card.MouseButton1Click:Connect(function()
                selectedAsset = asset
                InfoName.Text = asset.Name
                InfoId.Text = "ID: " .. asset.Id
                InfoImage.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. asset.Id .. "&width=420&height=420&format=png"
            end)
        end

        -- Update canvas size
        task.wait()
        GridFrame.CanvasSize = UDim2.new(0, 0, 0, GridLayout.AbsoluteContentSize.Y + 20)
    end

    setCategory("Models")
end

-- ============================================================
-- RAYFIELD WINDOW
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "Studio Script",
    LoadingTitle = "Studio Script",
    LoadingSubtitle = "by ItsKyanBence",
    ShowText = "Rayfield",
    Theme = "Default",
})

local Tab = Window:CreateTab("Main", "home")
local Tab2 = Window:CreateTab("Bot", "bot")
local Tab3 = Window:CreateTab("Settings", "Settings")
local Tab4 = Window:CreateTab("Info", "Info")

-- ==================== TAB 1 - MAIN ====================
local AssetIdValue = ""

Tab:CreateInput({
    Name = "Assets id",
    CurrentValue = "",
    PlaceholderText = "Paste Asset Id Here",
    RemoveTextAfterFocusLost = false,
    Flag = "StoreId",
    Callback = function(Text)
        AssetIdValue = Text
    end,
})

Tab:CreateButton({
    Name = "Insert Id",
    Callback = function()
        local id = AssetIdValue
        -- also try flag
        if (not id or id == "") and Rayfield.Flags and Rayfield.Flags["StoreId"] then
            id = Rayfield.Flags["StoreId"].CurrentValue
        end
        if not id or id == "" then
            Rayfield:Notify({Title = "Error", Content = "Please enter an Asset ID first", Duration = 4})
            print("[StudioScript] No Asset ID entered")
            return
        end
        InsertAsset(id)
    end,
})

Tab:CreateButton({
    Name = "Open Toolbox",
    Callback = function()
        CreateToolbox()
        Rayfield:Notify({Title = "Toolbox", Content = "Studio Toolbox opened!", Duration = 3})
    end,
})

-- ==================== TAB 2 - BOT ====================
Tab2:CreateButton({
    Name = "Derz AI",
    Callback = function()
        Rayfield:Notify({Title = "Derz AI", Content = "Derz AI is currently offline / placeholder", Duration = 4})
        print("[StudioScript] Derz AI clicked")
    end,
})

Tab2:CreateButton({
    Name = "Studio Lite AI",
    Callback = function()
        Rayfield:Notify({Title = "Studio Lite AI", Content = "Studio Lite AI is currently offline / placeholder", Duration = 4})
        print("[StudioScript] Studio Lite AI clicked")
    end,
})

Tab2:CreateButton({
    Name = "Part Editor AI",
    Callback = function()
        Rayfield:Notify({Title = "Part Editor AI", Content = "Part Editor AI is currently offline / placeholder", Duration = 4})
        print("[StudioScript] Part Editor AI clicked")
    end,
})

Tab2:CreateButton({
    Name = "Builder AI",
    Callback = function()
        Rayfield:Notify({Title = "Builder AI", Content = "Builder AI is currently offline / placeholder", Duration = 4})
        print("[StudioScript] Builder AI clicked")
    end,
})

-- ==================== TAB 3 - SETTINGS ====================
local AutoRejoin = false

Tab3:CreateToggle({
    Name = "Auto Rejoin When Kicked",
    CurrentValue = false,
    Flag = "auto_rejoin",
    Callback = function(Value)
        AutoRejoin = Value
        if Value then
            print("[StudioScript] Auto Rejoin enabled")
        else
            print("[StudioScript] Auto Rejoin disabled")
        end
    end,
})

-- Simple auto rejoin listener
game:GetService("CoreGui").RobloxPromptGui.DescendantAdded:Connect(function(desc)
    if AutoRejoin and desc.Name == "ErrorPrompt" then
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
end)

Tab3:CreateButton({
    Name = "Rejoin",
    Callback = function()
        Rayfield:Notify({Title = "Rejoining...", Content = "Teleporting back to this place", Duration = 3})
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
})

Tab3:CreateButton({
    Name = "Join Discord Server",
    Callback = function()
        local invite = "https://discord.gg/your-invite" -- change this
        if setclipboard then
            setclipboard(invite)
            Rayfield:Notify({Title = "Discord", Content = "Invite copied to clipboard!", Duration = 4})
        else
            print("[StudioScript] Discord Invite:", invite)
            Rayfield:Notify({Title = "Discord", Content = "Invite printed to console", Duration = 4})
        end
    end,
})

-- ==================== TAB 4 - INFO ====================
Tab4:CreateButton({
    Name = "Owners",
    Callback = function()
        print("=================================")
        print("Owner  : Eyfanboy09")
        print("Tester : TheSledM")
        print("=================================")
        Rayfield:Notify({Title = "Owners", Content = "Eyfanboy09 & TheSledM", Duration = 4})
    end,
})

Tab4:CreateButton({
    Name = "Channel",
    Callback = function()
        print("Channel : ItsKyanBence")
        Rayfield:Notify({Title = "Channel", Content = "ItsKyanBence", Duration = 4})
    end,
})

-- Ready
print("[StudioScript] Loaded | Owners: Eyfanboy09 | Tester: TheSledM | Channel: ItsKyanBence")
Rayfield:Notify({
    Title = "Studio Script Ready",
    Content = "Use Main tab to insert assets or open Toolbox",
    Duration = 5
})
