# Taskmaster

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

Taskmaster is a premium, high-performance life management application built with Flutter. It provides a centralized hub for organizing tasks, managing schedules, and gaining actionable insights into personal productivity through advanced analytics.

Designed with a focus on **professional aesthetics** and a **seamless user experience**, Taskmaster integrates multi-platform support with real-time data synchronization.

## ✨ Premium UI & UX

*   **Ambient Background**: A dynamic, glassmorphism-inspired ambient background that responds to your app's theme and depth.
*   **Immersive Splash Screen**: A high-end initializing sequence with branded animations and progress tracking.
*   **Glassmorphism Effects**: Modern UI components with subtle transparency and blur effects for a premium feel.

## 🛠️ Core Features

### Task Management
*   **Interactive Task Lifecycle**: Complete control over task creation, categorization, and status tracking.
*   **Drag-and-Drop Reordering**: Intuitive list management with native-feel reorderable gestures.
*   **Selective Deletion**: Long-press safety mechanisms for task removal to prevent accidental data loss.
*   **Advanced Filtering**: Organize work efficiently by status (All, Upcoming, Completed).

### Calendar & Scheduling
*   **Interactive Timeline**: A unified view of all time-sensitive obligations and events.
*   **Deadlines Integration**: Dynamic synchronization between your task list and calendar view.

### Analytics & Insights
*   **Productivity Trends**: Professional-grade graphical representations of your performance.
*   **Data-Driven Overviews**: Visual summaries of completed vs. pending objectives.

### Secure Authentication
*   **Identity Management**: Secure sign-in via Firebase (Email/Password & Google Sign-In).
*   **Private Profiles**: Encrypted user data and scoped storage for ultimate privacy.

---

## Technical Stack

The application leverages a modern, reactive architecture and best-in-class libraries within the Flutter ecosystem.

| Component | Technology | Role |
| :--- | :--- | :--- |
| Framework | Flutter | Cross-platform UI development |
| Language | Dart | Type-safe, high-performance logic |
| State Management | Riverpod | Robust, compile-time safe reactive states |
| Backend | Firebase | Real-time database, Auth, and Hosting |
| Navigation | GoRouter | Declarative routing for complex navigation flows |
| Database | Cloud Firestore | Scalable NoSQL cloud document storage |
| Persistence | Shared Preferences | Local storage for application settings |
| Visualization | FL Chart | Professional data visualization and analytics |

---

## Project Structure

Taskmaster follows a feature-based architectural pattern to ensure scalability and maintainability.

```text
lib/
├── core/           # Common components, themes, and application foundations
├── features/       # Independent functional modules
│   ├── auth/       # Identity and authentication logic
│   ├── calendar/   # Interactive scheduling systems
│   ├── profile/    # User settings and personalized data
│   ├── stats/      # Analytics and data visualization
│   └── tasks/      # Core task lifecycle management
├── shared/         # Reusable widgets and utilities across features
└── main.dart       # Application entry point
```

---

## Getting Started

### Prerequisites

*   Flutter SDK (^3.12.0)
*   Dart SDK
*   Firebase Project (Web, Android, iOS configurations)

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

3.  Configure Firebase:
    Refer to the detailed [Setup Guide](file:///c:/Users/DHANANJAY/Flutter/taskmaster/SETUP.md) for full instructions on linking your Firebase project and generating `firebase_options.dart`.

4.  Run the application:
    ```bash
    flutter run
    ```

---

## Quality Assurance

To maintain high code quality and consistency across the codebase, ensure all checks pass before contributions:

*   **Static Analysis**: `dart analyze .`
*   **Testing**: `flutter test`
*   **Formatting**: `dart format .`

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.
