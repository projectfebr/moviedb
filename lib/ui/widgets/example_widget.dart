import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/domain/blocs/users_bloc.dart';
import 'package:provider/provider.dart';

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UserState>(
      listener: (context, state) {
        print(state.currentUser.age);
      }, // можно просто слушать изменения, без ребилда (не влияет на перерисовку);
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _AgeTitle(),
                _AgeIncrementWidget(),
                _AgeDecrementWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final age = context.select((UsersBloc bloc) => bloc.state.currentUser.age);
    return Text("$age");

    return BlocBuilder<UsersBloc, UserState>(
      buildWhen: (prev, current) => prev.currentUser.age < current.currentUser.age,
      builder: (BuildContext context, state) {
        final age = state.currentUser.age;
        return Text('$age');
      },
    );

    final bloc = context.read<UsersBloc>();
    bloc.add(UsersInitializeEvent());
    return StreamBuilder<UserState>(
      initialData: bloc.state,
      stream: bloc.stream,
      builder: (context, snapshot) {
        final age = snapshot.requireData.currentUser.age;
        return Text("$age");
      },
    );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return ElevatedButton(
      onPressed: () => bloc.add(UsersIncrementEvent()),
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return ElevatedButton(
      onPressed: () => bloc.add(UsersDecrementEvent()),
      child: const Text('-'),
    );
  }
}

class Exa extends StatelessWidget {
  const Exa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UserState>(
      builder: (context, state) => Text("${state.currentUser.age}"),
      listener: (context, state) => print(state),
    );
  }
}
