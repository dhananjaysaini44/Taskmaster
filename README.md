# Taskmaster

[<img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white" height="25">](https://flutter.dev)
[<img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white" height="25">](https://dart.dev)
[<img src="https://img.shields.io/badge/Riverpod-%2302569B.svg?style=flat&logo=riverpod&logoColor=white" height="25">](https://riverpod.dev)
[<img src="https://img.shields.io/badge/Hive-%23FDC210.svg?style=flat&logo=hive&logoColor=black" height="25">](https://pub.dev/packages/hive)
[<img src="https://img.shields.io/badge/Firebase-%23039BE5.svg?style=flat&logo=firebase" height="25">](https://firebase.google.com)
[<img src="https://img.shields.io/badge/GoRouter-%2302569B.svg?style=flat&logo=flutter&logoColor=white" height="25">](https://pub.dev/packages/go_router)

Taskmaster is a high-fidelity productivity suite developed with Flutter, designed to provide a sophisticated balance of task management, calendar coordination, and productivity analytics.
The application adheres to a premium design philosophy, utilizing modern UI techniques including glassmorphism, dynamic gradients, and refined spatial layouts to deliver an immersive and intuitive user experience.

## Product Overview

The application is engineered for users who require a reliable and visually refined tool for managing daily professional and personal commitments. By leveraging a hybrid data architecture, Taskmaster ensures that productivity remains uninterrupted by network conditions, while offering robust cloud synchronization for multi-device consistency.

## Principal Features

Taskmaster implements a contemporary design language characterized by glassmorphism and dynamic gradients. The user interface features a cinematic 1.5-second splash experience with a zoom-in branding animation on theme-aware solid backgrounds (Deep Black/Pure White) and custom login backgrounds that intelligently transition between light and dark modes, reducing visual fatigue and enhancing engagement.

### Hybrid Synchronization Engine
The system utilizes a sophisticated dual-layered persistence and isolation strategy:
- **Local Persistence & Isolation**: Powered by Hive, ensuring near-zero latency. Data is partitioned into user-specific encrypted vaults (UID-prefixed boxes), ensuring strict multitenancy even on shared hardware.
- **Cloud Synchronization**: Integrated with Firebase Firestore to provide real-time data redundancy, secure cross-platform synchronization, and a secondary layer of data isolation.

### Secure Profile Management
Users can now maintain their identity directly within the application. The new profile suite allows for real-time updates to display names and secure password modifications, with all changes instantly synchronized to the Firebase cloud and across all active sessions.

### Integrated Scheduling
The calendar module offers a unified view of time-sensitive events, categorized by professional and personal domains. It features real-time synchronization, ensuring that schedules are always current across all logged-in instances.

### Intelligence Dashboard (Landing Page)
The Home screen serves as the primary landing experience, providing dynamic dashboards that visualize completion metrics and performance trends. It offers actionable insights into productivity patterns, immediate access to an expanded list of up to 10 pressing deadlines (including both tasks and events with completion support), and direct navigation to your profile via the interactive user header.

### Native Notification System
The application now features a robust, system-level reminder engine that ensures you never miss a deadline.
- **Proactive Reminders**: Automatically schedules high-priority notifications 30 minutes before task due dates and calendar event start times.
- **Dynamic Synchronization**: Reminders are instantly updated or canceled when tasks are modified, completed, or deleted.
- **Native Experience**: Utilizes system-level notification channels with custom branding and priority delivery, even on modern Android versions.

## Technical Implementation

Taskmaster is built upon a modern, reactive tech stack optimized for performance and maintainability:

| Technology | Category | Role in Taskmaster |
| :--- | :--- | :--- |
| **Flutter** | Core Framework | High-fidelity UI rendering and multi-platform consistency. |
| **Dart** | Language | Reactive programming and efficient, type-safe business logic. |
| **Riverpod** | State Management | Declarative state handling and robust dependency injection. |
| **Hive** | Local Database | High-performance NoSQL storage for offline-first data persistence. |
| **Firebase** | Cloud Infrastructure | Real-time data synchronization, secure cross-device authentication, and cloud-side data isolation. |
| **GoRouter** | Routing Engine | Declarative navigation and advanced deep-linking capabilities. |
| **Notifications** | Native Reminders | System-level scheduling with `flutter_local_notifications` and timezone awareness. |

## Architectural Pattern

The project follows a Feature-First Layered Architecture, promoting high modularity and clear separation of concerns:
- **Domain Layer**: Core business models and logic.
- **Data Layer**: Repository implementations handling the hybrid storage bridge.
- **Presentation Layer**: UI components and Riverpod providers.

## Project Structure

The project adheres to a **Feature-First Layered Architecture**, ensuring high modularity and scalability:

```text
taskmaster/
├── android/            # Android platform-specific configurations
├── assets/             # Global images, icons, and theme assets
├── app_info/           # Technical documentation and guides
│   ├── explanation.txt
│   └── firebase_benefits.txt
├── lib/
│   ├── core/           # Shared utilities, routing, and theme definitions
│   │   ├── router/     # GoRouter configuration
│   │   ├── services/   # Notification and system services
│   │   ├── theme/      # AppTheme and ThemeExtensions
│   │   └── utils/      # Validators and helpers
│   ├── features/       # Modular business logic and UI components
│   │   ├── {feature}/  # Standardized feature structure:
│   │   │   ├── data/           # Repositories and data sources
│   │   │   ├── domain/         # Models and business logic
│   │   │   └── presentation/   # Screens, providers, and widgets
│   │   ├── auth/       # Authentication, Login, Signup
│   │   ├── calendar/   # Event scheduling, Focus Flow, Streak tracking
│   │   ├── home/       # Productivity analytics dashboard
│   │   ├── mindmap/    # Mind Flow ideation and brainstorming
│   │   ├── profile/    # User identity and profile settings
│   │   ├── settings/   # Theme and application configuration
│   │   └── splash/     # Cinematic launch experience
│   ├── shared/         # Reusable widgets and UI components
│   │   └── widgets/
│   ├── firebase_options.dart
│   └── main.dart
├── test/               # Unit and widget test suites
└── pubspec.yaml        # Project dependencies and metadata
```

## Installation and Deployment

### Prerequisites
- **Flutter SDK**: `3.43.0-0.1.pre` (or later)
- **Dart SDK**: `3.12.0`
- **Platform Tools**: Configured environments for target platforms (Web, Android, iOS, or Desktop).

### Execution
1. **Clone Repository**:
   ```bash
   git clone https://github.com/dhananjaysaini44/taskmaster.git
   cd taskmaster
   ```

2. **Initialize Project**:
   ```bash
   flutter pub get
   ```

3. **Generate Dependencies**:
   The project requires code generation for Hive and Riverpod components.
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Launch Application**:
   ```bash
   flutter run
   ```

## Documentation

For an in-depth technical analysis, directory mapping, and detailed screen functionalities, please consult the [explanation.txt](file:///c:/Users/DHANANJAY/Flutter/taskmaster/app_info/explanation.txt) file located in the `app_info/` directory.

---

Maintainer: [Dhananjay Saini](https://github.com/dhananjaysaini44)  
Project Version: 1.8.0
