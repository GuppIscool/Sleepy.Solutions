local Combat = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

Combat.HitboxExpander = {
    Enabled = false,
    Size = 10,
    Keybind = Enum.KeyCode.B,
    Mode = "Toggle",
}

Combat.SoftAim = {
    Enabled = false,
    FOV = 100,
    Smoothness = 5,
    Keybind = Enum.KeyCode.V,
    Mode = "Hold",
}

Combat.Triggerbot = {
    Enabled = false,
    Delay = 0,
    Keybind = Enum.KeyCode.T,
    Mode = "Toggle",
}

Combat.Connections = {}
Combat.OriginalSizes = {}

local BONE_PARTS = {"Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso"}

local function GetPlayerModel(username)
    local model = workspace:FindFirstChild(username)
    if model and model:IsA("Model") then
        return model
    end
    return nil
end

local function IsAlive(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetClosestPartToCursor()
    local closestPart = nil
    local closestDist = math.huge
    local cursorPos = Vector2.new(Mouse.X, Mouse.Y)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local model = GetPlayerModel(player.Name)
            if model and IsAlive(model) then
                for _, partName in ipairs(BONE_PARTS) do
                    local part = model:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - cursorPos).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestPart = part
                            end
                        end
                    end
                end
            end
        end
    end

    return closestPart, closestDist
end

local function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local closestDist = math.huge
    local cursorPos = Vector2.new(Mouse.X, Mouse.Y)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local model = GetPlayerModel(player.Name)
            if model and IsAlive(model) then
                local head = model:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - cursorPos).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return closestPlayer, closestDist
end

function Combat.UpdateHitboxExpander()
    if not Combat.HitboxExpander.Enabled then
        for part, originalSize in pairs(Combat.OriginalSizes) do
            if part and part.Parent then
                part.Size = originalSize
                part.Transparency = 0
                part.Color = Color3.fromRGB(163, 162, 165)
            end
        end
        Combat.OriginalSizes = {}
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local model = GetPlayerModel(player.Name)
            if model and IsAlive(model) then
                for _, partName in ipairs(BONE_PARTS) do
                    local part = model:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        if not Combat.OriginalSizes[part] then
                            Combat.OriginalSizes[part] = part.Size
                        end
                        part.Size = Vector3.new(Combat.HitboxExpander.Size, Combat.HitboxExpander.Size, Combat.HitboxExpander.Size)
                        part.Transparency = 0.8
                        part.Color = Color3.fromRGB(255, 0, 0)
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end

function Combat.UpdateSoftAim()
    if not Combat.SoftAim.Enabled then return end

    local targetPlayer, dist = GetClosestPlayerToCursor()
    if targetPlayer and dist <= Combat.SoftAim.FOV then
        local model = GetPlayerModel(targetPlayer.Name)
        if model and IsAlive(model) then
            local head = model:FindFirstChild("Head")
            if head then
                local targetPos = Camera:WorldToViewportPoint(head.Position)
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local targetScreen = Vector2.new(targetPos.X, targetPos.Y)

                local dir = (targetScreen - screenCenter)
                local smoothDir = dir / Combat.SoftAim.Smoothness

                pcall(function()
                    game:GetService("UserInputService"):SendMouseMoveEvent(
                        screenCenter.X + smoothDir.X,
                        screenCenter.Y + smoothDir.Y
                    )
                end)
            end
        end
    end
end

function Combat.UpdateTriggerbot()
    if not Combat.Triggerbot.Enabled then return end

    local closestPart, dist = GetClosestPartToCursor()
    if closestPart and dist < 20 then
        task.delay(Combat.Triggerbot.Delay, function()
            if Combat.Triggerbot.Enabled then
                local humanoid = closestPart.Parent:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    pcall(function()
                        mouse1press()
                        task.wait(0.05)
                        mouse1release()
                    end)
                end
            end
        end)
    end
end

function Combat.SetHitboxSize(size)
    Combat.HitboxExpander.Size = math.clamp(size, 1, 10)
end

function Combat.SetSoftAimFOV(fov)
    Combat.SoftAim.FOV = fov
end

function Combat.SetSoftAimSmoothness(smooth)
    Combat.SoftAim.Smoothness = math.clamp(smooth, 1, 20)
end

function Combat.SetTriggerbotDelay(delay)
    Combat.Triggerbot.Delay = math.clamp(delay, 0, 0.5)
end

function Combat.Start()
    if Combat.Connections.Heartbeat then return end

    Combat.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        Combat.UpdateHitboxExpander()
        Combat.UpdateTriggerbot()
    end)

    Combat.Connections.RenderStepped = RunService.RenderStepped:Connect(function()
        Combat.UpdateSoftAim()
    end)
end

function Combat.Stop()
    for _, conn in pairs(Combat.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    Combat.Connections = {}

    Combat.HitboxExpander.Enabled = false
    Combat.SoftAim.Enabled = false
    Combat.Triggerbot.Enabled = false

    for part, originalSize in pairs(Combat.OriginalSizes) do
        if part and part.Parent then
            part.Size = originalSize
            part.Transparency = 0
            part.Color = Color3.fromRGB(163, 162, 165)
        end
    end
    Combat.OriginalSizes = {}
end

return Combat
