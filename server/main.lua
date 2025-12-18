-- MTJ2024_Kleidung - Server Main
-- Framework detection and initialization

ESX = nil
QBCore = nil
Framework = nil

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
            print('[MTJ2024_Kleidung] ESX Framework detected and loaded')
        else
            -- Try QB-Core
            success = pcall(function()
                QBCore = exports['qb-core']:GetCoreObject()
            end)
            
            if success and QBCore then
                Framework = 'qbcore'
                print('[MTJ2024_Kleidung] QB-Core Framework detected and loaded')
            else
                print('[MTJ2024_Kleidung] ^1ERROR: No framework detected!^0')
            end
        end
    elseif Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        Framework = 'esx'
        print('[MTJ2024_Kleidung] ESX Framework loaded')
    elseif Config.Framework == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
        Framework = 'qbcore'
        print('[MTJ2024_Kleidung] QB-Core Framework loaded')
    end
end)

-- Helper function to get player identifier
function GetPlayerIdentifier(source)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer and xPlayer.identifier or nil
    elseif Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player and Player.PlayerData.citizenid or nil
    end
    return nil
end

-- Helper function to get player money
function GetPlayerMoney(source, account)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return 0 end
        if account == 'cash' then
            return xPlayer.getMoney()
        elseif account == 'bank' then
            return xPlayer.getAccount('bank').money
        end
    elseif Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return 0 end
        if account == 'cash' then
            return Player.PlayerData.money['cash'] or 0
        elseif account == 'bank' then
            return Player.PlayerData.money['bank'] or 0
        end
    end
    return 0
end

-- Helper function to remove money from player
function RemovePlayerMoney(source, amount, account)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        if account == 'cash' then
            if xPlayer.getMoney() >= amount then
                xPlayer.removeMoney(amount)
                return true
            end
        elseif account == 'bank' then
            if xPlayer.getAccount('bank').money >= amount then
                xPlayer.removeAccountMoney('bank', amount)
                return true
            end
        end
    elseif Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return false end
        if account == 'cash' then
            if Player.PlayerData.money['cash'] >= amount then
                Player.Functions.RemoveMoney('cash', amount)
                return true
            end
        elseif account == 'bank' then
            if Player.PlayerData.money['bank'] >= amount then
                Player.Functions.RemoveMoney('bank', amount)
                return true
            end
        end
    end
    return false
end

-- Helper function to send notification
function SendNotification(source, message, type)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.showNotification(message)
        end
    elseif Framework == 'qbcore' then
        TriggerClientEvent('QBCore:Notify', source, message, type or 'primary')
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[Kleidung]', message }
        })
    end
end

-- Get player job
function GetPlayerJob(source)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer and xPlayer.job.name or nil
    elseif Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player and Player.PlayerData.job.name or nil
    end
    return nil
end

-- Load player outfits from database
RegisterNetEvent('mtj_kleidung:server:loadOutfits')
AddEventHandler('mtj_kleidung:server:loadOutfits', function()
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    if not identifier then
        print('[MTJ2024_Kleidung] ^1ERROR: Could not get identifier for player ' .. source .. '^0')
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM player_outfits WHERE identifier = @identifier ORDER BY slot ASC', {
        ['@identifier'] = identifier
    }, function(result)
        if result then
            TriggerClientEvent('mtj_kleidung:client:loadOutfits', source, result)
        else
            TriggerClientEvent('mtj_kleidung:client:loadOutfits', source, {})
        end
    end)
end)

-- Save outfit to database
RegisterNetEvent('mtj_kleidung:server:saveOutfit')
AddEventHandler('mtj_kleidung:server:saveOutfit', function(outfitName, outfitData, slot)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    if not identifier then
        SendNotification(source, _U('error_occurred'), 'error')
        return
    end
    
    -- Validate inputs
    if type(outfitName) ~= 'string' or outfitName == '' then
        SendNotification(source, _U('invalid_outfit'), 'error')
        return
    end
    
    if type(outfitData) ~= 'table' then
        SendNotification(source, _U('invalid_outfit'), 'error')
        return
    end
    
    -- Sanitize outfit name (max 60 characters)
    outfitName = string.sub(outfitName, 1, 60)
    
    -- Check if outfit already exists
    MySQL.Async.fetchAll('SELECT * FROM player_outfits WHERE identifier = @identifier AND name = @name', {
        ['@identifier'] = identifier,
        ['@name'] = outfitName
    }, function(result)
        if result and #result > 0 then
            -- Update existing outfit
            MySQL.Async.execute('UPDATE player_outfits SET outfit_data = @outfit_data WHERE identifier = @identifier AND name = @name', {
                ['@identifier'] = identifier,
                ['@name'] = outfitName,
                ['@outfit_data'] = json.encode(outfitData)
            }, function(affectedRows)
                if affectedRows > 0 then
                    SendNotification(source, _U('outfit_saved', outfitName), 'success')
                    TriggerClientEvent('mtj_kleidung:client:outfitSaved', source, outfitName)
                else
                    SendNotification(source, _U('database_error'), 'error')
                end
            end)
        else
            -- Insert new outfit
            MySQL.Async.execute('INSERT INTO player_outfits (identifier, name, outfit_data, slot) VALUES (@identifier, @name, @outfit_data, @slot)', {
                ['@identifier'] = identifier,
                ['@name'] = outfitName,
                ['@outfit_data'] = json.encode(outfitData),
                ['@slot'] = slot
            }, function(insertId)
                if insertId > 0 then
                    SendNotification(source, _U('outfit_saved', outfitName), 'success')
                    TriggerClientEvent('mtj_kleidung:client:outfitSaved', source, outfitName)
                else
                    SendNotification(source, _U('database_error'), 'error')
                end
            end)
        end
    end)
end)

-- Delete outfit from database
RegisterNetEvent('mtj_kleidung:server:deleteOutfit')
AddEventHandler('mtj_kleidung:server:deleteOutfit', function(outfitName)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    if not identifier then
        SendNotification(source, _U('error_occurred'), 'error')
        return
    end
    
    MySQL.Async.execute('DELETE FROM player_outfits WHERE identifier = @identifier AND name = @name', {
        ['@identifier'] = identifier,
        ['@name'] = outfitName
    }, function(affectedRows)
        if affectedRows > 0 then
            SendNotification(source, _U('outfit_deleted', outfitName), 'success')
            TriggerClientEvent('mtj_kleidung:client:outfitDeleted', source, outfitName)
        else
            SendNotification(source, _U('database_error'), 'error')
        end
    end)
end)

-- Process payment for clothing
RegisterNetEvent('mtj_kleidung:server:processPayment')
AddEventHandler('mtj_kleidung:server:processPayment', function(amount, paymentMethod, reason)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    if not identifier then
        TriggerClientEvent('mtj_kleidung:client:paymentResult', source, false, 'error_occurred')
        return
    end
    
    -- Validate inputs
    if type(amount) ~= 'number' or amount <= 0 or amount > 1000000 then
        print('[MTJ2024_Kleidung] ^1Invalid payment amount from player ' .. source .. '^0')
        TriggerClientEvent('mtj_kleidung:client:paymentResult', source, false, 'error_occurred')
        return
    end
    
    if paymentMethod ~= 'cash' and paymentMethod ~= 'bank' then
        print('[MTJ2024_Kleidung] ^1Invalid payment method from player ' .. source .. '^0')
        TriggerClientEvent('mtj_kleidung:client:paymentResult', source, false, 'error_occurred')
        return
    end
    
    if type(reason) ~= 'string' or reason == '' then
        reason = 'clothing'
    end
    
    -- Sanitize reason
    reason = string.sub(reason, 1, 100)
    
    -- Get player money
    local playerMoney = GetPlayerMoney(source, paymentMethod)
    
    if playerMoney >= amount then
        -- Remove money
        if RemovePlayerMoney(source, amount, paymentMethod) then
            -- Log transaction
            if Config.EnableDebug then
                print(string.format('[MTJ2024_Kleidung] Player %s paid %s$ (%s) for %s', identifier, amount, paymentMethod, reason))
            end
            
            TriggerClientEvent('mtj_kleidung:client:paymentResult', source, true, 'payment_success')
            SendNotification(source, _U('payment_success', amount), 'success')
        else
            TriggerClientEvent('mtj_kleidung:client:paymentResult', source, false, 'payment_failed')
            SendNotification(source, _U('payment_failed'), 'error')
        end
    else
        TriggerClientEvent('mtj_kleidung:client:paymentResult', source, false, 'insufficient_funds')
        SendNotification(source, _U('insufficient_funds'), 'error')
    end
end)

-- Get player money callback
RegisterNetEvent('mtj_kleidung:server:getPlayerMoney')
AddEventHandler('mtj_kleidung:server:getPlayerMoney', function()
    local source = source
    local cash = GetPlayerMoney(source, 'cash')
    local bank = GetPlayerMoney(source, 'bank')
    
    TriggerClientEvent('mtj_kleidung:client:receivePlayerMoney', source, cash, bank)
end)

-- Get player job for role-based outfits
RegisterNetEvent('mtj_kleidung:server:getPlayerJob')
AddEventHandler('mtj_kleidung:server:getPlayerJob', function()
    local source = source
    local job = GetPlayerJob(source)
    
    TriggerClientEvent('mtj_kleidung:client:receivePlayerJob', source, job)
end)

-- Skin System (esx_skin replacement)
-- Load player skin from database
RegisterNetEvent('mtj_kleidung:server:loadSkin')
AddEventHandler('mtj_kleidung:server:loadSkin', function()
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    if not identifier then
        print('[MTJ2024_Kleidung] ^1ERROR: Could not get identifier for player ' .. source .. '^0')
        return
    end
    
    MySQL.Async.fetchAll('SELECT skin FROM player_skin WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result and #result > 0 then
            -- Player has saved skin
            local skin = json.decode(result[1].skin)
            TriggerClientEvent('mtj_kleidung:client:loadSkin', source, skin, false)
        else
            -- New player - needs character creation
            TriggerClientEvent('mtj_kleidung:client:loadSkin', source, nil, true)
        end
    end)
end)

-- Save player skin to database
RegisterNetEvent('mtj_kleidung:server:saveSkin')
AddEventHandler('mtj_kleidung:server:saveSkin', function(skin)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    if not identifier then
        SendNotification(source, _U('error_occurred'), 'error')
        return
    end
    
    -- Validate skin data
    if type(skin) ~= 'table' then
        SendNotification(source, _U('invalid_outfit'), 'error')
        return
    end
    
    -- Check if player already has a skin
    MySQL.Async.fetchAll('SELECT id FROM player_skin WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result and #result > 0 then
            -- Update existing skin
            MySQL.Async.execute('UPDATE player_skin SET skin = @skin WHERE identifier = @identifier', {
                ['@identifier'] = identifier,
                ['@skin'] = json.encode(skin)
            }, function(affectedRows)
                if affectedRows > 0 then
                    if Config.EnableDebug then
                        print('[MTJ2024_Kleidung] Skin updated for ' .. identifier)
                    end
                end
            end)
        else
            -- Insert new skin
            MySQL.Async.execute('INSERT INTO player_skin (identifier, skin) VALUES (@identifier, @skin)', {
                ['@identifier'] = identifier,
                ['@skin'] = json.encode(skin)
            }, function(insertId)
                if insertId > 0 then
                    if Config.EnableDebug then
                        print('[MTJ2024_Kleidung] Skin saved for ' .. identifier)
                    end
                end
            end)
        end
    end)
end)

print('[MTJ2024_Kleidung] ^2Server side loaded successfully^0')
