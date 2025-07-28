local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

-- Настройки
local DEFAULT_WIDTH = 100 -- Ширина поиска (метры)
local DEFAULT_LENGTH = 500 -- Длина поиска (метры)
local MAX_LENGTH = 80000 -- Макс. длина дороги
local TELEPORT_COOLDOWN = 1 -- Задержка (секунды)

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeadRailsFarmGUI"
screenGui.Parent = player.PlayerGui

local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(0.35, 0, 0.45, 0)
mainWindow.Position = UDim2.new(0.6, 0, 0.3, 0)
mainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainWindow.BorderSizePixel = 0
mainWindow.ClipsDescendants = true
mainWindow.Parent = screenGui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.1, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
titleBar.Parent = mainWindow

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Text = "Dead Rails Фарм"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.15, 0, 1, 0)
closeButton.Position = UDim2.new(0.85, 0, 0, 0)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.Parent = titleBar

-- Тело окна
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0.9, 0)
contentFrame.Position = UDim2.new(0, 0, 0.1, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainWindow

-- Слайдеры для настроек
local function createSlider(parent, text, minVal, maxVal, defaultVal)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0.15, 0)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local valueBox = Instance.new("TextBox")
    valueBox.Size = UDim2.new(0.3, 0, 0.8, 0)
    valueBox.Position = UDim2.new(0.65, 0, 0.1, 0)
    valueBox.Text = tostring(defaultVal)
    valueBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    valueBox.TextColor3 = Color3.new(1, 1, 1)
    valueBox.Parent = sliderFrame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0.9, 0, 0.3, 0)
    slider.Position = UDim2.new(0.05, 0, 0.6, 0)
    slider.Text = ""
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    slider.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    slider.MouseButton1Down:Connect(function()
        local startX = slider.AbsolutePosition.X
        local endX = startX + slider.AbsoluteSize.X
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - startX) / (endX - startX), 0, 1)
                local value = math.floor(minVal + (maxVal - minVal) * percent)
                valueBox.Text = tostring(value)
                fill.Size = UDim2.new(percent, 0, 1, 0)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)

    valueBox.FocusLost:Connect(function()
        local num = tonumber(valueBox.Text)
        if num then
            num = math.clamp(num, minVal, maxVal)
            valueBox.Text = tostring(num)
            fill.Size = UDim2.new((num - minVal) / (maxVal - minVal), 0, 1, 0)
        else
            valueBox.Text = tostring(defaultVal)
        end
    end)

    return {
        GetValue = function()
            return tonumber(valueBox.Text) or defaultVal
        end
    }
end

-- Создаем слайдеры
local widthSlider = createSlider(contentFrame, "Ширина (50-500 м):", 50, 500, DEFAULT_WIDTH)
local lengthSlider = createSlider(contentFrame, "Длина (0-80000 м):", 0, MAX_LENGTH, DEFAULT_LENGTH)

-- Кнопка запуска фарма
local farmButton = Instance.new("TextButton")
farmButton.Size = UDim2.new(0.9, 0, 0.15, 0)
farmButton.Position = UDim2.new(0.05, 0, 0.35, 0)
farmButton.Text = "▶️ Запустить фарм"
farmButton.TextScaled = true
farmButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
farmButton.Parent = contentFrame

-- Кнопка выдачи электрокутера
local scooterButton = Instance.new("TextButton")
scooterButton.Size = UDim2.new(0.9, 0, 0.15, 0)
scooterButton.Position = UDim2.new(0.05, 0, 0.55, 0)
scooterButton.Text = "⚡ Выдать кутер"
scooterButton.TextScaled = true
scooterButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
scooterButton.Parent = contentFrame

-- Кнопка клонирования
local cloneButton = Instance.new("TextButton")
cloneButton.Size = UDim2.new(0.9, 0, 0.15, 0)
cloneButton.Position = UDim2.new(0.05, 0, 0.75, 0)
cloneButton.Text = "📦 Клонировать предмет"
cloneButton.TextScaled = true
cloneButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
cloneButton.Parent = contentFrame

-- Функция закрытия окна
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Функция выдачи электрокутера
local function giveScooter()
    if backpack:FindFirstChild("ElectricScooter") then return end
    
    local scooter = Instance.new("Tool")
    scooter.Name = "ElectricScooter"
    scooter.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 1, 4)
    handle.BrickColor = BrickColor.new("Electric blue")
    handle.Parent = scooter
    
    scooter.Parent = backpack
end

-- Функция клонирования предмета
local function cloneItem()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local tool = humanoid:GetEquippedTool()
    if not tool then return end
    
    local clone = tool:Clone()
    clone.Parent = backpack
end

-- Основная функция фарма облигаций
local isFarming = false
local function teleportBonds()
    if isFarming then return end
    isFarming = true
    farmButton.Text = "⏸️ Остановить фарм"
    farmButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

    while isFarming do
        task.wait(TELEPORT_COOLDOWN)
        if not character or not rootPart then continue end

        local currentWidth = widthSlider.GetValue()
        local currentLength = lengthSlider.GetValue()
        local playerPos = rootPart.Position

        -- Ищем вдоль железной дороги (ось Z)
        for _, item in ipairs(Workspace:GetDescendants()) do
            if item.Name:lower():find("облигация") or item.Name:lower():find("bond") then
                if item:IsA("BasePart") then
                    local itemPos = item.Position
                    -- Проверяем расстояние по ширине (X) и длине (Z)
                    if math.abs(itemPos.X - playerPos.X) <= currentWidth and 
                       math.abs(itemPos.Z - playerPos.Z) <= currentLength then
                        item.CFrame = rootPart.CFrame + Vector3.new(0, 2, 0)
                    end
                end
            end
        end
    end

    farmButton.Text = "▶️ Запустить фарм"
    farmButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
end

-- Кнопки
farmButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    if isFarming then
        teleportBonds()
    end
end)

scooterButton.MouseButton1Click:Connect(giveScooter)
cloneButton.MouseButton1Click:Connect(cloneItem)

-- Адаптация под мобильные устройства
if UserInputService.TouchEnabled then
    mainWindow.Size = UDim2.new(0.8, 0, 0.6, 0)
    mainWindow.Position = UDim2.new(0.1, 0, 0.2, 0)
end
