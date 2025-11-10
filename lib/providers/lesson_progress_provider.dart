import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoic_app/models/stoic_content.dart';

/// Gestiona el progreso de las lecciones usando SharedPreferences.
/// Almacena un `bool` por lección indicando si ha sido completada.
class LessonProgressProvider extends ChangeNotifier {
  LessonProgressProvider() {
    _loadStatuses();
  }

  static const String _storagePrefix = 'lesson_completed_';

  SharedPreferences? _prefs;
  bool _isLoaded = false;

  final Map<String, LessonStatus> _statuses = <String, LessonStatus>{};

  bool get isLoaded => _isLoaded;

  Future<void> _loadStatuses() async {
    _prefs = await SharedPreferences.getInstance();
    for (final key in _prefs!.getKeys()) {
      if (!key.startsWith(_storagePrefix)) continue;
      final lessonId = key.substring(_storagePrefix.length);
      final completed = _prefs!.getBool(key) ?? false;
      _statuses[lessonId] = completed
          ? LessonStatus.completed
          : LessonStatus.unread;
    }
    _isLoaded = true;
    notifyListeners();
  }

  LessonStatus statusFor(String lessonId, {LessonStatus? fallback}) {
    final stored = _statuses[lessonId];
    if (stored != null) {
      return stored;
    }
    return fallback ?? LessonStatus.unread;
  }

  bool isCompleted(String lessonId, {LessonStatus? fallback}) {
    return statusFor(lessonId, fallback: fallback) == LessonStatus.completed;
  }

  Future<void> setCompleted(String lessonId, bool completed) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final newStatus = completed ? LessonStatus.completed : LessonStatus.unread;
    final currentStatus = _statuses[lessonId];
    if (currentStatus == newStatus && currentStatus != null) {
      return; // No hay cambios reales
    }
    final success = await prefs.setBool('$_storagePrefix$lessonId', completed);
    if (success) {
      _statuses[lessonId] = newStatus;
      notifyListeners();
    }
  }

  Future<void> markCompleted(String lessonId) => setCompleted(lessonId, true);

  Future<void> markUnread(String lessonId) => setCompleted(lessonId, false);
}
