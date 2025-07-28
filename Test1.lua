-- Config
local config = {
    WindowSize = Vector2.new(300, 200),
    AutoFarmBonds = true,
    TeleportToBonds = true,
    CloneItems = true,
    ElectrocutionerFix = true,
    GodMode = false -- Новая опция бессмертия
}

-- UI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local window = library:CreateWindow("Dead Rails Farmer", config.WindowSize)
window:SetDraggable(true)

-- Functions
local function farmBonds()
    while config.AutoFarmBonds do
        if config.TeleportToBonds then
            for _, bond in ipairs(workspace:GetDescendants()) do
                if bond.Name == "Bond" and bond:IsA("BasePart") then
                    game.Players.LocalPlayer.Character:MoveTo(bond.Position)
                    task.wait(0.5)
                end
            end
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
        task.wait(1)
    end
end

-- GodMode (бессмертие)
local function toggleGodMode()
    if config.GodMode then
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
    else
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
        game.Players.LocalPlayer.Character.Humanoid.Health = 100
    end
end

-- Toggles
window:AddToggle("AutoFarmBonds", {Text = "Фарм облигаций", Default = true}):OnChanged(function(value)
    config.AutoFarmBonds = value
end)

window:AddToggle("TeleportToBonds", {Text = "Телепорт к облигациям", Default = true}):OnChanged(function(value)
    config.TeleportToBonds = value
end)

window:AddToggle("GodMode", {Text = "Бессмертие", Default = false}):OnChanged(function(value)
    config.GodMode = value
    toggleGodMode()
end)

window:AddButton("Старт", function()
    farmBonds()
end)

library:Init()
