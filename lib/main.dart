import 'package:flutter/material.dart';
import 'package:moviedb/ui/widgets/my_app.dart/my_app.dart';
import 'package:moviedb/ui/widgets/my_app.dart/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.checkAuth();
  runApp(MyApp(model: model));
}
