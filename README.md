# MTJ2024_Kleidung - Professional FiveM Clothing Script

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/MTJ2025script/Kleidung)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Ready-orange.svg)](https://fivem.net)

Ein professionelles Kleidungsscript für FiveM RP-Server mit vollständiger ESX Legacy und QB-Core Unterstützung.

## ⚠️ WICHTIG: Installation der Datenbank

**VOR dem ersten Start MUSS die install.sql ausgeführt werden!**

```bash
mysql -u username -p database_name < resources/mtj_kleidung/install.sql
```

Oder via phpMyAdmin/HeidiSQL die `install.sql` importieren.

Dies erstellt die benötigten Tabellen:
- `player_outfits` - Speichert gespeicherte Outfits
- `player_skin` - Speichert Spieler-Aussehen (für esx_skin Ersatz)

**Ohne diese Tabellen wird das Script NICHT funktionieren!**

## 🌟 Features

### ⭐ ESX_Skin Ersatz
- ✅ **Vollständiger esx_skin Ersatz** - Kann esx_skin komplett ersetzen!
- ✅ **Automatischer Start** - Öffnet beim Charakter-Spawn
- ✅ **Charaktererstellung** - Für neue Spieler
- ✅ **Skin-Persistenz** - Speichert Aussehen in Datenbank
- ✅ **/skin Command** - Öffnet Menü überall (wie esx_skin)

### Kernfunktionen
- ✅ **Kleidungsauswahl mit Live-Vorschau** - Sieh deine Änderungen in Echtzeit
- ✅ **Outfit-Verwaltung** - Speichere und lade unbegrenzt viele Outfits
- ✅ **Rollenbasierte Outfits** - Spezielle Uniformen für Polizei, Sanitäter, etc.
- ✅ **Zahlungssystem** - Integriertes Bezahlsystem mit Bargeld/Bank
- ✅ **Berufsrabatte** - Automatische Rabatte für bestimmte Jobs

### Framework-Kompatibilität
- ✅ **ESX Legacy** - Vollständig kompatibel
- ✅ **QB-Core** - Vollständig kompatibel
- ✅ **Automatische Erkennung** - Erkennt das Framework automatisch

### Mehrsprachigkeit
- 🇩🇪 Deutsch (Standard)
- 🇬🇧 Englisch
- 🇫🇷 Französisch

### Modernes UI/UX
- 🎨 **Responsive Design** - Funktioniert auf allen Bildschirmgrößen
- 🌈 **Modernes Design** - Glassmorphismus und Animationen
- 💳 **Professionelles Zahlungs-UI** - Intuitive Zahlungsabwicklung
- 🔔 **Benachrichtigungen** - Elegante Feedback-Benachrichtigungen

### Performance
- ⚡ **Optimiert** - Minimaler Server-Impact
- 💾 **Datenbank-Integration** - MySQL mit oxmysql
- 🔧 **Native GTA Functions** - Nutzt SetPedComponentVariation

## 📋 Voraussetzungen

- FiveM Server (aktuellste Version empfohlen)
- ESX Legacy ODER QB-Core Framework
- oxmysql Resource
- MySQL/MariaDB Datenbank
- Internetverbindung für NUI (Font Awesome & jQuery CDN)*

**Hinweis:** Das Script nutzt externe CDNs für Font Awesome und jQuery. Für maximale Sicherheit und Offline-Fähigkeit können diese lokal gehostet werden.

## 🔄 Als esx_skin Ersatz nutzen

**Dieses Script kann esx_skin vollständig ersetzen!**

Siehe **[ESX_SKIN_REPLACEMENT.md](ESX_SKIN_REPLACEMENT.md)** für:
- Schritt-für-Schritt Anleitung
- Migration von esx_skin
- Konfiguration
- Fehlerbehebung

**Schnellstart:**
1. Deaktiviere esx_skin in server.cfg
2. Aktiviere mtj_kleidung
3. Führe install.sql aus
4. Setze `Config.EnableSkinSystem = true`
5. Fertig! Script startet automatisch beim Charakter-Spawn

## 🚀 Installation

### 1. Resource herunterladen
```bash
cd resources
git clone https://github.com/MTJ2025script/Kleidung.git mtj_kleidung
```

### 2. Datenbank einrichten
Führe die `install.sql` Datei in deiner Datenbank aus:
```sql
mysql -u username -p database_name < install.sql
```

### 3. Resource konfigurieren
Öffne `config.lua` und passe die Einstellungen an:
```lua
Config.Framework = 'auto'  -- 'auto', 'esx', oder 'qbcore'
Config.DefaultLanguage = 'de'  -- 'de', 'en', oder 'fr'
```

### 4. Resource in server.cfg hinzufügen
```cfg
ensure oxmysql
ensure mtj_kleidung
```

### 5. Server neustarten
```bash
restart your-server
```

## ⚙️ Konfiguration

### Zahlungssystem
```lua
Config.EnablePayment = true  -- Zahlungssystem aktivieren/deaktivieren
Config.ClothingChangeCost = 150  -- Kosten für Kleidungsänderung
Config.OutfitSaveCost = 50  -- Kosten für Outfit-Speicherung
Config.FreeClothingChange = false  -- Kostenlose Änderungen
```

### Berufsrabatte
```lua
Config.JobDiscounts = {
    ['police'] = 100,  -- 100% Rabatt (kostenlos)
    ['ambulance'] = 100,
    ['mechanic'] = 50,  -- 50% Rabatt
}
```

### Kleidungsgeschäfte
Passe die Koordinaten der Kleidungsgeschäfte in `config.lua` an:
```lua
Config.ClothingShops = {
    vector3(72.3, -1399.1, 29.4),
    vector3(-703.8, -152.3, 37.4),
    -- Weitere Standorte...
}
```

### Rollenbasierte Outfits
Definiere spezielle Outfits für Jobs:
```lua
Config.RoleOutfits = {
    ['police'] = {
        jobs = {'police'},
        outfits = {
            {
                label = 'Polizei Uniform',
                male = { ... },
                female = { ... }
            }
        }
    }
}
```

## 🎮 Nutzung

### Im Spiel
1. Gehe zu einem Kleidungsgeschäft (markiert auf der Karte)
2. Drücke **E** oder nutze `/kleidung` Command
3. Wähle Kleidungsstücke aus verschiedenen Kategorien
4. Sieh die Live-Vorschau deiner Änderungen
5. Speichere dein Outfit für später
6. Bezahle mit Bargeld oder Bank

### Kommandos
- `/kleidung` - Öffnet das Kleidungsmenü (im Shop)

### Keybinds
- **F7** - Standard-Taste zum Öffnen des Menüs (konfigurierbar)
- **ESC** - Menü schließen

## 📁 Struktur

```
mtj_kleidung/
├── client/
│   └── main.lua          # Client-seitige Logik
├── server/
│   └── main.lua          # Server-seitige Logik
├── locales/
│   ├── de.lua            # Deutsche Übersetzung
│   ├── en.lua            # Englische Übersetzung
│   └── fr.lua            # Französische Übersetzung
├── html/
│   ├── index.html        # NUI Interface
│   ├── style.css         # Styling
│   ├── script.js         # JavaScript Logik
│   └── images/           # Bilder und Icons
├── config.lua            # Hauptkonfiguration
├── fxmanifest.lua        # Resource Manifest
├── install.sql           # Datenbankschema
└── README.md             # Diese Datei
```

## 🔧 API

### Client Events

```lua
-- Outfit laden
TriggerEvent('mtj_kleidung:client:loadOutfits', outfits)

-- Outfit gespeichert
TriggerEvent('mtj_kleidung:client:outfitSaved', name)

-- Geld erhalten
TriggerEvent('mtj_kleidung:client:receivePlayerMoney', cash, bank)

-- Zahlungsergebnis
TriggerEvent('mtj_kleidung:client:paymentResult', success, message)
```

### Server Events

```lua
-- Outfits laden
TriggerServerEvent('mtj_kleidung:server:loadOutfits')

-- Outfit speichern
TriggerServerEvent('mtj_kleidung:server:saveOutfit', name, data, slot)

-- Outfit löschen
TriggerServerEvent('mtj_kleidung:server:deleteOutfit', name)

-- Zahlung verarbeiten
TriggerServerEvent('mtj_kleidung:server:processPayment', amount, method, reason)
```

## 🐛 Fehlerbehebung

### Menu öffnet sich nicht
- Stelle sicher, dass du in einem Kleidungsgeschäft bist
- Überprüfe die Konsolenausgabe auf Fehler
- Prüfe ob das Framework korrekt geladen wurde

### Zahlung funktioniert nicht
- Überprüfe ob ESX/QB-Core richtig konfiguriert ist
- Stelle sicher, dass der Spieler genug Geld hat
- Aktiviere Debug-Modus: `Config.EnableDebug = true`

### Outfits werden nicht gespeichert
- Prüfe die Datenbankverbindung
- Stelle sicher, dass die Tabelle `player_outfits` existiert
- Überprüfe oxmysql Installation

## 📝 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe LICENSE Datei für Details.

## 👨‍💻 Entwickler

**MTJ2025**
- GitHub: [@MTJ2025script](https://github.com/MTJ2025script)

## 🤝 Beitragen

Beiträge, Issues und Feature-Requests sind willkommen!

1. Fork das Projekt
2. Erstelle einen Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

## 📞 Support

Bei Fragen oder Problemen:
1. Öffne ein [Issue](https://github.com/MTJ2025script/Kleidung/issues)
2. Kontaktiere uns über Discord

## ⭐ Credits

- Font Awesome für Icons
- Google Fonts für Poppins Schriftart
- FiveM Community

## 📜 Changelog

### Version 1.0.0 (2024-12-18)
- ✨ Initiales Release
- ✅ ESX Legacy & QB-Core Unterstützung
- ✅ Modernes NUI mit Zahlungssystem
- ✅ Mehrsprachigkeit (DE/EN/FR)
- ✅ Rollenbasierte Outfits
- ✅ Outfit-Verwaltung
- ✅ MySQL Integration

---

**Viel Spaß mit MTJ2024_Kleidung! 🎉**