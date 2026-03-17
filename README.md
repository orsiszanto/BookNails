[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/JoHdmBvg)
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/Ew36zBjj)
# Mobil alkalmazásfejlesztés — Projektmunka

> **Hallgató neve:** _[Írd ide a neved]_  
> **Neptun kód:** _[Írd ide a Neptun kódod]_  
> **Projekt téma:** _[Írd ide a választott témát]_  
> **Keretrendszer:** _[Írd ide a választott keretrendszert, pl. Flutter, React Native, SwiftUI, Kotlin Compose]_

---

## 🚀 A projekt indítása (lokális futtatás)

### Előfeltételek

> _[Sorold fel a szükséges eszközöket, pl. Flutter SDK, Android Studio, Xcode, Node.js stb.]_

### Telepítés és futtatás

```bash
git clone <repo-url>
cd <projekt-mappa>

# Flutter esetén:
flutter pub get
flutter run

# React Native esetén:
npm install
npx react-native run-android   # vagy: npx react-native run-ios
```

---

## 📱 Letöltés / Telepítés

> _[Írd ide a letölthető APK/IPA fájl elérhetőségét, vagy a tesztelési csatorna linkjét, pl. Firebase App Distribution, TestFlight, GitHub Releases]_

---

## 📁 Projekt struktúra

```
├── docs/                    # Dokumentáció
│   ├── SPECIFICATION.md     # Funkcionális és nem-funkcionális követelmények
│   ├── DATAMODEL.md         # Adatmodell (entitások, kapcsolatok)
│   ├── COMPONENTS.md        # Komponens-terv (widget-fa / navigációs gráf)
│   └── AI_PROMPT_LOG.md     # AI prompt napló
├── lib/                     # Forráskód (Flutter)
│   └── ...
├── android/                 # Android platform-specifikus fájlok
├── ios/                     # iOS platform-specifikus fájlok
├── test/                    # Unit tesztek
├── integration_test/        # Integrációs / E2E tesztek
└── .github/workflows/       # Automatikus értékelés (ne módosítsd!)
```

> _Megjegyzés: A fenti struktúra Flutter projektre példa. React Native, SwiftUI vagy Kotlin Compose esetén a mappastruktúra eltérhet — igazítsd a saját projektedhez._

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
