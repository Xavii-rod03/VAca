import '../models/user_model.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
}

class MockUserRepository implements UserRepository {
  User? _cachedUser;

  @override
  Future<void> saveUser(User user) async {
    // Simulamos guardado local
    _cachedUser = user;
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<User?> getUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _cachedUser;
  }
}
