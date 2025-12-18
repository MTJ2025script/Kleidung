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
function _U(str, ...) 
    -- Safe fallback if Config or Locales not loaded yet
    local lang = Config and Config.DefaultLanguage or 'de'
    if Locales and Locales[lang] and Locales[lang][str] then
        return string.format(Locales[lang][str], ...)
    else
        return 'Translation [' .. lang .. '][' .. str .. '] not found'
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
    
    -- Load player skin if skin system is enabled
    if Config.EnableSkinSystem and Config.LoadSkinOnSpawn then
        TriggerServerEvent('mtj_kleidung:server:loadSkin')
    end
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

-- Get current clothing (COMPLETE ESX_SKIN IMPLEMENTATION)
function GetCurrentClothing()
    local playerPed = PlayerPedId()
    local clothing = {}
    
    -- Drawable Components (Kleidungsstücke)
    clothing['tshirt_1'] = GetPedDrawableVariation(playerPed, 8)    -- Unterhemd
    clothing['tshirt_2'] = GetPedTextureVariation(playerPed, 8)
    clothing['torso_1'] = GetPedDrawableVariation(playerPed, 11)    -- Oberteil/Jacke
    clothing['torso_2'] = GetPedTextureVariation(playerPed, 11)
    clothing['decals_1'] = GetPedDrawableVariation(playerPed, 10)   -- Abzeichen/Patches
    clothing['decals_2'] = GetPedTextureVariation(playerPed, 10)
    clothing['arms'] = GetPedDrawableVariation(playerPed, 3)        -- Arme/Ärmel
    clothing['pants_1'] = GetPedDrawableVariation(playerPed, 4)     -- Hose
    clothing['pants_2'] = GetPedTextureVariation(playerPed, 4)
    clothing['shoes_1'] = GetPedDrawableVariation(playerPed, 6)     -- Schuhe
    clothing['shoes_2'] = GetPedTextureVariation(playerPed, 6)
    clothing['chain_1'] = GetPedDrawableVariation(playerPed, 7)     -- Kette/Halskette
    clothing['chain_2'] = GetPedTextureVariation(playerPed, 7)
    clothing['bags_1'] = GetPedDrawableVariation(playerPed, 5)      -- Tasche/Rucksack
    clothing['bags_2'] = GetPedTextureVariation(playerPed, 5)
    clothing['mask_1'] = GetPedDrawableVariation(playerPed, 1)      -- Maske/Gesicht
    clothing['mask_2'] = GetPedTextureVariation(playerPed, 1)
    clothing['bproof_1'] = GetPedDrawableVariation(playerPed, 9)    -- Kugelsichere Weste
    clothing['bproof_2'] = GetPedTextureVariation(playerPed, 9)
    
    -- Props/Accessories (Accessoires)
    clothing['helmet_1'] = GetPedPropIndex(playerPed, 0)            -- Helm/Hut
    clothing['helmet_2'] = GetPedPropTextureIndex(playerPed, 0)
    clothing['glasses_1'] = GetPedPropIndex(playerPed, 1)           -- Brille
    clothing['glasses_2'] = GetPedPropTextureIndex(playerPed, 1)
    clothing['ears_1'] = GetPedPropIndex(playerPed, 2)              -- Ohren/Kopfhörer
    clothing['ears_2'] = GetPedPropTextureIndex(playerPed, 2)
    clothing['watches_1'] = GetPedPropIndex(playerPed, 6)           -- Uhr
    clothing['watches_2'] = GetPedPropTextureIndex(playerPed, 6)
    clothing['bracelets_1'] = GetPedPropIndex(playerPed, 7)         -- Armband
    clothing['bracelets_2'] = GetPedPropTextureIndex(playerPed, 7)
    
    -- Sex/Gender (Geschlecht für korrekte Kleidung)
    clothing['sex'] = IsPedMale(playerPed) and 0 or 1
    
    return clothing
end

-- Apply clothing (COMPLETE ESX_SKIN IMPLEMENTATION)
function ApplyClothing(clothing)
    local playerPed = PlayerPedId()
    
    -- Drawable Components (Alle Kleidungsstücke)
    if clothing['tshirt_1'] then SetPedComponentVariation(playerPed, 8, clothing['tshirt_1'], clothing['tshirt_2'] or 0, 2) end
    if clothing['torso_1'] then SetPedComponentVariation(playerPed, 11, clothing['torso_1'], clothing['torso_2'] or 0, 2) end
    if clothing['decals_1'] then SetPedComponentVariation(playerPed, 10, clothing['decals_1'], clothing['decals_2'] or 0, 2) end
    if clothing['arms'] then SetPedComponentVariation(playerPed, 3, clothing['arms'], 0, 2) end
    if clothing['pants_1'] then SetPedComponentVariation(playerPed, 4, clothing['pants_1'], clothing['pants_2'] or 0, 2) end
    if clothing['shoes_1'] then SetPedComponentVariation(playerPed, 6, clothing['shoes_1'], clothing['shoes_2'] or 0, 2) end
    if clothing['chain_1'] then SetPedComponentVariation(playerPed, 7, clothing['chain_1'], clothing['chain_2'] or 0, 2) end
    if clothing['bags_1'] then SetPedComponentVariation(playerPed, 5, clothing['bags_1'], clothing['bags_2'] or 0, 2) end
    if clothing['mask_1'] then SetPedComponentVariation(playerPed, 1, clothing['mask_1'], clothing['mask_2'] or 0, 2) end
    if clothing['bproof_1'] then SetPedComponentVariation(playerPed, 9, clothing['bproof_1'], clothing['bproof_2'] or 0, 2) end
    
    -- Props/Accessories (Alle Accessoires)
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
    
    if clothing['watches_1'] and clothing['watches_1'] ~= -1 then
        SetPedPropIndex(playerPed, 6, clothing['watches_1'], clothing['watches_2'] or 0, 2)
    else
        ClearPedProp(playerPed, 6)
    end
    
    if clothing['bracelets_1'] and clothing['bracelets_1'] ~= -1 then
        SetPedPropIndex(playerPed, 7, clothing['bracelets_1'], clothing['bracelets_2'] or 0, 2)
    else
        ClearPedProp(playerPed, 7)
    end
end

-- Store original player position
local OriginalPlayerCoords = nil
local OriginalPlayerHeading = nil

-- Open clothing menu
function OpenClothingMenu(skipShopCheck)
    -- Allow opening anywhere if using skin command or skip check
    if not skipShopCheck and not InClothingShop and not Config.UseSkinCommand then
        return
    end
    
    MenuOpen = true
    OriginalClothing = GetCurrentClothing()
    CurrentClothing = table.clone(OriginalClothing)
    
    local playerPed = PlayerPedId()
    
    -- Save original position and heading
    OriginalPlayerCoords = GetEntityCoords(playerPed)
    OriginalPlayerHeading = GetEntityHeading(playerPed)
    
    -- Position player in front of camera for optimal view
    -- This positions the player so they appear centered in the left column
    local forwardVector = GetEntityForwardVector(playerPed)
    local newX = OriginalPlayerCoords.x + (forwardVector.x * 2.0)
    local newY = OriginalPlayerCoords.y + (forwardVector.y * 2.0)
    local newZ = OriginalPlayerCoords.z
    
    -- Set player to new position for preview
    SetEntityCoordsNoOffset(playerPed, newX, newY, newZ, false, false, false)
    SetEntityHeading(playerPed, OriginalPlayerHeading)
    
    -- Freeze player and hide HUD
    FreezeEntityPosition(playerPed, true)
    DisplayRadar(false)
    
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
    
    local playerPed = PlayerPedId()
    
    -- Restore original position and heading
    if OriginalPlayerCoords then
        SetEntityCoordsNoOffset(playerPed, OriginalPlayerCoords.x, OriginalPlayerCoords.y, OriginalPlayerCoords.z, false, false, false)
        SetEntityHeading(playerPed, OriginalPlayerHeading)
        OriginalPlayerCoords = nil
        OriginalPlayerHeading = nil
    end
    
    -- Unfreeze player and restore HUD
    FreezeEntityPosition(playerPed, false)
    DisplayRadar(true)
    
    if data.save then
        -- Player wants to save changes
        if Config.EnablePayment and not PendingPayment then
            -- Already paid or free
            ApplyClothing(CurrentClothing)
            
            -- Save skin to database if skin system is enabled
            if Config.EnableSkinSystem and Config.SaveSkinOnChange then
                TriggerServerEvent('mtj_kleidung:server:saveSkin', CurrentClothing)
            end
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

-- Skin command (open anywhere like esx_skin)
if Config.EnableSkinSystem and Config.UseSkinCommand then
    RegisterCommand(Config.SkinCommandName, function()
        OpenClothingMenu(true) -- Skip shop check
    end, false)
end

-- Quick Commands für Accessoires
if Config.UseMaskCommand then
    local maskOn = false
    local savedMask = {mask_1 = 0, mask_2 = 0}
    
    RegisterCommand(Config.MaskCommandName, function()
        local playerPed = PlayerPedId()
        
        if maskOn then
            -- Maske abnehmen
            SetPedComponentVariation(playerPed, 1, 0, 0, 2)
            maskOn = false
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = false,
                args = {"Kleidung", "Maske abgenommen"}
            })
        else
            -- Maske aufsetzen (letzte gespeicherte oder Standard)
            local currentSkin = GetCurrentClothing()
            if currentSkin['mask_1'] and currentSkin['mask_1'] > 0 then
                savedMask = {mask_1 = currentSkin['mask_1'], mask_2 = currentSkin['mask_2']}
            end
            
            if savedMask.mask_1 > 0 then
                SetPedComponentVariation(playerPed, 1, savedMask.mask_1, savedMask.mask_2, 2)
                maskOn = true
                TriggerEvent('chat:addMessage', {
                    color = {0, 255, 0},
                    multiline = false,
                    args = {"Kleidung", "Maske aufgesetzt"}
                })
            end
        end
    end, false)
end

if Config.UseHelmetCommand then
    local helmetOn = false
    local savedHelmet = {helmet_1 = -1, helmet_2 = 0}
    
    RegisterCommand(Config.HelmetCommandName, function()
        local playerPed = PlayerPedId()
        
        if helmetOn then
            -- Helm abnehmen
            ClearPedProp(playerPed, 0)
            helmetOn = false
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = false,
                args = {"Kleidung", "Helm abgenommen"}
            })
        else
            -- Helm aufsetzen
            local currentSkin = GetCurrentClothing()
            if currentSkin['helmet_1'] and currentSkin['helmet_1'] >= 0 then
                savedHelmet = {helmet_1 = currentSkin['helmet_1'], helmet_2 = currentSkin['helmet_2']}
            end
            
            if savedHelmet.helmet_1 >= 0 then
                SetPedPropIndex(playerPed, 0, savedHelmet.helmet_1, savedHelmet.helmet_2, 2)
                helmetOn = true
                TriggerEvent('chat:addMessage', {
                    color = {0, 255, 0},
                    multiline = false,
                    args = {"Kleidung", "Helm aufgesetzt"}
                })
            end
        end
    end, false)
end

if Config.UseGlassesCommand then
    local glassesOn = false
    local savedGlasses = {glasses_1 = -1, glasses_2 = 0}
    
    RegisterCommand(Config.GlassesCommandName, function()
        local playerPed = PlayerPedId()
        
        if glassesOn then
            -- Brille abnehmen
            ClearPedProp(playerPed, 1)
            glassesOn = false
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = false,
                args = {"Kleidung", "Brille abgenommen"}
            })
        else
            -- Brille aufsetzen
            local currentSkin = GetCurrentClothing()
            if currentSkin['glasses_1'] and currentSkin['glasses_1'] >= 0 then
                savedGlasses = {glasses_1 = currentSkin['glasses_1'], glasses_2 = currentSkin['glasses_2']}
            end
            
            if savedGlasses.glasses_1 >= 0 then
                SetPedPropIndex(playerPed, 1, savedGlasses.glasses_1, savedGlasses.glasses_2, 2)
                glassesOn = true
                TriggerEvent('chat:addMessage', {
                    color = {0, 255, 0},
                    multiline = false,
                    args = {"Kleidung", "Brille aufgesetzt"}
                })
            end
        end
    end, false)
end

if Config.UseVestCommand then
    local vestOn = false
    local savedVest = {bproof_1 = 0, bproof_2 = 0}
    
    RegisterCommand(Config.VestCommandName, function()
        local playerPed = PlayerPedId()
        
        if vestOn then
            -- Weste abnehmen
            SetPedComponentVariation(playerPed, 9, 0, 0, 2)
            vestOn = false
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = false,
                args = {"Kleidung", "Weste abgenommen"}
            })
        else
            -- Weste aufsetzen
            local currentSkin = GetCurrentClothing()
            if currentSkin['bproof_1'] and currentSkin['bproof_1'] > 0 then
                savedVest = {bproof_1 = currentSkin['bproof_1'], bproof_2 = currentSkin['bproof_2']}
            end
            
            if savedVest.bproof_1 > 0 then
                SetPedComponentVariation(playerPed, 9, savedVest.bproof_1, savedVest.bproof_2, 2)
                vestOn = true
                TriggerEvent('chat:addMessage', {
                    color = {0, 255, 0},
                    multiline = false,
                    args = {"Kleidung", "Weste angezogen"}
                })
            end
        end
    end, false)
end

-- Skin System Event Handlers
RegisterNetEvent('mtj_kleidung:client:loadSkin')
AddEventHandler('mtj_kleidung:client:loadSkin', function(skin, isNewPlayer)
    if isNewPlayer then
        -- New player - open character creation menu
        if Config.EnableCharacterCreation then
            Wait(1000) -- Wait for player to fully spawn
            
            -- Apply default skin based on gender
            local playerPed = PlayerPedId()
            local isMale = IsPedMale(playerPed)
            local defaultSkin = isMale and Config.DefaultSkin.male or Config.DefaultSkin.female
            
            ApplyClothing(defaultSkin)
            
            -- Open menu for customization
            Wait(500)
            OpenClothingMenu(true)
        end
    else
        -- Existing player - load saved skin
        if skin then
            ApplyClothing(skin)
            
            -- Auto-save current skin if enabled
            if Config.SaveSkinOnChange then
                CurrentClothing = skin
            end
        end
    end
end)

-- Save skin when clothing changes
RegisterNetEvent('mtj_kleidung:client:saveSkin')
AddEventHandler('mtj_kleidung:client:saveSkin', function()
    if Config.EnableSkinSystem and Config.SaveSkinOnChange then
        local currentSkin = GetCurrentClothing()
        TriggerServerEvent('mtj_kleidung:server:saveSkin', currentSkin)
    end
end)

-- Auto-save skin when applying changes
local originalApplyClothing = ApplyClothing
ApplyClothing = function(clothing)
    originalApplyClothing(clothing)
    
    -- Auto-save if skin system is enabled
    if Config.EnableSkinSystem and Config.SaveSkinOnChange and not MenuOpen then
        TriggerServerEvent('mtj_kleidung:server:saveSkin', clothing)
    end
end

print('[MTJ2024_Kleidung] ^2Client side loaded successfully^0')
