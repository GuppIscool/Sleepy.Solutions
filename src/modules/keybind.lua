local Keybind = {}
local UserInputService = game:GetService("UserInputService")

Keybind.Bindings = {}
Keybind.Connections = {}

Keybind.Modes = {
    Toggle = "Toggle",
    Hold = "Hold",
    Smart = "Smart",
}

function Keybind.Register(name, keyCode, mode, callback)
    if Keybind.Bindings[name] then
        Keybind.Unregister(name)
    end

    Keybind.Bindings[name] = {
        Key = keyCode,
        Mode = mode or Keybind.Modes.Toggle,
        Callback = callback,
        IsActive = false,
        WasHeld = false,
    }

    if not Keybind.Connections.InputBegan then
        Keybind.Connections.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end

            for name, binding in pairs(Keybind.Bindings) do
                if input.KeyCode == binding.Key then
                    if binding.Mode == Keybind.Modes.Toggle then
                        binding.IsActive = not binding.IsActive
                        if binding.Callback then
                            binding.Callback(binding.IsActive)
                        end
                    elseif binding.Mode == Keybind.Modes.Hold then
                        binding.IsActive = true
                        if binding.Callback then
                            binding.Callback(true)
                        end
                    elseif binding.Mode == Keybind.Modes.Smart then
                        if not binding.WasHeld then
                            binding.IsActive = not binding.IsActive
                            binding.WasHeld = true
                            if binding.Callback then
                                binding.Callback(binding.IsActive)
                            end
                        end
                    end
                end
            end
        end)
    end

    if not Keybind.Connections.InputEnded then
        Keybind.Connections.InputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if gameProcessed then return end

            for name, binding in pairs(Keybind.Bindings) do
                if input.KeyCode == binding.Key then
                    if binding.Mode == Keybind.Modes.Hold then
                        binding.IsActive = false
                        if binding.Callback then
                            binding.Callback(false)
                        end
                    elseif binding.Mode == Keybind.Modes.Smart then
                        binding.WasHeld = false
                    end
                end
            end
        end)
    end
end

function Keybind.Unregister(name)
    Keybind.Bindings[name] = nil
end

function Keybind.UpdateKey(name, newKey)
    if Keybind.Bindings[name] then
        Keybind.Bindings[name].Key = newKey
    end
end

function Keybind.UpdateMode(name, newMode)
    if Keybind.Bindings[name] then
        Keybind.Bindings[name].Mode = newMode
    end
end

function Keybind.IsActive(name)
    return Keybind.Bindings[name] and Keybind.Bindings[name].IsActive
end

function Keybind.GetKeyName(keyCode)
    if keyCode == Enum.KeyCode.None then
        return "None"
    end
    return tostring(keyCode):gsub("Enum.KeyCode.", "")
end

function Keybind.Start()
end

function Keybind.Stop()
    for _, conn in pairs(Keybind.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    Keybind.Connections = {}
    Keybind.Bindings = {}
end

return Keybind
