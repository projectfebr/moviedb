import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _apiCLient = ApiClient();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    return sessionId != null;
  }

  Future<void> login(String login, String password) async {
    final sessionId =
        await _apiCLient.auth(username: login, password: password);
    final accountId = await _apiCLient.getAccountInfo(sessionId);
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }
}
