import 'package:moviedb/domain/data_providers/session_data_provider.dart';

class MyAppModel {
  final _sessionDataProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();

    _isAuth = sessionId != null;
    // if (sessionId != null) {
    //   _isAuth = true;
    // } else {
    //   _isAuth = false;
    // }
  }
}
