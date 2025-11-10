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

class _LessonDetailScreenState extends State<LessonDetailScreen> {
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LessonDetailAppBar(
              content: widget.content,
              isCompleted: isCompleted,
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
                      styleSheet: _buildMarkdownStyle(context),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ...existing code...
      // ...existing code...
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          favoriteProvider.toggleFavorite(
            widget.content.id,
            fallback: widget.content.isFavorite,
          );
        },
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors
                  .grey
                  .shade100 // Fondo muy claro en modo claro
            : AppColors.sabioAccent, // Fondo acentuado en modo oscuro
        heroTag: 'lesson-fav-${widget.content.id}',
        tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors
                    .black // Negro en modo claro (outline o relleno)
              : (isFavorite
                    ? Colors.white
                    : context
                          .textPrimary), // Blanco si favorito en dark, textPrimary si no
        ),
      ),
      // ...existing code...
      // ...existing code...
    );
  }

  MarkdownStyleSheet _buildMarkdownStyle(BuildContext context) {
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;

    return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: AppTextStyles.bodyMediumPlus.copyWith(color: textPrimary),
      h2: AppTextStyles.h4.copyWith(color: textPrimary),
      h3: AppTextStyles.bodyLargeBold.copyWith(color: textPrimary),
      blockSpacing: 20,
      listBullet: AppTextStyles.bodyMediumPlus.copyWith(color: textPrimary),
      listIndent: 24,
      blockquote: AppTextStyles.brandSubtitleItalic.copyWith(
        color: textSecondary,
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
}

class _LessonDetailAppBar extends StatelessWidget {
  final StoicContent content;
  final bool isCompleted;

  const _LessonDetailAppBar({required this.content, required this.isCompleted});

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
          IconButton(
            tooltip: 'Opciones de lectura',
            onPressed: () {},
            icon: Icon(Icons.tune_rounded, color: textPrimary),
          ),
        ],
      ),
    );
  }
}
