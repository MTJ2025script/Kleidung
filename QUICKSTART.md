# MTJ2024_Kleidung - Schnellstart-Anleitung

## ⚠️ WICHTIG: Datenbank MUSS zuerst eingerichtet werden!

**Das Script funktioniert NICHT ohne die Datenbanktabellen!**

## 🚀 5-Minuten Installation

### 1️⃣ Download & Entpacken
```bash
cd resources
git clone https://github.com/MTJ2025script/Kleidung.git mtj_kleidung
```

### 2️⃣ Datenbank Setup (ERFORDERLICH!)
Führe `install.sql` aus:
```sql
SOURCE resources/mtj_kleidung/install.sql;
```

Oder via phpMyAdmin/HeidiSQL/MySQL Workbench:
- Öffne deine Datenbank
- Importiere `install.sql`
- Überprüfe dass `player_outfits` und `player_skin` Tabellen erstellt wurden

### 3️⃣ server.cfg
```cfg
ensure oxmysql
ensure mtj_kleidung
```

### 4️⃣ Server starten
```
restart mtj_kleidung
```

✅ **Fertig!** Gehe zu einem Kleidungsgeschäft und drücke **E**

---

## 🎮 Erste Schritte

### Menü öffnen
- Gehe zu einem Kleidungsgeschäft (🔵 auf der Karte)
- Drücke **E** oder nutze `/kleidung`

### Kleidung ändern
1. Wähle eine Kategorie (Oberteil, Hose, etc.)
2. Klicke auf ein Kleidungsstück
3. Sieh die **Live-Vorschau** mit 3D-Rotation
4. Klicke "Übernehmen & Bezahlen"
5. Wähle Bargeld oder Bank

### Outfit speichern
1. Stelle deine Kleidung zusammen
2. Wechsle zum "Outfits" Tab
3. Klicke "Neues Outfit"
4. Gib einen Namen ein
5. Bezahle und speichere

### Outfit laden
1. Öffne den "Outfits" Tab
2. Klicke ✅ bei gewünschtem Outfit
3. Outfit wird sofort angelegt

---

## ⚙️ Basis-Konfiguration

### Framework einstellen
```lua
-- config.lua
Config.Framework = 'auto'  -- oder 'esx' / 'qbcore'
```

### Sprache ändern
```lua
Config.DefaultLanguage = 'de'  -- oder 'en' / 'fr'
```

### Preise anpassen
```lua
Config.ClothingChangeCost = 150  -- Kosten für Kleidungsänderung
Config.OutfitSaveCost = 50       -- Kosten für Outfit-Speicherung
```

### Zahlungen deaktivieren
```lua
Config.EnablePayment = false  -- Alles kostenlos
```

---

## 🔧 Häufige Probleme

### ❌ "Script not found"
**Lösung:** Ordner muss `mtj_kleidung` heißen

### ❌ "Table doesn't exist"
**Lösung:** `install.sql` ausführen

### ❌ "No framework detected"
**Lösung:** `Config.Framework = 'esx'` setzen

### ❌ Menü öffnet sich nicht
**Lösung:** 
- Im Kleidungsgeschäft sein (< 2.5m)
- F8 Console auf Fehler prüfen

---

## 📱 Features Übersicht

| Feature | Beschreibung |
|---------|--------------|
| 🎨 **3D Preview** | Rotierender Spieler-Preview |
| 💰 **Zahlungen** | Bargeld & Bank Support |
| 💾 **Outfits** | Unbegrenzt speichern & laden |
| 👔 **Job-Outfits** | Spezielle Uniformen |
| 🏷️ **Rabatte** | Job-basierte Discounts |
| 🌍 **Multi-lang** | DE / EN / FR |
| 📱 **Responsive** | Funktioniert auf allen Auflösungen |

---

## 🎯 Commands

| Command | Beschreibung |
|---------|--------------|
| `/kleidung` | Öffnet das Kleidungsmenü |

---

## 🎨 UI Controls

| Aktion | Taste/Button |
|--------|--------------|
| Menü öffnen | **E** (im Shop) |
| Menü schließen | **ESC** |
| Rotation pausieren | ⏸️ Button |
| Ansicht zurücksetzen | 🔄 Button |

---

## 📊 Standard-Preise

| Aktion | Kosten |
|--------|--------|
| Kleidung ändern | 150$ |
| Outfit speichern | 50$ |
| Polizei/EMS | **KOSTENLOS** |

---

## 🎓 Erweiterte Nutzung

### Eigene Shops hinzufügen
```lua
-- config.lua
Config.ClothingShops = {
    vector3(x, y, z),  -- Deine Koordinaten
}
```

### Job-Uniform erstellen
```lua
Config.RoleOutfits = {
    ['mein_job'] = {
        jobs = {'mein_job'},
        outfits = {
            {
                label = 'Meine Uniform',
                male = {
                    ['torso_1'] = 4,
                    ['torso_2'] = 0,
                    -- ... weitere Komponenten
                }
            }
        }
    }
}
```

---

## 📚 Mehr Infos

- 📖 [Vollständige Dokumentation](README.md)
- 🔧 [Installation Guide](INSTALL.md)
- 🤝 [Contribution Guide](CONTRIBUTING.md)

---

## 💡 Tipps

- **Rabatt nutzen:** Bestimmte Jobs bekommen Rabatt
- **Preview nutzen:** Sieh Änderungen bevor du bezahlst
- **Outfits organisieren:** Nutze aussagekräftige Namen
- **Performance:** Deaktiviere Blips bei Bedarf

---

## 🆘 Support

Probleme? Erstelle ein [Issue](https://github.com/MTJ2025script/Kleidung/issues) mit:
- FiveM Version
- Framework (ESX/QB)
- Fehlermeldung (F8 Console)
- Screenshots

---

**Viel Spaß mit MTJ2024_Kleidung! 🎉**
