# 🚀 BookNails Firestore Seed Utasítás

## GYORS START (3 lépésben)

### 1️⃣ Firebase Service Account Kulcs Letöltése

1. Nyisd meg: https://console.firebase.google.com/
2. Válaszd a **booknail** projektet
3. Klikk a **⚙️ Projekt beállításai** (jobb felül)
4. Menj a **Szolgáltatási fiók** fülre
5. Válaszd a **Firebase Admin SDK** fület
6. Klikk: **"Új privát kulcs generálása"**
7. A letöltött JSON fájlt nevezd át: **`firebase-key.json`**
8. Másold a projektmunka-orsiszanto mappába (a seed_firestore.js mellé)

```
📁 projektmunka-orsiszanto/
   ├── 📄 firebase-key.json          ← IDE kell a fájl!
   ├── 📄 seed_firestore.js
   ├── 📄 clear_firestore.js
   ├── 📄 package.json
   └── ...
```

### 2️⃣ Node.js Függőségek Telepítése

```bash
# Nyiss egy parancssor ablakot (PowerShell/CMD)
cd D:\projektmunka-orsiszanto

# Telepítsd a firebase-admin SDK-t
npm install
```

**Várt output:**
```
added 100+ packages in 15s
```

### 3️⃣ Seed Adatok Feltöltése

```bash
# Futtasd a seed scriptet
npm run seed
```

**Várt output:**
```
🌱 BookNails Firestore seed adatok feltöltése...

📁 Kategóriák létrehozása...
  ✅ French Manicure (ID: abc123...)
  ✅ Gel Manicure (ID: def456...)
  ...

👩‍💼 Nail Artist feltöltése...
  ✅ User: Hajnalka Kozmetikus
  ✅ Profile: Luxe Nail Studio Budapest (ID: xyz789...)

👥 Rendszeres felhasználók feltöltése...
  ✅ Kiss Katalin (katalin.demo@example.com)
  ...

✅ Firestore seed adatok sikeresen feltöltve!

📊 ÖSSZEFOGLALÁS:
  ✨ Kategóriák: 5
  💅 Nail Artist: 1
  👥 Rendszeres felhasználók: 3
  💼 Szolgáltatások: 5
  📅 Foglalások: 4
  🖼️  Galéria tételek: 4
```

## ✅ Ellenőrzés

1. Nyisd meg a Firebase Console-t: https://console.firebase.google.com/
2. Válaszd a **booknail** projektet
3. Menj az **Firestore Database** szekciójába
4. Az alábbi kollekciók jelenjenek meg:
   - ✅ `users`
   - ✅ `nail_artist_profiles`
   - ✅ `categories`
   - ✅ `services`
   - ✅ `appointments`
   - ✅ `gallery_items`

## 🎮 Tesztelés az App-ban

1. Indítsd el a Flutter appot: `flutter run`
2. A login screenen: **5x klikk** a "BookNails" logóra
3. Debug menü megjelenik
4. Válaszd: **"🌱 Seed Firestore-t"**
5. A Dart service ugyanezt az adatot tölti fel

## 🗑️ Adatok Törlése (ha szükséges)

```bash
npm run seed:clear
```

```
⚠️  Biztosan szeretnéd ÖSSZES adatot törölni a Firestore-ból? (igen/nem): igen

🗑️  Összes adat törlése...

  Törlés: categories (5 dokumentum)...
  ✅ categories törölve!
  ...

✅ Összes adat sikeresen törölve!
```

## 🐛 Hibaelhárítás

### ❌ "firebase-key.json nem található!"

**Megoldás:**
1. Ellenőrizd, hogy letöltötted-e a Firebase Service Account kulcsot
2. A fájl az `D:\projektmunka-orsiszanto` könyvtárban kell lennie
3. Ellenőrizd az elnevezést: `firebase-key.json` (pontosan így!)

### ❌ "npm: a parancs nem ismert"

**Megoldás:**
1. Telepítsd a Node.js-t: https://nodejs.org/ (v14+)
2. Indítsd újra a parancssor ablakot
3. Próbáld újra: `npm install`

### ❌ "Permission denied" hiba

**Megoldás:**
1. Firebase Console > Projekt beállítások
2. Menj az **Adatbázis** szekciójára
3. Kattints a **Firestore Database** sorra
4. Válaszd az **Szabályok** fület
5. Cseréld ki ezt kódra (teszt módhoz):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

6. Tedd közzé: **"Közzéteszik"**
7. Próbáld újra a seed scriptet

## 📱 Flutter App Debug Menu

A `lib/screens/auth/login_screen.dart` fájlban van egy rejtett debug menü:

**Aktiválás:**
1. A login screenen **5x gyors klik** a "BookNails" szövegre
2. Megjelenik a debug menü
3. Gombos opcók:
   - 🌱 **Seed Firestore-t** - Seed adatok feltöltése az app-ból
   - 🗑️ **Összes adat törlése** - Megerősítéssel

## 📊 Seed Adatok Tartalmassága

### Kategóriák (5)
- French Manicure
- Gel Manicure
- Pedicure
- Nail Art
- Akril Körmök

### Nail Artist Profil (1)
- **Név:** Hajnalka Kozmetikus
- **Szalon:** Luxe Nail Studio Budapest
- **Cím:** 1051 Budapest, Nádor utca 12.
- **Telefo:** +36 1 266 5678
- **Napi órarendszer:** H-P 9-18 / Cs-P 9-20 / Szo 10-16
- **Értékelés:** 4.8 / 5 csillag

### Szolgáltatások (5)
| Név | Ár | Időtartam |
|-----|-----|----------|
| French Manicure | 8.500 Ft | 60 perc |
| Gel Manicure | 7.500 Ft | 50 perc |
| Pedicure | 9.500 Ft | 90 perc |
| Nail Art | 12.000 Ft | 120 perc |
| Akril Körmök | 10.000 Ft | 90 perc |

### Felhasználók (3 + 1 Nail Artist)
- 👩‍💼 `hajnalka@nails.com` - Nail Artist
- 👩 `katalin.demo@example.com` - Ügyfél 1
- 👩 `eva.demo@example.com` - Ügyfél 2
- 👩 `krisztina.demo@example.com` - Ügyfél 3

### Foglalások (4)
- Status: `pending` (2x)
- Status: `confirmed` (1x)
- Status: `completed` (1x)

### Galéria (4 tétel)
- Ombre French Nails
- Spring Collection Nails
- Sparkly Gel Design
- Luxury Acrylic Set

## 🔐 Biztonsági Megjegyzések

⚠️ **SOHA NE commiteld a `firebase-key.json` fájlt a Git-be!**

Az `.gitignore` már tartalmazza:
```
firebase-key.json
*-key.json
```

De mindig ellenőrizd az `npm run` előtt, hogy a fájl nem jelenik-e meg a staged changes-ben.

## 📝 Egyéni Seed Script Létrehozása

Ha egyéni adatokat szeretnél feltölteni:

1. Másold a `seed_firestore.js` fájlt, pl.: `seed_custom.js`
2. Módosítsd az adatokat az igényednek megfelelően
3. Futtasd: `node seed_custom.js`

```javascript
// seed_custom.js
const admin = require('firebase-admin');
// ... rest of code ...

// Futtasd: node seed_custom.js
```

## 🤝 Segítség

- Firebase Dokumentáció: https://firebase.google.com/docs
- Firestore Dokumentáció: https://firebase.google.com/docs/firestore
- Node.js Firebase Admin SDK: https://firebase.google.com/docs/admin/setup

---

✅ Kész vagy! Az összes adatod feltöltve van a Firestore-ba! 🎉

