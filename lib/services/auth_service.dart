import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/auth_models.dart';
import '../models/jwt_payload.dart';
import '../models/user_models.dart';
import 'api_service.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  static const String _boxName = 'auth';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _payloadKey = 'token_payload';
  static late Box _box;

  static Future<void> initialize() async {
    _box = await Hive.openBox(_boxName);
  }

  static JwtPayload? _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      return JwtPayload.fromJson(payloadMap);
    } catch (e) {
      return null;
    }
  }

  static Future<LoginResponse?> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);

    final response = await ApiService.post(
      '/api/v1/auth/login',
      request.toJson(),
      useAuth: false,
    );

    if (response['success']) {
      final apiResponse = ApiResponse.fromJson(
        response['data'],
        (json) => LoginResponse.fromJson(json),
      );

      if (apiResponse.code == 200 && apiResponse.data != null) {
        await _saveTokens(
          apiResponse.data!.accessToken,
          apiResponse.data!.refreshToken,
        );

        // Decode and save payload
        final payload = _decodeToken(apiResponse.data!.accessToken);
        if (payload != null) {
          await _box.put(_payloadKey, payload.toJson());
        }

        return apiResponse.data;
      }
    }

    return null;
  }

  static Future<LoginResponse?> refreshToken() async {
    final currentRefreshToken = getRefreshToken();
    if (currentRefreshToken == null) return null;

    final request = RefreshTokenRequest(refreshToken: currentRefreshToken);

    final response = await ApiService.post(
      '/api/v1/auth/refresh-token',
      request.toJson(),
      useAuth: false,
    );

    if (response['success']) {
      final apiResponse = ApiResponse.fromJson(
        response['data'],
        (json) => LoginResponse.fromJson(json),
      );

      if (apiResponse.code == 200 && apiResponse.data != null) {
        await _saveTokens(
          apiResponse.data!.accessToken,
          apiResponse.data!.refreshToken,
        );

        // Decode and save new payload
        final payload = _decodeToken(apiResponse.data!.accessToken);
        if (payload != null) {
          await _box.put(_payloadKey, payload.toJson());
        }

        return apiResponse.data;
      }
    }

    return null;
  }

  static Future<void> _saveTokens(
    String accessToken,
    String refreshToken,
  ) async {
    await _box.put(_accessTokenKey, accessToken);
    await _box.put(_refreshTokenKey, refreshToken);
  }

  static String? getAccessToken() {
    return _box.get(_accessTokenKey);
  }

  static String? getRefreshToken() {
    return _box.get(_refreshTokenKey);
  }

  static JwtPayload? getTokenPayload() {
    final payloadJson = _box.get(_payloadKey);
    if (payloadJson != null) {
      try {
        return JwtPayload.fromJson(Map<String, dynamic>.from(payloadJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static bool isLoggedIn() {
    return getAccessToken() != null;
  }

  static Future<void> logout() async {
    await _box.delete(_accessTokenKey);
    await _box.delete(_refreshTokenKey);
    await _box.delete(_payloadKey);
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = getAccessToken();
    if (token == null) return null;

    final response = await ApiService.get('/api/v1/auth/me');

    if (response['success']) {
      final apiResponse = ApiResponse.fromJson(response['data'], null);
      if (apiResponse.code == 200) {
        return apiResponse.data;
      }
    }

    return null;
  }

  static Future<UserProfile?> getUserProfile() async {
    final response = await ApiService.get('/api/v1/auth/me');

    if (response['success']) {
      final apiResponse = ApiResponse.fromJson(
        response['data'],
        (json) => UserProfile.fromJson(json),
      );

      if (apiResponse.code == 200 && apiResponse.data != null) {
        return apiResponse.data;
      }
    }

    return null;
  }
}
