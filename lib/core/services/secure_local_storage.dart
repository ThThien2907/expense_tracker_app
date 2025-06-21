import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureLocalStorage extends LocalStorage {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Future<String?> accessToken() async {
    return await secureStorage.read(key: supabasePersistSessionKey);
  }

  @override
  Future<void> persistSession(String jsonStr) async {
    await secureStorage.write(key: supabasePersistSessionKey, value: jsonStr);
  }

  @override
  Future<void> removePersistedSession() async {
    await secureStorage.delete(key: supabasePersistSessionKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    final session = await secureStorage.read(key: supabasePersistSessionKey);
    return session != null;
  }

  @override
  Future<void> initialize() async {
  }
}