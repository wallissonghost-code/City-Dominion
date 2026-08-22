local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("CityDominion"):WaitForChild("Remotes")
local doJob = remotes:WaitForChild("DoJob")
local buyPlot = remotes:WaitForChild("BuyPlot")
local spawnCar = remotes:WaitForChild("SpawnCar")

local gui = Instance.new("ScreenGui")
gui.Name = "CityDominionHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(290, 210)
panel.Position = UDim2.fromOffset(16, 16)
panel.BackgroundTransparency = 0.12
panel.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 38)
title.Position = UDim2.fromOffset(8, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "CITY DOMINION"
title.Parent = panel

local cashLabel = Instance.new("TextLabel")
cashLabel.Size = UDim2.new(1, -16, 0, 34)
cashLabel.Position = UDim2.fromOffset(8, 46)
cashLabel.BackgroundTransparency = 1
cashLabel.Font = Enum.Font.GothamMedium
cashLabel.TextScaled = true
cashLabel.Text = "Cash: R$0"
cashLabel.Parent = panel

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -16, 0, 32)
status.Position = UDim2.fromOffset(8, 82)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.Text = "Comece trabalhando"
status.Parent = panel

local function button(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 32)
    b.Position = UDim2.fromOffset(8, y)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = text
    b.Parent = panel
    return b
end

local workButton = button("TRABALHAR +R$85", 118)
local carButton = button("GERAR CARRO", 154)

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, -16, 0, 22)
hint.Position = UDim2.fromOffset(8, 188)
hint.BackgroundTransparency = 1
hint.Font = Enum.Font.Gotham
hint.TextScaled = true
hint.Text = "Clique em um lote para comprar"
hint.Parent = panel

local function updateCash()
    local stats = player:FindFirstChild("leaderstats")
    local cash = stats and stats:FindFirstChild("Cash")
    if cash then
        cashLabel.Text = "Cash: R$" .. cash.Value
        cash:GetPropertyChangedSignal("Value"):Connect(function()
            cashLabel.Text = "Cash: R$" .. cash.Value
        end)
    end
end

task.spawn(function()
    player:WaitForChild("leaderstats")
    updateCash()
end)

workButton.MouseButton1Click:Connect(function()
    local ok, a = doJob:InvokeServer("Courier")
    if ok then
        status.Text = "Entrega concluida: +R$" .. tostring(a)
    else
        status.Text = tostring(a)
    end
end)

carButton.MouseButton1Click:Connect(function()
    local ok, message = spawnCar:InvokeServer()
    status.Text = ok and "Carro gerado perto de voce" or tostring(message)
end)

local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    if UserInputService:GetFocusedTextBox() then return end
    local target = mouse.Target
    if target and target:GetAttribute("Plot") == true then
        local ok, message = buyPlot:InvokeServer(target)
        if ok then
            status.Text = "Lote comprado!"
        else
            status.Text = tostring(message)
        end
    end
end)
