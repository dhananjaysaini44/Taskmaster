import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/mindmap/presentation/mind_map_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'ambient_background.dart';
import 'minimal_app_bar.dart';
import 'app_drawer.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme_extension.dart';

class MainAppShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  late PageController _pageController;
  static int _lastMainIndex = 0;

  final List<String> _routes = ['/', '/tasks', '/calendar', '/mindmap', '/profile'];

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





  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final location = GoRouterState.of(context).uri.path;
    final trueIndex = _routes.indexOf(location);
    if (trueIndex != -1) {
      _lastMainIndex = trueIndex;
    }
    final currentIndex = _lastMainIndex;
    final isMainRoute = trueIndex != -1;
    final authState = ref.watch(authProvider).valueOrNull;
    final user = authState?.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );

    // Sync PageController with location if it changes externally
    if (_pageController.hasClients &&
        _pageController.page?.round() != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(currentIndex);
        }
      });
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: location == '/settings' ? null : MinimalAppBar(
        leading: isMainRoute
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: 'Menu',
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(_routes[_lastMainIndex]);
                  }
                },
                tooltip: 'Back',
              ),
        title: Text(
          'Taskmaster',
          style: GoogleFonts.goldman(
            textStyle: theme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primary,
            ),
          ),
        ),
        actions: [
          if (location == '/profile')
            IconButton(
              onPressed: () => context.push('/settings'),
              icon: Icon(Icons.settings_outlined, color: theme.primary),
              tooltip: 'Settings',
            )
          else
            IconButton(
              onPressed: () => context.push('/profile'),
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: theme.primary.withValues(alpha: 0.2),
                backgroundImage: (user != null &&
                        user.photoURL != null &&
                        user.photoURL!.isNotEmpty)
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: (user?.photoURL == null || user!.photoURL!.isEmpty)
                    ? Text(
                        user?.displayName?.isNotEmpty == true
                            ? user!.displayName![0].toUpperCase()
                            : user?.email?.isNotEmpty == true
                                ? user!.email![0].toUpperCase()
                                : '?',
                        style: TextStyle(
                          color: theme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              tooltip: 'Profile',
            ),
          const SizedBox(width: 8),
        ],
      ),
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
                HomeScreen(),
                TasksScreen(),
                CalendarScreen(),
                MindMapScreen(),
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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          context.go(_routes[index]);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hub_outlined),
            activeIcon: Icon(Icons.hub),
            label: 'Mind Flow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
