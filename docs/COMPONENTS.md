// filepath: docs/COMPONENTS.md

# Komponens-terv

<small>
Név: Szántó Orsolya
</small>

# 1.1 Dokumentáció

## 1.1.3 Komponens-terv

---

## Komponensfa

Az alkalmazás Flutterben, widget-alapú architektúrával készül, BLoC/Cubit állapotkezeléssel és Firebase backend integrációval.
Az alábbi komponensfa a fő modulok és azok kapcsolatát mutatja.

```text
App (main.dart)
│
├── MyApp
│   ├── MaterialApp.router
│   ├── AppRouter (GoRouter / Navigator)
│   └── ThemeData
│
├── Core
│   ├── AuthGuard
│   ├── RoleGuard
│   ├── FirebaseAuthService
│   ├── FirestoreService
│   ├── StorageService
│   └── ErrorHandler
│
├── Features
│   │
│   ├── Auth
│   │   ├── Screens
│   │   │   ├── LoginScreen
│   │   │   ├── RegisterScreen
│   │   │   └── ForgotPasswordScreen (optional)
│   │   ├── Widgets
│   │   │   └── AuthForm
│   │   └── DataAccess
│   │       └── AuthRepository
│   │
│   ├── Home
│   │   ├── Screens
│   │   │   └── HomeScreen
│   │   └── Widgets
│   │       └── SalonInfoCard
│   │
│   ├── Services
│   │   ├── Screens
│   │   │   ├── ServiceListScreen
│   │   │   └── ServiceDetailScreen
│   │   ├── Widgets
│   │   │   ├── ServiceCard
│   │   │   ├── ServiceSearchField
│   │   │   ├── ServiceFilterBar
│   │   │   └── PriceSortDropdown
│   │   └── DataAccess
│   │       └── ServiceRepository
│   │
│   ├── Booking
│   │   ├── Screens
│   │   │   ├── BookingCreateScreen
│   │   │   ├── BookingListScreen
│   │   │   └── BookingDetailScreen
│   │   ├── Widgets
│   │   │   ├── CalendarWidget
│   │   │   ├── TimeSlotSelector
│   │   │   ├── BookingCard
│   │   │   └── BookingStatusChip
│   │   └── DataAccess
│   │       └── BookingRepository
│   │
│   ├── Gallery
│   │   ├── Screens
│   │   │   └── GalleryScreen
│   │   ├── Widgets
│   │   │   ├── GalleryGrid
│   │   │   └── GalleryItemCard
│   │   └── DataAccess
│   │       └── GalleryRepository
│   │
│   ├── Profile
│   │   ├── Screens
│   │   │   └── ProfileScreen
│   │   └── DataAccess
│   │       └── UserRepository
│   │
│   ├── NailArtist
│   │   ├── Screens
│   │   │   ├── DashboardScreen
│   │   │   ├── AppointmentManagementScreen
│   │   │   ├── ServiceManagementScreen
│   │   │   ├── GalleryManagementScreen
│   │   │   ├── ProfileManagementScreen
│   │   │   └── AvailabilityManagementScreen
│   │   ├── Widgets
│   │   │   ├── AppointmentItem
│   │   │   ├── StatusUpdateDialog
│   │   │   ├── ServiceForm
│   │   │   └── GalleryUploadWidget
│   │   └── DataAccess
│   │       └── NailArtistRepository
│   │
│   └── Notifications
│       ├── Services
│       │   └── NotificationService
│       └── Widgets
│           └── NotificationBanner
│
└── Shared
    ├── Widgets
    │   ├── AppButton
    │   ├── AppTextField
    │   ├── AppScaffold
    │   ├── LoadingIndicator
    │   ├── EmptyState
    │   ├── ErrorState
    │   └── ConfirmDialog
    │
    ├── Theme
    │   ├── AppColors
    │   ├── AppTextStyles
    │   └── AppSpacing
    │
    ├── Utils
    └── Constants
```

---

## Modulok / képernyők

Az alábbi táblázat bemutatja a fő képernyőket és azok komponenseit.

| Képernyő                | Használt komponensek                                                                                                  |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Bejelentkezés           | LoginScreen, AuthForm, AppTextField, AppButton, ErrorState                                                            |
| Regisztráció            | RegisterScreen, AuthForm, AppTextField, AppButton                                                                     |
| Home                    | HomeScreen, SalonInfoCard                                                                                             |
| Szolgáltatáslista       | ServiceListScreen, ServiceCard, ServiceSearchField, ServiceFilterBar, PriceSortDropdown, EmptyState, LoadingIndicator |
| Szolgáltatás részletek  | ServiceDetailScreen, AppButton                                                                                        |
| Foglalás létrehozása    | BookingCreateScreen, CalendarWidget, TimeSlotSelector, AppTextField, AppButton                                        |
| Saját foglalások        | BookingListScreen, BookingCard, BookingStatusChip                                                                     |
| Foglalás részletek      | BookingDetailScreen, BookingStatusChip, ConfirmDialog                                                                 |
| Galéria                 | GalleryScreen, GalleryGrid, GalleryItemCard                                                                           |
| Profil                  | ProfileScreen, AppTextField, AppButton                                                                                |
| Nail artist dashboard   | DashboardScreen                                                                                                       |
| Foglalások kezelése     | AppointmentManagementScreen, AppointmentItem, StatusUpdateDialog                                                      |
| Szolgáltatások kezelése | ServiceManagementScreen, ServiceForm                                                                                  |
| Galéria kezelése        | GalleryManagementScreen, GalleryUploadWidget                                                                          |
| Profil kezelése         | ProfileManagementScreen                                                                                               |
| Elérhetőség kezelése    | AvailabilityManagementScreen                                                                                          |
| Hiba / jogosultság      | ErrorState                                                                                                            |

---

## Navigációs logika

Az alkalmazás navigációja szerepkör alapú.

### User flow

```text
Auth -> Home -> Services -> Service Details -> Booking -> My Appointments -> Appointment Details
```

### Nail artist flow

```text
Auth -> Dashboard -> (Appointments / Services / Gallery / Profile / Availability)
```

### Navigációs megoldás

* Router alapú navigáció (GoRouter vagy Navigator 2.0)
* AuthGuard: csak bejelentkezett felhasználók
* RoleGuard: role alapú képernyők
* Bottom navigation a fő képernyők között
* Stack alapú navigáció részletekhez

---

## Architektúra

Az alkalmazás moduláris felépítésű:

* **Core**: alap szolgáltatások (auth, firestore, error handling)
* **Features**: domain specifikus modulok
* **Shared**: újrahasznosítható UI komponensek
* **Repository layer**: adatkezelés Firebase-en keresztül

Ez az architektúra biztosítja:

* a kód átláthatóságát
* a skálázhatóságot
* a tesztelhetőséget
* a tiszta adatfolyamot

---

## Megjegyzések

* A foglalási rendszer a szolgáltatás időtartamára épül.
* A slot kiválasztás dinamikusan történik a kiválasztott szolgáltatás alapján.
* Az értesítések NotificationService segítségével kezelhetők.
* A Shared komponensek biztosítják az egységes design rendszert.

---
