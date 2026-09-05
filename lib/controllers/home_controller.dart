import 'package:flutter/material.dart';
import '../models/module_model.dart';
import '../models/user_model.dart';
import '../repositories/module_repository.dart';
import '../repositories/user_repository.dart';

class HomeController extends ChangeNotifier {
  final ModuleRepository repository;
  final UserRepository userRepository;
  
  List<Module> modules = [];
  User? currentUser;
  bool isLoading = true;

  HomeController({
    required this.repository,
    required this.userRepository,
  });

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    
    // Cargamos módulos y usuario en paralelo
    final results = await Future.wait([
      repository.getModules(),
      userRepository.getUser(),
    ]);

    modules = results[0] as List<Module>;
    currentUser = results[1] as User?;
    
    isLoading = false;
    notifyListeners();
  }
}
