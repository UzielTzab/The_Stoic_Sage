import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stoic_app/models/glossary_term.dart';

class GlossaryProvider extends ChangeNotifier {
  // Todos los términos cargados (origen completo)
  List<GlossaryTerm> _allTerms = [];
  // Términos filtrados según búsqueda / categoría
  List<GlossaryTerm> _terms = [];
  bool _isLoading = true;
  String? _error;

  // Filtrado / búsqueda
  String _searchQuery = '';
  String? selectedCategory;

  List<GlossaryTerm> get terms => _terms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  GlossaryProvider() {
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _allTerms = await _loadGlossaryTerms();
      // Inicialmente mostrar todos
      _applyFilters();
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<List<GlossaryTerm>> _loadGlossaryTerms() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/stoic_glossary.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final terms = jsonData['glossary'] as List<dynamic>;

      return terms
          .map(
            (term) => GlossaryTerm.fromJson(term as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Error loading glossary terms: $e');
    }
  }

  /// Aplica los filtros de búsqueda y categoría sobre `_allTerms`
  void _applyFilters() {
    final query = _searchQuery.trim().toLowerCase();
    _terms = _allTerms.where((t) {
      final matchesCategory = selectedCategory == null || t.category == selectedCategory;
      final matchesQuery = query.isEmpty ||
          t.term.toLowerCase().contains(query) ||
          t.definition.toLowerCase().contains(query) ||
          t.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Lista de categorías disponibles
  List<String> get categories {
    final set = <String>{};
    for (final t in _allTerms) set.add(t.category);
    final list = set.toList();
    list.sort();
    return list;
  }

  /// Actualiza la categoría seleccionada
  void setSelectedCategory(String? category) {
    selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Actualiza la query de búsqueda
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Devuelve términos relacionados (busca por nombre y mapea los related_terms)
  List<GlossaryTerm> getRelatedTerms(String termName) {
    try {
      final base = _allTerms.firstWhere(
        (t) => t.term.toLowerCase() == termName.toLowerCase(),
      );
      final related = <GlossaryTerm>[];
      for (final name in base.relatedTerms) {
        try {
          final match = _allTerms.firstWhere((t) => t.term.toLowerCase() == name.toLowerCase());
          related.add(match);
        } catch (_) {
          // Si no existe el término relacionado en el JSON, ignorar
        }
      }
      return related;
    } catch (_) {
      return [];
    }
  }

  /// Busca un término por nombre (nullable)
  GlossaryTerm? getTermByName(String termName) {
    try {
      return _allTerms.firstWhere((t) => t.term.toLowerCase() == termName.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  /// Filtrado simple público
  List<GlossaryTerm> searchTerms(String query) {
    final lower = query.toLowerCase();
    return _allTerms.where((term) {
      return term.term.toLowerCase().contains(lower) ||
          term.definition.toLowerCase().contains(lower) ||
          term.category.toLowerCase().contains(lower);
    }).toList();
  }
}