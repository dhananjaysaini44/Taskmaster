import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../core/router/router_keys.dart';

class MainAppShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  late PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const int _lastMainIndex = 0;
  final List<int> _history = [0];

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
    final currentIndex = trueIndex != -1 ? trueIndex : _lastMainIndex;
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        // 1. Check for open Drawer first
        final scaffoldState = _scaffoldKey.currentState;
        if (scaffoldState?.isDrawerOpen ?? false) {
          scaffoldState?.closeDrawer();
          return;
        }

        // 2. Check Root Navigator for modals (like AddTaskModal)
        final rootNav = rootNavigatorKey.currentState;
        if (rootNav?.canPop() == true) {
          rootNav?.pop();
          // If a modal was open, we ALSO move to the previous screen
          if (_history.length > 1) {
            _history.removeLast();
            final previousIndex = _history.last;
            context.go(_routes[previousIndex]);
          }
          return;
        }

        // 3. Check for sub-routes managed by GoRouter (like /settings)
        final shellNav = shellNavigatorKey.currentState;
        if (shellNav?.canPop() == true) {
          shellNav?.pop();
          return;
        }

        // 4. Back navigation through tab history
        if (_history.length > 1) {
          _history.removeLast();
          final previousIndex = _history.last;
          context.go(_routes[previousIndex]);
          return;
        }

        // 5. Fallback: Exit app
        SystemNavigator.pop();
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        appBar: location == '/settings' ? null : _buildAppBar(context, theme, location, isMainRoute, user),
        body: _buildBody(location, isMainRoute, currentIndex),
        bottomNavigationBar: _buildBottomNav(context, currentIndex),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppThemeExtension theme,
    String location,
    bool isMainRoute,
    dynamic user,
  ) {
    return MinimalAppBar(
      leading: isMainRoute
          ? null // AppBar automatically adds menu button if drawer exists
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
    );
  }

  Widget _buildBody(String location, bool isMainRoute, int currentIndex) {
    if (!isMainRoute) {
      return Stack(
        children: [
          const AmbientBackground(),
          widget.child,
        ],
      );
    }

    return Stack(
      children: [
        const AmbientBackground(),
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (index >= 0 && index < _routes.length) {
              if (_history.isEmpty || _history.last != index) {
                _history.add(index);
                if (_history.length > 20) _history.removeAt(0);
              }
              context.go(_routes[index]);
            }
          },
          children: [
            currentIndex == 0 ? widget.child : const HomeScreen(),
            currentIndex == 1 ? widget.child : const TasksScreen(),
            currentIndex == 2 ? widget.child : const CalendarScreen(),
            currentIndex == 3 ? widget.child : const MindMapScreen(),
            currentIndex == 4 ? widget.child : const ProfileScreen(),
          ],
        ),
      ],
    );
  }


  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
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
    );
  }
}
