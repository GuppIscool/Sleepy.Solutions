local MovementTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function MovementTab.Setup(tab)
    if not tab then return end

    Components.CreateSection(tab, "Speed")

    Components.CreateToggle(tab, "Speed Hack", false, function(value)
        print("Speed:", value)
    end)

    Components.CreateSlider(tab, "Speed Value", 16, 100, 50, function(value)
        print("Speed Value:", value)
    end)

    Components.CreateSection(tab, "Fly")

    Components.CreateToggle(tab, "Fly", false, function(value)
        print("Fly:", value)
    end)

    Components.CreateSlider(tab, "Fly Speed", 1, 50, 20, function(value)
        print("Fly Speed:", value)
    end)

    Components.CreateSection(tab, "Jump")

    Components.CreateToggle(tab, "Jump Boost", false, function(value)
        print("Jump Boost:", value)
    end)

    Components.CreateSlider(tab, "Jump Power", 50, 200, 100, function(value)
        print("Jump Power:", value)
    end)

    Components.CreateToggle(tab, "Infinite Jump", false, function(value)
        print("Infinite Jump:", value)
    end)
end

return MovementTab
