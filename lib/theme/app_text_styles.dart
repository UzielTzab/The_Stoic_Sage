import 'package:flutter/material.dart';

/// Sistema de tipografías centralizado para la aplicación
/// Define todos los TextStyles reutilizables con tamaños, pesos y estilos
class AppTextStyles {
  // Private constructor para prevenir instanciación
  AppTextStyles._();

  // ============= CONFIGURACIÓN BASE =============
  static const String _fontFamily =
      'SF Pro Display'; // Primary display font (default)
  static const String _fontFamilyDisplay =
      'Playfair Display'; // New Figma display font (change to actual asset name)
  static const String _fontFamilySecondary = '';

  // ============= HEADINGS =============
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle brandTitlePrimary = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle brandTitleSecondary = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle h6 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    height: 1.4,
  );

  // ============= BODY TEXT =============
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.2,
    height: 1.4,
  );

  static const TextStyle bodyMediumPlus = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.6,
  );

  // ============= VARIACIONES DE BODY =============
  static const TextStyle bodyLargeBold = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle bodyMediumBold = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle bodySmallBold = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.2,
    height: 1.4,
  );

  // ============= CAPTIONS & LABELS =============
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.3,
    height: 1.3,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0.3,
    height: 1.3,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 10,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 1.5,
    height: 1.6,
  );

  // ============= BUTTONS =============
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle authButtonText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // ============= INPUTS =============
  static const TextStyle inputText = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle inputHint = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle brandSubtitleItalic = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle linkMedium = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static const TextStyle separatorText = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.3,
  );

  static const TextStyle footerLink = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle appBarCaption = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle overlineStrong = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.4,
  );

  static const TextStyle lessonDetailTitle = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.2,
  );

  // ============= NAVEGACIÓN =============
  static const TextStyle tabLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    height: 1.3,
  );

  // ============= ESPECÍFICOS DE LA APP =============
  // Estilos especiales para la app de estoicismo
  static const TextStyle philosophyQuote = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular
    fontStyle: FontStyle.italic,
    letterSpacing: 0.2,
    height: 1.6,
  );

  static const TextStyle lessonTitle = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.1,
    height: 1.3,
  );

  static const TextStyle lessonSubtitle = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle chipText = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.2,
    height: 1.2,
  );

  // ============= MÉTODOS HELPER =============

  /// Crea un TextTheme para el tema de la aplicación
  static TextTheme get textTheme => const TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    displaySmall: h3,
    headlineLarge: h4,
    headlineMedium: h5,
    headlineSmall: h6,
    titleLarge: lessonTitle,
    titleMedium: h6,
    titleSmall: bodyLargeBold,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: buttonLarge,
    labelMedium: buttonMedium,
    labelSmall: buttonSmall,
  );

  /// Aplica color a un TextStyle
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Aplica opacidad a un TextStyle
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }

  /// Cambia el tamaño de fuente de un TextStyle
  static TextStyle withSize(TextStyle style, double fontSize) {
    return style.copyWith(fontSize: fontSize);
  }

  /// Cambia el peso de fuente de un TextStyle
  static TextStyle withWeight(TextStyle style, FontWeight fontWeight) {
    return style.copyWith(fontWeight: fontWeight);
  }
}

/// Extension para facilitar el uso de estilos de texto
extension AppTextStylesExtension on BuildContext {
  /// Acceso rápido a los estilos de texto
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Estilos personalizados de la app
  TextStyle get philosophyQuote => AppTextStyles.philosophyQuote.copyWith(
    color: Theme.of(this).brightness == Brightness.light
        ? const Color(0xFF6B6B6B)
        : const Color(0xFFB0B0B0),
  );

  TextStyle get lessonTitle => AppTextStyles.lessonTitle.copyWith(
    color: Theme.of(this).brightness == Brightness.light
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFFFFFFF),
  );

  TextStyle get lessonSubtitle => AppTextStyles.lessonSubtitle.copyWith(
    color: Theme.of(this).brightness == Brightness.light
        ? const Color(0xFF6B6B6B)
        : const Color(0xFFB0B0B0),
  );
}
