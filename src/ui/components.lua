local Components = {}
local TweenService = game:GetService("TweenService")

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/config.lua"))()
local Colors = Config.Colors

local function Tween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Components.CreateToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 28)
    toggleFrame.BackgroundColor3 = Colors.SurfaceLight
    toggleFrame.BackgroundTransparency = 0.5
    toggleFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleBG = Instance.new("TextButton")
    toggleBG.Name = "ToggleBG"
    toggleBG.Size = UDim2.new(0, 32, 0, 16)
    toggleBG.Position = UDim2.new(1, -40, 0.5, -8)
    toggleBG.BackgroundColor3 = default and Colors.Primary or Colors.Border
    toggleBG.Text = ""
    toggleBG.AutoButtonColor = false
    toggleBG.Parent = toggleFrame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = toggleBG

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 12, 0, 12)
    toggleCircle.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    toggleCircle.BackgroundColor3 = default and Colors.TextPrimary or Colors.TextDim
    toggleCircle.Parent = toggleBG

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 6)
    circleCorner.Parent = toggleCircle

    local isToggled = default or false

    toggleBG.MouseButton1Click:Connect(function()
        isToggled = not isToggled

        if isToggled then
            Tween(toggleBG, {BackgroundColor3 = Colors.Primary}, 0.12)
            Tween(toggleCircle, {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Colors.TextPrimary}, 0.12)
        else
            Tween(toggleBG, {BackgroundColor3 = Colors.Border}, 0.12)
            Tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Colors.TextDim}, 0.12)
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
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundColor3 = Colors.SurfaceLight
    sliderFrame.BackgroundTransparency = 0.5
    sliderFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = sliderFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.6, 0, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.4, -8, 0, 16)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Colors.Accent
    valueLabel.Font = Enum.Font.Code
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame

    local sliderBG = Instance.new("Frame")
    sliderBG.Name = "SliderBG"
    sliderBG.Size = UDim2.new(1, -16, 0, 4)
    sliderBG.Position = UDim2.new(0, 8, 0, 26)
    sliderBG.BackgroundColor3 = Colors.Border
    sliderBG.Parent = sliderFrame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 2)
    sliderCorner.Parent = sliderBG

    local fillRatio = math.clamp((default - min) / (max - min), 0, 1)

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new(fillRatio, 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.Parent = sliderBG

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = sliderFill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Handle"
    sliderButton.Size = UDim2.new(0, 10, 0, 10)
    sliderButton.Position = UDim2.new(fillRatio, -5, 0.5, -5)
    sliderButton.BackgroundColor3 = Colors.TextPrimary
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.ZIndex = 2
    sliderButton.Parent = sliderBG

    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 5)
    handleCorner.Parent = sliderButton

    local dragging = false

    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = sliderBG.AbsolutePosition.X
            local absSize = sliderBG.AbsoluteSize.X
            local relativeX = math.clamp((input.Position.X - absPos) / absSize, 0, 1)

            local value = min + (max - min) * relativeX
            value = math.floor(value * 10) / 10

            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -5, 0.5, -5)
            valueLabel.Text = tostring(value)

            if callback then
                callback(value)
            end
        end
    end)

    return sliderFrame
end

function Components.CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 28)
    button.BackgroundColor3 = Colors.SurfaceLight
    button.Text = text
    button.TextColor3 = Colors.TextPrimary
    button.Font = Enum.Font.Code
    button.TextSize = 11
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = Colors.Border}, 0.1)
    end)

    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = Colors.SurfaceLight}, 0.1)
    end)

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

function Components.CreateColorPicker(parent, text, default, callback)
    local pickerFrame = Instance.new("Frame")
    pickerFrame.Name = "ColorPicker"
    pickerFrame.Size = UDim2.new(1, 0, 0, 28)
    pickerFrame.BackgroundColor3 = Colors.SurfaceLight
    pickerFrame.BackgroundTransparency = 0.5
    pickerFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = pickerFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -42, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = pickerFrame

    local colorBox = Instance.new("TextButton")
    colorBox.Name = "ColorBox"
    colorBox.Size = UDim2.new(0, 20, 0, 16)
    colorBox.Position = UDim2.new(1, -28, 0.5, -8)
    colorBox.BackgroundColor3 = default or Colors.Primary
    colorBox.Text = ""
    colorBox.AutoButtonColor = false
    colorBox.Parent = pickerFrame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 2)
    boxCorner.Parent = colorBox

    local isOpen = false
    local popup = nil

    local presetColors = {
        Color3.fromRGB(130, 90, 220),
        Color3.fromRGB(180, 130, 255),
        Color3.fromRGB(80, 180, 80),
        Color3.fromRGB(220, 180, 50),
        Color3.fromRGB(200, 60, 60),
        Color3.fromRGB(60, 160, 220),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(0, 0, 0),
    }

    colorBox.MouseButton1Click:Connect(function()
        isOpen = not isOpen

        if isOpen then
            popup = Instance.new("Frame")
            popup.Name = "Popup"
            popup.Size = UDim2.new(0, 120, 0, 60)
            popup.Position = UDim2.new(1, -128, 0, 32)
            popup.BackgroundColor3 = Colors.Surface
            popup.ZIndex = 50
            popup.Parent = pickerFrame

            local popCorner = Instance.new("UICorner")
            popCorner.CornerRadius = UDim.new(0, 3)
            popCorner.Parent = popup

            local popStroke = Instance.new("UIStroke")
            popStroke.Color = Colors.Border
            popStroke.Thickness = 1
            popStroke.Parent = popup

            for i, color in ipairs(presetColors) do
                local colorBtn = Instance.new("TextButton")
                colorBtn.Size = UDim2.new(0, 20, 0, 20)
                colorBtn.Position = UDim2.new(0, 8 + ((i - 1) % 4) * 26, 0, 8 + math.floor((i - 1) / 4) * 26)
                colorBtn.BackgroundColor3 = color
                colorBtn.Text = ""
                colorBtn.ZIndex = 51
                colorBtn.AutoButtonColor = false
                colorBtn.Parent = popup

                local cBtnCorner = Instance.new("UICorner")
                cBtnCorner.CornerRadius = UDim.new(0, 2)
                cBtnCorner.Parent = colorBtn

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
    dropFrame.Size = UDim2.new(1, 0, 0, 28)
    dropFrame.BackgroundColor3 = Colors.SurfaceLight
    dropFrame.BackgroundTransparency = 0.5
    dropFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = dropFrame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropFrame

    local selectedValue = default or options[1]

    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = "DropBtn"
    dropBtn.Size = UDim2.new(0.45, -4, 0, 20)
    dropBtn.Position = UDim2.new(0.55, 0, 0.5, -10)
    dropBtn.BackgroundColor3 = Colors.Border
    dropBtn.Text = "  " .. selectedValue
    dropBtn.TextColor3 = Colors.TextPrimary
    dropBtn.Font = Enum.Font.Code
    dropBtn.TextSize = 10
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.AutoButtonColor = false
    dropBtn.Parent = dropFrame

    local dropBtnCorner = Instance.new("UICorner")
    dropBtnCorner.CornerRadius = UDim.new(0, 2)
    dropBtnCorner.Parent = dropBtn

    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 16, 1, 0)
    arrow.Position = UDim2.new(1, -18, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = Colors.TextDim
    arrow.TextSize = 10
    arrow.Font = Enum.Font.Code
    arrow.Parent = dropBtn

    local isOpen = false
    local listFrame = nil

    dropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen

        if isOpen then
            listFrame = Instance.new("Frame")
            listFrame.Name = "List"
            listFrame.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, #options * 22)
            listFrame.Position = UDim2.new(0, 0, 1, 4)
            listFrame.BackgroundColor3 = Colors.Surface
            listFrame.ZIndex = 50
            listFrame.Parent = dropBtn

            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 2)
            listCorner.Parent = listFrame

            local listStroke = Instance.new("UIStroke")
            listStroke.Color = Colors.Border
            listStroke.Thickness = 1
            listStroke.Parent = listFrame

            for i, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 22)
                optBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 22)
                optBtn.BackgroundColor3 = Colors.Surface
                optBtn.BackgroundTransparency = 1
                optBtn.Text = "  " .. option
                optBtn.TextColor3 = Colors.TextSecondary
                optBtn.Font = Enum.Font.Code
                optBtn.TextSize = 10
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.ZIndex = 51
                optBtn.AutoButtonColor = false
                optBtn.Parent = listFrame

                optBtn.MouseEnter:Connect(function()
                    Tween(optBtn, {BackgroundTransparency = 0, TextColor3 = Colors.TextPrimary}, 0.06)
                end)

                optBtn.MouseLeave:Connect(function()
                    Tween(optBtn, {BackgroundTransparency = 1, TextColor3 = Colors.TextSecondary}, 0.06)
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selectedValue = option
                    dropBtn.Text = "  " .. option
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

function Components.CreateLabel(parent, text)
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "Label"
    labelFrame.Size = UDim2.new(1, 0, 0, 20)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextSecondary
    label.Font = Enum.Font.Code
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = labelFrame

    return labelFrame
end

return Components
