# Account Ledger Flutter

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/Baneeishaque/account_ledger_flutter/blob/master/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.1.0--9.0.pre--beta-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-2.18.0+-blue.svg)](https://dart.dev/)
[![Build Status](https://dev.azure.com/banaborkardev/account-ledger/_apis/build/status/Baneeishaque.account_ledger_flutter?branchName=master)](https://dev.azure.com/banaborkardev/account-ledger/_build/latest?definitionId=1&branchName=master)

A cross-platform account ledger application built with Flutter, supporting Android, iOS, Web, Windows, macOS, and Linux platforms.

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Technical Overview](#technical-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Development](#development)
- [Building](#building)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [CI/CD](#cicd)
- [Contributing](#contributing)
- [License](#license)

## Features

- 🔐 **User Authentication** - Secure login with username/password validation
- 📊 **Account Management** - View and manage account ledgers
- 🎨 **Modern UI** - Beautiful gradient input borders and material design
- 📱 **Multi-Platform** - Runs on Android, iOS, Web, Windows, macOS, and Linux
- 🖥️ **Desktop Support** - Full native desktop experience with window management
- 🌐 **HTTP Integration** - RESTful API connectivity for data synchronization

## Screenshots

*Screenshots will be added once the application UI is finalized.*

## Technical Overview

### Core Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.1.0-9.0.pre-beta | Cross-platform UI framework |
| Dart | >=2.18.0-165.1.beta <3.0.0 | Programming language |
| Kotlin | JDK 7 | Android native code |
| Swift | Latest | iOS/macOS native code |
| C++ | CMake-based | Windows/Linux native code |

### Key Features

- **Universal Platform Support**: Single codebase targeting Android, iOS, Web, Windows, macOS, and Linux
- **Material Design 3**: Modern Material Design components with theming support
- **Form Validation**: Built-in input validation with user-friendly error messages
- **HTTP Client**: Integration with REST APIs using the `http` package
- **Window Management**: Desktop window title and size configuration

## Architecture

The application follows a widget-based architecture pattern typical of Flutter applications:

```
lib/
├── main.dart                      # Application entry point
├── account_ledger.dart            # Main app widget (alternative)
├── account_ledger_material_app.dart # Primary MaterialApp configuration
├── application_specification.dart  # App constants and specifications
├── http_service.dart              # HTTP API service layer
├── login.dart                     # Login screen stateful widget
├── login_form.dart                # Primary login form implementation
├── login_form3.dart               # Alternative form implementation
├── posts_model.dart               # Data model for posts
├── utils/
│   └── app_utils.dart             # Platform-specific utilities
└── views/
    └── home_page.dart             # Home screen widget
```

### Key Components

- **main.dart**: Entry point that initializes Flutter bindings, sets window title for desktop platforms, and launches the app
- **AccountLedgerMaterialApp**: Root widget with theme configuration and routing
- **HomePage**: Main navigation hub with options for Login, Register, List Users, and Balance Sheets
- **LoginForm**: Authentication form with gradient-styled input fields
- **HttpService**: HTTP client for API communications
- **AppUtils**: Platform-aware utility for app lifecycle management (exit/minimize)

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Tools

- **Flutter SDK** (version 3.1.0-9.0.pre-beta recommended)
- **Dart SDK** (version 2.18.0 or later - comes with Flutter)
- **Git** (for cloning the repository)

### Platform-Specific Requirements

#### Android Development
- Android Studio (Arctic Fox or later)
- Android SDK (API level 21+)
- Java Development Kit (JDK 11)
- Android Emulator or physical device

#### iOS Development (macOS only)
- Xcode 14.0 or later
- CocoaPods
- iOS Simulator or physical iOS device
- Apple Developer account (for device testing)

#### Web Development
- Chrome browser (recommended for debugging)
- Enabled web support in Flutter

#### Windows Development
- Visual Studio 2022 with "Desktop development with C++" workload
- Windows 10 SDK
- Windows 10 version 1803 or later

#### macOS Development
- Xcode 14.0 or later
- macOS 10.14 Mojave or later
- CocoaPods

#### Linux Development
- GCC (g++)
- CMake 3.10 or later
- GTK development libraries
- pkg-config
- On Ubuntu/Debian:
  ```bash
  sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
  ```

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Baneeishaque/account_ledger_flutter.git
cd account_ledger_flutter
```

### 2. Install Flutter SDK

If you haven't already, install Flutter by following the [official guide](https://docs.flutter.dev/get-started/install).

For this project, use the beta channel:

```bash
flutter channel beta
flutter upgrade
```

Or using asdf (if `.tool-versions` is used):

```bash
asdf plugin-add flutter
asdf install
```

### 3. Verify Flutter Installation

```bash
flutter doctor -v
```

Ensure all required components show green checkmarks for your target platform(s).

### 4. Get Dependencies

```bash
flutter pub get
```

### 5. Enable Desktop Support (if needed)

```bash
# Windows
flutter config --enable-windows-desktop

# macOS
flutter config --enable-macos-desktop

# Linux
flutter config --enable-linux-desktop
```

## Development

### Running the App

```bash
# Run on default device (auto-detected)
flutter run

# Run on specific platform
flutter run -d android       # Android device/emulator
flutter run -d ios           # iOS device/simulator (macOS only)
flutter run -d chrome        # Web browser
flutter run -d windows       # Windows desktop
flutter run -d macos         # macOS desktop (macOS only)
flutter run -d linux         # Linux desktop
```

### Hot Reload and Hot Restart

While the app is running:
- Press `r` for hot reload (preserves state)
- Press `R` for hot restart (resets state)
- Press `q` to quit

### Code Analysis

Run the static analyzer to check for issues:

```bash
flutter analyze
```

The project uses recommended lints from `flutter_lints` package configured in `analysis_options.yaml`.

### Code Formatting

Format your code to follow Dart style guidelines:

```bash
dart format lib/
```

## Building

### Android APK

```bash
# Debug APK (all architectures)
flutter build apk --debug

# Debug APK (split by ABI - recommended for smaller file size)
flutter build apk --debug --split-per-abi

# Release APK
flutter build apk --release --split-per-abi
```

Output location: `build/app/outputs/flutter-apk/`

### Android App Bundle

```bash
flutter build appbundle --release
```

Output location: `build/app/outputs/bundle/release/`

### iOS

```bash
# iOS app for simulator (debug)
flutter build ios --debug --simulator

# iOS app for device (requires signing)
flutter build ios --release
```

### Web

```bash
# Debug build
flutter build web

# Release build with optimizations
flutter build web --release
```

Output location: `build/web/`

### Windows

```bash
flutter build windows --release
```

Output location: `build/windows/runner/Release/`

### macOS

```bash
flutter build macos --release
```

Output location: `build/macos/Build/Products/Release/`

### Linux

```bash
flutter build linux --release
```

Output location: `build/linux/x64/release/bundle/`

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Integration Tests

```bash
flutter test integration_test/
```

## Project Structure

```
account_ledger_flutter/
├── android/                 # Android platform-specific code
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   ├── build.gradle
│   └── settings.gradle
├── ios/                     # iOS platform-specific code
├── lib/                     # Dart source code
│   ├── main.dart           # App entry point
│   ├── utils/              # Utility classes
│   └── views/              # Screen widgets
├── linux/                   # Linux platform-specific code
├── macos/                   # macOS platform-specific code
├── web/                     # Web platform-specific code
├── windows/                 # Windows platform-specific code
├── .tool-versions          # asdf tool versions
├── analysis_options.yaml   # Dart analyzer configuration
├── azure-pipelines.yml     # Azure DevOps CI/CD configuration
├── pubspec.yaml            # Dart dependencies and metadata
├── pubspec.lock            # Locked dependency versions
└── renovate.json           # Renovate bot configuration
```

## Dependencies

### Production Dependencies

| Package | Version | Description |
|---------|---------|-------------|
| `flutter` | SDK | Flutter framework |
| `cupertino_icons` | ^1.0.5 | iOS-style icons |
| `gradient_input_border` | git | Gradient-styled input borders |
| `http` | ^0.13.4 | HTTP client for API calls |
| `getwidget` | ^3.0.1 | UI component library |
| `minimize_app` | git | App minimize functionality (iOS) |
| `universal_platform` | ^1.0.0+1 | Platform detection |
| `universal_io` | ^2.0.4 | Cross-platform I/O |
| `window_size` | git | Desktop window management |

### Development Dependencies

| Package | Version | Description |
|---------|---------|-------------|
| `flutter_test` | SDK | Flutter testing framework |
| `flutter_lints` | ^2.0.1 | Recommended lints for Flutter |

## CI/CD

The project uses Azure Pipelines for continuous integration and delivery.

### Build Matrix

| Platform | Build Target | Status |
|----------|--------------|--------|
| Windows | APK (debug, split-per-abi) | ✅ |
| Windows | Web (debug) | ✅ |
| Windows | Desktop (debug) | ✅ |
| Linux | Desktop (debug) | ✅ |
| macOS | Desktop (debug) | ✅ |

### Pipeline Configuration

The CI pipeline (`azure-pipelines.yml`) is configured to:

1. Run on Ubuntu 22.04, macOS 14, and Windows latest
2. Install Flutter SDK (beta channel, version 3.1.0-9.0.pre-beta)
3. Build platform-specific artifacts
4. Publish debug APKs as pipeline artifacts

### Dependency Management

[Renovate Bot](https://github.com/renovatebot/renovate) is configured to automatically manage dependency updates.

## Contributing

Contributions are welcome! Here's how you can help:

### Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/account_ledger_flutter.git
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make your changes** with clear, descriptive commits
5. **Test your changes** thoroughly
6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request** with a clear description

### Coding Standards

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Ensure all code passes `flutter analyze` without warnings
- Format code with `dart format lib/`
- Write meaningful commit messages
- Add tests for new features when possible

### Pull Request Guidelines

- Keep PRs focused on a single feature or fix
- Update documentation if needed
- Ensure CI checks pass
- Request review from maintainers

### Reporting Issues

Found a bug or have a feature request? Please [open an issue](https://github.com/Baneeishaque/account_ledger_flutter/issues/new) with:

- A clear, descriptive title
- Steps to reproduce (for bugs)
- Expected vs. actual behavior
- Screenshots if applicable
- Flutter version and platform information

### Development Workflow

1. Sync your fork with upstream regularly
2. Create branches from `master`
3. Use meaningful branch names: `feature/*`, `bugfix/*`, `docs/*`
4. Squash commits before merging if needed

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Baneeishaque

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<p align="center">
  Made with ❤️ using <a href="https://flutter.dev">Flutter</a>
</p>