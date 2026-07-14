import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Controllers & Roles
import '../features/auth/auth_controller.dart';
import '../domain/entities/role.dart';

// Screens
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_shell.dart';
import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/employee_management_screen.dart';
import '../presentation/screens/attendance_screen.dart';
import '../presentation/screens/leave_management_screen.dart';
import '../presentation/screens/holiday_management_screen.dart';
import '../presentation/screens/reports_screen.dart';
import '../presentation/screens/payroll_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final loggedIn = authState.user != null;
      final loggingIn = state.matchedLocation == '/login';

      // 1. If not logged in and not heading to login, redirect to login
      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }

      // 2. If logged in and heading to login, redirect to dashboard
      if (loggingIn) {
        return '/dashboard';
      }

      // 3. Role-based Route Protection
      final role = authState.user!.role;
      final destination = state.matchedLocation;

      if (role == UserRole.employee) {
        final adminOnlyRoutes = ['/employees', '/reports', '/payroll'];
        if (adminOnlyRoutes.any((route) => destination.startsWith(route))) {
          return '/dashboard'; // Block employees from administrative sections
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/employees',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EmployeeManagementScreen(),
            ),
          ),
          GoRoute(
            path: '/attendance',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AttendanceScreen(),
            ),
          ),
          GoRoute(
            path: '/leave',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LeaveManagementScreen(),
            ),
          ),
          GoRoute(
            path: '/holidays',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HolidayManagementScreen(),
            ),
          ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReportsScreen(),
            ),
          ),
          GoRoute(
            path: '/payroll',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PayrollScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
