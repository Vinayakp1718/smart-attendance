import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/role.dart';
import '../../features/auth/auth_controller.dart';
import '../widgets/ai_chatbot_widget.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/employees')) return 1;
    if (location.startsWith('/attendance')) return 2;
    if (location.startsWith('/leave')) return 3;
    if (location.startsWith('/holidays')) return 4;
    if (location.startsWith('/reports')) return 5;
    if (location.startsWith('/payroll')) return 6;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/employees');
        break;
      case 2:
        context.go('/attendance');
        break;
      case 3:
        context.go('/leave');
        break;
      case 4:
        context.go('/holidays');
        break;
      case 5:
        context.go('/reports');
        break;
      case 6:
        context.go('/payroll');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final int selectedIndex = _getSelectedIndex(context);
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    final bool isEmployee = user.role == UserRole.employee;

    // Define menu items
    final List<_NavigationItem> items = [
      _NavigationItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Dashboard',
      ),
      if (!isEmployee)
        _NavigationItem(
          icon: Icons.people_outline,
          selectedIcon: Icons.people,
          label: 'Employees',
        ),
      _NavigationItem(
        icon: Icons.fingerprint_outlined,
        selectedIcon: Icons.fingerprint,
        label: 'Attendance',
      ),
      _NavigationItem(
        icon: Icons.date_range_outlined,
        selectedIcon: Icons.date_range,
        label: 'Leaves',
      ),
      _NavigationItem(
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month,
        label: 'Holidays',
      ),
      if (!isEmployee)
        _NavigationItem(
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
          label: 'Reports',
        ),
      if (!isEmployee)
        _NavigationItem(
          icon: Icons.payments_outlined,
          selectedIcon: Icons.payments,
          label: 'Payroll',
        ),
    ];

    // Readjust index if index has skipped items for employees
    int adjustedSelectedIndex = selectedIndex;
    if (isEmployee) {
      // Index mapping for employees:
      // 0 (dashboard) -> 0
      // 2 (attendance) -> 1
      // 3 (leave) -> 2
      // 4 (holidays) -> 3
      if (selectedIndex == 2) adjustedSelectedIndex = 1;
      if (selectedIndex == 3) adjustedSelectedIndex = 2;
      if (selectedIndex == 4) adjustedSelectedIndex = 3;
    }

    Widget drawerContent() {
      return Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? AppConstants.surfaceDark : AppConstants.primaryColor,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user.profilePhoto != null
                  ? NetworkImage(user.profilePhoto!)
                  : null,
              child: user.profilePhoto == null
                  ? Text(
                      '${user.firstName[0]}${user.lastName[0]}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  : null,
            ),
            accountName: Text('${user.firstName} ${user.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(user.email),
          ),
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            // Map index back to go router routes
            int actualIndex = idx;
            if (isEmployee) {
              if (idx == 1) actualIndex = 2;
              if (idx == 2) actualIndex = 3;
              if (idx == 3) actualIndex = 4;
            }

            return ListTile(
              leading: Icon(selectedIndex == actualIndex ? item.selectedIcon : item.icon),
              title: Text(item.label),
              selected: selectedIndex == actualIndex,
              onTap: () {
                if (!isDesktop) Navigator.pop(context); // Close drawer
                _onItemTapped(actualIndex, context);
              },
            );
          }),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppConstants.dangerColor),
            title: const Text('Logout', style: TextStyle(color: AppConstants.dangerColor)),
            onTap: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return Scaffold(
      appBar: !isDesktop
          ? AppConstants.buildBrandingAppBar(
              context: context,
              title: items[isEmployee 
                  ? (adjustedSelectedIndex == 1 ? 2 : (adjustedSelectedIndex == 2 ? 3 : (adjustedSelectedIndex == 3 ? 4 : adjustedSelectedIndex))) 
                  : selectedIndex].label,
            )
          : null,
      drawer: !isDesktop ? Drawer(child: drawerContent()) : null,
      body: Stack(
        children: [
          Row(
            children: [
              if (isDesktop) ...[
                // Side Menu Sidebar for Desktop
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: isDark ? AppConstants.surfaceDark : Colors.white,
                    border: Border(
                      right: BorderSide(
                        color: isDark ? AppConstants.borderDark : AppConstants.borderLight,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // App Branding Logo
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ISG',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ISG eSolutions',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'Pvt Ltd',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppConstants.textSecondaryDark : Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      
                      // Menu Items List
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemBuilder: (context, idx) {
                            final item = items[idx];
                            int actualIndex = idx;
                            if (isEmployee) {
                              if (idx == 1) actualIndex = 2;
                              if (idx == 2) actualIndex = 3;
                              if (idx == 3) actualIndex = 4;
                            }
                            
                            final isSelected = selectedIndex == actualIndex;
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: InkWell(
                                onTap: () => _onItemTapped(actualIndex, context),
                                borderRadius: BorderRadius.circular(12),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppConstants.primaryColor.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected ? item.selectedIcon : item.icon,
                                        color: isSelected ? AppConstants.primaryColor : (isDark ? AppConstants.textSecondaryDark : AppConstants.textSecondaryLight),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        item.label,
                                        style: TextStyle(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected ? AppConstants.primaryColor : (isDark ? AppConstants.textPrimaryDark : AppConstants.textPrimaryLight),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // User Profile Box at bottom
                      const Divider(indent: 16, endIndent: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: user.profilePhoto != null
                                  ? NetworkImage(user.profilePhoto!)
                                  : null,
                              child: user.profilePhoto == null
                                  ? Text('${user.firstName[0]}${user.lastName[0]}')
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    user.role.displayName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppConstants.textSecondaryDark : AppConstants.textSecondaryLight,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout, color: AppConstants.dangerColor, size: 20),
                              onPressed: () {
                                ref.read(authControllerProvider.notifier).logout();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Main Work Area Widget
              Expanded(
                child: widget.child,
              ),
            ],
          ),
          const AIChatbotWidget(),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? BottomNavigationBar(
              currentIndex: adjustedSelectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppConstants.primaryColor,
              unselectedItemColor: isDark ? AppConstants.textSecondaryDark : AppConstants.textSecondaryLight,
              onTap: (idx) {
                int actualIndex = idx;
                if (isEmployee) {
                  if (idx == 1) actualIndex = 2;
                  if (idx == 2) actualIndex = 3;
                  if (idx == 3) actualIndex = 4;
                }
                _onItemTapped(actualIndex, context);
              },
              items: items
                  .map((item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        activeIcon: Icon(item.selectedIcon),
                        label: item.label,
                      ))
                  .toList(),
            )
          : null,
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
