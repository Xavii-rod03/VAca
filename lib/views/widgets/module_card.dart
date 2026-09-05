import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/module_model.dart';

class ModuleCard extends StatelessWidget {
  final Module module;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 120,
        decoration: BoxDecoration(
          color: module.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  module.title,
                  style: GoogleFonts.baloo2(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: module.isHighlight ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 10,
              bottom: 10,
              child: Container(
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _buildModuleIcon(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleIcon() {
    // Implementación visual basada en la imagen
    switch (module.iconPath) {
      case 'pencil':
        return const Icon(Icons.edit, size: 40, color: Color(0xFF4A90E2));
      case 'letters':
        return Text(
          'ba',
          style: GoogleFonts.baloo2(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        );
      case 'word':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('S', style: GoogleFonts.baloo2(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24)),
            Text('O', style: GoogleFonts.baloo2(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 24)),
            Text('L', style: GoogleFonts.baloo2(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        );
      case 'book':
        return const Icon(Icons.menu_book, size: 40, color: Colors.blueGrey);
      default:
        return const Icon(Icons.star, size: 40);
    }
  }
}
