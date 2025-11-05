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
-- 🥚 Dropdown Auto Buy Egg
-------------------------------------------------------
-------------------------------------------------------
-- 🥚 Dropdown Pilih Telur
-------------------------------------------------------
local selectedEgg = "Basic Egg"
MainTab:CreateDropdown({
   Name = "Select Egg",
   Options = {"Basic Egg", "Rare Egg", "Super Rare Egg", "Hyper Egg", "Void Egg", "Bowser Egg", "Shark Egg"},
   CurrentOption = {"Basic Egg"},
   MultipleOptions = false,
   Flag = "EggDropdown",
   Callback = function(Options)
      selectedEgg = Options[1]
   end,
})

local autoEgg = false
MainTab:CreateToggle({
   Name = "Auto Buy Egg",
   CurrentValue = false,
   Flag = "AutoBuyEggToggle",
   Callback = function(Value)
      autoEgg = Value

      if autoEgg then
         task.spawn(function()
            while autoEgg do
               local ReplicatedStorage = game:GetService("ReplicatedStorage")
               local buyEggEvent = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("ResourceRE")

               if not buyEggEvent then
                  warn("[AutoBuyEgg] Event tidak ditemukan!")
                  return
               end

               pcall(function()
                  buyEggEvent:FireServer("PULL", "Eggs/" .. selectedEgg)
               end)

               game.StarterGui:SetCore("SendNotification", {
                  Title = "Auto Buy Egg",
                  Text = "Membeli " .. selectedEgg .. " 🥚",
                  Duration = 3
               })

               task.wait(45) -- delay 45 detik antar pembelian
            end
         end)
      end
   end,
})

-------------------------------------------------------
-- 🍌 Dropdown Pilih Food
-------------------------------------------------------
local selectedFood = "Banana"
MainTab:CreateDropdown({
   Name = "Select Food",
   Options = {"Banana", "Pineapple", "Gold Mango", "Deep Sea Pearl Fruit", "Colossal Pinecone"},
   CurrentOption = {"Banana"},
   MultipleOptions = false,
   Flag = "FoodDropdown",
   Callback = function(Options)
      selectedFood = Options[1]
   end,
})

local autoFood = false
MainTab:CreateToggle({
   Name = "Auto Buy Food",
   CurrentValue = false,
   Flag = "AutoBuyFoodToggle",
   Callback = function(Value)
      autoFood = Value

      if autoFood then
         task.spawn(function()
            while autoFood do
               local ReplicatedStorage = game:GetService("ReplicatedStorage")
               local buyFoodEvent = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("ResourceRE2")

               if not buyFoodEvent then
                  warn("[AutoBuyFood] Event tidak ditemukan!")
                  return
               end

               pcall(function()
                  buyFoodEvent:FireServer("BUY", "Food/" .. selectedFood)
               end)

               game.StarterGui:SetCore("SendNotification", {
                  Title = "Auto Buy Food",
                  Text = "Membeli " .. selectedFood .. " 🍎",
                  Duration = 3
               })

               task.wait(45) -- delay 45 detik antar pembelian
            end
         end)
      end
   end,
})

-------------------------------------------------------
-- 🧬 Dropdown Pilih Mutation
-------------------------------------------------------
MainTab:CreateDropdown({
   Name = "Mutation Type",
   Options = {"Jurassic", "Snow", "Halloween"},
   CurrentOption = {"Jurassic"},
   MultipleOptions = false,
   Flag = "MutationDropdown",
   Callback = function(Options)
      local selectedMutation = Options[1]
      local ReplicatedStorage = game:GetService("ReplicatedStorage")
      local mutationEvent = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("MutationRE")

      if not mutationEvent then
         warn("[Mutation] Event tidak ditemukan!")
         return
      end

      pcall(function()
         mutationEvent:FireServer("APPLY", selectedMutation)
      end)

      game.StarterGui:SetCore("SendNotification", {
         Title = "Mutation Applied",
         Text = "Mutation: " .. selectedMutation .. " 🧬",
         Duration = 3
      })
   end,
})
