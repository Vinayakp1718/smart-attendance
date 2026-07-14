import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/providers.dart';
import 'routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage Service (Hive Database seeding happens here)
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        // Override the storageServiceProvider with the fully initialized instance
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Smart Attendance System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Auto adapt light/dark mode based on system settings
      routerConfig: router,
    );
  }
}
