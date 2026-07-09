local MovementTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function MovementTab.Setup(UI)
    if not UI then return end

    local mainSection = UI.CreateSection("Movement", "Main")
    if mainSection then
        Components.CreateToggle(mainSection, "Speed Hack", false, function(value)
            print("Speed:", value)
        end)

        Components.CreateToggle(mainSection, "Fly", false, function(value)
            print("Fly:", value)
        end)

        Components.CreateToggle(mainSection, "Jump Boost", false, function(value)
            print("Jump Boost:", value)
        end)
    end

    local speedSection = UI.CreateSection("Movement", "Speed")
    if speedSection then
        Components.CreateSlider(speedSection, "Speed Value", 16, 100, 50, function(value)
            print("Speed Value:", value)
        end)

        Components.CreateDropdown(speedSection, "Speed Mode", {"Walk", "Sprint", "Bhop"}, "Walk", function(value)
            print("Speed Mode:", value)
        end)
    end

    local flightSection = UI.CreateSection("Movement", "Flight")
    if flightSection then
        Components.CreateSlider(flightSection, "Fly Speed", 1, 50, 20, function(value)
            print("Fly Speed:", value)
        end)

        Components.CreateDropdown(flightSection, "Fly Mode", {"Normal", "Smooth", "Physics"}, "Normal", function(value)
            print("Fly Mode:", value)
        end)

        Components.CreateToggle(flightSection, "Anti-Kick", false, function(value)
            print("Anti-Kick:", value)
        end)
    end
end

return MovementTab
