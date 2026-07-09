local UI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/config.lua"))()

local Colors = Config.Colors
local WindowConfig = Config.Window

UI.Window = nil
UI.ScreenGui = nil
UI.Tabs = {}
UI.CurrentTab = nil
UI.TabButtons = {}
UI.TabContents = {}
UI.Underline = nil
UI.UnderlineWidth = 0
UI.IsMinimized = false

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

function UI.CreateWindow()
    if UI.ScreenGui then
        UI.ScreenGui:Destroy()
    end
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SleepySolutions"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Colors.SurfaceLight
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = Colors.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 10)
    titleBarCorner.Parent = titleBar
    
    local titleBarFix = Instance.new("Frame")
    titleBarFix.Size = UDim2.new(1, 0, 0, 14)
    titleBarFix.Position = UDim2.new(0, 0, 1, -14)
    titleBarFix.BackgroundColor3 = Colors.Surface
    titleBarFix.BorderSizePixel = 0
    titleBarFix.Parent = titleBar
    
    local titleContainer = Instance.new("Frame")
    titleContainer.Name = "TitleContainer"
    titleContainer.Size = UDim2.new(0, 200, 1, 0)
    titleContainer.Position = UDim2.new(0, 14, 0, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = titleBar
    
    local sleepyText = Instance.new("TextLabel")
    sleepyText.Name = "Sleepy"
    sleepyText.Size = UDim2.new(0, 55, 1, 0)
    sleepyText.Position = UDim2.new(0, 0, 0, 0)
    sleepyText.BackgroundTransparency = 1
    sleepyText.Text = "Sleepy"
    sleepyText.TextColor3 = Colors.TextPrimary
    sleepyText.Font = Enum.Font.GothamBold
    sleepyText.TextSize = 15
    sleepyText.TextXAlignment = Enum.TextXAlignment.Left
    sleepyText.Parent = titleContainer
    
    local dotText = Instance.new("TextLabel")
    dotText.Name = "Dot"
    dotText.Size = UDim2.new(0, 8, 1, 0)
    dotText.Position = UDim2.new(0, 52, 0, 0)
    dotText.BackgroundTransparency = 1
    dotText.Text = "."
    dotText.TextColor3 = Colors.TextPrimary
    dotText.Font = Enum.Font.GothamBold
    dotText.TextSize = 15
    dotText.Parent = titleContainer
    
    local solutionsText = Instance.new("TextLabel")
    solutionsText.Name = "Solutions"
    solutionsText.Size = UDim2.new(0, 70, 1, 0)
    solutionsText.Position = UDim2.new(0, 58, 0, 0)
    solutionsText.BackgroundTransparency = 1
    solutionsText.Text = "Solutions"
    solutionsText.TextColor3 = Colors.Accent
    solutionsText.Font = Enum.Font.GothamBold
    solutionsText.TextSize = 15
    solutionsText.TextXAlignment = Enum.TextXAlignment.Left
    solutionsText.Parent = titleContainer
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Colors.TextPrimary
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinBtn"
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -72, 0, 4)
    minBtn.BackgroundColor3 = Colors.SurfaceLight
    minBtn.Text = "-"
    minBtn.TextColor3 = Colors.TextPrimary
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.Parent = titleBar
    
    local minBtnCorner = Instance.new("UICorner")
    minBtnCorner.CornerRadius = UDim.new(0, 6)
    minBtnCorner.Parent = minBtn
    
    local tabBarFrame = Instance.new("Frame")
    tabBarFrame.Name = "TabBarFrame"
    tabBarFrame.Size = UDim2.new(1, -24, 0, 32)
    tabBarFrame.Position = UDim2.new(0, 12, 0, 42)
    tabBarFrame.BackgroundTransparency = 1
    tabBarFrame.Parent = mainFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -24, 1, -84)
    contentFrame.Position = UDim2.new(0, 12, 0, 78)
    contentFrame.BackgroundColor3 = Colors.Surface
    contentFrame.BorderSizePixel = 0
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = mainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentFrame
    
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Colors.SurfaceLight
    contentStroke.Thickness = 1
    contentStroke.Parent = contentFrame
    
    UI.Window = mainFrame
    UI.ScreenGui = screenGui
    UI.TabBar = tabBarFrame
    UI.ContentFrame = contentFrame
    UI.Tabs = {}
    UI.TabButtons = {}
    UI.TabContents = {}
    UI.IsMinimized = false
    
    local tabNames = Config.Tabs
    local tabWidth = 1 / #tabNames
    
    for i, tabName in ipairs(tabNames) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName .. "Btn"
        tabBtn.Size = UDim2.new(tabWidth, -4, 1, 0)
        tabBtn.Position = UDim2.new((i - 1) * tabWidth, 0, 0, 0)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Colors.TextSecondary
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 13
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabBarFrame
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Size = UDim2.new(1, -8, 1, -8)
        tabContent.Position = UDim2.new(0, 4, 0, 4)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Colors.Primary
        tabContent.BorderSizePixel = 0
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = contentFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Name = "Layout"
        listLayout.Padding = UDim.new(0, 6)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        listLayout.Parent = tabContent
        
        local listPadding = Instance.new("UIPadding")
        listPadding.PaddingLeft = UDim.new(0, 4)
        listPadding.PaddingTop = UDim.new(0, 4)
        listPadding.PaddingRight = UDim.new(0, 4)
        listPadding.Parent = tabContent
        
        UI.Tabs[tabName] = tabContent
        UI.TabButtons[tabName] = tabBtn
        UI.TabContents[tabName] = tabContent
        
        tabBtn.MouseButton1Click:Connect(function()
            UI.SelectTab(tabName)
        end)
        
        tabBtn.MouseEnter:Connect(function()
            if UI.CurrentTab ~= tabName then
                Tween(tabBtn, {TextColor3 = Colors.TextPrimary}, 0.15)
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if UI.CurrentTab ~= tabName then
                Tween(tabBtn, {TextColor3 = Colors.TextSecondary}, 0.15)
            end
        end)
    end
    
    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.Size = UDim2.new(tabWidth, -8, 0, 2)
    underline.Position = UDim2.new(0, 4, 1, -2)
    underline.AnchorPoint = Vector2.new(0, 0)
    underline.BackgroundColor3 = Colors.Primary
    underline.BorderSizePixel = 0
    underline.Parent = tabBarFrame
    
    local underlineCorner = Instance.new("UICorner")
    underlineCorner.CornerRadius = UDim.new(0, 1)
    underlineCorner.Parent = underline
    
    UI.Underline = underline
    UI.UnderlineWidth = tabWidth
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(230, 60, 60)}, 0.15)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
        UI.Window = nil
        UI.ScreenGui = nil
    end)
    
    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundColor3 = Colors.TextSecondary}, 0.15)
    end)
    
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundColor3 = Colors.SurfaceLight}, 0.15)
    end)
    
    minBtn.MouseButton1Click:Connect(function()
        if UI.IsMinimized then
            UI.IsMinimized = false
            Tween(mainFrame, {Size = UDim2.new(0, 500, 0, 350)}, 0.3)
            task.wait(0.1)
            tabBarFrame.Visible = true
            contentFrame.Visible = true
        else
            UI.IsMinimized = true
            tabBarFrame.Visible = false
            contentFrame.Visible = false
            Tween(mainFrame, {Size = UDim2.new(0, 500, 0, 38)}, 0.3)
        end
    end)
    
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(mainFrame, {Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, -250, 0.5, -175)}, 0.4)
    
    task.wait(0.1)
    UI.SelectTab(tabNames[1])
    
    return UI
end

function UI.SelectTab(tabName)
    if not UI.Tabs[tabName] then return end
    if UI.CurrentTab == tabName then return end
    
    UI.CurrentTab = tabName
    
    for name, btn in pairs(UI.TabButtons) do
        if name == tabName then
            Tween(btn, {TextColor3 = Colors.Primary}, 0.2)
        else
            Tween(btn, {TextColor3 = Colors.TextSecondary}, 0.2)
        end
    end
    
    local tabIndex = table.find(Config.Tabs, tabName)
    if tabIndex and UI.Underline then
        local targetX = (tabIndex - 1) * UI.UnderlineWidth
        Tween(UI.Underline, {Position = UDim2.new(targetX, 4, 1, -2)}, 0.25)
    end
    
    for name, content in pairs(UI.TabContents) do
        if name == tabName then
            content.Visible = true
            content.CanvasPosition = Vector2.new(0, 0)
        else
            content.Visible = false
        end
    end
end

function UI.GetTab(tabName)
    return UI.Tabs[tabName]
end

function UI.SetupKeybinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        for _, key in ipairs(Config.Keybinds.Toggle) do
            if input.KeyCode == key then
                if UI.Window then
                    UI.Window.Visible = not UI.Window.Visible
                end
            end
        end
    end)
end

return UI
