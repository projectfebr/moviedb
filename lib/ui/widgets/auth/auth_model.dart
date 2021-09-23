import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiCLient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final loginTextController = TextEditingController();
  final passTextController = TextEditingController();
  String? _errorMessage;

  String? get errorMesage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final username = loginTextController.text;
    final password = passTextController.text;

    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();
    String? sessionId;
    try {
      sessionId = await _apiCLient.auth(username: username, password: password);
    } catch (e) {
      _errorMessage = 'Неправильный логин или пароль';
    }

    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }

    if (sessionId == null) {
      _errorMessage = 'Неизвестная ошибка, повторите попытку';
      return;
    }
    //если все ок сохраняем sessionId
    await _sessionDataProvider.setSessionId(sessionId);
    //совершить переход после успещной авторизации
    unawaited(Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen));
  }
}

// class AuthProvider extends InheritedNotifier {
//   final AuthModel model;

//   const AuthProvider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(
//           key: key,
//           notifier: model,
//           child: child,
//         );

//   static AuthProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }

//   static AuthProvider? read(BuildContext context) {
//     final widget =
//         context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
//     return widget is AuthProvider ? widget : null;
//   }
// }


