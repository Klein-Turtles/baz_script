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
-- 🍎 Toggle untuk mulai atau berhenti auto buy
-------------------------------------------------------
MainTab:CreateToggle({
   Name = "Auto Buy Food",
   CurrentValue = false,
   Flag = "AutoBuyFoodToggle",
   Callback = function(Value)
      _G.AutoBuyFoodEnabled = Value

      if Value then
         game.StarterGui:SetCore("SendNotification", {
            Title = "🍎 Auto Buy Food",
            Text = "Auto Buy dimulai untuk: " .. table.concat(_G.SelectedFoods, ", "),
            Duration = 4
         })

         task.spawn(function()
            while _G.AutoBuyFoodEnabled do
               for _, foodName in ipairs(_G.SelectedFoods) do
                  if not _G.AutoBuyFoodEnabled then break end

                  pcall(function()
                     FoodStoreRE:FireServer(foodName)
                  end)

                  game.StarterGui:SetCore("SendNotification", {
                     Title = "🍓 Auto Buy Food",
                     Text = "Membeli " .. foodName,
                     Duration = 3
                  })

                  task.wait(delayTime)
               end
            end
         end)
      else
         game.StarterGui:SetCore("SendNotification", {
            Title = "🍇 Auto Buy Food",
            Text = "Auto Buy dimatikan",
            Duration = 3
         })
      end
   end,
})

