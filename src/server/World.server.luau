local Workspace = game:GetService("Workspace")

local old = Workspace:FindFirstChild("CityDominionWorld")
if old then old:Destroy() end

local world = Instance.new("Folder")
world.Name = "CityDominionWorld"
world.Parent = Workspace

local function part(name, size, position, material, color)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = position
    p.Anchored = true
    p.Material = material or Enum.Material.Concrete
    if color then p.Color = color end
    p.Parent = world
    return p
end

part("Ground", Vector3.new(900, 2, 900), Vector3.new(0, -1, 0), Enum.Material.Grass, Color3.fromRGB(83, 124, 72))

local roadColor = Color3.fromRGB(42, 42, 42)
for i = -3, 3 do
    part("RoadX_" .. i, Vector3.new(900, 1, 34), Vector3.new(0, 0.1, i * 120), Enum.Material.Asphalt, roadColor)
    part("RoadZ_" .. i, Vector3.new(34, 1, 900), Vector3.new(i * 120, 0.12, 0), Enum.Material.Asphalt, roadColor)
end

local spawn = Instance.new("SpawnLocation")
spawn.Name = "CentralSpawn"
spawn.Size = Vector3.new(14, 1, 14)
spawn.Position = Vector3.new(0, 2, 0)
spawn.Anchored = true
spawn.Neutral = true
spawn.Parent = world

local function building(name, pos, size, color)
    local model = Instance.new("Model")
    model.Name = name
    model.Parent = world

    local base = Instance.new("Part")
    base.Name = "Structure"
    base.Size = size
    base.Position = pos + Vector3.new(0, size.Y / 2, 0)
    base.Anchored = true
    base.Material = Enum.Material.SmoothPlastic
    base.Color = color
    base.Parent = model

    local sign = Instance.new("BillboardGui")
    sign.Size = UDim2.fromOffset(220, 50)
    sign.StudsOffset = Vector3.new(0, size.Y / 2 + 3, 0)
    sign.AlwaysOnTop = true
    sign.Parent = base

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 0.15
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = name
    label.Parent = sign
end

building("CITY HALL", Vector3.new(0, 0, -70), Vector3.new(70, 28, 44), Color3.fromRGB(226, 221, 205))
building("BANK", Vector3.new(145, 0, -70), Vector3.new(55, 24, 42), Color3.fromRGB(196, 207, 215))
building("GARAGE", Vector3.new(-145, 0, -70), Vector3.new(60, 18, 42), Color3.fromRGB(91, 96, 102))
building("MARKET", Vector3.new(145, 0, 70), Vector3.new(58, 20, 42), Color3.fromRGB(216, 173, 91))
building("JOBS", Vector3.new(-145, 0, 70), Vector3.new(58, 20, 42), Color3.fromRGB(120, 160, 194))

local plotIndex = 0
for row = -2, 2 do
    for col = -2, 2 do
        local x = col * 120 + 55
        local z = row * 120 + 55
        if math.abs(x) > 80 or math.abs(z) > 80 then
            plotIndex += 1
            local plot = part("Plot_" .. plotIndex, Vector3.new(70, 0.5, 70), Vector3.new(x, 0.3, z), Enum.Material.Sand, Color3.fromRGB(171, 143, 97))
            plot:SetAttribute("Plot", true)

            local gui = Instance.new("BillboardGui")
            gui.Size = UDim2.fromOffset(170, 44)
            gui.StudsOffset = Vector3.new(0, 4, 0)
            gui.AlwaysOnTop = true
            gui.Parent = plot

            local label = Instance.new("TextLabel")
            label.Size = UDim2.fromScale(1, 1)
            label.TextScaled = true
            label.BackgroundTransparency = 0.2
            label.Font = Enum.Font.GothamBold
            label.Text = "LOT R$1.200"
            label.Parent = gui
        end
    end
end

print("City Dominion world generated with", plotIndex, "plots")
