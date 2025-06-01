import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_models.dart';
import '../models/jwt_payload.dart';
import '../services/auth_service.dart';

class AuthState {
  final String? accessToken;
  final String? refreshToken;
  final JwtPayload? payload;
  final bool isLoggedIn;
  final bool isLoading;

  const AuthState({
    this.accessToken,
    this.refreshToken,
    this.payload,
    this.isLoggedIn = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    String? accessToken,
    String? refreshToken,
    JwtPayload? payload,
    bool? isLoggedIn,
    bool? isLoading,
  }) {
    return AuthState(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      payload: payload ?? this.payload,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final accessToken = AuthService.getAccessToken();
    final refreshToken = AuthService.getRefreshToken();
    final payload = AuthService.getTokenPayload();
    
    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      payload: payload,
      isLoggedIn: accessToken != null,
    );
  }

  Future<LoginResponse?> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final result = await AuthService.login(email, password);
      
      if (result != null) {
        state = state.copyWith(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
          payload: AuthService.getTokenPayload(),
          isLoggedIn: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
      
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    state = const AuthState();
  }

  Future<void> refreshTokens() async {
    final result = await AuthService.refreshToken();
    
    if (result != null) {
      state = state.copyWith(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        payload: AuthService.getTokenPayload(),
        isLoggedIn: true,
      );
    } else {
      await logout();
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
