import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:stoic_app/models/stoic_content.dart';

class StoicContentLoader {
  static Future<List<StoicContent>> loadStoicContent() async {
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

  static LessonStatus _parseStatus(String? statusString) {
    switch (statusString) {
      case 'completed':
        return LessonStatus.completed;
      default:
        return LessonStatus.unread;
    }
  }
}
