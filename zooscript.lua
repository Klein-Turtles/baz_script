-- 🧩 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🪟 Buat Window
local Window = Rayfield:CreateWindow({
   Name = "Zoo Crot Enak",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "Aji Jembut",
   Theme = "Default",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "Big Hub"
   }
})

-- 📑 Tab utama
local MainTab = Window:CreateTab("Home", nil)
MainTab:CreateSection("Feature")

-------------------------------------------------------
-- 🎚️ Toggle: Low Graphic Mode
-------------------------------------------------------
local lowGraphicInitialized = false

MainTab:CreateToggle({
   Name = "Low Graphic Mode",
   CurrentValue = false,
   Flag = "LowGraphicToggle",
   Callback = function(Value)
      -- Abaikan pemanggilan pertama (Rayfield kadang auto-call saat load)
      if not lowGraphicInitialized then
         lowGraphicInitialized = true
         return
      end

      -- 🧱 Semua fungsi langsung di sini
      local RunService = game:GetService("RunService")
      local SoundService = game:GetService("SoundService")
      local Lighting = game:GetService("Lighting")
      local Players = game:GetService("Players")
      local player = Players.LocalPlayer
      if not player then return end

      local PlayerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)

      if Value then
         print("[Low Graphic Mode] ENABLED")

         -- Overlay hitam
         if not PlayerGui:FindFirstChild("LowGraphicOverlay") then
            local gui = Instance.new("ScreenGui")
            gui.Name = "LowGraphicOverlay"
            gui.IgnoreGuiInset = true
            gui.ResetOnSpawn = false
            gui.DisplayOrder = 9999

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.new(0, 0, 0)
            frame.BackgroundTransparency = 0
            frame.BorderSizePixel = 0
            frame.Parent = gui

            gui.Parent = PlayerGui
         end

         -- Matikan visual
         pcall(function() RunService:Set3dRenderingEnabled(false) end)
         pcall(function() SoundService.Volume = 0 end)

         for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
               pcall(function() obj.Enabled = false end)
            end
         end

         -- Lighting minim
         pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 200
            Lighting.Brightness = 1
         end)

         game.StarterGui:SetCore("SendNotification", {
            Title = "Low Graphic Mode",
            Text = "Activated ✅",
            Duration = 3
         })
      else
         print("[Low Graphic Mode] DISABLED")

         -- Pulihkan tampilan
         local overlay = PlayerGui:FindFirstChild("LowGraphicOverlay")
         if overlay then overlay:Destroy() end

         pcall(function() RunService:Set3dRenderingEnabled(true) end)
         pcall(function() SoundService.Volume = 1 end)

         for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
               pcall(function() obj.Enabled = true end)
            end
         end

         pcall(function()
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
         end)

         game.StarterGui:SetCore("SendNotification", {
            Title = "Low Graphic Mode",
            Text = "Deactivated ❌",
            Duration = 3
         })
      end
   end,
})

-------------------------------------------------------
-- 🍓 Auto Buy Multiple Food (Final Version)
-------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local FoodStoreRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("FoodStoreRE")

local delayTime = 45
local foods = {
   "FrankenKiwi",
   "Pumpkin",
   "CandyCorn",
   "Durian",
   "VoltGingko",
   "ColossalPinecone"
}

_G.SelectedFoods = {}
_G.AutoBuyFoodEnabled = false

-------------------------------------------------------
-- 🥝 Dropdown untuk memilih beberapa buah
-------------------------------------------------------
MainTab:CreateDropdown({
   Name = "Select Foods",
   Options = foods,
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "FoodSelectDropdown",
   Callback = function(Options)
      _G.SelectedFoods = Options
      game.StarterGui:SetCore("SendNotification", {
         Title = "🍍 Auto Buy Food",
         Text = "Target diubah ke: " .. table.concat(_G.SelectedFoods, ", "),
         Duration = 4
      })
   end,
})

-------------------------------------------------------
-- 🍓 Auto Buy Multiple Food (Stable Delay Version)
-------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FoodStoreRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("FoodStoreRE")
local delayTime = 45

local availableFoods = {
   "FrankenKiwi",
   "Pumpkin",
   "CandyCorn",
   "Durian",
   "VoltGingko",
   "ColossalPinecone"
}

_G.SelectedFoods = {}
_G.AutoBuyFoodEnabled = false

-------------------------------------------------------
-- 🥝 Dropdown Multiple Select
-------------------------------------------------------
MainTab:CreateDropdown({
   Name = "Select Foods",
   Options = availableFoods,
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "FoodSelectDropdown",
   Callback = function(Options)
      _G.SelectedFoods = Options
      game.StarterGui:SetCore("SendNotification", {
         Title = "🍍 Food Target Updated",
         Text = "Sekarang: " .. (#Options > 0 and table.concat(Options, ", ") or "Tidak ada pilihan"),
         Duration = 4
      })
   end,
})

-------------------------------------------------------
-------------------------------------------------------
-- 🍉 AUTO BUY FOOD (MULTI SELECT, 45s DELAY, FIX)
-------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FoodStoreRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("FoodStoreRE")

local availableFoods = {
   "FrankenKiwi",
   "Pumpkin",
   "CandyCorn",
   "Durian",
   "VoltGingko",
   "ColossalPinecone"
}

_G.SelectedFoods = {}
_G.AutoBuyFoodEnabled = false
local delayTime = 45

-------------------------------------------------------
-- 🍌 Dropdown Pilihan Buah
-------------------------------------------------------
local FoodDropdown = MainTab:CreateDropdown({
   Name = "Select Foods to Auto Buy",
   Options = availableFoods,
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "FoodDropdown",
   Callback = function(Options)
      _G.SelectedFoods = Options
      game.StarterGui:SetCore("SendNotification", {
         Title = "🍍 Food Selection Updated",
         Text = (#Options > 0 and "Dipilih: " .. table.concat(Options, ", ") or "Tidak ada buah dipilih"),
         Duration = 4
      })
   end,
})

-------------------------------------------------------
-- 🍎 Toggle Auto Buy Loop
-------------------------------------------------------
MainTab:CreateToggle({
   Name = "Auto Buy Selected Foods (45s)",
   CurrentValue = false,
   Flag = "AutoBuyFoodToggle",
   Callback = function(Value)
      _G.AutoBuyFoodEnabled = Value

      if Value then
         game.StarterGui:SetCore("SendNotification", {
            Title = "🍓 Auto Buy Food",
            Text = "Dimulai! Beli tiap 45 detik untuk semua buah terpilih.",
            Duration = 4
         })

         task.spawn(function()
            while _G.AutoBuyFoodEnabled do
               if #_G.SelectedFoods > 0 then
                  for _, food in ipairs(_G.SelectedFoods) do
                     pcall(function()
                        FoodStoreRE:FireServer(food)
                     end)
                     print("[AutoBuyFood] Membeli:", food)
                  end

                  game.StarterGui:SetCore("SendNotification", {
                     Title = "🍎 Membeli Buah",
                     Text = "Membeli: " .. table.concat(_G.SelectedFoods, ", "),
                     Duration = 4
                  })
               else
                  warn("[AutoBuyFood] Tidak ada buah yang dipilih.")
               end

               -- Delay antar siklus pembelian
               for i = 1, delayTime do
                  if not _G.AutoBuyFoodEnabled then break end
                  task.wait(1)
               end
            end
         end)
      else
         game.StarterGui:SetCore("SendNotification", {
            Title = "🍇 Auto Buy Food",
            Text = "Berhenti.",
            Duration = 3
         })
      end
   end,
})


