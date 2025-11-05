if game.PlaceID == 105555311806207 then
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zoo Crot Enak",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "Aji Jembut",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Home", nil) -- Title, Image
local MainSection = Tab:CreateSection("Feature")

local Toggle = Tab:CreateToggle({
   Name = "Low Graphic Mode",
   CurrentValue = false,
   Flag = "LowGraphicToggle",
   Callback = function(Value)
      -- Value = true → ON
      -- Value = false → OFF

      local RunService = game:GetService("RunService")
      local SoundService = game:GetService("SoundService")
      local player = game.Players.LocalPlayer
      local PlayerGui = player:WaitForChild("PlayerGui")

      if Value then
         -- 🟢 Aktifkan mode ringan
         print("[Low Graphic Mode] ENABLED")

         -- 🔲 Buat overlay hitam
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

         -- 🔇 Matikan rendering & suara
         RunService:Set3dRenderingEnabled(false)
         SoundService.Volume = 0

         -- ❌ Matikan efek partikel, beam, trail
         for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
               obj.Enabled = false
            end
         end

      else
         -- 🔴 Nonaktifkan mode ringan
         print("[Low Graphic Mode] DISABLED")

         local overlay = PlayerGui:FindFirstChild("LowGraphicOverlay")
         if overlay then overlay:Destroy() end

         -- Nyalakan lagi rendering & suara
         RunService:Set3dRenderingEnabled(true)
         SoundService.Volume = 1

         -- ✅ Aktifkan lagi efek
         for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
               obj.Enabled = true
            end
         end
      end
   end,
})
