import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/domain/blocs/users_bloc.dart';
import 'package:moviedb/ui/widgets/example_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<UsersBloc>(
        create: (_) => UsersBloc(),
        child: const ExampleWidget(),
      ),
    );
  }
}