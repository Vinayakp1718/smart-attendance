import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../features/attendance/attendance_controller.dart';
import '../../features/attendance/attendance_state.dart';
import '../../core/services/providers.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  String _selectedLocationType = 'Office';

  void _copyMapLink(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Maps link copied to clipboard! Paste it in your browser.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppConstants.buildBrandingAppBar(
        context: context,
        title: 'Punch Console & GPS',
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // refresh data and GPS
            await ref.read(attendanceControllerProvider.notifier).refreshGpsLocation();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 800;
              final childContent = [
                // Check In/Out Console Card
                _buildClockConsoleCard(context, state, isDark),
                const SizedBox(height: 20),
                // GPS status Card
                _buildGpsCard(context, state, isDark),
              ];

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: childContent[0]),
                          const SizedBox(width: 24),
                          Expanded(flex: 3, child: childContent[2]),
                        ],
                      )
                    else ...[
                      childContent[0],
                      const SizedBox(height: 24),
                      childContent[2],
                    ],
                    const SizedBox(height: 32),
                    // Attendance History list
                    Text(
                      'Attendance Log History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Card(
                        child: state.isLoading && state.history.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : state.history.isEmpty
                                ? const Center(child: Text('No attendance logs registered yet.'))
                                : ListView.separated(
                                    itemCount: state.history.length,
                                    separatorBuilder: (c, idx) => const Divider(),
                                    itemBuilder: (context, idx) {
                                      final log = state.history[idx];
                                      final checkInStr = log.checkInTime.toLocal().toString().substring(11, 16);
                                      final checkOutStr = log.checkOutTime != null
                                          ? log.checkOutTime!.toLocal().toString().substring(11, 16)
                                          : '--:--';
                                      
                                      // Get status color
                                      Color statusColor = AppConstants.primaryColor;
                                      if (log.status == 'Present') statusColor = AppConstants.accentColor;
                                      if (log.status == 'Late') statusColor = AppConstants.warningColor;
                                      if (log.status == 'Half Day') statusColor = AppConstants.infoColor;
                                      if (log.status == 'Absent') statusColor = AppConstants.dangerColor;

                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: statusColor.withValues(alpha: 0.1),
                                          child: Icon(Icons.fingerprint, color: statusColor),
                                        ),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              log.attendanceDate,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: statusColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                log.status,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          'In: $checkInStr | Out: $checkOutStr | Hours: ${log.workingHours} hrs | Mode: ${log.locationType}',
                                        ),
                                        trailing: log.latitude != 0.0
                                            ? IconButton(
                                                icon: const Icon(Icons.map_outlined, color: Colors.blue),
                                                tooltip: 'Open GPS Link',
                                                onPressed: () {
                                                  final link = ref.read(locationServiceProvider).getGoogleMapsLink(log.latitude, log.longitude);
                                                  _copyMapLink(context, link);
                                                },
                                              )
                                            : null,
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildClockConsoleCard(BuildContext context, AttendanceState state, bool isDark) {
    final rec = state.todayRecord;
    String clockInText = '--:--';
    String clockOutText = '--:--';
    String breakText = '0.00 hrs';
    String workingHrs = '0.00 hrs';

    if (rec != null) {
      clockInText = rec.checkInTime.toLocal().toString().substring(11, 16);
      if (rec.checkOutTime != null) {
        clockOutText = rec.checkOutTime!.toLocal().toString().substring(11, 16);
      }
      workingHrs = '${rec.workingHours} hrs';

      // Calculate break time
      if (rec.breakStartTime != null) {
        final DateTime end = rec.breakEndTime ?? DateTime.now();
        final minutes = end.difference(rec.breakStartTime!).inMinutes;
        breakText = '${(minutes / 60.0).toStringAsFixed(2)} hrs';
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Shift Clock Console',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Grid of times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeDisplayColumn('CHECK IN', clockInText, AppConstants.accentColor),
                _buildTimeDisplayColumn('CHECK OUT', clockOutText, AppConstants.dangerColor),
                _buildTimeDisplayColumn('BREAK TIME', breakText, AppConstants.warningColor),
                _buildTimeDisplayColumn('WORKING HOURS', workingHrs, AppConstants.primaryColor),
              ],
            ),
            const SizedBox(height: 28),

            // Location Type Selector
            if (!state.isCheckedIn) ...[
              const Text(
                'Select Work Mode / Location Type:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(value: 'Office', label: Text('Office'), icon: Icon(Icons.business)),
                  ButtonSegment<String>(value: 'Home', label: Text('Home'), icon: Icon(Icons.home)),
                  ButtonSegment<String>(value: 'Client Site', label: Text('Client'), icon: Icon(Icons.location_city)),
                ],
                selected: <String>{_selectedLocationType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedLocationType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

            // Display current status Banner
            if (state.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppConstants.dangerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: AppConstants.dangerColor, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // Check In Button
                if (!state.isCheckedIn)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.accentColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 52),
                    ),
                    icon: const Icon(Icons.login),
                    label: const Text('CHECK IN'),
                    onPressed: state.isLoading ? null : () => ref.read(attendanceControllerProvider.notifier).punchIn(_selectedLocationType),
                  ),
                  
                // Break Toggle Button
                if (state.isCheckedIn && !state.isCheckedOut)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.warningColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 52),
                    ),
                    icon: Icon(state.isOnBreak ? Icons.play_arrow : Icons.pause),
                    label: Text(state.isOnBreak ? 'END BREAK' : 'START BREAK'),
                    onPressed: state.isLoading ? null : () => ref.read(attendanceControllerProvider.notifier).toggleBreak(),
                  ),

                // Check Out Button
                if (state.isCheckedIn && !state.isCheckedOut)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.dangerColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 52),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('CHECK OUT'),
                    onPressed: state.isLoading ? null : () => ref.read(attendanceControllerProvider.notifier).punchOut(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplayColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildGpsCard(BuildContext context, AttendanceState state, bool isDark) {
    final locationService = ref.read(locationServiceProvider);
    final isInside = state.isWithinGeofence;
    
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
                  'GPS Location Tracker',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  tooltip: 'Force refresh location',
                  onPressed: () => ref.read(attendanceControllerProvider.notifier).refreshGpsLocation(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Latitude and Longitude Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Latitude:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                Text(
                  state.latitude != null ? state.latitude!.toStringAsFixed(6) : 'Locating...',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Longitude:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                Text(
                  state.longitude != null ? state.longitude!.toStringAsFixed(6) : 'Locating...',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Distance to Office:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                Text(
                  state.distanceToOffice != null
                      ? '${state.distanceToOffice!.toStringAsFixed(0)} meters'
                      : 'Calculating...',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Geofence status display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isInside 
                    ? AppConstants.accentColor.withValues(alpha: 0.1) 
                    : Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isInside 
                      ? AppConstants.accentColor.withValues(alpha: 0.3) 
                      : Colors.blue.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isInside ? Icons.verified_user : Icons.location_on,
                    color: isInside ? AppConstants.accentColor : Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isInside 
                          ? 'Inside Geofence Boundary (Office Radius: 200m).' 
                          : 'Outside Geofence (Office Radius: 200m). WFH Check-in enabled.',
                      style: TextStyle(
                        color: isInside ? AppConstants.accentColor : Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Map link button
            if (state.latitude != null)
              OutlinedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('OPEN GOOGLE MAPS LINK'),
                onPressed: () {
                  final link = locationService.getGoogleMapsLink(state.latitude!, state.longitude!);
                  _copyMapLink(context, link);
                },
              ),
          ],
        ),
      ),
    );
  }
}
