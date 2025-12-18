# MTJ2024_Kleidung als esx_skin Ersatz

## 🔄 ESX_Skin komplett ersetzen

Dieses Script kann **esx_skin vollständig ersetzen** und übernimmt alle Funktionen:
- ✅ Automatisches Laden beim Charakter-Spawn
- ✅ Charaktererstellung für neue Spieler
- ✅ Skin-Speicherung in Datenbank
- ✅ `/skin` Command überall verfügbar
- ✅ Automatisches Speichern bei Änderungen

## 📋 Installation als esx_skin Ersatz

### Schritt 1: esx_skin deaktivieren

Öffne deine `server.cfg` und **entferne oder kommentiere** esx_skin aus:

```cfg
# ensure esx_skin  <-- auskommentieren oder löschen
```

### Schritt 2: MTJ2024_Kleidung aktivieren

Füge in `server.cfg` hinzu:

```cfg
ensure oxmysql
ensure mtj_kleidung
```

**WICHTIG:** `mtj_kleidung` muss **NACH** `es_extended` geladen werden!

```cfg
ensure es_extended
ensure oxmysql
ensure mtj_kleidung
```

### Schritt 3: Datenbank einrichten

Führe die SQL-Datei aus:

```sql
SOURCE resources/mtj_kleidung/install.sql;
```

Dies erstellt zwei Tabellen:
- `player_skin` - Speichert Spieler-Aussehen
- `player_outfits` - Speichert gespeicherte Outfits

### Schritt 4: Konfiguration

Öffne `config.lua` und stelle sicher:

```lua
-- Skin System aktivieren
Config.EnableSkinSystem = true
Config.LoadSkinOnSpawn = true
Config.SaveSkinOnChange = true
Config.EnableCharacterCreation = true

-- /skin Command aktivieren (wie esx_skin)
Config.UseSkinCommand = true
Config.SkinCommandName = 'skin'
```

### Schritt 5: Server neu starten

```
restart your-server
```

## 🎮 Wie funktioniert es?

### Für neue Spieler:
1. Spieler wählt Charakter aus (ESX Character Selection)
2. **MTJ2024_Kleidung öffnet automatisch** das Kleidungsmenü
3. Spieler kann Aussehen anpassen
4. Beim Schließen wird alles automatisch gespeichert

### Für bestehende Spieler:
1. Beim Spawn wird automatisch das gespeicherte Aussehen geladen
2. Mit `/skin` kann das Menü jederzeit geöffnet werden
3. Änderungen werden automatisch gespeichert

## 🔧 Commands

| Command | Beschreibung |
|---------|--------------|
| `/skin` | Öffnet Kleidungsmenü überall (wie esx_skin) |
| `/kleidung` | Öffnet Menü in Kleidungsgeschäften |

## ⚙️ Konfigurationsoptionen

### Zahlungen für /skin deaktivieren

Wenn du möchtest, dass `/skin` kostenlos ist (wie esx_skin):

```lua
Config.EnablePayment = false  -- Komplett kostenlos
```

Oder nur für `/skin` kostenlos, aber Shops kostenpflichtig:

```lua
Config.EnableSkinSystem = true
Config.EnablePayment = true
Config.FreeClothingChange = true  -- Nur für /skin kostenlos
```

### Standard-Skin anpassen

Definiere Standard-Kleidung für neue Spieler:

```lua
Config.DefaultSkin = {
    male = {
        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
        ['torso_1'] = 0, ['torso_2'] = 0,
        ['arms'] = 0,
        ['pants_1'] = 0, ['pants_2'] = 0,
        ['shoes_1'] = 1, ['shoes_2'] = 0,
        -- ... weitere Komponenten
    },
    female = {
        -- ... weibliche Standard-Kleidung
    }
}
```

## 🔄 Migration von esx_skin

### Bestehende Spieler behalten ihre Kleidung?

**JA!** Wenn du von esx_skin wechselst:

1. Das Script erkennt neue Spieler automatisch
2. Beim ersten Login mit MTJ2024_Kleidung öffnet sich das Menü
3. Spieler passen ihre Kleidung einmal an
4. Ab dann wird alles automatisch geladen

### Daten von esx_skin migrieren (optional)

Wenn du bestehende `users` Tabelle mit Skin-Daten hast:

```sql
-- Migration von esx_skin zu mtj_kleidung
INSERT INTO player_skin (identifier, skin)
SELECT identifier, skin 
FROM users 
WHERE skin IS NOT NULL 
AND skin != '';
```

## 📊 Vergleich esx_skin vs MTJ2024_Kleidung

| Feature | esx_skin | MTJ2024_Kleidung |
|---------|----------|------------------|
| Automatisches Laden | ✅ | ✅ |
| /skin Command | ✅ | ✅ |
| Charaktererstellung | ✅ | ✅ |
| 3D Preview | ❌ | ✅ 360° Rotation |
| Zahlungssystem | ❌ | ✅ Optional |
| Kleidungsgeschäfte | ❌ | ✅ 14 Locations |
| Outfit-Speicherung | ❌ | ✅ Unbegrenzt |
| Job-Uniformen | ❌ | ✅ Rollenbasiert |
| Modernes UI | ❌ | ✅ Glassmorphism |
| Multi-Sprache | ❌ | ✅ DE/EN/FR |

## 🐛 Fehlerbehebung

### Script öffnet sich nicht beim ersten Spawn

**Lösung:**
1. Stelle sicher `Config.EnableSkinSystem = true`
2. Prüfe ob Tabelle `player_skin` existiert
3. Überprüfe Ladereihenfolge in server.cfg

### Spieler spawnen ohne Kleidung

**Lösung:**
1. Prüfe `Config.LoadSkinOnSpawn = true`
2. Stelle sicher Datenbank-Verbindung funktioniert
3. Aktiviere Debug: `Config.EnableDebug = true`

### /skin Command funktioniert nicht

**Lösung:**
1. Prüfe `Config.UseSkinCommand = true`
2. Stelle sicher `Config.EnableSkinSystem = true`
3. Restart Resource: `restart mtj_kleidung`

## 📝 Wichtige Hinweise

### ⚠️ Nicht mit esx_skin gleichzeitig nutzen!

Führe **NUR EINEN** der folgenden Scripts aus:
- ❌ esx_skin + mtj_kleidung = KONFLIKT
- ✅ nur mtj_kleidung = FUNKTIONIERT

### ✅ Empfohlene server.cfg Reihenfolge

```cfg
# Core
ensure mysql-async
ensure es_extended

# Database
ensure oxmysql

# Skin/Clothing (nur eines!)
ensure mtj_kleidung  # ✅
# ensure esx_skin    # ❌ auskommentiert!

# Andere Resources
ensure esx_policejob
# ...
```

## 🎯 Best Practices

### Für RP-Server:
```lua
Config.EnablePayment = true
Config.ClothingChangeCost = 150
Config.EnableSkinSystem = true
```

### Für Testing/Development:
```lua
Config.EnablePayment = false
Config.EnableDebug = true
```

### Für Public Server:
```lua
Config.EnableSkinSystem = true
Config.SaveSkinOnChange = true
Config.EnableCharacterCreation = true
```

## 🆘 Support

Problem beim Ersetzen von esx_skin?

1. Überprüfe [INSTALL.md](INSTALL.md)
2. Lese [QUICKSTART.md](QUICKSTART.md)
3. Öffne ein [Issue](https://github.com/MTJ2025script/Kleidung/issues)

---

**MTJ2024_Kleidung - Der bessere esx_skin Ersatz!** 🚀
