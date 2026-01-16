import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stoic_app/models/stoic_content.dart';

class StoicContentProvider extends ChangeNotifier {
  List<StoicContent> _lessons = [];
  bool _isLoading = true;
  String? _error;

  List<StoicContent> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  StoicContentProvider() {
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _lessons = await _loadStoicContent();
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<List<StoicContent>> _loadStoicContent() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/stoic_content.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final lessons = jsonData['lessons'] as List<dynamic>;

      return lessons
          .map(
            (lesson) => StoicContent(
              id: lesson['id'] as String,
              title: lesson['title'] as String,
              description: lesson['description'] as String,
              category: lesson['category'] as String,
              status: _parseStatus(lesson['status'] as String?),
              content: lesson['content'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading stoic content: $e');
      return [];
    }
  }

  LessonStatus _parseStatus(String? statusString) {
    switch (statusString) {
      case 'completed':
        return LessonStatus.completed;
      default:
        return LessonStatus.unread;
    }
  }

  /// Filtra las lecciones por query de búsqueda
  List<StoicContent> searchLessons(String query) {
    if (query.trim().isEmpty) {
      return _lessons;
    }
    final normalizedQuery = query.trim().toLowerCase();
    return _lessons.where((lesson) {
      return lesson.title.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  /// Obtiene lecciones por categoría
  List<StoicContent> getLessonsByCategory(String category) {
    return _lessons.where((lesson) => lesson.category == category).toList();
  }

  /// Obtiene todas las categorías únicas
  List<String> getCategories() {
    final categories = <String>{};
    for (var lesson in _lessons) {
      categories.add(lesson.category);
    }
    return categories.toList();
  }
}
