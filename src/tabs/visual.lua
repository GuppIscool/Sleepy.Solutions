local VisualTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function VisualTab.Setup(UI)
    if not UI then return end

    local mainSection = UI.CreateSection("Visual", "Main")
    if mainSection then
        Components.CreateToggle(mainSection, "ESP", false, function(value)
            print("ESP:", value)
        end)

        Components.CreateToggle(mainSection, "Fullbright", false, function(value)
            print("Fullbright:", value)
        end)

        Components.CreateToggle(mainSection, "NoFog", false, function(value)
            print("NoFog:", value)
        end)
    end

    local espSection = UI.CreateSection("Visual", "ESP")
    if espSection then
        Components.CreateColorPicker(espSection, "ESP Color", Color3.fromRGB(255, 0, 0), function(color)
            print("ESP Color:", color)
        end)

        Components.CreateToggle(espSection, "ESP Boxes", true, function(value)
            print("ESP Boxes:", value)
        end)

        Components.CreateToggle(espSection, "ESP Names", true, function(value)
            print("ESP Names:", value)
        end)

        Components.CreateToggle(espSection, "ESP Health", false, function(value)
            print("ESP Health:", value)
        end)
    end

    local worldSection = UI.CreateSection("Visual", "World")
    if worldSection then
        Components.CreateSlider(worldSection, "Brightness", 0, 10, 5, function(value)
            print("Brightness:", value)
        end)

        Components.CreateToggle(worldSection, "NoTextures", false, function(value)
            print("NoTextures:", value)
        end)

        Components.CreateToggle(worldSection, "XRay", false, function(value)
            print("XRay:", value)
        end)
    end
end

return VisualTab
