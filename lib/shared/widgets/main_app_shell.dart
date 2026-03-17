import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'ambient_background.dart';

class MainAppShell extends StatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  late PageController _pageController;

  final List<String> _routes = [
    '/',
    '/calendar',
    '/stats',
    '/profile',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getCurrentIndex(String location) {
    final index = _routes.indexOf(location);
    return index != -1 ? index : 0;
  }

  bool _isMainRoute(String location) {
    return _routes.contains(location);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(location);
    final isMainRoute = _isMainRoute(location);

    // Sync PageController with location if it changes externally
    if (_pageController.hasClients && _pageController.page?.round() != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(currentIndex);
        }
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          const AmbientBackground(),
          if (isMainRoute)
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                if (index != currentIndex) {
                  context.go(_routes[index]);
                }
              },
              children: const [
                TasksScreen(),
                CalendarScreen(),
                StatsScreen(),
                ProfileScreen(),
              ],
            )
          else
            widget.child,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          context.go(_routes[index]);
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
