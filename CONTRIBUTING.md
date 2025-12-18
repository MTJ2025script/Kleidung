# Beitragen zu MTJ2024_Kleidung

Vielen Dank für dein Interesse, zu MTJ2024_Kleidung beizutragen! Dieses Dokument enthält Richtlinien für Beiträge.

## 📋 Code of Conduct

- Sei respektvoll und professionell
- Konstruktive Kritik ist willkommen
- Helfe anderen in der Community
- Keine Belästigung oder Diskriminierung

## 🐛 Bug Reports

Wenn du einen Bug findest:

1. Überprüfe, ob das Problem bereits als [Issue](https://github.com/MTJ2025script/Kleidung/issues) gemeldet wurde
2. Wenn nicht, erstelle ein neues Issue mit:
   - Aussagekräftigem Titel
   - Detaillierter Beschreibung des Problems
   - Schritte zur Reproduktion
   - Erwartetes vs. tatsächliches Verhalten
   - FiveM Server Version
   - Framework (ESX/QB-Core) Version
   - Screenshots (wenn relevant)
   - Console Logs (F8)

### Bug Report Template
```markdown
**Beschreibung:**
Was ist das Problem?

**Reproduktion:**
1. Schritt 1
2. Schritt 2
3. ...

**Erwartetes Verhalten:**
Was sollte passieren?

**Tatsächliches Verhalten:**
Was passiert stattdessen?

**Umgebung:**
- FiveM Version: [z.B. 5848]
- Framework: [ESX Legacy / QB-Core]
- Framework Version: [z.B. 1.9.4]
- Andere relevante Resources: [z.B. oxmysql 2.7.5]

**Logs:**
```lua
-- Console Logs hier einfügen
```

**Screenshots:**
Füge Screenshots hinzu, wenn relevant
```

## 💡 Feature Requests

Für neue Features:

1. Überprüfe existierende Feature Requests
2. Erstelle ein Issue mit dem Label `enhancement`
3. Beschreibe:
   - Was das Feature tun soll
   - Warum es nützlich wäre
   - Wie es implementiert werden könnte (optional)

## 🔧 Pull Requests

### Vorbereitung

1. Fork das Repository
2. Erstelle einen Feature Branch:
   ```bash
   git checkout -b feature/mein-neues-feature
   ```
3. Mache deine Änderungen
4. Teste gründlich auf einem FiveM Server
5. Committe deine Änderungen:
   ```bash
   git commit -m "Add: Beschreibung des Features"
   ```
6. Pushe zum Branch:
   ```bash
   git push origin feature/mein-neues-feature
   ```
7. Öffne einen Pull Request

### Pull Request Guidelines

- **Titel:** Kurz und beschreibend
- **Beschreibung:** Erkläre was und warum geändert wurde
- **Tests:** Beschreibe wie du getestet hast
- **Screenshots:** Füge Screenshots für UI-Änderungen hinzu
- **Breaking Changes:** Kennzeichne Breaking Changes deutlich

### Commit Messages

Verwende aussagekräftige Commit Messages:

- `Add:` - Neue Features
- `Fix:` - Bugfixes
- `Update:` - Änderungen an bestehendem Code
- `Remove:` - Entfernte Features/Code
- `Refactor:` - Code-Refactoring
- `Docs:` - Dokumentationsänderungen
- `Style:` - Code-Formatierung
- `Test:` - Test-bezogene Änderungen

Beispiele:
```
Add: 3D rotating camera for player preview
Fix: Payment system not deducting money correctly
Update: Improve category grid layout
Docs: Add installation instructions for QB-Core
```

## 🏗️ Entwicklungsrichtlinien

### Code Style

**Lua:**
```lua
-- Verwende PascalCase für Funktionen
function GetPlayerClothing()
    -- Code hier
end

-- Verwende camelCase für lokale Variablen
local playerPed = PlayerPedId()
local currentOutfit = {}

-- Verwende UPPER_CASE für Konstanten
local MAX_OUTFITS = 10

-- Kommentiere komplexe Logik
-- Calculate discount based on job
if PlayerJob and Config.JobDiscounts[PlayerJob] then
    discount = Config.JobDiscounts[PlayerJob]
end
```

**JavaScript:**
```javascript
// Verwende camelCase für Variablen und Funktionen
let currentClothing = {};

function openClothingMenu() {
    // Code hier
}

// Verwende UPPER_SNAKE_CASE für Konstanten
const MAX_CATEGORIES = 12;

// Arrow Functions für Callbacks
button.addEventListener('click', () => {
    handleClick();
});
```

**CSS:**
```css
/* Verwende kebab-case für Klassen */
.clothing-menu {
    /* Styles */
}

/* Gruppiere zusammengehörige Styles */
.category-card {
    /* Layout */
    display: flex;
    
    /* Spacing */
    padding: 20px;
    margin: 10px;
    
    /* Visual */
    background: rgba(106, 90, 205, 0.2);
    border-radius: 12px;
    
    /* Animation */
    transition: all 0.3s ease;
}
```

### Performance

- Minimiere Server-Anfragen
- Nutze Client-seitiges Caching wo möglich
- Vermeide unnötige Loops
- Optimiere Datenbankabfragen
- Nutze natives effizient

```lua
-- Gut ✓
local playerPed = PlayerPedId() -- Einmal cachen
local coords = GetEntityCoords(playerPed)

-- Schlecht ✗
GetEntityCoords(PlayerPedId()) -- Mehrfach aufrufen
```

### Sicherheit

- Validiere alle Eingaben (Client & Server)
- Nutze SQL Prepared Statements
- Sanitize User Input
- Überprüfe Berechtigungen serverseitig
- Keine sensiblen Daten im Client-Code

```lua
-- Gut ✓
RegisterNetEvent('mtj_kleidung:server:saveOutfit')
AddEventHandler('mtj_kleidung:server:saveOutfit', function(name, data)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    -- Validierung
    if not identifier or not name or not data then
        return
    end
    
    -- Sanitize
    name = string.sub(name, 1, 60)
    
    -- Prepared Statement
    MySQL.Async.execute('INSERT INTO...', {
        ['@identifier'] = identifier,
        ['@name'] = name
    })
end)
```

### Testing

Teste auf:
- ESX Legacy (aktuellste Version)
- QB-Core (aktuellste Version)
- Verschiedenen Auflösungen (1920x1080, 2560x1440, 3840x2160)
- Mit/ohne andere Scripts
- Mit mehreren gleichzeitigen Spielern

### Dokumentation

- Kommentiere komplexen Code
- Update README.md bei Feature-Änderungen
- Update INSTALL.md bei Setup-Änderungen
- Füge JSDoc/LuaDoc Comments für Funktionen hinzu

```lua
---@param source number Player source ID
---@param amount number Amount to remove
---@param account string Account type ('cash' or 'bank')
---@return boolean success Whether the money was removed successfully
function RemovePlayerMoney(source, amount, account)
    -- Implementation
end
```

## 🌍 Lokalisierung

Beim Hinzufügen neuer Texte:

1. Füge Keys in alle Lokalisierungsdateien hinzu:
   - `locales/de.lua`
   - `locales/en.lua`
   - `locales/fr.lua`

2. Verwende aussagekräftige Keys:
```lua
-- Gut ✓
['outfit_saved_success'] = 'Outfit wurde erfolgreich gespeichert'

-- Schlecht ✗
['msg1'] = 'Success'
```

## 📝 Lizenz

Durch Beiträge stimmst du zu, dass deine Beiträge unter der MIT-Lizenz lizenziert werden.

## 🤝 Code Review Prozess

1. Pull Request wird erstellt
2. Automatische Checks laufen (wenn vorhanden)
3. Mindestens ein Maintainer reviewed den Code
4. Änderungen werden ggf. angefordert
5. Nach Approval wird gemerged
6. Release-Notes werden aktualisiert

## ❓ Fragen?

Bei Fragen kannst du:
- Ein Issue öffnen
- Im Pull Request kommentieren
- Die Community auf Discord kontaktieren

## 🎉 Anerkennungen

Alle Contributors werden in der README.md erwähnt!

Danke für deine Beiträge! 🚀
