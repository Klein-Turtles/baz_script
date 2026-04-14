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

-- 📑 Tab Utama
local MainTab = Window:CreateTab("Home", nil)

-------------------------------------------------------
-- 🎚️ Feature Section
-------------------------------------------------------
MainTab:CreateSection("Graphics & Utilities")

local lowGraphicInitialized = false
MainTab:CreateToggle({
   Name = "Low Graphic Mode",
   CurrentValue = false,
   Flag = "LowGraphicToggle",
   Callback = function(Value)
      if not lowGraphicInitialized then
         lowGraphicInitialized = true
         return
      end

      local RunService = game:GetService("RunService")
      local SoundService = game:GetService("SoundService")
      local Lighting = game:GetService("Lighting")
      local player = game:GetService("Players").LocalPlayer
      if not player then return end
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
-- 🍎 Auto Buy Food Section
-------------------------------------------------------
MainTab:CreateSection("Auto Farming")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FoodStoreRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("FoodStoreRE")
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
-- 🥚 Shop / Eggs Section (DIBETULIN DI SINI)
-------------------------------------------------------
MainTab:CreateSection("Premium Eggs")

-- Button 1: Celeste Egg
MainTab:CreateButton({
   Name = "Buy Celeste Egg x10",
   Callback = function()
      local success, err = pcall(function()
         local remote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ProductBuyRF")
         remote:InvokeServer("CelesteEgg_x1")
      end)
      if not success then warn("Error Celeste:", err) end
   end,
})

-- Button 2: Princess Egg (DITAMBAHKAN DI BAWAHNYA)
local remote = game:GetService("ReplicatedStorage").Remote.ProductBuyRF
local commonNames = {
    "PrincessEgg_x10",
    "Princess_Egg_x10",
    "Princess_x10",
    "Princess_Egg",
    "PrincessEgg",
    "EggPrincess_x10"
}

for _, name in pairs(commonNames) do
    print("Mencoba nama: " .. name)
    pcall(function()
        remote:InvokeServer(name)
    end)
    task.wait(1) -- Jeda 1 detik biar nggak dianggap spam/kick
end

-- Button 3: Cyber Dragon (Contoh x1)
MainTab:CreateButton({
   Name = "Buy Cyber Dragon x1",
   Callback = function()
      local success, err = pcall(function()
         local remote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ProductBuyRF")
         remote:InvokeServer("CyberDragonEgg_x1")
      end)
      if not success then warn("Error Cyber:", err) end
   end,
})

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Ready to Crot!",
   Duration = 5,
   Image = 4483362458,
})
