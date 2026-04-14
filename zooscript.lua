-- 🧩 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🪟 Buat Window
local Window = Rayfield:CreateWindow({
    Name = "Zoo Premium Hub",
    Icon = 0,
    LoadingTitle = "Loading Zoo Script...",
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

-- 📦 Services & Remotes (Didefinisikan sekali di awal)
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
-- 🥚 Section: Celeste Egg Shop
-------------------------------------------------------
MainTab:CreateSection("Celeste Egg Multi-Buy")

-- Tombol Beli x1
MainTab:CreateButton({
    Name = "Buy Celeste Egg (x1)",
    Callback = function()
        -- Catatan: Jika CelesteEgg_x1 tidak muncul, ganti string di bawah jadi "CelesteEgg"
        local args = { "CelesteEgg_x1" }
        local success, err = pcall(function()
            ProductBuyRF:InvokeServer(unpack(args))
        end)
        if not success then warn("Error:", err) end
    end,
})

-- Tombol Beli x3
MainTab:CreateButton({
    Name = "Buy Celeste Egg (x3)",
    Callback = function()
        -- Catatan: Sesuai eksperimenmu, jika x3 gagal, ganti string jadi "CelesteEgg"
        local args = { "CelesteEgg_x3" } 
        local success, err = pcall(function()
            ProductBuyRF:InvokeServer(unpack(args))
        end)
        if not success then warn("Error:", err) end
    end,
})

-- Tombol Beli x10
MainTab:CreateButton({
    Name = "Buy Celeste Egg (x10)",
    Callback = function()
        local args = { "CelesteEgg_x10" }
        local success, err = pcall(function()
            ProductBuyRF:InvokeServer(unpack(args))
        end)
        if not success then warn("Error:", err) end
    end,
})

-------------------------------------------------------
-- 🔍 Section: Troubleshooting
-------------------------------------------------------
MainTab:CreateSection("Bantuan (Jika Tombol Gagal)")

MainTab:CreateButton({
    Name = "Mode Spy (Cek Nama Asli di F9)",
    Callback = function()
        Rayfield:Notify({Title = "Spy Aktif!", Content = "Klik tombol beli asli di Shop Game sekarang!", Duration = 5})
        
        local oldInvoke
        oldInvoke = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            if tostring(self) == "ProductBuyRF" and getnamecallmethod() == "InvokeServer" then
                print("--- NAMA ITEM ASLI: " .. tostring(args[1]) .. " ---")
                Rayfield:Notify({Title = "Item Ditemukan!", Content = tostring(args[1]), Duration = 10})
            end
            return oldInvoke(self, ...)
        end)
    end,
})

-------------------------------------------------------
-- 🎉 Notifikasi Selesai
-------------------------------------------------------
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Tekan K untuk menyembunyikan menu.",
    Duration = 5,
    Image = 4483362458,
})
