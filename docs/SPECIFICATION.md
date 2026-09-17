// filepath: docs/SPECIFICATION.md
# BookNails Mobile Application

**Mobile application development practice**
**Flutter + Firebase – Demo project**
**Spring 2026**

---

## 1. Introduction

**BookNails** is a Flutter and Firebase-based mobile application that supports the booking process between a nail artist and a salon. The app allows users to browse services, view the nail artist’s portfolio, and book appointments through a simple and intuitive mobile interface.

The project aims to implement a modern, well-structured, mobile-first application that demonstrates frontend and backend integration as well as multi-entity, role-based functionality.

### 1.1 Technology stack

* **Flutter** – Cross-platform mobile framework
* **Firebase** – Backend services
* **Firebase Authentication** – User management
* **Cloud Firestore** – Persistent data storage
* **Dart** – Application development language

---

## 2. Roles

### 2.1 Nail Artist

The nail artist has an admin-style role. Their permissions include:

* Managing their own profile (salon details, availability)
* Creating, editing, and deleting services
* Setting available days and time intervals
* Viewing appointments
* Approving or rejecting appointments
* Initiating duration change requests
* Managing appointment status

---

### 2.2 User

The user plays the guest role. Their permissions include:

* Registration and login
* Viewing nail artist profiles and salon information
* Browsing and searching services
* Selecting an available time slot
* Creating an appointment
* Adding a note to the appointment
* Viewing their own appointments
* Initiating a cancellation request (based on the 48-hour rule)
* Editing profile information (name, phone number)

---

## 3. Functional requirements

1. The user can register using an email and password.
2. The user can log in using Firebase Authentication.
3. The user can browse services.
4. The user can search for services and sort them by price.
5. The user can select a service.
6. The system only shows available time slots that match the selected service.
7. The user can book an appointment.
8. The appointment status is initially “pending”.
9. The nail artist can approve or reject the appointment.
10. The nail artist can initiate a modification request (duration change).
11. The user can initiate a cancellation request (minimum 48 hours in advance).
12. The user can view their own appointments and their status.
13. The nail artist can manage services (CRUD).
14. The nail artist can configure available time intervals.

---

## 4. Non-functional requirements

1. Secure login based on Firebase Authentication.
2. Role-based access (user vs nail artist).
3. Mobile-first, adaptive user interface.
4. Consistent design system (colors, typography, spacing).
5. Accessibility considerations (contrast, readability).
6. Loading and error state handling.
7. Fast data queries using Firestore.
8. Stable operation and error handling.

---

## 5. Mobile screens

### 5.1 Public screens

* **Login**
* **Registration**
* **Password reset** *(optional)*

---

### 5.2 User screens

* **Home** – salon presentation
* **Services** – service list
* **Service Details** – service details
* **Booking** – appointment booking (calendar + slot selection)
* **My Appointments** – own appointments
* **Appointment Details** – appointment details
* **Profile** – user data

---

### 5.3 Nail Artist screens

* **Dashboard** – overview
* **Appointments** – appointment management
* **Appointment Details**
* **Services Management** – services CRUD
* **Profile Management** – salon information
* **Availability Management** – time interval setup

---

## 6. Data model (brief overview)

Main entities of the application:

* **User**
* **NailArtistProfile**
* **Service**
* **Category**
* **Appointment**

### Relationships

* User Appointment (1:N)
* User -> NailArtistProfile (1:1)
* NailArtistProfile -> Service (1:N)
* NailArtistProfile -> Appointment (1:N)
* Service -> Appointment (1:N)
* Category -> Service (1:N)

---

## 7. Installation and running

The system operates on Firebase infrastructure; no separate backend server is required.

Required tools:

* Flutter SDK (stable)
* Dart SDK
* Android Studio
* Firebase CLI

---

## 8. Folder structure

| Folder / File     | Description                     |
| ----------------- | ------------------------------- |
| `/docs`           | Documentation                   |
| `/lib`            | Flutter application source code |
| `/lib/screens`    | Screens                         |
| `/lib/widgets`   | UI components                   |
| `/lib/services`  | Firebase services               |
| `/lib/models`    | Data models                     |
| `/lib/cubit`     | State management                |
| `/assets`        | Images                          |
| `README.md`      | Installation guide              |

---

## 9. Implementation plan

* **Phase 1:** Core features (auth, services, UI)
* **Phase 2:** Booking system and backend integration
* **Phase 3:** Refinement, testing, UX improvements

---
