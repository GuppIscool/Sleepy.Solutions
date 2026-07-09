local UI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/config.lua"))()
local Animations = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/animations.lua"))()

local Colors = Config.Colors
local WindowConfig = Config.Window

UI.Window = nil
UI.Tabs = {}
UI.CurrentTab = nil
UI.TabButtons = {}
UI.TabContents = {}
UI.ToggleKey = Enum.KeyCode.Insert

function UI.CreateWindow()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SleepySolutions"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = WindowConfig.Size
    mainFrame.Position = WindowConfig.Position
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Colors.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Colors.Surface
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = ""
    titleLabel.TextColor3 = Colors.TextPrimary
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local sleepyLabel = Instance.new("TextLabel")
    sleepyLabel.Name = "Sleepy"
    sleepyLabel.Size = UDim2.new(0, 70, 1, 0)
    sleepyLabel.Position = UDim2.new(0, 0, 0, 0)
    sleepyLabel.BackgroundTransparency = 1
    sleepyLabel.Text = "Sleepy"
    sleepyLabel.TextColor3 = Colors.TextPrimary
    sleepyLabel.Font = Enum.Font.GothamBold
    sleepyLabel.TextSize = 16
    sleepyLabel.TextXAlignment = Enum.TextXAlignment.Left
    sleepyLabel.Parent = titleLabel
    
    local dotLabel = Instance.new("TextLabel")
    dotLabel.Name = "Dot"
    dotLabel.Size = UDim2.new(0, 10, 1, 0)
    dotLabel.Position = UDim2.new(0, 65, 0, 0)
    dotLabel.BackgroundTransparency = 1
    dotLabel.Text = "."
    dotLabel.TextColor3 = Colors.TextPrimary
    dotLabel.Font = Enum.Font.GothamBold
    dotLabel.TextSize = 16
    dotLabel.Parent = titleLabel
    
    local solutionsLabel = Instance.new("TextLabel")
    solutionsLabel.Name = "Solutions"
    solutionsLabel.Size = UDim2.new(0, 70, 1, 0)
    solutionsLabel.Position = UDim2.new(0, 72, 0, 0)
    solutionsLabel.BackgroundTransparency = 1
    solutionsLabel.Text = "Solutions"
    solutionsLabel.TextColor3 = Colors.Accent
    solutionsLabel.Font = Enum.Font.GothamBold
    solutionsLabel.TextSize = 16
    solutionsLabel.TextXAlignment = Enum.TextXAlignment.Left
    solutionsLabel.Parent = titleLabel
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    minimizeBtn.BackgroundColor3 = Colors.SurfaceLight
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = Colors.TextPrimary
    minimizeBtn.Font = Enum.Font.GothamMedium
    minimizeBtn.TextSize = 14
    minimizeBtn.Parent = titleBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minimizeBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Colors.Error
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Colors.TextPrimary
    closeBtn.Font = Enum.Font.GothamMedium
    closeBtn.TextSize = 14
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -20, 0, 35)
    tabBar.Position = UDim2.new(0, 10, 0, 45)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = mainFrame
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -20, 1, -90)
    tabContainer.Position = UDim2.new(0, 10, 0, 85)
    tabContainer.BackgroundColor3 = Colors.Surface
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = tabContainer
    
    UI.Window = mainFrame
    UI.ScreenGui = screenGui
    UI.TabBar = tabBar
    UI.TabContainer = tabContainer
    UI.Tabs = {}
    UI.TabButtons = {}
    UI.TabContents = {}
    
    local tabWidth = 1 / #Config.Tabs
    
    for i, tabName in ipairs(Config.Tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Size = UDim2.new(tabWidth, -5, 1, 0)
        tabButton.Position = UDim2.new((i - 1) * tabWidth, 0, 0, 0)
        tabButton.BackgroundTransparency = 1
        tabButton.Text = tabName
        tabButton.TextColor3 = Colors.TextSecondary
        tabButton.Font = Enum.Font.GothamMedium
        tabButton.TextSize = 13
        tabButton.Parent = tabBar
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Size = UDim2.new(1, -10, 1, -10)
        tabContent.Position = UDim2.new(0, 5, 0, 5)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Colors.Primary
        tabContent.BorderSizePixel = 0
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = tabContainer
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = tabContent
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 5)
        padding.PaddingTop = UDim.new(0, 5)
        padding.Parent = tabContent
        
        UI.Tabs[tabName] = tabContent
        UI.TabButtons[tabName] = tabButton
        UI.TabContents[tabName] = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            UI.SelectTab(tabName)
        end)
        
        tabButton.MouseEnter:Connect(function()
            if UI.CurrentTab ~= tabName then
                Animations.ColorChange(tabButton, {TextColor3 = Colors.TextPrimary}, 0.15)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if UI.CurrentTab ~= tabName then
                Animations.ColorChange(tabButton, {TextColor3 = Colors.TextSecondary}, 0.15)
            end
        end)
    end
    
    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.Size = UDim2.new(tabWidth, -10, 0, 2)
    underline.Position = UDim2.new(0, 5, 1, -2)
    underline.BackgroundColor3 = Colors.Primary
    underline.Parent = tabBar
    
    local underlineCorner = Instance.new("UICorner")
    underlineCorner.CornerRadius = UDim.new(0, 1)
    underlineCorner.Parent = underline
    
    UI.Underline = underline
    UI.UnderlineWidth = tabWidth
    
    minimizeBtn.MouseButton1Click:Connect(function()
        Animations.Tween(mainFrame, {Size = UDim2.new(WindowConfig.Size.X.Scale, WindowConfig.Size.X.Offset, 0, 40)}, 0.3)
        task.wait(0.3)
        tabContainer.Visible = false
        for _, btn in pairs(UI.TabButtons) do
            btn.Visible = false
        end
        tabBar.Visible = false
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Animations.Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    Animations.Tween(mainFrame, {Size = WindowConfig.Size}, 0.4)
    
    UI.SelectTab(Config.Tabs[1])
    
    return UI
end

function UI.SelectTab(tabName)
    if UI.CurrentTab == tabName then return end
    
    UI.CurrentTab = tabName
    
    for name, button in pairs(UI.TabButtons) do
        if name == tabName then
            Animations.ColorChange(button, {TextColor3 = Colors.Primary}, 0.2)
        else
            Animations.ColorChange(button, {TextColor3 = Colors.TextSecondary}, 0.2)
        end
    end
    
    local tabIndex = table.find(Config.Tabs, tabName)
    if tabIndex then
        local targetX = (tabIndex - 1) * UI.UnderlineWidth
        Animations.Tween(UI.Underline, {Position = UDim2.new(targetX, 5, 1, -2)}, 0.2)
    end
    
    for name, content in pairs(UI.TabContents) do
        if name == tabName then
            content.Visible = true
            content.GroupTransparency = 1
            Animations.Tween(content, {GroupTransparency = 0}, 0.2)
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
