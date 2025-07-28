-- Config
local config = {
    WindowSize = Vector2.new(350, 250),
    AutoFarmBonds = true,
    AutoCollectBonds = true,
    TeleportToBonds = true,
    CloneItems = true,
    ElectrocutionerFix = true,
    GodMode = false
}

-- UI Library (with min/max/close buttons)
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local window = library:CreateWindow("Dead Rails Farmer", config.WindowSize)
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

local function teleportToNextBond()
    if currentBondIndex > #bondLocations then
        currentBondIndex = 1
        if not updateBondLocations() then
            print("Облигации не найдены!")
            return false
        end
    end
    
    local char = game.Players.LocalPlayer.Character
    if char then
        local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(bondLocations[currentBondIndex])
            currentBondIndex = currentBondIndex + 1
            return true
        end
    end
    return false
end

local function autoCollectBonds()
    while config.AutoCollectBonds and config.AutoFarmBonds do
        if teleportToNextBond() then
            -- Имитация сбора (можно добавить firetouchinterest при необходимости)
            task.wait(0.5)
        else
            task.wait(2) -- Ждем, если облигаций нет
        end
    end
end

local function farmBonds()
    while config.AutoFarmBonds do
        if config.AutoCollectBonds then
            autoCollectBonds()
        elseif config.TeleportToBonds then
            updateBondLocations()
            teleportToNextBond()
        end

        if config.CloneItems then
            for _, item in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if item:IsA("Tool") then
                    item:Clone().Parent = game.Players.LocalPlayer.Backpack
                end
            end
        end

        if config.ElectrocutionerFix then
            local teslaLab = workspace:FindFirstChild("Tesla Laboratory")
            if teslaLab then
                local electrocutioner = teslaLab:FindFirstChild("Electrocutioner")
                if electrocutioner then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, electrocutioner, 0)
                    task.wait(1)
                end
            end
        end
        task.wait(0.5)
    end
end

-- GodMode
local function toggleGodMode()
    if config.GodMode then
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
    else
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
        game.Players.LocalPlayer.Character.Humanoid.Health = 100
    end
end

-- UI Elements
window:AddToggle("AutoFarmBonds", {Text = "Автофарм облигаций", Default = true}):OnChanged(function(value)
    config.AutoFarmBonds = value
    if value then
        farmBonds()
    end
end)

window:AddToggle("AutoCollectBonds", {Text = "Автосбор облигаций", Default = true}):OnChanged(function(value)
    config.AutoCollectBonds = value
end)

window:AddToggle("GodMode", {Text = "Бессмертие", Default = false}):OnChanged(function(value)
    config.GodMode = value
    toggleGodMode()
end)

window:AddButton("Обновить позиции", function()
    updateBondLocations()
    print("Найдено облигаций: " .. #bondLocations)
end)

library:Init()

-- Initial scan
updateBondLocations()
print("Скрипт активирован. Найдено облигаций: " .. #bondLocations)
