local ESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

ESP.Enabled = false
ESP.ShowBoxes = true
ESP.ShowNametags = true
ESP.ShowHealth = true
ESP.ShowDistance = true
ESP.BoxColor = Color3.fromRGB(255, 255, 255)
ESP.OutlineColor = Color3.fromRGB(0, 0, 0)
ESP.BoxThickness = 1
ESP.NametagColor = Color3.fromRGB(255, 255, 255)
ESP.HealthColor = Color3.fromRGB(0, 255, 0)

ESP.PlayerData = {}
ESP.Connections = {}

local BONE_PARTS = {"Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso"}

local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties or {}) do
        drawing[prop] = value
    end
    return drawing
end

local function GetPlayerModel(username)
    local model = workspace:FindFirstChild(username)
    if model and model:IsA("Model") then
        return model
    end
    return nil
end

local function GetModelBounds(model)
    local minPos = Vector3.new(math.huge, math.huge, math.huge)
    local maxPos = Vector3.new(-math.huge, -math.huge, -math.huge)

    for _, partName in ipairs(BONE_PARTS) do
        local part = model:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            local cf = part.CFrame
            local size = part.Size

            local corners = {
                cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
                cf * Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
                cf * Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
                cf * Vector3.new(size.X/2, size.Y/2, -size.Z/2),
                cf * Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
                cf * Vector3.new(size.X/2, -size.Y/2, size.Z/2),
                cf * Vector3.new(-size.X/2, size.Y/2, size.Z/2),
                cf * Vector3.new(size.X/2, size.Y/2, size.Z/2),
            }

            for _, corner in ipairs(corners) do
                minPos = Vector3.new(
                    math.min(minPos.X, corner.X),
                    math.min(minPos.Y, corner.Y),
                    math.min(minPos.Z, corner.Z)
                )
                maxPos = Vector3.new(
                    math.max(maxPos.X, corner.X),
                    math.max(maxPos.Y, corner.Y),
                    math.max(maxPos.Z, corner.Z)
                )
            end
        end
    end

    return minPos, maxPos
end

local function GetScreenCorners(minPos, maxPos)
    local corners3D = {
        Vector3.new(minPos.X, minPos.Y, minPos.Z),
        Vector3.new(maxPos.X, minPos.Y, minPos.Z),
        Vector3.new(minPos.X, maxPos.Y, minPos.Z),
        Vector3.new(maxPos.X, maxPos.Y, minPos.Z),
        Vector3.new(minPos.X, minPos.Y, maxPos.Z),
        Vector3.new(maxPos.X, minPos.Y, maxPos.Z),
        Vector3.new(minPos.X, maxPos.Y, maxPos.Z),
        Vector3.new(maxPos.X, maxPos.Y, maxPos.Z),
    }

    local screenCorners = {}
    local allOnScreen = true

    for _, corner in ipairs(corners3D) do
        local screenPos, onScreen = Camera:WorldToViewportPoint(corner)
        if not onScreen then
            allOnScreen = false
        end
        table.insert(screenCorners, Vector2.new(screenPos.X, screenPos.Y))
    end

    return screenCorners, allOnScreen
end

local function GetBoundingBox2D(screenCorners)
    local minX = math.huge
    local minY = math.huge
    local maxX = -math.huge
    local maxY = -math.huge

    for _, corner in ipairs(screenCorners) do
        minX = math.min(minX, corner.X)
        minY = math.min(minY, corner.Y)
        maxX = math.max(maxX, corner.X)
        maxY = math.max(maxY, corner.Y)
    end

    return {
        Position = Vector2.new(minX, minY),
        Size = Vector2.new(maxX - minX, maxY - minY),
        TopLeft = Vector2.new(minX, minY),
        TopRight = Vector2.new(maxX, minY),
        BottomLeft = Vector2.new(minX, maxY),
        BottomRight = Vector2.new(maxX, maxY),
        Center = Vector2.new((minX + maxX) / 2, minY),
        BottomCenter = Vector2.new((minX + maxX) / 2, maxY),
    }
end

local function CreatePlayerESP()
    return {
        BoxOutlineOuter = CreateDrawing("Square", {
            Filled = false,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 3,
            Visible = false,
        }),
        BoxOuter = CreateDrawing("Square", {
            Filled = false,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 1,
            Visible = false,
        }),
        BoxInner = CreateDrawing("Square", {
            Filled = false,
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
        }),
        BoxOutlineInner = CreateDrawing("Square", {
            Filled = false,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 3,
            Visible = false,
        }),
        HealthBarOutline = CreateDrawing("Square", {
            Filled = true,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 1,
            Visible = false,
        }),
        HealthBarBG = CreateDrawing("Square", {
            Filled = true,
            Color = Color3.fromRGB(40, 40, 40),
            Thickness = 1,
            Visible = false,
        }),
        HealthBar = CreateDrawing("Square", {
            Filled = true,
            Color = Color3.fromRGB(0, 255, 0),
            Thickness = 1,
            Visible = false,
        }),
        DistanceOutline = CreateDrawing("Text", {
            Text = "",
            Color = Color3.fromRGB(0, 0, 0),
            Size = 11,
            Center = true,
            Outline = false,
            Font = 2,
            Visible = false,
        }),
        Distance = CreateDrawing("Text", {
            Text = "",
            Color = Color3.fromRGB(200, 200, 200),
            Size = 11,
            Center = true,
            Outline = true,
            Font = 2,
            Visible = false,
        }),
        NametagOutline = CreateDrawing("Text", {
            Text = "",
            Color = Color3.fromRGB(0, 0, 0),
            Size = 11,
            Center = true,
            Outline = false,
            Font = 2,
            Visible = false,
        }),
        Nametag = CreateDrawing("Text", {
            Text = "",
            Color = Color3.fromRGB(255, 255, 255),
            Size = 11,
            Center = true,
            Outline = true,
            Font = 2,
            Visible = false,
        }),
    }
end

local function RemovePlayerESP(data)
    if data then
        for _, drawing in pairs(data) do
            if drawing and drawing.Remove then
                drawing:Remove()
            end
        end
    end
end

function ESP.Update()
    Camera = workspace.CurrentCamera
    local localPlayerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local username = player.Name
            local model = GetPlayerModel(username)

            if model and ESP.Enabled then
                if not ESP.PlayerData[username] then
                    ESP.PlayerData[username] = CreatePlayerESP()
                end

                local data = ESP.PlayerData[username]
                local minPos, maxPos = GetModelBounds(model)
                local screenCorners, allOnScreen = GetScreenCorners(minPos, maxPos)
                local bbox = GetBoundingBox2D(screenCorners)

                local head = model:FindFirstChild("Head")
                local headPos = nil
                if head then
                    local headScreen, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    headPos = Vector2.new(headScreen.X, headScreen.Y)
                end

                local humanoid = model:FindFirstChildOfClass("Humanoid")
                local health = humanoid and humanoid.Health or 0
                local maxHealth = humanoid and humanoid.MaxHealth or 100
                local healthPercent = math.clamp(health / maxHealth, 0, 1)

                local distance = 0
                if localPlayerPos then
                    local rootPart = model:FindFirstChild("Torso") or model:FindFirstChild("Head")
                    if rootPart then
                        distance = math.floor((localPlayerPos - rootPart.Position).Magnitude)
                    end
                end

                if ESP.ShowBoxes then
                    local outerSize = bbox.Size + Vector2.new(8, 8)
                    local outerPos = bbox.Position - Vector2.new(4, 4)

                    data.BoxOutlineOuter.Position = outerPos - Vector2.new(1, 1)
                    data.BoxOutlineOuter.Size = outerSize + Vector2.new(2, 2)
                    data.BoxOutlineOuter.Color = ESP.OutlineColor
                    data.BoxOutlineOuter.Thickness = 3
                    data.BoxOutlineOuter.Visible = true

                    data.BoxOuter.Position = outerPos
                    data.BoxOuter.Size = outerSize
                    data.BoxOuter.Color = ESP.OutlineColor
                    data.BoxOuter.Thickness = 1
                    data.BoxOuter.Visible = true

                    local innerSize = bbox.Size - Vector2.new(4, 4)
                    local innerPos = bbox.Position + Vector2.new(2, 2)

                    data.BoxOutlineInner.Position = innerPos - Vector2.new(1, 1)
                    data.BoxOutlineInner.Size = innerSize + Vector2.new(2, 2)
                    data.BoxOutlineInner.Color = ESP.OutlineColor
                    data.BoxOutlineInner.Thickness = 3
                    data.BoxOutlineInner.Visible = true

                    data.BoxInner.Position = innerPos
                    data.BoxInner.Size = innerSize
                    data.BoxInner.Color = ESP.BoxColor
                    data.BoxInner.Thickness = 1
                    data.BoxInner.Visible = true
                else
                    data.BoxOutlineOuter.Visible = false
                    data.BoxOuter.Visible = false
                    data.BoxOutlineInner.Visible = false
                    data.BoxInner.Visible = false
                end

                if ESP.ShowHealth then
                    local barHeight = bbox.Size.Y
                    local barWidth = 3
                    local barX = bbox.Position.x - 7

                    data.HealthBarOutline.Position = Vector2.new(barX - 1, bbox.Position.Y - 1)
                    data.HealthBarOutline.Size = Vector2.new(barWidth + 2, barHeight + 2)
                    data.HealthBarOutline.Color = ESP.OutlineColor
                    data.HealthBarOutline.Visible = true

                    data.HealthBarBG.Position = Vector2.new(barX, bbox.Position.Y)
                    data.HealthBarBG.Size = Vector2.new(barWidth, barHeight)
                    data.HealthBarBG.Color = Color3.fromRGB(40, 40, 40)
                    data.HealthBarBG.Visible = true

                    local filledHeight = barHeight * healthPercent
                    local healthColor = Color3.fromRGB(
                        255 * (1 - healthPercent),
                        255 * healthPercent,
                        0
                    )

                    data.HealthBar.Position = Vector2.new(barX, bbox.Position.Y + (barHeight - filledHeight))
                    data.HealthBar.Size = Vector2.new(barWidth, filledHeight)
                    data.HealthBar.Color = healthColor
                    data.HealthBar.Visible = true
                else
                    data.HealthBarOutline.Visible = false
                    data.HealthBarBG.Visible = false
                    data.HealthBar.Visible = false
                end

                if ESP.ShowDistance and localPlayerPos then
                    local distText = tostring(distance) .. "m"

                    data.Distance.Text = distText
                    data.Distance.Position = bbox.BottomCenter + Vector2.new(0, 12)
                    data.Distance.Color = Color3.fromRGB(200, 200, 200)
                    data.Distance.Visible = true

                    data.DistanceOutline.Text = distText
                    data.DistanceOutline.Position = bbox.BottomCenter + Vector2.new(0, 12)
                    data.DistanceOutline.Color = ESP.OutlineColor
                    data.DistanceOutline.Visible = true
                else
                    data.Distance.Visible = false
                    data.DistanceOutline.Visible = false
                end

                if ESP.ShowNametags and headPos then
                    local displayName = player.DisplayName or username

                    data.Nametag.Text = displayName
                    data.Nametag.Color = ESP.NametagColor
                    data.Nametag.Position = headPos - Vector2.new(0, 18)
                    data.Nametag.Visible = true

                    data.NametagOutline.Text = displayName
                    data.NametagOutline.Color = ESP.OutlineColor
                    data.NametagOutline.Position = headPos - Vector2.new(0, 18)
                    data.NametagOutline.Visible = true
                else
                    data.Nametag.Visible = false
                    data.NametagOutline.Visible = false
                end
            else
                if ESP.PlayerData[username] then
                    RemovePlayerESP(ESP.PlayerData[username])
                    ESP.PlayerData[username] = nil
                end
            end
        end
    end
end

function ESP.Clear()
    for username, data in pairs(ESP.PlayerData) do
        RemovePlayerESP(data)
    end
    ESP.PlayerData = {}
end

function ESP.Toggle(state)
    ESP.Enabled = state
    if not state then
        ESP.Clear()
    end
end

function ESP.SetBoxColor(color)
    ESP.BoxColor = color
end

function ESP.Start()
    if ESP.Connections.Update then return end

    ESP.Connections.Update = RunService.RenderStepped:Connect(function()
        if ESP.Enabled then
            ESP.Update()
        end
    end)

    ESP.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        local username = player.Name
        if ESP.PlayerData[username] then
            RemovePlayerESP(ESP.PlayerData[username])
            ESP.PlayerData[username] = nil
        end
    end)
end

function ESP.Stop()
    for _, conn in pairs(ESP.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    ESP.Connections = {}
    ESP.Clear()
end

return ESP
