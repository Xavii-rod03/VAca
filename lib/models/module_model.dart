import 'package:flutter/material.dart';

class Module {
  final int id;
  final String title;
  final String subtitle;
  final Color color;
  final String iconPath; // En el futuro será un asset, por ahora usaremos iconos de Flutter o placeholders
  final bool isHighlight;

  Module({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconPath,
    this.isHighlight = false,
  });
}
