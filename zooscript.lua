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

-- Daftar Item (Biar gampang diupdate)
local eggList = {
    {name = "Celeste Egg", id = "CelesteEgg"},
    {name = "Fly Egg", id = "FlyEgg"},
    {name = "Pink Unicorn Egg", id = "PinkUnicornEgg"},
    {name = "Shadow King Egg", id = "ShadowKingEgg"},
    {name = "Bumblebee Egg", id = "BumblebeeEgg"},
    {name = "Fiery Dragon Egg", id = "FieryDragonEgg"},
    {name = "Ancient Egg", id = "AncientEgg"},
    {name = "Sea Dragon Egg", id = "SeaDragonEgg"},
    {name = "Flower Whale Egg", id = "FlowerWhaleEgg"}
}

-------------------------------------------------------
-- 🛒 TAB 1: SHOP x1
-------------------------------------------------------
Tab1:CreateSection("Single Purchase (x1)")
for _, egg in ipairs(eggList) do
    Tab1:CreateButton({
        Name = "Buy " .. egg.name .. " x1",
        Callback = function() buyItem(egg.id, "_x1") end, -- Pakai _x1 atau kosongkan jika x1 tanpa suffix
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
-- 🎉 Notifikasi
-------------------------------------------------------
Rayfield:Notify({
    Title = "Multi-Tab Loaded",
    Content = "Pilih jumlah pembelian di tab yang sesuai!",
    Duration = 5
})
