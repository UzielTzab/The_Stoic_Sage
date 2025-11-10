import 'package:meta/meta.dart';

/// Estados posibles para el avance de una lección.
enum LessonStatus { unread, completed }

extension LessonStatusLabel on LessonStatus {
  String get label {
    switch (this) {
      case LessonStatus.unread:
        return 'No leído';
      case LessonStatus.completed:
        return 'Completado';
    }
  }
}

/// Modelo base para representar una lección o artículo estoico.
/// Mantiene el contenido textual junto con metadatos para la UI.
@immutable
class StoicContent {
  final String id;
  final String title;
  final String description;
  final String category;
  final LessonStatus status;
  final String content;
  final bool isFavorite;

  const StoicContent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.content,
    this.status = LessonStatus.unread,
    this.isFavorite = false,
  });

  bool get isCompleted => status == LessonStatus.completed;

  factory StoicContent.fromJson(Map<String, dynamic> json) {
    final statusString = json['status'] as String?;
    LessonStatus status;
    if (statusString != null) {
      status = LessonStatus.values.firstWhere(
        (value) => value.name == statusString,
        orElse: () => LessonStatus.unread,
      );
    } else {
      final completedFlag = json['isCompleted'] as bool? ?? false;
      status = completedFlag ? LessonStatus.completed : LessonStatus.unread;
    }

    return StoicContent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      content: json['content'] as String? ?? '',
      status: status,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'content': content,
    'status': status.name,
    'isCompleted': isCompleted,
    'isFavorite': isFavorite,
  };
}
