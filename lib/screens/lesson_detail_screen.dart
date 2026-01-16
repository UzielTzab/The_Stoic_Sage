import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:stoic_app/models/stoic_content.dart';
import 'package:stoic_app/providers/favorite_lessons_provider.dart';
import 'package:stoic_app/providers/lesson_progress_provider.dart';
import 'package:stoic_app/theme/app_colors.dart';
import 'package:stoic_app/theme/app_text_styles.dart';

/// Vista de detalle para mostrar el contenido completo de una lección estoica.
/// Soporta modo claro/oscuro y formateo Markdown para títulos y listas.
class LessonDetailScreen extends StatefulWidget {
  final StoicContent content;

  const LessonDetailScreen({super.key, required this.content});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

enum FontSizeOption { small, medium, large }

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  FontSizeOption _fontSize = FontSizeOption.medium;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final progressProvider = Provider.of<LessonProgressProvider>(
        context,
        listen: false,
      );
      progressProvider.markCompleted(widget.content.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = context.watch<LessonProgressProvider>();
    final favoriteProvider = context.watch<FavoriteLessonsProvider>();
    final status = progressProvider.statusFor(
      widget.content.id,
      fallback: widget.content.status,
    );
    final isCompleted = status == LessonStatus.completed;
    final isFavorite = favoriteProvider.isFavorite(
      widget.content.id,
      fallback: widget.content.isFavorite,
    );
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;

    double getFontSize() {
      switch (_fontSize) {
        case FontSizeOption.small:
          return 14.0;
        case FontSizeOption.medium:
          return 17.0;
        case FontSizeOption.large:
          return 22.0;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LessonDetailAppBar(
              content: widget.content,
              isCompleted: isCompleted,
              fontSize: _fontSize,
              onFontSizeChanged: (FontSizeOption newSize) {
                setState(() {
                  _fontSize = newSize;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.content.category.toUpperCase(),
                              style: AppTextStyles.overlineStrong.copyWith(
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.content.title,
                              style: AppTextStyles.lessonDetailTitle.copyWith(
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        //Rotar
                        Positioned(
                          top: -80,
                          right: -150,
                          child: Transform.rotate(
                            angle: 3.2,
                            child: Image.asset(
                              'assets/images/plants.png',
                              width: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: context.dividerColor.withValues(alpha: 0.4)),
                    const SizedBox(height: 20),
                    MarkdownBody(
                      data: widget.content.content,
                      selectable: true,
                      styleSheet: _buildMarkdownStyle(context, getFontSize()),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          favoriteProvider.toggleFavorite(
            widget.content.id,
            fallback: widget.content.isFavorite,
          );
        },
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade100
            : AppColors.sabioAccent,
        heroTag: 'lesson-fav-${widget.content.id}',
        tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : (isFavorite ? Colors.white : context.textPrimary),
        ),
      ),
    );
  }
}

MarkdownStyleSheet _buildMarkdownStyle(BuildContext context, double fontSize) {
  final textPrimary = context.textPrimary;
  final textSecondary = context.textSecondary;

  return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
    p: AppTextStyles.bodyMediumPlus.copyWith(
      color: textPrimary,
      fontSize: fontSize,
    ),
    h2: AppTextStyles.h4.copyWith(color: textPrimary, fontSize: fontSize + 4),
    h3: AppTextStyles.bodyLargeBold.copyWith(
      color: textPrimary,
      fontSize: fontSize + 2,
    ),
    blockSpacing: 20,
    listBullet: AppTextStyles.bodyMediumPlus.copyWith(
      color: textPrimary,
      fontSize: fontSize,
    ),
    listIndent: 24,
    blockquote: AppTextStyles.brandSubtitleItalic.copyWith(
      color: textSecondary,
      fontSize: fontSize,
    ),
    blockquoteDecoration: BoxDecoration(
      border: Border(
        left: BorderSide(
          color: AppColors.sabioAccent.withValues(alpha: 0.4),
          width: 3,
        ),
      ),
    ),
  );
}

class _LessonDetailAppBar extends StatelessWidget {
  final StoicContent content;
  final bool isCompleted;
  final FontSizeOption fontSize;
  final ValueChanged<FontSizeOption> onFontSizeChanged;

  const _LessonDetailAppBar({
    required this.content,
    required this.isCompleted,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = context.textPrimary;
    final accent = isCompleted
        ? const Color(0xFF4CAF50)
        : AppColors.sabioAccent;
    final statusLabel = isCompleted ? 'Completado' : 'En progreso';
    final statusIcon = isCompleted
        ? Icons.check_circle_outline
        : Icons.timelapse;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Volver',
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: textPrimary),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 18, color: accent),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: AppTextStyles.bodySmallBold.copyWith(color: accent),
                ),
              ],
            ),
          ),
          PopupMenuButton<FontSizeOption>(
            tooltip: 'Tamaño de fuente',
            icon: Icon(Icons.tune_rounded, color: textPrimary),
            onSelected: onFontSizeChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: FontSizeOption.small,
                child: Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      size: 18,
                      color: fontSize == FontSizeOption.small
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Pequeño'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FontSizeOption.medium,
                child: Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      size: 22,
                      color: fontSize == FontSizeOption.medium
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Mediano'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FontSizeOption.large,
                child: Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      size: 28,
                      color: fontSize == FontSizeOption.large
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Grande'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
