// filepath: docs/COMPONENTS.md

# Component Design

<small>
Name: Szántó Orsolya
</small>

# 1.1 Documentation

## 1.1.3 Component Design

---

## Component Tree

The application is built in Flutter using a widget-based architecture, BLoC/Cubit state management, and Firebase backend integration.
The component tree below shows the main modules and their relationships.

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
│   │   │   ├── ProfileManagementScreen
│   │   │   └── AvailabilityManagementScreen
│   │   ├── Widgets
│   │   │   ├── AppointmentItem
│   │   │   ├── StatusUpdateDialog
│   │   │   ├── ServiceForm
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

## Modules / Screens

The table below presents the main screens and their components.

| Screen                  | Used components                                                                                                         |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Login                   | LoginScreen, AuthForm, AppTextField, AppButton, ErrorState                                                             |
| Registration            | RegisterScreen, AuthForm, AppTextField, AppButton                                                                      |
| Home                    | HomeScreen, SalonInfoCard                                                                                               |
| Service list            | ServiceListScreen, ServiceCard, ServiceSearchField, ServiceFilterBar, PriceSortDropdown, EmptyState, LoadingIndicator |
| Service details         | ServiceDetailScreen, AppButton                                                                                           |
| Booking creation        | BookingCreateScreen, CalendarWidget, TimeSlotSelector, AppTextField, AppButton                                         |
| My appointments         | BookingListScreen, BookingCard, BookingStatusChip                                                                      |
| Appointment details     | BookingDetailScreen, BookingStatusChip, ConfirmDialog                                                                    |
| Profile                 | ProfileScreen, AppTextField AppButton                                                                                   |
| Nail artist dashboard   | DashboardScreen                                                                                                          |
| Appointment management | AppointmentManagementScreen, AppointmentItem, StatusUpdateDialog                                                       |
| Service management      | ServiceManagementScreen, ServiceForm                                                                                     |
| Profile management      | ProfileManagementScreen                                                                                                  |
| Availability management | AvailabilityManagementScreen                                                                                             |
| Error / access          | ErrorState                                                                                                              |

---

## Navigation Logic

Application navigation is role-based.

### User flow

```text
Auth -> Home -> Services -> Service Details -> Booking -> My Appointments -> Appointment Details
```

### Nail artist flow

```text
Auth -> Dashboard -> (Appointments / Services / Profile / Availability)
```

### Navigation solution

* Router-based navigation (GoRouter or Navigator 2.0)
* AuthGuard: only authenticated users
* RoleGuard: role-based screens
* Bottom navigation for main screens
* Stack-based navigation for details screens

---

## Architecture

The application has a modular structure:

* **Core**: base services (auth, firestore, error handling)
* **Features**: domain-specific modules
* **Shared**: reusable UI components
* **Repository layer**: data management through Firebase

This architecture ensures:

* code clarity
* scalability
* testability
* a clean data flow

---

## Notes

* The booking system is based on service duration.
* Slot selection is handled dynamically according to the selected service.
* Notifications can be managed through NotificationService.
* Shared components ensure a consistent design system.

---
