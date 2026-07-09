local VisualTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function VisualTab.Setup(tab)
    if not tab then return end

    Components.CreateSection(tab, "ESP")

    Components.CreateToggle(tab, "Enable ESP", false, function(value)
        print("ESP:", value)
    end)

    Components.CreateColorPicker(tab, "ESP Color", Color3.fromRGB(255, 0, 0), function(color)
        print("ESP Color:", color)
    end)

    Components.CreateToggle(tab, "ESP Boxes", false, function(value)
        print("ESP Boxes:", value)
    end)

    Components.CreateToggle(tab, "ESP Names", false, function(value)
        print("ESP Names:", value)
    end)

    Components.CreateSection(tab, "World")

    Components.CreateToggle(tab, "Fullbright", false, function(value)
        print("Fullbright:", value)
    end)

    Components.CreateSlider(tab, "Brightness", 0, 10, 5, function(value)
        print("Brightness:", value)
    end)

    Components.CreateToggle(tab, "NoFog", false, function(value)
        print("NoFog:", value)
    end)

    Components.CreateToggle(tab, "NoTextures", false, function(value)
        print("NoTextures:", value)
    end)
end

return VisualTab
