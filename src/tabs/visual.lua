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
            if value then
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").ClockTime = 14
            else
                game:GetService("Lighting").Brightness = 0
                game:GetService("Lighting").ClockTime = 12
            end
        end)

        Components.CreateToggle(mainSection, "NoFog", false, function(value)
            if value then
                game:GetService("Lighting").FogEnd = 99999
                game:GetService("Lighting").FogStart = 99999
            else
                game:GetService("Lighting").FogEnd = 100000
                game:GetService("Lighting").FogStart = 0
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

        Components.CreateColorPicker(espSection, "Box Color", Color3.fromRGB(255, 255, 255), function(color)
            ESP.SetBoxColor(color)
        end)

        Components.CreateSlider(espSection, "Box Thickness", 1, 5, 2, function(value)
            ESP.SetBoxThickness(value)
        end)
    end

    local worldSection = UI.CreateSection("Visual", "World")
    if worldSection then
        Components.CreateSlider(worldSection, "Brightness", 0, 10, 5, function(value)
            game:GetService("Lighting").Brightness = value
        end)

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
                    if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
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
