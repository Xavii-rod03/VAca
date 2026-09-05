import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/app_assets.dart';
import 'registration_screen.dart';
import '../../controllers/registration_controller.dart';
import '../../controllers/home_controller.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final RegistrationController registrationController;
  final HomeController homeController;

  const SplashScreen({
    super.key,
    required this.registrationController,
    required this.homeController,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Temporizador para pasar a la pantalla de registro después de 3 segundos
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => RegistrationScreen(
            registrationController: widget.registrationController,
            homeController: widget.homeController,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.logoSplash,
              width: 200,
              placeholderBuilder: (BuildContext context) => const Icon(
                Icons.school,
                size: 100,
                color: Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            ),
          ],
        ),
      ),
    );
  }
}
