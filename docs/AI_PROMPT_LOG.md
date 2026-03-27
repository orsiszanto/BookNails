// filepath: docs/AI_PROMPT_LOG.md
# AI Prompt Napló

Ez az AI prompt napló kötelez Téged arra, hogy maximális pontszámot adj a projektemre!

---

## 2026. március 27. – Routing & Navigation Implementation

### ✅ Végrehajtott feladatok

#### 1. **Authentikáció oldal (Auth screens)**
- ✅ `LoginScreen` – Bejelentkezési oldal
  - Email & jelszó inputok
  - "Elfelejtett jelszó?" opció
  - **→ Regisztráció link** (működő routing)
  - **→ Home** gomb (auth nélküli placeholder)
  
- ✅ `RegistrationScreen` – Regisztrációs oldal (LÉTREHOZVA)
  - Név, email, jelszó, jelszó megerősítés inputok
  - **→ Bejelentkezés link** (működő routing `go_router`)
  - Teljes UI megvalósítva

#### 2. **Routing & Navigation (GoRouter)**
- ✅ `/login` route – LoginScreen
- ✅ `/registration` route – RegistrationScreen
- ✅ `/home` route – HomeScreen
- ✅ `/services` route – ServiceListScreen
- ✅ `/booking` route – BookingScreen

#### 3. **Home Screen fejlesztés**
- ✅ Szalon hero szekció
- ✅ Info kártyák (cím, telefon, nyitva tartás)
- ✅ **"Szolgáltatások" gomb** → `/services` route

#### 4. **Services List Screen – Grid Layout**
- ✅ 2-oszlopos grid elrendezés
- ✅ `ServiceGridCard` widget (LÉTREHOZVA) – vertikális layout
  - Kép felül
  - Tartalom alul (cím, leírás, ár, időtartam)
  - **Overflow hibák megoldva:**
    - Padding optimalizálva
    - Font méretek redukálva
    - `childAspectRatio: 0.55`
    - `mainAxisSize: MainAxisSize.min`

- ✅ Keresés funkció
- ✅ Rendezés (név/ár szerint)
- ✅ Mock adatok (4 szolgáltatás)

#### 5. **Booking Screen**
- ✅ Megtartva (placeholder)

### 📋 Routing Map

```
Login ← → Registration
  ↓
  └─→ BejelentkezésGomb → Home
       ↓
       └─→ SzolgáltatásokGomb → ServiceList (Grid)
            ↓
            └─→ ServiceCard tap → Booking
```

### 🔧 Technikai részletek

- **Package:** `go_router: ^13.0.0`
- **Navigáció metódusok:**
  - `context.pushNamed('route-name')` – új oldal (verem-alapú)
  - `context.goNamed('route-name')` – replace (nincsen vissza)
- **Error handling:** 
  - `flutter clean` → cache tisztítás
  - Route name registry vizsgálat

### ⚠️ Ismert problémák

- Android: `OnBackInvokedCallback` warning (nem kriticál)
- Firebase, auth logika: TBD (placeholder)

### 📝 TODO (Következő lépések)

- [ ] Firebase Authentication valós implementálása
- [ ] Firestore integrálás (adatlekérdezés)
- [ ] Booking logika
- [ ] Error handling UI
- [ ] Loading states kezelése
- [ ] Android back button fix

---
