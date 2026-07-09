local Components = {}
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/animations.lua"))()
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/config.lua"))()

local Colors = Config.Colors

function Components.CreateButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(0, 120, 0, 35)
    button.Position = position or UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Colors.Primary
    button.Text = text
    button.TextColor3 = Colors.TextPrimary
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local originalColor = Colors.Primary
    
    button.MouseEnter:Connect(function()
        Utils.ColorChange(button, Colors.PrimaryLight, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        Utils.ColorChange(button, originalColor, 0.15)
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

function Components.CreateSlider(parent, text, min, max, default, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"
    sliderFrame.Size = UDim2.new(0, 200, 0, 50)
    sliderFrame.Position = position or UDim2.new(0, 10, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Name = "SliderBG"
    sliderBG.Size = UDim2.new(1, 0, 0, 6)
    sliderBG.Position = UDim2.new(0, 0, 0, 25)
    sliderBG.BackgroundColor3 = Colors.SurfaceLight
    sliderBG.Parent = sliderFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = sliderBG
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.Parent = sliderBG
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 14, 0, 14)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    sliderButton.BackgroundColor3 = Colors.TextPrimary
    sliderButton.Text = ""
    sliderButton.Parent = sliderBG
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 7)
    buttonCorner.Parent = sliderButton
    
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
            local relativeX = (input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            
            local value = min + (max - min) * relativeX
            value = math.floor(value * 10) / 10
            
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -7, 0.5, -7)
            label.Text = text .. ": " .. value
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return sliderFrame
end

function Components.CreateToggle(parent, text, default, position, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Size = UDim2.new(0, 180, 0, 30)
    toggleFrame.Position = position or UDim2.new(0, 10, 0, 10)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 130, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleBG = Instance.new("TextButton")
    toggleBG.Name = "ToggleBG"
    toggleBG.Size = UDim2.new(0, 40, 0, 20)
    toggleBG.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBG.BackgroundColor3 = default and Colors.Primary or Colors.SurfaceLight
    toggleBG.Text = ""
    toggleBG.Parent = toggleFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 10)
    bgCorner.Parent = toggleBG
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Colors.TextPrimary
    toggleCircle.Parent = toggleBG
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = toggleCircle
    
    local isToggled = default
    
    toggleBG.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        if isToggled then
            Utils.Tween(toggleBG, {BackgroundColor3 = Colors.Primary}, 0.2)
            Utils.Tween(toggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
        else
            Utils.Tween(toggleBG, {BackgroundColor3 = Colors.SurfaceLight}, 0.2)
            Utils.Tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
        end
        
        if callback then
            callback(isToggled)
        end
    end)
    
    return toggleFrame
end

function Components.CreateColorPicker(parent, text, default, position, callback)
    local pickerFrame = Instance.new("Frame")
    pickerFrame.Name = "ColorPicker"
    pickerFrame.Size = UDim2.new(0, 180, 0, 30)
    pickerFrame.Position = position or UDim2.new(0, 10, 0, 10)
    pickerFrame.BackgroundTransparency = 1
    pickerFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = pickerFrame
    
    local colorBox = Instance.new("TextButton")
    colorBox.Name = "ColorBox"
    colorBox.Size = UDim2.new(0, 30, 0, 20)
    colorBox.Position = UDim2.new(1, -35, 0.5, -10)
    colorBox.BackgroundColor3 = default or Colors.Primary
    colorBox.Text = ""
    colorBox.Parent = pickerFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = colorBox
    
    local isPickerOpen = false
    
    colorBox.MouseButton1Click:Connect(function()
        isPickerOpen = not isPickerOpen
        
        if isPickerOpen then
            local pickerPopup = Instance.new("Frame")
            pickerPopup.Name = "PickerPopup"
            pickerPopup.Size = UDim2.new(0, 150, 0, 100)
            pickerPopup.Position = UDim2.new(0, colorBox.AbsolutePosition.X - pickerFrame.AbsolutePosition.X, 0, 35)
            pickerPopup.BackgroundColor3 = Colors.Surface
            pickerPopup.ZIndex = 100
            pickerPopup.Parent = pickerFrame
            
            local popupCorner = Instance.new("UICorner")
            popupCorner.CornerRadius = UDim.new(0, 8)
            popupCorner.Parent = pickerPopup
            
            local presetColors = {
                Colors.Primary,
                Colors.Accent,
                Colors.Success,
                Colors.Warning,
                Colors.Error,
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(0, 0, 0),
            }
            
            for i, color in ipairs(presetColors) do
                local colorButton = Instance.new("TextButton")
                colorButton.Size = UDim2.new(0, 25, 0, 25)
                colorButton.Position = UDim2.new(0, 10 + ((i - 1) % 4) * 32, 0, 10 + math.floor((i - 1) / 4) * 32)
                colorButton.BackgroundColor3 = color
                colorButton.Text = ""
                colorButton.ZIndex = 101
                colorButton.Parent = pickerPopup
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = colorButton
                
                colorButton.MouseButton1Click:Connect(function()
                    colorBox.BackgroundColor3 = color
                    pickerPopup:Destroy()
                    isPickerOpen = false
                    
                    if callback then
                        callback(color)
                    end
                end)
            end
        else
            local popup = pickerFrame:FindFirstChild("PickerPopup")
            if popup then
                popup:Destroy()
            end
        end
    end)
    
    return pickerFrame
end

function Components.CreateSelectionBox(parent, text, options, default, position, callback)
    local selectionFrame = Instance.new("Frame")
    selectionFrame.Name = "SelectionBox"
    selectionFrame.Size = UDim2.new(0, 180, 0, 30)
    selectionFrame.Position = position or UDim2.new(0, 10, 0, 10)
    selectionFrame.BackgroundTransparency = 1
    selectionFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 80, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = selectionFrame
    
    local dropdownBG = Instance.new("TextButton")
    dropdownBG.Name = "DropdownBG"
    dropdownBG.Size = UDim2.new(0, 90, 0, 25)
    dropdownBG.Position = UDim2.new(1, -95, 0.5, -12)
    dropdownBG.BackgroundColor3 = Colors.SurfaceLight
    dropdownBG.Text = default or options[1]
    dropdownBG.TextColor3 = Colors.TextPrimary
    dropdownBG.Font = Enum.Font.GothamMedium
    dropdownBG.TextSize = 11
    dropdownBG.Parent = selectionFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
    bgCorner.Parent = dropdownBG
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Colors.TextSecondary
    arrow.TextSize = 10
    arrow.Parent = dropdownBG
    
    local isDropdownOpen = false
    
    dropdownBG.MouseButton1Click:Connect(function()
        isDropdownOpen = not isDropdownOpen
        
        if isDropdownOpen then
            local dropdownList = Instance.new("Frame")
            dropdownList.Name = "DropdownList"
            dropdownList.Size = UDim2.new(0, 90, 0, #options * 25)
            dropdownList.Position = UDim2.new(0, 0, 1, 5)
            dropdownList.BackgroundColor3 = Colors.Surface
            dropdownList.ZIndex = 100
            dropdownList.Parent = dropdownBG
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 6)
            listCorner.Parent = dropdownList
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 25)
                optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
                optionButton.BackgroundTransparency = 1
                optionButton.Text = option
                optionButton.TextColor3 = Colors.TextPrimary
                optionButton.Font = Enum.Font.GothamMedium
                optionButton.TextSize = 11
                optionButton.ZIndex = 101
                optionButton.Parent = dropdownList
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundColor3 = Colors.SurfaceLight
                    optionButton.BackgroundTransparency = 0
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundTransparency = 1
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdownBG.Text = option
                    dropdownList:Destroy()
                    isDropdownOpen = false
                    
                    if callback then
                        callback(option)
                    end
                end)
            end
        else
            local list = dropdownBG:FindFirstChild("DropdownList")
            if list then
                list:Destroy()
            end
        end
    end)
    
    return selectionFrame
end

return Components
