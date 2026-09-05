import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/registration_controller.dart';
import '../../controllers/home_controller.dart';
import 'home_screen.dart';
import '../../core/app_assets.dart';

class RegistrationScreen extends StatefulWidget {
  final RegistrationController registrationController;
  final HomeController homeController;

  const RegistrationScreen({
    super.key,
    required this.registrationController,
    required this.homeController,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Iniciamos la animación después de un breve delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _isVisible ? 1.0 : 0.0,
            child: Column(
              children: [
                const SizedBox(height: 60),
                // MODIFICAR AQUÍ: reemplazar assets/images/illustrations/registration.svg
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.8, end: 1.0),
                  duration: const Duration(seconds: 1),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: SvgPicture.asset(
                        AppAssets.registrationIllustration,
                        height: 180,
                        placeholderBuilder: (context) => Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_add,
                              size: 80, color: Color(0xFF4A90E2)),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  '¡Bienvenido!',
                  style: GoogleFonts.baloo2(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A90E2),
                  ),
                ),
                Text(
                  'Cuéntanos un poco sobre ti',
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 50),
                _buildTextField(
                  controller: _nameController,
                  label: '¿Cómo te llamas?',
                  icon: Icons.face,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _ageController,
                  label: '¿Cuántos años tienes?',
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 60),
                ListenableBuilder(
                  listenable: widget.registrationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: widget.registrationController.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                        child: widget.registrationController.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                '¡Comenzar!',
                                style: GoogleFonts.baloo2(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.baloo2(fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.baloo2(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  void _handleRegister() async {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text) ?? 0;

    if (name.isEmpty || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, escribe tu nombre y una edad válida',
            style: GoogleFonts.baloo2(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await widget.registrationController.registerUser(name, age);
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(controller: widget.homeController),
        ),
      );
    }
  }
}
