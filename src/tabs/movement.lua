local MovementTab = {}

local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuppIscool/Sleepy.Solutions/main/src/ui/components.lua"))()

function MovementTab.Setup(tab)
    Components.CreateToggle(tab, "Speed", false, UDim2.new(0, 10, 0, 10), function(value)
        -- TODO: Implement Speed
        print("Speed:", value)
    end)
    
    Components.CreateSlider(tab, "Speed Value", 16, 100, 50, UDim2.new(0, 10, 0, 50), function(value)
        -- TODO: Implement Speed Value
        print("Speed Value:", value)
    end)
    
    Components.CreateToggle(tab, "Fly", false, UDim2.new(0, 10, 0, 110), function(value)
        -- TODO: Implement Fly
        print("Fly:", value)
    end)
    
    Components.CreateSlider(tab, "Fly Speed", 1, 50, 20, UDim2.new(0, 10, 0, 150), function(value)
        -- TODO: Implement Fly Speed
        print("Fly Speed:", value)
    end)
    
    Components.CreateToggle(tab, "JumpBoost", false, UDim2.new(0, 10, 0, 210), function(value)
        -- TODO: Implement JumpBoost
        print("JumpBoost:", value)
    end)
    
    Components.CreateSlider(tab, "Jump Power", 50, 200, 100, UDim2.new(0, 10, 0, 250), function(value)
        -- TODO: Implement Jump Power
        print("Jump Power:", value)
    end)
end

return MovementTab
