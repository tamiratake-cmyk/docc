import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/pages/addNote_page.dart';
import 'package:flutter_application_1/app/pages/edit_notes_page.dart';
import 'package:flutter_application_1/app/pages/login_page.dart';
import 'package:flutter_application_1/app/pages/note_detail.dart';
import 'package:flutter_application_1/app/pages/notes_page.dart';
import 'package:flutter_application_1/app/pages/setting_page.dart';
import 'package:flutter_application_1/app/pages/signup_page.dart';
import 'package:flutter_application_1/app/screens/battery.dart';
import 'package:flutter_application_1/app/screens/home_page.dart';
import 'package:flutter_application_1/app/screens/user_page.dart';
import 'package:flutter_application_1/app/pages/camer_page.dart';
import 'package:flutter_application_1/app/pages/map_page.dart';
import 'package:flutter_application_1/data/services/auth_service.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:go_router/go_router.dart';

/// Responsive navigation using GoRouter's StatefulShellRoute.
/// - Mobile: Material 3 NavigationBar
/// - Tablet/Desktop: NavigationRail + optional Drawer
class AppRouter {
  static final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    refreshListenable: AuthService.instance,
    redirect: (context, state) {
      final isLoggedIn = AuthService.instance.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/add-note',
        name: 'add-note',
        builder: (context, state) => const AddNotePage(),
      ),
       GoRoute(
        path: '/view-note',
        name: 'view-note',
        builder: (context, state) {
          final note = state.extra as Note;
          return NoteDetailPage(note: note);
        },
      ),
       GoRoute(
        path: '/edit-note',
        name: 'edit-note',
        builder: (context, state) {
          final note = state.extra as Note;
          return EditNotesPage(note: note);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ResponsiveScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/user',
              name: 'user',
              builder: (context, state) => const UserPage(),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const UserPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(position: animation.drive(tween), child: child);
                },
              ),
            ),
          ]),
          // StatefulShellBranch(routes: [
          //   GoRoute(
          //     path: '/battery',
          //     name: 'battery',
          //     builder: (context, state) => BatteryLevelScreen(),
          //   ),
          // ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/notes',
              name: 'notes',
              builder: (context, state) => const NotesPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingPage(),
            ),
          ]),
          // StatefulShellBranch(routes: [
          //   GoRoute(
          //     path: '/camera',
          //     name: 'camera',
          //     builder: (context, state) => const CamerPage(),
          //   ),
          // ]),
          // StatefulShellBranch(routes: [
          //   GoRoute(
          //     path: '/map',
          //     name: 'map',
          //     builder: (context, state) => const MapPage(),
          //   ),

          // ]),
        ],
      ),
    ],
  );
}

class _ResponsiveScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _ResponsiveScaffold({required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onTap,
                  labelType: NavigationRailLabelType.selected,
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterLogo(size: 40),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('User'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.battery_std_outlined),
                      selectedIcon: Icon(Icons.battery_std),
                      label: Text('Battery'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.note_alt_outlined),
                      selectedIcon: Icon(Icons.note_alt),
                      label: Text('Notes'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.camera_alt_outlined),
                      selectedIcon: Icon(Icons.camera_alt),
                      label: Text('Camera'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.map_outlined),
                      selectedIcon: Icon(Icons.map),
                      label: Text('Map'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'User'),
              // NavigationDestination(icon: Icon(Icons.battery_full_outlined), selectedIcon: Icon(Icons.battery_full), label: 'Battery'),
              NavigationDestination(icon: Icon(Icons.note_alt_outlined), selectedIcon: Icon(Icons.note_alt), label: 'Notes'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
              // NavigationDestination(icon: Icon(Icons.camera_alt_outlined), selectedIcon: Icon(Icons.camera_alt), label: 'Camera'),
              // NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Map'),
            ],
          ),
        );
      },
    );
  }
}