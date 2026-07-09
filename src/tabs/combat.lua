local CombatTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function CombatTab.Setup(UI)
    if not UI then return end

    local mainSection = UI.CreateSection("Combat", "Main")
    if mainSection then
        Components.CreateToggle(mainSection, "KillAura", false, function(value)
            print("KillAura:", value)
        end)

        Components.CreateToggle(mainSection, "AutoClicker", false, function(value)
            print("AutoClicker:", value)
        end)

        Components.CreateSlider(mainSection, "Clicks Per Second", 1, 20, 10, function(value)
            print("CPS:", value)
        end)
    end

    local weaponsSection = UI.CreateSection("Combat", "Weapons")
    if weaponsSection then
        Components.CreateSlider(weaponsSection, "Reach Distance", 1, 6, 3, function(value)
            print("Reach:", value)
        end)

        Components.CreateToggle(weaponsSection, "AutoCrit", false, function(value)
            print("AutoCrit:", value)
        end)

        Components.CreateToggle(weaponsSection, "Velocity", false, function(value)
            print("Velocity:", value)
        end)
    end

    local targetingSection = UI.CreateSection("Combat", "Targeting")
    if targetingSection then
        Components.CreateDropdown(targetingSection, "Target Mode", {"Nearest", "Lowest HP", "Random"}, "Nearest", function(value)
            print("Target Mode:", value)
        end)

        Components.CreateToggle(targetingSection, "Team Check", true, function(value)
            print("Team Check:", value)
        end)

        Components.CreateToggle(targetingSection, "Wall Check", false, function(value)
            print("Wall Check:", value)
        end)
    end
end

return CombatTab
