--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║           MTJ2024_KLEIDUNG - GREENZONE420 CONFIG             ║
    ║                                                              ║
    ║     Professionelle Konfiguration für FiveM RP-Server        ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
    
    Diese Konfiguration ersetzt VOLLSTÄNDIG esx_skin und bietet:
    - Komplettes Kleidungssystem mit allen GTA V Komponenten
    - Masken, Brillen, Uhren, Armbänder, Helme
    - Kugelsichere Westen, Taschen, Abzeichen
    - 3D Vorschau mit 360° Rotation
    - Zahlungssystem mit Job-Rabatten
    - Automatisches Speichern & Laden
    - Character Creation für neue Spieler
    
    WICHTIG: Passe diese Config an deinen Server an!
--]]

Config = {}

-- ═══════════════════════════════════════════════════════════════
--  SERVER INFORMATIONEN (GreenZone420)
-- ═══════════════════════════════════════════════════════════════

Config.ServerName = "GreenZone420"
Config.ServerLogo = "https://i.imgur.com/your-logo.png"  -- Dein Server Logo URL
Config.ServerColor = "#00ff00"  -- Grün für GreenZone420
Config.ServerDiscord = "discord.gg/greenzone420"
Config.ServerWebsite = "www.greenzone420.de"

-- ═══════════════════════════════════════════════════════════════
--  FRAMEWORK EINSTELLUNGEN
-- ═══════════════════════════════════════════════════════════════

-- Welches Framework nutzt dein Server?
-- Optionen: 'esx', 'qbcore', 'auto'
-- 'auto' erkennt automatisch welches Framework du nutzt
Config.Framework = 'esx'

-- ═══════════════════════════════════════════════════════════════
--  SPRACHE & LOKALISIERUNG
-- ═══════════════════════════════════════════════════════════════

-- Hauptsprache des Servers
-- Optionen: 'de' (Deutsch), 'en' (English), 'fr' (Français)
Config.DefaultLanguage = 'de'

-- Erlaube Spielern die Sprache zu wechseln?
Config.AllowLanguageChange = false

-- ═══════════════════════════════════════════════════════════════
--  ESX_SKIN ERSATZ SYSTEM
-- ═══════════════════════════════════════════════════════════════

-- WICHTIG: Dieses Script ersetzt esx_skin vollständig!
-- Deaktiviere esx_skin in deiner server.cfg!

Config.EnableSkinSystem = true              -- Skin-System aktivieren
Config.ReplaceESXSkin = true                -- esx_skin vollständig ersetzen
Config.LoadSkinOnSpawn = true               -- Skin beim Spawn laden
Config.SaveSkinOnChange = true              -- Automatisch speichern bei Änderungen
Config.EnableCharacterCreation = true       -- Character Creation für neue Spieler

-- Character Creation beim ersten Spawn?
Config.ForceCharacterCreation = true        -- Neue Spieler MÜSSEN Charakter erstellen

-- ═══════════════════════════════════════════════════════════════
--  KLEIDUNGS-MENÜ EINSTELLUNGEN
-- ═══════════════════════════════════════════════════════════════

-- Taste zum Öffnen des Menüs (in Kleidungsgeschäften)
Config.MenuKey = 'E'  -- E-Taste

-- Commands aktivieren
Config.UseCommand = true                    -- /kleidung in Geschäften
Config.CommandName = 'kleidung'

Config.UseSkinCommand = true                -- /skin überall
Config.SkinCommandName = 'skin'

-- Weitere nützliche Commands
Config.UseOutfitCommand = true              -- /outfit [name] zum schnellen Laden
Config.OutfitCommandName = 'outfit'

Config.UseMaskCommand = true                -- /maske zum An/Ausziehen der Maske
Config.MaskCommandName = 'maske'

Config.UseHelmetCommand = true              -- /helm zum An/Ausziehen des Helms
Config.HelmetCommandName = 'helm'

Config.UseGlassesCommand = true             -- /brille zum An/Ausziehen der Brille
Config.GlassesCommandName = 'brille'

Config.UseVestCommand = true                -- /weste für kugelsichere Weste
Config.VestCommandName = 'weste'

-- ═══════════════════════════════════════════════════════════════
--  OUTFIT VERWALTUNG
-- ═══════════════════════════════════════════════════════════════

-- Maximale Anzahl gespeicherter Outfits pro Spieler
Config.MaxOutfits = 15

-- Standard-Outfits für alle Spieler verfügbar
Config.EnableDefaultOutfits = true
Config.DefaultOutfits = {
    {
        name = "Casual",
        description = "Lässiger Look für den Alltag",
        icon = "fa-tshirt"
    },
    {
        name = "Business",
        description = "Professioneller Business-Look",
        icon = "fa-briefcase"
    },
    {
        name = "Sport",
        description = "Sportlicher Look",
        icon = "fa-running"
    }
}

-- ═══════════════════════════════════════════════════════════════
--  VORSCHAU SYSTEM (3D ROTATION)
-- ═══════════════════════════════════════════════════════════════

Config.EnablePreview = true                 -- Live-Vorschau aktivieren
Config.PreviewDelay = 100                   -- Verzögerung in ms (Performance)
Config.Enable3DRotation = true              -- 360° Kamera-Rotation
Config.RotationSpeed = 0.5                  -- Rotationsgeschwindigkeit
Config.CameraDistance = 2.5                 -- Kamera-Abstand zum Spieler
Config.CameraHeight = 0.5                   -- Kamera-Höhe

-- ═══════════════════════════════════════════════════════════════
--  ZAHLUNGSSYSTEM
-- ═══════════════════════════════════════════════════════════════

-- Sollen Spieler für Kleidung bezahlen?
Config.EnablePayment = true

-- Preise (in $)
Config.ClothingChangeCost = 100             -- Kosten für Kleidung ändern
Config.OutfitSaveCost = 25                  -- Kosten zum Speichern eines Outfits
Config.MaskPrice = 50                       -- Preis für Masken
Config.GlassesPrice = 30                    -- Preis für Brillen
Config.HelmetPrice = 75                     -- Preis für Helme
Config.VestPrice = 200                      -- Preis für kugelsichere Weste

-- Zahlungsmethoden
Config.AllowBankPayment = true              -- Bezahlung mit Bank
Config.AllowCashPayment = true              -- Bezahlung mit Bargeld

-- Kostenloses Ändern im /skin Menü?
Config.FreeClothingInSkinMenu = false       -- false = überall kostenpflichtig

-- ═══════════════════════════════════════════════════════════════
--  JOB-RABATTE
-- ═══════════════════════════════════════════════════════════════

-- Rabatte für bestimmte Jobs (in Prozent)
Config.JobDiscounts = {
    ['police'] = 100,       -- Polizei: 100% Rabatt (kostenlos)
    ['sheriff'] = 100,      -- Sheriff: 100% Rabatt (kostenlos)
    ['ambulance'] = 100,    -- Sanitäter: 100% Rabatt (kostenlos)
    ['fib'] = 100,          -- FIB: 100% Rabatt (kostenlos)
    ['mechanic'] = 50,      -- Mechaniker: 50% Rabatt
    ['taxi'] = 25,          -- Taxi: 25% Rabatt
    ['reporter'] = 25,      -- Reporter: 25% Rabatt
}

-- VIP-Rabatte (wenn du ein VIP-System hast)
Config.EnableVIPDiscounts = true
Config.VIPDiscounts = {
    ['vip_bronze'] = 10,    -- Bronze VIP: 10% Rabatt
    ['vip_silver'] = 25,    -- Silver VIP: 25% Rabatt
    ['vip_gold'] = 50,      -- Gold VIP: 50% Rabatt
    ['vip_diamond'] = 100,  -- Diamond VIP: 100% Rabatt (kostenlos)
}

-- ═══════════════════════════════════════════════════════════════
--  KLEIDUNGSGESCHÄFTE
-- ═══════════════════════════════════════════════════════════════

-- Alle Kleidungsgeschäfte in Los Santos
Config.ClothingShops = {
    -- Los Santos
    {coords = vector3(72.3, -1399.1, 29.4), name = "Vespucci Canals"},
    {coords = vector3(-703.8, -152.3, 37.4), name = "Rockford Hills"},
    {coords = vector3(-167.9, -299.0, 39.7), name = "Legion Square"},
    {coords = vector3(428.7, -800.1, 29.5), name = "Strawberry"},
    {coords = vector3(-829.4, -1073.7, 11.3), name = "La Puerta"},
    {coords = vector3(-1447.8, -242.5, 49.8), name = "Cougar Avenue"},
    {coords = vector3(11.6, 6514.2, 31.9), name = "Paleto Bay"},
    {coords = vector3(123.6, -219.4, 54.6), name = "Hawick"},
    {coords = vector3(1696.3, 4829.3, 42.1), name = "Grapeseed"},
    {coords = vector3(618.1, 2759.6, 42.1), name = "Harmony"},
    {coords = vector3(1190.6, 2713.4, 38.2), name = "Grand Senora Desert"},
    {coords = vector3(-1193.4, -772.3, 17.3), name = "Vespucci Beach"},
    {coords = vector3(-3172.5, 1048.1, 20.9), name = "Chumash"},
    {coords = vector3(-1108.4, 2708.9, 19.1), name = "Route 68"},
}

-- Interaktions-Radius (in Metern)
Config.ShopRadius = 2.5

-- ═══════════════════════════════════════════════════════════════
--  KARTEN-BLIPS
-- ═══════════════════════════════════════════════════════════════

Config.EnableBlips = true                   -- Blips auf der Karte anzeigen
Config.BlipSprite = 73                      -- Icon (73 = T-Shirt)
Config.BlipColor = 2                        -- Farbe (2 = Grün für GreenZone420!)
Config.BlipScale = 0.8                      -- Größe
Config.BlipName = "Kleidungsgeschäft"       -- Name auf der Karte

-- ═══════════════════════════════════════════════════════════════
--  ROLLENBASIERTE UNIFORMEN
-- ═══════════════════════════════════════════════════════════════

-- Spezielle Uniformen für Jobs
Config.RoleOutfits = {
    -- Polizei
    ['police'] = {
        jobs = {'police', 'sheriff', 'state'},
        outfits = {
            {
                label = 'Streifenpolizist',
                male = {
                    ['tshirt_1'] = 58, ['tshirt_2'] = 0,
                    ['torso_1'] = 55, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 41,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bproof_1'] = 0, ['bproof_2'] = 0
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
                    ['ears_1'] = 2, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bproof_1'] = 0, ['bproof_2'] = 0
                }
            },
            {
                label = 'SEK / SWAT',
                male = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 52, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 40,
                    ['pants_1'] = 31, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = 117, ['helmet_2'] = 0,
                    ['mask_1'] = 52, ['mask_2'] = 0,
                    ['bproof_1'] = 15, ['bproof_2'] = 0
                },
                female = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 49, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 43,
                    ['pants_1'] = 35, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = 117, ['helmet_2'] = 0,
                    ['mask_1'] = 52, ['mask_2'] = 0,
                    ['bproof_1'] = 15, ['bproof_2'] = 0
                }
            }
        }
    },
    
    -- Sanitäter / EMS
    ['ambulance'] = {
        jobs = {'ambulance', 'ems'},
        outfits = {
            {
                label = 'Sanitäter',
                male = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 250, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 86,
                    ['pants_1'] = 96, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0
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
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0
                }
            }
        }
    },
    
    -- Mechaniker
    ['mechanic'] = {
        jobs = {'mechanic'},
        outfits = {
            {
                label = 'Mechaniker',
                male = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 12, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 11,
                    ['pants_1'] = 36, ['pants_2'] = 0,
                    ['shoes_1'] = 12, ['shoes_2'] = 6,
                    ['helmet_1'] = -1, ['helmet_2'] = 0
                },
                female = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 12, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 11,
                    ['pants_1'] = 36, ['pants_2'] = 0,
                    ['shoes_1'] = 12, ['shoes_2'] = 6,
                    ['helmet_1'] = -1, ['helmet_2'] = 0
                }
            }
        }
    }
}

-- ═══════════════════════════════════════════════════════════════
--  STANDARD-SKINS (Neue Spieler)
-- ═══════════════════════════════════════════════════════════════

Config.DefaultSkin = {
    male = {
        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
        ['torso_1'] = 0, ['torso_2'] = 0,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 0,
        ['pants_1'] = 0, ['pants_2'] = 0,
        ['shoes_1'] = 1, ['shoes_2'] = 0,
        ['helmet_1'] = -1, ['helmet_2'] = 0,
        ['chain_1'] = 0, ['chain_2'] = 0,
        ['ears_1'] = -1, ['ears_2'] = 0,
        ['bags_1'] = 0, ['bags_2'] = 0,
        ['glasses_1'] = -1, ['glasses_2'] = 0,
        ['mask_1'] = 0, ['mask_2'] = 0,
        ['bproof_1'] = 0, ['bproof_2'] = 0,
        ['watches_1'] = -1, ['watches_2'] = 0,
        ['bracelets_1'] = -1, ['bracelets_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
        ['torso_1'] = 0, ['torso_2'] = 0,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 0,
        ['pants_1'] = 0, ['pants_2'] = 0,
        ['shoes_1'] = 1, ['shoes_2'] = 0,
        ['helmet_1'] = -1, ['helmet_2'] = 0,
        ['chain_1'] = 0, ['chain_2'] = 0,
        ['ears_1'] = -1, ['ears_2'] = 0,
        ['bags_1'] = 0, ['bags_2'] = 0,
        ['glasses_1'] = -1, ['glasses_2'] = 0,
        ['mask_1'] = 0, ['mask_2'] = 0,
        ['bproof_1'] = 0, ['bproof_2'] = 0,
        ['watches_1'] = -1, ['watches_2'] = 0,
        ['bracelets_1'] = -1, ['bracelets_2'] = 0
    }
}

-- ═══════════════════════════════════════════════════════════════
--  PERFORMANCE & ERWEITERT
-- ═══════════════════════════════════════════════════════════════

Config.UpdateInterval = 100                 -- Update-Intervall in ms
Config.EnableDebug = false                  -- Debug-Modus (für Entwickler)

-- Datenbank
Config.UseOxMySQL = true                    -- oxmysql verwenden (empfohlen)

-- Benachrichtigungen
Config.NotificationDuration = 5000          -- Dauer in ms (5 Sekunden)

-- Anti-Exploit
Config.EnableAntiCheat = true               -- Verhindert Cheating/Exploits
Config.MaxClothingChangesPerMinute = 20     -- Max Änderungen pro Minute

-- Logging (für Admin-Überwachung)
Config.EnableLogging = true                 -- Logs aktivieren
Config.LogToDiscord = false                 -- Discord Webhook (optional)
Config.DiscordWebhook = ""                  -- Discord Webhook URL

--[[
    ════════════════════════════════════════════════════════════
    
    GREENZONE420 - ERWEITERTE EINSTELLUNGEN
    
    Für weitere Anpassungen siehe:
    - README.md - Vollständige Dokumentation
    - INSTALL.md - Installations-Anleitung
    - ESX_SKIN_REPLACEMENT.md - ESX Skin Ersatz Guide
    
    Support: discord.gg/greenzone420
    
    ════════════════════════════════════════════════════════════
--]]
