import 'package:bloc/bloc.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/auth_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';

abstract class AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;

  AuthLoginEvent({required this.login, required this.password});
}

enum AuthStateStatus { authorized, notAuthorized, inProgress }

abstract class AuthState {}

class AuthUnauthorizedState extends AuthState {}

class AuthAuthorizedState extends AuthState {}

class AuthFailureState extends AuthState {
  final Object error;

  AuthFailureState(this.error);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _sessionDataProvider = SessionDataProvider();
  final _authApiClient = AuthApiClient();
  final _accountApiClient = AccountApiClient();

  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthCheckStatusEvent>((event, emit) async {
      final sessionId = await _sessionDataProvider.getSessionId();
      final isAuth = sessionId != null;
      final newState = sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
      emit(newState);
    });
    on<AuthLoginEvent>((event, emit) async {
      try {
        final sessionId =
            await _authApiClient.auth(username: event.login, password: event.password);
        final accountId = await _accountApiClient.getAccountInfo(sessionId);
        await _sessionDataProvider.setSessionId(sessionId);
        await _sessionDataProvider.setAccountId(accountId);
        emit(AuthAuthorizedState());
      } catch (e) {
        emit(AuthFailureState(e));
      }
    });
    on<AuthLogoutEvent>((event, emit) async {
      try {
        await _sessionDataProvider.deleteSessionId();
        await _sessionDataProvider.deleteAccountId();
        emit(AuthUnauthorizedState());
      } catch (e) {
        emit(AuthFailureState(e));
      }
    });
    add(AuthCheckStatusEvent());
  }
}

class AuthProgressState extends AuthState {}

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _authApiCLient = AuthApiClient();
  final _accountApiCLient = AccountApiClient();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    return sessionId != null;
  }

  Future<void> login(String login, String password) async {
    final sessionId = await _authApiCLient.auth(username: login, password: password);
    final accountId = await _accountApiCLient.getAccountInfo(sessionId);
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }

  Future<void> logout() async {
    await _sessionDataProvider.deleteSessionId();
    await _sessionDataProvider.deleteAccountId();
  }
}
