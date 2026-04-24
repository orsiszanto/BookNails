[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/JoHdmBvg)
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/Ew36zBjj)
# Mobil alkalmazásfejlesztés — Projektmunka

> **Hallgató neve:** _Szántó Orsolya_  
> **Neptun kód:** _H93NV2_  
> **Projekt téma:** _BookNails Mobilalkalmazás_  
> **Keretrendszer:** _Flutter Firebase_

---

## 🚀 A projekt indítása (lokális futtatás)

### Előfeltételek

- Flutter SDK (stable)
- Dart SDK
- Android Studio (Android SDK + emulator)

### Telepítés és futtatás

```bash
git clone <repo-url>
cd <projekt-mappa>

# Függőségek telepítése
flutter pub get

# Futtatás Androidon
flutter run

# Futtatás konkrét eszközön
flutter devices
flutter run -d <device-id>
```

---

## 📱 Letöltés / Telepítés

> _[Írd ide a letölthető APK fájl elérhetőségét, vagy a tesztelési csatorna linkjét, pl. Firebase App Distribution, GitHub Releases]_

---

## 📁 Projekt struktúra

```
├── docs/                    # Dokumentáció
│   ├── SPECIFICATION.md     # Funkcionális és nem-funkcionális követelmények
│   ├── DATAMODEL.md         # Adatmodell (entitások, kapcsolatok)
│   ├── COMPONENTS.md        # Komponens-terv (widget-fa / navigációs gráf)
│   └── AI_PROMPT_LOG.md     # AI prompt napló
├── lib/                     # Forráskód (Flutter)
│   └── main.dart
├── android/                 # Android platform-specifikus fájlok
├── test/                    # Unit tesztek
├── integration_test/        # Integrációs / E2E tesztek
└── .github/workflows/       # Automatikus értékelés (ne módosítsd!)
```

> _Megjegyzés: A fenti struktúra Flutter projektre példa. A saját projektedhez igazíthatod (pl. további mappák: assets/, lib/screens/, lib/widgets/)._

---

## 📅 Mérföldkövek

| # | Tartalom | Határidő | Állapot |
|---|----------|----------|---------|
| 1 | Specifikáció, UI és megjelenés | 2026.03.29. 23:59 | ⬜ |
| 2 | Backend és adatok | 2026.04.26. 23:59 | ⬜ |
| 3 | Biztonság és tesztelés | 2026.05.10. 23:59 | ⬜ |

### Hogyan kérd az értékelést?

1. Commitold és push-old a munkádat a `main` vagy `master` branch-re
2. Menj a repód **Actions** fülére
3. Válaszd a **"Mérföldkő értékelés"** workflow-t
4. Kattints a **"Run workflow"** → válaszd ki a mérföldkövet → **"Run workflow"**
5. Az eredmény egy **GitHub Issue**-ban jelenik meg

> ⚠️ Mérföldkőnként **maximum 2 alkalommal** futtathatod az értékelést. Használd bölcsen!
> ⚠️ A határidőkön automatikus értékelés is fut.

---

## ⚠️ Fontos

- A `.github/workflows/` könyvtár tartalmát **ne módosítsd**!
- A `docs/` mappába rakd a dokumentációs fájlokat.
- Az `AI_PROMPT_LOG.md` fájlt a `docs/` mappában vezesd.
