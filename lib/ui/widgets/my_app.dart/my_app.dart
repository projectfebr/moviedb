import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moviedb/Theme/app_colors.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  //static чтобы не пересзодавался, он все равно всегда будет без изменений
  static final mainNavigation = MainNavigator();
  // final MyAppModel model;

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ru', 'RU'), // Spanish, no country code
      ],
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
      initialRoute: MainNavigationRouteNames.loader,
      routes: mainNavigation.routes,
      // в onGenerateRoute можно проверять авторизован ли юзер. canPop() будет всегда true
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
