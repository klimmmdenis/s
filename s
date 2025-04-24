-- Ultra Game Farm Script v4.1 (Stealth Mode)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Anti-detection
local player = Players.LocalPlayer
local fakePrint = function() end
local security = {
    FakeDeviceId = tostring(math.random(1e9, 1e10)),
    RandomDelay = function() return math.random(150, 350)/100 end
}

-- Auto-GUI System
local gui = Instance.new("ScreenGui")
gui.Name = "FarmGUI_"..tick()
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 160)
mainFrame.Position = UDim2.new(0.8, 0, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local elements = {
    title = Instance.new("TextLabel"),
    toggleBtn = Instance.new("TextButton"),
    status = Instance.new("TextLabel"),
    stealthToggle = Instance.new("TextButton"),
    stats = Instance.new("TextLabel")
}

-- GUI Setup
do
    elements.title.Text = "AUTO FARM v4"
    elements.title.TextColor3 = Color3.new(1, 1, 1)
    elements.title.Size = UDim2.new(1, 0, 0, 25)
    elements.title.Position = UDim2.new(0, 0, 0, 5)
    elements.title.BackgroundTransparency = 1
    elements.title.Font = Enum.Font.SourceSansBold
    elements.title.TextSize = 18
    elements.title.Parent = mainFrame

    elements.toggleBtn.Text = "▶ START"
    elements.toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    elements.toggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
    elements.toggleBtn.Position = UDim2.new(0.05, 0, 0, 30)
    elements.toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 90)
    elements.toggleBtn.Font = Enum.Font.SourceSansBold
    elements.toggleBtn.TextSize = 16
    elements.toggleBtn.Parent = mainFrame

    elements.status.Text = "Status: Ready"
    elements.status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    elements.status.Size = UDim2.new(0.9, 0, 0, 20)
    elements.status.Position = UDim2.new(0.05, 0, 0, 75)
    elements.status.BackgroundTransparency = 1
    elements.status.Font = Enum.Font.SourceSans
    elements.status.TextSize = 14
    elements.status.Parent = mainFrame

    elements.stealthToggle.Text = "STEALTH: ON"
    elements.stealthToggle.TextColor3 = Color3.new(1, 1, 1)
    elements.stealthToggle.Size = UDim2.new(0.45, 0, 0, 30)
    elements.stealthToggle.Position = UDim2.new(0.05, 0, 0, 100)
    elements.stealthToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
    elements.stealthToggle.Font = Enum.Font.SourceSans
    elements.stealthToggle.TextSize = 14
    elements.stealthToggle.Parent = mainFrame

    elements.stats.Text = "Farmed: 0 | XP: 0"
    elements.stats.TextColor3 = Color3.new(0.7, 0.7, 1)
    elements.stats.Size = UDim2.new(0.9, 0, 0, 15)
    elements.stats.Position = UDim2.new(0.05, 0, 0, 140)
    elements.stats.BackgroundTransparency = 1
    elements.stats.Font = Enum.Font.SourceSans
    elements.stats.TextSize = 12
    elements.stats.Parent = mainFrame
end

-- Core System
local farm = {
    Active = false,
    StealthMode = true,
    Stats = {Farmed = 0, XP = 0},
    Targets = {"Money", "Coins", "Gold", "XP", "Orbs"},
    SafeSpot = Vector3.new(0, 100, 0)
}

-- Smart Teleport Function
local function safeTeleport(cframe)
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root then
        if farm.StealthMode then
            local tween = TweenService:Create(
                root,
                TweenInfo.new(0.7, Enum.EasingStyle.Quad),
                {CFrame = cframe}
            )
            tween:Play()
            tween.Completed:Wait()
        else
            root.CFrame = cframe
        end
    end
end

-- Main Farm Loop
local function farmAction()
    while farm.Active do
        -- Find targets
        local target
        for _, objName in ipairs(farm.Targets) do
            target = workspace:FindFirstChild(objName, true)
            if target then break end
        end

        if target then
            -- Farm logic
            safeTeleport(target.CFrame * CFrame.new(0, 3, 0))
            task.wait(security.RandomDelay())
            safeTeleport(CFrame.new(farm.SafeSpot))
            
            -- Update stats
            farm.Stats.Farmed = farm.Stats.Farmed + 1
            farm.Stats.XP = farm.Stats.XP + (math.random(5, 15))
            elements.stats.Text = string.format("Farmed: %d | XP: %d", farm.Stats.Farmed, farm.Stats.XP)
        end
        
        task.wait(security.RandomDelay())
    end
end

-- GUI Controls
elements.toggleBtn.MouseButton1Click:Connect(function()
    farm.Active = not farm.Active
    elements.toggleBtn.Text = farm.Active and "⏹ STOP" or "▶ START"
    elements.status.Text = farm.Active and "Status: Farming..." or "Status: Stopped"
    elements.toggleBtn.BackgroundColor3 = farm.Active and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(60, 160, 90)
    
    if farm.Active then
        coroutine.wrap(farmAction)()
    end
end)

elements.stealthToggle.MouseButton1Click:Connect(function()
    farm.StealthMode = not farm.StealthMode
    elements.stealthToggle.Text = farm.StealthMode and "STEALTH: ON" or "STEALTH: OFF"
    elements.stealthToggle.BackgroundColor3 = farm.StealthMode and Color3.fromRGB(70, 70, 120) or Color3.fromRGB(120, 70, 70)
end)

-- Auto-Reconnect
player.CharacterAdded:Connect(function(character)
    if farm.Active then
        character:WaitForChild("Humanoid").Died:Connect(function()
            task.wait(3)
            if farm.Active then
                safeTeleport(CFrame.new(farm.SafeSpot))
            end
        end)
    end
end)

-- Anti-AFK
local VirtualInput = game:GetService("VirtualInputManager")
spawn(function()
    while true do
        if farm.Active then
            VirtualInput:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.1)
            VirtualInput:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end
        task.wait(25)
    end
end)

fakePrint("Script loaded successfully! | DeviceID: "..security.FakeDeviceId)
