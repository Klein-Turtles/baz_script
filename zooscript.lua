-- 🧩 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🪟 Buat Window
local Window = Rayfield:CreateWindow({
    Name = "Zoo Premium Hub",
    Icon = 0,
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by Tegar",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "ZooHubConfig"
    }
})

-- 📑 Tab Utama
local MainTab = Window:CreateTab("Home", nil)

-- 📦 Services & Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FoodStoreRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("FoodStoreRE")
local ProductBuyRF = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ProductBuyRF")

-------------------------------------------------------
-- 🎚️ Section: Utilities
-------------------------------------------------------
MainTab:CreateSection("Graphics & Utilities")

local lowGraphicInitialized = false
MainTab:CreateToggle({
    Name = "Low Graphic Mode (Anti-Lag)",
    CurrentValue = false,
    Flag = "LowGraphicToggle",
    Callback = function(Value)
        if not lowGraphicInitialized then
            lowGraphicInitialized = true
            return
        end

        local RunService = game:GetService("RunService")
        local SoundService = game:GetService("SoundService")
        local player = game:GetService("Players").LocalPlayer
        local PlayerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)

        if Value then
            if not PlayerGui:FindFirstChild("LowGraphicOverlay") then
                local gui = Instance.new("ScreenGui", PlayerGui)
                gui.Name = "LowGraphicOverlay"
                gui.IgnoreGuiInset = true
                local frame = Instance.new("Frame", gui)
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(0, 0, 0)
                frame.BorderSizePixel = 0
            end
            pcall(function() RunService:Set3dRenderingEnabled(false) end)
            pcall(function() SoundService.Volume = 0 end)
        else
            local overlay = PlayerGui:FindFirstChild("LowGraphicOverlay")
            if overlay then overlay:Destroy() end
            pcall(function() RunService:Set3dRenderingEnabled(true) end)
            pcall(function() SoundService.Volume = 1 end)
        end
    end,
})

-------------------------------------------------------
-- 🍎 Section: Auto Buy Food
-------------------------------------------------------
MainTab:CreateSection("Auto Farming")

local SelectedFoods = {}
local AutoBuyRunning = false

MainTab:CreateDropdown({
    Name = "Select Foods to Auto Buy",
    Options = {"FrankenKiwi", "Pumpkin", "CandyCorn", "Durian", "VoltGinkgo", "ColossalPinecone"},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "FoodDropdown",
    Callback = function(Options)
        SelectedFoods = Options
    end,
})

MainTab:CreateToggle({
    Name = "Auto Buy Selected Foods (45s)",
    CurrentValue = false,
    Flag = "AutoBuyFoodToggle",
    Callback = function(Value)
        AutoBuyRunning = Value
        if Value then
            task.spawn(function()
                while AutoBuyRunning do
                    if #SelectedFoods > 0 then
                        for _, food in ipairs(SelectedFoods) do
                            pcall(function() FoodStoreRE:FireServer(food) end)
                        end
                    end
                    task.wait(45)
                end
            end)
        end
    end,
})

-------------------------------------------------------
-- 🥚 Section: Premium Shop (DIBETULIN TOTAL)
-------------------------------------------------------
MainTab:CreateSection("Premium Eggs")

-- Button 1: Celeste Egg
MainTab:CreateButton({
    Name = "Buy Celeste Egg (x3 Mode)",
    Callback = function()
        local success, err = pcall(function()
            -- Sesuai eksperimenmu, "CelesteEgg" memicu x3
            ProductBuyRF:InvokeServer("CelesteEgg_x10")
        end)
        if not success then warn("Error Celeste:", err) end
    end,
})

-- Button 2: Princess Egg (DIPERBAIKI: Tidak jalan otomatis)
MainTab:CreateButton({
    Name = "Buy Princess Egg x10",
    Callback = function()
        local success, err = pcall(function()
            -- Gunakan nama yang paling mungkin benar (pastikan hasil Scanner F9)
            ProductBuyRF:InvokeServer("PrincessEgg_x10")
        end)
        if not success then warn("Error Princess:", err) end
    end,
})

-- Button 3: Cyber Dragon
MainTab:CreateButton({
    Name = "Buy Cyber Dragon x1",
    Callback = function()
        local success, err = pcall(function()
            ProductBuyRF:InvokeServer("CyberDragonEgg_x1")
        end)
        if not success then warn("Error Cyber:", err) end
    end,
})

-- Tombol Tambahan: Scanner Otomatis (Buat nyari nama asli item)
MainTab:CreateButton({
    Name = "Scan Item Names (Lihat di F9)",
    Callback = function()
        Rayfield:Notify({Title = "Scanning...", Content = "Cek Console (F9) untuk hasil", Duration = 3})
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ModuleScript") then
                local s, data = pcall(function() return require(v) end)
                if s and type(data) == "table" then
                    for i, _ in pairs(data) do
                        local n = tostring(i)
                        if n:find("Egg") or n:find("Princess") or n:find("Celeste") then
                            print("Ditemukan di " .. v.Name .. " -> Nama: " .. n)
                        end
                    end
                end
            end
        end
    end,
})

-------------------------------------------------------
-- 🎉 Notifikasi Selesai
-------------------------------------------------------
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Ready to use! Press K to Toggle UI.",
    Duration = 5,
    Image = 4483362458,
})
