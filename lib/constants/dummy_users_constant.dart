import 'dart:math';
import 'package:aiso/models/user_model.dart';

class DummyUserGenerator {
  static final List<UserModel> _dummyUsers = List.generate(10, (index) {
    return UserModel(
      id: 'dummy-uuid-$index',
      email: 'user$index@email.com',
      username: 'dummyuser$index',
      displayName: 'User $index',
    );
  });

  static UserModel? getDummyUserByEmail(String email) {
    try {
      return _dummyUsers.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  static List<UserModel> getAllDummyUsers() {
    return _dummyUsers;
  }

  static UserModel getRandomDummyUser() {
    final randomIndex = Random().nextInt(_dummyUsers.length);
    return _dummyUsers[randomIndex];
  }
}
