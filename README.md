# Taskmaster

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/Riverpod-4A148C?style=for-the-badge&logo=riverpod&logoColor=white)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Hive-FFAB00?style=for-the-badge&logo=hive&logoColor=white)](https://pub.dev/packages/hive)

Taskmaster is a premium, high-performance life management application built with Flutter. It provides a centralized hub for organizing tasks, managing schedules, and gaining actionable insights into personal productivity through advanced analytics.

Designed with a focus on **professional aesthetics** and an **offline-first reliable experience**, Taskmaster combines high-end UI design with robust local data persistence.

## Premium UI & UX

*   **Ambient Background**: A dynamic, glassmorphism-inspired ambient background that responds to your app's theme and depth.
*   **Immersive Splash Screen**: A cinematic 3-second initializing sequence with branded animations and progress tracking.
*   **Glassmorphism Effects**: Modern UI components with subtle transparency and blur effects for a premium "Glass" feel.
*   **Theme Continuity**: Seamless switching between premium light and dark modes with persistent styling.

## Core Features

### Task Management
*   **Full CRUD Lifecycle**: Create, Read, Update, and Delete tasks with a polished interface.
*   **Interactive Modal**: Add or edit tasks via a unified glassmorphic modal.
*   **Drag-and-Drop Reordering**: Intuitive list management with native reorderable handles.
*   **Advanced Filtering**: Organize work efficiently by status (All, Upcoming, Completed).
*   **Safety Mechanisms**: Long-press confirmation dialogs to prevent accidental deletions.

### Calendar & Scheduling
*   **Visual Schedule**: A unified view of all time-sensitive obligations and events for a selected day.
*   **Event Refinement**: Tap an event to edit details or long-press to delete.
*   **Completion Tracking**: Mark events as completed with visual strikethrough and reduced opacity.
*   **Dynamic Categories**: Custom event categories with a rich palette of accent colors.

### Analytics & Insights
*   **Productivity Trends**: Professional-grade graphical representations of task completion performance.
*   **Completion Metrics**: Real-time calculation of your task and event productivity ratios.

### Offline-First Architecture
*   **Hive Persistence**: All tasks and events are stored locally in a high-performance NoSQL database. No internet required for core functionality.
*   **Zero Data Loss**: Progress is saved instantly and persists across application restarts.

---

## Technical Stack

The application leverages a modern, reactive architecture and best-in-class libraries within the Flutter ecosystem.

| Component | Technology | Role |
| :--- | :--- | :--- |
| Framework | Flutter | Cross-platform UI development |
| Language | Dart | Type-safe, high-performance logic |
| State Management | Riverpod | Robust, compile-time safe reactive states |
| Local Database | **Hive** | Blazing fast NoSQL storage for offline persistence |
| Navigation | GoRouter | Declarative routing for complex navigation flows |
| Cloud Services | Firebase | (Future Implementation) Auth, Cloud Sync, and Notifications |
| Visualization | FL Chart | Professional data visualization and analytics |

---

## Project Documentation

For deeper technical insights, refer to the [app_info/](file:///c:/Users/DHANANJAY/Flutter/taskmaster/app_info/) directory:

- **[explanation.txt](file:///c:/Users/DHANANJAY/Flutter/taskmaster/app_info/explanation.txt)**: Comprehensive architectual guide, file-by-file importance, and screen functionalities.
- **[firebase_benefits.txt](file:///c:/Users/DHANANJAY/Flutter/taskmaster/app_info/firebase_benefits.txt)**: Strategic roadmap for cloud integration and its benefits.

---

## Getting Started

### Prerequisites

*   Flutter SDK (^3.12.0)
*   Dart SDK
*   (Optional) Firebase CLI (for cloud features)

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/dhananjaysaini44/Life_manager_V2.git
    cd taskmaster
    ```

2.  Install dependencies:
    ```bash
    flutter pub get
    ```

3.  Generate Code:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  Run the application:
    ```bash
    flutter run
    ```

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.
