// filepath: docs/DATAMODEL.md
# Data Model

<small>
Name: Szántó Orsolya  
</small>

# 1.1 Documentation

## 1.1.2 Data Model

---

## Entities

### User

| Field       | Description                              |
| ----------- | ---------------------------------------- |
| id          | unique identifier (Firebase UID)         |
| name        | user name                                |
| email       | user email address                       |
| role        | role (`user` or `nail_artist`)           |
| phoneNumber | phone number                             |
| createdAt   | creation time (timestamp)                |
| updatedAt   | last update time (timestamp)             |

---

### NailArtistProfile

| Field           | Description                             |
| --------------- | --------------------------------------- |
| id              | unique identifier                       |
| userId          | related user identifier                 |
| salonName       | salon name                              |
| address         | salon address                           |
| phoneNumber     | salon phone number                      |
| profileImageUrl | profile image                           |
| workingHours    | available days and time intervals       |
| createdAt       | creation time                           |
| updatedAt       | last modification time                  |

---

### Service

| Field               | Description                  |
| ------------------- | ---------------------------- |
| id                  | unique identifier            |
| nailArtistProfileId | related profile              |
| categoryId          | category identifier          |
| name                | service name                 |
| description         | description                  |
| price               | price                        |
| durationMinutes     | duration in minutes          |
| imageUrl            | image                        |
| isActive            | whether the service is bookable |
| createdAt           | creation time                |
| updatedAt           | last modification time       |

---

### Category

| Field    | Description                           |
| -------- | ------------------------------------- |
| id       | unique identifier                     |
| name     | category name                         |
| type     | category type (`service`)             |
| createdAt| creation time                         |

---

### Appointment

| Field                    | Description                                                                                                      |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| id                       | unique identifier                                                                                                |
| userId                   | booking user identifier                                                                                          |
| nailArtistProfileId      | nail artist profile                                                                                              |
| serviceId                | selected service                                                                                                 |
| appointmentDate          | date                                                                                                             |
| startTime                | start time                                                                                                       |
| requestedDurationMinutes | original duration                                                                                                 |
| estimatedDurationMinutes | modified duration (if any)                                                                                       |
| note                     | user note                                                                                                        |
| status                   | status (`pending`, `confirmed`, `modification_requested`, `cancel_requested`, `cancelled`, `rejected`)            |
| createdAt                | creation time                                                                                                    |
| updatedAt                | last modification time                                                                                           |

---

## Relationships

* **User 1 — N Appointment**
* **User 1 — 1 NailArtistProfile**
* **NailArtistProfile 1 — N Service**
* **NailArtistProfile 1 — N Appointment**
* **Service 1 — N Appointment**
* **Category 1 — N Service**

---

## Notes

* Each appointment always belongs to **one service**.
* Appointment duration is based on the service, but it can be modified by the nail artist.
* The `NailArtistProfile` is treated as a separate entity for salon-related data.
* Time-slot conflict handling is managed by backend logic (Firebase).
* Appointment status flows are managed as a workflow.

---

## Firestore collection structure

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
│       ├── type: "service"
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
```

---
