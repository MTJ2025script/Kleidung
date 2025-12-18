-- MTJ2024_Kleidung - Client Main
-- Client-side logic for clothing system

ESX = nil
QBCore = nil
Framework = nil
PlayerData = {}
CurrentOutfits = {}
CurrentClothing = {}
OriginalClothing = {}
InClothingShop = false
MenuOpen = false
PlayerMoney = { cash = 0, bank = 0 }
PlayerJob = nil
PendingPayment = false

-- Localization
Locales = {}
function _U(str, ...) 
    if Locales[Config.DefaultLanguage] and Locales[Config.DefaultLanguage][str] then
        return string.format(Locales[Config.DefaultLanguage][str], ...)
    else
        return 'Translation [' .. Config.DefaultLanguage .. '][' .. str .. '] not found'
    end
end

-- Framework Detection
CreateThread(function()
    if Config.Framework == 'auto' then
        -- Try ESX first
        local success = pcall(function()
            ESX = exports['es_extended']:getSharedObject()
        end)
        
        if success and ESX then
            Framework = 'esx'
            print('[MTJ2024_Kleidung] ESX Framework detected')
        else
            -- Try QB-Core
            success = pcall(function()
                QBCore = exports['qb-core']:GetCoreObject()
            end)
            
            if success and QBCore then
                Framework = 'qbcore'
                print('[MTJ2024_Kleidung] QB-Core Framework detected')
            end
        end
    elseif Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        Framework = 'esx'
    elseif Config.Framework == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
        Framework = 'qbcore'
    end
    
    -- Get player data
    if Framework == 'esx' then
        while ESX.GetPlayerData().job == nil do
            Wait(100)
        end
        PlayerData = ESX.GetPlayerData()
        PlayerJob = PlayerData.job.name
    elseif Framework == 'qbcore' then
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job.name
    end
    
    -- Load outfits
    TriggerServerEvent('mtj_kleidung:server:loadOutfits')
    TriggerServerEvent('mtj_kleidung:server:getPlayerMoney')
end)

-- Update player data on job change
if Framework == 'esx' then
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        PlayerData.job = job
        PlayerJob = job.name
    end)
elseif Framework == 'qbcore' then
    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerData.job = JobInfo
        PlayerJob = JobInfo.name
    end)
end

-- Create blips for clothing shops
CreateThread(function()
    if Config.EnableBlips then
        for _, coords in pairs(Config.ClothingShops) do
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, Config.BlipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.BlipScale)
            SetBlipColour(blip, Config.BlipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.BlipName)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Check if player is in clothing shop
CreateThread(function()
    while true do
        Wait(500)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local inShop = false
        
        for _, shopCoords in pairs(Config.ClothingShops) do
            local distance = #(playerCoords - shopCoords)
            if distance < 2.5 then
                inShop = true
                if not InClothingShop then
                    InClothingShop = true
                    DisplayHelpText()
                end
                break
            end
        end
        
        if not inShop and InClothingShop then
            InClothingShop = false
        end
    end
end)

-- Display help text
function DisplayHelpText()
    CreateThread(function()
        while InClothingShop do
            Wait(0)
            if not MenuOpen then
                DrawText3D(GetEntityCoords(PlayerPedId()), _U('press_to_open'))
                if IsControlJustReleased(0, 38) then -- E key
                    OpenClothingMenu()
                end
            end
        end
    end)
end

-- Draw 3D text
function DrawText3D(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z + 1.0)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(coords.x, coords.y, coords.z))
    
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

-- Get current clothing
function GetCurrentClothing()
    local playerPed = PlayerPedId()
    local clothing = {}
    
    clothing['tshirt_1'] = GetPedDrawableVariation(playerPed, 8)
    clothing['tshirt_2'] = GetPedTextureVariation(playerPed, 8)
    clothing['torso_1'] = GetPedDrawableVariation(playerPed, 11)
    clothing['torso_2'] = GetPedTextureVariation(playerPed, 11)
    clothing['decals_1'] = GetPedDrawableVariation(playerPed, 10)
    clothing['decals_2'] = GetPedTextureVariation(playerPed, 10)
    clothing['arms'] = GetPedDrawableVariation(playerPed, 3)
    clothing['pants_1'] = GetPedDrawableVariation(playerPed, 4)
    clothing['pants_2'] = GetPedTextureVariation(playerPed, 4)
    clothing['shoes_1'] = GetPedDrawableVariation(playerPed, 6)
    clothing['shoes_2'] = GetPedTextureVariation(playerPed, 6)
    clothing['helmet_1'] = GetPedPropIndex(playerPed, 0)
    clothing['helmet_2'] = GetPedPropTextureIndex(playerPed, 0)
    clothing['chain_1'] = GetPedDrawableVariation(playerPed, 7)
    clothing['chain_2'] = GetPedTextureVariation(playerPed, 7)
    clothing['ears_1'] = GetPedPropIndex(playerPed, 2)
    clothing['ears_2'] = GetPedPropTextureIndex(playerPed, 2)
    clothing['bags_1'] = GetPedDrawableVariation(playerPed, 5)
    clothing['bags_2'] = GetPedTextureVariation(playerPed, 5)
    clothing['glasses_1'] = GetPedPropIndex(playerPed, 1)
    clothing['glasses_2'] = GetPedPropTextureIndex(playerPed, 1)
    
    return clothing
end

-- Apply clothing
function ApplyClothing(clothing)
    local playerPed = PlayerPedId()
    
    if clothing['tshirt_1'] then SetPedComponentVariation(playerPed, 8, clothing['tshirt_1'], clothing['tshirt_2'] or 0, 2) end
    if clothing['torso_1'] then SetPedComponentVariation(playerPed, 11, clothing['torso_1'], clothing['torso_2'] or 0, 2) end
    if clothing['decals_1'] then SetPedComponentVariation(playerPed, 10, clothing['decals_1'], clothing['decals_2'] or 0, 2) end
    if clothing['arms'] then SetPedComponentVariation(playerPed, 3, clothing['arms'], 0, 2) end
    if clothing['pants_1'] then SetPedComponentVariation(playerPed, 4, clothing['pants_1'], clothing['pants_2'] or 0, 2) end
    if clothing['shoes_1'] then SetPedComponentVariation(playerPed, 6, clothing['shoes_1'], clothing['shoes_2'] or 0, 2) end
    if clothing['chain_1'] then SetPedComponentVariation(playerPed, 7, clothing['chain_1'], clothing['chain_2'] or 0, 2) end
    if clothing['bags_1'] then SetPedComponentVariation(playerPed, 5, clothing['bags_1'], clothing['bags_2'] or 0, 2) end
    
    if clothing['helmet_1'] and clothing['helmet_1'] ~= -1 then
        SetPedPropIndex(playerPed, 0, clothing['helmet_1'], clothing['helmet_2'] or 0, 2)
    else
        ClearPedProp(playerPed, 0)
    end
    
    if clothing['glasses_1'] and clothing['glasses_1'] ~= -1 then
        SetPedPropIndex(playerPed, 1, clothing['glasses_1'], clothing['glasses_2'] or 0, 2)
    else
        ClearPedProp(playerPed, 1)
    end
    
    if clothing['ears_1'] and clothing['ears_1'] ~= -1 then
        SetPedPropIndex(playerPed, 2, clothing['ears_1'], clothing['ears_2'] or 0, 2)
    else
        ClearPedProp(playerPed, 2)
    end
end

-- Open clothing menu
function OpenClothingMenu()
    if not InClothingShop then
        return
    end
    
    MenuOpen = true
    OriginalClothing = GetCurrentClothing()
    CurrentClothing = table.clone(OriginalClothing)
    
    -- Create preview camera
    CreatePreviewCamera()
    
    -- Update money
    TriggerServerEvent('mtj_kleidung:server:getPlayerMoney')
    
    -- Get available components
    local availableClothing = GetAvailableClothing()
    
    -- Calculate cost and discount
    local baseCost = Config.ClothingChangeCost
    local discount = 0
    
    if PlayerJob and Config.JobDiscounts[PlayerJob] then
        discount = Config.JobDiscounts[PlayerJob]
    end
    
    local finalCost = math.floor(baseCost * (1 - discount / 100))
    
    -- Send data to NUI
    SendNUIMessage({
        action = 'openMenu',
        data = {
            outfits = CurrentOutfits,
            currentClothing = CurrentClothing,
            availableClothing = availableClothing,
            roleOutfits = GetRoleOutfits(),
            money = PlayerMoney,
            costs = {
                clothingChange = finalCost,
                outfitSave = Config.OutfitSaveCost
            },
            discount = discount,
            paymentEnabled = Config.EnablePayment,
            allowBank = Config.AllowBankPayment,
            allowCash = Config.AllowCashPayment,
            maxOutfits = Config.MaxOutfits
        }
    })
    
    SetNuiFocus(true, true)
end

-- Get available clothing components
function GetAvailableClothing()
    local playerPed = PlayerPedId()
    local clothing = {}
    
    -- Get drawable variations
    clothing.tshirt = GetNumberOfPedDrawableVariations(playerPed, 8)
    clothing.torso = GetNumberOfPedDrawableVariations(playerPed, 11)
    clothing.decals = GetNumberOfPedDrawableVariations(playerPed, 10)
    clothing.arms = GetNumberOfPedDrawableVariations(playerPed, 3)
    clothing.pants = GetNumberOfPedDrawableVariations(playerPed, 4)
    clothing.shoes = GetNumberOfPedDrawableVariations(playerPed, 6)
    clothing.chain = GetNumberOfPedDrawableVariations(playerPed, 7)
    clothing.bags = GetNumberOfPedDrawableVariations(playerPed, 5)
    
    -- Get prop variations
    clothing.helmet = GetNumberOfPedPropDrawableVariations(playerPed, 0)
    clothing.glasses = GetNumberOfPedPropDrawableVariations(playerPed, 1)
    clothing.ears = GetNumberOfPedPropDrawableVariations(playerPed, 2)
    
    return clothing
end

-- Get role-based outfits
function GetRoleOutfits()
    local roleOutfits = {}
    
    if PlayerJob and Config.RoleOutfits then
        for roleName, roleData in pairs(Config.RoleOutfits) do
            for _, job in ipairs(roleData.jobs) do
                if job == PlayerJob then
                    for _, outfit in ipairs(roleData.outfits) do
                        table.insert(roleOutfits, {
                            label = outfit.label,
                            outfit = outfit
                        })
                    end
                end
            end
        end
    end
    
    return roleOutfits
end

-- Table clone helper
function table.clone(orig)
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = v
    end
    return copy
end

-- NUI Callbacks
RegisterNUICallback('closeMenu', function(data, cb)
    MenuOpen = false
    SetNuiFocus(false, false)
    
    -- Destroy preview camera
    DestroyPreviewCamera()
    
    if data.save then
        -- Player wants to save changes
        if Config.EnablePayment and not PendingPayment then
            -- Already paid or free
            ApplyClothing(CurrentClothing)
        end
    else
        -- Revert changes
        ApplyClothing(OriginalClothing)
    end
    
    PendingPayment = false
    cb('ok')
end)

RegisterNUICallback('updateClothing', function(data, cb)
    if data.component and data.value ~= nil then
        CurrentClothing[data.component] = data.value
        if data.texture ~= nil then
            CurrentClothing[data.component .. '_2'] = data.texture
        end
        
        -- Preview
        if Config.EnablePreview then
            ApplyClothing(CurrentClothing)
        end
    end
    cb('ok')
end)

RegisterNUICallback('saveOutfit', function(data, cb)
    if data.name and data.outfit then
        -- Check if payment is required
        if Config.EnablePayment and Config.OutfitSaveCost > 0 then
            -- Will be handled by payment callback
        else
            TriggerServerEvent('mtj_kleidung:server:saveOutfit', data.name, data.outfit, data.slot or 1)
        end
    end
    cb('ok')
end)

RegisterNUICallback('loadOutfit', function(data, cb)
    if data.outfit then
        CurrentClothing = json.decode(data.outfit.outfit_data)
        ApplyClothing(CurrentClothing)
    end
    cb('ok')
end)

RegisterNUICallback('deleteOutfit', function(data, cb)
    if data.name then
        TriggerServerEvent('mtj_kleidung:server:deleteOutfit', data.name)
    end
    cb('ok')
end)

RegisterNUICallback('loadRoleOutfit', function(data, cb)
    if data.outfit then
        local playerPed = PlayerPedId()
        local isMale = IsPedMale(playerPed)
        local outfit = isMale and data.outfit.male or data.outfit.female
        
        if outfit then
            CurrentClothing = outfit
            ApplyClothing(CurrentClothing)
        end
    end
    cb('ok')
end)

RegisterNUICallback('processPayment', function(data, cb)
    PendingPayment = true
    TriggerServerEvent('mtj_kleidung:server:processPayment', data.amount, data.method, data.reason)
    cb('ok')
end)

-- Server callbacks
RegisterNetEvent('mtj_kleidung:client:loadOutfits')
AddEventHandler('mtj_kleidung:client:loadOutfits', function(outfits)
    CurrentOutfits = outfits
end)

RegisterNetEvent('mtj_kleidung:client:outfitSaved')
AddEventHandler('mtj_kleidung:client:outfitSaved', function(name)
    TriggerServerEvent('mtj_kleidung:server:loadOutfits')
end)

RegisterNetEvent('mtj_kleidung:client:outfitDeleted')
AddEventHandler('mtj_kleidung:client:outfitDeleted', function(name)
    TriggerServerEvent('mtj_kleidung:server:loadOutfits')
end)

RegisterNetEvent('mtj_kleidung:client:receivePlayerMoney')
AddEventHandler('mtj_kleidung:client:receivePlayerMoney', function(cash, bank)
    PlayerMoney = { cash = cash, bank = bank }
    
    -- Update NUI if menu is open
    if MenuOpen then
        SendNUIMessage({
            action = 'updateMoney',
            data = PlayerMoney
        })
    end
end)

RegisterNetEvent('mtj_kleidung:client:paymentResult')
AddEventHandler('mtj_kleidung:client:paymentResult', function(success, message)
    SendNUIMessage({
        action = 'paymentResult',
        success = success,
        message = message
    })
    
    if success then
        PendingPayment = false
        TriggerServerEvent('mtj_kleidung:server:getPlayerMoney')
    end
end)

-- Command to open menu
if Config.UseCommand then
    RegisterCommand(Config.CommandName, function()
        if InClothingShop then
            OpenClothingMenu()
        end
    end, false)
end

print('[MTJ2024_Kleidung] ^2Client side loaded successfully^0')
