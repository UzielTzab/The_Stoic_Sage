import 'package:meta/meta.dart';

/// Modelo para representar un término del glosario estoico.
@immutable
class GlossaryTerm {
  final String term;
  final String definition;
  final String category;
  final List<String> relatedTerms;

  const GlossaryTerm({
    required this.term,
    required this.definition,
    required this.category,
    required this.relatedTerms,
  });

  factory GlossaryTerm.fromJson(Map<String, dynamic> json) {
    return GlossaryTerm(
      term: json['term'] as String,
      definition: json['definition'] as String,
      category: json['category'] as String,
      relatedTerms: List<String>.from(json['related_terms'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term': term,
      'definition': definition,
      'category': category,
      'related_terms': relatedTerms,
    };
  }
}