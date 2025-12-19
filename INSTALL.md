# MTJ2024_Kleidung - Installationsanleitung

## Schnellstart

### Schritt 1: Download
```bash
cd resources
git clone https://github.com/MTJ2025script/Kleidung.git mtj_kleidung
```

### Schritt 2: Datenbank einrichten
1. Öffne deine MySQL/MariaDB Datenbank
2. Führe die `install.sql` aus:
```bash
mysql -u dein_benutzer -p deine_datenbank < resources/mtj_kleidung/install.sql
```

Oder importiere die SQL-Datei über phpMyAdmin/HeidiSQL/MySQL Workbench.

### Schritt 3: Dependencies prüfen
Stelle sicher, dass folgende Resources installiert sind:
- `oxmysql` (erforderlich)
- `es_extended` ODER `qb-core` (eines von beiden erforderlich)

### Schritt 4: server.cfg anpassen
Füge folgende Zeilen zu deiner `server.cfg` hinzu:
```cfg
# Dependencies
ensure oxmysql
ensure es_extended  # oder qb-core

# MTJ2024_Kleidung
ensure mtj_kleidung
```

### Schritt 5: Konfiguration
Öffne `config.lua` und passe die Einstellungen an deine Bedürfnisse an:

```lua
-- Framework auswählen
Config.Framework = 'auto'  -- 'auto', 'esx', oder 'qbcore'

-- Sprache festlegen
Config.DefaultLanguage = 'de'  -- 'de', 'en', oder 'fr'

-- Zahlungssystem
Config.EnablePayment = true
Config.ClothingChangeCost = 150
Config.OutfitSaveCost = 50
```

### Schritt 6: Server starten
Starte deinen FiveM Server neu oder nutze:
```
restart mtj_kleidung
```

## Erweiterte Konfiguration

### Kleidungsgeschäfte anpassen
Bearbeite die Koordinaten in `config.lua`:
```lua
Config.ClothingShops = {
    vector3(72.3, -1399.1, 29.4),    -- Vespucci
    vector3(-703.8, -152.3, 37.4),   -- Rockford Hills
    -- Füge weitere Standorte hinzu
}
```

### Job-Rabatte einrichten
```lua
Config.JobDiscounts = {
    ['police'] = 100,      -- 100% Rabatt (kostenlos)
    ['ambulance'] = 100,   -- 100% Rabatt
    ['mechanic'] = 50,     -- 50% Rabatt
    ['taxi'] = 25,         -- 25% Rabatt
}
```

### Rollenbasierte Outfits hinzufügen
```lua
Config.RoleOutfits = {
    ['dein_job'] = {
        jobs = {'dein_job', 'dein_anderer_job'},
        outfits = {
            {
                label = 'Deine Uniform',
                male = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 4, ['torso_2'] = 14,
                    -- Weitere Komponenten...
                },
                female = {
                    ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                    ['torso_1'] = 27, ['torso_2'] = 0,
                    -- Weitere Komponenten...
                }
            }
        }
    }
}
```

## Fehlerbehebung

### "Script not found" Fehler
- Stelle sicher, dass der Ordner `mtj_kleidung` heißt
- Überprüfe ob alle Dateien vorhanden sind
- Prüfe die Dateiberechtigungen

### Datenbank-Fehler
```
Error: Table 'player_outfits' doesn't exist
```
**Lösung:** Führe die `install.sql` erneut aus

### Framework nicht erkannt
```
ERROR: No framework detected!
```
**Lösung:** 
1. Setze `Config.Framework = 'esx'` oder `'qbcore'`
2. Stelle sicher, dass ESX/QB-Core korrekt läuft
3. Überprüfe die Ladereihenfolge in server.cfg

### Menü öffnet sich nicht
- Prüfe ob du im Kleidungsgeschäft bist (2.5m Radius)
- Überprüfe F8 Console auf Fehler
- Stelle sicher, dass NUI-Dateien geladen wurden

### Zahlungen funktionieren nicht
- Prüfe ob der Spieler genug Geld hat
- Aktiviere Debug: `Config.EnableDebug = true`
- Überprüfe Server-Console auf Fehler

## Performance-Optimierung

### Für große Server (100+ Spieler)
```lua
Config.UpdateInterval = 150  -- Erhöhe auf 150ms
Config.EnableBlips = false   -- Deaktiviere Blips wenn nicht benötigt
```

### Für kleinere Server
```lua
Config.UpdateInterval = 50   -- Schnellere Updates
Config.EnableDebug = false   -- Deaktiviere Debug in Production
```

## Datenbank-Wartung

### Alte Outfits löschen
```sql
-- Outfits älter als 90 Tage löschen
DELETE FROM player_outfits 
WHERE updated_at < DATE_SUB(NOW(), INTERVAL 90 DAY);
```

### Outfits pro Spieler begrenzen
```sql
-- Behalte nur die neuesten 10 Outfits pro Spieler
DELETE t1 FROM player_outfits t1
INNER JOIN (
    SELECT identifier, id
    FROM (
        SELECT identifier, id,
        ROW_NUMBER() OVER (PARTITION BY identifier ORDER BY updated_at DESC) as rn
        FROM player_outfits
    ) ranked
    WHERE rn > 10
) t2 ON t1.id = t2.id;
```

## Support

Bei Problemen:
1. Überprüfe die [FAQ](https://github.com/MTJ2025script/Kleidung/wiki/FAQ)
2. Suche in [Issues](https://github.com/MTJ2025script/Kleidung/issues)
3. Erstelle ein neues Issue mit:
   - FiveM Server Version
   - Framework (ESX/QB-Core) Version
   - Fehlermeldung aus F8 Console
   - Server Console Logs

## Updates

Zum Aktualisieren:
```bash
cd resources/mtj_kleidung
git pull origin main
restart mtj_kleidung
```

**Wichtig:** Überprüfe nach Updates ob neue Config-Optionen hinzugefügt wurden!

## Mehr Informationen

- [README.md](README.md) - Hauptdokumentation
- [version.json](version.json) - Versionsinfo & Changelog
- [GitHub Repository](https://github.com/MTJ2025script/Kleidung)
