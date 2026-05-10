import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/providers.dart';
import '../../features/setup/presentation/pages/setup_flow_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/tracking/presentation/pages/tracking_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/api_keys_page.dart';

/// Routes nommées de l'application.
abstract class AppRoutes {
  static const String setup = '/setup';
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String tracking = '/tracking';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String apiKeys = '/settings/api-keys';
}

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: onboardingCompleted ? AppRoutes.home : AppRoutes.setup,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.setup,
        name: 'setup',
        pageBuilder: (context, state) => _buildPage(
          const SetupFlowPage(),
          state,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            redirect: (context, state) => AppRoutes.dashboard,
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => _buildPage(
              const DashboardPage(),
              state,
            ),
          ),
          GoRoute(
            path: AppRoutes.tracking,
            name: 'tracking',
            pageBuilder: (context, state) => _buildPage(
              const TrackingPage(),
              state,
            ),
          ),
          GoRoute(
            path: AppRoutes.history,
            name: 'history',
            pageBuilder: (context, state) => _buildPage(
              const HistoryPage(),
              state,
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => _buildPage(
              const SettingsPage(),
              state,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.apiKeys,
        name: 'apiKeys',
        pageBuilder: (context, state) =>
            _buildPage(const ApiKeysPage(), state),
      ),
    ],
  );
});

CustomTransitionPage<T> _buildPage<T>(Widget child, GoRouterState state) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      );
    },
  );
}

/// Shell principal avec la barre de navigation.
class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexFromLocation(location);

    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i) => _navigate(context, i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline_rounded),
          selectedIcon: Icon(Icons.add_circle_rounded),
          label: 'Suivre',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history_rounded),
          label: 'Historique',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_rounded),
          label: 'Paramètres',
        ),
      ],
    );
  }

  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoutes.tracking)) return 1;
    if (location.startsWith(AppRoutes.history)) return 2;
    if (location.startsWith(AppRoutes.settings)) return 3;
    return 0;
  }

  void _navigate(BuildContext context, int index) {
    final routes = [
      AppRoutes.dashboard,
      AppRoutes.tracking,
      AppRoutes.history,
      AppRoutes.settings,
    ];
    context.go(routes[index]);
  }
}
