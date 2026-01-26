# Epidexa Server - Database Structure

**Database**: PostgreSQL
**ORM/Framework**: Serverpod
**Primary Key Strategy**: UUID v7 (time-based sortable UUIDs)
**Encryption**: Sensitive fields stored as encrypted keys (encryptionKey, descriptionKey patterns)

---

## Entity Relationship Diagram

```
┌──────────────┐
│   app_user   │
└──────┬───────┘
       │
       ├──────────────────┬──────────────────┬──────────────────┬──────────────────┐
       │                  │                  │                  │                  │
       ▼                  ▼                  ▼                  ▼                  ▼
┌─────────────┐   ┌──────────────┐   ┌───────────┐   ┌──────────────┐   ┌────────────┐
│   doctor    │   │ symptom_check│   │  consent   │   │  audit_log   │   │  payment   │
└──────┬──────┘   └──────┬───────┘   └────────────┘   └──────────────┘   └──────┬─────┘
       │                  │                                                      │
       │                  ├──────────────────┐                                   │
       │                  │                  │                                   │
       │                  ▼                  ▼                                   │
       │          ┌──────────────┐   ┌─────────────┐                             │
       │          │    image     │   │recommendation│                             │
       │          └──────────────┘   └─────────────┘                             │
       │                                                                         │
       ├──────────────────┐                                                      │
       │                  │                                                      │
       ▼                  ▼                                                      │
┌──────────────┐          │                                                      │
│ consultation │◄─────────┘──────────────────────────────────────────────────────┘
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   message    │
└──────────────┘
```

---

## Tables

### 1. `app_user` - User accounts

| Field              | Type      | Nullable | Default   | Description                |
| ------------------ | --------- | -------- | --------- | -------------------------- |
| `id`             | UuidValue | Yes      | random_v7 | Primary key                |
| `email`          | String    | No       |           | User email                 |
| `phone`          | String    | No       |           | Phone number               |
| `age`            | int       | No       |           | User age                   |
| `gender`         | Gender    | No       |           | MALE, FEMALE               |
| `passwordHash`   | String    | No       |           | Hashed password            |
| `name`           | String    | No       |           | Full name                  |
| `role`           | Role      | No       |           | USER, DOCTOR, ADMIN        |
| `skinType`       | SkinType  | No       |           | Skin type classification   |
| `profilePhoto`   | String    | Yes      |           | Profile photo URL          |
| `encryptionKey`  | String    | No       |           | Encryption key for E2E     |
| `descriptionKey` | String    | No       |           | Encrypted description      |
| `createdAt`      | DateTime  | No       |           | Account creation timestamp |

**Source**: `lib/src/models/user.yaml`

---

### 2. `doctor` - Doctor profiles

| Field              | Type      | Nullable | Default   | FK                | Description                |
| ------------------ | --------- | -------- | --------- | ----------------- | -------------------------- |
| `id`             | UuidValue | Yes      | random_v7 |                   | Primary key                |
| `userId`         | UuidValue | No       |           | →`app_user.id` | Link to user account       |
| `name`           | String    | No       |           |                   | Doctor display name        |
| `credentialsKey` | String    | No       |           |                   | Encrypted credentials      |
| `encryptionKey`  | String    | No       |           |                   | Encryption key             |
| `licenseNumber`  | String    | No       |           |                   | Medical license number     |
| `verified`       | bool      | No       |           |                   | Verification status        |
| `rating`         | double    | No       |           |                   | Average rating             |
| `availability`   | bool      | No       |           |                   | Currently available        |
| `fee`            | double    | No       |           |                   | Consultation fee           |
| `createdAt`      | DateTime  | No       |           |                   | Profile creation timestamp |

**Source**: `lib/src/models/doctor.yaml`
**Relations**: `userId` → `app_user.id`

---

### 3. `symptom_check` - User symptom submissions

| Field             | Type                 | Nullable | Default   | FK                | Description                |
| ----------------- | -------------------- | -------- | --------- | ----------------- | -------------------------- |
| `id`            | UuidValue            | Yes      | random_v7 |                   | Primary key                |
| `userId`        | UuidValue            | No       |           | →`app_user.id` | User who submitted         |
| `skinType`      | SkinType             | No       |           |                   | Skin type at time of check |
| `symptoms`      | List\<Symptom\>      | No       |           |                   | List of symptoms (JSON)    |
| `affectedAreas` | List\<AffectedArea\> | No       |           |                   | Affected body areas (JSON) |
| `duration`      | String               | No       |           |                   | How long symptoms lasted   |
| `severity`      | Severity             | No       |           |                   | Severity level             |
| `notesKey`      | String               | No       |           |                   | Encrypted notes            |
| `encryptionKey` | String               | No       |           |                   | Encryption key             |
| `createdAt`     | DateTime             | No       |           |                   | Submission timestamp       |

**Source**: `lib/src/models/symptom_check.yaml`
**Relations**: `userId` → `app_user.id`

---

### 4. `consultation` - Doctor-patient consultations

| Field              | Type               | Nullable | Default   | FK                     | Description            |
| ------------------ | ------------------ | -------- | --------- | ---------------------- | ---------------------- |
| `id`             | UuidValue          | Yes      | random_v7 |                        | Primary key            |
| `userId`         | UuidValue          | No       |           | →`app_user.id`      | Patient                |
| `doctorId`       | UuidValue          | No       |           | →`doctor.id`        | Assigned doctor        |
| `checkId`        | UuidValue          | No       |           | →`symptom_check.id` | Related symptom check  |
| `status`         | ConsultationStatus | No       |           |                        | Current status         |
| `doctorNotesKey` | String             | No       |           |                        | Encrypted doctor notes |
| `encryptionKey`  | String             | No       |           |                        | Encryption key         |
| `createdAt`      | DateTime           | No       |           |                        | Creation timestamp     |
| `respondedAt`    | DateTime           | Yes      |           |                        | When doctor responded  |

**Source**: `lib/src/models/consultation.yaml`
**Relations**: `userId` → `app_user.id`, `doctorId` → `doctor.id`, `checkId` → `symptom_check.id`

---

### 5. `image` - Skin images uploaded by users

| Field              | Type      | Nullable | Default   | FK                     | Description           |
| ------------------ | --------- | -------- | --------- | ---------------------- | --------------------- |
| `id`             | UuidValue | Yes      | random_v7 |                        | Primary key           |
| `userId`         | UuidValue | No       |           | →`app_user.id`      | Uploader              |
| `checkId`        | UuidValue | No       |           | →`symptom_check.id` | Related symptom check |
| `url`            | String    | No       |           |                        | Image storage URL     |
| `metadata`       | String    | No       |           |                        | Image metadata        |
| `encryptionKey`  | String    | No       |           |                        | Encryption key        |
| `descriptionKey` | String    | No       |           |                        | Encrypted description |
| `uploadedAt`     | DateTime  | No       |           |                        | Upload timestamp      |

**Source**: `lib/src/models/image.yaml`
**Relations**: `userId` → `app_user.id`, `checkId` → `symptom_check.id`

---

### 6. `message` - Chat messages in consultations

| Field              | Type       | Nullable | Default   | FK                    | Description               |
| ------------------ | ---------- | -------- | --------- | --------------------- | ------------------------- |
| `id`             | UuidValue  | Yes      | random_v7 |                       | Primary key               |
| `consultationId` | UuidValue  | No       |           | →`consultation.id` | Parent consultation       |
| `senderId`       | UuidValue  | No       |           | →`app_user.id`     | Message sender            |
| `senderType`     | SenderType | No       |           |                       | USER or DOCTOR            |
| `messageKey`     | String     | No       |           |                       | Encrypted message content |
| `encryptionKey`  | String     | No       |           |                       | Encryption key            |
| `createdAt`      | DateTime   | No       |           |                       | Send timestamp            |

**Source**: `lib/src/models/message.yaml`
**Relations**: `consultationId` → `consultation.id`, `senderId` → `app_user.id`

---

### 7. `payment` - Payment transactions

| Field              | Type          | Nullable | Default   | FK                    | Description             |
| ------------------ | ------------- | -------- | --------- | --------------------- | ----------------------- |
| `id`             | UuidValue     | Yes      | random_v7 |                       | Primary key             |
| `userId`         | UuidValue     | No       |           | →`app_user.id`     | Payer                   |
| `consultationId` | UuidValue     | No       |           | →`consultation.id` | Related consultation    |
| `amount`         | double        | No       |           |                       | Payment amount          |
| `status`         | PaymentStatus | No       |           |                       | Payment status          |
| `provider`       | String        | No       |           |                       | Payment provider name   |
| `transactionId`  | String        | No       |           |                       | External transaction ID |
| `createdAt`      | DateTime      | No       |           |                       | Creation timestamp      |
| `updatedAt`      | DateTime      | No       |           |                       | Last update timestamp   |

**Source**: `lib/src/models/payment.yaml`
**Relations**: `userId` → `app_user.id`, `consultationId` → `consultation.id`

---

### 8. `recommendation` - AI/doctor recommendations

| Field             | Type      | Nullable | Default   | FK                     | Description           |
| ----------------- | --------- | -------- | --------- | ---------------------- | --------------------- |
| `id`            | UuidValue | Yes      | random_v7 |                        | Primary key           |
| `checkId`       | UuidValue | No       |           | →`symptom_check.id` | Related symptom check |
| `severity`      | Severity  | No       |           |                        | Severity assessment   |
| `tipsKey`       | String    | No       |           |                        | Encrypted care tips   |
| `warningsKey`   | String    | No       |           |                        | Encrypted warnings    |
| `encryptionKey` | String    | No       |           |                        | Encryption key        |
| `createdAt`     | DateTime  | No       |           |                        | Creation timestamp    |

**Source**: `lib/src/models/recommendation.yaml`
**Relations**: `checkId` → `symptom_check.id`

---

### 9. `consent` - User consent records

| Field              | Type      | Nullable | Default   | FK                | Description           |
| ------------------ | --------- | -------- | --------- | ----------------- | --------------------- |
| `id`             | UuidValue | Yes      | random_v7 |                   | Primary key           |
| `userId`         | UuidValue | No       |           | →`app_user.id` | User who gave consent |
| `type`           | String    | No       |           |                   | Consent type          |
| `accepted`       | bool      | No       |           |                   | Whether accepted      |
| `encryptionKey`  | String    | No       |           |                   | Encryption key        |
| `descriptionKey` | String    | No       |           |                   | Encrypted description |
| `createdAt`      | DateTime  | No       |           |                   | Consent timestamp     |

**Source**: `lib/src/models/consent.yaml`
**Relations**: `userId` → `app_user.id`

---

### 10. `audit_log` - System audit trail

| Field              | Type      | Nullable | Default   | FK                | Description               |
| ------------------ | --------- | -------- | --------- | ----------------- | ------------------------- |
| `id`             | UuidValue | Yes      | random_v7 |                   | Primary key               |
| `userId`         | UuidValue | No       |           | →`app_user.id` | User who performed action |
| `action`         | String    | No       |           |                   | Action performed          |
| `ip`             | String    | No       |           |                   | Client IP address         |
| `encryptionKey`  | String    | No       |           |                   | Encryption key            |
| `descriptionKey` | String    | No       |           |                   | Encrypted description     |
| `createdAt`      | DateTime  | No       |           |                   | Action timestamp          |
| `updatedAt`      | DateTime  | No       |           |                   | Last update timestamp     |

**Source**: `lib/src/models/audit_log.yaml`
**Relations**: `userId` → `app_user.id`

---

## Enums

### Gender

| Value  |
| ------ |
| MALE   |
| FEMALE |

### Role

| Value  |
| ------ |
| USER   |
| DOCTOR |
| ADMIN  |

### SkinType

| Value       |
| ----------- |
| NORMAL      |
| OILY        |
| DRY         |
| SENSITIVE   |
| COMBINATION |

### Symptom

| Value        |
| ------------ |
| ACNE         |
| RASH         |
| DRYNESS      |
| ITCHING      |
| PIGMENTATION |
| BLEEDING     |
| BURNING      |
| INFECTION    |
| OTHER        |

### AffectedArea

| Value |
| ----- |
| FACE  |
| HANDS |
| ARMS  |
| LEGS  |
| BACK  |
| NECK  |
| CHEST |
| OTHER |

### Severity

| Value     |
| --------- |
| LOW       |
| MEDIUM    |
| HIGH      |
| EMERGENCY |

### ConsultationStatus

| Value       |
| ----------- |
| PENDING     |
| ACCEPTED    |
| IN_PROGRESS |
| COMPLETED   |
| CANCELLED   |
| REJECTED    |

### PaymentStatus

| Value     |
| --------- |
| PENDING   |
| PAID      |
| FAILED    |
| REFUNDED  |
| CANCELLED |

### SenderType

| Value  |
| ------ |
| USER   |
| DOCTOR |

---

## Foreign Key Relationships Summary

| From Table         | Field              | To Table          | To Field |
| ------------------ | ------------------ | ----------------- | -------- |
| `doctor`         | `userId`         | `app_user`      | `id`   |
| `symptom_check`  | `userId`         | `app_user`      | `id`   |
| `consultation`   | `userId`         | `app_user`      | `id`   |
| `consultation`   | `doctorId`       | `doctor`        | `id`   |
| `consultation`   | `checkId`        | `symptom_check` | `id`   |
| `image`          | `userId`         | `app_user`      | `id`   |
| `image`          | `checkId`        | `symptom_check` | `id`   |
| `message`        | `consultationId` | `consultation`  | `id`   |
| `message`        | `senderId`       | `app_user`      | `id`   |
| `payment`        | `userId`         | `app_user`      | `id`   |
| `payment`        | `consultationId` | `consultation`  | `id`   |
| `recommendation` | `checkId`        | `symptom_check` | `id`   |
| `consent`        | `userId`         | `app_user`      | `id`   |
| `audit_log`      | `userId`         | `app_user`      | `id`   |

---

## Notes

- All tables use **UUID v7** as primary keys (time-sortable, generated server-side)
- Sensitive data is **encrypted at rest** using per-record encryption keys (`encryptionKey`, `descriptionKey`, `messageKey`, etc.)
- `symptoms` and `affectedAreas` in `symptom_check` are stored as **JSON arrays**
- FK constraints use **NO ACTION** on DELETE/UPDATE (referential integrity enforced)
- Serverpod framework also manages its own system tables for auth, sessions, logging, etc.
