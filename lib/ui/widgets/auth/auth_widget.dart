import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/Theme/button_style.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';
import 'package:moviedb/ui/widgets/auth/auth_view_cubit.dart';
import 'package:provider/provider.dart';

class _AuthDataStorage {
  String login = '';
  String password = '';
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthViewCubitState>(
      listenWhen: (_, current) => current is AuthViewCubitSuccessAuthState,
      listener: _onLoaderViewCubitStateChange,
      child: Provider(
        create: (_) => _AuthDataStorage(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Войти в свою учётную запись'),
          ),
          body: ListView(
            children: const [
              _HeaderWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoaderViewCubitStateChange(BuildContext context, AuthViewCubitState state) {
    MainNavigator.resetNavigation(context);
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  final textStyle = const TextStyle(fontSize: 16, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          const _FormWidget(),
          const SizedBox(height: 25),
          Text(
              'Чтобы пользоваться правкой и возможностями рейтинга TMDb, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой.',
              style: textStyle),
          const SizedBox(height: 5),
          TextButton(
              style: AppButtonStyle.linkButton, onPressed: () {}, child: const Text('Регистрация')),
          const SizedBox(height: 25),
          Text('Если Вы зарегистрировались, но не получили письмо для подтверждения.',
              style: textStyle),
          const SizedBox(height: 5),
          TextButton(
              style: AppButtonStyle.linkButton,
              onPressed: () {},
              child: const Text('Подтверждение email')),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_AuthDataStorage>();
    const textStyle = TextStyle(fontSize: 16, color: Color(0xff212529));
    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF01B4E4),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        const Text(
          'Имя пользователя',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          decoration: textFieldDecorator,
          onChanged: (text) => model.login = text,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Пароль',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: true,
          decoration: textFieldDecorator,
          onChanged: (text) => model.password = text,
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(width: 30),
            TextButton(
              onPressed: () {},
              child: const Text('Сбросить пароль'),
              style: AppButtonStyle.linkButton,
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AuthViewCubit>();
    final storage = context.read<_AuthDataStorage>();

    final canStartAuth = cubit.state is AuthViewCubitFormFillInProgressState ||
        cubit.state is AuthViewCubitErrorState;
    final onPressed = canStartAuth
        ? () => cubit.auth(
              login: storage.login,
              password: storage.password,
            )
        : null;
    final child = cubit is AuthViewCubitAuthProgressState
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ))
        : const Text('Войти');
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF01B4E4)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        ),
      ),
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<AuthViewCubit, AuthViewCubitState>(builder: (context, state) {});
    final errorMessage = context.select((AuthViewCubit cubit) {
      final state = cubit.state;
      return state is AuthViewCubitErrorState ? state.errorMessage : null;
    });

    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red, fontSize: 17),
      ),
    );
  }
}
