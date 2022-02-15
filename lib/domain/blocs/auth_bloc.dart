import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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

abstract class AuthState {}

class AuthUnauthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthUnauthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthAuthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthFailureState extends AuthState {
  final Object error;

  AuthFailureState(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailureState && runtimeType == other.runtimeType && error == other.error;

  @override
  int get hashCode => error.hashCode;
}

class AuthProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class CheckAuthProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CheckAuthProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _sessionDataProvider = SessionDataProvider();
  final _authApiClient = AuthApiClient();
  final _accountApiClient = AccountApiClient();

  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthCheckStatusEvent) {
        await onAuthCheckStatusEvent(event, emit);
      } else if (event is AuthLoginEvent) {
        await onAuthLoginEvent(event, emit);
      } else if (event is AuthLogoutEvent) {
        await onAuthLogoutEvent(event, emit);
      }
    }, transformer: sequential());

    add(AuthCheckStatusEvent());
  }

  Future<void> onAuthCheckStatusEvent(AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthProgressState());
    final sessionId = await _sessionDataProvider.getSessionId();
    final newState = sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
    emit(newState);
  }

  Future<void> onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthProgressState());
      final sessionId = await _authApiClient.auth(username: event.login, password: event.password);
      final accountId = await _accountApiClient.getAccountInfo(sessionId);
      await _sessionDataProvider.setSessionId(sessionId);
      await _sessionDataProvider.setAccountId(accountId);
      emit(AuthAuthorizedState());
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }

  Future<void> onAuthLogoutEvent(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _sessionDataProvider.deleteSessionId();
      await _sessionDataProvider.deleteAccountId();
      emit(AuthUnauthorizedState());
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }
}

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
