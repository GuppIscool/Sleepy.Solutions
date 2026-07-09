-- Sleepy.Solutions - HoPlex UI
-- Main Loader

local function LoadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        return result
    else
        warn("Failed to load module: " .. url)
        return nil
    end
end

local UI = LoadModule("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/init.lua")

if not UI then
    warn("Failed to load UI library")
    return
end

local CombatTab = LoadModule("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/tabs/combat.lua")
local VisualTab = LoadModule("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/tabs/visual.lua")
local MovementTab = LoadModule("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/tabs/movement.lua")
local MiscTab = LoadModule("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/tabs/misc.lua")

UI.CreateWindow()
UI.SetupKeybinds()

if CombatTab then
    CombatTab.Setup(UI.GetTab("Combat"))
end

if VisualTab then
    VisualTab.Setup(UI.GetTab("Visual"))
end

if MovementTab then
    MovementTab.Setup(UI.GetTab("Movement"))
end

if MiscTab then
    MiscTab.Setup(UI.GetTab("Misc"))
end

print("Sleepy.Solutions loaded successfully!")
