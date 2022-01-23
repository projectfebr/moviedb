import 'package:moviedb/domain/entity/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider {
  var imitationCounter = 0;
  final sharedPreferences = SharedPreferences.getInstance();

  Future<User> loadValue() async {
    final age = (await sharedPreferences).getInt('age') ?? 0;
    return User(age);
  }

  Future<void> saveValue(User user) async {
    imitationCounter += 1;
    if (imitationCounter.isEven) {
      await Future<dynamic>.delayed(const Duration(seconds: 1));
    }
    (await sharedPreferences).setInt('age', user.age);
  }
}
