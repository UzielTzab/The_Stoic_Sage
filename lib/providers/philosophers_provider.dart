import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stoic_app/models/stoic_content.dart';

class PhilosophersProvider extends ChangeNotifier {
  List<StoicContent> _philosophers = [];
  bool _isLoading = true;
  String? _error;

  List<StoicContent> get philosophers => _philosophers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PhilosophersProvider() {
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _philosophers = await _loadPhilosophers();
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<List<StoicContent>> _loadPhilosophers() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/stoic_content.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final philosophers = jsonData['philosophers'] as List<dynamic>;

      return philosophers
          .map(
            (philosopher) => StoicContent(
              id: philosopher['id'] as String,
              title: philosopher['title'] as String,
              description: philosopher['description'] as String,
              category: philosopher['category'] as String,
              status: _parseStatus(philosopher['status'] as String?),
              content: philosopher['content'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading philosophers: $e');
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

  /// Filtra los filósofos por query de búsqueda
  List<StoicContent> searchPhilosophers(String query) {
    if (query.trim().isEmpty) {
      return _philosophers;
    }
    final normalizedQuery = query.trim().toLowerCase();
    return _philosophers.where((philosopher) {
      return philosopher.title.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  /// Obtiene filósofos por categoría
  List<StoicContent> getPhilosophersByCategory(String category) {
    return _philosophers.where((philosopher) => philosopher.category == category).toList();
  }

  /// Obtiene todas las categorías únicas
  List<String> getCategories() {
    final categories = <String>{};
    for (var philosopher in _philosophers) {
      categories.add(philosopher.category);
    }
    return categories.toList();
  }
}