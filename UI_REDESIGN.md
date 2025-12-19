# 🎨 UI REDESIGN - GREENZONE420 KLEIDUNGSSYSTEM

## 🔥 KOMPLETT NEUES DESIGN

Das UI wurde von Grund auf neu entwickelt basierend auf modernen FiveM RP Standards!

---

## ✨ Was ist NEU?

### 🎯 Vollbild-Design (Fullscreen)
- **50/50 Split:** Linke Seite = 3D Player Preview | Rechte Seite = Controls
- Maximale Bildschirmausnutzung
- Kein winziges Fenster mehr!

### 👤 GROSSER 3D Player Preview
- **Linke Bildschirmhälfte vollständig** für Player-Ansicht
- 360° Rotation mit Animation
- Player Name Tag am unteren Rand
- Pause/Reset Controls im Header
- Animierte Background-Effekte

### 📋 Listen-basierte Auswahl (KEINE Vierecke!)
- **Große Item-Cards** in Listenform
- Jedes Item hat:
  - Icon links
  - Name & Beschreibung
  - Prev/Next Buttons für Auswahl
  - Aktueller Wert / Maximum
  - Preis rechts
- Einfach zu navigieren
- Touch-friendly Design

### 🎨 Modernes GreenZone420 Branding
- Grüne Akzentfarbe (#00ff00)
- Dark Theme für RP-Server
- Professionelle Animationen
- Smooth Transitions

---

## 📐 Layout-Struktur

```
┌─────────────────────────────────────────────────────────────┐
│                     FULLSCREEN UI                           │
├──────────────────────────┬──────────────────────────────────┤
│                          │  [Top Bar]                       │
│    3D PLAYER PREVIEW     │  Bargeld: $1,500  Bank: $5,000  │
│                          │  [X] Schließen                   │
│    [GreenZone420 Logo]   ├──────────────────────────────────┤
│                          │  [Tabs]                          │
│    ┌──────────────┐      │  [Kleidung] [Outfits] [Uniform] │
│    │              │      ├──────────────────────────────────┤
│    │   SPIELER    │      │  ITEM LIST (Scrollable)          │
│    │   MODELL     │      │                                  │
│    │   (360°)     │      │  ┌─────────────────────────────┐│
│    │              │      │  │ [👕] Unterhemd              ││
│    └──────────────┘      │  │      [<] 1/15 [>]  $25     ││
│                          │  └─────────────────────────────┘│
│    [Pause] [Reset]       │  ┌─────────────────────────────┐│
│                          │  │ [👔] Oberteil / Jacke       ││
│    [Live] [360°]         │  │      [<] 5/120 [>]  $50    ││
│                          │  └─────────────────────────────┘│
│                          │  ┌─────────────────────────────┐│
│                          │  │ [👖] Hose                   ││
│                          │  │      [<] 12/80 [>]  $40    ││
│                          │  └─────────────────────────────┘│
│                          │  ...mehr Items...                │
│                          ├──────────────────────────────────┤
│                          │  [Action Footer]                 │
│                          │  [Abbrechen] [Speichern]        │
└──────────────────────────┴──────────────────────────────────┘
```

---

## 🎮 Features im Detail

### 1. Player Preview (Linke Seite)

**Header:**
- 🌿 GreenZone420 Logo (animiert)
- Pause/Resume Button für Rotation
- Reset View Button

**Main Display:**
- Voller Bildschirm für 3D Player
- 360° automatische Rotation
- Rotation Indicator in der Mitte
- Player Name Tag am unteren Rand

**Footer:**
- Info Badges: "Live Vorschau", "360° Ansicht"

### 2. Controls (Rechte Seite)

**Top Bar:**
- Bargeld & Bank Anzeige (groß und lesbar)
- Schließen Button (rot)

**Discount Banner:**
- Zeigt VIP/Job Rabatte an
- Animierter Slide-In Effekt

**Tab Navigation:**
- Kleidung Tab
- Gespeicherte Outfits Tab
- Berufs-Uniformen Tab

**Item List:**
- Scrollbar (Custom styled)
- Große Item Cards:
  ```
  [Icon] Name              [<] Wert [>]  $Preis
         Beschreibung
  ```
- Hover Effekte
- Active State Highlighting

**Action Footer:**
- Abbrechen Button (sekundär)
- Änderungen Speichern Button (primär, grün)

---

## 🎨 Design-Details

### Farben
```css
--primary-color: #00ff00      /* GreenZone420 Grün */
--bg-dark: #0a0a0a            /* Hintergrund */
--bg-card: #151515            /* Karten */
--text-primary: #ffffff       /* Text */
--text-secondary: #a0a0a0     /* Sekundär Text */
```

### Animationen
- ✅ Fade In beim Öffnen
- ✅ Slide In für Tabs
- ✅ Hover Effects auf allen Buttons
- ✅ Active State Glow
- ✅ Smooth Transitions (0.3s)
- ✅ Rotating Background

### Typography
- **Font:** Inter (Modern, Clean)
- **Sizes:**
  - Titel: 28px
  - Item Names: 18px
  - Beschreibungen: 14px
  - Buttons: 16px

---

## 📱 Responsive Design

- Optimiert für 1920x1080 (Standard FiveM)
- Funktioniert bei 1600x900
- Funktioniert bei 1366x768
- Split-Layout passt sich an

---

## 🔧 Technische Verbesserungen

### Performance
- **Kein Grid mit 100 Items** - Nur sichtbare Items
- Lazy Loading für Listen
- CSS Transforms für Animationen (GPU accelerated)
- Optimierte Scrollbar

### Benutzerfreundlichkeit
- **Große Klick-Targets** (min. 40x40px)
- Klare visuelle Hierarchie
- Sofortiges Feedback bei Interaktionen
- Tastatur-Navigation möglich (ESC zum Schließen)

### Accessibility
- Hoher Kontrast
- Große Schrift
- Icons + Text Labels
- Klare Fokus-States

---

## 🎯 Verbesserungen gegenüber Alt-UI

| Feature | Alt-UI | Neu-UI |
|---------|--------|--------|
| **Player Preview** | Klein, schwer zu sehen | **Fullscreen, 50% des Bildschirms** |
| **Item Auswahl** | Kleine Boxen/Grid | **Große Listen mit Details** |
| **Navigation** | Unübersichtlich | **Klare Tabs + Kategorien** |
| **Größe** | 85vh (zu klein) | **100vh (Fullscreen)** |
| **Design** | Boxen/Kacheln | **Moderne Listen** |
| **Lesbarkeit** | Schwierig | **Groß & Klar** |
| **Bedienung** | Klicki-Bunti | **Professionell & Einfach** |

---

## 🚀 Wie es funktioniert

### Kleidung ändern:
1. Tab "Kleidung" auswählen
2. Item in der Liste suchen
3. Mit [<] [>] Buttons durchschalten
4. Live-Preview auf der linken Seite
5. "Änderungen speichern" klicken

### Outfit speichern:
1. Kleidung auswählen
2. Tab "Gespeicherte Outfits" öffnen
3. "Aktuelles Outfit speichern" klicken
4. Name eingeben
5. Fertig!

### Uniform anziehen:
1. Tab "Berufs-Uniformen" öffnen
2. Uniform auswählen
3. "Anziehen" klicken
4. Fertig!

---

## 📸 Visual Guide

### Item Card Struktur:
```
┌────────────────────────────────────────────────┐
│  [👕]  Unterhemd                    $25        │
│        Wähle dein Unterhemd                    │
│                    [<]  1 / 15  [>]            │
└────────────────────────────────────────────────┘
```

### Tab Navigation:
```
┌──────────────┬──────────────┬──────────────┐
│  👕 Kleidung │ 🔖 Outfits  │ 💼 Uniformen │
│   (ACTIVE)   │             │              │
└──────────────┴──────────────┴──────────────┘
```

---

## ✅ Alle Anforderungen erfüllt

✅ **Vollseite** - 100vh Fullscreen  
✅ **Listen-Design** - Keine Vierecke  
✅ **Großer Player** - 50% des Screens  
✅ **Spieler sichtbar** - Immer auf der linken Seite  
✅ **Professionell** - Moderne FiveM Standards  
✅ **Brauchbar** - Einfache Navigation  
✅ **GreenZone420** - Branded & Customizable  

---

## 🎓 FiveM Best Practices

✅ Dark Theme (RP Standard)  
✅ Minimale Animationen (Performance)  
✅ Klare Hierarchie  
✅ Sofortiges Feedback  
✅ Fullscreen Nutzung  
✅ Touch-friendly  

---

## 💡 Inspiriert von

- FiveM ESX Garage UI
- QB-Core Inventory System
- Modern Dashboard Designs
- Professional Admin Panels

---

**Made with 💚 for GreenZone420**
