# skinAware

This repository contains the skinAware project, organized as a multi-package workspace that includes a Server (Dart/Serverpod), a Flutter app, and a Dart client package.

Below is a concise map of the important top-level folders and what they contain.

## Top-level folders

- `skinAware_server/`
  - Dart server implementation (Serverpod). Contains `bin/`, `lib/`, `config/` and server-side source.
  - Important files:
    - `bin/main.dart` — server entrypoint
    - `pubspec.yaml` — server dependencies
    - `config/*.yaml` — environment/config files (development, staging, production, test)
  - Quick run (from this folder):
    ```
    dart pub get
    dart run bin/main.dart
    ```

- `skinAware_client/`
  - A Dart package that provides client-side code (API clients, protocol classes) used by the Flutter app and other clients.
  - Contains `lib/` and `pubspec.yaml`. Run `dart pub get` to fetch dependencies.

- `skinAware_flutter/`
  - Flutter application project. Contains `pubspec.yaml`, `android/`, `ios/`, and platform-specific code.
  - Use the usual Flutter workflow to run or build it.
  - Quick run (from this folder):
    ```
    flutter pub get
    flutter run -d <device-id>
    ```

- `lib/`, `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`
  - These folders are platform and app-level code for the Flutter app(s) in this workspace. `lib/` contains the app source (widgets, pages, main.dart).
  - If you have multiple Flutter projects, check each `pubspec.yaml` to determine which app uses which platform folders.

- `assets/`, `images/`, `fonts/`, `icons/`, `illustrations/`, `animations/`
  - Media and resource files used by the Flutter app(s). Fonts are under `fonts/` and images under `images/`.

- `build/`
  - Generated build artifacts. Safe to ignore in source control and usually added to `.gitignore`.

- `test/`
  - Unit and widget tests. Run tests with `dart test` or `flutter test` in the relevant package.

- `migrations/`
  - Database migration scripts (if present). Keep track of migration history here.

## How the pieces relate

- The server (`skinAware_server`) exposes APIs that the client package (`skinAware_client`) can call. The Flutter app (`skinAware_flutter` and/or root `lib/`) consumes the client package and UI code.
- Configuration for the server lives in `skinAware_server/config/*.yaml`.

## Common tasks

- Run the server:
  ```
  cd skinAware_server
  dart pub get
  dart run bin/main.dart
  ```

- Run the Flutter app (make sure Flutter SDK is installed):
  ```
  cd skinAware_flutter
  flutter pub get
  flutter run -d <device>
  ```

- Work with the client package:
  ```
  cd skinAware_client
  dart pub get
  ```
