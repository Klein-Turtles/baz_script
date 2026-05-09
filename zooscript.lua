-- 🧩 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Jatu Kece V7",
    LoadingTitle = "Merging All Features...",
    LoadingSubtitle = "by Tegar",
    ConfigurationSaving = {Enabled = false}
})

-- 📑 Definisi Tab
local Tab1 = Window:CreateTab("Shop x1", nil)
local Tab3 = Window:CreateTab("Shop x3", nil)
local Tab10 = Window:CreateTab("Shop x10", nil)
local TabUnit = Window:CreateTab("Unit Shop", nil)
local TabFusion = Window:CreateTab("Fusion Menu", nil) -- Tab Baru buat temuan Dex lu

-- 📦 Services & Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

-- Requirement buat ProductUtil (Sesuaikan path Shared lu kalau error)
local Shared = require(ReplicatedStorage:WaitForChild("Shared"))
local ProductUtil = Shared("GameProductUtility")

-- Remote lama buat Egg
local ProductBuyRF = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ProductBuyRF")

-- [Fungsi A] Untuk Egg (Jalur RemoteFunction)
local function buyEgg(itemName, suffix)
    local fullName = itemName .. suffix
    local args = {fullName, true, "ID"}
    pcall(function()
        ProductBuyRF:InvokeServer(unpack(args))
    end)
    Rayfield:Notify({Title = "Egg Request Sent", Content = fullName, Duration = 2})
end

-- [Fungsi B] Untuk Unit/Pet (Jalur ProductUtil Pcall)
local function buyUnitWithProductUtil(id)
    local success, err = pcall(function()
        ProductUtil:BuyGameProduct(Player, id)
    end)
    
    if success then
        Rayfield:Notify({Title = "Unit Purchase Sent", Content = "ID: " .. id, Duration = 2})
    else
        warn("Gagal beli unit: " .. tostring(err))
    end
end

-- Daftar Item
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
    {name = "Sirius Egg", id = "SiriusEgg"},
    {name = "Oaken Egg", id = "OakenEgg"}
}

local unitList = {
    {name = "Christmas Penguin", id = "Penguin_Christmas"},
    {name = "Snow Puff", id = "SnowWeasel"}
}

-------------------------------------------------------
-- 🛒 TABS EGG (Jalur RF)
-------------------------------------------------------
Tab1:CreateSection("Single Purchase (x1)")
for _, egg in ipairs(eggList) do
    Tab1:CreateButton({
        Name = "Buy " .. egg.name .. " x1",
        Callback = function() buyEgg(egg.id, "_x1") end,
    })
end

Tab3:CreateSection("Triple Purchase (x3)")
for _, egg in ipairs(eggList) do
    Tab3:CreateButton({
        Name = "Buy " .. egg.name .. " x3",
        Callback = function() buyEgg(egg.id, "_x3") end,
    })
end

Tab10:CreateSection("Mega Purchase (x10)")
for _, egg in ipairs(eggList) do
    Tab10:CreateButton({
        Name = "Buy " .. egg.name .. " x10",
        Callback = function() buyEgg(egg.id, "_x10") end,
    })
end

-------------------------------------------------------
-- 🛒 TAB UNIT (Jalur ProductUtil)
-------------------------------------------------------
TabUnit:CreateSection("Direct Unit Purchase (ProductUtil)")
for _, unit in ipairs(unitList) do
    TabUnit:CreateButton({
        Name = "Buy " .. unit.name,
        Callback = function() buyUnitWithProductUtil(unit.id) end,
    })
end

-------------------------------------------------------
-- 🧬 TAB FUSION (Bypass Access via Dex Hierarchy)
-------------------------------------------------------
TabFusion:CreateSection("Fusion Feature Access")

TabFusion:CreateButton({
    Name = "Force Open Fusion Menu",
    Callback = function()
        local fusionScreen = Player.PlayerGui:FindFirstChild("ScreenFusion", true)
        
        if fusionScreen then
            fusionScreen.Enabled = true -- Aktifin induknya
            
            -- Mencari elemen visual berdasarkan temuan Dex
            local root = fusionScreen:FindFirstChild("Root", true)
            local choiceFrame = fusionScreen:FindFirstChild("ChoiceFrame", true)
            
            if root then root.Visible = true end
            if choiceFrame then choiceFrame.Visible = true end
            
            Rayfield:Notify({
                Title = "Fusion Accessed",
                Content = "Menu Fusion dipaksa muncul!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "ScreenFusion tidak ditemukan!",
                Duration = 3
            })
        end
    end,
})

TabFusion:CreateButton({
    Name = "Open Fusion Preview",
    Callback = function()
        local preview = Player.PlayerGui:FindFirstChild("ScreenFusionPreview", true)
        if preview then
            preview.Enabled = true
            Rayfield:Notify({Title = "Preview Active", Content = "Menampilkan Preview", Duration = 2})
        end
    end,
})

Rayfield:Notify({
    Title = "Jatu Kece V7 Ready",
    Content = "Semua fitur termasuk Fusion sudah siap!",
    Duration = 5
})
