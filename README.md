
# Epidexa – AI-Based Skin Detection App

Epidexa is an AI-powered skin analysis platform designed to help users identify common skin conditions and receive basic skin-care guidance through a secure and easy-to-use mobile application.

The system consists of a Dart backend server, a shared client package, and a Flutter mobile application.
<img width="1621" height="978" alt="original" src="https://github.com/user-attachments/assets/6a65f1c7-cb18-4369-97d6-2533c82d00b3" />
<img width="1748" height="984" alt="original (1)" src="https://github.com/user-attachments/assets/07fa7270-24dd-4317-b34f-62109be8ef7f" />


---

## 📁 Project Configuration

Before running the project, download and configure the required environment files:

- 🔐 **Password Configuration**  
  [Download password.yaml](https://drive.google.com/file/d/1oLVmdVW-oAC_JeDRsNCC7zie_Rsd8Rzg/view?usp=sharing)

- **API Congiguration**
  - epidexa_flutter/lib/providers/serverpod_provider.dart
  - For Android, start server, use 10.0.2.2 and others

> Place these files in their respective configuration directories before starting the server.

---

## 📂 Project Structure

The repository is organized into three main components:

### epidexa_server/
Backend service built with Serverpod (Dart).
Hosted Postgres DB

**Contains:**
- `bin/main.dart` – Server entry point
- `lib/` – Backend source code
- `config/` – Environment configuration files
- `pubspec.yaml` – Server dependencies

---

### epidexa_client/
Shared Dart package providing API clients and protocol models.

**Contains:**
- `lib/` – Client logic and models
- `pubspec.yaml` – Package dependencies

---

### epidexa_flutter/
Flutter mobile application for Android and iOS.

**Contains:**
- `android/` / `ios/` – Platform-specific files
- `lib/` – Application source code
- `pubspec.yaml` – App dependencies

---

## ⚙️ Installation & Setup

### Prerequisites

Ensure the following tools are installed:

- Dart SDK
- Flutter SDK
- ServerPod Framework
- Android Studio or Xcode
- Git

---

### Clone the Repository

```bash
git clone https://github.com/Klassic-Mak/epidexa.git
cd epidexa
