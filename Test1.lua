-- Config
local config = {
    AutoFarmBonds = true,
    AutoCollectBonds = true,
    TeleportDelay = 0.5,
    GodMode = false
}

-- UI Library (используем более стабильную версию)
local success, library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Не удалось загрузить библиотеку UI",
        Duration = 5
    })
    return
end

-- Create window
local window = library:CreateWindow("Dead Rails Farmer", Vector2.new(350, 250))
window:SetDraggable(true)

-- Variables
local bondLocations = {}
local currentBondIndex = 1

-- Functions
local function updateBondLocations()
    bondLocations = {}
    for _, bond in ipairs(workspace:GetDescendants()) do
        if bond.Name == "Bond" and bond:IsA("BasePart") then
            table.insert(bondLocations, bond.Position)
        end
    end
    return #bondLocations > 0
end

local function teleportToPosition(position)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

local function autoCollectBonds()
    while config.AutoCollectBonds and config.AutoFarmBonds do
        if currentBondIndex > #bondLocations then
            if not updateBondLocations() or #bondLocations == 0 then
                task.wait(2)
                currentBondIndex = 1
                continue
            end
            currentBondIndex = 1
        end
        
        if teleportToPosition(bondLocations[currentBondIndex]) then
            currentBondIndex = currentBondIndex + 1
            task.wait(config.TeleportDelay)
        else
            task.wait(1)
        end
    end
end

-- GodMode
local function toggleGodMode()
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        if config.GodMode then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- UI Elements
window:AddToggle("AutoFarmBonds", {
    Text = "Автофарм облигаций",
    Default = config.AutoFarmBonds,
    Callback = function(value)
        config.AutoFarmBonds = value
        if value then
            coroutine.wrap(autoCollectBonds)()
        end
    end
})

window:AddToggle("AutoCollectBonds", {
    Text = "Автосбор облигаций",
    Default = config.AutoCollectBonds,
    Callback = function(value)
        config.AutoCollectBonds = value
    end
})

window:AddToggle("GodMode", {
    Text = "Бессмертие",
    Default = config.GodMode,
    Callback = function(value)
        config.GodMode = value
        toggleGodMode()
    end
})

window:AddButton("Обновить позиции", function()
    updateBondLocations()
    library:Notify("Найдено облигаций: " .. #bondLocations)
end)

-- Initialize
library:Init()
updateBondLocations()
library:Notify("Скрипт активирован. Найдено облигаций: " .. #bondLocations)

-- Auto-start if enabled
if config.AutoFarmBonds then
    coroutine.wrap(autoCollectBonds)()
end
