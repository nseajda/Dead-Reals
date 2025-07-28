-- ... (предыдущий код остается без изменений до части поиска облигаций) ...

-- Обновленная функция фарма облигаций
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

        -- Оптимизированный поиск по Workspace
        for _, item in ipairs(Workspace:GetDescendants()) do
            -- Проверяем ОБА варианта названия
            if (item.Name:lower():find("облигация") or 
                item.Name:lower():find("bond")) and item:IsA("BasePart") then
                
                local itemPos = item.Position
                -- Проверка зоны (ширина = X, длина = Z)
                local inWidth = math.abs(itemPos.X - playerPos.X) <= currentWidth
                local inLength = math.abs(itemPos.Z - playerPos.Z) <= currentLength
                
                if inWidth and inLength then
                    -- Телепорт с небольшим случайным смещением
                    local randomOffset = Vector3.new(
                        math.random(-1.5, 1.5),
                        2, -- Высота над игроком
                        math.random(-1.5, 1.5)
                    )
                    item.CFrame = rootPart.CFrame + randomOffset
                    
                    -- Визуальный эффект (по желанию)
                    if item:FindFirstChild("Sparkles") then
                        item.Sparkles:Destroy()
                    end
                end
            end
        end
    end

    farmButton.Text = "▶️ Запустить фарм"
    farmButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
end

-- ... (остальной код без изменений) ...
