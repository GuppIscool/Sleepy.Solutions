local Components = {}
local TweenService = game:GetService("TweenService")

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/config.lua"))()
local Colors = Config.Colors

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

function Components.CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, -8, 0, 32)
    button.BackgroundColor3 = Colors.Primary
    button.Text = text
    button.TextColor3 = Colors.TextPrimary
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.PrimaryLight
    stroke.Thickness = 0
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = Colors.PrimaryLight}, 0.12)
        Tween(stroke, {Thickness = 1}, 0.12)
    end)

    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = Colors.Primary}, 0.12)
        Tween(stroke, {Thickness = 0}, 0.12)
    end)

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

function Components.CreateToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Size = UDim2.new(1, -8, 0, 32)
    toggleFrame.BackgroundColor3 = Colors.SurfaceLight
    toggleFrame.BackgroundTransparency = 0.5
    toggleFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -56, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleBG = Instance.new("TextButton")
    toggleBG.Name = "ToggleBG"
    toggleBG.Size = UDim2.new(0, 36, 0, 18)
    toggleBG.Position = UDim2.new(1, -44, 0.5, -9)
    toggleBG.BackgroundColor3 = default and Colors.Primary or Colors.SurfaceLight
    toggleBG.Text = ""
    toggleBG.AutoButtonColor = false
    toggleBG.Parent = toggleFrame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 9)
    bgCorner.Parent = toggleBG

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 14, 0, 14)
    toggleCircle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    toggleCircle.BackgroundColor3 = Colors.TextPrimary
    toggleCircle.Parent = toggleBG

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 7)
    circleCorner.Parent = toggleCircle

    local isToggled = default or false

    toggleBG.MouseButton1Click:Connect(function()
        isToggled = not isToggled

        if isToggled then
            Tween(toggleBG, {BackgroundColor3 = Colors.Primary}, 0.18)
            Tween(toggleCircle, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.18)
        else
            Tween(toggleBG, {BackgroundColor3 = Colors.SurfaceLight}, 0.18)
            Tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.18)
        end

        if callback then
            callback(isToggled)
        end
    end)

    return toggleFrame
end

function Components.CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"
    sliderFrame.Size = UDim2.new(1, -8, 0, 48)
    sliderFrame.BackgroundColor3 = Colors.SurfaceLight
    sliderFrame.BackgroundTransparency = 0.5
    sliderFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = sliderFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local sliderBG = Instance.new("Frame")
    sliderBG.Name = "SliderBG"
    sliderBG.Size = UDim2.new(1, -20, 0, 6)
    sliderBG.Position = UDim2.new(0, 10, 0, 30)
    sliderBG.BackgroundColor3 = Colors.Background
    sliderBG.Parent = sliderFrame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderBG

    local fillRatio = math.clamp((default - min) / (max - min), 0, 1)

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new(fillRatio, 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.Parent = sliderBG

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Handle"
    sliderButton.Size = UDim2.new(0, 14, 0, 14)
    sliderButton.Position = UDim2.new(fillRatio, -7, 0.5, -7)
    sliderButton.BackgroundColor3 = Colors.TextPrimary
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.ZIndex = 2
    sliderButton.Parent = sliderBG

    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 7)
    handleCorner.Parent = sliderButton

    local handleStroke = Instance.new("UIStroke")
    handleStroke.Color = Colors.Primary
    handleStroke.Thickness = 2
    handleStroke.Parent = sliderButton

    local dragging = false

    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    local inputConn
    inputConn = game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local moveConn
    moveConn = game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = sliderBG.AbsolutePosition.X
            local absSize = sliderBG.AbsoluteSize.X
            local relativeX = math.clamp((input.Position.X - absPos) / absSize, 0, 1)

            local value = min + (max - min) * relativeX
            value = math.floor(value * 10) / 10

            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -7, 0.5, -7)
            label.Text = text .. ": " .. tostring(value)

            if callback then
                callback(value)
            end
        end
    end)

    return sliderFrame
end

function Components.CreateColorPicker(parent, text, default, callback)
    local pickerFrame = Instance.new("Frame")
    pickerFrame.Name = "ColorPicker"
    pickerFrame.Size = UDim2.new(1, -8, 0, 32)
    pickerFrame.BackgroundColor3 = Colors.SurfaceLight
    pickerFrame.BackgroundTransparency = 0.5
    pickerFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = pickerFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -56, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = pickerFrame

    local colorBox = Instance.new("TextButton")
    colorBox.Name = "ColorBox"
    colorBox.Size = UDim2.new(0, 24, 0, 20)
    colorBox.Position = UDim2.new(1, -34, 0.5, -10)
    colorBox.BackgroundColor3 = default or Colors.Primary
    colorBox.Text = ""
    colorBox.AutoButtonColor = false
    colorBox.Parent = pickerFrame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = colorBox

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Colors.TextSecondary
    boxStroke.Thickness = 1
    boxStroke.Parent = colorBox

    local isOpen = false
    local popup = nil

    local presetColors = {
        Color3.fromRGB(124, 58, 237),
        Color3.fromRGB(192, 132, 252),
        Color3.fromRGB(76, 175, 80),
        Color3.fromRGB(255, 193, 7),
        Color3.fromRGB(244, 67, 54),
        Color3.fromRGB(33, 150, 243),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(0, 0, 0),
    }

    colorBox.MouseButton1Click:Connect(function()
        isOpen = not isOpen

        if isOpen then
            popup = Instance.new("Frame")
            popup.Name = "Popup"
            popup.Size = UDim2.new(0, 140, 0, 72)
            popup.Position = UDim2.new(1, -148, 0, 36)
            popup.BackgroundColor3 = Colors.Background
            popup.ZIndex = 50
            popup.Parent = pickerFrame

            local popCorner = Instance.new("UICorner")
            popCorner.CornerRadius = UDim.new(0, 6)
            popCorner.Parent = popup

            local popStroke = Instance.new("UIStroke")
            popStroke.Color = Colors.SurfaceLight
            popStroke.Thickness = 1
            popStroke.Parent = popup

            for i, color in ipairs(presetColors) do
                local colorBtn = Instance.new("TextButton")
                colorBtn.Size = UDim2.new(0, 24, 0, 24)
                colorBtn.Position = UDim2.new(0, 8 + ((i - 1) % 4) * 30, 0, 8 + math.floor((i - 1) / 4) * 30)
                colorBtn.BackgroundColor3 = color
                colorBtn.Text = ""
                colorBtn.ZIndex = 51
                colorBtn.AutoButtonColor = false
                colorBtn.Parent = popup

                local cBtnCorner = Instance.new("UICorner")
                cBtnCorner.CornerRadius = UDim.new(0, 4)
                cBtnCorner.Parent = colorBtn

                local cBtnStroke = Instance.new("UIStroke")
                cBtnStroke.Color = Colors.SurfaceLight
                cBtnStroke.Thickness = 1
                cBtnStroke.ZIndex = 51
                cBtnStroke.Parent = colorBtn

                colorBtn.MouseEnter:Connect(function()
                    Tween(cBtnStroke, {Color = Colors.TextPrimary}, 0.1)
                end)

                colorBtn.MouseLeave:Connect(function()
                    Tween(cBtnStroke, {Color = Colors.SurfaceLight}, 0.1)
                end)

                colorBtn.MouseButton1Click:Connect(function()
                    colorBox.BackgroundColor3 = color
                    popup:Destroy()
                    popup = nil
                    isOpen = false

                    if callback then
                        callback(color)
                    end
                end)
            end
        else
            if popup then
                popup:Destroy()
                popup = nil
            end
        end
    end)

    return pickerFrame
end

function Components.CreateDropdown(parent, text, options, default, callback)
    local dropFrame = Instance.new("Frame")
    dropFrame.Name = "Dropdown"
    dropFrame.Size = UDim2.new(1, -8, 0, 32)
    dropFrame.BackgroundColor3 = Colors.SurfaceLight
    dropFrame.BackgroundTransparency = 0.5
    dropFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = dropFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropFrame

    local selectedValue = default or options[1]

    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = "DropBtn"
    dropBtn.Size = UDim2.new(0.45, -4, 0, 22)
    dropBtn.Position = UDim2.new(0.55, 0, 0.5, -11)
    dropBtn.BackgroundColor3 = Colors.Background
    dropBtn.Text = selectedValue
    dropBtn.TextColor3 = Colors.TextPrimary
    dropBtn.Font = Enum.Font.GothamMedium
    dropBtn.TextSize = 11
    dropBtn.AutoButtonColor = false
    dropBtn.Parent = dropFrame

    local dropBtnCorner = Instance.new("UICorner")
    dropBtnCorner.CornerRadius = UDim.new(0, 4)
    dropBtnCorner.Parent = dropBtn

    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 16, 1, 0)
    arrow.Position = UDim2.new(1, -18, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = Colors.TextSecondary
    arrow.TextSize = 10
    arrow.Font = Enum.Font.GothamBold
    arrow.Parent = dropBtn

    local isOpen = false
    local listFrame = nil

    dropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen

        if isOpen then
            listFrame = Instance.new("Frame")
            listFrame.Name = "List"
            listFrame.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, #options * 24)
            listFrame.Position = UDim2.new(0, 0, 1, 4)
            listFrame.BackgroundColor3 = Colors.Background
            listFrame.ZIndex = 50
            listFrame.Parent = dropBtn

            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 4)
            listCorner.Parent = listFrame

            local listStroke = Instance.new("UIStroke")
            listStroke.Color = Colors.SurfaceLight
            listStroke.Thickness = 1
            listStroke.Parent = listFrame

            for i, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 24)
                optBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 24)
                optBtn.BackgroundColor3 = Colors.Background
                optBtn.Text = option
                optBtn.TextColor3 = Colors.TextPrimary
                optBtn.Font = Enum.Font.GothamMedium
                optBtn.TextSize = 11
                optBtn.ZIndex = 51
                optBtn.AutoButtonColor = false
                optBtn.Parent = listFrame

                optBtn.MouseEnter:Connect(function()
                    Tween(optBtn, {BackgroundColor3 = Colors.SurfaceLight}, 0.08)
                end)

                optBtn.MouseLeave:Connect(function()
                    Tween(optBtn, {BackgroundColor3 = Colors.Background}, 0.08)
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selectedValue = option
                    dropBtn.Text = option
                    listFrame:Destroy()
                    listFrame = nil
                    isOpen = false

                    if callback then
                        callback(option)
                    end
                end)
            end
        else
            if listFrame then
                listFrame:Destroy()
                listFrame = nil
            end
        end
    end)

    return dropFrame
end

function Components.CreateSection(parent, text)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "Section"
    sectionFrame.Size = UDim2.new(1, -8, 0, 24)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Parent = parent

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 1, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = string.upper(text)
    sectionLabel.TextColor3 = Colors.TextSecondary
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextSize = 10
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Colors.SurfaceLight
    line.BackgroundTransparency = 0.5
    line.Parent = sectionFrame

    return sectionFrame
end

return Components
