-- Ultra Yeet Farm v3.0 (Stealth Mode)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualInput = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local random = Random.new()

-- Anti-Cheat Bypass Techniques
local function safeFireServer(remote, ...)
    if typeof(remote) == "Instance" and remote:IsA("RemoteEvent") then
        local args = {...}
        setidentity(2)
        remote:FireServer(unpack(args))
        setidentity(7)
    end
end

local function generateFakeDeviceId()
    return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 16)
end

-- Stealth GUI System
local gui = Instance.new("ScreenGui")
gui.Name = HttpService:GenerateGUID(false)
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local elements = {
    title = Instance.new("TextLabel"),
    toggleBtn = Instance.new("TextButton"),
    status = Instance.new("TextLabel"),
    progress = Instance.new("Frame"),
    stealthMode = Instance.new("TextButton"),
    antiAfk = Instance.new("TextButton"),
    debugInfo = Instance.new("TextLabel")
}

-- GUI Elements Configuration
do
    -- Title
    elements.title.Text = "GHOST FARM v3"
    elements.title.TextColor3 = Color3.new(1, 1, 1)
    elements.title.Size = UDim2.new(1, 0, 0, 25)
    elements.title.Position = UDim2.new(0, 0, 0, 5)
    elements.title.BackgroundTransparency = 1
    elements.title.Font = Enum.Font.SourceSansBold
    elements.title.TextSize = 20
    elements.title.Parent = mainFrame

    -- Toggle Button
    elements.toggleBtn.Text = "▶ START"
    elements.toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    elements.toggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
    elements.toggleBtn.Position = UDim2.new(0.1, 0, 0, 30)
    elements.toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 90)
    elements.toggleBtn.Font = Enum.Font.SourceSansBold
    elements.toggleBtn.TextSize = 16
    elements.toggleBtn.Parent = mainFrame

    -- Progress Bar
    elements.progress.Size = UDim2.new(0.8, 0, 0, 4)
    elements.progress.Position = UDim2.new(0.1, 0, 0, 70)
    elements.progress.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    elements.progress.BorderSizePixel = 0
    elements.progress.Parent = mainFrame

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(90, 180, 120)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = elements.progress

    -- Status Label
    elements.status.Text = "Status: Idle"
    elements.status.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    elements.status.Size = UDim2.new(0.8, 0, 0, 20)
    elements.status.Position = UDim2.new(0.1, 0, 0, 80)
    elements.status.BackgroundTransparency = 1
    elements.status.Font = Enum.Font.SourceSans
    elements.status.TextSize = 14
    elements.status.Parent = mainFrame

    -- Stealth Mode Toggle
    elements.stealthMode.Text = "🔒 Stealth: ON"
    elements.stealthMode.TextColor3 = Color3.new(1, 1, 1)
    elements.stealthMode.Size = UDim2.new(0.4, 0, 0, 25)
    elements.stealthMode.Position = UDim2.new(0.1, 0, 0, 110)
    elements.stealthMode.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    elements.stealthMode.Font = Enum.Font.SourceSans
    elements.stealthMode.TextSize = 14
    elements.stealthMode.Parent = mainFrame

    -- Anti-AFK System
    elements.antiAfk.Text = "🛡 Anti-AFK: ON"
    elements.antiAfk.TextColor3 = Color3.new(1, 1, 1)
    elements.antiAfk.Size = UDim2.new(0.4, 0, 0, 25)
    elements.antiAfk.Position = UDim2.new(0.5, 0, 0, 110)
    elements.antiAfk.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    elements.antiAfk.Font = Enum.Font.SourceSans
    elements.antiAfk.TextSize = 14
    elements.antiAfk.Parent = mainFrame

    -- Debug Info
    elements.debugInfo.Text = "Device ID: "..generateFakeDeviceId()
    elements.debugInfo.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    elements.debugInfo.Size = UDim2.new(0.8, 0, 0, 15)
    elements.debugInfo.Position = UDim2.new(0.1, 0, 0, 180)
    elements.debugInfo.BackgroundTransparency = 1
    elements.debugInfo.Font = Enum.Font.SourceSans
    elements.debugInfo.TextSize = 12
    elements.debugInfo.Parent = mainFrame
end

-- Core System Variables
local farm = {
    active = false,
    stealth = true,
    antiAfk = true,
    throwPosition = nil,
    safePosition = Vector3.new(0, 100, 0),
    loopDelay = 2.5,
    tweenSpeed = 0.7,
    rngOffset = 3
}

local connections = {}
local fakeDeviceId = generateFakeDeviceId()

-- Advanced Movement System
local function smoothTeleport(cframe)
    local startPos = player.Character.HumanoidRootPart.Position
    local tween = TweenService:Create(
        player.Character.HumanoidRootPart,
        TweenInfo.new(farm.tweenSpeed, Enum.EasingStyle.Quad),
        {CFrame = cframe + Vector3.new(
            random:NextNumber(-farm.rngOffset, farm.rngOffset),
            0,
            random:NextNumber(-farm.rngOffset, farm.rngOffset)
        }
    )
    
    if farm.stealth then
        tween:Play()
        tween.Completed:Wait()
    else
        player.Character.HumanoidRootPart.CFrame = cframe
    end
end

-- Smart Position Detection
local function updateThrowPosition()
    local potentialTargets = {"Launcher", "LaunchPad", "YeetPlatform", "Thrower"}
    for _, name in ipairs(potentialTargets) do
        local obj = workspace:FindFirstChild(name)
        if obj then
            farm.throwPosition = obj.Position
            return
        end
    end
    farm.throwPosition = Vector3.new(0, 50, 0)
end

-- Anti-Detection Systems
local function randomizeInputs()
    if farm.antiAfk then
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.W, false, fakeDeviceId)
        task.wait(0.1)
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.W, false, fakeDeviceId)
    end
end

local function fakeNetworkActivity()
    if math.random(1, 100) > 95 then
        safeFireServer(
            game:GetService("ReplicatedStorage").NetworkEvent,
            "Ping",
            HttpService:GenerateGUID(false)
        )
    end
end

-- Main Farm Loop
local function farmCycle()
    while farm.active do
        updateThrowPosition()
        smoothTeleport(CFrame.new(farm.throwPosition + Vector3.new(0, 5, 0)))
        task.wait(farm.loopDelay * 0.7)
        smoothTeleport(CFrame.new(farm.safePosition))
        task.wait(farm.loopDelay * 0.3)
        randomizeInputs()
        fakeNetworkActivity()
    end
end

-- GUI Handlers
elements.toggleBtn.MouseButton1Click:Connect(function()
    farm.active = not farm.active
    elements.toggleBtn.Text = farm.active and "⏹ STOP" or "▶ START"
    elements.status.Text = farm.active and "Status: Farming..." or "Status: Idle"
    elements.toggleBtn.BackgroundColor3 = farm.active and Color3.fromRGB(180, 70, 70) or Color3.fromRGB(60, 160, 90)
    
    if farm.active then
        updateThrowPosition()
        connections.farmThread = task.spawn(farmCycle)
    else
        if connections.farmThread then
            task.cancel(connections.farmThread)
        end
    end
end)

elements.stealthMode.MouseButton1Click:Connect(function()
    farm.stealth = not farm.stealth
    elements.stealthMode.Text = farm.stealth and "🔒 Stealth: ON" or "🔓 Stealth: OFF"
end)

elements.antiAfk.MouseButton1Click:Connect(function()
    farm.antiAfk = not farm.antiAfk
    elements.antiAfk.Text = farm.antiAfk and "🛡 Anti-AFK: ON" or "🛡 Anti-AFK: OFF"
end)

-- Auto-Reconnect System
player.CharacterAdded:Connect(function(newChar)
    local humanoid = newChar:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if farm.active then
            farm.active = false
            task.wait(3)
            farm.active = true
            connections.farmThread = task.spawn(farmCycle)
        end
    end)
end)

-- Memory Cleanup
gui.Destroying:Connect(function()
    table.clear(farm)
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    table.clear(connections)
end)

-- Performance Optimization
RunService.Heartbeat:Connect(function()
    if farm.active then
        local progress = (tick() % farm.loopDelay) / farm.loopDelay
        elements.progress:FindFirstChildWhichIsA("Frame").Size = UDim2.new(progress, 0, 1, 0)
    else
        elements.progress:FindFirstChildWhichIsA("Frame").Size = UDim2.new(0, 0, 1, 0)
    end
end)
