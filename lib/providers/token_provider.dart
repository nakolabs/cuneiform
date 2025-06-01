import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/jwt_payload.dart';

class TokenState {
  final JwtPayload? payload;
  final bool isLoading;

  TokenState({
    this.payload,
    required this.isLoading,
  });

  TokenState copyWith({
    JwtPayload? payload,
    bool? isLoading,
  }) {
    return TokenState(
      payload: payload ?? this.payload,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TokenNotifier extends StateNotifier<TokenState> {
  static const String _boxName = 'auth';
  static const String _payloadKey = 'token_payload';
  late Box _box;

  TokenNotifier() : super(TokenState(isLoading: true)) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _box = await Hive.openBox(_boxName);
      _loadPayloadFromStorage();
    } catch (e) {
      state = TokenState(isLoading: false);
    }
  }

  void _loadPayloadFromStorage() {
    final payloadJson = _box.get(_payloadKey);
    if (payloadJson != null) {
      try {
        final payload = JwtPayload.fromJson(Map<String, dynamic>.from(payloadJson));
        state = TokenState(payload: payload, isLoading: false);
      } catch (e) {
        state = TokenState(isLoading: false);
      }
    } else {
      state = TokenState(isLoading: false);
    }
  }

  Future<void> setPayload(JwtPayload payload) async {
    state = state.copyWith(payload: payload);
    await _box.put(_payloadKey, payload.toJson());
  }

  Future<void> clearPayload() async {
    state = TokenState(isLoading: false);
    await _box.delete(_payloadKey);
  }

  // Helper getters
  String? get userId => state.payload?.user.id;
  String? get userEmail => state.payload?.user.email;
  String? get schoolId => state.payload?.user.schoolId;
  String? get roleId => state.payload?.user.roleId;
  bool get isTokenValid {
    if (state.payload == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return state.payload!.exp > now;
  }
}

final tokenProvider = StateNotifierProvider<TokenNotifier, TokenState>((ref) {
  return TokenNotifier();
});
