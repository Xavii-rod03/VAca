enum LevelStatus { locked, current, completed }

class Level {
  final int id;
  final int moduleId;
  final String title;
  final LevelStatus status;
  final int stars; // 0 a 3

  Level({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.status,
    this.stars = 0,
  });
}
