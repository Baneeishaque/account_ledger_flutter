# Copilot Instructions for AI Agents

## Branch Safety for Review Tasks

**Always ensure you are on the correct feature or pull request branch (not master) before implementing any review feedback or making changes related to code reviews.**

This ensures all edits are applied to the intended branch for the active pull request and not to the main branch mistakenly.

## Project Overview

This is a Flutter-based cross-platform application for account ledger management. The codebase is structured for Android, iOS, web, macOS, Linux, and Windows targets. The main business logic and UI are in the `lib/` directory.

## Key Architecture & Patterns

- **Entry Point:** `lib/main.dart` initializes the app. The root widget is in `account_ledger_material_app.dart`.
- **Views & UI:** UI screens are in `lib/views/`. Example: `home_page.dart`.
- **Utilities:** Shared helpers are in `lib/utils/` (e.g., `app_utils.dart`).
- **Networking:** HTTP logic is in `lib/http_service.dart`.
- **Models:** Data models like `posts_model.dart` are in `lib/`.
- **Authentication:** Login forms are in `lib/login_form.dart` and `lib/login_form3.dart`.

## Developer Workflows

- **Build:** Use `flutter build <platform>` (e.g., `flutter build apk`, `flutter build ios`).
- **Run:** Use `flutter run` for local development.
- **Test:** No explicit test directory found; add tests under `test/` if needed.
- **Dependencies:** Managed via `pubspec.yaml`. Run `flutter pub get` after changes.
- **Platform Integration:** Android and iOS native code in `android/` and `ios/` folders. Flutter plugins may be present.

## Project Conventions

- **File Naming:** Follows Dart/Flutter conventions (snake_case for files).
- **State Management:** No explicit state management package detected; check `main.dart` and root widget for patterns.
- **Navigation:** Likely uses Flutter's built-in navigation; see `main.dart` and `account_ledger_material_app.dart`.
- **Secrets/Config:** No `.env` or config pattern detected; sensitive data should not be hardcoded.

## Integration Points

- **External Services:** HTTP requests handled in `http_service.dart`.
- **Platform Channels:** For native integration, see platform-specific folders.

## Examples

- To add a new screen: create a Dart file in `lib/views/`, add a widget, and register it in the app's navigation.
- To add a utility: place shared functions in `lib/utils/app_utils.dart`.

## References

- Main entry: `lib/main.dart`
- App root: `lib/account_ledger_material_app.dart`
- Utilities: `lib/utils/`
- Views: `lib/views/`
- Networking: `lib/http_service.dart`

---
For more, see `README.md` and `pubspec.yaml`.
