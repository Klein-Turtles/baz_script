-- 🧩 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Zoo Premium Hub",
    LoadingTitle = "Organizing Shop Tabs...",
    LoadingSubtitle = "by Tegar",
    ConfigurationSaving = {Enabled = false}
})

-- 📑 Definisi Tab
local Tab1 = Window:CreateTab("Shop x1", nil)
local Tab3 = Window:CreateTab("Shop x3", nil)
local Tab10 = Window:CreateTab("Shop x10", nil)
local TabUnit = Window:CreateTab("Unit Shop", nil) -- Tab Baru

-- 📦 Services & Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProductBuyRF = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ProductBuyRF")

-- Fungsi Universal untuk Membeli
local function buyItem(itemName, suffix)
    local fullName = itemName .. suffix
    local args = {
        fullName, 
        true,     
        "ID"      
    }
    local success, err = pcall(function()
        ProductBuyRF:InvokeServer(unpack(args))
    end)
    
    if success then
        Rayfield:Notify({Title = "Sent!", Content = "Request " .. fullName .. " dikirim.", Duration = 2})
    else
        warn("Gagal: " .. tostring(err))
    end
end

-- Daftar Item Egg
local eggList = {
    {name = "Celeste Egg", id = "CelesteEgg"},
    {name = "Fly Egg", id = "FlyEgg"},
    {name = "Pink Unicorn Egg", id = "PinkUnicornEgg"},
    {name = "Shadow King Egg", id = "ShadowKingEgg"},
    {name = "Bumblebee Egg", id = "BumblebeeEgg"},
    {name = "Fiery Dragon Egg", id = "FieryDragonEgg"},
    {name = "Ancient Egg", id = "AncientEgg"},
    {name = "Sea Dragon Egg", id = "SeaDragonEgg"},
    {name = "Flower Whale Egg", id = "FlowerWhaleEgg"},
    {name = "Pegasus Egg", id = "PegasusEgg"},
    {name = "Sirius Egg", id = "SiriusEgg"}
}

-- Daftar Unit (Gampang buat lu tambah lagi nanti)
local unitList = {
    {name = "Christmas Penguin", id = "Penguin_Christmas"},
    {name = "Snow Puff", id = "SnowWeasel"}
}

-------------------------------------------------------
-- 🛒 TAB 1: SHOP x1
-------------------------------------------------------
Tab1:CreateSection("Single Purchase (x1)")
for _, egg in ipairs(eggList) do
    Tab1:CreateButton({
        Name = "Buy " .. egg.name .. " x1",
        Callback = function() buyItem(egg.id, "_x1") end,
    })
end

-------------------------------------------------------
-- 🛒 TAB 3: SHOP x3
-------------------------------------------------------
Tab3:CreateSection("Triple Purchase (x3)")
for _, egg in ipairs(eggList) do
    Tab3:CreateButton({
        Name = "Buy " .. egg.name .. " x3",
        Callback = function() buyItem(egg.id, "_x3") end,
    })
end

-------------------------------------------------------
-- 🛒 TAB 10: SHOP x10
-------------------------------------------------------
Tab10:CreateSection("Mega Purchase (x10)")
for _, egg in ipairs(eggList) do
    Tab10:CreateButton({
        Name = "Buy " .. egg.name .. " x10",
        Callback = function() buyItem(egg.id, "_x10") end,
    })
end

-------------------------------------------------------
-- 🛒 TAB UNIT: UNIT SHOP
-------------------------------------------------------
TabUnit:CreateSection("Direct Unit Purchase")
for _, unit in ipairs(unitList) do
    TabUnit:CreateButton({
        Name = "Buy " .. unit.name,
        Callback = function() buyItem(unit.id, "") end, -- Unit biasanya gak pake suffix _x1
    })
end

-------------------------------------------------------
-- 🎉 Notifikasi
-------------------------------------------------------
Rayfield:Notify({
    Title = "Multi-Tab Loaded",
    Content = "Tab Unit Shop sudah siap, Gar!",
    Duration = 5
})
