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
-- 🍌 Auto Buy Food (Dynamic Delay System)
-------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE")

local foodList = {"FrankenKiwi", "Pumpkin", "CandyCorn", "Durian", "VoltGingko", "ColossalPinecone"}
local delayTime = 45 -- detik antar pembelian

_G.AutoBuyFoodActive = false
_G.SelectedFood = foodList[1]

-- Dropdown pilih makanan
MainTab:CreateDropdown({
   Name = "Select Food Type",
   Options = foodList,
   CurrentOption = {"FrankenKiwi"},
   MultipleOptions = false,
   Flag = "FoodTypeDropdown",
   Callback = function(Options)
      _G.SelectedFood = Options[1]
      game.StarterGui:SetCore("SendNotification", {
         Title = "Food Target Updated",
         Text = "Sekarang target makanan: " .. _G.SelectedFood .. " 🍎",
         Duration = 3
      })
   end,
})

-- Toggle auto buy makanan
MainTab:CreateToggle({
   Name = "Auto Buy Food",
   CurrentValue = false,
   Flag = "AutoBuyFoodToggle",
   Callback = function(Value)
      _G.AutoBuyFoodActive = Value

      if Value then
         game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Buy Food",
            Text = "🟢 Dinyalakan — target: " .. _G.SelectedFood,
            Duration = 3
         })

         task.spawn(function()
            while _G.AutoBuyFoodActive do
               pcall(function()
                  CharacterRE:FireServer("BuyFood", _G.SelectedFood)
               end)

               game.StarterGui:SetCore("SendNotification", {
                  Title = "Auto Buy Food",
                  Text = "Membeli " .. _G.SelectedFood .. " 🍎",
                  Duration = 4
               })

               task.wait(delayTime)
            end
         end)

      else
         game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Buy Food",
            Text = "🔴 Dimatikan",
            Duration = 3
         })
      end
   end,
})
