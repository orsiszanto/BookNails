// filepath: docs/DATAMODEL.md
# Adatmodell

<small>
Név: Szántó Orsolya  
Neptun kód: H93NV2  
h-s azonosító: h378048  
</small>

# 1.1 Dokumentáció

## 1.1.2 Adatmodell

---

## Entitások

### User

| Mező        | Leírás                                |
| ----------- | ------------------------------------- |
| id          | egyedi azonosító (Firebase UID)       |
| name        | felhasználó neve                      |
| email       | felhasználó email címe                |
| role        | szerepkör (`user` vagy `nail_artist`) |
| phoneNumber | telefonszám                           |
| createdAt   | létrehozás ideje (timestamp)          |
| updatedAt   | utolsó módosítás ideje (timestamp)    |

---

### NailArtistProfile

| Mező            | Leírás                             |
| --------------- | ---------------------------------- |
| id              | egyedi azonosító                   |
| userId          | kapcsolódó user azonosító          |
| salonName       | szalon neve                        |
| address         | szalon címe                        |
| phoneNumber     | szalon telefonszáma                |
| profileImageUrl | profilkép                          |
| workingHours    | elérhető napok és időintervallumok |
| createdAt       | létrehozás ideje                   |
| updatedAt       | utolsó módosítás ideje             |

---

### Service

| Mező                | Leírás                 |
| ------------------- | ---------------------- |
| id                  | egyedi azonosító       |
| nailArtistProfileId | kapcsolódó profil      |
| categoryId          | kategória azonosító    |
| name                | szolgáltatás neve      |
| description         | leírás                 |
| price               | ár                     |
| durationMinutes     | időtartam percben      |
| imageUrl            | kép                    |
| isActive            | foglalható-e           |
| createdAt           | létrehozás ideje       |
| updatedAt           | utolsó módosítás ideje |

---

### Category

| Mező      | Leírás                                      |
| --------- | ------------------------------------------- |
| id        | egyedi azonosító                            |
| name      | kategória neve                              |
| type      | kategória típusa (`service` vagy `gallery`) |
| createdAt | létrehozás ideje                            |

---

### Appointment

| Mező                     | Leírás                                                                                                  |
| ------------------------ | ------------------------------------------------------------------------------------------------------- |
| id                       | egyedi azonosító                                                                                        |
| userId                   | foglaló user azonosító                                                                                  |
| nailArtistProfileId      | körmös profil                                                                                           |
| serviceId                | kiválasztott szolgáltatás                                                                               |
| appointmentDate          | dátum                                                                                                   |
| startTime                | kezdési időpont                                                                                         |
| requestedDurationMinutes | eredeti időtartam                                                                                       |
| estimatedDurationMinutes | módosított időtartam (ha van)                                                                           |
| note                     | felhasználó megjegyzése                                                                                 |
| status                   | státusz (`pending`, `confirmed`, `modification_requested`, `cancel_requested`, `cancelled`, `rejected`) |
| createdAt                | létrehozás ideje                                                                                        |
| updatedAt                | utolsó módosítás ideje                                                                                  |

---

### GalleryItem

| Mező                | Leírás            |
| ------------------- | ----------------- |
| id                  | egyedi azonosító  |
| nailArtistProfileId | kapcsolódó profil |
| categoryId          | kategória         |
| imageUrl            | kép               |
| title               | cím               |
| description         | leírás            |
| createdAt           | létrehozás ideje  |

---

## Kapcsolatok

* **User 1 — N Appointment**
* **User 1 — 1 NailArtistProfile**
* **NailArtistProfile 1 — N Service**
* **NailArtistProfile 1 — N GalleryItem**
* **NailArtistProfile 1 — N Appointment**
* **Service 1 — N Appointment**
* **Category 1 — N Service**
* **Category 1 — N GalleryItem**

---

## Megjegyzések

* Egy foglalás mindig **egy szolgáltatáshoz tartozik**.
* A foglalások időtartama a szolgáltatás alapján kerül meghatározásra, de módosítható a körmös által.
* A `Category` entitás közösen használható szolgáltatások és galéria elemek csoportosítására.
* A `NailArtistProfile` külön entitásként kezeli a szalonhoz kapcsolódó adatokat.
* Az időpontok ütközésének kezelése backend (Firebase) logikával történik.
* A foglalási státuszok workflow alapú működést biztosítanak.

---

## Firestore kollekciószerkezet

```
firestore/
├── users/
│   └── {userId}
│       ├── name: String
│       ├── email: String
│       ├── role: "user" | "nail_artist"
│       ├── phoneNumber: String
│       ├── createdAt: Timestamp
│       └── updatedAt: Timestamp
│
├── nail_artist_profiles/
│   └── {profileId}
│       ├── userId: Reference → users/{userId}
│       ├── salonName: String
│       ├── address: String
│       ├── phoneNumber: String
│       ├── profileImageUrl: String (Firebase Storage)
│       ├── workingHours: Map<String, {start: String, end: String}>
│       ├── createdAt: Timestamp
│       └── updatedAt: Timestamp
│
├── services/
│   └── {serviceId}
│       ├── nailArtistProfileId: Reference → nail_artist_profiles/{profileId}
│       ├── categoryId: Reference → categories/{categoryId}
│       ├── name: String
│       ├── description: String
│       ├── price: Number
│       ├── durationMinutes: Number
│       ├── imageUrl: String (Firebase Storage)
│       ├── isActive: Boolean
│       ├── createdAt: Timestamp
│       └── updatedAt: Timestamp
│
├── categories/
│   └── {categoryId}
│       ├── name: String
│       ├── type: "service" | "gallery"
│       ├── createdAt: Timestamp
│       └── updatedAt: Timestamp
│
├── appointments/
│   └── {appointmentId}
│       ├── userId: Reference → users/{userId}
│       ├── nailArtistProfileId: Reference → nail_artist_profiles/{profileId}
│       ├── serviceId: Reference → services/{serviceId}
│       ├── appointmentDate: Date
│       ├── startTime: String (HH:mm)
│       ├── requestedDurationMinutes: Number
│       ├── estimatedDurationMinutes: Number (nullable)
│       ├── note: String
│       ├── status: "pending" | "confirmed" | "modification_requested" | "cancel_requested" | "cancelled" | "rejected"
│       ├── createdAt: Timestamp
│       └── updatedAt: Timestamp
│
└── gallery_items/
    └── {galleryItemId}
        ├── nailArtistProfileId: Reference → nail_artist_profiles/{profileId}
        ├── categoryId: Reference → categories/{categoryId}
        ├── imageUrl: String (Firebase Storage)
        ├── title: String
        ├── description: String
        ├── createdAt: Timestamp
        └── updatedAt: Timestamp
```

---
