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
-- ==== Robust Auto-Buy implementation (replace your previous auto-buy blocks) ====

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Helper: try find remote by common names under ReplicatedStorage (non-destructive)
local function findRemote(possibleNames)
    -- check common direct children first
    for _, name in ipairs(possibleNames) do
        local r = ReplicatedStorage:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction") or r:IsA("Folder")) then
            return r
        end
    end

    -- search deeper for RemoteEvent with matching names
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            for _, name in ipairs(possibleNames) do
                if obj.Name:lower():match(name:lower()) then
                    return obj
                end
            end
        end
    end

    -- not found
    return nil
end

-- Helper: convert dropdown label into probable internal id (Basic Egg -> BasicEgg)
local function toInternalEggName(label)
    -- common transforms, extend if needed
    local map = {
        ["Basic Egg"] = "BasicEgg",
        ["Rare Egg"] = "RareEgg",
        ["Super Rare Egg"] = "SuperRareEgg",
        ["Hyper Egg"] = "HyperEgg",
        ["Void Egg"] = "VoidEgg",
        ["Bowser Egg"] = "BowserEgg",
        ["Shark Egg"] = "SharkEgg",
        ["UnicornProEgg"] = "UnicornProEgg", -- passthrough examples
    }
    if map[label] then return map[label] end
    -- fallback: remove spaces and punctuation
    return label:gsub("%s+", ""):gsub("[^%w]", "")
end

local function toInternalFoodName(label)
    local map = {
        ["Banana"] = "Banana",
        ["Pineapple"] = "Pineapple",
        ["Gold Mango"] = "GoldMango",
        ["Deep Sea Pearl Fruit"] = "DeepSeaPearlFruit",
        ["Colossal Pinecone"] = "ColossalPinecone",
    }
    if map[label] then return map[label] end
    return label:gsub("%s+", ""):gsub("[^%w]", "")
end

-- ===== Egg UI: dropdown + toggle (robust) =====
local selectedEggLabel = "Basic Egg"
MainTab:CreateDropdown({
    Name = "Select Egg",
    Options = {"Basic Egg", "Rare Egg", "Super Rare Egg", "Hyper Egg", "Void Egg", "Bowser Egg", "Shark Egg"},
    CurrentOption = {selectedEggLabel},
    MultipleOptions = false,
    Flag = "EggDropdown",
    Callback = function(Options)
        selectedEggLabel = Options[1]
        warn("[UI] Selected egg label:", selectedEggLabel)
    end,
})

local autoEgg = false
MainTab:CreateToggle({
    Name = "Auto Buy Egg",
    CurrentValue = false,
    Flag = "AutoBuyEggToggle",
    Callback = function(Value)
        autoEgg = Value
        if not player then
            warn("[AutoBuyEgg] LocalPlayer missing. Run client-side.")
            return
        end

        if autoEgg then
            task.spawn(function()
                warn("[AutoBuyEgg] started loop")
                while autoEgg do
                    -- map label to internal name
                    local internalEgg = toInternalEggName(selectedEggLabel)
                    -- try find a sensible remote (common candidates)
                    local remote = findRemote({"ResourceRE", "BuyEgg", "BuyEggEvent", "Resource", "ResourceRE", "Remote"}) 
                    if not remote then
                        -- debug: list some remote names to console for help
                        warn("[AutoBuyEgg] No RemoteEvent found under ReplicatedStorage. Available Remotes (sample):")
                        for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
                            if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                                warn(" - ", d:GetFullName())
                            end
                        end
                        -- wait a bit and retry
                        task.wait(5)
                    else
                        -- show which remote used
                        warn("[AutoBuyEgg] Using remote:", remote:GetFullName(), "-> buying", internalEgg)
                        -- call remote safely: many games expect FireServer("PULL","Eggs/Name") like your example
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                -- try common argument patterns (try several to maximize chance)
                                local ok, err = pcall(function()
                                    -- first try pattern "PULL","Eggs/Name"
                                    remote:FireServer("PULL", "Eggs/"..internalEgg)
                                end)
                                if not ok then
                                    -- try alternative pattern: internal only
                                    remote:FireServer(internalEgg)
                                end
                            elseif remote:IsA("RemoteFunction") then
                                -- try invoke patterns
                                pcall(function() remote:InvokeServer("PULL", "Eggs/"..internalEgg) end)
                            end
                        end)
                        -- notification & wait
                        pcall(function()
                            starterGui:SetCore("SendNotification", {
                                Title = "Auto Buy Egg",
                                Text = "Membeli "..selectedEggLabel.." ("..internalEgg..")",
                                Duration = 3
                            })
                        end)
                        task.wait(45)
                    end
                end
                warn("[AutoBuyEgg] stopped loop")
            end)
        else
            warn("[AutoBuyEgg] toggled off")
        end
    end,
})

-- ===== Food UI: dropdown + toggle (robust) =====
local selectedFoodLabel = "Banana"
MainTab:CreateDropdown({
    Name = "Select Food",
    Options = {"Banana", "Pineapple", "Gold Mango", "Deep Sea Pearl Fruit", "Colossal Pinecone"},
    CurrentOption = {selectedFoodLabel},
    MultipleOptions = false,
    Flag = "FoodDropdown",
    Callback = function(Options)
        selectedFoodLabel = Options[1]
        warn("[UI] Selected food label:", selectedFoodLabel)
    end,
})

local autoFood = false
MainTab:CreateToggle({
    Name = "Auto Buy Food",
    CurrentValue = false,
    Flag = "AutoBuyFoodToggle",
    Callback = function(Value)
        autoFood = Value
        if not player then
            warn("[AutoBuyFood] LocalPlayer missing. Run client-side.")
            return
        end

        if autoFood then
            task.spawn(function()
                warn("[AutoBuyFood] started loop")
                while autoFood do
                    local internalFood = toInternalFoodName(selectedFoodLabel)
                    local remote = findRemote({"ResourceRE2", "BuyFood", "BuyFoodEvent", "FoodRemote", "Resource"})
                    if not remote then
                        warn("[AutoBuyFood] No RemoteEvent found. Available Remotes:")
                        for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
                            if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                                warn(" - ", d:GetFullName())
                            end
                        end
                        task.wait(5)
                    else
                        warn("[AutoBuyFood] Using remote:", remote:GetFullName(), "-> buying", internalFood)
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                local ok = pcall(function()
                                    remote:FireServer("BUY", "Food/"..internalFood)
                                end)
                                if not ok then
                                    remote:FireServer(internalFood)
                                end
                            elseif remote:IsA("RemoteFunction") then
                                pcall(function() remote:InvokeServer("BUY", "Food/"..internalFood) end)
                            end
                        end)
                        pcall(function()
                            starterGui:SetCore("SendNotification", {
                                Title = "Auto Buy Food",
                                Text = "Membeli "..selectedFoodLabel.." ("..internalFood..")",
                                Duration = 3
                            })
                        end)
                        task.wait(45)
                    end
                end
                warn("[AutoBuyFood] stopped loop")
            end)
        else
            warn("[AutoBuyFood] toggled off")
        end
    end,
})

-- ===== Mutation dropdown (inline apply) =====
MainTab:CreateDropdown({
    Name = "Mutation Type",
    Options = {"Jurassic", "Snow", "Halloween"},
    CurrentOption = {"Jurassic"},
    MultipleOptions = false,
    Flag = "MutationDropdown",
    Callback = function(Options)
        local selectedMutation = Options[1]
        local remote = findRemote({"MutationRE", "ApplyMutation", "MutationEvent", "MutationRemote"})
        if not remote then
            warn("[Mutation] remote not found. Check ReplicatedStorage for mutation remotes.")
            return
        end
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer("APPLY", selectedMutation)
            else
                remote:InvokeServer("APPLY", selectedMutation)
            end
        end)
        starterGui:SetCore("SendNotification", {
            Title = "Mutation",
            Text = "Applied "..selectedMutation,
            Duration = 3
        })
    end,
})

-- ===== End of auto-buy block =====
