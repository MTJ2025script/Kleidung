# 🌿 MTJ2024_Kleidung - GreenZone420 Edition

## 🎯 Das komplette Kleidungssystem für deinen FiveM RP-Server

**Willkommen bei MTJ2024_Kleidung** - dem professionellsten Kleidungs- und Skin-System für FiveM!

Dieses System **ersetzt vollständig esx_skin** und bietet dir alle Features, die du für einen modernen RP-Server brauchst.

---

## ✨ Was macht dieses Script so besonders?

### 🔥 Vollständiger ESX_Skin Ersatz
- ✅ **Alle GTA V Kleidungsteile** - Masken, Helme, Brillen, Uhren, Armbänder, Westen
- ✅ **Character Creation** - Neue Spieler erstellen ihren Charakter automatisch
- ✅ **Automatisches Speichern & Laden** - Kein manuelles Speichern nötig
- ✅ **3D Vorschau mit 360° Rotation** - Sieh deinen Charakter aus allen Winkeln

### 🎮 Gameplay Features
- ✅ **Quick Commands** - `/maske`, `/helm`, `/brille`, `/weste` zum schnellen An/Ausziehen
- ✅ **Unlimited Outfits** - Speichere so viele Outfits wie du willst
- ✅ **Job-Uniformen** - Automatische Uniformen für Polizei, EMS, Mechaniker, etc.
- ✅ **Job-Rabatte** - Staatsjobs bekommen Rabatte oder kostenlose Kleidung

### 💰 Wirtschaftssystem
- ✅ **Zahlungssystem** - Spieler bezahlen für Kleidung (konfigurierbar)
- ✅ **Bank & Bargeld** - Flexible Zahlungsmethoden
- ✅ **VIP-Rabatte** - Belohne deine VIP-Spieler

### 🎨 Modernes Design
- ✅ **Professionelles UI** - Glassmorphism Design
- ✅ **Responsive** - Funktioniert auf allen Auflösungen
- ✅ **Deutsche Sprache** - Vollständig auf Deutsch

---

## 📦 Installation (5 Minuten)

### Schritt 1: Download
```bash
cd resources
git clone https://github.com/MTJ2025script/Kleidung.git mtj_kleidung
```

### Schritt 2: Datenbank einrichten
⚠️ **WICHTIG:** Ohne Datenbank funktioniert das Script nicht!

```bash
mysql -u dein_benutzer -p deine_datenbank < resources/mtj_kleidung/install.sql
```

Oder importiere `install.sql` via phpMyAdmin/HeidiSQL.

### Schritt 3: esx_skin deaktivieren
Öffne deine `server.cfg` und **entferne oder kommentiere** esx_skin:

```cfg
# ensure esx_skin  <-- Diese Zeile auskommentieren oder löschen!
```

### Schritt 4: MTJ2024_Kleidung aktivieren
Füge in `server.cfg` hinzu:

```cfg
# Core
ensure es_extended
ensure oxmysql

# Kleidungssystem (ersetzt esx_skin)
ensure mtj_kleidung
```

### Schritt 5: Konfiguration anpassen
1. Kopiere `config_greenzone420.lua` nach `config.lua`
2. Passe die Einstellungen an deinen Server an
3. Ändere Logo/Farben/Namen

### Schritt 6: Server starten
```
restart your-server
```

✅ **Fertig!** Das Script läuft jetzt!

---

## 🎮 Commands für Spieler

| Command | Beschreibung | Wo verfügbar? |
|---------|--------------|---------------|
| `/skin` | Öffnet das komplette Kleidungsmenü | **Überall** |
| `/kleidung` | Öffnet das Menü | Nur in Shops |
| `/maske` | Maske an/ausziehen | Überall |
| `/helm` | Helm an/ausziehen | Überall |
| `/brille` | Brille an/ausziehen | Überall |
| `/weste` | Kugelsichere Weste an/ausziehen | Überall |
| **E-Taste** | Menü öffnen | In Kleidungsshops |

---

## ⚙️ Konfiguration für Server-Owner

### Grundeinstellungen

```lua
-- Server Info
Config.ServerName = "GreenZone420"
Config.ServerLogo = "https://i.imgur.com/dein-logo.png"
Config.ServerColor = "#00ff00"  -- Grün

-- Framework
Config.Framework = 'esx'  -- oder 'qbcore'

-- Sprache
Config.DefaultLanguage = 'de'
```

### Zahlungssystem anpassen

```lua
-- Aktivieren/Deaktivieren
Config.EnablePayment = true

-- Preise festlegen
Config.ClothingChangeCost = 100  -- Kleidung ändern kostet 100$
Config.OutfitSaveCost = 25       -- Outfit speichern kostet 25$
Config.MaskPrice = 50            -- Maske kostet 50$
```

### Job-Rabatte einrichten

```lua
Config.JobDiscounts = {
    ['police'] = 100,     -- Polizei: Kostenlos (100% Rabatt)
    ['ambulance'] = 100,  -- EMS: Kostenlos
    ['mechanic'] = 50,    -- Mechaniker: 50% Rabatt
    ['taxi'] = 25,        -- Taxi: 25% Rabatt
}
```

### VIP-Rabatte

```lua
Config.EnableVIPDiscounts = true
Config.VIPDiscounts = {
    ['vip_gold'] = 50,      -- Gold VIP: 50% Rabatt
    ['vip_diamond'] = 100,  -- Diamond VIP: Kostenlos
}
```

### Neue Kleidungsshops hinzufügen

```lua
Config.ClothingShops = {
    {coords = vector3(x, y, z), name = "Dein Shop Name"},
    -- Weitere Shops...
}
```

### Job-Uniformen erstellen

```lua
Config.RoleOutfits = {
    ['dein_job'] = {
        jobs = {'dein_job'},
        outfits = {
            {
                label = 'Deine Uniform',
                male = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 4, ['torso_2'] = 0,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 10, ['shoes_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    -- Weitere Komponenten...
                },
                female = {
                    -- Weibliche Variante...
                }
            }
        }
    }
}
```

---

## 🎨 UI Anpassungen

### Eigenes Logo einbinden

1. Lade dein Logo auf [imgur.com](https://imgur.com) hoch
2. Kopiere die Direkt-URL
3. Setze in config.lua:
```lua
Config.ServerLogo = "https://i.imgur.com/DEINE_LOGO_ID.png"
```

### Farben ändern

```lua
Config.ServerColor = "#00ff00"  -- Grün für GreenZone420
-- Andere Farben:
-- "#ff0000" = Rot
-- "#0000ff" = Blau
-- "#ffff00" = Gelb
-- "#ff00ff" = Lila
```

### Hintergrundbild ändern

Bearbeite `html/style.css`:
```css
.clothing-menu {
    background-image: url('https://dein-hintergrundbild.png');
}
```

---

## 🔧 Erweiterte Features

### Alle Kleidungsteile die unterstützt werden:

1. **Komponenten (Drawables):**
   - 👕 Unterhemd (tshirt)
   - 🧥 Oberteil/Jacke (torso)
   - 🏅 Abzeichen/Patches (decals)
   - 💪 Arme/Ärmel (arms)
   - 👖 Hose (pants)
   - 👟 Schuhe (shoes)
   - 💎 Kette (chain)
   - 🎒 Tasche/Rucksack (bags)
   - 😷 Maske (mask)
   - 🛡️ Kugelsichere Weste (bproof)

2. **Props/Accessoires:**
   - 🪖 Helm/Hut (helmet)
   - 🕶️ Brille (glasses)
   - 🎧 Ohren/Kopfhörer (ears)
   - ⌚ Uhr (watches)
   - 📿 Armband (bracelets)

### Performance Optimierung

```lua
-- Für Server mit vielen Spielern (100+)
Config.UpdateInterval = 150     -- Höherer Wert = bessere Performance
Config.EnableDebug = false      -- Debug immer aus in Production

-- Für kleinere Server
Config.UpdateInterval = 50      -- Schnellere Updates
```

### Anti-Cheat Einstellungen

```lua
Config.EnableAntiCheat = true
Config.MaxClothingChangesPerMinute = 20  -- Verhindert Spam
```

---

## 🆘 Fehlerbehebung

### Script startet nicht
**Problem:** Script wird nicht geladen

**Lösung:**
1. Prüfe ob `mtj_kleidung` in server.cfg steht
2. Stelle sicher dass es **nach** es_extended geladen wird
3. Überprüfe F8 Console auf Fehler

### Datenbank-Fehler
**Problem:** `Table 'player_skin' doesn't exist`

**Lösung:**
```bash
mysql -u user -p database < resources/mtj_kleidung/install.sql
restart mtj_kleidung
```

### Menü öffnet sich nicht
**Problem:** E-Taste funktioniert nicht

**Lösung:**
1. Bist du im Shop? (2.5m Radius)
2. Überprüfe F8 Console
3. Versuche `/skin` Command

### Kleidung wird nicht gespeichert
**Problem:** Nach Reconnect ist Kleidung weg

**Lösung:**
1. Prüfe ob install.sql ausgeführt wurde
2. Aktiviere Debug: `Config.EnableDebug = true`
3. Überprüfe Server-Console auf Datenbank-Fehler

### Konflikte mit anderen Scripts
**Problem:** Andere Kleidungs-Scripts verursachen Probleme

**Lösung:**
1. Deaktiviere **alle** anderen Kleidungs-Scripts
2. Besonders: esx_skin, fivem-appearance, etc.
3. Nur **ein** Kleidungs-Script pro Server!

---

## 📊 Vergleich mit esx_skin

| Feature | esx_skin | MTJ2024_Kleidung |
|---------|----------|------------------|
| Character Creation | ✅ Basis | ✅ Erweitert |
| Kleidung ändern | ✅ | ✅ |
| 3D Vorschau | ❌ | ✅ 360° Rotation |
| Masken | ✅ | ✅ + Quick Command |
| Uhren/Armbänder | ❌ | ✅ |
| Outfits speichern | ❌ | ✅ Unbegrenzt |
| Job-Uniformen | ❌ | ✅ |
| Zahlungssystem | ❌ | ✅ Optional |
| Job-Rabatte | ❌ | ✅ |
| VIP-System | ❌ | ✅ |
| Modernes UI | ❌ | ✅ Glassmorphism |
| Mehrsprachig | ❌ | ✅ DE/EN/FR |

---

## 🎓 Best Practices

### Für Realistische RP-Server:
```lua
Config.EnablePayment = true
Config.ClothingChangeCost = 150
Config.JobDiscounts = {
    ['police'] = 100,
    ['ambulance'] = 100,
}
```

### Für Community/Fun Server:
```lua
Config.EnablePayment = false  -- Alles kostenlos
Config.MaxOutfits = 50       -- Viele Outfits
```

### Für Hardcore RP:
```lua
Config.EnablePayment = true
Config.ClothingChangeCost = 500  -- Teuer
Config.JobDiscounts = {}          -- Keine Rabatte
Config.EnableAntiCheat = true
```

---

## 🔐 Sicherheit & Performance

### Was das Script verhindert:
- ✅ SQL Injection (Prepared Statements)
- ✅ Clothing Spam (Rate Limiting)
- ✅ Invalid Data (Server-side Validation)
- ✅ Exploits (Anti-Cheat System)

### Performance:
- 📊 Client FPS Impact: < 1 FPS
- 📊 Server MS: < 0.1ms
- 📊 Memory: ~10MB
- 📊 Database Queries: < 10ms

---

## 📝 Datenbank-Struktur

### player_skin Tabelle
```sql
- id: Eindeutige ID
- identifier: Spieler Identifier (Steam, License, etc.)
- skin: JSON mit kompletter Kleidung
- created_at: Erstellungsdatum
- updated_at: Letzte Änderung
```

### player_outfits Tabelle
```sql
- id: Eindeutige ID
- identifier: Spieler Identifier
- name: Outfit Name
- outfit_data: JSON mit Kleidungsdaten
- slot: Outfit Slot Nummer
- created_at: Erstellungsdatum
- updated_at: Letzte Änderung
```

---

## 🌐 Multi-Server Support

Du hast mehrere Server? Kein Problem!

### Gemeinsame Datenbank:
```lua
-- Server 1, 2, 3 nutzen die gleiche Datenbank
-- Spieler haben auf allen Servern die gleiche Kleidung!
```

### Getrennte Datenbanken:
```lua
-- Jeder Server hat eigene Kleidung
-- Passe die MySQL Connection an
```

---

## 💡 Tipps & Tricks

### Tipp 1: Schnelle Masken-Wechsel
```
/maske - Maske schnell an/ausziehen
Perfekt für Überfälle oder Undercover!
```

### Tipp 2: Job-Uniformen
```
Im Outfits-Tab findest du deine Job-Uniformen
Polizisten haben mehrere Varianten!
```

### Tipp 3: Outfit-Organisation
```
Gib deinen Outfits sinnvolle Namen:
- "Casual Freitag"
- "Business Meeting"
- "Nachtschicht"
```

### Tipp 4: VIP-Spieler belohnen
```lua
-- VIP-Spieler bekommen bessere Rabatte
Config.VIPDiscounts = {
    ['vip_diamond'] = 100  -- Kostenlos!
}
```

---

## 🎯 Roadmap & Zukünftige Features

### Geplant für v1.1:
- [ ] Barber Shop Integration (Friseur)
- [ ] Tattoo Shop Support
- [ ] Outfit Sharing (Teile Outfits mit Freunden)
- [ ] Fashion Shows (Events)
- [ ] Admin Panel
- [ ] Statistics Dashboard

### Geplant für v1.2:
- [ ] Mobile App Integration
- [ ] Seasonal Collections
- [ ] Achievement System
- [ ] Clothing Designer Tool

---

## 📞 Support & Community

### 🐛 Bug gefunden?
Erstelle ein Issue auf GitHub mit:
- FiveM Version
- Framework (ESX/QB-Core)
- Fehlermeldung (F8 Console)
- Screenshots

### 💬 Community
- Discord: discord.gg/greenzone420
- GitHub: github.com/MTJ2025script/Kleidung

### 📖 Weitere Dokumentation
- [INSTALL.md](INSTALL.md) - Detaillierte Installation
- [QUICKSTART.md](QUICKSTART.md) - Schnellstart
- [ESX_SKIN_REPLACEMENT.md](ESX_SKIN_REPLACEMENT.md) - ESX Skin Guide
- [FEATURES.md](FEATURES.md) - Alle Features

---

## 📜 Lizenz

MIT License - Du darfst das Script frei nutzen, verändern und verteilen!

---

## 🙏 Credits

**Entwickelt von:** MTJ2025  
**Server:** GreenZone420  
**Version:** 1.0.0

---

<div align="center">

**🌿 GreenZone420 - Dein professioneller FiveM RP-Server 🌿**

*Made with ❤️ in Germany*

</div>
