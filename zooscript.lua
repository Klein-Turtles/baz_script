-- 🧩 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🪟 Buat Window
local Window = Rayfield:CreateWindow({
   Name = "Zoo Crot Enak",
   Icon = 0,
   LoadingTitle = "Crot Enak",
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
            Text = "Crot",
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
            Text = "Ngga Crot",
            Duration = 3
         })
      end
   end,
})

-------------------------------------------------------
-- 🍉 AUTO BUY FOOD (MULTI SELECT, SEMUA SEKALIGUS SETIAP 45 DETIK)
-------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FoodStoreRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("FoodStoreRE")

local availableFoods = {
   "FrankenKiwi",
   "Pumpkin",
   "CandyCorn",
   "Durian",
   "VoltGinkgo",
   "ColossalPinecone"
}

local SelectedFoods = {}
local AutoBuyRunning = false
local delayTime = 45

-------------------------------------------------------
-- 🍌 Dropdown Pilihan Buah
-------------------------------------------------------
local FoodDropdown = MainTab:CreateDropdown({
   Name = "Select Foods to Auto Buy",
   Options = availableFoods,
   CurrentOption = {},
   MultipleOptions = true, -- ✅ bisa pilih banyak
   Flag = "FoodDropdown",
   Callback = function(Options)
      SelectedFoods = Options
      game.StarterGui:SetCore("SendNotification", {
         Title = " Food Selection Updated",
         Text = (#Options > 0 and "Dipilih: " .. table.concat(Options, ", ") or "Tidak ada buah dipilih"),
         Duration = 4
      })
   end,
})

-------------------------------------------------------
-- 🍎 Toggle Auto Buy Loop
-------------------------------------------------------
MainTab:CreateToggle({
   Name = "Auto Buy Selected Foods (Every 45s)",
   CurrentValue = false,
   Flag = "AutoBuyFoodToggle",
   Callback = function(Value)
      AutoBuyRunning = Value

      if Value then
         game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Buy Food",
            Text = "Crot",
            Duration = 4
         })

         task.spawn(function()
            while AutoBuyRunning do
               if #SelectedFoods > 0 then
                  print("[AutoBuyFood] Membeli batch buah:", table.concat(SelectedFoods, ", "))
                  for _, food in ipairs(SelectedFoods) do
                     pcall(function()
                        FoodStoreRE:FireServer(food)
                     end)
                     print("[AutoBuyFood] Membeli:", food)
                  end

                  game.StarterGui:SetCore("SendNotification", {
                     Title = " Membeli Batch Buah",
                     Text = "Crot",
                     Duration = 3
                  })
               else
                  warn("Crot")
               end

               -- Tunggu 45 detik sebelum batch berikutnya
               for i = 1, delayTime do
                  if not AutoBuyRunning then break end
                  task.wait(1)
               end
            end
         end)
      else
         game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Buy Food",
            Text = "Berhenti.",
            Duration = 3
         })
      end
   end,
})

