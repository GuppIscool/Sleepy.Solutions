local UI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/config.lua"))()
local Colors = Config.Colors

UI.Window = nil
UI.ScreenGui = nil
UI.CurrentTab = nil
UI.CurrentSection = nil

local function Tween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
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
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Colors.Border
    mainBorder.Thickness = 1
    mainBorder.Parent = mainFrame

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 32)
    topBar.BackgroundColor3 = Colors.Surface
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame

    local titleContainer = Instance.new("Frame")
    titleContainer.Name = "TitleContainer"
    titleContainer.Size = UDim2.new(0, 200, 1, 0)
    titleContainer.Position = UDim2.new(0, 10, 0, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Sleepy.Solutions"
    titleLabel.TextColor3 = Colors.TextPrimary
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.RichText = true
    titleLabel.Parent = titleContainer

    titleLabel.Text = '<font color="rgb(200,200,200)">Sleepy</font><font color="rgb(200,200,200)">.</font><font color="rgb(180,130,255)">Solutions</font><font color="rgb(80,80,80)"> | HoPlex</font>'

    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(0, 300, 1, 0)
    tabBar.Position = UDim2.new(0, 220, 0, 0)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = topBar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 0)
    tabLayout.Parent = tabBar

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -2, 1, -34)
    contentArea.Position = UDim2.new(0, 1, 0, 33)
    contentArea.BackgroundColor3 = Colors.Background
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    contentArea.Parent = mainFrame

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 130, 1, 0)
    sidebar.BackgroundColor3 = Colors.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentArea

    local sidebarBorder = Instance.new("UIStroke")
    sidebarBorder.Color = Colors.Border
    sidebarBorder.Thickness = 1
    sidebarBorder.Parent = sidebar

    local sidebarContent = Instance.new("Frame")
    sidebarContent.Name = "SidebarContent"
    sidebarContent.Size = UDim2.new(1, -8, 1, -8)
    sidebarContent.Position = UDim2.new(0, 4, 0, 4)
    sidebarContent.BackgroundTransparency = 1
    sidebarContent.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Name = "Layout"
    sidebarLayout.Padding = UDim.new(0, 2)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebarContent

    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.Size = UDim2.new(1, -132, 1, 0)
    mainContent.Position = UDim2.new(0, 132, 0, 0)
    mainContent.BackgroundColor3 = Colors.Background
    mainContent.BorderSizePixel = 0
    mainContent.ClipsDescendants = true
    mainContent.Parent = contentArea

    local contentBorder = Instance.new("UIStroke")
    contentBorder.Color = Colors.Border
    contentBorder.Thickness = 1
    contentBorder.Parent = mainContent

    UI.Window = mainFrame
    UI.ScreenGui = screenGui
    UI.TopBar = topBar
    UI.TabBar = tabBar
    UI.Sidebar = sidebarContent
    UI.MainContent = mainContent
    UI.TabButtons = {}
    UI.SectionButtons = {}
    UI.TabSections = {}
    UI.ContentFrames = {}

    local tabNames = {"Combat", "Visual", "Movement", "Misc"}

    for i, tabName in ipairs(tabNames) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName
        tabBtn.Size = UDim2.new(0, 70, 0, 26)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Colors.TextSecondary
        tabBtn.Font = Enum.Font.Code
        tabBtn.TextSize = 12
        tabBtn.AutoButtonColor = false
        tabBtn.LayoutOrder = i
        tabBtn.Parent = tabBar

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Size = UDim2.new(1, -8, 1, -8)
        tabContent.Position = UDim2.new(0, 4, 0, 4)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = Colors.TextDim
        tabContent.BorderSizePixel = 0
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = mainContent

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Name = "Layout"
        contentLayout.Padding = UDim.new(0, 4)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 4)
        contentPadding.PaddingTop = UDim.new(0, 4)
        contentPadding.PaddingRight = UDim.new(0, 4)
        contentPadding.Parent = tabContent

        UI.TabButtons[tabName] = tabBtn
        UI.ContentFrames[tabName] = tabContent
        UI.TabSections[tabName] = {}

        tabBtn.MouseButton1Click:Connect(function()
            UI.SelectTab(tabName)
        end)

        tabBtn.MouseEnter:Connect(function()
            if UI.CurrentTab ~= tabName then
                Tween(tabBtn, {TextColor3 = Colors.TextPrimary}, 0.1)
            end
        end)

        tabBtn.MouseLeave:Connect(function()
            if UI.CurrentTab ~= tabName then
                Tween(tabBtn, {TextColor3 = Colors.TextSecondary}, 0.1)
            end
        end)
    end

    for tabName, sections in pairs(Config.Tabs) do
        for i, sectionName in ipairs(sections) do
            local sectionBtn = Instance.new("TextButton")
            sectionBtn.Name = sectionName
            sectionBtn.Size = UDim2.new(1, 0, 0, 28)
            sectionBtn.BackgroundColor3 = Colors.Background
            sectionBtn.BackgroundTransparency = 1
            sectionBtn.Text = "  " .. sectionName
            sectionBtn.TextColor3 = Colors.TextSecondary
            sectionBtn.Font = Enum.Font.Code
            sectionBtn.TextSize = 12
            sectionBtn.TextXAlignment = Enum.TextXAlignment.Left
            sectionBtn.AutoButtonColor = false
            sectionBtn.LayoutOrder = i
            sectionBtn.Parent = sidebarContent

            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 3)
            sectionCorner.Parent = sectionBtn

            if not UI.TabSections[tabName] then
                UI.TabSections[tabName] = {}
            end
            UI.TabSections[tabName][sectionName] = sectionBtn

            sectionBtn.MouseEnter:Connect(function()
                if UI.CurrentTab ~= tabName or UI.CurrentSection ~= sectionName then
                    Tween(sectionBtn, {BackgroundTransparency = 0.7, TextColor3 = Colors.TextPrimary}, 0.1)
                end
            end)

            sectionBtn.MouseLeave:Connect(function()
                if UI.CurrentTab ~= tabName or UI.CurrentSection ~= sectionName then
                    Tween(sectionBtn, {BackgroundTransparency = 1, TextColor3 = Colors.TextSecondary}, 0.1)
                end
            end)

            sectionBtn.MouseButton1Click:Connect(function()
                UI.SelectSection(tabName, sectionName)
            end)
        end
    end

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 4)
    closeBtn.BackgroundColor3 = Colors.Error
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Colors.TextPrimary
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextSize = 12
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 3)
    closeCorner.Parent = closeBtn

    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinBtn"
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -58, 0, 4)
    minBtn.BackgroundColor3 = Colors.SurfaceLight
    minBtn.Text = "-"
    minBtn.TextColor3 = Colors.TextPrimary
    minBtn.Font = Enum.Font.Code
    minBtn.TextSize = 14
    minBtn.AutoButtonColor = false
    minBtn.Parent = topBar

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 3)
    minCorner.Parent = minBtn

    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}, 0.1)
    end)

    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Colors.Error}, 0.1)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.25)
        task.wait(0.25)
        screenGui:Destroy()
        UI.Window = nil
        UI.ScreenGui = nil
    end)

    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundColor3 = Colors.TextDim}, 0.1)
    end)

    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundColor3 = Colors.SurfaceLight}, 0.1)
    end)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tabBar.Visible = false
            contentArea.Visible = false
            Tween(mainFrame, {Size = UDim2.new(0, 600, 0, 32)}, 0.2)
        else
            Tween(mainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.2)
            task.wait(0.1)
            tabBar.Visible = true
            contentArea.Visible = true
        end
    end)

    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(mainFrame, {
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200)
    }, 0.35)

    task.wait(0.1)
    UI.SelectTab("Combat")

    return UI
end

function UI.SelectTab(tabName)
    if not UI.TabButtons[tabName] then return end
    if UI.CurrentTab == tabName then return end

    UI.CurrentTab = tabName
    UI.CurrentSection = nil

    for name, btn in pairs(UI.TabButtons) do
        if name == tabName then
            Tween(btn, {TextColor3 = Colors.Accent}, 0.15)
        else
            Tween(btn, {TextColor3 = Colors.TextSecondary}, 0.15)
        end
    end

    for name, content in pairs(UI.ContentFrames) do
        content.Visible = (name == tabName)
    end

    for tab, sections in pairs(UI.TabSections) do
        for sectionName, btn in pairs(sections) do
            if tab == tabName then
                btn.Visible = true
            else
                btn.Visible = false
            end
        end
    end

    local sections = Config.Tabs[tabName]
    if sections and #sections > 0 then
        UI.SelectSection(tabName, sections[1])
    end
end

function UI.SelectSection(tabName, sectionName)
    if not UI.TabSections[tabName] then return end
    if not UI.TabSections[tabName][sectionName] then return end

    UI.CurrentTab = tabName
    UI.CurrentSection = sectionName

    for name, btn in pairs(UI.TabButtons) do
        if name == tabName then
            Tween(btn, {TextColor3 = Colors.Accent}, 0.15)
        else
            Tween(btn, {TextColor3 = Colors.TextSecondary}, 0.15)
        end
    end

    for tab, sections in pairs(UI.TabSections) do
        for secName, btn in pairs(sections) do
            if tab == tabName then
                btn.Visible = true
                if secName == sectionName then
                    Tween(btn, {BackgroundTransparency = 0.5, TextColor3 = Colors.TextPrimary}, 0.1)
                else
                    Tween(btn, {BackgroundTransparency = 1, TextColor3 = Colors.TextSecondary}, 0.1)
                end
            else
                btn.Visible = false
            end
        end
    end

    for name, content in pairs(UI.ContentFrames) do
        if name == tabName then
            content.Visible = true
            for _, child in pairs(content:GetChildren()) do
                if child:IsA("Frame") and child:GetAttribute("Section") then
                    child.Visible = (child:GetAttribute("Section") == sectionName)
                end
            end
        end
    end
end

function UI.GetTab(tabName)
    return UI.ContentFrames[tabName]
end

function UI.CreateSection(tabName, sectionName)
    local content = UI.ContentFrames[tabName]
    if not content then return nil end

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = sectionName .. "Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 0)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame:SetAttribute("Section", sectionName)
    sectionFrame.LayoutOrder = 100
    sectionFrame.Parent = content

    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.Padding = UDim.new(0, 4)
    sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sectionLayout.Parent = sectionFrame

    local sectionPadding = Instance.new("UIPadding")
    sectionPadding.PaddingLeft = UDim.new(0, 4)
    sectionPadding.PaddingTop = UDim.new(0, 4)
    sectionPadding.PaddingRight = UDim.new(0, 4)
    sectionPadding.Parent = sectionFrame

    return sectionFrame
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
