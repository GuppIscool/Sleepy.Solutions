local ESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

ESP.Enabled = false
ESP.ShowBoxes = true
ESP.ShowNametags = true
ESP.BoxColor = Color3.fromRGB(255, 255, 255)
ESP.OutlineColor = Color3.fromRGB(0, 0, 0)
ESP.BoxThickness = 2
ESP.OutlineThickness = 1
ESP.NametagColor = Color3.fromRGB(255, 255, 255)

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
    }
end

local function CreatePlayerESP()
    return {
        BoxOutline = CreateDrawing("Square", {
            Filled = false,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 3,
            Visible = false,
        }),
        Box = CreateDrawing("Square", {
            Filled = false,
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
        }),
        NametagOutline = CreateDrawing("Text", {
            Text = "",
            Color = Color3.fromRGB(0, 0, 0),
            Size = 13,
            Center = true,
            Outline = false,
            Font = 2,
            Visible = false,
        }),
        Nametag = CreateDrawing("Text", {
            Text = "",
            Color = Color3.fromRGB(255, 255, 255),
            Size = 13,
            Center = true,
            Outline = true,
            Font = 2,
            Visible = false,
        }),
    }
end

local function RemovePlayerESP(data)
    if data then
        if data.Box then data.Box:Remove() end
        if data.BoxOutline then data.BoxOutline:Remove() end
        if data.Nametag then data.Nametag:Remove() end
        if data.NametagOutline then data.NametagOutline:Remove() end
    end
end

function ESP.Update()
    Camera = workspace.CurrentCamera

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

                if ESP.ShowBoxes then
                    data.BoxOutline.Position = bbox.Position - Vector2.new(1, 1)
                    data.BoxOutline.Size = bbox.Size + Vector2.new(2, 2)
                    data.BoxOutline.Color = ESP.OutlineColor
                    data.BoxOutline.Thickness = ESP.OutlineThickness
                    data.BoxOutline.Visible = true

                    data.Box.Position = bbox.Position
                    data.Box.Size = bbox.Size
                    data.Box.Color = ESP.BoxColor
                    data.Box.Thickness = ESP.BoxThickness
                    data.Box.Visible = true
                else
                    data.Box.Visible = false
                    data.BoxOutline.Visible = false
                end

                if ESP.ShowNametags and headPos then
                    local displayName = player.DisplayName or username

                    data.Nametag.Text = displayName
                    data.Nametag.Color = ESP.NametagColor
                    data.Nametag.Position = headPos - Vector2.new(0, 20)
                    data.Nametag.Visible = true

                    data.NametagOutline.Text = displayName
                    data.NametagOutline.Color = ESP.OutlineColor
                    data.NametagOutline.Position = headPos - Vector2.new(0, 20)
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

function ESP.SetBoxThickness(thickness)
    ESP.BoxThickness = thickness
end

function ESP.Start()
    if ESP.Connections.Update then return end

    ESP.Connections.Update = RunService.RenderStepped:Connect(function()
        if ESP.Enabled then
            ESP.Update()
        end
    end)

    ESP.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        task.wait(1)
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
    if ESP.Connections.Update then
        ESP.Connections.Update:Disconnect()
        ESP.Connections.Update = nil
    end

    if ESP.Connections.PlayerAdded then
        ESP.Connections.PlayerAdded:Disconnect()
        ESP.Connections.PlayerAdded = nil
    end

    if ESP.Connections.PlayerRemoving then
        ESP.Connections.PlayerRemoving:Disconnect()
        ESP.Connections.PlayerRemoving = nil
    end

    ESP.Clear()
end

return ESP
