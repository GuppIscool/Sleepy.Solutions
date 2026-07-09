local MiscTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function MiscTab.Setup(UI)
    if not UI then return end

    local mainSection = UI.CreateSection("Misc", "Main")
    if mainSection then
        Components.CreateToggle(mainSection, "AntiAFK", false, function(value)
            print("AntiAFK:", value)
        end)

        Components.CreateToggle(mainSection, "NoClip", false, function(value)
            print("NoClip:", value)
        end)

        Components.CreateToggle(mainSection, "AutoRespawn", false, function(value)
            print("AutoRespawn:", value)
        end)
    end

    local serverSection = UI.CreateSection("Misc", "Server")
    if serverSection then
        Components.CreateButton(serverSection, "Server Info", function()
            print("Server Info clicked")
        end)

        Components.CreateButton(serverSection, "Rejoin Server", function()
            print("Rejoin clicked")
        end)

        Components.CreateButton(serverSection, "Copy Server ID", function()
            print("Copy Server ID")
        end)
    end

    local farmSection = UI.CreateSection("Misc", "Farm")
    if farmSection then
        Components.CreateToggle(farmSection, "AutoFarm", false, function(value)
            print("AutoFarm:", value)
        end)

        Components.CreateToggle(farmSection, "AutoMine", false, function(value)
            print("AutoMine:", value)
        end)

        Components.CreateDropdown(farmSection, "Farm Mode", {"Manual", "Auto", "Smart"}, "Manual", function(value)
            print("Farm Mode:", value)
        end)
    end
end

return MiscTab
