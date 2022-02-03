import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/api_client_exception.dart';
import 'package:moviedb/domain/blocs/auth_bloc.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final loginTextController = TextEditingController();
  final passTextController = TextEditingController();
  String? _errorMessage;

  String? get errorMesage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String username, String password) => username.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String username, String password) async {
    try {
      await _authService.login(username, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Сервер недоступен. Проверьте подключение к интернету.';

        case ApiClientExceptionType.auth:
          return 'Не правильный логин или пароль.';

        case ApiClientExceptionType.sessionExpired:
        case ApiClientExceptionType.other:
          return 'Произошла ошибка. Попробуйте еще раз.';
      }
    } catch (e) {
      return 'Неизвестная ошибка, повторите попытку.';
    }
    return null;
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    } else {
      _errorMessage = errorMessage;
      _isAuthProgress = isAuthProgress;
      notifyListeners();
    }
  }

  Future<void> auth(BuildContext context) async {
    final username = loginTextController.text;
    final password = passTextController.text;

    if (!_isValid(username, password)) {
      _updateState('Заполните логин и пароль.', false);
      return;
    }

    _updateState(null, true);

    _errorMessage = await _login(username, password);

    if (_errorMessage == null) {
      MainNavigator.resetNavigation(context);
    } else {
      _updateState(_errorMessage, false);
    }

    //совершить переход после успещной авторизации
    MainNavigator.resetNavigation(context);
  }
}
