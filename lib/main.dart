import 'package:flutter/material.dart';
import 'package:moviedb/Theme/app_colors.dart';
import 'package:moviedb/widgets/auth/auth_model.dart';
import 'package:moviedb/widgets/auth/auth_widget.dart';
import 'package:moviedb/widgets/main_screen/main_screen_widget.dart';
import 'package:moviedb/widgets/movie_details/movie_details_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainDartBlue),
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDartBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => AuthProvider(
              child: const AuthWidget(),
              model: AuthModel(),
            ),
        '/main_screen': (context) => MainScreenWidget(),
        '/main_screen/movie_details': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          if (arguments is int) {
            return MoveDetailsWidget(movieId: arguments);
          }
          return MoveDetailsWidget(movieId: 0);
        },
      },
      // в onGenerateRoute можно проверять авторизован ли юзер. canPop() будет всегда true
      // onGenerateRoute: (RouteSettings settings) {
      //   return MaterialPageRoute(builder: (context) {
      //     return Scaffold(
      //       body: Center(child: Text('Ошибка навигации')),
      //     );
      //   });
      // },
    );
  }
}
