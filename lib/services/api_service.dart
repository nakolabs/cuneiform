import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import '../providers/auth_provider.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static WidgetRef? _ref;
  
  static void setRef(WidgetRef ref) {
    _ref = ref;
  }

  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    bool useAuth = true,
    int retryCount = 0,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
    };

    // Add authorization header if needed
    if (useAuth) {
      final token = AuthService.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      http.Response response;
      
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Handle token refresh for 401 errors
      if (response.statusCode == 401 && useAuth && retryCount == 0) {
        final refreshResult = await AuthService.refreshToken();
        if (refreshResult != null) {
          // Notify auth provider about token refresh
          if (_ref != null) {
            final authNotifier = _ref!.read(authProvider.notifier);
            authNotifier.refreshTokens();
          }
          
          // Retry the request with new token
          return _makeRequest(method, endpoint, body: body, useAuth: useAuth, retryCount: 1);
        } else {
          // Refresh failed, logout user through auth provider
          if (_ref != null) {
            final authNotifier = _ref!.read(authProvider.notifier);
            await authNotifier.logout();
          } else {
            await AuthService.logout();
          }
          
          return {
            'success': false,
            'statusCode': 401,
            'error': 'Authentication failed',
          };
        }
      }

      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, 
    Map<String, dynamic> body, {
    bool useAuth = true,
  }) async {
    return _makeRequest('POST', endpoint, body: body, useAuth: useAuth);
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool useAuth = true,
  }) async {
    return _makeRequest('GET', endpoint, useAuth: useAuth);
  }

  static Future<Map<String, dynamic>> put(
    String endpoint, 
    Map<String, dynamic> body, {
    bool useAuth = true,
  }) async {
    return _makeRequest('PUT', endpoint, body: body, useAuth: useAuth);
  }

  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool useAuth = true,
  }) async {
    return _makeRequest('DELETE', endpoint, useAuth: useAuth);
  }
}
