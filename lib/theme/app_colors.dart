import 'package:flutter/material.dart';

/// Sistema de colores centralizado para la aplicación
/// Contiene paletas para modo claro y oscuro
class AppColors {
  // Private constructor para prevenir instanciación
  AppColors._();

  // ============= MODO CLARO =============
  static const Color lightPrimary = Color.fromARGB(255, 63, 63, 63);
  static const Color lightPrimaryVariant = Color(0xFF1E4BA8);
  static const Color lightSecondary = Color(0xFFFF6B35);
  static const Color lightSecondaryVariant = Color(0xFFE55A2B);

  // Backgrounds
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);

  // Texts
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightTextHint = Color(0xFF9E9E9E);

  // Status colors
  static const Color lightError = Color(0xFFE53E3E);
  static const Color lightSuccess = Color(0xFF38A169);
  static const Color lightWarning = Color(0xFFED8936);
  static const Color lightInfo = Color(0xFF3182CE);

  // Dividers & Borders
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // ============= MODO OSCURO =============
  static const Color darkPrimary = Color.fromARGB(255, 255, 255, 255);
  static const Color darkPrimaryVariant = Color(0xFF2F6BFF);
  static const Color darkSecondary = Color(0xFFFF8A65);
  static const Color darkSecondaryVariant = Color(0xFFFF6B35);

  // Backgrounds
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardBackground = Color(0xFF2D2D2D);

  // Texts
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextHint = Color(0xFF757575);

  // Status colors
  static const Color darkError = Color(0xFFFF6B6B);
  static const Color darkSuccess = Color(0xFF68D391);
  static const Color darkWarning = Color(0xFFFBB040);
  static const Color darkInfo = Color(0xFF63B3ED);

  // Dividers & Borders
  static const Color darkDivider = Color(0xFF424242);
  static const Color darkBorder = Color(0xFF424242);

  // ============= COLORES ESPECÍFICOS DE LA APP =============
  // Colores para elementos específicos del estoicismo
  static const Color stoicGold = Color(0xFFD4AF37);
  static const Color stoicGoldDark = Color(0xFFB8941F);
  static const Color philosophyBlue = Color(0xFF4A90E2);
  static const Color wisdomPurple = Color(0xFF9B59B6);
  static const Color virtueGreen = Color(0xFF27AE60);
  static const Color sabioAccent = Color(
    0xFF555147,
  ); // Color secundario para "El Sabio"

  // ============= COLORES PARA INPUTS =============
  static const Color inputFillLight = Color.fromARGB(
    255,
    231,
    231,
    231,
  ); // Fondo gris claro para inputs
  static const Color inputFillDark = Color(
    0xFF2A2A2A,
  ); // Fondo oscuro para inputs en dark mode
  static const Color inputBorderLight = Color(
    0xFFE0E0E0,
  ); // Borde para inputs (si es necesario)
  static const Color inputBorderDark = Color(
    0xFF424242,
  ); // Borde para inputs en dark mode

  // Gradients
  static const LinearGradient lightGradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPrimary, lightPrimaryVariant],
  );

  static const LinearGradient darkGradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkPrimary, darkPrimaryVariant],
  );

  // ============= MÉTODOS HELPER =============

  /// Retorna el ColorScheme para modo claro
  static ColorScheme get lightColorScheme => const ColorScheme.light(
    primary: lightPrimary,
    secondary: lightSecondary,
    surface: lightSurface,
    error: lightError,
    onPrimary: lightOnPrimary,
    onSecondary: lightOnSecondary,
    onSurface: lightOnSurface,
    onError: lightOnPrimary,
  );

  /// Retorna el ColorScheme para modo oscuro
  static ColorScheme get darkColorScheme => const ColorScheme.dark(
    primary: darkPrimary,
    secondary: darkSecondary,
    surface: darkSurface,
    error: darkError,
    onPrimary: darkOnPrimary,
    onSecondary: darkOnSecondary,
    onSurface: darkOnSurface,
    onError: darkOnPrimary,
  );
}

/// Extension para facilitar el acceso a colores según el contexto
extension AppColorsExtension on BuildContext {
  /// Retorna los colores actuales según el theme (claro/oscuro)
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Retorna colores de texto según el theme actual
  Color get textPrimary => Theme.of(this).brightness == Brightness.light
      ? AppColors.lightTextPrimary
      : AppColors.darkTextPrimary;

  Color get textSecondary => Theme.of(this).brightness == Brightness.light
      ? AppColors.lightTextSecondary
      : AppColors.darkTextSecondary;

  Color get textHint => Theme.of(this).brightness == Brightness.light
      ? AppColors.lightTextHint
      : AppColors.darkTextHint;

  Color get cardBackground => Theme.of(this).brightness == Brightness.light
      ? AppColors.lightCardBackground
      : AppColors.darkCardBackground;

  Color get dividerColor => Theme.of(this).brightness == Brightness.light
      ? AppColors.lightDivider
      : AppColors.darkDivider;
}
