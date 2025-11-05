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
-- 🧱 Fungsi utama: Low Graphic Mode
-------------------------------------------------------
local function setLowGraphicMode(enable)
   local RunService = game:GetService("RunService")
   local SoundService = game:GetService("SoundService")
   local Lighting = game:GetService("Lighting")
   local Players = game:GetService("Players")
   local player = Players.LocalPlayer
   if not player then return end

   local PlayerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)

   if enable then
      print("[Low Graphic Mode] ENABLED")

      -- 🖤 Overlay hitam agar tampak seperti “no render”
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

      -- 🚫 Matikan render, suara, efek visual
      pcall(function() RunService:Set3dRenderingEnabled(false) end)
      pcall(function() SoundService.Volume = 0 end)

      for _, obj in ipairs(workspace:GetDescendants()) do
         if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
            pcall(function() obj.Enabled = false end)
         end
      end

      -- 🔦 Turunkan lighting
      pcall(function()
         Lighting.GlobalShadows = false
         Lighting.FogEnd = 200
         Lighting.Brightness = 1
      end)

      -- 🔔 Notifikasi
      game.StarterGui:SetCore("SendNotification", {
         Title = "Low Graphic Mode",
         Text = "Activated ✅",
         Duration = 3
      })

   else
      print("[Low Graphic Mode] DISABLED")

      -- 🔁 Pulihkan pengaturan
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
end

-------------------------------------------------------
-- 🎚️ Toggle UI
-------------------------------------------------------
local Toggle = MainTab:CreateToggle({
   Name = "Low Graphic Mode",
   CurrentValue = false,
   Flag = "LowGraphicToggle",
   Callback = function(Value)
      setLowGraphicMode(Value)
   end,
})
