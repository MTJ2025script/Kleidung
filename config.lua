Config = {}

-- Framework Selection
-- Options: 'esx', 'qbcore', 'auto'
-- 'auto' will automatically detect the framework
Config.Framework = 'auto'

-- Language Settings
-- Options: 'de', 'en', 'fr'
Config.DefaultLanguage = 'de'

-- Database Settings
Config.UseOxMySQL = true

-- Clothing Menu Settings
Config.MenuKey = 'F7' -- Key to open the clothing menu
Config.UseCommand = true -- Enable /kleidung command
Config.CommandName = 'kleidung'

-- Outfit Settings
Config.MaxOutfits = 10 -- Maximum number of saved outfits per player
Config.EnablePreview = true -- Enable clothing preview
Config.PreviewDelay = 500 -- Delay in ms before preview updates

-- Clothing Shops
Config.ClothingShops = {
    vector3(72.3, -1399.1, 29.4),
    vector3(-703.8, -152.3, 37.4),
    vector3(-167.9, -299.0, 39.7),
    vector3(428.7, -800.1, 29.5),
    vector3(-829.4, -1073.7, 11.3),
    vector3(-1447.8, -242.5, 49.8),
    vector3(11.6, 6514.2, 31.9),
    vector3(123.6, -219.4, 54.6),
    vector3(1696.3, 4829.3, 42.1),
    vector3(618.1, 2759.6, 42.1),
    vector3(1190.6, 2713.4, 38.2),
    vector3(-1193.4, -772.3, 17.3),
    vector3(-3172.5, 1048.1, 20.9),
    vector3(-1108.4, 2708.9, 19.1)
}

-- Blip Settings
Config.EnableBlips = true
Config.BlipSprite = 73
Config.BlipColor = 47
Config.BlipScale = 0.8
Config.BlipName = "Kleidungsgeschäft"

-- Role-Based Clothing
Config.RoleOutfits = {
    ['police'] = {
        jobs = {'police'},
        outfits = {
            {
                label = 'Polizei Uniform',
                male = {
                    ['tshirt_1'] = 58, ['tshirt_2'] = 0,
                    ['torso_1'] = 55, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 41,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                },
                female = {
                    ['tshirt_1'] = 35, ['tshirt_2'] = 0,
                    ['torso_1'] = 48, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 44,
                    ['pants_1'] = 34, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
            }
        }
    },
    ['ambulance'] = {
        jobs = {'ambulance', 'ems'},
        outfits = {
            {
                label = 'Sanitäter Uniform',
                male = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 250, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 86,
                    ['pants_1'] = 96, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0
                },
                female = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 258, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 109,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0
                }
            }
        }
    }
}

-- Payment Settings
Config.EnablePayment = true -- Enable payment system
Config.ClothingChangeCost = 150 -- Cost to change clothes in shop
Config.OutfitSaveCost = 50 -- Cost to save an outfit
Config.FreeClothingChange = false -- Allow free clothing changes
Config.AllowBankPayment = true -- Allow payment with bank account
Config.AllowCashPayment = true -- Allow payment with cash

-- Payment Discounts (in percentage)
Config.JobDiscounts = {
    ['police'] = 100, -- 100% discount (free)
    ['ambulance'] = 100,
    ['mechanic'] = 50, -- 50% discount
}

-- Performance Settings
Config.UpdateInterval = 100 -- Update interval in ms for clothing changes
Config.EnableDebug = false -- Enable debug messages
