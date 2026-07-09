local ESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

ESP.Enabled = false
ESP.ShowBoxes = true
ESP.ShowNametags = true
ESP.ShowHealth = true
ESP.ShowDistance = true
ESP.BoxColor = Color3.new(1, 1, 1)
ESP.NametagColor = Color3.new(1, 1, 1)

local TARGET_PARTS = {
    "Torso",
    "Right Arm",
    "Right Leg",
    "Left Leg",
    "Left Arm",
    "Head"
}

local playerDrawings = {}

local function createSquare(color, thickness, zIndex)
    local s = Drawing.new("Square")
    s.Color = color
    s.Thickness = thickness
    s.Filled = false
    s.Visible = false
    s.ZIndex = zIndex
    return s
end

local function createText(color, size, font, outline, zIndex)
    local t = Drawing.new("Text")
    t.Color = color
    t.Size = size
    t.Font = font or 2
    t.Center = true
    t.Outline = outline
    t.Visible = false
    t.ZIndex = zIndex or 1
    return t
end

local function setupDrawings(player)
    if player == LocalPlayer then return end

    playerDrawings[player] = {
        outline = createSquare(Color3.new(0, 0, 0), 3, 1),
        box = createSquare(ESP.BoxColor, 1, 2),
        healthOutline = createSquare(Color3.new(0, 0, 0), 1, 1),
        healthBG = createSquare(Color3.fromRGB(40, 40, 40), 1, 2),
        healthBar = createSquare(Color3.new(0, 1, 0), 1, 3),
        nameOutline = createText(Color3.new(0, 0, 0), 11, 2, false, 1),
        name = createText(Color3.new(1, 1, 1), 11, 2, true, 2),
        distOutline = createText(Color3.new(0, 0, 0), 10, 2, false, 1),
        dist = createText(Color3.fromRGB(180, 180, 180), 10, 2, true, 2),
    }
end

local function removeDrawings(player)
    if playerDrawings[player] then
        for _, d in pairs(playerDrawings[player]) do
            if d and d.Remove then pcall(function() d:Remove() end) end
        end
        playerDrawings[player] = nil
    end
end

function ESP.GetBox(player)
    local character = player.Character
    if not character then return nil end

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local hasParts = false

    for _, partName in ipairs(TARGET_PARTS) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            hasParts = true
            local size = part.Size
            local cf = part.CFrame

            for _, off in ipairs({
                CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
                CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
                CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                CFrame.new(size.X/2, size.Y/2, size.Z/2),
            }) do
                local sp = Camera:WorldToViewportPoint((cf * off).Position)
                minX = math.min(minX, sp.X)
                minY = math.min(minY, sp.Y)
                maxX = math.max(maxX, sp.X)
                maxY = math.max(maxY, sp.Y)
            end
        end
    end

    if not hasParts then return nil end

    return {
        X = minX, Y = minY,
        W = maxX - minX, H = maxY - minY,
        CX = (minX + maxX) / 2,
    }
end

function ESP.Update()
    Camera = Workspace.CurrentCamera

    for player, drawings in pairs(playerDrawings) do
        if player == LocalPlayer then continue end

        local character = player.Character
        local torso = character and (character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))

        if ESP.Enabled and character and torso then
            local _, isVisible = Camera:WorldToViewportPoint(torso.Position)

            if isVisible then
                local box = ESP.GetBox(player)
                if box then
                    if ESP.ShowBoxes then
                        drawings.outline.Size = Vector2.new(box.W + 2, box.H + 2)
                        drawings.outline.Position = Vector2.new(box.X - 1, box.Y - 1)
                        drawings.outline.Visible = true

                        drawings.box.Size = Vector2.new(box.W, box.H)
                        drawings.box.Position = Vector2.new(box.X, box.Y)
                        drawings.box.Color = ESP.BoxColor
                        drawings.box.Visible = true
                    else
                        drawings.outline.Visible = false
                        drawings.box.Visible = false
                    end

                    if ESP.ShowHealth then
                        local hum = character:FindFirstChildOfClass("Humanoid")
                        local hp = hum and hum.Health or 0
                        local mhp = hum and hum.MaxHealth or 100
                        local pct = math.clamp(hp / mhp, 0, 1)

                        local bw = 3
                        local bx = box.X - 6
                        local by = box.Y
                        local bh = box.H

                        drawings.healthOutline.Size = Vector2.new(bw + 2, bh + 2)
                        drawings.healthOutline.Position = Vector2.new(bx - 1, by - 1)
                        drawings.healthOutline.Visible = true

                        drawings.healthBG.Size = Vector2.new(bw, bh)
                        drawings.healthBG.Position = Vector2.new(bx, by)
                        drawings.healthBG.Visible = true

                        local fh = bh * pct
                        local hc = Color3.fromRGB(255 * (1 - pct), 255 * pct, 0)
                        drawings.healthBar.Size = Vector2.new(bw, fh)
                        drawings.healthBar.Position = Vector2.new(bx, by + (bh - fh))
                        drawings.healthBar.Color = hc
                        drawings.healthBar.Visible = true
                    else
                        drawings.healthOutline.Visible = false
                        drawings.healthBG.Visible = false
                        drawings.healthBar.Visible = false
                    end

                    if ESP.ShowNametags then
                        local dn = player.DisplayName or player.Name
                        drawings.name.Text = dn
                        drawings.name.Position = Vector2.new(box.CX, box.Y - 16)
                        drawings.name.Color = ESP.NametagColor
                        drawings.name.Visible = true

                        drawings.nameOutline.Text = dn
                        drawings.nameOutline.Position = Vector2.new(box.CX, box.Y - 16)
                        drawings.nameOutline.Visible = true
                    else
                        drawings.name.Visible = false
                        drawings.nameOutline.Visible = false
                    end

                    if ESP.ShowDistance then
                        local lChar = LocalPlayer.Character
                        local lRoot = lChar and lChar:FindFirstChild("HumanoidRootPart")
                        if lRoot then
                            local dist = math.floor((lRoot.Position - torso.Position).Magnitude)
                            local txt = dist .. "m"
                            drawings.dist.Text = txt
                            drawings.dist.Position = Vector2.new(box.CX, box.Y + box.H + 4)
                            drawings.dist.Visible = true

                            drawings.distOutline.Text = txt
                            drawings.distOutline.Position = Vector2.new(box.CX, box.Y + box.H + 4)
                            drawings.distOutline.Visible = true
                        end
                    else
                        drawings.dist.Visible = false
                        drawings.distOutline.Visible = false
                    end

                    continue
                end
            end
        end

        drawings.outline.Visible = false
        drawings.box.Visible = false
        drawings.healthOutline.Visible = false
        drawings.healthBG.Visible = false
        drawings.healthBar.Visible = false
        drawings.name.Visible = false
        drawings.nameOutline.Visible = false
        drawings.dist.Visible = false
        drawings.distOutline.Visible = false
    end
end

function ESP.Clear()
    for _, d in pairs(playerDrawings) do
        for _, v in pairs(d) do
            if v and v.Remove then pcall(function() v:Remove() end) end
        end
    end
    playerDrawings = {}
end

function ESP.Toggle(state)
    ESP.Enabled = state
    if not state then ESP.Clear() end
end

function ESP.SetBoxColor(c)
    ESP.BoxColor = c
end

function ESP.Start()
    if ESP.Connections then return end
    ESP.Connections = {}

    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            setupDrawings(player)
        end
    end)

    Players.PlayerRemoving:Connect(removeDrawings)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            setupDrawings(player)
        end
    end

    ESP.Connections.Render = RunService.RenderStepped:Connect(function()
        if ESP.Enabled then
            ESP.Update()
        end
    end)
end

function ESP.Stop()
    if ESP.Connections then
        for _, c in pairs(ESP.Connections) do
            if c and c.Disconnect then c:Disconnect() end
        end
        ESP.Connections = nil
    end
    ESP.Clear()
end

return ESP
