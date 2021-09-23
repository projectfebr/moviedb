import 'package:flutter/material.dart';
import 'package:moviedb/Theme/app_colors.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';
import 'package:moviedb/ui/widgets/my_app.dart/my_app_model.dart';

class MyApp extends StatelessWidget {
  //static чтобы не пересзодавался, он все равно всегда будет без изменений
  static final mainNavigation = MainNavigation();
  final MyAppModel model;

  const MyApp({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainDartBlue),
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDartBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: mainNavigation.initialRoute(model.isAuth),
      routes: mainNavigation.routes,
      // в onGenerateRoute можно проверять авторизован ли юзер. canPop() будет всегда true
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
