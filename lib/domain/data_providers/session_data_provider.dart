import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session_id';
}

class SessionDataProvider {
  static const _storage = FlutterSecureStorage();

  Future<String?> getSessionId() => _storage.read(key: _Keys.sessionId);
  Future<void> setSessionId(String? value) async {
    if (value != null) {
      _storage.write(key: _Keys.sessionId, value: value);
    } else {
      _storage.delete(key: _Keys.sessionId);
    }
  }
}
