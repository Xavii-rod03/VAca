import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class RegistrationController extends ChangeNotifier {
  final UserRepository repository;

  RegistrationController({required this.repository});

  bool isLoading = false;

  Future<bool> registerUser(String name, int age) async {
    if (name.isEmpty || age <= 0) return false;

    isLoading = true;
    notifyListeners();

    final user = User(name: name, age: age);
    await repository.saveUser(user);

    isLoading = false;
    notifyListeners();
    return true;
  }
}
