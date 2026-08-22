local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage:WaitForChild("CityDominion")
local Config = require(shared:WaitForChild("Config"))

local remotes = shared:FindFirstChild("Remotes") or Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = shared

local doJob = remotes:FindFirstChild("DoJob") or Instance.new("RemoteFunction")
doJob.Name = "DoJob"
doJob.Parent = remotes

local buyPlot = remotes:FindFirstChild("BuyPlot") or Instance.new("RemoteFunction")
buyPlot.Name = "BuyPlot"
buyPlot.Parent = remotes

local spawnCar = remotes:FindFirstChild("SpawnCar") or Instance.new("RemoteFunction")
spawnCar.Name = "SpawnCar"
spawnCar.Parent = remotes

local lastJobAt = {}
local ownedPlots = {}

local function ensureStats(player)
    local stats = player:FindFirstChild("leaderstats") or Instance.new("Folder")
    stats.Name = "leaderstats"
    stats.Parent = player

    local cash = stats:FindFirstChild("Cash") or Instance.new("IntValue")
    cash.Name = "Cash"
    cash.Value = cash.Value > 0 and cash.Value or Config.StartingCash
    cash.Parent = stats

    local plots = stats:FindFirstChild("Plots") or Instance.new("IntValue")
    plots.Name = "Plots"
    plots.Parent = stats

    return cash, plots
end

Players.PlayerAdded:Connect(function(player)
    ensureStats(player)
    ownedPlots[player] = {}
end)

Players.PlayerRemoving:Connect(function(player)
    lastJobAt[player] = nil
    ownedPlots[player] = nil
end)

for _, player in ipairs(Players:GetPlayers()) do
    ensureStats(player)
    ownedPlots[player] = {}
end

doJob.OnServerInvoke = function(player, jobName)
    local job = Config.Jobs[jobName]
    if not job then
        return false, "Emprego invalido"
    end

    local now = os.clock()
    local key = tostring(player.UserId) .. ":" .. jobName
    if now - (lastJobAt[key] or 0) < job.cooldown then
        return false, "Aguarde o cooldown"
    end

    lastJobAt[key] = now
    local cash = ensureStats(player)
    cash.Value += job.payout
    return true, job.payout, cash.Value
end

buyPlot.OnServerInvoke = function(player, plot)
    if typeof(plot) ~= "Instance" or not plot:IsDescendantOf(workspace) then
        return false, "Lote invalido"
    end
    if plot:GetAttribute("Plot") ~= true then
        return false, "Isto nao e um lote"
    end
    if plot:GetAttribute("OwnerUserId") then
        return false, "Lote ja possui dono"
    end

    local cash, plotCount = ensureStats(player)
    if cash.Value < Config.PlotPrice then
        return false, "Dinheiro insuficiente"
    end

    cash.Value -= Config.PlotPrice
    plot:SetAttribute("OwnerUserId", player.UserId)
    plot:SetAttribute("OwnerName", player.Name)
    plotCount.Value += 1
    table.insert(ownedPlots[player], plot)
    return true, cash.Value
end

local function createStarterCar(position)
    local model = Instance.new("Model")
    model.Name = "StarterCar"

    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(7, 1.6, 11)
    body.Position = position
    body.Anchored = false
    body.Parent = model

    local seat = Instance.new("VehicleSeat")
    seat.Name = "DriverSeat"
    seat.Size = Vector3.new(2, 1, 2)
    seat.Position = position + Vector3.new(0, 1.3, 0)
    seat.MaxSpeed = Config.Vehicles.StarterCar.maxSpeed
    seat.Parent = model

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = body
    weld.Part1 = seat
    weld.Parent = body

    for _, x in ipairs({-3.2, 3.2}) do
        for _, z in ipairs({-3.5, 3.5}) do
            local wheel = Instance.new("Part")
            wheel.Shape = Enum.PartType.Cylinder
            wheel.Size = Vector3.new(1.4, 2.2, 2.2)
            wheel.CFrame = CFrame.new(position + Vector3.new(x, -0.9, z)) * CFrame.Angles(0, 0, math.rad(90))
            wheel.Anchored = false
            wheel.Parent = model

            local w = Instance.new("WeldConstraint")
            w.Part0 = body
            w.Part1 = wheel
            w.Parent = body
        end
    end

    model.PrimaryPart = body
    model.Parent = workspace
    return model
end

spawnCar.OnServerInvoke = function(player)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false, "Personagem indisponivel"
    end

    local existing = workspace:FindFirstChild("Car_" .. player.UserId)
    if existing then existing:Destroy() end

    local car = createStarterCar(root.Position + root.CFrame.LookVector * 15 + Vector3.new(0, 3, 0))
    car.Name = "Car_" .. player.UserId
    car:SetAttribute("OwnerUserId", player.UserId)
    return true
end
