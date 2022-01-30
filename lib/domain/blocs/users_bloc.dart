import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:moviedb/domain/data_providers/user_data_provider.dart';
import 'package:moviedb/domain/entity/user.dart';

abstract class SomeState {}

class SomeSuccessState extends SomeState {
  final User currentUser;

  SomeSuccessState(this.currentUser);
}

class SomeFailureState extends SomeState {
  final String error;

  SomeFailureState(this.error);
}

// class SomeState {
//   final User? currentUser;
//   final String? error;
//
//   SomeState(this.currentUser, this.error);
// }

class UserState {
  final User currentUser;

  const UserState({
    required this.currentUser,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserState && runtimeType == other.runtimeType && currentUser == other.currentUser);

  @override
  int get hashCode => currentUser.hashCode;

  @override
  String toString() {
    return 'UsersState{ currentUser: $currentUser }';
  }

  UserState copyWith({
    User? currentUser,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

abstract class UserEvents {}

class UsersIncrementEvent implements UserEvents {}

class UsersDecrementEvent implements UserEvents {}

class UsersInitializeEvent implements UserEvents {}

class UsersBloc extends Bloc<UserEvents, UserState> {
  final _userDataProvider = UserDataProvider();

  UsersBloc() : super(UserState(currentUser: User(0))) {
    on<UserEvents>(
      (event, emit) async {
        if (event is UsersInitializeEvent) {
          final user = await _userDataProvider.loadValue();
          emit(UserState(currentUser: user));
        } else if (event is UsersDecrementEvent) {
          var user = state.currentUser;
          user = user.copyWith(age: user.age - 1);
          await _userDataProvider.saveValue(user);
          emit(UserState(currentUser: user));
        } else if (event is UsersIncrementEvent) {
          var user = state.currentUser;
          user = user.copyWith(age: user.age + 1);
          await _userDataProvider.saveValue(user);
          emit(UserState(currentUser: user));
        }
      },
      transformer: sequential(),
    );

    //   on<UsersInitializeEvent>((event, emit) async {
    //     final user = await _userDataProvider.loadValue();
    //     emit(UserState(currentUser: user));
    //   }, transformer: sequential());
    //
    //   on<UsersIncrementEvent>((event, emit) async {
    //     var user = state.currentUser;
    //     user = user.copyWith(age: user.age + 1);
    //     await _userDataProvider.saveValue(user);
    //     emit(UserState(currentUser: user));
    //   }, transformer: sequential());
    //
    //   on<UsersDecrementEvent>((event, emit) async {
    //     var user = state.currentUser;
    //     user = user.copyWith(age: user.age - 1);
    //     await _userDataProvider.saveValue(user);
    //     emit(UserState(currentUser: user));
    //   }, transformer: sequential());
  }
}
