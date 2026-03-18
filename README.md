# Taskmaster

Taskmaster is a high-fidelity productivity suite developed with Flutter, designed to provide a sophisticated balance of task management, calendar coordination, and productivity analytics. The application adheres to a premium design philosophy, utilizing modern UI techniques to deliver an immersive "Ambient" user experience.

## Product Overview

The application is engineered for users who require a reliable and visually refined tool for managing daily professional and personal commitments. By leveraging a hybrid data architecture, Taskmaster ensures that productivity remains uninterrupted by network conditions, while offering robust cloud synchronization for multi-device consistency.

## Principal Features

### Ambient Design System
Taskmaster implements a contemporary design language characterized by glassmorphism and dynamic gradients. The user interface features theme-aware ambient backgrounds that intelligently transition between light and dark modes, reducing visual fatigue and enhancing engagement.

### Hybrid Synchronization Engine
The system utilizes a dual-layered persistence strategy:
- **Local Persistence**: Powered by Hive, ensuring near-zero latency for all data operations.
- **Cloud Synchronization**: Integrated with Firebase Firestore to provide real-time data redundancy and cross-platform synchronization.

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

Taskmaster is built upon a modern, reactive tech stack:
- **Framework**: Flutter (Advanced UI Rendering)
- **State Management**: Riverpod (Declarative and Type-Safe State)
- **Local Storage**: Hive NoSQL (Offline-First Performance)
- **Cloud Infrastructure**: Firebase Firestore (Real-Time Data Sync)
- **Routing Engine**: GoRouter (Declarative Navigation Patterns)

## Architectural Pattern

The project follows a Feature-First Layered Architecture, promoting high modularity and clear separation of concerns:
- **Domain Layer**: Core business models and logic.
- **Data Layer**: Repository implementations handling the hybrid storage bridge.
- **Presentation Layer**: UI components and Riverpod providers.

## Project Structure

- `lib/core`: Global configurations, theme extensions, and application-wide utilities.
- `lib/features`: Modular directories containing logic for authentication, tasks, calendar, analytics, and profile management.
- `lib/shared`: Reusable infrastructure and "Ambient" UI assets.
- `app_info/`: Comprehensive technical documentation and architectural guides.

## Installation and Deployment

### Prerequisites
- Flutter SDK (Latest Stable Channel)
- Dart SDK
- Configured development environment for target platforms (Web, Android, iOS, or Desktop).

### Execution
1. **Initialize Project**:
   ```bash
   flutter pub get
   ```

2. **Generate Dependencies**:
   The project requires code generation for Hive and Riverpod components.
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Launch Application**:
   ```bash
   flutter run
   ```

## Documentation

For an in-depth technical analysis, directory mapping, and detailed screen functionalities, please consult the [explanation.txt](file:///c:/Users/DHANANJAY/Flutter/taskmaster/app_info/explanation.txt) file located in the `app_info/` directory.

---

Maintainer: [Dhananjay Saini](https://github.com/dhananjaysaini44)  
Project Version: 1.5.0
