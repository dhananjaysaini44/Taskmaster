# Taskmaster

[<img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white" height="25">](https://flutter.dev)
[<img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white" height="25">](https://dart.dev)
[<img src="https://img.shields.io/badge/Riverpod-%2302569B.svg?style=flat&logo=riverpod&logoColor=white" height="25">](https://riverpod.dev)
[<img src="https://img.shields.io/badge/Hive-%23FDC210.svg?style=flat&logo=hive&logoColor=black" height="25">](https://pub.dev/packages/hive)
[<img src="https://img.shields.io/badge/Firebase-%23039BE5.svg?style=flat&logo=firebase" height="25">](https://firebase.google.com)

Taskmaster is a high-fidelity productivity suite developed with Flutter, designed to provide a sophisticated balance of task management, calendar coordination, and productivity analytics.
 The application adheres to a premium design philosophy, utilizing modern UI techniques to deliver an immersive "Ambient" user experience.

## Product Overview

The application is engineered for users who require a reliable and visually refined tool for managing daily professional and personal commitments. By leveraging a hybrid data architecture, Taskmaster ensures that productivity remains uninterrupted by network conditions, while offering robust cloud synchronization for multi-device consistency.

## Principal Features

### Ambient Design System
Taskmaster implements a contemporary design language characterized by glassmorphism and dynamic gradients. The user interface features theme-aware ambient backgrounds that intelligently transition between light and dark modes, reducing visual fatigue and enhancing engagement.

### Hybrid Synchronization Engine
The system utilizes a sophisticated dual-layered persistence and isolation strategy:
- **Local Persistence & Isolation**: Powered by Hive, ensuring near-zero latency. Data is partitioned into user-specific encrypted vaults (UID-prefixed boxes), ensuring strict multitenancy even on shared hardware.
- **Cloud Synchronization**: Integrated with Firebase Firestore to provide real-time data redundancy, secure cross-platform synchronization, and a secondary layer of data isolation.

### Personalized User Interface
The application features a personalized greeting system and profile management, ensuring that user identity is integrated throughout the productivity flow.

### Task Lifecycle Management
A comprehensive suite of task management tools is provided, including:
- Multi-dimensional status filtering.
- High-fidelity drag-and-drop reordering for intuitive prioritization.
- Context-aware editing and deletion workflows.

### Integrated Scheduling
The calendar module offers a unified view of time-sensitive events, categorized by professional and personal domains. It features real-time synchronization, ensuring that schedules are always current across all logged-in instances.

### Productivity Analytics
Dynamic dashboards visualize completion metrics and performance trends, providing users with actionable insights into their productivity patterns.

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
│   │   ├── router/
│   │   ├── theme/
│   │   └── utils/
│   ├── features/       # Modular business logic and UI components
│   │   ├── auth/       # Authentication, Login, Signup, Splash
│   │   ├── calendar/   # Event scheduling and management
│   │   ├── profile/    # User identity and profile settings
│   │   ├── settings/   # Theme and application configuration
│   │   ├── stats/      # Productivity analytics dashboard
│   │   └── tasks/      # Core task management (CRUD, Reorder)
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
Project Version: 1.6.0
