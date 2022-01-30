import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:moviedb/domain/blocs/blocs_observer.dart';
import 'package:moviedb/ui/widgets/my_app.dart';

void main() {
  const myApp = MyApp();
  BlocOverrides.runZoned(
    () => runApp(myApp),
    blocObserver: BlocsObserver(),
  );
}
