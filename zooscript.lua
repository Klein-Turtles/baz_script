local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zoo Crot Enak",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "Aji Jembut",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",
   ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "Big Hub" },
})

local MainTab = Window:CreateTab("Home", nil)
-- buat section, dan pasang toggle di section ini
local MainSection = MainTab:CreateSection("Feature")

-- helper: safe get LocalPlayer
local function getLocalPlayer()
   local Players = game:GetService("Players")
   return Players.LocalPlayer
end

-- fungsi untuk aktif / nonaktif LowGraphic dengan pemeriksaan aman
local function setLowGraphicMode(enable)
   local RunService = game:GetService("RunService")
   local SoundService = game:GetService("SoundService")
   local player = getLocalPlayer()
   if not player then
      warn("LocalPlayer belum tersedia. Jalankan di client (LocalScript).")
      return
   end
   local PlayerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)

   if enable then
      if PlayerGui:FindFirstChild("LowGraphicOverlay") then return end -- sudah aktif
      local gui = Instance.new("ScreenGui")
      gui.Name = "LowGraphicOverlay"
      gui.ResetOnSpawn = false
      gui.IgnoreGuiInset = true
      gui.DisplayOrder = 9999

      local frame = Instance.new("Frame")
      frame.Size = UDim2.new(1, 0, 1, 0)
      frame.BackgroundColor3 = Color3.new(0, 0, 0)
      frame.BackgroundTransparency = 0
      frame.BorderSizePixel = 0
      frame.Parent = gui

      gui.Parent = PlayerGui

      -- disable rendering & suara
      -- wrap pcall karena beberapa executor/roblox client mungkin batasi
      pcall(function() RunService:Set3dRenderingEnabled(false) end)
      pcall(function() SoundService.Volume = 0 end)

      -- matikan efek (simpan state asli kalau mau restore selektif)
      for _, obj in ipairs(workspace:GetDescendants()) do
         if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
            pcall(function() obj.Enabled = false end)
         end
      end

      print("[LowGraphic] enabled")
   else
      local overlay = PlayerGui and PlayerGui:FindFirstChild("LowGraphicOverlay")
      if overlay then overlay:Destroy() end

      pcall(function() RunService:Set3dRenderingEnabled(true) end)
      pcall(function() SoundService.Volume = 1 end)

      for _, obj in ipairs(workspace:GetDescendants()) do
         if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
            pcall(function() obj.Enabled = true end)
         end
      end

      print("[LowGraphic] disabled")
   end
end

-- Buat toggle di Section (bukan MainTab)
local Toggle = MainSection:CreateToggle({
   Name = "Low Graphic Mode",
   CurrentValue = false,
   Flag = "LowGraphicToggle",
   Callback = function(Value)
      -- Value true = ON, false = OFF
      -- panggil fungsi aman
      setLowGraphicMode(Value)
   end,
})
