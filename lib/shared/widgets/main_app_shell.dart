import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppShell extends StatelessWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    // Map current location to index
    int getCurrentIndex() {
      if (location == '/calendar') return 1;
      if (location == '/stats') return 2;
      if (location == '/profile') return 3;
      return 0; // Default to Tasks
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getCurrentIndex(),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/calendar'); break;
            case 2: context.go('/stats'); break;
            case 3: context.go('/profile'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
