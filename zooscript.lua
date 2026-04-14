-- 🧩 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🪟 Buat Window
local Window = Rayfield:CreateWindow({
    Name = "Zoo Premium Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Tegar",
    ConfigurationSaving = {Enabled = false}
})

-- 📑 Tab Utama
local MainTab = Window:CreateTab("Home", nil)

-- 📦 Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Kita pakai pcall buat nangkep Remote biar gak stuck kalau gak ketemu
local ProductBuyRF
pcall(function()
    ProductBuyRF = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ProductBuyRF")
end)

-------------------------------------------------------
-- 🥚 Section: Celeste Egg
-------------------------------------------------------
MainTab:CreateSection("Celeste Egg Shop")

local function purchase(itemName)
    if not ProductBuyRF then 
        warn("Remote ProductBuyRF tidak ditemukan!") 
        return 
    end
    local success, err = pcall(function()
        ProductBuyRF:InvokeServer(itemName)
    end)
    if not success then warn("Error saat membeli: " .. tostring(err)) end
end

MainTab:CreateButton({
    Name = "Buy Celeste Egg (x1)",
    Callback = function() purchase("CelesteEgg_x1") end,
})

MainTab:CreateButton({
    Name = "Buy Celeste Egg (x3)",
    Callback = function() purchase("CelesteEgg_x3") end,
})

MainTab:CreateButton({
    Name = "Buy Celeste Egg (x10)",
    Callback = function() purchase("CelesteEgg_x10") end,
})

-------------------------------------------------------
-- 🔍 Troubleshooting
-------------------------------------------------------
MainTab:CreateSection("Bantuan")

MainTab:CreateButton({
    Name = "Mode Spy (Cek F9)",
    Callback = function()
        Rayfield:Notify({Title = "Spy Aktif", Content = "Klik tombol beli asli di Shop!", Duration = 5})
        local oldInvoke
        oldInvoke = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            if tostring(self) == "ProductBuyRF" and getnamecallmethod() == "InvokeServer" then
                print("STRING ITEM: " .. tostring(args[1]))
            end
            return oldInvoke(self, ...)
        end)
    end,
})

Rayfield:Notify({Title = "Ready!", Content = "Tekan K untuk menu", Duration = 3})
