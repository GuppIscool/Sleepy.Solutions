local CombatTab = {}
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()
local Combat = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/modules/combat.lua"))()
local Keybind = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/modules/keybind.lua"))()

function CombatTab.Setup(UI)
    if not UI then return end

    Combat.Start()
    Keybind.Start()

    local mainSection = UI.CreateSection("Combat", "Main")
    if mainSection then
        Components.CreateToggle(mainSection, "Hitbox Expander", false, function(value)
            Combat.HitboxExpander.Enabled = value
        end)

        Components.CreateSlider(mainSection, "Hitbox Size", 1, 10, 6, function(value)
            Combat.SetHitboxSize(value)
        end)

        Components.CreateDropdown(mainSection, "Hitbox Keybind", {"B", "V", "T", "Y", "U", "I", "O", "P"}, "B", function(value)
            local keyCode = Enum.KeyCode[value]
            if keyCode then
                Combat.HitboxExpander.Keybind = keyCode
                Keybind.UpdateKey("HitboxExpander", keyCode)
            end
        end)

        Components.CreateDropdown(mainSection, "Hitbox Mode", {"Toggle", "Hold", "Smart"}, "Toggle", function(value)
            Combat.HitboxExpander.Mode = value
            Keybind.UpdateMode("HitboxExpander", value)
        end)
    end

    local weaponsSection = UI.CreateSection("Combat", "Weapons")
    if weaponsSection then
        Components.CreateToggle(weaponsSection, "Soft Aim", false, function(value)
            Combat.SoftAim.Enabled = value
        end)

        Components.CreateSlider(weaponsSection, "Aim FOV", 10, 300, 100, function(value)
            Combat.SetSoftAimFOV(value)
        end)

        Components.CreateSlider(weaponsSection, "Smoothness", 1, 20, 5, function(value)
            Combat.SetSoftAimSmoothness(value)
        end)

        Components.CreateDropdown(weaponsSection, "Aim Keybind", {"V", "B", "T", "Y", "U", "I", "O", "P"}, "V", function(value)
            local keyCode = Enum.KeyCode[value]
            if keyCode then
                Combat.SoftAim.Keybind = keyCode
                Keybind.UpdateKey("SoftAim", keyCode)
            end
        end)

        Components.CreateDropdown(weaponsSection, "Aim Mode", {"Hold", "Toggle", "Smart"}, "Hold", function(value)
            Combat.SoftAim.Mode = value
            Keybind.UpdateMode("SoftAim", value)
        end)
    end

    local targetingSection = UI.CreateSection("Combat", "Targeting")
    if targetingSection then
        Components.CreateToggle(targetingSection, "Triggerbot", false, function(value)
            Combat.Triggerbot.Enabled = value
        end)

        Components.CreateSlider(targetingSection, "Trigger Delay", 0, 50, 0, function(value)
            Combat.SetTriggerbotDelay(value / 100)
        end)

        Components.CreateDropdown(targetingSection, "Trigger Keybind", {"T", "B", "V", "Y", "U", "I", "O", "P"}, "T", function(value)
            local keyCode = Enum.KeyCode[value]
            if keyCode then
                Combat.Triggerbot.Keybind = keyCode
                Keybind.UpdateKey("Triggerbot", keyCode)
            end
        end)

        Components.CreateDropdown(targetingSection, "Trigger Mode", {"Toggle", "Hold", "Smart"}, "Toggle", function(value)
            Combat.Triggerbot.Mode = value
            Keybind.UpdateMode("Triggerbot", value)
        end)
    end

    Keybind.Register("HitboxExpander", Combat.HitboxExpander.Keybind, Combat.HitboxExpander.Mode, function(active)
        Combat.HitboxExpander.Enabled = active
    end)

    Keybind.Register("SoftAim", Combat.SoftAim.Keybind, Combat.SoftAim.Mode, function(active)
        Combat.SoftAim.Enabled = active
    end)

    Keybind.Register("Triggerbot", Combat.Triggerbot.Keybind, Combat.Triggerbot.Mode, function(active)
        Combat.Triggerbot.Enabled = active
    end)
end

return CombatTab
