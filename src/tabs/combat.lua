local CombatTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function CombatTab.Setup(tab)
    if not tab then return end

    Components.CreateSection(tab, "Combat")

    Components.CreateToggle(tab, "KillAura", false, function(value)
        print("KillAura:", value)
    end)

    Components.CreateToggle(tab, "AutoClicker", false, function(value)
        print("AutoClicker:", value)
    end)

    Components.CreateSlider(tab, "Clicks Per Second", 1, 20, 10, function(value)
        print("CPS:", value)
    end)

    Components.CreateSection(tab, "Reach")

    Components.CreateSlider(tab, "Reach Distance", 1, 6, 3, function(value)
        print("Reach:", value)
    end)

    Components.CreateToggle(tab, "AutoCrit", false, function(value)
        print("AutoCrit:", value)
    end)

    Components.CreateDropdown(tab, "Target Mode", {"Nearest", "Lowest HP", "Random"}, "Nearest", function(value)
        print("Target Mode:", value)
    end)
end

return CombatTab
