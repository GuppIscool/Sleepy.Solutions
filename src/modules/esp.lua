local ESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

ESP.Enabled = false
ESP.ShowBoxes = true
ESP.ShowNametags = true
ESP.ShowHealth = true
ESP.ShowDistance = true
ESP.BoxColor = Color3.fromRGB(255, 255, 255)
ESP.BoxThickness = 1
ESP.NametagColor = Color3.fromRGB(255, 255, 255)

ESP.PlayerData = {}
ESP.Connections = {}

local BONE_PARTS = {"Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso"}

local function CreateDrawing(type, props)
    local d = Drawing.new(type)
    for k, v in pairs(props or {}) do
        d[k] = v
    end
    return d
end

local function GetModel(model)
    local m = workspace:FindFirstChild(model)
    if m and m:IsA("Model") then return m end
    return nil
end

local function GetBounds(model)
    local min = Vector3.new(math.huge, math.huge, math.huge)
    local max = Vector3.new(-math.huge, -math.huge, -math.huge)

    for _, name in ipairs(BONE_PARTS) do
        local p = model:FindFirstChild(name)
        if p and p:IsA("BasePart") then
            local cf, sz = p.CFrame, p.Size
            for _, off in ipairs({
                Vector3.new(-sz.X/2,-sz.Y/2,-sz.Z/2),
                Vector3.new(sz.X/2,-sz.Y/2,-sz.Z/2),
                Vector3.new(-sz.X/2,sz.Y/2,-sz.Z/2),
                Vector3.new(sz.X/2,sz.Y/2,-sz.Z/2),
                Vector3.new(-sz.X/2,-sz.Y/2,sz.Z/2),
                Vector3.new(sz.X/2,-sz.Y/2,sz.Z/2),
                Vector3.new(-sz.X/2,sz.Y/2,sz.Z/2),
                Vector3.new(sz.X/2,sz.Y/2,sz.Z/2),
            }) do
                local c = cf * off
                min = Vector3.new(math.min(min.X,c.X), math.min(min.Y,c.Y), math.min(min.Z,c.Z))
                max = Vector3.new(math.max(max.X,c.X), math.max(max.Y,c.Y), math.max(max.Z,c.Z))
            end
        end
    end
    return min, max
end

local function ToScreen(min, max)
    local pts = {}
    for _, c in ipairs({
        Vector3.new(min.X,min.Y,min.Z),
        Vector3.new(max.X,min.Y,min.Z),
        Vector3.new(min.X,max.Y,min.Z),
        Vector3.new(max.X,max.Y,min.Z),
        Vector3.new(min.X,min.Y,max.Z),
        Vector3.new(max.X,min.Y,max.Z),
        Vector3.new(min.X,max.Y,max.Z),
        Vector3.new(max.X,max.Y,max.Z),
    }) do
        local s, v = Camera:WorldToViewportPoint(c)
        table.insert(pts, Vector2.new(s.X, s.Y))
    end
    return pts
end

local function Box2D(pts)
    local x1, y1, x2, y2 = math.huge, math.huge, -math.huge, -math.huge
    for _, p in ipairs(pts) do
        x1 = math.min(x1, p.X)
        y1 = math.min(y1, p.Y)
        x2 = math.max(x2, p.X)
        y2 = math.max(y2, p.Y)
    end
    return {
        X = x1, Y = y1,
        W = x2 - x1, H = y2 - y1,
        CX = (x1+x2)/2, CY = (y1+y2)/2,
        BY = y2,
    }
end

local function NewESP()
    return {
        BoxOutline = CreateDrawing("Square", {Filled=false, Color=Color3.new(0,0,0), Thickness=3, Visible=false}),
        Box = CreateDrawing("Square", {Filled=false, Color=Color3.new(1,1,1), Thickness=1, Visible=false}),
        HealthBG = CreateDrawing("Square", {Filled=true, Color=Color3.new(0.15,0.15,0.15), Thickness=1, Visible=false}),
        HealthOutline = CreateDrawing("Square", {Filled=false, Color=Color3.new(0,0,0), Thickness=1, Visible=false}),
        HealthBar = CreateDrawing("Square", {Filled=true, Color=Color3.new(0,1,0), Thickness=1, Visible=false}),
        DistText = CreateDrawing("Text", {Text="", Color=Color3.new(0.8,0.8,0.8), Size=11, Center=true, Outline=true, Font=2, Visible=false}),
        DistOutline = CreateDrawing("Text", {Text="", Color=Color3.new(0,0,0), Size=11, Center=true, Outline=false, Font=2, Visible=false}),
        NameText = CreateDrawing("Text", {Text="", Color=Color3.new(1,1,1), Size=11, Center=true, Outline=true, Font=2, Visible=false}),
        NameOutline = CreateDrawing("Text", {Text="", Color=Color3.new(0,0,0), Size=11, Center=true, Outline=false, Font=2, Visible=false}),
    }
end

local function RemoveESP(d)
    for _, v in pairs(d) do
        if v and v.Remove then pcall(function() v:Remove() end) end
    end
end

function ESP.Update()
    Camera = workspace.CurrentCamera
    local lChar = LocalPlayer.Character
    local lRoot = lChar and lChar:FindFirstChild("HumanoidRootPart")
    local lPos = lRoot and lRoot.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local name = plr.Name
            local model = GetModel(name)

            if model and ESP.Enabled then
                if not ESP.PlayerData[name] then
                    ESP.PlayerData[name] = NewESP()
                end
                local d = ESP.PlayerData[name]

                local min, max = GetBounds(model)
                local pts = ToScreen(min, max)
                local b = Box2D(pts)

                local head = model:FindFirstChild("Head")
                local hum = model:FindFirstChildOfClass("Humanoid")
                local hp = hum and hum.Health or 0
                local mhp = hum and hum.MaxHealth or 100
                local hpPct = math.clamp(hp/mhp, 0, 1)

                local dist = 0
                if lPos then
                    local rp = model:FindFirstChild("Torso") or model:FindFirstChild("Head")
                    if rp then dist = math.floor((lPos - rp.Position).Magnitude) end
                end

                if ESP.ShowBoxes then
                    d.BoxOutline.Position = Vector2.new(b.X-1, b.Y-1)
                    d.BoxOutline.Size = Vector2.new(b.W+2, b.H+2)
                    d.BoxOutline.Visible = true

                    d.Box.Position = Vector2.new(b.X, b.Y)
                    d.Box.Size = Vector2.new(b.W, b.H)
                    d.Box.Color = ESP.BoxColor
                    d.Box.Visible = true
                else
                    d.BoxOutline.Visible = false
                    d.Box.Visible = false
                end

                if ESP.ShowHealth then
                    local bw = 3
                    local bx = b.X + b.W + 5
                    local by = b.Y
                    local bh = b.H

                    d.HealthBG.Position = Vector2.new(bx, by)
                    d.HealthBG.Size = Vector2.new(bw, bh)
                    d.HealthBG.Visible = true

                    d.HealthOutline.Position = Vector2.new(bx-1, by-1)
                    d.HealthOutline.Size = Vector2.new(bw+2, bh+2)
                    d.HealthOutline.Visible = true

                    local fh = bh * hpPct
                    local hc = Color3.fromRGB(255*(1-hpPct), 255*hpPct, 0)
                    d.HealthBar.Position = Vector2.new(bx, by + (bh - fh))
                    d.HealthBar.Size = Vector2.new(bw, fh)
                    d.HealthBar.Color = hc
                    d.HealthBar.Visible = true
                else
                    d.HealthBG.Visible = false
                    d.HealthOutline.Visible = false
                    d.HealthBar.Visible = false
                end

                if ESP.ShowDistance and lPos then
                    local txt = dist .. "m"
                    d.DistText.Text = txt
                    d.DistText.Position = Vector2.new(b.CX, b.BY + 4)
                    d.DistText.Visible = true

                    d.DistOutline.Text = txt
                    d.DistOutline.Position = Vector2.new(b.CX, b.BY + 4)
                    d.DistOutline.Visible = true
                else
                    d.DistText.Visible = false
                    d.DistOutline.Visible = false
                end

                if ESP.ShowNametags and head then
                    local hs, ho = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                    if ho then
                        local dn = plr.DisplayName or name
                        d.NameText.Text = dn
                        d.NameText.Position = Vector2.new(hs.X, hs.Y - 16)
                        d.NameText.Visible = true

                        d.NameOutline.Text = dn
                        d.NameOutline.Position = Vector2.new(hs.X, hs.Y - 16)
                        d.NameOutline.Visible = true
                    else
                        d.NameText.Visible = false
                        d.NameOutline.Visible = false
                    end
                else
                    d.NameText.Visible = false
                    d.NameOutline.Visible = false
                end
            else
                if ESP.PlayerData[name] then
                    RemoveESP(ESP.PlayerData[name])
                    ESP.PlayerData[name] = nil
                end
            end
        end
    end
end

function ESP.Clear()
    for _, d in pairs(ESP.PlayerData) do RemoveESP(d) end
    ESP.PlayerData = {}
end

function ESP.Toggle(state)
    ESP.Enabled = state
    if not state then ESP.Clear() end
end

function ESP.SetBoxColor(c) ESP.BoxColor = c end

function ESP.Start()
    if ESP.Connections.Update then return end
    ESP.Connections.Update = RunService.RenderStepped:Connect(function()
        if ESP.Enabled then ESP.Update() end
    end)
    ESP.Connections.Leaving = Players.PlayerRemoving:Connect(function(p)
        if ESP.PlayerData[p.Name] then
            RemoveESP(ESP.PlayerData[p.Name])
            ESP.PlayerData[p.Name] = nil
        end
    end)
end

function ESP.Stop()
    for _, c in pairs(ESP.Connections) do
        if c and c.Disconnect then c:Disconnect() end
    end
    ESP.Connections = {}
    ESP.Clear()
end

return ESP
