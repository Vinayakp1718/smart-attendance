import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../features/dashboard/dashboard_controller.dart';
import '../../features/auth/auth_controller.dart';
import '../../domain/entities/role.dart';
import '../widgets/premium_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsState = ref.watch(dashboardControllerProvider);
    final user = ref.watch(authControllerProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(dashboardControllerProvider.notifier).loadMetrics(),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome back, ${user?.firstName ?? "User"} • ${user?.role.displayName ?? ""}',
                        style: TextStyle(
                          color: isDark ? AppConstants.textSecondaryDark : AppConstants.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => ref.read(dashboardControllerProvider.notifier).loadMetrics(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              metricsState.when(
                loading: () => const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SizedBox(
                  height: 200,
                  child: Center(
                    child: Text('Error loading dashboard: $error', style: const TextStyle(color: AppConstants.dangerColor)),
                  ),
                ),
                data: (metrics) {
                  final bool isEmployee = user?.role == UserRole.employee;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stat Cards Grid
                      _buildMetricsGrid(context, metrics, isEmployee),
                      const SizedBox(height: 32),

                      // Birthdays Section (for everyone)
                      _buildBirthdaysSection(context, metrics['birthdays'] ?? [], isDark),

                      // Teammates Today Attendance Section (for everyone)
                      Text(
                        "Today's Teammates Status",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildTeammatesAttendanceWidget(context, metrics['presentList'] ?? [], metrics['absentList'] ?? [], isDark),
                      const SizedBox(height: 32),

                      // Charts Section (Hide for regular Employee as it represents organization metrics)
                      if (!isEmployee) ...[
                        Text(
                          'Organization Analytics',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth >= 800) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildAttendanceTrendChart(context, metrics['attendanceTrend'], isDark),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 2,
                                    child: _buildDeptWiseChart(context, metrics['departmentDistribution'], isDark),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  _buildAttendanceTrendChart(context, metrics['attendanceTrend'], isDark),
                                  const SizedBox(height: 24),
                                  _buildDeptWiseChart(context, metrics['departmentDistribution'], isDark),
                                ],
                              );
                            }
                          },
                        ),
                      ] else ...[
                        // Custom Employee Panel for local users
                        _buildEmployeeQuickLinks(context),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, Map<String, dynamic> metrics, bool isEmployee) {
    final width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width < 600 ? 2 : (width < 1200 ? 3 : 5);

    final List<_MetricItem> items = isEmployee 
        ? [
            _MetricItem(
              title: 'Total Balance',
              value: '38 Days',
              icon: Icons.date_range,
              color: AppConstants.primaryColor,
            ),
            _MetricItem(
              title: 'Present Today',
              value: metrics['presentToday'] > 0 ? 'Yes' : 'No',
              icon: Icons.fingerprint,
              color: AppConstants.accentColor,
            ),
            _MetricItem(
              title: 'Pending Leaves',
              value: '${metrics['pendingLeaves']}',
              icon: Icons.hourglass_empty,
              color: AppConstants.warningColor,
            ),
          ]
        : [
            _MetricItem(
              title: 'Total Employees',
              value: '${metrics['totalEmployees']}',
              icon: Icons.people,
              color: AppConstants.primaryColor,
            ),
            _MetricItem(
              title: 'Present Today',
              value: '${metrics['presentToday']}',
              icon: Icons.check_circle_outline,
              color: AppConstants.accentColor,
            ),
            _MetricItem(
              title: 'Absent Today',
              value: '${metrics['absentToday']}',
              icon: Icons.cancel_outlined,
              color: AppConstants.dangerColor,
            ),
            _MetricItem(
              title: 'Late Today',
              value: '${metrics['lateToday']}',
              icon: Icons.alarm,
              color: AppConstants.warningColor,
            ),
            _MetricItem(
              title: 'Pending Leaves',
              value: '${metrics['pendingLeaves']}',
              icon: Icons.hourglass_empty,
              color: AppConstants.infoColor,
            ),
          ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, idx) {
        final item = items[idx];
        return PremiumCard(
          borderColor: item.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppConstants.textSecondaryDark : AppConstants.textSecondaryLight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.color, size: 18),
                  ),
                ],
              ),
              Text(
                item.value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceTrendChart(BuildContext context, List<dynamic> trend, bool isDark) {
    if (trend.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Trend (Last 7 Days)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: trend.map((e) => (e['present'] as int) + (e['absent'] as int)).reduce((a, b) => a > b ? a : b).toDouble() + 2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final int index = value.toInt();
                          if (index < 0 || index >= trend.length) return const Text('');
                          final dateStr = trend[index]['date'] as String;
                          final date = DateTime.parse(dateStr);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: trend.asMap().entries.map((entry) {
                    final int idx = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: idx,
                      barRods: [
                        BarChartRodData(
                          toY: (data['present'] as int).toDouble(),
                          color: AppConstants.accentColor,
                          width: 14,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                        BarChartRodData(
                          toY: (data['absent'] as int).toDouble(),
                          color: AppConstants.dangerColor,
                          width: 14,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Present Today', AppConstants.accentColor),
                const SizedBox(width: 24),
                _buildLegendItem('Absent Today', AppConstants.dangerColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeptWiseChart(BuildContext context, List<dynamic> distribution, bool isDark) {
    if (distribution.isEmpty) return const SizedBox();

    final List<Color> colors = [
      AppConstants.primaryColor,
      AppConstants.secondaryColor,
      AppConstants.accentColor,
      AppConstants.warningColor,
      AppConstants.infoColor,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Employee Share by Dept',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(enabled: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: distribution.asMap().entries.map((entry) {
                    final int idx = entry.key;
                    final data = entry.value;
                    final count = data['count'] as int;
                    final color = colors[idx % colors.length];

                    return PieChartSectionData(
                      value: count.toDouble(),
                      color: color,
                      title: '$count',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: distribution.asMap().entries.map((entry) {
                final int idx = entry.key;
                final data = entry.value;
                final dept = data['department'] as String;
                final color = colors[idx % colors.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, color: color),
                      const SizedBox(width: 8),
                      Text(dept, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildEmployeeQuickLinks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.fingerprint, color: Colors.white),
                ),
                title: const Text('Punch In / Punch Out console'),
                subtitle: const Text('Register today\'s attendance using GPS location verification'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  // Direct to attendance tab
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Head over to the Attendance menu in the sidebar/bottom-bar to check in/out!'))
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.date_range, color: Colors.white),
                ),
                title: const Text('Apply for Leave'),
                subtitle: const Text('Check your available leave balances and submit a new request'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Head over to the Leaves menu in the sidebar/bottom-bar to apply!'))
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBirthdaysSection(BuildContext context, List<dynamic> birthdays, bool isDark) {
    if (birthdays.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF312E81), const Color(0xFF581C87)] 
              : [const Color(0xFFEEF2FF), const Color(0xFFF3E8FF)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark ? const Color(0xFF4338CA) : const Color(0xFFE0E7FF),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cake, color: Colors.purpleAccent, size: 24),
                const SizedBox(width: 12),
                Text(
                  "Today's Birthdays! 🎂🎉",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF312E81),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: birthdays.length,
                itemBuilder: (context, idx) {
                  final b = birthdays[idx];
                  final String name = '${b['firstName']} ${b['lastName']}';
                  final String dept = b['department'] ?? '';
                  final String code = b['employeeCode'] ?? '';
                  
                  return Card(
                    margin: const EdgeInsets.only(right: 16),
                    color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: b['profilePhoto'] != null ? NetworkImage(b['profilePhoto']!) : null,
                            child: b['profilePhoto'] == null 
                                ? Text(name.substring(0, 1).toUpperCase()) 
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                '$dept ($code)',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeammatesAttendanceWidget(
      BuildContext context, List<dynamic> presentList, List<dynamic> absentList, bool isDark) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    final presentCard = PremiumCard(
      borderColor: AppConstants.accentColor,
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Present Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.accentColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppConstants.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${presentList.length} Active',
                    style: const TextStyle(color: AppConstants.accentColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (presentList.isEmpty)
              const SizedBox(
                height: 150,
                child: Center(
                  child: Text('No employees checked in yet today.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
              )
            else
              SizedBox(
                height: 250,
                child: ListView.separated(
                  itemCount: presentList.length,
                  separatorBuilder: (_, __) => const Divider(height: 12),
                  itemBuilder: (context, idx) {
                    final p = presentList[idx];
                    final name = '${p['firstName']} ${p['lastName']}';
                    final dept = p['department'] ?? '';
                    final checkIn = p['checkInTime'] != null
                        ? DateTime.parse(p['checkInTime']).toLocal().toString().substring(11, 16)
                        : '--:--';
                    final status = p['status'] ?? 'Present';
                    
                    Color statColor = AppConstants.accentColor;
                    if (status == 'Late') statColor = AppConstants.warningColor;
                    if (status == 'Half Day') statColor = AppConstants.infoColor;

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          child: Text(name.substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text('$dept • In at $checkIn', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: statColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      );

    final absentCard = PremiumCard(
      borderColor: AppConstants.dangerColor,
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Absent Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.dangerColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppConstants.dangerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${absentList.length} Out',
                    style: const TextStyle(color: AppConstants.dangerColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (absentList.isEmpty)
              const SizedBox(
                height: 150,
                child: Center(
                  child: Text('Perfect attendance today! No one is absent.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
              )
            else
              SizedBox(
                height: 250,
                child: ListView.separated(
                  itemCount: absentList.length,
                  separatorBuilder: (_, __) => const Divider(height: 12),
                  itemBuilder: (context, idx) {
                    final p = absentList[idx];
                    final name = '${p['firstName']} ${p['lastName']}';
                    final dept = p['department'] ?? '';
                    
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppConstants.dangerColor.withValues(alpha: 0.1),
                          child: Text(
                            name.substring(0, 1).toUpperCase(), 
                            style: const TextStyle(fontSize: 12, color: AppConstants.dangerColor, fontWeight: FontWeight.bold)
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(dept, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: presentCard),
          const SizedBox(width: 24),
          Expanded(child: absentCard),
        ],
      );
    } else {
      return Column(
        children: [
          presentCard,
          const SizedBox(height: 16),
          absentCard,
        ],
      );
    }
  }
}

class _MetricItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}
