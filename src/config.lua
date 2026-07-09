local Config = {}

Config.Window = {
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200),
    Title = "Sleepy.Solutions",
    SubTitle = "| HoPlex",
}

Config.Colors = {
    Background = Color3.fromRGB(18, 18, 18),
    Surface = Color3.fromRGB(24, 24, 24),
    SurfaceLight = Color3.fromRGB(32, 32, 32),
    Border = Color3.fromRGB(45, 45, 45),
    Primary = Color3.fromRGB(130, 90, 220),
    Accent = Color3.fromRGB(180, 130, 255),
    TextPrimary = Color3.fromRGB(200, 200, 200),
    TextSecondary = Color3.fromRGB(120, 120, 120),
    TextDim = Color3.fromRGB(80, 80, 80),
    Success = Color3.fromRGB(80, 180, 80),
    Warning = Color3.fromRGB(220, 180, 50),
    Error = Color3.fromRGB(200, 60, 60),
}

Config.Keybinds = {
    Toggle = {Enum.KeyCode.Insert, Enum.KeyCode.RightShift},
}

Config.Tabs = {
    Combat = {"Main", "Weapons", "Targeting"},
    Visual = {"Main", "ESP", "World"},
    Movement = {"Main", "Speed", "Flight"},
    Misc = {"Main", "Server", "Farm"},
}

Config.Animation = {
    TweenSpeed = 0.15,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out,
}

return Config
