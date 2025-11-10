import 'package:flutter/material.dart';
import 'package:stoic_app/models/stoic_content.dart';
import 'package:stoic_app/theme/app_colors.dart';
import 'package:stoic_app/theme/app_text_styles.dart';

/// Widget reutilizable para mostrar items de lecciones
/// Diseño basado en prototipo de Figma con imagen y check de completado
class LessonListItem extends StatelessWidget {
  /// Título principal del item
  final String title;

  /// Subtítulo o autor
  final String? subtitle;

  /// Ruta de la imagen del libro
  final String? imagePath;

  /// Estado actual de la lección
  final LessonStatus status;

  /// Indica si la lección está marcada como favorita
  final bool isFavorite;

  /// Callback cuando se toca el item
  final VoidCallback? onTap;

  /// Margen personalizado
  final EdgeInsets? margin;

  const LessonListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.status = LessonStatus.unread,
    this.isFavorite = false,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == LessonStatus.completed;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final successColor = isDarkMode
        ? AppColors.darkSuccess
        : AppColors.lightSuccess;
    final pendingColor = context.dividerColor;
    final statusBackground = isCompleted
        ? successColor.withOpacity(0.18)
        : pendingColor.withOpacity(1);
    final statusTextColor = isCompleted
        ? (isDarkMode ? Colors.white : Colors.black)
        : (isDarkMode
              ? context.textSecondary
              : Colors.black); // Negro en claro, gris en oscuro
    final heartBackgroundColor = isFavorite
        ? (isDarkMode ? AppColors.sabioAccent : Colors.grey.shade100)
        : Colors.transparent;
    final heartIconColor = isFavorite
        ? (isDarkMode ? Colors.white : Colors.black)
        : Colors.transparent;
    final heartIcon = isFavorite ? Icons.favorite : Icons.favorite_border;
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.dividerColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Contenido de texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        title,
                        style: AppTextStyles.bodyMediumPlus.copyWith(
                          color: context.textPrimary,
                        ),
                      ),

                      // Subtítulo/Autor
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status.label,
                          style: AppTextStyles.captionBold.copyWith(
                            color: statusTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Imagen del libro
                if (imagePath != null) ...[
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Imagen del libro
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.asset(
                          imagePath!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Widget de respaldo si falla la imagen
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: context.cardBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: context.dividerColor,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.book,
                                color: context.dividerColor,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),

                      Positioned(
                        top: 1,
                        right: 1,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? successColor
                                : statusBackground,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.check,
                            color: AppColors.darkBackground,
                            size: 14,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -6,
                        left: -6,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: heartBackgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: isFavorite
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            heartIcon,
                            color: heartIconColor,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget simplificado para items básicos sin imagen
class SimpleLessonListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final LessonStatus status;
  final VoidCallback? onTap;
  final bool isFavorite;

  const SimpleLessonListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.status = LessonStatus.unread,
    this.onTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return LessonListItem(
      title: title,
      subtitle: subtitle,
      status: status,
      isFavorite: isFavorite,
      onTap: onTap,
    );
  }
}
