import 'package:flutter/material.dart';
import '../models/module_model.dart';

abstract class ModuleRepository {
  Future<List<Module>> getModules();
}

class MockModuleRepository implements ModuleRepository {
  @override
  Future<List<Module>> getModules() async {
    // Simulamos una carga de datos
    return [
      Module(
        id: 1,
        title: 'Trazos',
        subtitle: '',
        color: const Color(0xFF4A90E2),
        iconPath: 'pencil',
        isHighlight: true,
      ),
      Module(
        id: 2,
        title: 'Letras y sílabas',
        subtitle: 'ba',
        color: const Color(0xFFE0E0E0),
        iconPath: 'letters',
      ),
      Module(
        id: 3,
        title: 'Palabras',
        subtitle: 'SOL',
        color: const Color(0xFFE0E0E0),
        iconPath: 'word',
      ),
      Module(
        id: 4,
        title: 'Libros',
        subtitle: '',
        color: const Color(0xFFE0E0E0),
        iconPath: 'book',
      ),
    ];
  }
}
