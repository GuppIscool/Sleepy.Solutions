-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

ESP = {}
ESP.Enabled = false
ESP.ShowBoxes = true
ESP.ShowNametags = true
ESP.ShowHealth = true
ESP.ShowDistance = true
ESP.BoxColor = Color3.new(1, 1, 1)
ESP.NametagColor = Color3.new(1, 1, 1)
ESP.Connections = {}

-- Parts to include in the bounding box
local TARGET_PARTS = {
	"Torso",
	"Right Arm",
	"Right Leg",
	"Left Leg",
	"Left Arm",
	"Head"
}

-- Cache to hold player drawings
local playerDrawings = {}

-- Function to create a 2D Drawing Square
local function createBox(color, thickness, zIndex)
	local box = Drawing.new("Square")
	box.Color = color
	box.Thickness = thickness
	box.Filled = false
	box.Visible = false
	box.ZIndex = zIndex
	return box
end

-- Function to create a Drawing Text
local function createText(color, size, zIndex, outline)
	local text = Drawing.new("Text")
	text.Color = color
	text.Size = size or 11
	text.Font = 2
	text.Center = true
	text.Outline = outline or true
	text.Visible = false
	text.ZIndex = zIndex or 1
	return text
end

-- Initialize drawings for a player
local function setupDrawings(player)
	if player == LocalPlayer then return end
	
	playerDrawings[player] = {
		-- A thick black box that acts as the inner AND outer outline
		outline = createBox(Color3.new(0, 0, 0), 3, 1),
		-- A thin white box layered exactly in the middle
		main = createBox(ESP.BoxColor, 1, 2),
		-- Health bar on left
		healthOutline = createBox(Color3.new(0, 0, 0), 1, 1),
		healthBG = createBox(Color3.fromRGB(40, 40, 40), 1, 2),
		healthBar = createBox(Color3.new(0, 1, 0), 1, 3),
		-- Nametag
		nameOutline = createText(Color3.new(0, 0, 0), 11, 1, false),
		name = createText(ESP.NametagColor, 11, 2, true),
		-- Distance
		distOutline = createText(Color3.new(0, 0, 0), 10, 1, false),
		dist = createText(Color3.fromRGB(180, 180, 180), 10, 2, true),
	}
end

-- Cleanup when players leave
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
	local hasVisibleParts = false

	for _, partName in ipairs(TARGET_PARTS) do
		local part = character:FindFirstChild(partName)
		if part and part:IsA("BasePart") then
			hasVisibleParts = true
			local size = part.Size
			local cf = part.CFrame

			-- Calculate all 8 corners of the 3D part
			local corners = {
				(cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position,
				(cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)).Position,
				(cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)).Position,
				(cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2)).Position,
				(cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)).Position,
				(cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2)).Position,
				(cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2)).Position,
				(cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)).Position,
			}

			-- Convert 3D corners to 2D screen positions
			for _, corner in ipairs(corners) do
				local screenPos = Camera:WorldToViewportPoint(corner)
				minX = math.min(minX, screenPos.X)
				minY = math.min(minY, screenPos.Y)
				maxX = math.max(maxX, screenPos.X)
				maxY = math.max(maxY, screenPos.Y)
			end
		end
	end

	if not hasVisibleParts then return nil end

	return {
		X = minX, Y = minY,
		W = maxX - minX, H = maxY - minY,
		CX = (minX + maxX) / 2,
	}
end

function ESP.Update()
	for player, drawings in pairs(playerDrawings) do
		if player == LocalPlayer then continue end

		local character = player.Character
		local torso = character and (character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))

		if ESP.Enabled and character and torso then
			local _, isVisible = Camera:WorldToViewportPoint(torso.Position)

			if isVisible then
				local box = ESP.GetBox(player)
				if box then
					-- Box
					if ESP.ShowBoxes then
						drawings.outline.Size = Vector2.new(box.W + 2, box.H + 2)
						drawings.outline.Position = Vector2.new(box.X - 1, box.Y - 1)
						drawings.outline.Visible = true

						drawings.main.Size = Vector2.new(box.W, box.H)
						drawings.main.Position = Vector2.new(box.X, box.Y)
						drawings.main.Color = ESP.BoxColor
						drawings.main.Visible = true
					else
						drawings.outline.Visible = false
						drawings.main.Visible = false
					end

					-- Health bar on LEFT
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

					-- Nametag above box
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

					-- Distance below box
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

		-- Hide if not visible or disabled
		drawings.outline.Visible = false
		drawings.main.Visible = false
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
	if not state then
		ESP.Clear()
	end
end

function ESP.SetBoxColor(c)
	ESP.BoxColor = c
end

function ESP.Start()
	if ESP.Connections.Render then return end

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
	if ESP.Connections.Render then
		ESP.Connections.Render:Disconnect()
		ESP.Connections.Render = nil
	end
	ESP.Clear()
end

return ESP
