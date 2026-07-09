local TweenService = game:GetService("TweenService")
local Animations = {}

local function getTweenInfo(speed, style, direction)
    return TweenInfo.new(
        speed or 0.2,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
end

function Animations.Tween(instance, properties, speed, style, direction)
    local tween = TweenService:Create(instance, getTweenInfo(speed, style, direction), properties)
    tween:Play()
    return tween
end

function Animations.FadeIn(instance, speed)
    instance.GroupTransparency = 1
    return Animations.Tween(instance, {GroupTransparency = 0}, speed or 0.2)
end

function Animations.FadeOut(instance, speed)
    return Animations.Tween(instance, {GroupTransparency = 1}, speed or 0.2)
end

function Animations.SlideIn(instance, direction, speed)
    local startPos = direction == "Left" and UDim2.new(-1, 0, 0, 0) or 
                     direction == "Right" and UDim2.new(1, 0, 0, 0) or
                     direction == "Top" and UDim2.new(0, 0, -1, 0) or
                     UDim2.new(0, 0, 1, 0)
    
    instance.Position = startPos
    return Animations.Tween(instance, {Position = UDim2.new(0, 0, 0, 0)}, speed or 0.3)
end

function Animations.ScaleIn(instance, speed)
    instance.Size = UDim2.new(0, 0, 0, 0)
    instance.AnchorPoint = Vector2.new(0.5, 0.5)
    return Animations.Tween(instance, {Size = UDim2.new(1, 0, 1, 0)}, speed or 0.2)
end

function Animations.HoverGrow(instance, scale)
    local originalSize = instance.Size
    local newSize = UDim2.new(
        originalSize.X.Scale, originalSize.X.Offset + (scale or 2),
        originalSize.Y.Scale, originalSize.Y.Offset + (scale or 2)
    )
    return Animations.Tween(instance, {Size = newSize}, 0.15)
end

function Animations.HoverShrink(instance, originalSize)
    return Animations.Tween(instance, {Size = originalSize}, 0.15)
end

function Animations.ColorChange(instance, newColor, speed)
    return Animations.Tween(instance, {BackgroundColor3 = newColor}, speed or 0.15)
end

function Animations.TransparencyChange(instance, newTransparency, speed)
    return Animations.Tween(instance, {BackgroundTransparency = newTransparency}, speed or 0.15)
end

return Animations
