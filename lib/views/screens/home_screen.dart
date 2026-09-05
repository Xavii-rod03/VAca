import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/level_controller.dart';
import '../../repositories/level_repository.dart';
import '../widgets/module_card.dart';
import '../../core/app_assets.dart';
import 'level_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  final HomeController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, child) {
            if (widget.controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Módulos',
                      style: GoogleFonts.baloo2(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.controller.modules.length,
                      itemBuilder: (context, index) {
                        final module = widget.controller.modules[index];
                        return ModuleCard(
                          module: module,
                          onTap: () {
                            // Navegación a la pantalla de niveles
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LevelSelectionScreen(
                                  moduleId: module.id,
                                  moduleTitle: module.title,
                                  // Instanciamos el controlador localmente por ahora (idealmente inyectarlo desde main o un locator)
                                  controller: LevelController(repository: MockLevelRepository()),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 2)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: const Color(0xFF4A90E2),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 32),
                activeIcon: Icon(Icons.home, size: 32),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined, size: 32),
                activeIcon: Icon(Icons.emoji_events, size: 32),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 32),
                activeIcon: Icon(Icons.person, size: 32),
                label: ''),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              // MODIFICAR AQUÍ: reemplazar assets/images/logo/logo.png o usar una imagen de perfil
              AppAssets.logo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Si la imagen no existe, mostramos el icono por defecto
                return const Center(
                  child: Icon(Icons.face, size: 40, color: Colors.orange),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        RichText(
          text: TextSpan(
            style: GoogleFonts.baloo2(fontSize: 24, color: Colors.black),
            children: [
              const TextSpan(text: 'Hola '),
              TextSpan(
                text: widget.controller.currentUser?.name ?? 'Invitado',
                style: GoogleFonts.baloo2(
                    fontWeight: FontWeight.bold, color: const Color(0xFF4A90E2)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
