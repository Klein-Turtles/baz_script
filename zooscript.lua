local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zoo Crot Enak",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "Aji Jembut",
   Theme = "Default",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {Enabled = true, FileName = "Big Hub"}
})

-- Buat Tab
local MainTab = Window:CreateTab("Home", nil)

-- Tambah judul bagian
MainTab:CreateSection("Feature")

-- Buat Toggle langsung di tab, bukan di section
local Toggle = MainTab:CreateToggle({
   Name = "Low Graphic Mode",
   CurrentValue = false,
   Flag = "LowGraphicToggle",
   Callback = function(Value)
      print("Low Graphic Mode:", Value)
   end,
})
