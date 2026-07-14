import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/providers.dart';

class DashboardController extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref _ref;

  DashboardController(this._ref) : super(const AsyncValue.loading()) {
    loadMetrics();
  }

  Future<void> loadMetrics() async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(reportRepositoryProvider);
      final data = await repo.getDashboardMetrics();
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final dashboardControllerProvider = StateNotifierProvider<DashboardController, AsyncValue<Map<String, dynamic>>>((ref) {
  return DashboardController(ref);
});
