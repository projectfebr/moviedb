// import 'package:moviedb/domain/api_client/account_api_client.dart';
// import 'package:moviedb/domain/api_client/auth_api_client.dart';
// import 'package:moviedb/domain/data_providers/session_data_provider.dart';
//
// class AuthService {
//   final _sessionDataProvider = SessionDataProvider();
//   final _authApiCLient = AuthApiClient();
//   final _accountApiCLient = AccountApiClient();
//
//   Future<bool> isAuth() async {
//     final sessionId = await _sessionDataProvider.getSessionId();
//     return sessionId != null;
//   }
//
//   Future<void> login(String login, String password) async {
//     final sessionId = await _authApiCLient.auth(username: login, password: password);
//     final accountId = await _accountApiCLient.getAccountInfo(sessionId);
//     await _sessionDataProvider.setSessionId(sessionId);
//     await _sessionDataProvider.setAccountId(accountId);
//   }
//
//   Future<void> logout() async {
//     await _sessionDataProvider.deleteSessionId();
//     await _sessionDataProvider.deleteAccountId();
//   }
// }
