import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/providers.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthController(this._ref) : super(const AuthState()) {
    _initSession();
  }

  Future<void> _initSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = _ref.read(authRepositoryProvider);
      final user = await repo.getCurrentUser();
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> login(String email, String password, bool rememberMe) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(authRepositoryProvider);
      final user = await repo.login(email, password, rememberMe);
      state = AuthState(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = _ref.read(authRepositoryProvider);
      await repo.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  bool getRememberMe() {
    return _ref.read(authRepositoryProvider).getRememberMe();
  }

  String getRememberedEmail() {
    return _ref.read(authRepositoryProvider).getSavedEmail();
  }
}

// Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
