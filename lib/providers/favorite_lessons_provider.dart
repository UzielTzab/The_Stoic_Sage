import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gestiona los estados de favoritos para las lecciones usando SharedPreferences.
class FavoriteLessonsProvider extends ChangeNotifier {
  FavoriteLessonsProvider() {
    _loadFavorites();
  }

  static const String _storagePrefix = 'favorite_lesson_';

  SharedPreferences? _prefs;
  bool _isLoaded = false;

  final Map<String, bool> _favorites = <String, bool>{};

  bool get isLoaded => _isLoaded;

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    for (final key in _prefs!.getKeys()) {
      if (!key.startsWith(_storagePrefix)) continue;
      final lessonId = key.substring(_storagePrefix.length);
      _favorites[lessonId] = _prefs!.getBool(key) ?? false;
    }
    _isLoaded = true;
    notifyListeners();
  }

  bool isFavorite(String lessonId, {bool? fallback}) {
    final stored = _favorites[lessonId];
    if (stored != null) {
      return stored;
    }
    return fallback ?? false;
  }

  Future<void> setFavorite(String lessonId, bool isFavorite) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final current = _favorites[lessonId];
    if (current == isFavorite && current != null) {
      return;
    }

    final success = await prefs.setBool('$_storagePrefix$lessonId', isFavorite);
    if (success) {
      _favorites[lessonId] = isFavorite;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String lessonId, {bool? fallback}) async {
    final current = isFavorite(lessonId, fallback: fallback);
    await setFavorite(lessonId, !current);
  }
}
