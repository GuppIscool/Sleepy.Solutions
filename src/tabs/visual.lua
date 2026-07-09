local VisualTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/modules/esp.lua"))()

function VisualTab.Setup(UI)
    if not UI then return end

    ESP.Start()

    local mainSection = UI.CreateSection("Visual", "Main")
    if mainSection then
        Components.CreateToggle(mainSection, "Enable ESP", false, function(value)
            ESP.Toggle(value)
        end)

        Components.CreateToggle(mainSection, "Fullbright", false, function(value)
            local lighting = game:GetService("Lighting")
            if value then
                lighting.Brightness = 2
                lighting.ClockTime = 14
                lighting.GlobalShadows = false
            else
                lighting.Brightness = 0
                lighting.ClockTime = 12
                lighting.GlobalShadows = true
            end
        end)

        Components.CreateToggle(mainSection, "NoFog", false, function(value)
            local lighting = game:GetService("Lighting")
            if value then
                lighting.FogEnd = 999999
                lighting.FogStart = 999999
            else
                lighting.FogEnd = 100000
                lighting.FogStart = 0
            end
        end)
    end

    local espSection = UI.CreateSection("Visual", "ESP")
    if espSection then
        Components.CreateToggle(espSection, "Show Boxes", true, function(value)
            ESP.ShowBoxes = value
        end)

        Components.CreateToggle(espSection, "Show Nametags", true, function(value)
            ESP.ShowNametags = value
        end)

        Components.CreateToggle(espSection, "Show Health", true, function(value)
            ESP.ShowHealth = value
        end)

        Components.CreateToggle(espSection, "Show Distance", true, function(value)
            ESP.ShowDistance = value
        end)

        Components.CreateColorPicker(espSection, "Box Color", Color3.fromRGB(255, 255, 255), function(color)
            ESP.SetBoxColor(color)
        end)
    end

    local worldSection = UI.CreateSection("Visual", "World")
    if worldSection then
        Components.CreateToggle(worldSection, "NoTextures", false, function(value)
            if value then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Texture") or obj:IsA("Decal") then
                        obj.Transparency = 1
                    end
                end
            else
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Texture") or obj:IsA("Decal") then
                        obj.Transparency = 0
                    end
                end
            end
        end)

        Components.CreateToggle(worldSection, "XRay", false, function(value)
            if value then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj.Parent:FindFirstChildOfClass("Humanoid") then
                        obj.LocalTransparencyModifier = 0.7
                    end
                end
            else
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.LocalTransparencyModifier = 0
                    end
                end
            end
        end)
    end
end

return VisualTab
