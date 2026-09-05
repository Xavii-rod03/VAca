import 'package:flutter/material.dart';
import 'repositories/sqlite_module_repository.dart';
import 'repositories/sqlite_user_repository.dart';
import 'controllers/home_controller.dart';
import 'controllers/registration_controller.dart';
import 'views/screens/splash_screen.dart';

void main() async {
  // Aseguramos que Flutter esté inicializado antes de llamar a SQLite
  WidgetsFlutterBinding.ensureInitialized();

  // Inyectamos las dependencias usando SQLite Real
  final moduleRepository = SQLiteModuleRepository();
  final userRepository = SQLiteUserRepository();

  // Controladores
  final homeController = HomeController(
    repository: moduleRepository,
    userRepository: userRepository,
  );
  final registrationController = RegistrationController(repository: userRepository);

  runApp(MyApp(
    homeController: homeController,
    registrationController: registrationController,
  ));
}

class MyApp extends StatelessWidget {
  final HomeController homeController;
  final RegistrationController registrationController;

  const MyApp({
    super.key,
    required this.homeController,
    required this.registrationController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Educativa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90E2)),
        useMaterial3: true,
      ),
      home: SplashScreen(
        homeController: homeController,
        registrationController: registrationController,
      ),
    );
  }
}
