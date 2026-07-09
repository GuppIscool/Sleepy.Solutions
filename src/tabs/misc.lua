local MiscTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function MiscTab.Setup(tab)
    if not tab then return end

    Components.CreateSection(tab, "Player")

    Components.CreateToggle(tab, "AntiAFK", false, function(value)
        print("AntiAFK:", value)
    end)

    Components.CreateToggle(tab, "NoClip", false, function(value)
        print("NoClip:", value)
    end)

    Components.CreateToggle(tab, "AutoRespawn", false, function(value)
        print("AutoRespawn:", value)
    end)

    Components.CreateSection(tab, "Server")

    Components.CreateButton(tab, "Server Info", function()
        print("Server Info clicked")
    end)

    Components.CreateButton(tab, "Rejoin Server", function()
        print("Rejoin clicked")
    end)

    Components.CreateDropdown(tab, "Chat Spam", {"Off", "Hello", "GG", "EZ"}, "Off", function(value)
        print("Chat Spam:", value)
    end)

    Components.CreateSection(tab, "Farm")

    Components.CreateToggle(tab, "AutoFarm", false, function(value)
        print("AutoFarm:", value)
    end)

    Components.CreateToggle(tab, "AutoMine", false, function(value)
        print("AutoMine:", value)
    end)
end

return MiscTab
