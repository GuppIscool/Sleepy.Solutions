local Combat = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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

local BONE_PARTS = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local function GetModel(name)
    local m = workspace:FindFirstChild(name)
    if m and m:IsA("Model") then return m end
    return nil
end

local function IsAlive(model)
    local h = model:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function GetClosestPart()
    local best = nil
    local bestDist = math.huge
    local mPos = Vector2.new(Mouse.X, Mouse.Y)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local m = GetModel(p.Name)
            if m and IsAlive(m) then
                for _, n in ipairs(BONE_PARTS) do
                    local part = m:FindFirstChild(n)
                    if part and part:IsA("BasePart") then
                        local s, v = Camera:WorldToViewportPoint(part.Position)
                        if v then
                            local d = (Vector2.new(s.X, s.Y) - mPos).Magnitude
                            if d < bestDist then
                                bestDist = d
                                best = part
                            end
                        end
                    end
                end
            end
        end
    end
    return best, bestDist
end

local function GetClosestPlayer()
    local best = nil
    local bestDist = math.huge
    local mPos = Vector2.new(Mouse.X, Mouse.Y)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local m = GetModel(p.Name)
            if m and IsAlive(m) then
                local head = m:FindFirstChild("Head")
                if head then
                    local s, v = Camera:WorldToViewportPoint(head.Position)
                    if v then
                        local d = (Vector2.new(s.X, s.Y) - mPos).Magnitude
                        if d < bestDist then
                            bestDist = d
                            best = p
                        end
                    end
                end
            end
        end
    end
    return best, bestDist
end

function Combat.UpdateSoftAim()
    if not Combat.SoftAim.Enabled then return end

    local target, dist = GetClosestPlayer()
    if target and dist <= Combat.SoftAim.FOV then
        local m = GetModel(target.Name)
        if m and IsAlive(m) then
            local head = m:FindFirstChild("Head")
            if head then
                local ts = Camera:WorldToViewportPoint(head.Position)
                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local target2D = Vector2.new(ts.X, ts.Y)
                local dir = (target2D - center) / Combat.SoftAim.Smoothness

                pcall(function()
                    UserInputService:SendMouseMoveEvent(
                        center.X + dir.X,
                        center.Y + dir.Y
                    )
                end)
            end
        end
    end
end

function Combat.UpdateTriggerbot()
    if not Combat.Triggerbot.Enabled then return end

    local part, dist = GetClosestPart()
    if part and dist < 20 then
        task.delay(Combat.Triggerbot.Delay, function()
            if Combat.Triggerbot.Enabled then
                local hum = part.Parent:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
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
    if not Combat.Connections then
        Combat.Connections = {}
    end

    if Combat.Connections.Heartbeat then return end

    Combat.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        Combat.UpdateTriggerbot()
    end)

    Combat.Connections.Render = RunService.RenderStepped:Connect(function()
        Combat.UpdateSoftAim()
    end)
end

function Combat.Stop()
    if not Combat.Connections then return end

    for _, c in pairs(Combat.Connections) do
        if c and c.Disconnect then c:Disconnect() end
    end
    Combat.Connections = {}

    Combat.SoftAim.Enabled = false
    Combat.Triggerbot.Enabled = false
end

return Combat
