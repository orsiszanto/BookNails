// filepath: docs/SPECIFICATION.md
# BookNails Mobilalkalmazás

**Mobil alkalmazásfejlesztés gyakorlat**
**Flutter + Firebase – Demonstrációs projekt**
**2026. tavasz**

---

## 1. Bevezetés

A **BookNails** egy Flutter és Firebase alapú mobilalkalmazás, amely egy körmös és egy szalon időpontfoglalási folyamatát támogatja. Az alkalmazás lehetővé teszi a felhasználók számára a szolgáltatások megtekintését, a körmös portfóliójának böngészését, valamint időpont foglalását egy egyszerű és intuitív mobilos felületen keresztül.

A projekt célja egy modern, jól strukturált, mobil-first szemléletű alkalmazás megvalósítása, amely demonstrálja a frontend és backend integrációját, valamint a több entitásos, szerepkör-alapú működést.

### 1.1 Technológiai stack

* **Flutter** – Keresztplatformos mobil keretrendszer
* **Firebase** – Backend szolgáltatások
* **Firebase Authentication** – Felhasználókezelés
* **Cloud Firestore** – Perzisztens adattárolás
* **Firebase Storage** – Képek tárolása
* **Dart** – Alkalmazásfejlesztési nyelv

---

## 2. Szerepkörök

### 2.1 Nail Artist

A nail artist (körmös) admin jellegű szerepkörrel rendelkezik. Jogosultságai:

* Saját profil kezelése (szalon adatok, elérhetőség)
* Szolgáltatások létrehozása, módosítása és törlése
* Galéria képek feltöltése és kezelése
* Elérhető napok és időintervallumok beállítása
* Foglalások megtekintése
* Foglalások jóváhagyása vagy elutasítása
* Időtartam módosítási kérés indítása
* Foglalások státuszának kezelése

---

### 2.2 User

A user a vendég szerepkört tölti be. Jogosultságai:

* Regisztráció és bejelentkezés
* Körmös profil és szalon adatok megtekintése
* Szolgáltatások böngészése és keresése
* Galéria megtekintése
* Szabad időpont kiválasztása
* Foglalás létrehozása
* Megjegyzés hozzáadása a foglaláshoz
* Saját foglalások megtekintése
* Lemondási kérelem indítása (48 órás szabály alapján)
* Profiladatok szerkesztése (név, telefonszám)

---

## 3. Funkcionális követelmények

1. A felhasználó regisztrálhat e-mail és jelszó megadásával.
2. A felhasználó bejelentkezhet Firebase Authentication segítségével.
3. A felhasználó böngészheti a szolgáltatásokat.
4. A felhasználó kereshet szolgáltatásokat és rendezheti azokat ár szerint.
5. A felhasználó megtekintheti a körmös galériáját.
6. A felhasználó kiválaszthat egy szolgáltatást.
7. A rendszer csak a szolgáltatáshoz megfelelő szabad időpontokat jeleníti meg.
8. A felhasználó időpontot foglalhat.
9. A foglalás állapota kezdetben „pending”.
10. A körmös jóváhagyhatja vagy elutasíthatja a foglalást.
11. A körmös módosítási kérést indíthat (időtartam változtatás).
12. A felhasználó lemondási kérelmet indíthat (minimum 48 órával előtte).
13. A felhasználó megtekintheti saját foglalásait és azok státuszát.
14. A körmös kezelheti a szolgáltatásokat (CRUD).
15. A körmös kezelheti a galériát (CRUD).
16. A körmös beállíthatja az elérhető időintervallumokat.

---

## 4. Nem-funkcionális követelmények

1. Firebase Authentication alapú biztonságos bejelentkezés.
2. Role-based hozzáférés (user vs nail artist).
3. Mobil-first, adaptív felhasználói felület.
4. Egységes design rendszer (színek, tipográfia, spacing).
5. Accessibility szempontok figyelembevétele (kontraszt, olvashatóság).
6. Loading és error state-ek kezelése.
7. Gyors adatlekérdezés Firestore használatával.
8. Képek tárolása Firebase Storage-ben.
9. Stabil működés és hibakezelés.

---

## 5. Mobil képernyők

### 5.1 Nyilvános képernyők

* **Bejelentkezés**
* **Regisztráció**
* **Jelszó visszaállítás** *(opcionális)*

---

### 5.2 User képernyők

* **Home** – Szalon bemutatása
* **Services** – Szolgáltatások listája
* **Service Details** – Szolgáltatás részletei
* **Booking** – Időpontfoglalás (naptár + slot választás)
* **My Appointments** – Saját foglalások
* **Appointment Details** – Foglalás részletei
* **Gallery** – Körmös portfólió
* **Profile** – Felhasználói adatok

---

### 5.3 Nail Artist képernyők

* **Dashboard** – Áttekintés
* **Appointments** – Foglalások kezelése
* **Appointment Details**
* **Services Management** – Szolgáltatások CRUD
* **Gallery Management** – Képek kezelése
* **Profile Management** – Szalon adatok
* **Availability Management** – Időintervallumok beállítása

---

## 6. Adatmodell (rövid áttekintés)

Az alkalmazás fő entitásai:

* **User**
* **NailArtistProfile**
* **Service**
* **Category**
* **Appointment**
* **GalleryItem**

### Kapcsolatok

* User Appointment (1:N)
* User -> NailArtistProfile (1:1)
* NailArtistProfile -> Service (1:N)
* NailArtistProfile -> GalleryItem (1:N)
* NailArtistProfile -> Appointment (1:N)
* Service -> Appointment (1:N)
* Category -> Service (1:N)
* Category -> GalleryItem (1:N)

---

## 7. Telepítés és futtatás

A rendszer Firebase alapokon működik, külön backend szerver nem szükséges.

Szükséges eszközök:

* Flutter SDK (stable)
* Dart SDK
* Android Studio
* Firebase CLI

---

## 8. Mappaszerkezet

| Mappa / Fájl    | Leírás                       |
| --------------- | ---------------------------- |
| `/docs`         | Dokumentáció                 |
| `/lib`          | Flutter alkalmazás forráskód |
| `/lib/screens`  | Képernyők                    |
| `/lib/widgets`  | UI komponensek               |
| `/lib/services` | Firebase szolgáltatások      |
| `/lib/models`   | Adatmodellek                 |
| `/lib/cubit`    | Állapotkezelés               |
| `/assets`       | Képek                        |
| `README.md`     | Telepítési útmutató          |

---

## 9. Megvalósítási terv

* **Fázis 1:** Alap funkciók (auth, services, UI)
* **Fázis 2:** Foglalási rendszer és backend integráció
* **Fázis 3:** Finomítás, tesztelés, UX javítások

---
