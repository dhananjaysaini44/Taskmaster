# Taskmaster

Taskmaster is a high-performance, feature-rich life management application built with Flutter. It provides a centralized hub for organizing tasks, managing schedules, and gaining insights into personal productivity through advanced analytics.

Designed with a focus on professional aesthetics and seamless user experience, Taskmaster integrates multi-platform support with real-time data synchronization.

## Core Features

### Task Management
*   Complete task lifecycle including creation, categorization, and status tracking.
*   Advanced filtering systems to organize work by priority, project, and deadline.
*   Persistent state management for reliable task persistence across sessions.

### Calendar Integration
*   Unified view of all time-sensitive obligations and events.
*   Interactive scheduling interface for managing future commitments.
*   Dynamic synchronization with task deadlines for a comprehensive timeline.

### Analytics and Insights
*   Graphical representations of productivity trends.
*   Data-driven overviews of completed vs. pending objectives.
*   Performance metrics to help optimize personal time management.

### User Authentication
*   Secure identity management via Firebase Authentication.
*   Support for multiple authentication providers including Email/Password and Google Sign-In.
*   Scoped user profiles with private, encrypted data storage.

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
