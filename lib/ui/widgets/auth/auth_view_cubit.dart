import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moviedb/domain/api_client/api_client_exception.dart';
import 'package:moviedb/domain/blocs/auth_bloc.dart';

abstract class AuthViewCubitState {}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitFormFillInProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitErrorState extends AuthViewCubitState {
  final String errorMessage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;

  AuthViewCubitErrorState(this.errorMessage);
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitSuccessAuthState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitSuccessAuthState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(AuthViewCubitState initialState, this.authBloc) : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }

  void _onState(AuthState state) {
    if (state is AuthUnauthorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthAuthorizedState) {
      emit(AuthViewCubitSuccessAuthState());
      authBlocSubscription.cancel();
    } else if (state is AuthFailureState) {
      final errorMessage = _mapErrorToMessage(state.error);
      final authState = AuthViewCubitErrorState(errorMessage);
      emit(authState);
    } else if (state is AuthProgressState) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is CheckAuthProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is ApiClientException) {
      switch (error.type) {
        case ApiClientExceptionType.network:
          return 'Сервер недоступен. Проверьте подключение к интернету.';

        case ApiClientExceptionType.auth:
          return 'Не правильный логин или пароль.';

        case ApiClientExceptionType.sessionExpired:
        case ApiClientExceptionType.other:
          return 'Произошла ошибка. Попробуйте еще раз.';
      }
    } else {
      return 'Неизвестная ошибка, повторите попытку.';
    }
  }

  bool _isValid(String username, String password) => username.isNotEmpty && password.isNotEmpty;

  void auth({required String login, required String password}) {
    if (!_isValid(login, password)) {
      emit(AuthViewCubitErrorState('Заполните логин и пароль.'));
      return;
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
