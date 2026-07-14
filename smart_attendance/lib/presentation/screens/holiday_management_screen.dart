import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/role.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/holidays/holidays_controller.dart';

class HolidayManagementScreen extends ConsumerWidget {
  const HolidayManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(holidaysControllerProvider);
    final user = ref.watch(authControllerProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isEmployee = user.role == UserRole.employee;

    return Scaffold(
      appBar: AppConstants.buildBrandingAppBar(
        context: context,
        title: 'Holidays & Workweeks',
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(holidaysControllerProvider.notifier).loadHolidaysData(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              final childContent = [
                // Weekend config card
                _buildWeekendConfigCard(context, state, ref, isEmployee, isDark),
                const SizedBox(height: 24),
                // Holiday list card
                _buildHolidaysCard(context, state, ref, isEmployee, isDark),
              ];

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: state.isLoading && state.holidays.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: childContent[0]),
                              const SizedBox(width: 24),
                              Expanded(flex: 3, child: childContent[2]),
                            ],
                          )
                        : ListView(
                            children: [
                              childContent[0],
                              const SizedBox(height: 24),
                              childContent[2],
                            ],
                          ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWeekendConfigCard(
    BuildContext context,
    dynamic state,
    WidgetRef ref,
    bool isEmployee,
    bool isDark,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Weekly Off Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toggle weekly off days. These configurations will automatically offset payroll summaries.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Saturday weekly off', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Check-ins will be optional on Saturdays.'),
              value: state.saturdayOff,
              activeThumbColor: AppConstants.primaryColor,
              onChanged: isEmployee
                  ? null
                  : (val) {
                      ref.read(holidaysControllerProvider.notifier).updateWeekendConfig(
                            saturdayOff: val,
                            sundayOff: state.sundayOff,
                          );
                    },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Sunday weekly off', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Check-ins are disabled/weekly off by default.'),
              value: state.sundayOff,
              activeThumbColor: AppConstants.primaryColor,
              onChanged: isEmployee
                  ? null
                  : (val) {
                      ref.read(holidaysControllerProvider.notifier).updateWeekendConfig(
                            saturdayOff: state.saturdayOff,
                            sundayOff: val,
                          );
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHolidaysCard(
    BuildContext context,
    dynamic state,
    WidgetRef ref,
    bool isEmployee,
    bool isDark,
  ) {
    final holidays = state.holidays;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Holidays List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (!isEmployee)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 44),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Holiday'),
                    onPressed: () => _showHolidayDialog(context, ref, null),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            
            holidays.isEmpty
                ? const SizedBox(
                    height: 200,
                    child: Center(child: Text('No national holidays configured.')),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: holidays.length,
                    itemBuilder: (context, idx) {
                      final h = holidays[idx];
                      final date = parseFlexibleDate(h.holidayDate);
                      final formattedDate = DateFormat('MMM dd, yyyy').format(date);
                      final dayName = DateFormat('EEEE').format(date);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppConstants.secondaryColor.withValues(alpha: 0.1),
                                child: const Icon(Icons.celebration, color: AppConstants.secondaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      h.holidayName,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$formattedDate ($dayName) • ${h.description}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isEmployee) ...[
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.amber),
                                  onPressed: () => _showHolidayDialog(context, ref, h),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppConstants.dangerColor),
                                  onPressed: () => ref.read(holidaysControllerProvider.notifier).deleteHoliday(h.holidayId),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showHolidayDialog(BuildContext context, WidgetRef ref, dynamic h) {
    final formKey = GlobalKey<FormState>();
    final isEdit = h != null;

    final nameController = TextEditingController(text: h?.holidayName ?? '');
    final descController = TextEditingController(text: h?.description ?? '');
    DateTime selectedDate = h != null ? parseFlexibleDate(h.holidayDate) : DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Holiday' : 'Add Holiday'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Holiday Name'),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                        TextButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              setState(() => selectedDate = date);
                            }
                          },
                          child: const Text('Select Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                    
                    bool success;
                    if (isEdit) {
                      success = await ref.read(holidaysControllerProvider.notifier).updateHoliday(
                            h.holidayId,
                            nameController.text,
                            dateStr,
                            descController.text,
                          );
                    } else {
                      success = await ref.read(holidaysControllerProvider.notifier).addHoliday(
                            nameController.text,
                            dateStr,
                            descController.text,
                          );
                    }

                    if (success && context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

DateTime parseFlexibleDate(String dateStr) {
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    final cleaned = dateStr.trim();
    final datePart = cleaned.split(' ')[0];
    final parts = datePart.split('/');
    if (parts.length == 3) {
      final p0 = int.tryParse(parts[0]);
      final p1 = int.tryParse(parts[1]);
      final p2 = int.tryParse(parts[2]);
      if (p0 != null && p1 != null && p2 != null) {
        if (p0 > 12) {
          return DateTime(p2, p1, p0);
        }
        if (p1 > 12) {
          return DateTime(p2, p0, p1);
        }
        return DateTime(p2, p1, p0);
      }
    }
    return DateTime.now();
  }
}
