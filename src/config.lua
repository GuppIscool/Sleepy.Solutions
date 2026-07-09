local Config = {}

-- Window Settings
Config.Window = {
    Size = UDim2.new(0, 500, 0, 350),
    Position = UDim2.new(0.5, -250, 0.5, -175),
    Title = "Sleepy.Solutions",
}

-- Colors (Fluent/Material Design)
Config.Colors = {
    Background = Color3.fromRGB(30, 30, 46),
    Surface = Color3.fromRGB(43, 43, 61),
    SurfaceLight = Color3.fromRGB(55, 55, 75),
    Primary = Color3.fromRGB(124, 58, 237),
    PrimaryLight = Color3.fromRGB(167, 119, 227),
    Accent = Color3.fromRGB(192, 132, 252), -- Solutions color
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 176),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(255, 193, 7),
    Error = Color3.fromRGB(244, 67, 54),
}

-- Keybinds
Config.Keybinds = {
    Toggle = {Enum.KeyCode.Insert, Enum.KeyCode.RightShift},
}

-- Tabs
Config.Tabs = {"Combat", "Visual", "Movement", "Misc"}

-- Animation Settings
Config.Animation = {
    TweenSpeed = 0.2,
    EasingStyle = Enum.EasingStyle.Quint,
    EasingDirection = Enum.EasingDirection.Out,
}

return Config
